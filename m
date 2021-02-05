Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD559C433E6
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 09:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65DC864FB8
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 09:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBEJr1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 5 Feb 2021 04:47:27 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12850 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBEJpQ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 5 Feb 2021 04:45:16 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DX9QB1LzLz7hVb;
        Fri,  5 Feb 2021 17:40:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 17:41:50 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: [PATCH for-next 10/12] RDMA/hns: Avoid unnecessary memset on WQEs in post_send
Date:   Fri, 5 Feb 2021 17:39:32 +0800
Message-ID: <1612517974-31867-11-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612517974-31867-1-git-send-email-liweihang@huawei.com>
References: <1612517974-31867-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

All fields of WQE will be rewrote, so the memset is unnecessary. And when
SQ is working in OWNER mode, the pipeline may prefetch the WQEs beyond PI,
the memset operation may flip the owner bit too early, then the pipeline
may get a wrong WQ.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1bff432..55dfd44 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -467,7 +467,6 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	int ret;
 
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
-	memset(ud_sq_wqe, 0, sizeof(*ud_sq_wqe));
 
 	ret = set_ud_opcode(ud_sq_wqe, wr);
 	if (WARN_ON(ret))
@@ -573,7 +572,6 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	int ret;
 
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
-	memset(rc_sq_wqe, 0, sizeof(*rc_sq_wqe));
 
 	rc_sq_wqe->msg_len = cpu_to_le32(msg_len);
 
-- 
2.8.1

