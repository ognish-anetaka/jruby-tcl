require 'java'
require 'jacl.jar'
require 'tcljava.jar'

module Tcl

  module Java
    java_import "tcl.lang.Interp"
    java_import "tcl.lang.Command"
    java_import "tcl.lang.TclList"
    java_import "tcl.lang.TclString"
    java_import "tcl.lang.TclException"
  end

  class SendCommand
    include Tcl::Java::Command
    def cmdProc(interp, args)
      begin
        array = args.to_ary
        raise Tcl::Error if array.size == 0
        array.shift #interp_send
        raise Tcl::Error if array.size == 0
        method_name = array.shift
        array.map! {|m| m.toString.to_s}
        result = interp.interp_receive(method_name, *array)
        obj = Tcl::Java::TclString.newInstance( result.to_s )
        interp.setResult( obj )
      rescue => e
        puts e.message
        raise Tcl::Error
      end
    end
  end

  class Interp < Tcl::Java::Interp

    def initialize
      super
      self.createCommand("interp_send", Tcl::SendCommand.new)
#      ObjectSpace.define_finalizer(self, @interp.dispose)
    end

    def list_to_array list
      string = Tcl::Java::TclString.newInstance(list.to_s)
      elements = nil
      begin
        elements = Tcl::Java::TclList.getElements(self, string)
      rescue
        return nil
      end
      elements.map {|m| m.to_s}
    end

    def array_to_list array
      list = Tcl::Java::TclList.newInstance
      array.each do |elem|
        string = Tcl::Java::TclString.newInstance(elem.to_s)
        Tcl::Java::TclList.append(self, list, string)
      end
      list.toString.to_s
    end

    def eval arg, *dummy
      begin
        super(arg.to_s, 0)
        self.getResult.toString.to_s
      rescue => e
        puts e.message
        raise Tcl::Error
      end
    end
  end

  class SafeInterp < Interp
  end

  class Error < StandardError
  end

#  class Timeout < Error
#  end

end

#if __FILE__ == $0
#  puts "--test--"
#
#  interp = Tcl::Interp.new
#  interp.eval "set a {Hello World}"
#  interp.eval "puts $a"
#  interp.dispose
#
#  puts "--done--"
#end
