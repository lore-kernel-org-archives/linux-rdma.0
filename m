Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524326;
	b=bAhYC2LDA/HynWm1I6rTwhoSkhL8a1WNQVjXwb2RpPbvQinAO7+IZh8yn74LJeHtWJCL
	 uKZ1s0aX3A3YIKZ9yO5BVEEma71eO/EA2oWJ7UN8sL82lC/OK75dx4e8oQUuam8iDsiKo
	 kpinxZ0tlL0lmLjT0BMvaX/IJx3PJqefTw8GI9FpadxEjreN34kJwhEu3u08GfXpsrM2M
	 qBMBak+s2li1ITJZx2cuyaKScQUPQ7XbrvvV7cRANuRGHIIrQOeg5jj2xr6OjihP9ScWD
	 ZhUiPGwpjCBCKF9C0+ZKWAdhJFQdfWHrJGrCA/xY+tm9elKLdAEug6r5MDIhqI42l4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524326;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5Sj6vt5blCGoie1LkcBf7P//9btZKiE3qaJI1R2ghjI=;
	b=Zwyv09Zw97HZ/0wXteno6NlYmYNyLwLxf8DapJb6yzF9jqTLO+NESrIimE8bxmNl9h54
	 Sxpv73G4t2iQbiwZ35aUVcyTvJOQuuBIKuhzkYYvKqM3GpcKqkKWSCkJAvWRNyAjFXaKe
	 /0+Jl8Qj8+Ao0wQwJ/Fxo3TtnkW7WQaoTD7wxHALty5PkmgH5ZvdRkNM9H3C+vr3qNUm5
	 sb6thihRYCq96blqOSNbVhb8SnxRjru/t3khtdmsLqgzRifiDPHqSmlfWx7j+sMYe6b8J
	 yyEgUf5TKL4WnoAorw2Jh3aD3NenD1K0ZnhLnZk4KCmsiuYFfKv0fA8uyqnVm9TfDIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WAlH/UGT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE66606A32C;
	Tue, 24 Nov 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAlH/UGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB271F000D0;
	Tue, 24 Nov 2026 12:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795524325;
	bh=5Sj6vt5blCGoie1LkcBf7P//9btZKiE3qaJI1R2ghjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WAlH/UGTbdFYbcp4uGccwwwj9aceAhnTMHSaYUpe4lveJMZCIIgYXKYesJWZbH3lK
	 JFDSQ9bpSfm5jdD9yEL846v+60YFMlIyls0m0+nTZUUnRN5iByRJUUEBjKpkFmIfYO
	 ynsXbvjsOX/3cZJgG3MXEd+42Lf0awLRKm1iy54/bHJQUvjJqwrf49URWzHh40lZzN
	 pUPALaWfUnqnov8IBzYh/KyElIFTqEfKE75/Ilj7PvMUovrmwmrHXqvyAoq1NxNgbC
	 cBh73O33suf+EamI77tMCpxlYqVoE7pFFVyh5f8Ei6nT3RyLiKlPJl5HvaaZ8AQxw0
	 /yxG5R0EvC30w==
Date: Tue, 24 Nov 2026 14:45:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Snehal Sanghvi <snsanghvi@linux.microsoft.com>
Cc: kotaranov@microsoft.com, snsanghvi@microsoft.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: support enhanced connection
 establishment
Message-ID: <20261124124519.GQ14811@unreal>
References: <20261120010851.616472-1-snsanghvi@linux.microsoft.com>
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
In-Reply-To: <20261120010851.616472-1-snsanghvi@linux.microsoft.com>

On Thu, Nov 19, 2026 at 05:08:51PM -0800, Snehal Sanghvi wrote:
> From: Snehal Sanghvi <snsanghvi@microsoft.com>
> 
> Expose ECE when the firmware supports it. Return the firmware ECE offer
> for RC and UC QPs, and use the RNIC set-state V4 layout for every modify
> so that user ECE options reach the firmware and its current options are
> returned; 0 means no update, and option bits are interpreted by the
> firmware. Without firmware support, requests keep their legacy layout.
> 
> Reviewed-by: Konstantin Taranov <kotaranov@microsoft.com>
> Signed-off-by: Snehal Sanghvi <snsanghvi@microsoft.com>
> ---
> Matching rdma-core userspace implementation:
> https://github.com/linux-rdma/rdma-core/pull/1866
> 
>  drivers/infiniband/hw/mana/main.c    | 12 +++++++--
>  drivers/infiniband/hw/mana/mana_ib.h | 20 ++++++++++++---
>  drivers/infiniband/hw/mana/qp.c      | 38 ++++++++++++++++++++--------
>  include/uapi/rdma/mana-abi.h         | 15 +++++++++--
>  4 files changed, 67 insertions(+), 18 deletions(-)

<...>

>  
> @@ -996,18 +996,33 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>  	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
>  	struct mana_rnic_set_qp_state_resp resp = {};
>  	struct mana_rnic_set_qp_state_req req = {};
> +	struct mana_ib_modify_qp_resp uresp = {};
> +	struct mana_ib_modify_qp ucmd = {};
>  	struct gdma_context *gc = mdev_to_gc(mdev);
>  	struct mana_port_context *mpc;
>  	struct net_device *ndev;
> +	bool ece = mana_ib_ece_supported(mdev);
>  	int err;
>  
> -	err = ib_no_udata_io(udata);
> -	if (err)
> -		return err;
> +	if (udata && udata->inlen) {
> +		err = ib_copy_validate_udata_in_cm(udata, ucmd, ece_options, 0);
> +		if (err)
> +			return err;

This is not the correct way to extend udata support, it breaks backward
compatibility. Before this change, users could provide udata with four zero
bytes of provider input and no provider output:

struct ib_uverbs_attr uhw_in = {
	.attr_id = UVERBS_ATTR_UHW_IN,
	.len = 4,
	.data = 0,
};

Now, ib_copy_validate_udata_in_cm(..., ece_options, 0) requires eight bytes
and returns -EINVAL if fewer are provided.

Thanks
