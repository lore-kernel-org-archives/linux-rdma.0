Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795084825;
	b=o+MAej8vDd0eEjXffc8ukpSTInIx2fQBm6mCsSYuWSdXh8LXXxN7rHm60omX2xUHzO58
	 SjjReiBGreHBTa2uLFa49qdX5gmQxjjYHGV8WxU4qydACmGTBwV8M4dSZhZvPq2oOGyeo
	 RYy7gniHvJw6exjfJEnG84j1Esi1VjzKmj8Ehb0l474SNXHS/Wdt59BkXNmHei7zus3xq
	 pO4jcF0hvQxIi4IVDu6/3mHH0rqDpoVyg/WO4F4VVjuNZvdTPsFwdBEAQa5gq2QA87pdH
	 hQ+agzGya7WIo3ihA05mP6PQi3M/vbZ0wwZoSJhKgHTQ883jAPzwmAAMZU/DvUZrxZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084825;
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
	bh=kNHTZryAJQS89PP/ZSM4IqLnWuir5JiBlTFMR/UDDmc=;
	b=fim6gQ+UVhpIKAnXst0U+u2JxO0ToFqTSNerdf8uGyO0QkaJdOxOTJQQ8ldVR9iFd/Dy
	 9LbiFo9p5apIRq3/Bu/bdv86DCqJmo6gph+rvvgqqYyFHyl+dZvta1JzFFEvcnaUym5c3
	 AxlUJBpBC10TDMBdM5VbrRNqY2BPM1R45xC+g8YXxzIp5Mufa/1eN/DZM/wjNsP+50NR4
	 5CRpx53T3izgbKe08Ir8uvUBR7dmcEkjIfWNQ0WLknVv/TIu7ZGMp09tYQQndBCJCVPMv
	 2iofjFL3fBetMXBDniuJdBMF/3eraxB5nXm2sBPu2hCEh7AgZOUoPQXbYzLOB4Q5Klw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sHzbxxaS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.33
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010033.outbound.protection.outlook.com [52.101.46.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882960A260D;
	Thu, 19 Nov 2026 10:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E882960A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sHzbxxaS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWh1n3UCJSV0bQUDJ4if4QuUo3pfvB13DTRjeziDZxJmx879MNvNtk2jYJm5VOuyhH/2iDLjnzeOGq9klf0HawVE3k9jXpcYdqdExyeUNxy6+qEwmBOry5cPBouIoffNZXThBNBxZc6j3wXrQsaBHhIrGqqJqrx4JOnCqJjh0dP9kdnmhhpGQgMo3gs3xrlHOgVzLL/4fwTnrmGGdLcLL+6zMPngluPMCvX0lP2GTLke+BcQaf+rU/XGhEQezgvqrzELsueV5qhLM6Y7qW/80kCeQCfxoFSiCHShq9PEgBrcNndRJgFPB7M4msFNru+GuPLZYNtRNJnUyAsynd7nbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNHTZryAJQS89PP/ZSM4IqLnWuir5JiBlTFMR/UDDmc=;
 b=aizPy3EXvzgfXR5p45WRzqhc9jhNaB+qf35X3jUHvMRbnNKy9I5yqauxg8vVf4weITWSl3mnRWuNtPRu0YPYUOTIlIDXfmuo0TLqC9axKdoLyWX/pE1XDyoGITXruggr5d2Mh+KSBp3s2ATSESEhOmcH74C5HnQ4Zkr8K119aDX7ayPd3ea7QhHuElbNhnQobXuh8P9RtMycInMtP+wpu2e0b5mR15ZDVjmezE6LIKKx/kXX/PxWl+DY4bqJRehEzWYlYmz14LUqq68XNGG0xW3ojwtTufCoIgABWsHY/YlyYhwMJWde/yulbjJI6pO7BuUoLFC+yHPdN55Xb7S1Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNHTZryAJQS89PP/ZSM4IqLnWuir5JiBlTFMR/UDDmc=;
 b=sHzbxxaSh2WP6f7lHx7PmoxipYtGMbBoHnJzHUsUXzEWCzsiaFy7x0vYvOHL208PkobrHDQM7JomajgsE6+ScPkZz0luby+2pLA1g4mkOKhXvlK0QuLKUXmUlNvFzgVNbs0wytNf/FwkRT9cUvLMloBxnr3Qzsg/1gfv+NjauDFPxdZCzkiKHyr+kgAuOOppvGhqDOANKnaZ9oHKH4E1xs5bFvLEbXSM6Y6aSVu5otAVxpdomN5/jZ8CYjQKcueITdVxhzAFemHcjzDEYc/G2PQ0mQNdyXkBtGR7UocQPLFQskQwFwRYhXop4FuHVfeV3lnKmCgfCfgAsRSlQGhd1A==
Received: from PH8PR02CA0049.namprd02.prod.outlook.com (2603:10b6:510:2da::25)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Thu, 19 Nov
 2026 10:40:15 +0000
Received: from PH1PEPF00062F28.namprd02.prod.outlook.com
 (2603:10b6:510:2da:cafe::a4) by PH8PR02CA0049.outlook.office365.com
 (2603:10b6:510:2da::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 10:40:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH1PEPF00062F28.mail.protection.outlook.com (10.167.243.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 10:40:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:40:01 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:40:00 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 19
 Nov 2026 02:39:54 -0800
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
Subject: [PATCH net-next V3 1/2] net/mlx5e: Batch NAPI RCU grace periods on channel close
Date: Thu, 19 Nov 2026 12:39:34 +0200
Message-ID: <20261119103935.2190627-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH1PEPF00062F28:EE_|DS0PR12MB8270:EE_
X-MS-Office365-Filtering-Correlation-Id: 2004fcd6-a8a4-47e2-9df6-08df46297f5b
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|7416014|82310400026|23010399003|5023799004|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|11063799006|56012099006|261021121427099003|10067099003|261009223027099003|261102123227099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	wPO9Ge1zbHxcqvF4l706LA7RBYU1aOR27tjTB35knqJOnu0wp9lOSQld0qy4JaHrgUHfc5FPFhA5wO/VnBWe+r3ANe1T3kQSfz/NhKIPpK8EWuyMZmD9DDcsZHi7NG5grjFbZyjVPGafnpa3X39dcH/7SkIcDHo2wFx0VvUz0Uh1z4r3H2pwIFLXqIcS9eXgHipDbdZzHM2gdSgUI8yex1uU+2CJkBzbDub+In4Y5r4eCm8ZVPk8xI/URV8bTctPKtDdoZwOTQivkh7FwKCtAWvatILSPgptV/QGHAAAfAyJgktghez67Seq9CDVGwPUsF0VWL4nroKvSpKYC+RzlFOjfhrG6jPs04x+BCFeQQytt4QBzL65vUuGiT7nfSBWtMjWzSJCMubsYfHbJqvDMjxadNMzV+xhqK2pG/1MbECQxNrFgxYJVHtjEkfv1RXYJTeKEoxPcXv7THLxbUdRuyDCUzrDdH3Yb7fzpx3FfE34LehmNfhldsSGwxj/dAFF5PtZk3F69tI9GrHFxF4/gnIWObGuMm6XEM2IYvJWiItAswqJ2yHmMaLMS1R3pYFTDLzq34L3UQ6UlijbUs8G7Xi5xb6gS4gSiMAdVc5839ZN5Mk5N7ynU39PQrsZxj7mzaPB6wj6YlHebZ1GMBdyhBfbjzUlpcrkjQREGXSHsZ4uBgEykuZoMe33Id7MWoCUuh8rjiON+PnLPpZ1tZlyNw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(7416014)(82310400026)(23010399003)(5023799004)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(11063799006)(56012099006)(261021121427099003)(10067099003)(261009223027099003)(261102123227099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e78bkth98SvoqY0EWACxZx6y0xZjnSldMdPwVJhAKiYpgr7UAInC2KsxeX8HZ0kXL7/qnUDvK9WsTzLSYOFHxS97VqqEq778xWW6mviR8PZ+612L88flVR1lVWES9wPClsqXYkV/nEZH1ZJs3BfAKt0PadXkYDnC/BvXdFv6IlwEmkRccEe/+EdiAZ1vYaEVIFCDwzyyQjOWAD7qPN7eWHYufQZUEqf1E2lyEKaiTBJtI1Myuu/pcPVzd+EehjeUpUo/6UMC5klmEIWB9MEAB8se/YYFU7tLnheI7eQoXIMtzvS8vmzHmdLUAOcMVGFMDgPDuKqYMxGvf6ujwH5g+vqe+CWk+ZKUqp/wQR7w0mZQQVLyOt1cfN24uKPOid4NWUbtvDPphtKPCg5o/WO3OKqHrLNMepAvjwyCHPaw2MexKeffXH7AAd8wEpCcQGX6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 10:40:15.3650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2004fcd6-a8a4-47e2-9df6-08df46297f5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH1PEPF00062F28.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270

From: Carolina Jubran <cjubran@nvidia.com>

Channel close currently invokes synchronize_net() repeatedly while
tearing down each channel. RQ, ICOSQ, TX SQ and NAPI teardown each
require a grace period, causing the number of waits to scale with the
number of channels. TX SQ teardown adds a wait for each traffic class,
while XDP and QoS can add further calls.

Batch these waits across all channels. Split channel deactivate and
close into pre_sync and post_sync phases. First clear the ENABLED state
on all queues, then wait for a single grace period before continuing
with the teardown. Once NAPI is disabled on all channels, wait for one
more grace period, as the poll may still arm the CQs after
napi_complete_done().

Similarly, close the queues and unlink all NAPI instances with
__netif_napi_del_locked(), issue one synchronize_net() after all of
them have been unlinked, and only then free the channels.

Keep the existing per object synchronize_net() calls for single queue
paths. Drop the one in mlx5e_close_xdpsq(), as its callers already
wait for a grace period or run before NAPI is enabled.

248 channels, rcu_normal=1, ip link set eth2 down:
Before: 11.837s
After:   0.817s (~14.5x faster)

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  27 +++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  42 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 -
 .../mellanox/mlx5/core/en/xsk/setup.c         |  22 ++-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 126 ++++++++++++++----
 9 files changed, 185 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..657a7d59c845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1158,8 +1158,10 @@ int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
 int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
+void mlx5e_deactivate_rq_pre_sync(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
+void mlx5e_deactivate_icosq_pre_sync(struct mlx5e_icosq *icosq);
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
@@ -1169,6 +1171,8 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 		     struct mlx5e_txqsq *sq, int tc, u16 qos_queue_group_id,
 		     struct mlx5e_sq_stats *sq_stats);
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq);
+void mlx5e_deactivate_txqsq_pre_sync(struct mlx5e_txqsq *sq);
+void mlx5e_deactivate_txqsq_post_sync(struct mlx5e_txqsq *sq);
 void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq(struct mlx5e_txqsq *sq);
 void mlx5e_tx_disable_queue(struct netdev_queue *txq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 2edb55afff1d..f67f6beaf190 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -928,10 +928,17 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	return err;
 }
 
-void mlx5e_ptp_close(struct mlx5e_ptp *c)
+void mlx5e_ptp_close_pre_sync(struct mlx5e_ptp *c)
 {
+	/* NAPI is disabled and synced, or was never enabled. */
 	mlx5e_ptp_close_queues(c);
-	netif_napi_del_locked(&c->napi);
+	__netif_napi_del_locked(&c->napi);
+}
+
+void mlx5e_ptp_close(struct mlx5e_ptp *c)
+{
+	mlx5e_ptp_close_pre_sync(c);
+	synchronize_net(); /* Sync with NAPI and page pool readers. */
 
 	kvfree(c);
 }
@@ -954,18 +961,28 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
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
index 2a457a2ed707..47d4bae5f354 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -128,9 +128,11 @@ static inline bool mlx5e_ptpsq_metadata_freelist_empty(struct mlx5e_ptpsq *ptpsq
 
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
+void mlx5e_ptp_close_pre_sync(struct mlx5e_ptp *c);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
-void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
+void mlx5e_ptp_deactivate_channel_pre_sync(struct mlx5e_ptp *c);
+void mlx5e_ptp_deactivate_channel_post_sync(struct mlx5e_ptp *c);
 int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
 int mlx5e_ptp_alloc_rx_fs(struct mlx5e_flow_steering *fs,
 			  const struct mlx5e_profile *profile);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 3176549eff3e..604c9e67c16a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -233,7 +233,7 @@ void mlx5e_close_qos_sq(struct mlx5e_priv *priv, u16 qid)
 	kfree(sq);
 }
 
-void mlx5e_qos_close_queues(struct mlx5e_channel *c)
+void mlx5e_qos_close_queues(struct mlx5e_channel *c, bool sync_needed)
 {
 	struct mlx5e_txqsq __rcu **qos_sqs;
 	int i;
@@ -241,7 +241,8 @@ void mlx5e_qos_close_queues(struct mlx5e_channel *c)
 	qos_sqs = rcu_replace_pointer(c->qos_sqs, NULL, lockdep_is_held(&c->priv->state_lock));
 	if (!qos_sqs)
 		return;
-	synchronize_rcu(); /* Sync with NAPI. */
+	if (sync_needed)
+		synchronize_rcu(); /* Sync with NAPI. */
 
 	for (i = 0; i < c->qos_sqs_size; i++) {
 		struct mlx5e_txqsq *sq;
@@ -263,7 +264,7 @@ void mlx5e_qos_close_all_queues(struct mlx5e_channels *chs)
 	int i;
 
 	for (i = 0; i < chs->num; i++)
-		mlx5e_qos_close_queues(chs->c[i]);
+		mlx5e_qos_close_queues(chs->c[i], true);
 }
 
 int mlx5e_qos_alloc_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
@@ -326,11 +327,10 @@ void mlx5e_qos_activate_queues(struct mlx5e_priv *priv)
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
@@ -346,7 +346,30 @@ void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c)
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
 
@@ -361,7 +384,12 @@ void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs)
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
index 4947afa23b73..57abeb5887b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -28,9 +28,10 @@ void mlx5e_reset_qdisc(struct net_device *dev, u16 qid);
 
 int mlx5e_qos_open_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
 void mlx5e_qos_activate_queues(struct mlx5e_priv *priv);
-void mlx5e_qos_deactivate_queues(struct mlx5e_channel *c);
+void mlx5e_qos_deactivate_queues_pre_sync(struct mlx5e_channel *c);
+void mlx5e_qos_deactivate_queues_post_sync(struct mlx5e_channel *c);
 void mlx5e_qos_deactivate_all_queues(struct mlx5e_channels *chs);
-void mlx5e_qos_close_queues(struct mlx5e_channel *c);
+void mlx5e_qos_close_queues(struct mlx5e_channel *c, bool sync_needed);
 void mlx5e_qos_close_all_queues(struct mlx5e_channels *chs);
 int mlx5e_qos_alloc_queues(struct mlx5e_priv *priv, struct mlx5e_channels *chs);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 5b8f4094d553..10fd91eda9b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -136,8 +136,6 @@ static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
 		clear_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
 
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
-	/* Let other device's napi(s) and XSK wakeups see our new state. */
-	synchronize_net();
 }
 
 static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 11500fd213a5..1bdccb823eb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -163,11 +163,9 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	return err;
 }
 
-void mlx5e_close_xsk(struct mlx5e_channel *c)
+void mlx5e_close_xsk_queues(struct mlx5e_channel *c)
 {
-	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	synchronize_net(); /* Sync with NAPI. */
-
+	/* Caller guarantees that NAPI can no longer access the XSK queues. */
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
 	mlx5e_close_xdpsq(&c->xsksq);
@@ -177,6 +175,13 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 	memset(&c->xsksq, 0, sizeof(c->xsksq));
 }
 
+void mlx5e_close_xsk(struct mlx5e_channel *c)
+{
+	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+	synchronize_net(); /* Sync with NAPI. */
+	mlx5e_close_xsk_queues(c);
+}
+
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
 	/* ICOSQ recovery deactivates RQs. Suspend the recovery to avoid
@@ -189,7 +194,7 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	/* TX queue is created active. */
 }
 
-void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
+void mlx5e_deactivate_xsk_pre_sync(struct mlx5e_channel *c)
 {
 	/* ICOSQ recovery may reactivate XSKRQ if clear_bit is called in the
 	 * middle of recovery. Suspend the recovery to avoid it.
@@ -197,7 +202,12 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
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
index 664ec78192c3..203cff64fcef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
@@ -16,8 +16,10 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct mlx5e_channel_param *cparam,
 		   struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c);
+void mlx5e_close_xsk_queues(struct mlx5e_channel *c);
 void mlx5e_close_xsk(struct mlx5e_channel *c);
 void mlx5e_activate_xsk(struct mlx5e_channel *c);
+void mlx5e_deactivate_xsk_pre_sync(struct mlx5e_channel *c);
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c);
 
 #endif /* __MLX5_EN_XSK_SETUP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d8563f863844..65e86b4cef85 100644
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
 
@@ -2145,8 +2164,8 @@ void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
+	/* Caller guarantees that NAPI can no longer access the XDP SQ. */
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI. */
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
@@ -2936,35 +2955,52 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
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
+	for (tc = 0; tc < c->num_tc; tc++)
+		mlx5e_deactivate_txqsq_pre_sync(&c->sq[tc]);
+	mlx5e_qos_deactivate_queues_pre_sync(c);
+}
+
+static void mlx5e_deactivate_channel_post_sync(struct mlx5e_channel *c)
+{
+	int tc;
+
 	for (tc = 0; tc < c->num_tc; tc++)
-		mlx5e_deactivate_txqsq(&c->sq[tc]);
-	mlx5e_qos_deactivate_queues(c);
+		mlx5e_deactivate_txqsq_post_sync(&c->sq[tc]);
+	mlx5e_qos_deactivate_queues_post_sync(c);
 
 	napi_disable_locked(&c->napi);
 }
 
-static void mlx5e_close_channel(struct mlx5e_channel *c)
+static void mlx5e_close_channel_pre_sync(struct mlx5e_channel *c)
 {
-	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
-		mlx5e_close_xsk(c);
+	/* NAPI is disabled and synced, or was never enabled, so the queues
+	 * can be destroyed without another grace period.
+	 */
+	if (test_and_clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+		mlx5e_close_xsk_queues(c);
 	mlx5e_close_queues(c);
-	mlx5e_qos_close_queues(c);
-	netif_napi_del_locked(&c->napi);
+	mlx5e_qos_close_queues(c, false);
+	__netif_napi_del_locked(&c->napi);
+}
 
+static void mlx5e_close_channel(struct mlx5e_channel *c)
+{
+	mlx5e_close_channel_pre_sync(c);
+	synchronize_net(); /* Sync with NAPI and page pool readers. */
 	kvfree(c);
 }
 
@@ -3060,32 +3096,63 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
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
+	if (chs->ptp)
+		mlx5e_ptp_close_pre_sync(chs->ptp);
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_close_channel_pre_sync(chs->c[i]);
+}
+
+static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
 {
 	int i;
 
 	if (chs->ptp) {
-		mlx5e_ptp_close(chs->ptp);
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
+	mlx5e_close_channels_pre_sync(chs);
+	/* One grace period for NAPI and page pool readers. */
+	synchronize_net();
+	mlx5e_close_channels_post_sync(chs);
+}
+
 static int mlx5e_modify_tirs_packet_merge(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rx_res *res = priv->rx_res;
@@ -3394,7 +3461,14 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 	netif_tx_disable(priv->netdev);
 
 	mlx5e_xdp_tx_disable(priv);
-	mlx5e_deactivate_channels(&priv->channels);
+	mlx5e_deactivate_channels_pre_sync(&priv->channels);
+	/* One grace period for XDP, RQ, ICOSQ, TX, QoS, XSK and PTP. */
+	synchronize_net();
+	mlx5e_deactivate_channels_post_sync(&priv->channels);
+	/* napi_disable() can return while the poll still arms the CQs.
+	 * Wait for it, so close can destroy the queues right away.
+	 */
+	synchronize_net();
 }
 
 static int mlx5e_switch_priv_params(struct mlx5e_priv *priv,
-- 
2.44.0

