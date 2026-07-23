Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F315B18D636;
	Thu, 23 Jul 2026 09:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800474; cv=fail; b=VAcIpl8jGQCltS0IZ6sph9NqTtgMsmC2vdPeMmOiKHg4wpSuK982LqQeYDl+6jhYyT5pLo1VjQII8SYmFRQ5wV8U9eoe+OGGoCjhwQgSFy0iYYvF7F9ixc2T8IfqAEewnBwz1dEIZgON4bN9xC2v0ptfOZWeTuukpdUmkUYNudY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800474; c=relaxed/simple;
	bh=MPWppvU7/Q+VZjakggjpMpe72+Th9iWjN68dXIJCH3M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bm+x6vAyoT3i3LXEgHCL3s7Qetj/uN+iJbJTBXm28EiZ2fIFOy6/RCv2ctOUKhPQeaLdeRskr2mry4S1+HnuCIUGS+t36yHF9LnuUCFGtl8X7xs2IWoeQsbFO/Zg6zCPvHlJLzbKB6DAAO9jj7dXnoc7mEKOwo3l5AeSg74WlC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mWKdHKNy; arc=fail smtp.client-ip=40.93.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mWKdHKNy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oLb6ZrxxSOG7aqIpMdY2XGAMQ8O3aHEQtPzE2LrJ9Su3NxxYWQzACMV7tV67BVkGaIxgsaLCwODG/IChMLRVsMC8NMvJPP7i8bjNf8BzIMrZdAj/YmNAuN9nGX/DyBzLzZ+DKQoFQiYTHM+E5IzXHOALygruCRl36+pM+UAizKDKJu7H0OPA3WHKztah0cTx9KHejzDM99KO3j88Cz8MRP6O+8G7TE7U/NIXaXtioaZo5bUR0AN9gfFTyJ114FDAsSCR/Ipd5SxVUPmD5+++w3ialYZjNXMlPzP5Bvt4ykLYyZs55NN9PtAXgtZuA+l89kl7KmdyppwbiHvF9jFuEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=or2fAtZ6XOmYgIK9BbTAp/74W/opCNK2yn7eznoPS/E=;
 b=HycUj0nfv58wZsy5ZxS7fZDPXQPIFfG3+a+b+c+fse03WC7hVC7XlRb20bhzXRT7myb951x6AsS6grrCXMr5UsMcYa0K66iBVv50TG/mgZaDCPB2NWk+YLmDUN5pY7phfPBsO5k6ti58QfoKyuiCdHPdAQBfi/HDUY221CwUyxylX5UvnOZ3IRYfy8eLNaVj5ITUdSUoSBahi/+YCc/oXEUdVR22ljIXBMgrTg7jpDEC+BAREK6z1SyARbi1a8pvi2Y5u8MSBpJR4TU8oelXugWrJl0MR0TVwBMhh2WSFiVKYfLa8hXQqmPnmCW2DiP1RGpy1YO81+qQEJJtOQ4e3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=or2fAtZ6XOmYgIK9BbTAp/74W/opCNK2yn7eznoPS/E=;
 b=mWKdHKNySP/4evUvjIL5yTT+LsUZ7HcI7mnIRuBTzjvk2rTfyMKYGcNIeFBE9zkPX13i8oZ8QOtcJrw2QX31qNvfjAp/u8TuOwrmU6d4a5rjRWzv/V14av+sw6MWAec/pvH6dfy+mArenYhbDN794Vz1AdWELO8Bask/x+GSxHkpDDPm8vycmersw9QzRuS+W3kS2fQmICeAHSEtRqzDLnqg1Tjz67jzSUb0ExZyeTe/VveCOYmW3XOXllQ1073SG6oh0/CGMyTr+2QKN4J4Bmdect3OcR3+L8zdxkOjDfGGpD7an6mShxQukPYiFoERyrK0OoEh7pBnFqPJuTNnXg==
Received: from MN2PR06CA0005.namprd06.prod.outlook.com (2603:10b6:208:23d::10)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 09:54:27 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::1d) by MN2PR06CA0005.outlook.office365.com
 (2603:10b6:208:23d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 09:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:54:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:14 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:07 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 0/5] net/mlx5: HWS misc enhancements
Date: Thu, 23 Jul 2026 12:53:44 +0300
Message-ID: <20260723095349.1890983-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: c5769525-cc71-4482-f3ae-08dee8a0625f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|7416014|36860700016|376014|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Gj/B8/PTbfD+gBrntBBLT836H7pQJ80d+jpNVH7XSYpBLM+w9OUC5OxaBpm0nr8WGDjdldd6b2eobFtz1M3qifEAUV8HOAGebWHtTEneLVyuySXehxdRti1dm2Cuvg8txJVko77QLSlc1i/VjRHu81AYW3urG10Q0YixOeh/0QBnNMTiCjH0MW+ZFCZWSC4hrONjBh9DCaWtR1SNccrGbA/o3v6fLuuEzFHeCit9H12WI0MxsqblJTZBMNp97VRhDrHQ52Hbivo2dd9zUCnlq+7mhLp1qEUrXTUesQNymdRkFTpsr4xJoqZ2SrCDZNdcshT/irg/IDJ8O3GSFfVDW5xoF6Gclm8IrfBzhjOrbK4GIOJUcTtGKrxpM51b3ZY1K/nq/E3ZFlWu0wjJraVN6lARc96Fhtv2SNwUqZ41zpLy4Qwm9qaDJq/5L2+EmLc2yM2sHZgU/mHfFv9OdIY3pnYg06Cs3OI6IUaVX+9hk4HKl9WqW1H/8iCoTYebf3jfQE9q8mRPHsbz+uv+1AG91vO1/z8oDGnkTNiWsKNR8kZQSTda+IMXxwSTvrdU9wOOFhtPdDXG8FZmwGVIdTcI6fc4gvdvoEU5AK5VorTwiDCdD6EF14sZxhLUod02+OO3gbO1ATZw/yIYN3dagc8/qjNciznbEdWWCJw57EU71in7vM7BB71kGPQMmpCq+KEfXfW4TDQDfRtQk/K+QWQD/g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(7416014)(36860700016)(376014)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	62aDxLOHj4wx3A+7zc2bHDoZZzesoVoEgng+enxzRZGpkq8j6B84lb7zQw3vZHP7vIG3SC0yEFaEZSrVZyOrNeiZHsdvuBWlIu2ksFbsRHp0Yr2ZU/IwLUU7GyT2bcVVdh3GPJTKelZo9dh8BC4MG+YTIgfSVY12XMaqsssVW4tbEUtSGRMh/p8Y7SobzuA7yYvV0TXT9ZYdz3wMFrqV127ds7KauEmP3wKXAARBpoqmd9PnHJGftH8j2eJZzB2Gl6RtaK0RgKeZblQTEZtp3BcdVKmdHKQj/nLTOBvfWWaeQ15+5fKRYXv+8JbAJkdYJh/VyKUqa3Ts4Bn1CTKXVvArog4jdWV78bEiuQH11G5WZPwoI/jKCjWsrfc0SnqyBmd6JB8ZFDQYTxmgk69tCnMjzA2fd1t09ya9j6m8GP/FfBkTeDpG5xmVDbufHhWl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:54:27.4180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5769525-cc71-4482-f3ae-08dee8a0625f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192

Hi,

This series by Yevgeny brings several misc improvements to the mlx5 HWS
driver.

Regards,
Tariq

Yevgeny Kliteynik (5):
  net/mlx5: HWS, Print more details for bad completion
  net/mlx5: HWS, Log syndrome on STC modify failure
  net/mlx5: HWS, Set the num of queues only when alloc succeeded
  net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
  net/mlx5: HWS, Remove redundant FW command when reading caps

 .../mellanox/mlx5/core/steering/hws/cmd.c     | 15 ++--
 .../mellanox/mlx5/core/steering/hws/send.c    | 72 +++++++++++++------
 2 files changed, 56 insertions(+), 31 deletions(-)


base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

