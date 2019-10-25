Return-Path: <SRS0=Cj4f=YS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6839CCA9EA0
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Oct 2019 12:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 471AB21D71
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Oct 2019 12:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391200AbfJYMeq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Oct 2019 08:34:46 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:24101 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfJYMeq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 25 Oct 2019 08:34:46 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x9PCYfbU013247;
        Fri, 25 Oct 2019 05:34:42 -0700
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com,
        nirranjan@chelsio.com, Dakshaja Uppalapati <dakshaja@chelsio.com>
Subject: [PATCH for-rc] iw_cxgb4: avoid freeing skb twice in arp failure case
Date:   Fri, 25 Oct 2019 18:04:40 +0530
Message-Id: <1572006880-5800-1-git-send-email-bharat@chelsio.com>
X-Mailer: git-send-email 2.3.9
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

_put_ep_safe() and _put_pass_ep_safe() free the skb before it is freed by
process_work(). fix double free by freeing the skb only in process_work().

Fixes: 1dad0ebeea1c ("iw_cxgb4: Avoid touch after free error in ARP failure handlers")
Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e87fc0408470..8333442380d5 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -495,7 +495,6 @@ static int _put_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	release_ep_resources(ep);
-	kfree_skb(skb);
 	return 0;
 }
 
@@ -506,7 +505,6 @@ static int _put_pass_ep_safe(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = *((struct c4iw_ep **)(skb->cb + 2 * sizeof(void *)));
 	c4iw_put_ep(&ep->parent_ep->com);
 	release_ep_resources(ep);
-	kfree_skb(skb);
 	return 0;
 }
 
-- 
2.3.9

