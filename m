Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010025.outbound.protection.outlook.com [52.101.85.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2FC4D1786;
	Thu, 17 Sep 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668628; cv=fail; b=LWHdWnFS4ywm7jJ5OBWYmnQ7ZFWQphkFYyGJk3PnGMK/4Izam0R0BwcxCDH7aIW6N9WfBYLM8nj/MB9fwq4tYPTTvfifmM2jU8DR2nWQhw53JjLVpNPTK6ez9iroLzRq4XgT0WwwAJQ9hLRYRWW+EmWod6273CcZkjK8qD6YMpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668628; c=relaxed/simple;
	bh=HIVHp3lfjIsIaVubG5wPh8M1YCpQSwKKcJSeNN4GfKM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gzYoBOrRujMxJtps/Gv6fJZdvXdqGLuVS/BnbyT4e4o2Jr8dGHF7imK0Sg1Rtos8KiFD5NFxyo1WVLPJt4LC5ekAyJTpQm14jeoWgFNyl5kd7awjJDyFGbFJVbleZdm3+RFOYHk9/pAyv79TxJ7BD5Hk+ijGbl17kLORvkxeFBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jY4L0g8m; arc=fail smtp.client-ip=52.101.85.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jY4L0g8m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZneMHE5KtSBkO3Tv4ry9kOhmqH4o3Zx6n2tGQJ3UmZA3jCmtC+8gIJfhMln1nKgJua6rKhBY4Hs3L0LmFsyACzkTpPv+AvlFNKtgj2XhsTlyGhnj8G7UAb5RyBbeFXvCO6AIHAKGoXghSo6cd8XGbm8yrgRBJMafI8ob7Cc07q/FadsK/8qTnqbK4CxjyF79JXWX7koSOf7+bIpJtaueEdVAP8y1CU17L+WW90RopabfRiBpZhiX+ehB79JRYs7F1wMHvJ3jFnlYWvr6I9llNI9Deyd/MRMLW12WSmGS3bYPlVSwo1UZLiCD6ewJ5DbzJBDfVSEDu2xjacGMwf6uQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8DBP7aRbBhb+CqrjYhVK8hQGslb8b/WlkuK9m8KV5A=;
 b=bEBj44o+2JAp9b53jUFdUyQghr9LH5D5oVC+bjF96rPTcB2F4bO37xcWxMx2TCFjvLrD0yUevmuigyrf5yJNRmhpHfC4Q/mTgjko7ATPZ/thGFXlGsnMiFcsm8tt6PN42KcGYzCfbHXuZYf/usFc8VrzlZOS71y6+679Z0HxU5Cu/S7ijHR719p7NuDL0++RSYtfYDfMgyy/B5XjOvI98uu/wKFUoNskj7tYzDHtYPVhqQc5rRwmzzdZf9tCT+ZeszttFmcRXfwtWKGwhSScbp19MdqeIMBzH1kgonlWcd7cCClzN/UepG3QLhiGA5rXz4h/dwh5buxxkI7lzwoxAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8DBP7aRbBhb+CqrjYhVK8hQGslb8b/WlkuK9m8KV5A=;
 b=jY4L0g8mID4kUZNC6cxr6jXYxMhAK1IqNm73L2HgGjj1RokTZQDUEcmCsoRJ91T4isECM7qHA00jnDEpUg8L3oIaHgtk40po4bXeAR2X0Qg1+g1tQBNe62bI56wPhn0WfMH+1Iqmoy4gAcH2gO+Weru+7oC725+TWbd0gDXQ009Vso+Lnq/KfSvsTO/J2fy7u4QLu0pBcXeR7UUVI/+r6E0q2HmnUrgV56arp+MvtirTWJH14XkbCtVq35YTvjLHRHifFgjDUayIdonylS8sSPfI6pHvDGXDRhBUW5o1Z61l31Pu1k05y+xxI97r+pYao48Aw3JpQOnXhUAjyWcnsA==
Received: from BLAPR05CA0011.namprd05.prod.outlook.com (2603:10b6:208:36e::26)
 by SN7PR12MB7978.namprd12.prod.outlook.com (2603:10b6:806:34b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 18:10:19 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::50) by BLAPR05CA0011.outlook.office365.com
 (2603:10b6:208:36e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Thu, 17
 Sep 2026 18:10:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 18:10:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:09:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 11:09:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 17
 Sep 2026 11:09:47 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Boris Pismenny <borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Parav Pandit <parav@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 0/7] net/mlx5e: Fix offload lifetime, cleanup and exclusion bugs
Date: Thu, 17 Sep 2026 20:54:26 +0300
Message-ID: <20260917175433.4090878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|SN7PR12MB7978:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b426cb1-160b-477e-9929-08df14e6ee72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|23010399003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l4bVdm7ASU2EDyAAq+XRDZ80RfYXOejouYtDft4Q2D3F9FxLjzqgj4/mK/IsGFbwsiv7leBPj7ldCjjNPcUQC/GPP48YolZ19sW5Dk0Kue/KmbIKXYH1EpCHaNIaoa54p3R9IZcOS6r6k5kCbEwsVP9Yzb941WNIXekjgPmaFKfhmrnbm+a6/atQTg+Zfc/Y182Za8sAYu/zmQ+/exJgdnUM+32zSLg5lXM3tpZcYQGNLC/xZ6mMetFLZlW1Fm6ymfD2/pdsRv9EhgBzMePxDAQbim8aPejzb+19u8BNFYZ751/+wIAR9ztjACVURwvrxSg+3z38IfJyMW73ml9h6VOmiCnEJ6IyuN7QXCDiKFfFYw57AyKkdelx0mQhU91cQ0njMCeqWVrDiSZaCRO+JKRjjVOYXL5UEHDqtsbRJjww7aY9wTwAQM+KdQ4eBQfloPIKHN3IoYtFDjlRZuIBkGLxuT5d0mBfgZ5WC1l5KQ4UnIuu9hCsYWG3jrd0jneICC3DAI0CIMhWhRHDGq7fWYy4UKzJdbDqPYG/PXpgYS/AZzqpDOl/vryE2CzUZJDs7PiWsyjffjW0gpFQJayMWpFAi760MRIA46GVVd+YOBU9GF7cRo5SOxZEak6ywNrA8Eq+6PLOaLSqDlO9y0xA6c3HFB4yPKNm0yiME2XQJ8oeVyT64ofRm9Az/wqL1UhfLH/gxugz4YXz7mpcRBuSFQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(23010399003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VixsRj1KBda2eFTix2mc9Ox0CPK0oRn7YJUbIctGnWPZhMt5RXy2bvweoQhcYHWoc2pTmUcXn3jtaHWPULA2cEL6GIxrJkzntJHUtUXuQ8aDJHnew9LPWm0P0PC0njgisqohMfI620MoEv5r4MLRJF8E2jQCJBDA5dO2pHSJ9p9lHynWodeGxhHamF4gjKwGltebyQMrVwQMW5dpZhojrK/KIbd8pU1phzNQ5VcSsIdj72kT1e7u5wYxrN48JIwNNOmYh05gRPy35rUZEQ1JmYKtXRa7LDYjuaHQEdOXd+cQ2+e9W3MpVBjXNTWpN45lakhzcR689z2KIPXOPcK0LTFoyR9O/j404mR31YHSMKjVrnnHzvb5/pfIwmu/FMLAlZaPn0pTy0rbCbRixYCdxZR1of1PKB6C56HvJPv8jZzqadVG0cPrjeZEDj+h9Ovf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 18:10:18.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b426cb1-160b-477e-9929-08df14e6ee72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7978

Hi,

This series by Cosmin fixes several mlx5e offload issues:

- Block eswitch mode changes before accessing the IPsec context during
  policy and SA creation.
- Tie TC eswitch and IPsec-blocking references to flow destruction,
  covering bulk cleanup and flows with outstanding references.
- Track MACsec hardware-object ownership explicitly and delete remaining
  SecYs during driver cleanup.
- Serialize TC/IPsec exclusion counters with a dedicated mutex.
- Prevent SHAMPO from merging PSP packets.

Regards,
Tariq

Cosmin Ratiu (7):
  net/mlx5e: ipsec: Block eswitch mode changes during policy creation
  net/mlx5e: ipsec: Block eswitch mode changes before accessing
    priv->ipsec
  net/mlx5e: tc: Tie esw & accel blocking refs to the flow's lifetime
  net/mlx5e: macsec: Track hardware object ownership for SA teardown
  net/mlx5e: macsec: Delete remaining SecYs during cleanup
  net/mlx5e: Serialize TC and IPsec offload exclusion counters
  net/mlx5e: shampo: Do not merge PSP packets

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 55 +++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 47 ++++---------
 .../mellanox/mlx5/core/en_accel/macsec.c      | 60 +++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 15 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 66 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 23 ++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 11 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  7 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 +
 include/linux/mlx5/driver.h                   |  7 +-
 10 files changed, 172 insertions(+), 122 deletions(-)


base-commit: c9151088f1674fd29ff26a20f5fc687acf53a2f0
-- 
2.44.0

