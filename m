From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Only put mmap_info ref if it exists
Date: Wed, 2 Nov 2016 17:40:54 +0200
Message-ID: <20161102154054.GG3617@leon.nu>
References: <1478033052-147252-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BNd1cQq+8a6XQVk/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478033052-147252-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BNd1cQq+8a6XQVk/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 01:44:12PM -0700, Jim Foraker wrote:
> rvt_create_qp() creates qp->ip only when a qp creation request comes from
> userspace (udata is not NULL).  If we exceed the number of available
> queue pairs however, the error path always attempts to put a kref to this
> structure.  If the requestor is inside the kernel, this leads to a crash.

It will be great to have a crash report if you have one.

>
> We fix this by checking that qp->ip is not NULL before caling kref_put().
>

Please add Fixes line which refers to the commit you are fixing.
It will ensure automatic pickup to various stable trees.

Thanks

> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index 6500c3b..0004e8b 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -884,7 +884,8 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
>  	return ret;
>
>  bail_ip:
> -	kref_put(&qp->ip->ref, rvt_release_mmap_info);
> +	if (qp->ip)
> +		kref_put(&qp->ip->ref, rvt_release_mmap_info);
>
>  bail_qpn:
>  	free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BNd1cQq+8a6XQVk/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGgkGAAoJEORje4g2clinJ0UQAMNU+gDIBlZF+FduCUaLdzp2
mwB2wVguoxiXup0EWelU5drPVXqM9DIuQXafLXqqUTWaY71x/YpSimFourg8EE0O
D3vjDPKvfPwmHkJzrPcnMk+p54XyP1fKYB7yStjYmnZaBqJa2NgP4JrFOS1zbmhZ
SWnU1BnZJBENso8wAWaYWoJs/UjCS0Zml0YMQYLDoDcJVjCx0FfZE0kR1LQrPIJG
15K3mMGTC2crzKiuhdfvcq78Rycn4303BiDdqMv5ZC8gyBbAaD9ne0xTgvysXIWT
7qqB1mAjuSL1uArvuldxx/4uQihwpsIKpXhHAhnD6TySQsYvP1LuWTctZ6tdeXTL
hZ0iuZN8SwbyGymL+MrKV1eodhuJ+2IBivdYo82rmUZxRO1kDrgA/x0rnW8bVThZ
ab4e+Q/+uOGsiWx8fDld+EFZRXPFaWbLnCy/DVyYGc8OY4kECir6dlOdh1P2YTq2
asc05ZLVInekcqpcd9qnuXuPQ8svlZXH1LBj1HbJ1TvpSajN9vBb8pYJWRip4q9U
JQuc4CqkK2bRY+7t3rMtfLDrO+O3AMPs6vyHgdj22vyp5bW9xFGSm1J4s37eVL0o
gPDozN7bYlzJ/sm6plFAK5R7O7mRDPamAMHFMT4XHAFYAQ9xJFTft3/40GJEvbrw
zErExXr+BevVyytLJqM4
=LUF2
-----END PGP SIGNATURE-----

--BNd1cQq+8a6XQVk/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
