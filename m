Return-Path: <SRS0=lJT2=CS=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FBDC43461
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 08:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF21218AC
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Sep 2020 08:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgIII66 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:58:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbgIII6y (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 9 Sep 2020 04:58:54 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AC36B5CBB5947B061025;
        Wed,  9 Sep 2020 16:58:53 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Sep 2020 16:58:43 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 9/9] RDMA/hns: Fix missing sq_sig_type when querying QP
Date:   Wed, 9 Sep 2020 16:57:34 +0800
Message-ID: <1599641854-23160-10-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599641854-23160-1-git-send-email-liweihang@huawei.com>
References: <1599641854-23160-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The sq_sig_type field should be filled when querying QP, or the users may
get a wrong value.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index fe11c9a..8d30b74 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4834,6 +4834,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	}
 
 	qp_init_attr->cap = qp_attr->cap;
+	qp_init_attr->sq_sig_type = hr_qp->sq_signal_bits;
 
 out:
 	mutex_unlock(&hr_qp->mutex);
-- 
2.8.1

