Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9D0C433ED
	for <linux-rdma@archiver.kernel.org>; Thu,  6 May 2021 08:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CED6611AE
	for <linux-rdma@archiver.kernel.org>; Thu,  6 May 2021 08:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhEFIzp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 6 May 2021 04:55:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17472 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbhEFIzp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 6 May 2021 04:55:45 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FbS4p5zYSzkWrH;
        Thu,  6 May 2021 16:52:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 6 May 2021 16:54:39 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jgg@ziepe.ca>, <leon@kernel.org>
CC:     <liweihang@huawei.com>, <liangwenpeng@huawei.com>,
        <shiju.jose@huawei.com>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH] RDMA/ucma: Cleanup to reduce duplicate code
Date:   Thu, 6 May 2021 16:51:46 +0800
Message-ID: <1620291106-3675-1-git-send-email-tanxiaofei@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The lable "err1" does the same thing as the branch of copy_to_user()
failed in the function ucma_create_id(). Just jump to the label directly
to reduce duplicate code.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 drivers/infiniband/core/ucma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 15d57ba..1f198c1 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -468,8 +468,8 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 	resp.id = ctx->id;
 	if (copy_to_user(u64_to_user_ptr(cmd.response),
 			 &resp, sizeof(resp))) {
-		ucma_destroy_private_ctx(ctx);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto err1;
 	}
 
 	mutex_lock(&file->mut);
-- 
2.8.1

