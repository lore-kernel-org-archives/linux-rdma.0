Return-Path: <SRS0=BxIS=BH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D865C433E4
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Jul 2020 10:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BEB20775
	for <linux-rdma@archiver.kernel.org>; Tue, 28 Jul 2020 10:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgG1KnT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Jul 2020 06:43:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728614AbgG1KnT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 28 Jul 2020 06:43:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9559CCE201BA10053DD2;
        Tue, 28 Jul 2020 18:43:16 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 18:43:10 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 5/7] RDMA/hns: Delete unnecessary memset when allocating VF resource
Date:   Tue, 28 Jul 2020 18:42:19 +0800
Message-ID: <1595932941-40613-6-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1595932941-40613-1-git-send-email-liweihang@huawei.com>
References: <1595932941-40613-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

The hns_roce_cmq_setup_basic_desc() can clear the whole desc, so removes
these redundant memset operations.

Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 8cda4a9..9d64804 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1514,8 +1514,6 @@ static int hns_roce_alloc_vf_resource(struct hns_roce_dev *hr_dev)
 
 	req_a = (struct hns_roce_vf_res_a *)desc[0].data;
 	req_b = (struct hns_roce_vf_res_b *)desc[1].data;
-	memset(req_a, 0, sizeof(*req_a));
-	memset(req_b, 0, sizeof(*req_b));
 	for (i = 0; i < 2; i++) {
 		hns_roce_cmq_setup_basic_desc(&desc[i],
 					      HNS_ROCE_OPC_ALLOC_VF_RES, false);
-- 
2.8.1

