Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010030.outbound.protection.outlook.com [52.101.85.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6233E36A;
	Sun, 16 Aug 2026 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890104; cv=fail; b=AFYGm3rF69DJR2hM0u7++umRz1vCCXrVECk37kQn1NKbpTpfES4wcMbKWCOrNr012N92Ie//VprA3iHtoyEmbFkZ+TfTxxS+tQZKJhl//5CxM0Ilk9cWtgTyyPA/Psjf9t9B1Bqqei329B3RPkj+M8MbApgRcnQ2BrsbGMDoZUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890104; c=relaxed/simple;
	bh=Oae45WZrDulG6LPQimjkx4Vq0xSfKRNDyWF/9k3u1m4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUCVcF85UozlgLgxdj3Zmg9FZMte8QRvykbjLNFavvlc8tsQiG4wUQGkfpWNY1siyFK26DkKb7VPxqpauKnsWE0EZo3oMYeCy69amXmjIoLHKTW8s2kRipql+vgtmhdw4REtVgHQZDvZmGLZHpszOf1TR5cN9xd9DN732U57lEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fo7LA7MN; arc=fail smtp.client-ip=52.101.85.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fo7LA7MN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URnUs8QuUf0URqCVBxpCCwPAqQSEUTT/RMo+Iyn+r36HWYAY/ZxiY4Uur5PzeBcY6DV3M7XM8q/db9CsJNIQos2A66p5Ngi7wW+x3/GFFZ9OoGlKfn2ZIhw122vKuUSGMzUxRR384noE0vhTqFKCtT7BbKUkJLX1bDKo/IBpGX6X3n3vWScWSTkxl+vSIjdFzsNCz5hnjK4HYAYZQcSuVMUV3OLc2YGHXbw6bFdFxZ7UuXf/uBrWNKmWkj/mw8kVwy2PdB2bfj0HT9FZuclNYJmvzetK6PDWtGaX4bxfNNUWiYHj2/PggRfWKtf61akfHXNpNzPSu8kvBB8BVHo3Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Avbxoj4msPmpU72pq89HoJIublgsoOiA8HZqD4RaxAo=;
 b=UzZfuvEPJnoSTEpC02faFG4ZjD4YI/TTpk8a+xIzYUtaC9qp0StvZBnzBUa6LEyBbnx4vkIhHZw9ac5IDYxEBscdiuIasRWrSPjieYg4EU7nqzmou6URaTGEmcEJYFwbPtqiiazNSuiYVVNgPL6VMsU7tKqY1NnT2bh7hJ/8r4WCudYlOfQlctq+tiXOece1JqdwcaVz6YfEMuQRAjN9sf2VxvEDhZCQ32ADiCTvveMovZuGSum//XKsxhoylxOI6CEDGlseTnHQ8l229BP45HazhsgHHSdPfgIaj+GveS42jLCQEuehNUXMm1EDw1+a0cwbDZqZgwIXuByOcYW5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Avbxoj4msPmpU72pq89HoJIublgsoOiA8HZqD4RaxAo=;
 b=Fo7LA7MNO4BN8WilJo6ELTkuD1yHSKU9XwKqWhabVo66fMeQga2hN/dLakLzE8+n3x2ZZLkg7KqGonxRt+tFWom+E6Y5sVXbsxw9+RKgtZgg87lEGZEhSV6FYr9+iCkjFvQs6zVZh29seKMc88mAf/AYsXWtMey15foISvBeItJroJcl64/u0lIKhDsH14ehbVyZ2A2UIGC1ghA7BwI74VIJF1JyFFtO6j/+i4ZwHKlyBtRU8F+C1iUd6lOLlyPcgCJYXHfyZZ1s21vO2SA+eImqZWReou/aR1PydquoQ/upTLH4yuQuwWqrAhdWSw/J33cyyEqei4WVZbBMU29KJg==
Received: from DS7PR03CA0131.namprd03.prod.outlook.com (2603:10b6:5:3b4::16)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 14:21:37 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:5:3b4:cafe::73) by DS7PR03CA0131.outlook.office365.com
 (2603:10b6:5:3b4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 14:21:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:24 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 16 Aug
 2026 07:21:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:21:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alex Vesker <valex@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Erez
 Shitrit" <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V3 3/5] net/mlx5: HWS, Set the num of queues only when alloc succeeded
Date: Sun, 16 Aug 2026 17:20:43 +0300
Message-ID: <20260816142045.3289452-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260816142045.3289452-1-tariqt@nvidia.com>
References: <20260816142045.3289452-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|CH2PR12MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: 836e65e0-bffa-4618-7e96-08defba1add8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	8ZfSbU4aE2UUenDUoWdhbRf9YHO+YANOhLofM5ft7lWHgbkIS8oxHc27HkFbRUhlTBWSxhnY2Gk1g7sR0y4jRsYEB3oMTg0SqvCuZwM8125rXFDEjN12UvBBypdkLIry6TzNh1cHmcm9tl7GLMCsboUNr/mTGS/7fwDdysxBM8+BmmDRUUNIbCz8DVhINAlzGX7PdoKYhB1jFOqB6fG/tnVyxdvIAoL55j1pndJiI1sv/+bKua3dWkZvEMjBhT5BhaH5ItJuZjjhC364GJ/HDyLdpaduyobGfzfHtLWVygv6cCSWLt/vXGnSdj+Czt+F2mEmqdqwQ5SaIDqQThwtieJHosUvFXbby99LWL5TFocjnvwkhzYoOCEjkIrG4hmu2ZwyJgCbsZUeViYdChbp5YTTM5r8eVjoBe9ddpzhQd8c4/QfY1rx0/P1mWcvhYxZQClSpNiqpXay3sLgNZ54Wq9TSvIExFDnvqJAYS1N/g5DxIizKMy3UhgtHyYs5ohRznfpnTT0J24wPIt/dB8DNjLzOeuzKxX/jaf5wIPCPqzfG1Mnnba2CCs9L4EEzdjKb+vS0LXtg4yuf/Z1zKQj9qfaTPo4QWjRCvnUms171cagxJEewsOFkDKrU8JvRa+5hbuaHUtY2W+wm3Oi7GcqowywgvWct0qPSD90U/CI9Ph4pia8lNe5NdS72f+av3LyYaXFPA5y/CewzS9vN3cZ/Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wPvr3Z9Mp+hOmKTynkqrSwJDKVahb/yAjD47oNqVRVsoGHpSwwluQWBMsl/IPChQF1CBCxZQEbMF2uiY0hsrycS3KNICNDf4oZU6mo205MdIkykr088mLBNy0H/Y98XV6NDEh62MIl5Zv1tV2hv7g7w01fTJ3OUIB3v59ygZJPKlfB83lpi8zdRGGg9Xbwvhm6Zy/sYGyFuakzM/Nvz8H34QqwLIHP8XIqFXakaC6PRYjlzT7knp5v/5AJ+6kCW6hjn4+EIFzHr9eP1IUAbu72bzoHt6IRCC5NV5TLqRIdQzsmcLmpB1QAPoH2kBN07qQ8fbgICkvUzeL4d9mXY6VMh2yaz2bX6gU1+x0DuYW/uuZeT/bs9R52qAPRN12VEz9Sg2Gcaojv2N384RxztI0+GzUFkWL3K/ZWXDJ+ZGrwfOoodpgPbZym7jtwgS1x53
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:35.6715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 836e65e0-bffa-4618-7e96-08defba1add8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When initializing send queues, set the number of queues only
when allocations are over.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 6612e58c896a..df3b93499eeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1116,8 +1116,6 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!mlx5hws_context_bwc_supported(ctx))
 		return 0;
 
-	ctx->queues += bwc_queues;
-
 	ctx->bwc_send_queue_locks = kzalloc_objs(*ctx->bwc_send_queue_locks,
 						 bwc_queues);
 
@@ -1129,6 +1127,8 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!ctx->bwc_lock_class_keys)
 		goto err_lock_class_keys;
 
+	ctx->queues += bwc_queues;
+
 	for (i = 0; i < bwc_queues; i++) {
 		mutex_init(&ctx->bwc_send_queue_locks[i]);
 		lockdep_register_key(ctx->bwc_lock_class_keys + i);
-- 
2.44.0

