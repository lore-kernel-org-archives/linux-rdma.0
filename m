Return-Path: <SRS0=XFIj=5F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFDAC4332B
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 03:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32322070A
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 03:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCTD1l (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:27:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726834AbgCTD1k (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Mar 2020 23:27:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7294F23B136F2D4A1F0F;
        Fri, 20 Mar 2020 11:27:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Mar 2020 11:27:27 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 07/10] RDMA/hns: Remove meaningless prints
Date:   Fri, 20 Mar 2020 11:23:39 +0800
Message-ID: <1584674622-52773-8-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1584674622-52773-1-git-send-email-liweihang@huawei.com>
References: <1584674622-52773-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

ceq and aeq is a ring buffer, consumer index of them will be set to zero
after reaching the maximum value. The warning should be removed or it may
mislead the users.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 9 ++-------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +----
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 2e53045..5ff028d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3935,10 +3935,8 @@ static int hns_roce_v1_aeq_int(struct hns_roce_dev *hr_dev,
 		eq->cons_index++;
 		aeqes_found = 1;
 
-		if (eq->cons_index > 2 * hr_dev->caps.aeqe_depth - 1) {
-			dev_warn(dev, "cons_index overflow, set back to 0.\n");
+		if (eq->cons_index > 2 * hr_dev->caps.aeqe_depth - 1)
 			eq->cons_index = 0;
-		}
 	}
 
 	set_eq_cons_index_v1(eq, 0);
@@ -3988,11 +3986,8 @@ static int hns_roce_v1_ceq_int(struct hns_roce_dev *hr_dev,
 		ceqes_found = 1;
 
 		if (eq->cons_index >
-		    EQ_DEPTH_COEFF * hr_dev->caps.ceqe_depth - 1) {
-			dev_warn(&eq->hr_dev->pdev->dev,
-				"cons_index overflow, set back to 0.\n");
+		    EQ_DEPTH_COEFF * hr_dev->caps.ceqe_depth - 1)
 			eq->cons_index = 0;
-		}
 	}
 
 	set_eq_cons_index_v1(eq, 0);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index aff7c5d..bd14e71 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5361,7 +5361,6 @@ static struct hns_roce_ceqe *next_ceqe_sw_v2(struct hns_roce_eq *eq)
 static int hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_eq *eq)
 {
-	struct device *dev = hr_dev->dev;
 	struct hns_roce_ceqe *ceqe = next_ceqe_sw_v2(eq);
 	int ceqe_found = 0;
 	u32 cqn;
@@ -5380,10 +5379,8 @@ static int hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
 		++eq->cons_index;
 		ceqe_found = 1;
 
-		if (eq->cons_index > (EQ_DEPTH_COEFF * eq->entries - 1)) {
-			dev_warn(dev, "cons_index overflow, set back to 0.\n");
+		if (eq->cons_index > (EQ_DEPTH_COEFF * eq->entries - 1))
 			eq->cons_index = 0;
-		}
 
 		ceqe = next_ceqe_sw_v2(eq);
 	}
-- 
2.8.1

