Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8282B30D411;
	Wed,  5 Aug 2026 05:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785908062; cv=fail; b=XWQ5bYDSPC1u9gVUSAOxQhi+hT9RmaCzvQncCGpzyfTdobbOD49wPH/NnZy6Th3FH6lQxIqjGluzvhv+pM9I9Y+29QFXh88ls9s7qTJrDjOuiwrDxux/mwzF7lHO4elFJ6rRz0vR5nB1O1Eh+xWtrtf6B6FMvkwE1n+R7uQTsBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785908062; c=relaxed/simple;
	bh=sQ9M2SSOWMS+imgfE0U4cHleALcCEcL3qco/HqqXTMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXkpsW+7t+vDvepus4Xm5zc0FdHgIr6Tl+s1prfLZcoHriLShnJ0by++IgmessuMmQHrtC54qYAVPOnQkQmYDUnac+AUQz4w+4QsI7bDTVCBpQXtFBfJFzOUvThYD4kjoIPRyKPbc+icu4BCaJ7hUo1RH+CzdW00X4QAyqwlzLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cJmcMVmT; arc=fail smtp.client-ip=52.101.62.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cJmcMVmT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=py2wiplvhekVeK1YUvf74EqVJOoiNFD9FOht9uaWNXdcj2HeJ4nZGqBB/IhFRA9hEnXjdbizaJHzUIbdWiRE85+gjZ7JnsMvVA/JqOuybtkhZyxrnxRAfRv0562F7DLCmBdgUZOd+ynAG9nN5JsrQbdsoL7NVKOu6jgIFyHXICoYNYHaBhXPw3HVduv78toea54uRaGhvgfsQjeiRorle+MXfon0wnwBIgKi3x5r+4IXf3NcFLTGp1MnPuR3boNyEVjk/ctHC6mJa+RJO7vYgs2D5FsFcBmbrBDMC0sXb+jMR9eCwTusxeEdsB+0dYC0ReKdITt9YJyrrvde7gM1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60GzUSFp06nmRtiZBk3iW0BAEUbUIRUyp6rPtVQQ65A=;
 b=aW0fBAAmI0ZNO1SpptiVW9M4UERckkGFtECnHeRxcWkCgTWe1tZGUemSi9RZpindm1oGaXZMQVhru01kzpNGQii/6B0UTOL3wbQsPpqA35tVGs4NMglbPDmrpmLL3R7j0HAFUdY15gN4/bimIg5SymXpEfw4J/7By4Z17rFF1Acx9zN1l4vqteuK9v5tH7mklbiw4bigmrq1bIiwOlJlWFjsllMdPW5di76sSKu5tc41jpIQWwO9pL3PYjWMx0dl3lOx+DaDn8dyzEBVQ2NTRUYT8/0iTDjcjPlLY/N29At9Bsd89RC0JUvZ0/MDMTAcKMySQNRAjr+T/fnwD8qnkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60GzUSFp06nmRtiZBk3iW0BAEUbUIRUyp6rPtVQQ65A=;
 b=cJmcMVmTMJEOsbLOjVATJsvFbeGYBHeyG+h3VxOfaX+fe/Qfvea3a/7RtiLvVPXHPxObIhJ5bbKYjZIvdsuxMOm9wzonrEqV+tz97jwx8O16tUTxrHfASvqKHOfif9kT4MNvegBbaYi0Vuv8JeU0ZeQH/LSLu2zFMWtcy80Pp8o=
Received: from CH2PR12CA0030.namprd12.prod.outlook.com (2603:10b6:610:57::40)
 by CH3PR12MB9146.namprd12.prod.outlook.com (2603:10b6:610:19c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Wed, 5 Aug
 2026 05:34:16 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::1f) by CH2PR12CA0030.outlook.office365.com
 (2603:10b6:610:57::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 05:34:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 05:34:15 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 00:34:15 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 5 Aug 2026 00:34:13 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [PATCH 2/2] RDMA/ionic: Embed counter driver data in rdma_counter allocation
Date: Wed, 5 Aug 2026 11:02:54 +0530
Message-ID: <20260805053254.4023262-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260805053254.4023262-1-abhijit.gangurde@amd.com>
References: <20260805053254.4023262-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|CH3PR12MB9146:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8ca4c9-0a06-458c-7977-08def2b33076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|376014|18002099003|22082099003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	G/qF9kUH9VHyqsfkeYSTyRVeDLHZjuWS8/1L4l+PE9HogJMI0FbbtNr+jElxevKzjFX+iFdZ8N7zrWabfYTaULheyUjEaBRN7d9NILui9TzzJ/a5P2lGFqahs0Ig10pkgc9c8CBmKXeO+Pf+fWynUvYknzkmTDseq9t7JeTCD8fiSZjQsHjKDJ8vUUdC0tmb4HoLKZgXDIfVW73Hfbs+5ebb/Dc41b9iVUv6Xov5fAdnPEY1qSYvcIOC/XHU8J7UI8lUxxiRdqcbWEfPZ9lpE03fi37ACvwnRN0HnUzkOESidmyXq8WW6I57S1uEuFMCWzF46CurDFOF7Oa/JIh5aeDNlJICmsiEe3w7jOISmT9kKmvEpycIr1jBUTGPdIxJnXMisYMeh9zv1GqHHm/47+Kg0Y2m7FJWq/hPFImJas2Cg5QiNWAyljCMqbt3BE1c6ZLaVA+rro4jBrKRHFUsxmnhVqFbCd+XEmi/IJY5iVfmXObW4VK7zBOs+aqxmesPxfQhb59PAWh/wiCRTIYVZhh+SSOl2ygG+OKgQCmB9eDDKHcpUFNudITyEtMdhwf/oqg5IJ9+suWav7onp5EDhTLlxqUx4CgQ3ODGiOcNiyrr/5vqpHmrPgnkcgLeU4DHFepjFHKfT9iNCxvIFEEAAhdtgAVX2fU6VG5No97DlFOd+z0lg+ynZWf9CXbfWMIDIf8Q1GkfaOBTdgYpltDF/Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(376014)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+ATGdcsp3KMBiIGGvnd9IfcAf4rH7/1PaKDPJ5hOcw2hEQRRJte+U/Ukl63Kd0yxE32eDWyGpwHHacv+VK1G5Z6R3PP6dsedZEioFwkP1ZNvaaOzfnrfS/X1MAGEVOKjWcipV/vHyJI5Rci2UhQJNdoDGXEKI5VoqAef0Gv4CfLAMsR8yQba72rvP32aN7chA05dDcqQZ0N8MTB90QpmLfDQ57s3CJH4BpdOANejSoVNkA0Ah9iz0SYRXDy6QFiSntqXwmPM/OH5ZGwCJJHYfSNcngnNL0K9jJ8hlxJMLXDdkm7Q1DaiON14kmMX7RzjA/4AVd8hpKWMO2WrZWlBM5ATfMJLoLw4KSVwg61ruzosM55uw3au9twG4zUNymrHbPNaZben86P9Gi7oOE8r/SKpBkNHP7mzwW7r9Px4KlfTCSMKlUgqyigH5lKOF/XZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 05:34:15.8768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8ca4c9-0a06-458c-7977-08def2b33076
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9146

Commit 7e53b31acc7f ("RDMA/core: Create and destroy rdma_counter using
rdma_zalloc_drv_obj()") requires drivers implementing counter ops to
embed struct rdma_counter in a driver-specific struct, register its size
via INIT_RDMA_OBJ_SIZE, and provide a counter_init callback.

The ionic driver was merged without this adaptation, causing a NULL
pointer dereference in alloc_and_bind() since rdma_zalloc_drv_obj()
allocates zero bytes when size_rdma_counter is unset.

Consolidate struct ionic_counter into a new struct ionic_rdma_counter
that embeds struct rdma_counter, replace the xarray with a lightweight
ida for ID allocation, and add the required counter_init and
INIT_RDMA_OBJ_SIZE declarations.

Fixes: ea4c399642b8 ("RDMA/ionic: Implement device stats ops")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_hw_stats.c | 95 +++++++++-----------
 drivers/infiniband/hw/ionic/ionic_ibdev.h    | 11 ++-
 2 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_hw_stats.c b/drivers/infiniband/hw/ionic/ionic_hw_stats.c
index f72c9837e135..4f0a2dedbdfe 100644
--- a/drivers/infiniband/hw/ionic/ionic_hw_stats.c
+++ b/drivers/infiniband/hw/ionic/ionic_hw_stats.c
@@ -235,35 +235,34 @@ static int ionic_get_hw_stats(struct ib_device *ibdev,
 static struct rdma_hw_stats *
 ionic_counter_alloc_stats(struct rdma_counter *counter)
 {
+	struct ionic_rdma_counter *cntr = to_ionic_rdma_counter(counter);
 	struct ionic_ibdev *dev = to_ionic_ibdev(counter->device);
-	struct ionic_counter *cntr;
-	int err;
+	struct rdma_hw_stats *stats;
+	int id;
 
-	cntr = kzalloc_obj(*cntr);
-	if (!cntr)
-		return NULL;
-
-	/* buffer for current values from the device */
 	cntr->vals = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!cntr->vals)
-		goto err_vals;
+		return NULL;
 
-	err = xa_alloc(&dev->counter_stats->xa_counters, &counter->id,
-		       cntr,
-		       XA_LIMIT(0, IONIC_MAX_QPID),
-		       GFP_KERNEL);
-	if (err)
-		goto err_xa;
+	id = ida_alloc_max(&dev->counter_stats->counter_ida,
+			   IONIC_MAX_QPID, GFP_KERNEL);
+	if (id < 0)
+		goto err_ida;
 
-	INIT_LIST_HEAD(&cntr->qp_list);
+	counter->id = id;
+
+	stats = rdma_alloc_hw_stats_struct(dev->counter_stats->stats_hdrs,
+					   dev->counter_stats->queue_stats_count,
+					   RDMA_HW_STATS_DEFAULT_LIFESPAN);
+	if (!stats)
+		goto err_hw_stats;
+
+	return stats;
 
-	return rdma_alloc_hw_stats_struct(dev->counter_stats->stats_hdrs,
-					 dev->counter_stats->queue_stats_count,
-					 RDMA_HW_STATS_DEFAULT_LIFESPAN);
-err_xa:
+err_hw_stats:
+	ida_free(&dev->counter_stats->counter_ida, id);
+err_ida:
 	kfree(cntr->vals);
-err_vals:
-	kfree(cntr);
 
 	return NULL;
 }
@@ -271,14 +270,10 @@ ionic_counter_alloc_stats(struct rdma_counter *counter)
 static int ionic_counter_dealloc(struct rdma_counter *counter)
 {
 	struct ionic_ibdev *dev = to_ionic_ibdev(counter->device);
-	struct ionic_counter *cntr;
-
-	cntr = xa_erase(&dev->counter_stats->xa_counters, counter->id);
-	if (!cntr)
-		return -EINVAL;
+	struct ionic_rdma_counter *cntr = to_ionic_rdma_counter(counter);
 
+	ida_free(&dev->counter_stats->counter_ida, counter->id);
 	kfree(cntr->vals);
-	kfree(cntr);
 
 	return 0;
 }
@@ -287,13 +282,8 @@ static int ionic_counter_bind_qp(struct rdma_counter *counter,
 				 struct ib_qp *ibqp,
 				 u32 port)
 {
-	struct ionic_ibdev *dev = to_ionic_ibdev(counter->device);
+	struct ionic_rdma_counter *cntr = to_ionic_rdma_counter(counter);
 	struct ionic_qp *qp = to_ionic_qp(ibqp);
-	struct ionic_counter *cntr;
-
-	cntr = xa_load(&dev->counter_stats->xa_counters, counter->id);
-	if (!cntr)
-		return -EINVAL;
 
 	list_add_tail(&qp->qp_list_counter, &cntr->qp_list);
 	ibqp->counter = counter;
@@ -313,29 +303,23 @@ static int ionic_counter_unbind_qp(struct ib_qp *ibqp, u32 port)
 	return 0;
 }
 
-static int ionic_get_qp_stats(struct ib_device *ibdev,
-			      struct rdma_hw_stats *hw_stats,
-			      u32 counter_id)
+static int ionic_counter_update_stats(struct rdma_counter *counter)
 {
-	struct ionic_ibdev *dev = to_ionic_ibdev(ibdev);
-	struct ionic_counter_stats *cs;
-	struct ionic_counter *cntr;
+	struct ionic_rdma_counter *cntr = to_ionic_rdma_counter(counter);
+	struct ionic_ibdev *dev = to_ionic_ibdev(counter->device);
+	struct ionic_counter_stats *cs = dev->counter_stats;
 	dma_addr_t hw_stats_dma;
 	struct ionic_qp *qp;
 	int rc, stat_i = 0;
 
-	cs = dev->counter_stats;
-	cntr = xa_load(&cs->xa_counters, counter_id);
-	if (!cntr)
-		return -EINVAL;
-
 	hw_stats_dma = dma_map_single(dev->lif_cfg.hwdev, cntr->vals,
 				      PAGE_SIZE, DMA_FROM_DEVICE);
 	rc = dma_mapping_error(dev->lif_cfg.hwdev, hw_stats_dma);
 	if (rc)
 		return rc;
 
-	memset(hw_stats->value, 0, sizeof(u64) * hw_stats->num_counters);
+	memset(counter->stats->value, 0,
+	       sizeof(u64) * counter->stats->num_counters);
 
 	list_for_each_entry(qp, &cntr->qp_list, qp_list_counter) {
 		rc = ionic_hw_stats_cmd(dev, hw_stats_dma, PAGE_SIZE,
@@ -345,7 +329,7 @@ static int ionic_get_qp_stats(struct ib_device *ibdev,
 			goto err_cmd;
 
 		for (stat_i = 0; stat_i < cs->queue_stats_count; ++stat_i)
-			hw_stats->value[stat_i] +=
+			counter->stats->value[stat_i] +=
 				ionic_v1_stat_val(&cs->hdr[stat_i],
 						  cntr->vals,
 						  PAGE_SIZE);
@@ -360,11 +344,6 @@ static int ionic_get_qp_stats(struct ib_device *ibdev,
 	return rc;
 }
 
-static int ionic_counter_update_stats(struct rdma_counter *counter)
-{
-	return ionic_get_qp_stats(counter->device, counter->stats, counter->id);
-}
-
 static int ionic_alloc_counters(struct ionic_ibdev *dev)
 {
 	struct ionic_counter_stats *cs = dev->counter_stats;
@@ -424,12 +403,22 @@ static const struct ib_device_ops ionic_hw_stats_ops = {
 	.get_hw_stats = ionic_get_hw_stats,
 };
 
+static void ionic_counter_init(struct rdma_counter *counter)
+{
+	struct ionic_rdma_counter *cntr = to_ionic_rdma_counter(counter);
+
+	INIT_LIST_HEAD(&cntr->qp_list);
+}
+
 static const struct ib_device_ops ionic_counter_stats_ops = {
 	.counter_alloc_stats = ionic_counter_alloc_stats,
 	.counter_dealloc = ionic_counter_dealloc,
 	.counter_bind_qp = ionic_counter_bind_qp,
 	.counter_unbind_qp = ionic_counter_unbind_qp,
 	.counter_update_stats = ionic_counter_update_stats,
+	.counter_init = ionic_counter_init,
+
+	INIT_RDMA_OBJ_SIZE(rdma_counter, ionic_rdma_counter, rdma_counter),
 };
 
 void ionic_stats_init(struct ionic_ibdev *dev)
@@ -458,7 +447,7 @@ void ionic_stats_init(struct ionic_ibdev *dev)
 			return;
 		}
 
-		xa_init_flags(&dev->counter_stats->xa_counters, XA_FLAGS_ALLOC);
+		ida_init(&dev->counter_stats->counter_ida);
 
 		ib_set_device_ops(&dev->ibdev, &ionic_counter_stats_ops);
 	}
@@ -467,7 +456,7 @@ void ionic_stats_init(struct ionic_ibdev *dev)
 void ionic_stats_cleanup(struct ionic_ibdev *dev)
 {
 	if (dev->counter_stats) {
-		xa_destroy(&dev->counter_stats->xa_counters);
+		ida_destroy(&dev->counter_stats->counter_ida);
 		kfree(dev->counter_stats->hdr);
 		kfree(dev->counter_stats->stats_hdrs);
 		kfree(dev->counter_stats);
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index 63828240d659..1c43344ec93c 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -331,14 +331,21 @@ struct ionic_counter_stats {
 	int queue_stats_count;
 	struct ionic_v1_stat *hdr;
 	struct rdma_stat_desc *stats_hdrs;
-	struct xarray xa_counters;
+	struct ida counter_ida;
 };
 
-struct ionic_counter {
+struct ionic_rdma_counter {
+	struct rdma_counter rdma_counter;
 	void *vals;
 	struct list_head qp_list;
 };
 
+static inline struct ionic_rdma_counter *
+to_ionic_rdma_counter(struct rdma_counter *counter)
+{
+	return container_of(counter, struct ionic_rdma_counter, rdma_counter);
+}
+
 static inline struct ionic_ibdev *to_ionic_ibdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct ionic_ibdev, ibdev);
-- 
2.43.0

