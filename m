Return-Path: <SRS0=XFIj=5F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E880C4332E
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 03:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3152320724
	for <linux-rdma@archiver.kernel.org>; Fri, 20 Mar 2020 03:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCTD1k (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:27:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12105 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726838AbgCTD1j (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Mar 2020 23:27:39 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 658622EAE41E85874AE4;
        Fri, 20 Mar 2020 11:27:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Mar 2020 11:27:27 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH v2 for-next 10/10] RDMA/hns: Remove redundant judgment of qp_type
Date:   Fri, 20 Mar 2020 11:23:42 +0800
Message-ID: <1584674622-52773-11-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1584674622-52773-1-git-send-email-liweihang@huawei.com>
References: <1584674622-52773-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Type of qp has been checked in check_send_valid(), so this judgment should
be removed.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 31b6146..7eceeea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -583,13 +583,6 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 			ret = set_ud_wqe(qp, wr, wqe, &sge_idx, owner_bit);
 		else if (ibqp->qp_type == IB_QPT_RC)
 			ret = set_rc_wqe(qp, wr, wqe, &sge_idx, owner_bit);
-		else {
-			ibdev_err(ibdev, "Illegal qp_type(0x%x)\n",
-				  ibqp->qp_type);
-			spin_unlock_irqrestore(&qp->sq.lock, flags);
-			*bad_wr = wr;
-			return -EOPNOTSUPP;
-		}
 
 		if (ret) {
 			*bad_wr = wr;
-- 
2.8.1

