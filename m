Return-Path: <SRS0=OVxU=5L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C150C2D0EC
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Mar 2020 03:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E66820719
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Mar 2020 03:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCZDoR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 25 Mar 2020 23:44:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727647AbgCZDoR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 25 Mar 2020 23:44:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9EB5C7779D08CF2D859C;
        Thu, 26 Mar 2020 11:44:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Mar 2020 11:44:04 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 2/3] RDMA/hns: Reduce the maximum number of extend SGE per WQE
Date:   Thu, 26 Mar 2020 11:40:17 +0800
Message-ID: <1585194018-4381-3-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1585194018-4381-1-git-send-email-liweihang@huawei.com>
References: <1585194018-4381-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

Just reduce the default number to 64 for backward compatibility, the driver
can still get this configuration from the firmware.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 2a117ff..4f90ef7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -50,15 +50,14 @@
 #define HNS_ROCE_V2_MAX_WQE_NUM			0x8000
 #define	HNS_ROCE_V2_MAX_SRQ			0x100000
 #define HNS_ROCE_V2_MAX_SRQ_WR			0x8000
-#define HNS_ROCE_V2_MAX_SRQ_SGE			0x100
+#define HNS_ROCE_V2_MAX_SRQ_SGE			64
 #define HNS_ROCE_V2_MAX_CQ_NUM			0x100000
 #define HNS_ROCE_V2_MAX_CQC_TIMER_NUM		0x100
 #define HNS_ROCE_V2_MAX_SRQ_NUM			0x100000
 #define HNS_ROCE_V2_MAX_CQE_NUM			0x400000
 #define HNS_ROCE_V2_MAX_SRQWQE_NUM		0x8000
-#define HNS_ROCE_V2_MAX_RQ_SGE_NUM		0x100
-#define HNS_ROCE_V2_MAX_SQ_SGE_NUM		0xff
-#define HNS_ROCE_V2_MAX_SRQ_SGE_NUM		0x100
+#define HNS_ROCE_V2_MAX_RQ_SGE_NUM		64
+#define HNS_ROCE_V2_MAX_SQ_SGE_NUM		64
 #define HNS_ROCE_V2_MAX_EXTEND_SGE_NUM		0x200000
 #define HNS_ROCE_V2_MAX_SQ_INLINE		0x20
 #define HNS_ROCE_V2_UAR_NUM			256
-- 
2.8.1

