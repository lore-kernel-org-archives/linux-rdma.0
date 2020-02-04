Return-Path: <SRS0=EG8C=3Y=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13199C3524D
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 08:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE24D21D7E
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 08:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgBDIYm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 4 Feb 2020 03:24:42 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbgBDIYm (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 4 Feb 2020 03:24:42 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 94585196024AD1E7C24D;
        Tue,  4 Feb 2020 16:24:39 +0800 (CST)
Received: from SZA160416817.china.huawei.com (10.46.14.205) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Feb 2020 16:24:33 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH RFC v2 for-next 4/7] RDMA/qedr: remove deliver net device event
Date:   Tue, 4 Feb 2020 16:24:05 +0800
Message-ID: <20200204082408.18728-5-liweihang@huawei.com>
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

The code that handles the link event of the net device has been moved into
the core, and the related processing should been removed from the provider
driver.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
---
 drivers/infiniband/hw/qedr/main.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index dcdc85a..d85894b 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -957,24 +957,11 @@ static void qedr_remove(struct qedr_dev *dev)
 	ib_dealloc_device(&dev->ibdev);
 }
 
-static void qedr_close(struct qedr_dev *dev)
-{
-	if (test_and_clear_bit(QEDR_ENET_STATE_BIT, &dev->enet_state))
-		qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_PORT_ERR);
-}
-
 static void qedr_shutdown(struct qedr_dev *dev)
 {
-	qedr_close(dev);
 	qedr_remove(dev);
 }
 
-static void qedr_open(struct qedr_dev *dev)
-{
-	if (!test_and_set_bit(QEDR_ENET_STATE_BIT, &dev->enet_state))
-		qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_PORT_ACTIVE);
-}
-
 static void qedr_mac_address_change(struct qedr_dev *dev)
 {
 	union ib_gid *sgid = &dev->sgid_tbl[0];
@@ -1014,12 +1001,6 @@ static void qedr_mac_address_change(struct qedr_dev *dev)
 static void qedr_notify(struct qedr_dev *dev, enum qede_rdma_event event)
 {
 	switch (event) {
-	case QEDE_UP:
-		qedr_open(dev);
-		break;
-	case QEDE_DOWN:
-		qedr_close(dev);
-		break;
 	case QEDE_CLOSE:
 		qedr_shutdown(dev);
 		break;
-- 
2.8.1


