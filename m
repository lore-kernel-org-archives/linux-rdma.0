Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013012.outbound.protection.outlook.com [40.107.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828C7445AF2;
	Thu, 17 Sep 2026 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643722; cv=fail; b=EOfRrWmP++CLgQwWJdm5ZM63RrUxvP02RiAcDp0ZuIekIpRbC7sf34DKwg01E4Prmj09VBMM1qsg/v30KX/vCj8Aah/ZRm97QbqFTyTlhyfpPcrk/jrCogv2j3xv2aLKot0mZvBGyasNdhvZJyVWTGk7UssfK7UZE4MrcSTGKYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643722; c=relaxed/simple;
	bh=CR65iGfRmTz1UFSQXCX1w7C6iCKRvSE6jzCoPjaSy9I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eL0ihuR8FNF+FTjS+Zjg7q2z0thiw16ba/Qyogjyzs7nlSP1mUqf65GvO1cu30ayVLXSSA9Zvh0VOfW5OjTZtoD+hF27HgIK2XQ5mv0JTK9YlxRtugcr5t3ak1JoyJs2Ke6jSTy4KlKdn3OkuQREAuleS9Ia6FDDF8pAXXk/6Uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J4x+NScM; arc=fail smtp.client-ip=40.107.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J4x+NScM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPhgUD8oL+HJGiiLhH5AEo7WmFqEfHrWBlAqS6Q9mvoZlh2CWuI93dAQ48/A7OzdleIhs30kHJ5BIE/YDDt2n/3eWJfKJhchS9VC0st12Re4KwOp6qzSwwiLmcdRqKARMBRs+A3mPhpjvjtDGaMweAP8WOEohb6/CnqrvyauRKG4xONfn2EN0yO4ayeGCuKBTA5i27l0Qb3/JDsjdNX0Zx2MzyNUvtbj2kmYToPiSEcUaIgcqwcHVG3Zai3zIVVQLlzJ0w1bsy+9uGFnSSGg9IA7V+p8+MSxH49FIhIIJmjKB+O6twDPVbCK32tnDNoyOU1PQEyAOwyUQkuZQEHPEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIPFNSajlJPOTRNJN4X0yg07Ss8O28fgThYg/NGe9jk=;
 b=PHpmtas8Bv9IXgJLwaT9DvfDfDqLUFqP9XvAshnzVd3GmBlX7FbJRj8aDWIM3IcpU42ocVzBRx/np7N6LN1AnQQ/bYoG3qmuLSFtRGJLy7WPSqBcpbK/nFfhRyHRlILM/QhyFAU/xmcWOXjfwER75iqIno9nStMqXwxUPt85SHfnrJM4Hkx293+sr97v87aYdDiYXMmlDxPEOoyxyaT8tNC74n2eyldp2o3CnJUHeTlbKWDIXRkSGB3WDwF0AaYVK2AnhQyBEoh9nf6RnrvH0Q/Rp392H2qyrnIbeYS8pAlZxZuLZaR2EiB6SwEa7rY0WCgKbQBxvvi9SpzG+Cge2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIPFNSajlJPOTRNJN4X0yg07Ss8O28fgThYg/NGe9jk=;
 b=J4x+NScMrxvv3++Uj3jjL0HSARXcB3ZODwEOjv3sqbz9BIy74Wd/6xgs0Ax/fIO1PvR3vPEH3n9bWjF5eRLQ1++f2BKbjRkAL2oRbPAOz48BOA+72oiZKhlL9oOK32EtL8FhAxm/hO7gXafoJ5fNnui8HGfziRJMUEk4gUH/rAKgUTqUTlAbTMQ0JdzXQTbJHMAZEMoqBEfY7WNbbe2joPN1VQjIGw3NydY1Gz/96fyDHB945Evuwy7Jxg5+OwE4zUvbBYj2JVCYb4pN+nocWX8a3lyc6b1cesp8xx4CdY+nT2i6k37XwSjYvhwKdeFmm4a6uNGdbWVDmbhy0RcBqQ==
Received: from CH5P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::27)
 by SJ0PR12MB6736.namprd12.prod.outlook.com (2603:10b6:a03:47a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 11:15:11 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::2d) by CH5P220CA0013.outlook.office365.com
 (2603:10b6:610:1ef::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:00 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:14:55 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:14:51 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next 00/10] mlx5: Move data direct infrastructure to mlx5_core
Date: Thu, 17 Sep 2026 14:14:12 +0300
Message-ID: <20260917111422.4054862-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|SJ0PR12MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 4392205f-9508-45cb-1f0f-08df14acf019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|23010399003|56012099006|11063799006|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	u33CHcSu4lF9A91DpJYjbrqtJv7jJjbAyqvlPKlrz4BlW7lsERM/vQosw4nKNQ7dzi9ScDR5FJqC2SieNVxyV779ZxbECZ6MnmCCBOjlyiWDQNOIRV8tBIA2XVLNUw0ZxORD9ZlmUVSpQrlHmHkVNPJbvZqMM434RkhfCJ0mPbF9SYhG2h9yuwVGWmY3IeH8GKxLOJZFSj5AjH3B9Jd3EcJ/Sjva99pVdAH4R1bGFXA2vhU+pH7NsU0MC4KOuCnPLmzVvZLZDiTRcWVBfCxiRpJYXtaUqOmhJ+bDYBEcKqsPVtylKDGEz6lNoDP7IOCcRugyBre4xk2L/zHRvcXaHgBhCnMNaDehzWvTS6hjplv2yTHkV/bQcm8LLSqfFvFjuMqQjNBk0Pqmf3DD1t1a1aMyAvnm8Dxyry0fE0F4+XrvX36lVO6AOb3bW3dfYAvAuxZVdToSU3TxoJN+Yc8iOTosL/xQJBq5jGrJYdEgsoTPQq4tCqAHkD5o3Hj0Gq1FU3mwenz6QU3ov4mnBC1NtsMz/lcGKFf7mrnTAQcMxOllWw/aMSSdJHy4h/f/69Hx1GXjRqCMz4xlm7C1rJ1Qapu3xZdsEqbLN/jqt8M7fbk1bfFE4GN+6nQlKuna4+I8udttzNve8XkTB7/oJk55GPt2cO1WQqKhx2uia/c9nJnYB2JP4yoAj1FS9zn6ym9UebRRDgQ+5rxa+vOda/ggDg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uc+SjkI5edrSkqsRgC2hyPc3pZMWVGYeSbCaNzeXTidW+u99gSKL0fBRX48dju0T1yqOjuj+0cpINBj69vtNoDJoaBXAyKKzvLDSNCIvncUiLzJEcBRUR7wYwRdb0uNFJ1y3wEkDLKk/k/qBBd7buFjIf7CRuw6kYN8ug+C9pKxxtT+sNSa6g+svNCkUcbHJ4BOCOfOv/hXkn230kUSyK4Nu46I0lAfMQxefKxIQw/xz8+NyrTL7G7jNOaKmFI97sYhSuN0hI8iXvHcSr5CyXAG0ieYyeXBkNvbbuJNYUZX8QiPHOSrE4L6GiRVJhExc5pXzcW2aWGaO9zWHzrCgfXnBGyjaSBMLyVMX7aUDyGBjFuGuBTc9qsMPdn1rqmUvKIkcPKD/f6RjvmSUTIpQTvcNEbcnDiwI1xWemiqcpXhmaQ/P7jUYvpzdyTZW/PQF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:10.3503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4392205f-9508-45cb-1f0f-08df14acf019
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6736

Hi,

Data direct support currently lives in mlx5_ib, which owns the data
direct PCI driver, device matching and resource management. To prepare
for data direct support in netdev, move this infrastructure to mlx5_core
and provide a common interface for its consumers.

The series first replaces the direct IB unbind callback with a blocking
notifier chain, allowing multiple consumers to receive unbind events.
It then separates consumer registration from initialization,
consolidates the per-device state and resources, and keeps IB-specific
locking and MR teardown in mlx5_ib.

With these preparations in place, the final patch moves the shared
implementation and PCI driver to mlx5_core. Data direct initialization
and resource creation run during core load, before consumers attach;
cleanup runs during core unload, after consumers detach.

The data direct PCI driver is also explicitly named "mlx5_dd", replacing
the previous "mlx5_ib" name derived from KBUILD_MODNAME.

This series by Dragos prepares the shared infrastructure for netdev
support.  The netdev consumer will follow in a separate series.

Regards,
Tariq

Dragos Tatulea (10):
  RDMA/mlx5: Notify data direct users via a notifier chain on unbind
  RDMA/mlx5: Add mlx5_data_direct_supported() helper
  RDMA/mlx5: Make the data direct VUID query self-contained
  RDMA/mlx5: Give the data direct PCI driver a proper name
  RDMA/mlx5: Move and rename data direct resource functions
  RDMA/mlx5: Add new registration stage for data direct users
  RDMA/mlx5: Extract IB specific lock out of data direct
  RDMA/mlx5: Consolidate data direct state into one object
  RDMA/mlx5: Pull data_direct resource creation in init phase
  mlx5: Move data direct implementation to mlx5_core

 drivers/infiniband/hw/mlx5/Makefile           |   1 -
 drivers/infiniband/hw/mlx5/cmd.c              |  21 -
 drivers/infiniband/hw/mlx5/cmd.h              |   2 -
 drivers/infiniband/hw/mlx5/data_direct.c      | 227 ----------
 drivers/infiniband/hw/mlx5/data_direct.h      |  23 -
 drivers/infiniband/hw/mlx5/main.c             | 144 +------
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  18 +-
 drivers/infiniband/hw/mlx5/mr.c               |   7 +-
 drivers/infiniband/hw/mlx5/odp.c              |   2 +-
 drivers/infiniband/hw/mlx5/std_types.c        |   3 +-
 drivers/infiniband/hw/mlx5/umr.c              |  11 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/data_direct.c | 402 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  15 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +
 include/linux/mlx5/data_direct.h              |  47 ++
 include/linux/mlx5/driver.h                   |   8 +
 17 files changed, 517 insertions(+), 421 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.c
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
 create mode 100644 include/linux/mlx5/data_direct.h


base-commit: 36b1d3299d0b6aa51485cc9a79b8d94948d5f3d4
-- 
2.44.0

