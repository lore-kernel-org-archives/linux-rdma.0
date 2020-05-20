Return-Path: <SRS0=bXLp=7C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC47C433E0
	for <linux-rdma@archiver.kernel.org>; Wed, 20 May 2020 07:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB19206C3
	for <linux-rdma@archiver.kernel.org>; Wed, 20 May 2020 07:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgETHQL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 20 May 2020 03:16:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:50747 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgETHQL (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 20 May 2020 03:16:11 -0400
IronPort-SDR: EIWTm0YC5IHLA4uMNiuL1g7em9ogUPOK5NwEjhvbNmKo72yYSYwqhK0V85AuL/fZS9fj0AAfbT
 rQqRjlHeKGRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 00:04:20 -0700
IronPort-SDR: jKXi83yAslZwbvVzs8bsJY0WrC3Pb1Dxh1PfVFPlBChAozaDKlZtToPkNlHWXXeZzv2DRflXJY
 KxTC39/lhmgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="264581261"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 20 May 2020 00:04:19 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net,
        gregkh@linuxfoundation.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: [RDMA RFC v6 16/16] RDMA/irdma: Update MAINTAINERS file
Date:   Wed, 20 May 2020 00:04:15 -0700
Message-Id: <20200520070415.3392210-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add maintainer entry for irdma driver.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 598d0e1b3501..8b8e3e0064cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8745,6 +8745,14 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/cpufreq/intel_pstate.c
 
+INTEL ETHERNET PROTOCL DRIVER FOR RDMA
+M:	Mustafa Ismail <mustafa.ismail@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/irdma/
+F:	include/uapi/rdma/irdma-abi.h
+
 INTEL SPEED SELECT TECHNOLOGY
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.26.2

