Return-Path: <SRS0=Yo+y=AL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D7FC433DF
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 12:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36BA720780
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jun 2020 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593520576;
	bh=FGOdI61sjJfyZS2fArc7EfSlBw9mMNS79AYKno1N5gY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Rg2tQYC3c6i/GcDqKeFfiu1Y92o6cbeH2cuJqCi/6pdbLVsxHIc2Kp8SG65m4fATW
	 VUyYnePxLrqSH6qYPsxt+5avDD2LQCloGP2K0ZCwo55qW0e952H40o6k5e/FGnA2Rl
	 QgwzIKCvtFKRtVSrzTmKjFPWEfMJ4dnFLqoTrrKE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgF3MgP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jun 2020 08:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732042AbgF3MgP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 30 Jun 2020 08:36:15 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC6A2073E;
        Tue, 30 Jun 2020 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593520574;
        bh=FGOdI61sjJfyZS2fArc7EfSlBw9mMNS79AYKno1N5gY=;
        h=From:To:Cc:Subject:Date:From;
        b=qqOPMSgCAt13EPAq1Xty6nzHz5yvVqKGEPKW8V8BF3Ic96Tg6FkB8VYRr7+8lEyXv
         IDGhEoVQaA/bh5md8IozAolRBXZvU1svWhdytT2x7tmPPjX/D8DP/fKOWJ4kBhFkpY
         y5p4aBlHlt1S7OE3/WK5bMALq8jhl03sHuwXp+LE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Zhu Yanjun <yanjunz@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/rxe: Skip dgid check in loopback mode
Date:   Tue, 30 Jun 2020 15:36:05 +0300
Message-Id: <20200630123605.446959-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

In the loopback tests, the following call trace occurs.

Call Trace:
 __rxe_do_task+0x1a/0x30 [rdma_rxe]
 rxe_qp_destroy+0x61/0xa0 [rdma_rxe]
 rxe_destroy_qp+0x20/0x60 [rdma_rxe]
 ib_destroy_qp_user+0xcc/0x220 [ib_core]
 uverbs_free_qp+0x3c/0xc0 [ib_uverbs]
 destroy_hw_idr_uobject+0x24/0x70 [ib_uverbs]
 uverbs_destroy_uobject+0x43/0x1b0 [ib_uverbs]
 uobj_destroy+0x41/0x70 [ib_uverbs]
 __uobj_get_destroy+0x39/0x70 [ib_uverbs]
 ib_uverbs_destroy_qp+0x88/0xc0 [ib_uverbs]
 ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xb9/0xf0 [ib_uverbs]
 ib_uverbs_cmd_verbs+0xb16/0xc30 [ib_uverbs]

The root cause is that the actual RDMA connection is not created in the
loopback tests and the rxe_match_dgid will fail randomly.

To fix this call trace which appear in the loopback tests, skip check
of the dgid.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 831ad578a7b2..46e111c218fd 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -330,10 +330,14 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)

 static int rxe_match_dgid(struct rxe_dev *rxe, struct sk_buff *skb)
 {
+	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 	const struct ib_gid_attr *gid_attr;
 	union ib_gid dgid;
 	union ib_gid *pdgid;

+	if (pkt->mask & RXE_LOOPBACK_MASK)
+		return 0;
+
 	if (skb->protocol == htons(ETH_P_IP)) {
 		ipv6_addr_set_v4mapped(ip_hdr(skb)->daddr,
 				       (struct in6_addr *)&dgid);
@@ -366,7 +370,7 @@ void rxe_rcv(struct sk_buff *skb)
 	if (unlikely(skb->len < pkt->offset + RXE_BTH_BYTES))
 		goto drop;

-	if (unlikely(rxe_match_dgid(rxe, skb) < 0)) {
+	if (rxe_match_dgid(rxe, skb) < 0) {
 		pr_warn_ratelimited("failed matching dgid\n");
 		goto drop;
 	}
--
2.26.2

