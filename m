Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011014.outbound.protection.outlook.com [52.101.62.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159CD2BEC2A;
	Sun, 11 Oct 2026 13:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791725614; cv=fail; b=eT3p79hlFvarPF/AmR3OfGd/QEAuzgUc62Kjsdn49EtS1iTAAANT43KYTdXJu/zvoeyVUEpl17kGJwSRqN2+2EcTkk1NCiDZvD9o2Y0kp0uID1kbbTYVh6J0CtorWcADuYC/rPtSdhZZIOy9Vs5bX4ZamdOs0UyYUX6TkFeArrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791725614; c=relaxed/simple;
	bh=KJqb0kxIVDJGIdOtSo1lJCc3+8OmSMWzfk3x1lLTyRU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9JaQaicHw9dRvmVguSMzs9SmMWK/JYegEOlHvzIZlf8myIKwUz1Eu0Sisjhv5h0vMK85sNoDpb949NdbfGjc4mY31POy4l18BwQ0ilCIGUDwFrb3NG5BX7x8JEZj7qSoKr4YqvaeaKY19eJvtZrTF+CHb/2h/9GsYVRI9xpNX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lxh/hIXU; arc=fail smtp.client-ip=52.101.62.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lxh/hIXU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kkq/dyVWXWYZBtURIRUebR7wB+kPk9KH6qQzET/shDx38iIfIZGcEQPej+npS1o3V29LTLEc0T0e8rda7G70741VP9D3xyGfZpyyzulf2ROawHC7PUIL2es87QUhzB7cQDfWvNq8yaLmr/CAGPF/SZqI53iNHTGoYdciMcO9Tk2Ytw/hdOZGRT8JqGlZaqqa0SgyMxG30suGgnGaqYo/Nj+Qlo/mkcxo6YsC743tvwKzaBoaqU+RyvyOAje5SWDAefSUvNvPyqTw4/yUux/z1Bo6hJBxTYk/2uSPePQEhQcDuaxWz95eaIkci7HImEZIrRcIoxMchk7g8UTLSnLigQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plxIjL2f6Uwl2oo1f7j5zwXDHL5tCrCCR45m7CTBVsw=;
 b=T0E3QrquiH1GJKDb5Tl64P/F0qA7NRHRl2U5gW/GZzzwWc6z9XUjjl9xCIGoEUBZOhfLUjd9f4pkfrLFatH2iiHhlnDkX4Vf1V4wSnLOLEzizrsM11cGlFr6vwCGSmVjsN2/KB+hU776zgwy3fLCX6lO3FBhDDZ8ZXCZu9oClbIr0w90e917P/ZIAiUtmbpQ7Hb7+n2/GDlhJXCGrdt0aUTwSVV+xbfPjsiL7/witSCghAg2c1n861qoJjup017teSV5uD+8AwXKWFB7b2YugPUMzh5NQPiFKkCpWVy5kX8K2w4bT0HBq4ChndmbGHaCHTxA9cP41VIDv2zvlwLfIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plxIjL2f6Uwl2oo1f7j5zwXDHL5tCrCCR45m7CTBVsw=;
 b=Lxh/hIXUKQTZRs8Ecyx2A64mHdonUlIdP5JeyBjyOKimrK56SO7fCSMti+MrlG2wmZCb3bAzNDXQJQi/gmLDPLru89A4pZpWtDI7+szfDqwz4KTONAyHCCq89MlLrOdD41O8IEB/PVgv5tLdoiyoPnl1dEkedSbic44kWpnPevSCbO/STz4TtdORbLJxKYuFjbDRhVKE/6GovWkaUvmD+jJFFfS1MgY4lUI52B02HMFujZVbo5Qh9Pg2KiP0MuiIPl1nmuye7F/BK/K83x5jbwc8PJkg4+atGLm5abAq9tG2/OnJEoDuHHlX1jJT6Xfe6MoQu9TZdIE6VCaBT+285g==
Received: from SJ0PR05CA0142.namprd05.prod.outlook.com (2603:10b6:a03:33d::27)
 by DS5PPF5E0E7945E.namprd12.prod.outlook.com (2603:10b6:f:fc00::650) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Sun, 11 Oct
 2026 13:33:23 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::67) by SJ0PR05CA0142.outlook.office365.com
 (2603:10b6:a03:33d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Sun, 11
 Oct 2026 13:33:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 13:33:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 06:33:02 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Kees Cook <kees@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Mark Bloch
	<mbloch@nvidia.com>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>, Tariq Toukan <tariqt@nvidia.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>, "Adrian
 Moreno" <amorenoz@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH net-next 1/2] net/mlx5e: Batch NAPI RCU grace periods on channel close
Date: Sun, 11 Oct 2026 16:32:11 +0300
Message-ID: <20261011133212.807979-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261011133212.807979-1-tariqt@nvidia.com>
References: <20261011133212.807979-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|DS5PPF5E0E7945E:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4cb91b-af7c-47a3-5488-08df279c38c7
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|23010399003|1800799024|36860700016|6133799003|18002099003|22082099003|3023799007|11063799006|10067099003|5023799004|56012099006|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6vJd0ZkKE73M9ms0mU2He64y68m7I4c2BFHvy7kP4cME24ai2C9rT4AKEO6xj4RaXbQ7srEIIyqAK428UyVszf8FYhY/+RjLYjXHKrzBC41HvPrAWu7BisRQtdDW7GQWBXw35Wre4SnLvym8UOg9iTPOoq1Ud9QjNT3zf6uftOalXjrK2+XQ7Dm4LJ4HnPnJALU2LtSUvIb8G9fJmly1c98ZxGQ078XNFqLwP0eccSouXYjejsl6DX4DlRkMIt9JEAxfo5D/NkEesAruvdA+wTStVuzPYstaHptBodvJFVvIa5eqfuC4NR+74TdWHtzLJpd7VNFLvUdCjsHkicoiqx5EUjL4azLMx3ntAFPspbFYUAlCRGd5oYCKGosW3335/ImIt6nREI582YzEmRbc9NGfbzTFtjNR49KYdxu4zx5Z7kea8Q+VL48LCamMmAK8wo+9ZUk8kKgmIDHKdXnnwLAszwrrQe8KMoAmc5LJuo597tiYK13kRUurFLh6t9bUpQlKrUywWpkxFPXoVrLEy71q4mjGkN2w6o1bZlOhBW9L/aX++WH3IXbu9TLHoL8zifiTlQfQoAr6E8fLSAlILUItW6XWcFmBf9wRcIAqdyn7tk8aWJ9YYrIFrqdtwo3qw8sd88GZEkYPdUguIqqLAXhXoRf7WcnCY88k5ULgxMhsRLb2C9WeMw6Sl5MMQ85tcWcHnXgZc3gL54OG/D16WA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(23010399003)(1800799024)(36860700016)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(10067099003)(5023799004)(56012099006)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PVysFxw/Yz0rc45Z6P3Io7cpFLOH4cP8UtDToe7yUYuCvgL7X31KUl5cu9sYtsxjxJ9ZxvCG1/ulsL5VHDNoDzoG29quOHpjdr/q3LulkvK9wVHFhfSp1ndND4jqxwbxcTX/UOig+MWYvL+JEZ5N7RzXuQT6clD95iXqMRk+iomNZm++w/pR7TQmwJm25pLHikvkEBhN6FndG78xNJ0Kbum8F2Kr1OMrqrDFvOkJbTWRNCvciQu0/hSHGIGLM30CTPWdfTGx0g+OXh9CHcUB0cPfXXVI2LYK2KlO3PSi6J4r1DSJHRgzZWnO5wInvjP7h88EdcBevDQSeJzlupY/lKyxVPtYQPTnqpamRbZcrCTyEQSdSbozInGtNBkq0fAGFLepZZTgTfrIsrmiAfP0SCMlbtA4ZCDWuy4qRgKU4L0Gz2uvTUBrzu5plFeIDn/3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 13:33:22.9502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4cb91b-af7c-47a3-5488-08df279c38c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5E0E7945E

From: Carolina Jubran <cjubran@nvidia.com>

Channel close currently invokes synchronize_net() repeatedly while
tearing down each channel. RQ, ICOSQ, TX SQ and NAPI teardown each
require a grace period, causing the number of waits to scale with the
number of channels. TX SQ teardown adds a wait for each traffic class,
while XDP and QoS can add further calls.

Batch these waits across all channels. Split channel deactivate and
close into pre_sync and post_sync phases. First clear the ENABLED state
on all queues, then wait for a single grace period before continuing
with the teardown.

Similarly, unlink all NAPI instances with
__netif_napi_del_locked(), issue one synchronize_net() after all of
them have been unlinked, and only then free the channels.

Keep the existing per object synchronize_net() calls for single queue
paths.

248 channels, rcu_normal=1, ip link set eth2 down:
Before: 10.183s
After:   0.715s (~14x faster)

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  69 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   4 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  27 ++-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 204 +++++++++++++++---
 9 files changed, 282 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..1a169fce075a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1103,6 +1103,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
+void mlx5e_close_xdpsq_post_sync(struct mlx5e_xdpsq *sq);
 
 struct mlx5e_create_cq_param {
 	struct net_device *netdev;
@@ -1159,8 +1160,10 @@ int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
+void mlx5e_deactivate_rq_pre_sync(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
+void mlx5e_deactivate_icosq_pre_sync(struct mlx5e_icosq *icosq);
 
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
@@ -1170,6 +1173,8 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_sq_stats *sq_stats);
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_deactivate_txqsq_pre_sync(struct mlx5e_txqsq *sq);
+void mlx5e_deactivate_txqsq_post_sync(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_tx_disable_queue(struct netdev_queue *txq);
 int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 17084d76209e..3fa629228878 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -775,7 +775,7 @@ static int mlx5e_ptp_open_queues(struct mlx5e_ptp *c,
 	return err;
 }
 
-static void mlx5e_ptp_close_queues(struct mlx5e_ptp *c)
+void mlx5e_ptp_close_queues(struct mlx5e_ptp *c)
 {
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_close_rq(&c->rq);
@@ -932,7 +932,6 @@ void mlx5e_ptp_close(struct mlx5e_ptp *c)
 {
 	mlx5e_ptp_close_queues(c);
 	netif_napi_del_locked(&c->napi);
-
 	kvfree(c);
 }
 
@@ -954,18 +953,28 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	mlx5e_trigger_napi_sched(&c->napi);
 }
 
-void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
+void mlx5e_ptp_deactivate_channel_pre_sync(struct mlx5e_ptp *c)
 {
 	int tc;
 
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		netif_queue_set_napi(c->netdev, c->rq.ix, NETDEV_QUEUE_TYPE_RX, NULL);
-		mlx5e_deactivate_rq(&c->rq);
+		mlx5e_deactivate_rq_pre_sync(&c->rq);
+	}
+
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (tc = 0; tc < c->num_tc; tc++)
+			mlx5e_deactivate_txqsq_pre_sync(&c->ptpsq[tc].txqsq);
 	}
+}
+
+void mlx5e_ptp_deactivate_channel_post_sync(struct mlx5e_ptp *c)
+{
+	int tc;
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
 		for (tc = 0; tc < c->num_tc; tc++)
-			mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+			mlx5e_deactivate_txqsq_post_sync(&c->ptpsq[tc].txqsq);
 	}
 
 	napi_disable_locked(&c->napi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 2a457a2ed707..b42ce33635a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -129,8 +129,10 @@ static inline bool mlx5e_ptpsq_metadata_freelist_empty(struct mlx5e_ptpsq *ptpsq
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
+void mlx5e_ptp_close_queues(struct mlx5e_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
-void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_deactivate_channel_pre_sync(struct mlx5e_ptp *c);
+void mlx5e_ptp_deactivate_channel_post_sync(struct mlx5e_ptp *c);
 int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
 int mlx5e_ptp_alloc_rx_fs(struct mlx5e_flow_steering *fs,
 			  const struct mlx5e_profile *profile);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index ac4979087e0d..3e59862a0e60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -233,15 +233,20 @@ void mlx5e_close_qos_sq(struct mlx5e_priv *priv, u16 qid)
 	kfree(sq);
 }
 
-void mlx5e_qos_close_queues(struct mlx5e_channel *c)
+static struct mlx5e_txqsq __rcu **
+mlx5e_qos_unpublish_queues(struct mlx5e_channel *c)
+{
+	return rcu_replace_pointer(c->qos_sqs, NULL,
+				   lockdep_is_held(&c->priv->state_lock));
+}
+
+static void mlx5e_qos_free_queues(struct mlx5e_channel *c,
+				  struct mlx5e_txqsq __rcu **qos_sqs)
 {
-	struct mlx5e_txqsq __rcu **qos_sqs;
 	int i;
 
-	qos_sqs = rcu_replace_pointer(c->qos_sqs, NULL, lockdep_is_held(&c->priv->state_lock));
 	if (!qos_sqs)
 		return;
-	synchronize_rcu(); /* Sync with NAPI. */
 
 	for (i = 0; i < c->qos_sqs_size; i++) {
 		struct mlx5e_txqsq *sq;
@@ -258,6 +263,27 @@ void mlx5e_qos_close_queues(struct mlx5e_channel *c)
 	kvfree(qos_sqs);
 }
 
+void mlx5e_qos_close_queues_post_sync(struct mlx5e_channel *c)
+{
+	struct mlx5e_txqsq __rcu **qos_sqs;
+
+	qos_sqs = mlx5e_qos_unpublish_queues(c);
+	/* Caller guarantees that NAPI is stopped or was never enabled. */
+	mlx5e_qos_free_queues(c, qos_sqs);
+}
+
+void mlx5e_qos_close_queues(struct mlx5e_channel *c)
+{
+	struct mlx5e_txqsq __rcu **qos_sqs;
+
+	qos_sqs = mlx5e_qos_unpublish_queues(c);
+	if (!qos_sqs)
+		return;
+
+	synchronize_rcu(); /* Sync with NAPI. */
+	mlx5e_qos_free_queues(c, qos_sqs);
+}
+
 void mlx5e_qos_close_all_queues(struct mlx5e_channels *chs)
 {
 	int i;
@@ -326,11 +352,10 @@ void mlx5e_qos_activate_queues(struct mlx5e_priv *priv)
 	mlx5e_htb_enumerate_leaves(priv->htb, mlx5e_activate_qos_sq, priv);
 }
 
-void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
+void mlx5e_qos_deactivate_queues_pre_sync(struct mlx5e_channel *c)
 {
 	struct mlx5e_params *params = &c->priv->channels.params;
 	struct mlx5e_txqsq __rcu **qos_sqs;
-	u16 txq_ix;
 	int i;
 
 	qos_sqs = mlx5e_state_dereference(c->priv, c->qos_sqs);
@@ -346,7 +371,30 @@ void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
 			continue;
 
 		qos_dbg(c->mdev, "Deactivate QoS SQ qid %u\n", qid);
-		mlx5e_deactivate_txqsq(sq);
+		mlx5e_deactivate_txqsq_pre_sync(sq);
+	}
+}
+
+void mlx5e_qos_deactivate_queues_post_sync(struct mlx5e_channel *c)
+{
+	struct mlx5e_params *params = &c->priv->channels.params;
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	int i;
+
+	qos_sqs = mlx5e_state_dereference(c->priv, c->qos_sqs);
+	if (!qos_sqs)
+		return;
+
+	for (i = 0; i < c->qos_sqs_size; i++) {
+		u16 qid = params->num_channels * i + c->ix;
+		struct mlx5e_txqsq *sq;
+		u16 txq_ix;
+
+		sq = mlx5e_state_dereference(c->priv, qos_sqs[i]);
+		if (!sq)
+			continue;
+
+		mlx5e_deactivate_txqsq_post_sync(sq);
 
 		txq_ix = mlx5e_qid_from_qos(&c->priv->channels, qid);
 
@@ -361,7 +409,12 @@ void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs)
 	int i;
 
 	for (i = 0; i < chs->num; i++)
-		mlx5e_qos_deactivate_queues(chs->c[i]);
+		mlx5e_qos_deactivate_queues_pre_sync(chs->c[i]);
+
+	synchronize_net();
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_qos_deactivate_queues_post_sync(chs->c[i]);
 }
 
 void mlx5e_reactivate_qos_sq(struct mlx5e_priv *priv, u16 qid, struct netdev_queue *txq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index 4947afa23b73..8d171a1079e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -28,9 +28,11 @@ void mlx5e_reset_qdisc(struct net_device *dev, u16 qid);
 
 int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
 void mlx5e_qos_activate_queues(struct mlx5e_priv *priv);
-void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
+void mlx5e_qos_deactivate_queues_pre_sync(struct mlx5e_channel *c);
+void mlx5e_qos_deactivate_queues_post_sync(struct mlx5e_channel *c);
 void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs);
 void mlx5e_qos_close_queues(struct mlx5e_channel *c);
+void mlx5e_qos_close_queues_post_sync(struct mlx5e_channel *c);
 void mlx5e_qos_close_all_queues(struct mlx5e_channels *chs);
 int mlx5e_qos_alloc_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 5b8f4094d553..ea557a8310e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -130,14 +130,12 @@ static inline void mlx5e_xdp_tx_enable(struct mlx5e_priv *priv)
 		set_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 }
 
-static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
+static inline void mlx5e_xdp_tx_disable_pre_sync(struct mlx5e_priv *priv)
 {
 	if (priv->channels.params.xdp_prog)
 		clear_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
-	/* Let other device's napi(s) and XSK wakeups see our new state. */
-	synchronize_net();
 }
 
 static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 11500fd213a5..deb84ef29ca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -160,23 +160,35 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 err_close_rx_cq:
 	mlx5e_close_cq(&c->xskrq.cq);
 
+	c->xskrq.xsk_pool = NULL;
+	c->xsksq.xsk_pool = NULL;
+
 	return err;
 }
 
-void mlx5e_close_xsk(struct mlx5e_channel *c)
+void mlx5e_close_xsk_pre_sync(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	synchronize_net(); /* Sync with NAPI. */
+}
 
+void mlx5e_close_xsk_post_sync(struct mlx5e_channel *c)
+{
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
-	mlx5e_close_xdpsq(&c->xsksq);
+	mlx5e_close_xdpsq_post_sync(&c->xsksq);
 	mlx5e_close_cq(&c->xsksq.cq);
 
 	memset(&c->xskrq, 0, sizeof(c->xskrq));
 	memset(&c->xsksq, 0, sizeof(c->xsksq));
 }
 
+void mlx5e_close_xsk(struct mlx5e_channel *c)
+{
+	mlx5e_close_xsk_pre_sync(c);
+	synchronize_net(); /* Sync with XSK wakeup and NAPI. */
+	mlx5e_close_xsk_post_sync(c);
+}
+
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
 	/* ICOSQ recovery deactivates RQs. Suspend the recovery to avoid
@@ -189,7 +201,7 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	/* TX queue is created active. */
 }
 
-void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
+void mlx5e_deactivate_xsk_pre_sync(struct mlx5e_channel *c)
 {
 	/* ICOSQ recovery may reactivate XSKRQ if clear_bit is called in the
 	 * middle of recovery. Suspend the recovery to avoid it.
@@ -197,7 +209,12 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 	mlx5e_reporter_icosq_suspend_recovery(c);
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	mlx5e_reporter_icosq_resume_recovery(c);
-	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 
 	/* TX queue is disabled on close. */
 }
+
+void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
+{
+	mlx5e_deactivate_xsk_pre_sync(c);
+	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
index 664ec78192c3..66a0b09452f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
@@ -17,7 +17,10 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c);
 void mlx5e_close_xsk(struct mlx5e_channel *c);
+void mlx5e_close_xsk_pre_sync(struct mlx5e_channel *c);
+void mlx5e_close_xsk_post_sync(struct mlx5e_channel *c);
 void mlx5e_activate_xsk(struct mlx5e_channel *c);
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c);
+void mlx5e_deactivate_xsk_pre_sync(struct mlx5e_channel *c);
 
 #endif /* __MLX5_EN_XSK_SETUP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f90b5a34e097..fe4e5d0b2e9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1458,9 +1458,14 @@ void mlx5e_activate_rq(struct mlx5e_rq *rq)
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 }
 
-void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
+void mlx5e_deactivate_rq_pre_sync(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
+}
+
+void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
+{
+	mlx5e_deactivate_rq_pre_sync(rq);
 	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
@@ -1954,13 +1959,15 @@ void mlx5e_tx_disable_queue(struct netdev_queue *txq)
 	__netif_tx_unlock_bh(txq);
 }
 
-void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
+void mlx5e_deactivate_txqsq_pre_sync(struct mlx5e_txqsq *sq)
 {
-	struct mlx5_wq_cyc *wq = &sq->wq;
-
 	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, NULL);
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
+}
+
+void mlx5e_deactivate_txqsq_post_sync(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
 
 	mlx5e_tx_disable_queue(sq->txq);
 
@@ -1978,6 +1985,13 @@ void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	}
 }
 
+void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
+{
+	mlx5e_deactivate_txqsq_pre_sync(sq);
+	synchronize_net(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
+	mlx5e_deactivate_txqsq_post_sync(sq);
+}
+
 void mlx5e_close_txqsq(struct mlx5e_txqsq *sq)
 {
 	struct mlx5_core_dev *mdev = sq->mdev;
@@ -2089,9 +2103,14 @@ void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 	set_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
 }
 
-void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+void mlx5e_deactivate_icosq_pre_sync(struct mlx5e_icosq *icosq)
 {
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+}
+
+void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+{
+	mlx5e_deactivate_icosq_pre_sync(icosq);
 	synchronize_net(); /* Sync with NAPI. */
 }
 
@@ -2141,18 +2160,28 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	return err;
 }
 
-void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+static void mlx5e_destroy_xdpsq(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI. */
-
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
 	mlx5e_free_xdpsq(sq);
 }
 
+void mlx5e_close_xdpsq_post_sync(struct mlx5e_xdpsq *sq)
+{
+	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+	mlx5e_destroy_xdpsq(sq);
+}
+
+void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+{
+	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+	synchronize_net(); /* Sync with NAPI. */
+	mlx5e_destroy_xdpsq(sq);
+}
+
 static struct mlx5e_xdpsq *mlx5e_open_xdpredirect_sq(struct mlx5e_channel *c,
 						     struct mlx5e_params *params,
 						     struct mlx5e_channel_param *cparam,
@@ -2184,6 +2213,13 @@ static struct mlx5e_xdpsq *mlx5e_open_xdpredirect_sq(struct mlx5e_channel *c,
 	return ERR_PTR(err);
 }
 
+static void mlx5e_close_xdpredirect_sq_post_sync(struct mlx5e_xdpsq *xdpsq)
+{
+	mlx5e_close_xdpsq_post_sync(xdpsq);
+	mlx5e_close_cq(&xdpsq->cq);
+	kvfree(xdpsq);
+}
+
 static void mlx5e_close_xdpredirect_sq(struct mlx5e_xdpsq *xdpsq)
 {
 	mlx5e_close_xdpsq(xdpsq);
@@ -2749,6 +2785,27 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	mlx5e_close_cq(&c->icosq.cq);
 }
 
+static void mlx5e_close_queues_post_sync(struct mlx5e_channel *c)
+{
+	if (c->xdp)
+		mlx5e_close_xdpsq_post_sync(&c->rq_xdpsq);
+	/* The same ICOSQ is used for UMRs for both RQ and XSKRQ. */
+	cancel_work_sync(&c->icosq.recover_work);
+	mlx5e_close_rq(&c->rq);
+	mlx5e_close_sqs(c);
+	mlx5e_close_icosq(&c->icosq);
+	mutex_destroy(&c->icosq_recovery_lock);
+	if (c->async_icosq)
+		mlx5e_close_async_icosq(c->async_icosq);
+	if (c->xdp)
+		mlx5e_close_cq(&c->rq_xdpsq.cq);
+	mlx5e_close_cq(&c->rq.cq);
+	if (c->xdpsq)
+		mlx5e_close_xdpredirect_sq_post_sync(c->xdpsq);
+	mlx5e_close_tx_cqs(c);
+	mlx5e_close_cq(&c->icosq.cq);
+}
+
 static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 {
 	u16 port_aff_bias = mlx5_core_is_pf(mdev) ? 0 : MLX5_CAP_GEN(mdev, vhca_id);
@@ -2936,35 +2993,56 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 	netif_queue_set_napi(c->netdev, c->ix, NETDEV_QUEUE_TYPE_RX, &c->napi);
 }
 
-static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
+static void mlx5e_deactivate_channel_pre_sync(struct mlx5e_channel *c)
 {
 	int tc;
 
 	netif_queue_set_napi(c->netdev, c->ix, NETDEV_QUEUE_TYPE_RX, NULL);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
-		mlx5e_deactivate_xsk(c);
+		mlx5e_deactivate_xsk_pre_sync(c);
 	else
-		mlx5e_deactivate_rq(&c->rq);
+		mlx5e_deactivate_rq_pre_sync(&c->rq);
 
 	if (c->async_icosq)
-		mlx5e_deactivate_icosq(c->async_icosq);
-	mlx5e_deactivate_icosq(&c->icosq);
+		mlx5e_deactivate_icosq_pre_sync(c->async_icosq);
+	mlx5e_deactivate_icosq_pre_sync(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_deactivate_txqsq(&c->sq[tc]);
-	mlx5e_qos_deactivate_queues(c);
+		mlx5e_deactivate_txqsq_pre_sync(&c->sq[tc]);
+	mlx5e_qos_deactivate_queues_pre_sync(c);
+}
+
+static void mlx5e_deactivate_channel_post_sync(struct mlx5e_channel *c)
+{
+	int tc;
+
+	for (tc = 0; tc < c->num_tc; tc++)
+		mlx5e_deactivate_txqsq_post_sync(&c->sq[tc]);
+	mlx5e_qos_deactivate_queues_post_sync(c);
 
 	napi_disable_locked(&c->napi);
 }
 
-static void mlx5e_close_channel(struct mlx5e_channel *c)
+static void mlx5e_close_channel_pre_sync(struct mlx5e_channel *c)
 {
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
-		mlx5e_close_xsk(c);
-	mlx5e_close_queues(c);
-	mlx5e_qos_close_queues(c);
-	netif_napi_del_locked(&c->napi);
+		mlx5e_close_xsk_pre_sync(c);
+}
+
+static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
+{
+	if (c->xskrq.xsk_pool)
+		mlx5e_close_xsk_post_sync(c);
+	mlx5e_close_queues_post_sync(c);
+	mlx5e_qos_close_queues_post_sync(c);
+}
 
+static void mlx5e_close_channel(struct mlx5e_channel *c)
+{
+	mlx5e_close_channel_pre_sync(c);
+	synchronize_net();
+	mlx5e_close_channel_post_sync(c);
+	netif_napi_del_locked(&c->napi);
 	kvfree(c);
 }
 
@@ -3060,33 +3138,72 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
 	return err ? -ETIMEDOUT : 0;
 }
 
-static void mlx5e_deactivate_channels(struct mlx5e_channels *chs)
+static void mlx5e_deactivate_channels_pre_sync(struct mlx5e_channels *chs)
 {
 	int i;
 
 	if (chs->ptp)
-		mlx5e_ptp_deactivate_channel(chs->ptp);
+		mlx5e_ptp_deactivate_channel_pre_sync(chs->ptp);
 
 	for (i = 0; i < chs->num; i++)
-		mlx5e_deactivate_channel(chs->c[i]);
+		mlx5e_deactivate_channel_pre_sync(chs->c[i]);
 }
 
-void mlx5e_close_channels(struct mlx5e_channels *chs)
+static void mlx5e_deactivate_channels_post_sync(struct mlx5e_channels *chs)
+{
+	int i;
+
+	if (chs->ptp)
+		mlx5e_ptp_deactivate_channel_post_sync(chs->ptp);
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_deactivate_channel_post_sync(chs->c[i]);
+}
+
+static void mlx5e_close_channels_pre_sync(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_close_channel_pre_sync(chs->c[i]);
+}
+
+static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
 {
 	int i;
 
-	ASSERT_RTNL();
 	if (chs->ptp) {
-		mlx5e_ptp_close(chs->ptp);
+		mlx5e_ptp_close_queues(chs->ptp);
+		__netif_napi_del_locked(&chs->ptp->napi);
+	}
+
+	for (i = 0; i < chs->num; i++) {
+		mlx5e_close_channel_post_sync(chs->c[i]);
+		__netif_napi_del_locked(&chs->c[i]->napi);
+	}
+
+	synchronize_net();
+
+	if (chs->ptp) {
+		kvfree(chs->ptp);
 		chs->ptp = NULL;
 	}
+
 	for (i = 0; i < chs->num; i++)
-		mlx5e_close_channel(chs->c[i]);
+		kvfree(chs->c[i]);
 
 	kfree(chs->c);
 	chs->num = 0;
 }
 
+void mlx5e_close_channels(struct mlx5e_channels *chs)
+{
+	ASSERT_RTNL();
+	mlx5e_close_channels_pre_sync(chs);
+	synchronize_net();
+	mlx5e_close_channels_post_sync(chs);
+}
+
 static int mlx5e_modify_tirs_packet_merge(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rx_res *res = priv->rx_res;
@@ -3376,7 +3493,7 @@ static void mlx5e_cancel_tx_timeout_work(struct mlx5e_priv *priv)
 		cancel_work_sync(&priv->tx_timeout_work);
 }
 
-void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
+static void mlx5e_deactivate_priv_channels_pre_sync(struct mlx5e_priv *priv)
 {
 	if (priv->rx_res)
 		mlx5e_rx_res_channels_deactivate(priv->rx_res);
@@ -3394,8 +3511,21 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 	 */
 	netif_tx_disable(priv->netdev);
 
-	mlx5e_xdp_tx_disable(priv);
-	mlx5e_deactivate_channels(&priv->channels);
+	mlx5e_xdp_tx_disable_pre_sync(priv);
+	mlx5e_deactivate_channels_pre_sync(&priv->channels);
+}
+
+static void mlx5e_deactivate_priv_channels_post_sync(struct mlx5e_priv *priv)
+{
+	mlx5e_deactivate_channels_post_sync(&priv->channels);
+}
+
+void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
+{
+	mlx5e_deactivate_priv_channels_pre_sync(priv);
+	/* One grace period for XDP, RQ, ICOSQ, TX, QoS, XSK and PTP. */
+	synchronize_net();
+	mlx5e_deactivate_priv_channels_post_sync(priv);
 }
 
 static int mlx5e_switch_priv_params(struct mlx5e_priv *priv,
@@ -3611,8 +3741,14 @@ int mlx5e_close_locked(struct net_device *netdev)
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	netif_carrier_off(priv->netdev);
-	mlx5e_deactivate_priv_channels(priv);
-	mlx5e_close_channels(&priv->channels);
+
+	mlx5e_deactivate_priv_channels_pre_sync(priv);
+	mlx5e_close_channels_pre_sync(&priv->channels);
+
+	synchronize_net();
+
+	mlx5e_deactivate_priv_channels_post_sync(priv);
+	mlx5e_close_channels_post_sync(&priv->channels);
 
 	return 0;
 }
-- 
2.44.0

