Return-Path: <SRS0=0bz2=23=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2C2C33C8C
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Jan 2020 12:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 749BC207FF
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Jan 2020 12:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgAFMZM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:25:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgAFMZM (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 6 Jan 2020 07:25:12 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9B866C255863954E9A94;
        Mon,  6 Jan 2020 20:25:09 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 Jan 2020 20:24:59 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 4/7] RDMA/hns: Delete unnessary parameters in hns_roce_v2_qp_modify()
Date:   Mon, 6 Jan 2020 20:21:13 +0800
Message-ID: <1578313276-29080-5-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578313276-29080-1-git-send-email-liweihang@huawei.com>
References: <1578313276-29080-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Current state and new state of qp won't be configured when modifying qp,
so these two redundant parameters should be removed.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cb8071a..b0faef8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3159,8 +3159,6 @@ static int hns_roce_v2_clear_hem(struct hns_roce_dev *hr_dev,
 }
 
 static int hns_roce_v2_qp_modify(struct hns_roce_dev *hr_dev,
-				 enum ib_qp_state cur_state,
-				 enum ib_qp_state new_state,
 				 struct hns_roce_v2_qp_context *context,
 				 struct hns_roce_qp *hr_qp)
 {
@@ -4443,7 +4441,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_60_QP_ST_S, 0);
 
 	/* SW pass context to HW */
-	ret = hns_roce_v2_qp_modify(hr_dev, cur_state, new_state, ctx, hr_qp);
+	ret = hns_roce_v2_qp_modify(hr_dev, ctx, hr_qp);
 	if (ret) {
 		dev_err(dev, "hns_roce_qp_modify failed(%d)\n", ret);
 		goto out;
-- 
2.8.1

