requires 'perl', '5.008001';
requires 'Nephia';
requires 'File::pushd';
requires 'File::Which';
requires 'File::Spec';
requires 'Carton';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Capture::Tiny';
};

