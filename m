From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/3] mlx5 and NLDEV fixes
Date: Mon, 13 Nov 2017 13:54:46 -0500
Message-ID: <1510599286.3735.24.camel@redhat.com>
References: <20171030122315.21924-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-w+3zWTlAn4KfYKnL5hfk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030122315.21924-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-w+3zWTlAn4KfYKnL5hfk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-30 at 14:23 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> There are three patches targeted for this -RC, while mlx5 patches can
> easily go to -next, the nldev patch better to be forwarded to Linus in
> this cycle.
>=20
> Because, we are in -rc7 now, I would really appreciate to hear your
> plans regarding nldev patch.
>=20
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-r=
c-2017-10-30
>=20
> 	Thanks
> ---------------------------------------
>=20
> Leon Romanovsky (1):
>   RDMA/nldev: Enforce device index check for port callback

This went into -rc7 direct from you to Linus, so I dropped it here.

> Majd Dibbiny (2):
>   IB/mlx5: Assign send CQ and recv CQ of UMR QP
>   IB/mlx5: Fix RoCE Address Path fields

But I went ahead and took these two.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-w+3zWTlAn4KfYKnL5hfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ6nYACgkQuCajMw5X
L920Sg//UonP9/a918KMR54kS4qzJZPx3bMAz9OayUmXyOO0IkFYqZU+objzIXGk
wuS9bnWyNqyYb1p3AO84le5AUzeU541Ycn/WvpHtpjRgtVsJD1oK1LOtIAmklRpV
5u8Vto/Iyoiu3w+S4dDiZAcUQcEHV+qTkl4GbA94eKdBc35Wh0nBji5lYATP4Fvm
n+xbHZUJLGgE0GxBjt0nMwStahCXM/7Jr9zmsykOgqkWVl7+5OAV0mDbIARUyg1b
9LK4EN9p2Nq52BkseCg58wQqeqDpjIx89BLir0XXxAkClI008hRtZF3kpuSKAHCK
IgX19Rx9EpzdziDe+ZXUf7ezJFGSDP4UGBeaMMJ5PnSe1cBKbg/M7xTP2u6fctrQ
H+BzdzhWMfZyLWDWgQMgjPCwvV1R1C/MuNHZnsD8fgCdYoPviP8s/G49opKUJD37
4Tc++0tUdyMByJOgDHQxThZgZQmhZ8/09ACg5EPqk7qgCf3tPWvfX57fJYvrDwpa
aTN/9U4EBRvrt4xLdk2yIr/29ZSyY59NA6FYocS5A1iuF3sM/KQFX3DBZUvCF2Df
oNraHWlxAwob6i5dWLT/AumyYA5TX8C9sXTyUrmfcHjctiqU5cGtVf+nSaetDNc9
yf1AeK98LDwJJRsWokVYomaXwAfwT6NQEOOoa9ii8aXpvVHkOrc=
=VLw9
-----END PGP SIGNATURE-----

--=-w+3zWTlAn4KfYKnL5hfk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
