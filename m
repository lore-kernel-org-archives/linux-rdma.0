From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bug 190951] New: SoftRoCE Performance Puzzle
Date: Sun, 25 Dec 2016 12:00:20 +0200
Message-ID: <20161225100020.GC14356@mtr-leonro.local>
References: <bug-190951-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bug-190951-11804-3bo0kxnWaOQUvHkbgXJLS5sdmw4N0Rt+2LY78lusg7I@public.gmane.org/>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: songweijia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 23, 2016 at 03:59:25AM +0000, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=190951
>
>             Bug ID: 190951
>            Summary: SoftRoCE Performance Puzzle
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 4.9
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Infiniband/RDMA
>           Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
>           Reporter: songweijia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>         Regression: No
>
> Created attachment 248401
>   --> https://bugzilla.kernel.org/attachment.cgi?id=248401&action=edit
> SoftRoCE Performance with 10G ethernet
>
> I found the SoftRoCE throughput is much lower than TCP or UDP. I used two
> high-end servers with Myricomm 10G dual port NIC. I ran a CentOS-7 virtual
> machine in each of them. I upgraded the virtual machine kernel to the lastest
> 4.9(2016-12-11) version:
> --------------------------------------------------------------------------
> [weijia@srvm1 ~]$ uname -a
> Linux srvm1 4.9.0 #1 SMP Fri Dec 16 16:35:46 EST 2016 x86_64 x86_64 x86_64
> GNU/Linux
> --------------------------------------------------------------------------
> The two virtual machines use virtio nic driver so the network I/O over head is
> very low. The iperf tool show ~9Gbps peak throughput with both TCP/UDP:
> --------------------------------------------------------------------------
> [weijia@srvm1 ~]$ iperf3 -c 192.168.30.10
> Connecting to host 192.168.30.10, port 5201
> [  4] local 192.168.29.10 port 59986 connected to 192.168.30.10 port 5201
> [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> [  4]   0.00-1.00   sec  1.06 GBytes  9.12 Gbits/sec    3   1.28 MBytes
> [  4]   1.00-2.00   sec  1.09 GBytes  9.39 Gbits/sec    1   1.81 MBytes
> [  4]   2.00-3.00   sec  1.06 GBytes  9.14 Gbits/sec    0   2.21 MBytes
> [  4]   3.00-4.00   sec  1.09 GBytes  9.36 Gbits/sec    0   2.56 MBytes
> [  4]   4.00-5.00   sec  1.07 GBytes  9.15 Gbits/sec    0   2.85 MBytes
> [  4]   5.00-6.00   sec  1.09 GBytes  9.39 Gbits/sec    0   3.00 MBytes
> [  4]   6.00-7.00   sec  1.07 GBytes  9.21 Gbits/sec    0   3.00 MBytes
> [  4]   7.00-8.00   sec  1.09 GBytes  9.39 Gbits/sec    0   3.00 MBytes
> [  4]   8.00-9.00   sec  1.09 GBytes  9.39 Gbits/sec    0   3.00 MBytes
> [  4]   9.00-10.00  sec  1.09 GBytes  9.38 Gbits/sec    0   3.00 MBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-10.00  sec  10.8 GBytes  9.29 Gbits/sec    4             sender
> [  4]   0.00-10.00  sec  10.8 GBytes  9.29 Gbits/sec                  receiver
>
> iperf Done.
>
> [weijia@srvm1 ~]$ iperf3 -c 192.168.30.10 -u -b 15000m
> Connecting to host 192.168.30.10, port 5201
> [  4] local 192.168.29.10 port 50826 connected to 192.168.30.10 port 5201
> [ ID] Interval           Transfer     Bandwidth       Total Datagrams
> [  4]   0.00-1.00   sec   976 MBytes  8.19 Gbits/sec  124931
> [  4]   1.00-2.00   sec  1.00 GBytes  8.63 Gbits/sec  131657
> [  4]   2.00-3.00   sec  1.02 GBytes  8.75 Gbits/sec  133452
> [  4]   3.00-4.00   sec  1.05 GBytes  9.02 Gbits/sec  137581
> [  4]   4.00-5.00   sec  1.05 GBytes  9.02 Gbits/sec  137567
> [  4]   5.00-6.00   sec  1.02 GBytes  8.72 Gbits/sec  133102
> [  4]   6.00-7.00   sec  1.00 GBytes  8.61 Gbits/sec  131386
> [  4]   7.00-8.00   sec   994 MBytes  8.34 Gbits/sec  127229
> [  4]   8.00-9.00   sec  1.04 GBytes  8.94 Gbits/sec  136484
> [  4]   9.00-10.00  sec   839 MBytes  7.04 Gbits/sec  107376
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total
> Datagrams
> [  4]   0.00-10.00  sec  9.92 GBytes  8.52 Gbits/sec  0.005 ms  323914/1300764
> (25%)
> [  4] Sent 1300764 datagrams
>
> iperf Done.
> --------------------------------------------------------------------------
>
> Then I used ibv_rc_pingpong to test the bandwith between the two virtual
> machines. The result is extremely low:
> --------------------------------------------------------------------------
> [weijia@srvm1 ~]$ ibv_rc_pingpong -s 4096 -g 1 -n 1000000 192.168.30.10
>   local address:  LID 0x0000, QPN 0x000011, PSN 0x3072e0, GID
> ::ffff:192.168.29.10
>   remote address: LID 0x0000, QPN 0x000011, PSN 0xa54a62, GID
> ::ffff:192.168.30.10
> 8192000000 bytes in 220.23 seconds = 297.58 Mbit/sec
> 1000000 iters in 220.23 seconds = 220.23 usec/iter
> [weijia@srvm1 ~]$ ibv_uc_pingpong -s 4096 -g 1 -n 10000 192.168.30.10
>   local address:  LID 0x0000, QPN 0x000011, PSN 0x7daab0, GID
> ::ffff:192.168.29.10
>   remote address: LID 0x0000, QPN 0x000011, PSN 0xdd96cf, GID
> ::ffff:192.168.30.10
> 81920000 bytes in 67.86 seconds = 9.66 Mbit/sec
> 10000 iters in 67.86 seconds = 6786.20 usec/iter
>
> --------------------------------------------------------------------------
>
> Then I repeated the ibv_rc_pingpong experiments with different message sizes,
> and tried both polling/event mode. And I also measured the CPU utilization of
> the ibv_rc_pingpong process. The result is shown in the attached figure. 'poll'
> means polling mode, where ibv_rc_pingpong is issued without '-e' option; while
> 'int' (interrupt mode) represents the event mode with '-e' enabled. It seems
> the CPU is saturated when SoftRoCE throughput goes up to ~2Gbit/s. This does
> not make sense since udp and tcp can do much better. Could there be some
> optimization for SoftRoCE implementation?
>
> ibv_devinfo information:
> --------------------------------------------------------------------------
> [weijia@srvm1 ~]$ ibv_devinfo
> hca_id: rxe0
>         transport:                      InfiniBand (0)
>         fw_ver:                         0.0.0
>         node_guid:                      5054:00ff:fe4b:d859
>         sys_image_guid:                 0000:0000:0000:0000
>         vendor_id:                      0x0000
>         vendor_part_id:                 0
>         hw_ver:                         0x0
>         phys_port_cnt:                  1
>                 port:   1
>                         state:                  PORT_ACTIVE (4)
>                         max_mtu:                4096 (5)
>                         active_mtu:             1024 (3)
>                         sm_lid:                 0
>                         port_lid:               0
>                         port_lmc:               0x00
>                         link_layer:             Ethernet
>
> --------------------------------------------------------------------------

Thanks for taking look on it,

We are working to fix the issue. Right now, Yonatan is working to add
various counters to better instrument SoftRoCE.

>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhfmLMACgkQ5GN7iDZy
WKdwHBAAn0f1pweiMuriKaMk3Asv/vBVLN6eWJgg/3s80htWRoEyZRE+hEQQ/374
dytjvtgqhQlORiqFX8lBuJKyTumZuNvSx5nvkOS8QNyIQ5bGVelT8kNz1A8Rp9IK
iDrZC3SvqS1756+lfBydaSW2iB3vWnVIOm8KYXCccg8FAw0oqVXPcriDV20sXhar
3/nxjm4B1eInOUQoqtdtMDL36oQPzXkIb4iiKKc/f6OPcKtA5UKWTBUm0TmDr9mH
/F1BoNv9z1KB26CmOsTvEcmCOzRD50sR5v++/AVbTmiBoeAq7Tsazw4oqDnQ5N/v
0sAIZq8OjgFEiYr0rGnlTbEYwYJGNUgo0lt79h8T72uJjN3AqUYzgWAxKsnIubfa
+/EnvPMLDfwKYFss1AY5jiev1pE20no58eZM3twTQOc3g3yrrUu9yBbvUKdZvYsy
cq4ytHPB7y954wxodn5JjPvVwOtrBsgWDlUr6G3VXJtNFd0pBAmk70D/U8lK3Tv9
E+6Y+HkQMEHR4iTGdvEGpTQuRqkNV6ZbBHnRT5tM93KvT/s/3sHwg0FJEHTww7o1
pjQn7vW6k30Sv2aAs56+//vDRJ+NZqE0BUWEuEOaOeX7Jy4eYORXMZqUUckTV3uL
8AtX2piLrYQb3rAJWOyzQZtfp3iS3SDZ2zb+lw1Acw8BTNNEM4g=
=VLMR
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
