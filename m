Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BBAC433DB
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Feb 2021 06:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D39AF64E31
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Feb 2021 06:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBDG0J (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Feb 2021 01:26:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12395 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhBDG0F (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 4 Feb 2021 01:26:05 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DWT5v1hT0z7gcT;
        Thu,  4 Feb 2021 14:24:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 14:25:19 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH for-next 1/6] RDMA/hns: Remove unused member and variable of CMDQ
Date:   Thu, 4 Feb 2021 14:23:01 +0800
Message-ID: <1612419786-39173-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612419786-39173-1-git-send-email-liweihang@huawei.com>
References: <1612419786-39173-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

last_status of structure hns_roce_v2_cmq has never been used, and the
variable named 'complete' in __hns_roce_cmq_send() is meaningless.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 +++------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 1 -
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a5bbfb1..7a5a41d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1243,7 +1243,6 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
 	struct hns_roce_cmq_desc *desc_to_use;
-	bool complete = false;
 	u32 timeout = 0;
 	int handle = 0;
 	u16 desc_ret;
@@ -1290,7 +1289,6 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	}
 
 	if (hns_roce_cmq_csq_done(hr_dev)) {
-		complete = true;
 		handle = 0;
 		while (handle < num) {
 			/* get the result of hardware write back */
@@ -1302,16 +1300,15 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 				ret = 0;
 			else
 				ret = -EIO;
-			priv->cmq.last_status = desc_ret;
+
 			ntc++;
 			handle++;
 			if (ntc == csq->desc_num)
 				ntc = 0;
 		}
-	}
-
-	if (!complete)
+	} else {
 		ret = -EAGAIN;
+	}
 
 	/* clean the command send queue */
 	handle = hns_roce_cmq_csq_clean(hr_dev);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 69bc072..9f97e32 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1839,7 +1839,6 @@ struct hns_roce_v2_cmq {
 	struct hns_roce_v2_cmq_ring csq;
 	struct hns_roce_v2_cmq_ring crq;
 	u16 tx_timeout;
-	u16 last_status;
 };
 
 enum hns_roce_link_table_type {
-- 
2.8.1

