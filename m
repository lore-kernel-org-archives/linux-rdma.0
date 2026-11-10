Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318351;
	b=0VPmC4Eg+gdpSE3nRjvdIjgk/5m36ZPmyOJFzt6KU9fBh3NL9b6QtACJbaQuTKzi1kTN
	 +YfIF0VMyZftBmCdVZ8Ys5dQ+HIUHDX75s1eTdLXLlNMOnn8BHoY4h2b8plAzND5UIzn9
	 L9dkZXuivnBbIq0GkafAuS0bsVP6/F+CzTXS+7ihGwVy6bZGJDEPGqhiW/dgiWzlrYMRc
	 gC4ZxdbcBq1/v7LdNlAlgZ+4qqhBZ9+QpIAlpJgsQMOgMH6AbJa5oXqXmUEla3EQuoQIn
	 SbxmiYAcBxOo/Rpo05yPmBZ2dQr2QKdMbPOIEL2XCD46r99+5VksUYcVYo5zQs3IvTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318351;
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
	bh=YkFSDakXKuU0qwSuS4b0H6rmmn99zTKB9VNq5AT2QbU=;
	b=gojMkbDbFdodnT/h5qktNoG6alXvJl88WIWWs/ofMOhF9wAmairOi9xcLfamsnRrayUB
	 fhTA+7BRPc+Oz0so46lSpN06TtGQcN5l+qJdx/W5vThk/8XhjznRfEtcM+a2GF+6uCpdJ
	 qUSppelepJBmtQjOdePPmWMRx+KxcO1YOuWH2ydfatBPpe0xaDRCQepC2Xq3dkVVgUeb6
	 B5jezk27ITiBxZxHvIPN/GeqUhG1cZvVfbkMXJ+3zcLnVQ28QNFDPEo1lmrTlgtJHw2kD
	 nXGtkPDZWBzROJWXRodFD+GhQBWo+jKIYfwhTNtKr2grm0UYg0qLa1HKxsy2AeckzMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eF2R7auK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.8
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011008.outbound.protection.outlook.com [52.101.52.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0E2606A321;
	Tue, 10 Nov 2026 13:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F0E2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eF2R7auK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXZCVVRgUf56VPEr2CtfGbFMoh2Im/TD1Hr5wPMNrYJw7aoDi42JWvqO196lFnULbtrKlX9sOcCBKb66IUhfHH2MIRWfmlNn2M74cImelQonZ2hvC4//6Te3+QQ0t3epiY7ZwbSTtqPA7oQYxodi/c6slftMvP4I55jej9/jPg2tuJKVQHBW3TAx9OBt5gcVmPcJjbult9pGK0GOyQLzOvn7tU7sJZtOnKm3nuTsiAFdMufFqQ0TW8D8596exjjs9My/O6KLwTLX9jF8NOlL06SHgvkim0aH5S2NRn6h0iI/SXw6Mg+eeLJYj9wXMmigW1IQXglkcQJmPe23QfpMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkFSDakXKuU0qwSuS4b0H6rmmn99zTKB9VNq5AT2QbU=;
 b=xEXyyQgGhcQ3Lzl4QNfwwXeWnPJP77/hU6GzuaT81+AIz7oQ2cZ5h5V01yHSXeb4cQ6poXukOmFU5AeRSLD+zaULumOHGZZ4qvlzuLcUzhHk0NF4Ycmru9nBZ1fEGU4SYWG55iheGPPMXSfLDvznRHhJ1Ihyzbhm09pN2Pvzk9kwil+yONmmkfPuJbaNxmhtVAdPgTQxOqbppXdgCYGXUcHVHL9Kd52AUdZfDHGSeIoqNv/U2Qs3kkCbKf8qritb642vk/U2InYfu/jEtUEZUFjmVHYPf6ZsYHP69qj5fO9Sd0s9sFMQTrWSRNLB9QM6gWBR02bu4U5zEb0+BHUMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkFSDakXKuU0qwSuS4b0H6rmmn99zTKB9VNq5AT2QbU=;
 b=eF2R7auKlv2RF+/sf+j3k4JgqCn50IXa6cUPCwrOroy5zj5Gx9ZbXlcaIoVE1CKYNyAj1GlaB1AtjSInu8bHGA4o9BCtc5ZIVby+fjes4kzQyhwQqRMfN4+/LU2Y8uY+xxy0p+Jf0Y5G7Jz6aTOx0T9CshFWmMJeDpW0o+o8uqFvwZglqke8pQtLuTpYsOS8shOES25jHu/J8Xpjc2T4YS4axoIzJOUdaRTBd+53OnLlT3tKLfaZ/h7rfPGE7TXtSUomMDWZtyOLpm6X1Bw+D/TzHkeNcsAQNK6MiBwwnxrTB69EpiQIzYaOpv2NEKcRe/Q9C8Vdb2xJmygfKizLgg==
Received: from SJ0PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:33a::27)
 by LV0PR12MB078426.namprd12.prod.outlook.com (2603:10b6:408:3b6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:47 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::5d) by SJ0PR03CA0022.outlook.office365.com
 (2603:10b6:a03:33a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Tue,
 10 Nov 2026 13:45:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:29 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:28 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:24 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 22/24] RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
Date: Tue, 10 Nov 2026 15:43:18 +0200
Message-ID: <20261110134320.34408-23-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|LV0PR12MB078426:EE_
X-MS-Office365-Filtering-Correlation-Id: a1787301-cdef-494e-76fe-08df3f30ec97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|36860700016|82310400026|260925021311599003|260925021911599003|260925022911599003|11063799006|56012099006|261022105027099003|261022075727099003|261021121427099003|261021123027099003|261021135927099003|261026121527099003|10067099003|261028144727099003|261102123227099003|261009223027099003|261026140227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	fxWyqjZXjSSt2MR299jQr4zIe3aD/DVXAJc+4K9FNqEtE0TRA4I95AAlDbT9VfG+G46M3h9kuD7cVaKSMQCUPJIfztvDJwEe+0nTCTq52XUqr4pgYvK2WFl8WJxDD+syIJbdpMxllPV+CXHSZ2g0S0MhwkqDsIr5S3hIEIV1MGnOPWy8YuhINKdeis4NzvUjJxK9lBN0e+U5ElhZWqu0jtMqPiJRi7x4JfFsyEWXLVB1Qc+xwjiyFzxm+BOgEjZrzFTz9ujyc+dw7Y0Y0m0DpkpJ2XnWr6O+GZinYFM+AZMy8Bm0Rg7agmmFBAoPAWWTW811hGsRhFFqVAKl5UJ9b4jA6IyLrh39joWYDxBabtAvblny/HSV59/EXu3w54DsZuUwcr11Xp5Ma5rYXn/pVieb7u+o4AUrbtxRtgMip1s5KzADZ5tp6nIbzXGs2k+56/ANn4Ho+2Qcl9lq4GaUR3hvZgTQS5vpRqfrOt1iTKUw4N+1BtyA971xQ1brD9Dy2A61OMPd/964V7zUI8QTs+u3p9OcZsy+AUan6/oRjfzQOixekklx7GYB9uKKqUkcbN0g+wtajph6lMCS4J14derA8EvZe+s3qRdx+HqQT2R1Xwg6Y+OeYVzYKZXYTOlkQZj0YPyaNnTp/NRV1fOahwiTg3YykzBykcnrS3rftpvwXjVmyQknzdhmaSScMiwEOLPG4AWaJ+kGdv8OY9OyDw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(36860700016)(82310400026)(260925021311599003)(260925021911599003)(260925022911599003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261021135927099003)(261026121527099003)(10067099003)(261028144727099003)(261102123227099003)(261009223027099003)(261026140227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YVFDFYZCANoJa4SjwZIgRSxiZTZECqyltgWIeAMTcmk03SBfVhHB4HqrE/mSFhZy4L6iZ/+3MQyZC4aFVjvkni7wwkeLhqx7EyUhB2eOD1cKokBOa8/4gc8eFOXQg7mfGcM1NBS6ZNZzTDIsxlyio8IN9avf3/9BhYA5hp0v7hUWD50lBD2sCKt+1Cjd4Tir6LiDSx/T3lsrtf7C44FLoRY+1Q9tdgZJdlsy+ZR8Q9NdRGzCG2i/HS8s2t7Pq3AfQjv+JwdA6JIYvnjCmSwW7e9+bWNR9s74NR6usPy9JbhI6M2PYT+cslCDYAMcGR47JvRAwwG/0+R0Divu2TUD+/La6KioEFIbACLfa/sW17MVS1tc4cTU/NHeN2KqcaI+sjbGJowu4Jw4kv06DcEJobhehIUkEJok5JuOQp2s2NtSA3WJUuRSQcTrojzWf49g
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:46.9985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1787301-cdef-494e-76fe-08df3f30ec97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB078426

The device, port and ucontext attributes and the SRQ size limit are
computed as 1 << cap from log_max_* FW capabilities. An untrusted NIC
can report 31 or more, which makes the shift undefined. The same
applies to 1ull << log_pg_sz with a value of 64 or more, and to the
max_tso computed as 1 << max_lso_cap, which can be 31.

Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
values, and BIT() for max_tso. As the limits can now reach 2^31,
compute max_qp_wr in 64 bits and saturate the max_res_rd_atom and
max_total_mcast_qp_attach products at U32_MAX. Cap max_cqe at 2^30 - 1,
the largest CQ size the create path accepts.

The SRQ size limit then lets the rounded up SRQ size overflow the int
srq->msrq.max, and the SRQ buffer size exceed the int passed to
create_srq_user() and create_srq_kernel(). Reject both above INT_MAX,
computing the buffer size with check_mul_overflow().

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c  |  2 +-
 drivers/infiniband/hw/mlx5/main.c | 65 +++++++++++++++++--------------
 drivers/infiniband/hw/mlx5/srq.c  | 14 +++++--
 3 files changed, 46 insertions(+), 35 deletions(-)

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
index 808c66c7afb3..df42a04799ec 100644
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
@@ -1111,29 +1112,33 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
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
+	/* The CQ size is a power of two that fits in an int */
+	props->max_cqe = min_t(u32, MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz),
+			       rounddown_pow_of_two(INT_MAX)) - 1;
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
@@ -1167,19 +1172,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
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
 
@@ -1503,7 +1508,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u32 port,
 		props->port_cap_flags &= ~IB_PORT_CM_SUP;
 
 	props->gid_tbl_len	= mlx5_get_gid_table_len(MLX5_CAP_GEN(mdev, gid_table_size));
-	props->max_msg_sz	= 1 << MLX5_CAP_GEN(mdev, log_max_msg);
+	props->max_msg_sz	= MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_msg);
 	props->pkey_tbl_len	= mlx5_to_sw_pkey_sz(MLX5_CAP_GEN(mdev, pkey_table_size));
 	props->bad_pkey_cntr	= rep->pkey_violation_counter;
 	props->qkey_viol_cntr	= rep->qkey_violation_counter;
@@ -2127,16 +2132,16 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
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
index 6a4a937d97ce..4bd04599d98f 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -196,9 +196,10 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	struct mlx5_ib_srq *srq = to_msrq(ib_srq);
 	size_t desc_size;
 	size_t buf_size;
+	unsigned long max;
 	int err;
 	struct mlx5_srq_attr in = {};
-	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	__u32 max_srq_wqes = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);
 	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
 			    sizeof(struct mlx5_wqe_data_seg);
 
@@ -222,7 +223,11 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	mutex_init(&srq->mutex);
 	spin_lock_init(&srq->lock);
-	srq->msrq.max    = roundup_pow_of_two(init_attr->attr.max_wr + 1);
+	/* srq->msrq.max is an int */
+	max = roundup_pow_of_two(init_attr->attr.max_wr + 1);
+	if (max > INT_MAX)
+		return -EINVAL;
+	srq->msrq.max    = max;
 	srq->msrq.max_gs = init_attr->attr.max_sge;
 
 	desc_size = sizeof(struct mlx5_wqe_srq_next_seg) +
@@ -238,8 +243,9 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	srq->msrq.max_avail_gather = (desc_size - sizeof(struct mlx5_wqe_srq_next_seg)) /
 		sizeof(struct mlx5_wqe_data_seg);
 	srq->msrq.wqe_shift = ilog2(desc_size);
-	buf_size = srq->msrq.max * desc_size;
-	if (buf_size < desc_size)
+	/* create_srq_user() and create_srq_kernel() take an int */
+	if (check_mul_overflow((size_t)srq->msrq.max, desc_size, &buf_size) ||
+	    buf_size > INT_MAX)
 		return -EINVAL;
 
 	in.type = init_attr->srq_type;
-- 
2.18.1

