require 'rake/packagetask'

task :default => [:test, :clean, :compile, :_package, :post_package]


task :clean do
  sh "rm -rf class/*"
  sh "rm -rf pkg"
end

task :test do
  sh "rspec"
end

task :compile => [:clean] do
  begin
    sh "mkdir class"
  rescue Exception
  end
  sh "cd lib; jruby -S jrubyc -t ../class .; cd .."
end

def config_files
  ['config.yml', 'queries.txt', 'README.txt']
end

def do_common_packaging_stuff(p)
  p.need_tar_gz = true
  p.need_zip = true
  p.package_files.include("class/*")
  p.package_files.include("class/findporn/*")

  p.package_files.include("jars/*")
  p.package_files.exclude("jars/jruby-complete-1.7.3.jar")
end

def do_win_packaging_stuff(p)
  save_root_configs
  copy_config_files_to_root 'win'
  include_config_files p
  sh "cp -f win/findporn.bat ."
  p.package_files.include("findporn.bat")
end

def do_nix_packaging_stuff(p)
  save_root_configs
  copy_config_files_to_root 'nix'
  include_config_files p
  sh "cp -f nix/findporn.sh ."
  p.package_files.include("findporn.sh")
end

def include_config_files(p)
  config_files.each do |f|
    p.package_files.include f
  end
end

def copy_config_files_to_root(os)
  config_files.each do |f|
    sh "cp -f #{os}/#{f} ."
  end
end

def clean_config_files
  config_files.each do |f|
    sh 'rm ' + f
  end
end

def save_root_configs
  begin
    sh 'mkdir temp'
    config_files.each do |f|
      begin
        sh "cp -f #{f} temp/"
      rescue Exception => e
      end
    end
    rescue Exception => e
  end
end

def load_saved_root_files
  config_files.each do |f|
    begin
      sh "cp -f temp/#{f} ."
    rescue Exception
    end
  end
  sh "rm -rf temp"
end

task :_package => [:compile] do
  task :pack_nix do
    Rake::PackageTask.new("findporn-linux-mac", :noversion) do |p|
      do_common_packaging_stuff p
      do_nix_packaging_stuff p
    end
    Rake::Task["package"].invoke
  end

  task :pack_win do
    Rake::PackageTask.new("findporn-win", :noversion) do |p|
      do_common_packaging_stuff p
      do_win_packaging_stuff p
    end
    Rake::Task["package"].reenable
    Rake::Task["package"].invoke
  end

  Rake::Task["pack_nix"].invoke
  Rake::Task["pack_win"].invoke
end

task :post_package => [:package] do
  load_saved_root_files
  sh 'rm findporn.bat'
  sh 'rm findporn.sh'
end
