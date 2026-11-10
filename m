Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336686;
	b=n4vpbG2GOVAZmWAZytFFAczDyXm8ezp7KP7JV7Mxou3ihJQ7RL8vlVZFwyjPwGO6hVKK
	 qGQRZz4ezShNpTM0koSJZ1ehJjpNHV+VSKG765vZ/wnZA4W5IySQ5ZXQuPKLPaHgqEqgS
	 vW7VSmOk29lmTfJW+wgXS2saNNlLXkJVGbhAdui3KTrZ+rRewBehMB+FG0nW1vIs+z0vW
	 D536Ivzu6keSQa5AFbou5+/3y8MwqGBGBCntEWNnlLJEt+Qwm1ZoR308G8ZtolvQ1oyoK
	 9xGuMkmqZ5WZeMzL/UHOZ+M2XkrOkfd3cyjd2LXB2XQP0gxF8FaEYJEX05o5LiOqrOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336686;
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
	bh=vl2JZC9ChaugblYlpJLLCFB6a256VSX7nEg2C61Tizk=;
	b=eGk7G+KWlhjIS4Z5Gu5V9a569EhiUPdkGKMll2biihrszvzzwRVPGz3yjb79Nrd3VVdQ
	 4HQum7A8Z9YCLH9qDGV5A4FXBx/fzuWxcGS7ai3bKVR2BENkVSA0Kd9YkWqGY2ttQCi4Z
	 xQ1qhvnwPF8NJab5zYd5WegzgVkIPrOPnMiNMmjvcGSKUnrmNxZk00lijPbnJEjjvTbjd
	 z7thLveCdgHqR1RoUy1cohSKlne5FsLlOfShb/UYDQezJEMQsLl0KztnFGumQrFL8A8xn
	 HpFGfoxuQxGrHGJlJx/TIqtvZwT9FWqPu0tR9dyMgTGVt1fkXiA08yYIjY2i+bWOHpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z0RdL2zk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.17
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230A606A32E;
	Tue, 10 Nov 2026 18:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F230A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z0RdL2zk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ms3nFbgBlXcPTL9BBeKEGJ1bmrEhLSpKVz/4XkY6UInQddmq/b5X5nYsyMCPcucEQBlIGfyN8VwHAgWY6u6bfWEqU1SLWx6dnXezJFjxNn0tRIB6gwSvnHPXKIf9EjF7wQA2LbV5cJpVSbhi9tL6mH26r3iks0ybejTYGE36SwVodIHwFIazG3msIITKhrQnCilXabZfsM5/t3y7hQqc7ObacevKn43EoH7qene2gCU7upts+hTPsl2hZeS7WTWC7PAy2awI2gTd5+7A8AFN2GAfKRv21Rj3e02tYQxp0Gffcb7UIHMTjYEKQ9K3dS5TmQo65fXy82J9ssHgRdBtxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vl2JZC9ChaugblYlpJLLCFB6a256VSX7nEg2C61Tizk=;
 b=M0IgnCmdZqGPVyqKfjxmutc/gP/85gMuhVWAvgPaozRGjkbzl9aDyxqQ3iH2YwV9q8/h+C0shPbcTOfZQFUMAr8yZe7vNRx1xg7wuE9NfT9mUb2QAr3v/ILQDiA8WH4s1ZAdEE8W7pU63Bmjt5dOVOTkh3nC0+K3iLS7ZIXkMl8bG/qvJoId5UQDWI6rPwlxF3OrWFVK/3b6PV3bAH62h90yhIPZFkZMhnF0kd3d4bIm7oY5lUzjVPnVGoFffu6j+Ot5eoBWDi4L60p46tPVVMFRfTHOuWt/kZVe8yT6lRsquXaWSzU7sqQI6iwXA53+ic+VNwkVrVs4el/PSMpHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vl2JZC9ChaugblYlpJLLCFB6a256VSX7nEg2C61Tizk=;
 b=Z0RdL2zk2XlPWoG4VrtaI+PrY2t/uU82jYBOjJl3BHPed6t8D7Fqi7o3WZzyRyhPMFTlnVuKaAj58TKVt6ct2FHH7ij6zMVXgQ1P4T6rhlXpj07duznHPn2wevjBUZlNGfd00Q9qvlolzf5G/DM0+ehGuzj9YOqGxc5xy0OZnEPIGLiSs4vVbwoqbLQP2u+RpEqQa/x1w0JdQ4lVGrWrEKfCTRoDZDC7uUl26VLxC44iYcZs7lmPrjfHxhpDdp6T0WGZLXqAbQ2WPnZ8BoWGdQcSAu+Yejn5T5+fq/GPyqHmVjmLNBbcuMQ/LK3f8LKoT9AOQ6UYApPfWwhYFQipvA==
Received: from BN9PR03CA0740.namprd03.prod.outlook.com (2603:10b6:408:110::25)
 by LV2PR12MB5920.namprd12.prod.outlook.com (2603:10b6:408:172::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:51:14 +0000
Received: from BN3PEPF00022BD7.namprd03.prod.outlook.com
 (2603:10b6:408:110:cafe::70) by BN9PR03CA0740.outlook.office365.com
 (2603:10b6:408:110::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:51:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BD7.mail.protection.outlook.com (10.167.248.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:51:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:39 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:38 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:50:32 -0800
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
Subject: [PATCH net-next V2 1/2] net/mlx5e: Batch NAPI RCU grace periods on channel close
Date: Tue, 10 Nov 2026 20:50:04 +0200
Message-ID: <20261110185005.2932568-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD7:EE_|LV2PR12MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 590f55f6-df74-4b8d-129b-08df3f5b98a1
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|1800799024|82310400026|5023799004|11063799006|56012099006|261021123027099003|261009223027099003|261102123227099003|261021121427099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|10067099003|22082099003|18002099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	9RA4X5Lji+NHc9UVGXa4rW4Ug1fng3Z+JQkjhGDJJztn5c84KCNdcyp4hcVT5iq7zXBJ0onVVMpYmL3MmpziuwkW7KGuxFNa9WlODsvYcE3w8m7yJCHKoodpKh6nTyidHmDRkWfK2vkG1j4Cs9nVF+Es+DP91qQc70oEdMumjqShq1UWSUUU05+tpriP36JQrxp+kWdmv01WZMM1aacoC1+NC1Oyi1AEVe5xESwKysDFfHpIjyTKtOVwYHRZYIrIKgjpC4FoyQywd5LTBhgRFfHfoZslKLKeJ2LMB1Vhbep6t+3ul0hBpHE/y5IfaizE1xQCE9CyjOIzzk/q/ZBG7GUPPUX1vcQDAsXyFF0y+aJgdIioa+YIeh2F/DE3jsS3DIQW3/mEpbFL0BAEcRfbk37DAaHsN4tFa9y9GRXwVD5Y/XW8Jws56fFqtvdvfpq8EpHUrHlIyI8ccRYZx73h2B2HeZeUyFzwbKyX5ZCG41SL5pWFg3bre6lLVPZRW2DCE4diBI99eWjOa8TvT0S3lqf7QFfbhhpDSQ76WZDxpr6zuXyzuLFaM1GuK/KcFPehQnIe3TTP1UjuobCJSFo/GV9ghnDi1ofEIm5hDUIOZ8PUyZdGjQMhKCRX9RmWzvoxVMcRJ5FXLGXU9Dq7m1KeDUezPA27y1HxM+XXjOTcHzeeGWq0Aze1W4y2cDkDcP8X
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(5023799004)(11063799006)(56012099006)(261021123027099003)(261009223027099003)(261102123227099003)(261021121427099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xiXoG5YvEd7M37e+HL77Gy8MSnrwQTFscT8dEky4lFXyrD4le5SiyRR2J4Sv+EC9mAXFRz5QaNf4Q7/gU2ooqx2yXaoez47jJ2v5v0FMiG9CkALdqgwuAhkurpgi3N/BslcRqhCFXwHn9vtU8cAPR3pml0W/O8VvX7thWlPfofCG1TRw3SC7m4M4v/z4Gr4u/5kMI40C38Xb1rI5oXpwy6VmaBcGSTmwe7ZKWeOR0T5nFtdszQJlTVzsM3NHZuTc+1O2bHOPyaoE6hP5gtwAe7LcB0tNHRBJ2LljF+Qo8RagEQaGpVjLPuj2bjpu8LYmh4Jnn5mPGKnWAiCr6LUuIpePcvWaS0h6tBOz6A/TnAaEex4Xu2AQ1USkmo73It8rOnnxhYL8KdwgYtUC7mfs+nnLr/svUHClkidYkURvZGD74oQdwUf4P21YAQcy6gH4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:51:14.4087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 590f55f6-df74-4b8d-129b-08df3f5b98a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5920

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
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  69 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   4 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  31 ++-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 210 +++++++++++++++---
 9 files changed, 290 insertions(+), 58 deletions(-)

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
index 2edb55afff1d..3fc439997282 100644
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
@@ -954,18 +954,28 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
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
 	}
 
 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
 		for (tc = 0; tc < c->num_tc; tc++)
-			mlx5e_deactivate_txqsq(&c->ptpsq[tc].txqsq);
+			mlx5e_deactivate_txqsq_pre_sync(&c->ptpsq[tc].txqsq);
+	}
+}
+
+void mlx5e_ptp_deactivate_channel_post_sync(struct mlx5e_ptp *c)
+{
+	int tc;
+
+	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
+		for (tc = 0; tc < c->num_tc; tc++)
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
index 11500fd213a5..d2f1d0e06508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -160,23 +160,39 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 err_close_rx_cq:
 	mlx5e_close_cq(&c->xskrq.cq);
 
+	/* Close uses xsk_pool to decide whether XSK queues need teardown,
+	 * so clear it if XSK open fails.
+	 */
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
+	/* Caller guarantees that NAPI can no longer access the XSK queues. */
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
@@ -189,7 +205,7 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	/* TX queue is created active. */
 }
 
-void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
+void mlx5e_deactivate_xsk_pre_sync(struct mlx5e_channel *c)
 {
 	/* ICOSQ recovery may reactivate XSKRQ if clear_bit is called in the
 	 * middle of recovery. Suspend the recovery to avoid it.
@@ -197,7 +213,12 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
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
index c3c2c5720c6f..73b504ba8c8c 100644
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
+static void mlx5e_close_xdpsq_pre_sync(struct mlx5e_xdpsq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
-
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_net(); /* Sync with NAPI. */
+}
 
+void mlx5e_close_xdpsq_post_sync(struct mlx5e_xdpsq *sq)
+{
+	struct mlx5e_channel *c = sq->channel;
+
+	/* Caller guarantees that NAPI can no longer access the XDP SQ. */
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
 	mlx5e_free_xdpsq(sq);
 }
 
+void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
+{
+	mlx5e_close_xdpsq_pre_sync(sq);
+	synchronize_net(); /* Sync with NAPI. */
+	mlx5e_close_xdpsq_post_sync(sq);
+}
+
 static struct mlx5e_xdpsq *mlx5e_open_xdpredirect_sq(struct mlx5e_channel *c,
 						     struct mlx5e_params *params,
 						     struct mlx5e_channel_param *cparam,
@@ -2184,13 +2213,20 @@ static struct mlx5e_xdpsq *mlx5e_open_xdpredirect_sq(struct mlx5e_channel *c,
 	return ERR_PTR(err);
 }
 
-static void mlx5e_close_xdpredirect_sq(struct mlx5e_xdpsq *xdpsq)
+static void mlx5e_close_xdpredirect_sq_post_sync(struct mlx5e_xdpsq *xdpsq)
 {
-	mlx5e_close_xdpsq(xdpsq);
+	mlx5e_close_xdpsq_post_sync(xdpsq);
 	mlx5e_close_cq(&xdpsq->cq);
 	kvfree(xdpsq);
 }
 
+static void mlx5e_close_xdpredirect_sq(struct mlx5e_xdpsq *xdpsq)
+{
+	mlx5e_close_xdpsq_pre_sync(xdpsq);
+	synchronize_net(); /* Sync with NAPI. */
+	mlx5e_close_xdpredirect_sq_post_sync(xdpsq);
+}
+
 static int mlx5e_alloc_cq_common(struct mlx5_core_dev *mdev,
 				 struct net_device *netdev,
 				 struct workqueue_struct *workqueue,
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
@@ -2936,35 +2993,62 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
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
+
+	if (c->xdp)
+		mlx5e_close_xdpsq_pre_sync(&c->rq_xdpsq);
 
+	if (c->xdpsq)
+		mlx5e_close_xdpsq_pre_sync(c->xdpsq);
+}
+
+static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
+{
+	if (c->xskrq.xsk_pool)
+		mlx5e_close_xsk_post_sync(c);
+	mlx5e_close_queues_post_sync(c);
+	mlx5e_qos_close_queues_post_sync(c);
+}
+
+static void mlx5e_close_channel(struct mlx5e_channel *c)
+{
+	mlx5e_close_channel_pre_sync(c);
+	synchronize_net();
+	mlx5e_close_channel_post_sync(c);
+	netif_napi_del_locked(&c->napi);
 	kvfree(c);
 }
 
@@ -3060,32 +3144,67 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
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
+		__netif_napi_del_locked(&chs->ptp->napi);
+
+	for (i = 0; i < chs->num; i++) {
+		mlx5e_close_channel_pre_sync(chs->c[i]);
+		__netif_napi_del_locked(&chs->c[i]->napi);
+	}
+}
+
+static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
 {
 	int i;
 
 	if (chs->ptp) {
-		mlx5e_ptp_close(chs->ptp);
+		mlx5e_ptp_close_queues(chs->ptp);
+		kvfree(chs->ptp);
 		chs->ptp = NULL;
 	}
-	for (i = 0; i < chs->num; i++)
-		mlx5e_close_channel(chs->c[i]);
+
+	for (i = 0; i < chs->num; i++) {
+		mlx5e_close_channel_post_sync(chs->c[i]);
+		kvfree(chs->c[i]);
+	}
 
 	kfree(chs->c);
 	chs->num = 0;
 }
 
+void mlx5e_close_channels(struct mlx5e_channels *chs)
+{
+	mlx5e_close_channels_pre_sync(chs);
+	synchronize_net();
+	mlx5e_close_channels_post_sync(chs);
+}
+
 static int mlx5e_modify_tirs_packet_merge(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rx_res *res = priv->rx_res;
@@ -3375,7 +3494,7 @@ static void mlx5e_cancel_tx_timeout_work(struct mlx5e_priv *priv)
 		cancel_work_sync(&priv->tx_timeout_work);
 }
 
-void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
+static void mlx5e_deactivate_priv_channels_pre_sync(struct mlx5e_priv *priv)
 {
 	if (priv->rx_res)
 		mlx5e_rx_res_channels_deactivate(priv->rx_res);
@@ -3393,8 +3512,21 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
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
@@ -3610,8 +3742,14 @@ int mlx5e_close_locked(struct net_device *netdev)
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
 
 	netif_carrier_off(priv->netdev);
-	mlx5e_deactivate_priv_channels(priv);
-	mlx5e_close_channels(&priv->channels);
+
+	mlx5e_deactivate_priv_channels_pre_sync(priv);
+	synchronize_net();
+	mlx5e_deactivate_priv_channels_post_sync(priv);
+
+	mlx5e_close_channels_pre_sync(&priv->channels);
+	synchronize_net();
+	mlx5e_close_channels_post_sync(&priv->channels);
 
 	return 0;
 }
-- 
2.44.0

