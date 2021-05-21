Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83CDC433B4
	for <linux-rdma@archiver.kernel.org>; Fri, 21 May 2021 09:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8457B6100A
	for <linux-rdma@archiver.kernel.org>; Fri, 21 May 2021 09:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhEUJb4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 21 May 2021 05:31:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4570 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbhEUJbp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 21 May 2021 05:31:45 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fmh8M4Cb8zqVJX;
        Fri, 21 May 2021 17:27:15 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 17:30:03 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 17:30:02 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, "Xi Wang" <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH for-next 3/5] RDMA/hns: Fix wrong timer context buffer page size
Date:   Fri, 21 May 2021 17:29:53 +0800
Message-ID: <1621589395-2435-4-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621589395-2435-1-git-send-email-liweihang@huawei.com>
References: <1621589395-2435-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

The HEM page size for QPC timer and CQC timer is always 4K and there's no
need to calculate a different size by the hns driver, otherwise the ROCEE
may access an invalid address.

Fixes: 719d13415f59 ("RDMA/hns: Remove duplicated hem page size config code")
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0c12d87..17cf51a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2057,12 +2057,6 @@ static void set_hem_page_size(struct hns_roce_dev *hr_dev)
 	calc_pg_sz(caps->max_cqes, caps->cqe_sz, caps->cqe_hop_num,
 		   1, &caps->cqe_buf_pg_sz, &caps->cqe_ba_pg_sz, HEM_TYPE_CQE);
 
-	if (caps->cqc_timer_entry_sz)
-		calc_pg_sz(caps->num_cqc_timer, caps->cqc_timer_entry_sz,
-			   caps->cqc_timer_hop_num, caps->cqc_timer_bt_num,
-			   &caps->cqc_timer_buf_pg_sz,
-			   &caps->cqc_timer_ba_pg_sz, HEM_TYPE_CQC_TIMER);
-
 	/* SRQ */
 	if (caps->flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		caps->srqc_ba_pg_sz = 0;
-- 
2.7.4

