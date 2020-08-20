Return-Path: <SRS0=u/e5=B6=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1850C433EB
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B589422B40
	for <linux-rdma@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgHTNW5 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729236AbgHTNTA (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 20 Aug 2020 09:19:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7D33BF8DF47F09922AA3;
        Thu, 20 Aug 2020 21:18:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 20 Aug 2020 21:18:49 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 1/4] RDMA/hns: Export hardware capability flags to userspace
Date:   Thu, 20 Aug 2020 21:17:46 +0800
Message-ID: <1597929469-22674-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597929469-22674-1-git-send-email-liweihang@huawei.com>
References: <1597929469-22674-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

The libhns in userspace for HIP09 will use the hardware's capability to
enable some features. So export the hardware capablility flags to userspace
by reusing the reserved fields in structure
"hns_roce_ib_alloc_ucontext_resp".

Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 1 +
 include/uapi/rdma/hns-abi.h               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 5907cfd..98945df 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -313,6 +313,7 @@ static int hns_roce_alloc_ucontext(struct ib_ucontext *uctx,
 		return -EAGAIN;
 
 	resp.qp_tab_size = hr_dev->caps.num_qps;
+	resp.cap_flags = (u32)hr_dev->caps.flags;
 
 	ret = hns_roce_uar_alloc(hr_dev, &context->uar);
 	if (ret)
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index eb76b38..5c38758 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -73,7 +73,7 @@ struct hns_roce_ib_create_qp_resp {
 
 struct hns_roce_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
-	__u32	reserved;
+	__u32	cap_flags;
 };
 
 struct hns_roce_ib_alloc_pd_resp {
-- 
2.8.1

