Return-Path: <SRS0=pRdt=V7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFBEC31E40
	for <linux-rdma@archiver.kernel.org>; Sat,  3 Aug 2019 08:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5317F21783
	for <linux-rdma@archiver.kernel.org>; Sat,  3 Aug 2019 08:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbfHCItf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 3 Aug 2019 04:49:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387809AbfHCIte (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 3 Aug 2019 04:49:34 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A5845A169AFB743E9C37;
        Sat,  3 Aug 2019 16:49:30 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 3 Aug 2019 16:49:22 +0800
From:   Lijun Ou <oulijun@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH V3 for-next 05/13] RDMA/hns: Clean up unnecessary initial assignment
Date:   Sat, 3 Aug 2019 16:45:11 +0800
Message-ID: <1564821919-100676-6-git-send-email-oulijun@huawei.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564821919-100676-1-git-send-email-oulijun@huawei.com>
References: <1564821919-100676-1-git-send-email-oulijun@huawei.com>
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
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 455b08c..88e96c1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -239,7 +239,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_v2_db sq_db;
 	struct ib_qp_attr attr;
-	unsigned int sge_ind = 0;
+	unsigned int sge_ind ;
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

