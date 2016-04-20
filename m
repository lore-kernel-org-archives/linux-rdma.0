From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Wed, 20 Apr 2016 08:52:21 +0300
Message-ID: <20160420055221.GT6349@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0WGqsT62A4RTsSXf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Following the discussions at OFVWG (4/19/2016), I want to present
shared repository and topic branch for ABI change proposed patches.

Please post them on linux-rdma mailing list with clear indication that
it is supposed for ABI related work.

I would like to suggest to use [PATCH ABI xxx] notation, so it will be
easy for me to take them and don't mix with general RDMA development.

Kernel part git address:
 * git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
 * https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/

Branch name:
 * topic/abi

The supplementary user space (libibverbs) repository will be set a
little bit later.

Thanks

--0WGqsT62A4RTsSXf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFxkVAAoJEORje4g2clinLBkQAIsYVPnjF0bwjDs5v3eWvKlb
6DIil8EsIkt2afeuTPjMv1AoypZq7Dd9C++bI2MNbc8UJxx+Ok0HYqugE0Q2wJEB
I9sBMRgBnPFTiKqrZGFq6HuMxpymUFwZ+JhMbYWU6IBSprWkISwAb2HMb/91L6yC
rOXvKwI3AYUn+Y8A2ZLnZFJ3YQejwKtqAXIc+PB5g4RvlTCCpRTDm2CohJxjGekc
Og7l8izE3vWZvsG53hWiAteZFN+2+zuVGZWgGHR9zGnwWjH0ezZpvgUg//sV/6kb
m2RM5zBH51PaNTonk+ZLBw4wR5ca9xeRWcAAjPIDdD5eveeXaYzkIHoayHbZnUuC
ZfrjYFlg+9mVk37dkTUx7PuSB+Wwq1VPl9wVbhiBQRK2p+0R4J7zmdVp+FDSdf3G
zkPDbebBB5EQ5zva6tUQCrj9LXJC8/CJvTHrxCvz9XtNzjv52/UZzT5Xo/aVV1UJ
sLhMvsCV+HTZ1n3lbvWXBZFyOa/qrUFjFGNiA1G5S7XIS3GVKc+HhLvN/bUk2/iM
wE/RuIIsjN2002dsvZtIMplFxmghY7hbKy62xxizWdjqv0/Nt0H/KBqv6Heb01qz
dD9CYTzPQ0wB6yRi1b1gh7Y+GepaO5icpqD2FzbtFwcP7uMk8ODHuglypWaHoR5h
YYqyorfZH8vuRyI1fJhL
=sbRt
-----END PGP SIGNATURE-----

--0WGqsT62A4RTsSXf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
