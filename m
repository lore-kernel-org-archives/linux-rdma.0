Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011022.outbound.protection.outlook.com [52.101.52.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560E65650E1
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881455; cv=fail; b=rH+sfJkwOja8z+ex3/2h0bMJgvMG7mFGSFtiYGFhJ7r0mDuoBARVHw+35K31iuo91z8YHu4OlmvBCYH1Ntj92ozNHwStXjWQcVHRGOUL/qiz7MvBcvpOYeSSWo+KFmpVKfJOQwBPjR9ZAVo8uAfLgPqVy60aqig3yEtZVDeAZH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881455; c=relaxed/simple;
	bh=tLo3ktCR3HmuWSSTzVVa1Ml/NYDVL3O2RnPfRdgAY8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h6Jpsd4j7SBk+x+IUHqwilyLVToxi8Nc0YdnAZkZUwtD+WFyEPOAaPS/bDW7Qh26pb+NwM1fpV2c7eGEhCm/NS1KGDMbhZtdMfGuaPLAMLIxe/t9XirTrBohpPe7zxXXij/rtmuPFekCoufItaZW5fC0DtqbDmjD9lV/qpi5Cus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sGeJhNnc; arc=fail smtp.client-ip=52.101.52.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sGeJhNnc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEbTiHFp4/BJXSqWY44He3eK0dSm23AyMxb7HgVaaDvJGD7wKLDQZz2UCCUVkScDHPs7uQVM3y/gzQTsqZwekDW66S9/vg5/mztKw93wicR5JdjYNaxKPVTPeco1vJeBb8vGYiyFKUWCrduMtz2B1q8b7l4XIXBLqOIPirx6kqJCuzxuGnz+AsXMonvPMM1a8oWIz888YM2BaIxdBfvcfQXNogSvc9h1Ukd83bVvgfsR6/l9ZZyDEjWQrUIP39/1Y5TPHDKvZvwa5vtc7POFh5OAbf5Fh/7MBnbz/urE5HI3aNH3pQEIx8Rx87F6VYmcqggh0dsEEKJqCi11qgZ37g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/is11G69O203exrkSKF2RpGZmOvO5SW167y3Wgbfxs=;
 b=UIwkv4hdltFdTY2WPafVkOP3eFb8eXzE/Kmsti41p3Le7PGsYf2UCzgwKieO6F6ahK2d+UEb9kmA/kbt7SBOgxL+edeb0mw9TcMEunKKkXo2hg3u4YqQUkSjEJ04nUEvusCvBxUo4NyfLDFoxybcVW3crZivmISXd46GkQi5MsN3RXv7BZ/V27KZLJ2t0OfJzSFvXbVrt79KlI6NUhO0hz4Byz7XIiSPv/mu0z+CNr8zCAYnmZVRh296uS+7o2FEOJUhICj1YKm4KYbv1XDks7gP+Ng1EllafQt6VYQN/u6XGLw2HSA61W7VBxkIApfqA5wey9PB5UACnQqW4ww6Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/is11G69O203exrkSKF2RpGZmOvO5SW167y3Wgbfxs=;
 b=sGeJhNncaNESLeiFOMiXkUhmCzYonsEbOoON9Ju6EVkB+9K+BuL0xtY9CuvKLgdTXoDtwPZrGTRxNqOqJJgt2w4QnJjq+tRttNRGCxmKmBx4RKxYDPKpKCF95KTEXj3WLV41/EkfoqUZg4HtzpY1o81oukxEyeIKSMF56Glw7aSSPeZY1yZDPclPsJtAR+ZCEHqEglAxDtENvfsJXg36tr46ftd9IncA7X46V9g7mzvmUaHxoyS2oWvndcIPNYTTbIFKeLKJdd7NY3qMv6amzXM2xlj3AYx577iAC0CZe7kr1vhkY0XXPZ5XeL5AfgdMPsImRdG100KBbHjl7ruByQ==
Received: from BLAPR03CA0149.namprd03.prod.outlook.com (2603:10b6:208:32e::34)
 by MW4PR12MB7358.namprd12.prod.outlook.com (2603:10b6:303:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Tue, 8 Sep 2026
 15:30:30 +0000
Received: from BN2PEPF0000A88E.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::56) by BLAPR03CA0149.outlook.office365.com
 (2603:10b6:208:32e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A88E.mail.protection.outlook.com (10.167.248.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:30:00 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:55 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 06/15] RDMA/umem: Map CQ buffers DMA_FROM_DEVICE
Date: Tue, 8 Sep 2026 18:28:42 +0300
Message-ID: <20260908152851.1307294-7-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A88E:EE_|MW4PR12MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: acac3851-ac5f-4a45-a58b-08df0dbe1d88
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700016|23010399003|82310400026|6133799003|3023799007|10067099003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	C/OLq0BoBbwqWUJR1lzzBk3mUxCSYRER1f+9rInl1rTJzCgajLUi7OTxgRtQwpaNqtyl9QdKgR+UxFWB8pLn8HRjbEcbBF4vmP/9oU2krLSeF3sWaq4EmOzIUtEke316BUkwa5UffeJ4qbCYCuHlcPU/FVOltEgfew8qlfamvli2LfnKH2PYgw/OE7Lb6/PWzO/eMKXKdwQtypFTHeYi8Sf5KsZWqhcfRsKhqaFYibVXxV3n1r7xlYInASxu5bSP7RCDUp6YDiPYVih/byzi2dj9v5DY6IcZUklefrxxcuoED3h8g56tZ7Hy6OtNYuheiZ8EVbhpxewptLiC/Ozx1aUpu4WR13Wvki9sP8qgAXxKXFb6iL5gRdesiTeW6gDdHcbYta3uJnlaDKRPgaZXKsGt/f5Dqjy1CS+ySTTBoaHBA73NL+fzJ6rjTCuJpu89q5yI8Z5UdSPM9PLEpjhn5ADfjb3XdxmzfRHjR7AHYpuifE+LOgvfYYKGOGLTjAqgh0TxEijNYw4/WlE5FFVYmJlg1fBq7NRFRYFueQ7APWDn5iKOzSaRk1C8xT9JY2dZbGq8Amltd2U6sjfAA5MsKbL15Oa36HncO9eQFbF2igH5gYrg9vuyY2qIVnf3ZVb7kCo7we/WI+7eMQAx/je/gt136PLi35jjwx2Cg6PyPPRjce8iRKbvq6lYSNJ1qBXz4JQEbnoGyCgVSqkEgOS3kQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700016)(23010399003)(82310400026)(6133799003)(3023799007)(10067099003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MAAy84IB3+LvLbgsVnIYnJX13+saDQkchH3k1Ht1LaUL08OytnWyc9NC9JqS34wZpTtD90ZEirAtyYHmevGrk4dkoFKTvfd1VqgxzIod0bt0+2Dd0f9VDW8O9f+VX7d+p9YlQbDoL+/dklUx3L8FAy8QGFQKPXEQMpUCysTx9j1wRFPezkKLRr26flA8qUlJUQ9N+ldOg51N73oZ+BjyAecgpz1EDtOmsCP/Mvj6jDrKkzG0g7hkHqnkxQrRBwPpSfDYsvRUea80C+NeJvgpuAkAzkTWX+1SY97DlDLK/Y2RwxkDWzVwzjZ2ZJ0Pljcgmvcy28w1b3+mIfxX37S2fsESYfOOVQCm46pxY6gl1EATpiZxZD5/p7tk9PRB+5SA9FyXPH4srBpzpWuKSnKUmgd56vbhGShP1zM2P7cj0Uxbo50wWpbmRB+Z9Qaq+pn9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:29.8546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acac3851-ac5f-4a45-a58b-08df0dbe1d88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A88E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7358

ib_umem_get_cq_buf() / ib_umem_get_cq_buf_or_va() pass DMA_FROM_DEVICE
explicitly, overriding the default DMA_BIDIRECTIONAL mapping. CQ callers
pass IB_ACCESS_LOCAL_WRITE, which only means the umem must be pinned
writable for GUP purposes; it says nothing about which side of the PCIe
link actually touches the memory. For a CQ ring the device writes CQEs
and the CPU only reads, the opposite of what IB_ACCESS_LOCAL_WRITE
conventionally implies for MR/WQE buffers.  Deriving the direction from
access flags the way the following patch does for other buffer types
would give DMA_BIDIRECTIONAL here (ib_access_writable() treats
IB_ACCESS_LOCAL_WRITE as writable), identical to today's unconditional
behaviour, and CQ buffers would get none of this hardening -- hence the
explicit override instead.

For dmabuf buffers the direction is managed by the dmabuf subsystem and
ib_umem_get_desc() routes them unchanged, ignoring the derived
direction.

All drivers that call the CQ pinning functions benefit automatically:
mlx5, mlx4, efa, bnxt_re, ionic, qedr, mana, erdma, and hns -- including
CQ resize and legacy VA-only creation paths, since an earlier commit
already routed all of them through ib_umem_get_cq_buf_or_va() instead of
the generic ib_umem_get_va(). vmw_pvrdma's CQ was deliberately left on
the generic path by that same commit for its own embedded ring-state
reason, and continues to correctly derive DMA_BIDIRECTIONAL there.

Security gain by platform:
  - Platforms with a write-enforcing IOMMU (e.g. CoCo guests backed by
    ARM SMMU or Intel VT-d in strict mode): a hostile device is
    hardware-prevented from reading write-only buffers (CQ ring),
    limiting information leakage.
  - Standard deployments without IOMMU direction enforcement: no
    practical security effect today, but the correct semantic
    declaration and zero runtime cost.

Note: the CPU does not write to the CQ ring buffer; the CQ
consumer-index doorbell update goes through the UAR (MMIO), not through
this DMA-mapped buffer.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/umem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index c2f277ada042..f1da70c4e352 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -587,6 +587,9 @@ static int uverbs_create_cq_get_buffer_desc(const struct uverbs_attr_bundle *att
  * must arrange its own backing (typically an in-kernel allocation)
  * when no source is available.
  *
+ * The buffer is mapped DMA_FROM_DEVICE: the NIC writes CQEs into it
+ * and the CPU only reads.
+ *
  * Return: caller-owned umem on success; NULL when no source supplied
  * a buffer; ERR_PTR(...) on error.
  */
@@ -597,7 +600,7 @@ struct ib_umem *ib_umem_get_cq_buf(struct ib_device *device,
 	return ib_umem_get_from_attrs(device, attrs,
 				      UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 				      uverbs_create_cq_get_buffer_desc,
-				      size, access, DMA_BIDIRECTIONAL);
+				      size, access, DMA_FROM_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf);
 
@@ -613,6 +616,9 @@ EXPORT_SYMBOL(ib_umem_get_cq_buf);
  * Like ib_umem_get_cq_buf(), but pins @addr/@size when neither the
  * UMEM attribute nor the legacy CQ buffer attributes are supplied.
  *
+ * The buffer is mapped DMA_FROM_DEVICE: the NIC writes CQEs into it
+ * and the CPU only reads.
+ *
  * See ib_umem_get_attr_or_va() for the note on @size's dual role and
  * the migration path for drivers that would distinguish a user-supplied
  * length from a driver-computed minimum.
@@ -626,7 +632,7 @@ struct ib_umem *ib_umem_get_cq_buf_or_va(struct ib_device *device,
 	return ib_umem_get_from_attrs_or_va(device, attrs,
 					    UVERBS_ATTR_CREATE_CQ_BUF_UMEM,
 					    uverbs_create_cq_get_buffer_desc,
-					    addr, size, access, DMA_BIDIRECTIONAL);
+					    addr, size, access, DMA_FROM_DEVICE);
 }
 EXPORT_SYMBOL(ib_umem_get_cq_buf_or_va);
 
-- 
2.18.1

