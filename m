Return-Path: <SRS0=uoZ+=CQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071C1C433E2
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 17:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36C7206B8
	for <linux-rdma@archiver.kernel.org>; Mon,  7 Sep 2020 17:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgIGNzz (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 7 Sep 2020 09:55:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11245 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729720AbgIGNzN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 7 Sep 2020 09:55:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 09CF8DC3685404B99047;
        Mon,  7 Sep 2020 21:38:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 21:37:54 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 3/9] RDMA/hns: Add interception for resizing SRQs
Date:   Mon, 7 Sep 2020 21:36:42 +0800
Message-ID: <1599485808-29940-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599485808-29940-1-git-send-email-liweihang@huawei.com>
References: <1599485808-29940-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

HIP08 doesn't support modifying the maximum number of outstanding WR in an
SRQ. However, the driver does not return a failure message, and users may
mistakenly think that the resizing is executed successfully. So the driver
needs to intercept this operation.

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9a9639b..4a88d41 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5044,6 +5044,10 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 	struct hns_roce_cmd_mailbox *mailbox;
 	int ret;
 
+	/* Resizing SRQs is not supported yet */
+	if (srq_attr_mask & IB_SRQ_MAX_WR)
+		return -EINVAL;
+
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
 		if (srq_attr->srq_limit >= srq->wqe_cnt)
 			return -EINVAL;
-- 
2.8.1

