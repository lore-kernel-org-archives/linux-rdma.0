Return-Path: <SRS0=iMHv=YI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32DCECE588
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 11:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A12D21925
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 11:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfJOLsO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:48:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3763 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728386AbfJOLsN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 15 Oct 2019 07:48:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8A3E82110A68FC938004;
        Tue, 15 Oct 2019 19:48:10 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 19:48:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/rds: Remove unnecessary null check
Date:   Tue, 15 Oct 2019 19:47:36 +0800
Message-ID: <20191015114736.16928-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Null check before dma_pool_destroy is redundant, so remove it.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/rds/ib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 62d4ebe..3fd5f40 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -108,8 +108,7 @@ static void rds_ib_dev_free(struct work_struct *work)
 		rds_ib_destroy_mr_pool(rds_ibdev->mr_1m_pool);
 	if (rds_ibdev->pd)
 		ib_dealloc_pd(rds_ibdev->pd);
-	if (rds_ibdev->rid_hdrs_pool)
-		dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
+	dma_pool_destroy(rds_ibdev->rid_hdrs_pool);
 
 	list_for_each_entry_safe(i_ipaddr, i_next, &rds_ibdev->ipaddr_list, list) {
 		list_del(&i_ipaddr->list);
-- 
2.7.4


