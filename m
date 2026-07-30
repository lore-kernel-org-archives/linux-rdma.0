Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D73769FD
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426893; cv=none; b=Skd0pJbN9dsWTUbjlAIrGbquwU50P6SXzRH/wY9yYSA40Ysa36FNmc/obSYvKqoLBRPMVZuzRsegwxQIJvRKmas7Ga2XWHlcLXKt4puyUpNUB/6hJuKU8IUc/T/1FaqW7pX7STd05qPys7QyLl9B304wWmLblPCbSDf2oqMfdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426893; c=relaxed/simple;
	bh=6RUJbJCJmcOgmBVoIfacETmzluT4jCS47ZikeWc4G18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C24wDvhNqZzctB8xcTVEIrMrN5M2I6aHHT1AnUIB1UaxotYW2w5qdJJBKzx6r+eRsYXteXpHAEr25vmLre36P8er8UBW5QK6QiftbuKs3TBaZKfyESCgN9LWGJ5JEKkXKKeGIU9CO4I6ICdqAr0LzO1R0BtlJvniBvpxyAMlR94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to; spf=none smtp.mailfrom=dama.to; dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b=S1qxlM8b; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b="S1qxlM8b"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e041ea211so54121a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 08:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20251104.gappssmtp.com; s=20251104; t=1785426890; x=1786031690; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ffWa1sUD0fV7EQhpv7D4SRQ+QnX1CHB/1+CmFyAsMhI=;
        b=S1qxlM8badubcVu+2zpnNR9vP5APe33QEemGuVqcmIIVsTyOWeXQNIrkFVGB1OUPgw
         8AwGXhCPXL1jxOY7i5dwV77y7TJMWn9XBuHUMPpSg/oHMqJCaBc5tPSbAbBR1fKoTc9p
         nAqIn+NL5WfZ1rUxYRn0WtLR4j2m+jgQrTYsSUL04xxxihMe5PWSjvWnSpfoovhtfxpx
         9bw/mL2y6DsR33MiffSsQtcywRCdlu7LpbuC0hQ739TFTpg/LespTWQiLtrJugHSlHqY
         T/ogjw72GZvhT3rKpRet8SQp4zgh5ZC1eYkH3Y70S0ruCTy8/qysIDYRNxp7MGRvLQfd
         17PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785426890; x=1786031690;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ffWa1sUD0fV7EQhpv7D4SRQ+QnX1CHB/1+CmFyAsMhI=;
        b=UySu89rbPko1ngU5FP1kBC8WP4bZeCHOOC7DHPiDsBB9FzJwFr/jfrIOP7sYzPxxut
         JKzu3tTXEDbyuF1Em6KvlYUa7g19LkNCH7hYtfF42HhisDhuY0Jtf2ZVMTh096Z3bknC
         D21woHFu5JIAr+sQ4JTi09E2QhOW/A4ktD7+fhBZ03QfDcEOnVXORjojLtth6bZwA7o9
         UQjr0PWdpPyX+KxD7/xyqTM/gGmkeGJkctHM6fe+AJq6VfVIqBcCBSaKIbMPBHhH7g1Q
         IbSHeIRtwXo3GmJ80Sw59url0sx8BZR1d6OOdAvpTv5t1XWESdn/GGEd5vzcebHF3ZJS
         bwQw==
X-Forwarded-Encrypted: i=1; AHgh+RoaDLHbruzD/Huxfe2C/UWzccXOGCjauZQEhpfi8LWqKQySjI3oVyNT9o4jcQZgraBLPsRa0AMPXEzS@vger.kernel.org
X-Gm-Message-State: AOJu0YxhzSXpjcTdiJV15zTJRZKVW4+g9/yO1fElHYfBnJQHTscVWLMK
	lxf8DYuvLppEBeyvvF0VFFc9BGUj79CMuTm4mBpkFmVktQ/e2/FT4sVa8OryK7YNrv8=
X-Gm-Gg: AR+sD121vTgTLluNKy1Fwsv7NsnS71HDgcm+iY4bXQtgZuIQXTvICOJ+W/J+tygBQY2
	tQOhuq1BGGtxxuebgjvcHlTxicyGJYpJ6c0EDUIvCl2ZG/t6GEfcKBMLekEYddXKx/yWgO96FUc
	fsKYb4gmX8uc+eI1cNiRfzRNDu/qSJha6J0PjWFlAwtHBqZySr7AIfhKaTSl174l4bzKDzov3Yq
	1ptWyb/r8Kv34gQEKMqq6t/ai116LIqUYepb67QokGX+UEOork6XdSNbU6t9dSH41X0Rfwg18QS
	YnQGkY02kOaxMdn+IaUvhVFxtDK6GWXUyPrKnCjgPSRVdhl1g4T4WrTwv9pQKDoO61HmlT3zEiE
	E90hIsCWIcbRD22gAnPVo7vh1srwbRiHQdlgqNs5VQ2EN1cDlLWfCF4qOZuRqHBqrMojDA7YWiC
	JZl85WuSXOnPQ64Uyyzx+cKR14R3w3slmwtlTwSe1b3A==
X-Received: by 2002:a17:90b:3b86:b0:381:bc4c:da56 with SMTP id 98e67ed59e1d1-38f9bde74d1mr2714794a91.19.1785426889854;
        Thu, 30 Jul 2026 08:54:49 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:43::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b99bda7sm1282895a91.12.2026.07.30.08.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:54:49 -0700 (PDT)
Date: Thu, 30 Jul 2026 08:54:48 -0700
From: Joe Damato <joe@dama.to>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Breno Leitao <leitao@debian.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, paulros@microsoft.com
Subject: Re: [PATCH net-next] net: mana: Extend RX CQE coalescing up to 8
 packets
Message-ID: <amtzyNmcIIYy6/bK@devvm20253.cco0.facebook.com>
Mail-Followup-To: Joe Damato <joe@dama.to>,
	Haiyang Zhang <haiyangz@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Breno Leitao <leitao@debian.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, paulros@microsoft.com
References: <20260729225235.3573786-1-haiyangz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729225235.3573786-1-haiyangz@linux.microsoft.com>

On Wed, Jul 29, 2026 at 03:52:22PM -0700, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> To support up to 8 packets per CQE, put two packet lengths and
> hash values into one PPI entry by using the reserved fields.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 137 ++++++++++++------
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  30 +++-
>  include/net/mana/gdma.h                       |   4 +
>  include/net/mana/mana.h                       |  43 ++++--
>  4 files changed, 150 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index a8c329bdbacf..720d22e6aea9 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1241,6 +1241,9 @@ int mana_gd_query_device_cfg(struct gdma_context *gc, u32 proto_major_ver,

[...]

>  
> +static void mana_process_one_rx_pkt(struct device *dev, struct mana_rxq *rxq,
> +				    struct mana_rxcomp_oob *oob,
> +				    u32 pktlen, u32 pkt_hash)
> +{
> +	struct mana_recv_buf_oob *rxbuf_oob;
> +	struct net_device *ndev = rxq->ndev;
> +	void *old_buf = NULL;
> +	bool old_fp;
> +
> +	rxbuf_oob = &rxq->rx_oobs[rxq->buf_index];
> +	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
> +
> +	if (unlikely(pktlen > rxq->datasize)) {
> +		/* Increase it even if mana_rx_skb() isn't called. */
> +		rxq->rx_cq.work_done++;
> +
> +		++ndev->stats.rx_dropped;

It looks like this code was moved from mana_process_rx_cqe, so this is prob
out of scope, but I saw this and was wondering if maybe rx_length_errors is more
appropriate?

from if_link.h:

 * @rx_length_errors: Number of packets dropped due to invalid length.
 *   Part of aggregate "frame" errors in `/proc/net/dev`.
