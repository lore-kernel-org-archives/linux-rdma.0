Return-Path: <SRS0=52Hh=2O=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A70BC2D0D0
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Dec 2019 08:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE266206B7
	for <linux-rdma@archiver.kernel.org>; Tue, 24 Dec 2019 08:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLXIdE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:33:04 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfLXIdE (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 24 Dec 2019 03:33:04 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7F2ABEB75AD3285691C0;
        Tue, 24 Dec 2019 16:33:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 16:32:51 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bmt@zurich.ibm.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <linux-rdma@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 1/5] RDMA/siw: use true,false for bool variable
Date:   Tue, 24 Dec 2019 16:40:08 +0800
Message-ID: <1577176812-2238-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577176812-2238-1-git-send-email-zhengbin13@huawei.com>
References: <1577176812-2238-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Fixes coccicheck warning:

drivers/infiniband/sw/siw/siw_cm.c:32:18-41: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 3bccfef4..0c3f058 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -29,7 +29,7 @@
  * MPA_V2_RDMA_NO_RTR, MPA_V2_RDMA_READ_RTR, MPA_V2_RDMA_WRITE_RTR
  */
 static __be16 rtr_type = MPA_V2_RDMA_READ_RTR | MPA_V2_RDMA_WRITE_RTR;
-static const bool relaxed_ird_negotiation = 1;
+static const bool relaxed_ird_negotiation = true;

 static void siw_cm_llp_state_change(struct sock *s);
 static void siw_cm_llp_data_ready(struct sock *s);
--
2.7.4

