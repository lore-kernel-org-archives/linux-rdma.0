Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32AAC433B4
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Apr 2021 15:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3FA6112F
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Apr 2021 15:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbhDGPjR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:39:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16020 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353712AbhDGPjP (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 7 Apr 2021 11:39:15 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFpQR5j9FzPnxd;
        Wed,  7 Apr 2021 23:36:15 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 23:38:54 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Yangyang Li <liyangyang20@huawei.com>,
        Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] RDMA/hns: Use GFP_ATOMIC under spin lock
Date:   Wed, 7 Apr 2021 15:49:00 +0000
Message-ID: <20210407154900.3486268-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

A spin lock is taken here so we should use GFP_ATOMIC.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1213f4011dd1..0312d383d49e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4623,7 +4623,7 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	/* If no dgid is found, a new dip and a mapping between dgid and
 	 * dip_idx will be created.
 	 */
-	hr_dip = kzalloc(sizeof(*hr_dip), GFP_KERNEL);
+	hr_dip = kzalloc(sizeof(*hr_dip), GFP_ATOMIC);
 	if (!hr_dip) {
 		ret = -ENOMEM;
 		goto out;

