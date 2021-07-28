use Test::More tests => 3;

use warnings;
use strict;

use PDF::API2;

my $pdf = PDF::API2->new(-compress => 0);

my $jpg = $pdf->image_jpeg('t/resources/1x1.jpg');
isa_ok($jpg, 'PDF::API2::Resource::XObject::Image::JPEG',
       q{$pdf->image_jpg()});

my $gfx = $pdf->page->gfx();
$gfx->image($jpg, 72, 144, 216, 288);
like($pdf->to_string(), qr/q 216 0 0 288 72 144 cm \S+ Do Q/,
     q{Add JPG to PDF});

# Missing file

$pdf = PDF::API2->new();
eval { $pdf->image_jpeg('t/resources/this.file.does.not.exist') };
ok($@, q{Fail fast if the requested file doesn't exist});
