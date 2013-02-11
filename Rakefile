require 'rake/packagetask'

task :default => [:test]

task :test do
  sh "rspec"
end

Rake::PackageTask.new("findporn", :noversion) do |p|
  p.need_tar_gz = true
  p.package_files.include("*.rb")
  p.package_files.include("config.yml")
end
