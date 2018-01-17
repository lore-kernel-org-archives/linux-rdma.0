From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Expose mlx5 core driver's clock
 information
Date: Wed, 17 Jan 2018 16:16:32 -0500
Message-ID: <1516223792.3403.287.camel@redhat.com>
References: <20180116180841.18976-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QsBf5+RHXREfyyGDtBng"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180116180841.18976-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-QsBf5+RHXREfyyGDtBng
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-16 at 20:08 +0200, Leon Romanovsky wrote:
> From Feras:
>=20
> This series adds the ability to query mlx5 core clock info from userspace
> applications. This will allow userspace applications to translate timesta=
mps
> from HCA core clock units to nanoseconds using the latest clock info.
>=20
> The first patch creates a new clock info page, which will be updated in
> the kernel only, and the second patch maps the page to userspace.
>=20
> In order to read the clock info correctly, a sequence number is increment=
ed
> at the beginning and end of each update. An odd number means the data is
> being updated while an even means the access was already done.
>=20
> To ensure correctness, the user will:
>=20
> repeat:
>         seq1 =3D <read sequence>
>         goto <repeate> while odd
>         <read data structure>
>         seq2 =3D <read sequence>
>         if seq1 !=3D seq2 goto repeat
>=20
> Thanks
>=20
> Feras Daoud (2):
>   net/mlx5e: Add clock info page to mlx5 core devices
>   IB/mlx5: Mmap the HCA's clock info to user-space
>=20
>  drivers/infiniband/hw/mlx5/main.c                  | 44 ++++++++++++++++=
-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h               | 10 ----
>  .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 55 ++++++++++++++++=
++++++
>  include/linux/mlx5/driver.h                        |  3 ++
>  include/uapi/rdma/mlx5-abi.h                       | 34 ++++++++++++-
>  5 files changed, 133 insertions(+), 13 deletions(-)
>=20
> --
> 2.15.1
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-QsBf5+RHXREfyyGDtBng
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfvTAACgkQuCajMw5X
L92lpQ/9GYH+/dkL3fRv9jTC06Q1uvaLQLypGQ4r7LpZ1oXW3FsB24Jfyw5j82QY
fNGa95lRDPyN9yfWUKC0IV96xZTh57J7G3mNhXfxNjAWev3axJESzBu1Fs7GrXJJ
vnoXXjwjuqBsp0RCU6MAMx/yrCyR0WyJO/wG6arQuILc8apPPo4gYJ7aEabIhivZ
Tjf50itb7l68m4WuShDB2aV+3vaOjGr8pR9zqJ/9x7KnR9p+zZ9rIu4mswYj+I/I
qImpQxvWoZkpx/fF5qcvbFQbpDuvuHZMt3qT4hALTLLxTFxohQKjoGxu4Es/gGzz
roJqXZfZXKzZhgUb7Q3x2U5jcE+Z/H6yNPKIoCZVRRi5OIVlf5XOH4Xw8ZArWOAI
ntiVd5uZVS7+3WgSCeLn6G4fdrVHXhxP79LxykN0hdwZDTGtNachWaaP55nbmry9
vVhdKbbFKw8SB0VFtMUe2Y1P+7EWP9gNVhC+Yt87xN1mcE7HulCAUryei1DQ9PqH
GLv+We8gC069Z+lEWtmpkjzSq3foE/Xot+VKtcAXwB+xJACpkgsAuPIBFSiQyZI1
o3by7R7pmRldiBa9K6IfWa6IOb3biOnEyDeJKuD60ie7v746mV6Inr94vT00+S/2
y1GYV+lre+YGoXWBjf1crkXBl7JdC/acs5bE3Fnge7B6oP7mBMo=
=ZKHP
-----END PGP SIGNATURE-----

--=-QsBf5+RHXREfyyGDtBng--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
