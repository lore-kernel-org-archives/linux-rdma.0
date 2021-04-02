Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558DEC43460
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B46361105
	for <linux-rdma@archiver.kernel.org>; Fri,  2 Apr 2021 09:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhDBJKS (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:10:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbhDBJKR (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 2 Apr 2021 05:10:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBZ2H2QTvznXlB;
        Fri,  2 Apr 2021 17:07:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 17:10:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 1/9] RDMA/hns: Avoid enabling RQ inline on UD
Date:   Fri, 2 Apr 2021 17:07:26 +0800
Message-ID: <1617354454-47840-2-git-send-email-liweihang@huawei.com>
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

RQ inline is not supported on UD/GSI QP, it should be disabled in QPC.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 +++++--
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cc334d5c..b48bdc9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4106,8 +4106,11 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 		       ((u32)hr_qp->rdb.dma) >> 1);
 	context->rq_db_record_addr = cpu_to_le32(hr_qp->rdb.dma >> 32);
 
-	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RQIE_S,
-		    (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) ? 1 : 0);
+	if (ibqp->qp_type != IB_QPT_UD && ibqp->qp_type != IB_QPT_GSI)
+		roce_set_bit(context->byte_76_srqn_op_en,
+			     V2_QPC_BYTE_76_RQIE_S,
+			     !!(hr_dev->caps.flags &
+				HNS_ROCE_CAP_FLAG_RQ_INLINE));
 
 	roce_set_field(context->byte_80_rnr_rx_cqn, V2_QPC_BYTE_80_RX_CQN_M,
 		       V2_QPC_BYTE_80_RX_CQN_S, get_cqn(ibqp->recv_cq));
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 268d460..f214bd0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -487,7 +487,9 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 					    hr_qp->rq.max_gs);
 
 	hr_qp->rq.wqe_cnt = cnt;
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE &&
+	    hr_qp->ibqp.qp_type != IB_QPT_UD &&
+	    hr_qp->ibqp.qp_type != IB_QPT_GSI)
 		hr_qp->rq_inl_buf.wqe_cnt = cnt;
 	else
 		hr_qp->rq_inl_buf.wqe_cnt = 0;
-- 
2.8.1

