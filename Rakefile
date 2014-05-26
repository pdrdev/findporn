require 'rake/packagetask'

task :default => [:test, :clean, :_package, :post_package]


task :clean do
  sh 'rm -rf pkg'
end

task :test do
  sh 'rspec'
end

def config_files
  ['config.yml', 'queries.txt', 'README.txt', 'findporn.sh']
end

def do_common_packaging_stuff(p)
  p.need_tar_gz = true
  p.need_zip = true

  save_root_configs
  copy_config_files_to_root 'include'
  include_config_files p
  p.package_files.include 'lib/**/*'
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

def include_config_files(p)
  config_files.each do |f|
    p.package_files.include f
  end
end

def copy_config_files_to_root(dir)
  config_files.each do |f|
    sh "cp -f #{dir}/#{f} ."
  end
end

def clean_config_files
  config_files.each do |f|
    sh 'rm ' + f
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

task :_package => [:clean] do
  task :pack do
    Rake::PackageTask.new("findporn-dist", :noversion) do |p|
      do_common_packaging_stuff p
    end
    Rake::Task["package"].invoke
  end

  Rake::Task["pack"].invoke
end

task :post_package => [:package] do
  load_saved_root_files
end
