require "dkim_parse/version"

module DkimParse

  def self.check_host(host, resolver)
    host_without_tld = host[0...host.rindex('.')]
    defaults = %W[default dkim google #{host_without_tld}]
    defaults.uniq!
    puts "  - using selectors: #{defaults}"
    dkim = nil
    defaults.each do |selector|
      result = nil
      record_path = "#{selector}._domainkey.#{host.downcase}"
      begin
        dkim = resolver.getresource(record_path, Resolv::DNS::Resource::IN::TXT).strings.join
        dkim = {:record =>dkim, :record_path=>record_path}
        break
      rescue Resolv::ResolvError
      end
    end
    dkim
  end
end
