Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB80C56202
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Nov 2020 09:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556C421741
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Nov 2020 09:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgKZJ2l (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:28:41 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8407 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKZJ2l (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 26 Nov 2020 04:28:41 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ChXVn2gWmz743P;
        Thu, 26 Nov 2020 17:28:17 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 17:28:30 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-rc] RDMA/hns: Fix wrong field of SRQ number the device supports
Date:   Thu, 26 Nov 2020 17:26:52 +0800
Message-ID: <1606382812-23636-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

The SRQ capacity is got from the firmware, whose field should be ended at
bit 19.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 1409d05..3b4d79e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1717,7 +1717,7 @@ struct hns_roce_query_pf_caps_d {
 	__le32 rsv_uars_rsv_qps;
 };
 #define V2_QUERY_PF_CAPS_D_NUM_SRQS_S 0
-#define V2_QUERY_PF_CAPS_D_NUM_SRQS_M GENMASK(20, 0)
+#define V2_QUERY_PF_CAPS_D_NUM_SRQS_M GENMASK(19, 0)
 
 #define V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_S 20
 #define V2_QUERY_PF_CAPS_D_RQWQE_HOP_NUM_M GENMASK(21, 20)
-- 
2.8.1

