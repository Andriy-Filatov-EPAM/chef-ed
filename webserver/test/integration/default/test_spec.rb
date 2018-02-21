   describe package("nginx") do
     it { should be_installed }
   end
   describe file("/usr/share/nginx/html/index.html") do
     it { should exist }
   end
   describe systemd_service('nginx.service') do
     it { should be_enabled }
     it { should be_running }
   end
   describe command("curl localhost") do
     its("stdout") { should_not match "404 Not Found" }
   end
