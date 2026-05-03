Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F15221277
	for <linux-rdma@vger.kernel.org>; Sun,  3 May 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777820593; cv=none; b=J78PPl7etHgch8N7HE/Ygz7EqPtrK0swPZcNfgMGYYkL53HEiPWNliV9tm1h60oK5Wo4npda3hWdq1ImEmsgGKD7YHXK8aLW9pvsuZFXaQx6MGFcFqvc1hNGgEWmMqParDOO8DqQR7Me5gcZX/P2zgmMCcY/61ZfVUeobe6jUmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777820593; c=relaxed/simple;
	bh=SmsycKGD84uJFaDjMDDWUHCx2uTB4vhTDJlj2677Qtg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bq3z7Abt4oigLCnWaAwkA8zdjZexdsI7Uj3xfZOEd36WmN2cibKP6fPSpvdoi8Q2Q+AtSxU+k63FGlq47A+7/jwBSQQaXBcFB/2URszrG+V+YOYP7ndfbzSFOkmX074GfjRr1AQED2H1kHiFTjkTz4FGMGIeqNeflemSbrkl6vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QDt7Yj6+; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QDt7Yj6+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1777820592; x=1809356592;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZTek/PqlERtw4aDUX53B5sjYEKk/hI+lcAatxAvbUsc=;
  b=QDt7Yj6+JHQoo19J6daVeWcf8vJxnUlkqHt8astcxkbFRAwccF5NNN+j
   /J10oaacsYKHPWUEdC49vV/DcSg2uNhaj46SIEFd+9KYakBJJ+3cOlVQ1
   nDPvP94Gx9FFH4SAs0X0MP7bZL8DTOXdcqHQ++wjg/Dc0hZhOo6dBERDj
   kNpLh5U45tJM3iQjQakTNAUkdgTAasUZGT7wNQb8RO4Mlaiz5yliNzz0D
   I7AYPXUvxRNIxgp6PIUoIDdWCs3UjS1bP49yA40LEdLXEhb6vfu6fPEO2
   rok4VM2qlmKnzHw+v41NGnEAcOQF3CFyHgBr1rqWQ0lteBpNHiffSg4xU
   Q==;
X-CSE-ConnectionGUID: iUMnMRKETXOs6Md6nHR0XQ==
X-CSE-MsgGUID: zEqVtW7+QPyhGiCquA+taA==
X-IronPort-AV: E=Sophos;i="6.23,213,1770595200"; 
   d="scan'208";a="18618950"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 15:03:09 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:15264]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.4.227:2525] with esmtp (Farcaster)
 id 0105a5a8-e8fc-42d5-8fb3-cefe490c5d56; Sun, 3 May 2026 15:03:09 +0000 (UTC)
X-Farcaster-Flow-ID: 0105a5a8-e8fc-42d5-8fb3-cefe490c5d56
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 3 May 2026 15:03:05 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Sun, 3 May 2026
 15:03:03 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, "Yehuda
 Yitschak" <yehuday@amazon.com>
Subject: [PATCH for-next] RDMA/efa: Expose device P2P DMA support via device query
Date: Sun, 3 May 2026 15:02:46 +0000
Message-ID: <20260503150246.2349679-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Expose device P2P DMA support using the query device verbs.
If the device support P2P DMA, it can DMA directly to and from a peer
PCIe device

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Yehuda Yitschak <yehuday@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 10 +++++++++-
 drivers/infiniband/hw/efa/efa_verbs.c           |  3 +++
 include/uapi/rdma/efa-abi.h                     |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index ad34ea5da6b0..097b3303f3e9 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -725,7 +725,11 @@ struct efa_admin_feature_device_attr_desc {
 	 *    on TX queues
 	 * 4 : unsolicited_write_recv - If set, unsolicited
 	 *    write with imm. receive is supported
-	 * 31:5 : reserved - MBZ
+	 * 5 : event_counters - If set, event counters are
+	 *    supported
+	 * 6 : p2p_dma - If set the device can DMA directly
+	 *    to and from a peer PCIe device
+	 * 31:7 : reserved - MBZ
 	 */
 	u32 device_caps;
 
@@ -1132,6 +1136,10 @@ struct efa_admin_host_info {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_DATA_POLLING_128_MASK BIT(2)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_SHIFT 5
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_P2P_DMA_SHIFT    6
+#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_P2P_DMA_MASK     BIT(6)
 
 /* create_eq_cmd */
 #define EFA_ADMIN_CREATE_EQ_CMD_ENTRY_SIZE_WORDS_MASK       GENMASK(4, 0)
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 7bd0838ebc99..b16f470f7d30 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -270,6 +270,9 @@ int efa_query_device(struct ib_device *ibdev,
 		if (EFA_DEV_CAP(dev, UNSOLICITED_WRITE_RECV))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV;
 
+		if (EFA_DEV_CAP(dev, P2P_DMA))
+			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_P2P_DMA;
+
 		if (dev->neqs)
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_CQ_NOTIFICATIONS;
 
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index d5c18f8de182..d19cb59d822d 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -133,6 +133,7 @@ enum {
 	EFA_QUERY_DEVICE_CAPS_RDMA_WRITE = 1 << 5,
 	EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV = 1 << 6,
 	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
+	EFA_QUERY_DEVICE_CAPS_P2P_DMA = 1 << 8,
 };
 
 struct efa_ibv_ex_query_device_resp {
-- 
2.50.1

