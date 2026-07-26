Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57D33B6E8;
	Sun, 26 Jul 2026 07:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785051472; cv=none; b=LkBaet5C2ALxjZsagazqNCkaIxgl2IDecE4afdYuIpSVVNc1wh9T5uagE3QHi4ho3xJ8Npwl0JYTw0qPtiKBKZGYjKcHAma2e54xAzYWEcE31oj6ZAcG3pOXuYetkWqrkfwTcN8putGnU71BEEpeo4f7EfcuNuw6ydTyA+ueXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785051472; c=relaxed/simple;
	bh=u/MI6ExjoFulnNa+MvxGW+buu2n+cYRskqPPVOuMQlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3DW+TsgNCV/AjoXdRYXigHv7x18F5lbgbqBiws1VsdkpEmysd5RtRajG05H8eHRP2PxZ3BVh4BYjdBsG0ctadKKPYClzTTl99TJ5SMfl4BAqKIBZBQlY21CCqqU80YrqNwbSABuOT2V2vxLAo3F9bZt4ZgI/TlUNirbxJyU6tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckpsiUyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckpsiUyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772FA1F000E9;
	Sun, 26 Jul 2026 07:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785051471;
	bh=OK6VKKnUmiyjxog4KGKRSwGzbiHvPknlYFynfS5CTEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ckpsiUyqEPc/2kBa899JLgLKk2FY2eBihd87YxdJqWeV42bSDr3k3sAEo9ARxShSq
	 q3iFBWI/l1H4JcWpRbwEVZGnVZxAJkOkm48Jitjec90WTfBh5zEg6hHX/BkRafNWlY
	 BFEnJqCL0megvx8xGueHXKUM3ZO/qD3Z3c3n1YJeEwIBCEOoZEiyCOXVvWq3fKxBcQ
	 /gYusxb754Ny+00nd5Iy/EjRjVz9iyRJ0P2NPgjD459C5KwovxOW6lAEPnnDxI/vuK
	 dg9fiakXgvLt8gYY0WTV16H4tGIVoSv9lNpXpg6OGgSbc1JdrjuarC1K8RGpe1OW34
	 /io9BK24Eqv1Q==
Date: Sun, 26 Jul 2026 10:37:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Edward Srouji <edwards@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Deprecate latency-sensitive QPs
 feature
Message-ID: <20260726073746.GB12003@unreal>
References: <20260723-deprecate-lat-qps-v1-1-8bc8b8431520@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723-deprecate-lat-qps-v1-1-8bc8b8431520@nvidia.com>

On Thu, Jul 23, 2026 at 06:01:23PM +0300, Edward Srouji wrote:
> From: Michael Guralnik <michaelgur@nvidia.com>
> 
> New HW no longer implements a separate class for latency-sensitive QPs and
> advertises this by a new cap bit.
> REG_UMR is the only QP that used this feature, so gate its usage of the
> feature on this cap.
> 
> Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
> Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c |  6 +++++-
>  drivers/infiniband/hw/mlx5/qp.c   | 12 +++++++-----
>  include/linux/mlx5/mlx5_ifc.h     |  3 ++-
>  3 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index d65ebdef28234fe91ad4c24a5ded2d3af8bc646e..a0f5341f40ff1c0414939dba50301f0255825065 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -4950,6 +4950,9 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
>  	if (err)
>  		return err;
>  
> +	if (MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
> +		return 0;
> +
>  	err = mlx5_alloc_bfreg(dev->mdev, &dev->fp_bfreg, false, true);
>  	if (err)
>  		mlx5_free_bfreg(dev->mdev, &dev->bfreg);
> @@ -4959,7 +4962,8 @@ static int mlx5_ib_stage_bfrag_init(struct mlx5_ib_dev *dev)
>  
>  static void mlx5_ib_stage_bfrag_cleanup(struct mlx5_ib_dev *dev)
>  {
> -	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
> +	if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
> +		mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
>  	mlx5_free_bfreg(dev->mdev, &dev->bfreg);
>  }
>  
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 7ff02d89c31d5b4db4c94453efafc0fce212acea..9253402ed645c9985eed098d3b21bea638028218 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -1123,7 +1123,8 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
>  	void *qpc;
>  	int err;
>  
> -	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
> +	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR &&
> +	    !MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
>  		qp->bf.bfreg = &dev->fp_bfreg;
>  	else
>  		qp->bf.bfreg = &dev->bfreg;
> @@ -2509,11 +2510,12 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
>  	MLX5_SET(qpc, qpc, st, mlx5_st);
>  	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
>  
> -	if (attr->qp_type != MLX5_IB_QPT_REG_UMR)
> +	if (attr->qp_type == MLX5_IB_QPT_REG_UMR) {
> +		if (!MLX5_CAP_GEN(dev->mdev, qp_latency_sensitive_disable))
> +			MLX5_SET(qpc, qpc, latency_sensitive, 1);
> +	} else {
>  		MLX5_SET(qpc, qpc, pd, to_mpd(pd ? pd : devr->p0)->pdn);
> -	else
> -		MLX5_SET(qpc, qpc, latency_sensitive, 1);
> -
> +	}
>  
>  	if (qp->flags & IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
>  		MLX5_SET(qpc, qpc, block_lb_mc, 1);
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 695c86ee6d7a3f15945fe7af092f63d9121da47a..28582c4d94d4335283009595f6a278c4d17c7eaa 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -2005,7 +2005,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>  	u8         log_max_stride_sz_rq[0x5];
>  	u8         reserved_at_3a8[0x3];
>  	u8         log_min_stride_sz_rq[0x5];
> -	u8         reserved_at_3b0[0x3];
> +	u8         reserved_at_3b0[0x2];
> +	u8         qp_latency_sensitive_disable[0x1];

This change should be split into a separate commit.

Thanks

>  	u8         log_max_stride_sz_sq[0x5];
>  	u8         reserved_at_3b8[0x3];
>  	u8         log_min_stride_sz_sq[0x5];
> 
> ---
> base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
> change-id: 20260723-deprecate-lat-qps-ca1942227499
> 
> Best regards,
> -- 
> Edward Srouji <edwards@nvidia.com>
> 
