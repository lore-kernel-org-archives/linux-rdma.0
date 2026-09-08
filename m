Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAF956260D
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881420; cv=fail; b=dXTts65QiLUuTK0oMGSLZunva5EWZ+SeoAf7tQCfA7xd16aEUiwvYBV/qJo66YC/3FwtkuQVFEv0IvokpLMqmhmqGbMzs9cTZb0n0tlwmAJUtNLynHzT1d+sXa5kqLfBkm5zJ0lOKYRfjsY3PVUJB5GiOam7J0DpnyOJGG3VKYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881420; c=relaxed/simple;
	bh=5jwka++ZV6Sy5hgoiILxjgR9meJoOdyfgrAqy07Jimo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cooPIGcA0mrQvnLms6UpmQcxSs0ZeOAuhjiYSUj/wRj0nlGMYgLrZRnef/MqLAxjTOryg+ZLM5CQy1ZRuTaZtK42rmS6fGwRnrDH7OrlXJrObixMiEjDMupWz7VthBluyl0v74J+Q2HdRfZKMBJDgG2CHLccbBcwJK8S3v8PX0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nHl825p6; arc=fail smtp.client-ip=40.93.195.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nHl825p6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYChrniEkIaAzZbBySc8W9IYgVprnwi39/YewQKDl8sTGdBAY6MTbtzLgftooTfMNCIoTSzPaNWHnf1CZnTeohoHHSeHUO/ME0ifA7rBN042PgFEDxpZ0SIVQF/JbSaoQQqKB7AensGFtntaz6G2RGBESa+L8NCxyqE/MGMGgNLAzA6pHx5RpY5GHZ8N3vBchWi5kyhiwS02Qp5BSycu5z8zC7rywj+OsfSqsdTRvLNsEpZmMhhk4PXMQq0arGnksJJeVGfPGqMP5pijS5wy/2KuY5pfMzaaLVKknSI461CXb1aS6BoCcNFHcYFUcZ7KYqaSgyM/G3c24g96Wpifjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OI1yzcLV+i0VXTuVF+3egoGYps3Xu5+LMyG/IlV+og=;
 b=pZEzf9KdRah5Oy1+Qw465/uj1oIK5tC4a3WvA8uabuaO5B1K6QdhEDYsvweUaWOqg14Qx9GndY6S38a8DEt4kxQA51d1mI4Q6kDKkr9nEaJaKB+vZWkNA7W7N6icyZ+WP4n98PhgVrbchUTI3dGFqgP3LaUVWvtttCS/QrYbTg1QT92afWwWsqdiQusU+pOF6J2tFpJc4mW+f3XaQ07ukleJ1nTxoOEcPdtFiS9y35s5sgRD4a5R2Z+FH622+bj6BS155ACbFerQo5KKNmfPkFrprI/wdfywkbYriQsdWUqyTKbwaDAL3RtGfzAnSVLyQxepqz/AjCh2k7v7sfpqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OI1yzcLV+i0VXTuVF+3egoGYps3Xu5+LMyG/IlV+og=;
 b=nHl825p6jrLwqfk0rd7gDDlfYAvBs60jXRfsZuI1/X8YHv31nO/JVhdU9oNGXnlB20kPwE+10SjaT7TnvkVz53q+HPs+DTI4sgsuk+jdWzG/J1LPBChk9vbwGkQQyLl0tvdpodbbnnHjYjt2nrpt6XbBmAdrSVJBRRS/SBrA4srJz57hASLRJDidfTriFGrydOZXlMk0VhHOsrQIRAgUc/kKHXqhMlCizzRxP2VX78kuS34K+IDkSu4IFB6iE+kN252fzu+tZmqRP1OKfs/ZtStufHgBLXQl1kRH75JivNa+a/yyia2VXIhDYst5N4eK1YXZfcfkUSLmC2wyyWbfJQ==
Received: from BN9PR03CA0439.namprd03.prod.outlook.com (2603:10b6:408:113::24)
 by SA1PR12MB999251.namprd12.prod.outlook.com (2603:10b6:806:4dd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:30:05 +0000
Received: from BN2PEPF0000A895.namprd04.prod.outlook.com
 (2603:10b6:408:113:cafe::20) by BN9PR03CA0439.outlook.office365.com
 (2603:10b6:408:113::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A895.mail.protection.outlook.com (10.167.248.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:28 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:23 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 00/15] DMA direction and mlx5 driver correctness fixes
Date: Tue, 8 Sep 2026 18:28:36 +0300
Message-ID: <20260908152851.1307294-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A895:EE_|SA1PR12MB999251:EE_
X-MS-Office365-Filtering-Correlation-Id: dabed5ce-8430-496a-8303-08df0dbe0ed4
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|23010399003|82310400026|3023799007|10067099003|11063799006|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	GKSbpzdzbGT44cCdLcYj2HsYuUAjhi9wmzlr/UkULxzjbv3wdVwf56HVR4EKTHcjwqxLfCYg38QoNQo1u8P7iBGz03Sf76TmW7+aW8aeyxM/44FtBmGSq9KnlVW/YyaVtikDWCTIYOC3vxNn2nxojpgyq7j1FBJgRUN8AYW6ZKFDrxQjdcKU4Phvxc8EzeOmznR3soUTOKI1gLtBPLnkEN/qT27f/RDUBKcitSKcL2HOqcwU9Pk+92XjPhbt3fupmXptBWFF5ZUSnbAKF6jXXXotF0gYMI61gNqkAFNDBfh3rUHShz5Hqkkp/jh7OK2QPOWX/1aXTyIPyGI5dgwSbk+BHzhhduur4a+IgRAnBb7S8030IEyu5WfwXhjkg8gqzNgcIfAZHeL9pZmh3vXvOJFzC+Zt1n/iAqr9H4txJQM8T+hTsUunNRaARTLVnSfO0gilejNsGjmeRjbdls0/7gsuGpt5jvRZgaBNq4J7kVG3rJekoEPoq4WMYdKbnBKJMLGqaxUBkwusug1+0AIHyZ3IRXH/qHGT0OSuO12EwGb60dXnHf/5GdVS5LcOZrxGVa7k96UOSQAHi9UX3xmFvzBsZiLywhNvFJ1tutnGqWaD+01hN5umBnxgd5qVijsAT993Cb69/gLTNSmwXKwgck+uvAt+s6jTsZSdPJkvsdiuyVt8AxEQASogg7mMZO4XUsI48rKDtuDPwj4fr2QrCg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(23010399003)(82310400026)(3023799007)(10067099003)(11063799006)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J3LKNzFHxyrOwYApAgXutkBpxjZRYtjNOKbJ0q0H6Ft9rEgVqiU1juQrftw4GT59uLcXADimC1d1a+vxi53v+Sj75wR68aX9XB6oyjqf5YKW/KR+xJ6wFayiJeJh0iY0vVS2C52MrMx2mfFcvbFqsUVnF7R5JI30yzLSzOn5+GqncvLZIuuxrewZI6rv4KbGN0agaug7Bo2ZaCxmhN3KJRwQtc7c0q1M4xOioATkgyBBatEgcHHEPaDp6DMrl0S27PNZ32HZ90xbN86LlcPUJP7MgRZnmX7heTgGtXmxOOmMPjISP2i7pTF15d01FDzj+npVdxSiY52K7ZslpPtqhB2pS87cnq1CTZii5yNmjg2Y9AY1+RXk+7W1wVwxFC6WQ+RJ24M744VSrEniWahHmmlr+9Txqb9FZ7UL9/tp7D79dqKQS+NgOSPiwUv1tB0F
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:05.1635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dabed5ce-8430-496a-8303-08df0dbe0ed4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A895.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999251

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

 drivers/infiniband/core/umem.c                | 87 ++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c     | 19 ++--
 drivers/infiniband/hw/hns/hns_roce_cq.c       |  3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       | 22 +++--
 drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |  4 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   |  5 +-
 drivers/infiniband/hw/mana/cq.c               |  2 +-
 drivers/infiniband/hw/mana/main.c             |  9 +-
 drivers/infiniband/hw/mana/mana_ib.h          |  2 +-
 drivers/infiniband/hw/mana/qp.c               |  9 +-
 drivers/infiniband/hw/mana/wq.c               |  3 +-
 drivers/infiniband/hw/mlx4/cq.c               | 14 +--
 drivers/infiniband/hw/mlx5/cq.c               |  6 +-
 drivers/infiniband/hw/mlx5/main.c             | 56 +++++++-----
 drivers/infiniband/hw/mlx5/qp.c               | 29 ++++---
 drivers/infiniband/hw/mlx5/qpc.c              | 20 +++--
 drivers/infiniband/hw/mlx5/srq.c              |  3 +-
 drivers/infiniband/hw/qedr/verbs.c            | 23 +++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |  3 +-
 include/rdma/ib_umem.h                        |  2 +
 25 files changed, 223 insertions(+), 119 deletions(-)

-- 
2.18.1

