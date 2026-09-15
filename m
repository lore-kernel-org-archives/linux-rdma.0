Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6918735F161
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481470; cv=fail; b=Oy0TIr4CZ4pkNlhIWEE6BPUeF3BiAKFtfM5LIv+WyTt0Xc07nlbcFSHcnIUS0bTHwS/aVZZTeh5PoaIfSWqO2ZdTkJvs1c4QLHe9Uf8O6s2scsSQjnGzeOIOhBfcIAqkui1Gfr4klY2uRUDM9siptPc8ljpEKnGnglhnZgUxzo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481470; c=relaxed/simple;
	bh=BvKSlc6YMKYh+j4Bvu1JfJXBvC8aKUmuYw5qr+O7zXc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xn9pxMTltrqAmXbZemk9g8WBaqC6f7P2Hr2mU8CG6yJmmoua0gGkrFFNSGbnFWzJpueYJIvDTuJgI58EqF9dT0osrZpnB0WdH5KbjTIlDZTf+7WZmV5OOivC9u43IQW+IlN/W5QZQzfC16F1JkxozbsySzX6G4AjBKvZhoKAsZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HL5ORRnq; arc=fail smtp.client-ip=40.93.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HL5ORRnq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygJPgN7TobC7yagjeRuIqrAmoX5XWGF0WribznG2VPHWaf28PhmvyrmUpzMZRlgqHzdqftkZ4WjQ37Cod5LjpN7DTSauUS+wuCnb0jMYrhgS0WruT2iCd5j6TLeId3izKxRrAP0BE5zyT2kbMWnebueSc/XAmkB3dPqvqWeVh6Q6h6aWnxlfi1eriMenznHPbyC+1w1VSQXIlECsufpCQw879BEsu7PEpV3hN50P9WjyEn3J9C6bPeY+GQnvnr+VEu4Rv3b+JBD/cWUleXhRMtT3XfjzzheXvxh4SuaSMVzA5SDojokbORBW1dRWk+lUGHNacFKke55AXhLgesXutg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/hzcxpsGYD7TbQBJ94zpoS3rjXd6sC7uATN2w6jxnA=;
 b=nBYj669DGSa+BT7TS28Y60VRXoQtlDLmvY1gp+aKrkSVueEQNgoPamn/e1NafoFZlROlf8DZz0wX5Syuh+O3X6AgC9+flG6bnmigAd/FLlDiFrOC3FecbHOg6lFkZ/mDY0eUuPqd1f7sy5GkJkAuwf2c9UDi5ALYCFz46vn5s99oj/9LZQnGTFgiM3POiS0S0MZ7rKxilfIMS9Thvpm0SVTZ1h6eT4wAlRyqAECxCz8wU8Yv3pI16K1CEgcKEuJrV7dZay4pAi2F/nXCHJui1cRrZnLfxksAv7WHyegk5mTAItAX3pxEilqaMbDNbhwz4giRiB36btXMq7+yV3Aoiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/hzcxpsGYD7TbQBJ94zpoS3rjXd6sC7uATN2w6jxnA=;
 b=HL5ORRnqpsKM/UkOjfbE9q8kQOGszyFG6jK4lMxpTFobyAEWQwyWp8Decj7C3BHSigVxNdkYy9NhTxjcBgCdawDHZpA7F7TxEPTQExG7MZl0Zt1WnG/ikMlugkYeHn+iLqWGHuTaex36/0SuNwuvtwE87mMO/y3pJ/Ben6NzNgtKYaDdjCN6OJXThs0F4DIvznushvIZGaS8Bu1v+USqyPQswkdTm8aOpDA6itIdg3cJBRflrZj9wseXT9tN7oJwbLO0mAInblHg7HnIKzqtv3iJ/MhFw72m2SuVeIpKszd+j3o1XLA12DP6ISu99hNlsK9CYdQIEfkovfAWcyrGwA==
Received: from PH0PR07CA0012.namprd07.prod.outlook.com (2603:10b6:510:5::17)
 by CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:10:40 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::8b) by PH0PR07CA0012.outlook.office365.com
 (2603:10b6:510:5::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 14:10:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:10:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:09 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:08 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:04 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 00/15] DMA direction and mlx5 driver correctness fixes
Date: Tue, 15 Sep 2026 17:09:18 +0300
Message-ID: <20260915140933.40580-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|CY8PR12MB8297:EE_
X-MS-Office365-Filtering-Correlation-Id: 087c4391-d0dd-4eaa-bf14-08df13331caa
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|18002099003|13003099007|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	13QPWeYOS396ouzdLfGnOzy52T7PCAPZVkvZPqzGde5/PJ1bZFlE9cVgSu0jqKhS9OS8WA3DkYJKCKqhXUNHE/ryPWc0AhM9qs+ehv6yKOGsi3eX5FGabmYU+P9eoEBWS5s14aXCUpbQBQK25PI/GzKI2gHdS2UeEYa6/Kf1hOZkRDWU0ekeYdWAC1SxXrghYkOliLVymoIMma9slDXZ4n+1tq0xClxziIbIe3wjuFc44ppV8mY36kPy598bYbHvyTzU4/MNIlyQN2qdoQMhqjESUJUbwhBh9n12NhGee+vfxRLZD+EpSCLZGeo90vJGsGlubcXhmeZENzVrbQGfEN1XUkXTJhcg9V2S5bbLRSH0Bqu3xkAM8iCPAk2A9+MNuDRlZ3mkDY3zHcff8f6ITxt9X2p2Kxniy3tkyWlxhcV5r0tQj360NW3zKqnzlDMWDriUYJXsyS6MKXUOapp94opJB4ZXvEz2h2SRgz06YFEyOTWoAAD6VGVpdIMOzRMbc1GzuucsyPZswAWSbH+K7I9gP4LFhAaNAU1NcDTkClC9HF3CD5tEoDzO9PbXBaY0Oex798Ylq0HylJX2QDIPcoFvQMaQ/XV69gYboDNfyNX9Fmkdus8JBc/PkjUrZDNBuFqwbtY5J75/B2BlYoeTqTxiQl5lNNZx2bPBpcWxFCQvjACPvxfvsrW1b43AT8ts7YTEgVFQfrvZFK0wpVAtZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(18002099003)(13003099007)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4xsLloNsoHYE49y16+TXhOPavlsVLaaOCoc/Is706gSlQzslyE5Gd2Hu6oDjNtj8DIgaoPt2Sq85MkRjBa0GYcWZ09s8NnfJHgCKswNF3vVOkvGjTAsKxsEJd/ivpCRzTvyd6IOLIANSSZO6fN0ySVkNsr2lLKStgMhiwEZhf2i8+RdAmihrs9Kq4x1j+j6OkAyxhXgaW8S2VsdjPR/iTUhtcI34Sz+CFBctmJZSrF5Mvg1WQPKln1IYVs7aCCuJZFWg6rAlSIaSbsU0zZRWcxR+2UF6udL90jS1m+6OWJ/RsN5gSg3Kyc0i8Quu2JxMlXWlOwnjqO03T5kzbCH95wRzYAVKXhEMMOUV50ItzTgmBUQmW51GAoadULeAKE7WIk9cABEPOAi0tKWxJsBasFAD2xWsLPsvErTO8Rep+gHM28dwMAZDtDWSRmpJ/EJm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:10:35.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 087c4391-d0dd-4eaa-bf14-08df13331caa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8297

This series contains two independent groups of fixes for the RDMA
subsystem.

Group 1: DMA direction correctness (patches 1-7).

RDMA drivers have historically mapped all pinned user buffers
DMA_BIDIRECTIONAL regardless of how the device actually accesses them.
This group tightens the DMA mapping direction to match the real access
pattern for each buffer type:

  - CQ ring buffers: the device writes CQEs, the CPU only reads.
    Mapped DMA_FROM_DEVICE.

  - WQE rings, SRQ rings, doorbell records: the CPU writes, the device
    only reads.  Mapped DMA_TO_DEVICE (derived from the absence of any
    write access flag).

  - Writable MRs and other buffers with write access flags: unchanged,
    DMA_BIDIRECTIONAL.

On platforms with a write-enforcing IOMMU this prevents the device from
accessing memory beyond what the mapping semantically declares.  On
standard deployments without direction enforcement the change declares
the correct semantic at zero runtime cost.

The group includes preparatory driver fixes (patches 1-3) that correct
existing access=0 pins on writable buffers in erdma, hns, and
vmw_pvrdma, and a refactoring patch (4) that consolidates all CQ buffer
pinning through ib_umem_get_cq_buf_or_va() so the directional change in
patch 6 covers every CQ call site automatically.  Full details are in
the individual commit logs.

Group 2: mlx5 driver correctness fixes (patches 8-15).

Patch 8 fixes driver probe failure on XRC-less devices.
mlx5_ib_dev_res_init() was returning -EOPNOTSUPP when the firmware XRC
capability is absent. XRC is optional; the patch makes the devr
resource path XRC-optional throughout.

Patches 9-14 fix a cluster of related bugs in the mlx5 firmware event
dispatch path. The common root cause is that resources were made
visible to the event notifier (via radix tree or xarray insertion)
before their event callback, container pointer, and refcount were fully
initialized, leaving windows where firmware EQEs could call through NULL
function pointers or corrupt refcounts:

- mlx5_ib_wq_event() never released the reference taken before
    dispatch, leaking it on every WQ event.
  - WQ, SRQ, QP, and raw-packet QP SQ/RQ event callbacks were
    assigned after the resource became visible to the notifier.
    For SRQ and QP paths this directly causes a kernel crash on any
    matching firmware event.
  - create_resource_common() initialized the refcount and completion
    after the radix tree insert, allowing refcount_inc() on a
    still-zero refcount_t, which saturates the counter and permanently
    corrupts the resource's lifecycle tracking.

Patch 15 fixes undefined behavior in the EQE type field shift: the u8
type is left-shifted by 24 without a cast, promoting it to signed int
and causing UB for values >= 128.  All currently used type codes are
below 128, but a cast to u32 makes the shift well-defined.

Changes from V0:
- Clean up some AI-generated commit messages and comments.
- Patch #7: Add a simple wrapper for a repeated pattern.
- Link to V0: https://lore.kernel.org/linux-rdma/20260908152851.1307294-1-yishaih@nvidia.com/T/#t

Yishai

Yishai Hadas (15):
  RDMA/erdma: Pin CQ buffer writable to match device DMA write access
  RDMA/hns: Pin CQ buffer writable to match device DMA write access
  RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA
    write access
  RDMA/umem: Reuse ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
  RDMA/umem: Support an explicit DMA direction other than
    DMA_BIDIRECTIONAL
  RDMA/umem: Map CQ buffers DMA_FROM_DEVICE
  RDMA/umem: Derive DMA direction from IB access flags
  RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
  RDMA/mlx5: Put resource reference in mlx5_ib_wq_event()
  RDMA/mlx5: Set WQ event handler before firmware RQ insertion
  RDMA/mlx5: Set SRQ event handler before xarray insertion
  RDMA/mlx5: Set RQ event handler for raw-packet QP
  RDMA/mlx5: Set QP event handler before firmware QPC insertion
  RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
  RDMA/mlx5: Fix signed integer overflow in EQE qp_srq type shift

 drivers/infiniband/core/umem.c                | 77 +++++++++++++------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++-
 drivers/infiniband/hw/erdma/erdma_verbs.c     | 19 +++--
 drivers/infiniband/hw/hns/hns_roce_cq.c       |  3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       | 22 ++++--
 drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |  4 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   |  5 +-
 drivers/infiniband/hw/mana/cq.c               |  2 +-
 drivers/infiniband/hw/mana/main.c             |  9 ++-
 drivers/infiniband/hw/mana/mana_ib.h          |  2 +-
 drivers/infiniband/hw/mana/qp.c               |  9 ++-
 drivers/infiniband/hw/mana/wq.c               |  3 +-
 drivers/infiniband/hw/mlx4/cq.c               | 14 ++--
 drivers/infiniband/hw/mlx5/cq.c               |  6 +-
 drivers/infiniband/hw/mlx5/main.c             | 56 ++++++++------
 drivers/infiniband/hw/mlx5/qp.c               | 29 +++----
 drivers/infiniband/hw/mlx5/qpc.c              | 20 +++--
 drivers/infiniband/hw/mlx5/srq.c              |  3 +-
 drivers/infiniband/hw/qedr/verbs.c            | 23 ++++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |  3 +-
 include/rdma/ib_umem.h                        |  2 +
 25 files changed, 213 insertions(+), 119 deletions(-)

-- 
2.18.1

