Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29200C64E7A
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Dec 2020 13:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D547B20770
	for <linux-rdma@archiver.kernel.org>; Tue,  1 Dec 2020 13:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgLAN0T (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:26:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8484 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLAN0T (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 1 Dec 2020 08:26:19 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CljWs35GyzhXwr;
        Tue,  1 Dec 2020 21:25:13 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Dec 2020 21:25:25 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next] RDMA/hns: Move capability flags of QP and CQ to hns-abi.h
Date:   Tue, 1 Dec 2020 21:23:44 +0800
Message-ID: <1606829024-51856-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

These flags will be returned to the userspace through ABI, so they should
be defined in hns-abi.h. Furthermore, there is no need to include
hns-abi.h in every source files, it just needs to be included in the
common header file.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     |  1 -
 drivers/infiniband/hw/hns/hns_roce_device.h | 11 +----------
 drivers/infiniband/hw/hns/hns_roce_main.c   |  1 -
 drivers/infiniband/hw/hns/hns_roce_pd.c     |  1 -
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  1 -
 drivers/infiniband/hw/hns/hns_roce_srq.c    |  1 -
 include/uapi/rdma/hns-abi.h                 | 10 ++++++++++
 7 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 68f355f..5e6d688 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -36,7 +36,6 @@
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
 #include "hns_roce_hem.h"
-#include <rdma/hns-abi.h>
 #include "hns_roce_common.h"
 
 static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1c1deb4..6c5d5dd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_DEVICE_H
 
 #include <rdma/ib_verbs.h>
+#include <rdma/hns-abi.h>
 
 #define DRV_NAME "hns_roce"
 
@@ -129,16 +130,6 @@ enum {
 	SERV_TYPE_UD,
 };
 
-enum hns_roce_qp_caps {
-	HNS_ROCE_QP_CAP_RQ_RECORD_DB = BIT(0),
-	HNS_ROCE_QP_CAP_SQ_RECORD_DB = BIT(1),
-	HNS_ROCE_QP_CAP_OWNER_DB = BIT(2),
-};
-
-enum hns_roce_cq_flags {
-	HNS_ROCE_CQ_FLAG_RECORD_DB = BIT(0),
-};
-
 enum hns_roce_qp_state {
 	HNS_ROCE_QP_STATE_RST,
 	HNS_ROCE_QP_STATE_INIT,
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index f01590d..e8aa807 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -40,7 +40,6 @@
 #include <rdma/ib_cache.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
-#include <rdma/hns-abi.h>
 #include "hns_roce_hem.h"
 
 /**
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 98f6949..45ec91d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -32,7 +32,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <uapi/rdma/hns-abi.h>
 #include "hns_roce_device.h"
 
 static int hns_roce_pd_alloc(struct hns_roce_dev *hr_dev, unsigned long *pdn)
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 5e505a3..5a94b20 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -39,7 +39,6 @@
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
-#include <rdma/hns-abi.h>
 
 static void flush_work_handle(struct work_struct *work)
 {
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 27646b9..36c6bcb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -4,7 +4,6 @@
  */
 
 #include <rdma/ib_umem.h>
-#include <rdma/hns-abi.h>
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
 #include "hns_roce_hem.h"
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index 9ec85f7..2dd5fa07 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -43,6 +43,10 @@ struct hns_roce_ib_create_cq {
 	__u32 reserved;
 };
 
+enum hns_roce_cq_cap_flags {
+	HNS_ROCE_CQ_FLAG_RECORD_DB = BIT(0),
+};
+
 struct hns_roce_ib_create_cq_resp {
 	__aligned_u64 cqn; /* Only 32 bits used, 64 for compat */
 	__aligned_u64 cap_flags;
@@ -69,6 +73,12 @@ struct hns_roce_ib_create_qp {
 	__aligned_u64 sdb_addr;
 };
 
+enum hns_roce_qp_cap_flags {
+	HNS_ROCE_QP_CAP_RQ_RECORD_DB = BIT(0),
+	HNS_ROCE_QP_CAP_SQ_RECORD_DB = BIT(1),
+	HNS_ROCE_QP_CAP_OWNER_DB = BIT(2),
+};
+
 struct hns_roce_ib_create_qp_resp {
 	__aligned_u64 cap_flags;
 };
-- 
2.8.1

