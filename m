Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C317C4338F
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Aug 2021 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 499D1613D0
	for <linux-rdma@archiver.kernel.org>; Mon, 23 Aug 2021 15:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhHWPt6 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:49:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:27938 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhHWPtv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 23 Aug 2021 11:49:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="302712462"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="302712462"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 08:48:52 -0700
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="684434343"
Received: from tenikolo-mobl1.amr.corp.intel.com ([10.212.22.232])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 08:48:51 -0700
From:   Tatyana Nikolova <tatyana.e.nikolova@intel.com>
To:     jgg@nvidia.com, dledford@redhat.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Subject: [PATCH v2 rdma-core] irdma: Add ice and irdma to kernel-boot rules
Date:   Mon, 23 Aug 2021 10:48:16 -0500
Message-Id: <20210823154816.2027-1-tatyana.e.nikolova@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add ice and irdma to kernel-boot rules so that
these devices are recognized as iWARP and RoCE capable.

Otherwise the port mapper service which is only relevant
for iWARP devices may not start automatically after boot.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
---
 kernel-boot/rdma-description.rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-description.rules
index 48a7ced..f2f7b38 100644
--- a/kernel-boot/rdma-description.rules
+++ b/kernel-boot/rdma-description.rules
@@ -24,11 +24,13 @@ DRIVERS=="hfi1", ENV{ID_RDMA_OPA}="1"
 # Hardware that supports iWarp
 DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
 DRIVERS=="i40e", ENV{ID_RDMA_IWARP}="1"
+DRIVERS=="ice", ENV{ID_RDMA_IWARP}="1"
 
 # Hardware that supports RoCE
 DRIVERS=="be2net", ENV{ID_RDMA_ROCE}="1"
 DRIVERS=="bnxt_en", ENV{ID_RDMA_ROCE}="1"
 DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
+DRIVERS=="ice", ENV{ID_RDMA_ROCE}="1"
 DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
 DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
 DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
-- 
1.8.3.1

