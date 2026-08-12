Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A913F46C83C;
	Wed, 12 Aug 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546775; cv=fail; b=vCkh0/cS/2V+4xSZx+13OuvGVRJhkAwWvLDH3lJ5vPGGmbVcCO4nzNYG5LL7t8ybCb7ISlOQcZIX8zXtA+PZoJTRdOAwssaZ6kGGjksc+440YJ0wJ4LBnkiW7+7iYVfpfZf7TQ9Kq+2Z3lpP6dwV2MGTUk5qe1t4feCBBUXSKK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546775; c=relaxed/simple;
	bh=s+trHm0DiymDAru5aZGkaRptRFpLmqeqkImeXA17E7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cojrSFcOyIgq7k3a+LtlCk/pb53t32q5seDTXHICcNwgVIa1y8GKm9zEHeeSdeIkkwu98+BpOt9beu7Pz1/zFJtC8OP6PDRXh7KgVcv63q875/T2zuC9hJ0FoGxNfFC/7f1I2pjYdhXiuJxy44KVAEMxO9FOWDbmqV4B1LgfT1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OkRHwKzW; arc=fail smtp.client-ip=52.101.46.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OkRHwKzW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KPAw2L74PXreRGTK2PNWhC7l1IIujuFPv4MKC8PEz7/GWlRyWO6jzQQjplcc0ljKTldxpKMbpBWY8K+yvarubesSURoYeUB7qWO/5r+SxrhGrxDGA6nc5obeAgop2DHM27Q23sHmqGkXS6ICQP+PwpVUPUzsgcYIl6FRiOePKnxAutplMh+ZiEmJSsx5EHUbz4zl2NPI4u+/EMLyce1p8mpTvGt98zexd66BXNhVpOxVtl85cvnKdF6HVwXeVGEspK1pzUcmBko38wa87gXDbV7WfwSOzQD7PER+GrA646AI6XY714vzXaUsmr3QOlyLTUK8QM8HG5+uKX4KRFS8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdRRq4B+UtVi2BsamMzpsqRLYurqh87I0OzONwlHJK0=;
 b=xmU9fQbd7DWZeu2A/rne7wtN1sKtqUZE7oXq4cqpHC8gUcOZOJu3oNqd4w0W7OjPNw8NU/ztI7dBhm4AcNKUeaI9Tka9jivH8c7oJabIZscXLDjfT8XUrHdsh1L62a3wZ4vPb34+4D3lNQqfLyzW4tdbyh9DBeMAvby7X0uRmhmINPpeytVGkLAXx+I2ZFIhdKz5y7x+/ctXtllna/K5l3M1SinMh8ojin28Go6LIDA/xBNnwoXvRx6qiGhBTxXQRxZPdbFFdvm6efeyaXXrV1gpLm93upJCyUud0LaL1FNk/Xh7HfT8ozdQP41vNIoaWaQBk53foBdiqWTgGLXyIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdRRq4B+UtVi2BsamMzpsqRLYurqh87I0OzONwlHJK0=;
 b=OkRHwKzWErWDWgjjoS7s6XNHzOhgYcnOAru+5r7nCbHgQJH2UXKpFVg71kmtiRaGduEaegERJn7GPFNLa13HXkFYeLzPUbk9x5fF213DegBexEjh+HyDUffU1dv7OqPbbw/p++UjBwjzl7tYuibvdcm0ybNJuJni4ZyqO0AgIMVhsAXqHy0+KoSC4MTAfwAq4ZAoa3o6Z2ieCJd15Em9+B7LDUy5GGX/X6qlHmwbULSlMnlvhtm6sE/ctCorMCc0zqUZAFf+RJOFsrR/buo2Kn6jCsqtVkpgR6Ez7b66Ka1vLjaKZ2PFyrgIOzbiAhLWhVVsgOoLuKSNpaLP18uIjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8435.namprd12.prod.outlook.com (2603:10b6:806:2e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Wed, 12 Aug
 2026 14:59:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v4 00/10] mlx5 support for VFIO self test
Date: Wed, 12 Aug 2026 11:58:58 -0300
Message-ID: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:408:e2::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: 9860fbe7-18f4-4dc9-884a-08def88243ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|921020|6133799003|56012099006|10067099003|11063799006|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	oF3OAK9swOv/98Me+ixLR5HKeVfRF1/R0hUDS7EHGfGaMmWBbHy9kMJHIEUHI+7gcYmljl+kArU6r9Shqzh+TaKutt42QezCAmPdeUHJ9PV72DpYJq7bJtMV3crvc7CtH91g57ZwEAtIroWkEShaPugkO0CDogddPNQWVA9KRAP/kdjf9bCclIwCgVTVhY+JmhBl/ChTF/+6i/NBwaPeh80GbHLtBW8iu9GpKZ+FKUGvxxNin+AqDObJ4yb6zTkXtwSNRnU/MqYeUqC66DNlEwNNJ3xYw0ZW3OMTMb6Os0IcqcF8c45nLkdvhaB9jY4v9Z0yli6vEr6lYZ4aXK5vxeZB8PWDqQL2ZVEqwONIgnKQ9nCniVDaxoXR27wk8fBh4tW1DAjdCYs/OR6bgfXZ4UZkvzzSkSe9ds0jhcVT2RaUcdNYb7EgbO2eyk5oSwVWXZZpW4ad+4FBMhHjKwbawfIMKAyfTHXDiZ+dKTuvxXOteH5LiGy05B55cqjoZm2vmuPcQAnFdw+9IFE+Z2RuQoilPTCqMQuEB/JMAJaDSwf6OeHYdFDiLT5NrlNDO//Un9JvwhMEQwQ8S2miNS/zwDEBvVUVSwpGryasXyzF8IVN0VYNBlj6FnMZGn2moBBmWDuSYE9St9Uat6f07cyKYvYcvGWmaYZo+2+h6gvWDOszmFR+oDHUJh78f464zbbSRDHYJAAxGB1pO8Mizi/+ww==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(921020)(6133799003)(56012099006)(10067099003)(11063799006)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zCAzvQfjciFL3yEjuBQHXTttLB9qv7Xnv5gNUiITU1MV3BaS4AhTq8kTyBhZ?=
 =?us-ascii?Q?isEuBmpZM4NOIP3tPobFql/IQnOTumGyYf4a4oFkjtozVLN8bTUvzD02Lrd2?=
 =?us-ascii?Q?gRNZlBVelHq6NrSVVP2CRqPB4nYDUtWViOQFMho3M7MBgTpJOS3cIp26BExq?=
 =?us-ascii?Q?aMijt36Xg9L2DLADGVgmx4vcOrQlG2l+xE6XRx0A1mMlvtLeq8bNXitjZ975?=
 =?us-ascii?Q?43XzqnZ6wPs0WIYz8HbvrFuDy6TvqEiixmNjPxY6vsLfzCdsnFkaqYHXoJE3?=
 =?us-ascii?Q?L8FDYICtNezlBbwOb0ufCeQnHlWw0E275OCUmONQX9WVQSstIQwd4E9IBrfy?=
 =?us-ascii?Q?+HnHrTgmPHAxTGFhaH6V9u73DITSvvGfUEnkF6F3/IqTwYbOjT4bt4ookR05?=
 =?us-ascii?Q?Hvuhmkb0ajqr+Awrqi5xvw31b4FRvFywGSQFT6XwkvhtmMpzOFZmAFHzaFRo?=
 =?us-ascii?Q?11kLl3J86PVZBy/JtgB/vG/kjoZFw8nu2m3qTtD02y+9RPrTWFyb+KhHAohn?=
 =?us-ascii?Q?AgPfVfM6npBaXP/Rjh8VtJOCWsdbrYAYwp0C54ktF0AQcLR3RRGDZo4lVbtQ?=
 =?us-ascii?Q?8aP7zWGKn6tNy7KhlpJ/ZkZU8uHioIu0fj1p5lJ75FTJGw/qwuoxkSIkBvHQ?=
 =?us-ascii?Q?wtDy6F19x2rm8h/m8mShy7A3Qt8eNkKJ1qG36TSF2GehAldz7avKHAA5gCiY?=
 =?us-ascii?Q?CD9CT8qdBr4c1U1HWt6BgzXTClfUpITkr4u8ve7j+wDFTsL8iKmTtqetsF28?=
 =?us-ascii?Q?OkdUZR48JPzSzT4HJp34ja8/unkuVf6X55/nodrlVFkKIN2qI2KAgK9NiTd1?=
 =?us-ascii?Q?sbkexY3k9/D1C4yKBZgq7X3XlKoIbpTw8hzExzlQKwgaKGhkmO8k5Xm5pB+b?=
 =?us-ascii?Q?m7zJLDXOZNIPb5gJIPdj6fTZWRNvtg3VUCRZHgNHMyALJvXIiNaKy9EzUlE3?=
 =?us-ascii?Q?V/VgE/ESsO/Bc/bZMqudxDqe609yaiCZ3uIda9KFTkpE3cdHgmN1A6OajWCv?=
 =?us-ascii?Q?I3oRRt6tDigMcjsBxFbDgqF/cKg3JDiU68KaSmuNmIzpR/jU3I7yCq4g4GWn?=
 =?us-ascii?Q?wxliG0ME/JLcI+gQOlb2XpdrvTrQalcOxAXdSOd70XuES6GxisPqr1398AfV?=
 =?us-ascii?Q?R9sn7ssSzMp9Lp+eyZ5sl5SefuxkT9ScbHXkJV7KIXlKza8aZkpjDr/xJrHd?=
 =?us-ascii?Q?eO+ghhvuEAwF598zB7Kl4kOwpDam2W7iQ0UDYfSxbrxrkBQvB5hkFAgWViOB?=
 =?us-ascii?Q?7lp82rzr9zXjb2HVmm9xTeHnffiLbmXQ309uWKpKbclmhpH/7G4FFDmVaSbS?=
 =?us-ascii?Q?C0Cp2POStMfxrroFcy1REyta6P8DyWT7gPIlopvubwpw0o0W4ODcT3Tz4NkO?=
 =?us-ascii?Q?0FPhgW+vJzuSdPZUYv4OUebL3YQXPJXm42iUDAvYxUx/OSIsQ0kJWUkK9EIS?=
 =?us-ascii?Q?nWFZY784eYxkV57MBRRf5sT4xSMQO/NdNS8in9pliMCdUWJjtAqOIrjyJcG5?=
 =?us-ascii?Q?ouHIMHFCIuOMbDGeIJ6k6oEhmC3jQ7SLyCfa4a9n8SiUPLQCGIBzxTi+XlHs?=
 =?us-ascii?Q?wuDbNIwY+Af6ruPVfwPXrM+YSEopT+ATmcSll26WN5ENFl48EYtpnv07Bv+b?=
 =?us-ascii?Q?8Nt00PIwlpsKoumrJUre/pCCeXs0ADhTt4Cte4H8T2xIELwSmIb9nhWRMnNW?=
 =?us-ascii?Q?2ie8DoDtPsoLgmBUb9ficeEtIYeDw64BXxqGAYdtbQJGwuPF9XWyss/CBXqL?=
 =?us-ascii?Q?MXlLO7WUFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9860fbe7-18f4-4dc9-884a-08def88243ac
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:09.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmlHYAOe5UZx4Ky+w7n2ioWCcZOtczj7Z2rw+OEuvwKUoTmz9raoSrdM+BBc1HH6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8435

Add an mlx5 driver to VFIO self test. This is largely a remix of the
existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
to issue RDMA WRITE operations which effectively perform memory
copies using DMA. Since mlx5 has a stable programming ABI this
should work on devices from CX5 to current HW. The device FW must
support the QP loopback configuration.

Also support send_msi by arming completion events of the RDMA WRITE
to trigger MSI delivery.

mlx5 device startup is very complex and most of this code is just
booting the device, with a smaller amount for operating the QP.

This entire series was coded by Claude Code in about 4 days. It
used about 4.5M output tokens, 30 individual sessions and 5600 lines
of AI-generated .md files. I spent an annoying amount of time
de-slopping and cleaning its work product to make it presentable.
However, previous VFIO drivers have taken on the order of 1-2
months to write, so getting one in a week is pretty remarkable.

For those interested, the flow I used was broadly a prompt sequence
sort of like:

 - Hey Claude, go look at the falcon series, VFIO self test, the
   mlx5 driver, rdma-core and some PDF documentation and make a
   plan to put mlx5 under the selftest.
 - Write an rdma-core application using the built-in VFIO provider
   that can do the required memcpy operations that vfio selftests
   wants.
   (This resulted in a 1k loc C file that compiled and ran the
    first time but had a few bugs related to device programming
    that the AI resolved.)
 - Replace the rdma-core components with open-coded versions to
   create a fully stand-alone program that does the DMA memcpy.
 - Review and audit the thing.
 [Pause and de-slop it]
 - Make it work on a PF too (this is surprisingly hard!).
 [Move to a kernel tree and copy all the .md files and .c program
  it made]
 - Hey Claude, look at all this stuff and make a broad plan to
   actually build a VFIO self test.
 - Here is my 1 sentence advice on what each patch should look
   like, make a detailed plan to make a patch for every one.
 [Pause and polish the patch plans]
 - Execute plan X then commit it [pause and de-slop each patch,
   repeat].
 [Review and final polish]

v4:
 - Rebase on vfio next, update igb and falcon
 - Move rounding to iova_allocator_alloc()
 - Remove arm barrier changes
v3: https://patch.msgid.link/r/0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com
 - Move max into vfio_pci_driver_probe()
 - Rebase on v7.2-rc3
v2: https://patch.msgid.link/r/0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com
 - Rebase on v7.1-rc3, drop falcon patches
 - dev_dbg checks the format string even in non debug builds
 - Sort includes
 - Adjust comments/commit messageas
 - Use linux/pci_ids.h
 - Compute the driver.max_memcpy_size the same as mlx5 kernel driver, it
   should be GBs now on most devices
 - Put region_size into all drivers instead of allowing 0
v1: https://patch.msgid.link/r/0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com

Jason Gunthorpe (10):
  net/mlx5: Add IFC structures for CQE and WQE
  net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
  net/mlx5: Extract MLX5_SET/GET macros into mlx5_ifc_macros.h
  net/mlx5: Add ONCE and MMIO accessor variants to mlx5_ifc_macros.h
  selftests: Add additional kernel functions to tools/include/
  vfio: selftests: Allow drivers to specify required region size
  vfio: selftests: Add dev_dbg
  vfio: selftests: Add mlx5 driver - HW init and command interface
  vfio: selftests: Add mlx5 driver - data path and memcpy ops
  vfio: selftests: mlx5 driver - add send_msi support

 include/linux/mlx5/cq.h                       |   10 -
 include/linux/mlx5/device.h                   |  231 +-
 include/linux/mlx5/mlx5_ifc.h                 |  178 ++
 include/linux/mlx5/mlx5_ifc_macros.h          |  185 ++
 tools/arch/arm64/include/asm/barrier.h        |    4 +
 tools/arch/x86/include/asm/barrier.h          |    5 +
 tools/include/asm-generic/io.h                |   28 +
 tools/include/asm/barrier.h                   |    8 +
 tools/include/linux/stddef.h                  |   10 +
 .../selftests/vfio/lib/drivers/dsa/dsa.c      |    1 +
 .../selftests/vfio/lib/drivers/igb/igb.c      |    1 +
 .../selftests/vfio/lib/drivers/ioat/ioat.c    |    1 +
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 1928 +++++++++++++++++
 .../selftests/vfio/lib/drivers/mlx5/mlx5_hw.h |  114 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc.h          |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h     |    1 +
 .../vfio/lib/drivers/mlx5/mlx5_ifc_macros.h   |    1 +
 .../vfio/lib/drivers/nv_falcon/nv_falcon.c    |    1 +
 .../lib/include/libvfio/vfio_pci_device.h     |   11 +
 .../lib/include/libvfio/vfio_pci_driver.h     |    6 +
 .../selftests/vfio/lib/iova_allocator.c       |    5 +-
 tools/testing/selftests/vfio/lib/libvfio.mk   |    1 +
 .../selftests/vfio/lib/vfio_pci_driver.c      |    5 +
 .../selftests/vfio/vfio_pci_driver_test.c     |    3 +-
 24 files changed, 2498 insertions(+), 241 deletions(-)
 create mode 100644 include/linux/mlx5/mlx5_ifc_macros.h
 create mode 100644 tools/include/linux/stddef.h
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_hw.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_fpga.h
 create mode 120000 tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5_ifc_macros.h


base-commit: 28ca5f67e1a79f62ed7988674fb07a8fc9eab8d2
-- 
2.43.0

