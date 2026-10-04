Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011056.outbound.protection.outlook.com [40.107.208.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3C4352030;
	Sun,  4 Oct 2026 06:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791096599; cv=fail; b=MdEoejF/QQrCDz10vOjsy92jMJJnCs7fVgJJKg9vRihAxC229nJqV8OA960AWByXRE5aSYaMwbLmkSHZKEjneV7Xyuf+Jw0DYxvPZc8tw/pDVOwO1W2Vh1lijmBVdPy9sYn/kLP6zXUOcDpl3EpdGxFCywox+aiWQ7iBW+QSKvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791096599; c=relaxed/simple;
	bh=bfeLESUN4v8SB9UssKknA5SVpXkAwBJ8iv8U9Ha0Bh4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c5T98HL5zX7KWmJoUs6KE6S7tqaWNbT/6fQfHPSz9ZKpGRQbjpSmhdLw3KL/Su0EHHrLl8Z4MfK1N0uER/lESRAjho6pl1dW2qqwuohd4bg/hNSuELdQ+K4rGZN/JhPACD0waIMERNlTrOKKGr9aPMBcGjfXCR8ZUWKTAiOWfVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kkYu7d2H; arc=fail smtp.client-ip=40.107.208.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kkYu7d2H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDxyr9c4Zz46Fp96BlLlgpZEsraEIiOrsO3fbuxjI1HDcT4/snLOs0zIfrFPN289CgG1EqqwdnkPEJxFLYq7FLhq+dptxZfR20Okf7/agqJdi2n/85gm08c2SxjWKg5Jmj3436sZY2ZvFXvjsmqaIfG+Lg4tAZmGdwYMYo0d/6gqFefsdadVOP81aXlZGP7CHIYSzaoZAPa9fedEXAE6OhO92dYuqrIbiVod6fY9c0iZ/W8kulqo+XilcxRyhj32Y8wUYrPX3XQgnQR2/cT78F5PmCHDyAMkfaxFfqnpUCIEgCmpFYiR2d06zgAQWlskOqqI21+WrYq1hB4pYC6gQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lvwd8hLV4YbfzOLwOAVVw3iXTxexnl5OJKwSEqf2RWE=;
 b=Ns0eG3rV4W1pF9fsIKxGicBgSYyayjvmWuynvfbwnEbXTnzNyK4iQyIEkgqCz91W4crgX7BoLDKw0Q1ng+Qf8BloGBTR9rIuH0MO7c50FO2mrUsF/x6kMmkpM6E5Z2rPP17eI6yIfiZeoTxUc7SRYvnAk66SJOHL+SZZrcgjMhcCxIi0kpxaGk7yeig83TJV6pVF2KouuU7+NyYfafxgQW3ky75LQAJGw8ihYYFjLM7iv3OYOYLYVs9KTJjAnjNZlEjzPyhYsvMJR3+mawubrbHoGv5QgllZP+3Hq2NWoI+7adTcsYm/bpK1riZofllYZtpKtRO8CGPMAZ1EzMWPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lvwd8hLV4YbfzOLwOAVVw3iXTxexnl5OJKwSEqf2RWE=;
 b=kkYu7d2Hjfc/PPRlkWawQ1CAXJLuZYltwe6xp02gP5puItdagY965EC4cR/dHfKPDKZrHOtEi7J4gg2nWPrpnoGaW/PAAZP+xdDrbPV+ovjteEihTX17wPKbxBworHCRiYvIRfkurUJo+f2t7qBcKbEBxuE3RFi2wTIjnV6FGbnAdzvm+SQkT44T8CnEXyF0hZej+us3LF5a87mvfqKb90JaR/5ABoMP8gdCbBlPA0jTyWlhS5jTqVud2jf+xaIbB4LILEB8jgFNtdYFHNW00tAHx4TKW5mibmx7trfDGeU1T1Mysfo3WP1U/t3NgMtP/7gtdOqc2c25CgX6d7umwA==
Received: from CH0P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::31)
 by MW4PR12MB5666.namprd12.prod.outlook.com (2603:10b6:303:188::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 06:49:53 +0000
Received: from BL6PEPF0006C3DE.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::79) by CH0P223CA0007.outlook.office365.com
 (2603:10b6:610:116::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Sun, 4
 Oct 2026 06:49:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0006C3DE.mail.protection.outlook.com (10.167.249.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Sun, 4 Oct 2026 06:49:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sat, 3 Oct
 2026 23:49:41 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 23:49:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sat, 3 Oct 2026 23:49:36 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [pull-request] mlx5: Move data direct infrastructure to mlx5_core
Date: Sun, 4 Oct 2026 09:49:21 +0300
Message-ID: <20261004064921.213888-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DE:EE_|MW4PR12MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e5e5ce5-15a6-47f2-d353-08df21e3b11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|23010399003|6133799003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	D3/CoywAY1fbHWUK0g2g9QnQ9Dyf+RaXx/VP+/KiUN9NA2grtvaCabnchYIC13St6d6AjEaZrz1J16fR4li3QUski9nc2d+4Q6FncgiHc5W3LGas4+1DefMQ2oeDE7V9LD3+pA/wAyZk61B+crxBk+cXDDcE/GOBhFFd8lw5ofCtQxsEFtsTkG+j6MI6RG3h5CHMAIud0eYbFShDmgyxnM0wW0n/iHaFUtkvZmKrltj3BYYWoHNzSV9PsfB71nATNu4LvCPBLDPO7KG+7U46Nl2atZEu7+JO4TJLFURIPqke2dtkFT62O63LUysFw1EK26UB+Jmn51rHuPqlV0Sh8UrQWGd8S7T6mw+ar7Ep3KxxcR7nsfYO3ymy8w+afSsS/QjSG/3dYV/OcYiX7vD6ttos25DX7klRgVQTi9RfKRWgFBeySJE/ctDD4UygUj693QMYoGHZf1zy9Hsrr3IuDmLCWJ48BfTYa+oTnccYK03LFJ9gYt7ncgdICD+ZNhZByzfclDHB0GdY4E0NFPtRNwuXTp5eAb0K7DVlH/mlo2ICOm4mfhpqHslYGCYdLE34uo2ZixJWcy2PUDfytEU/RWTzUi8Y1Ta01STMJIErjjpI1ciWkmTX3Mp0zi3bwI9xE6/FRecgZwVs+fkUqvG9jCTfwWx46tz1lkecDQDZFONlj+PMGI6e37UQIZNHCctTkZhdp++OefOLbkdOa4AB2w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(23010399003)(6133799003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Y4URZKTYaUrMPqeQcMu1vQbwSWpHTx5fRXsuITE6xMRHIJXWIW20glx7W/XyvZm0GeVuAT27sQOQ2Id4RFp6GXjan/efPck5O2poulMY2WuzhbPEk205WH8DATwWH0KzRBj6uRh4/UfaWNHKYmeXciRC0yp4MD2rPkAPNz/SP/bNHimSoFiav5HmOiAbvT48TWrWyzAKiLJuQbz2L2b1EC2U2a0mVihEauT31TBLTNN6hJ9fXyX3xXvgdM3MYcoauHqsiH35Ey22m4i5Eb0rzhMz5fZG7gnrYuBXc7r2OhvoeRyotPe7sSu1YzBuzCZVG3FuqUirCDWEs9O4Y3QWGr7w4PtoD1fW+gNOXqr2GJNzgJgCw9nFlYb7FUbqP8Z5Yx8/Qp6Zp0zcL4JKlme1YHb62n6LS4NbEwuuIVTXwI4TIRbcXB0BZYE3TIWpZucU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 06:49:52.0674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5e5ce5-15a6-47f2-d353-08df21e3b11c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5666

Hi,

The following pull-request contains common mlx5 updates
for your *net-next* tree.
Please pull and let me know of any problem.

Find more details below [1].

Regards,
Tariq

[1]
Data direct support currently lives in mlx5_ib, which owns the data
direct PCI driver, device matching and resource management. To prepare
for data direct support in netdev, move this infrastructure to mlx5_core
and provide a common interface for its consumers.

The series first replaces the direct IB unbind callback with a blocking
notifier chain, allowing multiple consumers to receive unbind events.
It then separates consumer registration from initialization, consolidates
the per-device state and resources, and keeps IB-specific locking and MR
teardown in mlx5_ib.

With these preparations in place, the final patch moves the shared
implementation and PCI driver to mlx5_core. Data direct initialization
and resource creation run during core load, before consumers attach;
cleanup runs during core unload, after consumers detach.

The data direct PCI driver is also explicitly named "mlx5_dd", replacing
the previous "mlx5_ib" name derived from KBUILD_MODNAME.

This series prepares the shared infrastructure for netdev support.
The netdev consumer will follow in a separate series.

----------------------------------------------------------------

The following changes since commit 36b1d3299d0b6aa51485cc9a79b8d94948d5f3d4:

  net/mlx5: Add qp_latency_sensitive_disable cap bit (2026-07-27 02:35:16 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 00290b9ff59ef47b990d26a6b1a8b2ea6dedf5e9:

  mlx5: Move data direct implementation to mlx5_core (2026-10-01 11:40:42 -0400)

----------------------------------------------------------------
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

 drivers/infiniband/hw/mlx5/Makefile                |   1 -
 drivers/infiniband/hw/mlx5/cmd.c                   |  21 --
 drivers/infiniband/hw/mlx5/cmd.h                   |   2 -
 drivers/infiniband/hw/mlx5/data_direct.c           | 227 ------------
 drivers/infiniband/hw/mlx5/data_direct.h           |  23 --
 drivers/infiniband/hw/mlx5/main.c                  | 144 ++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  18 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   7 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   2 +-
 drivers/infiniband/hw/mlx5/std_types.c             |   3 +-
 drivers/infiniband/hw/mlx5/umr.c                   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/data_direct.c  | 400 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  15 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   5 +
 include/linux/mlx5/data_direct.h                   |  47 +++
 include/linux/mlx5/driver.h                        |   8 +
 17 files changed, 515 insertions(+), 421 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.c
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
 create mode 100644 include/linux/mlx5/data_direct.h
