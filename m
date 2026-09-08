Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012037.outbound.protection.outlook.com [40.107.209.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B954DADA
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881441; cv=fail; b=BH60H7HnShId8zY8c42MdbAVDsgtX+YXrKn2CYpJIWomKVPpPBXAkZDatwOKLlyzYqoo9L6lEdaz2pYKzfGL1NFRk7Yr9PprCXcBj7FPGN11fj4ze9+YEhQX6e/ZrJj5kshxz8SEjRl/beNNr4HMoscE6jCdhq4qkkCEpSuxP9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881441; c=relaxed/simple;
	bh=9BataqLdoJcs4dQ/WG7wgRIW1z0P3z/H5nQFsVm0Y10=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqwwWZEkyo8ByWB7gqxFEd6wT457I76uCcQMnPzLTp3aT4Psnzwzo68JlxKPvHTyypLidtv2Pt9QTRXvr0zIbXyD6gVrKJJ+tbu9z8+6vBpO7JvLRj6OOlmGNivfJeW515KCtoxMJk7v8E3tu3CDuGOWcd1SBYRsq8Br4+8Gtz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bmkfikAW; arc=fail smtp.client-ip=40.107.209.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bmkfikAW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QG57Wiz7N0cnbEdYIx1lFCV8z6l3pPGmHL292tlS9EOuucC86YwIiWm9D43CUytWD7J/vVoiQGLiZEdCyRvCyrpi90//NvOA+O1UU92AHJvHpoITg03pWtD8TcqtVCE1NTgM5PIM/nLbQ2U4vCB+NFiNl8c/2JlHHCsFxprnQpqAyHE7BlEPNxTbnN7WqiZTUFvTjzzmlxVR/uZ8kTGIP1/ZSnroiRY478Fggw3gDeYbNzsdKcexuG/fZYX977MiUXzWu/Q8Ikm+18W0WJaq1mWK5cQuAEiZOTPcThJ1qiGsI4lLczzRINWgp4RQE/wwOZ36uBgBFdXpJ7kvuJoKRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/QnVr3QE38AoFY0mKuTas8dJkhE+YU0OtuIUs4yM04=;
 b=g3yuqkIoQ3aPBSd5bE3V93PxmIMyCmFc4RXW6sN1iNs3u2wn5tc1OUHPu+idYs+80jKcaM9dMP9AXS3lZC6CZYvG7UFLW3L+zEyj4mQBHlElyAt4IKJDoZgS/CoKWG2yBuxPYNBcVlk0md5M7JjBa0dgiH7iaUu08PSAbJDqBdeJXizzTQ1FkEJTS2ldATr7pehwBYzpYqbQvdCHoUeI7MLHmStGR69RvtFyf3BG202XsAsxjkpohQF5+AdtDKOCImOISwPBSIRPxxbznN64Jo+5kBTIkiQFPjA435rgMn+pSp4PlvXBWV25/fItmzTFz3LgKSQR6AtC01gn279Tzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/QnVr3QE38AoFY0mKuTas8dJkhE+YU0OtuIUs4yM04=;
 b=bmkfikAWjctcRVDucUqOiA2HeQ6jCIjbCtvoFOubBuoKqdrPGBJ0RQK0gD9xsBTy9Yklmoh3KaYs5yf6t3plBxmdD3fjIJIZo+kf88m548M8By+zWch/4eYub/8743f4xbhA+eiUS8zan4WIdQh4wbcq9ctc2dkB42XqVoS3JR+ZlVVuibD9kfLKYey8X1rYTRzuHOsj1lN3r8xoI0fCnmrx/AxRsU9m12WNujI9MdhDYtf28gsVB6mdAyZRmJlpkG60bClpTA9t8U22t7y8KWQI3AlKTsqWkjsk8M0ZxHbQOtqU8ql3/amzayP6RnGmSoZdN0c82Z2dbNfMieTNmA==
Received: from CH2PR14CA0040.namprd14.prod.outlook.com (2603:10b6:610:56::20)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 8 Sep 2026
 15:30:21 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::7c) by CH2PR14CA0040.outlook.office365.com
 (2603:10b6:610:56::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:54 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:54 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:49 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 05/15] RDMA/umem: Support an explicit DMA direction other than DMA_BIDIRECTIONAL
Date: Tue, 8 Sep 2026 18:28:41 +0300
Message-ID: <20260908152851.1307294-6-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|MW5PR12MB5683:EE_
X-MS-Office365-Filtering-Correlation-Id: d48270d3-b54b-49e0-3fbf-08df0dbe17f0
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|7416014|1800799024|36860700016|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	szZvmY+3/SbhdPAazcZq7wjpCk0kCiTZ/bGZx0DNH3qNAZL2JIsyhDBLfIPSoWncZjG2eqWoeMjPSEV2fiyt57Nnt2GCoBBt9h+R0jia2Zr9rq6wvF/cx9LGoCcuL6sjIhnEG8j6C3Z6stkepDgTKvdqVfJVIWUYoD9J1msbBGiPItRGAtW1Nm3eOFPSg/zl8BwZNUBlC//XRPk1sD4e/ySqqMU9uhtrdC+PYtUDn0f6Urj06CSHuFMKXxF3lTnm274HEcvhj6RMoDoVEyk8ATjOaxrcQWHfiQbEcFVwQOpyNondp6ifpNFw9JFPDGb7cwF/2P57eJbnSKmj0QMjOiQ8Y/xFnWioIdWO03wpXfIUTZc1elXHPFZ99a2pH3eoC3WfPrMaE/dv7YrKs/ZVVj6n+esbed8Oeg3XiyDt34D+0DKZ1+ZA+y8H7lHwDf4/Q9JX4N5wItM8csgYbByvZLCHHyt/U9lyRvjB1ReT0/ubqRwwQrWHHzEXzucvmbEcvNAQcZlcKUgaD2jhUOjPuXlxaC1R+KkULY4ffhi7EpMva9s75ey1ZbEinfSVABWvWlW5cQdlUcHaE1nsyuwJD6YSagjrYWB/2QrLTlVUoeA/dy4Rkc7PpCI6Qr6MNcJ4cgZS6Ww0+/MmFnc7Ktt1R4UAPkuyUsyqkuEWwFitwewHHzjNoictFfb2PFdi6SZE3I7hBHMyDBYlSHQ9mFzXfQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(7416014)(1800799024)(36860700016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4EX0OqTgpaYl2YiHaQucuYVNZcNZbzXmswXDfPPzlOzfLWg4ybZ0klvrfAXYC8sLqb4bn0Bq6456NWqUqqA+a1XwjE/5TFoJqLXjUHrjWplsPEn5UKTICJVkRF22KAegPFy685wVGALQ5G40RqVmE1kKkW+4CGglV+qQMbZf2mvVynFedzD3dNlQwhL5FtpCMMaqUzji04z5QYQN+jvul0amd1a4usSs7+o2ERve/dwqAuqRs+jCBC8m/JiGbiuF6JYi/MY5rLd1080jq3pua82SCCgeYhHUyg5qmCOc6mGokn62E8isRZ4Z2QFnGX+IYvknDZ1sGsgSNuNHI2LNb8+RUPThB2HNSzuze6D60g3nVmk9SxdZQk8LMZyDTImkN/8UadbjpNi5KlJK2pIXYRmuCExd2wwMU1QE0/4DPlwEfgFk319cMbU4xWmU0B0n
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:20.4932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d48270d3-b54b-49e0-3fbf-08df0dbe17f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683

User memory pinned via ib_umem_get_desc() (and the CQ buffer variant)
has always been mapped DMA_BIDIRECTIONAL, regardless of the IB access
flags or buffer type. This is unnecessarily broad for buffers where the
device only reads or only writes host memory, and is the first step
toward deriving the DMA direction from how each buffer type is actually
used.

Add a dma_dir field to struct ib_umem so the direction chosen at map
time is recorded and reused consistently at unmap time in
__ib_umem_release(). Thread an explicit dma_data_direction parameter
through the internal pinning helpers (__ib_umem_get_va(),
__ib_umem_get_desc_dir(), ib_umem_get_desc_check(),
ib_umem_get_from_attrs(), ib_umem_get_from_attrs_or_va()) so each caller
can supply the direction that matches how the device actually accesses
its buffer. Every existing caller still passes DMA_BIDIRECTIONAL
explicitly, so this patch is a pure mechanism addition with no
behavioural change.

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

