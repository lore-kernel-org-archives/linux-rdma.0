Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010659;
	b=Ozy+NZnn7G0nBBFRIwBFNh4Accsw88HQXdizevgkgQXB7jrKi2vIhdxxLHkae/FzMOya
	 bS4pQ6eeQOzLkQnQgmODI7bgC0ekH1hQS+huGGqaXpJkgyeluPZKWGMf2PDN+g03xaREF
	 Pj31kqxkDi2509tWsCQU5pvGXjanvpHb26igzw8Slju2vWOYEABi8dRQTPUcgyqnWUadh
	 BfQbFq0f2pbSuo4BKDf6XVVGZT6rLe+CAAEf/vnqkNGrn9XZ8xUAdtuwEjLB1/akJT/9O
	 Acu/yagLz/aWsaY813E5u0VqPR6LYSR0o5Z+D71GzDqG/KAkcw+Hd3CAUrUaos9rncw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010659;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fim8nxfTb3qSZvg9mWR4HSyNJ4mWCnKXvqbcqVmGWNE=;
	b=JstQzPxKs1+poVsf52WqQMYk/lf+eE5P7vHu8RDmS6I24PQlyYladDTZRAA4UI7Qf7NR
	 LAgdxfp8XFI1GnztwfoO9zLAaIcJLVRx924/UQZJ3S2bskevU3IDV0DyuBk2tm7FfrYP6
	 25a/bTTw3SzXW4Nh8Z103hoK57xnsSorVedKdp6Ii4cv+4U6CXf93r4nvSDXXrDA9Vjlu
	 EHgWrp+q6rtwEBelwn8RcgtMzpLdDdbHeWJ2H7tLwuvXibZUyJzeoL4xkgfZepJehoGLu
	 MwmWWGqxrDAAAyo7kVyBTuM+MjQfIPRMbcA+8FT/oHZQrIysY+3YSKHxuLSSiKaBSEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkiADMls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F498606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AkiADMls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D161F000C4;
	Wed, 18 Nov 2026 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010659;
	bh=Fim8nxfTb3qSZvg9mWR4HSyNJ4mWCnKXvqbcqVmGWNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AkiADMlsMqKhUVR/ot3aqgotycQzzAHnLOdn9cHf9arYaVoKxzxBO4ceOvhQkdqX2
	 nYtVVJnxxNtjXGwz+6lLVanMj2EIlnnPC6E4i8B03Z3agK1dfp2QJ84D36eAPvWaVr
	 QmO7nVjB/AUq3q0DFDTBP4QKTP54g0AcLT0bf0kqDh7NCQ5avRoh5KpgcHoTaSivlV
	 OItGs+FyLjZ+uOqrrzNg/OAvbtH43C5mzxs5JgDHh4cheXamrQO2sMQzlhFj/yeJDs
	 NTtDkHkegcBdRt66YLENaQZCypLgKYhXJQtPNpL/iFvs1W0gv28M9Db83pFaCnpYZ6
	 ycDwB18bpvMAg==
Message-ID: <sashiko-outbox-221137@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 08/11] RDMA/mlx5: Resolve core device from
 ucontext for DEVX resources
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-8-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-8-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] RDMA/mlx5: type confusion in
  UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)() [1]
--

commit 9b620675534530ff6a87e491bd8226b49883a88b
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Resolve core device from ucontext for DEVX resources

This commit introduces a uctx_to_mdev() helper to resolve the mlx5_core_dev
from the user context for DEVX resources and removes redundant mdev
pointers from struct devx_umem and struct mlx5_ib_pp.

[ ... ]

> diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5=
/dm.c
> index fbb46d821865b..31a7c0f72b40f 100644
> --- a/drivers/infiniband/hw/mlx5/dm.c
> +++ b/drivers/infiniband/hw/mlx5/dm.c
> @@ -209,6 +209,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_AD=
DR)(
>  {
>  	struct ib_uobject *uobj =3D uverbs_attr_get_uobject(
>  		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
> +	struct mlx5_ib_ucontext *c =3D to_mucontext(uobj->context);
>  	struct mlx5_ib_dev *dev =3D to_dev(uobj->context->device);
>  	struct ib_dm *ibdm =3D uobj->object;
>  	struct mlx5_ib_dm_memic *dm =3D to_memic(ibdm);
> @@ -223,7 +224,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_AD=
DR)(
>  	if (op >=3D BITS_PER_TYPE(u32))
>  		return -EOPNOTSUPP;
> =20
> -	if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
> +	if (!(MLX5_CAP_DEV_MEM(uctx_to_mdev(c), memic_operations) & BIT(op)))
>  		return -EOPNOTSUPP;
> =20
>  	mutex_lock(&dm->ops_xa_lock);

[Severity: High]
This problem wasn't introduced by this patch, but can
UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)() cause type confusion when
called on a non-MEMIC DM handle [1]?

The handler casts ibdm to struct mlx5_ib_dm_memic via to_memic() without
verifying that to_mdm(ibdm)->type is MLX5_IB_UAPI_DM_TYPE_MEMIC.  When
userspace allocates a software ICM object such as
MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM, handle_alloc_dm_sw_icm() allocates
the smaller struct mlx5_ib_dm_icm instead, so accessing dm->ops_xa_lock,
dm->ops, and dm->ref writes past the end of the allocation and corrupts
adjacent slab memory.

[1] https://sashiko.dev/#/bug/linux-56314797-6963-404a-8cb9-efc7a99eb571

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D8
