Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011009.outbound.protection.outlook.com [52.101.57.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61C55C334
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881453; cv=fail; b=XyR34fiBOIuFxxC4bU+g6f6Q4TOBRqXe60TixkIki7G25I9BHw8ONlXnunJtopiF2bgHW8ibz8NQHP4i375HHCC5etDISqfbt3HQnAl1Wj/a80HmVw3nyC7ZBBcUfmuWspZVzVTt+O6BLFCxxFSUSKJ5S6uMOknnRe2KxQ2BkPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881453; c=relaxed/simple;
	bh=4icT+7eyLhY2+sWrAdHQWpYTxI7MuMjxnwJLfNDdeew=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+CQmch4DRwzP70LS5IGeFuDO6vjIrGmRaYhSDE3s56DvLMv0sAcBrXwmIZVA4KmTesLnlebcdEl96UfwxlniWRw1UhKV+0B+7V0XmvJw+zbnEHzwYrXEzOrmf3KNbmyd0aF4YmbKqVcGRuauSKs5rUHDQrgg01fhdO1uPtxomI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZevBKErC; arc=fail smtp.client-ip=52.101.57.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZevBKErC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpMBwsD0SxArzJKVXIU2qQHfUmehS7526aLN3LwcIu1cP+kRDlAASq5pre6JxRjbDZNzKjXnsfWnrPmJZvEJnHFJXiLYTRAgWjmn2r6pOVjvhaDsjFkgAlz6nB5FHXbirruaIQFG/adp+pFn02iKmmg2RN/6aWOSkt4K72Am8Xh6AL07CaPhgTZUqjnHbTQ/R3A2fnJKvbI+rNg/dofTXdNSgbK9ELh8TESi/2qyyZxdaoigdfvRSU+N2FgQHa8hbG2BYM3Af3k+/Ek68/lSIu8w1SzfT2ZNII5S+YUZcj4L5cJFS/gpS0GeAna1+Yee/WAyJBQiCk69IRDRDDiV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJtDguj7Kfs7KErgJ1roi9+nkXNqvVlyi/vJPL8ciUg=;
 b=ogl+WmOzMhBvyZi1j972yyeRnYWqpDr+Ua7h/WimG9c63s1H9CO+YoFkHiV/2cbn6YjNMu76KJt0SB0qQH3SVndauZGFgoF0O+mYxrwTxhsSMxcDN7Kz8lFkNy7QbNlFlUgrbvV8P94/VW/XMbNA2i86Ul8QktrKLtHCUgpJne3rwfJrFGD9wqrJmFQL+TeA0ErMc88W+MupXeMV/Ib7JFze7QcBGekhhJs9MLitBfdIWWfP11+GlqdJ3PHtYNvsZ6qhn/lMZdNRGW2+OLWSyj6djPU2G8YqbEc7bVEyB+XrMiCIe3+Qse0JnhKvZS2nVUbV8tHHmlFYbfSIWEh4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJtDguj7Kfs7KErgJ1roi9+nkXNqvVlyi/vJPL8ciUg=;
 b=ZevBKErCh1W/PnmVWaNe1oruB5SQcObfypZQ+//am/PM211WEB6uCXP6hqO+Al8PoG37yx6lgn62Kxit26kYBETgw1kRGd5ZZNRqzEtxE7eX3GrJNJ6s1Nlk+nBetOnLsku0iZZyM7Z244uFWPg2LD8kNgBV1QEBqpxdEvBZ5IjvI4N0lHYlRV/7Yk9gREs0a0fZyYENUIGXGlviHK3CrxhBTO0veBmAFq2s3ZPpYexnJcCDmzCVEjC3NLU8fWxNj2QEh5/xe37cdTcyk9IAf1aTLnPWMkZ0OK1lwuu8z5xzRFFvNVWKPLYUQhDvm4IMX1sfuMH4KeZvnkHsFKgzKg==
Received: from CH2PR14CA0031.namprd14.prod.outlook.com (2603:10b6:610:56::11)
 by LV3PR12MB9260.namprd12.prod.outlook.com (2603:10b6:408:1b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:30:35 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::2e) by CH2PR14CA0031.outlook.office365.com
 (2603:10b6:610:56::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:05 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:30:00 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 07/15] RDMA/umem: Derive DMA direction from IB access flags
Date: Tue, 8 Sep 2026 18:28:43 +0300
Message-ID: <20260908152851.1307294-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|LV3PR12MB9260:EE_
X-MS-Office365-Filtering-Correlation-Id: 6877ca68-23f6-4291-4643-08df0dbe1f75
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|23010399003|3023799007|10067099003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xC/wxYMmVbLCaf4qgAJq27tMmRNtAQyamuvoSEtpq6gVTnx9FHCDzDsum4qwy/THlGCU8Ps0zdpVNVqHijzNb+DZXTqTnWJaPLnM1pvfrl9q1Vc9/JLGzZMaci9oLLxH+bFs9hOEEQc5eMzXRRJgHAVXQeyzmvObiTYOEctCmRs9EFhitVwDWD+HNiZnBXPHwAGRfXnkBdFn9BN+TFw+bGLSfWm1AnrGnrvIABdzKt4vqyWrWTDABYRZ5DeAy+PYm1zf2wbB7qS7bgNFBuGbRit+GKow7mZOdfGYGChSYKLmQFpyxZJJ48oU4fmHHTu0tqc4YueRvIdx5w541zXtJuc/iwPU8EI59lpwaAONxrGv2koqGMvEbglZCyWUABuoLVzdc6t/VPkrfKnqIZ6yP+2Y71ejBKPHYD/ALqZw8ksZtoPmnPGrbk2CUrUr4zqlDLtfG+EDYlF5DdzDJXP/A5qGYuXiHFVRILrNloapbI+n+CoxXWMpNexTMNk7aP6mMA9o3UQvWtqtX5jt0mo56mknse06fyHkjnrPSjlhz0o3yk6qHpzXYSbJNT109oDuTiN0NH8GUSJ1Bcr4OclXzhff5b7itRy7mEQCbcNS8ZM6o7C3HtbeOYNxKuxfJYAY4H5DIRT8cmhjmw3dJ7Dl85n+JlUAxF9bBzCzCy/G6Gmedv7Jggc6y8eznt+XbFtMTX7TFPRolz4lL6JypEaV6w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(23010399003)(3023799007)(10067099003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cxZCZ3hjCDwob37/meNq6s1D7BEYR+JeoNKRHCTBnrv2m3/SqGNWSC2sLoqS22z+RXH50jXPLhCPowdE1V8277/wxD4e0Rp31AvcH8sPZdwnckirzThcT3cVILYWRzJvsnm+PLU3LtZUidkyg8/U6txoXNwEKc+2To01ZO/uTDosjG4ftkggV6fCt3bfb0l3cQdNbtEW+SsyjrtpRGpguBSZK0NMlVycJ41yeaGW/reEgjKqNAIQvu93ayh+Gqc87whNU4g8ki2detHPMBmjFREOW9bGmrzKTzPbf3JnI5GoipFbtJiL46kulmRJCMY3lGSwxx0kTeKy3NZvEF1lCo2Sng/1kReku9r+nKK4GWXxA+yVtC8K4ti7+1nVCmmu9VWlr6HG+pO4FfO+cweykg0W8yNFtKdzwK4liCzJDbiSNxGGshYBI8TB/U3raV/0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:33.0965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6877ca68-23f6-4291-4643-08df0dbe1f75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9260

ib_umem_get_desc() / ib_umem_get_attr() / ib_umem_get_attr_or_va() can
now derive the DMA direction from the IB access flags instead of always
mapping DMA_BIDIRECTIONAL:

  - No write access granted (as determined by ib_access_writable():
    IB_ACCESS_LOCAL_WRITE, IB_ACCESS_REMOTE_WRITE,
    IB_ACCESS_REMOTE_ATOMIC, or IB_ACCESS_MW_BIND): the NIC may only
    read the pages, so DMA_TO_DEVICE. This covers all callers that
    pass access=0 (SRQ WQE rings, QP SQ/RQ WQE rings, doorbell
    records) and MRs registered without write access
    (IB_ACCESS_REMOTE_READ only).

  - Any such flag set: DMA_BIDIRECTIONAL, unchanged behaviour.

This is not just a theoretical default: it has been verified, driver by
driver, against every QP SQ/RQ, SRQ, and doorbell-record buffer in the
tree pinned this way -- mlx5, mlx4, bnxt_re, efa, ionic, qedr, mana,
erdma, hns, and irdma all externalize their producer/consumer
bookkeeping through a separate doorbell/UAR MMIO write or a distinct
completion queue, never by the device writing back into the same buffer
the CPU posts WQEs into. vmw_pvrdma is the sole exception, already
pinning its QP/SRQ rings with IB_ACCESS_LOCAL_WRITE (see the earlier
fix), so it continues to correctly derive DMA_BIDIRECTIONAL here without
any special-casing.

For dmabuf buffers the direction is managed by the dmabuf subsystem and
ib_umem_get_desc() routes them unchanged, ignoring the derived
direction. CQ buffers already get their own tighter, unconditional
DMA_FROM_DEVICE mapping from the previous patch and are unaffected by
this rule.

Security gain by platform:
  - Platforms with a write-enforcing IOMMU (e.g. CoCo guests backed by
    ARM SMMU or Intel VT-d in strict mode): a hostile device is
    hardware-prevented from writing to read-only buffers (WQEs,
    doorbell records), limiting corruption.
  - Standard deployments without IOMMU direction enforcement: no
    practical security effect today, but the correct semantic
    declaration and zero runtime cost.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/umem.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index f1da70c4e352..490ce660193e 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -329,7 +329,20 @@ struct ib_umem *ib_umem_get_desc(struct ib_device *device,
 				 const struct ib_uverbs_buffer_desc *desc,
 				 int access)
 {
-	return __ib_umem_get_desc_dir(device, desc, access, DMA_BIDIRECTIONAL);
+	/*
+	 * Derive the DMA direction from the IB access flags.  If the caller
+	 * grants no write access (local or remote), the NIC may only read the
+	 * pages - use DMA_TO_DEVICE so that platforms with a write-enforcing
+	 * IOMMU (e.g. CoCo / SMMU with SMMU_CB_ARC_FAULT_ENABLE) can enforce
+	 * the restriction.
+	 *
+	 * Where the IOMMU does not enforce direction (most x86 bare-metal
+	 * deployments today) this has no security effect, but is still the
+	 * correct semantic declaration and costs nothing.
+	 */
+	return __ib_umem_get_desc_dir(device, desc, access,
+				      ib_access_writable(access) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_desc);
 
@@ -482,7 +495,9 @@ struct ib_umem *ib_umem_get_attr(struct ib_device *device,
 				 u16 attr_id, size_t size, int access)
 {
 	return ib_umem_get_from_attrs(device, attrs, attr_id, NULL, size,
-				      access, DMA_BIDIRECTIONAL);
+				      access,
+				      ib_access_writable(access) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_attr);
 
@@ -521,7 +536,9 @@ struct ib_umem *ib_umem_get_attr_or_va(struct ib_device *device,
 				       int access)
 {
 	return ib_umem_get_from_attrs_or_va(device, attrs, attr_id, NULL, addr,
-					    size, access, DMA_BIDIRECTIONAL);
+					    size, access,
+					    ib_access_writable(access) ?
+					    DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_attr_or_va);
 
-- 
2.18.1

