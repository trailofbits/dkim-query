# dkim-query

[![Code Climate](https://codeclimate.com/github/trailofbits/dkim-query/badges/gpa.svg)](https://codeclimate.com/github/trailofbits/dkim-query)
[![Test Coverage](https://codeclimate.com/github/trailofbits/dkim-query/badges/coverage.svg)](https://codeclimate.com/github/trailofbits/dkim-query)
[![Build Status](https://travis-ci.org/trailofbits/dkim-query.svg)](https://travis-ci.org/trailofbits/dkim-query)

The `dkim-query` library searches the [DKIM] records for a host. We assume the
host uses standard dkim 'selectors', and also check if they use their own
'selector'.

## Examples

Parse a DKIM record:

    require 'dkim/query'

    key = DKIM::Query::Key.parse("k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key")
    
    key.v
    # => nil

    key.g
    # => nil

    key.h
    # => nil

    key.k
    # => :rsa

    key.n
    # => "A 1024 bit key"

    key.p
    # => "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB"

    key.s
    # => nil

    key.t
    # => nil

Query all keys for a domain:

    domain = DKIM::Query::Domain.query('yahoo.com')
    # => #<DKIM::Query::Domain:0x0000000315c950 @name="yahoo.com", @keys={"s1024"=>#<DKIM::Query::Key:0x0000000315c9f0 @v=nil, @g=nil, @h=nil, @k=:rsa, @n="A 1024 bit key;", @p="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB", @s=nil, @t=nil>}>

    domain['s1024']
    # => #<DKIM::Query::Key:0x0000000315c9f0 @v=nil, @g=nil, @h=nil, @k=:rsa, @n="A 1024 bit key;", @p="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB", @s=nil, @t=nil>

    domain.each do |key|
      # ...
    end

## Synopsis

Query a domain:

    dkim-query google.com
    ____________________________
    DKIM record search for google.com
      - using selectors: ["default", "dkim", "google"]
      - no DKIM record found for google.com
    ____________________________


Query multiple domains:

    dkim-query trailofbits.com facebook.com yahoo.com
    ____________________________
    DKIM record search for trailofbits.com
      - using selectors: ["default", "dkim", "google", "trailofbits"]
      - found DKIM record for trailofbits.com at trailofbits._domainkey.trailofbits.com:
      v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwe04g1hSR55ACcRiLAg0MoEiY5BBviJHJHq/d9r6o+F50fa1TrNNulwKXaST+WCEcW6D2KZ+dt9JvgB9ApIEAFCzHRXhawga0GsfDkOllvpXgT95IPcnYrSkM+rJSbaqHh+YI5sV9sKnvzZDVmB7l5gU3yD74aDmjs9wSg8RC5wIDAQAB
    ____________________________
    
    ____________________________
    DKIM record search for facebook.com
      - using selectors: ["default", "dkim", "google", "facebook"]
      - found DKIM record for facebook.com at default._domainkey.facebook.com:
      t=y; k=rsa; p=MHwwDQYJKoZIhvcNAQEBBQADawAwaAJhALkZ4wTn2SQ3EW0vVBExi8izmZZnjZH8JIY5Y964jzDORZku43o6ooFq6HLMjBxmcDYOrJFRdcsKDWtI0Be/uLfc/rClXuyEbcENXfadg77HHv35BI85RNy4TKeai3hxoQIDAQAB;
    ____________________________
    
    ____________________________
    DKIM record search for yahoo.com
      - using selectors: ["default", "dkim", "google", "yahoo"]
      - no DKIM record found for yahoo.com
    ____________________________

## Requirements

* [ruby] >= 1.9.1
* [parslet] ~> 1.6

## Install

    rake install

## License

See the {file:LICENSE.txt} file.

[DKIM]: https://tools.ietf.org/html/rfc6376
[ruby]: https://www.ruby-lang.org/
[parslet]: http://kschiess.github.io/parslet/
