Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794583385;
	b=wvSMMR8QOmgPASi/MxhZ+GgC0by2ndTOsZ2ygda78usR3Hp13/J32p151QKj0WrtaGwa
	 K1BDhdDt85dWCEF62Gqtcn4TmS18/9YuGsM447rtvgpM2m1BmR855MJIDxrXUBhf/I35Q
	 Zus77WM1v0A7FvJ+erdj+k8FCsv/rCS5MMB9bus4fuWWGlW3aAxtwDbTi8r4Xv3ktyuBC
	 83hcHGlu0+S9mWkSfIiQz4IaOo+/EEi2jgpC3vqyVQmzM+2QKEYm32Mtm4FIJKI+/q1Yc
	 +2qfHNNRwYxWGFLbcRQ7cCMiB//yBbJG/6T8iWC1Rt/3TRSXjLQgPW94hW7MZwqDRbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583385;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tBoG3yPbHOknMukm/yHUFzmOQKrS5xctV7/1Wnkk7Ak=;
	b=t9XfIyv6/rbDtl6w9HGLuRRmvJmSLdF5Inu1BV66CdxP+geK5uiotT6656WCH5mMHdIp
	 8TDQvu7kMvM9s8G2h6Vkm7DGh9TStgMAcxVLfyVYTLwB7QVf18nqs0ARB1e5c55oPRl7S
	 oVjbBvYSbhvINRSjlpmK9ffV7l1vuD/1nvuJaX6gUqZMdPbmZiJQUsLN+IeRk/UsB3XiA
	 R032kxJB8eYRnFjCBI2P8zdlAusi0ZQvvVRVSJGA52tdRRvq1/AmKA9MRSSM0wb4WDILg
	 SMPhmsbhH4gQLfrNlpiTRkM3KwU8ODixj6rsFZG73+olfUWSc19JIruTL6pAHrb3tHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DxiHxWxG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.51
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010051.outbound.protection.outlook.com [52.101.56.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62122606A331;
	Fri, 13 Nov 2026 15:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62122606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DxiHxWxG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=voqM27EbFBigqAEb4u6tQQGl4jkLYXMWRmd88SVwMhTXCPtgtMK/2UORxFmvNvJEqYre6/kZV9Pa7qfKgEadsZf3RE290IgypmdaBTp1JssmpB7cd3ZbaM4aL5x36FRIfsyhwjtWkCYmwbj/iGLGVSozN3mm/DaeHNXZHJtk+jAzne52mEwpIlEAfp3vQB7zA/t0MmXlyJni332aMUiniJ0nBZPm7L8tQrdv3iyDenTZJsRJb4/6JADy0btzjH0BPJ4uDI6dbpRedaTOocGKpF7gDm2hHxMQ4qQP5//hjDnixMaxppVoHoW+hVXH+o2LJpHc+7fY+POdpSuYv3zVow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBoG3yPbHOknMukm/yHUFzmOQKrS5xctV7/1Wnkk7Ak=;
 b=hzaphtT8Ubu2i6+nHhJ8Sn2FCyNcMuDaR2bB1CSifZ6Bir7pnwoAbZsi1lFrj6VFZCSEOJHOQbxFVOqc5gbRW1rrEHv4bTSCWisrrsw6Mz0L29Uc+fuslY8RbAa4zPJd81VCuLVxqqPKV9J5d64Cl2ZP3Y5pslg/I4HkMbxtrZuoO04VcWLwXxweqrza7/6USlA2RIvrHmiUKlFTKwR67vuX/LZk//O7Ib9LSAEUU3O0ZQn0yEgRmVmN5UjlgBHt64FnlC3xh6Ok3UgSUZ44paKvX3jEJZXR0/gCilfWT/Ag51HEzmDyGpVbsJoCOFSCfkxjGsqDj/wTEe1rC7JJKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBoG3yPbHOknMukm/yHUFzmOQKrS5xctV7/1Wnkk7Ak=;
 b=DxiHxWxG3yyCBDdEzROFveyAS5ltote5s5aAHO+7DOD9b5ltO4dJgrHXH4pYNjTKsihZq7mD8EKKS/KfY4txK8AErI6VeV/QOnLCz9jFwxytVwNuxD29sQAA+lHR7BCQtVvlvbHA72Jk27IC6CUNxwcQduZ7yS9lUGPbZ8c961DjLcMX/4Rzj7qHTj1kwIacs696J5KayALcDY3D+DABApgyAAsWqARz2mSVDLvhBTUVTH8om26hcdxweIROMKakN/V5pbhHeiLJJlv4JqwuGdSjLnhC2b9QSvxZcW6pe8Ax7o68YHjxpGsGKezdiBMrjuaVSjFJig/6MBre7ebXnA==
Received: from SJ0PR13CA0225.namprd13.prod.outlook.com (2603:10b6:a03:2c1::20)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 15:22:53 +0000
Received: from SJ1PEPF00002323.namprd03.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::3e) by SJ0PR13CA0225.outlook.office365.com
 (2603:10b6:a03:2c1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Fri, 13
 Nov 2026 15:22:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002323.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 15:22:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 10:29:53 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 12 Nov
 2026 10:29:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 12
 Nov 2026 10:29:49 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5: IFC, enlarge active_port field to support 8 port LAG
Date: Thu, 12 Nov 2026 20:29:40 +0200
Message-ID: <20261112182940.3655773-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002323:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d50da7-d457-43a7-a4cc-08df4199fc0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|23010399003|82310400026|56012099006|11063799006|18002099003|10067099003|261009223027099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261102123227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	1SUIt56uMIafVceIsvw2U3chDkbLPyC9azBgui1THwrf5M09qu5GxW+FExR7OXAlOPMLzpsApT8NdrAyZQ0odZP6wNA0e3waSRVTeliOL/bf9oOjGQHdyCUHPVxPjRXdOf0Qjf2NzaxsAUrmwPb2gAGXNqZYuNtjBy48qIWkWOP4jB3gKa6xMWhc8d0ha311/rqMpBdLgnSyB2fvZV3CIlLxobSYF5VrHellwZFD4a85dJ1g/Dcv1Jpgfz6AVDcNlOSwhH91D8diF7s0fJtqvLnDPkQ/cX5WFV+OrmLTPd9vCYVnkKI7q3gD5g+M44tyBPOVLu1WvXTd3nAxbxcpNsHu6agmRQvSA9BsdtJG9R7pVV2T/r60Wm2wy10JpnYbddoF6rsgD+5Pjy6jUvhx5nBBPjm2HeGaRwDoqFZ9kc4qBNQQE4itKdLRMx2TSl804Oph/5vwfDT/PxMpzdYNuvqsJtvHnZgBsaA3s21vlEtuUjb4+oRt5vaHLKy/XNVvco28oIIBk0Jj0PJfRj2y7LvFgEtrakrfsEW2MeJLn2mXCKBo99PUebW1eg1T4z7CPMUpWMZq013iBdMIOfCh+ALi4hVXUsvWYo5Xtzi0SpTmJO4slCDn7dpl4tt0P18hzVM0B9oscvUHekeCO++QOY39QANtxn0yJBFjMrzvlcyNsCG57leWGsR0Exslooo76Vwb7mxmO+uA5ddpV7Uv4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(23010399003)(82310400026)(56012099006)(11063799006)(18002099003)(10067099003)(261009223027099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261102123227099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	30muaqj91j86JpfEpDM0BcvOZlsCgrUD6dEPXgBj51Qn/HaIXQDVtchZTaPfvzyc7TZ7RhYOiXjMlkBSykEA3+/3g0PtPoIohHJ+QP3vqcgwxv6Hv5qx/1k9wZ3rPzCtJsGbfLU1JFTcWlMMYk3SUTUYOU3Ak7Ozk4er0mKGURlaUw5Vf4lWKBQfkZtLLtb47lrkaQF2yiNJVxhR5rp7y1Zc6EFw33ac09JtvMqRSRMrXiX5MYagXc/BhhsZOb3U2aQQVr/Zl7GzfgPXB1uCgmnAjyRi1fLwqiBBw2YwYAaAJ2jVJnYIIiNf4t0ZAsuYDOGm3Ntfq7HGJqNLOe3/BGFdT9amiyzhHPxFp+8eygkyxchyRZv+XVmi/MhaLMNfIUxUW5uI3xiFJQK0GIzqiGiAt+aT553jXTwgZeoRmy69M/gDZUYLD+vEjNy4y+rJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:22:52.3972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d50da7-d457-43a7-a4cc-08df4199fc0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002323.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564

From: Shay Drory <shayd@nvidia.com>

active_port is a bitmask with a bit per LAG port. The cited commit
enabled 8 port LAG, but active_port remained 4 bits wide.

Enlarge active_port to 8 bits, as defined in the PRM.

Fixes: e0e6adfe8c20 ("net/mlx5: Enable 8 ports LAG")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 697fc9387b73..37b6e47c9091 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12453,8 +12453,8 @@ struct mlx5_ifc_lagc_bits {
 	u8         reserved_at_18[0x5];
 	u8         lag_state[0x3];
 
-	u8         reserved_at_20[0xc];
-	u8         active_port[0x4];
+	u8         reserved_at_20[0x8];
+	u8         active_port[0x8];
 	u8         reserved_at_30[0x4];
 	u8         tx_remap_affinity_2[0x4];
 	u8         reserved_at_38[0x4];

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

