Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336702;
	b=o/c4vcbdRdpohIUgWfiWNfQYhcYmY5yz034mx/UoZ7gYxGmxI9cx2FcynQ/5/iA+BpHv
	 Pz0YApc68m/20CYVmSvxzhBpUx6AMeWVbRWtfgVoI/s39+fvwQgsWzLDP3pI6qGIpNLJt
	 vpA2DmH0V+UZ/a7ey3VYya9SXGBnWeEJcxkvQxwqdlfeJPfvjbdO4k/56QblQNJqdUbij
	 wVL5UtesKQ3Ay9mE5dgOb6KHlC16B5FwKmEsLifi1F2KF0hQ4le7uAXPn9Po33pQ7ynsC
	 6LxYY2k/4idGijfy/YqEfXT2hYLNaFEn5UabNBfHUAsGgXRcNViyGkO3I3Tpt9tzecA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336702;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
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
	bh=/4oGOhaamHF4seuAGCNwe1TO1I3nwECDlckD3fVXNeI=;
	b=KIL2AhK71JUr/lVh1XAVMx3ATZ+0kPuurM40uHqkuqfLM/QPIG9jWQmwfCwjSmODEBk9
	 edpN4NLm3VF64wTPJX1pupNpu0FxUWI5RR7VYsCv6K1RtAQSuvqQW3FVkstTLL5Fd0IjP
	 zm4bYTYC7gdsj52c1VF0SKLK5znIxQFXccKHzWkPx9siP8iJXJpP5snwBOJEoqg5cZSIX
	 siPpM8VNd+QfSSvjdhA6hOWLWHkevZ/uaJ9u5ULZ+50vgGeI6gAuUjKKAhSk1sXHna2iS
	 SC4lSGWr/pp2STkYadaX3h9VqZv55mBoCLdhHyl2EVs/cc5bqXUWFd0RsvDBDXLTauA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jegMaMpJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6C4606A32E;
	Tue, 10 Nov 2026 18:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C6C4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jegMaMpJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfgTMTaX+XwL0txwHVy6FgditIqq2q6Q+6VjH/gzYWlpyrCmMIvH4CSs0vmC0T/zJHZZ89B/sXBbTTQ8WWsmeE9Px6+ZK/AMsStn5GPY5TM6PaoMbRnWTj0AUOKreu+xe9EYhdxLqW+ZT3gEVdmYRv33+33eACPwx1j/nPXbR3Y+NPd+mRjlHPxJpZuQqvrlZERb6E/4bMd0htcU1GYk3onYmxvkn+/PAlFHkkogjhTXD0F7cnPWdW9SRa1g+YjH1kDzL7iW/iQY3v6AOs8Mo8W3k3Ne8PaDj6oGFmanq+ceyCbQkCFY3yOfhOIbcb3Cyrf0ysJG2DjyAGQTI6XQOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4oGOhaamHF4seuAGCNwe1TO1I3nwECDlckD3fVXNeI=;
 b=MbUiJXOoriN9puCHo+SWS3Rt7o6ihlnl+y/SQ1MNcZZhp3CoBO18RkVlxiTRUuWouEQE8BfQIksaN/LEj8XQWcymhnG1ql+QdxL1IFehIqD94EMdSlCarDALTTioVrQFhQyUe84djbJVQXOTERmBTEcTpdTvcShtK0W3Q95ymzRBmngzSSKQr0NEuj+rmAJnCSk1sCbLeVEVOXlEjKI4CZJPP7oIBJNm2dLzvMq3EvFKb1mkpnBi0nKAmukotIBk4el6iSyht1oNC785R70PXLnSXG4+S+vX8pHAwwqq5Rgm/9jO11/+luahdmkmoXoxZqtZ/FUvw5dcIxCXGbyS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4oGOhaamHF4seuAGCNwe1TO1I3nwECDlckD3fVXNeI=;
 b=jegMaMpJgAsnq96sa0BPnbzDLxN/1IJLnHJ4+hMepxcpFFP8MB0MD5DVZugfm0P6pt3j6CCEoPwXc3KqXCDgNEgsVYbmkRiFNWy22cuHxFB0Ts7rK5nGGyKCwWpr1JvN7xor7YM2PRzruFc45dAwkEl5vDoWAB7B5LL8LAkwpHfObwxotCd5476D/ifis3ourrbKxhnZ5ODYOhYsOl4ZZ2g3QG+nluPutgwWsOoY7NjF2CtmtWa3wQnRp70Rak3ngQL7ZsveuzqlD4r3VCW2NziOXMOdVLEpbkQfe9ZSkyNEISqUVzAcCnhF3zoqASuBvmye6x4ZBYR8cITuNbBH6g==
Received: from CY8PR12CA0005.namprd12.prod.outlook.com (2603:10b6:930:4e::13)
 by DS4PR12MB733313.namprd12.prod.outlook.com (2603:10b6:8:50e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:51:37 +0000
Received: from EA8PEPF0000000C.namprd05.prod.outlook.com
 (2603:10b6:930:4e:cafe::af) by CY8PR12CA0005.outlook.office365.com
 (2603:10b6:930:4e::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:51:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 EA8PEPF0000000C.mail.protection.outlook.com (10.167.249.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:51:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:52 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:50:39 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Leon Romanovsky <leon@kernel.org>,
	"open list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, "Li
 RongQing" <lirongqing@baidu.com>, Mark Bloch <mbloch@nvidia.com>, "Richard
 Cochran" <richardcochran@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>, Stanislav Fomichev <sdf@fomichev.me>,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 2/2] net/mlx5e: Batch ICOSQ trigger RCU synchronization
Date: Tue, 10 Nov 2026 20:50:05 +0200
Message-ID: <20261110185005.2932568-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110185005.2932568-1-tariqt@nvidia.com>
References: <20261110185005.2932568-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: EA8PEPF0000000C:EE_|DS4PR12MB733313:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c6426a-1228-4b48-d970-08df3f5ba5f9
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|376014|7416014|23010399003|18002099003|22082099003|6133799003|10067099003|11063799006|261009223027099003|261028144727099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|56012099006|261021123027099003|261022113327099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	dIxhuCbHlnNvl5qYgLbR71al5rdByeUjHxEaS/BiQ2bTP7Jdj87c6uPXjKl9wnWNAcKlyzgt5L96xhm5xxAz0KeuFqQJpJSOgNGBOGiqYz9KCEw1FlslRy84qXc0RuHPeKCk97Y10TyKTSH//HzcEdQn+4Q53WVFK0aWGaUqLkKRZI2VFuYWqkBnQ+FVYfSo63inG3rsk1qaNJNLSVPeeYhXc/Sp8dFs2vdH5LOjWKATpMsT1HLO3UqBCeRf4mzuKLSBvXue7sjus8wITTlhgXfXHjXxWzIWaQ8yShCaWvJeVpYY87rXTl0GgeWoS5ion8rLEZqwoB/4yN1NePlnu+J/VhGDrd2zohHPb8GAQYO/5VMljLih08oPvnTVN2GA2r7NmfSM3xSoiHZHveaO9jQigUeCrhwsuB773W1A80klC/rRgW5ujmTi7gp3pGMhWCIRLL8eb2/CHEU2gdotapNCc3LIuahXSWpp0bJSW6wVO/ANAMMYCzdci566paVAMtfOcFJ5+6lzvvsOgpxO+1BpW6IZoriBChZPMrjFyJdGB0bq6KAa2wlC6rjeGQgv4xzWJpj7Vae/zcAiDPYmjuorZYL6/JM+MB8JiftjPnCZw2nulct80rksUasPS/FETcLCFCM7MoGZp34bpg9/MWi6Qoid7Y46fFF8kQmU8Y0ydyzW5yRuvgbGzsX6BK1ixidBQhiNEhQyW7JHbLtHaQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(376014)(7416014)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(261009223027099003)(261028144727099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(56012099006)(261021123027099003)(261022113327099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ojph21dhJ/IM44LrGF+D/R3fhxpS5EkvY7oxB2IWQCVSdlOLPs2cvBPasYaPIoatpGudNNEPRNGIKySyOIHMnTiC9AOhADi1a0fwWHa+dez5sdGB/DjB+TmbNDhabGkpEUSANHcT0gAM6fy12E4XCq2d4rAQPl9v5MEY33+nDo2o4ZjWBRiqu8ll5rgHQpD/UZkXMHyzgnUBLx+wP6nAz0R4uhPgAsIQ+83J3mxDpN5fLYVIeilYZh/P9hAi3qj/xI2VIuo+IJvEXMXI53Nfsitz4C1DI3aR20B/9qpdjajYucbCqlltFMqDihF5W9h189A93rXAPuKDR4DSmp/hxgSEIMtjU7TzDulD2txbKl7a467aT3KUyh3fi1PE5vmBw3qr2gHbzWSEpOi1EzmMR0NkXHDhJpSSJg4gJzHsfTavgB2pVtS8HIJSmR954/BS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:51:36.8050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c6426a-1228-4b48-d970-08df3f5ba5f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	EA8PEPF0000000C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB733313

From: Carolina Jubran <cjubran@nvidia.com>

During channel activation, mlx5e_activate_channels() triggers the ICOSQ
once for every channel in order to kick NAPI. mlx5e_trigger_napi_icosq()
sets MLX5E_SQ_STATE_LOCK_NEEDED and waits for an RCU grace period before
serializing the trigger with ICOSQ users in NAPI context.

Mark all channel ICOSQs as requiring locking first, wait for a single
grace period, and then trigger all of them.

Keep mlx5e_trigger_napi_icosq() with its existing synchronization
semantics for standalone callers.

248 channels, rcu_normal=1, ip link set eth2 up:
Before: 3.095s
After:  1.794s (~1.7x faster) 

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 73b504ba8c8c..0726c42290b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2837,14 +2837,11 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	return 0;
 }
 
-void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+static void mlx5e_trigger_napi_icosq_post_sync(struct mlx5e_channel *c)
 {
 	struct mlx5e_icosq *sq = &c->icosq;
 	bool locked;
 
-	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);
-	synchronize_net();
-
 	locked = mlx5e_icosq_sync_lock(sq);
 	mlx5e_trigger_irq(sq);
 	mlx5e_icosq_sync_unlock(sq, locked);
@@ -2852,6 +2849,13 @@ void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
 	clear_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);
 }
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+{
+	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &c->icosq.state);
+	synchronize_net();
+	mlx5e_trigger_napi_icosq_post_sync(c);
+}
+
 void mlx5e_trigger_napi_async_icosq(struct mlx5e_channel *c)
 {
 	struct mlx5e_icosq *sq = c->async_icosq;
@@ -3105,6 +3109,19 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	return err;
 }
 
+static void mlx5e_trigger_napi_icosqs(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++)
+		set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &chs->c[i]->icosq.state);
+
+	synchronize_net();
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_trigger_napi_icosq_post_sync(chs->c[i]);
+}
+
 static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
 {
 	int i;
@@ -3115,8 +3132,7 @@ static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channe
 	if (priv->htb)
 		mlx5e_qos_activate_queues(priv);
 
-	for (i = 0; i < chs->num; i++)
-		mlx5e_trigger_napi_icosq(chs->c[i]);
+	mlx5e_trigger_napi_icosqs(chs);
 
 	if (chs->ptp)
 		mlx5e_ptp_activate_channel(chs->ptp);
-- 
2.44.0

