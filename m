From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Init subsys if compiled to  vmlinuz-core
Date: Mon, 27 Nov 2017 15:43:35 +0200
Message-ID: <20171127134335.GN29104@mtr-leonro.local>
References: <20171127133905.8231-1-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127133905.8231-1-dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 27, 2017 at 01:39:05PM +0000, Dmitry Monakhov wrote:
> Once infiniband was compiled as core component it's subsystem must be
> enabled before device initialization. Otherwise this result NULL pointer
> dereference during mlx4_core init, calltrace:
> ->device_add
>   if (dev->class) {
>      deref  dev->class->p =>NULLPTR
>
> #Config
> CONFIG_NET_DEVLINK=y
> CONFIG_MAY_USE_DEVLINK=y
> CONFIG_MLX4_EN=y
>
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlocFocACgkQ5GN7iDZy
WKdwgw//a4mAmKLiyQh36GBRXZvj7PVI1w4f9vVP00LbznyiQMdH9NnYmC/lbLKq
Zff7SHZqMoE3CcoBAwauUD8gUBnyvSG590POevGWjjb2BChAtupxsJwAwAjr2Rvd
N9kC2S+n8BXn6Z1DA/gHqdPLqEferWShFqDqMXNPy2X1rUXG5V3S/xVzf60yzDdP
R/H7LHdPxN9VV18RfFS4mZnnTBpfUt6TnuuMLt6xyHL+yWbzcxY8cuh0C4whnuoL
0pEOADZ9+BAS9bsqM+FeTlqVDyMukxY+YCLPetft5mRg1lTXYUeUwsSm2INeNACv
7FXUGuXJS4LWF/o+59YAPAyXwGzzOTbOsmjjQmDz8/giIb37Lp23H9B3YdOquoHR
P8o1Lr1r7K/HmG9r3dAuIgqm7tNFs5IhPaiGwQ2HM/BM5fFaKh4NA6Lo/Nnc4bIn
OoRjRsDdKhCHoZcttjVxkFbjDZTS9jPHWz++Rd5/dTBfp0KM7ruTr7uaax7/vk+o
izhiDjLnVVQh4y2dwyC3j6DFLuTeQiO/L3ckhoIYDH4og50/01VmlJn6rAfB2GFB
w4wzOuteyH10mSPBRh0IFRSP2u9zE1TnFf8WKMp5ykYB2XXLZgUlgKDCNydrDwxf
yuAX2+YJbODlVeWzEmT77v+EYb3tbuaYEDtRS39fH1zkCTrfcTQ=
=dUOq
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
