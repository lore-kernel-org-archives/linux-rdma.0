From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] IB/rxe: use setup_timer to simplify the code
Date: Tue, 7 Feb 2017 18:29:46 +0200
Message-ID: <20170207162946.GN6005@mtr-leonro.local>
References: <20170207151510.12503-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KwgAcZnBnwoMp5TU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207151510.12503-1-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KwgAcZnBnwoMp5TU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 03:15:10PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Use setup_timer function instead of initializing timer with the function
> and data fields.
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_qp.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--KwgAcZnBnwoMp5TU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliZ9fUACgkQ5GN7iDZy
WKea6xAArRJdlamkBKt6SBp3T0g8msI/dVcLx2RMNH8jLZbjRXFFYpYzXvFc4wNb
EXOTO9nObsv9QLWlXaf43urHy6JHiu3yDHKk2mcw7zrUh9GWwlFFiq7RU6HArY6G
pYH6uYuUhJvek9ZEzxJvka0wBDB0ATaL4JUDcuAj3xqmJf7CI77x9kluzm+/zceV
j/Mup7DATovw/HYryK9rzjtri2JueGWxZcLP8qxpmUscdZnkCIVXcDl2YP2/SnSz
XEAYzuctsurRw/uP7xqazIEg0gEWTei6D119NOW7GmE6QqWTh2U1HCi8gmFdYjhA
V/Hm34OsBGEQv71PSoPgWwpnfzMyzmkEt4wQr+ZLPYOK+lGfwsqYrQ+1FYqAFhuC
vA0B8MRtXLzwk5iW8fL7lPGcm5EDgXomveNvIhFw8se72RyDM6pA1FDHcZXen+OT
LprtOizRZ5PpWG/Ropg2f3iF9SRKvwy9fPAy55tDbUUS4ecs1va1v3p9sHelKG7E
GcDaKpTOGv2KLe8lHwVCApuHnx3twJR1mHzlBmumLin1IEk4PYkIrx6PfpflP6xu
H+JeX9WIxVwLvaad0U5zlBra3ehXDgOqP8KlRomKr2dKIDPitt7TPnCSYupowPuy
RdAgUBeNtJ/tfBliIvJG35fftNr2LaBkys7g52hTzUa+Kj1aBw4=
=ZZey
-----END PGP SIGNATURE-----

--KwgAcZnBnwoMp5TU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
