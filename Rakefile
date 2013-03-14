require 'rake/packagetask'

task :default => [:package]

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

task :package => :compile
Rake::PackageTask.new("findporn", :noversion) do |p|
  p.need_tar_gz = true
  p.package_files.include("*.rb")
  p.package_files.include("config.yml")
end

Rake::PackageTask.new("findporn-java", :noversion) do |p|
  p.need_tar_gz = true
  p.need_zip = true
  p.package_files.include("class/*")

  p.package_files.include("lib/*")
  p.package_files.exclude("lib/jruby-complete-1.7.3.jar")

  p.package_files.include("config.yml")
  p.package_files.include("queries")
  p.package_files.include("findporn.sh")
end
