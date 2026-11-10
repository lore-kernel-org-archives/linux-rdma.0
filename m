Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336005;
	b=ciq53Tj6+QZ4DbLObIIIHkhseY2DHSQSXDfXaRrGl1EWCgC2BpHgAGPElLCxco97Xqet
	 9Wfx2fbUmwI2ozCTJWaZhRNnL7EP9OaSj8PGHaxYLFnjicZuGt9aKCLb9iXpWNn75OslN
	 gvTqq9fagzB4Kfq2BBPt+BfhqW5oEQ28Pw15eDYSLFdOcyX4pInBd3GqW5lNP1/KnxFmE
	 rh3hzG8gwnQ0fd9n9FHCZ5RwyklGZL6JDRgm5BupL8Ji767zJifhRjnLo2/9IXZtgeUtp
	 PLshSqvKB7siptkTZCpXCN6LsaqtJ9s3PDQ1uOcZYIwKS9a5BOD2rtPbqIlC6V0lEmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336005;
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
	bh=L2GVA57AABLCbkLPr82SnBEbcyzClcwCNPZhuuMqYAQ=;
	b=fzrWKbqBMKGpPu6K7E/2PUTdRxxWK8fihbp57rEnKEmRhcaJfXQf1U2QrL6qE5fOXoUZ
	 QcgqNIz5Sr5MrPBH6WGXzidbkg+6mRfNIaU4Er9d21F3qOjsQzZVa99DCF7LiHOpnw0cT
	 F5IBGFXF4UowAaQOe3ZLrb1lpj9Kxiv/ZExESGo+m4dbE1ilEQdRCP2pL1/pSw6VrJGzg
	 jaDmrCMdzsExNPGe9QPTSuEfRMZT6bGEu9C/e7D/QMdvXyU/h9TGPMv3BN5Nc+W6Wz9K+
	 tjDDJVHZDhh7RT6rryC3NhdfODs4wS0UzGqWRvriHxdgHptZOMa6b5JJE9kYg1/+giw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mN5Spq6l;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.41
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536E560A261C;
	Tue, 10 Nov 2026 18:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 536E560A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mN5Spq6l
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1ONkMWrKuB8NnXQQdEtoPNmoVRmh7u794Y3/zDT5JpoJOz0O3irKoYdN3JQjRefl1Y/zItruZ2BmZcJ6tU59eiCSmbRBsU2arZYFAVw0XYlP+sx0hhHkQ2IyZVgNz8/QvfIb9M7ZL+a1TLiZ+VPepBbz6a7C4ks61dZCoj/HlzTEndrbnS1GSgSwFmyQ+QDm8aKdtPub4s4TVthN2qxLzXys+AIRNRpK/gyWQ3o8T6qNFqWsViL/2CdiFAu9rKA5JtnjksbA9dpWM8ug+CF/jhkGYQm0RnZFlU2AOjBrbdTmcvyc7L9LIQdQhBWm74OjCTbLEAK23mcoqzSFpWpjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2GVA57AABLCbkLPr82SnBEbcyzClcwCNPZhuuMqYAQ=;
 b=YImS0Oh3Qc7cGnzn7Rc6UiCoUVNhMkteaj7xM6s8RdTMXV33aJgitcjRLVkaqciat3OnbbSyx6sM/JOJxbFJ+O4mUleFjy2ED5b1w9CqpSTKXD/oRleBnLZi64b4SrVH9gtD+QiOzUTrPtFgTNspfxzKE/+iGb874nlztXp41QGqsQLKjg2e7HPvwIUstvQfvFsKT80h5vDOaaQ8reWijm1HppDsGAQMVk/0iUnKoJi/xxPkdJwZ3+Q0mnc1QQwpoLbExUrEMKabpldlSAm4ea9FvnKQtb90Vt2CBXPb7dnMFVbjKH3QCt+E9LNJpNvL/kdBqi8trwZR2e68c7he7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2GVA57AABLCbkLPr82SnBEbcyzClcwCNPZhuuMqYAQ=;
 b=mN5Spq6li4UuGJ7exq9UNJg0sbLGltuBwj7TDQwhY6Fwiz63GYgGx4i3eTgyYDxR8TgjXh9QmMtMXfhlUlSSdS9KbTCAAn+TldXeFrH3YaW5sCa8hoJbhmDKz8T14iji8b6P2iKrxEpPxTWBK1VEEzujiJo6MtdXiI2cVMF3g0mU44eJ3KsFSyn/SEyV8Uws19zFbux4ItW2zPLlJr5NofnxeD54LfEpTk3c8ZsEutyioxWf81esAP8vS4htHMwg2BmrNGerKReOpVEyCx2RnO3XJbom/S22YYnzNdsgmqwkp8mmGbFwSlhHBR1F7ayES7fSNXOXVbRYxwDH0Uv4AQ==
Received: from PH8P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::16)
 by SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:39:56 +0000
Received: from PH2PEPF00048915.namprd05.prod.outlook.com
 (2603:10b6:510:2d7:cafe::11) by PH8P222CA0025.outlook.office365.com
 (2603:10b6:510:2d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048915.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:35 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:27 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 06/13] net/mlx5e: Add data direct RX infrastructure
Date: Tue, 10 Nov 2026 20:38:19 +0200
Message-ID: <20261110183826.2927274-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048915:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f66e0f3-02c9-43d0-ca02-08df3f5a0476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|261009223027099003|10067099003|261026140227099003|261022105027099003|261021135927099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wSeBxigH8bxGRTyMzUcpHk6nKzs3miHGGa+oz1i7S+dYnsX5abG//cxcFzhfIpduAESmea6U0kyjarNJPITqVGXhq6HQHz/nAMF+DDKvoVErzao0TGiHfRk+1sqPBUKqyF+oYfKt4NiF1dt6OT2vbnNSgwyUoO+0Z4qUeLxa/zk50KMSXBYhkDVms9D/0xhrhoAtnEKY7YLbVWhwphaAW+/+G6MQZf1HxrQi7EbBDBpkfmSM0od/BkMdwKpiHkLwhz0CHeF7+iRpC3Sa78+Zi8xy0UKmH5Vh8vFG7sLdIt1qIupZ0tSL3AhVmHHBNvTHAHuaWkYwtI+QCATBd24E6P5UaOnYjo4i5WJ+A48sQ4mWPWvJt6jpsgleY0qVVxSfEy4AqmBK3lprdVGBYIBQ93HARXnVDcuMCyQP6O/QbfLVbGCb1YsPDZEUdIOxvfeW2WZ0j2zDuyXKhdMoyZ10PRH3Tq+F9KaJyaCVY7ML8PNZkmzSNAFVfOaujXWpvHWqP+JzjJWsBZKAlilaN7nxTPVHmLQcQWiWSxcVGLkrCk3yFdjGEunj/oFnkgw5xKZHZC4TH3oxUu3II0OUwgkdR5tKFjOUrzuDYGfkQXio3Q/oF4HUaqHbEFmYQc5ERAP2w6X5WG+9wENs2Sv/u0yIvhpOV7h+yTX4kVYtmj977NREQdiLWdn5tqcuvbdXRMJNXPNe6hR9LKREZt16UMoJIQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(261009223027099003)(10067099003)(261026140227099003)(261022105027099003)(261021135927099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a+8ZtLoWQrtvY0Du8md58M54Y0sSe6L8do1iEnz74htXt/evvl9BpJC5mLdP3bDffHHb4KZlAk2HGtitvoWI76G2DYqgMPb7vxQGHxKjy6o+2+IAKYCsfodKULVUHIqq2HGwTw/wvsb+Lc4J0P7SvsYVyWg5hHGOJ0ILhGUW5Eus778+tZ38Pi21AdcAu7l/ErAgdjbm+PH17GIrKcYzHoHsDpLBCEahqn3KlNtWToDL/iFmCLMMd9E3bg0fGTo9setBwzabdjpfoV4Ega9PCCpz3FxbP5ZmXY/Ln7kJBSKVEoLbEYCTjrPVWvVy3xDIDnlShFaoQL3ebhAEI1NaU8TJgr+ABTUVTF4sLhoUsHlHiSTz+DcoJsMhyE52q3oq79ulqy2eSWkE29UE9OeO6JP0vrniKpMgATMzign9msV7L1fSckN9ZFsBds0sgEEl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:56.3407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f66e0f3-02c9-43d0-ca02-08df3f5a0476
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048915.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805

From: Dragos Tatulea <dtatulea@nvidia.com>

Data direct is a HW feature that allows a type of peer-to-peer DMA
between the NIC and another device (e.g. GPU) going through a specific
PCIe topology.

For data direct to work on the RX path, the RQ will use a KSM mkey whose
entries will point to the crossed mkey. This is necessary to enable DMA
from the NIC to the other device.

This commit adds the necessary infrastructure on RX side:
- New RQ state flag for the data direct state.
- Create crossing mkey.
- Create KSM mkey and in data direct PD and make it point to the
  crossed mkey.
- Size the ICOSQ for the UMR mode of the RQ: KSM UMR WQEs map half the
  pages of MTT ones, so a data direct RQ needs twice as many of them.

This commit has no functional changes. data direct mode will be
enabled in a subsequent commit and mlx5e_queue_get_dma_dev() will then
point to the right device.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  18 ++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 104 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  12 +-
 6 files changed, 130 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c5bbe5adea45..d716e70c6d47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -342,6 +342,7 @@ enum {
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
 	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
 	MLX5E_RQ_STATE_XSK, /* set to indicate an xsk rq */
+	MLX5E_RQ_STATE_DATA_DIRECT, /* set when the rq maps data through data direct */
 	MLX5E_NUM_RQ_STATES, /* Must be kept last */
 };
 
@@ -685,6 +686,8 @@ struct mlx5e_rq {
 			struct mlx5e_mpw_info *info;
 			mlx5e_fp_skb_from_cqe_mpwrq skb_from_cqe_mpwrq;
 			__be32                 umr_mkey_be;
+			__be32                 ksm_child_mkey_be;
+			u32                    crossing_mkey;
 			u16                    num_strides;
 			u16                    actual_wq_head;
 			u8                     log_stride_sz;
@@ -1202,6 +1205,9 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 extern const struct ethtool_ops mlx5e_ethtool_ops;
 
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey);
+int mlx5e_create_crossing_vhca_mkey(struct mlx5_core_dev *mdev,
+				    u32 crossed_mkey, u64 crossed_len,
+				    u32 *crossing_mkey);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_modify_tirs_lb(struct mlx5_core_dev *mdev, bool enable_uc_lb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5caf7820a136..61a77ee77244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -62,6 +62,9 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev,
 	bool unaligned = xsk ? xsk->unaligned : false;
 	bool oversized = false;
 
+	if (rqo && rqo->data_direct)
+		return MLX5E_MPWRQ_UMR_MODE_UNALIGNED;
+
 	if (xsk) {
 		oversized = xsk->chunk_size < (1 << page_shift);
 		WARN_ON_ONCE(xsk->chunk_size > (1 << page_shift));
@@ -1213,8 +1216,14 @@ static u32 mlx5e_max_xsk_wqebbs(struct mlx5_core_dev *mdev,
 
 static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 				      struct mlx5e_params *params,
-				      struct mlx5e_rq_param *rq_param)
+				      struct mlx5e_rq_opt_param *rqo)
 {
+	/* Only the UMR mode matters here. Leave qcfg out: sizing for
+	 * PAGE_SIZE is an upper bound for larger RX page sizes.
+	 */
+	struct mlx5e_rq_opt_param umr_rqo = {
+		.data_direct = rqo && rqo->data_direct,
+	};
 	u32 wqebbs, total_pages, useful_space;
 
 	/* MLX5_WQ_TYPE_CYCLIC */
@@ -1222,7 +1231,7 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
 
 	/* UMR WQEs for the regular RQ. */
-	wqebbs = mlx5e_mpwrq_total_umr_wqebbs(mdev, params, NULL);
+	wqebbs = mlx5e_mpwrq_total_umr_wqebbs(mdev, params, &umr_rqo);
 
 	wqebbs += mlx5e_max_xsk_wqebbs(mdev, params);
 
@@ -1296,18 +1305,21 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      struct netdev_queue_config *qcfg,
+			      bool data_direct,
 			      struct mlx5e_channel_param *cparam)
 {
 	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
 	int err;
 
 	cparam->rq_opt.qcfg = qcfg;
+	cparam->rq_opt.data_direct = data_direct;
 
 	err = mlx5e_build_rq_param(mdev, params, &cparam->rq_opt, &cparam->rq);
 	if (err)
 		return err;
 
-	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(mdev, params, &cparam->rq);
+	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(mdev, params,
+						      &cparam->rq_opt);
 	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(mdev);
 
 	mlx5e_build_sq_param(mdev, params, &cparam->txq_sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 275f9be53a34..43332015f445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -15,6 +15,7 @@ struct mlx5e_xsk_param {
 struct mlx5e_rq_opt_param {
 	struct mlx5e_xsk_param *xsk;
 	struct netdev_queue_config *qcfg;
+	bool data_direct;
 };
 
 struct mlx5e_cq_param {
@@ -146,6 +147,7 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
 			      struct netdev_queue_config *qcfg,
+			      bool data_direct,
 			      struct mlx5e_channel_param *cparam);
 
 void mlx5e_build_xsk_channel_param(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 6efb626b5506..f9fce1d0e9e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -21,6 +21,7 @@ static const char * const rq_sw_state_type_name[] = {
 	[MLX5E_RQ_STATE_SHAMPO] = "shampo",
 	[MLX5E_RQ_STATE_MINI_CQE_ENHANCED] = "mini_cqe_enhanced",
 	[MLX5E_RQ_STATE_XSK] = "xsk",
+	[MLX5E_RQ_STATE_DATA_DIRECT] = "data_direct",
 };
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 96b521d8bed3..cee73f3b7a99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -425,7 +425,7 @@ static u8 mlx5e_mpwrq_access_mode(enum mlx5e_mpwrq_umr_mode umr_mode)
 static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 				 u32 npages, u8 page_shift, u32 *umr_mkey,
 				 dma_addr_t filler_addr,
-				 enum mlx5e_mpwrq_umr_mode umr_mode,
+				 enum mlx5e_mpwrq_umr_mode umr_mode, u32 pdn,
 				 u32 xsk_chunk_size)
 {
 	struct mlx5_mtt *mtt;
@@ -465,7 +465,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, access_mode_1_0, mlx5e_mpwrq_access_mode(umr_mode));
 	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
 	MLX5_SET(mkc, mkc, translations_octword_size, octwords);
 	if (umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE)
@@ -531,9 +531,11 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq)
 {
 	u32 xsk_chunk_size = rq->xsk_pool ? rq->xsk_pool->chunk_size : 0;
+	bool dd = test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state);
 	u32 wq_size = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
 	u32 num_entries, max_num_entries;
-	u32 umr_mkey;
+	u32 umr_mkey = 0;
+	u32 pdn;
 	int err;
 
 	max_num_entries = mlx5e_mpwrq_max_num_entries(mdev, rq->mpwqe.umr_mode);
@@ -546,13 +548,80 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
 			      __func__, wq_size, rq->mpwqe.mtts_per_wqe,
 			      max_num_entries);
 
+	pdn = dd ? mdev->data_direct->pdn : mdev->mlx5e_res.hw_objs.pdn;
 	err = mlx5e_create_umr_mkey(mdev, num_entries, rq->mpwqe.page_shift,
 				    &umr_mkey, rq->wqe_overflow.addr,
-				    rq->mpwqe.umr_mode, xsk_chunk_size);
+				    rq->mpwqe.umr_mode, pdn,
+				    xsk_chunk_size);
 	rq->mpwqe.umr_mkey_be = cpu_to_be32(umr_mkey);
 	return err;
 }
 
+int mlx5e_create_crossing_vhca_mkey(struct mlx5_core_dev *mdev,
+				    u32 crossed_mkey, u64 crossed_len,
+				    u32 *crossing_mkey)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	int access_mode = MLX5_MKC_ACCESS_MODE_CROSSING;
+	void *mkc;
+	u32 *in;
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return -EOPNOTSUPP;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode & 0x3);
+	MLX5_SET(mkc, mkc, access_mode_4_2, (access_mode >> 2) & 0x7);
+	MLX5_SET(mkc, mkc, crossing_target_vhca_id,
+		 MLX5_CAP_GEN(mdev, vhca_id));
+	MLX5_SET(mkc, mkc, translations_octword_size, crossed_mkey);
+	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET64(mkc, mkc, start_addr, 0);
+	MLX5_SET64(mkc, mkc, len, crossed_len);
+
+	err = mlx5_core_create_mkey(mdev, crossing_mkey, in, inlen);
+	kvfree(in);
+	return err;
+}
+
+static int mlx5e_rq_alloc_data_direct_mkey(struct mlx5e_rq *rq)
+{
+	struct mlx5_core_dev *mdev = rq->mdev;
+	u32 umr_mkey;
+	u64 umr_len;
+	int wq_sz;
+
+	if (!test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+		return 0;
+
+	wq_sz = mlx5_wq_ll_get_size(&rq->mpwqe.wq);
+	umr_mkey = be32_to_cpu(rq->mpwqe.umr_mkey_be);
+	umr_len = (u64)wq_sz * rq->mpwqe.mtts_per_wqe << rq->mpwqe.page_shift;
+
+	rq->mpwqe.ksm_child_mkey_be =
+		cpu_to_be32(mdev->data_direct->mkey_ro_valid ?
+			    mdev->data_direct->mkey_ro :
+			    mdev->data_direct->mkey);
+
+	return mlx5e_create_crossing_vhca_mkey(mdev, umr_mkey,
+					       umr_len,
+					       &rq->mpwqe.crossing_mkey);
+}
+
+static void mlx5e_rq_free_data_direct_mkey(struct mlx5e_rq *rq)
+{
+	if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+		mlx5_core_destroy_mkey(rq->mdev, rq->mpwqe.crossing_mkey);
+}
+
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 {
 	struct mlx5e_wqe_frag_info next_frag = {};
@@ -900,6 +969,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 {
 	void *rqc_wq = MLX5_ADDR_OF(rqc, rq_param->rqc, wq);
 	struct mlx5_core_dev *mdev = rq->mdev;
+	bool data_direct = false;
 	u32 pool_order = 0;
 	u16 entries_bytes;
 	u32 pool_size;
@@ -937,6 +1007,11 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (err)
 			goto err_rq_wq_destroy;
 
+		data_direct = rqo && rqo->data_direct;
+
+		if (data_direct)
+			set_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state);
+
 		rq->mpwqe.umr_mode = mlx5e_mpwrq_umr_mode(mdev, rqo);
 		rq->mpwqe.pages_per_wqe =
 			mlx5e_mpwrq_pages_per_wqe(mdev, rq->mpwqe.page_shift,
@@ -975,10 +1050,14 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		if (err)
 			goto err_rq_drop_page;
 
-		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
+		err = mlx5e_rq_alloc_data_direct_mkey(rq);
 		if (err)
 			goto err_rq_mkey;
 
+		err = mlx5e_rq_alloc_mpwqe_info(rq, node);
+		if (err)
+			goto err_rq_free_dd_mkey;
+
 		err = mlx5e_rq_alloc_mpwqe_linear_info(rq, node, params, rqo);
 		if (err)
 			goto err_free_mpwqe_info;
@@ -1071,7 +1150,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 			wqe->data[0].addr = cpu_to_be64(dma_offset + headroom);
 			wqe->data[0].byte_count = cpu_to_be32(byte_count);
-			wqe->data[0].lkey = rq->mpwqe.umr_mkey_be;
+			wqe->data[0].lkey = data_direct ?
+				cpu_to_be32(rq->mpwqe.crossing_mkey) :
+				rq->mpwqe.umr_mkey_be;
 		} else {
 			struct mlx5e_rx_wqe_cyc *wqe =
 				mlx5_wq_cyc_get_wqe(&rq->wqe.wq, i);
@@ -1105,6 +1186,8 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 		kvfree(rq->mpwqe.linear_info);
 err_free_mpwqe_info:
 		kvfree(rq->mpwqe.info);
+err_rq_free_dd_mkey:
+		mlx5e_rq_free_data_direct_mkey(rq);
 err_rq_mkey:
 		mlx5_core_destroy_mkey(mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 err_rq_drop_page:
@@ -1132,6 +1215,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 		mlx5e_rq_free_shampo(rq);
 		kvfree(rq->mpwqe.linear_info);
 		kvfree(rq->mpwqe.info);
+		mlx5e_rq_free_data_direct_mkey(rq);
 		mlx5_core_destroy_mkey(rq->mdev, be32_to_cpu(rq->mpwqe.umr_mkey_be));
 		mlx5e_free_mpwqe_rq_drop_page(rq);
 		break;
@@ -2849,6 +2933,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	struct mlx5e_xsk_param xsk;
 	bool async_icosq_needed;
 	struct mlx5e_channel *c;
+	bool data_direct;
 	unsigned int irq;
 	int vec_ix;
 	int cpu;
@@ -2873,7 +2958,12 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 		goto err_free;
 	}
 
-	err = mlx5e_build_channel_param(mdev, params, qcfg, cparam);
+	data_direct = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT) &&
+		      params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO &&
+		      netif_rxq_has_unreadable_mp(netdev, ix);
+
+	err = mlx5e_build_channel_param(mdev, params, qcfg, data_direct,
+					cparam);
 	if (err)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a9392ee5376e..0f9a946aef41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -670,9 +670,15 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			goto err_unmap;
 
 		addr = page_pool_get_dma_addr_netmem(frag_page->netmem);
-		umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
-			.ptag = cpu_to_be64(addr | MLX5_EN_WR),
-		};
+		if (test_bit(MLX5E_RQ_STATE_DATA_DIRECT, &rq->state))
+			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
+				.key = rq->mpwqe.ksm_child_mkey_be,
+				.va  = cpu_to_be64(addr),
+			};
+		else
+			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
+				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
+			};
 	}
 
 	/* Pad when the value set to ucseg->xlt_octowords in
-- 
2.44.0

