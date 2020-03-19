Return-Path: <SRS0=gM5Z=5E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA7AC41620
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2235720658
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgCSN3I (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:29:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729236AbgCSN3I (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Mar 2020 09:29:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F2D9C81C967C2ED411C7;
        Thu, 19 Mar 2020 21:28:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Mar 2020 21:28:42 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 03/11] RDMA/hns: Check return value of kmalloc with macro
Date:   Thu, 19 Mar 2020 21:24:50 +0800
Message-ID: <1584624298-23841-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1584624298-23841-1-git-send-email-liweihang@huawei.com>
References: <1584624298-23841-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

As the return value of kmalloc may be null or error code, use kernel macro
to do return value check.

Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.c b/drivers/infiniband/hw/hns/hns_roce_cmd.c
index 455d533..d52311a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
@@ -268,7 +268,7 @@ struct hns_roce_cmd_mailbox
 	struct hns_roce_cmd_mailbox *mailbox;
 
 	mailbox = kmalloc(sizeof(*mailbox), GFP_KERNEL);
-	if (!mailbox)
+	if (IS_ERR_OR_NULL(mailbox))
 		return ERR_PTR(-ENOMEM);
 
 	mailbox->buf = dma_pool_alloc(hr_dev->cmd.pool, GFP_KERNEL,
-- 
2.8.1

