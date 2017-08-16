From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: fall back to vmalloc for mlx5_ib_wq
Date: Wed, 16 Aug 2017 15:12:05 +0300
Message-ID: <20170816121205.GN24282@mtr-leonro.local>
References: <20170816110632.9779-1-dongyang.li@anu.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vHrcnSuaBi45WmF/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170816110632.9779-1-dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vHrcnSuaBi45WmF/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 09:06:32PM +1000, Li Dongyang wrote:
> We observed multiple times on our Lustre OSS servers that when
> the system memory is fragmented, kmalloc() in create_kernel_qp()
> could fail order 4/5 allocations while we still have many free pages.
>
> Fall back to vmalloc to allow the operation to contine, also switch
> to kmalloc_array() from kmalloc().
>
> Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c  | 54 +++++++++++++++++++++++++++++-----------
>  drivers/infiniband/hw/mlx5/srq.c |  8 ++++--
>  2 files changed, 45 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 0889ff367c86..e662fa5af5bb 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -959,11 +959,35 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
>  		goto err_free;
>  	}
>
> -	qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid), GFP_KERNEL);
> -	qp->sq.wr_data = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data), GFP_KERNEL);
> -	qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(*qp->rq.wrid), GFP_KERNEL);
> -	qp->sq.w_list = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.w_list), GFP_KERNEL);
> -	qp->sq.wqe_head = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wqe_head), GFP_KERNEL);
> +	qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt, sizeof(*qp->sq.wrid),
> +				    GFP_KERNEL | __GFP_NOWARN);
> +	if (!qp->sq.wrid)
> +		qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid),
> +					GFP_KERNEL, PAGE_KERNEL);

Please don't open code, the kvmalloc and kvmalloc_array functions.

Thanks for doing it.

--vHrcnSuaBi45WmF/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUNpUACgkQ5GN7iDZy
WKe5hQ//S/KcBtMeSk9N1XBh6t4WKUUAv25vupk/45CBk767a/yHteM765cI4Aim
smhpuRbtvTmd2orhf8HN5LIiB2TJHsxF/IgLMHaXccwvCZDoH3/UfkQHGvOPDiYm
a4iExI+nNZhDbU69RdNduNRCs0XjvE9TZztEgqBY9LGlzKGOXuvdttChnVqn7ecP
w6a6u0XnoYba8kf/zp8pNqL7uACsOGByM+xXyEffQ15Yk6ZGNbJBbc8XjFUTSBvB
DobgXYdg1t6d01Q6xS7/4SuPQk1a2bMsNuzEvcgxipICS8rH5uHgQe2/pQfuCVa+
zRLaBzos/HHcdtOfJHnekfq+/aWW1kOgWz/V+5iaBkZK8FroSf67jo1LvRUOGAl8
EtUzoe1xaA6pq6bi0LUPcmiSBAHld4l3PX7vQTI1q+RIU7Q1gVXCsZjkauBNzTAA
aBi+g2fIT/z7yiZPNDMYCg2zgNPNtl91SIs3cRd5S6VdwdVSF2Ml3/wwJYbU9Gzu
yfxczhbq6Y0FWExOGldupsTNwheiLqtWm+16EzOPxvtheRPkNjnHhs437ggpaeBm
MQZdA7rB9fOwMrxJY26XlkutHBt0v+MpP4Otd/aa2ms4j7Tc+S70SdrE4xL8IUNs
rq9i8RwDVx6dl9HjiFlv5GAo4S8AL/XR4LPF+CbkzajV3t4KHWI=
=xHgH
-----END PGP SIGNATURE-----

--vHrcnSuaBi45WmF/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
