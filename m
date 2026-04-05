Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645422236FD;
	Sun,  5 Apr 2026 19:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775416712; cv=none; b=F2uTlr/JNVJOIzWk1TENYlbRTF8EXdNsjuWffvF2avuYz4d1nipUN87gzJpta7iL7myv0TwaREbWYiZkVlhoI7CeieLw55djdMrGciIjHC7FP0xj+CBaHsnxa9nzpgWAaXfgo9kkRYeM0D48ZGgB6GEKiVW01Hr9EuiBwDXjXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775416712; c=relaxed/simple;
	bh=hq/Alr9hthm7cr9qeQTsBWX5BkqDhPszYxFl26u/m54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihfecOQJ7vTWaH+20GOLJB260CZnKWH9k0CDT1VMrqFVrfDjm1MOjT7nCklZsOh9/t5qTg6VVw1MzgQvrBvalzDacGBARI7aWkTkI0kvA77yjFzvzjyUnO+OtxsILhlbXx0blzvmHQXT8gXAczlewWzmgSnbvQ2RJlTe/TSW+/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xes7ZSGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xes7ZSGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9267FC116C6;
	Sun,  5 Apr 2026 19:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775416712;
	bh=hq/Alr9hthm7cr9qeQTsBWX5BkqDhPszYxFl26u/m54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xes7ZSGnwoB1HqGmN0v9IYXAvWQjqtSeqrYjUoKVqhjd5v7CniFFca8euGQl7AU0F
	 utnyJa7q/P1p2x6MpBZ1wELFXcX81fcqXpH2YjW/ID5FxeqfaJk0cjSmzIO8kYEHDa
	 oL6phIH7Q4r1ppVE8KJ/4nncNb5cNoycFT6TjP6Ex13H5POP5zwq5dnJxWIxUHpzN/
	 ljRRSFnBPs26vE1X0rgfiw2E6xdwAsMfRdQ/R4xuj0rhgh5it/2U3rLX34oSqT6kGy
	 PnVOvb71H9+MM87V1xgvgQOOPMQATAZWBz+0yRoXlIaHnPxDFXtwi1GMSa3I1kNc81
	 Wg4wCjTnl5C0w==
Date: Sun, 5 Apr 2026 22:18:28 +0300
From: Leon Romanovsky <leon@kernel.org>
To: zhenwei pi <zhenwei.pi@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	zyjzyj2000@gmail.com, jgg@ziepe.ca
Subject: Re: [PATCH v3 2/3] RDMA/rxe: add SENT/RCVD bytes
Message-ID: <20260405191828.GB86584@unreal>
References: <20260329054156.125362-1-zhenwei.pi@linux.dev>
 <20260329054156.125362-3-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329054156.125362-3-zhenwei.pi@linux.dev>

On Sun, Mar 29, 2026 at 01:41:55PM +0800, zhenwei pi wrote:
> There is a lack of sent/received counter in bytes.
> 
> Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
> ---
>  drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 ++
>  drivers/infiniband/sw/rxe/rxe_hw_counters.h | 2 ++
>  drivers/infiniband/sw/rxe/rxe_net.c         | 1 +
>  drivers/infiniband/sw/rxe/rxe_recv.c        | 1 +
>  drivers/infiniband/sw/rxe/rxe_verbs.h       | 6 ++++++
>  5 files changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> index 437917a7d8f2..17edaa9a9b9b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> +++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> @@ -22,6 +22,8 @@ static const struct rdma_stat_desc rxe_counter_descs[] = {
>  	[RXE_CNT_LINK_DOWNED].name         =  "link_downed",
>  	[RXE_CNT_RDMA_SEND].name           =  "rdma_sends",
>  	[RXE_CNT_RDMA_RECV].name           =  "rdma_recvs",
> +	[RXE_CNT_SENT_BYTES].name          =  "sent_bytes",
> +	[RXE_CNT_RCVD_BYTES].name          =  "rcvd_bytes",
>  };
>  
>  int rxe_ib_get_hw_stats(struct ib_device *ibdev,
> diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.h b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> index 051f9e1c3852..01b355103cbc 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> +++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> @@ -26,6 +26,8 @@ enum rxe_counters {
>  	RXE_CNT_LINK_DOWNED,
>  	RXE_CNT_RDMA_SEND,
>  	RXE_CNT_RDMA_RECV,
> +	RXE_CNT_SENT_BYTES,
> +	RXE_CNT_RCVD_BYTES,
>  	RXE_NUM_OF_COUNTERS
>  };
>  
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 20338cb8e3c2..ec0ae7479fe7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -519,6 +519,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>  	}
>  
>  	rxe_counter_inc(rxe, RXE_CNT_SENT_PKTS);
> +	rxe_counter_add(rxe, RXE_CNT_SENT_BYTES, skb->len);

Are you certain that the skb is still valid at this point?

Thanks

>  	goto done;
>  
>  drop:
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 5861e4244049..b5522017852d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -342,6 +342,7 @@ void rxe_rcv(struct sk_buff *skb)
>  		goto drop;
>  
>  	rxe_counter_inc(rxe, RXE_CNT_RCVD_PKTS);
> +	rxe_counter_add(rxe, RXE_CNT_RCVD_BYTES, skb->len);
>  
>  	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
>  		rxe_rcv_mcast_pkt(rxe, skb);
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index fb149f37e91d..2bcfb919a40b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -460,6 +460,12 @@ static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
>  	atomic64_inc(&rxe->stats_counters[index]);
>  }
>  
> +static inline void rxe_counter_add(struct rxe_dev *rxe, enum rxe_counters index,
> +				   s64 val)
> +{
> +	atomic64_add(val, &rxe->stats_counters[index]);
> +}
> +
>  static inline struct rxe_dev *to_rdev(struct ib_device *dev)
>  {
>  	return dev ? container_of(dev, struct rxe_dev, ib_dev) : NULL;
> -- 
> 2.43.0
> 
> 
