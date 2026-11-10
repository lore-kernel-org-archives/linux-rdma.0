Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336680;
	b=0wRx2CvTodV8TXJ5DHfdOYYfNyl23VL96uyWf9gOoGxlgLgQdV3MqeuxP6on4Zo8XVdP
	 uXaH2PoBzXmgT+VI/4u5fhWwOgeGSYntFV9LBaIwvqjSsINxBBg4Nv9j02N6zwbiX6ehp
	 yHLpYMrU80Lu/RBURtsTc9l2vT/s/DPNU3QrUfm8yTCOI9Of1As9hagPVRYqKKjtdjZym
	 3UXmifI37TZYYa8SBGN9YDzQR0hiYyRuu2aQf3H8U0nCPh4H5uTMDta9VDbeqZt3Df/aH
	 ZAkfMid2oP0INzYFWCjYzt2JiH6aAZYUT8QcU8fgVwgdLDGiKnK6iakLWpBWUAiM/gg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336680;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
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
	bh=IoIUBTpp4WB7fFqpCsVloYFrBFyj4hwLPnUnViySpvQ=;
	b=wrJNVTMgU2kRBV7TleG0yQxMdinDPk++5JuVkJefx/M8AOeTpROFWmDN7/qydbEwyuv9
	 qYzHb7KAW6a8/EKAI4Wn7YZp6tyTCCbjMtJycc8mG1QxfaO1RsMvGOnCVirIcezboHP+B
	 td8savjSWFnCcdQjhv1jW+s9qr6aSx1WeBJ6vj9Qt3kLpqtbMDl8L2VcyfFZAOB84S2Vy
	 9WsBTzXFd+9D9Rfhm5U1X9wtHA6o3uK7MQgNMmMUA8za9sBgJCGZumQRD9sWjnOZx6+W2
	 jBIbVAAC7p5x1wvOGX3qcdKTtSS2+0MdOvxZ1yPxxhi6rAawkHDYE+q1o9loqMvcDSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="R5H/WTtr";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.56
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D44B606A327;
	Tue, 10 Nov 2026 18:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D44B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R5H/WTtr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EmCiqZ9jR0E4Lv1EBi7Rl1/8UMyt7/8p/U4scLechxzoi/MMSs67FbURoZwUnp1UPDC95EcqZRkUKhn1lovN8FGtXSADB22PtkUX7DB8ZalGhuo9OBL2FyTllVRHY0POlXCkYEUxYgUcCwfueR4Xl0wQ6ddzS3fSexGfkmJKAFPddHYr3pOx/dQBh4vq9G+hNCs+A6kgQIxvrGLCtWKkTw+mZXFuDO+FDrsvO8Z1Vp6yq7pWBrlxKI/JMt4MBV4sjHlcaUR42flQtue+O8aCA0vkHaJ/F8ZheiNNX1+1IXOJiuJizfCySfd/Xbl8p9U230Z0uP02iXdo4LY6sF6bkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoIUBTpp4WB7fFqpCsVloYFrBFyj4hwLPnUnViySpvQ=;
 b=mnzjvNIWWR6MY5VImqNxt8N712GF382A0COky4U0a1ttWhadUQJ26ahBFT+vC/vGi0mtNn9YOszYm4jJDFO/mTyQyuKasF7wg2CdAo3bt4k3qu2zUQoxxFwxUrnO6284sP4+/QHGIKBX+k2FyYq4HYUfp3bGqaaGumi4TCp1Ak02RCKD3JhV8u2+dGhvd4VNxo/S7LDZDxG9G5nLlFCN9HG9lcV9FngcJPQHvgO8R+xIthglIh4OD1ovGwNLiu4VmskrJOjOKs5Jdvan7Po7Mv3Q55+15di9uSJBRXbvad/+I5BRC5aS33z0AqCQav71qWT3QmkCiCYFqsA4o5GlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoIUBTpp4WB7fFqpCsVloYFrBFyj4hwLPnUnViySpvQ=;
 b=R5H/WTtrfg4P7XfVkoUiiqnRgXLZWlvTzFmRoaqMI85lHsY7YsiFJWVXiXv6eCHlgvhdg7ETVNu3Go9E/+QLqhtTV52JJo09jwgynz+ZlEhXeq3R7Zmyoi0C6LyaPJWOubbc4sjVFW9JRzQPQAYQQsrVuE80iVcgECLzcYCeUL2ffu3F1nphHCT1l5AFLFw2qTFZHopHolziPY2XH28xf5o3HirWguMsmJadi36/7yr7aD71j2I05n5Wu1UzxzfuB2ZFtoaUVPxLDYyd7LHt59QWvKQpwDAUVnOFTSay8UARKPDMTdHjVL+OK/oRjMRvPvOxvq30ZrXc46EDXgp40A==
Received: from BN9PR03CA0748.namprd03.prod.outlook.com (2603:10b6:408:110::33)
 by SA1PR12MB7367.namprd12.prod.outlook.com (2603:10b6:806:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:51:08 +0000
Received: from BN3PEPF00022BD7.namprd03.prod.outlook.com
 (2603:10b6:408:110:cafe::b) by BN9PR03CA0748.outlook.office365.com
 (2603:10b6:408:110::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:51:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BD7.mail.protection.outlook.com (10.167.248.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:51:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:32 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:50:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:50:25 -0800
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
Subject: [PATCH net-next V2 0/2] net/mlx5e: Batch RCU grace periods on channel open and close
Date: Tue, 10 Nov 2026 20:50:03 +0200
Message-ID: <20261110185005.2932568-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD7:EE_|SA1PR12MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6911dc-d260-4d9d-407a-08df3f5b94b9
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|23010399003|376014|18002099003|6133799003|13003099007|56012099006|11063799006|261022105027099003|261026140227099003|261028144727099003|261026121527099003|261022075727099003|261102123227099003|261021121427099003|261021123027099003|261009223027099003|261022113327099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	TIakcz9BH3dZs0GolEn+kGWRn6AjTzPylNOJ9S/NGRlUrUEBo8x8WU+QjmiM36zG10VqOiF4dvfSeGvCMqNZv9Cw2hjt54mfM2DdVi/huFWxBHSrlrzg4mZAzjEWV95gr1O1H9gFtrLTE874IvnK8k87f5AAsHPKTutJeU0+pZsFmW3nGZdeJ5D2K405Py8ZX9Qmi4EjJVekIfOp/9HGXvqgPAQfNvbmdYLKDYMEgaMd7dlQJKPh8LYfJujHAk3JXJ9u5MT+GsBLMEmnuCxtLVg1VUFZddOasdAk9a/YlU4SRVNjh13PR+SXr+WKYAC8nJM4zJc6C2zA1U+GX4dUnSAQdFm22y0UmWZ0HkCJznCct01n7tkiFTbGnyf2Dilpb0oswM6Y1FeYt744lRle2wpevubltvT22xiyLNAeImya2xetfMB0QgfNa4M72jhpS28y/6C89BA8dsZ0HvAfbzQO37ASjKbv+ZJqhV/TDtVo2XHwgWHkW4rG2P0zFc9Bv5SSebZsQTnXUFwGZ5ZcA9dNHhb/3DhZ6nJJIND284RURDSXqhe5IZT+4NEymMs0iH9zOqvzIhL8bBK4nFTXA62jZRbPFiWiY///IhLD5Eb9AXo+K+LXrHBXpmzI2jyEJ3kqpEnPd0u3/aPOdAI8uqXKZM0fIkF+iajFyqQTyICz+29yD34+7szBkplzQS6sTHo9fbukvC6PSMRFrdhfgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(23010399003)(376014)(18002099003)(6133799003)(13003099007)(56012099006)(11063799006)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022075727099003)(261102123227099003)(261021121427099003)(261021123027099003)(261009223027099003)(261022113327099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gJSaNe7WktFQGwzSQgl0qgsLTeBKIS1GedKt0FMRbdKBT3MyEJCrnoUwFqit8KmtbGeA/KmAXwm/pVztZus0DtxSBoT9J6WBlbW7E5ipeNRG4nm6wh3xNv/V6l1cUht/XBfQAW7y0dTTQHJKnwgbQ3YmmubicK00gD3SQrGz4f0ssU0KwvDmKy7ilP9le7MMpw0ZW1qeD3nljRQc990meNE6K6nwanhSgoM7a53gz542jJrpb7GSigN6yrAUwDlHHHRcwMKy+1zAMlBuaKd8R1cPYomn7qZvki3+Nh5kKQHgK9f+SzReMzDudQWNcYU16Fh1yBugRK9SOymgHd4Grqn5jP9r3QWZOTkFzM33JyWPGnxZyyP5ewrBhaL+gozV6aCnjjxB+5fVtTYERGIRni6mo5LbHzxzELx8/1X18D8AWRMFlQpjG7xcBm5Y2sOd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:51:07.8568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6911dc-d260-4d9d-407a-08df3f5b94b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7367

Hi,

This series by Carolina reduces the time mlx5e spends waiting for RCU
grace periods when bringing an interface up or down with many channels.

Today the channel open and close flows call synchronize_net() per
object. On close, RQ, ICOSQ, TX SQ and NAPI teardown each require a
grace period, so the number of waits scales with the number of channels.
TX SQ teardown adds a wait per traffic class, and XDP and QoS can add
more. On activation, mlx5e_activate_channels() triggers the ICOSQ of
every channel, and each trigger waits for its own grace period. With a
large channel count this makes link down and link up slow.

Patch 1 batches the waits on channel close. Channel deactivate and close
are split into pre_sync and post_sync phases: the ENABLED state is first
cleared on all queues of all channels, a single grace period is awaited,
and only then does the teardown continue. NAPI instances are likewise
unlinked with __netif_napi_del_locked(), followed by one
synchronize_net() before the channels are freed. The existing per object
synchronize_net() calls are kept for single queue paths. The change
touches the regular channels as well as the PTP, QoS, XDP and XSK
queues.

Patch 2 does the same for the ICOSQ trigger on activation: all channel
ICOSQs are first marked as requiring locking, one grace period is
awaited, and then all of them are triggered. mlx5e_trigger_napi_icosq()
keeps its existing semantics for standalone callers.

Results with 248 channels and rcu_normal=1:
- ip link set eth2 down: 10.183s before, 0.715s after.
- ip link set eth2 up: 3.095s before, 1.794s after.

Regards,
Tariq

V2:
- Patch 1: Split XDP SQ close, including the XDP redirect SQ, into
  pre_sync and post_sync parts, and clear their ENABLED state in the
  pre_sync phase so the single grace period covers them.
- Patch 1: Unlink the NAPI instances in the pre_sync phase of channels
  close, and wait for a grace period before closing the queues, instead
  of unlinking them together with the queue close.
- Patch 1: Clear the XSK pool pointers if XSK open fails, since close
  relies on them to decide whether XSK queues need teardown.

V1:
https://lore.kernel.org/all/20261011133212.807979-1-tariqt@nvidia.com/

Carolina Jubran (2):
  net/mlx5e: Batch NAPI RCU grace periods on channel close
  net/mlx5e: Batch ICOSQ trigger RCU synchronization

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  69 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   4 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  31 ++-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 238 ++++++++++++++----
 9 files changed, 312 insertions(+), 64 deletions(-)


base-commit: fa5196392691051963726787944db872420dfa75
-- 
2.44.0

