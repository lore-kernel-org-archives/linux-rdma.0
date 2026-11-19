Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795084829;
	b=4sp8rsSD7hHRlzGnKBQazLZICbKYyRIvLJ4iz5DM9aanLftrfubEIBIGOJURtcB35boV
	 islfjMXQMN+tqAFF2HfTGUhoVsPy8eQkEJm430VnrXZrtjxj64w1srMT/tP7UCuF2O1/W
	 Ou8lyrZRYK0S87j0ciTxUzitjxRZxUDRv/wsPxe3U+3YIL3zTBuzxk8p5FvrwgK3OZjYT
	 rLT9pdWwOUZKN+x/BEjfBPLz1ygHep9HGSa+oVABXt0e4G5JpwHKAqPJhRPcmsiSOP1AG
	 O3NDLyue+7P8zJmJ4IApZL4nMLO7+DvCuw8dk03Po/o27N3ptvcLbt4RMs5bLY8bKMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084829;
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
	bh=COpq7cRLav9KjEn+mpexnGg2szDWNwKA/sO8BBeQSWc=;
	b=0vvWBv/JYJd15ewOQWeTwZSVoPyudyAkqzEzxMH+pmwIKK+9rY/YNvefF77qupDlwZLb
	 6Gw1uS3rL4sPH/hyvybxia0M1fkIx0Gmpx5aqoqNn0eAuOdr4JdKYzD71UcBgkPaOkBZ+
	 sT+v3Jdgk6sq12mgXzNk4h3+kraXf99wbz6+iC4sCTAJNG395vJNVm3fxTBFs31/i6Ow+
	 ILdgzYXQrbpjrme3dCQE2ViEEKTbCGAkODP/q13T5rVJ5IFDPZgmCFuAb0UC4SguPfe5z
	 i1YydAEhEPPLxdtySxy5vfYgWcCt4xtEgeRYRCEOF2Fmd5bsL/VH9iqdUtLIEI50K6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PisEc085;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.5
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012005.outbound.protection.outlook.com [52.101.53.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD5A606A320;
	Thu, 19 Nov 2026 10:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD5A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PisEc085
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5vX34NlM8WJKxcCtu9gFwWoMGvV9VQpVaEhecfn0Bpl8A8QpSJgJoXj5k733ILMmFlPzPBkmmx/a9PYxD7gUJRDAUC4jFCQYrnQIxVwId5WyWBb6Xjqf+G0JDKbuAnYeYenG70ullgaCkrHqfh/AccoK/ToBJHn3RXsOLemeCw+h3NHN3xVMhuTRoptK+9PcKWscSpC7GW9uakCxScBXEyEQ0Irah1RqW0nXfdaCOMmJvf0ugbKMLxAWSfh1rtFiOn+CgSdjYlYKCsYajj08jrGS2Hc7fPSeN2DCDvEaFNNYHH9+ABGW3enqLORXvAkPyCNetOP1gvaXEqagA6VtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COpq7cRLav9KjEn+mpexnGg2szDWNwKA/sO8BBeQSWc=;
 b=d59PCzeU/6YOTtAGoIUs1PkEbkAfJDDVpRMSqzAi7NIYk8lwhBM9JjjEVGPfR4HBetL4dkX7bzvssaT/EaqW15566gBp962gtduvAPgdLn0iBzvCE6CZoxED65yBDql0x8iDRGEAPyl8L3wmIoZoHlcylODaZVeZKXvlMH76IS6ax3OacTHQfbthF0g2xA+JRdx+YR1xvY/akyVqVuOffrQGOTo7N7N13DDfO93mOnzS5mO09FJQJ2LDL0ZRXVX5m5ijMcRy+G9QmmJcyjffw74o6Mg2q3Xf3B9glxCIvcDkTuTkW8WzdP97W2U7YizSNQZNrRGkeEa4ScDiVz3NYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COpq7cRLav9KjEn+mpexnGg2szDWNwKA/sO8BBeQSWc=;
 b=PisEc085NczFLNYnA3w+1iwQmLvL7QZQBFJ3CqtY92oCsm2KUYENu6ndifn3uDkFLb19DMozXddKW6PXMGEqQRIDC+Sn/iF+v4XDD9gOinRkUnHqtBHVKbPYcfzftRuQTVPDUSOHvBuk89M3PBVYMt8PLyVt0pKgVgiZx6z6ilDsKtJlI3G34C4ke34QrOwBjscbKDpCXXHg18iWupjQ6mn4K+dMxus8G/6X20Iqk6CvTdsHHHZ0iGGJfVu+6m8ODZ3/iT1WCHCMMDm6M2N6HuMnU65Yzw9tpPYcMQSNoZfviSI8J7CQsk9HxShT6CrpSvipAhpHoT6RQ0vw4BRW9Q==
Received: from PH7PR17CA0067.namprd17.prod.outlook.com (2603:10b6:510:325::13)
 by IA6PR12MB074433.namprd12.prod.outlook.com (2603:10b6:208:5fc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Thu, 19 Nov
 2026 10:40:25 +0000
Received: from PH1PEPF00062F26.namprd02.prod.outlook.com
 (2603:10b6:510:325:cafe::85) by PH7PR17CA0067.outlook.office365.com
 (2603:10b6:510:325::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 10:40:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH1PEPF00062F26.mail.protection.outlook.com (10.167.243.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 10:40:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:40:08 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 19 Nov
 2026 02:40:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 19
 Nov 2026 02:40:01 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Kees Cook <kees+treewide@kernel.org>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Stanislav Fomichev <sdf@fomichev.me>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH net-next V3 2/2] net/mlx5e: Batch ICOSQ trigger RCU synchronization
Date: Thu, 19 Nov 2026 12:39:35 +0200
Message-ID: <20261119103935.2190627-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261119103935.2190627-1-tariqt@nvidia.com>
References: <20261119103935.2190627-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH1PEPF00062F26:EE_|IA6PR12MB074433:EE_
X-MS-Office365-Filtering-Correlation-Id: a18f14fa-7018-44c3-0786-08df4629840d
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|82310400026|23010399003|10067099003|56012099006|11063799006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022075727099003|261022105027099003|261022113327099003|261026140227099003|261028144727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qPnoeGop00WJMTyIQmGUcGVldAywfMRA21F4E0KMtirrWaRf2GSHfvmwdWcdNqY2w1FTAJOSdkb5pGlXq/nYTs8CMpS+ckyK58k5mS/H9VhnjY/Vgty5DD8OjBCVtZdnjz5iF9P9PGs38ANoii6psEhh8fz68RnGFsMrcpoZgB6Vs5nhouXcqW3N3pQs01VcdZk6A+u8+1ldUAiZcZDf16mKqDN5RD6EWzE7KbaW8GEVuEcYRVssJJVOO8BpuoVJeJpXf2fpJR0O8NEZXENysxuUH61C0i9ClwPrt4TAyq+RlBi43ihM1WqiY0lAkXfTGepbpHiFW+tESO1K0d/98bgmplVmHBRKP7rAOTfisPtKBYtNe1mopJfJcxLK2wLK3Q8ssQ/0z3HL3DjB4X+B+LopQse0h/EvV8rnehpcFQ6lnHdkpsa8/fzjUp8qZ1YE6aeJIU0jsTER7NyBgop7TveNDIkrPU2mg8+qRD/EMuQ5ljmw+lSr04cFl4Hs33SbRRBwtZ0dQGekFG4gJg70YeNblA8DeK8WLHIRnay+6JwdEuGORHUDtiDxGmy8uGJyqeEQOfLbbcmw7sZhiQVjMuGhWxZU10ZKC2BDJz7lnL4RwturGOZkgm1ExxzEeK5ZDLYoTa7tLqh+SvNjD2cNi9b/6WmBpPe8mktABgvIQGgtVxnc5+XvdNtggL+lGON8uqll69PolWYwRDzjKo1Oxg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(82310400026)(23010399003)(10067099003)(56012099006)(11063799006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022075727099003)(261022105027099003)(261022113327099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jWwY1oA9YE94qCzga1Lu7Kch7ahRDnoCq86gvMIeO9AY2m8t9uG4iDQlJbnp0he0WzD2VUHtQYQ6iFsh5YSEPcsmndhgFBmB0FC9pZI6oR9aey2YANPgGDK4eLwDWWvK35DlvZmbWuu7w5WEnNpFEMcCbYRZ5t3Ev6lKsvIEO2YxQkmDJx/0nF1YxBSqDtS4O/JI+NEwh1AwfnYXkWWmLral5au2NLsktWCJ8MYGYk/XR6PZxbkWLohNrkHTHunL0DNlKmu6+bUTktG0JhDjy4VK9X5AlQIrxZyE8VkFsk0IjzeYbXw9VSU0VWFIgSAVJfOqbM/iFhkzDtCHTR3EgHYXoCratV1o5Gj+YtnpoaGmQPp7ChxpoMapQI5R86Q4GP2ukQYl6AZw47UWqIhL13izSfvM9G7I5kNjqJ8Ohw0GGClBTBFlwrIppGpHa/sq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 10:40:23.1986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a18f14fa-7018-44c3-0786-08df4629840d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH1PEPF00062F26.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR12MB074433

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
Before: 4.087s
After:  1.080s (~3.8x faster) 

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65e86b4cef85..e599968d06d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2799,14 +2799,11 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
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
@@ -2814,6 +2811,13 @@ void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
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
@@ -3057,6 +3061,19 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
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
@@ -3067,8 +3084,7 @@ static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channe
 	if (priv->htb)
 		mlx5e_qos_activate_queues(priv);
 
-	for (i = 0; i < chs->num; i++)
-		mlx5e_trigger_napi_icosq(chs->c[i]);
+	mlx5e_trigger_napi_icosqs(chs);
 
 	if (chs->ptp)
 		mlx5e_ptp_activate_channel(chs->ptp);
-- 
2.44.0

