Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7BBC433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Feb 2021 08:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4533C64E92
	for <linux-rdma@archiver.kernel.org>; Mon, 22 Feb 2021 08:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBVI0F (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:26:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12632 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBVIZ7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 22 Feb 2021 03:25:59 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DkZvf4sBlz16BKQ;
        Mon, 22 Feb 2021 16:23:42 +0800 (CST)
Received: from localhost (10.174.179.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Mon, 22 Feb 2021
 16:25:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <leon@kernel.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <yishaih@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] IB/mlx5: Add missing error code
Date:   Mon, 22 Feb 2021 16:25:03 +0800
Message-ID: <20210222082503.22388-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.96]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Set err to -ENOMEM if kzalloc fails instead of 0.

Fixes: 759738537142 ("IB/mlx5: Enable subscription for device events over DEVX")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index ebc2a4355fa5..3c8e6a25465d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2073,8 +2073,10 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 
 		num_alloc_xa_entries++;
 		event_sub = kzalloc(sizeof(*event_sub), GFP_KERNEL);
-		if (!event_sub)
+		if (!event_sub) {
+			err = -ENOMEM
 			goto err;
+		}
 
 		list_add_tail(&event_sub->event_list, &sub_list);
 		uverbs_uobject_get(&ev_file->uobj);
-- 
2.20.1

