Return-Path: <SRS0=ZuZ5=V5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41664C433FF
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 08:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EBEA2087E
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 08:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfHAId2 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Aug 2019 04:33:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730280AbfHAId2 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Aug 2019 04:33:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2AAD611FFF5FB4155AB5;
        Thu,  1 Aug 2019 16:33:23 +0800 (CST)
Received: from linux-ioko.site (10.71.200.31) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 16:33:15 +0800
From:   Lijun Ou <oulijun@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH V2 for-next 12/13] RDMA/hns: Remove redundant print in hns_roce_v2_ceq_int()
Date:   Thu, 1 Aug 2019 16:29:13 +0800
Message-ID: <1564648154-123172-13-git-send-email-oulijun@huawei.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564648154-123172-1-git-send-email-oulijun@huawei.com>
References: <1564648154-123172-1-git-send-email-oulijun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.71.200.31]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

There is no need to tell users when eq->cons_index is overflow, we
just set it back to zero.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8244540..5cc64da 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5009,10 +5009,9 @@ static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 		++eq->cons_index;
 		aeqe_found = 1;
 
-		if (eq->cons_index > (2 * eq->entries - 1)) {
-			dev_warn(dev, "cons_index overflow, set back to 0.\n");
+		if (eq->cons_index > (2 * eq->entries - 1))
 			eq->cons_index = 0;
-		}
+
 		hns_roce_v2_init_irq_work(hr_dev, eq, qpn, cqn);
 
 		aeqe = next_aeqe_sw_v2(eq);
-- 
1.9.1

