From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 00/33] RDMA netlink refactoring and
 RDMAtool code
Date: Wed, 9 Aug 2017 13:48:28 -0400
Message-ID: <daad4fb0-cb9d-f6f2-073f-1150d80ac951@redhat.com>
References: <20170809160405.25142-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pRH8qU9Ninvdm50lBuMs6Lr99foUvJlME"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pRH8qU9Ninvdm50lBuMs6Lr99foUvJlME
Content-Type: multipart/mixed; boundary="HJNVoGJB5FThKELG3XksFRjU9Lo30B2w9";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <daad4fb0-cb9d-f6f2-073f-1150d80ac951-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 00/33] RDMA netlink refactoring and
 RDMAtool code
References: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--HJNVoGJB5FThKELG3XksFRjU9Lo30B2w9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/9/2017 12:03 PM, Leon Romanovsky wrote:
> Changes from v0:
>  * Dropped revert patch in favor of patch-hack from Intel (Ismail, Must=
afa)
>    for iWARP, in order to progress with series. For the record, I think=

>    that it is wrong.

Noted.

Series reviewed, comments made.  Overall, I think it looks really nice.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--HJNVoGJB5FThKELG3XksFRjU9Lo30B2w9--

--pRH8qU9Ninvdm50lBuMs6Lr99foUvJlME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZi0rsAAoJELgmozMOVy/d+BgP/1JXzGvArcXpXhVJN+u5Zikf
AZzFUiHTsTVnd4q5oGUv3+6dqm8GIDX0HCP75jNipuRXZcemPa7uwujLPJxZHH4o
rljYEDstwQWYVQ8xdSkRui7MDT7KBqEYzKBnXuOBEodtJ+5d197wAb88vyc9Iemi
vH6VgGsvAPETM9va7ssj8x4vfzXLDMsnnfn5Z9cjkoVI319QyKXxBF4WX4AJeRKg
+vx81ZzcvGHBK3VsKzz+jZqyXnoyt7u7Tt8OTSEJdC+CNouAwZLq3vRFyyu95rve
fcbflP9Gr6NLKKrRWpEYKxJGqfZlPTYAuehB2V3Ydg/4Q3QUWMF5BGseAd/F7etM
RyMmUepU7YnKvaI+I51YulTIm1byL6a4k1fp3MhTo+r5VWoSJKA0jhNSYItew9HB
Z+x/UedV/dbAz4R7FxAcf4U2Ch/Rv/C505kxYBoFZwkkanbdw4GsQzgV9D/Pu+/e
nUZ5pKpKjADhEtHDVVLBCR151B17/CUY7xO4rcJD6NOqST/ja+pxMS3Mb/I/nutg
B7KcplXva8Vuw1/PY06HL7UslNs72wQBrQFGXjMUwCGxXjetH+j42d0u8FFtbqWU
7Z1j2K6KiTjfakeLTDhDPKs74Gy8vx5tDSNx46ufvI/jcP+Zli6YD9OiNePwfPQJ
K6LlMUorUS8RNcaJ9g0v
=Uv2i
-----END PGP SIGNATURE-----

--pRH8qU9Ninvdm50lBuMs6Lr99foUvJlME--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
