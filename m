From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Destroy ocrdma_dev_id IDR on module exit
Date: Wed, 08 Jul 2015 17:43:17 -0400
Message-ID: <559D9975.5020306@redhat.com>
References: <1436368980-31088-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qq94X3H7VXdjT0O2IOVVX8nHOqhWxTT28"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436368980-31088-1-git-send-email-jthumshirn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qq94X3H7VXdjT0O2IOVVX8nHOqhWxTT28
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/08/2015 11:23 AM, Johannes Thumshirn wrote:
> Destroy ocrdma_dev_id IDR on module exit, reclaiming the allocated memo=
ry.
>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qq94X3H7VXdjT0O2IOVVX8nHOqhWxTT28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnZl1AAoJELgmozMOVy/dbEgP/i1V/19MdUJ9i2vppXH+7AOe
eQvSNZtWdyhPWgbLk9wEp6SEecr4cYH0f0FpT6bOKe9CeNxwqv9fxk6XJIBixWSc
W3UPDN2g7Ou1zsz+K4zxoXNOR+o+vNhwfCAWrVZNhun6F9YS/lysNrIuXpMXd12A
OvXRZSx6WfxqnGy/SnOEAB5vkZU1FGPCh4gch6LNJN5BwKaGVGQXCl7+N9iWvWX+
7jquYlJYsqAHf7YO3f4iXPhNgJ5MLWNU/0QV1eP9ypnqlICjyhLXVbZ/UQUAwLHn
jmwHjqD5KgGKyyq48pYm1iXjpjXqq5Z5qRYFTcL9E01eclBNPWAowMNXnzFGL7r6
86xK7rmmbSBIkeB/i3LEXCHO5ZwEPLGDSm2HZUr07IwhJ8+ZCoJvW135aY7Sc6gB
PSf94kab8ISu5OfQe2UGC1IuHZZF6RzUw80eAO1npobTkdSgmTY99v7lMb7EOsgT
+kCxOXB+lIjg9AdNOMK5Kw1z114wyzKlNM1DVP8JDPQsszIKbbimS0p1+x18f2vS
mnc2gzTURUfE3OlQ92d9Ol9L9HUtGBZoNRrQSv32IAhyzxeRvQY1Yk6C1DJSKt7I
OIpcsMcCUvNnFFa7cF2gdLSY6H1EcaOjr9k51IflY3wQ+F87Y0PrSAGTkThr1wg3
IubM617FIhtVwtEG+oKF
=hr8H
-----END PGP SIGNATURE-----

--qq94X3H7VXdjT0O2IOVVX8nHOqhWxTT28--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
