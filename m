Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011059.outbound.protection.outlook.com [40.93.194.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B813AB28D;
	Tue,  6 Oct 2026 11:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285893; cv=fail; b=lpWF35D6wtxmaTvd5vutMbyttGiwjgia7HpQbcpiP0svJt1+21RdipvZwxDfr1JJhFwYg0kxw4ts1W6bndJ/NR4DF+qzi4qexkDt3ry9gTQJGk6UgQ3sXJDdfJsTifdSMb8uKyeMe9CwjNRJKDgjuMObkGsUC4bRGB3Qp8uvBJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285893; c=relaxed/simple;
	bh=u9M/053LOtMBXeLbblWSAmARlYZh1J/nz9Lber6N6JU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=etE75uyjL46WmM894XMVva72CYeGIT4CI1euDshn50UIzGdy+hT60qThI/ij0c4IP+XE4VTEAZ+CwhUymy0zF/teAxExaqV0rUd75M0P+yiOHLGP0a1ZjmFdRxQZz4lOrsCOo4j9IU8TlBHU/HirEHJFyL3yZQb71Y3VgangfpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Aw6m5u16; arc=fail smtp.client-ip=40.93.194.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Aw6m5u16"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unAj/6IgM40VqVbP7d7282cklcZfXtYYTEjGTCpFd9fdtpkSAoguKyVLAy2Q3EoZyf4VNXKavQS5IQzx+j0rDms1xUp7vP4qjDevEpOas/6pqpNWHpg/To55ikQyr4w50OUri06EzXF4s0LL3NbELWBqE+yqPP+2Spf/aCO09bbf8IcMZSI4BnD5ZlBhCaWYlz66sFRfYIPrKRrPkR98j4eOfcpbrvsIZzwp8Fhtwn7C09+0M9NT9aMkz0tVKWFw9xPkgIypKr/B7qKzIYnqAwB9ea0SgVAuTN2Ji/fpVePGPey7RQ4UIyTW7++1K7Z/a5+i0i1Lc/VTzhjHgwd4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PggzhCewVSlVEzJvcpo9KqlJyrvfOeG096iBp1NkF8k=;
 b=H2S/Y2nZAP3tgoN6LVEvcJJDlWFZ+G8jnVREC5X8lujcrrHlvtxOZAaHTV7871x2e3lh06e9NDUz8+JiETjf2wVhitfXWjq9GT2qtLWERUEwWMwIjA9wZ37wu+yNssxKZAQXkqmr09EdbeUidJMBaLg94DP6F+6OIdwpbqJwrq1eiougP94uiPuORhmBlPIz6zwH0Np7745O8OiVA5z+WlMB59Rk03yn5rNgq5FJcJ2reALlFepK6uNgqN/w9dFEacV7TaC3YEPGXaia4J/Vb/z3WIngVwVNa0L29mEjXrJL2abdEuF4l7Qp+WhB3G8Wj6BfH4OVw7J5DnO7WqMtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PggzhCewVSlVEzJvcpo9KqlJyrvfOeG096iBp1NkF8k=;
 b=Aw6m5u16Z3n3P0JgDe4rzd2esykZt0AW7MZ2XSAnPxpNszdmFy0aZprFZFc69U9PovmU/ugaXe8dkZWtd7hFM4twb72vhwhsH+vz0AjtOygjIJ9dQqJpS3dyBWlf/BlKtRDUqnk99ZRI379XFvvfcFDYufMHmQNJJRJCRXBwqOiopQfkD2OiRpCyuEqdsDkguVjhH2TZlScZVixIovg7xdS+0hdaRrWUxbqRHQC7RwFHAM33/p3Mn/ikehXUyHqxEX8e1iRlLz1uYKV7A5aP4xS267pRaG3lztuxmWqHhmaTHEiWJBUTI8bTUH6A0vohcz8aVoiHNcgQrrJKc9H+Zw==
Received: from CH0PR03CA0260.namprd03.prod.outlook.com (2603:10b6:610:e5::25)
 by PH7PR12MB6538.namprd12.prod.outlook.com (2603:10b6:510:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 6 Oct
 2026 11:24:44 +0000
Received: from DM3PEPF000265AF.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::a5) by CH0PR03CA0260.outlook.office365.com
 (2603:10b6:610:e5::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 11:24:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265AF.mail.protection.outlook.com (10.167.23.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 11:24:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 04:24:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 04:24:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 6 Oct 2026 04:24:25 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Kees
 Cook" <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
Date: Tue, 6 Oct 2026 14:24:15 +0300
Message-ID: <20261006112415.259157-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265AF:EE_|PH7PR12MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: d2095bab-0be8-469e-bace-08df239c6be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|7416014|82310400026|376014|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZSFTPBfw8XKUpb/l0uufnx0/0r/CcbVo084sIGLPnA0YkwznmLZghy4X8jGlENN05x4nukhoMNZvm6aLlNWpBiUZUoIVeZNj+oVe4YaXGxQE3m3rNjVhZAQgyu4F0xh1Z4sUlih/Vi32zcd1iOre719qsxyf/kDsau/37v6+4B+mUZrfG0wNQN3sARb4c616ov8wkYYDxUh4L4gnC4W4JZj6qKwvmgb+MooIIBvGJZGXQKe6/4xH+kvOoDce86mIibsrF0N9alvo+yj+ubwi+7x6l1vkgwnLzICZz5U29n0AtbFwglUhxa3hgwQhPSVmO/JUIPLfN8YCwj4Wq8jIPkJYPdw2UqikIQ1m6AbHXqBbsKuwitbuhT6UazCZXSpFDE+0VHohL8okZodkUIkLifdJX2d+rg+OO9deIIeNfKYea9mWo+AYnIWVs73yfywiHhwUg3F/1WmR2RkDsTb6WBe5d/DXkJmn5/xk2rpbquUQT2uAyvi3flGDlQg5t8te1By78HKPgrr3HEw8azujA/GGctFtmnzq2I9sjNfuneUaIMuKyKN136+xfCfAt4aYl8g3EXP0d25KsR98gUO7CsaqaK42RnHkjmzpbysG5vaGwpwyMTVOJ5j+wUir0K6SAf887lI7wxoQ/Ie3/Xa5foq8xQISa/+WB4N5Sxzb4yB+Bjb+LWWqoL3kU1oYmBI1qKFg3uTuGqRvk6z/AkE+tA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(7416014)(82310400026)(376014)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BG2+WngydA//ELfyXAFD5Ye8q7MHvMi1pUMLHmgdLmqgBNUv65XlUPkK0cnLOaJ6dtPhMJTP0pRTAb1YLu99IQUW7E+YsGZut2tTsRIo4cHKwuFGYoMM1RVkvW34pfEr+fIpY52EFa9JJvbdSrHHejJtMYTxdS8j6+QmaDLYeRzXhn7XDATeIR3+8bW6EZIoW8gKmPdPfUOykh10FdWtBiIAJcV2vmOFpRvbJII0RWcoVx3Ww7+3gJyqs+Nihq5MoYgAzTlMAMtlrIz2UNR8XTE8akM7SaFiiTKL8AW1IHxw6eR2V2vZBhDaIF7U6OK8PNA8L6A6y6qcWtufCyXCnLaBbbVihVNLQY+PWx09znbULN7kruLUBTgeTWlmMQUpt1hH6hps0Uvio6f1LjHIK2yUiUJ6varRjdAwkofF/QOyGvu9MkXZb3AH2zvcGweH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 11:24:44.0374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2095bab-0be8-469e-bace-08df239c6be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265AF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6538

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5_lag_disable_mpesw() never called mlx5_lag_reset_vports_speed(),
unlike regular LAG teardown in mlx5_do_bond(), leaving stale cached and
FW-configured speeds after MPESW is torn down.

Call it from mlx5_lag_disable_mpesw() as well, so the reset is paired
with mlx5_lag_set_vports_agg_speed() on the MPESW path too.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index abf72026c751..e0a57b7dd82e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -157,6 +157,7 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 	if (ldev->mode != MLX5_LAG_MODE_MPESW)
 		return;
 
+	mlx5_lag_reset_vports_speed(ldev);
 	mlx5_mpesw_metadata_cleanup(ldev);
 	mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
 	if (mlx5_lag_has_sd_group(ldev))

base-commit: d5a007b9b457c915ab1a53227e8939e4018aa97a
-- 
2.44.0

