Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33A6C4332F
	for <linux-rdma@archiver.kernel.org>; Fri, 25 Feb 2022 11:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiBYL1M (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 25 Feb 2022 06:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239165AbiBYL1K (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 25 Feb 2022 06:27:10 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B391DBA90
        for <linux-rdma@vger.kernel.org>; Fri, 25 Feb 2022 03:26:25 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4K4nSG3WX3z9sJx;
        Fri, 25 Feb 2022 19:22:38 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 19:26:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 19:26:07 +0800
From:   Wenpeng Liang <liangwenpeng@huawei.com>
To:     <jgg@nvidia.com>, <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
        <liangwenpeng@huawei.com>
Subject: [PATCH v2 for-next 7/9] RDMA/hns: Clean up the return value check of hns_roce_alloc_cmd_mailbox()
Date:   Fri, 25 Feb 2022 19:25:57 +0800
Message-ID: <20220225112559.43300-8-liangwenpeng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220225112559.43300-1-liangwenpeng@huawei.com>
References: <20220225112559.43300-1-liangwenpeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

hns_roce_alloc_cmd_mailbox() never returns NULL, so the check should be
IS_ERR(). Additionally, PTR_ERR() should be used to return an error code.

Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c    | 8 +++-----
 drivers/infiniband/hw/hns/hns_roce_srq.c   | 4 ++--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 631f6e233492..06eb4f00428c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5981,8 +5981,8 @@ static int hns_roce_v2_create_eq(struct hns_roce_dev *hr_dev,
 
 	/* Allocate mailbox memory */
 	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
-	if (IS_ERR_OR_NULL(mailbox))
-		return -ENOMEM;
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
 
 	ret = alloc_eq_buf(hr_dev, eq);
 	if (ret)
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 39de862666d7..6184894bd897 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -148,10 +148,8 @@ static int hns_roce_mr_enable(struct hns_roce_dev *hr_dev,
 
 	/* Allocate mailbox memory */
 	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
-	if (IS_ERR(mailbox)) {
-		ret = PTR_ERR(mailbox);
-		return ret;
-	}
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
 
 	if (mr->type != MR_TYPE_FRMR)
 		ret = hr_dev->hw->write_mtpt(hr_dev, mailbox->buf, mr);
@@ -282,7 +280,7 @@ struct ib_mr *hns_roce_rereg_user_mr(struct ib_mr *ibmr, int flags, u64 start,
 
 	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
 	if (IS_ERR(mailbox))
-		return ERR_CAST(mailbox);
+		return ERR_PTR(mailbox);
 
 	mtpt_idx = key_to_hw_index(mr->key) & (hr_dev->caps.num_mtpts - 1);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index e316276e18c2..97032a357b00 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -89,9 +89,9 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq)
 	}
 
 	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
-	if (IS_ERR_OR_NULL(mailbox)) {
+	if (IS_ERR(mailbox)) {
 		ibdev_err(ibdev, "failed to alloc mailbox for SRQC.\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(mailbox);
 		goto err_xa;
 	}
 
-- 
2.33.0

