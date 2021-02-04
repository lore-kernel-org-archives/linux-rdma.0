Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F33BC433DB
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Feb 2021 06:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0727B64E31
	for <linux-rdma@archiver.kernel.org>; Thu,  4 Feb 2021 06:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhBDG0D (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Feb 2021 01:26:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12392 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBDG0D (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 4 Feb 2021 01:26:03 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DWT5v1Rh9z7gc6;
        Thu,  4 Feb 2021 14:24:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 14:25:20 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH for-next 3/6] RDMA/hns: Fixes missing error code of CMDQ
Date:   Thu, 4 Feb 2021 14:23:03 +0800
Message-ID: <1612419786-39173-4-git-send-email-liweihang@huawei.com>
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

When posting a multi-descriptors command, the error code of previous failed
descriptors may be rewrote to 0 by a later successful descriptor.

Fixes: a04ff739f2a9 ("RDMA/hns: Add command queue support for hip08 RoCE driver")
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 260c17c..13f7897 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1245,7 +1245,7 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	u32 timeout = 0;
 	int handle = 0;
 	u16 desc_ret;
-	int ret = 0;
+	int ret;
 	int ntc;
 
 	spin_lock_bh(&csq->lock);
@@ -1283,15 +1283,14 @@ static int __hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 
 	if (hns_roce_cmq_csq_done(hr_dev)) {
 		handle = 0;
+		ret = 0;
 		while (handle < num) {
 			/* get the result of hardware write back */
 			desc_to_use = &csq->desc[ntc];
 			desc[handle] = *desc_to_use;
 			dev_dbg(hr_dev->dev, "Get cmq desc:\n");
 			desc_ret = le16_to_cpu(desc[handle].retval);
-			if (desc_ret == CMD_EXEC_SUCCESS)
-				ret = 0;
-			else
+			if (unlikely(desc_ret != CMD_EXEC_SUCCESS))
 				ret = -EIO;
 
 			ntc++;
-- 
2.8.1

