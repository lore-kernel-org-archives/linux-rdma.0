Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E68C433ED
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 08:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB81613DE
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 08:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhDFIhl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Apr 2021 04:37:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15490 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244404AbhDFIhk (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Apr 2021 04:37:40 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF17F4CnyzwRNp;
        Tue,  6 Apr 2021 16:35:21 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 16:37:23 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next] RDMA/core: Flush workqueue before destroy it
Date:   Tue, 6 Apr 2021 16:34:51 +0800
Message-ID: <1617698091-47439-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

It is safer to flush the workqueue before destroying it.

Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/core/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0abce00..e58a06b 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -883,6 +883,7 @@ int addr_init(void)
 void addr_cleanup(void)
 {
 	unregister_netevent_notifier(&nb);
+	flush_workqueue(addr_wq);
 	destroy_workqueue(addr_wq);
 	WARN_ON(!list_empty(&req_list));
 }
-- 
2.8.1

