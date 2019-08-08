Return-Path: <SRS0=Pj7p=WE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9388C0650F
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 14:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABCC21874
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Aug 2019 14:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733119AbfHHO6P (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Aug 2019 10:58:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732667AbfHHO6O (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 8 Aug 2019 10:58:14 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5E32F952AFA308A9F81D;
        Thu,  8 Aug 2019 22:58:12 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 8 Aug 2019 22:58:06 +0800
From:   Lijun Ou <oulijun@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH V4 for-next 05/14] RDMA/hns: Clean up unnecessary initial assignment
Date:   Thu, 8 Aug 2019 22:53:45 +0800
Message-ID: <1565276034-97329-6-git-send-email-oulijun@huawei.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1565276034-97329-1-git-send-email-oulijun@huawei.com>
References: <1565276034-97329-1-git-send-email-oulijun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

Here remove some unncessary initialization for some valiables.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
---
V3->V4:
1. Remove the unnecessary whitespace
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index eedafd6..2bb2d0c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -239,7 +239,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_v2_db sq_db;
 	struct ib_qp_attr attr;
-	unsigned int sge_ind = 0;
+	unsigned int sge_ind;
 	unsigned int owner_bit;
 	unsigned long flags;
 	unsigned int ind;
@@ -4291,7 +4291,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	struct hns_roce_v2_qp_context *context;
 	struct hns_roce_v2_qp_context *qpc_mask;
 	struct device *dev = hr_dev->dev;
-	int ret = -EINVAL;
+	int ret;
 
 	context = kcalloc(2, sizeof(*context), GFP_ATOMIC);
 	if (!context)
-- 
1.9.1

