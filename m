Return-Path: <SRS0=/r8L=Y6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E02EC5DF64
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 03:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1562053B
	for <linux-rdma@archiver.kernel.org>; Wed,  6 Nov 2019 03:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbfKFDRS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 5 Nov 2019 22:17:18 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:47980 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730576AbfKFDRS (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 5 Nov 2019 22:17:18 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E6DAB69401FDE45F494;
        Wed,  6 Nov 2019 11:17:12 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 6 Nov 2019
 11:17:05 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>,
        <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <linux-rdma@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] RDMA/core: make function rdma_user_mmap_entry_free static
Date:   Wed, 6 Nov 2019 11:24:17 +0800
Message-ID: <1573010657-11997-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fix sparse warnings:

drivers/infiniband/core/ib_core_uverbs.c:149:6: warning: symbol 'rdma_user_mmap_entry_free' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/infiniband/core/ib_core_uverbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
index 88d9d47..62eebad 100644
--- a/drivers/infiniband/core/ib_core_uverbs.c
+++ b/drivers/infiniband/core/ib_core_uverbs.c
@@ -146,7 +146,7 @@ rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key,
 }
 EXPORT_SYMBOL(rdma_user_mmap_entry_get);

-void rdma_user_mmap_entry_free(struct kref *kref)
+static void rdma_user_mmap_entry_free(struct kref *kref)
 {
 	struct rdma_user_mmap_entry *entry =
 		container_of(kref, struct rdma_user_mmap_entry, ref);
--
2.7.4

