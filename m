Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335996;
	b=SiNcZGff+oG1oobfdCQnhgkl37g9k5YWzNCxSCvmlet1yCq/LMPpHjc21CJvYBjgO3sA
	 StAauqHG0RZq15ylVGkSSVKb/cw3FnvsXRdTduoVX/Bkwq6TMNICYzvlWtBAmg5Xe8oyE
	 nbQOmpPri2G6WuepZnlP8sOwkhMjSjAKw4nOAATOSsWkASgCiwyqvUM7orV3rCyj1Qs7H
	 qlWYzgjedE+djvt0OBR43mOkfNZvdhv0cd4pBHcUGOPnSy29QAGESS+9WZPvJM6V+Ecu8
	 KSTF68IdSHMuOmzAI8DYWcLlU3E3MwDziznmhHloU7AwsYHI0V4ZV+4Hit7Nnzx1ioQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335996;
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
	bh=ptEpm4eRJcZt/uX+VjSQ7odnxzFzklv5srye9jElBOA=;
	b=4twcAT5WAHab82YdeSz9kRAGbm7jTSvw5AAqmQdtin42MEoH499jpeChO+qclqN4Z+HE
	 dmvzOlKe35IqBQuRNQz/FN1itIW7+PK96BL4+FfAI3EuC1QQYLFRtdc/6vlt68bO3pbN7
	 dpR7vo7qF0w1igcgeIiJZT6cKJDVCNy7FzGgAX+S3TC3nQx/X6QgPR30zla+5yesa95O6
	 Cv6wjqnA97gacO9JEkfUqfqHUYVj8mojLm/kZonTY13BIukHilxM9+21B0XGFbmaYNp7J
	 N8PRPUU9HoJMEm9Cz2UYTaVYRG2A5HCLwfJQ/AjTs4fSAkCneVbkDIkqH3zdOQ9zQcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BpgLbU+K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.33
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84D6606A33D;
	Tue, 10 Nov 2026 18:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A84D6606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BpgLbU+K
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubgNVMAwfeb5Es9FkDVnywoyq5KR/OAgYvZNAM6p1YM5YTKAMUlGSBLP4pTJuWNkcpvAs6POfX1K3PSMhkHTWo0xKl8J7FLsJobFEJCUJOz8ZjY3J/uvH64URc52EALcmU3MU0441eaYtk8uz7qRjsyNG7LpzpzY8z8UHMR/esUOcbyk7ExyKYuuDUKQfF/FPI9Jrx3Cm5iYqqLURKw41W9pYYs44MgZg3DIk01Z6zUHxy5eXzzrRAXGWAZV09TDDC7LaWPgriqjJrZ780WEo4685mWN0IIUDQxgUkYv8ClLhd4j/Jfigb1dA4SMXdR2tH5ZjkqicuETWqHvga9IJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptEpm4eRJcZt/uX+VjSQ7odnxzFzklv5srye9jElBOA=;
 b=HXpQXMzvkhUMFPBE2jK/VPqIQLr2SQGViFCZmUqRu9NVD9NANgOFMOLLnXZ2pVoarcwfEvHikSBA1wJQMudNOUayhQzT92En4zzCQAtpQJybVVIbW0xtqp4TJfikft750l+NpeTx/XR6t5dUinGDcq6QNQJKqoKXItI6NoUddMjjxfmXcn7o57Z4v0tpl9/XXWA3slHtGTgOjNSCZSsH7smVzQqO5D1GrgpLbZv+MKv63wX1fOG42HPC7po7mIz8g6tbn+RVVOQGMyy5/BaWIL8LmPCF69vhpd2abUnXEu+ekHYGg6crSaN1GFfvgP/sdYkBphZFW85HY/rsBL3h+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptEpm4eRJcZt/uX+VjSQ7odnxzFzklv5srye9jElBOA=;
 b=BpgLbU+KNErtT9hT6oHB4kyYwR5u7wVp5XtwA2gnJY6LsJsQ32bUPEKIN8oFpLeCrYszP5/hfj1iCSMLlG2pKO14gr1nA6klkDaAOhQCgrmc6hhMcVRuUjkPgFoZ337aD83fbD9oRtCM9pUS2nXt4zSyPUsiSzIBTNqdcAqTh22n4rdobWX4YKDV5/MplSv+H6OjTITUZp6PmQ3+sHnoZTIHUJ3cZ48O8VpEcC681xMmdb8RNY5t2ULHanWO2XcWJixYVSs3UTrlRMR8bHIRQg5yjEEB41xrurZJz72l3NRJJIM9d9UhQPyKAFo/SAMv/LE/AMkYgJlYPqVA0wIkHg==
Received: from PH7PR17CA0056.namprd17.prod.outlook.com (2603:10b6:510:325::17)
 by CY1PR12MB9558.namprd12.prod.outlook.com (2603:10b6:930:fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:39:51 +0000
Received: from PH2PEPF00048913.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::9e) by PH7PR17CA0056.outlook.office365.com
 (2603:10b6:510:325::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048913.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:27 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:26 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:39:19 -0800
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
Subject: [PATCH net-next V2 05/13] net/mlx5e: Add data direct ethtool private flag
Date: Tue, 10 Nov 2026 20:38:18 +0200
Message-ID: <20261110183826.2927274-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048913:EE_|CY1PR12MB9558:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b905fa-598d-4930-dfaa-08df3f5a00e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|23010399003|56012099006|261026121527099003|11063799006|261021121427099003|261022075727099003|261009223027099003|261102123227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	EojSrsb5kmDPzn2IORgUGSeiLCRnCoL74A1yW/sy/QA66t+YrpbRplFgiVoOr7MLtFUIrRs1fxrdnOy6yBm2pjv5uSu637vXkjVemG/ya0mjFGHqFIzhDISlVXTSB7st2jFX9aDRwnOsrqJ5RtCjMhmK3bsva7VCo3cimcmMiBD5pf3WO+puFObThDswt0vYQ/tR6g1H09D94S9O4iJDN+p0TR5m7yteQQpuBXJM/kdax/6roOeEuaobXcQ57ycOl1POyXHvuCsElr4cQwGs4jgQLQF9/XAzZWAQvIXJRo/LaM7ZXKfT8031jsuYXtVJr8uN3hGJOdcvMjlWvleuwC9vGtuEJHkrOFDYGBN6vezACcPSrS0WiJaZv9yDsGJxtFkfIO2y2RWbLzPU6krXXJ2WfFLHkNHOvykqc+E/2B1EehOrLL046AS27/ub+SBwIgKEAjrCsb5A68yy7g44PyEYYEYNsqAakN2Gccg00+DvVY+qNizpG2fCxGsIrJfe9AGxGT3y+5jlVvKkp3TK/d6vU/OZliG9LTCcW3hl4mt+/ldj1TT/tHueyJaTFy1wyhzJtCktIL/tyLsTxj5xhpeuLSogqDdw73eZAeUicVDZZ5V4++yYftlg2hVwtB1M9dFMxEt9X9cT7zrY099Hoa+vJoicmNQDh/2BUYBqC0VewWduetn90tNeIfLsrSfU
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(23010399003)(56012099006)(261026121527099003)(11063799006)(261021121427099003)(261022075727099003)(261009223027099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yqehak3Eq1kngSW0ibKcKngPM900Ft2zZpmxe28rnuIqZElJX6Cvqj6HN72rh0upPFEHETleErttUxU5yhIn0NVM0DK8wS87GnBm7gXIZozTbuJb65lbGaZNjkdSS7e0M2mzC+PDq6h/VUQKzBAdg4H3cXNqzT7wbxQuXLtcJdaShNsYpG/cezIcfltbYUtG6lomp/2SqEJ0uyOAdMNeWukZx3NJV7aG+PDS5FpmBduKTzQ4wxSJHIEhf6OVzBf3Gte225kIMEoYugaGdsJZaNCsdGO9m52LubazT5vmfMYydrL5vJrTpwWLmfPozd8TtTyUq9TFpBUelP3OwjQkLw83caMm9F0yOPLJDG9cWPWT3BKLsxyjTuu8sE5bHrr+7G2NE3qJYvPoVhR5bfmS15z/JU/6AGLedBn98INoJdw5CBqHfjbHrsOFg2Oweir/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:50.3742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b905fa-598d-4930-dfaa-08df3f5a00e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048913.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9558

From: Dragos Tatulea <dtatulea@nvidia.com>

This patch adds the data direct private flag infrastructure.
The MLX5E_PFLAG_DATA_DIRECT flag is needed in the follow-up patches to
detect the configuration of data direct from the user side.

For now the flag can't be actually set. This will be implemented in a
follow-up patch once all pieces are put together.

This patch doesn't introduce any functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 000493f42912..c5bbe5adea45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -264,6 +264,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_XDP_TX_MPWQE,
 	MLX5E_PFLAG_SKB_TX_MPWQE,
 	MLX5E_PFLAG_TX_PORT_TS,
+	MLX5E_PFLAG_DATA_DIRECT,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 1f534051cdfe..26f76449af35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2405,6 +2405,11 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_pflag_data_direct(struct net_device *netdev, bool enable)
+{
+	return -EOPNOTSUPP;
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -2414,6 +2419,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
 	{ "skb_tx_mpwqe",        set_pflag_skb_tx_mpwqe },
 	{ "tx_port_ts",          set_pflag_tx_port_ts },
+	{ "data_direct",         set_pflag_data_direct },
 };
 
 static int mlx5e_handle_pflag(struct net_device *netdev,
-- 
2.44.0

