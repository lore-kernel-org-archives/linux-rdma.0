From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: hw: mlx4: fix improper return value
Date: Sun, 4 Dec 2016 08:15:01 +0200
Message-ID: <20161204061501.GG4497@leon.nu>
References: <1480830544-5002-1-git-send-email-bianpan201603@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480830544-5002-1-git-send-email-bianpan201603-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pan Bian <bianpan201603-9Onoh4P/yGk@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 04, 2016 at 01:49:04PM +0800, Pan Bian wrote:
> From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
>
> If uhw->inlen is non-zero, the value of variable err is 0 if the copy
> succeeds. Then, if kzalloc() or kmalloc() returns a NULL pointer, it
> will return 0 to the callers. As a result, the callers cannot detect the
> errors. This patch fixes the bug, assigning "-ENOMEM" to err before
> the NULL pointer checks.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=189031
>
> Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index b597e82..f6c5158 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -455,6 +455,7 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
>  		sizeof(resp.response_length);
>  	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
>  	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
> +	err = -ENOMEM;
>  	if (!in_mad || !out_mad)
>  		goto out;

In such case, the err initialization at the beginning of
mlx4_ib_query_device function is not necessary. Can you please remove it?

Besides that, look good.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>
> --
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYQ7RlAAoJEORje4g2clinbysQAINtYJh5d5AQ5WuzLwlmIe8L
clfC1ff0WT9Rvh2Y9WRZdVeQMsaa7krVVG1IxOAVbrYPLksD4If3rR6rCrqjPiNo
L6YfStgpeer5xygAw8fTVrtqnK6N9Djmu9y2ky1FNuMjKVIvdWg6E/SeVgkmwpiZ
2pFmwsPFrtx8gaWDsUo5JuxzwtmfYzo7rI4a9QztimqK6JvxV4Bz6r+BswFGkx+8
zmLZbkZoXynDH1d+d/x2yMw5re7s3tmhNso7JCDpv/BquEW1tGnJcUct1MJ8ybGp
3+mqbqTr4dY2/Wmt8+Yesl6DKSYvxT9HBmG2ZMU3/WNsxgP9vLI7bk0o3z0CCk11
Sh54ZDHHHOaX+Cd2ezqJKMmTJA32oWceoMTf7BDa+v5elkoaQQCECyILvcZsUPpC
pvP4ij5Gly5txAFuwsYTBzcgErTsMyorar+ZQTes08i+mbMXc/SIIWQadu5030XP
MrLi6vdvQRsBRcLQgUnd+wrqSGx/fi7PqXaEhKr2ZLLsC9Rc176Lv1AEg1dqSBP7
8/9HPXG/rEK9gfdCqSRPL2rdJLvDGoYGJ7zjWk5wyDoNvtxWROQE5LU0Vu+geRK8
1Tv2X1DlKrU06fgXbjo8px/UG/ZVq5cfqptbKaQaFRu1OxbUiZ4TVnFBgM/XpQjv
WP/66UiP19xgWoRqR+Ax
=+k18
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
