Return-Path: <SRS0=HFDa=6S=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C6EC3A5A9
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E721D20746
	for <linux-rdma@archiver.kernel.org>; Mon,  4 May 2020 05:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588569589;
	bh=ObOBH3lTBTjIdfxDCx9vx104ShIZc/GciHmNhHy20Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h8q5BD+LpKAMB9zOvbCl7xZ4xXg9LnKavrwnhEB3Gi8LM1FN4+I4Crl02rYkKBbeh
	 TDTSkaPXRBIYxcd7l6jXZ3RcbDAwKuOOsdhC5PSeLRrejSonHyMWvyXvrBhurSmaXy
	 LVi7jHlKqrEDHlLRsRXAqukjPxg7zAbjr/Y4Lgks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEDFTt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 4 May 2020 01:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgEDFTs (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 4 May 2020 01:19:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A614A20735;
        Mon,  4 May 2020 05:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588569588;
        bh=ObOBH3lTBTjIdfxDCx9vx104ShIZc/GciHmNhHy20Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9p/9gj8RtBGdZGVhiTiCMKpMNLjEZCHJc0u/jAVBINMyS5FzARHgmj96a5B1wb33
         iHUg+sHErMA06gBQIDyjOdjflPcU3Cqrys0k8WrcykjKiP0lYxiiXTT8wnxH2Felgk
         s2Si9+tgYQCtIC345iUCxQACHRwl8ENbxAI873ys=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next v3 2/5] RDMA/core: Consider flow label when building skb
Date:   Mon,  4 May 2020 08:19:32 +0300
Message-Id: <20200504051935.269708-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504051935.269708-1-leon@kernel.org>
References: <20200504051935.269708-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Use rdma_flow_label_to_udp_sport to calculate the UDP source port
of the RoCEV2 packet.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/lag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index a29533626a7c..7063e41eaf26 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -34,7 +34,8 @@ static struct sk_buff *rdma_build_skb(struct ib_device *device,
 	skb_push(skb, sizeof(struct udphdr));
 	skb_reset_transport_header(skb);
 	uh = udp_hdr(skb);
-	uh->source = htons(0xC000);
+	uh->source =
+		htons(rdma_flow_label_to_udp_sport(ah_attr->grh.flow_label));
 	uh->dest = htons(ROCE_V2_UDP_DPORT);
 	uh->len = htons(sizeof(struct udphdr));
 
@@ -114,7 +115,8 @@ struct net_device *rdma_lag_get_ah_roce_slave(struct ib_device *device,
 	struct net_device *master;
 
 	if (!(ah_attr->type == RDMA_AH_ATTR_TYPE_ROCE &&
-	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP))
+	      ah_attr->grh.sgid_attr->gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP &&
+	      ah_attr->grh.flow_label))
 		return NULL;
 
 	rcu_read_lock();
-- 
2.26.2

