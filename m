From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 00/16] RDMA/Intel X722 iWARP driver update
Date: Sun, 17 Apr 2016 17:07:14 +0300
Message-ID: <20160417140714.GE6349@leon.nu>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2016 at 09:30:36AM -0500, Mustafa Ismail wrote:
> This (V2) series incorporates feedback received for the initial series.
>=20
> This patch series covers changes to i40iw since the initial driver
> submission including base memory management extensions, virtual channel
> messages queue, corrections for endian warnings and bug fixes.
>=20
> This patch series is based on Doug Ledford's
> https://github.com/dledford/linux.git branch: k.o/for-4.6-rc
>=20
> Changes from original version to V2 incorporates feedback received:
> 1. Move RDMA in subject line.

It will be great if for your next submission remove RDMA word from [RDMA
PATCH xx/xx] title and add versioning to it.

Thanks

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXE5iSAAoJEORje4g2clinQDAQAKS6aQuEzLqKuRaD5lHnk666
aWsiLq6sAgC1NDKg27Qn2U/0s4UpgglF29/f+pnc7eZF9zT5vzT4ekBRg9F9P3Ph
FZiwS2R8siImeRhFnm7OKhynsz0Tk0X6RAnGin7EzrLgAoDEpvQyNLzgkQfKuZJ3
dAilLtJkdysPrtEcLyFBJ9Y+VKCocFPjo4TO8PMZ6YjRSM+gB6yrlAQv4hv1Xb8p
CR6q6nbQPb2/K72Smx0F79zDQE7fvBR/An2bO8xttiTiahtLHLg3DpfCC8195UEv
F95sq4o7yq1GQ7l0/zYGHtBoHOklcs3FvbPWaTOm+OyGOXcw+jyOP63kLoQwCx3o
+KGsAXoEf8Odd5pYfbyHexjPxaVJdZmFJ5gVqM1/3qmn55bG7iTVPua53tSxg+/b
qLzDJhy71V1A/quoH03i8/DYuELU1Bhek+2aLJnCjHJaQ9v/ED6L1ufNfs6GnMGz
FeOyv95pkhJwxN4JdElQpJytUCWIKnbZhV6O2mZ6dxb79StKYlYklWeJbPka7ZMm
KiYpxJDfoIjei05IXjrWf48Yl/mwzQYilh6A+TvVp/aTnK9PuBxM2+RbKLhRV+tT
jFFQZ6zaXT7G7Vr//+Xu9VA6o62SldKCS+SP0A0HH4cebO2MNM/Sej0gofOt3bVh
wWgtXK02ULe9DJp6RFe+
=PXzf
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
