Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_12_24,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446C6C07E95
	for <linux-rdma@archiver.kernel.org>; Tue, 13 Jul 2021 10:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2311961260
	for <linux-rdma@archiver.kernel.org>; Tue, 13 Jul 2021 10:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhGMKvp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 13 Jul 2021 06:51:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:16175 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235552AbhGMKvp (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 13 Jul 2021 06:51:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="189823687"
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="189823687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 03:48:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="459532945"
Received: from unknown (HELO intel-86.bj.intel.com) ([10.238.154.86])
  by orsmga008.jf.intel.com with ESMTP; 13 Jul 2021 03:48:53 -0700
From:   yanjun.zhu@linux.dev
To:     zyjzyj2000@gmail.com, yanjun.zhu@intel.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        yanjun.zhu@linux.dev, leon@kernel.org
Subject: [PATCH 2/3] RDMA/irdma: change the returned type of irdma_set_hw_rsrc to void
Date:   Tue, 13 Jul 2021 23:11:29 -0400
Message-Id: <20210714031130.1511109-3-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210714031130.1511109-1-yanjun.zhu@linux.dev>
References: <20210714031130.1511109-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

Since the function irdma_set_hw_rsrc always returns zero, change
the returned type to void and remove all the related source code.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/hw/irdma/hw.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 7afb8a6a0526..00de5ee9a260 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1920,7 +1920,7 @@ enum irdma_status_code irdma_ctrl_init_hw(struct irdma_pci_f *rf)
  * irdma_set_hw_rsrc - set hw memory resources.
  * @rf: RDMA PCI function
  */
-static u32 irdma_set_hw_rsrc(struct irdma_pci_f *rf)
+static void irdma_set_hw_rsrc(struct irdma_pci_f *rf)
 {
 	rf->allocated_qps = (void *)(rf->mem_rsrc +
 		   (sizeof(struct irdma_arp_entry) * rf->arp_table_size));
@@ -1937,8 +1937,6 @@ static u32 irdma_set_hw_rsrc(struct irdma_pci_f *rf)
 	spin_lock_init(&rf->arp_lock);
 	spin_lock_init(&rf->qptable_lock);
 	spin_lock_init(&rf->qh_list_lock);
-
-	return 0;
 }
 
 /**
@@ -2000,9 +1998,7 @@ u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf)
 
 	rf->arp_table = (struct irdma_arp_entry *)rf->mem_rsrc;
 
-	ret = irdma_set_hw_rsrc(rf);
-	if (ret)
-		goto set_hw_rsrc_fail;
+	irdma_set_hw_rsrc(rf);
 
 	set_bit(0, rf->allocated_mrs);
 	set_bit(0, rf->allocated_qps);
@@ -2025,9 +2021,6 @@ u32 irdma_initialize_hw_rsrc(struct irdma_pci_f *rf)
 
 	return 0;
 
-set_hw_rsrc_fail:
-	kfree(rf->mem_rsrc);
-	rf->mem_rsrc = NULL;
 mem_rsrc_kzalloc_fail:
 	kfree(rf->allocated_ws_nodes);
 	rf->allocated_ws_nodes = NULL;
-- 
2.27.0

