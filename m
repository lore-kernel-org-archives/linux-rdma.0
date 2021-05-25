Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984A1C4708C
	for <linux-rdma@archiver.kernel.org>; Tue, 25 May 2021 06:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9E2610A2
	for <linux-rdma@archiver.kernel.org>; Tue, 25 May 2021 06:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhEYGxa (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 May 2021 02:53:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3936 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhEYGx3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 25 May 2021 02:53:29 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fq4S33nylzBvYF;
        Tue, 25 May 2021 14:49:07 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 14:51:58 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 25 May 2021 14:51:54 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH v3 for-next 05/13] RDMA/core: Use refcount_t instead of atomic_t on refcount of mcast_port
Date:   Tue, 25 May 2021 14:51:36 +0800
Message-ID: <1621925504-33019-6-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621925504-33019-1-git-send-email-liweihang@huawei.com>
References: <1621925504-33019-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The refcount_t API will WARN on underflow and overflow of a reference
counter, and avoid use-after-free risks.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/core/multicast.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index de134a4..a236532 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -61,7 +61,7 @@ struct mcast_port {
 	struct mcast_device	*dev;
 	spinlock_t		lock;
 	struct rb_root		table;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	comp;
 	u32			port_num;
 };
@@ -178,7 +178,7 @@ static struct mcast_group *mcast_insert(struct mcast_port *port,
 
 static void deref_port(struct mcast_port *port)
 {
-	if (atomic_dec_and_test(&port->refcount))
+	if (refcount_dec_and_test(&port->refcount))
 		complete(&port->comp);
 }
 
@@ -589,7 +589,7 @@ static struct mcast_group *acquire_group(struct mcast_port *port,
 		kfree(group);
 		group = cur_group;
 	} else
-		atomic_inc(&port->refcount);
+		refcount_inc(&port->refcount);
 found:
 	atomic_inc(&group->refcount);
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -840,7 +840,7 @@ static int mcast_add_one(struct ib_device *device)
 		spin_lock_init(&port->lock);
 		port->table = RB_ROOT;
 		init_completion(&port->comp);
-		atomic_set(&port->refcount, 1);
+		refcount_set(&port->refcount, 1);
 		++count;
 	}
 
-- 
2.7.4

