Return-Path: <SRS0=BxIS=BH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB5DC433E5
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Jul 2020 10:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9372B20775
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Jul 2020 10:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgG1KnT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Jul 2020 06:43:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728636AbgG1KnT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 28 Jul 2020 06:43:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 99987A2592D0A30DD6FB;
        Tue, 28 Jul 2020 18:43:16 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 18:43:10 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 6/7] RDMA/hns: Fix error during modify qp RTS2RTS
Date:   Tue, 28 Jul 2020 18:42:20 +0800
Message-ID: <1595932941-40613-7-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1595932941-40613-1-git-send-email-liweihang@huawei.com>
References: <1595932941-40613-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

One qp state migrations legal configuration was deleted mistakenly.

Fixes: 357f34294686 ("RDMA/hns: Simplify the state judgment code of qp")
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9d64804..0c81100 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4262,7 +4262,9 @@ static bool check_qp_state(enum ib_qp_state cur_state,
 		[IB_QPS_RTR] = { [IB_QPS_RESET] = true,
 				 [IB_QPS_RTS] = true,
 				 [IB_QPS_ERR] = true },
-		[IB_QPS_RTS] = { [IB_QPS_RESET] = true, [IB_QPS_ERR] = true },
+		[IB_QPS_RTS] = { [IB_QPS_RESET] = true,
+				 [IB_QPS_RTS] = true,
+				 [IB_QPS_ERR] = true },
 		[IB_QPS_SQD] = {},
 		[IB_QPS_SQE] = {},
 		[IB_QPS_ERR] = { [IB_QPS_RESET] = true, [IB_QPS_ERR] = true }
-- 
2.8.1

