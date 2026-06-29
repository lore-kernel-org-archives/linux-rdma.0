Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013035.outbound.protection.outlook.com [40.107.201.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49438E12D;
	Mon, 29 Jun 2026 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757336; cv=fail; b=hYDsnZX+s4o0iAgsDQDFf9AwgsEORUXjEu0WuEbhx6+OYxU9Lr2oRdXicDUsTmp500bxj8LmXjHGPIE5iSKQwrZSOP+16WkBBB518AxJAAmLWcgV1jgu77SotE12oiFj440i4bprxiVesp4Jrx0gcJXwkmho9CHwU4eHNp2+p4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757336; c=relaxed/simple;
	bh=D7y1w1hAd0iotSyKh7CxtFC4/yc2h/GnCKbOuoAwXZ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KDVS7KrEi/DqOiAgOWW2qzFW4drKA20FqUvRreUhYbC6q2CVvukhjYbrBD9UwjKqKXjKbbWtZo0ywT+E6Q0qeCxQgHiriUU+X8v3YCT12DLLYj2SMxKn32ezcKVU/FfqpL//uq0//ToMg81vB3ukFdLFBiDC3FkJVei2VOSrqNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AY4Z7Cqu; arc=fail smtp.client-ip=40.107.201.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AY4Z7Cqu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=st5u1hGrcJ34B3LUN1tOnrnZKJYmcTPbDxLorMpixlEwAMZo/Vjb9mvmBSzrWcdRYUWvZekQWvpcAY/Lvlp+8EqOIa/2rP4j38lYBYtyFHR2rc/6H86AE/xrpJIwsNpPR+QJue3iBP0DZ2TXE3msriGpSNNEfjzvAvxrbFIufqEgBSxHtEHgDjsFW8YRWQUy8hTJ45zEGmsZ7TvPnHrkBY+Y6tFrl7vvWfy6vGPBWyECvbPhgx8AF6EXlCWLtaI3WSbO4HfPqsqV+U1GaWjVEr9C8g4Ti9h4CeMQN+my0XJ+bpNFdhW/qrKyECS8NltHrsH7VmqcYkn2Rb5uKoR0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YruQRGdooAus926mXQ5iORF2/vtVgeWZuFRhOiiAGHc=;
 b=LBuuHDL5OVrxD3aQJXJkuU0pxQrLfXA92j6S96Asn6Hg4/cAcjZD3Fq0ho6p0AagN9bUAaU88+PhFMB0BGkHFKMJi86sTQbW+X0K9PpFWoMbYLfzaxDP38o9GNu0KRi/jTFcaJ3/KQNSEAA0W1C8qqFU0w8yREYpT9U0fDwHdFKS3NM4wSUxqyntlgBvqTsU7G+U3AX1/bv7I1Fru4KVXlG4pIhJXjRvRLoft7F8eo+Pj1v87IoNxjv8ER8bhEcHWbj3HlEQeXr+mZ16e0nLR7Rsn5/I3ioWEeIvIG/1sEDN1yg30Qf0mn6vD+5fa+Bv0ZbVBCK/hf18Sojd/yhunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YruQRGdooAus926mXQ5iORF2/vtVgeWZuFRhOiiAGHc=;
 b=AY4Z7CqukUG9xa6zK8F8own0nn7p6DaTi0pLccSQV1S8XG0R8STi0fQZlCRPPSFoyM1dZMy+hzQzLprdlhXJmylRxBaJMDMA1P2FnHyY5L6OgS3bE/7kDp19BfJc5JWsndetfpr1EUcv57eke+8lIX8Ut6psoe+AOque5EDE4pUgjrFAbvgL4cB6oHj+Y/nOcDZad4t+cabOoZ3N2bDAu+Kx7WHXVsOSlLlhB97FRXSjmrD8R+wjT/HY2HBaXL2+1ZjVMCEMC+H6mKpOfJ53g1hPVw5FaGX7y2O9EuMBsD79KIbaW01Ol0mJXGY/8L/2mzhN5IVU0x9EVzeCq9+2mA==
Received: from BY3PR03CA0004.namprd03.prod.outlook.com (2603:10b6:a03:39a::9)
 by CH2PR12MB9544.namprd12.prod.outlook.com (2603:10b6:610:280::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 18:22:03 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::6b) by BY3PR03CA0004.outlook.office365.com
 (2603:10b6:a03:39a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon,
 29 Jun 2026 18:22:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Mon, 29 Jun 2026 18:22:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 29 Jun
 2026 11:21:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 29 Jun
 2026 11:21:33 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Mon, 29
 Jun 2026 11:21:29 -0700
From: Mark Bloch <mbloch@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH net-next V4 6/6] net/mlx5: Apply devlink eswitch mode boot default on probe
Date: Mon, 29 Jun 2026 21:21:01 +0300
Message-ID: <20260629182102.245150-7-mbloch@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629182102.245150-1-mbloch@nvidia.com>
References: <20260629182102.245150-1-mbloch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|CH2PR12MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dbc2d87-a2c5-442e-9c42-08ded60b5121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|36860700016|82310400026|22082099003|56012099006|18002099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	BxKV+01KYuzasOYrOOvG0xFXztPW13FlPHwUO+yDzG9b9gmFVD76l06xrWufSQcOpc6O5A5oSSYzOT7ssi2fZryfoEsxdm1Lv87nrTrKweasbdfGlxrQEuaUOgaIAgVP6+AZleeO4DxmG/yFA8AcgETs0NLOxWVuEaVbKSYB4OSDYAou1BOCfCV/YwWNhFW0oNGfcq8h1xmZQUq7WZfmXipDkHThrVE/rWKzZGMOC9qChfu9EUX+cMymrLO+BHJEbSR0JpN0Rvpaa0DNXbBapi8WzjpfKrVLJXduKIt0jLKgaUt8qmilEOdFE6G/EV0ZCeI8WBOZQDMWmJfsW0Fw2ZE0BfW40G4Wz9kVXq++BOz8s/Bu+JINNqcv4S28AL6UdE7d1WCLU88mv038puCMTVt5zLHaYxVs84HkF+ZL6LpTLxGFGaAz0CIWIghMlUtq4YVM5vNYYkDd47JwMHyNw9PmxpqaJcySQFrXxp/7ranYb10WmbYJW+ZKuNLepvM02J3L2/dfcukhSZ+UUUmJYp6+0H4awK8y4aJmihwuIhhlI+tBudUEN40FOkV4AjkqY5ErconLfQQqGTmlESzEcdy+mUK4egLnq0pjd193PIvOX64RpkzUVNs2OXPv90zFDMBgn/JpoHRIp7sxbIZNcSEegNfrT22bBxFwI6I7yqc/BOEO+oxDgICsy9Gn2qmqjbnkm/EWoLX4Katmm8dupA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(36860700016)(82310400026)(22082099003)(56012099006)(18002099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1IDKa+ktD+TI/p0FeGl4lZXcuHmSOdWap/z0sEBwkQaF/pTbV0OWuCWfl1GXRwC3FSlXARzx9c7Hr24HNuXNf7mCJ+5izvDek7fK/RJpEaOY5V55rNwRa+ppWLt268kRzfANWXCSEmiyHlSo3cmvwnJqF6qSkKq3mjLBoDwnkZBo0C1AgFBa/eWxvJ3lfnBICp8II+JF5SDxjQ/esA/fk6oQW1x+i+B8Tn4qr06AGyVhGbdiGYIXFRP+qh/xOp86yLKOmmp55NNhKzw1H78H3CTBBhG/BMpZE7K1/bp0HJ0JBq1fxgvpzv9lgGaVPVmSLFp5eWC3zFQBSD1M66kxQiJ2sU2oP5t69R1az35ntX5Eo8zzc86ge75M/iNSjyP+99Ea6eV1frdbqKjudrlRKnmP+Sc/arnc3Wu4921qwAHcdeW7C7LjJO98mAgLowNg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 18:22:02.6996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbc2d87-a2c5-442e-9c42-08ded60b5121
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9544

Apply devlink_eswitch_mode= boot defaults for mlx5 after the initial
probe finishes device initialization while holding the devlink instance
lock.

At this point the devlink instance is registered and mlx5 can perform an
eswitch mode change. Calling devl_apply_default_esw_mode() also clears
any pending default apply work queued by devl_register(), so the queued
work will not apply the same default again.

Keep this call in mlx5_init_one() rather than the lower-level
devl-locked init helper. That helper is also used by devlink reload, and
devlink core already applies the boot default after a successful
DRIVER_REINIT reload.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 643b4aac2033..0712efea74cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1392,6 +1392,17 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_free_bfreg(dev, &dev->priv.bfreg);
 }
 
+static void mlx5_devl_apply_default_esw_mode(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return;
+
+	devl_assert_locked(devlink);
+	devl_apply_default_esw_mode(devlink);
+}
+
 int mlx5_init_one_devl_locked(struct mlx5_core_dev *dev)
 {
 	bool light_probe = mlx5_dev_is_lightweight(dev);
@@ -1471,6 +1482,8 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	err = mlx5_init_one_devl_locked(dev);
 	if (err)
 		devl_unregister(devlink);
+	else
+		mlx5_devl_apply_default_esw_mode(dev);
 unlock:
 	devl_unlock(devlink);
 	return err;
-- 
2.43.0

