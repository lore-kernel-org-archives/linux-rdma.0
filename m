Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010041.outbound.protection.outlook.com [52.101.193.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1174BEE27;
	Wed, 30 Sep 2026 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768630; cv=fail; b=QQ0kLbavqtZgTIfVzWNuTRxh0MY/UNQRr4HjllV0tIPtdn9ux1BPK7n/ajufE9oH72Sb+6tclRtz4EDn+3u5qaHEemRbGzMA/lJZXsv5rYA/HWZJo/dvZHynvfbdX2pHSAIJpFrr8H05TFcsyT3rGRG9brm7t2OW5jEbbK5B+Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768630; c=relaxed/simple;
	bh=r9Wm60sc9tMnd22VSZ6B+pnrNURjmPa6IniaxgPNdJk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=koimDnx6q5Vi0BsLp+nfy0ggNES+7XtuC8EzAE9Js4b6/u98K6k7M2Aw5XqDz6Yo28v/9NlT9tnMQhgFUo6V9cbSHg9nuGv0a4FowxBw6dvreglxOsQpDDTCfZSqc8kntTGGsZ7Ogw36/uIwe4+Nw1yPIFrUuK4YUkYGnUYck9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WivASdpP; arc=fail smtp.client-ip=52.101.193.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WivASdpP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEpCJQ2CxBflNyKdF87xDJcnVzFr73TP0Lw7i7RqcokkbkvSwRRxo/gg2R25mtngl84yOhzYiy/MUNtM8CWaoZQRxI7spiRacYKn2b0JFLiARyo7Zjnaksidrx04nBhYoA8tEKT3KUCobl5NaTIkcIRIXl7Iobby3nqjoCOGGAEyLinBr6Q54mi6WfUP72SDWAaK45DJQCXzq+YDzIAFjjtrmZHiYBfU3eE6nlS66jL0+hznUge3L9wJATYDmMyig0ShmbJ0C2cwZNIffmrKvmPSzpk6suzoixcFlW234FQtOjU19Vtn2wYtgvYnJFkXGosh04RKmg6AxAFiSwJB8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yn7FqyQybb6HdN/63D7v7WVMTTJktwooWDRcTLI3kIQ=;
 b=awTyDgobKSO3UCj7Ey3NenzPMjsP/XdO+mcfKNP322+7k30yS4TV9SYA5WpkfQU69cuI1lXlx6qLU4FOEnOc6qZgWL2PdyCpelJshUNmR7slOOo0pZi8LY4bc+/QJ9yOpMGEL5duxQFUxASJVQnb5yeMkMJEeE0TYpokHMKrZTuBWEuogB/2gQfBWOL1v8+8ojqMZczJS0/XN84Vy594SAM9wAtO9nXMv7SQZTemgT+FFMfqrGWhJho3Sv/RV4qvG7omrMTJLSjmH1n32wS6FZdxFqLL6h+G4WpbYqFBi5VV41sWN8z36ogfWqxAXbXOnfx346MmjRhdSCX62TV/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn7FqyQybb6HdN/63D7v7WVMTTJktwooWDRcTLI3kIQ=;
 b=WivASdpPUFNN7Y18u8i5DAOEQLs7uuh97u90d+602wYHABN4aMVcZv71D0TmWdA6kudMapXiej1Im82U1w67ObnYDIZKkWXqGjMNn9lK5oGHETJ3XWn/sxmfQdqL3b6Lr2LNMh8Q/9LSloyYf2TUbJQyVLoAnMQnV2D3aZy/v0t29PCg0FYpaiH2niteAusLmHcHd+cvlrwD3JI1kYDbGZ7tXQjKVoi4PXmz59WxtxiH8J/vBU3UPhilw8fbl02G3w8zTtixvLFie4wrUt8HsV0Afm9TnIRdcXx8vfIYvIKpibIg/q2QJg+yjbDW+WevRIT6fyxMxIWBQZg9OIiwjw==
Received: from BN9PR03CA0380.namprd03.prod.outlook.com (2603:10b6:408:f7::25)
 by SJ5PPF6375781D1.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::995) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:43:41 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:408:f7:cafe::4c) by BN9PR03CA0380.outlook.office365.com
 (2603:10b6:408:f7::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:43:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:43:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:20 -0700
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
Subject: [PATCH mlx5-next V2 00/10] mlx5: Move data direct infrastructure to mlx5_core
Date: Wed, 30 Sep 2026 14:42:17 +0300
Message-ID: <20260930114227.139274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|SJ5PPF6375781D1:EE_
X-MS-Office365-Filtering-Correlation-Id: a49479f3-98d6-43a0-1e59-08df1ee8132c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|36860700016|82310400026|11063799006|10067099003|56012099006|6133799003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	6Tj9AEk6oK9oe18ZP5wpzAi/rQa/V5dp96UmzirjVXJZitq5a6zwIEwscFErcRENhKvqrK0O6cgUn6eb5VXRbUd5e1MaNKYOni67MzPxYFASJzlwJsX8hI5tnriQaUElWcd9fBSuVdkdDBtGFQ/a5O3RNRMzADxUAgrOiGLva+6FyoDYSVa/5cIzOsf/ZFWhazYk5msnL6KTZkKre5f2hqMUk4T/BpW+tyUFmiIUW1yWUCKjYhScSpnvQfRikRdcuJAyVtK31YOaF/6KDF0PYQf+CHGOe3PKZtdcqHjOtxKpOnPnmqmkOyf4pqR6COUE8y4eo6snkSu86hjING520KW6utztvygd2obcTzEtkyegm/JvQRTLvvRpqYQdKGm34dcvVCyecSA1hNwgQtCAZh2v4UIJ9FiHVGVaDNCPaAsieFy2C2YWiPD1Etto58MwssuFdC8g7eMRGmxvm6qLNnNWwE4pp+FmA1Zi/3lH9nqAYkfBGyIvAog8bzLFEOPP9LgYR9rYQwTqxl2wXg9ey1CtsbmZ0QGmSxeqJgbpUHbgcOzU0XOvhstIlUuRhvBU7AmHTe6gxqbERFx9Wc9fXjYdFEzjUvGl+Wam8VdwJHHLNxRHW8OQR2FqtzvAiu1TGk26S8Dl9AiLpJlDH2vR/XDQ2oq8MU60JnXDe5fyDLHTyUZb8T86x1wIogsOAxjR3edJ1sw5Xjke5yGjPYttTw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(11063799006)(10067099003)(56012099006)(6133799003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ixqzQ8PQvqQiceK7t0hEDeI7Y++xL/Wsf//eZ1YDl+9Ys7r4BEP8gvBCj/fePu/wLk48YLnnd/CuZPogG3rYeC/VEttwWH5Q/+W1gyWcuA0mKZUW+0j3+HsTRVrue1qfj2iyhFMB3JyqwqWosDEDqlzOl1Q8ZQCS/WflHL7y7kw4A4Db8v7BmcHK4Hlnq86RIgTw2QNVzHtMXwKR63GBXu9dq9Furg6ryn/tQWa5zuf/XMd47gJWWVPQbQkkFTvwcxIfNGzBsrWwmxd1I1Q57kYlUNsxbg/0QXp4q01b4oEopDDGOn4whN+h8AlOzOJL2bUyEgTE4pwLizJYKJCvbc4vED37+HBiWjiOjOuvlN2iiCMJJvChxyThzxvmu004e6bLK2at5HT0qnVuMn8n7eWmrR/EyiyD3gt2ls7WyVRL8Lcmk9gbPplpOHzh2wD+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:43:41.1034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a49479f3-98d6-43a0-1e59-08df1ee8132c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6375781D1

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

V2:
- Changed error message on VUID query failure (Leon)

V1:
https://lore.kernel.org/all/20260917111422.4054862-1-tariqt@nvidia.com/

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
 .../ethernet/mellanox/mlx5/core/data_direct.c | 400 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  15 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +
 include/linux/mlx5/data_direct.h              |  47 ++
 include/linux/mlx5/driver.h                   |   8 +
 17 files changed, 515 insertions(+), 421 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.c
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
 create mode 100644 include/linux/mlx5/data_direct.h


base-commit: 36b1d3299d0b6aa51485cc9a79b8d94948d5f3d4
-- 
2.44.0

