Return-Path: <SRS0=nSk8=VH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D858DC73C63
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 01:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA5620651
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 01:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfGJBv1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 9 Jul 2019 21:51:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfGJBv1 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 9 Jul 2019 21:51:27 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 48FCA33D463FEB7EBE02;
        Wed, 10 Jul 2019 09:51:24 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 10 Jul 2019
 09:51:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <bmt@zurich.ibm.com>, <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] RDMA/siw: Print error code while kthread_create failed
Date:   Wed, 10 Jul 2019 09:50:09 +0800
Message-ID: <20190710015009.57120-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

In iw_create_tx_threads(), if we failed to create kthread,
we should print the 'rv', this fix gcc warning:

drivers/infiniband/sw/siw/siw_main.c: In function 'siw_create_tx_threads':
drivers/infiniband/sw/siw/siw_main.c:91:11: warning:
 variable 'rv' set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/sw/siw/siw_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index fd2552a..2a70830d 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -101,7 +101,8 @@ static int siw_create_tx_threads(void)
 		if (IS_ERR(siw_tx_thread[cpu])) {
 			rv = PTR_ERR(siw_tx_thread[cpu]);
 			siw_tx_thread[cpu] = NULL;
-			pr_info("Creating TX thread for CPU %d failed", cpu);
+			pr_info("Creating TX thread for CPU%d failed %d\n",
+				cpu, rv);
 			continue;
 		}
 		kthread_bind(siw_tx_thread[cpu], cpu);
-- 
2.7.4


