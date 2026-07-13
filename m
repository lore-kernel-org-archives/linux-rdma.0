Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012000.outbound.protection.outlook.com [52.101.43.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581D3BD638;
	Mon, 13 Jul 2026 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932277; cv=fail; b=LqS4cNTvT9RwPZ7R0lTggN7ATplP48k3fgy3oUJebT48DmRyy2q/DYGmimmvE78RIkGzoxt/WYO6UsLS5gKQ8mVeqhf+V/7BcDftYlbHnJYDLV3EAeKIDABB65UZKSUku5pEbj8jOfCE24TVgNygnt+asadsFy+A6Z2uEIwEl+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932277; c=relaxed/simple;
	bh=AGrLFb3LWWznt3NC302vpp97OpEyP85pMd/jAjN+MPM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sMdcIWeKJL6JGG/iECbxOlUhwQwT8BT8rfJzcudoTW+pxzZWpMtKD5/KtTE5Nvt6HvVtDxX654pqoap61YMdzAR24o6Wxm+dy2eKaREcCdig7eZJ7j4TTxCfakCjylXDaEEJzaUwKF8sjoEZ7T9OYHPLaTN3WLZNvcgz6x7Iq/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NBPEm8Ub; arc=fail smtp.client-ip=52.101.43.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NBPEm8Ub"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOZTm0/yg1M+NB/FLsHkuZSsl1XXssCiIaRENzO0l+KU3+/NMTYyGIq65+Jlvg34PFmn9Enp6v+BeIAXVpHHIHIfQxE1bQq6aNalYZmUws9EG7d62Ek9jsYjrJ+pk3NByetW4d4+ZKz2g+4NbbllNXX0ECMiK7exhMuWw0U0f85K2ckrytMUjxDimRyXvckaF1SJYkINUuPVcMdsbY6UO/NeO3Emj0+r/LWzLuYKzBhNSMs8aKiwT9TeN0dnuC4AfyMhfA7JWAzgmPZkFEYTiRDqM81LlErVa7R1TGbAbhGS8oS2FXoJwey3WRn/cVEn6py4YRKEel09diLO8Nu0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YP7j4W+PcRlWV9513DgYu+HzQFCSsUzwRpkWBvLYH2E=;
 b=CQK19QGPQGKpNrqi0YEL1aTZsX5NMPL5UDhHngWFIkiTxzYOW9lMNT5PvY2e9LXUjHt/571TQdmFIoRwNoqboGwpD747jwLlEUJtJ8wG9MsjuJrk3RRqDoM+PSsbE6WB8lFD8YbvCjb/EtyoreBSvGoN4wFFN2wY9X6wal0XfdLrzAIk39jje2Gwx6WmV0FwGuv6hVdzVXM6/piDR8Qz6hWAzSgitoASgJGB6E9ZElWnwWMk1tIHb5bK8RcaPchpEgS1CltyWftZUh2PsE6v64u0ttltYh6naE222eZULtDQtKBG2hKWAUaAiGCWE5bF/IwuYZwGPu0CKuLbGMis4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YP7j4W+PcRlWV9513DgYu+HzQFCSsUzwRpkWBvLYH2E=;
 b=NBPEm8UbR9YEHrfZU0GERv173G590OSLadTokpZgdKWP7Jtt8Hr6ZHlWA4DECu92rrsaqz7rqvrnHQdk8gu9HWPNN5BqV6vnBN9QjPyRrtd5fY/9gbPmNJTkbOQ6VfdxxIvN3PVTeOOaN7n8J0vw+n8CcUDrgX2q1fmvskFwXvsDeosIYyrn8pVgGa0zgfIm/y/+Ou6Xv6OMv6uot/kyNHd7Z0tIJCh7xy01BaDgU5XAkgw9SEPLqy5K8rb4yRBNtci8dORMi1l+J5Mqw6j04wcHCNx3bIxoSghZUPL55BA+6abXuNDnUXM+3wGCnWINAf7u8icfNbontIrbLAsYMA==
Received: from CY8PR12CA0054.namprd12.prod.outlook.com (2603:10b6:930:4c::17)
 by CH3PR12MB7716.namprd12.prod.outlook.com (2603:10b6:610:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Mon, 13 Jul
 2026 08:44:10 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:930:4c:cafe::18) by CY8PR12CA0054.outlook.office365.com
 (2603:10b6:930:4c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.20 via Frontend Transport; Mon,
 13 Jul 2026 08:44:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Mon, 13 Jul 2026 08:44:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 01:43:51 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 13 Jul
 2026 01:43:50 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 13
 Jul 2026 01:43:45 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Alexei Lazar <alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, "Andrew
 Lunn" <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>, "David S.
 Miller" <davem@davemloft.net>, Dragos Tatulea <dtatulea@nvidia.com>, "Eric
 Dumazet" <edumazet@google.com>, Feng Liu <feliu@nvidia.com>, Jakub Kicinski
	<kuba@kernel.org>, Kees Cook <kees@kernel.org>,
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Parav Pandit
	<parav@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH mlx5-next 0/2] mlx5-next updates 2026-07-13
Date: Mon, 13 Jul 2026 11:43:18 +0300
Message-ID: <20260713084320.1015240-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|CH3PR12MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: f052c4b6-989b-4b24-2e59-08dee0bae899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|23010399003|82310400026|1800799024|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Km412n9wCtjpSL9uQjWXLIK1SLmVtryJ6Quw/XGCoX1YpKUmRZ+C2s7K5Wc5bpl8UIQextcjd4/SOSGHZkoh2Cqks6W6IJsokC1GSCUFiqGODzDDABhI/Ui8Ic530ivr34dCGfJFsAaFqUPFO8ByxGW2rFhtwzQP43X2moUsLE00yDPOSlH0JfIk4ObRjeOrb0+aTqHb+28QeDZ6CrKiHFbIh8eb/nwS5gZayHEnMmBYq+va1DZhDPEjubxd5EKmOUvehFw7GvVgorFKdzJ1Ltn7a0beaWV2HkyPvHjqUESE3juRMbuPXEtaiWQuM5+CrURlrn7kuR+DUnoh3gr9vAfoX7X+3QDH/HfKRKwzxS49x5h18P375jlgBNGom+QocBP6x4RjM1UfOQca8x3Ko6oHGlqGznHcmjJFfdfPswV0kYekVSF8FesyDMKCUslrYLsRMp0RLnjZLz3TzpiSo3i23wmK/OxUNHTk0XoFcNHnXEc8rMzohPh3f1m8Jj64X0ZJxxEPGnRqHqxKYyz6HC3wk6NDzRrpkIG+dg//CoyBVb2gst6vGGT7Y3eUiHHHuEOlcxQwYSUA7v2KDw6VVcdKJ/Ea9B3Cn8vxdeygT2+FTuFSFLDZwJ7sdu7cTV3W+9b6eMp2UtUmXvpx2YkFvQ72AeRe2IlILHr4HtisdRdke2A7ghfquB4xGvvXgeg208ZpWneyZwTVG2rS8RI7+A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(23010399003)(82310400026)(1800799024)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uRxx3YR351/HaWjDiAba0aH/DGuPDKvFKI2MJuJR/6a95ANC90ihcitXuAlffvDn+hR7PpiySKQ/g7rYceg0WzWhikIm/xtmz8kjza4C/tVolD0124QQ7T7IVBj1YDXvzlYqY9pwHV8jNWyDsyi31DaqjKOkqQKfmaPr/UDF0AxwzOc+DnEezJRUldAWzJplv/AgX+6LcgWaY+ntJSYx+wzc1jvpAdqw412WUoy9Xaupf2rUsKW6KuOb27eruOI9b0ObDOQIPc5sc/UsYddizrUHvK2RFsP1w0YwiPcyAW144qE1980vXmNB3fRFfaI7xgRwrh0DF8jj5VeAXLeOTcpa+84rNkNxi7ovcojyHYMMQJxezN1CrYFNdsG3jn3neSuOU91SpcgHyiQTqj/QDmThA4VkSLk/VxKceqIbhPDsXCZq9HzQM2ZFEZTvOBNa
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 08:44:10.2613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f052c4b6-989b-4b24-2e59-08dee0bae899
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7716

Hi,

This series contains mlx5 shared updates.

Regards,
Tariq

Cosmin Ratiu (1):
  net/mlx5: ifc: Add PSP related fields

Shay Drory (1):
  net/mlx5: Drop redundant esw_cap, reuse e_switch_cap

 .../net/ethernet/mellanox/mlx5/core/fs_core.h | 12 +-----
 .../mellanox/mlx5/core/steering/hws/cmd.c     |  6 +--
 include/linux/mlx5/device.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 38 ++++++++++---------
 4 files changed, 25 insertions(+), 32 deletions(-)


base-commit: ddbddbf8aee54bee038149187270c93a45478473
-- 
2.44.0

