Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E072F2417D1;
	Sun, 16 Aug 2026 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890116; cv=fail; b=hD945KZtBTt4zltooV+s/mynDXdnJLZ8l976B512Z1rVCc6zx8sj0rCkS6mAoZjF2/IRa/HlXTQQUEN9WuPUodfvhizdbbguNhRVRj3gJnjWfyJ0yf/RS64HGg5FFGqTVg6MpK1gy3tnv394Zm1QsREcco3XnY0MnlAE3FDWVzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890116; c=relaxed/simple;
	bh=BqdBky2MpSvkGrYn8twM8y154qItT/kJtjkfI/3F3vE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xk5QB9G0tuTvNB2OSu64wQZsA/BbO8A3LkONwXGS4GxPRjzrNYfTgRuE/zgBkr+vp/CM83+UaMDyTFX2J+pQaZ5DsAcY25oqrTirXXWzY2Z89K+RcQA21IebjDuFi1C1OVJyjOoRhTd2MOwzGltsxtBeC2zQhejiVz/QY8Cwx+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DpSnQGRC; arc=fail smtp.client-ip=52.101.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DpSnQGRC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8n5xanI/7XLrlE0Cgi7THUQ9ZF78wRMMYO8KpmkBHsf70QA5y68toPAYm+ueeLMZmZ5ujPMYCyS4DZrEaSUPYxY0FrcWmyMhK4kii/ae8hhq9k/pmcYpdE7Z2P3jTfPztqScFTIp1bIye93ThqM9RTsKY+FU9by1X6+M92ej0UPThO+eoccIawZIV8rrY7TEdYmQ3Rnrq+1bikjctrEIDywOn7bK7EJJjAJ2osMpreZqvUZUrB62TshgS/ndH8xHb5UflYuxhqx+W1x/MNOGJrOVtG8BDenbMQB8yxU0puyztO+TU3TFKrECzxFGqv0wnKPhqg1ytjARTdYUxNm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waAq3pvXpaIpOkJbZrJVLU1YE3sH/BXHRAoWZqWHDQ8=;
 b=OcAr2SlkDkOd3O7pAOzPS8GshQl6JjEd3q7yqSnllWvYivdCAkTJlO5K5LXf3MLjCNWbf2mgWuI8CoJPjmVKY3fdtP6FVRwV/IeWRCUKKFhEZfuYhIbdkvP/81HRJ9+71kUlQJzfSaZ8ch6uPPOCR4GKL0SNbn9bwvz2xqtKqB5DLLhRa5/0Q9kM7v9Rg7EmJQ4dAdBWCmFsk9qRz4UU763DyzxhtBfU56cXeW7upskxRW+JWJEgZIoBv3ugKVShdY2U7cefJKUL/lQDHUztBsR1uZgb2PDtW+HdAAaTRo4y1fhGoffs5oXLhdAXbSNJiolg5EC/A+arkl13lkHvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waAq3pvXpaIpOkJbZrJVLU1YE3sH/BXHRAoWZqWHDQ8=;
 b=DpSnQGRCTGhb1UgJmihHQ07THN7kvaEzdpPlLaFlWEBl3lfFs0lSyJEoTgyUCM8Hfl0pq91RQtiziQg8zheUyONQrWLn3cMno3lLIYpznDfAE/xJWh3I9e4QxgAIk1ZvBXA2/oRwBphBzB9cOd1wq8lMMprEaXC1R1aKYmsoZmPg0M4G7TRYP3QYTRs+OKBUB3ujwIqJBzv9HMn+dudiD4M58xjFJ812w5KWqUnFK7Xr+3qpaHM9RP/Ph36qrEGIQRPOZd+iOn6dQuugx/y1mD18GJRbXokbBpZq2SnG4l1qh9DmLRnsuzeJybDYoO6D+imEkW/4HFBQ369oNO2jDg==
Received: from BN9P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::23)
 by DS7PR12MB6239.namprd12.prod.outlook.com (2603:10b6:8:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 14:21:47 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:10c:cafe::26) by BN9P222CA0018.outlook.office365.com
 (2603:10b6:408:10c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 14:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:21:25 -0700
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
Subject: [PATCH net-next V3 4/5] net/mlx5: HWS, Remove redundant MLX5_SET in RTC creation
Date: Sun, 16 Aug 2026 17:20:44 +0300
Message-ID: <20260816142045.3289452-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|DS7PR12MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 03543b20-33b1-4ae2-b094-08defba1b487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|376014|1800799024|36860700016|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	lvsZYTxrcF2/MjrNme/xnin1tFx8eMQ6Wcp6lX111/erbUF9kQXafvgipeYTHYeBq8nhsogIhr04bY4/rRXKDuBlgBcuQl+tiBnAOLtK5wO5bdV1W6CKEwqCjU7dJAGNrFpI6jdpXNP5DafGcY0kk5SO0eC06pD2Qysqu2+XLs5HkiqncYDSIv1CZ6U/eV/jUHY2nnT8x8t5JCZr+nisXUtSZnTxVl4ICD5eFzU4Tyt3zcL/rebAkW6dTAs+ama/eLepIilQxfEGYvgbPpR/02ZD6kAL8gmYI4N8zpXX6/JeWm3MoQSXe5WvN8MP90hdHzIVRK3URykKq9etGtKvYMKswdEjwGL0FE/Isuc+6EWZVWqo828Y6IKUe11be0w1sGK5X7h1Mt0znYCxbTbd/oYP/zJWEAlO9ypeWZcuGsUDtcQjfmL/LrZ/o3aTVmOcnq5E8SCupz3dhx+7AWhZgXfMHxJK66W2uU8blAlgP6nHWLHr8oZ97KSgaLbg/iZu6QXQtxeQjOLjkP7TGQibeeRsWw4JgYp49DrTcN0jU1MN+RQhs0qHFkyA0y6N7W143k7qmHo2EtG3MfmIMXAAmf/BunbGpb47G2WNPbiTZJhuShhMTAHL1mH8dUGrXdMS+p9Mwhu26jgEsw4xwpV4IpyVZ6bEr9nshLekwob+jBeceHowJXiFPwHPedt7i6mg8VKEX8LiBGq1cqL+KZqcuA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(376014)(1800799024)(36860700016)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	flMQSCZK++psD2u/PxtZSjhKa1DDTd5G+BBXyFx7Rvn142RlX7sxyXdYFHi29VNY3s0tuqlRSE9JXOycXRBenTVtKaH5TTu5huVEvkQmWELNdnpwNlEUwBZ5bxdU5JpIsg+J507MacV1hasKR470AV7z39bqbxZMYTAVIbuEwkKh4XxXZWVIYozrk+PDII2gHgSSAYUii5uljbwMiDtuyBrJ0ZGoRU2z/WAJI2PENaJCkia0UNWyrTOFuRbEaHluwMg9GqIaSJdziMUWqcIPdZojhJ6BM+V7OyL1BD0N9HEwkCzrPM7rMHH1q5YRGu+lMa4x57Z6hR97rAnlwo6pHIE/6hiiOuh6su3Xj1xPHbOVHcNZIgvZIuJWxu+KY7W7WhMNAgJXDOam5HznRrhlRn30Q4wfwvypsccCtKrCFDWqkvHJ2+Vl8OnQY/c4AySl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:46.8370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03543b20-33b1-4ae2-b094-08defba1b487
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6239

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove duplicated setting of field in mlx5hws_cmd_rtc_create().

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 2cdc03421433..3782d793550d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -398,7 +398,6 @@ int mlx5hws_cmd_rtc_create(struct mlx5_core_dev *mdev,
 	MLX5_SET(rtc, attr, update_method, rtc_attr->fw_gen_wqe);
 	MLX5_SET(rtc, attr, update_index_mode, rtc_attr->update_index_mode);
 	MLX5_SET(rtc, attr, access_index_mode, rtc_attr->access_index_mode);
-	MLX5_SET(rtc, attr, num_hash_definer, rtc_attr->num_hash_definer);
 	MLX5_SET(rtc, attr, log_depth, rtc_attr->log_depth);
 	MLX5_SET(rtc, attr, log_hash_size, rtc_attr->log_size);
 	MLX5_SET(rtc, attr, table_type, rtc_attr->table_type);
-- 
2.44.0

