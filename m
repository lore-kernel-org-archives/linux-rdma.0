Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913513;
	b=YllbaRqsFM+s0kevAIOrwNT/7e++L0OhMtjPj/e3DOUJV6UEcHf1oQ3oVPtrCLrYVcew
	 qdp0EFX7GpbAjWm4U/zJ8wZVWyFE1H+4pfVRQRcdqfK+Qpngid4Bdar/c9LiR7UhS860b
	 gVJb8KAo8pHV6jcYgRX71BNvIQJdVI7XTCRUhIl188okp7g0dZ93x45DXVFBoIodbUFD+
	 oqCX80FwzemmrQjvsLHgDiiPSpMokJ+1kotT8KUEN1EF9Iv/WST5TvHnY7cfiGMaGEDOc
	 JMNR7+f7Uq6Jl+xD/2gsmRNV/nCAwoZP2teN6hRh4saeY1PZeKKD9wzh8sKRG2Rv31w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913513;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=idhKrh8uUVc5yxt+j09UwoBoyIDMx5hoaetLDVaRBeU=;
	b=cle9ohlX4TtvFcKHSFg4VSCQyj/3gvsPP3VQvbgbUeKqklSfUWf+vEdnB+EeciQRL3gF
	 HbG7vwslOVXAAn/FPvcAK74veaeSW5yYWscNkN0ZlCowy7z+6YB8WzdatiJ1CwSomrrog
	 x2QYau/aa7Dg2sn7QE2WRNoNbufO33cGILOrj6Q0/jYAQgIOCXTSlBoNu/PSQuaJG9VgX
	 QlvrGgoP9dG5mcch6QNMj5W5DimBmALBdBph0QZJRKLtWBlOK57RGYDRoW0cjoxYtfBvJ
	 E4o4kwrtPVnwgZZchXJNqjI3GeXI4hsEKEfNSMS1gX9QR2J62M34JnxuG7W5MZvtELA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VEXv6wgd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.50
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09A0606D802;
	Thu,  5 Nov 2026 21:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A09A0606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VEXv6wgd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1TpEYWzevc/T6umSNC3srCDVP+KD3d6JFqNqaHr4+BQaSEE4KDz98joqts46jCun+mYWHcQTAceudQjaZJyM2x9TtCpbUErVXkA7aEmm16WVhq8w0zA/VS+0itbW51HgWImIL/XFHvbn5pt21EfE1AJ9Cru0N1Dls792xXtCBGae1btKYGlvt8ZmQAFUXml5H/a0SJBs1vb7ni6cBK0nQmiZzQ3ciSpp5StzijLMLTSkVfetjcKKSzI/eb26vbSwLVFdjfEknhSUOvnCrN1UWGooBp6ygEK60qHGVYKUGUlSDooo7ybLwvFNYuxsJpa4a061S6hbcKwB3vY+CC6dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idhKrh8uUVc5yxt+j09UwoBoyIDMx5hoaetLDVaRBeU=;
 b=XVNvpT9l2Zt+0qAPq//HwrD27pJFsTlwKvARqNQm4w4nVHBipl1TBskD82vpMWj91h3a1Qe/pD6fe79t8m3uB4y/xSeoj1TFBvgD7eZXzfN4pgGiyhLXS+c2RwCO17XWC1BaQkKqr4Zw1L+XQGe4rY16wOCacqUy/tspMat1UAzzevEbT/onmwP8hgH2MHrhR4PSIjAn49i3ijfS+k0h05wliwWSwongPTa3XdZ0ddimOTMV3nx9A6rt476YP9f7K9ltw8dHO5rpZptidh8WUrMgj4jWgEp5Jcib5/Pvt1RBWKQZXEW/8BfxxpZYNOvqrTCdv9doTAEcguJxY233qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idhKrh8uUVc5yxt+j09UwoBoyIDMx5hoaetLDVaRBeU=;
 b=VEXv6wgdoOU4RESkgR+cWZ4U1aEhlmFsMAMfSroC1NlAi2Lij1ZgNLk+1XGaS+BtixZH5XZwxRpFuDKYlgl3wpt+2490MmNXUmf6kGkchjJZlAo6P4qcBIiIPzH6WYY5zOyxAl8SjVE6kgDBSPGUXRlNlLW+dVfa57TPVf/9GGs+eSWuDTCSF2u+tU93yBPwNu9bIYmB0zVDzwWanbdIShWMqrTukaBHKolkcPkV46DV69aBvkQBIs9FWl4gHT5NT04TpdbgAvBfRC68eYDfVUXWqT+dqxeD1lbDBhjHHHDkDp/Kxc1gSC80AYaEfDKgzlJvrO8K2kh+s+cBucOlOw==
Received: from BN9PR03CA0798.namprd03.prod.outlook.com (2603:10b6:408:13f::23)
 by DS0PR12MB8813.namprd12.prod.outlook.com (2603:10b6:8:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:18:25 +0000
Received: from BN3PEPF00022BD8.namprd03.prod.outlook.com
 (2603:10b6:408:13f:cafe::7) by BN9PR03CA0798.outlook.office365.com
 (2603:10b6:408:13f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Thu, 5
 Nov 2026 21:18:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BD8.mail.protection.outlook.com (10.167.248.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:18:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:55 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:49 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Raed Salem <raeds@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3 8/8] net/mlx5e: Serialize TC and IPsec offload exclusion counters
Date: Thu, 5 Nov 2026 23:16:36 +0200
Message-ID: <20261105211637.1083978-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261105211637.1083978-1-tariqt@nvidia.com>
References: <20261105211637.1083978-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD8:EE_|DS0PR12MB8813:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f32a77-3f73-487c-8e03-08df3b825423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|36860700016|1800799024|82310400026|10067099003|11063799006|56012099006|261009223027099003|261022075727099003|261021123027099003|261022105027099003|261021121427099003|261102123227099003|261026140227099003|261028144727099003|22082099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	0JMLc4s5MH70jEDELfG2FRyn21JAt5uBgTV4zQdxkWp7REgTMVe7r+Cgg0KASe6sKSJX8FpzzV5hpYEuKrU0hfTSDqSzkX4zj4id4vg+KPVoYJp4B2VQ8VbMPCWBrqgFLpjtR0t30kNN8eCdtwTC2RFt2xF5Dr4prHqAh2OnfkANSz2lVWj55+7KBXIH5jn8aIL5EXslSUnqB9VzLLVVd7SiawG+OtN+1TegXmVyzCBdomEImNSvl460lH31NuiJ4CAZ4rRC99P1EYLRHgTmE33ZHA2S6qRPJTkoVIFYLROsGBlZI5F3vPCg1YRWKikv4e6HEWhkiLdYVrDHE2qULAakaLTKCIvPl7V/rjoIbf9n26z1YMoObEoQ/0egoIeTXfvMMHEFB5VtP0+6xPdyOBrrCMt/GEYeT86hcp4VpvwafS9vlLIR7aTv5SBL9pEmIx66zOgyE/CH0SH4zU1re++6gY6YOjMHymm/9MmxidDsDcGuYpEB/GW55fCGd4p4O7ImekzD1dR4L/fuwlg7VVUCwuOZNwsJV/pvjlNVAzGKVVwVjwRcWzi4TWePJwBbbdiszRGp7FOd6cl2h/+2bJRRitYhI4B7oB3mN/AA5me8pYdMs4cF4YwWj9yHThdg3WezKljH2dgMqAa+JMeg0wa2LQj0e1UlIbI0lxWngYDIUgjVTwjXskHC8PqmmhISkII6Gp9FJUkGs2FN0H6Q1w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(36860700016)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(261009223027099003)(261022075727099003)(261021123027099003)(261022105027099003)(261021121427099003)(261102123227099003)(261026140227099003)(261028144727099003)(22082099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+hFIAKF1e9GuM8hPDKKAdjFZmnJL2SaqA929kK5LcmuY6SXf+kWI0sodpkbsavrYcpjxPhBTGgGphZqtTAnkAJU2Hh7Nh2Mz6uU8Phzeao2Us3M37UyJJ6MKYGndh+PI4/QJHUa5rwfl77O0Jf/JKImBkel2y6vej84T/BR67pI1+rDqFDYBYHB1GATVVdVDBjyw4ckJmUpQvNv1n73fyg1RQu7QE2WLFjyqp3ycOPieR5CfIzwgdYIzU6FK02zwzIgAG6tAu8KnaaXI2XOMhIkYJtsFpeNPUXX82F+1la8bAoE4ExEnELT6l1+oaWvyL6oDyhoW0rBzsEDlwOKPAS4yIUMdD1DIhipFgXKoGvBOKBalH07It+Jz5LQe1FUldXTiiL0WHis49OCcRW9pAk4KxqwaR/mZ2WQXC6ODkqymWaCxKWKZNoVlMNA/AVXq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:18:25.1536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f32a77-3f73-487c-8e03-08df3b825423
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8813

From: Cosmin Ratiu <cratiu@nvidia.com>

The counters enforcing TC and IPsec packet offload mutual exclusion are
not consistently serialized. IPsec admission conditionally takes
mode_lock for writing, while TC admission holds it only for read.
Neither release path takes the lock, and devices without an eswitch
cannot rely on it at all.

These are per-core-device counters, separate from the eswitch mode and
encapsulation reservations protected by mode_lock. Move them into
mdev->offload_block and protect their checks, increments and decrements
with a dedicated spinlock that is available even without an eswitch.
A spinlock is used because some of these functions are called from
atomic context and is a good fit because the critical sections are and
will stay really short.

IPsec admission then no longer needs mode_lock to update these counters.
Add warnings for unbalanced releases. Keep mlx5_esw_lock() for eswitch
operation admission and temporary mode/encapsulation reservations.

This was found by upstream Sashiko during review of [1], and spun-off
into a fix from the larger patch.

[1]
https://lore.kernel.org/netdev/178907726586.219967.4695695146458742597@kernel.org/

Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 43 ++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 +++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/driver.h                   |  8 +++-
 4 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dbe5547d7a49..55de9abbd72b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2585,45 +2585,26 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-	int err = 0;
-
-	if (esw) {
-		err = mlx5_esw_lock(esw);
-		if (err)
-			return err;
-	}
-
-	if (mdev->num_block_ipsec) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	int ret = 0;
 
-	mdev->num_block_tc++;
-
-unlock:
-	if (esw)
-		mlx5_esw_unlock(esw);
-
-	return err;
-}
-#else
-static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
-{
-	if (mdev->num_block_ipsec)
-		return -EBUSY;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_ipsec)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_tc++;
+	spin_unlock_bh(&mdev->offload_block.lock);
 
-	mdev->num_block_tc++;
-	return 0;
+	return ret;
 }
-#endif
 
 static void mlx5e_ipsec_unblock_tc_offload(struct mlx5_core_dev *mdev)
 {
-	mdev->num_block_tc--;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!mdev->offload_block.num_block_tc))
+		mdev->offload_block.num_block_tc--;
+	spin_unlock_bh(&mdev->offload_block.lock);
 }
 
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 708b7987ea4c..9f97c9d680bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4836,16 +4836,19 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
 static int mlx5e_tc_block_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int ret = 0;
 
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return 0;
 
-	if (mdev->num_block_tc)
-		return -EBUSY;
-
-	mdev->num_block_ipsec++;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_tc)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_ipsec++;
+	spin_unlock_bh(&mdev->offload_block.lock);
 
-	return 0;
+	return ret;
 }
 
 static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
@@ -4853,7 +4856,10 @@ static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return;
 
-	priv->mdev->num_block_ipsec--;
+	spin_lock_bh(&priv->mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_block_ipsec))
+		priv->mdev->offload_block.num_block_ipsec--;
+	spin_unlock_bh(&priv->mdev->offload_block.lock);
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..0439fcfb9ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1814,6 +1814,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	spin_lock_init(&dev->offload_block.lock);
 	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_init(&dev->wc_state_lock);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..84e9f6bdb7c1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -789,8 +789,12 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_hwmon	*hwmon;
-	u64			num_block_tc;
-	u64			num_block_ipsec;
+	struct {
+		/* Protects the fields below. */
+		spinlock_t lock;
+		u64 num_block_tc;
+		u64 num_block_ipsec;
+	} offload_block;
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_macsec_fs *macsec_fs;
 	/* MACsec notifier chain to sync MACsec core and IB database */
-- 
2.44.0

