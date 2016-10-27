From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 8/9] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Thu, 27 Oct 2016 09:09:58 +0300
Message-ID: <20161027060958.GB3617@leon.nu>
References: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org>
 <1477468874-16328-9-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477468874-16328-9-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 26, 2016 at 01:31:13PM +0530, Binoy Jayan wrote:
> Clean up the following common code (to post a list of work requests to the
> send queue of the specified QP) at various places and add a helper function
> 'mlx5_ib_post_send_wait' to implement the same.
>
>  - Initialize 'mlx5_ib_umr_context' on stack
>  - Assign "mlx5_umr_wr:wr:wr_cqe to umr_context.cqe
>  - Acquire the semaphore
>  - call ib_post_send with a single ib_send_wr
>  - wait_for_completion()
>  - Check for umr_context.status
>  - Release the semaphore
>
> As semaphores are going away in the future, moving all of these into the
> shared helper leaves only a single function using the semaphore, which
> can then be rewritten to use something else.
>
> Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 115 +++++++++++-----------------------------
>  1 file changed, 32 insertions(+), 83 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index d4ad672..19c292a 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -856,16 +856,40 @@ static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
>  	init_completion(&context->done);
>  }
>
> +static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> +					 struct mlx5_umr_wr *umrwr)
> +{
> +	struct umr_common *umrc = &dev->umrc;
> +	struct ib_send_wr *bad;
> +	int err;
> +	struct mlx5_ib_umr_context umr_context;
> +
> +	mlx5_ib_init_umr_context(&umr_context);
> +	umrwr->wr.wr_cqe = &umr_context.cqe;
> +
> +	down(&umrc->sem);
> +	err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
> +	if (err) {
> +		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
> +	} else {
> +		wait_for_completion(&umr_context.done);
> +		if (umr_context.status != IB_WC_SUCCESS) {
> +			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
> +				     umr_context.status);
> +			err = -EFAULT;
> +		}
> +	}
> +	up(&umrc->sem);
> +	return err;
> +}
> +
>  static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
>  				  u64 virt_addr, u64 len, int npages,
>  				  int page_shift, int order, int access_flags)
>  {
>  	struct mlx5_ib_dev *dev = to_mdev(pd->device);
>  	struct device *ddev = dev->ib_dev.dma_device;
> -	struct umr_common *umrc = &dev->umrc;
> -	struct mlx5_ib_umr_context umr_context;
>  	struct mlx5_umr_wr umrwr = {};
> -	struct ib_send_wr *bad;
>  	struct mlx5_ib_mr *mr;
>  	struct ib_sge sg;
>  	int size;
> @@ -894,24 +918,12 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
>  	if (err)
>  		goto free_mr;
>
> -	mlx5_ib_init_umr_context(&umr_context);
> -
> -	umrwr.wr.wr_cqe = &umr_context.cqe;
>  	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmkey.key,
>  			 page_shift, virt_addr, len, access_flags);
>
> -	down(&umrc->sem);
> -	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
> -	if (err) {
> -		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
> +	err = mlx5_ib_post_send_wait(dev, &umrwr);
> +	if (err != -EFAULT)
>  		goto unmap_dma;

NAK,
You are breaking driver.

it should be "if (err && err != -EFAULT)"

Thanks

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEZo1AAoJEORje4g2clinr5oP/RedS5YIVToVDEiuXHOt0JbE
IN8l4Lga09xxIafhCe4RrtEg/YAibxUiP/WtC4Q3YmCtbeeCX9Cwdk/98sDclyW4
/JWwQoIgJHi0STr9IOTbThKMI6PLUPtgyolqDNaRVmBEbP5LQ22oEzLdglw17t8t
RK2rABpqDCsmgeV7QKSiF3pj2BekjeYwmzlJ+hHJfZBLojb15FZCOU1A+mwZpp5q
rNjN5qtD/87bKvuGfNvJg+P+GPSs4pftHQymOPKNEDM2A8dpQsELO0rgR1W6WPYJ
0ci8BLuXo1+jCMtxi3g80Y840iUWICOPGmVkIbrROmrzL4pVUbzR8s9nNvfb0Uj5
Widg2jY+2G9YF+j8NYcIzMPzBYFMwxWVvXY7bqV4u3PSMn5CQpR/J2YbpV1kuLLs
iVUSbuDPbmtfs8cnTJV/2vggyHAqU/6oAiTce4bgf9hWkgxT7A3hW0XmQjDpPA6K
4G6XjVBO6YZG4DUy6SmQCYREuZ8PEgFk9MKRenxrcSin0p/rp3r9lyhIeRzPP9ga
3uUWdbwApthu5+gZdIinR3uYcyokuyFe0babOL1SDjjP3atzDEab6QkMU+AIs4X6
2LCmEI+HDq7yg6ncV3u8Dv1Or3Ae/Dby/lsaawoSSdB28nH8nEjPcscOA6tw64YY
gufhtGcyf2lSkbKTLR3K
=DaP/
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
