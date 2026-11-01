Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793516365;
	b=WKMKPLsYBmD0ch32i4Qi2FP6rd1FcGDSBkbUSNGnvXP6B26lDUDFLwdGLNTuJEuxtP7X
	 BoefjxRTwL4fQc0bd8zzK1jDnDfIkYyqC0PV4A/CkhPXFLGWzSk3oemwJ4xtD0QxmLj6H
	 B94VT9+GaYcylVPacnqONNLfG9XsKV5ryvG9R3gU6B8l86DTJ+OxZ4UiGTVlV0s/hKk2H
	 EpjBsx1eKDWlZll2OGsLKjrzNZcV7COWEBdWRRdauGHQUawMdokpRrVJBjZmYnXmcB/oT
	 hsJlN8EegghKp14a9vNidEJBAXUC4doIlypJPf2NOAPAEXB5nf8LAg9GM4Sua60jeqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793516365;
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
	bh=lpqTz4OM9Ut97NfdEFjpNZQ2yJgreBzp/Nk1/XMAYg0=;
	b=GgOvPebSBJFwluvjplJHSpm7XWZxtDpQiDJOnFhjdOFB7cYw/day9Hb6ewI7w4oFkkJX
	 IkEdgUTXrA/uFHMMCwU/K7umC+G7v6zN5woZzFnfZQjb8ZFBkqOlmRHnXM9dLACpfaOnF
	 NP7tXdCXoQOE+U7aKuYL95ASTQHR330tdYvt8YMj/gKx7DtjEPr/0Z7lhvutF1lOBDlVJ
	 9+1Xb/MgmxYmaevA68lgRmhF7D1MmbHJ677RzSgmkauwgOtqFz5r5frmf6jk6F9sYoq9q
	 G6PVqfPhod9jnb1dcQ6LR69YFOKEEOFOcOtrIvxtpm4zwy1KHIyv39LDEemYE7xVNDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gJ36rkW7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.50
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013050.outbound.protection.outlook.com [40.107.201.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1F0606A324;
	Sun,  1 Nov 2026 06:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C1F0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gJ36rkW7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWpb/vzakyPm+mkGlpJWaMNGB6JkbLQCM7BS3jGsft2sJUnfBGUCV+e5TJ1NQOmllVZOha/z9Obed1aHaBYXhI163A8dpDMblhOwtYohjeHXW1qkBXheJ6ibEQdKu899ik+aWrXFwGj4yiuoa73fUXh8aBFeZm5daFtBycqA9tInm4dt7pq/XrzgShr2tjbBm7lBLD1QmeEhXQ/0ULpFQ4JlI4kgVINSrWNsEr0cwAhsNMehe+ZwmS7yQrYtLyKv83PujfonvW88Swe6DSDIOmQZMUqwdFmqWtslLxMAR9ARPLGhNJkb6mAFBDHXTLrwoBCo1Cp+frloNyzYaq4kfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpqTz4OM9Ut97NfdEFjpNZQ2yJgreBzp/Nk1/XMAYg0=;
 b=j6ZcwPonqTaMt0FRKYp22XPPUBux/QL4WVTQLzCf96221CYQxGvxTr05ayA9fbkt+fBeEhsZBkofgPldYXlCQ6ltiAbBrVNTjKNHlPscaUgsW6/FhNjTWlkBIfV3Sk8U+ipeVrfxyUcJFx0PyyLeuIeicnYIG1kWo2RgRLXG1IOMGcU4CMvLdUx82Ch5Uev29niXrRjKTKKE1YlUnWR2LBRrMYNqbVDEUiqdJKKKp8tXFACU+V4BQd2RzCFPcYWZF6ngQoaQHQODpLKurMG7SFnea5PiuyMcV2bP4jOfV+BlC6Gt4OTcDqjtpGuHpoDkJ3nHR0i4IVjtHSK1Hzeakw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpqTz4OM9Ut97NfdEFjpNZQ2yJgreBzp/Nk1/XMAYg0=;
 b=gJ36rkW7HlGKgF1a5J5fZu7p6ryBoo/chCunIGTZjdzfzzVYoBkrZ4pugxNNUcFu9hThMwHYx8FvtecAi4oNEEOl80ZYn6vpnVYd7SkPg2dwF5DtJQ/5QP192KQF1zGJDc9wpKWY03TU5+rVb/E5Llt5sK8mxCs0NlI4A4DlGNXO+tx/96UhtMc0cHYzfyvRoO1LhqZqp8dzR/8yqNeYsziV7Z7yJxd8kkwqCTNgh6qicfiTswnNkHhiLoyGx2dY2rbCiR1TQog2wiif+HtDy4A4ZXk9A/EJ7YCudJSFWQJE9cLkI0o9ijgF0cOxiQjbJKwQcG+o+tq0+Wb8nzxGYw==
Received: from CH0PR03CA0393.namprd03.prod.outlook.com (2603:10b6:610:11b::21)
 by SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sun, 1 Nov
 2026 06:59:20 +0000
Received: from BN1PEPF00018546.namprd05.prod.outlook.com
 (2603:10b6:610:11b:cafe::8a) by CH0PR03CA0393.outlook.office365.com
 (2603:10b6:610:11b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.11 via Frontend Transport; Sun, 1
 Nov 2026 06:59:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018546.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Sun, 1 Nov 2026 06:59:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sat, 31 Oct
 2026 23:58:58 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sat, 31 Oct
 2026 23:58:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Sat, 31
 Oct 2026 23:58:53 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, "Maher
 Sanalla" <msanalla@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Add missing Ethernet multicast octets to vport_rx_bytes sum
Date: Sun, 1 Nov 2026 08:58:33 +0200
Message-ID: <20261101065833.282261-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018546:EE_|SA1PR12MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 923cc554-991b-43b0-fea8-08df37e5a6ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|18002099003|56012099006|11063799006|261026121527099003|261021121427099003|261009223027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	p0L/qzu/7PwwQ8L17RNDFMmMH2BjyjZVEPsbZ715SLWfoSk943cN/Copmi3sGc9fLGrjcJoeguYj3pG98ENciux4x7wyhsSctF+E0/Xi8jaoI3punNQ+uRa+9vN+hROmCuimJpJLDQ4XuHHNKx16q6c5p4VNydbjjeL1cgXWPiFzraTyf0myudM0SGCF12PNOi1+GW2fsFamN3zVKZK+uvlaLoiHNRwwkk2V52CIWAXC6MfcueGXaFpAergKLtvQ6lE9nZoQdXvXiW/mIpjmGYF6BW03Lb3Ap9NCX5bg64K+jQX/66Gq+ren55fJku9lJM/+EAP+IUTTmSVBEEHvrgzKTrRw2QX0dpl1Y8s5USae5ZftZP/p/2Hb6gtSSfVIcgF8fVlV6xsWcypijlnIjDD/h+2GSqxJfZyENOEMMNmmSCBNeNYVtn0DPJ63AqXdX1wFQzeLVQQ1a9z47PGwDHSzGXXwE2f2AnQLm9q27GQSoH4ZW3didSa9FCuoSozGdE/Fpvysb20IIJ8uHvR9buo/f66sX5vs3wGmSl0YzBB8QKSaKGevl0iILJgDXzc2PwNr845O67bfneJaw0+kuDiBHsO32lGfxnpq9DSTUjrxS3WnB1miXMfnUaFBQdfHupFzcl5SrD8fSdt5269YQ8J4Y/vhSYk+Hq4rSUujue1wdF+ykxSs/zkfEE0ImGm+SN5ZBK3LWFrgldF9dcASSw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(18002099003)(56012099006)(11063799006)(261026121527099003)(261021121427099003)(261009223027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wjtXbt+GhVMLVDr1DX7HmfDSgkHSjYQYuQYkuzwu8CIsK6Wm5aKbMOz13Exlwj2Uj8KcMAot9o2eHb9RSi9wfxwP6btK2sI31VIL2MGZBQTgdtA1sGhJfNNmYpQ+jo+jqDNaZqldkGu/ayHf3SJbSEwB3mEuM6Z1b1ke8cg0IYBXVYG2s28rmmy2OkXhJ7lALQ25VlRT5YG4s+wHRK1mT4l+v4PzuWX6TMvQm2RxISFC2khf0/PyaYa4WTNVdH3ClxuLgbfJ/Q1tWQdRLaUBClZ7IaO5WwUECFjbYHVCO6Jp/rJngHH6AhLjEezSQGUF4w8/RdqpxCQwtduY5peuHbbjaK5V2WqDGaR769BujeHIgzSfoyoCFczSJsfGZuUuWPtnbBiXBtmUAHUC0ZdLYkLQpTH4rGjAu6/48AjSSsHqvne5mstieoD6oNzWqCaw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2026 06:59:19.5682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 923cc554-991b-43b0-fea8-08df37e5a6ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018546.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5614

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5e_rep_update_hw_counters() adds transmitted_eth_multicast.packets
to vport_rx_packets but does not add transmitted_eth_multicast.octets
to vport_rx_bytes. As a result, Ethernet multicast sent by a VF/SF is
counted in its representor's rx_packets but not in rx_bytes.

Fix by adding transmitted_eth_multicast.octets to the vport_rx_bytes
sum.

Fixes: 64b68e369649 ("net/mlx5: Refactor and expand rep vport stat group")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 88a170e40bd9..a50a42581528 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -238,6 +238,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 		MLX5_GET_CTR(out, transmitted_ib_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_unicast.octets) +
 		MLX5_GET_CTR(out, transmitted_ib_multicast.octets) +
+		MLX5_GET_CTR(out, transmitted_eth_multicast.octets) +
 		MLX5_GET_CTR(out, transmitted_eth_broadcast.octets);
 
 	rep_stats->vport_tx_bytes =

base-commit: cb284914e749388eef402938bdb3115fe1f6d337
-- 
2.44.0

