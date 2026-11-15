Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794727807;
	b=bOBo39LvPpkDidoi2r1dhD5JQ4WeqVe0fAl/59FCAkIsiFVfvT2jAOEreupfGfI7uj1G
	 E0kqM2D4wRveIqnZYVvMqUXnQfeAyBDul9PL0RXc/nJqlXN9623NwG/1+5IGhNW2XwoTZ
	 bicpIT1QnffodFD4VfRZ1K2hC0cIJ5oCqsKEwgyb6NQtn9tlcsX5DyeJL/a3qt1wnJQFX
	 bg8X4TiuW4ex8Eixlf+RWuPA1lmgEgBD9cpSXW7kSMdgVNTCFjkv1HEUxlLuws2zCz3wr
	 RnYCiKvwCMYdUwTr992gLz3t61/xsd+DUEehJJhoVp3Fp7do7CRvyrLKJNNHbtjoq4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727807;
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
	bh=sFRNHl/A+EBSc+ljJstso20ObPhS8+gGdpPRrKt1w80=;
	b=SDg7tiPS9UfdVzM5Iv8MULXgiQRDidkzzzU2cTjpLnx8AWgtJH/AKwKzRlK9L3bJ6T2b
	 zR1eTH3SrfI7e2lh8UlB8YJ2yfl3xlNjqFzsGX0zez/4zlc6JFbd0DxnRUOFvFU53WFd1
	 IQOL/iEmj4pn+cmox1KM1nhsvrp28TM/phzGLS0XDD/y8A9i228iTKksYvdQlpfk3Uce8
	 WOAj7TPxnOYqoihY/U4tUYIY3C+68YS16lUyRoL9N9v83+Hu42GQbbpIaBEv800oSRGu1
	 IAy4kNlSvaSb1Wr+0AL6EKXk1n9Lk1+ACuhAtF5Jtp1Tv7HQpuNyQoS9AhYzq3Cs/sQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K7gpPQNA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.64
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4ED606A31D;
	Sun, 15 Nov 2026 07:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB4ED606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=K7gpPQNA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+f4pAtiphNBVySsDIQwnbxRk0yHRzA+fUZSWj5A52icZNDV/xTmUIIPlZkojRhLFC9LU8UaMqsglSxcTYhAN1xKjk7JDvIyEby4SbgXvrZd29AXoFLHXJazwH5y7fvxq5cQQ80T0oGjht2EnI27C/eKq8+XdGs0p5hRHyqkhfntBMoLHx05EpmuIBFaBnXzJhYkY4vjygnWhNeEPP7w6PrWw2VKbUkqukSce5qLD2l6ZLqOphmjEMqn0VJRlHzUtkelDb+its8GZjQvqtvhYSdn53e2MLuY72jFPk+BKmylpWd4Pt7fQfIWI5xBsKcOMFgRalaFHoKlFV0f7LUkLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFRNHl/A+EBSc+ljJstso20ObPhS8+gGdpPRrKt1w80=;
 b=IbVvgTbsKtRo7OB86lG6NXdW2FEGfDip0Aazvyo4HwCS6zJB9MA3ws6WbNXJC6mWi48yXp4nfThbg3wsNpyGiS8W8QPHyh6anHHYtfnPvGL/R/RFMOnbjEq6rnQsrq1YydX3dahzW+AyeLHT6SRCSio2sOJAfA/Ocd5vrevEKc17DQLiFx9Os77b2tB/1ZC+srtv2ku50P0sXDqdy2DBABri4/xQohH4F1k2UMjNKO+KBNYea3l+nQVACJe+aJvmqVsy6sUFYH2AdE1N6vZMcMpAAFWJn7u4CCY1o2N7AvHhdq2605KfQKKr/dmtwMVwgIhxywh74WmmaDXJ3GIvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFRNHl/A+EBSc+ljJstso20ObPhS8+gGdpPRrKt1w80=;
 b=K7gpPQNAqZsnJiLKwQyUySt43qwrwPQFbb0MnHvC6RqicNPjiNalhp0jSf1bY+KMnlzpIEvECcGl7BDeJ/x0xvHWxepWyFyFrIubSYBXAwUiyVq9mQvocspXD9RWhCnQremkFc2g6yk5Zg+WnN7i+fgmosMuFFAyPb+kNUA5eWNUZKeC+Hl6crDlnaVXdE+nn39FuElwbXWqDSd4AEkuJR3Cl7IHjlreTgMovV+SpC+Agsh1iFBExObWAUn9q+mf5X3h3r/JdL6SubwGj+BbSc4fCIJ5gHc/d97inhfVPWbWxNCE9GOmFKF9hM801R++JButTOlqJKDZE6/ok7ngSA==
Received: from MW4PR02CA0029.namprd02.prod.outlook.com (2603:10b6:303:16d::34)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sun, 15 Nov
 2026 07:30:01 +0000
Received: from BY1PEPF00026967.namprd05.prod.outlook.com
 (2603:10b6:303:16d:cafe::8f) by MW4PR02CA0029.outlook.office365.com
 (2603:10b6:303:16d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Sun,
 15 Nov 2026 07:30:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BY1PEPF00026967.mail.protection.outlook.com (10.167.244.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 15 Nov 2026 07:30:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sat, 14 Nov
 2026 23:29:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sat, 14 Nov
 2026 23:29:46 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Sat, 14
 Nov 2026 23:29:40 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, "Gal
 Pressman" <gal@nvidia.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Leon Romanovsky <leon@kernel.org>,
	"open list" <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	Mark Bloch <mbloch@nvidia.com>, Nimrod Oren <noren@nvidia.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Fix XSK pool corruption when switching channels
Date: Sun, 15 Nov 2026 09:29:34 +0200
Message-ID: <20261115072934.353341-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026967:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: a18c81c7-f9ba-4039-5294-08df42ea426b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|82310400026|36860700016|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mMss/ffZN5xNu632jl93QLbbBsDYVxgSD/VBCPyspBu6St81KUvp2+cl40qrwCpJ8tsGvuZ9ZDixxqbGOeZHXTtRCuFkou0yOubgJBs9g6WS4wTh4adTyRHNUIPPMSSA8/jIs6s6tn6TOMoXEm9TnztTyh/ZQK072572Iz8wv9tHtDGlU1xUt+UOl0dmKOg5F7e6JCX7yqHWhOu/3ENsogBeriuIVqrhmbad9ByBmfu+TZPVE8unuuw1iAf+Ex2kIc4jpOGlNvJgfW2/3oBJT24ZvhyjNkq2h/pH+8KeqbXuaiHcwMmnp2Kf5blIe2hq4R9n+s9F9SFQC+gF4sgK4fYSjEwTfNLOXnjPZ+Z9r74+zR3Z1n05BzlBTT/XO0zgboL0DOtME/bH8rMJsUyaxd6TRWF/vL3tnKDkURza9gmnertzMEZrkWM3hn7La+xHJokflIM++vgmWmEEdFylrck5rUwRqMSDiv9EEbUiyrG1D3r9fqNrVilrtMCXUOcq/splUyZPdj+/KKrW6Q4bEHNDvDa8PicPIeyAXV5iw18DGknruljaT+zaxrae2URxRqqIemTWcnMVZHGDTmdH8gUzAeXGlIkqiVtGXgyXDiZIvRAW8vO2RfrBkXgBIYDUnyRC34CLWNtKSeLFiIZyeeXHKKSYUc3Cuufp0PjxwNfY1QHxhL4jvZO8iVRaDwNjcRpxSzmAwkUgRE+Jb6OZZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(82310400026)(36860700016)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SqN7nNEBWRfJRBSGviImOrPNwm43N9JLb2WzTnQTuU5M/z6tt1Vm7Osb1b3M0Vn4odBemndmtig30njG8DYMjvmVaWIc9OJIsXTDX3xGnvUtpAf3BIYnjgB/lYAPjFC7vhQ4RN5mxFGsfS3JLKrGHCGQQyh7NX844OzHOQMr43Hjpy6QIaAJWy8kEqPkK62Mv3Mgo3wPX0ZEIRSMjkkxK2HFQg8XzvuQK6pJ3a7BJB2kElr2SsQiYKzpj73ckBhAiwJbbS0WdmrdzHNA+LxMvf8e73YNM8b4zOl7R772rH3pro+AVljF2k/QAdQkBLwBW9j0e0qq0YmH2x2iypwP893UIo1hVjJg0DVbWlMpUEfwO30EIELTyX+AfIKXqrl26WmHs0kTC8Ugb5tUGglc0APjS7Fa62pkaEso0py/vSjxWAWmAI5Mf5xtZ4jV9MFa
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 07:30:01.3750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a18c81c7-f9ba-4039-5294-08df42ea426b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026967.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

From: Gal Pressman <gal@nvidia.com>

When the device supports tis_tir_td_order, mlx5e_safe_switch_params()
closes the old channels only after the new ones are activated.  With an
AF_XDP socket bound, the old and the new channel hold an XSK RQ on the
same pool.

The old RQ returns its buffers to the pool while the new RQ is already
allocating from it. Since the pool is lockless and expects a single user
at a time, it gets out of sync.

Close the old XSK queues before activating the new channels, the rest of
the old channels can still be closed later.

The crash was hit by our regression tests, with a random sequence of
binding xdpsock to every queue and later changing the ring size.

This resolves the following call trace:
  BUG: kernel NULL pointer dereference, address: 0000000000000068
  RIP: 0010:mlx5e_free_rx_mpwqe+0x113/0x250 [mlx5_core]
  Call Trace:
   mlx5e_dealloc_rx_mpwqe+0x38/0xb0 [mlx5_core]
   mlx5e_free_rx_descs+0x126/0x170 [mlx5_core]
   mlx5e_close_rq+0x81/0xb0 [mlx5_core]
   mlx5e_close_channels+0x4b/0xa0 [mlx5_core]
   mlx5e_safe_switch_params+0x34d/0x3e0 [mlx5_core]
   mlx5e_xdp_set+0x287/0x3a0 [mlx5_core]
   dev_xdp_install+0x269/0x400

Fixes: 3b88a535a8e1 ("net/mlx5e: Defer channels closure to reduce interface down time")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72bca10c579d..97081a644d5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3421,6 +3421,23 @@ static int mlx5e_switch_priv_params(struct mlx5e_priv *priv,
 	return 0;
 }
 
+/* The old and the new channel of the same index are bound to the same
+ * XSK pool, which is lockless and expects a single user at a time.
+ * Close the old XSK queues before the new ones are activated, even
+ * when the closure of the rest of the old channels is deferred.
+ */
+static void mlx5e_close_channels_xsk(struct mlx5e_channels *chs)
+{
+	int i;
+
+	for (i = 0; i < chs->num; i++) {
+		struct mlx5e_channel *c = chs->c[i];
+
+		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+			mlx5e_close_xsk(c);
+	}
+}
+
 static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				      struct mlx5e_channels *old_chs,
 				      struct mlx5e_channels *new_chs,
@@ -3452,6 +3469,8 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	mlx5e_set_xdp_feature(priv);
 	if (!MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
 		mlx5e_close_channels(old_chs);
+	else
+		mlx5e_close_channels_xsk(old_chs);
 	priv->profile->update_rx(priv);
 
 	mlx5e_selq_apply(&priv->selq);

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

