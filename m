Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935504;
	b=ow3f0HinidrwfELz5NfBYAyh2/c4e6EggMLRaLx2QzrjgJB+Uq9PjLs7gdmggdKyV17X
	 TYMMm+p6GWMw2OXpkriS9Uq4m/SWphV9PA+/tl/C7mhDY+N800t0gMJzdxYU6gOZA6q7M
	 u4H3Geo1UJSOeQ/VmC+Shfbd/k4eaFBjIMUtYhbXZ6S7HR5WBdFxq/AwpIe0y5PWfJ18T
	 7e+N0j01mW+eEclWX8yG6Shcpd8hd/cN67YORto5ogzHm7FRLlsJMLx6cqdWhXiROwJqF
	 SZtf8dMp7X1QguVgS5TfndibOWdpNXsjofax3SlKSosne8rwfQTMhZSFAdvKxgw6YBg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935504;
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
	bh=DNwYHVEi790EqWASgofH3cwKgTorlYOmQeAIC71UaGY=;
	b=gOTkjZYeU2uPfqDlcBVjrp2CKVZoIBewCZVkKVcl63pSojWBGd91Sp+yG117yKBkedIS
	 NPCIVLAIyNSWW14fJ95DYCVmiIgR84JCJZG+2kmiK8aofG4SKiY2kdW3/yFEvEPkK37gG
	 B5YuM6SlIgwsutmTVAddS0kjhiafBONmrDRmUIJjA1+36suiwL47ktrj8TTp3HJ+K/suW
	 EITQPSW2U1IASsjyxbpnGbxrSAX6RFaz0+Kut3kZKVqHIUglGoFO9vGInqPdqjuNRIcgM
	 n1Uvq5CqlWKTtqzg97Vssnay+ycSuLPK/TySNyHMwyOG3NvGuUy8G9rp/G/x+LASnww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VJHYN+1v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.21
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A7F606A32A;
	Tue, 17 Nov 2026 17:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93A7F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VJHYN+1v
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYSBYw6Orm50/Kgh5kv7XohcRSFCRPBBMqEpmdErHbiD2mMbMMXmr1xejy99z8haWIDoYiffBH9IKHabjBlNFg7Lzb4HYV4l0dulbtuVowWaMdmTUgHFIpTTz+0yE84u8djAKYGklfiA5OV5tUs1dtS/mO4lfLHcK8yJsMm7NsAovQymGJ/FsH2GAN8GEskdTZITMR0xOnYn4TmVVB+MoP8B3wG1NxyO79cKiNw+NuB11Fw7y5KGXYDFV4IUUOmV55t6HAElH+qFFl/c++jMA7pGILwfKPPhWaaDPl/6JJfwusR133ynmhMkzG2hPI/17CQITZ3YItshmLoAFNq/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNwYHVEi790EqWASgofH3cwKgTorlYOmQeAIC71UaGY=;
 b=vkPBw/bPAF20YRDP2IpuuH2zKX+b9VAcTd1GnC3012ip+ozHpRAOab0oYvrmYP6LNULRiHAEx8A0B0nC/4d3tmI6vLEPyS85nkZ4YEypJwMKANmHb86xTIiEhUn4TRLw2lkQGwW4PErktzPOR7BFvsCcE/u2j3rHauE4Rriu61O9pRO8BAZ8IvyzPtvtVAeXAWWjinhhC71bH4nzQmz/D245vaqrDDw4fkrVmn658WCwVT3qFXtUXDTb2Y0qdn8DDf2BkZ5SA1QgmDgFnbeBWgdIaqDsfc5S+vZXPuAK4EPcZNb+1GLDh1ozneWbY017SmmtRVzvgXpsa8n3dxItSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNwYHVEi790EqWASgofH3cwKgTorlYOmQeAIC71UaGY=;
 b=VJHYN+1vyidQCD+tj28TQRMNdhKqHFe5yyfDsTaEdO4rV3CGwsXZ8/C2zv0s8OimZbLJG3qkGedqJ8fbUoODCbeGhvMbl87moxwBp2FtKlOavyd26Clnk4BraDQkX6JhJglSNzdtXkciCC5gEh4VhH+AxAULaG/SIegcx528mKtjaUFJ9xAgKMihN+VVt9C16uPABEBfW5wzWP4FkMhf3PFXYtxnwKXwv3hCC0xAILGHLbCRzG5gF/x6ZL4xo74rDj+GxdoWtLL50WAxl9C2EP+nRG3zw2z0ej3rw8/rQ88chmqON2SzFQh43BtyoRCqZ5vzUOc61rQxJWiJrdcmRg==
Received: from SJ0PR03CA0379.namprd03.prod.outlook.com (2603:10b6:a03:3a1::24)
 by PHXPR12MB999232.namprd12.prod.outlook.com (2603:10b6:510:3cd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:37 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::5a) by SJ0PR03CA0379.outlook.office365.com
 (2603:10b6:a03:3a1::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 17:11:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:11:17 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:11:16 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:11:12 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 20/21] RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
Date: Tue, 17 Nov 2026 19:09:13 +0200
Message-ID: <20261117170914.27410-21-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|PHXPR12MB999232:EE_
X-MS-Office365-Filtering-Correlation-Id: ce9d923d-65fc-4b82-c1e8-08df44cdd6b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|22082099003|18002099003|6133799003|261009223027099003|11063799006|260925021311599003|260925021911599003|56012099006|260925022911599003|10067099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261021123027099003|261021135927099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	MEolOBNPoQ/upiHB9AsQyUUIlfIMHNZqb0QrGAGHXTYT1QmsRqF8axrEky/7KbqyJrcxKFrm9ygH7T1D/OPyDb5mUDpwET+6Tkg13SG4Goz62iRkirUtZt3Pc5NE0Des7zCaTQWL2A0+hSPNxMuEewoYDUBecxFZDj+sQE2RlDvWV2eSat5coeHk0gAE5emxSckz37uvzKCqA617hirSXkRhlBxYJb4p3/KgZPHQkh1lhRY2b/fgYXxMbvggkYflNYjPVGrfB807ZvputJRQNPK6ksnHETknO5p7AVSH74CtMwULiZg56gjtrAHTZ1PgvzacTZ8rCJ9x2Di+bc3MEZlPDbdEXsBFSNgZhz+2YYcOlsAII7w/GKY6IHIfp/beW9bAxylJBuiZxK6Gg0pNmkBbmPgnkBahAHP2LoNiaTFf75yc6y3hkfuAtLb7PKZEgkoVcMKcTQtAuiUFdc6BcysaLFGDwW9SB62omSlkpXARgv2Ft0qqg5omJZPooTdtAFd2537dqocnQuMgaIPelfjcTWwYy5zh/iTlMYoNeC/NoaA9ztQn43TsGp7y6UUfJLMxc8wMR9OmL5JdmIZLHvqR07/AqUarZ35efs2UIjyC1F9pk2v95YUMW0ItmX0u5dPBlvnjbDe2wJB26wFGf9r3XPtpLDoJ5wBRQGHOvAcwN8ZknqOQ45PVLTXj46alSEtiBdqPv/pkotgWWIrxvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(260925021311599003)(260925021911599003)(56012099006)(260925022911599003)(10067099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cCakVYyOq0KkSzFXWj/b2FIsqMqfD8sqlc3xlU8XvU8GdNvOdolG1ZvEXVjMowbxOqzbEykVDYymtnDYaBnK0Q01ZtD+0s323gjM5Uv3B96Hemxu1zshSsFAYPa5dwwMPQNIpnfhhD3DB+p4PnnkBNnxBsNlmRU6OdmBrfjoxEo6HyR8uCg9umx2ldrZ7jbdrpKcuuhNiaCR8SdQfkMjT1pRDlCYLqTDZuHYNyHxZMQEWL711DLvnwdgjdt0pCZt2pu+rlL/PWEj0aB3UYdyUgUPnTlD4780EitiHSjolWRt5jgonofanxah80bYXJF9NCRkkQevJvCz59JYYaQ7kRmRtBqQHkyCA/N5/uJfPZjjdSi5TaEkFcTeO9+vZTigGkz25q8PbIIjRvXrUH19JbUNlsh3wHSHxdJ6uT6yYbS27k4vX+gkf6lENoK+SxuS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:37.0678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9d923d-65fc-4b82-c1e8-08df44cdd6b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999232

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

The SRQ size limit then lets the rounded up SRQ size reach 2^31, which
doesn't fit the int srq->msrq.max, so make it a u32. The SRQ buffer size
can also exceed the int passed to create_srq_user() and
create_srq_kernel(). Reject it above INT_MAX, computing it with
check_mul_overflow().

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mad.c  |  2 +-
 drivers/infiniband/hw/mlx5/main.c | 66 +++++++++++++++++--------------
 drivers/infiniband/hw/mlx5/srq.c  |  7 ++--
 drivers/infiniband/hw/mlx5/srq.h  |  2 +-
 4 files changed, 42 insertions(+), 35 deletions(-)

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
index 0bf7e68a377d..94cef5c460ee 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -598,7 +598,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u32 port_num,
 		props->qkey_viol_cntr = qkey_viol_cntr;
 	}
 	props->max_mtu          = IB_MTU_4096;
-	props->max_msg_sz       = 1 << MLX5_CAP_GEN(dev->mdev, log_max_msg);
+	props->max_msg_sz       = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_msg);
 	props->pkey_tbl_len     = 1;
 	props->state            = IB_PORT_DOWN;
 	props->phys_state       = IB_PORT_PHYS_STATE_DISABLED;
@@ -929,7 +929,7 @@ static u32 mlx5_ib_calc_max_sq_overhead(void)
 static u32 mlx5_ib_calc_max_qp_wr(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
-	u32 max_wqe_bb_units = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	u64 max_wqe_bb_units = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp_sz);
 	u32 max_wqe_size;
 	/* max QP overhead + 1 SGE, no inline, no special features */
 	max_wqe_size = mlx5_ib_calc_max_sq_overhead() +
@@ -939,7 +939,8 @@ static u32 mlx5_ib_calc_max_qp_wr(struct mlx5_ib_dev *dev)
 
 	max_wqe_size = ALIGN(max_wqe_size, MLX5_SEND_WQE_BB);
 
-	return (max_wqe_bb_units * MLX5_SEND_WQE_BB) / max_wqe_size;
+	/* Up to 2^31 units, so the product needs 64 bits */
+	return div_u64(max_wqe_bb_units * MLX5_SEND_WQE_BB, max_wqe_size);
 }
 
 static int mlx5_ib_query_device(struct ib_device *ibdev,
@@ -953,7 +954,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_sq_desc;
 	int max_rq_sg;
 	int max_sq_sg;
-	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	u64 min_page_size = MLX5_CAP_GEN_LOGSZ_U64(mdev, log_pg_sz);
 	bool raw_support = !mlx5_core_mp_enabled(mdev);
 	struct mlx5_ib_query_device_resp resp = {};
 	size_t resp_len;
@@ -999,7 +1000,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, imaicl)) {
 		props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
 					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
-		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
+		props->max_mw = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mkey);
 		/* We support 'Gappy' memory registration too */
 		props->kernel_cap_flags |= IBK_SG_GAPS_REG;
 	}
@@ -1032,7 +1033,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (offsetofend(typeof(resp), tso_caps) <= uhw_outlen) {
 			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
 			if (max_tso) {
-				resp.tso_caps.max_tso = 1 << max_tso;
+				resp.tso_caps.max_tso = BIT(max_tso);
 				resp.tso_caps.supported_qpts |=
 					1 << IB_QPT_RAW_PACKET;
 				resp.response_length += sizeof(resp.tso_caps);
@@ -1099,7 +1100,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = ~(min_page_size - 1);
-	props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
+	props->max_qp		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_qp);
 	props->max_qp_wr = mlx5_ib_calc_max_qp_wr(dev);
 	max_rq_sg =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 		     sizeof(struct mlx5_wqe_data_seg);
@@ -1110,29 +1111,34 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
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
+	/* CQ create accepts up to 2^30 - 1 entries */
+	props->max_cqe = min(MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz),
+			     SZ_1G) - 1;
+	props->max_mr		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_mkey);
+	props->max_pd		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_pd);
+	props->max_qp_rd_atom	   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_ra_req_qp);
+	props->max_qp_init_rd_atom = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_ra_res_qp);
+	props->max_srq		   = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_srq);
+	props->max_srq_wr = MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_srq_sz) - 1;
 	props->local_ca_ack_delay  = MLX5_CAP_GEN(mdev, local_ca_ack_delay);
-	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
+	if (check_mul_overflow(props->max_qp_rd_atom, props->max_qp,
+			       &props->max_res_rd_atom))
+		props->max_res_rd_atom = U32_MAX;
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
+	if (check_mul_overflow(props->max_mcast_qp_attach, props->max_mcast_grp,
+			       &props->max_total_mcast_qp_attach))
+		props->max_total_mcast_qp_attach = U32_MAX;
 	props->max_ah = INT_MAX;
 	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
@@ -1166,19 +1172,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
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
 
@@ -1502,7 +1508,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u32 port,
 		props->port_cap_flags &= ~IB_PORT_CM_SUP;
 
 	props->gid_tbl_len	= mlx5_get_gid_table_len(MLX5_CAP_GEN(mdev, gid_table_size));
-	props->max_msg_sz	= 1 << MLX5_CAP_GEN(mdev, log_max_msg);
+	props->max_msg_sz	= MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_msg);
 	props->pkey_tbl_len	= mlx5_to_sw_pkey_sz(MLX5_CAP_GEN(mdev, pkey_table_size));
 	props->bad_pkey_cntr	= rep->pkey_violation_counter;
 	props->qkey_viol_cntr	= rep->qkey_violation_counter;
@@ -2126,16 +2132,16 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
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
index 6a4a937d97ce..2bd98f52e1ff 100644
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
 
@@ -238,8 +238,9 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	srq->msrq.max_avail_gather = (desc_size - sizeof(struct mlx5_wqe_srq_next_seg)) /
 		sizeof(struct mlx5_wqe_data_seg);
 	srq->msrq.wqe_shift = ilog2(desc_size);
-	buf_size = srq->msrq.max * desc_size;
-	if (buf_size < desc_size)
+	/* create_srq_user() and create_srq_kernel() take an int */
+	if (check_mul_overflow(srq->msrq.max, desc_size, &buf_size) ||
+	    buf_size > INT_MAX)
 		return -EINVAL;
 
 	in.type = init_attr->srq_type;
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index a7e3dc5564ac..3961fdd42987 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -41,7 +41,7 @@ struct mlx5_ib_dev;
 struct mlx5_core_srq {
 	struct mlx5_core_rsc_common common; /* must be first */
 	u32 srqn;
-	int max;
+	u32 max;
 	size_t max_gs;
 	size_t max_avail_gather;
 	int wqe_shift;
-- 
2.18.1

