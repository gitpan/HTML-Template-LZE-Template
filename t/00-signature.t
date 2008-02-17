use Test::More;
eval 'use Test::Signature';
plan skip_all => 'Test::Signature is required to run this test' if $@;
plan(tests => 1);
signature_ok();
