Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC1DC433ED
	for <linux-rdma@archiver.kernel.org>; Wed, 12 May 2021 10:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887D4613C3
	for <linux-rdma@archiver.kernel.org>; Wed, 12 May 2021 10:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhELKHE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 12 May 2021 06:07:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2653 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhELKHD (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 12 May 2021 06:07:03 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fg9Nb3FZqzldC9;
        Wed, 12 May 2021 18:03:43 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 18:05:45 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Leon Romanovsky" <leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 1/2] RDMA/cm: Delete two redundant condition branches
Date:   Wed, 12 May 2021 18:05:36 +0800
Message-ID: <20210512100537.6273-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210512100537.6273-1-thunder.leizhen@huawei.com>
References: <20210512100537.6273-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The statement of the last "if (xxx)" branch is the same as the "else"
branch. Delete it to simplify code.

No functional change.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/infiniband/core/cm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 0ead0d223154011..510beb25f5b8a0b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -668,8 +668,6 @@ static struct cm_id_private *cm_insert_listen(struct cm_id_private *cm_id_priv,
 			link = &(*link)->rb_right;
 		else if (be64_lt(service_id, cur_cm_id_priv->id.service_id))
 			link = &(*link)->rb_left;
-		else if (be64_gt(service_id, cur_cm_id_priv->id.service_id))
-			link = &(*link)->rb_right;
 		else
 			link = &(*link)->rb_right;
 	}
@@ -700,8 +698,6 @@ static struct cm_id_private *cm_find_listen(struct ib_device *device,
 			node = node->rb_right;
 		else if (be64_lt(service_id, cm_id_priv->id.service_id))
 			node = node->rb_left;
-		else if (be64_gt(service_id, cm_id_priv->id.service_id))
-			node = node->rb_right;
 		else
 			node = node->rb_right;
 	}
-- 
2.26.0.106.g9fadedd


