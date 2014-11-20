# dkim_parse

[![Code Climate](https://codeclimate.com/github/trailofbits/dkim_parse.png)](https://codeclimate.com/github/trailofbits/dkim_parse) [![Build Status](https://travis-ci.org/trailofbits/dkim_parse.svg)](https://travis-ci.org/trailofbits/dkim_parse)
[![Gem Version](https://badge.fury.io/rb/dmarc.svg)](http://badge.fury.io/rb/dmarc)
[![YARD Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/gems/dmarc)
[![Test Coverage](https://codeclimate.com/github/trailofbits/dkim_parse/badges/coverage.svg)](https://codeclimate.com/github/trailofbits/dkim_parse)

The `dkim_parse` library searches the dkim records for a host. We assume the host uses standard dkim 'selectors', and also check if they use their own 'selector'.

## Examples

    dkim google.com
    ____________________________
    DKIM record search for google.com
      - using selectors: ["default", "dkim", "google"]
      - no DKIM record found for google.com
    ____________________________

    dkim twitter.com
    ____________________________
    DKIM record search for twitter.com
      - using selectors: ["default", "dkim", "google", "twitter"]
      - found DKIM record for twitter.com at dkim._domainkey.twitter.com:
      v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCrZ6zwKHLkoNpHNyPGwGd8wZoNZOk5buOf8wJwfkSZsNllZs4jTNFQLy6v4Ok9qd46NdeRZWnTAY+lmAAV1nfH6ulBjiRHsdymijqKy/VMZ9Njjdy/+FPnJSm3+tG9Id7zgLxacA1Yis/18V3TCfvJrHAR/a77Dxd65c96UvqP3QIDAQAB
    ____________________________

## Install

    rake install

## License

See the {file:LICENSE.txt} file.