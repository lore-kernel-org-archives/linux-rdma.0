Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D87C4332B
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Dec 2020 13:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C607620771
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Dec 2020 13:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgL2Nww (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Dec 2020 08:52:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9699 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgL2Nwv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 29 Dec 2020 08:52:51 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D4wmV4rCgzkxsX;
        Tue, 29 Dec 2020 21:50:50 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:51:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] RDMA/rw: Use kzalloc for allocating only one thing
Date:   Tue, 29 Dec 2020 21:52:23 +0800
Message-ID: <20201229135223.23815-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/infiniband/core/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 13f43ab7220b..a41413c51609 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -407,7 +407,7 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 
 	ctx->type = RDMA_RW_SIG_MR;
 	ctx->nr_ops = 1;
-	ctx->reg = kcalloc(1, sizeof(*ctx->reg), GFP_KERNEL);
+	ctx->reg = kzalloc(sizeof(*ctx->reg), GFP_KERNEL);
 	if (!ctx->reg) {
 		ret = -ENOMEM;
 		goto out_unmap_prot_sg;
-- 
2.22.0

