Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E91C361967;
	Thu, 17 Sep 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668649; cv=fail; b=HMDO1gIH9x5+dosOcagaLLjQE6yRDLA1jmz/u9rFE5Rgg/KklKzzfrO53uOagQhlgqwrXT9NL2u+kWLl+Wbv7CfPn9UxSdLUOalZoyXluiLI7VOQljVzgx5qqvrnwrBsFph6Y0usTqNn53tJqGB4CBiOBoUspwPDK5/xjcNLfyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668649; c=relaxed/simple;
	bh=7zfcBYJ6pWoaBL4rK45tVZzzji9iIJ3XGzVvqFcriIQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9nupfIPctpcX5NZRHtbbj6g7DtqlmGwpGyYrdc9woWe5FCsDzbRwnTsXRI+dUapmubWXNc8qtCe8iif83hdfh+q4x81lyZZdL8B3mPQoICoejkTkcJz1zU52waViZgHtMxJ1B+NnMi/c3j+NyMdsVBvZ7G8d7rM9rRQ2xH9w7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SSFKyN3M; arc=fail smtp.client-ip=40.107.200.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SSFKyN3M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sV9PS/jzfT9d7L4oSi1fk+EizOi/+NqZzor7QhC36YRusgm390+fmk6a/qt2yYRiaVUfPaHYlfnSGWxiaiJ5s729SwRm0T1mW5APSqOBx9kJd8xOKC1WQlXAO+iW2nMTuC/MJ0CnpPIrMdDKkt9PfGnI/1BKd5ATzrmK7ih9JZ9SMUPXcDXp23nKw2qbtDtwOHopqbsVVBIgZHgPEZPSLkAnoglaipmvKnRJCUNcGSlry0JWHwNqfXAuJCIwZ7iGYi7+0Ti6OFrDC0jyA8a40/B4THeFMgc2g4pza/DDImcNGIdKV0cWa4Zns1DCpX1FrcDDBfqk9iazaHD+u4I+TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NQ2ANzsvNXkp3KH4WS1/hXFAgoGEfz68bvW08b9m2g=;
 b=b33hJ60CQINpzMxesXJTJfZMl26cXwDi7Ge8N8hNVWTnvUYqYGBVKz6K0AClN2qvip8DCiXf+L+FDhMgkfBwyQ/3MyPz3DFGcEv+M8bYAwYQ8VP5zK580YgnP9OdL852fcl8VtSz4hf7LNdXjAZHAMUl2DfTIkgrQSnladsjrmEuhMsvVSTMzYkrAn1DR7wONK5Fsm7ytw7Zz2ajFSSD5+83xCdyujjKeqsCKRByUbE5G+iTBdni/5CJ87cKKKO3LrXzfEFK80puK9tH8TwGlkf/R4G5Lnz4Rn4Ss24C9HDOoZhLCbZR3ffdTXBYv8BX6vl1xaCbrdnSO5D1K7h3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NQ2ANzsvNXkp3KH4WS1/hXFAgoGEfz68bvW08b9m2g=;
 b=SSFKyN3MWNvOnC0ljiKy7ClbrwsSvFhZ/1Yx60D7wR/eMdFFlrVC1S84Gx6k57pjbpwt9w/Xut9PwSUu5zNubpWQ0+r2yJkD6jkAQyh5orvQ2M0JUAz9lP9+liY9YJLu4CwcyKTw8xKJZlXzTVeULZm8i30F3+1yyzZWTOIaqtLLTC2kJITJ1RvXd5mONDg/0yrBiQ9qXaE362SWp3lyC3OynHzCplJDXJN7HYkmRILtfQR/E6kreVTKNThGQ5kjUVxOjPyVWtkHkgtrBgJk7TIunghHJLCFewQcVsBgJ8BVOKuWWa0+x94+wuM37utzkzLO2bLYXeqxTWk5c/TGfw==
Received: from BN1PR12CA0020.namprd12.prod.outlook.com (2603:10b6:408:e1::25)
 by DM4PR12MB6256.namprd12.prod.outlook.com (2603:10b6:8:a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.9; Thu, 17 Sep 2026 18:10:33 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::42) by BN1PR12CA0020.outlook.office365.com
 (2603:10b6:408:e1::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 18:10:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:10:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:01 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 2/7] net/mlx5e: ipsec: Block eswitch mode changes before accessing priv->ipsec
Date: Thu, 17 Sep 2026 20:54:28 +0300
Message-ID: <20260917175433.4090878-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917175433.4090878-1-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|DM4PR12MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: f69cf094-666f-4d93-409d-08df14e6f748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|7416014|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	CG6+bOZuFStunIbTlVD8jk1uAMAMR12IySBlsMiifY2s+JqTr85nO0ktIq8qn1jLkL1tF0vZGw7ldotiqA3+nHTPbI1gpHsfrzPCXj9jPjJ4r4b/0VaMfNz7j3XG3f54WrW8R1EJQ25175laND/EzlhM8E1nZhTclHsRuflVBjFAt6EXRHIGVpaiVWwGHrAhabN8L46Cy6t5eefkmgSxAKRSrw7Tg07Qj/lx0W5jKGVdfEALUwYLtpuEslBDB20cVs32/6isJG9/bo2lnOWyqksW4eUfjEDJHKIQEhwa4b898WkOu6a/JabMSRjIEBngx+zbzr2y6plyawlDSTMhSjhbGIu4zWyRyRNQ8cXncxVxgduzSFbHD0f7yrfJruxwhtKwHgw0i9CY23ycPSPVBn1J5HH3D/hLbzs63PIu4+b8MAE+f+BsGKtsxQTz9xn2ZJlq3LClzKa9+DKY+Kji9/q615DZu9MZLL5PvwgXbDEIjVO8lY3rbIBtEW9HbZOtdMm5kY35tTxD3otPpPxX4ua6gdXOnYqR8SEEtcWR41QoFG54qKjw9M8fpLnGkl0JyjnReITyk47hZM0D9BstdtHHl2QLAep6Hzbm0/JWOg5H6M5BjPTWipd8smIDTT3F9NJmjk/fNpXO7eComSnIpxzN2gP6xue6P/kmYpJH6h7jRoOYKzWHSpk7bGKCp0Ey4aWCyJ2xkyjXwjkBczXQ+g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(7416014)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TPDX0CGcrndcOMzEUwqBGkRKBbD066mh/ZldXKkq9m12AWCqgRykjxunNKk28ZnOhwcgyyF1JAQHETZUDZ724NTJa3LG7P0BF6V9e0oggaRrAtvyBjvxUy+dUtU31Ynm5LZV3hn6YdFtQXL8GifwoVYJq/f3e8YPYeFvg4qv7drqavdLrpMKx8qYwpPacuV7IBzXt6n6wEQgPpV6EEskIDMIZpf7gnu6RQrkIffyaabVdVzL8ywc+8WYaYpVrOltr7MacxVAtHPS1Di8Z6tGy+RVzLMuoV4adsmJjDHDTNiQ7AB+Egw45S5y9pVj3o4Plsf4T+K7fE4J3JYH0DQhk+RQS+XDHNxkWI6bIJZQwvc3ggc+eDjhxkWGYSUE9v4iCBW6I/f3I8YQorWGpq2LIo2n/ChpmJxvVmGdsve/11MEYaFtAsNbWlIwMDRS8uPC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:33.1889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f69cf094-666f-4d93-409d-08df14e6f748
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6256

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_xfrm_add_state() reads priv->ipsec and validates mode-dependent
capabilities before blocking eswitch mode changes. A concurrent profile
change can free the saved IPsec context and cause use-after-free.

Move the mode block before the first context access and release it on
all error paths. Keep the atomic acquire-placeholder path exempt, since
it creates no hardware state and cannot take sleeping locks.

Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 34 ++++++++++++-------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 841ecdc2c4d9..1488faece80e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -771,6 +771,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 				struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
+	bool is_acq = x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ;
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
 	struct mlx5e_ipsec *ipsec;
@@ -779,20 +780,30 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	int err;
 
 	priv = netdev_priv(dev);
-	if (!priv->ipsec)
-		return -EOPNOTSUPP;
+	if (!is_acq) {
+		err = mlx5_eswitch_block_mode(priv->mdev, true);
+		if (err)
+			return err;
+	}
 
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
@@ -806,10 +817,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(priv->mdev, true);
-	if (err)
-		goto unblock_ipsec;
-
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
 	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
 		allow_tunnel_mode = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
@@ -817,7 +824,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Packet offload tunnel mode is disabled due to encap settings");
 			err = -EINVAL;
-			goto unblock_mode;
+			goto unblock_ipsec;
 		}
 	}
 
@@ -893,12 +900,13 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 unblock_encap:
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(priv->mdev);
-unblock_mode:
-	mlx5_eswitch_unblock_mode(priv->mdev);
 unblock_ipsec:
 	mlx5_eswitch_unblock_ipsec(priv->mdev);
 err_xfrm:
 	kfree(sa_entry);
+unblock_mode:
+	if (!is_acq)
+		mlx5_eswitch_unblock_mode(priv->mdev);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
 	return err;
 }
-- 
2.44.0

