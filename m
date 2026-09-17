Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA94F93BD;
	Thu, 17 Sep 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668677; cv=fail; b=iTdC4tMNQKF/7++YQYSI6rXivo2WUNbt8reqBOHT86Npsdgplm4fXHW9/jBSObXA+8Yz8DTJDoh6No2KCqxNP428eVy5BBCuJUKgXAk++fBWlxfBVT4bmTwdBQHa49IOzevH+SZLD5anRBadNQHijUyNumJCRR0ofD8ipTNf01c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668677; c=relaxed/simple;
	bh=JY+425xCMi47BtA/EI1b8bFmU9+6jdynEQH6uhqDqVY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCbAf2GhIg5OaGG6bFCbTYhCKG2Osn5C0hczaZ/RNJxk+6XEBcnnXOaa4R3Rh/S4BFiDUXUlRdQenmOpRIJ2RLsQdIq7H38y5jj9JPzZYlw8yZBlJPKzrKJNfP9C+1VIUI8T+L4TsGdNa0lfwlYi8MEzSJuvifpFFCARsyrXvX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F6iPhFg1; arc=fail smtp.client-ip=52.101.201.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F6iPhFg1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFF9vEh6z4zfSq8O2eRJ4Ig+iH9mKSqRJ3YinB3MjM00QfsyXaxp1JpV1NKIVlQgZmRyuDRQP4bRsl/Wuw3ALGl+/hkwHklzv0U8FAx8uCP2ags9Qm+CM6xVkklU39jV7Ho078Z6CG9W2oNCi5swOQltN9iHjVMUvUTqqWjQPjNlw2YqlozomYv4JCThheDrFfxQm23ZzTg6nHXZG2OjOLF+fWRgl/aUekU+wWTSucMKT4vet9of9jaateLa2YfDmHMgiBPFAAOm4+3F39eEwgI9yu6+M/wYzSQxSG62OVqnYPVxDOneRReONaJy7laHE+AVpjxUhM+Rk6iRWNmx9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WSRkB9p7B1WkV0ZDmZT74nZ6lsqbxP/uKjSV608p5M=;
 b=v4clwhQnBJf8el+zyvzoxX/ap7h1wbv5x5S8udR2+6RFQ3zjDtKINZapzNUwX/qql8wiQ5EGO2QtKXLH7YJRcBnV55HsQPdfGvT6wz4/3rJuAyth4VgMWsV9jQhaXnHngIR1bw7H3knWo2xhWRcSYFjHWDJaRvA7uERs2ppHOUbBEyy33VVzm9n7DYMNPfXyJ7VhQ3mXdKGCLc0UjfUphL0zVCV/otpQ/ulk90oHeVgo5xGOTkVAZ1iWc0K1BfctkTUFhXFPP4EWlengEurD24Z8K4X9yw1abM42eUabVxVZtBHfnYFVXaKjZgNMs77Hi7EX/VTmrQr6phmBqSdNPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WSRkB9p7B1WkV0ZDmZT74nZ6lsqbxP/uKjSV608p5M=;
 b=F6iPhFg137SrpmL/KyqVgxAM5NAn7G48jEEDvdnRkju4ka3Bqjy5k+MblF4gYnp3+N6NhTOaTsa+wE5uDfJUd1s840u1E97IXd0R/u+bgK/agksv6zCIspu81jVQlJamarZBzNJoA/ZR85jEsoIkmO5Q4sG+IZiAIJcUgEhvBBAWxkS/p652bwA9z+j5FImEGx42mLdYE9rTpohKzSzF7nOGoBh/Xo2v3Y+N6NBUPzeS6g69NG1dpJ4UKyWdyZ1iC2VI0EghhQ0bb8UQBtMDlKz2fAPS33164wZrrOqlgyIxTGFLHHIjHBz6lbjPeu8Hm8e4lHFLwMOOzXKFVgZ5CQ==
Received: from MW4PR04CA0188.namprd04.prod.outlook.com (2603:10b6:303:86::13)
 by PH0PR12MB8824.namprd12.prod.outlook.com (2603:10b6:510:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 18:11:12 +0000
Received: from MWH0EPF000C6194.namprd02.prod.outlook.com
 (2603:10b6:303:86:cafe::8) by MW4PR04CA0188.outlook.office365.com
 (2603:10b6:303:86::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 18:11:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000C6194.mail.protection.outlook.com (10.167.249.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Thu, 17 Sep 2026 18:11:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:42 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:10:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:10:36 -0700
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
Subject: [PATCH net 7/7] net/mlx5e: shampo: Do not merge PSP packets
Date: Thu, 17 Sep 2026 20:54:33 +0300
Message-ID: <20260917175433.4090878-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6194:EE_|PH0PR12MB8824:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca943b7-7acb-4100-f664-08df14e70e91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jYmXe0XZLKsGLcBKHvYe/DXGU8ClOCRewjThWVEfEvEEslRNvzo2K591N0hksEAiMJLyXTTJn0PC+RRz39+p6DZOclvhuIQZvaFqov4ssvq+pc1Vzj4pG1VvxigF8dYTzC1orZLsfhSj0WHy29bDZAJmd3UWzz3r4AgHL+WY+q9jz4Q4+2qjnYQFECVS/9XvRIcWsv+sE9Cj37Uyn1MpTADNut3aRHoOON0mw6nJFdsN/Vj4dSW3m7OT7t6DQ487Cd+xWTHp5RJE+zkY6AJ7Daopu+pjU6Yx/A5rq3V7xHXO9hChjdt/R9hC27x97RfssxK/oer8ahGIHXt6moSBGy/nbvHGJKpwUA2b17MwDg2bVmSzVW/+BuEADgxDdtc1lyeTTAU/DduKz6UemiO/L1zoOw+516eJHw5Xr8yH+Gsgl+E5rRrMLd8vlnaNldH7Dd5z5eEuWUY/UTOpgtiyom0jTaQspgdZVjriAHeLxFaADOZr/v7ibuSDxxN+ivDLrV36zs/teN386al7iqqgs/YeiH5wGcfBl3RhVY/5tS6boufKqi4vKzuidF+BVs7vhnaCo30PTNH8AhOAdDbY9+VR2nDCwo89oSRZXc9piYd5HQJItjhIkPBvZ6xYvMOr4Gj2D6Wxwd7h2g5JmA2wnvXpV8fqkWPytiHpbRpHbkS5C0wpV0EZxssxpO7fCAzg27y5RqI+wto25E9iCmJYRA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Aol9Azlu4LWugktsICgqFVEKKCDEwhvWursCyLRgxC8XZhX38Fc7NjcpOmPnnJUSYRuISLL0f4pwG2qqw27QqVynZu6dDpX1Q5jnFbHDIQ9GoHBwsQCMsbPqPJOxa1dqWAVwnAQBRkvci54wvjx6if0K+hHRikHVDyzh43tCAOozqfVD/iQAgVCdnSbiHfCJljhDyXJRE0/RPb85YCmXKINet00cPuspQdgYf/xazFcdoLLV1+E2KSYZMBtZCEqyXHI4Jmvmmv4v3ApLqMCFBs9oRcWT+BioBDa2VdVvmu8ykgTFZ0KshEsiTPAWfhoYC0CDoWesbvj23hQQF/ssdxf9frQczEW8mRkBUFdUBU7C2TFdlyim1p2q56xBaJLaSVzXCUO3geGhYn0Rkk/lK2TW/Gy1ka5VZes7CEx7n39B++InokPGMmoCIUq34W0x
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:11:12.2964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca943b7-7acb-4100-f664-08df14e70e91
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6194.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8824

From: Cosmin Ratiu <cratiu@nvidia.com>

PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
makes it possible to merge those packets in a silly way:
IP|UDP1|PSP1|payload1|UDP2|PSP2|payload2|...

That happens because the HW GRO machinery doesn't know about PSP and
considers it part of the UDP payload.

This patch enforces no match in SW.

Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7bd0606a5253..5e07cc8586f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2224,6 +2224,16 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
 		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
+static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
+{
+#ifdef CONFIG_MLX5_EN_PSP
+	/* PSP packets cannot be merged. */
+	return !mlx5e_psp_is_rx_flow(cqe);
+#else
+	return true;
+#endif
+}
+
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
@@ -2266,8 +2276,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	if (*skb &&
-	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
-							 page_size))) {
+	    !(match &&
+	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
+	      mlx5e_hw_gro_psp_match(*skb, cqe))) {
 		match = false;
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 	}
-- 
2.44.0

