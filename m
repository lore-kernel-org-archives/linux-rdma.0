Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBF1C433ED
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C53B60FF3
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhDBJKS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:10:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14678 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbhDBJKR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Apr 2021 05:10:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBZ2H3mlfznY8M;
        Fri,  2 Apr 2021 17:07:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 17:10:06 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 6/9] RDMA/hns: Remove unsupported QP types
Date:   Fri, 2 Apr 2021 17:07:31 +0800
Message-ID: <1617354454-47840-7-git-send-email-liweihang@huawei.com>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

The hns ROCEE does not support UC QP currently.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 3 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 -
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index e5f7c2e..8a3fe6d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3449,8 +3449,7 @@ static int hns_roce_v1_q_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 				   ((roce_get_bit(context->qpc_bytes_4,
 			QP_CONTEXT_QPC_BYTE_4_ATOMIC_OPERATION_ENABLE_S)) << 3);
 
-	if (hr_qp->ibqp.qp_type == IB_QPT_RC ||
-	    hr_qp->ibqp.qp_type == IB_QPT_UC) {
+	if (hr_qp->ibqp.qp_type == IB_QPT_RC) {
 		struct ib_global_route *grh =
 			rdma_ah_retrieve_grh(&qp_attr->ah_attr);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a0d2448..8e15ad8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5324,7 +5324,6 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 				    V2_QPC_BYTE_76_ATE_S)) << V2_QP_ATE_S);
 
 	if (hr_qp->ibqp.qp_type == IB_QPT_RC ||
-	    hr_qp->ibqp.qp_type == IB_QPT_UC ||
 	    hr_qp->ibqp.qp_type == IB_QPT_XRC_INI ||
 	    hr_qp->ibqp.qp_type == IB_QPT_XRC_TGT) {
 		struct ib_global_route *grh =
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index f214bd0..230a909 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1189,8 +1189,6 @@ int to_hr_qp_type(int qp_type)
 	switch (qp_type) {
 	case IB_QPT_RC:
 		return SERV_TYPE_RC;
-	case IB_QPT_UC:
-		return SERV_TYPE_UC;
 	case IB_QPT_UD:
 	case IB_QPT_GSI:
 		return SERV_TYPE_UD;
-- 
2.8.1

