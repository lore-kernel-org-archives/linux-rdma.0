Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795883996;
	b=r3sU4x18CqzmM1QgbhXjmgA0AJyBgs8+ULcJ0CHBAtveumk/phC7ZRLC/f0d4VDr+XaW
	 cm62ZV/Q1hgB94szpSpw/Qeep+y0sKID7LgeFGNB5nRJU9tQDKpeNl0FGQxkZZo31BNkI
	 XeQcysA34ndMVlKFGkzoW940NYejNOEY7w2psQtJ2T/iPOcrGsdHsq/TpSdpG/l3jhggR
	 euCu+u0MkAx3vR/sYle2NWBTi6xYPNmBiaM5oDw1gxl9/kwcptCUka2LFAd1lP3r5rPg2
	 BGoXF6k3GWIiRSdEB50xibEYn/AidGptPkgAz2sJy1OXdfbZyqsoaehuO0eSNDIi15A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795883996;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=f7yih6Q8yEFy5xRz0HMwq8FiPEUkseJ7ijl9DnPpcgQ=;
	b=OoVesyAAymEVvmpJjnaCIPMwgQhZE9Kl5jftk5RATbdy3NbpcDIIfmL+pp/ULfbFnzRQ
	 LG9RcDwoagEPV/dnRbpaxnCtM0gQlu5FNb4bn+vY7rKct0LYZIqAZEvUwsLF3+NcVBNcx
	 +lxkG/p1ykMTudlOeVNjsfQEmgtkD0gMBfFWM0mujSpOXW02NqNyw/3bjAxQixDbiINO5
	 meuIQITwSLDOtvysGzHwSZ+KGv4QPOnmaqBxN7KUig2W4/jEW8a1U5lGy76gg4Op2HU+2
	 Ll3tod1Not2UZP3YDMd57n7QPCnUVBWPQoDVNI8q6dO0L3/Ug/m+Oyxy9lwmNrQuTsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qzu+TXGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31889606A323;
	Sat, 28 Nov 2026 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qzu+TXGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05871F00925;
	Sat, 28 Nov 2026 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795883995;
	bh=f7yih6Q8yEFy5xRz0HMwq8FiPEUkseJ7ijl9DnPpcgQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Qzu+TXGE64WwWr8fJzK+n4Eg/AlcnZyV55egFjn/nBLYWnBEZeEcQqoy/ZOViMLZF
	 Ga+2SA2A6JCgnFGoakwX4dVhgC1RLqQROHm5Yz4a03Dqszn3va3LIBzqV05SyIr0Bu
	 1c4eGpZE6lgQeZe9kPPD/djnMACqaJMlPoUmRtO2+M/zPNbDkCYGdqQwS+9vDPsW3U
	 3RfiKjdenhLz1F1MWS+gGlUCp4BFLr5yuDoQIcBnTAu7QH4oBU4Cq/L7P2jLAxm+9X
	 hvGQbEDfTMUN/5DMNJeB8eOAZI2RCCsnE2hDZ3kmePgq0hi7MescmOPBTbIq+dqsxi
	 u9LGze28pls5g==
Subject:
 Re: [PATCH net-next v12 5/5] net: mana: use the reported HWC queue depth
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 28 Nov 2026 16:39:53 +0000
Message-ID: <179588399336.3135.15832712725709611248@kernel.org>
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.5@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.5@linux.microsoft.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch may apply each firmware-reported HWC message limit
  to the wrong direction.

--

net: mana: use the reported HWC queue depth

This commit rebuilds the HWC at the PF-reported queue depth when all four
descriptor rings fit in 4 KiB and the reported message sizes match the
bootstrap allocations. Otherwise it keeps the bootstrap queues and
enforces the reported transmit and receive limits. It also tests the
rebuilt channel and restores a depth-one channel if that test fails.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index cf1b9c75b10e2..c78c2baf7048d 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -1097,32 +1138,177 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)

[ ... ]

> +static int mana_hwc_finish_channel(struct hw_channel_context *hwc,
> +				   const struct mana_hwc_init_report *report)
>  {
> -	u32 max_req_msg_size, max_resp_msg_size;
> -	u16 q_depth_max;
>  	int err;
>  
> -	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
> +	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
> +	hwc->rx_msg_size_limit = report->max_req_msg_size;
> +	hwc->tx_msg_size_limit = report->max_resp_msg_size;

[Severity: Medium]
Are these two limits applied to the right directions?

HWC_INIT_DATA_MAX_REQUEST is stored as rx_msg_size_limit, and
HWC_INIT_DATA_MAX_RESPONSE as tx_msg_size_limit. The tx limit then bounds
every host-to-PF request, first in mana_hwc_get_max_req_size():

    return min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);

and then in mana_hwc_stage():

    if (sub->len > min(hwc->tx_msg_size_limit, tx->buf_len) ||
        sub->resp_len > min(hwc->rx_msg_size_limit, hwc->max_req_msg_size))
        return -EMSGSIZE;

Before this patch, mana_gd_create_dma_region() and
mana_ib_gd_create_dma_region() bounded outgoing requests by
hwc->max_req_msg_size. So the request maximum was treated as the bound
for requests.

The comment "MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ" follows
the driver's own buffer naming in mana_hwc_init_queues(). Nothing in the
tree says what the PF means by these two values.

Suppose MAX_REQUEST is the largest request the PF accepts. Then on the
keep-bootstrap path in mana_hwc_prepare_channel(), wouldn't each
direction get the other direction's limit? For example:

  If the PF reports MAX_REQUEST=2048 and MAX_RESPONSE=4096, the driver
  sends CREATE_DMA_REGION and ADD_PAGES messages of up to 4 KiB to a PF
  that accepts only 2 KiB.

  If the PF reports MAX_REQUEST=4096 and MAX_RESPONSE=1024, requests are
  capped at 1 KiB. mana_gd_create_dma_region() then returns -EINVAL for
  queue buffers that need more than about 120 page entries. The RDMA
  max_pgs_create_cmd and max_pgs_add_cmd batches also shrink.

The rebuild path requires both values to be 4096. So this only matters
when the bootstrap queues are kept and the PF reports other sizes.

The commit message says "enforce the reported transmit and receive
limits", but it does not say which report maps to which direction.

Could the mapping be checked against the firmware definition and
documented?

> +
> +	err = mana_hwc_test_channel(hwc);
> +	if (err)
> +		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);
> +
> +	return err;
> +}

[ ... ]

> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index c154264f0f7c3..23df7222e8339 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h

[ ... ]

> @@ -233,6 +240,13 @@ struct hw_channel_context {
>  	struct hwc_caller_ctx *caller_ctx;
>  };
>  
> +/* Host-to-PF requests are bounded by the negotiated TX limit and SQ stride. */
> +static inline u32
> +mana_hwc_get_max_req_size(const struct hw_channel_context *hwc)
> +{
> +	return min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0%40linux.microsoft.com
