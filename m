Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1383B5311;
	Sun, 11 Oct 2026 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718174; cv=fail; b=a/Q+Bg9bO8r5jv3GGcALoNLB+djitHcph/OTENzAjUBlJlmQU3n1W2h64+EzEbD3l5ZQoyoGGig2fsK8rg+2HSCwHGEDzkeMn0HOUr3Bl2UmO27JHphHRRq6iXTFRGi/1VnlZ0sXsw9E+aYcrQA2LmxUMOIASHVbOxq/4KHb4Bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718174; c=relaxed/simple;
	bh=X82hLBCbnyroIHSrTe+TuJ8pHCwu8QGSdH3CGwSFFJw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jW9FetAQ7OTKfWbGLKyzynqc5W+hxbjdza4YVVHm9NE7IyxUtsU7uDOWMh8BGVOBimHZhFSaVfya+FWB6DteEpFr0srQOXhv7g45fsjpY0w3gSnP+Pt8ea3xojbp5M8NyrYZbxlqr1R2f+A8kHX4fYDUrci98a3V7T/6BCsnIJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SugfnU5B; arc=fail smtp.client-ip=40.107.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SugfnU5B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vayD05hIlFGA44wRMb+yYlenAw64zv2Whr+/vuGyLHFfwLbrkuV+KIYAXeBNZ8/vsDnSY4XfB2TvI8BtF/vBJ3uWrS6KNUY2S6bf/FRFbOvrRJLiomL+Pheb7HrmQnQEK+iKA/e5TP/88bxumI1GyXZjirG4/B4GB8+Bj/PDSWSflUJ+sJu3757qN7MrBWKix0vUiWyqqcgnV8Gomlae8SXi/FXckXscUuzG3H8rwEHOICR+W89QiTJnPN9gWhrSabm8/7pU5ZNrV+mh7ngD//tkImA1kEgdFS9QqjmINb2a9RpxX6H+FAHnTLph+aZVUT+DxOJyNljNCnG0aO5BMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XdcOqIQrTG79WjbNJAuk1hdM+eNSTQXGox2rrPPPZ8=;
 b=CQ7ebHnpoeZ/p9XpIzi1wb1w1jkxYGYDMx9bcHfzVmBegb+4jSGUKn8FVWxJnPxcorFYSEe4gnUDOv3ixsXALwx3SLtBZ2I9J4v1NzhTZqZrrG/crWQY7ccOvzAYPiEs7mfCadOqiB7N7CbYK9/LjfW0zZezERBbpQInmodJByW2EYjkQkaZMvLtxpN169V01ljBmaMMskvXr9EH5KYQQtzy7DPAE4NwuGbrc5TppQraYN9tiTg0hAn4KPdXdw7+yvncAPCjX5jV3RbH0yKo7D7V6rfMRJvFvxfa1pV55qNMi3Gdr80w55xsmLQYMEIYInJfn3+zepQAGrf7iY9y6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XdcOqIQrTG79WjbNJAuk1hdM+eNSTQXGox2rrPPPZ8=;
 b=SugfnU5BnmbLUVcXLUF7ObrZKDrxYQzRKnmn8hIR/ToTAYy8xfCKdsXy4ohuYQKHDwhcN7tlo6Fs1+8ZOkddFi+Z2w8/gN01hG481RexQQkb51c6SrQXFJp+NcXlqMwClwsbc3TD/psv6jPAcrbHSIGqGQ+HzX1zKnurB4fMbNfv6M10ZeT/Y+IPzuYkl3cMw0VrJF11hedptYu7YuSJz4XivSt8lY7FUaJiCRdLXjSxldKPa1S6WmXft5gqXmFtIa9x/OPco0rFHbiEh+4SgGw10RJHVXE/xRHLgk/Qo+FPk2PAUGZFqet/gVKuwnZjX8drU6zJb/HGSK4az0dSbg==
Received: from DS7P220CA0089.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:25a::7) by
 SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Sun, 11 Oct
 2026 11:29:28 +0000
Received: from DM3PEPF000265C1.namprd03.prod.outlook.com
 (2603:10b6:8:25a:cafe::72) by DS7P220CA0089.outlook.office365.com
 (2603:10b6:8:25a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 11:29:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265C1.mail.protection.outlook.com (10.167.23.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 11:29:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 04:29:22 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 11 Oct 2026 04:29:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 11 Oct 2026 04:29:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] net/mlx5e: Select DCBX HOST/AUTO from capability flags in setdcbx
Date: Sun, 11 Oct 2026 14:28:59 +0300
Message-ID: <20261011112900.802150-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261011112900.802150-1-tariqt@nvidia.com>
References: <20261011112900.802150-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265C1:EE_|SJ2PR12MB8784:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ece183-f1d1-49d2-9ac1-08df278ae94b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|56012099006|11063799006|10067099003|18002099003|22082099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	IUMaaCgm15xHc4ojnRYRN6/a2Zd4AmR0uNFNAmaN3+1SDDOxlfzd5mtgLh4d10dSDfWATPSnjBo9AyDZbhSfh8uvZIgsGBjOl2nNZJqEdH+6sMqlmL21biKeUiZi0JavQeZIU3tQ3fj6PeOK21fwZm0qvNQ8uno/k1fEXD22ja5PSaZ5dc/6O6KVbHm1hEAJRIiQK0hT+gXee+b+TKOFCxYe2xtpm7/8asiyM2L2gSrfLP6tmeamfD9v22bgRwihlQZ3sLqj6SgdEhunOcDDMu/3j57YaAqv8xnzvKnEg9A3Wr0+oO2G2/j8IvUVIMtrTCdfxOpZa1HdZkQLUDl6bScbmzCuPS0qbvc9XN/gVN13kvWOsSj4pfF4yOyxoZ7ylfXE4jIknXTDSU8GgaVvLX+0iDhaooAqSCFz34SfKDnaPhCFuxIkDl4cy9MNzNtEdWU3jOrVPRM/h24kgWPuPADwqU9V1Uo/Mn+yoFAa7nbEmqcp0+bK7yOwZ9wZJtodrdKa5ZtFxPWrZdTIs1fQjvckCSmkvFatJG1tmm07MDnrpJgEFuBNc5dEBgGTwBP9520PwQ+WjcJuaef0u+wUkCtpUxtt7h7+BNiO0uvyEwR2XL0lhfktZMVAjiJZYXzjiuuRmRxXe7wUkZ1xVnBrZhMtxk83NSMip3FxoLZLq2HRKdXrLO979dT9FgnxoNgzVKnYPvg19jDZcpk+r8nP/g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qIfZSYPLqmXUGcuw3X5wi2zcls6Qyr2g3x7jB1Kw+I75DwOzRWr2LF9cU8xbmwcMmQLP6D4vDr513eXtGmzvQpG/xHoYy7ESFyr1adnLcnjgFTwxUe1gWpcTxE1E12715XT1n9CP8H0Ob5a4FpUxAdzOUpCzArmBEODut1clQjyRuE+VfVSozGsFtqM+2QMJUKqTzFwZ/tA63/v/pL4FAtRjhFqWyiwkwgR3+JpsoKMGBBLF11SKcg5HZwZAuJ/umEmJ5KBMoEbnfMf0n58R69sSd6015cdeIfqHBEbnaJJhoVGrmvycdtExQ8c3L9C/h8qEfXdPiy6tqS5iOps2t6Sw2HekD0uUe2B1Glwqnfdp32P6cX4QIA/+6yL0/kpk1OBAFlz8IiVTlfqpSA2SJljNLXpVlHy+In52JPoXjGWLUtIZ1fsJuwyfdKzIZMYj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 11:29:28.1440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ece183-f1d1-49d2-9ac1-08df278ae94b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265C1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8784

From: Alexei Lazar <alazar@nvidia.com>

mlx5e_dcbnl_setdcbx() used two different policies: mode 0 switched
firmware to AUTO, and any other request was accepted only with
DCB_CAP_DCBX_HOST.

Switch the firmware HOST/AUTO modes based on the DCB_CAP_DCBX_HOST
bit. This better aligns with the DCBX capability flags. It also
allows folding the two different code paths into one.

When switching to firmware-controlled (non-host) mode, report CEE,
IEEE and LLD_MANAGED together due to a FW limitation.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 48 ++++++-------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 741f75b5bfec..4eef929f5ae9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -99,25 +99,6 @@ static int mlx5e_dcbnl_set_dcbx_mode(struct mlx5e_priv *priv,
 	return mlx5_set_port_dcbx_param(mdev, param);
 }
 
-static int mlx5e_dcbnl_switch_to_host_mode(struct mlx5e_priv *priv)
-{
-	struct mlx5e_dcbx *dcbx = &priv->dcbx;
-	int err;
-
-	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
-		return 0;
-
-	if (dcbx->mode == MLX5E_DCBX_PARAM_VER_OPER_HOST)
-		return 0;
-
-	err = mlx5e_dcbnl_set_dcbx_mode(priv, MLX5E_DCBX_PARAM_VER_OPER_HOST);
-	if (err)
-		return err;
-
-	dcbx->mode = MLX5E_DCBX_PARAM_VER_OPER_HOST;
-	return 0;
-}
-
 static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 				   struct ieee_ets *ets)
 {
@@ -453,32 +434,31 @@ static u8 mlx5e_dcbnl_getdcbx(struct net_device *dev)
 
 static u8 mlx5e_dcbnl_setdcbx(struct net_device *dev, u8 mode)
 {
+	bool new_is_host = mode & DCB_CAP_DCBX_HOST;
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_dcbx *dcbx = &priv->dcbx;
+	enum mlx5_dcbx_oper_mode target_mode;
 
 	if (mode & DCB_CAP_DCBX_LLD_MANAGED)
 		return 1;
 
-	if ((!mode) && MLX5_CAP_GEN(priv->mdev, dcbx)) {
-		if (dcbx->mode == MLX5E_DCBX_PARAM_VER_OPER_AUTO)
-			return 0;
-
-		/* set dcbx to fw controlled */
-		if (!mlx5e_dcbnl_set_dcbx_mode(priv, MLX5E_DCBX_PARAM_VER_OPER_AUTO)) {
-			dcbx->mode = MLX5E_DCBX_PARAM_VER_OPER_AUTO;
-			dcbx->cap &= ~DCB_CAP_DCBX_HOST;
-			return 0;
-		}
+	if (!MLX5_CAP_GEN(priv->mdev, dcbx))
+		return !new_is_host;
 
-		return 1;
-	}
+	target_mode = new_is_host ? MLX5E_DCBX_PARAM_VER_OPER_HOST :
+				    MLX5E_DCBX_PARAM_VER_OPER_AUTO;
+	if (dcbx->mode == target_mode)
+		return 0;
 
-	if (!(mode & DCB_CAP_DCBX_HOST))
+	if (mlx5e_dcbnl_set_dcbx_mode(priv, target_mode))
 		return 1;
 
-	if (mlx5e_dcbnl_switch_to_host_mode(netdev_priv(dev)))
-		return 1;
+	if (!new_is_host)
+		mode = DCB_CAP_DCBX_VER_CEE |
+		       DCB_CAP_DCBX_VER_IEEE |
+		       DCB_CAP_DCBX_LLD_MANAGED;
 
+	dcbx->mode = target_mode;
 	dcbx->cap = mode;
 
 	return 0;
-- 
2.44.0

