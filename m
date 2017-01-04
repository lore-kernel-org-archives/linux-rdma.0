From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/15] IB/rxe: Add a runtime check in alloc_index()
Date: Wed, 4 Jan 2017 19:27:04 +0200
Message-ID: <20170104172704.GU12077@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353638.3592.30.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GeONROBiaq1zPAtT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353638.3592.30.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GeONROBiaq1zPAtT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:41:58AM +0000, Bart Van Assche wrote:
> Since index values equal to or above 'range' can trigger memory
> corruption, complain if index >=3D range.

It looks like severe bug and the proper error folding is needed, if it
is a real situation.

>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/sw/rxe/rxe_pool.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw=
/rxe/rxe_pool.c
> index 7d1e2862b928..75d11ee635ec 100644
> --- a/drivers/infiniband/sw/rxe/rxe_pool.c
> +++ b/drivers/infiniband/sw/rxe/rxe_pool.c
> @@ -266,6 +266,7 @@ static u32 alloc_index(struct rxe_pool *pool)
> =C2=A0	if (index >=3D range)
> =C2=A0		index =3D find_first_zero_bit(pool->table, range);
> =C2=A0
> +	WARN_ON_ONCE(index >=3D range);
> =C2=A0	set_bit(index, pool->table);
> =C2=A0	pool->last =3D index;
> =C2=A0	return index + pool->min_index;
> --=C2=A0
> 2.11.0
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2j"?=
?!

--GeONROBiaq1zPAtT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhtMGgACgkQ5GN7iDZy
WKd8ew/+O02k5MEgow4d7N7FXn7+NDAI3wPFsGCuWIvjYQrpA0J7E7fMraVfGaZa
76l8khsl/6d0Zh2TlgeCvexBjdiAahkttKU/jokh7rRRt7tZ+y0Utai2+7oqXE7D
gef/+ydCkc5V5cK11the1BhQ9+e5x6AcRtjSdepVE/xMgfDEzBmlcSMcUyXSF+Jv
fbKny0FhBdEhlzjKL8iXTDqxyrWZDIbwE19Z/jYseX7Z/xjbZgyhIpx2Ui+VJUkO
r9/LcBvnldxIVzM3KtmgasecdjXMYMbLOv03rNN2nkVX8U0hz0WopgW8MGhw86TJ
62TtTbYFVa0hZYjmAmSnFpyWxke7C32WNLqcIs24Lz7VJAjLM25237M+VAJxFrxu
TVIlXh5ziuhogTtk9RatXwJK9ybeHCiD25FPy/eRG+D5iEyIOLWBWFf0ykAg7NaV
IyjVgDaeGQ3mgCjxjvvV79UfQws5Xm+otFZgdbZt/c+DSeyEAHe6uJXy4ZCk+Zld
D5rXDdBPupCGXhTIXCRV+ebI/nLPuLuE3jb2z+11M9ytCTEAIMQmn85Ek6KeAMrQ
62drJU5co5817wtUtZoMljkbAYhXca+4AzYZu29d/dPUdmTNihYgk5Jc7GgcSngv
YYqXZJJa8Kxg9cYRucU0vwV07Wjqw6Xiemwycw+CNjQHdBf+/0M=
=UJ1c
-----END PGP SIGNATURE-----

--GeONROBiaq1zPAtT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
