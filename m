From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Upstream mlx4 driver very broken (when using SRIOV)
Date: Sat, 13 Jun 2015 01:35:01 -0400
Message-ID: <557BC105.3070405@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bCN5N5m35Aj1PTVSHKkTF65ADOiFM6Mtu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bCN5N5m35Aj1PTVSHKkTF65ADOiFM6Mtu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I ran across a problem today when I went to do some run tests of my
for-4.2 tree.  For a second there, I was about to seriously have a
conniption fit.  But, after about 6 hours of work bisecting and
debugging, I've come to find that I wasn't so crazy after all.

When I went to install my for-4.2 tree, IPoIB was totally busted, as in
DOA.  I knew the 4.1 code I submitted to Linus I had checked, but I
wanted to have a good starting point for a bisection so I compiled a
kernel from my for-4.1-rc branch.  And it was DOA too.  That seriously
unnerved me because I knew I tested that code.  I did a number of manual
checkouts at possible suspicious code points, and none of them showed
that the problem was resolved.  Then I started doing some debugging on
both the afflicted machine and on the opensm server.  I finally saw that
the afflicted machine was claiming that it was attempting to join the
multicast group, but was reporting error 110 (ETIMEDOUT).  The opensm
server was not seeing the requests at all.

Long story short, I did my testing in the 4.1 merge window and rc phase
on machines without SRIOV enabled, but when you enable SRIOV in the mlx4
driver, the current driver seems to have broken QP0/QP1 multiplexing
support because the host becomes unable to join the IPoIB multicast
groups.  In addition, with SRIOV enabled, mlx4_en throws corruption
errors on reboot and requires that the machine be power cycled as
opposed to rebooting cleanly.  From what I can tell, the 4.0 release
kernel has this problem too, and it still exists at least as far as
4.1-rc7 + all of my queued up -next patches.

=46rom my /etc/modprobe.d/mlx4.conf file if you want to try and duplicate=
:

options mlx4_core probe_vf=3D0 num_vfs=3D7 port_type_array=3D1,2
options mlx4_en pfctx=3D0x28 pfcrx=3D0x28

And I'm guessing that your internal regression tests must not have a
machine in IB/Eth SRIOV mode as a standard config.  I would consider
adding it to the mix.  I have it myself, but only on a few machines and
I don't always use them for initial testing.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bCN5N5m35Aj1PTVSHKkTF65ADOiFM6Mtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVe8EFAAoJELgmozMOVy/dZhAQAJkD3VAj4+K+RFuT1FXqFt51
HYD5pC8nw7vy/d5LU/2dM2k+Qmg0bZ5uPvhjysgahJzrvM5R+78EITtSwlGu0Kqs
xEL9fNX11tmLgxuli/gY8Dm1c+b+bySq2NGwLsDlYWBzQjTJAxeVyYRjrnZhU7AQ
bkDg6nKCFAW0FnQ30XbzB+rCQyUc6r8kBxbDt21Xn5g4J3KaXJMi/SKbHUPG7YEM
OXhLqmBTQahwdSz2n4jBQ1D8p7dQI8zx2Wm3pP8qF4E3UWeozdYWLyWxMAjHA/k0
5x7dPA9+eOSjzIF278xotv541nqNJqN7LOfHICoVas9eOypVNXXSDdsSODy7qYaM
mHR+24zBVzUcqKnKeAqYK4iH4O84Vg+JUZbWZ6g/KQRPjaixTXoMgK6lzOHqaM4X
9iX6F4CUZxs7CLbyApcLoLQ9Yi1mqAXNYcImqeQ/poQIL3Nm7jWdFUyWQ6HLNwWS
oDECnnioukJrjA8VsrO52S7BBib3nFNR3umK1VsXvG3RvR3qqsc7ijGg1NOPBYu2
w8ZyBeFyE2367vlmIqGg3B2MRgMFU86jyCccibcCYvJdHB4X39YTW8bIcvjsof5R
Z9fH2quIaIrhyzBZsuperRKNjB1xvvCFxWx6i7/NEHF5ibi28NQthDokmp2JujRP
ebzOXJUK1TDy7PLNy0TY
=Y6l8
-----END PGP SIGNATURE-----

--bCN5N5m35Aj1PTVSHKkTF65ADOiFM6Mtu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
