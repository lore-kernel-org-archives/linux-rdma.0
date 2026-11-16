Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794863414;
	b=GwL6mKX3UTA+9hskX590Ydf6pIfP0+kxvdGvM9Xhgj5GYq/stNbAQMxXzEAApmRsP1CT
	 UaCvqav5GR5ri2fjwbRo10biBjoY5B4F4/IjconB5Cn8ugoz1EezDqUWn892MwAG2SzMC
	 R5Gw8IzD9khuKtkiJw14+rYRZg9wdrcLpotB7XZAOjxDuFn4LZZEpFfal5vEVSNhy+HeN
	 AyBbv40vLoTPgcG5kuURwxMtQxWAxnorLR1tzskK0zPFTj0ijoJ3ihIfi73EHYIyNTHdL
	 5natXKi14/VJd/PuPivHosHiM5cyUSm+FblS5jvm0D6yaaNCdA6ggS/BSJ4i6M1ktlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863414;
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
	bh=hMjspzuh/V/gJxPg7aqbZdVttjTuJX1U4nFnd10UFzA=;
	b=Y0iXyjdeIasz37SLfEepv9mE5hnyYa/u/QvuiZZwv7zJ5Rebhhgua87JkFEhl/FocIzi
	 hLMIyyeVm/RUZr0lij4swAusd3is/GB6/yWsw4xMFzel9klyEphv6znRsW5qz/2PwMXcn
	 k1EsjddYhSOXDs8JHdjNGLYo9KFCrUOYjDeLLq0bEl30wUnsrx2eTF18r+o+LdnFuPIWU
	 56E2bQrGiNkQbFj8THHx0UUjBoptZ08kEzlSH66nXSvIGznddtldWFbQPjGOzvY/zyKpq
	 bAx5ceBc3oY9f1BKn0e8MUeAtrZl1pHOVsl413QqmIBU8Y/9qK4EjN5+pKgD4P6xh5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BNd5flzY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.63
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013063.outbound.protection.outlook.com [40.107.201.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F7A60A260C;
	Mon, 16 Nov 2026 21:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6F7A60A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BNd5flzY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKHfHQE+shBEnOHOhLxzyvXcLQ7gSg+7Mb5ef15Y1VFVuwJa1PnQi1HcGLfKi2FwtEBgX5frUWI07mXGebEK4o4WTmXPZR9ZKiWjN+WRS7UrhzL86PIxI9JqgWQm5KEPhpr+UH25OmnEaYH1wpPL4mmV73tciNEy9TQ6tV2xo1NbTuUcTzF288LEDLvmbzA1VyxLx3daieJhsqHY7W9PqbvblXD+6foN/6yvYJLMq+6pe/L527iidh5x2BtXI35SgMgFQkJubJbAn0Ca15J4KYKdnpHMebu5Yj3m46/LGYBVcxqgKh9XNYl8m/CuLWrSuKMVsr4FYP9ra6dLScWwTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMjspzuh/V/gJxPg7aqbZdVttjTuJX1U4nFnd10UFzA=;
 b=fbTQWaIkqYYC0BWb2fwHs+EyJHZ3eXWzEmjLUOXSEWL3pQrtrFeKn0m0Ekyg0mJTsfkFAP6NI7VmxhuU9ULOEX8CnO2uTLFZEe3/8pXLfgbII+47/mE35zvIM/goGga9gIHkmgxDkwND7UZcqZQgxsTjP/3/q/vg8kBLPj66RcCP6M9FaFxWOs23qRjTf6E2mNdqRvVtSvcUhlHiuJsyZUcUxiHEB8zyfltSdNchDv7t+O9UUu4i5Lfd1EhnswmTgZLdANVXKL2HTzxjyE0RhD21plN6nRoC/UU1iC7mLo6hNmonePMAxkg0ou5N5Hx2oafLTbAPif5rrLskzOxcFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMjspzuh/V/gJxPg7aqbZdVttjTuJX1U4nFnd10UFzA=;
 b=BNd5flzYD6U8TO8xdtrrW2gRQuEe9qpJPc1lYy7KRFu96qE2MI3lchWICkR/ENDCqQ2PO7vbCHAKdjA1Hwa25kWRkX0lNKS0ttYjdxWDI9DgSo0M/VGkjtMxizA2Jv5Ltuw0/u24vDQb1MXJTZ8HxvnL9tFZt87q+91M0CRu2t65L8WYPQmOPQ/HClAYVbqCUjQaXPuD8561nTcHqljlS+a0Ka/9E+5QirSo9sKLrtkqe4ExMv33ZynRRrYQ/4whW8VAVJ0igexqRl2H2HKmoUYXPWEnm2SkjXFulZpcFQGcKh/NhQ+nMqZ1akzqSjkTVh/4RpKOPjvkiZNV1MQ5Ww==
Received: from BLAPR03CA0147.namprd03.prod.outlook.com (2603:10b6:208:32e::32)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 21:10:05 +0000
Received: from BL2PEPF000352D0.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::6a) by BLAPR03CA0147.outlook.office365.com
 (2603:10b6:208:32e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Mon,
 16 Nov 2026 21:10:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352D0.mail.protection.outlook.com (10.167.249.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 21:10:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 13:09:33 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 13:09:33 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 16
 Nov 2026 13:09:28 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark
 Bloch <mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next] net/mlx5: E-Switch, Size FDB peer groups for asymmetric peers
Date: Mon, 16 Nov 2026 23:09:17 +0200
Message-ID: <20261116210917.1297111-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D0:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0544fa-4f1a-4e13-d87f-08df4425fc66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	xodmWK5ybYj6vWgvfb8xCrKA078vuAnIR4xoRfpbR5IHYTyg04KgDPWt0yVsSdBPVXxjllsTtsdo6jWmYSD2ZX5KpPGalT2CZt8yJ/utmEGxJlj228MpgETLgCqq897BFKXTmfesct8JQdU3d93YXyUExdMtG5gneyy2XJKHKkDaAhXj6Xdqjb6AyXaVonzG9lJtV03fZp1ha9WWeU/eR7SYcLoCnQmu0fE3UzmSFME8yEHXbyN1EpQdNlh1N92lUQd2sG0BhEJT70jebIxATrx6+xrwLVrCjEIyu6TQvNmum8QoZ9BsLXYXb2X8UXrY/BnG5o/0hqOyLYmt37nrNk8rovEgrVbBrPBLi0hPGzwWrDVc4x2lFdRTQBHAlo9FEiZmYsYV8W7Cz/MJ+MO6CcJbTOqF90H4fUSXreW8SK2q3iJN80a4QE0jjU+rP6ZAN3mpYS7sAiw3SU2iIqDJBjH1RprarixVccUZAe53nGVaGDdNRsWT0czYx8kiZDAkdRBpYt+sCBilAaKFP9IYYFich/xupHdPB4N4rzaUB8G8xHsV3WYVtvkzaer1G1LkNvIAcfCOMUeDs69X2SDOazKxzgQYQSwm1s9XiFJ8PNOWeGhZQXGgE0/k9gr8/XiJU8nUVzIjmpaFSckM4kdKoGcMDoa/vyk4MI0eapbkyuCYqcDtsiHLIantpkdzQST6YhXLTJ2jQLWYmLLGDpMszg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mGOjG+P3JZZxee1Ga2cImVs8/lyD/DRJ3dkb8YZIHh7jp9Z7Bp/j0ChfMAtvfIeshyDFOazzw6rUZzcZWejcXkJgjFuiN2gfAob6eBgHA7LHD0S8BXlu9J5vVbw12RgfNJxpVC3JijqxvwkKDYQl5f73F4oejlNZM2fH+wP+sGTT8A2Z8oE2Fam8oUaKhb9Jn5LWtWCukNkhQ5BJMd7JTNx+PwRFUzpZYOaO1kxWVVnLVtpuHsCnd++O8BIFxqlmZRoQYMgGVZtPgdk/cgxaZe0EkIiAuYwfTn5QQWr03I7SfeIPBZ7mRShNADGnBVnRLC/YfleCPQnG4fKokIWIGIAsUoaKvLisnzi+PQg4FtTOYvYekJpjMT4tQrKuFAJC8XlZS+8sSdCsf/iEfz2gMt5ta4gv1E0ZpRv3/8y0nTGsiJMak1tXpozzp47axRoO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 21:10:04.7741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0544fa-4f1a-4e13-d87f-08df4425fc66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770

From: Uri Dar <udar@nvidia.com>

The slow path FDB send-to-vport and peer-miss groups are sized from the
local eswitch total_vports, assuming every eswitch that may pair has the
same number of vports. Per-PF VF configuration (e.g. PF_NUM_OF_VF set
differently per port) breaks that assumption: the larger peer installs
rules sized by its own total_vports into the smaller peer's groups,
which cannot hold them, so pairing fails.

In SW and HW steering the flow table is unbounded (max_fte is INT_MAX)
and flow groups are backed by dynamically grown matchers, so size the
peer dependent groups to the architectural vport maximum. FW steering,
whose table is bounded by log_max_ft_size, keeps the current sizing.

Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c       | 17 +++++++++++++++--
 include/linux/mlx5/eswitch.h                    |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 474784131091..20eca8b89b8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1744,6 +1744,17 @@ esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
 
 #endif
 
+/* SW and HW steering tables are unbounded, so they can be sized for any peer.
+ * FW steering is bounded by log_max_ft_size, so it uses local total_vports.
+ */
+static int esw_max_vports(const struct mlx5_eswitch *esw)
+{
+	if (esw->dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS)
+		return esw->total_vports;
+
+	return MLX5_ESW_MAX_VPORT_ID;
+}
+
 static int
 esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
 			       struct mlx5_flow_table *fdb,
@@ -1771,7 +1782,9 @@ esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
 	}
 
 	/* See comment at table_size calculation */
-	count = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ);
+	count = MLX5_MAX_PORTS *
+		(esw_max_vports(esw) * MAX_SQ_NVPORTS + MAX_PF_SQ);
+
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, *ix + count - 1);
 	*ix += count;
@@ -1841,7 +1854,7 @@ esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
 			       u32 *flow_group_in,
 			       int *ix)
 {
-	int max_peer_ports = (esw->total_vports - 1) * (MLX5_MAX_PORTS - 1);
+	int max_peer_ports = (esw_max_vports(esw) - 1) * (MLX5_MAX_PORTS - 1);
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *g;
 	void *match_criteria;
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 03d3620141c8..cfc52d0697e4 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -103,6 +103,8 @@ bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
 #define ESW_REG_C0_USER_DATA_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
 #define ESW_REG_C0_USER_DATA_METADATA_MASK GENMASK(ESW_REG_C0_USER_DATA_METADATA_BITS - 1, 0)
 
+#define MLX5_ESW_MAX_VPORT_ID ((1 << ESW_VPORT_BITS) - 1)
+
 static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)
 {
 	return GENMASK(31, 32 - ESW_SOURCE_PORT_METADATA_BITS);

base-commit: 7ccc5e05043b1bb84326b19a2b05938d8f7a2ae6
-- 
2.44.0

