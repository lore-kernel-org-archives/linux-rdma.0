Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1DDC56202
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Nov 2020 10:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D636D208CA
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Nov 2020 10:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgKZK16 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Nov 2020 05:27:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8041 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgKZK16 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 26 Nov 2020 05:27:58 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ChYqC0lvlzhhck;
        Thu, 26 Nov 2020 18:27:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 18:27:50 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>
CC:     <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH for-rc] RDMA/hns: Bugfix for memory window mtpt configuration
Date:   Thu, 26 Nov 2020 18:26:12 +0800
Message-ID: <1606386372-21094-1-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Yixian Liu <liuyixian@huawei.com>

When a memory window is bound to a memory region, the local write access
should be set for its mtpt table.

Fixes: c7c28191408b ("RDMA/hns: Add MW support for hip08")
Signed-off-by: Yixian Liu <liuyixian@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6d30850..3cc0375 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2936,6 +2936,7 @@ static int hns_roce_v2_mw_write_mtpt(void *mb_buf, struct hns_roce_mw *mw)
 
 	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_R_INV_EN_S, 1);
 	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_L_INV_EN_S, 1);
+	roce_set_bit(mpt_entry->byte_8_mw_cnt_en, V2_MPT_BYTE_8_LW_EN_S, 1);
 
 	roce_set_bit(mpt_entry->byte_12_mw_pa, V2_MPT_BYTE_12_PA_S, 0);
 	roce_set_bit(mpt_entry->byte_12_mw_pa, V2_MPT_BYTE_12_MR_MW_S, 1);
-- 
2.8.1

