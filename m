Return-Path: <SRS0=EG8C=3Y=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B0AC2D0B1
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 13:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DA412084E
	for <linux-rdma@archiver.kernel.org>; Tue,  4 Feb 2020 13:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgBDNzZ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 4 Feb 2020 08:55:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:59682 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbgBDNzZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 4 Feb 2020 08:55:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 05:55:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,402,1574150400"; 
   d="scan'208";a="279064808"
Received: from awfm-01.aw.intel.com ([10.228.212.213])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Feb 2020 05:55:24 -0800
From:   "Goldman, Adam" <adam.goldman@intel.com>
To:     linux-rdma@vger.kernel.org
Cc:     mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        "Goldman, Adam" <adam.goldman@intel.com>
Subject: [PATCH] kernel-boot: Do not perform device rename on OPA devices
Date:   Tue,  4 Feb 2020 08:55:20 -0500
Message-Id: <1580824520-38122-1-git-send-email-adam.goldman@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: "Goldman, Adam" <adam.goldman@intel.com>

PSM2 will not run with recent rdma-core releases. Several tools and
libraries like PSM2, require the hfi1 name to be present.

Recent rdma-core releases added a new feature to rename kernel devices,
but the default configuration will not work with hfi1 fabrics.

Related opa-psm2 github issue:
  https://github.com/intel/opa-psm2/issues/43

Fixes: 5b4099d47be3 ("kernel-boot: Perform device rename to make stable names")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Goldman, Adam <adam.goldman@intel.com>
---
 kernel-boot/rdma-persistent-naming.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-boot/rdma-persistent-naming.rules b/kernel-boot/rdma-persistent-naming.rules
index 9b61e16..95d6851 100644
--- a/kernel-boot/rdma-persistent-naming.rules
+++ b/kernel-boot/rdma-persistent-naming.rules
@@ -25,4 +25,4 @@
 #   Device type = RoCE
 #   mlx5_0 -> rocex525400c0fe123455
 #
-ACTION=="add", SUBSYSTEM=="infiniband", PROGRAM="rdma_rename %k NAME_FALLBACK"
+ACTION=="add", SUBSYSTEM=="infiniband", KERNEL!="hfi1*", PROGRAM="rdma_rename %k NAME_FALLBACK"
-- 
1.8.3.1

