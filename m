Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8483A383305;
	Sat, 17 Oct 2026 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792201240; cv=none; b=jRDhveEMazvR0Sed67nEwsVqNXMDCDeBgrScBKafTsfYiEw/DoTYcNOnWcawDNjiU6XRfVg0+keI12ViRQleCxM/b/MNFtZ7yU6wLfPxps6dVgR0EXl9Y9LaUNKDzppEpUGJ77YbnGUy1I599f1JEjfvhDf3uG7QEKclr6O+7PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792201240; c=relaxed/simple;
	bh=U8eIFTYwxUu2VYvFOQzZjCM7aeka9NIhYJlnAVuUNnE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=NHfAd597IjsqnF+lq7ML7PC4g6qS3htPRs9KC4y+JePid7SBYjNCbngYdofjvOJC+3ni1Yzs/Ld15w/mBH58cdZgwURfxygYICZiCSqitJIRNeDLN9rZORmzp2fumyqsFWsvSPiI9U4+xFrpMNuMHWy+DzdC74F/3+lO45w+lFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=sjsqKYeN; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="sjsqKYeN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1792201228; bh=SulC2LqArsX3jadYIM8tN2dHXQIl6HR06k4bbKuqBEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjsqKYeNM6jI0WhISVo5wG0INzTLSjSYR4591DHI42gpoAbwau5YlyrVVuP4mommV
	 RRCTqv318mYE/a9lvCzkNCjiFf6tkpH9kEjfIonsV/+ylNqJBJEmcpSaNGMNUvo9jD
	 JHaDW3ANeki9HHGRlr2ooqS0gC023DtXiIMLTLdk=
Received: from localhost.localdomain ([27.128.219.93])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id A18BD2DC; Sat, 17 Oct 2026 09:40:24 +0800
X-QQ-mid: xmsmtpt1792201224tknng2gcy
Message-ID: <tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznV+Qz8/DlZcoqg0BRIelR6LRpetdzzNJJIlsBkVuQXyohDes1Q6
	 ETLIUOZ5VCxMNfmmQ4hRCzdtjuv6SlOwfwLOq9RkqPt1cj1IZlwT5oYB/MNjLnjKRHUmGy53ArCe
	 5l//Abhq4RvuSGDitPz7tx13ZvcRYbuKgbeK2fMAHOvIM1bHvrP/p+rpHBFDkyWnUWGdmd6Ob7+t
	 CRMu1IuKgYHy9H9bFpLb1PWcbaUEx9fGTyivmeNTjEO6I1q5XWpGxACFiAmdUI8abq6+z/pxwkW0
	 FArOpM6Ie3+zsHVhp2oZdRhn3dXfUcL8MO1vPfDJnWzdghZFYzMM9Re4yhtMzzYaH+7DcCcGDtkz
	 3dZK/IEe9fg8hbUH6dqIbSxlKhvpqyTY0njlivS2jL8YBgtyK/5GQutZgm2xAYvedU98OZ95+Irl
	 mjZhVNcY5WjN0pN8r45QdpEn9VeTY+B6X2+UGL4nQzLXGxYb4ad8nYCLl+HEgnFKceE6mBZC2sJe
	 MKeJLySiAHdCSmj1MzOtc6q7+VEGFJMndWSM0zSeiBStSfMILLAUKb477ruDdk+5YaAr/TebZ8Sk
	 3FvtBdf9AIAwwxt1UcRgfrRZZO73u75LBAd/fztOW66o08/aCxt3BGrq7W51vFwdI3GiWxESp8Tg
	 F136J47UbfVVhs9HEhwCBq44wcnh5SQ+D2RNC9OwRwCMAlEi7OscE91FecrgqU72OzP2o4/OBhQ9
	 RbQEo6qlRjDKv2F3apdW/FcB8n7xdII2OSeSSrhLVFxiVAUuYLqYHWnHuglXsmXrKL9oaIsBCToH
	 7HWSvQO16hKAP//Jg/vA+wa23gaZEH56Nz7J3uxhaohO4tSFXdOLSrWwdQYKWX8ZMUuOKzNdRChX
	 Vp8bTD447ehc9qMIbEXav+Vgo5saHoilcDHggs6Tp7DJ1qAeWdRIaasBSqpQLFI/tO2SBPurdBxE
	 RJZea+Sy795udIwAIb92OC867sU0xnv6iH9BgyPKhjzi14Z+cZaWBQe7xzuWPmx5xRx4bAqEaO6x
	 AUrkupt5MfErF1vC0XibUpnp+I1W2Q2+kNs35FbW7CZE71A/rEzhmP+wVVCqWXwIF90YGX9EXL4D
	 8xQQQ1+BGaNBOL1nRGL/5CoP7XwA==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Zhiwei Zhang <202275009@qq.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhiwei Zhang <202275009@qq.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()
Date: Sat, 17 Oct 2026 09:40:21 +0800
X-OQ-MSGID: <20261017014021.59707-1-202275009@qq.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261016020835.41630-1-202275009@qq.com>
References: <20261016020835.41630-1-202275009@qq.com>
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
Assisted-by: LLM
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
---
Changes in v2:
- Add Assisted-by: LLM to acknowledge AI assistance.
- Add Reviewed-by from Zhu Yanjun.
- No code changes.

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

