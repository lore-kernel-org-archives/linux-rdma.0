Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87DDC433F5
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Feb 2022 13:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiBRN3E (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Feb 2022 08:29:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBRN3E (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 18 Feb 2022 08:29:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B5629693B
        for <linux-rdma@vger.kernel.org>; Fri, 18 Feb 2022 05:28:47 -0800 (PST)
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="238529357"
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="238529357"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 05:28:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,378,1635231600"; 
   d="scan'208";a="489452705"
Received: from intel-obmc.bj.intel.com (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga003.jf.intel.com with ESMTP; 18 Feb 2022 05:28:45 -0800
From:   yanjun.zhu@linux.dev
To:     mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev, leon@kernel.org
Subject: [PATCH 2/3] RDMA/irdma: Remove the unnecessary variable saddr
Date:   Sat, 19 Feb 2022 00:49:17 -0500
Message-Id: <20220219054918.3819830-2-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220219054918.3819830-1-yanjun.zhu@linux.dev>
References: <20220219054918.3819830-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The variable saddr is to check the type of a network. Now the
variable net_type is used to do the same work. So it is removed.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 -
 drivers/infiniband/hw/irdma/verbs.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b306c50d0f8e..7e4d0cc9222f 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4155,7 +4155,6 @@ static int irdma_create_ah(struct ib_ah *ibah,
 	struct irdma_ah_info *ah_info;
 	struct irdma_create_ah_resp uresp;
 	union {
-		struct sockaddr saddr;
 		struct sockaddr_in saddr_in;
 		struct sockaddr_in6 saddr_in6;
 	} sgid_addr, dgid_addr;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index d0fdef8d09ea..d2d4a7e5f954 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -29,7 +29,6 @@ struct irdma_av {
 	u8 macaddr[16];
 	struct rdma_ah_attr attrs;
 	union {
-		struct sockaddr saddr;
 		struct sockaddr_in saddr_in;
 		struct sockaddr_in6 saddr_in6;
 	} sgid_addr, dgid_addr;
-- 
2.27.0

