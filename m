From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Tue, 26 Sep 2017 11:38:43 +0300
Message-ID: <20170926083843.GB6816@mtr-leonro.local>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 12:20:01PM +0530, Arvind Yadav wrote:
> pr_err() and mlx5_ib_dbg( messages should terminated with a new-line to
> avoid other messages being concatenated.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Did you see it is happening?
It is not needed after 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")

Thanks.

>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index 0e2789d..92d643a 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1229,13 +1229,13 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  		mr = alloc_mr_from_cache(pd, umem, virt_addr, length, ncont,
>  					 page_shift, order, access_flags);
>  		if (PTR_ERR(mr) == -EAGAIN) {
> -			mlx5_ib_dbg(dev, "cache empty for order %d", order);
> +			mlx5_ib_dbg(dev, "cache empty for order %d\n", order);
>  			mr = NULL;
>  		}
>  	} else if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset)) {
>  		if (access_flags & IB_ACCESS_ON_DEMAND) {
>  			err = -EINVAL;
> -			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB");
> +			pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB\n");
>  			goto error;
>  		}
>  		use_umr = false;
> --
> 1.9.1
>

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKEhIACgkQ5GN7iDZy
WKfN9w//Z2I3YrmqWGw/HrmiaEWZ2xRY4SSLf1LpX6IJlFNd/1+10LDmZwnTKxnU
Su4h9ssmiO4RZ7g9Y1IxQrcOzAbj7xXGJgDI7qaS9otYsJCIZXB1lggUVIYf1uAe
NBp2x8kX8T+/fN0VjZsPBA4vbWwSspkOdwkNCsni05fYZgLILKbW7SvzATX3IjEN
XcZYatDEMGMSDgdZYuzHOqky7gE92oS3x6WiFvL1gyKqq8JkuFYc66s+LGkU5JNe
KdRsL6k3V8gC3xKtffOx0RbGK2WGHVYBt7o/SEcTwayp0IN4Psult1P8cxNZyUdV
n29JmDBYANn1ENo1Gjrfr3jVw4AqLW/Bdu+1XketgJVVU8HZj5MEzTrRhEvOBRSD
H8c6jztOkdJYwBwK3hag+vG5/VViD9NQ0O3kX1UQKnsuziCCJLlyXBbOc4r1m79v
xSeDu9ER6+c7pyJOq5RsG1lZAvkrx9pPX4/A9VWr8cffhhigq1u8Vv+86OEIoNsl
nLTk0n9k5UlW4sPdYW5ZsClMWDORAxpLYaCCPfdKuPeg7iHiUbW6oPEH8n+WHp6V
yb7mOwsbklZjpGA8MpNjHTqObLDdgjbmfGSY9ye2t1GovtU0CY8xk2EEWv0mqb0b
BNMEICN9y+a72FkBkPkwr+f22Wx1mQdt1nvuP4nYwHtWa6GmmBY=
=9aF0
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
