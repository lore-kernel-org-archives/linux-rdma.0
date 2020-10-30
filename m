Return-Path: <SRS0=ZJsx=EF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEC9C4363A
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 11:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF73221EB
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 11:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgJ3LlP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:41:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7111 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJ3LlO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 30 Oct 2020 07:41:14 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CN0kZ40J9zLr1v;
        Fri, 30 Oct 2020 19:41:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 30 Oct 2020 19:41:01 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 7/8] RDMA/hns: Add UD support for HIP09
Date:   Fri, 30 Oct 2020 19:39:34 +0800
Message-ID: <1604057975-23388-8-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604057975-23388-1-git-send-email-liweihang@huawei.com>
References: <1604057975-23388-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

HIP09 supports service type of Unreliable Datagram, add necessary process
to enable this feature.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 8 +++++---
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 9a032d0..23f8fe7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -222,7 +222,9 @@ enum {
 	HNS_ROCE_CAP_FLAG_FRMR                  = BIT(8),
 	HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL		= BIT(9),
 	HNS_ROCE_CAP_FLAG_ATOMIC		= BIT(10),
+	HNS_ROCE_CAP_FLAG_UD			= BIT(11),
 	HNS_ROCE_CAP_FLAG_SDI_MODE		= BIT(14),
+
 };
 
 #define HNS_ROCE_DB_TYPE_COUNT			2
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ab68e6b..29cbf9f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -701,7 +701,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 		       ~(((qp->sq.head + nreq) >> ilog2(qp->sq.wqe_cnt)) & 0x1);
 
 		/* Corresponding to the QP type, wqe process separately */
-		if (ibqp->qp_type == IB_QPT_GSI)
+		if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_UD)
 			ret = set_ud_wqe(qp, wr, wqe, &sge_idx, owner_bit);
 		else if (ibqp->qp_type == IB_QPT_RC)
 			ret = set_rc_wqe(qp, wr, wqe, &sge_idx, owner_bit);
@@ -1892,7 +1892,7 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->flags |= HNS_ROCE_CAP_FLAG_ATOMIC | HNS_ROCE_CAP_FLAG_MW |
 		       HNS_ROCE_CAP_FLAG_SRQ | HNS_ROCE_CAP_FLAG_FRMR |
-		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL;
+		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL | HNS_ROCE_CAP_FLAG_UD;
 
 	caps->num_qpc_timer	  = HNS_ROCE_V2_MAX_QPC_TIMER_NUM;
 	caps->qpc_timer_entry_sz  = HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ;
@@ -5157,7 +5157,9 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 	unsigned long flags;
 	int ret = 0;
 
-	if (hr_qp->ibqp.qp_type == IB_QPT_RC && hr_qp->state != IB_QPS_RESET) {
+	if ((hr_qp->ibqp.qp_type == IB_QPT_RC ||
+	     hr_qp->ibqp.qp_type == IB_QPT_UD) &&
+	   hr_qp->state != IB_QPS_RESET) {
 		/* Modify qp to reset before destroying qp */
 		ret = hns_roce_v2_modify_qp(&hr_qp->ibqp, NULL, 0,
 					    hr_qp->state, IB_QPS_RESET);
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index e288946..9ffd92a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1010,6 +1010,7 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 	switch (init_attr->qp_type) {
 	case IB_QPT_RC:
 	case IB_QPT_GSI:
+	case IB_QPT_UD:
 		break;
 	default:
 		ibdev_err(ibdev, "not support QP type %d\n",
@@ -1030,7 +1031,7 @@ struct ib_qp *hns_roce_create_qp(struct ib_pd *pd,
 	if (ret) {
 		ibdev_err(ibdev, "Create QP type 0x%x failed(%d)\n",
 			  init_attr->qp_type, ret);
-		ibdev_err(ibdev, "Create GSI QP failed!\n");
+
 		kfree(hr_qp);
 		return ERR_PTR(ret);
 	}
-- 
2.8.1

