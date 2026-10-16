Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F2F37DABD
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 23:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792193002; cv=none; b=KC1RRFa4Rc6vuuByQPfLs7lTTW4ylKXAtU9C95KuOXdsm+zvwnUIRqT2EOsD6tGJSdpmb2/YEJa6EFdRYDqfJlGXnRAEqu6dE1z0hWI+vcdZIr9+n4vBXfznuhvZM1JW5oooojeIuIOQn7sL0fK0lgHdrGmkfSDuRRLHM4P2qbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792193002; c=relaxed/simple;
	bh=0+E3T1/LognaqAEqD3vtOpnBDpCq4wDNO/h4ZlKIs3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feJOjC8zarb7T89cw0t5J3PfY+Is5N8CJ7aMNg6LMwD03Vtmvn2Xxei7W6xNtrtBEe5vY0orvvY+zGWAjbeti5km2guWMh83QTHsff8ykfH5YcvhPWhvNAHOwIoC/OmK7NZvZYpt+frTDmFJJGBq4alzu3vHOgn9OuoeFB/M9S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PrHY8A4Q; arc=none smtp.client-ip=91.218.175.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PrHY8A4Q"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0+E3T1/LognaqAEqD3vtOpnBDpCq4wDNO/h4ZlKIs3g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792192996; v=1; x=1792797796;
 b=PrHY8A4QK0dgBMCHasJO5JqAbqBeclaErIsTf2r9RzfCdus+AwVWXbDQ4Vwhs64MkYlvOnsO
 0f5LXQIKD9sdMuDUjZtH/B/S5Sg0XEdKnrWU5UsCZs4GICwE/n6jHSLab3AhMv33pF4m/W2WH+f
 0+ed+D7bUxG9o8VqTh8+kcTQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5722531e999b4a13;
	Fri, 16 Oct 2026 23:23:16 +0000
X-Mizu-Trace-ID: 5722531e999b4a13
X-Migadu-Flow: FLOW_OUT
Message-ID: <d521710d-85e1-4205-a904-3823325fa90f@linux.dev>
Date: Fri, 16 Oct 2026 16:23:13 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Clear pkt->qp before the early drop exits in
 rxe_rcv()
To: Zhiwei Zhang <202275009@qq.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/15 19:08, Zhiwei Zhang 写道:
> rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
> uninitialized on the two paths that take an early goto:
> 
> 	if (unlikely(skb->len < RXE_BTH_BYTES))
> 		goto drop;
> 
> 	if (rxe_chk_dgid(rxe, skb) < 0)
> 		goto drop;
> 
> 	pkt->opcode = bth_opcode(pkt);
> 	pkt->psn = bth_psn(pkt);
> 	pkt->qp = NULL;		<- too late for the gotos above
> 	...
> drop:
> 	if (pkt->qp)
> 		rxe_put(pkt->qp);
> 
> pkt points into skb->cb, which rxe does not own at this point: the
> network stack has used that space for its own state.  For IPv6,
> ip6_rcv_core() memsets inet6_skb_parm and then writes
> 
> 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
> 
> at offset 14, so the qword at cb + 8, which is where pkt->qp lives,
> reads back as 0x0006000000000000 for every IPv6 packet.
> 
> Any IPv6 datagram to port 4791 whose payload is shorter than the BTH
> takes the first goto and reaches the drop label with that value, so
> rxe_put() runs refcount_dec_and_test() on 0x0006000000000150 and the
> kernel faults, in softirq, on a non-canonical address:
> 
> 	general protection fault, probably for non-canonical address
> 	0x0006000000000150: 0000 [#1] PREEMPT SMP
> 	RIP: 0010:__rxe_put+0x.../...
> 	Call Trace:
> 	 <IRQ>
> 	 rxe_rcv+0x.../... [rdma_rxe]
> 	 rxe_udp_encap_recv+0x.../... [rdma_rxe]
> 	 udp_queue_rcv_one_skb
> 	 ...
> 	Kernel panic - not syncing: Fatal exception in interrupt
> 
> The fault happens in softirq, so it panics even with panic_on_oops=0,
> and with panic=0 the machine hangs until it is power cycled.  A remote
> sender only needs to send an empty UDP datagram to port 4791; no RDMA
> connection, GID or other state is involved and the rxe socket is bound
> in init_net.
> 
> IPv4 is not affected: ip_rcv_core() memsets the whole inet_skb_parm, so
> the pkt->qp slot is zero there.
> 
> Fix by clearing pkt->qp before the first early exit.  pkt->qp is only
> ever assigned a reference-owning value by hdr_check() and
> rxe_rcv_mcast_pkt(), both of which run after this point, so the put at
> the drop label stays balanced.
> 
> The ordering has been unsafe since the driver was merged: the two early
> gotos have preceded pkt->qp = NULL in every version since 8700e3e7c485.
> 
> Testing done: the driver was built and run on a 6.2 vendor tree that
> carries this code, where a single 0-byte IPv6 datagram to port 4791
> reproduced the panic above (that tree does not pull the UDP header in
> rxe_udp_encap_recv(), so payloads of 0..3 bytes reach the first goto
> there, versus 0..11 on mainline).  With this change, the same packets
> are dropped as intended and tracing the drop label shows pkt->qp is 0
> on every path that reaches it.  Not done: the mainline tree was not
> built in the environment used to prepare this, and the reproducer is
> left out of this message on purpose - both are available on request.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")

If AI helps this problem, please add
Assist-by tag.

Thanks a lot.
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> Signed-off-by: Zhiwei Zhang <202275009@qq.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_recv.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 2c90387aa126..e1d90633f085 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -320,6 +320,14 @@ void rxe_rcv(struct sk_buff *skb)
>   	struct rxe_dev *rxe = pkt->rxe;
>   	unsigned int skblen = skb->len - skb_network_offset(skb);
>   
> +	/*
> +	 * pkt lives in skb->cb, which the network stack has already used
> +	 * for its own state: for IPv6 the qword holding pkt->qp holds
> +	 * inet6_skb_parm.nhoff.  The drop label puts pkt->qp, so clear
> +	 * it before the first early exit.
> +	 */
> +	pkt->qp = NULL;
> +
>   	if (unlikely(skb->len < RXE_BTH_BYTES))
>   		goto drop;
>   
> @@ -328,7 +336,6 @@ void rxe_rcv(struct sk_buff *skb)
>   
>   	pkt->opcode = bth_opcode(pkt);
>   	pkt->psn = bth_psn(pkt);
> -	pkt->qp = NULL;
>   	pkt->mask |= rxe_opcode[pkt->opcode].mask;
>   
>   	/*

