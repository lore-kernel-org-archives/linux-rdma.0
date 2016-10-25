From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 8/8] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Tue, 25 Oct 2016 15:26:09 +0300
Message-ID: <20161025122609.GQ25013@leon.nu>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jo46wx5DSA4a/gWG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--jo46wx5DSA4a/gWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 05:31:59PM +0530, Binoy Jayan wrote:
> Clean up common code (to post a list of work requests to the send queue of
> the specified QP) at various places and add a helper function
> 'mlx5_ib_post_send_wait' to implement the same. The counting semaphore
> 'umr_common:sem' is also moved into the helper. This may later be modified
> to replace the semaphore with an alternative.
>
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 96 +++++++++++++----------------------------
>  1 file changed, 29 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index d4ad672..261984b 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -856,16 +856,38 @@ static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
>  	init_completion(&context->done);
>  }
>
> +static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> +					 struct mlx5_ib_umr_context *umr_context,
> +					 struct mlx5_umr_wr *umrwr)
> +{
> +	struct umr_common *umrc = &dev->umrc;
> +	struct ib_send_wr __maybe_unused *bad;
> +	int err;
> +
> +	down(&umrc->sem);
> +	err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
> +	if (err) {
> +		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
> +	} else {
> +		wait_for_completion(&umr_context->done);
> +		if (umr_context->status != IB_WC_SUCCESS) {
> +			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
> +				     umr_context->status);
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
>  	struct mlx5_ib_umr_context umr_context;
>  	struct mlx5_umr_wr umrwr = {};
> -	struct ib_send_wr *bad;
>  	struct mlx5_ib_mr *mr;
>  	struct ib_sge sg;
>  	int size;
> @@ -900,18 +922,9 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
>  	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmkey.key,
>  			 page_shift, virt_addr, len, access_flags);
>
> -	down(&umrc->sem);
> -	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
> -	if (err) {
> -		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
> +	err = mlx5_ib_post_send_wait(dev, &umr_context, &umrwr);
> +	if (err != -EFAULT)
>  		goto unmap_dma;

In case of success (err == 0), you will call to unmap_dma instead of
normal flow.

NAK,
Leon Romanovsky <leonro@mellanox.com>



> -	} else {
> -		wait_for_completion(&umr_context.done);
> -		if (umr_context.status != IB_WC_SUCCESS) {
> -			mlx5_ib_warn(dev, "reg umr failed\n");
> -			err = -EFAULT;
> -		}
> -	}
>
>  	mr->mmkey.iova = virt_addr;
>  	mr->mmkey.size = len;
> @@ -920,7 +933,6 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
>  	mr->live = 1;
>
>  unmap_dma:
> -	up(&umrc->sem);
>  	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
>
>  	kfree(mr_pas);
> @@ -940,13 +952,11 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
>  {
>  	struct mlx5_ib_dev *dev = mr->dev;
>  	struct device *ddev = dev->ib_dev.dma_device;
> -	struct umr_common *umrc = &dev->umrc;
>  	struct mlx5_ib_umr_context umr_context;
>  	struct ib_umem *umem = mr->umem;
>  	int size;
>  	__be64 *pas;
>  	dma_addr_t dma;
> -	struct ib_send_wr *bad;
>  	struct mlx5_umr_wr wr;
>  	struct ib_sge sg;
>  	int err = 0;
> @@ -1031,19 +1041,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
>  		wr.mkey = mr->mmkey.key;
>  		wr.target.offset = start_page_index;
>
> -		down(&umrc->sem);
> -		err = ib_post_send(umrc->qp, &wr.wr, &bad);
> -		if (err) {
> -			mlx5_ib_err(dev, "UMR post send failed, err %d\n", err);
> -		} else {
> -			wait_for_completion(&umr_context.done);
> -			if (umr_context.status != IB_WC_SUCCESS) {
> -				mlx5_ib_err(dev, "UMR completion failed, code %d\n",
> -					    umr_context.status);
> -				err = -EFAULT;
> -			}
> -		}
> -		up(&umrc->sem);
> +		err = mlx5_ib_post_send_wait(dev, &umr_context, &wr);
>  	}
>  	dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
>
> @@ -1210,11 +1208,8 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
>  static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
>  {
>  	struct mlx5_core_dev *mdev = dev->mdev;
> -	struct umr_common *umrc = &dev->umrc;
>  	struct mlx5_ib_umr_context umr_context;
>  	struct mlx5_umr_wr umrwr = {};
> -	struct ib_send_wr *bad;
> -	int err;
>
>  	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
>  		return 0;
> @@ -1224,25 +1219,7 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
>  	umrwr.wr.wr_cqe = &umr_context.cqe;
>  	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
>
> -	down(&umrc->sem);
> -	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
> -	if (err) {
> -		up(&umrc->sem);
> -		mlx5_ib_dbg(dev, "err %d\n", err);
> -		goto error;
> -	} else {
> -		wait_for_completion(&umr_context.done);
> -		up(&umrc->sem);
> -	}
> -	if (umr_context.status != IB_WC_SUCCESS) {
> -		mlx5_ib_warn(dev, "unreg umr failed\n");
> -		err = -EFAULT;
> -		goto error;
> -	}
> -	return 0;
> -
> -error:
> -	return err;
> +	return mlx5_ib_post_send_wait(dev, &umr_context, &umrwr);
>  }
>
>  static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
> @@ -1252,10 +1229,8 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
>  	struct mlx5_ib_dev *dev = to_mdev(pd->device);
>  	struct device *ddev = dev->ib_dev.dma_device;
>  	struct mlx5_ib_umr_context umr_context;
> -	struct ib_send_wr *bad;
>  	struct mlx5_umr_wr umrwr = {};
>  	struct ib_sge sg;
> -	struct umr_common *umrc = &dev->umrc;
>  	dma_addr_t dma = 0;
>  	__be64 *mr_pas = NULL;
>  	int size;
> @@ -1291,21 +1266,8 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
>  	}
>
>  	/* post send request to UMR QP */
> -	down(&umrc->sem);
> -	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
> -
> -	if (err) {
> -		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
> -	} else {
> -		wait_for_completion(&umr_context.done);
> -		if (umr_context.status != IB_WC_SUCCESS) {
> -			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
> -				     umr_context.status);
> -			err = -EFAULT;
> -		}
> -	}
> +	err = mlx5_ib_post_send_wait(dev, &umr_context, &umrwr);
>
> -	up(&umrc->sem);
>  	if (flags & IB_MR_REREG_TRANS) {
>  		dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
>  		kfree(mr_pas);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jo46wx5DSA4a/gWG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYD09hAAoJEORje4g2clinfUsP+wV4+jX8Lo6fkLi+zo+qTVp8
G+a1QzrufnAboZw/YR6uAqNEZqZz/hs04ZVcO1liNWhlQAXNEKdbH/497kYmuSof
F7nLeDYs+qfDI7o0mCh4jYuxbHbazJFxZzcBqUvMl4YTmODgK2AHNOxQuEnAKrHl
VkA7GmD51Kpd1TUB3vtTHdSdV7BG8CSXwG/kQOQ4q5yJ8e55mtVG0KA5AF1bYg8J
5H8jKtxFKaWovV2VhFg+pKhlakk6r7LUbtvh6JIXZGN0l3iI/NqPC1sDYQTHE3TQ
QyluiwGHgrsEjcEf3CkxePj9rtURfPedXxA4PBtzChVZZan1XCwrRAxintIi+qZ/
0WjX4bL5LpbMerit1FIEE1vVBqGugOWGBazttXKqsVKrTqVayeYRQrsMPPUAsJ4U
AZ4PIvvd8LMCDx4bvU5vHUXbyrEm5XXqlb7mUyGClXdqFkvNkoDm2YxAjbUC+7fi
u/F/S6SSZwl252O8/wA6rjwNuMo5LK06tCUJQobZNbqbxyPS2yMcUrmE871WA16P
VNIvMug0DoXf9B7YuuDFIfMVl/hkmVGg4/6fSA6df7YkEhg+WKXxAS072wXX6S5z
0W1vwWw2ZLWeG1x18Hgd0SeXn70XDRVvJewDVFm6K6Gp/7K9Tq4ufWNhXSmBnhuk
yy2VfXB7C9h+kSZq2m5T
=M+dg
-----END PGP SIGNATURE-----

--jo46wx5DSA4a/gWG--
