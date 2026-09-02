Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2AF4ACC6F;
	Wed,  2 Sep 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367680; cv=fail; b=DxMHq+ifj2VmPMNkd0ASxN1GZQOYv0n1omrwxZG/ZYmuwiUyVIluu66F6YjfKRBBBvfY5xv5uj6gCPIyVogkP79p1+i9iGeTr+x8sxeeBbVlkGKkFwVdZL7jkjVNSWrlqViXhk2jvKgJI5RKmYpcXjd0HNdk7UbZDk0EVS8YtVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367680; c=relaxed/simple;
	bh=TtwWuO61PL31wAOvNp48aJV5ftoZq3IaxsrKPIumg7c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYtHfEhn7NzfZpnZSuptzdUzh59J2eEBajx94RmXo22Ju9S1dvJQ/8ryLi2v9UtrK1+7b7BjIl7kWQj43fS/IT1ZVlpW3Ww9W5YEdJqgigISZW2960k4fo033vatzIpn/L4AeYHwIkYT+14wyc/ys9t+ftqnGUW2SUxJhQO4Pwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KXOAcazN; arc=fail smtp.client-ip=52.101.62.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KXOAcazN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLlwwHPV45VedD18WrNK9OZ9oyHDrzA5z0poka79IMlj+4yhu3M7w83Xn7aA4ZOq0Jtz4O3DtNQLtd97S4So5fgqeKa1L627AzrHV8f9mXhRIrebEi36mEY4+XggZMz1djT2S+kJgpeUt60xZmEzZyOcZM2Po/FQ9Oi7OVVdHaUOVrQJW0L1uibrUkVIQYDnN2ZezPFLs/QCRh2N64f+sppa8FZ4+DGoVXfTYSw1x8uDPqLbai5CcE29h7M7JTlkYDhXT/AjL9zATDIIxFXdLdpecgSoymSZM/GsdBw+AjcTJiL3gQfAfEb5K63ITFDc+xbsPl+F1jsLUJ5aw0yktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tf8t+/faTlpWntnoIxgslEC/ybuw9gkTFIyxrcz5STU=;
 b=MAZ88IhPL5GvHB1tJk1iGw/sy30MpbczsezHoNAffypt7beHAmlcvwyKOSm2XTb6rn33V5SzGtJ/xttPvCGI2x6r5boL9U4+mCgraOrNggGu85dgLzGy6iwkUF5P99nqPVPhVbJAH+s0yNbaw4m9VK0IThnzI8Qb2C0bBTqJdJqKAacWa8FsHp0NnAM+03vM1dkXb4DSxaUAyr/MkwmHGkihMPAq8VPYJFJj6DbEnserdB/o8YY8YyXEAe6IQHUst5RPImmcVIlhftFenZ4ljcV88zPu4/Bik2Xaxly58KOxOCUAlGLHWW15WBIsGCrHpFbIbzFpy0nZmeS4euLB4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tf8t+/faTlpWntnoIxgslEC/ybuw9gkTFIyxrcz5STU=;
 b=KXOAcazN8J/DTFhAYYVMrd1EyHJhf7ZAOhbQcT4siYwSXd2sbC57CYBuXynFfHrZGWO5+s/mHT/DJ26lJuGiWFiD4/qXyAID4qTbojrjhGbb+71wkGkj4nVYWBdsc/DuqMUrbZM1C+UIsy/rULg9aGaOvJIMN4m4xZTC647O6aBqb1rGV+e/sMzgaL4ByurTZLMoZ3KhyttvHaPncsEoROn+y3L4ZkvNh9llYaEHg/Btropli633wi6tTsRuv0zxBMwmB6Ik5jStPkTtmf778iPlKUUof7m88vfXj5T7oNVzs20J4T21tTArVKARcMK1J/AOF6ylJPHrwJdzKBgIDA==
Received: from BL1PR13CA0298.namprd13.prod.outlook.com (2603:10b6:208:2bc::33)
 by SA1PR12MB9545.namprd12.prod.outlook.com (2603:10b6:806:45b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:47:52 +0000
Received: from BN3PEPF00022BD6.namprd03.prod.outlook.com
 (2603:10b6:208:2bc:cafe::8c) by BL1PR13CA0298.outlook.office365.com
 (2603:10b6:208:2bc::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:47:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD6.mail.protection.outlook.com (10.167.248.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:47:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:47:19 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:47:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:47:14 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit
	<shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net 2/3] net/mlx5e: Fix setting RS FEC after remapping
Date: Wed, 2 Sep 2026 19:46:33 +0300
Message-ID: <20260902164634.3657606-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260902164634.3657606-1-tariqt@nvidia.com>
References: <20260902164634.3657606-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD6:EE_|SA1PR12MB9545:EE_
X-MS-Office365-Filtering-Correlation-Id: a018c7fe-d1e0-4133-4d01-08df0911edbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|11063799006|56012099006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ABp3nPeRE1EnMOyOXUzPVIHE1epbykpzq27D6czSpoZmapdrqbLEEwQ4pbFqJKd6+caGoPYIzhI+UfIhrt4C1fBQdz5//FO66v8Wxb+kkyeqZjnpKsz5FRM1daJTGMZCzcQGqbUEzpRAgX0+eaLQ0Wa5ZF2o+vFRZ3R+nMCAGqDeuY+bvo9EgnTztji+eF31HRFRPLHnO6bl9g9EV/obVIAmKAbvNgv7WELS9pWUwnwNMXfKLNXKN4aXUMBIREi/W7YIqLM0z/Wk6r0eWhuzShcfqWt8E2IFMsomdOQz8pLavtUtWAUVwuWgVc6V+Uc36iI5UE5RYeXgNiGb17iu30KY/J5RKhZW3MZAFPWOVJ9h2JE5Gr/7hD5DydxeGdkqE2iRK97YsuHQu4kAKhowsaNNdF7yB1u30E0OajgW7YnK94Ut83J3/6TzZxll1J47S/2AnUxHBSQinVOaKm56188mQXiau+SVa3dSgFVoVimQ35rBoFlYRtShtFnYcPlDhvyXNJSFYIbrO+yC/xWlInrzMeWCOSF0RJkEspNLegHQBLV6vKPlJ+M9eBYi2AFCI4h/6HhjorZLXqDKlKIax1IVILsx2ePcq3/mg/s8spK+Se7YIDvmbFJBnQjVSOhUhL70zPwIsXhokzRkLOJ8SkRIsEylqhP4W+/0Asia1TYNZKAJnrhzb/sAk6anVhceVBHysa+TV4KzdjXatY+PUA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(11063799006)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5sfOCjs7eCWjyUqxYBz49+vgQok83ZyMqtYrV3CGPjAP4GcmDRBVZ17hF+X+eftvLusIe+DAUKnW8yYI7XOv9azIEhdO5pakc88zvYzIH+2mhfJ89UtnY0GFGX4zIbJb9TXrOPDz2CZ8p4LAw0BnAIanszCmeFVLIAKqcFWl+VncT+HH2tUpmRqyoXvHVLtdX+OuUTT6zRi9elbv6JFeR+1Z/gXikWLPDlGg6b2MHmuhO+6xixC+aLYpNByrsD3Kj7WPy3UQR8kcBn7ZiLp/W7iDuKMZESoDNFuFXj85LL/+L9N09eKECTeSgSdAce09+G5usDyxI1Vd0TA+O1uXBvDNoh/ut0msvgrtEpTwZSyvLTJJebVBfKpUMhcYnQymMgn4c/Ig6/FMRDJwIAilcxkn4yDqCcQ0Ly9cCssixIlcieKd41fCh4KqEYbKztOv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:47:51.5203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a018c7fe-d1e0-4133-4d01-08df0911edbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9545

From: Shahar Shitrit <shshitrit@nvidia.com>

When a user sets a FEC mode via ethtool, the driver maps the ethtool
FEC type to the lowest mlx5 bit of that type. For RS FEC, this is
MLX5E_FEC_RS_528_514 (bit 2). The driver then checks whether this
bit is supported by at least one link mode by inspecting the
fec_override_cap fields via mlx5e_fec_in_caps(), and returns
-EOPNOTSUPP if not.

This check is incorrect. RS FEC has three supported hardware variants:
RS_528_514 (bit 2), RS_544_514_INTERLEAVED_QUAD (bit 4), and
RS_544_514 (bit 7). mlx5e_remap_fec_conf_mode() already remaps bit 2
to the appropriate RS variant per link mode when writing the admin
fields, but the early capability check is done against the raw
unmapped bit. As a result, a device that supports RS_544_514 or
RS_544_514_INTERLEAVED_QUAD but not RS_528_514 will incorrectly reject
the user's RS FEC request.

Remove the early support check from mlx5e_set_fec_mode() and fold
it into the existing write loop, checking caps against the remapped
policy per link mode. Return -EOPNOTSUPP before the final register
write if no link mode accepted the policy.

Fixes: 2608a2f831c4 ("net/mlx5e: Fix return status when setting unsupported FEC mode")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 6049ccf475bc..a4c096a4fed2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -557,6 +557,7 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
 	u16 fec_policy_auto = 0;
+	bool fec_set = false;
 	int err;
 	int i;
 
@@ -569,9 +570,6 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
 		return -EOPNOTSUPP;
 
-	if (fec_policy && !mlx5e_fec_in_caps(dev, fec_policy))
-		return -EOPNOTSUPP;
-
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
@@ -591,12 +589,17 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 
 		/* policy supported for link speed */
-		if (fec_caps & conf_fec)
+		if (fec_caps & conf_fec) {
 			mlx5e_fec_admin_field(out, &conf_fec, 1, i);
-		else
-			/* set FEC to auto*/
+			fec_set = true;
+		} else {
+			/* set FEC to auto */
 			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
+		}
 	}
 
+	if (fec_policy && !fec_set)
+		return -EOPNOTSUPP;
+
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
 }
-- 
2.44.0

