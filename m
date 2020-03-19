Return-Path: <SRS0=gM5Z=5E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD1EC5518F
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41DD4208C3
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Mar 2020 13:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgCSN3I (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:29:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729088AbgCSN3H (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 19 Mar 2020 09:29:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E7B632931751B1A94B18;
        Thu, 19 Mar 2020 21:28:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Mar 2020 21:28:44 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 10/11] RDMA/hns: Remove redundant assignment of wc->smac when polling cq
Date:   Thu, 19 Mar 2020 21:24:57 +0800
Message-ID: <1584624298-23841-11-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1584624298-23841-1-git-send-email-liweihang@huawei.com>
References: <1584624298-23841-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The field smac in ib_wc was used for create AH and then it will be treated
as destination mac address in UD sqwqe, but related code about filling smac
into AH has been removed in core. Actually, the dmac in UD sqwqe is parsed
from the dgid in grh which is passed in by ULP now, so this assignment
should be removed.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2b03c72..31b6146 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3236,14 +3236,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		wc->port_num = roce_get_field(cqe->byte_32,
 				V2_CQE_BYTE_32_PORTN_M, V2_CQE_BYTE_32_PORTN_S);
 		wc->pkey_index = 0;
-		memcpy(wc->smac, cqe->smac, 4);
-		wc->smac[4] = roce_get_field(cqe->byte_28,
-					     V2_CQE_BYTE_28_SMAC_4_M,
-					     V2_CQE_BYTE_28_SMAC_4_S);
-		wc->smac[5] = roce_get_field(cqe->byte_28,
-					     V2_CQE_BYTE_28_SMAC_5_M,
-					     V2_CQE_BYTE_28_SMAC_5_S);
-		wc->wc_flags |= IB_WC_WITH_SMAC;
+
 		if (roce_get_bit(cqe->byte_28, V2_CQE_BYTE_28_VID_VLD_S)) {
 			wc->vlan_id = (u16)roce_get_field(cqe->byte_28,
 							  V2_CQE_BYTE_28_VID_M,
-- 
2.8.1

