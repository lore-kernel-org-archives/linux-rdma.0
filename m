Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC7B3A1D2;
	Sat, 28 Mar 2026 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774720971; cv=none; b=QZiSqgL8osY7RXI+EWDAssAJSWfbp8vt/tjv079FKFwDjf4e4JBkacCLrgH56J66IQbkmvB+7uc+41RAqkBQICw28uhAeoMM58bvWwZyYoNc/Z6JyztncDmAQib+Sh1RvQ6aSc5Qbknqwb/jgYgF3PEHFitwl+t3eIGEGDdto5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774720971; c=relaxed/simple;
	bh=K4viw1bkLNt2zfpKpa4SYbYUeUvF2hDBuR2nyNYu2oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YE2yQiV/GdrCzHBLr6sdHe4ecvcMF/t5fh8b/nr4ny4HV6YKVdBvCF3QtKjc3oDcu9Nk2liPm9Xu666PoBQUmMKC32fiH5ueg8/U11Y6VhpGp46c9C2NGRR0z5ZphOkx/awstBiiEGsboloUaLhHbtjJg7q5q+YjnSG27F5vWIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VxtOCjnj; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VxtOCjnj"
Message-ID: <4f4c2881-d7b5-4528-807a-9bbbb6783d08@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774720966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4N6R38xS3/olYr0K68dx0QOhu41P4Kl0TWucYAAmtg=;
	b=VxtOCjnj3tW/rqny7+O1EtbJCq73pQeVpit0VyL5x0L7BeT0uJw8wr90YvPrNijqKLu5A/
	MRs9cSa67WY/fkIjrTnhs3KZp+exPlQGJZYo3Qe7s6LJUph1USrj5/G7EEIL1QVWrlzr5g
	xzfS2KUslaOEAzmUcImJA91nyENcXvE=
Date: Sat, 28 Mar 2026 11:02:33 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] RDMA/rxe: add SENT/RCVD bytes
To: zhenwei pi <zhenwei.pi@linux.dev>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
References: <20260328092839.111499-1-zhenwei.pi@linux.dev>
 <20260328092839.111499-3-zhenwei.pi@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260328092839.111499-3-zhenwei.pi@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/3/28 2:28, zhenwei pi 写道:
> There is a lack of sent/received counter in bytes.
> 
> Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
> ---
>   drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 ++
>   drivers/infiniband/sw/rxe/rxe_hw_counters.h | 2 ++
>   drivers/infiniband/sw/rxe/rxe_net.c         | 1 +
>   drivers/infiniband/sw/rxe/rxe_recv.c        | 1 +
>   drivers/infiniband/sw/rxe/rxe_verbs.h       | 6 ++++++
>   5 files changed, 12 insertions(+)
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
> index 20338cb8e3c2..ec0ae7479fe7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -519,6 +519,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>   	}
>   
>   	rxe_counter_inc(rxe, RXE_CNT_SENT_PKTS);
> +	rxe_counter_add(rxe, RXE_CNT_SENT_BYTES, skb->len);
>   	goto done;
>   
>   drop:
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 5861e4244049..b5522017852d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -342,6 +342,7 @@ void rxe_rcv(struct sk_buff *skb)
>   		goto drop;
>   
>   	rxe_counter_inc(rxe, RXE_CNT_RCVD_PKTS);
> +	rxe_counter_add(rxe, RXE_CNT_RCVD_BYTES, skb->len);
>   
>   	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
>   		rxe_rcv_mcast_pkt(rxe, skb);
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index fb149f37e91d..2bcfb919a40b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -460,6 +460,12 @@ static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
>   	atomic64_inc(&rxe->stats_counters[index]);
>   }
>   
> +static inline void rxe_counter_add(struct rxe_dev *rxe, enum rxe_counters index,
> +				   s64 val)
> +{
> +	atomic64_add(val, &rxe->stats_counters[index]);

Currently atomic64 variable is used to calculate the statistics. But to 
get better performance, per cpu variable is preferred. Since RXE is a 
software emulation rdma driver, the atomic64 variable is fine in RXE.

To mlx5, broadcom and efa driver, to get better performance, the per cpu 
variable is preferred.

Zhu Yanjun

> +}
> +
>   static inline struct rxe_dev *to_rdev(struct ib_device *dev)
>   {
>   	return dev ? container_of(dev, struct rxe_dev, ib_dev) : NULL;

