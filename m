Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010047.outbound.protection.outlook.com [52.101.193.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2F355F49
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881436; cv=fail; b=knsgwshN42k6fL6U/Q+ordgwgwNkwkRcll/qb4U0JHj4IkC4ca6JBEFylq2oygXrCXF+RcoUq+TIG8IBFpNjCQGxWTPQvM5ztHuPEtKr510fix617JHnX1HVnMDmDfUhdk2t410gyRndOAqdQcO9pHPVnI6q8ZIzo0mZKZbfyQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881436; c=relaxed/simple;
	bh=6ieoUF5VyVe7FVEb3m2SDB0kPKtdG7tSDLyj9D2WlTM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5KA41ih1wJxYZ1j5Jw4MXzOoNpcdJVA0ASJhsVEQvMikGYXDC2/A3/HgzxBKz7CxvCU/kCbvnEI58WtFiWIgFivUvfi0I0De00bm1fjcdyS7eZNaBhe6mFpriJMIXtVccg6LZmLSlg+WJsY+czh+KrtNvux+2nsKSUU9i3QpGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mTT7Q9NA; arc=fail smtp.client-ip=52.101.193.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mTT7Q9NA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMSmUfiJOmp3dy6DIhr7xSVozhqA9LVsqDytIEIgqeOZOjJJzNrlbc41joQC39etcw9GNMteOYUnvgHvsj70OKGx4v6InPXcun5e9scLbZC+AApV4m/aF/iVMjAMHG4THWUcTBIk56sL7yXBTrfUZuJ2mqCb4N8BKEVgAL7D8tkdzXfN96KhHQG50Q0jCPFRNfRXpILxtLDGwwR/BnOYCf+Nel2Nkl5Uit3eM8w9RcxBUAFE1/1DHrhefOu7VTVgZvkN9RmO/+38oMZDyaR/9X9lMczTkqQ65Ink0kMUk5Qsfkw38ikJUHwYLqFw5f4tE1WjF2aXxnjYBCaTEcgNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvfP6plXv+LVPuCM7n42yvKhgw71f5SadeuG5q/ptvo=;
 b=RSTDTlSEoVj0BrDbah+e2qcIi3FCX25F04dPHe/0JxIX9x4sn8vxQ1eyF+34AjHQnQvJ7xk9kOaeD5KXnlUIquG/Ue69l+6cU1m6wQVoA/i0xffSAIs2HtWfoloPU4hiFkuzlOVtRTkdTolxY/n4Kmxwyvx1iCOhon4kvMsQdnAh338HmNFHhP8plDVqNLlZvhKShwl9KQCwP5klCIj0Pv5sVx3dDwVzH5IduCaYEwAGZcfsVajmv2HEV5ThrVqwXdRaiNuYSQCM97EkwO5W/pc+jNlQzhZR40HpABKy7Dy8bJ8r7ys7QpNbrYG8VpbFLDlQ5aaqOvNhR0mQHaNisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvfP6plXv+LVPuCM7n42yvKhgw71f5SadeuG5q/ptvo=;
 b=mTT7Q9NAuNsRJ7nwamaZ5plX4jr8Z0ihutROZ/2araJ8/UY1YD6AdC2l6LHYv3B1wrDufz6FhyQpukDDkuXBN1qH/hdrt2PK8GqyZfKVrA9XNYM6P93nZ/Xf3H97gJHPvB7LFmJPL4G1DhdSI2gfovosfik9a208wT5j3kSyRNd2uTAVUjfcbyQwAvGD2DmhfxQLpkEEuJ6nlh+gf/EHyC89x0M1azYj7B3YHDq7jVz/7d6rYUTROwVOhAO2VI75i194B/F/59a6D8ZzXxME54mrMUu1l2qkkyN4mB3TgV4iSsRLoDrn3JrtozeUfw5KC7me4SzJFzw8fDj275Na7g==
Received: from CH3P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::23)
 by SJ0PR12MB6757.namprd12.prod.outlook.com (2603:10b6:a03:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:30:12 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::c) by CH3P220CA0001.outlook.office365.com
 (2603:10b6:610:1e8::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Tue, 8
 Sep 2026 15:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:44 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:39 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 03/15] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
Date: Tue, 8 Sep 2026 18:28:39 +0300
Message-ID: <20260908152851.1307294-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|SJ0PR12MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: cc6f6e55-c8b8-40a7-cf74-08df0dbe1288
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|82310400026|36860700016|3023799007|10067099003|56012099006|11063799006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KZO/IFj9ynBlBAvkmxsSLo/dZWyvG7t43kknGnPsDTGTn0USPxzw+ShEjnsCiM0gcMjzXorya5g74fJmRdQ6X8tyOi3WITTxy2v7L2YDsxEKNN0LXiuil9mIpV49g1K/LY9TGJDl/+SukZcMBTGg7wZWUG47VXsdDUGfPvGjbbrWsV0/QGi+AgczpLLIi2CR1Ik40+xUAsrpnMsJyV3VUpVGPO5bVXTT+BHanegRPpdm6CJltK6xzdkylHu3eN7vdTu1u1MreZPyrjVC0KbfOh2jccST2eTMZa0TJbkNVb2DQWUFRmbU0InCHTpTFUCCLlCUlmXUZJNs4Gb13ediBov7uBwRNwJPQwvsZEhhQwgIZAYHroHwXM868KQ+BusDVu1kBICGAOz5NyRhcEAYVva7On6wivnuiKsiQyDRCTDwRSKa7+PrbkEsW/zvSY/LrQlW17hMcD65gT8yLgwqznb89TzVjq786m94riiEoaJabxaA+tKXPm/OjgXWljj5SKBQO8Kkopr+8uw/YAyzVe1JRKVvcQUok0VsXzeW6umXmdLOoK03t2XES4/wCcWci7UfOLdJQ1Kfwz/5IvJ9M7wT0Rb3QnbGIlinZr4kaxB8lrQ3K28QiIf3CnzkdvM41c80/uIV8pF5vUnmR802Y2broPGDH36qzXLzNT32vcgYM8L3pAV277c1p+JU9rLNUjNcb9Y48eK31kOv0Xjcmg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(3023799007)(10067099003)(56012099006)(11063799006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kc7DmP+ujYO6IOt3nUphnXPhwHEkfJKeXJVUqsBUw1ejj4StXaTEcc2orGAQJ7cD44aitD34gQPC9WjPYOuUBwvopLojDl69ueJC3K15aHYLpLEaYGq5gUMYo+BrGJMiG8PdRevwtKrT28MK/Xz8gVBb1d72/X5BXFS6ZTROrJl4fBVh6kVWAQjY2Vk8m3VN/Ljxp7tgiSTXVWcyCohwYSWEj2gArN9Ce2WARt1bOPHG+Px7t/RCxXnyjLiTyufaJdD8mWQ/GIMnt34p+Si3mupKe4fNajtI+VqQ1shQyZDsLpx0w0fjBCHTssrXFqaJO6eZncE0WsdF5eOdKEPYSLZeso7BsVa6QwafuGhjonZp8Si6NX0s+cfsmhQmm/fbVkAUdM6EAnEjw1CVyDACQn/ClKru3eniOpbWel8f4YZi0nhSeGaa2QwKX45YEyzx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:11.4288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6f6e55-c8b8-40a7-cf74-08df0dbe1288
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6757

pvrdma_create_qp() and pvrdma_create_srq() pin their ring buffers with
access=0. PVRDMA embeds a pvrdma_ring_state header directly inside these
buffers:

  qp->sq.ring = qp->pdir.pages[0];
  qp->rq.ring = is_srq ? NULL : &qp->sq.ring[1];

and the hypervisor writes cons_head into that header -- a field the
driver never writes itself outside of QP reset. With access=0,
ib_access_writable() is false, so ib_umem_get_va() pins the pages
without FOLL_WRITE and does not mark them dirty on unpin.

Without FOLL_WRITE, pin_user_pages_fast() can hand back a page this
process does not exclusively own (e.g. the shared zero page for an
untouched anonymous mapping) instead of forcing a private copy. The
hypervisor is then free to write cons_head into that shared physical
page, corrupting memory visible to every other mapper of it. Missing the
dirty mark on unpin also risks the hypervisor's writes being silently
discarded on reclaim.

This is not gated by any IOMMU permission check: PVRDMA is a fully
emulated device, not a real PCIe device sitting behind a guest-facing
IOMMU, so the DMA mapping direction has no enforcement effect here.  The
hypervisor already owns the guest's entire physical address space and
writes to it directly, without going through this process's page tables
or any virtual-address permission check -- the CPU's page protection
bits only gate CPU-issued load/store instructions via
virtual-to-physical translation, not a hypervisor writing to guest RAM
it already controls. FOLL_WRITE is a one-time decision made at pin time
about which physical page GUP hands back for this VA; once that page is
chosen (or the wrong one is chosen, as happens today), nothing stops a
later write to it.

PVRDMA's SRQ ring does not currently wire up its ring_state field (no
post_srq_recv is implemented), so nothing depends on it being written by
the hypervisor today. Pin it writable anyway, both for symmetry with the
QP rings this same driver embeds ring state in, and because the umem
pinning here has no way to know if that will still be true tomorrow.

Pass IB_ACCESS_LOCAL_WRITE for all three rings so they are pinned
consistently with how the hypervisor actually uses them.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  | 6 ++++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index e939cd5ce40b..53cc49f2b8c9 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -270,7 +270,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 				/* set qp->sq.wqe_cnt, shift, buf_size.. */
 				qp->rumem = ib_umem_get_va(ibqp->device,
 							   ucmd.rbuf_addr,
-							   ucmd.rbuf_size, 0);
+							   ucmd.rbuf_size,
+							   IB_ACCESS_LOCAL_WRITE);
 				if (IS_ERR(qp->rumem)) {
 					ret = PTR_ERR(qp->rumem);
 					goto err_qp;
@@ -282,7 +283,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 			}
 
 			qp->sumem = ib_umem_get_va(ibqp->device, ucmd.sbuf_addr,
-						   ucmd.sbuf_size, 0);
+						   ucmd.sbuf_size,
+						   IB_ACCESS_LOCAL_WRITE);
 			if (IS_ERR(qp->sumem)) {
 				if (!is_srq)
 					ib_umem_release(qp->rumem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index 345ec486a223..3252c2eb405a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -146,7 +146,8 @@ int pvrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 	if (ret)
 		goto err_srq;
 
-	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size, 0);
+	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size,
+				   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(srq->umem)) {
 		ret = PTR_ERR(srq->umem);
 		goto err_srq;
-- 
2.18.1

