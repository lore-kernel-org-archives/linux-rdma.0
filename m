Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724150;
	b=TNVZuqwNWX3pkKCpnptZGFJ8e72QJxWbdwrZzp3Q25QFa5s//nltcXpaK/HeRELUpDqn
	 wo20xckuqvxPY2YgJBTWFkQJlIMz2vuCNPz7al0F/yL1dOKkJ44L+v5P5Dm1SVEOi0T6u
	 eVH9w1H9CqJRdW0k/ND8MtUpeRngGU0nOW6SzOfPnNf3pAW+A9MklxiHEdEaY02nBV/W3
	 Eq0H6fmo8bUSh/tZV2xhgeiSQXYKfn32ADkwnmREJrR6saIRYQfYEU7ki/MOj0kLsQEp3
	 ETRf+W1pZAni19Qv/XYaQ0+K02qmxlEPk8ZcqNazDJdGzTCA/9Wek44v1Gg6B0kMEMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724150;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=qsaQah5zFuwjMufiNHwYYQNA+mOqdWDYet04NMrCGxY=;
	b=P+RhfMhh7hRl6Ak4GgGzWWOW72+LJcOUD8e5OOPox1FrgxXdtzXY8jxWmVP8YdMk/nLo
	 vBwsH086AKIxnGwfmSXzd5682i5377NXUI4L+MFg6NOvTyIWkqEL7fPANkIEOVgEywsI2
	 bCm6FDKP8a2t7+5G18A962pbPDZ5mT+poVCk0V6UMA61M6NKkGPpjqKpaCI7rIeyRFB4J
	 hPkctsHLlE8UEFsOA6khL9dNXZUAgY5avwo8mmMXxaBpyOonxGEB8T/pawn9CEza3WteN
	 CY1z9sa/ubYcUzcka7O0gJlu29qR+ZjsQiy7+GlA368hPCePsyhT0lZPi9+DRVBBnJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YrqsCQa3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.16
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012016.outbound.protection.outlook.com [40.93.195.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A516606D814;
	Tue,  3 Nov 2026 16:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A516606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YrqsCQa3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rv8iAjkqzBR0kJVBO34qFRpZfkanfBPKIJ5IRC4Na5O51mFO1hedx4Mlr6CKYCmsi469HdA6HExBqEvA3OH1Q7SdhzTl1ZLSjAe+vBjk2i4Rrr9BvyRmSYO8llBxHJiYFp+Mrvjc77X/bxjxeLrvBh1aLhn147tcYHHB1wpjAQJLEdguW1FXah+f07CE2fEIQqrjNENGucvZ3mo7t9BBZwWF+6L3Rk+n2f3J9ckH9NclxbC4/gdmh1fepTz/qCzdddZbW1gpiR5INlF4IBAn4OJtxz7vM7gSLPDiD+gWKv6o6Ec101dact2DT8qeuy89ir7KMjVioPPYrJHnZt5f4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsaQah5zFuwjMufiNHwYYQNA+mOqdWDYet04NMrCGxY=;
 b=s+5eIXU+4mPi22H7ClADjRWd7CY9oPt9PlHQWgkK+03wv9Ptp3Ok898+9DpJmNmP88mqzVSif59YGKSYc1LIhiTRc0giH2XvXxQesA5JTjKAIGSw46I4QUJzA8kj3lIxm262O5c+Q4GLQslParieeUJ/yXOs3LK00JV6tA5YeGlUpc6AHG76Y9FxhKb0+H8AshPsgNcm1hHybsCXfnmzaxm90a2c9IuODqC7x5MtnGl3nVVDCWou0ie+D+O5KnMOU4F3O4u+VzjckwMB1qm7FkzO9dKcLgsNnOcOq0kl9KtrrbhQhX6UG9rerP+BRZZF7h2fL9OAEpFUXzNNa3hUPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsaQah5zFuwjMufiNHwYYQNA+mOqdWDYet04NMrCGxY=;
 b=YrqsCQa3omQfOJE99xcEP9mf5CTcwSPIB4FAauA7CJrRXalM/grlE6YmgnlcoZ5McCD+7JTeyqXMziTrPj+ZcvuwoyaHzQVki3fNSVNHqatL7K41vrquB9jdYZtJEBhPvo+zpX8wMwpjl5r+g6io0CteGtEEO9igjAAz58halcIPMSRy+WfbIcmdNf2/b8POW/RjpUi0j5h9VA1tFwK/49eYmc46IpkF4GR+TZ2FQojrBYf1LzOQik7nPfd+H/tpn/MUHUrLsBjoyNb3R6MIBWk8YbzQaQIiM5zy8l/Adfq36bE/5MeMYcqA5nOoFAeItQRgjxu0JFhY8aUuTHIJaQ==
Received: from SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::19)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:42:15 +0000
Received: from SJ1PEPF000037A9.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::60) by SJ0PR03CA0014.outlook.office365.com
 (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037A9.mail.protection.outlook.com (10.167.244.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:56 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:56 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:52 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 21/23] RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
Date: Tue, 3 Nov 2026 18:39:47 +0200
Message-ID: <20261103163949.1554-22-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A9:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: ce111b69-e2cd-4017-b61e-08df39c96aa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|6133799003|10067099003|22082099003|18002099003|261102123227099003|56012099006|261026121527099003|11063799006|261021121427099003|261022105027099003|261009223027099003|261021135927099003|261028144727099003|260925021311599003|261022075727099003|261026140227099003|261021123027099003|260925022911599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	atwGmjs69qn9imr5r8pHGLjxYrAgItlD8ExZ6SHCL3jTwO34MEH1uT4Uj5x5gGrEl+R3L27ugW0OpccOPX3kWpVzJdaXnDUqNpjmEUPSW3Bn89YLJctwAMdwL6EmDqlfjC+/f7kTWNIn8rlA/M7HpjCYb1v/CBId7JGv8ij5AHEU+k9ch0D7S4Nk+JlhisFZ+LeKdyqppaPHAAy7ydPob3vp+TWBKIfBDkSWrhBaY+fybDBtJdVxoc94l2D4CHiEjPDJC5RtR1pgAwjCgzMzzLCKrN84LGG4+7jyKiwth6qL+j4+1MMJhdia+3DNMGTrkkcKGctRxAIQnwt7OH9SHhVk8K8azjAUXs0MhgjG/ZZ0RE+ujKjLLn545IHTSc41LBklwj54drCjU/UqBcy7o3JsCGT/d8+t1WWb5iDU3v7DIP/lmWyK9ID53P6nGA/sFkFp0pZnEwcOTtmORfT5hlN4jD3vBKk9VeCPLv0tDzC0HAZyp/qgcuXAII9gK4swpUX/9u4J6JwRPmg5SLGS49RJA5v7h+jO87mxktj96/6ijEe3nuh80c+hcRuCrFUbgprRB5VN8CSU0ob6rEODnJS0tc0WDE3vNY1Xp55gM+iExferAxqijKLq3+alqCDb9omuqFJfhxZNgb/pRMB9Pg8kLwqynhyUfv9j4iM4+caDm+bPOyDE5M3o41S9Uap3iGl0vQ+/MO8PU7iNLLN1Uw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(261102123227099003)(56012099006)(261026121527099003)(11063799006)(261021121427099003)(261022105027099003)(261009223027099003)(261021135927099003)(261028144727099003)(260925021311599003)(261022075727099003)(261026140227099003)(261021123027099003)(260925022911599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cuNkF38qJDWTkjTfrDL39oibg6Wag1pHnQqAlcEkL+Oko4K7ELOaML7vngp84zQQ4imtMFtOsnTqncVaxbLvJStsffN/wjaUd+/CenbO0ALJ39HsECPNHDh4Rr0+zvHbex9nrvCF2TKFWu3jdUajSg46mTyE65XbqFujkYm7eKb/i/dGoUU6YVYTrt4tgcoWFC7domptsQ7XB62GjBdaJGC9+P4D24U+siEoxh8JzuKUUZwAcXNJMKNBGQx+7Hqy+gTQqZxGMfg3PrauEK6GPyeGWv1W3S+kIwrtgrI+zw6hk/JKAAETUHdrEftzLl2uVuce566tVaF6J5/DTV2rPgd0UreNq41kAGigThw9zG7MjtBddK5rgXh8/WPPr1owbr3162yN8gi9WQEwQkzFU4GzyM3uQ3mAwSAp5YfQF4mrvGgFmoWTgadQTh28fmid
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:14.9238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce111b69-e2cd-4017-b61e-08df39c96aa8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972

The device, port and ucontext attributes and the SRQ size limit are
computed as 1 << cap from 8-bit log_max_* FW capabilities. An untrusted
NIC can report 31 or more, which makes the shift undefined. The same
applies to 1ull << log_pg_sz with a value of 64 or more.

Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
values. As the limits can now reach 2^31, compute max_qp_wr in 64 bits
and saturate the max_res_rd_atom and max_total_mcast_qp_attach products
at U32_MAX.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c  |  2 +-
 drivers/infiniband/hw/mlx5/main.c | 63 ++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/srq.c  |  2 +-
 3 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 8925331855ff..cf9f6a4d5ccf 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -629,7 +629,7 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u32 port,
 	props->phys_state	= out_mad->data[33] >> 4;
 	props->port_cap_flags	= be32_to_cpup((__be32 *)(out_mad->data + 20));
 	props->gid_tbl_len	= out_mad->data[50];
-	props->max_msg_sz	= 1 << MLX5_CAP_GEN(mdev, log_max_msg);
+	props->max_msg_sz	= MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_msg);
 	props->pkey_tbl_len	= dev->pkey_table_len;
 	props->bad_pkey_cntr	= be16_to_cpup((__be16 *)(out_mad->data + 46));
 	props->qkey_viol_cntr	= be16_to_cpup((__be16 *)(out_mad->data + 48));
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c29102260989..ace4cdc95c9d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -599,7 +599,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 		props->qkey_viol_cntr = qkey_viol_cntr;
 	}
 	props->max_mtu          = IB_MTU_4096;
-	props->max_msg_sz       = 1 << MLX5_CAP_GEN(dev->mdev, log_max_msg);
+	props->max_msg_sz       = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_msg);
 	props->pkey_tbl_len     = 1;
 	props->state            = IB_PORT_DOWN;
 	props->phys_state       = IB_PORT_PHYS_STATE_DISABLED;
@@ -930,7 +930,7 @@ static u32 mlx5_ib_calc_max_sq_overhead(void)
 static u32 mlx5_ib_calc_max_qp_wr(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
-	u32 max_wqe_bb_units = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	u64 max_wqe_bb_units = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp_sz);
 	u32 max_wqe_size;
 	/* max QP overhead + 1 SGE, no inline, no special features */
 	max_wqe_size = mlx5_ib_calc_max_sq_overhead() +
@@ -940,7 +940,8 @@ static u32 mlx5_ib_calc_max_qp_wr(struct mlx5_ib_dev *dev)
 
 	max_wqe_size = ALIGN(max_wqe_size, MLX5_SEND_WQE_BB);
 
-	return (max_wqe_bb_units * MLX5_SEND_WQE_BB) / max_wqe_size;
+	/* Up to 2^31 units, so the product needs 64 bits */
+	return div_u64(max_wqe_bb_units * MLX5_SEND_WQE_BB, max_wqe_size);
 }
 
 static int mlx5_ib_query_device(struct ib_device *ibdev,
@@ -954,7 +955,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_sq_desc;
 	int max_rq_sg;
 	int max_sq_sg;
-	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	u64 min_page_size = MLX5_CAP_GEN_LOGSZ_U64(mdev, log_pg_sz);
 	bool raw_support = !mlx5_core_mp_enabled(mdev);
 	struct mlx5_ib_query_device_resp resp = {};
 	size_t resp_len;
@@ -1000,7 +1001,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, imaicl)) {
 		props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
 					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
-		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
+		props->max_mw = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mkey);
 		/* We support 'Gappy' memory registration too */
 		props->kernel_cap_flags |= IBK_SG_GAPS_REG;
 	}
@@ -1033,7 +1034,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (offsetofend(typeof(resp), tso_caps) <= uhw_outlen) {
 			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
 			if (max_tso) {
-				resp.tso_caps.max_tso = 1 << max_tso;
+				resp.tso_caps.max_tso = BIT(max_tso);
 				resp.tso_caps.supported_qpts |=
 					1 << IB_QPT_RAW_PACKET;
 				resp.response_length += sizeof(resp.tso_caps);
@@ -1100,7 +1101,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = ~(min_page_size - 1);
-	props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
+	props->max_qp		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp);
 	props->max_qp_wr = mlx5_ib_calc_max_qp_wr(dev);
 	max_rq_sg =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 		     sizeof(struct mlx5_wqe_data_seg);
@@ -1111,29 +1112,31 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_send_sge = max_sq_sg;
 	props->max_recv_sge = max_rq_sg;
 	props->max_sge_rd	   = MLX5_MAX_SGE_RD;
-	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
-	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
-	props->max_mr		   = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
-	props->max_pd		   = 1 << MLX5_CAP_GEN(mdev, log_max_pd);
-	props->max_qp_rd_atom	   = 1 << MLX5_CAP_GEN(mdev, log_max_ra_req_qp);
-	props->max_qp_init_rd_atom = 1 << MLX5_CAP_GEN(mdev, log_max_ra_res_qp);
-	props->max_srq		   = 1 << MLX5_CAP_GEN(mdev, log_max_srq);
-	props->max_srq_wr = (1 << MLX5_CAP_GEN(mdev, log_max_srq_sz)) - 1;
+	props->max_cq		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq);
+	props->max_cqe = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz) - 1;
+	props->max_mr		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mkey);
+	props->max_pd		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_pd);
+	props->max_qp_rd_atom	   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_ra_req_qp);
+	props->max_qp_init_rd_atom = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_ra_res_qp);
+	props->max_srq		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_srq);
+	props->max_srq_wr = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_srq_sz) - 1;
 	props->local_ca_ack_delay  = MLX5_CAP_GEN(mdev, local_ca_ack_delay);
-	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
+	props->max_res_rd_atom	   = min_t(u64, (u64)props->max_qp_rd_atom * props->max_qp,
+					   U32_MAX);
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len =
-		1 << MLX5_CAP_GEN(mdev, log_max_klm_list_size);
+		MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_klm_list_size);
 	props->max_pi_fast_reg_page_list_len =
 		props->max_fast_reg_page_list_len / 2;
 	props->max_sgl_rd =
 		MLX5_CAP_GEN(mdev, max_sgl_for_optimized_performance);
 	get_atomic_caps_qp(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
-	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
+	props->max_mcast_grp	   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mcg);
 	props->max_mcast_qp_attach = MLX5_CAP_GEN(mdev, max_qp_mcg);
-	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
-					   props->max_mcast_grp;
+	props->max_total_mcast_qp_attach =
+		min_t(u64, (u64)props->max_mcast_qp_attach * props->max_mcast_grp,
+		      U32_MAX);
 	props->max_ah = INT_MAX;
 	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
@@ -1167,19 +1170,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (mlx5_ib_port_link_layer(ibdev, 1) ==
 	    IB_LINK_LAYER_ETHERNET && raw_support) {
 		props->rss_caps.max_rwq_indirection_tables =
-			1 << MLX5_CAP_GEN(dev->mdev, log_max_rqt);
+			MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_rqt);
 		props->rss_caps.max_rwq_indirection_table_size =
-			1 << MLX5_CAP_GEN(dev->mdev, log_max_rqt_size);
+			MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_rqt_size);
 		props->rss_caps.supported_qpts = 1 << IB_QPT_RAW_PACKET;
 		props->max_wq_type_rq =
-			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
+			MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_rq);
 	}
 
 	if (MLX5_CAP_GEN(mdev, tag_matching)) {
 		props->tm_caps.max_num_tags =
-			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
+			MLX5_CAP_GEN_LOGSZ_U32(mdev, log_tag_matching_list_sz) - 1;
 		props->tm_caps.max_ops =
-			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+			MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp_sz);
 		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
@@ -1503,7 +1506,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u32 port,
 		props->port_cap_flags &= ~IB_PORT_CM_SUP;
 
 	props->gid_tbl_len	= mlx5_get_gid_table_len(MLX5_CAP_GEN(mdev, gid_table_size));
-	props->max_msg_sz	= 1 << MLX5_CAP_GEN(mdev, log_max_msg);
+	props->max_msg_sz	= MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_msg);
 	props->pkey_tbl_len	= mlx5_to_sw_pkey_sz(MLX5_CAP_GEN(mdev, pkey_table_size));
 	props->bad_pkey_cntr	= rep->pkey_violation_counter;
 	props->qkey_viol_cntr	= rep->qkey_violation_counter;
@@ -2127,16 +2130,16 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY;
 	}
 
-	resp->qp_tab_size = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp);
+	resp->qp_tab_size = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp);
 	if (mlx5_wc_support_get(dev->mdev))
 		resp->bf_reg_size = 1 << MLX5_CAP_GEN(dev->mdev,
 						      log_bf_reg_size);
 	resp->cache_line_size = cache_line_size();
 	resp->max_sq_desc_sz = MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq);
 	resp->max_rq_desc_sz = MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq);
-	resp->max_send_wqebb = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
-	resp->max_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
-	resp->max_srq_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	resp->max_send_wqebb = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz);
+	resp->max_recv_wr = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_qp_sz);
+	resp->max_srq_recv_wr = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);
 	resp->cqe_version = context->cqe_version;
 	resp->log_uar_size = MLX5_CAP_GEN(dev->mdev, uar_4k) ?
 				MLX5_ADAPTER_PAGE_SHIFT : PAGE_SHIFT;
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 6a4a937d97ce..3fbb0eaf1255 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -198,7 +198,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	size_t buf_size;
 	int err;
 	struct mlx5_srq_attr in = {};
-	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	__u32 max_srq_wqes = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);
 	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
 			    sizeof(struct mlx5_wqe_data_seg);
 
-- 
2.18.1

