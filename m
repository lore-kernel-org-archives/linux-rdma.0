Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F412EC433FE
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 19:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB68D6120E
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 19:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhIPTOV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:14:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:63939 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233872AbhIPTOP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Sep 2021 15:14:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="220757292"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="220757292"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 12:12:37 -0700
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="545830748"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.81.178])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 12:12:36 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org,
        Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH rdma-rc 2/4] RDMA/irdma: Validate number of CQ entries on create CQ
Date:   Thu, 16 Sep 2021 14:12:20 -0500
Message-Id: <20210916191222.824-3-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210916191222.824-1-shiraz.saleem@intel.com>
References: <20210916191222.824-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

Add lower bound check for CQ entries at creation time.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 829ddfa7e144..23c47482c749 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2034,7 +2034,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		/* Kmode allocations */
 		int rsize;
 
-		if (entries > rf->max_cqe) {
+		if (entries < 1 || entries > rf->max_cqe) {
 			err_code = -EINVAL;
 			goto cq_free_rsrc;
 		}
-- 
2.27.0

