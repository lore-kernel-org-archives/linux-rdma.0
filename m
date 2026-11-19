Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795084818;
	b=PV4/OO9wwFPhGt7ZLGn33uX8tIUVLhgtb91OCL/v1RNIDMHaybodQJTY58qB/EFu5W6c
	 e2YKa26SlG3FeCzUJnEuOf+LkqjhnPdez5x75Kj6XFpENL+15IU0P3ifTkp0UfnB+p0GU
	 /re/68kz66RHLa/q2dpfEknhE3VCZMJTo4XvJSqDyADqj6/ekr9EvpqmWwfv0/dXlJmxR
	 Oa0ZoMlEKRi1HuOI3DzKl81prtXXZ9vx6IPH/HJ2uE/r6Gg6Xyi0e4fx7Jw0iksswZRqR
	 IT5x9Mve3ZE6VwGHtExlbSt4jNYAarWoaoVmndVjhKfRZxo1Up9CN4zocLNpp7o3NBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084818;
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
	bh=iGDF0KbsCmcczrsVrqDKgQeQ+DrvSjv/IBGR3UZqu4E=;
	b=wL/VvH9rbqc3wJaCOEQmGiGv/lFWDl6RAITffB2qlRW112RUcVfuR1OxhHXQd5EQ4uuH
	 tUKA6mKXYgIH/zF5jFzBxks1PsTME2MsuyZC6gkFCONTwKCrPdXo46Y/Pm5zcszQL4ahE
	 iLgUlXf5IRNmU67ZfB18Iciv2bFmkD5ZA3ClGQaK7nXsxgScyKeKAFs4FanImWReSRdvS
	 KQeEYEgYvoBVzDIT+OQU+5EafhV3Pvaxr2kG9D7FRgJNmbOH7eXvMtSBoaqfJ9rmYXPSi
	 n5s8/QKHLU8kqcxpVvxlnK46VBZ+XTKTbv5eUWhq+3NF7OwgEnzOuzmKJLmJXTFAQ5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Jucy7cyj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.25
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A360A260E;
	Thu, 19 Nov 2026 10:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA3A360A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Jucy7cyj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bMa70QYBKPIUhsHjW+nOydwVTcPhcEWt8QdD0+HF54n5h7ib94fy9libqluC6NJiQmo4fLIhr5iFZ/U/vZi1/6ks4YYFaaWHkbNaHZnLf6Sf/l+KjzyQMf6r2A3N7M08/3azn1mu/zhPTczpFZeO+tsK8CPLfJlcawBPoPYgagkeXHBtNMFmpQnrCfI8Zz2U9z/BQNJVP80DcA2yweP/jQK5wDui7hNtGf/gzjhYVcxcOOEhJdkdosyhBlNwe9t/XejIDAMGtC4NOcxbfonXU7/WsjWSE3eYPBGYFYTao4pyZ8JYEaWMzSVnK1/nrBsRBXa1Z47HXTqflcZl6fCEbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGDF0KbsCmcczrsVrqDKgQeQ+DrvSjv/IBGR3UZqu4E=;
 b=EgWCsKc1Q19InrvUBPT4zldOyy2/HCZB0xhm6sNZveo0ewqGICKc5spdlMNGgl2OGULlHs/oAchdfuD3WxzS9b/wJsIqpBvKXxvX0VBDUpmovjw7j86dWEJgmSD4ad6zCwUoEXsL8kAhp0EpJQFtHYbovp8It9wdS3BJL+Ng/3vjYaofnRsBc15KmgWe1/T8sMC6nsDkTj8vAeqaTyY6ENlg1yvadg+Afl72pqazBuRR+zJcQtcIZIB07NnyD72A4gdziQHvE2qBrrOCH+DK/QkLRQau2m5yPpSbCA1MyQkw+/j6M8Xfx6asdRWY25EGv5JPnK5YD2q5a6cbSn5euQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGDF0KbsCmcczrsVrqDKgQeQ+DrvSjv/IBGR3UZqu4E=;
 b=Jucy7cyjEYzA9aihTirB7XjGLX6GRDy9Bf7H8XrTd6P2tPUGDUl/9WtJyE6HbAyeCM1IiHm3Asth9cwht40TLHKBMg4shZqYx9sY/jsO7zVT36vfFQJ/R1afeD6b4fH6VMEocavq4uj8/RHnk26FjeF5cNArnAda3N7LcysVdYKvc00LjznM2h4pJBjrIoqux8m0wiBvJDuIggeOQkjRYCEbOkSnFu48cldJTK9+QV1UDS0mzUG1/y18i69s0B1Ihk6VQpkadHrP9pXDIfLdFhPBCgWL3guxp5tsU06deJrGTU+SJ6jAFe8fBZ/nctpzEeoBdMxNjdPenY88Pyb1xw==
Received: from PH7P220CA0067.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32c::9)
 by MN2PR12MB4061.namprd12.prod.outlook.com (2603:10b6:208:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 10:40:11 +0000
Received: from PH1PEPF00062F29.namprd02.prod.outlook.com
 (2603:10b6:510:32c:cafe::3d) by PH7P220CA0067.outlook.office365.com
 (2603:10b6:510:32c::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 10:40:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH1PEPF00062F29.mail.protection.outlook.com (10.167.243.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 10:40:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 02:39:54 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 19 Nov
 2026 02:39:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Thu, 19
 Nov 2026 02:39:48 -0800
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
Subject: [PATCH net-next V3 0/2] net/mlx5e: Batch RCU grace periods on channel open and close
Date: Thu, 19 Nov 2026 12:39:33 +0200
Message-ID: <20261119103935.2190627-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH1PEPF00062F29:EE_|MN2PR12MB4061:EE_
X-MS-Office365-Filtering-Correlation-Id: dc636065-0a7f-4241-e413-08df46297c6f
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|36860700016|82310400026|10067099003|261026140227099003|11063799006|56012099006|261026121527099003|261021123027099003|261022075727099003|261021121427099003|261022105027099003|261022113327099003|261028144727099003|261102123227099003|18002099003|6133799003|261009223027099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	ed/HQrSP1gDMkpIrTduXzrXZ5k2Q/3iqDt7l2m2piPhjrjseZcxciYEaW6laY53HVGBc/ckjUun/09T48l0hbbcHJkqbPgmPluDrRzyMbcsc+9W6ZnKCy5t1OiZZqNJC8qXxIxI1qKC96ptff216p4f3YG5ggaT4f5dL1UkssSHtI69wIy8g39Z/a72+qpNtpRrNNG+kBHHCIvbJGqNVz9yj9i9VVKtudHFNM9OPuLy6NBHp9UdGAOWFXotUaS9+nPGHYxUz8+OcOKoO4bYGrwTjSGyPLTx2J58w78hqyBb8BLnqCHDKamHRWEKPUZdUiwkp5mvbxEOG5cNN4Wr5PYNHLjvFCo7DdAkfSMnT5cY8so7P9cSkLr1qw2GxLOM4YBa0S2lQIxi9sVdRuXm9irsYgV+OHXCbROgH4c7ne4xhJNwh1fNGbTTImMAq8AvauUQosk3kd/iu7qX12Q8ECq9B/nw9MKJBNndnJllzZUHJxCREB8lV6GsggSxRqji0ZFlsUtIYbLhVe1g0JBpps9Bd6iivZh/y5KdyvuBZjDdpRGrZylyiXC8Kpas/cRHp/YCJQEpixUri5f8o7mjMBqUAZMfy4bm5oc4BdnWwAI2uKgmLQJhZTfh/tHNhO31A13hFGlXpnd7PKpyP6isbaenIyS/1NMEniAkYp9CyEQ1gEMAMvS/oixk6K+yty/IBmLIIH5GuXAfm4fg7KnIRkQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(36860700016)(82310400026)(10067099003)(261026140227099003)(11063799006)(56012099006)(261026121527099003)(261021123027099003)(261022075727099003)(261021121427099003)(261022105027099003)(261022113327099003)(261028144727099003)(261102123227099003)(18002099003)(6133799003)(261009223027099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GR+i7OQXsOXI+/Vj3aYWnesMSVqnlmbOAV58kFpFSsy+YKyg+VVhj9LMRJfBmRxursdiqTIEcbDrNCKTOz+ktLObUwkks824iEUt6tHDLKMMr3l2P5OtUILwoDUIBP6NlMfrwyl+u9ozlHF4zAmFNKV8Sq4k5/Lkc7ZAbLnpdyDKOKU4IAO4OLGsVWS1IaB74noxO/mjaOXYgwplK+rsj/QimkTEIReODrDpjJpBqux0W0MxH3N8Xr68fjvK9QHKB3aRy7Sff1+9cSC210ZpwNUAUL1c0GoN41qK/m+K6JTnBe9+2nLuvBmAoaY9lSmdqyV7h2A+OHYc1ZxQLZg4ItkrHeyN9dvT3TW0B33n0ZdPyL28kuoOoHGIDHmdu9cfneiX/dL+InD4/DU8eZr5OR4V/5SwmVkamuClyn2L6Ix4jcc03k4E4NIr+w4fidBq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 10:40:10.4347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc636065-0a7f-4241-e413-08df46297c6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH1PEPF00062F29.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4061

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
and only then does the teardown continue. Once NAPI is disabled on all
channels, one more grace period is awaited, as the poll may still arm
the CQs after napi_complete_done(). The queues are then closed and the
NAPI instances are unlinked with __netif_napi_del_locked(), followed by
one synchronize_net() before the channels are freed. The existing per
object synchronize_net() calls are kept for single queue paths. The
change touches the regular channels as well as the PTP, QoS, XDP and XSK
queues.

Patch 2 does the same for the ICOSQ trigger on activation: all channel
ICOSQs are first marked as requiring locking, one grace period is
awaited, and then all of them are triggered. mlx5e_trigger_napi_icosq()
keeps its existing semantics for standalone callers.

Results with 248 channels and rcu_normal=1:
- ip link set eth2 down: 11.837s before, 0.817s after.
- ip link set eth2 up: 4.087s before, 1.080s after.

Regards,
Tariq

V3:

- Wait for one more grace period after napi_disable() in deactivate, so
  close can destroy the queues before its single synchronize_net().
  This fixes the page pool and PTP SQ recovery issues from V2, and makes
  the close path simpler and cleaner, with no separate page pool unlink
  step.
- Drop the synchronize_net() in mlx5e_close_xdpsq() instead of splitting
  it, as its callers already wait for a grace period or run before NAPI
  is enabled.
- Test and clear the XSK state bit once on close, instead of using
  xsk_pool to decide on XSK teardown.
- Add a sync_needed parameter to mlx5e_qos_close_queues() instead of a
  separate variant without the wait.
- Keep the original mlx5e_xdp_tx_disable() name instead of renaming it
  to _pre_sync, and only drop its synchronize_net().
- Build the single object paths from pre_sync, synchronize_net() and
  post_sync, and keep mlx5e_close_locked() calling the existing
  wrappers.
- Remove the priv level deactivate wrappers.
- Order the new functions as pre_sync, post_sync, then the wrapper.

V2:
https://lore.kernel.org/all/20261110185005.2932568-1-tariqt@nvidia.com/

V1:
https://lore.kernel.org/all/20261011133212.807979-1-tariqt@nvidia.com/

Carolina Jubran (2):
  net/mlx5e: Batch NAPI RCU grace periods on channel close
  net/mlx5e: Batch ICOSQ trigger RCU synchronization

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  27 ++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  42 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 -
 .../mellanox/mlx5/core/en/xsk/setup.c         |  22 ++-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 154 ++++++++++++++----
 9 files changed, 207 insertions(+), 55 deletions(-)


base-commit: 7ccc5e05043b1bb84326b19a2b05938d8f7a2ae6
-- 
2.44.0

