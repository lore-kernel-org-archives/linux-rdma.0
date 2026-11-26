Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730243;
	b=p3uxYzSyKme2ufavHFOu+yeNKOy4QCObymBsBYZDui/1mcWcsjevBuDJ/3Ck2mjJt1mM
	 ZiYt4c3FD2mWdmTK0RWApmRJ+5Dg0HwSIZymy5r4nRCfX2Fs2OwnLoJkCSdJKeYRtQu35
	 FeChrkv5stZy0JSkLv5cKVq0sHDbC5iHDggPtcT1FmemsjAziuNjmoXmDQKujhJpz0mKo
	 +GOxeXCy63dNvmrR9AYujL6diARI4+IJBQUcHQgi3mIWkO9a7sLiYpVBmtemrQryiXXUD
	 mx5e0cGFvY2j8CBj5rPceU1+gNrVHi1lfuBdlVCoNINd5CHdtWHDOrIX+dl4ED6kdng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730243;
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
	bh=AwfBaNM5nLma3Xd3oJXZ1FGFaiUr8QruQ1w0yPcIIzI=;
	b=ZhGpsCMyITBthzbsX6yFKyKmo+COX6ELXvqN8TWuCeEJWSOHYerMbkeIGFc1riMlfgzP
	 zjNLVgN9jsBWFaLpg8EpsExRlyOSVCjdIgQzwQIWETZyma4Z4ljznFFRbEavjglgXCOOq
	 ElkeuZe3GuRbYDXL7/Y32RAPGz8F0razD5L4qXmftyIzqeX3JmPvWNRdCh9qMSbgHvi7d
	 v6qD37FYBxVW3vHRAQcKmwWNX4pPbTM9JYmUph+pm/cjRYv6IMt9315kOW0F9P4dd1/0J
	 SVTRvnuCz6550eG+TgNsWKtfIR3VGbVRfVZz+k137yRSO7umib7aIvxgsrDMTZIZn4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h9FfR2I9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.46
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010046.outbound.protection.outlook.com [52.101.56.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08619606A696;
	Thu, 26 Nov 2026 21:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08619606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h9FfR2I9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGmxZal0YM0m+cNWz5UOAf6o0bmzEhcwjPeHkY8LRPjburvHE72mJapbFET6cDbmBNhKcYWacIfQ7uAtAkY4A6v76iFH5JH3VUDdf4/z1NOFV+4DBtvI0R+Z05AosPUMBlCYUtWaH1FfVUhsShvOdYhO86Jea/xdSJO5pOO8Y7roUJRuf74gcqIIXE6me/u1Ps5VOGY4pmq8nw8r0fFmW2+pXqy+rRWqENEsj5KgugRhLpEyPdlnMekymxhJSf1becrS/qi26wZB6fE89XVqrTCRUxw0Dczuly8GhR7MJwKtaRv8wCKTcWpAlN/xqvVoe11TP6W0ENNgKf5pS8XiSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwfBaNM5nLma3Xd3oJXZ1FGFaiUr8QruQ1w0yPcIIzI=;
 b=KzBEIUmhQsjPLoEndermJNjtpRSbK81PYoNBbUIrYPYPCJQWfJPamMVdqgfrGMsRJxT/ucqlIovjl5/syqIsEo9T6yGgQBdOenUzmSCdwKcyZh9+lYiXsBJThJCNh0FdrPZl8qwB6KjyzXaNyJRNoF1eas6sbXVDf4gs/vW4Sv75o9J+xYJtZxYfuCS2Z6zNUqCKuugkuYjVdyltHotoRZa/9MXwQytHDMf0r9nEA9RBn1EJAelqGxrBYYFuV6F4Nm84pa0fsBF2897jASbPsc61ItZ4f6nkqZDXosm/+hejts5mQ5cvMMy3mb7n4behs1ArQOaL+Qd9pHdh/oSKMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwfBaNM5nLma3Xd3oJXZ1FGFaiUr8QruQ1w0yPcIIzI=;
 b=h9FfR2I9xUVS71YquuW3xoEd9owgHuKKFF4szNA9SilC0rvR8WC6H7PxA+488EkMCn05uVtC76jxHgrAeXf43LLe5UxcljVKl3DZVvJYx081+odBb4p6M5IxsszKjIzGOywWyNLYyKJklg0IxSQCK4ZyrkwJ1m4XLb688co0/+uAhmF3AJTc+RxEjS4vGpYb5EDBC0LIXilPJPNsLZv1V9nzZazCkj36xwhKyfdNOBuvdqXwpE1b0WA4jQXIdqp5pbHHpiXKPkILfYciwhSYRzxYuNR8WsPiLRKseJLNRVYKnNoO3Fj3GuFORJ5/2QYVkJqs3xFBm0x3Un53QtXc3Q==
Received: from CH2PR14CA0056.namprd14.prod.outlook.com (2603:10b6:610:56::36)
 by IA4PR12MB125293.namprd12.prod.outlook.com (2603:10b6:207:14d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:17 +0000
Received: from CH2PEPF000166C1.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::1f) by CH2PR14CA0056.outlook.office365.com
 (2603:10b6:610:56::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Thu, 26
 Nov 2026 21:57:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166C1.mail.protection.outlook.com (10.167.252.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:16 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:09 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:03 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Elliot Edmunds <eedmunds@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>, Sridhar Samudrala <sridhar.samudrala@intel.com>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 04/10] net/mlx5e: Drain pending hardware event work before freeing IPsec SA
Date: Thu, 26 Nov 2026 23:56:08 +0200
Message-ID: <20261126215614.792598-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261126215614.792598-1-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C1:EE_|IA4PR12MB125293:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cee774-80b8-42a5-c571-08df4c083ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|261022075727099003|261021121427099003|10067099003|56012099006|11063799006|261026140227099003|261026121527099003|261022105027099003|261028144727099003|261021123027099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	63Sj+ET6pj+GNi3B3rBq2aMi0obg32Rm8mfgyPG0ST/iQck6pPy56dFtoHzUC4G1eJaDTn//qpld/KS5pArfzYHRrmxDOgFU9izeMAnSgwIIpKWEYicHolXGf5uaNI6XTyB+ADa5/MFSGmoGVe5vvehchZwjVYkEeBhHB4uH2GtlJFOBd5k7s7x2PAEEssB1hJRoFKOU52vwvBUgSa1hTbC6peODtyYrbdlEmQKnxud4oAEx0lHHsNTHwuMW1JqQ6wgNEkaejCR2ZvWCU/xYd8fL3oiaff8Dmhyae5e8aFOO07sA4YB0T2uDiPZ7i0sxlHPsu9unDuBSAFC8VUo84sm/cS9P0y3DWfha7Uju5f9HrQ3a9bkIHndzRPgp8g71aqs+zFaGhcupr5j2klL+raQKsscAW8QOUHzj9faKOxBFX7kpL7k6dUBBr3MZkXKJJIei6EdNCxaRbFeCsypi43r1DxX6UgpprnhlhvLP6OwFU00IuC6pfZd5Tv6hPjvvFQiCQmk+hzGoIOK5/2PdIOzxpyYCMvuicTJk4F16KpP7tWe+Qp5zw0+V/0p9gg9hPgZ1UPTFIyliZbWwh4fBCBaf/0YUnTrXH1NOuIgRl9YER8JkdeaU3nDtRllE1kQBF5q9/zxtxEkpJC5FN6WsgNW2WQ8aZg2FITIyrZzWBB8u36ukOpIKSrsUqwYTpxlAqNiHbwxoDEUFUBF0rMiVgA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(261022075727099003)(261021121427099003)(10067099003)(56012099006)(11063799006)(261026140227099003)(261026121527099003)(261022105027099003)(261028144727099003)(261021123027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0lEqau1v6Sx2kQoTwR8V1ihNZmjMuuGxdViHRQPOOmWgSQK855B+M01oClp++iU2bvDArrMXcXSJOta7hE9s+qOMG55wBwA67Gk2rz9lWPFZ6hXv7E8q94UqhNxk/9CDNOOXLS6/gFGTP6AEC5sgqpswRQ2Jv9EWJ5zzL2Yd6cSi/tliXb2PnKbUDwv+CGttQTPk8GEezVtl+oOgVAM9u2s0La+F3hvttw3q/1voxnEHl/nhrpZUHcFIsIGzaWDXFmPE/2aXGPtb/zueCE7HFAqiLmPy9QpjTyJ8QqNm0hjY9QbS2FqoK8bImHCHxRV068ymUpDyqZWiog7VAHjpIzq5TbTn4hOlGrl9dhbyCcDsnNmD+IRu/rL7tYGoKpv44+oZNd8Mxr0riM926IaY4GvGGBxeAyay2LQsEEVwD1rydmdARlc2xkKa30hFt8Ao
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:16.9203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cee774-80b8-42a5-c571-08df4c083ca3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB125293

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_ipsec_event() queues a per-event work item. This is untracked by
the SA, so mlx5e_xfrm_free_state() cannot cancel it, potentially
resulting in a use-after-free.

Embed the work in sa_entry so SA destruction can cancel it. The event
handler looks the SA up without a lock and a device flush frees the SA
right after deleting it, so wait for a running handler before
cancelling the work.

Discovered by manual code inspection. Reproduced on ConnectX-7 (fw
28.48.1000) under KASAN, with a 3 s delay added at the start of
mlx5e_ipsec_handle_event() and the SAs flushed right after a soft
limit event:

  BUG: KASAN: slab-use-after-free in mlx5e_ipsec_handle_event

With the fix the flush waits for the handler, no report.

Fixes: 8c582ddfbb47 ("net/mlx5e: Handle hardware IPsec limits events")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 34 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  5 +++
 .../mlx5/core/en_accel/ipsec_offload.c        | 25 ++++----------
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index a549851c8382..ea7a1ae2056f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -42,6 +42,7 @@
 #include "ipsec.h"
 #include "ipsec_rxtx.h"
 #include "en_rep.h"
+#include "lib/eq.h"
 
 #define MLX5_IPSEC_RESCHED msecs_to_jiffies(1000)
 #define MLX5E_IPSEC_TUNNEL_SA XA_MARK_1
@@ -869,6 +870,8 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (err)
 		goto err_hw_ctx;
 
+	INIT_WORK(&sa_entry->event_work, mlx5e_ipsec_handle_event);
+
 	/* We use *_bh() variant because xfrm_timer_handler(), which runs
 	 * in softirq context, can reach our state delete logic and we need
 	 * xa_erase_bh() there.
@@ -944,6 +947,9 @@ static void mlx5e_xfrm_free_state(struct net_device *dev, struct xfrm_state *x)
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
 		goto sa_entry_free;
 
+	mlx5_eq_synchronize_async_irq(ipsec->mdev);
+	cancel_work_sync(&sa_entry->event_work);
+
 	if (sa_entry->work)
 		cancel_work_sync(&sa_entry->work->work);
 
@@ -1002,10 +1008,13 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 
 void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
+	u32 caps = mlx5_ipsec_device_caps(priv->mdev);
+	bool pkt_offload = caps & MLX5_IPSEC_CAP_PACKET_OFFLOAD;
+	bool tunnel = caps & MLX5_IPSEC_CAP_TUNNEL;
 	struct mlx5e_ipsec *ipsec;
 	int ret = -ENOMEM;
 
-	if (!mlx5_ipsec_device_caps(priv->mdev)) {
+	if (!caps) {
 		netdev_dbg(priv->netdev, "Not an IPSec offload device\n");
 		return;
 	}
@@ -1022,18 +1031,22 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	if (!ipsec->wq)
 		goto err_wq;
 
-	if (mlx5_ipsec_device_caps(priv->mdev) &
-	    MLX5_IPSEC_CAP_PACKET_OFFLOAD) {
+	if (pkt_offload) {
 		ret = mlx5e_ipsec_aso_init(ipsec);
 		if (ret)
 			goto err_aso;
+
+		ipsec->nb.notifier_call = mlx5e_ipsec_event;
+		ret = mlx5_notifier_register(priv->mdev, &ipsec->nb);
+		if (ret)
+			goto clear_aso;
 	}
 
-	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL) {
+	if (tunnel) {
 		ipsec->netevent_nb.notifier_call = mlx5e_ipsec_netevent_event;
 		ret = register_netevent_notifier(&ipsec->netevent_nb);
 		if (ret)
-			goto clear_aso;
+			goto err_notifier;
 	}
 
 	ipsec->is_uplink_rep = mlx5e_is_uplink_rep(priv);
@@ -1047,10 +1060,13 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	return;
 
 err_fs_init:
-	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL)
+	if (tunnel)
 		unregister_netevent_notifier(&ipsec->netevent_nb);
+err_notifier:
+	if (pkt_offload)
+		mlx5_notifier_unregister(priv->mdev, &ipsec->nb);
 clear_aso:
-	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+	if (pkt_offload)
 		mlx5e_ipsec_aso_cleanup(ipsec);
 err_aso:
 	destroy_workqueue(ipsec->wq);
@@ -1073,8 +1089,10 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 		ipsec->netevent_nb.notifier_call = NULL;
 	}
 	if (ipsec->aso)
-		mlx5e_ipsec_aso_cleanup(ipsec);
+		mlx5_notifier_unregister(ipsec->mdev, &ipsec->nb);
 	destroy_workqueue(ipsec->wq);
+	if (ipsec->aso)
+		mlx5e_ipsec_aso_cleanup(ipsec);
 	kfree(ipsec);
 	priv->ipsec = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 9bbcd9e4c319..6c17bd997a0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -37,6 +37,7 @@
 #include <linux/mlx5/device.h>
 #include <net/xfrm.h>
 #include <linux/idr.h>
+#include <linux/workqueue.h>
 #include "lib/aso.h"
 #include "lib/devcom.h"
 
@@ -286,6 +287,7 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5e_ipsec_work *work;
 	struct mlx5e_ipsec_dwork *dwork;
+	struct work_struct event_work;
 	struct mlx5e_ipsec_limits limits;
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 };
@@ -332,6 +334,9 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
 void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
+void mlx5e_ipsec_handle_event(struct work_struct *work);
+int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
+		      void *data);
 
 int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 			  struct mlx5_wqe_aso_ctrl_seg *data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 145677ce9640..1f03465762e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -438,11 +438,10 @@ static void mlx5e_ipsec_handle_limits(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 }
 
-static void mlx5e_ipsec_handle_event(struct work_struct *_work)
+void mlx5e_ipsec_handle_event(struct work_struct *work)
 {
-	struct mlx5e_ipsec_work *work =
-		container_of(_work, struct mlx5e_ipsec_work, work);
-	struct mlx5e_ipsec_sa_entry *sa_entry = work->data;
+	struct mlx5e_ipsec_sa_entry *sa_entry =
+		container_of(work, struct mlx5e_ipsec_sa_entry, event_work);
 	struct mlx5_accel_esp_xfrm_attrs tmp = {};
 	struct mlx5_accel_esp_xfrm_attrs *attrs;
 	bool need_modify = false;
@@ -471,16 +470,14 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	spin_unlock_bh(&sa_entry->x->lock);
 	if (need_modify)
 		mlx5_accel_esp_modify_xfrm(sa_entry, &tmp);
-	kfree(work);
 }
 
-static int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
-			     void *data)
+int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
+		      void *data)
 {
 	struct mlx5e_ipsec *ipsec = container_of(nb, struct mlx5e_ipsec, nb);
 	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct mlx5_eqe_obj_change *object;
-	struct mlx5e_ipsec_work *work;
 	struct mlx5_eqe *eqe = data;
 	u16 type;
 
@@ -497,14 +494,7 @@ static int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
 	if (!sa_entry)
 		return NOTIFY_DONE;
 
-	work = kmalloc_obj(*work, GFP_ATOMIC);
-	if (!work)
-		return NOTIFY_DONE;
-
-	INIT_WORK(&work->work, mlx5e_ipsec_handle_event);
-	work->data = sa_entry;
-
-	queue_work(ipsec->wq, &work->work);
+	queue_work(ipsec->wq, &sa_entry->event_work);
 	return NOTIFY_OK;
 }
 
@@ -536,8 +526,6 @@ int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
 	}
 
 	spin_lock_init(&aso->lock);
-	ipsec->nb.notifier_call = mlx5e_ipsec_event;
-	mlx5_notifier_register(mdev, &ipsec->nb);
 
 	ipsec->aso = aso;
 	return 0;
@@ -559,7 +547,6 @@ void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
 	aso = ipsec->aso;
 	pdev = mlx5_core_dma_dev(mdev);
 
-	mlx5_notifier_unregister(mdev, &ipsec->nb);
 	mlx5_aso_destroy(aso->aso);
 	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
 			 DMA_BIDIRECTIONAL);
-- 
2.44.0

