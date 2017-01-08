From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/15] IB/rxe: Let the compiler check the type of the
 cleanup functions
Date: Sun, 8 Jan 2017 16:22:51 +0200
Message-ID: <20170108142251.GR15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353591.3592.26.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EkxpYdHiqGHPYbUt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353591.3592.26.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--EkxpYdHiqGHPYbUt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:41:23AM +0000, Bart Van Assche wrote:
> Change the argument type of these functions from void * into
> struct rxe_pool_entry *.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/rxe/rxe_cq.c=A0=A0=A0=A0| 4 ++--
> =A0drivers/infiniband/sw/rxe/rxe_loc.h=A0=A0=A0| 8 ++++----
> =A0drivers/infiniband/sw/rxe/rxe_mcast.c | 4 ++--
> =A0drivers/infiniband/sw/rxe/rxe_mr.c=A0=A0=A0=A0| 4 ++--
> =A0drivers/infiniband/sw/rxe/rxe_pool.h=A0=A0| 6 ++++--
> =A0drivers/infiniband/sw/rxe/rxe_qp.c=A0=A0=A0=A0| 4 ++--
> =A0drivers/infiniband/sw/rxe/rxe_verbs.h | 2 +-
> =A07 files changed, 17 insertions(+), 15 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--EkxpYdHiqGHPYbUt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhySzsACgkQ5GN7iDZy
WKeVMg//fk6AB2HOBKHeaChSRnF+70fls7EzKyXea1chlbSH436EQIxR54u9hdzU
e4QbMvwPZz4jZyh+Goo2bXXx5EZAbdV3FrqDuh+e/dwemIiqwJKMOLl4sXlOVtPo
hbGe80l1bLO5suJnInRlHahnjnJRiGRzY3Q7g8JpTOsJrc/tgs3ziqEIISM3hqJi
649LSF75aWEd5MU4Fxk507PdiMbL11pRuIttiRBW7gWPXyBRVpDpIjCdMIXXZeQv
Tt9j0L1RsiTVSmsHmDxCRUdxLj85H95Fvo/lXiVn+3DLTbycJd/HSge2kMFkcESS
he6ke2Eq7e8O8DilC38ysqAbscpuj2kEX95NYw0S6pciHabfGceWTl+RqUJ3sJRM
0MqqQI+ZwmVdprWckh3NIsh/zL4J6AJ23QQxCCH0fTe1KrWb1gz2xsDZYT93nJnc
lN4C+WadOKqRKsuSSVyf2tuic9e3w9qn5gsi5glqNcK918WzJMaiACUUdhNnwi0O
1WIi6vHdhzJ/+pE0MSR2/g4L10c4RJc4qt7Xc4TzbK1VqMCV86IJvoHJgCpZbe+6
p33Rd1/iuCQoFWdtWgcOZ+5l86x93ll4gScXk+KHNEwgQyY+Zhw3hluWlp6zPLVR
yjl1og8cU17umUbF8C5E0olwYZrRczdSd+gZMQRVtZrfMeRuPgc=
=IlHP
-----END PGP SIGNATURE-----

--EkxpYdHiqGHPYbUt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
