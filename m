Return-Path: <SRS0=EG8C=3Y=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3FAC3524A
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 08:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99EE021D7D
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 08:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBDIYm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 4 Feb 2020 03:24:42 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10147 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727102AbgBDIYl (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 4 Feb 2020 03:24:41 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 90051ED0EE7CD91FF3CC;
        Tue,  4 Feb 2020 16:24:39 +0800 (CST)
Received: from SZA160416817.china.huawei.com (10.46.14.205) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Feb 2020 16:24:32 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH RFC v2 for-next 3/7] qede: remove invalid notify operation
Date:   Tue, 4 Feb 2020 16:24:04 +0800
Message-ID: <20200204082408.18728-4-liweihang@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20200204082408.18728-1-liweihang@huawei.com>
References: <20200204082408.18728-1-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.46.14.205]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

The qedr notify() will remove the processing of QEDE_UP and QEDE_DOWN,
so qede no more needs to notify rdma of these two events.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
---
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index ffabc2d..0493279 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -145,8 +145,6 @@ void qede_rdma_dev_remove(struct qede_dev *edev, bool recovery)
 
 static void _qede_rdma_dev_open(struct qede_dev *edev)
 {
-	if (qedr_drv && edev->rdma_info.qedr_dev && qedr_drv->notify)
-		qedr_drv->notify(edev->rdma_info.qedr_dev, QEDE_UP);
 }
 
 static void qede_rdma_dev_open(struct qede_dev *edev)
@@ -161,8 +159,6 @@ static void qede_rdma_dev_open(struct qede_dev *edev)
 
 static void _qede_rdma_dev_close(struct qede_dev *edev)
 {
-	if (qedr_drv && edev->rdma_info.qedr_dev && qedr_drv->notify)
-		qedr_drv->notify(edev->rdma_info.qedr_dev, QEDE_DOWN);
 }
 
 static void qede_rdma_dev_close(struct qede_dev *edev)
-- 
2.8.1


