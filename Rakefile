require 'rake/packagetask'

  task :default => [:post_package]

  task :clean do
    sh "rm -rf class/*"
    sh "rm -rf pkg"
  end

  task :test do
    sh "rspec"
  end

  task :compile => [:test, :clean] do
    sh "cd src; jruby -S jrubyc -t ../class *.rb; cd .."
  end

  def config_files
    ['config.yml', 'queries.txt', 'README.txt']
  end

  def do_common_packaging_stuff(p)
    p.need_tar_gz = true
    p.need_zip = true
    p.package_files.include("class/*")

    p.package_files.include("lib/*")
    p.package_files.exclude("lib/jruby-complete-1.7.3.jar")
  end

  def do_win_packaging_stuff(p)
    save_root_configs
    copy_config_files_to_root 'win'
    include_config_files p
    sh "cp win/findporn.bat ."
    p.package_files.include("findporn.bat")
    puts "post win!"
  end

  def do_nix_packaging_stuff(p)
    save_root_configs
    copy_config_files_to_root 'nix'
    include_config_files p
    sh "cp nix/findporn.sh ."
    p.package_files.include("findporn.sh")
    puts "post nix!"
  end

  def include_config_files(p)
    config_files.each do |f|
      p.package_files.include f
    end
  end

  def copy_config_files_to_root(os)
    config_files.each do |f|
      sh "cp #{os}/#{f} ."
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
          sh "cp #{f} temp/"
        rescue Exception => e
        end
      end
      rescue Exception => e
    end
  end

  def load_saved_root_files
    config_files.each do |f|
      sh "cp temp/#{f} ."
    end
    sh "rm -rf temp"
  end

  task :package => :compile
  Rake::PackageTask.new("findporn-nix", :noversion) do |p|
    do_common_packaging_stuff p
    do_nix_packaging_stuff p
  end

  Rake::PackageTask.new("findporn-win", :noversion) do |p|
    do_common_packaging_stuff p
    do_win_packaging_stuff p
  end

  task :post_package => [:package] do
    puts "post_package!!!"
    clean_config_files
    load_saved_root_files
    sh "rm -rf findporn.bat findporn.sh"
  end
