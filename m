Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B1330B3A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Feb 2026 11:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771327403; cv=none; b=ptPOJC2q5KwjtciWBnYuR4KtAywh+9P370Ks9MHyiwkAPFZFj5ho94FK+6pj3ZlanYq8nMror7+E1EzGOYqIQs//3BKAJZjJzF3GxasSxj9jSGeYL7mVYxUoyPz4ju+KSYLkWV4Jh5UQ0o7Ua7GcPQDWC05Wg2MzmXgro1V2U+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771327403; c=relaxed/simple;
	bh=eoCMO3CFpgkaXHHDn3qAjJySkiVBtp6elIS3neRUkHg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ocOiQnKZgKX4dzbh0epHml30NwK4A7dfFS28Gfu7Nh/JF8U4G+TNTCdDL5V62zSjMtMQVYntY6el0uh0FCz82tGj9qyGp/ForPj62T7p4ElJXpXPY6p3lPvuq2KClb3kFT1ZvK3DVIMORqtMrZcHGezf5WuiSdjJIKkfSPgb7qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=iU4kXJ3W; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="iU4kXJ3W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771327402; x=1802863402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BjiY4pa9Wc/alKfWmH+4DTWD8kEYoq2dhsDUNacBem0=;
  b=iU4kXJ3Wuz5liDdHbyJ9BDDApFxDO4GsE6VgVXLnHaj4nsXeIpDv8pIu
   G9YdcQ0JcDlXeluZoPBI7Eor31ODyLlyfITDWkyE+AYQU1/KEHWPIJNt/
   FU9Gnh/MySedgtPF0OY0os50mswOCxhfO8eYozaFE1kbYVSdsgCOO+f+0
   ZA6wBxip38M/rEpK1bQj5yrxAgoizKd8/uJrtNsGr3wK2FZJgtkoTZcow
   2FcF5aZyaNevvO/QnfzV+v0z9E701ON9vJ5M2MntTe2ezugrDEAe9ZFAR
   lJgHtnDyUhz9OBgUqqy3v+ezEsGS01dpjV13uxVPcSGgGzKFfF4RxXBHI
   w==;
X-CSE-ConnectionGUID: hMAytNqbRKqdTEjhBZRAvQ==
X-CSE-MsgGUID: UIBfXni3S3SkuhM0bSJ3+w==
X-IronPort-AV: E=Sophos;i="6.21,296,1763424000"; 
   d="scan'208";a="13207251"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 11:23:18 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:1450]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.96:2525] with esmtp (Farcaster)
 id eabce09c-3ab6-4c80-85e3-36328441eca6; Tue, 17 Feb 2026 11:23:18 +0000 (UTC)
X-Farcaster-Flow-ID: eabce09c-3ab6-4c80-85e3-36328441eca6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Tue, 17 Feb 2026 11:23:18 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Tue, 17 Feb 2026
 11:23:16 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v3 1/3] RDMA/efa: Rename admin queue attributes struct name for extendability
Date: Tue, 17 Feb 2026 11:23:02 +0000
Message-ID: <20260217112304.36849-2-ynachum@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260217112304.36849-1-ynachum@amazon.com>
References: <20260217112304.36849-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

As preparation for adding a second queue attributes query, change the
name of the existing queue attributes.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 .../infiniband/hw/efa/efa_admin_cmds_defs.h   |  8 ++--
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 40 +++++++++----------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index 57178dad5eb7..5bbc765b6e3f 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
 /*
- * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #ifndef _EFA_ADMIN_CMDS_H_
@@ -38,7 +38,7 @@ enum efa_admin_aq_feature_id {
 	EFA_ADMIN_DEVICE_ATTR                       = 1,
 	EFA_ADMIN_AENQ_CONFIG                       = 2,
 	EFA_ADMIN_NETWORK_ATTR                      = 3,
-	EFA_ADMIN_QUEUE_ATTR                        = 4,
+	EFA_ADMIN_QUEUE_ATTR_1                      = 4,
 	EFA_ADMIN_HW_HINTS                          = 5,
 	EFA_ADMIN_HOST_INFO                         = 6,
 	EFA_ADMIN_EVENT_QUEUE_ATTR                  = 7,
@@ -744,7 +744,7 @@ struct efa_admin_feature_device_attr_desc {
 	u32 reserved1;
 };
 
-struct efa_admin_feature_queue_attr_desc {
+struct efa_admin_feature_queue_attr_desc_1 {
 	/* The maximum number of queue pairs supported */
 	u32 max_qp;
 
@@ -872,7 +872,7 @@ struct efa_admin_get_feature_resp {
 
 		struct efa_admin_feature_network_attr_desc network_attr;
 
-		struct efa_admin_feature_queue_attr_desc queue_attr;
+		struct efa_admin_feature_queue_attr_desc_1 queue_attr_1;
 
 		struct efa_admin_event_queue_attr_desc event_queue_attr;
 
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index 9ead02800ac7..592c420e4473 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2025 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include "efa_com.h"
@@ -479,31 +479,31 @@ int efa_com_get_device_attr(struct efa_com_dev *edev,
 
 	edev->supported_features = resp.u.device_attr.supported_features;
 	err = efa_com_get_feature(edev, &resp,
-				  EFA_ADMIN_QUEUE_ATTR);
+				  EFA_ADMIN_QUEUE_ATTR_1);
 	if (err) {
 		ibdev_err_ratelimited(edev->efa_dev,
-				      "Failed to get queue attributes %d\n",
+				      "Failed to get queue attributes1 %d\n",
 				      err);
 		return err;
 	}
 
-	result->max_qp = resp.u.queue_attr.max_qp;
-	result->max_sq_depth = resp.u.queue_attr.max_sq_depth;
-	result->max_rq_depth = resp.u.queue_attr.max_rq_depth;
-	result->max_cq = resp.u.queue_attr.max_cq;
-	result->max_cq_depth = resp.u.queue_attr.max_cq_depth;
-	result->inline_buf_size = resp.u.queue_attr.inline_buf_size;
-	result->max_sq_sge = resp.u.queue_attr.max_wr_send_sges;
-	result->max_rq_sge = resp.u.queue_attr.max_wr_recv_sges;
-	result->max_mr = resp.u.queue_attr.max_mr;
-	result->max_mr_pages = resp.u.queue_attr.max_mr_pages;
-	result->max_pd = resp.u.queue_attr.max_pd;
-	result->max_ah = resp.u.queue_attr.max_ah;
-	result->max_llq_size = resp.u.queue_attr.max_llq_size;
-	result->sub_cqs_per_cq = resp.u.queue_attr.sub_cqs_per_cq;
-	result->max_wr_rdma_sge = resp.u.queue_attr.max_wr_rdma_sges;
-	result->max_tx_batch = resp.u.queue_attr.max_tx_batch;
-	result->min_sq_depth = resp.u.queue_attr.min_sq_depth;
+	result->max_qp = resp.u.queue_attr_1.max_qp;
+	result->max_sq_depth = resp.u.queue_attr_1.max_sq_depth;
+	result->max_rq_depth = resp.u.queue_attr_1.max_rq_depth;
+	result->max_cq = resp.u.queue_attr_1.max_cq;
+	result->max_cq_depth = resp.u.queue_attr_1.max_cq_depth;
+	result->inline_buf_size = resp.u.queue_attr_1.inline_buf_size;
+	result->max_sq_sge = resp.u.queue_attr_1.max_wr_send_sges;
+	result->max_rq_sge = resp.u.queue_attr_1.max_wr_recv_sges;
+	result->max_mr = resp.u.queue_attr_1.max_mr;
+	result->max_mr_pages = resp.u.queue_attr_1.max_mr_pages;
+	result->max_pd = resp.u.queue_attr_1.max_pd;
+	result->max_ah = resp.u.queue_attr_1.max_ah;
+	result->max_llq_size = resp.u.queue_attr_1.max_llq_size;
+	result->sub_cqs_per_cq = resp.u.queue_attr_1.sub_cqs_per_cq;
+	result->max_wr_rdma_sge = resp.u.queue_attr_1.max_wr_rdma_sges;
+	result->max_tx_batch = resp.u.queue_attr_1.max_tx_batch;
+	result->min_sq_depth = resp.u.queue_attr_1.min_sq_depth;
 
 	err = efa_com_get_feature(edev, &resp, EFA_ADMIN_NETWORK_ATTR);
 	if (err) {
-- 
2.47.3

