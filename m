Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5103C433E0
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Mar 2021 09:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B115B64F53
	for <linux-rdma@archiver.kernel.org>; Fri, 19 Mar 2021 09:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCSJ6t (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 19 Mar 2021 05:58:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14098 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCSJ61 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 19 Mar 2021 05:58:27 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1zn75JZlz19GgH;
        Fri, 19 Mar 2021 17:56:27 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 17:58:12 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next] RDMA/core: Correct misspellings of two words in comments
Date:   Fri, 19 Mar 2021 17:55:49 +0800
Message-ID: <1616147749-49106-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

Correct the following spelling errors:
1. shold -> should
2. uncontext -> ucontext

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/core/rdma_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 75eafd9..94d83b6 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -112,7 +112,7 @@ static void assert_uverbs_usecnt(struct ib_uobject *uobj,
  * however the type's allocat_commit function cannot have been called and the
  * uobject cannot be on the uobjects_lists
  *
- * For RDMA_REMOVE_DESTROY the caller shold be holding a kref (eg via
+ * For RDMA_REMOVE_DESTROY the caller should be holding a kref (eg via
  * rdma_lookup_get_uobject) and the object is left in a state where the caller
  * needs to call rdma_lookup_put_uobject.
  *
@@ -916,7 +916,7 @@ static int __uverbs_cleanup_ufile(struct ib_uverbs_file *ufile,
 }
 
 /*
- * Destroy the uncontext and every uobject associated with it.
+ * Destroy the ucontext and every uobject associated with it.
  *
  * This is internally locked and can be called in parallel from multiple
  * contexts.
-- 
2.8.1

