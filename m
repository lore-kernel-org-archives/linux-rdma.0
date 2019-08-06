Return-Path: <SRS0=BMee=WC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0E0C32751
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 21:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769F42189D
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565127990;
	bh=SUeVgyj9KGoSJ+/rEsQbWqM3p6Wy0GHD60j0+1FUhQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ItR+GxRsxosjfnirOLRsn5ds4X4DWuPywLL7mAYtfodCxi/44ef6cOXnHdKS+eNnL
	 qYptEY8bbzIsvuA8VTZIdWzt08GOJa7RBW/pQEzWQQWRQahbXBCeL3d+StlCRYOvPN
	 8CtBMF4Y81uKsVIznSWwa/y/cAklv4qFwjzZ87TQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfHFVdX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Aug 2019 17:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfHFVdX (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B561621743;
        Tue,  6 Aug 2019 21:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127202;
        bh=SUeVgyj9KGoSJ+/rEsQbWqM3p6Wy0GHD60j0+1FUhQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKazNVjHT/NKB7fUA3OpJ/X1J3O1TNHkHes+u8G+G2Mub8DE+G7ccSneDnYJ/5z8o
         LA19c6dmZ0u7SO//CQXVXfS9tp9leJLcG8yJHoCdzJeHg0zLNONi9/XEfZ+24qs5Wj
         b2RKcmeepSIv+nH+s1EpEa5GjaXHzGimHzbXzkTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/59] IB/mlx5: Replace kfree with kvfree
Date:   Tue,  6 Aug 2019 17:32:22 -0400
Message-Id: <20190806213319.19203-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit b7f406bb883ba7ac3222298f6b44cebc4cfe2dde ]

Memory allocated by kvzalloc should not be freed by kfree(), use kvfree()
instead.

Fixes: 813e90b1aeaa ("IB/mlx5: Add advise_mr() support")
Link: https://lore.kernel.org/r/20190717082101.14196-1-hslester96@gmail.com
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 91507a2e92900..f6e5351ba4d50 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1765,7 +1765,7 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *work)
 
 	num_pending_prefetch_dec(to_mdev(w->pd->device), w->sg_list,
 				 w->num_sge, 0);
-	kfree(w);
+	kvfree(w);
 }
 
 int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
@@ -1807,7 +1807,7 @@ int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 	if (valid_req)
 		queue_work(system_unbound_wq, &work->work);
 	else
-		kfree(work);
+		kvfree(work);
 
 	srcu_read_unlock(&dev->mr_srcu, srcu_key);
 
-- 
2.20.1

