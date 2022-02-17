Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B963C433EF
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Feb 2022 01:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiBQB7H (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:59:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiBQB7G (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 16 Feb 2022 20:59:06 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134381738CE
        for <linux-rdma@vger.kernel.org>; Wed, 16 Feb 2022 17:58:52 -0800 (PST)
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="250709709"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="250709709"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 17:58:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="529855242"
Received: from intel-obmc.bj.intel.com (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga007.jf.intel.com with ESMTP; 16 Feb 2022 17:58:49 -0800
From:   yanjun.zhu@linux.dev
To:     mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev, leon@kernel.org
Subject: [PATCH 1/1] RDMA/irdma: Make irdma_create_mg_ctx return a void
Date:   Thu, 17 Feb 2022 13:19:38 -0500
Message-Id: <20220217181938.3798530-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The function irdma_create_mg_ctx always returns 0,
so make it void and delete the return value check.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/hw/irdma/uda.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uda.c b/drivers/infiniband/hw/irdma/uda.c
index 7a9988ddbd01..5eeb76bc29fd 100644
--- a/drivers/infiniband/hw/irdma/uda.c
+++ b/drivers/infiniband/hw/irdma/uda.c
@@ -86,8 +86,7 @@ enum irdma_status_code irdma_sc_access_ah(struct irdma_sc_cqp *cqp,
  * irdma_create_mg_ctx() - create a mcg context
  * @info: multicast group context info
  */
-static enum irdma_status_code
-irdma_create_mg_ctx(struct irdma_mcast_grp_info *info)
+static void irdma_create_mg_ctx(struct irdma_mcast_grp_info *info)
 {
 	struct irdma_mcast_grp_ctx_entry_info *entry_info = NULL;
 	u8 idx = 0; /* index in the array */
@@ -106,8 +105,6 @@ irdma_create_mg_ctx(struct irdma_mcast_grp_info *info)
 			ctx_idx++;
 		}
 	}
-
-	return 0;
 }
 
 /**
@@ -135,9 +132,7 @@ enum irdma_status_code irdma_access_mcast_grp(struct irdma_sc_cqp *cqp,
 		return IRDMA_ERR_RING_FULL;
 	}
 
-	ret_code = irdma_create_mg_ctx(info);
-	if (ret_code)
-		return ret_code;
+	irdma_create_mg_ctx(info);
 
 	set_64bit_val(wqe, 32, info->dma_mem_mc.pa);
 	set_64bit_val(wqe, 16,
-- 
2.27.0

