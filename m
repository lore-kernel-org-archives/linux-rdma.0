Return-Path: <SRS0=u98Z=43=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDEDC18E5B
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 13:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55838246BD
	for <linux-rdma@archiver.kernel.org>; Tue, 10 Mar 2020 13:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgCJNJ7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 10 Mar 2020 09:09:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730947AbgCJNJ7 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C5C4024471B37B8CD9B8;
        Tue, 10 Mar 2020 21:09:54 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Mar 2020 21:09:46 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next] RDMA/hns: Fix wrong judgments of udata->outlen
Date:   Tue, 10 Mar 2020 21:06:09 +0800
Message-ID: <1583845569-47257-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

These judgments were used to keep the compatibility with older versions of
userspace that don't have the field named "cap_flags" in structure
hns_roce_ib_create_cq_resp. But it will be wrong to compare outlen with
the size of resp if another new field were added in resp. oulen should be
compared with the end offset of cap_flags in resp.

Fixes: 4f8f0d5e33dd ("RDMA/hns: Package the flow of creating cq")
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
Related discussions can be found at:
https://patchwork.kernel.org/patch/11372851/

 drivers/infiniband/hw/hns/hns_roce_cq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 5ffe4c9..5bfb52f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -257,8 +257,8 @@ static int create_user_cq(struct hns_roce_dev *hr_dev,
 		return ret;
 	}
 
-	if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
-	    (udata->outlen >= sizeof(*resp))) {
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB &&
+	    udata->outlen >= offsetofend(typeof(*resp), cap_flags)) {
 		ret = hns_roce_db_map_user(context, udata, ucmd.db_addr,
 					   &hr_cq->db);
 		if (ret) {
@@ -321,8 +321,8 @@ static void destroy_user_cq(struct hns_roce_dev *hr_dev,
 	struct hns_roce_ucontext *context = rdma_udata_to_drv_context(
 				   udata, struct hns_roce_ucontext, ibucontext);
 
-	if ((hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) &&
-	    (udata->outlen >= sizeof(*resp)))
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB &&
+	    udata->outlen >= offsetofend(typeof(*resp), cap_flags))
 		hns_roce_db_unmap_user(context, &hr_cq->db);
 
 	hns_roce_mtt_cleanup(hr_dev, &hr_cq->mtt);
-- 
2.8.1

