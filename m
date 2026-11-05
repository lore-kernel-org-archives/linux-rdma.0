Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913491;
	b=fQ3esN7PHqnYF1bZwVzW0OvnSbPe7b9wTTDU8oPWug+39W0geTVC1IWsANDu+gwljYAO
	 a+OpvGERVCh2Jbwa0vdOrgGioKcivsiipLAG45O8q6XpsfTNQKPG0G8ok9HWE5lkcRk4V
	 VxrwG8Im8yKfxXj+5A/HrwOebfYxKhrCm+IDnJjLJFI7Vxy7qVN+aVyIFZy/PHuKaTwYJ
	 gJbIX/nzeimfCErcF8EfxCzG8sd8prE5iV9g208fTu3F1Bwyjj9a18OxydqCAXD5J6E3A
	 AahFy5K/4wdUbjy6aR1FGbH5k9nIwHoCsoYQ+/M2kwPwjhtzi5SjhWj7lw30Jk8P4Jg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913491;
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
	bh=0PnT5Dwd5djydnyBVdSpP2EeaHVJ9TTmym0hU2AzNJQ=;
	b=GrV3M1L72Fwa3jcKl5vFlRpN/im3NmRadyU/KMO+ng2e8fpa7LsUtfj35tm1rJ4Gq2K+
	 IqWvPF9oT1cSfP+Vzimn3HCYG8gXn9FaW16SsxTNFZYIEFRHfpJ4KwS7mCulRKJg6dulY
	 XpOkYcsMAo+aT6TEHfIfI0dWY6GQ+wbG1DTwbabU8h5hWkKVQkdnxx4Mw/i9dlWEyl1Ey
	 40pFT676YUnwW/TIIKtqiY2u+fIHBSo9pPDIxPHAu89ltum58lgANgYTT+b9uVZTS2j+/
	 qTPvQHyU+BvDuFPJMb9qySeEplmfoiYYvtAUH0Bu9IcAF2cdn7mXGjzohmn97cv5tTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jmebO7e1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.44
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB476606A333;
	Thu,  5 Nov 2026 21:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB476606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jmebO7e1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dPCvEWdATR8vGZYe+kxgMaVnxLYxmKRj0Ek0897UzYd/QMDLB1lDbRo/cjLSskdpy6VNe1BlU9a9s3rDtCsLq8J/2NERf7WQpF8L4u6rCljQu4stK9c8FPTZhhHPNcagQ4QH3jzkByBoH855DWA9mDKlYSzpJrn7ueS6lwyPqffC8zCTfFO8IR8xofljM8zKUWAFxKeqRl3XAoqGCqILFmKTofSHyJDniTGR/x/p/ow3UMclAP9JgYbHE873eLoo3Wuo1ZFjVWiNlyMndxwB7xegZWvekM4jjm0jCjlezrAUWFUhBhsmWQLafJOyMmEIKyBUxdfcsFA3BhQh2DG15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PnT5Dwd5djydnyBVdSpP2EeaHVJ9TTmym0hU2AzNJQ=;
 b=rfJQR5t0uG5PSUtg/aEvbPcHW6z595+sfNyhzftv1aoQgiWKzls5HAIu++ZXhPyOBj8vV9b1sWMgYW6YgXWCip4PyP7c9ZT20R6vhI7DxXONR3xYIKwZiMFO6cBSPMs6Bu+pUm+GTuu6w/LsxNivRPkI2PCEcgV+TCpjH2QHEcdoa2GSmruO2QqFiBl3I2me3IDOy1aI32ZSSatYEHgO4Q0KxX1Li5Cj730HLgX/VfKVARNaqDKDejEzgDCxRBaHDE2c4CvkvWg/nUN6xbOtpdM+yjyUjd3oHYkuD/sLo0SKHvyc4CNCdWUB68rt4QnG1C172/Ayq5IUJI3j3p2cTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PnT5Dwd5djydnyBVdSpP2EeaHVJ9TTmym0hU2AzNJQ=;
 b=jmebO7e18qIQxNvEC5ItdNfw+m2NJAkcUBUTtsWEEJQSA/7VV3bP+KIfWvwP8JkieOfzWZdGwECJ88qf0nikb3sBP/Lp64LT5QO7/pMeL8C8hpblcm7KScI1nPkuVgElKiJktTNfjLqXaxYJ/fkR+pUOnpzrfKfcl5DvYzJrLhj8vYpthuJRTcpwNzQaHZ7b5Z4CmnU3AqdqtF8bCnx0v6Jome75PNWJnARwea8f8f/8q1hnZBruvA3jS83RZ7iQImgFLqbCVfl4kdwkC2lyVUEWxtR0MGLjRP0fjQuXV+nJJkod05iTMKYRULbVl3yFpydT7oHl2XSDOVnPyB84Bw==
Received: from BN0PR08CA0012.namprd08.prod.outlook.com (2603:10b6:408:142::34)
 by DS0PR12MB6534.namprd12.prod.outlook.com (2603:10b6:8:c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 21:18:03 +0000
Received: from BN3PEPF00022BD9.namprd03.prod.outlook.com
 (2603:10b6:408:142:cafe::71) by BN0PR08CA0012.outlook.office365.com
 (2603:10b6:408:142::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:18:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BD9.mail.protection.outlook.com (10.167.248.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:18:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:35 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:29 -0800
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
Subject: [PATCH net V3 5/8] net/mlx5e: Fix ipsec core device access during profile changes
Date: Thu, 5 Nov 2026 23:16:33 +0200
Message-ID: <20261105211637.1083978-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD9:EE_|DS0PR12MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f7f07a-5baa-4906-14c2-08df3b8246e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|36860700016|82310400026|261009223027099003|11063799006|261026140227099003|56012099006|261102123227099003|261021121427099003|261022075727099003|261026121527099003|261028144727099003|261022105027099003|261021123027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	77msvi/G9XhoFKVbsDKZP+lKncepO92MyxhhSc65klAFKQUhELSvifHlqp+S2ZzCVDmPg8tRew9AI8RqqhUvQs4mX7zOtso54t7Yc/Fw39SsWmQ47Ku6uzuGOEnj18qh83Y202chdjYUNpmdy737Jv7hTbbd5WLtXF2nGhzTxAQ5+TVxIZ8eJKQghY/gFcRH4ug9K4VTgbAfeN9teIemhM/yZTwXxzbLhKOVZZK2SMzDEBOU2ebzOZv2Hv5ZF2C/hPq+qpMERHvD2OJZ77Q++8cHuSbkM7i8o8JTbUcB+ilw8VBBcbEiQum1mHhtencnZpR747vCdmZvb52YXIQhs3Lv8iZts1a7kap925Qr9XvuL1Wd8IX81j2FfZUozM497M6KuzjrXf3QzET2BN/F2Ej3CY9pGvnfXVCuGJgWMc619rkJX3htXeVpvaSaoEKHwxOtuBUk7hI0oUS3wt7mfDdADiUEOQugY2E/N0qIeD3tdho1NqbhtB8nxTaSSbFc2IJ0CSm63wLpQ25M4AKpHf7KPdmis7COyeHOOPLslUbjMHBWZHTQaftrnHTUCc4UMHJ+8op0/GZU+1MT5RmFXBFNknDG2gy/VFGEpadlaE9lvAO+WduK+p+9GwoQ0lOXl0+vtz6G6THPSv2OZhCMKTWU7DjKvaM2vw0+iZCkMzpR0cjIw3fwDPCSrV5FYIe++WzFoZYanpGvQUk52PbR6w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(36860700016)(82310400026)(261009223027099003)(11063799006)(261026140227099003)(56012099006)(261102123227099003)(261021121427099003)(261022075727099003)(261026121527099003)(261028144727099003)(261022105027099003)(261021123027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4NWXFNXMgNAEKRWijFt7OJ78WxOSfVow3OMcmCwNqdhFuQ29uZr9pMyRwkXJQTEZP3Ipqvr1j2abrCD6Y8Nv8C8+G8BKBBpeDMTUXLORUjKulS4TQgyv2hQInwl78bbgOW7fkl/lLQAw2XEvmyFZXbo3DFqDxOtmhA3IIJq7rSK152Z2bZZAp+w9xL9KHzDdBKm4qVSFXQxPl301+tYi7zsXQ+Flbhyax3Eh2xEN1wwt2ekByyOLhCvOGgN2HrHlUQGIvjGAYks730N3Ts5vUEK3e/roy+sSsb/ojV0nxNjYmXOx7hRKs/ey3nEC3ejR97cHY8ViXBK2rOzijaDkin0eAp/wXy9afy2S2chSs0kJABUOp6Tig1VfaCIyhBQEqDFIUPtHFEaPpBzJ6+YhqJewF+f3c76kP7dnDIjpr5mY0Ao4K1cQFrZjNqAYjsem
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:18:02.9107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f7f07a-5baa-4906-14c2-08df3b8246e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6534

From: Cosmin Ratiu <cratiu@nvidia.com>

Devlink E-Switch mode changes replace the netdev profile without
unregistering the netdev. XFRM state and policy creation can therefore
run while mlx5e_priv_cleanup() clears priv with memset() or
mlx5e_priv_init() initializes it again. Accesses to priv->mdev can
observe NULL or a torn pointer, and repeated loads may return different
values.

Read priv->mdev once in each add callback and use the saved pointer
throughout the callback, including error unwinding. The core device
survives the in-place profile change, so a saved non-NULL pointer
remains valid even if priv is cleared in the meantime.

A NULL priv->mdev means a profile change is in progress, which only
happens during an eswitch mode change. Return -EBUSY in that case, as
mlx5_eswitch_block_mode() does for the same mode change. -EOPNOTSUPP
would make xfrm_dev_state_add() silently fall back to software for a
crypto offload SA for its whole lifetime.

Use WRITE_ONCE() when initializing priv->mdev and when clearing it
before memset(). This makes the transition to NULL atomic; the
subsequent bulk clear only writes zero bytes over an already NULL
pointer. Annotate the READ_ONCE() snapshots with data_race() to allow
that harmless overlap with the unmarked memset() without suppressing
checks for the rest of priv.

This fixes the core-device pointer accesses. Protecting the IPsec
context itself during state and policy creation is handled separately.

This was found by Sashiko, during review of the next patches in the
series. No attempt was made at reproducing this race, the chances seem
vanishingly small.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 38 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7bc5d07b4321..33a7434a7bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -773,12 +773,20 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5e_priv *priv;
 	gfp_t gfp;
 	int err;
 
 	priv = netdev_priv(dev);
+	/* Profile cleanup can memset an already NULL mdev. */
+	mdev = data_race(READ_ONCE(priv->mdev));
+	/* NULL only during a profile change, which is an eswitch operation. */
+	if (!mdev) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add state");
+		return -EBUSY;
+	}
 	if (!priv->ipsec)
 		return -EOPNOTSUPP;
 
@@ -797,16 +805,16 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		return 0;
 	}
 
-	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
+	err = mlx5e_xfrm_validate_state(mdev, x, extack);
 	if (err)
 		goto err_xfrm;
 
-	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
+	if (!mlx5_eswitch_block_ipsec(mdev)) {
 		err = -EBUSY;
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(priv->mdev);
+	err = mlx5_eswitch_block_mode(mdev);
 	if (err)
 		goto unblock_ipsec;
 
@@ -877,9 +885,9 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	if (allow_tunnel_mode)
-		mlx5_eswitch_unblock_encap(priv->mdev);
+		mlx5_eswitch_unblock_encap(mdev);
 
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 
 	return 0;
 
@@ -895,11 +903,11 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	kfree(sa_entry->work);
 unblock_encap:
 	if (allow_tunnel_mode)
-		mlx5_eswitch_unblock_encap(priv->mdev);
+		mlx5_eswitch_unblock_encap(mdev);
 unblock_mode:
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 unblock_ipsec:
-	mlx5_eswitch_unblock_ipsec(priv->mdev);
+	mlx5_eswitch_unblock_ipsec(mdev);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
@@ -1268,16 +1276,24 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 {
 	struct net_device *netdev = x->xdo.dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int err;
 
 	priv = netdev_priv(netdev);
+	/* Profile cleanup can memset an already NULL mdev. */
+	mdev = data_race(READ_ONCE(priv->mdev));
+	if (!mdev) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
+		return -EBUSY;
+	}
+
 	if (!priv->ipsec) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5e_xfrm_validate_policy(priv->mdev, x, extack);
+	err = mlx5e_xfrm_validate_policy(mdev, x, extack);
 	if (err)
 		return err;
 
@@ -1288,7 +1304,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
 
-	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
+	if (!mlx5_eswitch_block_ipsec(mdev)) {
 		err = -EBUSY;
 		goto ipsec_busy;
 	}
@@ -1302,7 +1318,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return 0;
 
 err_fs:
-	mlx5_eswitch_unblock_ipsec(priv->mdev);
+	mlx5_eswitch_unblock_ipsec(mdev);
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..5cf3362259fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6382,7 +6382,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	node = dev_to_node(mlx5_core_dma_dev(mdev));
 
 	/* priv init */
-	priv->mdev        = mdev;
+	WRITE_ONCE(priv->mdev, mdev);
 	priv->netdev      = netdev;
 	priv->max_nch     = nch;
 	priv->max_opened_tc = 1;
@@ -6467,6 +6467,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		mlx5e_mqprio_rl_free(priv->mqprio_rl);
 	}
 
+	/* Clear atomically before memset() for lockless XFRM readers. */
+	WRITE_ONCE(priv->mdev, NULL);
 	memset(priv, 0, sizeof(*priv));
 	if (destroying) /* restore destroying bit, to allow unload */
 		set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-- 
2.44.0

