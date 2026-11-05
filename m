Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913459;
	b=qlF5wTx0un+Yprc82JyUg8sf5W9DQXO+qvoU/FJcepI5XLtVe5xinUVnBy4lxq8MWnIe
	 DQ3WI+Sw2gejIwW697dRub8Cm+5YaSauJwkSN0DvDeobkB76xt5No9LFVNnawNDt3Gbta
	 Xo5fYmnVAISQYq+Z8Mkvyejhqi/zzPJFu9dC9GGV0dxVoW8RxY8r0t1UzVSXwv+Y6zZ4W
	 ZY0b0pu6Y3798AhUlZBoeda/P+w8GSmavkzUBw1zUFhAzPZUwlHHeM7cPpKAfAnFtBch5
	 2dNlqTbfzKSqP3CIyD/VyNJeENzfdleJCPUJdabtPPtNOW+wGXVklgfz0dDKyRJpB6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913459;
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
	bh=WDCMr7D7H+hnRy6Hx7D7IU0YogpJvB1INW2oxBpsZOA=;
	b=HOisCjhjFUUjf/oQkGa1ScPoccjC1TH3/iciNRG1pYsRA9sC9oIzVBy90ZKT0vjp8HLX
	 WwLHnq+HqvjasaVxuXSkTOWRpcf8UMHebcG9q4SVOJBWBX/y20/Dvpd+vLvFYLY9GsCNv
	 4psFFs8LA1bMBzF3NlkmjYozsK77fnpwTzLuNp1C3E5IOrmjHElWUEgqAmZ+NphGk7CP5
	 9XMfjIzas095Igs9KvCX5e8pufYoUEqdeh5S/2Ficqj/p6ywB4zHSTMw3ksaBYGDlUyoG
	 1gnU8AzsydpLl/F1dTNgNDKywDck4JxKZvFO/bDPHcwPjgc9EgfUWXrK+b6JiFh12WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="p2iumcs/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.21
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54683606D806;
	Thu,  5 Nov 2026 21:17:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54683606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p2iumcs/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6rpsb9RUm2+bgyE8+AYJp9Pb2hg1sa2h7xXaM7qlM9/cgKG44Ah1ybV7hMEQLAdu0kQXAuOPDmbQSxkORHTfaD4MvSa/5WTHkBVH059kQvv34zDYs5bLixMSrwYJeXPupykL0Ge21JiIMXtmKF3p7lxZx6kN96Q7ZiDcrdseio+jCTQeRtBxbEQjCTaAb+QWjQce656hLPvUmdjJl7Xm3yI3/O2QpCyav+bZxJxK56/RgSP1xc9NAAAgWjI17PEHTclmuUjbEdgVLPItEUqk4MkC5K/BFOrkO3DShZzDqNOxuQy2J5HEAHQoNa8rma8NHYVWLExZbgxB1B2rVzSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDCMr7D7H+hnRy6Hx7D7IU0YogpJvB1INW2oxBpsZOA=;
 b=F4r/1D9OmrMAZNVsGkfgCU4kq1hh2InDJTiIZNjerM4hEl0hzlV/x39hOMdNNe9YSecgCnTBjfx+8SxB+Pg5ln/Oc8MuOBLfzVNdxf97R+4etXsrWOIkLaP5E1cAhXEadVPFiyP412KL+yPgFOaHbUA30KLGtIqQAPhTG87fycu9pKwG347nKxxJOUldSkso+LowhPlTcp8V0OQuxSAJM2Dr8eHZifuNSUhWl0D7BoWShclb0T8Vy4bLK8gi/kbvYOYrfuiqLzULTkBgiDO7igJMgK0WIwoKQnXBVWm4qu+JhRUoWEt903bzAPydtMVW9cXJW4R7r4564vjceRrw/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDCMr7D7H+hnRy6Hx7D7IU0YogpJvB1INW2oxBpsZOA=;
 b=p2iumcs/rkCig4q66V5sH4T78fJRsz/DVIXQD265k6HMOsUdN7MwLE2FhMAnyQirSrN88IkziuL+l1xB/+Kvza4tcvrCbiR+Xw132tpAJGy1ALocpp+H0P3DM/hlCe+V1HY6gRuyYXdWtZUZ7KwOlKAXzoQnm8po9XsKV7zVDzEVB9Wjh7apoRjcoZpH8VVyUMtbzVjJYWwmQT+bNAMEQGpCMacD2ZZFkt7WLteMFmXsi+oYFnenfTw+IayAiHdwRO/k488spFQyw1RHI8o2QFeC04+LRDPOImXcBXJVTp94yXhTrl6sPv+u3SLBfjvKxsQ26bO3gAHYNyRkpN/ilQ==
Received: from CH0PR13CA0037.namprd13.prod.outlook.com (2603:10b6:610:b2::12)
 by CH3PR12MB7569.namprd12.prod.outlook.com (2603:10b6:610:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 21:17:32 +0000
Received: from CH2PEPF000166BF.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::4a) by CH0PR13CA0037.outlook.office365.com
 (2603:10b6:610:b2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4 via Frontend Transport; Thu, 5
 Nov 2026 21:17:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF000166BF.mail.protection.outlook.com (10.167.252.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:17:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:09 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:02 -0800
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
Subject: [PATCH net V3 1/8] net/mlx5e: Release IPsec root table reference on RX setup failure
Date: Thu, 5 Nov 2026 23:16:29 +0200
Message-ID: <20261105211637.1083978-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BF:EE_|CH3PR12MB7569:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae467eb-40cb-43c2-7d72-08df3b8233cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|7416014|376014|18002099003|22082099003|11063799006|56012099006|261009223027099003|261028144727099003|261026140227099003|261021121427099003|261022075727099003|261021123027099003|261022105027099003|261102123227099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ckCs3E+Ej+2qfx5xOd2FVIltV9fO9TGNiAQ5UVkErgCBU4LygKMjNYeVu0x69y4g+c4DGw5/zSLrRt9/ZSotzxEyW5+364oLpRfuMwjgF29w6hUfcCLmc5cbCDznpDviZngbwIRGU/YfxZHZwnGEknn09tg6P1Pdx4dJc5edcs+0W04c4aq77wxZwOE0RjtRg8kxqi094hIvdlDeZeJaVbyB1byEzlyEsvzkwjjl+KEAEWK1CslVY8u0jVZPbcHORquB0+EkK/g+wZB6JrGGBUnrbEll9DFIPsvnJIY/d6ICDT25o1gC+d+vWE16DjLdGo94Tx/xOHfg6cmQl+Aqmv67JSNIcNpUTqOn/hjH7ctvLz10rcoXefP/ywy4FJcmehqJfRyOKX8oRQbUkAQVqR+hoXoCrF5MWip2x4HPhS7LGkYS4mLBV5CSA7RCVw00LxdQhtd7CYBJdz/AO/u9tedGnCcXvyG7zm11wTYhDX69mYYJBuXTXTjmqtxvsX6Olm22qGcFF4BVP1Nevc/xSgnVxz2yQwzKF/oz4hva9rMMrq1g5+wYop294YvQuuvZQDZzOqliu13tAjSPJJiNy09/SZRkBMy7lStP7q+8S9aHwGVYh4JMa3nVWgMAne/a8u38Jo5V1nG1L77i1P/4rMa6O80F3buAB583uXOumYVl3fK31sJs+NM5chyqh6P4F65fthBUBe03s2bjS1C1pw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(7416014)(376014)(18002099003)(22082099003)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022075727099003)(261021123027099003)(261022105027099003)(261102123227099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OeU9+TTcIeR/OKrb+kCxcqtWz9v0tLmK40E5OBNJzGko6wlTvsKMDktBw6a2B+5dceFjr6ebTNfXPYRQcNmRd61GftKzkBPTzbEg8wnVrWIsc6h31FcQnNmTX/xgtGlMu8kJuC3WIrzMFO19Ru9Btg1C0kjPupOFPZAx49cPg5nX3eJlHwN3nYBbK4QiP7omzFCO6p1jE4Cxl+8nBEFv7Rtt6ivlIvJbvxrCRXceTrVpfTWoN/KnNC0e2VPSVcOrrH25Q0fGF07hgOxN+NXbhVGoU7QGYb2MaYoXCoZxLx/LX/ddrTkNSydLwe3RmpWmNvWlo3V0GxiFoA7Ggrq4RIcLlPhf59A+TFJCpLx1g/TU5Fh5k30shB6Ew5Xm9bDHiMqwTfhrFaT7p7Y7dMzu9LPtzMg7RO8LqbKDOBJWw1VfSUML1zskfNnbqAIfMz8B
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:17:30.9324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae467eb-40cb-43c2-7d72-08df3b8233cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7569

From: Cosmin Ratiu <cratiu@nvidia.com>

Switchdev RX setup takes a root-chain table reference before creating
its flow tables. If creation fails, rx_get() returns without
incrementing the RX reference count, so rx_destroy() never releases the
chain reference.

Extract the cleanup logic in a counter-partner to the function acquiring
the root table ref, and call it on error to properly release everything.
Also call it from the normal destroy path to reduce code duplication.

mlx5_esw_ipsec_rx_status_pass_dest_get() ignored chain table acquisition
errors, returning success with an error pointer as the destination. The
new unwind could then release a reference that was never taken.
Propagate the error so cleanup only runs after a successful get.

Discovered by Sashiko. Not triggered as it's an unlikely error path.

Fixes: 1762f132d542 ("net/mlx5e: Support IPsec packet offload for RX in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 20 +++++++++++--------
 .../mellanox/mlx5/core/esw/ipsec_fs.c         | 15 ++++++++++++--
 .../mellanox/mlx5/core/esw/ipsec_fs.h         |  6 ++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8ffa8068e90a..fd9fbf359333 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -720,6 +720,16 @@ static void ipsec_rx_sa_selector_destroy(struct mlx5_core_dev *mdev,
 	mlx5_destroy_flow_table(rx->ft.sa_sel);
 }
 
+static void
+ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec,
+			      struct mlx5e_ipsec_rx *rx,
+			      u32 family)
+{
+	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, ipsec->mdev);
+	if (rx == ipsec->rx_esw)
+		mlx5_esw_ipsec_rx_status_pass_dest_put(ipsec);
+}
+
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		       struct mlx5e_ipsec_rx *rx, u32 family)
 {
@@ -739,13 +749,7 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	ipsec_rx_policy_destroy(rx);
 
-	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, mdev);
-
-#ifdef CONFIG_MLX5_ESWITCH
-	if (rx == ipsec->rx_esw)
-		mlx5_chains_put_table(esw_chains(ipsec->mdev->priv.eswitch),
-				      0, 1, 0);
-#endif
+	ipsec_rx_status_pass_dest_put(ipsec, rx, family);
 }
 
 static void ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
@@ -1115,7 +1119,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs_ft_sa_sel:
 	mlx5_destroy_flow_table(rx->ft.status);
 err_fs_ft_status:
-	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, mdev);
+	ipsec_rx_status_pass_dest_put(ipsec, rx, family);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index ab50d2c734ed..f8c97954b6ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -34,12 +34,23 @@ void mlx5_esw_ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
 int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ipsec,
 					   struct mlx5_flow_destination *dest)
 {
-	dest->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest->ft = mlx5_chains_get_table(esw_chains(ipsec->mdev->priv.eswitch), 0, 1, 0);
+	struct mlx5_flow_table *ft;
+
+	ft = mlx5_chains_get_table(esw_chains(ipsec->mdev->priv.eswitch),
+				   0, 1, 0);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
 
+	dest->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest->ft = ft;
 	return 0;
 }
 
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec)
+{
+	mlx5_chains_put_table(esw_chains(ipsec->mdev->priv.eswitch), 0, 1, 0);
+}
+
 int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 					  struct mlx5_flow_act *flow_act)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
index 514c15258b1d..bb6f2423078b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
@@ -12,6 +12,7 @@ void mlx5_esw_ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
 				       struct mlx5e_ipsec_rx_create_attr *attr);
 int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ipsec,
 					   struct mlx5_flow_destination *dest);
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec);
 int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 					  struct mlx5_flow_act *flow_act);
 void mlx5_esw_ipsec_rx_id_mapping_remove(struct mlx5e_ipsec_sa_entry *sa_entry);
@@ -32,6 +33,11 @@ static inline int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ips
 	return -EINVAL;
 }
 
+static inline
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec)
+{
+}
+
 static inline int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 							struct mlx5_flow_act *flow_act)
 {
-- 
2.44.0

