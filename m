Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913447;
	b=k4ZJ9LZEFRm+rLWFE4B8tPPh3hU7pbh7IbZUlEfHuO8EfruMlhEHJWKmjddKUQxiWPH4
	 /o33CiUEJ16USYASBqujlXGiqy4ReExYNehegrhgFmJMenI4hrsK7ulIWWnY+SWYxDLyl
	 P8q04PXdE4LN0IxDaTTVRr9elaodnK1fCscXlbtA+9YFhUImfSpTmc2jODgqLSY8Wcz6d
	 2PUFN+2uQLh/mkk/h2uaZVEmZTtOS+L4rulOLIKLZ/+7s6Ghr3lT0KetpUvHufL8nWAuh
	 Pe7Y5WMXhYzFfpeJKjA38tM3iLktiGW/UrD/EnWtl8txK2Yj1baPgQjPDDK2unpkkvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913447;
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
	bh=1VklHjx2ocvTTItGNBIiBpHKD6IbgdMlWISL/fVNAQI=;
	b=SkI1cNsBLopTYxJQOL3L+0HiuWsQVZCrAJrwhBYT53O7c4v9AR91ukDz2iIrcu7rhfxm
	 fRXYoYJbKQ9Mpg183TViHyu2WP91OWayN3g60CBdgoQcVNSwx2+mcXVaGh/Cdd1EVSWsF
	 hRnuZiynT/M+RNAl7lQPaKS1SuYcrnMrnQHoFExUIljjiCy815klVKf7ADofdag4QntyZ
	 5rW2toEMfsGBikG8DiByhvIV4vq0J8Q1wrg4gT+AdVFnQb7/ThQrABKAb0SoKbcb2ElkK
	 xTJjwzHAk8J6PmIlxQNj0BXYPgvhsatzTc68BnIzec8Bj/ndJQ+/kkCLcvO7b2gMjlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lrlGEIDc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.50
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011050.outbound.protection.outlook.com [40.107.208.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFBD606A31B;
	Thu,  5 Nov 2026 21:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EFBD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lrlGEIDc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyTc8b+smMk4+KldRah+m/FfkWJjVsNObhjB+hL5f/uZ78aw8ZkN/S3nbOZgQezErK1eZ85rFveVY6pXowZDYTbhkb95grSvYuUNjpwCl+z9m2IkG6cVfaFsTm9H9Mn7BuEfrMus62e3nUhqflEZPrsMwzSZ10MsXFIoVfX0Gw2Mbog7wbT3EYQyXAZyVFDqjeVjHjVJL8NBIlzuIZlOea5REYwEHaE5n4313+EYeug+Zw3l0JDoSWJcE16lZtjWW9MS1xgOjsXtEf9p4XSNH7jLfyShdShEOyV2wyQe9reTU0BRrCwo0/3J0DwVBM2Hy7AWcM+DnenVjFMtvF92Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VklHjx2ocvTTItGNBIiBpHKD6IbgdMlWISL/fVNAQI=;
 b=nYTg73nd+VJMoK239daI27abL8CQv2HfcN0c84Nw4BypjpbODoF8OpTuTj5L/seEhcdNvkaGokDLuSIh06lUUdPBmgLoDfdY3fW7Z4+Rms1pfSrNKcPveww00CLpx4NNgS2jnDriE3bsJ/qxVR55ffTMb3u5mNQo76j2MaYm1Vzw2d912hD123+t16bQj/aJzKY4H/CpP9VreKKlY1eBW9WI88xMi5Wb5cCKylzIthWnapY0g7PDbvfAUmPkmAR2yzpOEfPGwlRgOMao9OwYoYJjddWeFNeMoytn1RwpnY1c8Sow73l9xi6o05TGsYgOoi6Ev3fxBn0bUZnIrW8qKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VklHjx2ocvTTItGNBIiBpHKD6IbgdMlWISL/fVNAQI=;
 b=lrlGEIDc3eXQB5MORNxMHfrt6OvD9tlkq44UqFdwAx88QE47yT6j/rsoecUhKcc52UlySZvflwNEUpMFMob+5Aqot/6UUxLIWJYm4kHkvni4WScNNeIw3BzBfYtTlMq3dCkOxig1K10jmspm7duFWcyxJ+0eAcqC/h0I03kvrIFQQgZzcNCCjBDUwzaGIjXXpvAXDcnpOZljcr2z08KJOyoXwBrn29Ot7x3FQZW/1QLVIDM6Qp4ECFjxuPtg63MCb8CqItLMPmTbRMLUF33UPcjAhX7czW0EPZUQuqWwCrZpi1JQ6S0KTNBZYNQNMBultSD9iuQgp0c46nLd03Jq1A==
Received: from CH0PR03CA0303.namprd03.prod.outlook.com (2603:10b6:610:118::16)
 by IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 21:17:20 +0000
Received: from CH2PEPF000166C1.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::99) by CH0PR03CA0303.outlook.office365.com
 (2603:10b6:610:118::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:17:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF000166C1.mail.protection.outlook.com (10.167.252.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:17:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:02 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:16:56 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Raed Salem <raeds@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3 0/8] net/mlx5e: Fix offload lifetime and exclusion bugs
Date: Thu, 5 Nov 2026 23:16:28 +0200
Message-ID: <20261105211637.1083978-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C1:EE_|IA1PR12MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 893ad6e3-076e-4606-c4d0-08df3b822d06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|36860700016|376014|23010399003|56012099006|10067099003|261102123227099003|13003099007|18002099003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	EFe8EoHYjzOYimxFYSamxJsY+WWLHhhnYAGPHOk2YziZUMdZeiX6frj+xh75wAptSVOhAw5w9UwK8G0uCyEXMqWjiXG6MUK25yAteUYvv0vDdUvJ2TpgwJ5Dg0EaSrBvsKFjo4lzT+ieqA/m7ggGYV9azdrKv3OMRBq2RBTTjGUNLBZ8CMM8V58efc6U2nSb6ZkTlZE7eN0N8+1rhuaohKBEV/1W6U14gcZ5WShBQHEz9D/Hz8IAxGquk/1U9+kqkBaMBKCw8XkbNa4nUgcgn2pnLho+Mi3QBOXgffoLwX4CS4ux7j2JVIFyMX+WW+HJT6iEHzp3VfRjRWqH6VumEC3HZNcKFZRPGz2HvzNynlNPypIguD2DV/AwTKhmakOkpOFZh7ydWuG053/+A84jCvMTxIamDGmga5GW3q52hn5EF6/xy429Zg/xAQQ7AmBGo2kUAknsthUNAeyuSenkhbQi+1vVgOIgwZDCwhC6Ny7MX0pgMYcKvr0aorsKZwAffjI5m1up98PQr5ieA+4cHSKm9QzHjRD1kson1sQ6902TrdawbPMBsOb/k9vzUKHELlGmVWFgEI7zaCJGrCyUcGOobQfASBTr4XqwQj/tu0xwVny3P8id0CsnXveKDPMnLgzhT2BWaLQsGMSylId3hD9s8UPFqFWXugqVqWcFAsnrU1sErCvvbFTlxZFcr95QfAg/IsjurrFP6mRaN8FdQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(56012099006)(10067099003)(261102123227099003)(13003099007)(18002099003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BbEqEZ01GY9JRx8CWsIlzTG4Vc+T6zlw9LpGi1dxKgAMf3cQQQGI7qUnhQZp6Doj+Q9i7KWVpnyPTRziGkMt0a67uYvjCcV1f45vLb3GzdbC0d6gC1ZPIBaM8Fx0YdAkqSljABC1U5wyn46uVyGyRkpjVIdEg11F+wtJcgMXd1SioISN23qRc2ieLJlUFIU7A11XqtQm1HqYMw35bN0tuZbnWMKTeRR3Pm7pkMdP9iNoPD4lO63ycPvOx3e9acMByuFF9PfJ59Y/NeghLRNFPEU7f1izwdukT+cMuP2Irm/edCfz3vy5NL13BJiaGcZBueTzf4TbJgb+JQ9F23n9ir2iAYqZNKdolDs3cNhesRi9KhoEStiQD4RDPd4tnOCaJQSVTxyDS5IVb4hmZenvpnK8bNK4Z0hSY8c1wDU97Ul9hU3HPQwuQtwSvy36j+Xf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:17:19.5660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 893ad6e3-076e-4606-c4d0-08df3b822d06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6235

Hi,

This series by Cosmin fixes several mlx5e offload issues.

1.   Fix fs root table cleanup bug.
2.   Fix IPsec encap serialization bugs.
3.   Fix a deadlock between HCA devcom lock and mode_lock.
4.   Fix uplink unbind deadlocks by not holding mode_lock across
     removal. All eswitch operation initiators wait for ongoing ones to
     finish first. Unblocked by 3.
5.   Fix races between profile cleanup/init and IPsec policy/state add.
     Unblocked by 4.
6+7. Block eswitch mode changes before accessing the IPsec context
     during policy and SA creation. Unblocked by 5.
8.   Serialize TC/IPsec exclusion counters with a per-device spinlock.
     Unblocked by 6+7.

Regards,
Tariq

V3:
- Added several new fixes, all found by internal Sashiko.
- Addressed a few Sashiko comments from V2.
- Renamed V2 patches 1-2 to "Block E-Switch mode changes during IPsec
  policy creation" and "... during IPsec state creation".
- Dropped V2 patch 4, "net/mlx5e: tc: Tie esw & accel blocking refs
  to the flow's lifetime", to be submitted separately.
- Exclusion counters: use a spinlock instead of a mutex, as some
  callers run in atomic context.

V2:
https://lore.kernel.org/netdev/20260930121119.141953-1-tariqt@nvidia.com/
- Use mlx5_esw_lock() in mlx5_eswitch_block_mode() (Sashiko)
- Clarified the fix split across first two patches (Sashiko)
- More careful dereferencing priv->mdev in mlx5e_xfrm_add_state() (Sashiko)
- Avoided spurious error message during IPsec SW fallback (Sashiko)
- Harmonized check_users arg for policy & state add (Sashiko)
- Clarified the scope of the "tc: tie..." fix (Sashiko)
- Moved macsec patches into a separate series.

V1:
https://lore.kernel.org/netdev/20260917175433.4090878-1-tariqt@nvidia.com/

Cosmin Ratiu (8):
  net/mlx5e: Release IPsec root table reference on RX setup failure
  net/mlx5e: Serialize ipsec encap reservations with eswitch operations
  net/mlx5e: Take HCA devcom lock before esw->mode_lock
  net/mlx5e: Fix E-Switch races in uplink unbind
  net/mlx5e: Fix ipsec core device access during profile changes
  net/mlx5e: Block E-Switch mode changes during IPsec policy creation
  net/mlx5e: Block E-Switch mode changes during IPsec state creation
  net/mlx5e: Serialize TC and IPsec offload exclusion counters

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 95 +++++++++++++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 88 ++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 ++--
 .../mellanox/mlx5/core/esw/ipsec_fs.c         | 15 ++-
 .../mellanox/mlx5/core/esw/ipsec_fs.h         |  6 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 15 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 88 +++++++++--------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/driver.h                   |  8 +-
 12 files changed, 231 insertions(+), 133 deletions(-)


base-commit: fafbc4051123d5459ea6950899cec08ed946e278
-- 
2.44.0

