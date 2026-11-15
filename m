Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794750689;
	b=M4GrgkOcKmTzSAognyRneIc0SvwLqRoB9GDTo9kgjOKolWfc5n4lVtyn8/8qwmrISoUR
	 m01ykCl+x4WLZx0hH/fW02ApR/SD4gAx9Icw/H/t7RVcXAQ+chrv7fn2Mf4Ib0whlUhi2
	 16ayWkHzSTYbzA3OxytZCM8DmMXZuNE++CmuPN9T5aDm4s/1T+QlGOdPmouH+3X9c/QPI
	 2tcwJM01aW1jjrJjHAzroV8RmS/2vYtUw7aKKOsVMfoQ7h1LlR3R6EcdAeyS3i0ds8arR
	 rMtXEZLHFmy7xkGsNK8Z5w9G3lcKAToRpjVRXJVbz8SxcQe2OMPhT8Dok30HvwS3ltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794750689;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2f/XyUW0oOhGaKE1DlyYgsVR8D2NP5OeQR1z9DlMLFk=;
	b=yPga3QAq35GjCpEKW82HpAB+fT8LUQAc1DiKfW0H8BdsidMqQftUfSCE1cPcOPBj1OAh
	 T/FOqwghwGvpGzumMm8KmwyuPfXAzqV85O6O0j/EF0z9V37YNb9UhS2TJih8zon7qSqEF
	 7dJVylh7fFKK4HHM+1P6wcXQG3XqRs6VpBOQY1CNnSoTJir8bDjDhboQXPw0SGrpEanau
	 i86n0yVHHf6TGmt6hThcRjWFpICdnCG5XjJiaEI+sHSEbTg+qvCQ9w/TwG/5Ma9FRudrt
	 YopORH0l1d2qvGnBXGZyiWllbep025zkQiXIYZCLXUlnXCA5wy7m6RfKmfhLT7NCo3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lD3XwZC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B26606A31A;
	Sun, 15 Nov 2026 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lD3XwZC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E671F000C4;
	Sun, 15 Nov 2026 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794750688;
	bh=2f/XyUW0oOhGaKE1DlyYgsVR8D2NP5OeQR1z9DlMLFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lD3XwZC1dIsekgv2Ix3LkYPoKVHdbTFRizPAb/500M+htFfXbkvahH+8MvKfNkKfM
	 oFGR1VVxXzuXCQ5B7CNJs36qSwDQIqtSBg5qgIgT3ZkWeFGjdU61nhDm3y7lokgonU
	 SIQk0h+zzH51ewwrEP/S9d2id2WNW68iO+REkwV/vaA10fGFAZccuYnhpDBqz8FHqR
	 gg3FS7JVbqdl8POUypsOpJ5LIv6euGkMldGwzfUCt+ca81PAwIMEkoL+6iNV6SeLRJ
	 yrZxpDi3M0+5t4JUON6dZbev4PlchTB4bf7ldpHiX/Ru50MS9Cfo+ZN9Tb5NYER3x9
	 WodcIGccUo6vA==
Date: Sun, 15 Nov 2026 15:51:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Artemy Kovalyov <artemyko@mellanox.com>,
	Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix UAF after DEVX DCT create failure
Message-ID: <20261115135123.GD42525@unreal>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
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
In-Reply-To: <20261111105346.3220427-1-lee@jaeyeong.cc>

On Wed, Nov 11, 2026 at 10:53:54AM +0000, Jaeyeong Lee wrote:
> The DEVX object create handler destroys and frees a hardware object itself
> when copying the command output or setting up an indirect mkey fails.
> 
> For DCT objects, mlx5_core_destroy_dct() can fail while leaving the DCT in
> qp_table.dct_xa. The error is ignored and the enclosing devx_obj is freed.
> A later DCT_DRAINED event then loads the stale xarray entry and calls
> complete() on freed memory.
> 
> Mark the uobject as holding a valid hardware object immediately after the
> DEVX object is initialized. Let the uverbs abort path invoke
> devx_obj_cleanup() for subsequent failures. If hardware destruction fails,
> rdma_alloc_abort_uobject() commits the uobject instead of freeing it. This
> keeps the object alive for cleanup at file close.
> 
> A KASAN QEMU reproducer that forces DRAIN_DCT to fail and delivers a
> DCT_DRAINED event reports:
> 
>   BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave
>   complete
>   rsc_event_notifier

Please resubmit the patch with the full dmesg output and a clear explanation of
what it fixes.

Thanks

> 
> The issue was found with a static analysis tool. OpenAI Codex assisted with
> reproducer validation and patch preparation.
> 
> Fixes: c5ae1954c47d3 ("IB/mlx5: Use mlx5 core to create/destroy a DEVX DCT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index fc6f793dcc658..037c2b6ff9714 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -1535,7 +1535,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
>  	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
>  		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
>  	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
> -	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
>  	struct devx_obj *obj;
>  	u16 obj_type = 0;
>  	int err, err2 = 0;
> @@ -1613,10 +1612,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
>  	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
>  				   &obj_id);
>  	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
> +	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_HANDLE);
>  
>  	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd_out, cmd_out_len);
>  	if (err)
> -		goto obj_destroy;
> +		return err;
>  
>  	if (opcode == MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
>  		obj_type = MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
> @@ -1625,18 +1625,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
>  	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
>  		err = devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
>  		if (err)
> -			goto obj_destroy;
> +			return err;
>  	}
>  	return 0;
>  
> -obj_destroy:
> -	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
> -		mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
> -	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
> -		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
> -	else
> -		mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox, obj->dinlen, out,
> -			      sizeof(out));
>  obj_free:
>  	kfree(obj);
>  	return err2 ?: err;
> 
