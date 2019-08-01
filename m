Return-Path: <SRS0=ZuZ5=V5=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21264C433FF
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 11:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6E04214DA
	for <linux-rdma@archiver.kernel.org>; Thu,  1 Aug 2019 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564660114;
	bh=RrTALbo/Q05tGlWNwGZnAZ0tHRqY0Wj1Ki0WV4qz2ro=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=roiEmQd+hw89q0k3VElgC9XKMz6pQW2zSMI+FdFZyQEYqNJ+hfZ6Oon9g8KftwIMP
	 QDwi92zanqdSBx64yDkF2n02bPXrAsZe/IRsh3avt6JHRD2umc+Fkj6yGrSahUEYXA
	 SWPmsw+pHy/LUX/wE+4/3n+/vif4C5Z6/ht7wErg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfHALsd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 1 Aug 2019 07:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbfHALsd (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 1 Aug 2019 07:48:33 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F1320B7C;
        Thu,  1 Aug 2019 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564660112;
        bh=RrTALbo/Q05tGlWNwGZnAZ0tHRqY0Wj1Ki0WV4qz2ro=;
        h=From:To:Cc:Subject:Date:From;
        b=PM+7yPGZGEJSamJRMnFV32nhMnZ49VP3PeUsPm7aPjUrGamaqU7ob4Bm7174E+nZ8
         frPSJgOtpZDJM2CLC2AfUxOEpCZPyiVlZx7yzqFie2ZmZuuJJbkHeCugVFblq2Nmz2
         +FcYNcf8llADKap48TdkDO5a/OCZcRr0/lavQS9M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Lijun Ou <oulijun@huawei.com>
Subject: [PATCH rdma-next] RDMA/hns: Remove not used UAR assignment
Date:   Thu,  1 Aug 2019 14:48:27 +0300
Message-Id: <20190801114827.24263-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

UAR in CQ is not used and generates the following compilation
warning, clean the code by removing uar assignment.

drivers/infiniband/hw/hns/hns_roce_cq.c: In function _create_user_cq_:
drivers/infiniband/hw/hns/hns_roce_cq.c:305:27: warning: parameter _uar_ set but not used [-Wunused-but-set-parameter]
  305 |      struct hns_roce_uar *uar,
      |      ~~~~~~~~~~~~~~~~~~~~~^~~

Fixes: 4f8f0d5e33dd ("RDMA/hns: Package the flow of creating cq")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 507d3c478404..22541d19cd09 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -83,7 +83,6 @@ static int hns_roce_sw2hw_cq(struct hns_roce_dev *dev,

 static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 			     struct hns_roce_mtt *hr_mtt,
-			     struct hns_roce_uar *hr_uar,
 			     struct hns_roce_cq *hr_cq, int vector)
 {
 	struct hns_roce_cmd_mailbox *mailbox;
@@ -154,7 +153,6 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,

 	hr_cq->cons_index = 0;
 	hr_cq->arm_sn = 1;
-	hr_cq->uar = hr_uar;

 	atomic_set(&hr_cq->refcount, 1);
 	init_completion(&hr_cq->free);
@@ -302,7 +300,6 @@ static int create_user_cq(struct hns_roce_dev *hr_dev,
 			  struct hns_roce_cq *hr_cq,
 			  struct ib_udata *udata,
 			  struct hns_roce_ib_create_cq_resp *resp,
-			  struct hns_roce_uar *uar,
 			  int cq_entries)
 {
 	struct hns_roce_ib_create_cq ucmd;
@@ -337,9 +334,6 @@ static int create_user_cq(struct hns_roce_dev *hr_dev,
 		resp->cap_flags |= HNS_ROCE_SUPPORT_CQ_RECORD_DB;
 	}

-	/* Get user space parameters */
-	uar = &context->uar;
-
 	return 0;

 err_mtt:
@@ -350,10 +344,10 @@ static int create_user_cq(struct hns_roce_dev *hr_dev,
 }

 static int create_kernel_cq(struct hns_roce_dev *hr_dev,
-			    struct hns_roce_cq *hr_cq, struct hns_roce_uar *uar,
-			    int cq_entries)
+			    struct hns_roce_cq *hr_cq, int cq_entries)
 {
 	struct device *dev = hr_dev->dev;
+	struct hns_roce_uar *uar;
 	int ret;

 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
@@ -420,7 +414,6 @@ int hns_roce_ib_create_cq(struct ib_cq *ib_cq,
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_ib_create_cq_resp resp = {};
 	struct hns_roce_cq *hr_cq = to_hr_cq(ib_cq);
-	struct hns_roce_uar *uar = NULL;
 	int vector = attr->comp_vector;
 	int cq_entries = attr->cqe;
 	int ret;
@@ -439,14 +432,13 @@ int hns_roce_ib_create_cq(struct ib_cq *ib_cq,
 	spin_lock_init(&hr_cq->lock);

 	if (udata) {
-		ret = create_user_cq(hr_dev, hr_cq, udata, &resp, uar,
-				     cq_entries);
+		ret = create_user_cq(hr_dev, hr_cq, udata, &resp, cq_entries);
 		if (ret) {
 			dev_err(dev, "Create cq failed in user mode!\n");
 			goto err_cq;
 		}
 	} else {
-		ret = create_kernel_cq(hr_dev, hr_cq, uar, cq_entries);
+		ret = create_kernel_cq(hr_dev, hr_cq, cq_entries);
 		if (ret) {
 			dev_err(dev, "Create cq failed in kernel mode!\n");
 			goto err_cq;
@@ -454,7 +446,7 @@ int hns_roce_ib_create_cq(struct ib_cq *ib_cq,
 	}

 	/* Allocate cq index, fill cq_context */
-	ret = hns_roce_cq_alloc(hr_dev, cq_entries, &hr_cq->hr_buf.hr_mtt, uar,
+	ret = hns_roce_cq_alloc(hr_dev, cq_entries, &hr_cq->hr_buf.hr_mtt,
 				hr_cq, vector);
 	if (ret) {
 		dev_err(dev, "Creat CQ .Failed to cq_alloc.\n");
--
2.20.1

