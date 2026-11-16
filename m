Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835330;
	b=nbU6CjHw0S59HhURWGNzDsCaIGtf1ZuSr/83+5ciKoqRkY7TV5vMEUv+zH6SXaldQUwd
	 cNXpSDS+TWVPqo5bJlSUSPQ6IeH7jnP4PPZAQufN5/RjjDlfAul9rd16UeI65e/y4pygx
	 2DL10yIGXFj/heaiogp9G0lgzSKILkgp8xVFQshCW8O0BlbomkCciHwV/1wj7MBneR+ii
	 Wui/OS51mflydA05f99PyV3S7PIYms1maf+RwXZA7sYGCQI7mD+m0W8q5SOfKxzcXANpZ
	 RAFTNXo/guCLYElapSRKxI8Y0/mig5m7u4q117kOmkKVAHWYzN+s4nDAtd8aN7rfCAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835330;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=knm4G4gK01CY59iwSKeed9szB97/Ep0vOE3ggzYBduc=;
	b=TbAiBMF5GZlAH6rXJt4o2oqPSgHdQga7OwM1/woc1CxYBBpsmTU3SXaYUuB3XthiRlDq
	 xEYKycdePhP6WGgHvWLgMjygiUQxBtNxy3Q8nLIqekIiekJuin01NPNauJikoyAP5o75f
	 sBeW0Az4Bp3sQrQi9KPa+OuqLE5HKENNUqE9H7ASflEMZIC/raQfjddWiyongnT4kcUkz
	 bon8LupbsRSX5LNiFCR1BkQzM70Wb1KdnfxhG9sKZV/3H3K+bfCXAMVD7uA3R33D8H/+H
	 zdPTRNEQxZrZ8JhSnoJEjFloknmEQbER7aoYpHNfXAI51mt9Lg0PthNKRhkxHtg9Jsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeBTCDuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AAB606A329;
	Mon, 16 Nov 2026 13:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeBTCDuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AED1F000C4;
	Mon, 16 Nov 2026 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835330;
	bh=knm4G4gK01CY59iwSKeed9szB97/Ep0vOE3ggzYBduc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JeBTCDuctffnLKDP3Vu9toIePLQpnOu889BO/bAZtGRRCOFuhaNipuoKNs8Mxxbhd
	 reRKnkO7ANWMPvsfKB6txBxr1BMTbYQBwypnPHvNgp6m2TzWj/g1I4OIT9r4ebSgEP
	 4zwS7zXPCLH12GXNlR5E8kf8cLl3e0L8pMwOYa1Pa/muA41+//c4sPGV5W8ecBfq7U
	 ILSeMcXff6FKbEno/G3rLVmJ4BKzA5Mnlj2vbkbtQl9rMkJksw2d8Q+kqLYPLtwf1q
	 3tRL4BciO4X05X+bHA0SYTjSec4LpftGVtiWp4xBA+2b5WLspqV0GhhfoT61rDpmXC
	 xqNpowK4L4bLg==
Date: Mon, 16 Nov 2026 15:22:05 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: jgg@ziepe.ca, maorg@nvidia.com, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Check the DM type before mapping a MEMIC
 operation
Message-ID: <20261116132205.GM11319@unreal>
References: <20261115104342.56112-1-dennylin0707@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115104342.56112-1-dennylin0707@gmail.com>

On Sun, Nov 15, 2026 at 10:43:42AM +0000, Hungyu Lin wrote:
> MLX5_IB_METHOD_DM_MAP_OP_ADDR accepts a handle to any DM object and
> converts it with to_memic() without checking the DM type. The handle can
> refer to a SW ICM object, which is a struct mlx5_ib_dm_icm and is
> smaller than struct mlx5_ib_dm_memic.
> 
> The handler then uses the ops_xa_lock, ops and ref members, which are
> all located past the end of the mlx5_ib_dm_icm allocation, so it locks
> and modifies memory that belongs to other slab objects.
> 
> Return -EOPNOTSUPP for DM objects that are not MEMIC, as
> MLX5_IB_METHOD_DM_QUERY already does.
> 
> Fixes: cea85fa5dbc2 ("RDMA/mlx5: Add support in MEMIC operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/dm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
> index 7a6fe4fea3e2..16e42fd6c802 100644
> --- a/drivers/infiniband/hw/mlx5/dm.c
> +++ b/drivers/infiniband/hw/mlx5/dm.c
> @@ -213,6 +213,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
>  	int err;
>  	u8 op;
>  
> +	if (dm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
> +		return -EOPNOTSUPP;
> +
>  	err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);
>  	if (err)
>  		return err;

I applied this patch with the following change:

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 6a1971b9627b1..7d1e642a8d4c9 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -208,12 +208,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
                attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
        struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
        struct ib_dm *ibdm = uobj->object;
+       struct mlx5_ib_dm *mdm = to_mdm(ibdm);
        struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
        struct mlx5_ib_dm_op_entry *op_entry;
        int err;
        u8 op;

-       if (dm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
+       if (mdm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
                return -EOPNOTSUPP;

        err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);

Thanks

> -- 
> 2.43.0
