Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1303B30566F
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481470; cv=fail; b=erBo1ojBXwSNvMEuBvoan4A8zD2LnbOGgGApOtLpHkYta/jJIEuF+ZAlkzvGbZ4ioNcGmbzQ0vKjlughNPJuiCUuR3r/n0TAEk128gvlBpdw6p7zPAYwdaA88URjH97w803bidu5ABnZBXbqQE46tlHr1Q8LAdFcUibXw0xeUMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481470; c=relaxed/simple;
	bh=p6H8L2nNlYDVupxBae7zY/qPjcvm/lF8Y4owzjonEMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K7H+ZU2UJBv9lWyHPLjJwuxFyp8XsxBOYyXGOPXQPgryWFDTWeYRRTRR8iqJinr/bA9n2w6FdqfG0FagcwraATmEPi55Xf6mK+me6ovERxe/RQTelm8NSFKP1duDGbbdXu7Yd2TVe7cHOKlui8gCBcSD65nMS/lChEDZbd3nHIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pCqXJQNJ; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pCqXJQNJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmE88PepKxhUqg6HZghT2xKBJ88Su15f48Kg74CNTWf8EVdMXrVsvmzker1Tgo/JhzEs9mPOvvKyT/ClogAeLyxd+S1B2yGNANf+Ag0UoidJJNddozg5TP3lVQ3MkJDehIGZbD41K3OLLYrFMeruCeZUrwlrbs+kJf572K99oZMjIsuBPMeeZIUU0vPR7eeY7sMoHykQG9uefBaIagFjSAL7p5am6BpOeFHovJfHPY8KcDpKdfPIQapfE3yHGbZx4JlDbHvOHDWp40W1t6TcPHAavRWag0wV0hHP/hioH/afXOJJ/JlDlKrAHhNK28NelX75uwrzh97oYDXscPhoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6eVPzHUZN/38iXipC5ANN9qYyzob6O621gBwVrdOmI=;
 b=nldFNP1WCIwsugEp0vV5B2w8lHe2GBvF4xf3/UIVXDV7J6V/IDn8yRXlebX2HM8XKM4sqXAB9C13CGQnDSgsnpQBFne1AeV01ih43m5CmQAM1O6r4I3BXyB5s1nCJToj7ouXwqWi5a0rwnuoYa/h8nCsijuY0lwyC7qxf/qVo2lUqviJHzywhvCtufrK8MjfNQ7avvFKhm9TpxrlXX6zmenGF+dcHeFMqZVustOduJuqtQ1Br18xvWOb0XWnaE83XdT0j2ijXzahjodH4gHGkPEtlm85gQ0CyZpSAcLIv8y6FHGWPfYZc8ZkiAPRSi44miYLz/rm/w9384nH6UEe/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6eVPzHUZN/38iXipC5ANN9qYyzob6O621gBwVrdOmI=;
 b=pCqXJQNJPDfFdmN5B9WqHm9PFSNuf2rMB38nfMuvtB+LKcPPt16QD9YcY7xP720lJAKnybbIIM7oqAREB7xVahW7ljCMugkar41mDeY27/d5+cyxtgsRlTohrpGUrr+qj8nYj7DmS9bF+/aNwGLVOW2C9i9XS+QJcp8pWxKAb6VlnilTSoL8IawPi9wPR1DG63X72TDVLZC0Ic73JLe2RIvhyFqcD9hVf/VpI/Vu/EsbjmWEy47Pn4fqeeYdOATsjne4gb9YMJGr/EG078znm6wXab/vznEADpxTZfRN55jR+JkQYcnxhhEVOCtW9N4sTaICP+0gwTKVfwJvsT1LYQ==
Received: from DS7PR05CA0063.namprd05.prod.outlook.com (2603:10b6:8:57::19) by
 CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 14:11:01 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:8:57:cafe::2e) by DS7PR05CA0063.outlook.office365.com
 (2603:10b6:8:57::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:34 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:33 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:29 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 05/15] RDMA/umem: Support an explicit DMA direction other than DMA_BIDIRECTIONAL
Date: Tue, 15 Sep 2026 17:09:23 +0300
Message-ID: <20260915140933.40580-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: f50e4da7-f336-43fb-d427-08df13332c4a
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|376014|7416014|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	RicQ/Fe/QQPm95G5nLDlt8e9BiSPT1IghLNNhDudjWf8vvEP0z0IUjBiRtD7oJK7bs41K9LRJl1+Z01Vx4FjmAL/NNE/NHaCOj+MvqoyZaF1JlpEu8lj8K0Wz8/zKsU7yzugxduNh768T/y+3vPTuoDF9Em53Cjqb4BGwXloEZiAz1lh6BtgrjVKqbkjV4AGXIpqKNFmjnVx/rARmnkIun3xseMILB7mXVMuPldHaSRhIZfA1SLTiQa9Bv1NulmKONYCU58MeGvGnFrLf1KxgFnp2SYA7Khv2eqXKwaC+DKYh5BtH4stPV0nq1sjAppBKES3hnotu+B+YzKQRt2Q1mD708Lc4+fXlqDEFgMPfAyaaWYKZMxr9Hevi4Yw7rMwilgEJ9QOURTibiPVx10pFKmoMIJfFx3iwt36zmOcPqvps7iuBX7uPnQy8BnPuRjzBFtJI2BY/vH8qMciH6Z6ZFcbah8VEjzc+vHQuKgey3FXUrPcjpePv7GN53O7eZwdYd6V5zcn0wHB0Vb9D8QQ3J/5znA1QqeVMe/nE1BAAHpHRZ6z6rRnKa/syRxJ4MOKsatRwdpo+U8q7LH7GoaAlYVOq+8v5qWbjjJsEWjIP9CLR0WkmyesBQ1oRY70+xB/H64QkzxYN2wiMu6KtNrPvXaUyKqkbvn68BdTBEg1qHDs6Qpgk36+R/sKqpi/8juBpgRrxqLZxpWHWXPNEcHM6g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(376014)(7416014)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	omlfz26fdSIYm0ei41lIRS/ZmE9S2CveTErgAdS1LEgulcNoO4JT5JVGrBJv4AmAYRAN5OxkakBUC+nZ1ByHWK+JvUOQORnJ3FtRG4y71SFwvgYSve+lFIFW72QnArn6sDDTZtMPFmZ3r7Y88VltDcr6Ge0FrzLXhnQoQmL8wLnsjWO5KxB+SUwnIRj3by57cHUbK61wLUijgOz47VIvcbJn+jJfIA1JAHFLljwydGDJN5+ChIzC6tSZZVk8dQp8tSla3Mov0sO1CCgaD7Rio10N2EUZpYFE6FxJWVlIgyxJxxoHJXhvikxhR/5xzDAWJ+CsWD5h9gTXOoncTL46n5tzsBUNBvzmvAXROAmeCqTxGZ0tdWdj4ww272IyWS4HbaXEoX3jiKUTBZL22Lujxe92608K5Q45DwW/gN+WdSr6HqARVIb2WNGBGQbzSw/5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:01.5900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f50e4da7-f336-43fb-d427-08df13332c4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524

Add a dma_dir field to struct ib_umem to record the direction chosen at
map time and reuse it at unmap. Thread an explicit dma_data_direction
parameter through the internal pinning helpers so each caller can supply
the direction that matches the device's actual access pattern.

All existing callers still pass DMA_BIDIRECTIONAL, so this is a pure
mechanism addition with no behavioural change.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/umem.c | 64 ++++++++++++++++++++++------------
 include/rdma/ib_umem.h         |  2 ++
 2 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 88110b9661f5..c2f277ada042 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,7 +55,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 	if (dirty)
 		ib_dma_unmap_sgtable_attrs(dev, &umem->sgt_append.sgt,
-					   DMA_BIDIRECTIONAL, umem->dma_attrs);
+					   umem->dma_dir, umem->dma_attrs);
 
 	for_each_sgtable_sg(&umem->sgt_append.sgt, sg, i) {
 		unpin_user_page_range_dirty_lock(sg_page(sg),
@@ -161,7 +161,8 @@ EXPORT_SYMBOL(ib_umem_find_best_pgsz);
 
 static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 					unsigned long addr, size_t size,
-					int access)
+					int access,
+					enum dma_data_direction dir)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -202,6 +203,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	 */
 	umem->iova = addr;
 	umem->writable   = ib_access_writable(access);
+	umem->dma_dir    = dir;
 	umem->owning_mm = mm = current->mm;
 	umem->dma_attrs = DMA_ATTR_REQUIRE_COHERENT;
 	if (access & IB_ACCESS_RELAXED_ORDERING)
@@ -261,7 +263,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	}
 
 	ret = ib_dma_map_sgtable_attrs(device, &umem->sgt_append.sgt,
-				       DMA_BIDIRECTIONAL, umem->dma_attrs);
+				       dir, umem->dma_attrs);
 	if (ret)
 		goto umem_release;
 	goto out;
@@ -279,17 +281,16 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	return ret ? ERR_PTR(ret) : umem;
 }
 
-/**
- * ib_umem_get_desc - Pin a umem from a buffer descriptor.
- * @device: IB device.
- * @desc:   buffer descriptor (VA or DMABUF).
- * @access: IB access flags.
+/*
+ * __ib_umem_get_desc_dir - core implementation for ib_umem_get_desc().
  *
- * Return: caller-owned umem on success, ERR_PTR(...) on error.
+ * @dir applies to VA buffers only; dmabuf direction is managed by the
+ * dmabuf subsystem and this argument is ignored for that type.
  */
-struct ib_umem *ib_umem_get_desc(struct ib_device *device,
-				 const struct ib_uverbs_buffer_desc *desc,
-				 int access)
+static struct ib_umem *
+__ib_umem_get_desc_dir(struct ib_device *device,
+		       const struct ib_uverbs_buffer_desc *desc,
+		       int access, enum dma_data_direction dir)
 {
 	struct ib_umem_dmabuf *umem_dmabuf;
 
@@ -310,11 +311,26 @@ struct ib_umem *ib_umem_get_desc(struct ib_device *device,
 		return &umem_dmabuf->umem;
 	case IB_UVERBS_BUFFER_TYPE_VA:
 		return __ib_umem_get_va(device, desc->addr, desc->length,
-					access);
+					access, dir);
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 }
+
+/**
+ * ib_umem_get_desc - Pin a umem from a buffer descriptor.
+ * @device: IB device.
+ * @desc:   buffer descriptor (VA or DMABUF).
+ * @access: IB access flags.
+ *
+ * Return: caller-owned umem on success, ERR_PTR(...) on error.
+ */
+struct ib_umem *ib_umem_get_desc(struct ib_device *device,
+				 const struct ib_uverbs_buffer_desc *desc,
+				 int access)
+{
+	return __ib_umem_get_desc_dir(device, desc, access, DMA_BIDIRECTIONAL);
+}
 EXPORT_SYMBOL(ib_umem_get_desc);
 
 /*
@@ -376,11 +392,12 @@ static int ib_umem_resolve_desc(const struct uverbs_attr_bundle *attrs,
 static struct ib_umem *
 ib_umem_get_desc_check(struct ib_device *device,
 		       const struct ib_uverbs_buffer_desc *desc,
-		       size_t min_size, int access)
+		       size_t min_size, int access,
+		       enum dma_data_direction dir)
 {
 	struct ib_umem *umem;
 
-	umem = ib_umem_get_desc(device, desc, access);
+	umem = __ib_umem_get_desc_dir(device, desc, access, dir);
 	if (IS_ERR(umem))
 		return umem;
 	if (umem->length < min_size) {
@@ -401,7 +418,7 @@ static struct ib_umem *
 ib_umem_get_from_attrs(struct ib_device *device,
 		       const struct uverbs_attr_bundle *attrs,
 		       u16 attr_id, ib_umem_buf_desc_filler_t legacy_filler,
-		       size_t size, int access)
+		       size_t size, int access, enum dma_data_direction dir)
 {
 	struct ib_uverbs_buffer_desc desc = {};
 	int ret;
@@ -411,7 +428,7 @@ ib_umem_get_from_attrs(struct ib_device *device,
 		return NULL;
 	if (ret)
 		return ERR_PTR(ret);
-	return ib_umem_get_desc_check(device, &desc, size, access);
+	return ib_umem_get_desc_check(device, &desc, size, access, dir);
 }
 
 /*
@@ -431,7 +448,8 @@ ib_umem_get_from_attrs_or_va(struct ib_device *device,
 			     const struct uverbs_attr_bundle *attrs,
 			     u16 attr_id,
 			     ib_umem_buf_desc_filler_t legacy_filler,
-			     u64 addr, size_t size, int access)
+			     u64 addr, size_t size, int access,
+			     enum dma_data_direction dir)
 {
 	struct ib_uverbs_buffer_desc desc = {};
 	int ret;
@@ -445,7 +463,7 @@ ib_umem_get_from_attrs_or_va(struct ib_device *device,
 		};
 	else if (ret)
 		return ERR_PTR(ret);
-	return ib_umem_get_desc_check(device, &desc, size, access);
+	return ib_umem_get_desc_check(device, &desc, size, access, dir);
 }
 
 /**
@@ -464,7 +482,7 @@ struct ib_umem *ib_umem_get_attr(struct ib_device *device,
 				 u16 attr_id, size_t size, int access)
 {
 	return ib_umem_get_from_attrs(device, attrs, attr_id, NULL, size,
-				      access);
+				      access, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(ib_umem_get_attr);
 
@@ -503,7 +521,7 @@ struct ib_umem *ib_umem_get_attr_or_va(struct ib_device *device,
 				       int access)
 {
 	return ib_umem_get_from_attrs_or_va(device, attrs, attr_id, NULL, addr,
-					    size, access);
+					    size, access, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(ib_umem_get_attr_or_va);
 
@@ -579,7 +597,7 @@ struct ib_umem *ib_umem_get_cq_buf(struct ib_device *device,
 	return ib_umem_get_from_attrs(device, attrs,
 				      UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 				      uverbs_create_cq_get_buffer_desc,
-				      size, access);
+				      size, access, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf);
 
@@ -608,7 +626,7 @@ struct ib_umem *ib_umem_get_cq_buf_or_va(struct ib_device *device,
 	return ib_umem_get_from_attrs_or_va(device, attrs,
 					    UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 					    uverbs_create_cq_get_buffer_desc,
-					    addr, size, access);
+					    addr, size, access, DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf_or_va);
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 1fe87fd1d769..dcb645419692 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -7,6 +7,7 @@
 #ifndef IB_UMEM_H
 #define IB_UMEM_H
 
+#include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 
 struct ib_device;
@@ -19,6 +20,7 @@ struct ib_umem {
 	size_t			length;
 	unsigned long		address;
 	unsigned long		dma_attrs;
+	enum dma_data_direction dma_dir;
 	u32 writable : 1;
 	u32 is_odp : 1;
 	u32 is_dmabuf : 1;
-- 
2.18.1

