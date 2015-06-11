using System;

public class Azan {
    
    /*
    # azan.go
    # Anda boleh menggunakan dan menyebarkan file ini dengan menyebutkan sumbernya:
    # Nara Sumber awal:
    # Dr. T. Djamaluddin
    # Lembaga Penerbangan dan Antariksa Nasional (LAPAN) Bandung
    # Phone 022-6012602. Fax 022-6014998
    # e-mail: t_djamal@lapan.go.id  t_djamal@hotmail.com
    # Porting ke Perl:
    # Wastono ST
    # Jl Taman Cilandak Rt:001 Rw:04 No.4 Jakarta 12430
    # Phone 021-75909268. was.tono@gmail.com
    # Porting ke C#:
    # Wicaksono Trihatmaja
    # trihatmaja@gmail.com
    */

    internal static int[] dat = new int[]{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    internal static string[] datname = new string[]{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    internal static double[] t = new double[]{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    internal static double dek;
    internal static double h = 0;
    internal static double zd = 0;
    internal static double pi = (double)3.1415926539;
    internal static double rad = (double)(pi / 180.0);
    internal static double tdif;
    internal static double phi;
    internal static double lamd;
    
    public static void Main(string[] args)
    {
        double latitude = -6.193781;
        double longitude = 106.795906;
        double timezone = +7.0;
        string city = "Jakarta";
        AzanSchedule(latitude, longitude, timezone, city);
    }
    
    public static void AzanSchedule(double latitude, double longitude, double timezone, string city)
    {
        Console.WriteLine("Waktu azan untuk wilayah " + city);
        if (timezone > 0){
            Console.WriteLine("GMT+" + timezone + " Latitude=" + latitude + " Longitude="+ longitude);
        } else {
            Console.WriteLine("GMT" + timezone + " Latitude=" + latitude + " Longitude="+ longitude);
        }
        lamd = (double)(longitude / 15.0);
        phi = (double)(latitude * rad);
        tdif = (double)(timezone - lamd);
        int n = 0;
        for (int x = 0; x < 12; x = x + 1) {
            Console.WriteLine("\n" + datname[x]);
            Console.WriteLine("Tanggal\tSubuh\tTerbit\tDhuhur\tAshar\tMaghrib\tIsya");
            for (int k = 0; k < dat[x]; k = k + 1) {
                n = n + 1;
                int a = 6;
                double z = (double)(110.0 * rad);
                for (int w = 1; w < 7; w = w + 1) {
                    double st = (double)(n + (a - lamd) / 24.0);
                    double L = (double)((0.9856 * st - 3.289) * rad);
                    L = (double)(L + 1.916 * rad * Math.Sin(L) + 0.02 * rad * Math.Sin(2 * L) + 282.634 * rad);
                    double RA = (double)((int)(L / pi * 12.0 / 6.0) + 1);
                    if ((int)(RA / 2) * 2 - RA != 0) {
                        RA = RA - 1;
                    }
                    RA = (double)(Math.Atan(0.91746 * Math.Tan(L)) / pi * 12.0 + RA * 6.0);
                    double X = (double)(0.39782 * Math.Sin(L));
                    double ATNX = (double)Math.Sqrt(1 - X * X);
                    dek = (double)Math.Atan(X / ATNX);
                    if (a == 15) {
                        z = (double)Math.Atan(Math.Tan(zd) + 1);
                    }
                    X = (double)((Math.Cos(z) - X * Math.Sin(phi)) / (ATNX * Math.Cos(phi)));
                    if (Math.Abs(X) < 1) {
                        ATNX = (double)(Math.Atan(Math.Sqrt(1 - X * X) / X) / rad);
                        if (ATNX < 0.0) {
                            ATNX = (double)(ATNX + 180.0);
                        }
                        h = (double)((360.0 - ATNX) * 24.0 / 360.0);
                        if (a == 18) h = (double)(24.0 - h);
                        if (a == 12) h = (double)0.0;
                    }
                    if (a == 15) {
                        h = (double)(24.0 - h);
                    }
                    st = (double)(h + RA - 0.06571 * st - 6.622 + 24.0);
                    st = (double)(st - (int)(st / 24.0) * 24.0);
                    st = st + tdif;
                    if (w == 1) {
                        if (Math.Abs(X) < 1) {
                            t[1] = st;
                        }
                        z = (double)((90.0 + 5.0 / 6.0) * rad);
                    } else if (w == 2) {
                        t[2] = st;
                        a = 18;
                        z = (double)((90.0 + 5.0 / 6.0) * rad);
                    } else if (w == 3) {
                        t[5] = (double)(st + 2.0 / 60.0);
                        z = (double)(108.0 * rad);
                    } else if (w == 4) {
                        if (Math.Abs(X) < 1) {
                            t[6] = st;
                        }
                        a = 12;
                    } else if (w == 5) {
                        t[3] = (double)(st + 2.0 / 60.0);
                        zd = dek - phi;
                        if (zd < 0.0) {
                            zd = Math.Abs(zd);
                        }
                        a = 15;
                    } else {
                        t[4] = st;
                    }
                }
                Console.Write("{0}\t", k+1);
                for (int j = 1; j < 7; j++) {
                    int th = (int)t[j];
                    int tm = (int)((t[j] - th) * 60);
                    if(tm < 10) {
                        Console.Write("{0}:0{1}\t",th,tm);
                    } else {
                        Console.Write("{0}:{1}\t",th,tm);
                    }
                    if (j == 6) {
                        Console.Write("\n");
                    }
                }
                if (n == 59) {
                    if (k == 27) {
                        n = n - 1;
                    }
                }
            }
        }
    }
}

