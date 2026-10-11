Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489072BEC2A;
	Sun, 11 Oct 2026 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791725596; cv=fail; b=bL+A9LNXO8dSY+ZCEHa2vsmqeo46kSdQNJdPcxR5OsXg5URZb1G/LqNI35gIpFLfe7aEp1mXTrAQq2xiq3KeffF1Z02MhSt/dMc0XJBor0fIQyZkdEt1q8nYjH74XxuAxaCwrmXbSSyhpbcVAMc/v3oj+a3usZAxu6acPEOhntI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791725596; c=relaxed/simple;
	bh=efGY2KjHB/bYWJ0JOLkxsKH9xLIcKYiMex1w4x7Wpwc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qvOA/rETifCmE2LvgEFxadq1RayhzQJdkSym8pzn4JM3l73oGiPz9Fc8uSA57A61lBW+pbHBsxJV1A/1ZeeHLPdNYXR2tAflkBKC1rGOlnCkQglnUfzsakKvwfa1+VfAA81Kl9hr9P4u2QluJeTKlXot4/CwCbetkcZA/KN/pvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jU6EYc4e; arc=fail smtp.client-ip=40.93.194.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jU6EYc4e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mtnh/gC3dXGcK4MNNnGJ+veoZ/DmC9r32cE/BoVgH9XRJB+wcwQ1PkzXjI61wPZjY2XT84a0E9Bza2bt7p0whbyhmn6StphIDatby4e34HQNeokfYbooIaczo7RGApN0THL5Ky2JpDz9C8StPMwsK8P37m9IE6gLEvB+HbvezIdTDZdABP7hhz6frx3OwrOAtJ1Kt9vmlGmHBYp7ECE1yaW0N3nEsMekZ5/1IGnGi/Zn/ewOSzNWftR1BPLSDMjEl5zmrv2hlxzmGLITGDfiB2wa80Bu6s3C7wTIlLJHouNnGYKSnAuLGU5bQecise0n1q2PO29cVM3Yh+6ZX5pzkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vz73Ma+hetMZNzwbw51LanWdgC2anLrVClgGiTHMn4=;
 b=C0f0vV/wD/TqRIINgrOt1VA/1u998cvcaL/E1VG8NQt4ncAf9Bg2PGXf8qHS9j92SngbRAPhEpDAdPyeaBUPWCaEOVDSiRI3jg7TTKMvqMt40yA7fzuqrE9bWGM/KoOpVhltWEz/VhmNEy9gljyMC5VbCBF/Nr7GEqZzCqzJZjbUkHWhvz929uN1MlcCinjr6HJwZ8w5bwTsJ5Zvz3iDccysZDoWCakgOOPvGTWRK+f2W5hiucYBZJe/xTc0Jj1fbwqesKXL+2BpQo/+ASvP1kgFWsibGqC012vecwSyLD4B66F/O9RSY9Svbub7lh4Y2gyJjfoquOGSis1OcMA9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vz73Ma+hetMZNzwbw51LanWdgC2anLrVClgGiTHMn4=;
 b=jU6EYc4ekiyluXTDkJO3JumRPLHmzO29y+njO14PQvawLK6c5CdA+EF3uOdL6fvLwOuuHOYMhctUIPtrqyXu5mdCEi8+fekVknyvAbiFAiDK0rDTpFJpBF5ggJg3xgskdmeYQGqMqzwXrPh1eieaB+HdT0ZssRCRDmtd4eKEJ/9rQUbBNxfxG4zowA2pPX5iT856laNFAvY2ip4gyvx8uiiKKw+u55n5GH7EwrGcWTpzUXyu3wGB43OsDbZIyUT5etAePTdwEtO8waZHRaVg+2K6yshWJCjeO0irBdSDSwkgTl8qYudEifIECiVKk1f5aaI/CDZmFL5wT8bauFenzw==
Received: from MW4PR03CA0176.namprd03.prod.outlook.com (2603:10b6:303:8d::31)
 by SN7PR12MB7154.namprd12.prod.outlook.com (2603:10b6:806:2a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sun, 11 Oct
 2026 13:33:11 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:303:8d:cafe::1) by MW4PR03CA0176.outlook.office365.com
 (2603:10b6:303:8d::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Sun, 11
 Oct 2026 13:33:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Sun, 11 Oct 2026 13:33:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:02 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 11 Oct
 2026 06:33:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Sun, 11
 Oct 2026 06:32:55 -0700
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
Subject: [PATCH net-next 0/2] net/mlx5e: Batch RCU grace periods on channel open and close
Date: Sun, 11 Oct 2026 16:32:10 +0300
Message-ID: <20261011133212.807979-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SN7PR12MB7154:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fccc7fa-2b66-4536-689a-08df279c3153
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|6133799003|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	IMcbGWrRwmTurVd40m7noqGCwWX6L//i9Avpe0BeWnTDosf7+gLKTSd2MKo8ZnBgANAFy478sGVSJNCj1XCAZtqlkZoysF/acSsFuBv5FoHM8oTYuckbpbHAtBSTcuGtKxqEfxNss+TtOwmiEyVFDt699NtV3Ap4X1ep4owqmQ0Zp6y76dlQxh3oDqiAwPk+D0aNneCKcLhO2XgfMxIbS1MGkP8DXYPgIFAZrq5uN5eL1bhXp2D72jzfZVq86CcRhrw+jxjFL+0LEfRzdul8PkE5aDSl4jKjKA7zhPaRrnSSCkJcF//dDqIGIrKimJNlbQHihb7QFL1sS3pLVrBpRK6SdtRnbEKYIZSfW2iv6N4Vw7nvg/uDu5CQrbo/Jns4Wq5xLqz/Kg3mQkTpPRKJmOu3Rnlek1Wg94YV+GrmI7RaGjf7y8sFLWy3DpP9ER1s6xGXnp5RaF4lAp0xVj5NntRxkNUCS7YEU+dptVfZogsDfXmZzGnD33RWh2j8I5KOBMUJFGebhM9C2JG65UyjtrTFdSE/tD54m3H4E4Jhae4/ZhbRB5sFHAyPb89Rv/S1mKcNoxEnY/2z2d3ZnVemgDX/cDzPQMqs5xLjV6fApwvCFzP38257UEvhHXAJrzOM51Ip/Y+RXSBev6VoRyn3jEWVcfqDGoASBo8DqaqckOI9Ud+au7EqZ0i3sNoJXmH0aadMgjtjfAr90nKdhh9IVw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(6133799003)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G/d1LKh5kC4hMu2c3AXBNq3zb+P5z6uwAzphmFi/Jc1lOtFLakIM9fcyvNHofNDjLCbCz3tytYpav6sKXPefb/gDzWJWl++9h4SVTqckwGbgMB46F+q2x49Iom2XcElQoDCun03W2lMaVtQTFfM09k0EuG5lcY7Cm7gzfZFjObHRFkm2ChiXXjIpUgnB8XZa9O9Wnbkh8JDzKGtdsWVVMks8tqzv+NmJP0JpD5RBqS53TgZAMN1Ncy2USD8t/nLu65wrN46zw+PSGxcXSQhIfdOYXX9WARR6qXL9SggKF1bX9GyZIquA1hnjkr6qACE7LSJs1uwPdH/+aKzT5+DGqWqXG2ojHU1LR3uBB0Ed0jvIEWdkB4Xvyx4aMd37KqGtxeglW+mWIii6MvW1TLBR78aQdp/zaXcari6uFLSTFnpJ+qBxFrGXAiElgWeZdi53
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 13:33:10.2788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fccc7fa-2b66-4536-689a-08df279c3153
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7154

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
touches the regular channels as well as the PTP, QoS and XSK queues.

Patch 2 does the same for the ICOSQ trigger on activation: all channel
ICOSQs are first marked as requiring locking, one grace period is
awaited, and then all of them are triggered. mlx5e_trigger_napi_icosq()
keeps its existing semantics for standalone callers.

Results with 248 channels and rcu_normal=1:
- ip link set eth2 down: 10.183s before, 0.715s after.
- ip link set eth2 up: 3.095s before, 1.794s after.

Regards,
Tariq

Carolina Jubran (2):
  net/mlx5e: Batch NAPI RCU grace periods on channel close
  net/mlx5e: Batch ICOSQ trigger RCU synchronization

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |  69 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   4 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  27 +-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 232 +++++++++++++++---
 9 files changed, 304 insertions(+), 63 deletions(-)


base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.44.0

