Return-Path: <SRS0=uoZ+=CQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA98C433E2
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 17:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D44206B8
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 17:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgIGRTw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:19:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729701AbgIGNyM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Sep 2020 09:54:12 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F24471E2F5BB58652730;
        Mon,  7 Sep 2020 21:38:01 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 21:37:55 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 6/9] RDMA/hns: Solve the overflow of the calc_pg_sz()
Date:   Mon, 7 Sep 2020 21:36:45 +0800
Message-ID: <1599485808-29940-7-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599485808-29940-1-git-send-email-liweihang@huawei.com>
References: <1599485808-29940-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

calc_pg_sz() may gets a data calculation overflow if the PAGE_SIZE is 64 KB
and hop_num is 2. It is because that all variables involved in calculation
are defined in type of int. So change the type of bt_chunk_size,
buf_chunk_size and obj_per_chunk_default to u64.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 07e3e3c..8690151 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1801,9 +1801,9 @@ static void calc_pg_sz(int obj_num, int obj_size, int hop_num, int ctx_bt_num,
 		       int *buf_page_size, int *bt_page_size, u32 hem_type)
 {
 	u64 obj_per_chunk;
-	int bt_chunk_size = 1 << PAGE_SHIFT;
-	int buf_chunk_size = 1 << PAGE_SHIFT;
-	int obj_per_chunk_default = buf_chunk_size / obj_size;
+	u64 bt_chunk_size = 1 << PAGE_SHIFT;
+	u64 buf_chunk_size = 1 << PAGE_SHIFT;
+	u64 obj_per_chunk_default = buf_chunk_size / obj_size;
 
 	*buf_page_size = 0;
 	*bt_page_size = 0;
-- 
2.8.1

