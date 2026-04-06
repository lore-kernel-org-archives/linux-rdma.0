Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC5930F7EF
	for <linux-rdma@vger.kernel.org>; Mon,  6 Apr 2026 14:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775487370; cv=none; b=ArBKmnKARl/zPRoFIq/js/Ft+X0FFtLtZZZA3vpTJexuvycuNH7F9Ziv0asazXupUMMzhV6qmJeSeCSH/k667mqtXUDTgaMUwk+t1GZRakGoteW1XCMt9KcbXBHlIZRrR/fzGyfdQV1gjIOa7M6s+kkn9Dj0GP8MOFlFmfd2274=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775487370; c=relaxed/simple;
	bh=2oCDeTTAz4i+oRoQx9Lwjvq3SOYNYNQbJ/oFMugWHhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f8bYXRttfsAfkhKDteFcvTnigrq7tx+d/bI1B/ADhZgZZFDnmmJ8xoSuooIDwYNaXQndygKb8YSm+lvxYg84p5GTTExzkTTPjPw6UuR3gT4c0fa7oNjyGy2a+yX0HWL+geJ5j5tgdx2Er63S11RXPvhzm8MrVFaeWOtpPPTRxsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=en5s2sRj; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="en5s2sRj"
Message-ID: <92943fb0-b0ec-443e-a04f-204faba0c9cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775487357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyF5qRaqjabeid2cTBHwWHRbO+gNt0L032MGRaraC74=;
	b=en5s2sRjaeyVZIMCYu3xKOULPJLBKTcv0vlCs6lzCx0D93QQMFCq9Ky2o0D3cLUFE+oJLJ
	4YYWkFypiRhr2JQfTM4Ql2GeuVHLL1AETT7JCiCcyeDa9iN++wh3aLQNwt8GdFIUSNRgX/
	dqYGfksungNY4aXBnoscxVXOlIh72pc=
Date: Mon, 6 Apr 2026 07:55:41 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/4] RDMA/rxe: add SENT/RCVD bytes
To: zhenwei pi <zhenwei.pi@linux.dev>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
References: <20260406132830.435381-1-zhenwei.pi@linux.dev>
 <20260406132830.435381-4-zhenwei.pi@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260406132830.435381-4-zhenwei.pi@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/4/6 6:28, zhenwei pi 写道:
> There is a lack of sent/received counter in bytes.
> 
> Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
> ---
>   drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 ++
>   drivers/infiniband/sw/rxe/rxe_hw_counters.h | 2 ++
>   drivers/infiniband/sw/rxe/rxe_net.c         | 2 ++
>   drivers/infiniband/sw/rxe/rxe_recv.c        | 6 ++++++
>   drivers/infiniband/sw/rxe/rxe_verbs.h       | 6 ++++++
>   5 files changed, 18 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> index 437917a7d8f2..17edaa9a9b9b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> +++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
> @@ -22,6 +22,8 @@ static const struct rdma_stat_desc rxe_counter_descs[] = {
>   	[RXE_CNT_LINK_DOWNED].name         =  "link_downed",
>   	[RXE_CNT_RDMA_SEND].name           =  "rdma_sends",
>   	[RXE_CNT_RDMA_RECV].name           =  "rdma_recvs",
> +	[RXE_CNT_SENT_BYTES].name          =  "sent_bytes",
> +	[RXE_CNT_RCVD_BYTES].name          =  "rcvd_bytes",
>   };
>   
>   int rxe_ib_get_hw_stats(struct ib_device *ibdev,
> diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.h b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> index 051f9e1c3852..01b355103cbc 100644
> --- a/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> +++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
> @@ -26,6 +26,8 @@ enum rxe_counters {
>   	RXE_CNT_LINK_DOWNED,
>   	RXE_CNT_RDMA_SEND,
>   	RXE_CNT_RDMA_RECV,
> +	RXE_CNT_SENT_BYTES,
> +	RXE_CNT_RCVD_BYTES,
>   	RXE_NUM_OF_COUNTERS
>   };
>   
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 6621d01ac32d..86660031ffa2 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -503,6 +503,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>   	int err;
>   	int is_request = pkt->mask & RXE_REQ_MASK;
>   	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
> +	unsigned int skblen = skb->len;
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&qp->state_lock, flags);
> @@ -526,6 +527,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>   	}
>   
>   	rxe_counter_inc(rxe, RXE_CNT_SENT_PKTS);
> +	rxe_counter_add(rxe, RXE_CNT_SENT_BYTES, skblen);
>   	goto done;
>   
>   drop:
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 5861e4244049..0d9112e95eae 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -318,6 +318,7 @@ void rxe_rcv(struct sk_buff *skb)
>   	int err;
>   	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
>   	struct rxe_dev *rxe = pkt->rxe;
> +	unsigned int skblen = skb->len + sizeof(struct udphdr);
>   
>   	if (unlikely(skb->len < RXE_BTH_BYTES))
>   		goto drop;
> @@ -341,6 +342,11 @@ void rxe_rcv(struct sk_buff *skb)
>   	if (unlikely(err))
>   		goto drop;
>   
> +	if (skb->protocol == htons(ETH_P_IP))
> +		skblen += sizeof(struct iphdr);
> +	else if (skb->protocol == htons(ETH_P_IPV6))
> +		skblen += sizeof(struct ipv6hdr);
> +	rxe_counter_add(rxe, RXE_CNT_RCVD_BYTES, skblen);

 From the above source code, I think that you want to calculate total 
length starting from the Network Layer (IP Header).
Maybe the following is compact.

"
unsigned int skblen = skb->len - skb_network_offset(skb);
rxe_counter_add(rxe, RXE_CNT_RCVD_BYTES, skblen);
"

Zhu Yanjun

>   	rxe_counter_inc(rxe, RXE_CNT_RCVD_PKTS);
>   
>   	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index e800545d1046..0f5ffd94643f 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -455,6 +455,12 @@ static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
>   	atomic64_inc(&rxe->stats_counters[index]);
>   }
>   
> +static inline void rxe_counter_add(struct rxe_dev *rxe, enum rxe_counters index,
> +				   s64 val)
> +{
> +	atomic64_add(val, &rxe->stats_counters[index]);
> +}
> +
>   static inline struct rxe_dev *to_rdev(struct ib_device *dev)
>   {
>   	return dev ? container_of(dev, struct rxe_dev, ib_dev) : NULL;

