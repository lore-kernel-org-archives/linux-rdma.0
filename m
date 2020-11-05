Return-Path: <SRS0=hjws=EL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4424EC55178
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 22:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0932721D46
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgKEWeY (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Nov 2020 17:34:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:40478 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgKEWeW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Nov 2020 17:34:22 -0500
IronPort-SDR: Ht3fYDF4pQS4ugeHNTqeSGIOYwTM5Yj9a9/RHUfbEaarsFWfl9PTbv4ENiKvzJfAcQ5EGIfu80
 nJDruSvOEyDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169619067"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="169619067"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 14:34:22 -0800
IronPort-SDR: OWoIXfLA49JmhHsQGUKvn+8PPzZYe72d6Finy4GRjlXbWeD3b6PZw2zrDdMKTvPct+Nr/Jmdrp
 CRsDHEm5SUkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="363980570"
Received: from cst-dev.jf.intel.com ([10.23.221.69])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Nov 2020 14:34:21 -0800
From:   Jianxin Xiong <jianxin.xiong@intel.com>
To:     linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Jianxin Xiong <jianxin.xiong@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian Koenig <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH v8 5/5] dma-buf: Reject attach request from importers that use dma_virt_ops
Date:   Thu,  5 Nov 2020 14:48:09 -0800
Message-Id: <1604616489-69267-6-git-send-email-jianxin.xiong@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604616489-69267-1-git-send-email-jianxin.xiong@intel.com>
References: <1604616489-69267-1-git-send-email-jianxin.xiong@intel.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

dma_virt_ops is used by virtual devices that map pages / scatterlists to
virtual addresses for CPU access instead of performing DMA. This is not
the intended use of dma_buf_attach() and dma_buf_map_attachment(). CPU
access of dma-buf should use dma_buf_vmap() and related functions.

Signed-off-by: Jianxin Xiong <jianxin.xiong@intel.com>
---
 drivers/dma-buf/dma-buf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 9a054fb5..ba2b877 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -686,6 +686,11 @@ struct dma_buf_attachment *
 	if (WARN_ON(importer_ops && !importer_ops->move_notify))
 		return ERR_PTR(-EINVAL);
 
+#ifdef CONFIG_DMA_VIRT_OPS
+	if (dev->dma_ops == &dma_virt_ops)
+		return ERR_PTR(-EINVAL);
+#endif
+
 	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
-- 
1.8.3.1

