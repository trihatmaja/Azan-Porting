# azan.pl
# Anda boleh menggunakan dan menyebarkan file ini dengan menyebutkan sumbernya:
# Nara Sumber awal:
# Dr. T. Djamaluddin
# Lembaga Penerbangan dan Antariksa Nasional (LAPAN) Bandung
# Phone 022-6012602. Fax 022-6014998 
# e-mail: t_djamal@lapan.go.id  t_djamal@hotmail.com 
# Sumber dalam perl:
# Wastono ST
# Jl Taman Cilandak Rt:001 Rw:04 No.4 Jakarta 12430
# Phone 021-75909268. was.tono@gmail.com

use strict;
if( $ARGV[4] eq "" )
{
   print "\n\tPerintah:";
   print "\n\tperl azan.pl Latitude Longitude GMT AzanCommand PlaceName";
   print "\n\n\tContoh:";
   print "\n\tperl azan.pl -6.18 106.83 7 \"ogg123 Al-Azan.ogg\" Jakarta";
   print "\n\n\tSalam was.tono\@gmail.com\n\n";
   exit;
}

open(OUTFILE, ">$ARGV[4].tab") or die "\nError : $!\n";
print OUTFILE "# ", $ARGV[4], "  GMT";
close OUTFILE;

open(OUTFILE, ">>$ARGV[4].tab") or die "\nError : $!\n";

sub tan { sin($_[0]) / cos($_[0])  }
sub atan { atan2($_[0],1) }
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
sub asin { atan2($_[0], sqrt(1 - $_[0] * $_[0])) }

my $RAD = 3.1415926539 / 180;
my $PHI = $ARGV[0] * $RAD;   # garis lintang
my $LAMD = $ARGV[1] / 15;    # garis bujur
my $TD = $ARGV[2] + 0;       # beda waktu
my $SC = $ARGV[3];           # perintah azan
my $KOTA = $ARGV[4];         # nama tempat
my $xfy = "";

if( $TD >= 0 )
{
   print OUTFILE "+";
   $xfy = "+";
}

print OUTFILE $TD, " Latitude: ", $ARGV[1], " Longitude: ", $ARGV[0], "\n";
my $fbuf = "\tJadwal Waktu Azan";
$fbuf = $fbuf." untuk ".$KOTA;
$fbuf = $fbuf."\n\tGMT".$xfy.$TD."  Latitude: ".$ARGV[1]."  Longitude: ".$ARGV[0];
my $tbuf = "";
my $subh = "";
my $zuhr = "";
my $magr = "";
my $isy = "";
my @bulan = (32, 29, 32, 31, 32, 31, 32, 32, 31, 32, 31, 32);
my @bbuf = ("Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember");
my @XX = (0.0,0.0,0.0,0.0,0.0);
my $DEK = 0.0;
my $X = 0.0;
my $A = 0.0;
my $Z = 0.0;
my $N = 0;
my $ST = 0.0;
my $I = 0.0;
my $K = 0.0;
my $MN = 0.0;
my $ZD = 0.0;
my $H = 0.0;
my $STX = 0.0;
my $cnt = 0;

sub hitung
{
   my $T = $N + ($A - $LAMD) / 24;
   my $M = (0.9856 * $T - 3.289) * $RAD;
   my $L = $M + 1.916 * $RAD * sin($M) + 0.02 * $RAD * sin(2 * $M) + 282.634 * $RAD;
   my $LH = $L / 3.1415926539 * 12;
   my $QL = int($LH / 6) + 1;
   if ((int($QL / 2) * 2 - $QL) != 0) { $QL -= 1; }
   my $RA = (atan(0.91746 * tan($L)) / 3.1415926539 * 12) + ($QL * 6);
   my $SIND = 0.39782 * sin($L);
   my $COSD = sqrt(1 - $SIND * $SIND);
   $DEK = atan($SIND / $COSD);
   if ($A == 15) { $Z = atan(tan($ZD) + 1); }
   $X = (cos($Z) - $SIND * sin($PHI)) / ($COSD * cos($PHI));
   if (abs($X) <= 1)
   {
      my $ATNX = atan(sqrt(1 - $X * $X) / $X) / $RAD;
      if ($ATNX < 0) { $ATNX += 180; }
      $H = (360 - $ATNX) / 15;
      if ($A == 18) { $H = 24 - $H; }
      if ($A == 12) { $H = 0; }
   }
   if ($A == 15) { $H = 24 - $H; }
   my $TLOC = $H + $RA - 0.06571 * $T - 6.622 + 24;
   $TLOC = $TLOC - int($TLOC / 24) * 24;
   $ST = $TLOC - $LAMD + $TD;
}

sub tulis
{
   my $TH = int($XX[$cnt]);
   my $TM = int(($XX[$cnt] - $TH) * 60);
   $tbuf = $TH.":";
   if ($TM > 9 ) { $tbuf = $tbuf.$TM; }
   else { $tbuf = $tbuf."0".$TM; }
   print OUTFILE $TM . " " . $TH . " " . $K . " " . ($MN + 1) . " * " . $SC . "\n";
}

for( $MN = 0; $MN < 12; $MN++)
{
   $fbuf = $fbuf."\n\n\t".$bbuf[$MN]."\n\tTgl\tSubuh\tZuhur\tAshar\tMagrib\tIsya";
   for( $K = 1; $K < $bulan[$MN]; $K++)
   {
      $N++;
      $A = 6;
      $Z = 110 * $RAD;
      hitung;
      $cnt = 0;
      if (abs($X) <= 1) { $XX[$cnt] = $ST; } # subuh
      tulis;
      $subh = $tbuf."\t";
      $Z = (90 + 5 / 6) * $RAD;
      hitung;
      #$ST = $ST; # waktu terbit
      $A = 18;
      $Z = (90 + 5 / 6) * $RAD;
      hitung;
      $cnt = 1;
      $XX[$cnt] = $ST + 1 / 30; # magrib
      tulis;
      $magr = $tbuf."\t";
      $Z = 108 * $RAD;
      hitung;
      $cnt = 2;
      if (abs($X) <= 1) { $XX[$cnt] = $ST; } # isya
      tulis;
      $isy = $tbuf;
      $A = 12;
      hitung;
      $cnt = 3;
      $XX[$cnt] = $ST + 1 / 30; # zuhur
      tulis;
      $zuhr = $tbuf."\t";
      $ZD = abs($DEK - $PHI);
      $A = 15;
      hitung;
      $cnt = 4;
      $XX[$cnt] = $ST; # ashar
      tulis;
      $fbuf = $fbuf."\n\t".$K."\t".$subh.$zuhr.$tbuf."\t".$magr.$isy;
   }
   if ($MN == 1)
   {
      $fbuf = $fbuf."\n\t".$K."\t".$subh.$zuhr.$tbuf."\t".$magr.$isy;
      for( $cnt = 0; $cnt < 5; $cnt++) { tulis; }
   }
}
close OUTFILE;

open(OUTFILE, ">$ARGV[4].txt") or die "\nError : $!\n";
print OUTFILE $fbuf,"\n\n\twas.tono\@gmail.com\n\n";
close OUTFILE;

print "\n\tTable cron ada pada $ARGV[4].tab";
print "\n\tTable jadwal azan ada pada $ARGV[4].txt";
print "\n\n\tUntuk menginstal Anda bisa gunakan perintah ini:";
print "\n\tcrontab $ARGV[4].tab";
print "\n\n\tSalam was.tono\@gmail.com\n\n";

# end of file
