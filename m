Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795641668;
	b=iWUy+huy8zArcC1mFFUwS4H2TQQluP8mA6JU/Jv0tKR7uqXvPd5WGVG25gTSDJ70uqCD
	 mFoIUhogfyh9E4SeZVuQ/IOya6/GtxOEeG0FFbwnLC/bjcDjw4zR5kYWVWeBK2En7VyGc
	 RwpsTVtYwASYQJiuIisIgsQIUs+nTQwFE6tdKIZQd6tTEIxvg27Fn8amfCDphiGGh+gaP
	 pCEVUDIOOdw7VAIRVN34XcX20mEsA+MQa2Lg1pGn5vZs1LMth5H0/s6D5ABlePbs0tPHA
	 W42g16L1atlqxFNf4gxyVzIU8Fy2Q0U1eCSUNRxXEWoLTB3kXaUw4f/cjT+i0kKbhfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641668;
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
	bh=6MKkvT+ZnTcVhfPG45CQpxg8IQFBZdHJdTN34fDanwQ=;
	b=ymTzorInh5Y1+Z7SqTJyJAPBNPv35RB8+7e6/kBpDcAftkNGlVDzOjeVOqJTroWweB60
	 1VikWwF1OCuIpWHWFFSQNP01HVWz8LM7zV15N29jB4e1Zjzk3LKIs1jnpNzYO7jSNA+z8
	 QswVUF2E9ySP/FVTaXOwwB3CjRbJauU8dyTLnKNO4YfWqB6qPMDs2KNCQF3lghU3xpsh5
	 PsuxghOfkqDg9WztBQAyEwBlylF4OGt+3sIAbWrEI0u5vJngrxXbxhgk04xJ5uzP62RIu
	 gMw5eib+EXKb3oYMkOWH+Aa40LArwN5PUALZv/ytE6yIAgrhV4osDgFVYVVcrdE1p9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bvfVPCFN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.42
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90263606A31E;
	Wed, 25 Nov 2026 21:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90263606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bvfVPCFN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yd+WTTz2haopH8orsBX9lkkoeCVu78WaqHDsFurzopLKOunQv0qHCeNZlhSh/I+gqdhtfndEeBwIf3rA2iecPNfxTFTQnzmjgJyc7pBCOnV5EMeAaXBVQ2dNlbwy8Nd0nXIedMHrTmGMJcyntmsdzryQWjfJDDlE5TzeW37icT7LeJWREsc5jKovdhLmxniso0ig5/+heJLy+u7DpTUQ7uG7rFYC+ON76m94DiRn0KE0pqrBguM4ko1bOwDuLImXJoAUocHpRQYx1fO/saPkN8f+PdY4+5UROdGMPmUDGv4OBpi+Zp4/aN2zejVZiPAGp5n8A1+r3K86vhI4d7SExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MKkvT+ZnTcVhfPG45CQpxg8IQFBZdHJdTN34fDanwQ=;
 b=PQTlB22cRb4PEG3/nm2PhbGYG6Ehp6OZnkcv2bV3sJobyvaAiVOqkSuzdNHPaQU6Sf0ew+fNLlISKjwbpoOYT1mCZCwKWw4MfwtzzIpKu1vYaJllIiIsscNlAmJEgu9HXL2dyctirdR19xSWcm5galSMvD8PfZF6pVqmBwKRpZFKcLnltgqTO9ZZb8XIkKFj6dhTYFrd6pXZDCbKr3l/8psHPuWSXzvz6HQC88sppny5ELV1cj9NERQ7/vCEUBZ+e7f7vEm7Ki+h1tO5m5ZHV8SMmxND1sOtlNJc4op2XIZch2J2+GW1nlUuPzr/MXbPyZOOHe4pvtLPpVuonRPRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MKkvT+ZnTcVhfPG45CQpxg8IQFBZdHJdTN34fDanwQ=;
 b=bvfVPCFNbNpreONObyq2Z+EWx0953Taq6RBC/q/k5pPzdTYzPcncCzqFhry61OVLyZjfik6z8SlskniEi9fpiIxOhfooDnrUPk8O70+goZ+NIBt7dWad6+L/CYg102m0ZNYDBcR/jf+ItU6eY7WuNN9Tbv+c8yX0Chmr6nU7tjX7c+QGzIWKNa0I2qk3zFSUPiYTD+fNnB5IzJ2KxmbrB1wXrJ6LXvn1yJdOBY82QzHMH83C1iAedeoZmU81Y2VHv9bvmCY96nejJnX61I3d3+VUZcXhL/1etQSDHVyLJi6WQ399YLewloA7zj2gJIAqzHxJZAUl4ZoCA0KEJiq77g==
Received: from BN0PR08CA0004.namprd08.prod.outlook.com (2603:10b6:408:142::22)
 by DS3PR12MB999216.namprd12.prod.outlook.com (2603:10b6:8:38d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 21:21:03 +0000
Received: from BN3PEPF00022BD8.namprd03.prod.outlook.com
 (2603:10b6:408:142:cafe::5f) by BN0PR08CA0004.outlook.office365.com
 (2603:10b6:408:142::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Wed, 25
 Nov 2026 21:21:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BD8.mail.protection.outlook.com (10.167.248.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:21:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:41 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:20:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25
 Nov 2026 13:20:36 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Kees Cook <kees+treewide@kernel.org>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 0/2] net/mlx5: Add controller number to SF and VF phys_port_name
Date: Wed, 25 Nov 2026 23:20:30 +0200
Message-ID: <20261125212032.243064-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD8:EE_|DS3PR12MB999216:EE_
X-MS-Office365-Filtering-Correlation-Id: 30b88774-2bfe-4772-a529-08df4b3a0270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|23010399003|36860700016|6133799003|18002099003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261026140227099003|261102123227099003|261028144727099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	wonEK+7YX3+prvRvYdYnhtCawg1sFB9ZcdPVId9POlYpe/qOhv5rznzGBmZBtvt5xvjV3CI8uZn+vR2XZBuSiuZD7jvpHVY4sglVflc+nLDQzQc/JiYjFzdpiGDwEbqe+JeEJ+tCWdNgmz6QL2mpxo0aCYK4e9s1wixiCVqhOYhUh8eY96yKCqQX5GJwHYMY7H+TMz6vCnqFPzACOM5micQuQ+ganRumpGs2v/rpgOfd4dFvF14VWV7yZymHXdB1q6dmxIop3UwNl4A9xQcDymLMNCewCEN41MSFfcOnbiax7lHmGww7GSd12XVcQJ8wW2LQ2TLYBpm0ZOafQEGYrQwUZP2CQwm+bHD6KCvf4BV+oHLAt9BOOT3DBfKJD5u33ZnVtFIPxDzrB2S9M7cw9D+BHH2fguTUTA1ngXdQ4fg0Ell7NA/FjYVEoBekfpd/17hcunbwY2FfOEfHTqrrxQ/6BZ38KlbckmBfC849uepSQdt87PitkSp2gumRPYz1dvXN0+vtVpEHTP6LsaIQskdIVouXzZhzBgirON0sAeh8X+tI8Nc23aEp6eZhHXOB0XZ1mM4XVzIQA6Xb/ju6/kaQmwbGhclRAXss0OW2viwFexme7gGzpM8vyI3IkJIWANiMVSAhQJzxahv6/YIpJk0nkNIPQKORuAkZE5pB8rwOXrS6512pkzCfCuSCl/2TKkIdnfKaZRawM9iQWgkQpg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(23010399003)(36860700016)(6133799003)(18002099003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026140227099003)(261102123227099003)(261028144727099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bBUoXBGvVMLyWOK9/tD1KrcDg193650f3GXkU4WTmgkqiivlP2fPuiIA4x60fKnROJEIB9q1RYg8EaM3csuufHNImAiP4u1aEQDHVqFYFKK9oQ6SlgXGG8EzbmqdiK09sfiI0iPL8CCO/U/rTCxww1hNTQhWDAO4XzhRIgG+gcxwneqdsrz/hJVBcJmvKTes4w/buZh9IoeQpDzAwC+vgtrmu5c2YunnYXLgp/geuRWneVwO+TEzi1T2/HvW9kdBhicPeMea/a/fyLCPMFFcCuo/HAc4glyKidTOreCXIMpR58bbo5TBSc92GfUWgGksV0I5PydRL7ZbynWGGA77wUGPNpfE5aVIbX+pMbUQPIdibopJydELbb17gfXeUyXy/QGlYcdVjkbwZWNP9P/fRpP2TYC3TkqRM1r6d4Gq7CdnihRzkxopR/zsMPSz0QiO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:21:02.9275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b88774-2bfe-4772-a529-08df4b3a0270
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999216

Hi,

This series by Chris adds the controller number to the phys_port_name of
SF and VF representors on the non-master PCI link of a BlueField-4
Socket-Direct topology.

Today the controller number is omitted from phys_port_name when it is 0.
In a BlueField-4 Socket-Direct topology there are two PCI links under a
single eswitch, and they have duplicate function numbers (pf num) and
SF/VF numbers. As a result, SFs/VFs on the two links end up with the
same phys_port_name, for example pf0sf0 on both, and cannot be told
apart.

Patch 1 is a preparation patch. It passes a pfnum parameter through the
SF hardware-table allocation and free call chain, and stores it on
struct mlx5_sf. This is plumbing only: pfnum is not used for hwc
selection yet, and the controller/pfnum validation is unchanged.

Patch 2 gives the non-master PCI link its own controller number, read
from the MLX5_PCI_PF_TYPE_QUERY_PF entry of QUERY_ESW_FUNCTIONS as
host_number + 1, so that its SFs/VFs display the controller prefix.
Since the self PF and a satellite PF share the same controller number,
pfnum is used to locate the right hwc table. With this, the SF on the
second link is named c4pf0sf0 instead of pf0sf0. A user can create an SF
with the device controller number either specified or omitted, and any
other controller number is rejected.

Regards,
Tariq

Chris Mi (2):
  net/mlx5: SF, Pass pfnum through the SF hardware-table allocation path
  net/mlx5: Add controller number for SF and ECVF phys_port_name

 .../mellanox/mlx5/core/esw/devlink_port.c     |  24 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 117 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  22 +++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  16 ++-
 .../mellanox/mlx5/core/lag/shared_fdb.c       |  58 +++++++++
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  58 +++++++--
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |  49 +++++---
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |  12 +-
 8 files changed, 295 insertions(+), 61 deletions(-)


base-commit: 612848d37e68b858e15815175f1c5e609e09d719
-- 
2.44.0

