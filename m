Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010060.outbound.protection.outlook.com [52.101.61.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F2E403AE6;
	Mon,  3 Aug 2026 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763578; cv=fail; b=RV38BzxJUdVvbaC5t9O+uCCaeJgb9t7KaNwuVgXJNarmkaK9IgVXJCXguI8POk/+f8sfGbfNni2Fh/rrrwpgYVO18Z3JXmoXDuwQecLlUeBpD+CUAs+4zHje/50JmXbiSotIQe3VK5NIjoIqkbxTC03o04u5A+cl0n+BDovc+ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763578; c=relaxed/simple;
	bh=RbZAmq11lMfptBep6Iof4585bH64D/dY3csPA/ec2BI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JCLt/N4bAPcE7vKJfnJH4qOdODkmK9I8VfVeG0AfmTKbN6J8DCHSmY54Z2QY4u5xm92kZyLXk7QqPzuKQzajQkwHVLVBlekSsPTGTVKWJ46lbtZScHdqw3TbEF2z8irAIyO3Y9YuCOP3IxBN+lghPMx/RijKJ0L8BbSs2ZkI55I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uqzfwjw6; arc=fail smtp.client-ip=52.101.61.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uqzfwjw6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UdfpZ6YzoKOgv5C+CzVNvzy+ikUZUDSZWQu5V94PssmnDfcjd8Ubq00rDNuSZrDH8oRG7ZoHDH32Fi14D4ms3atTwCBzeZ1DApO4NaSqLWpg3MRPRRvdD4rjA87AgX+BiZPBEp72MPnhKdfvZSwZuswkaNwX7swhibQ0TFugiZWfMhrwFExEc2ofNJLHmxfRyOPeNXhG1qZ7jU8/sddhMMIns1PQ7+Mimx9UiUO9NN3qH28HHyFhSnVF/hvgHkCQSaUwMQxoNXp8q3ZLGiEbrFX1Q9V8CGdF8r5uPGKzA4huE2fxxHRQrORrxp6COhBtAtu59wGsjeWQuz+Pt2s+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/SzXuF87TrcLwdKQHvWpvA1vqI8LGaP1fgGnV9xFZY=;
 b=IAonPF5PQKeRbaQbLhICqz2MG8TgGrDSlfW3doOOtG0/RAvm58fSo0dazrHzq809aAQuWtL3+6J4RSNZAihabB+wS0elvf0yaRDng5w/PeBzF6MVu+ZLw5f2LaHRvj0lNISegdImhkDUbyphncSJ0nwQNdeSwFiqRBqjHd3ALdZ6jhncZ+RuQgf8YB3HcjK6Tsno7os4mBHqsstZZAS7eaOuHuGDvLhoNtbfGBQoBxwB9gv8poq/PLq+tWkSlB+Z+t06omkH7vHOy7vHLX7sCt4Cuv9W7/XexfCzu5YQQizJEQzRPU8MzmKrXTIeQRlFtQflLtSVsYd9DmNyhqWrng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/SzXuF87TrcLwdKQHvWpvA1vqI8LGaP1fgGnV9xFZY=;
 b=Uqzfwjw6H+jWvYOMXAbd4cHFpCsEq4eZMhtHbN6kmVrTuJFluWJHavGP8WuO3CzkvIN8tO5S6CAiht8SC8SQ04RCD4Zp6jAQw4YKGVhxXURQ6MoQ3KhAQlkxiwnvBG7DLxwCMZblzVQDvtokjOBCE97IkNDSO0e26zs18tqp7P7eYETqVwxeBjkkvXcYNOogoC+sV+hc33KA2UaWmykwumbyiTNX/M5hg0O+lclO4zmbJ0urHxoPeQt9+U52oe46sRzzD7RIRyhUKjF4qG6o6/D/QJIo5MEiamWuENSnC6eej4KplNuNBNlpJJGKAEuguJ0fQJPrV6YQ9XA/RqHHDQ==
Received: from BLAPR05CA0040.namprd05.prod.outlook.com (2603:10b6:208:335::21)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 13:26:05 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:335:cafe::68) by BLAPR05CA0040.outlook.office365.com
 (2603:10b6:208:335::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.14 via Frontend Transport; Mon, 3
 Aug 2026 13:26:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Mon, 3 Aug 2026 13:26:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 3 Aug
 2026 06:25:49 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 3 Aug 2026 06:25:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 3 Aug 2026 06:25:46 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 0/3] net/mlx5: allocate doorbells from dma pools
Date: Mon, 3 Aug 2026 16:25:17 +0300
Message-ID: <20260803132520.2891860-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 93fa872c-3430-4156-2001-08def162c4ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|18002099003|6133799003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	reaM64hmJjLWicthnyELH7pXHcoFoC7QDXiDcho4EmMYgmFbgJG2EAfiuVyKZR5BXPfujIIA87JdbSiqfg0CCy5j+GuCdI9Xx2RFHXtyk2zznekPqQ1vKI7+50nbh+tSX/UVVBSs9DvSgLONkGE5Ok+dp5Dt3/CCBaIE8PFzSghx76cSNtBOq7sEPS7aCY7qWXxncoOCfaqruUCoAcdxxpZjkHFA1EoeQHbi2o6hu9FhpTqtuDoF1agB5bBZ7ouauhlhzKqKGkakVKqm8Xne+u5Ebeq7BQFWEEZIMA5PS0VEGEFIfkQr80jziPZEE7ahCCjYnBiLetc9aDRcSFK/zy4UtW13LZyoFD4RVxqvsaOFIxkDqhu3UQm7bgPert1LSv5tcSxwZ36gWYjfdqjCnIDPPkvQXmUCGpE2UScI0dZyer8eAtuGYWzEpr0sQoAhWSlvQxX3ixujzMh9HaumFgQyB3AKXfwXnLi10IcdNm+J5S2Tcgu9+gdtIGGA0mf64pAhpzGfGC/T4WqzRjFNy1Uq27wlXnlciOEnYljl+H5soNU2SD37L8vwReamv4Su+FaBcucPs3Mz2RF6nSG1ulajugEiQZBpAd9j8u1oneN/hain0VSbpG5cWXweiqzdYBLNxO9o0VvXleaVc91ndln/r7P9KnkKP1xRrsCptY6jqo9zJpriZPoWyYQbb2pkH7jGHmD5A3kmkhA1UrI/xg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(18002099003)(6133799003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KAx7UlkXYNOEbHxo5eIk+mQQawZVC8oOomVdjM47hX1KWU8kzOGA0jIxaybsGd4UiDAPna+AzoG0PBOgN/4BaCAEuxOOfiH+u5VCuuwVuMMtbgEBdnJeNPf4o9oR8XknhygVUCejpbR2ZrnrKUO8yuuyxNIry9IIN+2W5foM6/cFbHtHcJlwjbjoEU1Z4uUbmrWeSefYhY8Ocad+Ffv95HNrmhVasuBtH31KWt8B+fFMbwXkrE34Ypyt3reeV4Jc77d0sKxC5rWttZI03i4dA1wcuqKzpeVDQ4fAU3yx+5VY1vKa9nxUiHElcXJX425uVhVuFnufHwCeyQ8/h7jQUpotWnL563LApEkdeQ3lJHRSLPoqE5CwoYkF3+34P0PLppbidYd/B6rOKBs6maTpUHSka/wwM0cyRhcJ9rRQOdWURNR1Mj20ZYQ7DAUK6v9e
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:26:04.4249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fa872c-3430-4156-2001-08def162c4ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

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

V2:
- Dropped defensive check in patch 3 (Leon).

Nimrod Oren (3):
  net/mlx5: initialize doorbell dma pools
  net/mlx5: allocate doorbells from dma pools
  net/mlx5: add debugfs stats for doorbell dma pools

 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 139 ++++++++----------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  11 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/driver.h                   |   8 +-
 4 files changed, 76 insertions(+), 84 deletions(-)


base-commit: 69963a0678a347d57c4ac8b16939dba216eb95ce
-- 
2.44.0

