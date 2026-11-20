Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161651;
	b=SNkbrPlW12gUGCPeDySIvgqadW0o1nWAZN0tyc0EeDaBx17ln+zYbpnTIXn5H+MGOFns
	 59GqUwbUQbVIruOkH04IHC//Cdl82UiRQ35uzKtQYfPGo6sRHF5MwgqzZzQd8dmjB2aqV
	 suyjoZXb1ezJXByoGxwP4YyZwBPRdeZzcMbeJNflE6cozZNvV60fJtJLB/GQb0hs/2v04
	 vbPXctnb0xMguafXT48oncdFU52CQpaN6vEsOO/2zoH3nqCcX8c+qB+oygkXHx0F+g8Lo
	 rJoUKbEUYQNplVIu0xdUa5Crt6WHaK4ffXqDIS7GS+QD6hUdk3dX5fl7Z50GJUDaLWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161651;
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
	bh=GpsknwpJerXmYLtJdUU6XyQZ5S8DFCyZVNlFXkpeRhA=;
	b=XiKGQx/DEFH3ruuxfFdYxsbdE/5OoZbJyg+j/KBgTKhci7ybQi8EwAL4dZ5gnmWDvyWj
	 ABc8nmiyHTVOwp4C1hCuqo8HRjyA7V56c01PUXuF8hiU0aqs2IeDcIImG98Q60YiVwvPF
	 ePiGfHK6kbPdeqgRXvL9vWup+WUqdjPx3myMgQc12N14fOFTSFgIUW6/n2j/3pFnfHQeJ
	 ufXAVFxxyFEUBh6pUHOBCuL3Pl46DfUTzE3q8kmTNaH6ggeeF26wC8gTFtOkTAbRSOiM9
	 S4dCUDF8SlGzzf+wBtGQi0BrPNqAcgKE/Wo4fcSrXWTDRDhH7u2Rs8LNeDCBDFVBSqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CU3R0aVd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9E7606A334;
	Fri, 20 Nov 2026 08:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F9E7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CU3R0aVd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDGwL4k1lYHsaaBy2Q6Vt+0FmeuRyJQl7giiLdMXNgE9kv1qZXxidfHO059vKJfuyz0PGMyJ3nLbEMvx+jnIyFNiKXyFpVl+CI9WHh42xLW2FVbSX6gDFMDlyrsm7CdKBsz18sPeNWB+FUOI8zk6tN6YNfDYIxBMzRRvo888k0KcPX2glGJ05g/8VTqD0tDS5aNBrQzXCzf7F6K2CTo4YD8XV2Wi0nk1rBEe9BrG394vD4DMGi69NdtfCT1MYyBaXUD4/IcVEE2TWAZF5utySYeipZgBEiNXVgwLwHOEh5D9PlVDfx+reyf8hwTEag2Uy51+/JJLCzdhbmAIupdHtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpsknwpJerXmYLtJdUU6XyQZ5S8DFCyZVNlFXkpeRhA=;
 b=VfaZgreuRsa1UKUdKXAR78/yyu1aW3GQNS6T7DuACcAKra8qWtWFBWzvPCZ9qSRVqFZ0q8JWnom/Iqtsj3z1CWdsW084NGAlfFdrOfF/AmeLI2qg/xs/Eg3cQrCDIUZmyyBYV9594jthHhWlqUpGqnXRNpaRgEe9twyU5OAIxzqsUGrLDKWbfBTqaPdzmh1wH0F2eWWv5kIfpxT6s4T3/KuISO2JRV/hgCKem/+jdDMEOt2WKDuMAIJkWD+JbnWuUqOpDdYHwB/5BFDYfZ9TxRnjlp71eMInAlNa9RH46l9JbL63ntG86mQJOKiOlrduI20lFFrJIlQRgzsNUo060A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpsknwpJerXmYLtJdUU6XyQZ5S8DFCyZVNlFXkpeRhA=;
 b=CU3R0aVduc21OKpcEEEP6nDa2KYW+gI8BCOmBTz1ULsauuB9kZbMeVNPSDiFTpZQyiLxJrmfdxieKBsdD+x75+WfNP8fsfjR4JSWVU38rAnP7njGsgMChB8H0Xt1SLdQlR+1y2ZZDsAlknRvPmQqKa0/C7pYitdImxROuSvXlyeyqouHWtTbQ9ZTjaORS/wgauvPkHI8xkJdps2m6Z2g6/OngGFv+MIg23WhekpTNrEJQeoYhkKt/ziNszuHB8AWy0cFITIFIFnz7RcddgM7Ti+ozEsB0uUf8xlPljLqUCtMjT4bn213cIOm83DIs/d1k6fKd7d3yucrHQhdWIGzTg==
Received: from CH5PR03CA0011.namprd03.prod.outlook.com (2603:10b6:610:1f1::23)
 by CY3PR12MB9578.namprd12.prod.outlook.com (2603:10b6:930:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 08:00:47 +0000
Received: from BN2PEPF0000A805.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::30) by CH5PR03CA0011.outlook.office365.com
 (2603:10b6:610:1f1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:00:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A805.mail.protection.outlook.com (10.167.245.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:00:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:25 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:20 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 1/5] net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches
Date: Fri, 20 Nov 2026 09:59:54 +0200
Message-ID: <20261120075959.2533702-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A805:EE_|CY3PR12MB9578:EE_
X-MS-Office365-Filtering-Correlation-Id: a2f4cd1a-e9e4-45a6-bde3-08df46dc6285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|261022075727099003|10067099003|11063799006|56012099006|261102130727099003|261022113327099003|261028144727099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|5023799004|261026121527099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	yK8/yXblJsKD2NbBJmJ91zSvrCCDKvNyO/S8BaMyF8NvEJ7F8/tGscY7l5bu7LClRRjZBUwVvNlTIDEFgYGALCD9cygxBdV9Yb2uNT1dULSBnK6rjc2CclmxwMXcYi82HAChX9NUXaCjtMY4IJawdn5hX4POdTSbR50HU3UO5ulgLlQJFP42dhMnnmqQZLS8SzZ0BqvIgrxO7iql6suzlYXagnkYPuuKW1WDcbAOlFopObz8UIKgFtsrj2ZUVe5SgAD4B/MeNTbmR8IZ3qFzSIo4zGZDhxQTvnW1EHAwxmkLIHsS/IKuPx78K5K2w2rffluQAX/0zsVDirfjiaiQESDboFUmtTPZvbeos3wQshdGUPjYMwiVl/rN46snNlXBbXJ0dQ2RnEqbjS4Fr/rlJCkyeUft2MqgErAE8Pw84CBcyFDZi08dyp4hrSJ6JCo9ufmJ/79DGpJRlC5yTJ+yF1ZvFn9BFDXUIGEUb54oS0s4pUNclQo1DuMfc9czb4v1mDneQy8PldCcSIaOlTKcupKuI392vsgrJUBoPaS29gkB+9OCevqTZDLrOcYjFXw9OaQ97KMaEux+VUxiQiGohcW5B6HoI/kcIhtopUJb9nzE+G6MirNra32BK6ZjiwBgcsrrcTymWmhxhK1aJzffH28oBLg5VVw9M1KzXdGlOzCZqXM+YGAVJ/l2MMD3kpZW8pA+ve0LZRkTIdcPnD5dew==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(261022075727099003)(10067099003)(11063799006)(56012099006)(261102130727099003)(261022113327099003)(261028144727099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(5023799004)(261026121527099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wqGJrDEqvSQtkkCWc8JaJR8AgXa/YzCF93NkU4vIAx0GSMIoMkcXL4htFMkUzEwaHI4X5wK1QWNSgfkrpct/rexI84n90hubAq81TgKGCjuz+ywlfxMozW1OQbZ0l0HLzVlVfYXv6y6k3wRXyLZv/FalKPP3XwCbQcPiZ5N5eIAoAoyz35mSYF9ASSIXGPO8s5SN3s9rs9FvrL5rRQc5g83glaWdOivpumkGJcwHx97VYNxFR0xJkNPMyPJONYlWwdw5GcHeuUOyf5R0Z5m8AKm3jHqen28Gb5I0ooHp+yTMkZLJ9I7OOqOlLurEjXgcnrr+TJg+wG6HFPE6b0uOJeHq6TP4KTG6OEo/LzA8whUYSj6d58N2bzq8RwxGhdAeuR0N6zuDAsL20+oBH4A2SO0yt7dRcz+xYR4jHwWPqxHenFA44L4FzHqcgp79bohV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:00:46.7837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f4cd1a-e9e4-45a6-bde3-08df46dc6285
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A805.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9578

From: Shay Drory <shayd@nvidia.com>

The eswitch source-port match metadata is laid out as 4 bits of PFNUM
and 12 bits of a unique id (ESW_SOURCE_PORT_METADATA_BITS). PFNUM is the
native_port_num reported in HCA_CAP, so all VFs/SFs of the same PF share
a single PFNUM. Each VF/SF eswitch allocates its id from its own
vport_metadata_ida, restarting from the lowest value, so two VFs/SFs of
the same PF can end up with identical metadata. Once their eswitches
share an FDB (virt LAG), that metadata no longer uniquely identifies the
source port.

Add a dedicated allocator for nested (virt LAG) eswitches that replaces
the PFNUM field with the VF/SF's slot in the LAG (its xarray index in
ldev->fns). That index is unique per function within the LAG, so
combined with a per-VF/SF id it yields unique metadata regardless of
which PF the VFs/SFs belong to. The split is 8 bits for the virt LAG
index - which fits the U8_MAX cap on the LAG xarray - and the remaining
8 bits for the id; the two still sum to ESW_SOURCE_PORT_METADATA_BITS,
so nothing downstream of the match changes. Describe the nested layout
next to the reg_c_0 layout in include/linux/mlx5/eswitch.h.

The PFNUM value 0xf is reserved for internal port offload, which stamps
it into reg_c_0 and matches it with the same mask used for vport
metadata. That offload is gated on switchdev mode only, so it can be
used on a nested eswitch as well. Cap the LAG index accordingly.

Select the nested layout for a non-PF eswitch, unless it is virt LAG
capable but not a LAG member, e.g. one refused as a late joiner and left
standalone. Such a device keeps the PFNUM layout: it does not pair with
the eswitches of the LAG members, so its metadata is never compared
against theirs. PFs, which never report the virt LAG capabilities, keep
the PFNUM layout.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 17 +++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 include/linux/mlx5/eswitch.h                  |  4 ++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1323114ce7f9..3c1355f91090 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3650,6 +3650,48 @@ static u32 mlx5_esw_match_metadata_reserved(struct mlx5_eswitch *esw)
 	return MLX5_ESW_METADATA_RSVD_UPLINK;
 }
 
+/* Nested (virt LAG) source-port metadata layout: the upper ESW_NESTED_IDX_BITS
+ * hold the VF/SF's slot in the LAG and the lower ESW_NESTED_VPORT_BITS hold a
+ * vport id unique within its eswitch. The two fields still sum to
+ * ESW_SOURCE_PORT_METADATA_BITS. The LAG slot (0-254, per the xa_alloc() limit
+ * in mlx5_ldev_add_mdev()) fits in ESW_NESTED_IDX_BITS; slots 0xf0 and up would
+ * drive the PFNUM bits to the 0xf reserved by internal port offload, so only
+ * 0-239 are used.
+ */
+#define ESW_NESTED_VPORT_BITS 8
+#define ESW_NESTED_IDX_BITS (ESW_SOURCE_PORT_METADATA_BITS - ESW_NESTED_VPORT_BITS)
+
+static u32 mlx5_nested_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
+{
+	u32 vport_end_ida = (1 << ESW_NESTED_VPORT_BITS) - 1;
+	u32 max_idx = (1 << ESW_NESTED_IDX_BITS) -
+		      (1 << (ESW_NESTED_IDX_BITS - ESW_PFNUM_BITS)) - 1;
+	int idx;
+	int id;
+
+	idx = mlx5_lag_get_member_idx(esw->dev);
+	if (idx < 0 || idx > max_idx)
+		return 0;
+
+	/* Use only non-zero id's (2-255). */
+	id = ida_alloc_range(&esw->offloads.vport_metadata_ida,
+			     MLX5_ESW_METADATA_RSVD_UPLINK + 1,
+			     vport_end_ida, GFP_KERNEL);
+	if (id < 0)
+		return 0;
+	id = (idx << ESW_NESTED_VPORT_BITS) | id;
+	return id;
+}
+
+static void mlx5_nested_esw_match_metadata_free(struct mlx5_eswitch *esw,
+						u32 metadata)
+{
+	u32 vport_bit_mask = (1 << ESW_NESTED_VPORT_BITS) - 1;
+
+	/* Metadata holds only ESW_NESTED_VPORT_BITS of actual ida id. */
+	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
+}
+
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 {
 	u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
@@ -3658,6 +3700,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 	int pf_num;
 	int id;
 
+	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
+		return mlx5_nested_esw_match_metadata_alloc(esw);
+
 	/* Only 4 bits of pf_num */
 	pf_num = mlx5_sd_pf_num_get(esw->dev);
 	if (pf_num < 0 || pf_num > max_pf_num)
@@ -3678,6 +3723,9 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
 {
 	u32 vport_bit_mask = (1 << ESW_VPORT_BITS) - 1;
 
+	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
+		return mlx5_nested_esw_match_metadata_free(esw, metadata);
+
 	/* Metadata contains only 12 bits of actual ida id */
 	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index abcab76fced0..193fbe47fef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -516,6 +516,23 @@ int mlx5_lag_get_dev_seq(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_get_dev_seq);
 
+int mlx5_lag_get_member_idx(struct mlx5_core_dev *dev)
+{
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
+	struct lag_fn *fn;
+	int idx;
+
+	if (!ldev)
+		return -ENOENT;
+
+	xa_lock(&ldev->fns);
+	fn = mlx5_lag_fn_by_dev(ldev, dev);
+	idx = fn ? fn->idx : -ENOENT;
+	xa_unlock(&ldev->fns);
+
+	return idx;
+}
+
 /* seq 0 = master, then all remaining devices */
 static int mlx5_lag_get_dev_index_by_seq_all(struct mlx5_lag *ldev, int seq)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index d84d0424d04e..f5f105762d88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -275,6 +275,7 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev);
 void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev);
 void mlx5_lag_disable_change(struct mlx5_core_dev *dev);
 void mlx5_lag_enable_change(struct mlx5_core_dev *dev);
+int mlx5_lag_get_member_idx(struct mlx5_core_dev *dev);
 
 int mlx5_events_init(struct mlx5_core_dev *dev);
 void mlx5_events_cleanup(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 03d3620141c8..06d7d634de0d 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -95,6 +95,10 @@ bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
  * unique non-zero vport id (range 1-4095). The rest (lowest 16 bits) is left
  * for user data objects managed by a common mapping context.
  * PFNUM + VPORT comprise the SOURCE_PORT matching.
+ *
+ * A nested (virt LAG) VF/SF eswitch splits the SOURCE_PORT bits differently:
+ * the highest 8 bits are its slot in the LAG (range 0-239) and the next 8
+ * bits are a unique non-zero vport id (range 2-255).
  */
 #define ESW_VPORT_BITS 12
 #define ESW_PFNUM_BITS 4
-- 
2.44.0

