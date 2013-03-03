require 'open-uri'
require 'fileutils'

@dl_path   = "http://sourceforge.net/projects/tcljava/files/jacl/1.4.1/jaclBinary141.zip/download"
@file_name = "jaclBinary141.zip"

def download_file(file, path)
  open(file, "wb") do |output|
    open(path) do |data|
      output.write data.read
    end
  end
end

#require 'zipruby'
#def unzip(src,dest)
#  Zip::Archive.open(src) do |entries|
#    entries.each do |entry|
#      name = entry.name.encode("UTF-8").gsub("\\", "/")
#      if entry.directory?
#        FileUtils.mkdir_p(File.join(dest,name))
#      else
#        dirname = File.join(dest,File.dirname(name))
#        FileUtils.mkdir_p(dirname)
#        puts File.join(dest,name)
#        open(File.join(dest,name), "wb") do|f|
#        f << entry.read
#        end
#      end
#    end
#  end
#end

require 'zip/zipfilesystem'
def unzip(src, dest)
  Zip::ZipInputStream.open(src) do |rf|
    src = src.encode("UTF-8").gsub("\\", "/")
    while entry = rf.get_next_entry
      dir = File.dirname(entry.name)
      FileUtils.mkdir_p(File.join(dest,dir))
      path = File.join(dest,entry.name)
      unless entry.name_is_directory?
        puts path
        File.open(path, "wb") do |wf|
          wf << rf.read
        end
      end
    end
  end
end

cur_path = File.dirname(__FILE__)

puts "access ... #{@dl_path}"
download_file(File.join(cur_path,@file_name), @dl_path)
puts "done."
puts "unzip... #{File.join(cur_path,@file_name)}"
unzip File.join(cur_path,@file_name), File.join(cur_path,"tmp")
puts "done."

files = Dir[
  File.join(cur_path,"tmp/**/jacl.jar"),
  File.join(cur_path,"tmp/**/tcljava.jar")]

FileUtils.cp(files, File.join(cur_path,"../lib"))

puts "copy #{files} --> #{File.join(cur_path,'../lib')}"

FileUtils.rm_r(File.join(cur_path,"tmp"))
FileUtils.rm_r(File.join(cur_path,@file_name))
