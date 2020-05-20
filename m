Return-Path: <SRS0=bXLp=7C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45223C433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 20 May 2020 13:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25EB4207F9
	for <linux-rdma@archiver.kernel.org>; Wed, 20 May 2020 13:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETNxq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 May 2020 09:53:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgETNxq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 20 May 2020 09:53:46 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E8DDE87A2E9E527C41CF;
        Wed, 20 May 2020 21:53:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 21:53:35 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 1/9] RDMA/hns: Let software PI/CI grow naturally
Date:   Wed, 20 May 2020 21:53:11 +0800
Message-ID: <1589982799-28728-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1589982799-28728-1-git-send-email-liweihang@huawei.com>
References: <1589982799-28728-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

The hardware can truncate PI/CI when posting or polling, the driver does
not need to do truncation. Therefore keep the software's PI/CI consistent
with it in the hardware.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ebe570a..7d0556ef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -500,8 +500,7 @@ static inline void update_sq_db(struct hns_roce_dev *hr_dev,
 		roce_set_field(sq_db.byte_4, V2_DB_BYTE_4_CMD_M,
 			       V2_DB_BYTE_4_CMD_S, HNS_ROCE_V2_SQ_DB);
 		roce_set_field(sq_db.parameter, V2_DB_PARAMETER_IDX_M,
-			       V2_DB_PARAMETER_IDX_S,
-			       qp->sq.head & ((qp->sq.wqe_cnt << 1) - 1));
+			       V2_DB_PARAMETER_IDX_S, qp->sq.head);
 		roce_set_field(sq_db.parameter, V2_DB_PARAMETER_SL_M,
 			       V2_DB_PARAMETER_SL_S, qp->sl);
 
@@ -806,7 +805,8 @@ static int hns_roce_v2_post_srq_recv(struct ib_srq *ibsrq,
 		srq_db.byte_4 =
 			cpu_to_le32(HNS_ROCE_V2_SRQ_DB << V2_DB_BYTE_4_CMD_S |
 				    (srq->srqn & V2_DB_BYTE_4_TAG_M));
-		srq_db.parameter = cpu_to_le32(srq->head);
+		srq_db.parameter =
+			cpu_to_le32(srq->head & V2_DB_PARAMETER_IDX_M);
 
 		hns_roce_write64(hr_dev, (__le32 *)&srq_db, srq->db_reg_l);
 	}
@@ -2947,8 +2947,7 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 	roce_set_field(doorbell[0], V2_CQ_DB_BYTE_4_CMD_M, V2_DB_BYTE_4_CMD_S,
 		       HNS_ROCE_V2_CQ_DB_NTR);
 	roce_set_field(doorbell[1], V2_CQ_DB_PARAMETER_CONS_IDX_M,
-		       V2_CQ_DB_PARAMETER_CONS_IDX_S,
-		       hr_cq->cons_index & ((hr_cq->cq_depth << 1) - 1));
+		       V2_CQ_DB_PARAMETER_CONS_IDX_S, hr_cq->cons_index);
 	roce_set_field(doorbell[1], V2_CQ_DB_PARAMETER_CMD_SN_M,
 		       V2_CQ_DB_PARAMETER_CMD_SN_S, hr_cq->arm_sn & 0x3);
 	roce_set_bit(doorbell[1], V2_CQ_DB_PARAMETER_NOTIFY_S,
-- 
2.8.1

