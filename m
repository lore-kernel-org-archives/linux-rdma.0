Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D0ECAAA1
	for <linux-rdma@archiver.kernel.org>; Sun, 11 Sep 2022 09:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiIKJXk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 11 Sep 2022 05:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIKJXa (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 11 Sep 2022 05:23:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3823E759
        for <linux-rdma@vger.kernel.org>; Sun, 11 Sep 2022 02:23:28 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MQPP34rmvzHnlP;
        Sun, 11 Sep 2022 17:21:27 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 11 Sep 2022 17:23:26 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <dennis.dalessandro@cornelisnetworks.com>, <jgg@ziepe.ca>,
        <leon@kernel.org>, <cuigaosheng1@huawei.com>,
        <mike.marciniszyn@intel.com>
CC:     <linux-rdma@vger.kernel.org>
Subject: [PATCH] IB/hfi1: remove rc_only_opcode and uc_only_opcode declarations
Date:   Sun, 11 Sep 2022 17:23:25 +0800
Message-ID: <20220911092325.3216513-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

rc_only_opcode and uc_only_opcode have been removed since
commit b374e060cc2a ("IB/hfi1: Consolidate pio control masks
into single definition"), so remove them.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/infiniband/hw/hfi1/verbs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 38565532d654..7f30f32b34dc 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -391,9 +391,6 @@ void hfi1_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 int hfi1_setup_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		   bool *call_send);
 
-extern const u32 rc_only_opcode;
-extern const u32 uc_only_opcode;
-
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_packet *packet);
 
 u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
-- 
2.25.1

