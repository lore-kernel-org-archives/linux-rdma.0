From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] Release candidate 2 of rdma-core is now available
Date: Thu, 15 Dec 2016 16:31:54 -0500
Message-ID: <b0bf35bb-7c63-88a0-d97b-aca8d845fb19@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uQU34AKCq5I96vB7rm2kRQmoXrgH3Sted"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uQU34AKCq5I96vB7rm2kRQmoXrgH3Sted
Content-Type: multipart/mixed; boundary="djBt52tuKE3E6BuEM7HF3frghNLHnljeE";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <b0bf35bb-7c63-88a0-d97b-aca8d845fb19-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] Release candidate 2 of rdma-core is now available

--djBt52tuKE3E6BuEM7HF3frghNLHnljeE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

There are no major changes (like API changes) from the first tarball,
but quite a few fixups and such for various drivers.  This is intended
to be a close match to the 4.9 kernel, so two pull requests are being
held until after the final release as they relate to code appearing in
4.10.  If there are no major issues with this, I'll tag an official
tarball in a week or so.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--djBt52tuKE3E6BuEM7HF3frghNLHnljeE--

--uQU34AKCq5I96vB7rm2kRQmoXrgH3Sted
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUwvKAAoJELgmozMOVy/dGDAP/26qIJyl5K8klsj1Z2l+SUIU
lXPv7YpLaEPopCeEQiDnnHGkxTd6K+p3H8dN+mzzMleH9vq6FTO5C/5tUFz11MBh
VzILKiuGJIvRO4TseoeI5HciVRT42e5jLtQLnQ6j8xuhbE1ky9WyGQxV+dLUz8ep
JOxFnm0yKriTH3+REwzBFumoyol7BJ3gpTHp2+YHsbpM5YJe7BktgBuAqwqdT+wX
11QuqJY55CgQWaM4aBYVAFtzR0KmFerIeL7AaQfHOX/TT5yllH7BP0M5wAQPIfne
OkZU7vhobXEyqrU3PvXFwOsxeyzydydxToLOvEFGNvWUdYr0/Ky8rqpJUBe8ZGug
qCV6WDIByKDefMzkNNw7mVmEWbKxW0hDK/bxqXmZsKGL/SZ/SoLE4DSAk2chNu+v
3Do04S10KYjwle6Zz77com624kgYV52Yd8ybPyx65r96y/AsgF///ENFtOZZw7xq
8v7eGx0kuQCdTArKRGZqrWmTboh0+u5O5wHf+t4GBgg4/71sOgKDLthUI9XbimUd
hQWPfR/HOiF3+leSOtjYjMbvGk5KZG02faxgcUjbMSZpKInEzS37a5tXwpNzcFYD
BBFd884XkpxNkVEs1zPe92rC7PY2Xqwj3K6ylrbdqEbS9IRsSyUsAd+51Xg5uIK5
7vWoo7iLX17mcJxVOOdH
=9tlr
-----END PGP SIGNATURE-----

--uQU34AKCq5I96vB7rm2kRQmoXrgH3Sted--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
