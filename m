Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1018C392C2F;
	Fri, 16 Oct 2026 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116525; cv=none; b=AvUSz4ePSGmiZCtiwfAClEFFp8KD/w5+Zll9TemeuL2iJK195wewZZ/CYqPFAnuvAI2oukOSNZHDpQRMDYqYZeVayI9WluSicQw/p/oC4hvuDidU9CWyu2yB6yEu+5H4Lxxd3qxEvm5rAF2PP1FOwcm1ocAfV7Mwh4lsL79wdng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116525; c=relaxed/simple;
	bh=A9DNSh/GpVgeWxphkEEKj5gWyDFRycRky6BHk+POuFA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=UiZPoWQT72MOTSjnMr6e7YToWdvaV5FmbTU7rfsxs5ZvbebYcd9AiEHT19kju3P+OZOOu+yZOIqNyCegE6qpqKixQadSSrQv52Np9s04xDlysmRyDGFwX7p5mEmNMnUFy2WhntPJZjDaLyO3lujzcsgDB1ms/bIYboBCL7Ii4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=nV+3PnrL; arc=none smtp.client-ip=203.205.221.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="nV+3PnrL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1792116519; bh=8tyOD97QdhD/OnpSrxE/vMsDZGnNXY3E47ZCLM/8/LA=;
	h=From:To:Cc:Subject:Date;
	b=nV+3PnrLBr/A4UJprRUsPE1O/ZBmU0p2K6lIFm2H5r48H1pd4Hm9AFpHHFylRFn0R
	 XhzYi6OeTLwO+JuIAI8Na1DS4ArGC+gnR2Ih81cHnKs/pVV8asn0XPGoHtAcbRM5pX
	 1Ru57OWs9LgfHwq8yFa/f6f4H0XlD+jfBXcXbbnE=
Received: from localhost.localdomain ([221.194.148.30])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 223A7A2D; Fri, 16 Oct 2026 10:08:35 +0800
X-QQ-mid: xmsmtpt1792116515tfo5q9lx5
Message-ID: <tencent_1BF6EE2B5853D22DD4A2F3EBADE737905209@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uP+cOMNo6JM6cTOE5C2uQnQ5q5I1NPbWdSj5XK9r0CFBQ7BoJwj
	 Xc30PqXrWjZQ3RXEGWmvrdn+QSgmne740bvzDeGE+H50B1iyXjwG66zYDrK0ZCn3GLNZYizJnceh
	 bAtDJtDBZjNOe0fdYgcAfKb5WYlm+RDZrVJnQYqxkrvAXfmVd8MURWVOX7p6z1eJMo2CyPUfsGFu
	 zZZk7iCfOi63yeBxfr3X+QV7KZa5XZUKlgp/kh9WVtJgnn5N8Cz4DNEn+9sHUD4q4qjO0s/YhwyF
	 iGQzWQwi7fPk6udAW81Qmim/ofmWALNG2l0hoyqR/J15JR0Ucs7lD08v9NhuhUPRRu8Y+Cj3hTZ8
	 BGz4+/CgHR91aiKIcO/32Lh4oeAacr7wTQ2dGB8fZKqBRosyK829WpNs2dSGHK12llFjzXRaV5vl
	 PsnKv7lex71PuUaYKlUYG1vzLFnziFR/lrxsZwPlycnvzdyGF2DLTE50fN+EsWTPNyU28KPSa3zv
	 3JQMVSnUjeGfLX8ekQOqJyP/w3x4D7F3FCt7cVrgKrpYFU+oI2kVvwjdxLtgVQN6eOm1oTHSiT7k
	 wLScfE+Du7MDDxXv4QMh+xRogQJTxND2LS8k7S/rMt0xgVUjmY2bqporCgLkaDLUkahJ1+y8Mpjp
	 H+e4W0LNAqTPzJD2gJNyvgXiNTxiG3x0miMGpw6+QvhBptOG7mZW6cYiPHWG8nz1/IRSl6c5XiMK
	 /DmLu558c8wActcKB7UJhvr7kMrerUy3FqPGPo3nq0hranIZfyr5puvn+1HGPHpJd+qFmrCOXPwO
	 8agbTa2Kpu8aebrrXUfkT0ZMTnh1thxiymFLFeDFSF7gpJPZbuCqgc0j2w2FYzIgleLVmgekmf7d
	 yP01/JeqUxwzju2Xc/F0i7Q9p7hblxRFCXBwBtyjBC9wp6WB8bZwyGWtP38ZL472TcknJAOWbBYh
	 kUmSIHV6iSez38m14aT2kOvi6/W9yXEFhq0SnZ0u4opjXknbuJct0xrWGQo4SSM7r3v1jaHmglbW
	 mHJYNG5lKOJsh+tskjQPZg4kBIjOU=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Zhiwei Zhang <202275009@qq.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Zhiwei Zhang <202275009@qq.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()
Date: Fri, 16 Oct 2026 10:08:22 +0800
X-OQ-MSGID: <20261016020835.41630-1-202275009@qq.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
uninitialized on the two paths that take an early goto:

	if (unlikely(skb->len < RXE_BTH_BYTES))
		goto drop;

	if (rxe_chk_dgid(rxe, skb) < 0)
		goto drop;

	pkt->opcode = bth_opcode(pkt);
	pkt->psn = bth_psn(pkt);
	pkt->qp = NULL;		<- too late for the gotos above
	...
drop:
	if (pkt->qp)
		rxe_put(pkt->qp);

pkt points into skb->cb, which rxe does not own at this point: the
network stack has used that space for its own state.  For IPv6,
ip6_rcv_core() memsets inet6_skb_parm and then writes

	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);

at offset 14, so the qword at cb + 8, which is where pkt->qp lives,
reads back as 0x0006000000000000 for every IPv6 packet.

Any IPv6 datagram to port 4791 whose payload is shorter than the BTH
takes the first goto and reaches the drop label with that value, so
rxe_put() runs refcount_dec_and_test() on 0x0006000000000150 and the
kernel faults, in softirq, on a non-canonical address:

	general protection fault, probably for non-canonical address
	0x0006000000000150: 0000 [#1] PREEMPT SMP
	RIP: 0010:__rxe_put+0x.../...
	Call Trace:
	 <IRQ>
	 rxe_rcv+0x.../... [rdma_rxe]
	 rxe_udp_encap_recv+0x.../... [rdma_rxe]
	 udp_queue_rcv_one_skb
	 ...
	Kernel panic - not syncing: Fatal exception in interrupt

The fault happens in softirq, so it panics even with panic_on_oops=0,
and with panic=0 the machine hangs until it is power cycled.  A remote
sender only needs to send an empty UDP datagram to port 4791; no RDMA
connection, GID or other state is involved and the rxe socket is bound
in init_net.

IPv4 is not affected: ip_rcv_core() memsets the whole inet_skb_parm, so
the pkt->qp slot is zero there.

Fix by clearing pkt->qp before the first early exit.  pkt->qp is only
ever assigned a reference-owning value by hdr_check() and
rxe_rcv_mcast_pkt(), both of which run after this point, so the put at
the drop label stays balanced.

The ordering has been unsafe since the driver was merged: the two early
gotos have preceded pkt->qp = NULL in every version since 8700e3e7c485.

Testing done: the driver was built and run on a 6.2 vendor tree that
carries this code, where a single 0-byte IPv6 datagram to port 4791
reproduced the panic above (that tree does not pull the UDP header in
rxe_udp_encap_recv(), so payloads of 0..3 bytes reach the first goto
there, versus 0..11 on mainline).  With this change, the same packets
are dropped as intended and tracing the drop label shows pkt->qp is 0
on every path that reaches it.  Not done: the mainline tree was not
built in the environment used to prepare this, and the reproducer is
left out of this message on purpose - both are available on request.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 2c90387aa126..e1d90633f085 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -320,6 +320,14 @@ void rxe_rcv(struct sk_buff *skb)
 	struct rxe_dev *rxe = pkt->rxe;
 	unsigned int skblen = skb->len - skb_network_offset(skb);
 
+	/*
+	 * pkt lives in skb->cb, which the network stack has already used
+	 * for its own state: for IPv6 the qword holding pkt->qp holds
+	 * inet6_skb_parm.nhoff.  The drop label puts pkt->qp, so clear
+	 * it before the first early exit.
+	 */
+	pkt->qp = NULL;
+
 	if (unlikely(skb->len < RXE_BTH_BYTES))
 		goto drop;
 
@@ -328,7 +336,6 @@ void rxe_rcv(struct sk_buff *skb)
 
 	pkt->opcode = bth_opcode(pkt);
 	pkt->psn = bth_psn(pkt);
-	pkt->qp = NULL;
 	pkt->mask |= rxe_opcode[pkt->opcode].mask;
 
 	/*
-- 
2.51.0

