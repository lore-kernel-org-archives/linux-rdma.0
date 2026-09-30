Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011031.outbound.protection.outlook.com [52.101.57.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215384908A1;
	Wed, 30 Sep 2026 12:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770360; cv=fail; b=ql/n5IFMZ25bP9EMysxKqh0c/yK8gCUMKujL1szGqYQmJVnJW5mGlumHvCmFJOwSjBTK/jN53Hb/FlFHwPb2DxGg3yW1PR6MOYeNu0ODtiPLfparH/Wi+zaSD9964dE7RmgIstY//CuLkhDC0F0LOYvGTuZRvLV8I01nbDRAvgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770360; c=relaxed/simple;
	bh=Z1mgpvSnnbGpPGfX5B/pGa4j2MBIodIV9AEaIr1ru+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKToCiIXy9CZ9pLCLZXmdKgunjUf+baZ03N/nTor06izThXF3D/hpDono1KCCh0L6viyCGJlFqpMkarIQQLZNB3kdiBKJDabZsAhXKCXGt7KPahQMHfza8WAeNsHsvoFZRU5nck7ww4NYkdGY8dkqb2q6uIOI8ic00DisKGPIyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U7xH5+pK; arc=fail smtp.client-ip=52.101.57.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U7xH5+pK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YUxplsJzgxUR0fkN2HQmV1gq+CTVqrClf10Yyi6Qzci2s/n8VSOyLMgM8RaG/Tc9M827CwoA05ls/ijaa4//+sAYDu/xNUt8aQa6mIgfukjjyKM9VZHtQHW0OmOKJpW8NklSaPz9Xb3EJDTljmhqJXvz49atL2u5EUEAyAjUsHJpuj8WxZxUJ/ysAnTVF5W7dtA/MXDn+7juds04D7i75YKyfwPKVaxYY/0v7qZlef6OUnTcYeKcxdUu2ujBugsepvnZaR+7M4W3xnbroi9PFIiCQrJTKdIC/myKrpDFQBICv82ERb09s+t0tNUS1dyONBaP6CJ9D6mxKmau1An6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifMxEzPXog4GWuS6y0YdiMh4DpgBv1QzXh6qpauP9vU=;
 b=g2GCIZ7R3xRDdLcUL7YMKW2ILXaWnxlzgIaPznrlf2+UYBoExIMqYx0E0+ax0kWSgLrx+PypVx5r0E+2dzekPae0BuCb7OvTuO15brqZT40Jwn96g680m5LCB4NbJ+X7SeY8I+JHCVAxZkci6PicTPkojkpL9JHGyFn8n4vgeYsqXmC8W5JleS//RTfACHTZZBh+d8BQTrYxmogsXugetLbo099fiD+ycAzCS36gbpoYwWrjI4HDAQVul28A47ZEF7pO8hiekcJmK13qED7Wb5kBYJGQAKNfhyoBTXfeUGRyKj/yIqt7mXnGrXQyqaAcA73f87e+gyiohaw0hh+U2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifMxEzPXog4GWuS6y0YdiMh4DpgBv1QzXh6qpauP9vU=;
 b=U7xH5+pKNTYBAHF5yhk6DFTVll15zawYWYROGxQCkFiB/Y4ptPkBNok0nszh3GtHrtVFmfGtRjxBmFlQ+4rPdFPCrJFTF8Q0bUTroyxxRzYIRVhGKCtChHSwjYdiHFqiP3DfffuikDlT3Ka4/7vQlODVTBzWKjsMJiiWVoKJ8TnKMD5W+N8AacaC92rhWEVgnLTcDB6/8NPI7TS4YfD+5cKS15Zk/RIqw22Q0P0Fo91YAW0mLkQmI2b2QxEpCh9jV81z0y09qxzDOj3jDR2qw2cLxqRHzYDFqqzMD2gMCUdwJpmXCFDQ5IwX+JED2QnZ9IDp8fO9eInBNq81uNSj9g==
Received: from CH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::9) by
 DM4PR12MB6638.namprd12.prod.outlook.com (2603:10b6:8:b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.23; Wed, 30 Sep 2026 12:12:23 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::3f) by CH0P220CA0013.outlook.office365.com
 (2603:10b6:610:ef::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Wed,
 30 Sep 2026 12:12:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:12:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 05:12:01 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:12:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 05:11:55 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Steffen Klassert <steffen.klassert@secunet.com>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH net V2 2/4] net/mlx5e: ipsec: Block eswitch mode changes before accessing priv->ipsec
Date: Wed, 30 Sep 2026 15:11:17 +0300
Message-ID: <20260930121119.141953-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930121119.141953-1-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|DM4PR12MB6638:EE_
X-MS-Office365-Filtering-Correlation-Id: 749333bd-e108-4a02-7354-08df1eec1556
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|7416014|36860700016|376014|10067099003|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	/GH+fu2XJOAQGSjqUqMo21lMDvddEa6goCPtfX8ItaBRPRwW74xhsdUjHtwymxsOGQz9rYLrQVgiKFFS+L8esn6T/e6d9r/q0JSDdEheUSsEMogumjGkkcjaRSn/FRqR4F3OhPQCJ9N+B6W2mjH219SSez+0MrD5McZ/Xtueyu8XLN0qL5YKYrF9/oiINOYOX5SBhwKK9RaGfV3loHim8T3zrYZbJrdx+YP+caTA2Pi/w+7Tr75e2E9dLDg2hA/TEGkXz91Nt0n+1ve3IsFqjlyPy9X0pArbmOJ4+3BReMXeYG4ihMUBM8At7eNN8GXHIT6pZSuSp5+Mo1MIuHFelso2gVueYp/nQkvDiNAlE9lLOaAujC4914YB81rG4jn2wO0yDF06/I1yNm4Is3vJnOYClmGYsQKkygixkEHCHOLzsIWrPSMwsj/wdj4wlSd3jrtafucGz1GBq/jmYaLeHG/bjh4r0MR2xAb7awU9tmE1p47xUCVd54riYz9THINnA/5HwJgZX0gOYKhmg+IMbh94/7nFHs+yBgeenBUnR/HS87jNH6SZl0X2m0wgr9WPSAZjpqxFYUYUEpmbt6a9p1fMoEU701PWPo93vBc39Uq/pEh5BCfyjV4PgdlvH6MhXtwOme1dDiXHeJzD9LD5UxG/wlV3luUrxLlXHnWvjY2lDrYSHTiT6S9O6+7I0NgGVoN+ghvsDZXYGWl3b1hykA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(7416014)(36860700016)(376014)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+917nMDQwJTZy+yN+oI48afyHpVl5JX35FwHveLLkcsu5oebT5ruSLxbwEPHrZfoHBRPfuXtc3L8RKoYdCAd0kjbK/QgOeBuPb8+4QdE/XXaV2Qvn87E/ciKE2qCsJtBkhyH0WpT7RuKSkQvQBBUJF/81GGuWUkbHJjwyaLqnHndSxiiLh5Nc+bFPjka5jIYLLe46pHPnYIpQXcpkd3rFlUoWJt22S9YEmTcOzCeZuH+A6DU1J23U1do6J4UibGNF3UtVtj00N/7lt1ktB5+v43pmZKl7OYYMFdEu/vIdg33NObNAgYMQZQiSqiTj97Vs6tzp2RiE3k1OQLf4W1jb+WlwVsjwaVAZJIzopC7uAe+OlKsqYdyuhsMwLtkgbxtkmQOxsXHXI3lTIPFcTk1jFWRInxC58xbTv6oUlEACAFPYaERdqfmAGlJITHvKBTI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:12:22.7504
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 749333bd-e108-4a02-7354-08df1eec1556
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6638

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_xfrm_add_state() reads priv->ipsec and validates mode-dependent
capabilities before blocking eswitch mode changes. A concurrent profile
change can free the saved IPsec context and cause use-after-free.

Move the mode block before saving the IPsec context and validating the
state, and release it on all error paths. Retain an early availability
check to preserve software fallback when IPsec is unavailable, and check
the context again after taking the mode block. Keep the atomic
acquire-placeholder path exempt, since it creates no hardware state and
cannot take sleeping locks.

As in policy creation, do not check eswitch users when taking this
temporary mode block. This allows states to reuse existing IPsec tables
when TC rules exist on VF representors, instead of rejecting them
unconditionally. New RX/TX tables still check eswitch users, and the
TC/IPsec exclusion counters still reject conflicting packet offloads.

Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 50 +++++++++++++------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 841ecdc2c4d9..cf721ef83d59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -771,28 +771,44 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 				struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
+	bool is_acq = x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ;
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5e_priv *priv;
 	gfp_t gfp;
 	int err;
 
 	priv = netdev_priv(dev);
-	if (!priv->ipsec)
+	mdev = priv->mdev;
+	if (!mdev || !priv->ipsec)
 		return -EOPNOTSUPP;
 
+	if (!is_acq) {
+		err = mlx5_eswitch_block_mode(mdev, false);
+		if (err)
+			return err;
+	}
+
 	ipsec = priv->ipsec;
-	gfp = (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) ? GFP_ATOMIC : GFP_KERNEL;
+	if (!ipsec) {
+		err = -EOPNOTSUPP;
+		goto unblock_mode;
+	}
+
+	gfp = is_acq ? GFP_ATOMIC : GFP_KERNEL;
 	sa_entry = kzalloc_obj(*sa_entry, gfp);
-	if (!sa_entry)
-		return -ENOMEM;
+	if (!sa_entry) {
+		err = -ENOMEM;
+		goto unblock_mode;
+	}
 
 	sa_entry->x = x;
 	sa_entry->dev = dev;
 	sa_entry->ipsec = ipsec;
 	/* Check if this SA is originated from acquire flow temporary SA */
-	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) {
+	if (is_acq) {
 		x->xso.offload_handle = (unsigned long)sa_entry;
 		return 0;
 	}
@@ -806,10 +822,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(priv->mdev, true);
-	if (err)
-		goto unblock_ipsec;
-
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
 	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
 		allow_tunnel_mode = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
@@ -817,7 +829,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Packet offload tunnel mode is disabled due to encap settings");
 			err = -EINVAL;
-			goto unblock_mode;
+			goto unblock_ipsec;
 		}
 	}
 
@@ -876,7 +888,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(priv->mdev);
 
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 
 	return 0;
 
@@ -893,13 +905,14 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 unblock_encap:
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(priv->mdev);
-unblock_mode:
-	mlx5_eswitch_unblock_mode(priv->mdev);
 unblock_ipsec:
 	mlx5_eswitch_unblock_ipsec(priv->mdev);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
+unblock_mode:
+	if (!is_acq)
+		mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
@@ -1262,12 +1275,17 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 {
 	struct net_device *netdev = x->xdo.dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int err;
 
 	priv = netdev_priv(netdev);
+	mdev = priv->mdev;
+	if (!mdev)
+		return -EOPNOTSUPP;
+
 	/* Block esw mode changes until the policy holds its own block. */
-	err = mlx5_eswitch_block_mode(priv->mdev, false);
+	err = mlx5_eswitch_block_mode(mdev, false);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
 		return err;
@@ -1303,7 +1321,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		goto err_fs;
 
 	x->xdo.offload_handle = (unsigned long)pol_entry;
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 	return 0;
 
 err_fs:
@@ -1312,7 +1330,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 unblock_mode:
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
-- 
2.44.0

