From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without
 plugged in SFP module
Date: Fri, 27 Oct 2017 22:35:06 +0300
Message-ID: <20171027193506.GH16127@mtr-leonro.local>
References: <20171027123011.10454-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3cI6DWK3Xt33P8nt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171027123011.10454-1-tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--3cI6DWK3Xt33P8nt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 27, 2017 at 02:30:11PM +0200, Thomas Bogendoerfer wrote:
> If there is no SFP module plugged into a port of mlx5 cards
> 'cat /sys/class/infniband/mlx5_X/ports/1/rate' returns Invalid argument.
> This causes tools like 'ibstat' to malfunction. This change adjusts mlx5
> to all other RoCE/iWarp drivers, which always return valid speed/width.

Like Parav, I have mixed feelings about such change. It returns EINVAL
if nothing is connected and it is right thing to do. It is hard to call
"valid speed/width" for unconnected port.

I would like to have ibstat and other drivers fixed instead of
converting mlx5 to be wrong.

Proposed change breaks existing scripts.

Thanks

>
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 260f8be1d0ed..4388618e3434 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -246,7 +246,10 @@ static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
>  		*active_speed = IB_SPEED_EDR;
>  		break;
>  	default:
> -		return -EINVAL;
> +		/* Unknown */
> +		*active_width = IB_WIDTH_1X;
> +		*active_speed = IB_SPEED_SDR;
> +		break;
>  	}
>
>  	return 0;
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3cI6DWK3Xt33P8nt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnzimoACgkQ5GN7iDZy
WKe1Ew/7BPkSZoCYS5+4ABB5Fweh7ZQRor1TY2LP4ZGk/wSFFlaOhgxTjzFzxS+9
TNfVaQBiC90VAVbdRCGgZJEePfqeFt63g0b/NaYX/kJ5pvHcB/bIgs7kRKTG+qZ9
vQT4DD6946x3Yp/mkZsXdU3H/mJRAs1y6jFp4hqrRZcWX5GJsYYhel8ElVqVK5MY
oLq2hoYuBMSStKexSIblB0KbBSjBHRMkCvqgmN1QjM0974T1ZP6VHLiZ9bQGNoAI
Ba/163HDh3KuaX9H8NLVp8rwvvXCpxENoclZrdCt1mhnJ0WZT9+r0/2wnlSx2sTn
emBny2TFOnv+4lyDwgm8fgJ55GqWOK73EJgiUVJmoQmzylVJhF0e1aIyJ0DZNzIF
vG5EfCRNKRUkkit4DTQ2coybGwez2uKxf5wW7jG9qjinbiIg6e87tcsKQiLC4eCB
LNPRumi9DyWiQXhtLv6JSw3MQjwEs8gSWe3nZg+CzzupZcSu/E0799F5I5qa83+N
ib8d7VgrSee04DcB//oM/iiyNWrAwMOB1tA6wBSZreObjCkn3tzSd6odse5e2Xq3
Ty/feEFvggozzxARig9Q3/eKUmtgfsRFl/rCVJwSCKLHqf3lP0kjrT1yCdleV5wV
FHXgrjR7+NBd4DK7j897BmezI0lqbFIsfMbxqP4ZTQsdInH3ex4=
=dApQ
-----END PGP SIGNATURE-----

--3cI6DWK3Xt33P8nt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
