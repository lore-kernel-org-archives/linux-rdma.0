Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752758;
	b=lSSjcOc7EFzjlE1O0nVxaBuZUPNx2Vw5VYCqJYDzl1uH4KSzAiRKbrnAnsBVlhkEtK29
	 6rE+i8GKukK2gYFIkw3g/8MNuLVp4yGxwfuxfNa/dJdJugjaxr+qG8gp3VsyCc/fztXZZ
	 NtprPSuOOnkAFexbhj/gBDBuRBWJC0v4xxGQpQLUIzb9gXoLpOt6Jfw93vBmZTDTr6JHj
	 HtCUm9SWs3R4fpvVW4mqmRcsWEguk7MabV557qnPhiyXtLXQqlpNmUNy/I2LaJXivSNDU
	 XOEEmyfESp/2Rxt1Ne5ZxXj4r1EuBZjfXRaZFSIWcNXloXQoDmeAq6UA8X68OeKzREA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752758;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=pEJooFGfISpLe3pbAp7u2DszuMvLOiZLqcHdt+Lue3o=;
	b=NbYZyYNusZayAMOS1BQ3cyVF1it/35PjaO2rWRrDwM2zlPclECTEXOAr8GbTg2+2U4lc
	 rw9hb/SdyAWL4MT2iAPAl+GSqgrlKXQndN3T8e2tbtDZuyBlXbgxwgQWFn7K7Smi6adN3
	 0uUFUl4zwCGrlo1vIqLiDhAszPSw48Wphu0DYV3dhs1GvKVzCAJm9mTnMsVG6k5//rPB8
	 5afyUI8Xv3C3iQHQOmz2UihN12tfBG100ZWDDMT09Zor3shgBErAneNWEsjEDs3lZTVym
	 cgFOtngGFZYQygbqQlGyhFI5ouIKEGTu1qimqHEBY1Mh9zYHrdW7muWo0arRkFtt9TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEJsW5wz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0651606A31B;
	Fri, 23 Oct 2026 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEJsW5wz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1091F01828;
	Fri, 23 Oct 2026 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792752757;
	bh=pEJooFGfISpLe3pbAp7u2DszuMvLOiZLqcHdt+Lue3o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XEJsW5wzXREGE1XDKsZwfAuDE5lTmyOAnhOEXS0SlI9W/C1gPPWcfBsKVetVHKwbp
	 7skX65XDxjW0wdUX3k1nfuJjG3nTKWKrc/3DGDBHuNjBiHkD/wACbv+yJJHI4q5qSH
	 rTnrMls4nQ0XTylH+RMDxAktMZbLPTp+n4+qzw6ia1EEqFiCO66zQuwEInn5Z4o1kK
	 Wnjw9m3nipJ0jeRbmrKnMMLS8yIIhs/tV8YBMqoSSt0e22nHKFHEf7YUhGW3w+eUiD
	 yIh0+nfr1xBFnGi88OIoyWzK9tZ1V0dzlxcBs9aIZGeo4TPHx6KTQ7q0X/1nEH2TL9
	 rwKUGiD/qfd7w==
Subject: Re: [PATCH net 2/3] net/mlx5: HWS, Fix heap buffer overflow in insert
 header action
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 acassen@corp.free.fr, valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 igozlan@nvidia.com, kees@kernel.org, kees+treewide@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, prathameshdeshpande7@gmail.com,
 saeedm@nvidia.com, william@theesfeld.net, kliteyn@nvidia.com
Date: Fri, 23 Oct 2026 10:52:35 +0000
Message-ID: <179275275576.3134.7528632839557500568@kernel.org>
In-Reply-To: <20261021074949.3471704-3-tariqt@nvidia.com>
References: <20261021074949.3471704-3-tariqt@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Concern: the commit message calls this a 'heap buffer overflow'
  and carries a Fixes: tag, but the overflow is not reachable today.

Pre-existing issues:
- [Medium] mlx5hws_action_create_insert_header()
  (drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c:1464)…

--

net/mlx5: HWS, Fix heap buffer overflow in insert header action

This commit changes mlx5hws_action_create_insert_header() to use
hws_action_create_generic_bulk() instead of hws_action_create_generic(),
so it allocates num_of_hdrs action structs instead of one. It also
returns NULL early when num_of_hdrs is zero.

> hws_action_create_generic() allocates only a single action struct,
> but the loop writes to action[i] for each of the num_of_hdrs entries.
> When num_of_hdrs > 1 this overflows the allocated buffer.

[Severity: Low]
This isn't a bug, but could the commit message say that the overflow
can't be hit today?

The only in-tree caller, mlx5_fs_insert_hdr_bulk_action_create() in
fs_hws_pools.c, always passes num_of_hdrs = 1:

	return mlx5hws_action_create_insert_header(ctx, 1, &insert_hdr,
						   log_bulk_size, flags);

The HWS symbols are not exported, so nothing else can reach the
num_of_hdrs > 1 case. The description above is accurate as written. A
note that the overflow can't currently be triggered would help when
reviewing the Fixes: tag for stable.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
> index 23e86f2920228..9caaa34074dbb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
> @@ -1473,7 +1473,12 @@ mlx5hws_action_create_insert_header(struct mlx5hws_context *ctx,
>  	int ret;
>  	int i;
>  
> -	action = hws_action_create_generic(ctx, flags, MLX5HWS_ACTION_TYP_INSERT_HEADER);
> +	if (!num_of_hdrs)
> +		return NULL;
> +
> +	action = hws_action_create_generic_bulk(ctx, flags,
> +						MLX5HWS_ACTION_TYP_INSERT_HEADER,
> +						num_of_hdrs);
>  	if (!action)
>  		return NULL;
>  

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. The
zero check and bulk allocation here now match
mlx5hws_action_create_reformat(). Should that function's SHARED flag
check be copied here as well?

mlx5hws_action_create_reformat() rejects this combination:

	if ((flags & MLX5HWS_ACTION_FLAG_SHARED) && (log_bulk_size || num_of_hdrs > 1)) {
		mlx5hws_err(ctx, "Reformat flags don't fit HWS (flags: 0x%x)\n", flags);
		goto free_action;
	}

mlx5hws_action_create_insert_header() has no such check.

Both constructors call hws_action_handle_insert_with_ptr(). That function
sets max_sz to the largest hdrs[i].sz, but passes only the first header's
buffer:

	ret = mlx5hws_arg_create(action->ctx,
				 hdrs->data,
				 max_sz,
				 log_bulk_sz,
				 action->flags & MLX5HWS_ACTION_FLAG_SHARED,
				 &arg_id);

With MLX5HWS_ACTION_FLAG_SHARED set, max_sz bytes are copied from that
single pointer into the send queue WQEs:

  mlx5hws_arg_create()
    mlx5hws_arg_write_inline_arg_data()
      mlx5hws_arg_write()
        memcpy(wqe_arg, arg_data, MLX5HWS_ARG_DATA_SIZE);

Take a caller that passes MLX5HWS_ACTION_FLAG_SHARED, num_of_hdrs > 1,
and a hdrs[0].hdr.sz smaller than a later header's size. Would this read
past the end of hdrs[0].hdr.data and pass those heap bytes to the device?
Headers 1..n would also silently get header 0's data.

The only caller today passes num_of_hdrs = 1 and does not set
MLX5HWS_ACTION_FLAG_SHARED, so this can't be triggered yet. Before this
patch, the same over-read sat behind the action[] overflow.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021074949.3471704-1-tariqt%40nvidia.com
