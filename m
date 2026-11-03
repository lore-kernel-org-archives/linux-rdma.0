Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726006;
	b=zmQV7s/gedLFBgWqPeZG5Bb4gLW+pmENcIVoS9Lw2jjMCQLqqqLksVmkwqoLqmOrUpY2
	 o7Ol/snyhkJZt8rsC79Vi4jTxZ9QxlDX/4mKn6kjKMhz3fk0nKnKWi3tcEIcQLgUL4/I4
	 p7xL9S1pXyUxqL76RHwLbaEQmsfJAsSVi2CKGrG4kX2czbHLdCt74NnvZaKT03eKwFSZm
	 hfqJCWYRRczxSMZZ7p/TLVPbJ4iy5Vzpm14k9VV1rHGV/V9bzB0b1vXr2ySMDsXB2wOAR
	 p80/JWSD8KdPfKolbgejgufeTOlGqhXBbvleQllaV89uqjEPhKPd8Ox++Y883tfoeKg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726006;
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
	bh=/1rVNfCC+jL2QlexzNn5llOVHxSIGjbQtQNz1LzrW0s=;
	b=AX7AdEOcJB4dOlSzBBvafZbXOqXSBw3CtVTwSj4Qs7kH7ZZF/frNjNzwVsISChG4Nm+S
	 IqN8Q/Vh6jwnbqHVRRehqgE/qtwov01YhEbg3bv0hEdorBmVZkquHZYfqe9k7XiOA3eUV
	 CC+7XB0+Yls8HNQCpeRyvj/ZCDMc36wgzLRUFQfjQTpP5iTTj468DOi2BfWcYKEI9rQdX
	 MThRt0QjKz1KYJWpJBJXIt757GpDZqyJkMhEXEo/WTLf2tGtI3CIDjMXAAXCOf7QQ7UC9
	 SEovvxxciF3j3ILEFnQlu8Xqru+VnOIJdid0r3BozNFImm86ATavKO7x6ay8l8fv0CA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="J/8KYCq0";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.41
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CC7606EEB7;
	Tue,  3 Nov 2026 17:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99CC7606EEB7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=J/8KYCq0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6ttV+4xZ37irHSk358KUZ96nOQNEFXXWsIjTcb33YZsPVY8UBqIq8p9zDmmzeHnOOdWfkzbFjI+Raids3zj7w32qoymYZH4UWsTxMNYw2FaSmCz5+4JNMmx49yL7ONGGBdqZ6jsr0mnOAWjB5XkgEU6LY9wjWi25Fp40VsF6iWyq1yV9Us7YrdwncabNkzYl37Tkg48jaY3C2/dUYdbjZJFwfC4gj6f4btSPJJhLMChMMYmKT99z5enLq9Cen6+4rboodtmYPeU/56znDscfEqzlCjYRQDQ8Y+Hf97V2wYJNp+zkeHKfSa9Mt42pPAZDiqr6+kH6VPoNXHx8C+efA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1rVNfCC+jL2QlexzNn5llOVHxSIGjbQtQNz1LzrW0s=;
 b=Sv0UUZqOz07Kdubh5wRuHYzGAKo57BCZGFsQ/Ub4ZoYQgP9OpCkGGJMxc0LvgVEJkICl+21c8QwTnUn/2zw1vTQDu4TBwGdF6F3QYfwvUP4V8p/oO/zRiUkq7hpBGIyiJCC/ZqEhyLExc46LdyeVSBb7UoBiSGYm7EbZ1hBx3h8DSdD4FoLa8Odc82wP+dnoQuWnUbOe4gd697rh0V9DgOz4b8xQ5SZV5rG+eUn+nnlUne73VlHs+xh7kNe5QrWISaZ6AhU08UaTnHuXxIakypDhS7PmfBCdALYgWH+PtiRDhj4W0BU/Tgxaecww0Ya1e2jEpn2SYMAUDh0PgxYZIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1rVNfCC+jL2QlexzNn5llOVHxSIGjbQtQNz1LzrW0s=;
 b=J/8KYCq0qFc2Ij9xqBhUqiXxvb73p0wrGOTGAS0kj9YYSMgTUT2SnVUfLREdG29pznkQCX3YjkxjjDiifqVrEePcgbATyF1+8EAWk1Gk3UZaPMJm0TDSCTRAxDOINHcq+gE1vRwBqUD8ifIdWyVClKnDs3fuFJiEVmNe4R/oCsnfYm6EzO3RnwyBJ0D9RN3hoR+I9VjVPRiIePWtiAAY7wiKrRVi4hD/EtzVYn+8P7NKMFPSF/i/D8EWoXFBSDncEKukMARBEC+yjezXm5M1ELKiRebZvpEmu1XVCwdSnrXmyc5TWVk5UybstWVVLJu5acn3cvU73CavQMd2IBP5Eg==
Received: from CH2PR03CA0001.namprd03.prod.outlook.com (2603:10b6:610:59::11)
 by DS6PR12MB262455.namprd12.prod.outlook.com (2603:10b6:8:530::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:20 +0000
Received: from DM3PEPF000265B3.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::96) by CH2PR03CA0001.outlook.office365.com
 (2603:10b6:610:59::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265B3.mail.protection.outlook.com (10.167.23.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:46 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:41 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 11/15] net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches
Date: Tue, 3 Nov 2026 19:10:05 +0200
Message-ID: <20261103171009.563034-12-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B3:EE_|DS6PR12MB262455:EE_
X-MS-Office365-Filtering-Correlation-Id: ec823538-daf3-430a-77ef-08df39cdc28d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|23010399003|6133799003|10067099003|18002099003|22082099003|261102123227099003|56012099006|11063799006|5023799004|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|261102130727099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	h0dZ7BltJck5ZyGz+Jo7mf0/gP5nqcaU1ZTck0st/El6QGJaohCuvu4jQyaYPIWX7+xtua8QOoAH1gJ6C0rqE4geM2qOi6CTnF4e2P8R9sGMbltYKVPDGGIMYQiXB5Cg1jT49eN9SK1TVPWUDAPw+xpSgTZwYKzWXpRl7ke0Eqqk/5tOhiYgHu+zip32CLb+GJ4M0P0ESjcs11/kJs8M5uPTAdjy8OjbaW13zbNvbchOx9RoFP/i9B6yDG4fNS8RetfWEB0bBkT7FH1WGndqC0Vaau1Uy2j1gxYPnRsuUp1yCcwq3mipPwITKjWNVydODOTlU67iECp5FSjQF26WhATd5t8kdtdPhgTChWRBrdIfol2riVF498NzMtyoJq+0HcusfR8MKJ/hRuZqmvPUp+DH5l63iPwmpVJ0q4+jauaGaA/0UWOyoRbZrO6I2ggyjVYpNd37wzwS4qipsT1G4AdBcy84Y+OVaMKsNcPM78UgGMEDT+kS4ioKWClCE8b/pN4CYKMNl/rVYYb0L5KD7i0LJLRuBW/5rvzlEOgFgZwkrgF9Sf6MeW9WA9r/m415FC6N882kE+JgfRqH2JQPbOOzQuQ2LT0Ab5Aw+M4m6BAGDtngpzqsLlwASesKmv8HkhAkT16e7zoBlPG9RElwCBwbikPp6s2mrR4NVyjYwLOSqA9j43X7TzqHG5pFY/v2VyVREo6Am4Nv5xVCtm1yvw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(261102123227099003)(56012099006)(11063799006)(5023799004)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(261102130727099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HfyRNB0RrLHbcjhiRyjSi6d8a/Z2i23uU0l56t6e6b+YDafJoih7T4zLta9GEI/7REMuPvtK68aLid98F4WA0iuDBL5wCVVpUOwE8jIkKeYWc7XSgbdsrMXFJAREGPBTA7dmTo1OfywXzXgdPNIdTSbsoZovUgDUpHJbbu58kPeOWYLLuSGT0KEWxv/a3vxJC7FdBa7x0iGuDoR7Usi52yf6sDbRI4l60Cel2D4xQdF/+1KBGl9pMlr3zjDO0uWB0vjcb7wnbNEvHJyZ9L8MIhG9ayfckiqH6PCFdFvIJAS1sJeEiEWQ46Fh9FEsdzAeBwQnBL5BdySm9HTaIY4Hcy+ceMKasSdx8UIsq9uHb1fuw1iFm/gi6P67hOC6u647oj5XcoPb5G+sjjAfmkBKtH6eo5LsScBcG9nBuydICLtghqWhfOIhh1TySTReN0Fu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:20.3571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec823538-daf3-430a-77ef-08df39cdc28d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB262455

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
so nothing downstream of the match changes.

The PFNUM value 0xf is reserved for internal port offload, which stamps
it into reg_c_0 and matches it with the same mask used for vport
metadata. That offload is gated on switchdev mode only, so it can be
used on a nested eswitch as well. Cap the LAG index accordingly.

Select the nested layout for any non-PF eswitch, so every PF keeps the
PFNUM layout regardless of its virt LAG capabilities.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 17 +++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 70e6dd9561a6..ef1043517e9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3651,6 +3651,48 @@ static u32 mlx5_esw_match_metadata_reserved(struct mlx5_eswitch *esw)
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
@@ -3659,6 +3701,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 	int pf_num;
 	int id;
 
+	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
+		return mlx5_nested_esw_match_metadata_alloc(esw);
+
 	/* Only 4 bits of pf_num */
 	pf_num = mlx5_sd_pf_num_get(esw->dev);
 	if (pf_num < 0 || pf_num > max_pf_num)
@@ -3679,6 +3724,9 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
 {
 	u32 vport_bit_mask = (1 << ESW_VPORT_BITS) - 1;
 
+	if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
+		return mlx5_nested_esw_match_metadata_free(esw, metadata);
+
 	/* Metadata contains only 12 bits of actual ida id */
 	ida_free(&esw->offloads.vport_metadata_ida, metadata & vport_bit_mask);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index d73bac8441f7..4e15e16ae6e8 100644
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
-- 
2.44.0

