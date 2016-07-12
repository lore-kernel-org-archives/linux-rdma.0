From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH -next] IB/mlx5: Fix duplicate const warning
Date: Tue, 12 Jul 2016 15:17:29 +0300
Message-ID: <20160712121729.GA17430@leon.nu>
References: <1468323167-1843-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468323167-1843-1-git-send-email-weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: weiyj_lk-9Onoh4P/yGk@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2016 at 11:32:47AM +0000, weiyj_lk-9Onoh4P/yGk@public.gmane.org wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>=20
> Fixes the following sparse warning:
>=20
> drivers/infiniband/hw/mlx5/main.c:2574:25: warning: duplicate const=20
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 7fa2fe7..a342d73 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -2571,7 +2571,7 @@ dealloc_counters:
>  	return ret;
>  }
> =20
> -static const char const *names[] =3D {
> +static const char * const names[] =3D {
>  	"rx_write_requests",
>  	"rx_read_requests",
>  	"rx_atomic_requests",
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhN/ZAAoJEORje4g2clin3c0P/jTylAScE2PkYrzmBt13dNFQ
uOpogl/vfnnw3YgtNYx+eeKZw4ft8QbRONTLXk8ofhEqLU/vZ2TGKdHeo5NhOKTK
YOBCVhzNqLC4r0dw2QelSZQVnlhc4Xg00V6LKKbFTdS5Wec/erDGDiwu/aDLmkbt
25g3G1qdSIiTlryaT23r/iMoaA8ErDPlwHaQrsGyxtmVWjGoLuqi+s0HCrGe6vv1
VEYlWc8Q4nHGtPrWCivVRFh8cIxcijhE03stxBaUqW/wjZy9IcG5ngmpBtrTZkCR
I77IZ0WkzkFu24TIjCW1r98BEp9nLADM2rxif3s9Pw06l74eqvBsTCXXXoQ0BqSb
3WtLZcfU2godGkXFKwJESkbtXcPszNtWEPYC5/7ltXgdt5g3GtlLL9Y90nWyGIDc
fVq9kRSg68FQcQeDUDdWBIzp3XhSKvOICDJ1ix8/nPgEcHyFxOWiPJ4ZlPTsSCre
N3guAYNSox9ebule70SGCGm5hBaG6EosQtqIhZKBZsIbmwZAcPmlwtxaZ61Z0zxD
ev9rV0+7z8TjxL9DdXkHMMm2zB8Y6CmAGYeDQX6qSkigrpDOhV1mlmPHtFJyQDGN
apbarKTxAK9uWuPod/fuhJhU65jc4edcPfN8Ya7WWN5CcLB2Yiot9x/I9DxDPxug
7DkylW5Db93b2Jvg05Me
=K4aQ
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
