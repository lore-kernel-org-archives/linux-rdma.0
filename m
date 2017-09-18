From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: fix debugfs cleanup
Date: Mon, 18 Sep 2017 08:49:10 +0300
Message-ID: <20170918054910.GE5788@mtr-leonro.local>
References: <1505651288-4781-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505651288-4781-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 17, 2017 at 01:28:08PM +0100, Sudip Mukherjee wrote:
> If delay_drop_debugfs_init() fails in any of the operations to create
> debugfs, it is calling delay_drop_debugfs_cleanup() as part of its
> cleanup. But delay_drop_debugfs_cleanup() checks for 'dbg' and since
> we have not yet pointed 'dbg' to the debugfs we need to cleanup the
> cleanup fails and we are left with stray debugfs elements and also a
> memory leak.
>
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index ab3c562..fba1920a 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3870,6 +3870,7 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
>  	return 0;
>
>  out_debugfs:
> +	dev->delay_drop.dbg = dbg;
>  	delay_drop_debugfs_cleanup(dev);
>  	return -ENOMEM;
>  }

Thank you for doing that,
I would prefer to have the patch below to set dbg pointer in one place, together with following
fixes line in commit message:
Fixes: 4a5fd5d2965c ("IB/mlx5: Add necessary delay drop assignment")

Thanks

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ab3c562d5ba7..451aed790248 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3837,6 +3837,8 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
 	if (!dbg)
 		return -ENOMEM;

+	dev->delay_drop.dbg = dbg;
+
 	dbg->dir_debugfs =
 		debugfs_create_dir("delay_drop",
 				   dev->mdev->priv.dbg_root);
@@ -3865,8 +3867,6 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
 	if (!dbg->timeout_debugfs)
 		goto out_debugfs;

-	dev->delay_drop.dbg = dbg;
-
 	return 0;

 out_debugfs:

> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm/XlYACgkQ5GN7iDZy
WKeGpBAAuz1MKnzYoD6JtnqqLZ+IOtI+IFJVQ173eEXl5cRN0KEb6FxB91mMHvAG
gK5ThWwL0exhNlaz73398kXNycDVHMDKuseH60hlul/0g5kdhaGCL85l9GWEsieK
cZgrS5XHvfKsN5xzk3Ea/ZSAmnZWkUNLTqDioVmfBMjwq9QwTD0iTQZZMJkkzRuo
ykL/GERlrM7ercX6XPpvdqWg1bjFMvT2iCQpST9eZOSppgyR7LGdZDBDKC47TZ3B
qV+ea9/72LNtlIMwhz9ILfCvd45NyjwPqWa8TI7kDzW+y/JzkBv0l+h4Ysct8DT8
6sDGQoMn8FIxYH5TpsPsKMIYaI3ulnKkI6y8PnZ77R2lg50Jd2kypNy06I4mCrKZ
OOklQzOj7hpf57lnnYVRiQbnGnQtwsgI2e5iBg5G/1EflLn6QyDkYdo8e6TvP23P
wtiNTeLMqLm1wEp106VfIk1WmmPLagDixXVuQCD0yeI0eBke/FRhpGZfAR5qzEse
haWl+f89+3tv3b7c/v1/d6aji9QHe7v/tD5S4Sx3Sht4WEC7HQX0pmcxaqwyCxU0
ITOWxBqcojKtP7YmLAB0vK1UQ5s+u/2caOK/UIBOWTqutUtle9dGJyutrK4obNgq
sVYcJWuAqslKB+sUGKnF1+MMv8joLEcrcUzMS4wKrPQMmAWmeQg=
=eAcD
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
