Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47360C4345E
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Mar 2021 00:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12701619DB
	for <linux-rdma@archiver.kernel.org>; Wed, 24 Mar 2021 00:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhCXAD7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 23 Mar 2021 20:03:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:37624 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234381AbhCXADq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 23 Mar 2021 20:03:46 -0400
IronPort-SDR: XwxcD26wZWbfdd5MEXZ2YDCr3lrdgnD6DPatLm0SbUBLL3hkA/s9XqtCeFrp3YHb+AmwGbeGJ+
 7bY3vvMa/b3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="170556675"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="170556675"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:46 -0700
IronPort-SDR: IAjqE2wQFx4oOaiYY/ZHBLkmsyGmquzE5v7IvB5+BWhQ07hc9DGVLEAfV3qY9ed6dI/NFo0b3u
 Tfg6Ci+hFd1A==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381542336"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.103.207])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:45 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 23/23] RDMA/irdma: Update MAINTAINERS file
Date:   Tue, 23 Mar 2021 19:00:07 -0500
Message-Id: <20210324000007.1450-24-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210324000007.1450-1-shiraz.saleem@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Add maintainer entry for irdma driver.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 211fbc4..6b0aeaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8958,6 +8958,14 @@ F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
 F:	include/linux/net/intel/iidc.h
 
+INTEL ETHERNET PROTOCOL DRIVER FOR RDMA
+M:	Mustafa Ismail <mustafa.ismail@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/irdma/
+F:	include/uapi/rdma/irdma-abi.h
+
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
 L:	linux-fbdev@vger.kernel.org
-- 
1.8.3.1

