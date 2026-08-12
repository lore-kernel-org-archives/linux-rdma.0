Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FE937E5F3;
	Wed, 12 Aug 2026 23:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578415; cv=none; b=NffgQSuqT3upoI2ZlQhubwfYbcjdre5zSPxgjugtsMBznCrAyQK3ZgsipR5CrRo2yRQguilZWeO+JBDhp6a+nN8C8LZ6UYrLgKNnbMAcc9JaFKcPfnX7pa7mpu0TPzPRciz8e/lNYK+aVnCVIwzCKiUdhXDZjaC1ZsfJt9Dc6FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578415; c=relaxed/simple;
	bh=oYZnb0pOFVLU/jt8Hxc5iimMBQzigTltg3nBu/C9VWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcwDjWCHik81pj5YbkN6RvrPbQzTsORUnCT27JGLGJCrTZJQEclDYCQGd57HZmHo2HafBjxOSZaAEIjhaR/sI65FS+dLnu+UXYvltv5kcdyaniH1LcvwHfKaTlDBstBluxiJcOQNHQasOGU94pJgN+avJD5plpaKDygdVaXyYFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2DUPxql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2DUPxql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284871F00A3E;
	Wed, 12 Aug 2026 23:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578413;
	bh=hF0CNQ7UhNfL/sCSDU5thkYpJyclr1NyvngKX5NBdOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2DUPxqlg/wPSIRHVL+majAxZJBEQKUp2Ls09rfKzMVWvNHCzyiN/ySstXshmWj1y
	 GSXeh8RcFs/+D2jHKavWCubiNe1rR5+9aXA7qhBQu1KBLAd5lEqbHtbmIREeUUGqdx
	 9IiELkJm5LZWrjmBJkOX52dPRHAbvhgLu1wz1Zagrof8yOA+e4ZSiVAfBc7zy4sIfq
	 fC3pknXDDXKas3mqwlkqrjIW1EIIJjtxCxXvdvkglQKp7T/yg/3kMam9xQtIV3+za2
	 3f10V+4eu1NWyxM0qKa+K8tXVvdBzKPUzSCGVqQPDffTjKOYw7sOfoTwYRaqpJ+Q1q
	 usY7OUHRj5MHA==
From: Jakub Kicinski <kuba@kernel.org>
To: longli@microsoft.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	kotaranov@microsoft.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 2/7] net: mana: fix HWC RQ/SQ buffer size swap
Date: Wed, 12 Aug 2026 16:46:52 -0700
Message-ID: <20260812234652.2193454-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-3-longli@microsoft.com>
References: <20260811023823.2391255-3-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: fix HWC RQ/SQ buffer size swap

The patch swaps the message sizes used to allocate the HWC RQ and SQ so the
RQ (which receives responses) is sized by max_resp_msg_size and the SQ
(which sends requests) by max_req_msg_size.  It also stores
max_resp_msg_size in struct hw_channel_context and uses it as the RX slot
stride in mana_hwc_rx_event_handler().  The commit message notes both sizes
are 0x1000 today, so the previous swap had no observable effect.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 409e20caeccdc..3f011ebbe7b3e 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -733,14 +733,14 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  		goto out;
>  	}
>  
> -	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
> +	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_resp_msg_size,
>  				 hwc->cq, &hwc->rxq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
>  		goto out;
>  	}
>  
> -	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
> +	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_req_msg_size,
>  				 hwc->cq, &hwc->txq);
>  	if (err) {
>  		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
> @@ -749,6 +749,7 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
>  
>  	hwc->num_inflight_msg = q_depth;
>  	hwc->max_req_msg_size = max_req_msg_size;
> +	hwc->max_resp_msg_size = max_resp_msg_size;

[Severity: Medium]
This isn't a bug introduced by this patch, but while looking at how these
two fields are produced and consumed, the hardware-reported sizes appear to
be dead: is the negotiated-size half of this interface still expected to do
something?

mana_hwc_establish_channel() hands the device-reported values back to its
caller:

	*q_depth = hwc->hwc_init_q_depth_max;
	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;

and mana_hwc_create_channel() forwards them:

	err = mana_hwc_test_channel(gc->hwc.driver_data,
				    HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
				    max_req_msg_size, max_resp_msg_size);

but the body of mana_hwc_test_channel() references neither
max_req_msg_size nor max_resp_msg_size, and nothing else applies them to
the already-created queues or to hw_channel_context.  So the fields set
here in mana_hwc_init_queues() permanently hold the bootstrap constants
HW_CHANNEL_MAX_REQUEST_SIZE / HW_CHANNEL_MAX_RESPONSE_SIZE (both 0x1000),
which matches the commit message.

Two peer consumers do read hwc->max_req_msg_size as if it were the
hardware-negotiated request bound.  mana_gd_create_dma_region() in
gdma_main.c uses it to reject oversized commands:

	if (req_msg_size > hwc->max_req_msg_size)
		return -EINVAL;

and mana_ib_gd_create_dma_region() in drivers/infiniband/hw/mana/main.c
sizes both its request buffer and its page-list capacity from it:

	max_pgs_create_cmd =
		(hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
	...
	request_buf = kzalloc(hwc->max_req_msg_size, GFP_KERNEL);

If a device ever reported HWC_INIT_DATA_MAX_REQUEST smaller than 0x1000
(recorded into hwc->hwc_init_max_req_msg_size by
mana_hwc_init_event_handler()), would those callers keep building up to 4KB
commands that the hardware then rejects, and would a larger reported value
simply be ignored?  There is no memory-safety consequence today since the
SQ buffer and that bound are the same 0x1000 value after this patch, but
would it be worth either applying the reported sizes or dropping the unused
mana_hwc_test_channel() parameters?
