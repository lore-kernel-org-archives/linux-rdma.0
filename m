Return-Path: <SRS0=ZJsx=EF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22034C4363A
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 11:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F342076E
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 11:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJ3LlM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:41:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7108 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgJ3LlM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 30 Oct 2020 07:41:12 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CN0kZ4LM5zLr6S;
        Fri, 30 Oct 2020 19:41:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 30 Oct 2020 19:41:01 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-next 5/8] RDMA/hns: Remove the portn field in UD SQ WQE
Date:   Fri, 30 Oct 2020 19:39:32 +0800
Message-ID: <1604057975-23388-6-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604057975-23388-1-git-send-email-liweihang@huawei.com>
References: <1604057975-23388-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This field in UD WQE in not used by hardware.

Fixes: 7bdee4158b37 ("RDMA/hns: Fill sq wqe context of ud type in hip08")
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 --
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 69386a5..99e4189 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -499,8 +499,6 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	}
 	roce_set_field(ud_sq_wqe->byte_40, V2_UD_SEND_WQE_BYTE_40_SL_M,
 		       V2_UD_SEND_WQE_BYTE_40_SL_S, ah->av.sl);
-	roce_set_field(ud_sq_wqe->byte_40, V2_UD_SEND_WQE_BYTE_40_PORTN_M,
-		       V2_UD_SEND_WQE_BYTE_40_PORTN_S, qp->port);
 
 	roce_set_field(ud_sq_wqe->byte_48, V2_UD_SEND_WQE_BYTE_48_SGID_INDX_M,
 		       V2_UD_SEND_WQE_BYTE_48_SGID_INDX_S, ah->av.gid_index);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 1409d05..1466888 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1121,9 +1121,6 @@ struct hns_roce_v2_ud_send_wqe {
 #define	V2_UD_SEND_WQE_BYTE_40_SL_S 20
 #define V2_UD_SEND_WQE_BYTE_40_SL_M GENMASK(23, 20)
 
-#define	V2_UD_SEND_WQE_BYTE_40_PORTN_S 24
-#define V2_UD_SEND_WQE_BYTE_40_PORTN_M GENMASK(26, 24)
-
 #define V2_UD_SEND_WQE_BYTE_40_UD_VLAN_EN_S 30
 
 #define	V2_UD_SEND_WQE_BYTE_40_LBI_S 31
-- 
2.8.1

