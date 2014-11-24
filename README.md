# dkim_parse

[![Code Climate](https://codeclimate.com/github/trailofbits/dkim_parse.png)](https://codeclimate.com/github/trailofbits/dkim_parse) [![Build Status](https://travis-ci.org/trailofbits/dkim_parse.svg)](https://travis-ci.org/trailofbits/dkim_parse)
[![Test Coverage](https://codeclimate.com/github/trailofbits/dkim_parse/badges/coverage.svg)](https://codeclimate.com/github/trailofbits/dkim_parse)

The `dkim_parse` library searches the dkim records for a host. We assume the host uses standard dkim 'selectors', and also check if they use their own 'selector'.

## Examples

###CLI
___
-use a single domain

    dkim google.com
    ____________________________
    DKIM record search for google.com
      - using selectors: ["default", "dkim", "google"]
      - no DKIM record found for google.com
    ____________________________


-or a bunch in a row

    dkim trailofbits.com facebook.com yahoo.com
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

###In a project
___

    require 'dkim_parse'
    
    DKIMParse.check_host('twitter.com')
    - using selectors: ["default", "dkim", "google", "twitter"]
    => {:record=>"v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrZ6zwKHLkoNpHNyPGwGd8wZoNZOk5buOf8wJwfkSZsNllZs4jTNFQLy6v4Ok9qd46NdeRZWnTAY+lmAAV1nfH6ulBjiRHsdymijqKy/VMZ9Njjdy/+FPnJSm3+tG9Id7zgLxacA1Yis/18V3TCfvJrHAR/a77Dxd65c96UvqP3QIDAQAB", :record_path=>"dkim._domainkey.twitter.com"}
    

## Install

    rake install

## License

See the {file:LICENSE.txt} file.
