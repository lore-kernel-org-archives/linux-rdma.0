Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212634;
	b=QB5sPBxj/BBMAsYoqaXsO168edivEJ2s3HTBDbvgqliYSuCoRyMuzvxZlXIlzmxyhGpS
	 3MIvOJmx2qgQAgzDcqTrXEvL68evysj1EuEue3G9vr/SwmubgMDuOMaMOuhxcWRd28nJr
	 3YAMSIm9uWWeXTvPCnTkrGK4FJHfFTC5Eau0ItXDr74u2WRErK+CAUg7nsAkLSpM+MNRl
	 E4d7lzn6kiOSZnXYgurAMx12WJSUloiUo7S+azof1WiJSo94MrLmCtUJ18fZk503DVQvE
	 jZOcPHkVhBR0gm/Ifhz/W99SJ0Kh0gylFURoDcLXwZHa+xYIP0fq34FoO4EYjbGwoTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212634;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1JTQyG22sdRNJ8RntkpKDjs1VJz1ws+WgBDgHO6I6AQ=;
	b=kCMiOS61fnc52OaeqwWk71Gf0fTk5gbtk17b5WUAqHZI68hibNoujV3D8D4EiFafWyii
	 rOR8PBDrlVbB0GIFyqhqh70hlIRDp3vjfFGwnR4jh1Cu4U54mKm6/mxPt/fKihdEAos8j
	 PNR0MUdluageYStq7SawBVvIuvgKvly8LAUrorWGSkRkBVsFU/Vu8fM1uxVh6gcXxfG/T
	 9rrFpP6p8buytBsDZ8TCLuBsD0mlueNiAdAZNy2MssZjTSMbp1jmJu8MG+OtC1sHOWp60
	 yVpGhFcPdOhS7Krf+7MdKtRKDML0R2/9yylWCc7cYWcTJWwXC6Yxnmw3cAWnHyMwGxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGFwOOt3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E29606A322
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGFwOOt3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D741F0089F;
	Mon,  9 Nov 2026 08:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794212634;
	bh=1JTQyG22sdRNJ8RntkpKDjs1VJz1ws+WgBDgHO6I6AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UGFwOOt3CRrFGU+w17swOdrPUhCbMsaFvwh0clQX27L/jT9hmObkVlDgWaYnpVtUf
	 qCijf6dNF4EMqWZrBxXU3bRpp+krfo+5gFaCFJJk7enyX2ElZNdn3kFwXH/0+AjKIH
	 u3ASUwJWo+KiVXNxoBaGlNKYpvKU5KxhhYkNCMCKOi228aYf8Q7RqlkHur51dFyL27
	 +xOQqQGBWAUu+jMS9thK6kHzPOXAcu+WwnDLWsTxON8SOpmfpfzWq0c7Ug2zUhwC5I
	 piEc0P3cu+/hIIpj3amP5jJjWTRjva4bCCI5WSuD4f0w+g0Kk5lt8+opCAsp+GH4cn
	 6bG8e556mpHWQ==
Date: Mon, 9 Nov 2026 10:23:49 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/iwcm: restrict MAPINFO to administrators
Message-ID: <20261109082349.GB8635@unreal>
References: <20261107093338.618394-1-tjdqudcks0424@naver.com>
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
In-Reply-To: <20261107093338.618394-1-tjdqudcks0424@naver.com>

On Sat, Nov 07, 2026 at 06:33:38PM +0900, Sung Byeongchan wrote:
> 
> RDMA_NL_IWPM_MAPINFO announces the userspace iWARP port mapper and asks
> the kernel to send its live mapping table. Its callback registration does
> not request an administrative permission check, so an ordinary local
> NETLINK_RDMA sender can use the public mapper name and ABI version to
> replace the global daemon portid.
> 
> With a production SIW mapping present, an unprivileged claimant received
> the complete local and mapped sockaddr records in three of three fresh
> KASAN boots. A second independent unprivileged socket could repeat the
> claim. Wrong-name and old-version controls were rejected.
> 
> Set RDMA_NL_ADMIN_PERM on only the MAPINFO callback. The common RDMA
> netlink receiver then requires CAP_NET_ADMIN before the callback changes
> the daemon identity or serializes the mapping table.
> 
> The fixed kernel rejected the valid unprivileged request with -EPERM and
> zero records in three of three matched boots. Legitimate root mapper
> registration, live SIW mapping, daemon recovery, mapping removal and
> post-remove cleanup all passed their baseline and fixed controls.
> 
> The demonstrated impact is disclosure of local iWARP endpoint metadata
> and displacement of the trusted mapper identity. Uninitialized memory,
> controlled read or write, RCE and LPE were not demonstrated.

1. People still read commit messages, so please read yours before submitting.
2. Write a proper commit message; don't submit AI-generated slop.
3. Include the full kernel stack trace from dmesg in the commit message.
4. Add RDMA_NL_ADMIN_PERM to all IWPM commands.

Thanks

> 
> Fixes: b493d91d333e ("iwcm: common code for port mapper")
> Assisted-by: OpenAI Codex
> 
> Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
> ---
>  drivers/infiniband/core/iwcm.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
> index 4b05867dad895..8a3b5aa2dc5f7 100644
> --- a/drivers/infiniband/core/iwcm.c
> +++ b/drivers/infiniband/core/iwcm.c
> @@ -86,7 +86,10 @@ static struct rdma_nl_cbs iwcm_nl_cb_table[RDMA_NL_IWPM_NUM_OPS] = {
>  	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
>  	[RDMA_NL_IWPM_REMOTE_INFO] = {.dump = iwpm_remote_info_cb},
>  	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
> -	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
> +	[RDMA_NL_IWPM_MAPINFO] = {
> +		.dump = iwpm_mapping_info_cb,
> +		.flags = RDMA_NL_ADMIN_PERM,
> +	},
>  	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb},
>  	[RDMA_NL_IWPM_HELLO] = {.dump = iwpm_hello_cb}
>  };
> 
> base-commit: d48723711bae9b8cdc56719c448ba42fef28cbee
> -- 
> 2.43.0
