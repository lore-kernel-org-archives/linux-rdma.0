Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913497;
	b=QsCji+WsOGFVp+Ve1KwYjjYZopCe13Mk/ZtTkCUNwm6Thn3WlUhkJgmR3ke0++FsSoOu
	 DMPyJUqpvqQddbFi3hu5qU0aY0VQEgPWUC81VziIty8cMzjnO96ipV6uqJZyZoQ+HX/r2
	 phneEuuoJAeTVEjdPed7h5EDWqiVAJCDqufMaCZmX1KCqw7sxct3G9yQMhjJPN4KUmKX3
	 kIQdOqHvx2751q0+8fXebnJrBrQnr+9RAQgKEDIK1Lj9qfJacbfcKwKqXwwHaNQubidvq
	 tgENpZaxMgJHS+AD5s5SZ91ZuqeRYLE/VZmrozPCWhp+WktchUiTvqjZ/t7UWW5tz+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913497;
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
	bh=Md/xjq0nl/4pWP7ZHFOILaXaSpm3v8PmvpxjXI0/q5s=;
	b=NE5ajx4BdsctAL5rlFpvVQc/JZxik153xFscPvgsEgznpP6195bOURFg5hAmCfi7f9Uc
	 pOZ1YA+wiI8cgUuobN2OarAwD6OEHIs1zQ5zpcUleiufQ4reFQz+SLAyVXnJDEpXIsAE/
	 DWoq+XnWgXDEEovhmZxgL2IvkMbSljdes8Ym8B4q8zvuhaMMmftS0M3GzebyaMn4DlDP0
	 Gppy+Vhe8BPihAJM5Z+T42ftC99SE8b3637b5WGko2fPN+0OhZckRZShGN4Z2QwR2D12L
	 qa4iSCeP4FgNwz6T/jTYC3IpHwtSmxPIS83lYisUr+Qmq3wL9/VeJA5xmBDon/WChFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=f4DmEEF2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.35
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F9606A32F;
	Thu,  5 Nov 2026 21:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E75F9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=f4DmEEF2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQTHQRMbcGfzToC5+VRX/iLahLUHXR3oZI1pyP91xiAEdYBfInEoE4bkUVn+Lhjo2L0pOHOsfarP77GcskYry7jgjPwP0+dkc0k0DltmxU0e/vcUXPYs+fqhcMbUbVSv0CJ7RIPqppZmtc65I0nkhJT01vxx9tyrLhDbGC3AP31r/GPFgtbvq4yB54NRHohTr3OK61Pq7ZjXKhDOC6QN0kuY2pYDjGvVeYPGTZxie/jDbFfi2cBL3jlit5aFAuHIQH3bctBDFMwF2J140kpTfzSqh5Thlkd+671PiWixTMDuPiZZiqNqrTNuLMZtbxyIgGQzH7oB4kEgNkB1XOZhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Md/xjq0nl/4pWP7ZHFOILaXaSpm3v8PmvpxjXI0/q5s=;
 b=EVf+Wu+x6MTLWV0GQuHazg3G46wkOWTU9trmX1emdQLRx/vYsvHNPOoiFeQU/fVKP2dzoxnA68ugfMG6ljib9fSCTrNTnZotgfxwTlmVTtjndeU8ZTNstLeSG+UKCotWbh9mkT6VyZjWnfCPZmoIxrqdkR2gS6D5VHMGWoXgUqYXZS+s0if8M1YEQA8t/202HSDyjQJjugO/d/jCgp/RNBww20vDVNIX8gMkSPmHMaS2zTRjpl9nHFNPm7X0vdy6W3Zo0m1mVHyrdaytW1iUXQec0R69gj5CYKW67GT0tiRBKPc91zrv7cZKY7lO8xpwWNydjxAV9sPxooG4QbJIww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Md/xjq0nl/4pWP7ZHFOILaXaSpm3v8PmvpxjXI0/q5s=;
 b=f4DmEEF2tL4TfxqK0ZUoGvnbEa9gdZMYB2GBAqCWvWH9OwuMpSrRlxGfEh7t5kAojlVN5ls4E0SPzi2q0Jy/ZB2O2xK7a4HfjkTKzm5IUxPTyRT6Boy0I6ahw3gEw0sOteDaZONDJ7UtryssVWulN6E+TlgGyvTVeBKYTWkkJguJrI2JpHgT7n/qx8tl63wXG3QM/EWueHQzFr/V0AV0YmTbIcMqu4Dz+U8Wrvm4rzcoK9PVIgs2/ULibZecOY/YG7LmNtd6VCQk83kEu77K9cFeuYK+dxB3SNl28rPkyl4VFDEw/AmEzBJ40tQ+E+Eq/Uaxo1LawSSt5pAFnu3D5g==
Received: from CH2PR12CA0021.namprd12.prod.outlook.com (2603:10b6:610:57::31)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 21:18:11 +0000
Received: from CH2PEPF000166BD.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::60) by CH2PR12CA0021.outlook.office365.com
 (2603:10b6:610:57::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:18:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF000166BD.mail.protection.outlook.com (10.167.252.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:18:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:49 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:48 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:42 -0800
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
Subject: [PATCH net V3 7/8] net/mlx5e: Block E-Switch mode changes during IPsec state creation
Date: Thu, 5 Nov 2026 23:16:35 +0200
Message-ID: <20261105211637.1083978-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BD:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f85082-4bac-4260-b91f-08df3b824baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|7416014|376014|22082099003|6133799003|10067099003|18002099003|56012099006|261026140227099003|11063799006|261026121527099003|261028144727099003|261021123027099003|261022105027099003|261022075727099003|261102123227099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	TQPT+Aj5xGeh7dhmBqVXzSCd5thAefi9KgshsU9MLliIg5PsT2PQM7lSoeMFOIuzHC4THMN4gm4YWeCKBZrE0miyN31WKBDyls7OLG34ZMaJ7Riqem2MqlEyJwrB05zqRp2MYR2SSLdVF+GK/QJqthLDZEIgFaeYfFnfaXyFOzJBWxKGP4UGI8FGFuHx5ZJGfar22Q3D+MEbATiQjCQuqt/F2xTOxjuZFOQQtOCl2im0mEC3ahrbf8IeLm87SUKbm++Ow3zVO0IPAWy7HvRi6foigGFHQhMevX7VOww7Xqfa6y2XRq79hV0CXMrHkeDTN7CFt6ndw/4gn0F2olv1il6HDGKKkrP1dPEWwth9Airpy3yMwTb1qEqsj95rIYrQ4pXUZQB+NZvN1s7qW0tWH/DsKS/8aDCDZ44W28h7A7lxERt/yvEnb1+I4jFeBMsZSZ1KygCGZDChibwjbn6DtBPq7F8V9HoZf1xuV1DaAEOfaT0PV3tnfaN60pdXjNmJhu6u27xTF7LBzC0VVKfcrzfD7HCSlerd/0dhsXXU5Eg2kr+JiN/GO/RRWIgWZtJ06S6Shzo0Gcakk6BuyA1fZWrpixheK7mYq/lcjr2HluCpQHy2OQktAhQjAYwPXPR8J+rSNcG0yZippR0LckO7q9RZUfNCgisQ/0DeuxcMG0HBnakQq6kMDeq5/XTRBzFTxHt3L5+tyILlgKJzEVFG5w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(7416014)(376014)(22082099003)(6133799003)(10067099003)(18002099003)(56012099006)(261026140227099003)(11063799006)(261026121527099003)(261028144727099003)(261021123027099003)(261022105027099003)(261022075727099003)(261102123227099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LBBuK3g8vvLNU4o8sDCQvQJ6mMjkCHvn2hosPscCDwwWGrLPqOEF218i0IzG/m6iStdqB447TZhSvTY2YwHF+gDT481ksejcO6TCU37sqIxYZZ8nQqx/miUhJY6UCzczdIjHnrxmyI0N9nMXglA6CbQXGzmeOfjkB3Fe/83jFus7Lcpoy/yOdCAzsSyXdUvW5xsbql6c665BBuou6e9mIfhn8e0si3wFIyAlJGfybqmRTMLllq3Icsrn4SYoWeh+cbNHhLQZQgpIJ4wIFOgjWb1oqzDKfi+A1DSBqQ3lgJ4hsBJIO8Xz3RflWBWh7Yd2YULLBV3A6O7nZElTggJiP0Bg9ZuOgIg1PXXDP08JLaEmsx77JVT9ajt2gdFfX5vP/g7Zx8y1vbQNZ9gnqS3XuPwhdBAPqBFXmzAS9yeugOT+GQOxHeKcPIgb/nra9jiV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:18:10.9644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f85082-4bac-4260-b91f-08df3b824baa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5e_xfrm_add_state() reads priv->ipsec before blocking eswitch mode
changes. A concurrent profile change can free the saved IPsec context
and cause use-after-free.

The temporary mode reservation was added in commit 22239eb258bc
("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
after saving priv->ipsec but the race was actually enabled by the
"Fixes" commit.
Extend the reservation to cover obtaining the context as well.

Use mlx5_eswitch_block_mode(mdev, false) for the temporary reservation,
as policy creation does, to check operation ownership under mode_lock
without rejecting existing eswitch users. This allows reusing existing
IPsec tables while TC rules exist on VF representors.

Check the context only after taking the mode reservation, so a
concurrent mode change consistently returns -EBUSY and a missing context
returns -EOPNOTSUPP, preserving software fallback for crypto offload.
Keep the atomic acquire-placeholder path exempt, since it creates no
hardware state and cannot take sleeping locks.

This was found by Sashiko, during review of the last patch in the
series. No reproduction attempted, as it seems quite a tricky race to
successfully trigger.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 37 ++++++++++++-------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3cd0b36a02e7..fa6cb51fdb93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -771,6 +771,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 				struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
+	bool is_acq = x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ;
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
 	struct mlx5_core_dev *mdev;
@@ -787,20 +788,31 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add state");
 		return -EBUSY;
 	}
-	if (!priv->ipsec)
-		return -EOPNOTSUPP;
+
+	if (!is_acq) {
+		err = mlx5_eswitch_block_mode(mdev, false);
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
@@ -814,21 +826,17 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(mdev, true);
-	if (err)
-		goto unblock_ipsec;
-
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
 	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
 		err = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
 		if (err < 0)
-			goto unblock_mode;
+			goto unblock_ipsec;
 		allow_tunnel_mode = err;
 		if (!allow_tunnel_mode) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Packet offload tunnel mode is disabled due to encap settings");
 			err = -EINVAL;
-			goto unblock_mode;
+			goto unblock_ipsec;
 		}
 	}
 
@@ -904,13 +912,14 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 unblock_encap:
 	if (allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(mdev);
-unblock_mode:
-	mlx5_eswitch_unblock_mode(mdev);
 unblock_ipsec:
 	mlx5_eswitch_unblock_ipsec(mdev);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
+unblock_mode:
+	if (!is_acq)
+		mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
-- 
2.44.0

