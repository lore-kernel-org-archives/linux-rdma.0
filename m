Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795332720;
	b=hyHicioXJNdJX9RtqkcLiOETa8FvDDyiS9KS0lbKREkt5vQ3moCCpAn58uvHscDItKeY
	 +RWMyn+fkxf3K1dPjKVO0tFjT7DQPI/ys7LlATRvgzadv8EiHztFs3GYtsnVoerhFchkI
	 DsiWxqPEe24PgbRWaNkPfTwmk4VvFqnpHCHZuvHkI11ZvdF3eqZ13aH1BXI771j1gKVO5
	 8whuVfStDqJNriAFQ584ysQ7wtNrbVBq74YYcUgvVM441sD1CdA7Cjp/LU35ozRE66xsS
	 yDEjCK1jRvwwpg8ExmMGA4PJvE8wP7OgSu/Y38iX+njuAivHKQOjUVYEmc6R/jvkCRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795332720;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=xgVBMAHpFXauZz1gV3iFhYHUEjmYQRD26/8ElLnj53I=;
	b=k+2pDs28jFJcvgKiVsjx0e/M4SPWhNk+qpCC6lO2ciq3H2TR3PtAcpv50A4b1u9AKHsp
	 7g4wM3wBR1E1/5Qilp7z/cFvnoiVWqdbCylihThLZaKT/c3VH6t5q6SmzVKmBK2s1sKF2
	 19pwpbOahIeu+7qUQ808OmuRgDxfDnfPBkoRICZq5mgs9nNnIVZeSfb70+pW+x+seYYjx
	 m/dJa6sJF3Mao7i4Qqs7K1QiXAg1ukBN46Lk6ykOQeTh7G8pzgEUxp5T15RlGTvW+vm2U
	 LSg/bmqx3Q4mgebUPFNv4pzsrNm/PMt+3hrBoWXyebVO+yL1gN8NNG2AjLfydxV74VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbkxsRwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF49606A320;
	Sun, 22 Nov 2026 07:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbkxsRwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C624D1F000C4;
	Sun, 22 Nov 2026 07:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795332720;
	bh=xgVBMAHpFXauZz1gV3iFhYHUEjmYQRD26/8ElLnj53I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IbkxsRwBBMEjo+WUxQrp7X1LmlXKug7cCt0VR69KiqdYMs9q5OovgeuiBrCYgxX1L
	 /dC+oNKqoN0UWtF+ucJfWf3e/bYLp8ZjkfpFGL7vvYYbwCSpAG7KAahDKOZhb4B5bq
	 5KtQx81wCrVRXASD2g9kiln9c7EJRQU6KFYdUJkbKeTP0/x2J7zTsZrlyT2MwUhtwv
	 C1oICmAYYdlDif629MhzTpShnOfMMjvbeYiAvVKTfpsrjqdcxTUh7sY5qVHi0T/krd
	 2VzBJ9AhyigvAgT8UdF0xda09leS1e7dBP6n4bRwAsQUm6JK7Scvxn0EfCbMlFhpqd
	 fbmgdGsooWl4Q==
Date: Sun, 22 Nov 2026 09:31:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261122073156.GA12665@unreal>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261117170914.27410-22-yishaih@nvidia.com>

On Tue, Nov 17, 2026 at 07:09:14PM +0200, Yishai Hadas wrote:
> Userspace must know when a device is in adversarial mode, and an
> unaware rdma-core must not get a context on such a device, as it
> doesn't harden itself against the NIC.

Why is this a “must”? If it is required, please describe in the commit
message the scenario that cannot be supported without this new UAPI flag.

> 
> Report the mode with IB_UVERBS_CORE_SUPPORT_ADVERSARIAL in the
> core_support of GET_CONTEXT and QUERY_CONTEXT. Add an optional
> UVERBS_ATTR_GET_CONTEXT_FLAGS input, where userspace declares
> UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED. In adversarial
> mode, GET_CONTEXT without that flag fails with -EPERM, and so does the
> legacy write() GET_CONTEXT, which has no way to pass it.

The above is AI generated useless information, completely useless.

Thanks

> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/core/uverbs_cmd.c             |  5 +++++
>  .../infiniband/core/uverbs_std_types_device.c    | 16 ++++++++++++++++
>  include/uapi/rdma/ib_user_ioctl_cmds.h           |  5 +++++
>  include/uapi/rdma/ib_user_ioctl_verbs.h          |  1 +
>  4 files changed, 27 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index aca7c6ab55cd..b78207a81091 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -292,6 +292,11 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
>  		goto err_ucontext;
>  	}
>  
> +	if (ib_dev->adversarial_mode) {
> +		ret = -EPERM;
> +		goto err_uobj;
> +	}
> +
>  	resp = (struct ib_uverbs_get_context_resp){
>  		.num_comp_vectors = attrs->ufile->device->num_comp_vectors,
>  		.async_fd = uobj->id,
> diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
> index db65032e80b4..72c67f09533e 100644
> --- a/drivers/infiniband/core/uverbs_std_types_device.c
> +++ b/drivers/infiniband/core/uverbs_std_types_device.c
> @@ -248,6 +248,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>  	u32 num_comp = attrs->ufile->device->num_comp_vectors;
>  	u64 core_support = IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS;
>  	struct ib_device *ib_dev;
> +	u32 ctx_flags;
>  	int ret;
>  
>  	ib_dev = srcu_dereference(attrs->ufile->device->ib_dev,
> @@ -255,6 +256,15 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>  	if (!ib_dev)
>  		return -EIO;
>  
> +	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
> +				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
> +	if (ret)
> +		return ret;
> +
> +	if (ib_dev->adversarial_mode &&
> +	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
> +		return -EPERM;
> +
>  	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
>  			     &num_comp, sizeof(num_comp));
>  	if (IS_UVERBS_COPY_ERR(ret))
> @@ -262,6 +272,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
>  
>  	if (ib_dev->ops.uverbs_robust_udata)
>  		core_support |= IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA;
> +	if (ib_dev->adversarial_mode)
> +		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
>  	ret = uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
>  			     &core_support, sizeof(core_support));
>  	if (IS_UVERBS_COPY_ERR(ret))
> @@ -303,6 +315,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QUERY_CONTEXT)(
>  	if (IS_UVERBS_COPY_ERR(ret))
>  		return ret;
>  
> +	if (ib_dev->adversarial_mode)
> +		core_support |= IB_UVERBS_CORE_SUPPORT_ADVERSARIAL;
>  	ret = uverbs_copy_to(attrs, UVERBS_ATTR_QUERY_CONTEXT_CORE_SUPPORT,
>  			     &core_support, sizeof(core_support));
>  	if (IS_UVERBS_COPY_ERR(ret))
> @@ -519,6 +533,8 @@ DECLARE_UVERBS_NAMED_METHOD(
>  			   UVERBS_ATTR_MIN_SIZE(sizeof(int)),
>  			   UA_OPTIONAL,
>  			   UA_ALLOC_AND_COPY),
> +	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
> +			     UA_OPTIONAL),
>  	UVERBS_ATTR_UHW());
>  
>  DECLARE_UVERBS_NAMED_METHOD(
> diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
> index 816b3107464f..3e482a4338f9 100644
> --- a/include/uapi/rdma/ib_user_ioctl_cmds.h
> +++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
> @@ -101,10 +101,15 @@ enum uverbs_attrs_query_comp_cntr_caps_attr_ids {
>  	UVERBS_ATTR_QUERY_COMP_CNTR_CAPS_SUPPORTED_QP_ATTACH_OPS,
>  };
>  
> +enum uverbs_attrs_get_context_flags {
> +	UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED = 1 << 0,
> +};
> +
>  enum uverbs_attrs_get_context_attr_ids {
>  	UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VECTORS,
>  	UVERBS_ATTR_GET_CONTEXT_CORE_SUPPORT,
>  	UVERBS_ATTR_GET_CONTEXT_FD_ARR,
> +	UVERBS_ATTR_GET_CONTEXT_FLAGS,
>  };
>  
>  enum uverbs_attrs_query_context_attr_ids {
> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
> index 21f86cc7bb1f..5861f34f8343 100644
> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
> @@ -47,6 +47,7 @@
>  enum ib_uverbs_core_support {
>  	IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS = 1 << 0,
>  	IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA = 1 << 1,
> +	IB_UVERBS_CORE_SUPPORT_ADVERSARIAL = 1 << 2,
>  };
>  
>  enum ib_uverbs_access_flags {
> -- 
> 2.18.1
> 
