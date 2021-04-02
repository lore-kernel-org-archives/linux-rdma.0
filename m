Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDCFC43470
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564D761008
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhDBJKV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:10:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14682 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhDBJKT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Apr 2021 05:10:19 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBZ2H4HXMznYCJ;
        Fri,  2 Apr 2021 17:07:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 17:10:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 3/9] RDMA/hns: Delete redundant condition judgment related to eq
Date:   Fri, 2 Apr 2021 17:07:28 +0800
Message-ID: <1617354454-47840-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617354454-47840-1-git-send-email-liweihang@huawei.com>
References: <1617354454-47840-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

The register value related to the eq interrupt depends only on enable_flag,
so the redundant condition judgment is deleted.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 570fd7d..807c90c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6058,31 +6058,16 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 }
 
 static void hns_roce_v2_int_mask_enable(struct hns_roce_dev *hr_dev,
-					int eq_num, int enable_flag)
+					int eq_num, u32 enable_flag)
 {
 	int i;
 
-	if (enable_flag == EQ_ENABLE) {
-		for (i = 0; i < eq_num; i++)
-			roce_write(hr_dev, ROCEE_VF_EVENT_INT_EN_REG +
-				   i * EQ_REG_OFFSET,
-				   HNS_ROCE_V2_VF_EVENT_INT_EN_M);
-
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG,
-			   HNS_ROCE_V2_VF_ABN_INT_EN_M);
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_CFG_REG,
-			   HNS_ROCE_V2_VF_ABN_INT_CFG_M);
-	} else {
-		for (i = 0; i < eq_num; i++)
-			roce_write(hr_dev, ROCEE_VF_EVENT_INT_EN_REG +
-				   i * EQ_REG_OFFSET,
-				   HNS_ROCE_V2_VF_EVENT_INT_EN_M & 0x0);
+	for (i = 0; i < eq_num; i++)
+		roce_write(hr_dev, ROCEE_VF_EVENT_INT_EN_REG +
+			   i * EQ_REG_OFFSET, enable_flag);
 
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG,
-			   HNS_ROCE_V2_VF_ABN_INT_EN_M & 0x0);
-		roce_write(hr_dev, ROCEE_VF_ABN_INT_CFG_REG,
-			   HNS_ROCE_V2_VF_ABN_INT_CFG_M & 0x0);
-	}
+	roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG, enable_flag);
+	roce_write(hr_dev, ROCEE_VF_ABN_INT_CFG_REG, enable_flag);
 }
 
 static void hns_roce_v2_destroy_eqc(struct hns_roce_dev *hr_dev, int eqn)
-- 
2.8.1

