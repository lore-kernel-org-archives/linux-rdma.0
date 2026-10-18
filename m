Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782513AD516;
	Sun, 18 Oct 2026 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792326432; cv=none; b=GFmz8S1ZOwBI7q2+MqC0m3FK5EeU/R6FgzCA1350ydhJ+ssmJikfTGrzRQ8JJpPfgYt8P6wcuwxV7Vf49iTWqGZccCbISbsahNCDVP0CJYvOiW46psYuZFRCA6+MACvVaUin8rBdRYL09WFyTaCKt2PyB5Ma0r13bOigTBkZsc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792326432; c=relaxed/simple;
	bh=WR6Vg0O7bJPrHyWVSJKPMdxmFI5S9sVE+qBtJtowEAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puKTRjhhlPJF8IZnfjBWMvYzBXc4NUohanVvbmkCrk/SIZ7o01zsdSbtudHCPLijk5G3chWaguZpx/7lgUlvUBpPwV+batGLeM1NxrvOv66MU80lOOFDL7xOZBKVgf8afHnY60mLaRW1UqNJL+fe8q4hQAui3RWlQdJloOEEgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7PzG85a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7PzG85a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3351F000C4;
	Sun, 18 Oct 2026 12:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792326431;
	bh=pHfu2FQ7GiWnpLS4u1eg8OhhpNTGtD/KxUyVIA8ijCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b7PzG85aZewCtPvFd+m2pAZ7z8sTeKOxXgKksfcXNwuZxLnaILtPbB0lnPVZ6U2go
	 8WMLCzsO4vxzUhaBhPElDqJ0YWu1MEvxFIz7fgVfoIT81zcsxLb8ioSLbJ17MNiaIL
	 ZQpSsCQU159p88omEvOaO0p5Sd85gcx46cXN4eZJehSCWrpH71/Vc1tbR3GKfOd0od
	 MeUL3rkYdb6jRw5EaWp5wH2yVsVYSB/YcTk26/Fc3F6128UxtYZGyeX1741ZJ8QfEw
	 Oe1QqRqNp68N65ZqcsHxNbXkGOe8MvgsrWwmB7dhVrsmVmM8fRDTNzGgFP4aX06ljX
	 WuBNTi2FqgWTQ==
Date: Sun, 18 Oct 2026 15:27:07 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhiwei Zhang <202275009@qq.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Clear pkt->qp before the early drop exits in
 rxe_rcv()
Message-ID: <20261018122707.GC64621@unreal>
References: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
 <d521710d-85e1-4205-a904-3823325fa90f@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d521710d-85e1-4205-a904-3823325fa90f@linux.dev>

On Fri, Oct 16, 2026 at 04:23:13PM -0700, Zhu Yanjun wrote:
> 在 2026/10/15 19:08, Zhiwei Zhang 写道:
> > rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
> > uninitialized on the two paths that take an early goto:
> > 
> > 	if (unlikely(skb->len < RXE_BTH_BYTES))
> > 		goto drop;
> > 
> > 	if (rxe_chk_dgid(rxe, skb) < 0)
> > 		goto drop;
> > 
> > 	pkt->opcode = bth_opcode(pkt);
> > 	pkt->psn = bth_psn(pkt);
> > 	pkt->qp = NULL;		<- too late for the gotos above
> > 	...
> > drop:
> > 	if (pkt->qp)
> > 		rxe_put(pkt->qp);
> > 
> > pkt points into skb->cb, which rxe does not own at this point: the
> > network stack has used that space for its own state.  For IPv6,
> > ip6_rcv_core() memsets inet6_skb_parm and then writes
> > 
> > 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
> > 
> > at offset 14, so the qword at cb + 8, which is where pkt->qp lives,
> > reads back as 0x0006000000000000 for every IPv6 packet.
> > 
> > Any IPv6 datagram to port 4791 whose payload is shorter than the BTH
> > takes the first goto and reaches the drop label with that value, so
> > rxe_put() runs refcount_dec_and_test() on 0x0006000000000150 and the
> > kernel faults, in softirq, on a non-canonical address:
> > 
> > 	general protection fault, probably for non-canonical address
> > 	0x0006000000000150: 0000 [#1] PREEMPT SMP
> > 	RIP: 0010:__rxe_put+0x.../...
> > 	Call Trace:
> > 	 <IRQ>
> > 	 rxe_rcv+0x.../... [rdma_rxe]
> > 	 rxe_udp_encap_recv+0x.../... [rdma_rxe]
> > 	 udp_queue_rcv_one_skb
> > 	 ...
> > 	Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > The fault happens in softirq, so it panics even with panic_on_oops=0,
> > and with panic=0 the machine hangs until it is power cycled.  A remote
> > sender only needs to send an empty UDP datagram to port 4791; no RDMA
> > connection, GID or other state is involved and the rxe socket is bound
> > in init_net.
> > 
> > IPv4 is not affected: ip_rcv_core() memsets the whole inet_skb_parm, so
> > the pkt->qp slot is zero there.
> > 
> > Fix by clearing pkt->qp before the first early exit.  pkt->qp is only
> > ever assigned a reference-owning value by hdr_check() and
> > rxe_rcv_mcast_pkt(), both of which run after this point, so the put at
> > the drop label stays balanced.
> > 
> > The ordering has been unsafe since the driver was merged: the two early
> > gotos have preceded pkt->qp = NULL in every version since 8700e3e7c485.
> > 
> > Testing done: the driver was built and run on a 6.2 vendor tree that
> > carries this code, where a single 0-byte IPv6 datagram to port 4791
> > reproduced the panic above (that tree does not pull the UDP header in
> > rxe_udp_encap_recv(), so payloads of 0..3 bytes reach the first goto
> > there, versus 0..11 on mainline).  With this change, the same packets
> > are dropped as intended and tracing the drop label shows pkt->qp is 0
> > on every path that reaches it.  Not done: the mainline tree was not
> > built in the environment used to prepare this, and the reproducer is
> > left out of this message on purpose - both are available on request.
> > 
> > Fixes: 8700e3e7c485 ("Soft RoCE driver")
> 
> If AI helps this problem, please add
> Assist-by tag.

The consensus is to drop the tag, since it adds no value. The patches
already make it obvious that they were generated by AI.

Thanks

> 
> Thanks a lot.
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Zhu Yanjun
> 
> > Signed-off-by: Zhiwei Zhang <202275009@qq.com>
> > ---
> >   drivers/infiniband/sw/rxe/rxe_recv.c | 9 ++++++++-
> >   1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> > index 2c90387aa126..e1d90633f085 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> > @@ -320,6 +320,14 @@ void rxe_rcv(struct sk_buff *skb)
> >   	struct rxe_dev *rxe = pkt->rxe;
> >   	unsigned int skblen = skb->len - skb_network_offset(skb);
> > +	/*
> > +	 * pkt lives in skb->cb, which the network stack has already used
> > +	 * for its own state: for IPv6 the qword holding pkt->qp holds
> > +	 * inet6_skb_parm.nhoff.  The drop label puts pkt->qp, so clear
> > +	 * it before the first early exit.
> > +	 */
> > +	pkt->qp = NULL;
> > +
> >   	if (unlikely(skb->len < RXE_BTH_BYTES))
> >   		goto drop;
> > @@ -328,7 +336,6 @@ void rxe_rcv(struct sk_buff *skb)
> >   	pkt->opcode = bth_opcode(pkt);
> >   	pkt->psn = bth_psn(pkt);
> > -	pkt->qp = NULL;
> >   	pkt->mask |= rxe_opcode[pkt->opcode].mask;
> >   	/*
> 
> 
