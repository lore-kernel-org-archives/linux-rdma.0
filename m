Return-Path: <SRS0=0bz2=23=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E72C33C9B
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Jan 2020 12:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B8C2071A
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Jan 2020 12:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAFMZL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:25:11 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbgAFMZL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 6 Jan 2020 07:25:11 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8152824D64A6CF41820;
        Mon,  6 Jan 2020 20:25:09 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 Jan 2020 20:24:59 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 3/7] RDMA/hns: Update the value of qp type
Date:   Mon, 6 Jan 2020 20:21:12 +0800
Message-ID: <1578313276-29080-4-git-send-email-liweihang@huawei.com>
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

The values used to represent service type of RC and UD should be
interchanged according to design of hardware. And it's better to define
these types in enumeration than macros.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 5f1d1b3..19366a5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -107,11 +107,6 @@
 #define NODE_DESC_SIZE				64
 #define DB_REG_OFFSET				0x1000
 
-#define SERV_TYPE_RC				0
-#define SERV_TYPE_RD				1
-#define SERV_TYPE_UC				2
-#define SERV_TYPE_UD				3
-
 /* Configure to HW for PAGE_SIZE larger than 4KB */
 #define PG_SHIFT_OFFSET				(PAGE_SHIFT - 12)
 
@@ -131,6 +126,13 @@
 #define EQ_DEPTH_COEFF				2
 
 enum {
+	SERV_TYPE_RC,
+	SERV_TYPE_UC,
+	SERV_TYPE_RD,
+	SERV_TYPE_UD,
+};
+
+enum {
 	HNS_ROCE_SUPPORT_RQ_RECORD_DB = 1 << 0,
 	HNS_ROCE_SUPPORT_SQ_RECORD_DB = 1 << 1,
 };
-- 
2.8.1

