Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8F1C43219
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 19:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC3B61212
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Sep 2021 19:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhIPTOW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:14:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:63939 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234765AbhIPTOQ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 16 Sep 2021 15:14:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="220757297"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="220757297"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 12:12:37 -0700
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="545830757"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.81.178])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 12:12:37 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com
Cc:     linux-rdma@vger.kernel.org,
        Sindhu Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH rdma-rc 3/4] RDMA/irdma: Report correct WC error when transport retry counter is exceeded
Date:   Thu, 16 Sep 2021 14:12:21 -0500
Message-Id: <20210916191222.824-4-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210916191222.824-1-shiraz.saleem@intel.com>
References: <20210916191222.824-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Sindhu Devale <sindhu.devale@intel.com>

When the retry counter exceeds, as the remote QP didn't send any Ack or
Nack an asynchronous event (AE) for too many retries is generated. Add
code to handle the AE and set the correct IB WC error code
IB_WC_RETRY_EXC_ERR.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/hw.c    | 3 +++
 drivers/infiniband/hw/irdma/user.h  | 1 +
 drivers/infiniband/hw/irdma/verbs.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 33c06a3a4f63..cb9a8e24e3b7 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -176,6 +176,9 @@ static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
 	case IRDMA_AE_LLP_RECEIVED_MPA_CRC_ERROR:
 		qp->flush_code = FLUSH_GENERAL_ERR;
 		break;
+	case IRDMA_AE_LLP_TOO_MANY_RETRIES:
+		qp->flush_code = FLUSH_RETRY_EXC_ERR;
+		break;
 	default:
 		qp->flush_code = FLUSH_FATAL_ERR;
 		break;
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index ff705f323233..267102d1049d 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -102,6 +102,7 @@ enum irdma_flush_opcode {
 	FLUSH_REM_OP_ERR,
 	FLUSH_LOC_LEN_ERR,
 	FLUSH_FATAL_ERR,
+	FLUSH_RETRY_EXC_ERR,
 };
 
 enum irdma_cmpl_status {
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 23c47482c749..c7e129ee74d0 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3352,6 +3352,8 @@ static enum ib_wc_status irdma_flush_err_to_ib_wc_status(enum irdma_flush_opcode
 		return IB_WC_LOC_LEN_ERR;
 	case FLUSH_GENERAL_ERR:
 		return IB_WC_WR_FLUSH_ERR;
+	case FLUSH_RETRY_EXC_ERR:
+		return IB_WC_RETRY_EXC_ERR;
 	case FLUSH_FATAL_ERR:
 	default:
 		return IB_WC_FATAL_ERR;
-- 
2.27.0

