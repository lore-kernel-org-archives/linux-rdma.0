Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F90A4A8A2C;
	Wed,  2 Sep 2026 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377907; cv=fail; b=XdRqni7cPLWEisE4REXwRVXOVHlqC2gSkPg5P6oMm8v8dobT+Jb6r3ugUwYjo/s67ViLa4dvxn2lI4sfU4GEyBRL+qadlHTqTm/WC8RLLohjkwVdkXEGDehvYNZ+5TtasrhvRizQMNnGRL9w6cISDTv8SPtmeR/aFEW6Zd89VAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377907; c=relaxed/simple;
	bh=q6R9rCxgbKP0HdoNZySFcvzZq09TxZ4AdudZ46G/ehY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fW2Y7VezwQwldk4KsXnkgZOeynMEhs7yIE5Va37nzH6OalCKzvxWy8fa1DZRl9gaBfrW7iKizCzL3GeuVTQWNuM4jnsYL4z1k+Sy4xQOyiB/o/xaQvcbwpbgnm2fredQkXM3b6IHH7cFyjD798kLASX0CG6c8XU45iizaK8CB/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SnGIBkP6; arc=fail smtp.client-ip=40.93.196.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SnGIBkP6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tp5EF1dcXf0J1yXXb/lfSkvV2B0FeH3n/L8q4RM+7v+wL3d83MA9+ayGgRjDpyoIllzwXkV2HtrilCKrL/to/qXloLnDIOxEVLWpkCxtTE4AJG7SLGKG9pjWUVrG9Y7RvN2AK9oPrJOg/OzRPI9ThHXz2kcv85lEBCP5FpWAkBrrBDwW3KUhM0jkrNW89kB2/K2KHR/c81mxYwlCQVUAzkW46gvFMi21RNN4qHxEkBi7JFKJ4ILNLesh+FOtKtGjT7Xrybl0ZTyhlhAbxChidMkUWnxeDroVIHIVoo3t1X+DmDAypf5S34ose/VGgCIQjoI8E3dffQG+11DbRQ1JXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGBRj2JdpssG4a7zRM6dThpjWKZJlRfESKX2YkXh6pg=;
 b=VAAZawN3/c7/zb6fmWqWkeK+WrhqQ6NO9B5p1jiLPadPt0nwJOVwKvpN7BOJMGBdJf+NQySY0db1JNibov0PUlF0ReXnll3YyVgL6AHkrcSrRw8MXQ0SWTZiLSoQpMYvIFlq7FuaMe14fTGe4IjjN8gWNyUVkda+Td7PIqROYEt0OwFQkvUtWonuBvnuTWjRm7FhXPBXbvE4A53+9vK//nQsrZUZigOoQaMMlRhm/U2rgsvrv8OZS8Y11P5Og72B/xpouz39CmjiZ6b2nZyGWnbIwDp3NgLyi8xrz3fFECy/iDnaUqseyomsozWdmWF9Ft84K53iMlV6nyLApMB9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGBRj2JdpssG4a7zRM6dThpjWKZJlRfESKX2YkXh6pg=;
 b=SnGIBkP6m3fAYyuo/1k7Gt/TsSmCNkqxQR/cIQ7JsLBHRaN0zNG08itu1jirDbXiiGuQ1HidyVkYRVk1Zi1TvffzY1eixr16CvAJqELCSZrCvX0/Ta7U9kz+qRPXi/aGELRPoXqEew5u56rkTIvIPLu+yw3FBNnoILlzKdaM4DeJhZEd215wMiU4qAeBOQU9Teln+gbBJbEWgonTlZoe0k1RXebEWfKb9Lyg03NwkdqbrCvCQY9NUjUvvDKU6U/iLCB7WM8AiNnDdU44EnriTaDshNUDGT/m5viPf2zHjnlenYWdbLz2Ujn5AqPjqBiGujwmDUg9b55/7QJqOMl4yg==
Received: from DS7PR03CA0062.namprd03.prod.outlook.com (2603:10b6:5:3bb::7) by
 DS7PR12MB6213.namprd12.prod.outlook.com (2603:10b6:8:97::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Wed, 2 Sep 2026 19:38:05 +0000
Received: from DM2PEPF00003FC4.namprd04.prod.outlook.com
 (2603:10b6:5:3bb:cafe::9b) by DS7PR03CA0062.outlook.office365.com
 (2603:10b6:5:3bb::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 19:38:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM2PEPF00003FC4.mail.protection.outlook.com (10.167.23.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 19:38:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:37:44 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 12:37:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 2 Sep
 2026 12:37:39 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, Richard Cochran
	<richardcochran@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shahar
 Shitrit" <shshitrit@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Keep HW timestamp stats monotonic across reconfiguration
Date: Wed, 2 Sep 2026 22:37:31 +0300
Message-ID: <20260902193731.3668958-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC4:EE_|DS7PR12MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 92b699b8-b460-4593-54be-08df0929b53d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|7416014|376014|10067099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	wRkvpmHA6qsEjdU998dKX2GGDSwuZ3pOkVN3qRhe0y1bHnBbJGPed9z9pW7hwcTrgjKV3e93jVtCj6/hy8vHtv59mHdGv8DqG+w97q74AFDOXDpmSPvTXRACD8SCa4riQaXQInrHOqckjV68adQSZ5I9f364nEra7XzOHKqzT5j2WFCy7bEoZntS6A4Kaw8HSyqtWkYUPx42r3cSlMuTqAqat+i2Nx5OQsx+IROBWZZT4U1P9HbCdadpZXBheJSJfYFEKOj2Pr3qZxAMCQzq/N6hRLsKJihV90aG79ZwK+78hTCCA54KQAeRpmSsiFpfiFhmjLBfkS1kMLYdhapP1RJ74ZNgqJrnYyEc8I7rdInc6AN1Mtgr5ReXp8Zvo2fg80HWAA5qTxMQj6tGRCfwnvpy0vYwhotC+o2wJNTOjWvQgnhflLxy3mSivRBnHAUXYPTWW5ISZxF5pMgIq3p0xS3khN8f3XMu5itEx1dImsuIc9WJUDpACoHFn6m0+s1cBGduWb2ngKpgTXj/9KMJAonlPxSeZuNzoIdpUKeSraialiNwzeX6bimoRlTthTBmz4itFFUXPI3w1uAmbXwctdxgRTcI0NGSmk4XE0kem+49CegPaCy2xovHeGe6fx29/v0G/jKhclBxPKVYo8M2Brbs8HWldlrxZH9dG+KFvkQJfZEu7PzOPzSfckqkPYwGf8pkBdv0uX3SjJYzjV7pyA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ye0xGD06bYGbf5qBQwmvGFJmTdcDViW6q/25e/Qm0HNs9UdmuIMBr7AxWKFE9wuX3jLLhhLOcpOyvpEHQ+YMb066obzXjKzXFhK/SBiL0JdZkwwvIxrf9lhgaXgQBjWkOjnF9HGlmkXoHba5h0yBvncuwqxqeuSUklPn77BP2SWpAbmGtO6z6KaKc3w+dYP6KnTC4WkQt/fvd68vMAcBwILVOhqTlsAaObemK9YjQtsJSBGX1k7egZw1c79N1gNUIYldtuZcjO7iD8QxCiKcUChvF0ptMr0CXjLVolZEbPMRzxry72ynYsh4nCpfmVGYuSqta0FWzTCAacNJfso9oM9HfYf/OtjZVfUNTTp3l7YQlo16lPg6xHReCczWbf96Ikugheqwa4EdQki8ZO0A270HSfwWlXtmMLD1Sg4IzJEBEvQWL/1WQA6PFknLUSC6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 19:38:04.7454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b699b8-b460-4593-54be-08df0929b53d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6213

From: Carolina Jubran <cjubran@nvidia.com>

`mlx5e_stats_ts_get()` currently selects either DMA or port timestamp
counters based on `tx_ptp_opened`. This flag is intentionally kept set
once the PTP TX queues have been opened so their statistics remain
available after queue teardown. As a result, DMA timestamps are no
longer reported after switching from port timestamping back to DMA
timestamping.

The function also reads statistics only from the currently active
channels and TCs. Reducing the number of channels or TCs can therefore
drop previously accumulated timestamp counters from the reported value.

Read the persistent channel statistics instead and always include DMA
timestamp counters. Once the PTP TX queues have been opened, also
include the port timestamp counters.

This also drops state_lock. It previously protected live channel/PTP
pointers, the new code only reads persistent channel_stats and
ptp_stats via mlx5e_stats_nch_read(), which is already safe for
lockless stats access.

Fixes: 3579032c08c1 ("net/mlx5e: Implement ethtool hardware timestamping statistics")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 51 ++++++++-----------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e7e6db7f6bf1..cd94bb44f6ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1199,50 +1199,39 @@ void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
 void mlx5e_stats_ts_get(struct mlx5e_priv *priv,
 			struct ethtool_ts_stats *ts_stats)
 {
-	int i, j;
+	u16 nch = mlx5e_stats_nch_read(priv);
+	int i, tc;
 
-	mutex_lock(&priv->state_lock);
+	ts_stats->pkts = 0;
 
-	if (priv->tx_ptp_opened) {
-		struct mlx5e_ptp *ptp = priv->channels.ptp;
+	for (i = 0; i < nch; i++) {
+		struct mlx5e_channel_stats *channel_stats =
+			priv->channel_stats[i];
 
-		ts_stats->pkts = 0;
+		for (tc = 0; tc < priv->max_opened_tc; tc++)
+			ts_stats->pkts += channel_stats->sq[tc].timestamps;
+	}
+
+	/* Accumulate DMA and port timestamp counters so values stay monotonic
+	 * across channel teardown and mode switches.
+	 */
+	if (priv->tx_ptp_opened) {
+		/* Err and Lost stats are only relevant for port timestamping,
+		 * as the DMA layer will always successfully timestamp packets.
+		 */
 		ts_stats->err = 0;
 		ts_stats->lost = 0;
 
-		if (!ptp)
-			goto out;
-
-		/* Aggregate stats across all TCs */
-		for (i = 0; i < ptp->num_tc; i++) {
+		for (tc = 0; tc < priv->max_opened_tc; tc++) {
 			struct mlx5e_ptp_cq_stats *stats =
-				ptp->ptpsq[i].cq_stats;
+				&priv->ptp_stats.cq[tc];
 
 			ts_stats->pkts += stats->cqe;
 			ts_stats->err += stats->abort + stats->err_cqe +
-				stats->late_cqe;
+					stats->late_cqe;
 			ts_stats->lost += stats->lost_cqe;
 		}
-	} else {
-		/* DMA layer will always successfully timestamp packets. Other
-		 * counters do not make sense for this layer.
-		 */
-		ts_stats->pkts = 0;
-
-		/* Aggregate stats across all SQs */
-		for (j = 0; j < priv->channels.num; j++) {
-			struct mlx5e_channel *c = priv->channels.c[j];
-
-			for (i = 0; i < c->num_tc; i++) {
-				struct mlx5e_sq_stats *stats = c->sq[i].stats;
-
-				ts_stats->pkts += stats->timestamps;
-			}
-		}
 	}
-
-out:
-	mutex_unlock(&priv->state_lock);
 }
 
 #define PPORT_PHY_LAYER_OFF(c) \
-- 
2.44.0

