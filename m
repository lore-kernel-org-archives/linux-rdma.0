Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F4AC4332E
	for <linux-rdma@archiver.kernel.org>; Tue, 19 Jan 2021 13:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B09233EA
	for <linux-rdma@archiver.kernel.org>; Tue, 19 Jan 2021 13:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390259AbhASNLq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 19 Jan 2021 08:11:46 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11405 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387522AbhASJba (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 19 Jan 2021 04:31:30 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DKjzN73Bgz7XPd;
        Tue, 19 Jan 2021 17:29:36 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 19 Jan 2021 17:30:38 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH for-rc] RDMA/hns: Use mutex instead of spinlock for ida allocation
Date:   Tue, 19 Jan 2021 17:28:33 +0800
Message-ID: <1611048513-28663-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

GFP_KERNEL may cause ida_alloc_range() to sleep, but the spinlock covering
this function is not allowed to sleep, so the spinlock needs to be changed
to mutex.

As there is a certain chance of memory allocation failure, GFP_ATOMIC
is not suitable for QP allocation scenarios.

Fixes: 71586dd20010 ("RDMA/hns: Create QP with selected QPN for bank load balance")
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 55d5386..ad82532 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -532,7 +532,7 @@ struct hns_roce_qp_table {
 	struct hns_roce_hem_table	sccc_table;
 	struct mutex			scc_mutex;
 	struct hns_roce_bank bank[HNS_ROCE_QP_BANK_NUM];
-	spinlock_t bank_lock;
+	struct mutex bank_mutex;
 };
 
 struct hns_roce_cq_table {
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index d8e2fe5..1116371 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -209,7 +209,7 @@ static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 		hr_qp->doorbell_qpn = 1;
 	} else {
-		spin_lock(&qp_table->bank_lock);
+		mutex_lock(&qp_table->bank_mutex);
 		bankid = get_least_load_bankid_for_qp(qp_table->bank);
 
 		ret = alloc_qpn_with_bankid(&qp_table->bank[bankid], bankid,
@@ -217,12 +217,12 @@ static int alloc_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 		if (ret) {
 			ibdev_err(&hr_dev->ib_dev,
 				  "failed to alloc QPN, ret = %d\n", ret);
-			spin_unlock(&qp_table->bank_lock);
+			mutex_unlock(&qp_table->bank_mutex);
 			return ret;
 		}
 
 		qp_table->bank[bankid].inuse++;
-		spin_unlock(&qp_table->bank_lock);
+		mutex_unlock(&qp_table->bank_mutex);
 
 		hr_qp->doorbell_qpn = (u32)num;
 	}
@@ -408,9 +408,9 @@ static void free_qpn(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 	ida_free(&hr_dev->qp_table.bank[bankid].ida, hr_qp->qpn >> 3);
 
-	spin_lock(&hr_dev->qp_table.bank_lock);
+	mutex_lock(&hr_dev->qp_table.bank_mutex);
 	hr_dev->qp_table.bank[bankid].inuse--;
-	spin_unlock(&hr_dev->qp_table.bank_lock);
+	mutex_unlock(&hr_dev->qp_table.bank_mutex);
 }
 
 static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
@@ -1371,6 +1371,7 @@ int hns_roce_init_qp_table(struct hns_roce_dev *hr_dev)
 	unsigned int i;
 
 	mutex_init(&qp_table->scc_mutex);
+	mutex_init(&qp_table->bank_mutex);
 	xa_init(&hr_dev->qp_table_xa);
 
 	reserved_from_bot = hr_dev->caps.reserved_qps;
-- 
2.8.1

