Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010015.outbound.protection.outlook.com [52.101.201.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576373DA5B3;
	Thu, 23 Jul 2026 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791401; cv=fail; b=apOAQqJYzUnPrgs/G9SkMKm3w3aVwy3GnRIhE+vbAUR1chGHAbwKvrJpWBZDYuRYvj8HmdHMlbYg237/3NuFv3ucreYdveSJGSuIGddtMaYnT65yKLQhKomUW9KSyxP8SRk2L5DPD2aZylsdeyxEvhDWFK/nQQt8t5yFwFnYWQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791401; c=relaxed/simple;
	bh=H8LEeMz5x/soJHqHXqV/GyS3beK1CIlI/w9sF6tjCyw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PPJdMaP+wGR9oRow4/tEtXQZQB5xPNrvzOyFeiiky/5B543t/P8FOxX1U7VxsWHeDIusOk69ugQEGHfC7XVAVakSK1lONpYCqV8JeKLqczYppN1ZWRhNmUUNAJ7L9SBInWepDcAh+uPEI8n0XWlIVLno8fD2n1YDQSyQuTitETc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U4oi66w2; arc=fail smtp.client-ip=52.101.201.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U4oi66w2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIs8RY4k+R7B8aEER4gmQOEvenB61SysrDQNP3DQcNVZLG6IilTjWwkCX64MhqTSLzd3J++WhbZGj8FukTXIrgV09eO5cGw+ziyOvvdhU7IRXoYr0BJj6FEqJT1fUicjGCgYrZF1FoVhafCA0PTxZdLvb2vLCoRokCI5aCHppEHTqgfhrRqbHblTVSLPr1W0g9fMzmiqXyLdklTsq8/DdqYgc+V/U91TBirYqOKwLzZRpDk62d51bJLi4pfHMGXdqA7UFa2Qjdth74z+CxngTteYNCMpmR+ye466OYfRo+3tn7XzozPzduav+xfY4eRu9ArgyHN2YW0sc3lsBvyeRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abaJPrVgrn2iLDDS9TXE3iSO8i5zb1j6dOazXyQXVlo=;
 b=vwu09eshBsOMR/Nz0MO8j7YxuLw0UA7TCbaLnbUvcomqyLGvAni4GXQc5CdGHHsfm6dTHG6eoQcBcvAAj1oJf/x+PvQuw08uMU+Ud92fcLBMXUfSrdDOy8GEuVd4I/A57ioGucmfcypEusHkQwvR3mSqDhycoAK61r98UBz5sq1A0rBeWzEGekwOHq2IcydHLHDIrt661/zxIFTUYmlu6+PAfF7mTMxaWPAIwSq3AERtJzhyVAu2CLxphg4FHITtN0WfTiWJfH88Z5zgn+X1cI35V0OsrA6TAY0RKiwzwdsdOERvB4MIEpBjjGR3zz44FtudsFHcTc5/zKRwFVOVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abaJPrVgrn2iLDDS9TXE3iSO8i5zb1j6dOazXyQXVlo=;
 b=U4oi66w2qarE57ZZBSgl6DwZuCbbeQY77JiIhd3m66mIy4IIqCc8ZiVXTL8ph2HrVV2oylsoytaAx+jFxRne/OV9OvUHnO/cK5qVuEDkcBcocz3WALWpJ65jY2VXnkXjYLxc1st0XmYszqxKSEdszCwzR6hQRyQcVCC3NbHC+vwJFJPVjn1LN1jX91bg5BIW3IwOJ2rf5i+tn1lz3OKrsH7R0821+VRn2AYm3zgWOFwNzgSE1ZP6eVN6jqFLCItMyJlvbQoPJ6vAmLvVhtDJki6HSFrwI4r8LEiGkmNXIwGywchlm9QhrQ3LqWqIn9y35APpiI2hK23BIli02iEkKQ==
Received: from CH2PR11CA0023.namprd11.prod.outlook.com (2603:10b6:610:54::33)
 by CYYPR12MB8750.namprd12.prod.outlook.com (2603:10b6:930:be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 07:23:08 +0000
Received: from DS2PEPF000061C8.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::77) by CH2PR11CA0023.outlook.office365.com
 (2603:10b6:610:54::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 07:23:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C8.mail.protection.outlook.com (10.167.23.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:23:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:22:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:22:54 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:22:50 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 0/3] net/mlx5: allocate doorbells from dma pools
Date: Thu, 23 Jul 2026 10:22:19 +0300
Message-ID: <20260723072222.1863558-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C8:EE_|CYYPR12MB8750:EE_
X-MS-Office365-Filtering-Correlation-Id: 7593c221-f528-4865-7566-08dee88b3e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|18002099003|6133799003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8RyhXKTAwLCL/JRXrboeTYRmzN2NgKkVz+2q2837fTrQTtJbJIRjUi1ZVJj/4lsIcViqpNX0YNTOx3WOI2Jp1JtZtkT9s5UGgNlsmcBDP7INYeogZVt+UsPje3ham8a7VXt2am8qr0+UPGDa6cxWwnszfkiIhmhIK8UOPZMTqO9jPh7+J88eFYe6wmTmTLpZ0jHTNM4XOZCTJRp09JxyJm3duIdBOanKimsJT3CaEKolE8jebb4fr7i5y0J2UuoRdDbk2NazRcNSTtU3rlxG1DrAFu+T14kmWvna05U1xCxsGQgapo4uySgAav8nsDCGQ/Sdt63iUrl4OMJ+QAU5JgSTiMB0Ygj86h4msDWgpoIEeR7g7+LDF8ElYQfuYyYB4u87XfP562TdAMEgUlnfxLmRYSaHTnsAZ7AP9yqTc12WfIbKMLZ/oP+KPmbaHYxJ3ED/zAlYMgqmF/JWm3tYIYYovbvfqL5x67RlcE+xq8PaRG91GLYVXPH6CtmSLgCxeO/Ntqn8NnBHa+EWMlqhYyIjxE0Ta4N1SaAbr+trX9kSLTofRjrZXVZQm0aRiei1TQCaF3oHaneH5+5e8ZLAMPHbcFobFHwVzl4XlVDELw1DRAPDeFHv/pJ2mD3IPlIt0pI6C/aUZ/exQ2OTyQl0/Oo0r0Bb2WT/MlyUDYLwWZ+i5l7Qutvn6td35u7gDS+ez6gRCJ7TMzREE3KZ+Z+G6A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(18002099003)(6133799003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DtbQjluQ0ybkLUyJOfPZnC1yW9zH1JZXbTDmZ+q2RDauRVKyBGdEwfLjsRjUe/QbkVBTYISdS8yg3hO0pExCgK0KOMYQKfi9Q86yPvL1BDlWUkTNuEa+Wn+wBfxUL7Wpu04EHICsAOj4M9plW0751O3Jqu87MCEbst8WdCvYvGHiXrum7bczpZmn43FtRmTzVLFrbHIjaUNDsvr02P8LWO9KTGBiQLIxtuI8BRrnRkBzOHQJCnZCMqaYSe1fgpP4jZUlqu0K6WXnruVKdViRe/06yVm+DTL7JTMsXU7LDiaSy5BAwHESOROqUZci2AjMmUxJE/440ilEzfGUmZLreSZV4jaib0xCcUQbKUW/aJt3pw0UDHT/x2gYh5mEJRFmX5PBYUm1+9ouAWKB8+0C7BKaQGqIrASWiwQYAoOj9Lm8mOF4Xz9W1771LXQr5ARg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:23:07.2116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7593c221-f528-4865-7566-08dee88b3e1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8750

Hi,

This series by Nimrod extends the mlx5 internal DMA pool infrastructure
to doorbell objects.

Doorbell allocations currently use a separate pgdir allocator. Moving
them to the common mlx5 DMA pool implementation keeps the same coherent
DMA allocation model while sharing the pool code used by mlx5_frag_buf.

The series first creates per-node doorbell pools, then switches doorbell
allocation to use them, and finally exposes their usage through debugfs.

Regards,
Tariq

Nimrod Oren (3):
  net/mlx5: initialize doorbell dma pools
  net/mlx5: allocate doorbells from dma pools
  net/mlx5: add debugfs stats for doorbell dma pools

 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 142 ++++++++----------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  11 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/driver.h                   |   8 +-
 4 files changed, 79 insertions(+), 84 deletions(-)


base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

