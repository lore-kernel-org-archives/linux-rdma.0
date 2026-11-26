Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730279;
	b=C5c/3DVrPvhSAQFH7PeY3ZZREqgECcDe0RcnPNtnzvR2uMNBOtc1uAxjuiGPXZNhqFoO
	 xzEy8aOxHcMgxjLxa6vDpslQ6QFTGDMrrsTrwEr/ap+dZhVdzT464/lFADWyk33l1s9ya
	 6xFiN7U5aInOp/QVQrtliwOpsXvaeQEzGLMBAo++utTFTcbrxPJYBpWOFa792n5QWptFA
	 awm+2CXxdf3fat6ZBWmrd76VC/qYxdeR3kSln4QJ5I3XoE+4nNcG3MVsb5PlbtUnwMfy4
	 9vCe80A4Zl/8RCdJbof80s/VcQlwJxd2fTD31xDNSHkpE9bp9z3LvhAaDEQ/AKMrz4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730279;
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
	bh=TglRTeWqOzhe2hQ0RDp7JOZgUmNQyKkZ3pGDFAEkads=;
	b=0f72XK7qVNiZ67Of426Jk4DL5SHlR22Z+66tbEsgWk7MX+wY+o8xbGzG/ZqRXrlbIxtw
	 +PpXSVq4ASyradDj3Pzfu76lOtwmkNkd6DD2m3s23WBTDAZgTswjVDTVl8+QfhXqKiApl
	 dw7Qzp8zojmTAtr1ABsYDI+f7KHEy8wIG72WS3/IFScQ6eQNaLf/CKFmdlK6Znxv+JhwC
	 vLpaQMFbT6oDsgTNRjdcpyKn5PapRI5NhUzZfyasExCngAp82FOLFG+/oy2POPGi4CXOn
	 MZfkK50NfUCEgLPwXUAffbeF4c3TeL6Ch70dHxXOSjPfDnr280WNYxbuWOgMfej2d1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UyYDoMfR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.70
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A44606A339;
	Thu, 26 Nov 2026 21:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9A44606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UyYDoMfR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qJyeh7kk2xh2c7oOcX3PQI5hmEaeuRi+brISF64DoR/AdtfqAfoZyvy9olGNS8W7kO5ngH9gUjXFv0CvuK/1tP82dGu5Mtyi0ObcGLkp9iOBHqWuWXcbDHWHpdffM2r4stGf4ppxwdhRF4TYEwRY51nBeLPwLVVvvFGtQnYHqZOziuyrXdUCSPkFjH3J3brjFSulbt4Spet77UBXeAhYPCrnlPfN5jx6+eoGQhRhwMsqQGhIjw0YH0Bu6L+UkZQgQqHuGy7SfkaAkB7VUfTRjwg5nAgo0SlYeaVUU9hQKuSDPQh4n5KTFKyAyrUOyRKAILPH7HB0kANGqgiU3pJuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TglRTeWqOzhe2hQ0RDp7JOZgUmNQyKkZ3pGDFAEkads=;
 b=Ti1lVoGV6R9uWGfKUvKskHJNZ/UyqbBhDLD0u4TiSqvWdIRtnpnY63u0MeWlP0XkXv3jIc81pAn+trv1lY9lhN/tqc3PlrCz1jfoDgPvgAUquyBMWoDobqwm2lPWWzmwfvk8shqzZSn9UHKDorCevOWNuT0L/0D6Gm1Giw/KXfhsleCbyT3cZyunUA7OvlVfC3ceBmzCxgc7+WBwUURfjh0Iyeyx7zn0qAM+jWyVNxBN+voZ58GxqWqj2ka6qqnjLQZ3EAK/LJPXW/JJrexZruU7SuHueJJSddy9NJeJMLGEOgpM5hq6TuTXocCubOOPAJcb4ZnHFBcIRxhlu3/x7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TglRTeWqOzhe2hQ0RDp7JOZgUmNQyKkZ3pGDFAEkads=;
 b=UyYDoMfRcGbOaIGxUqqmRRRWxGpXSsT0INPU4om3/1r7RZzs+Pxm+3K+ATo6HYXN54M5/lO8xKcn1MpoVrzE0zQFXkGDxZd/tRCCHNCFk3JwHCixb5vAD+bLUVDB/hZFKZuolvDZ0XgebhqY5NCaWjWPnVnLUC4U4NbgW/IRxCM7HKLEpgeSbuZ9RMjxoep239aXGyisXYTlGrxE5qZtl7SJ+0CTB718n3a7mHLlG03XsSNNHZfEb2TemNhnU02YLbkybOE+SKbUTvIRDo4ygErSfK0cIuNuCNLp51O3j9+pGJd61Ofgx9e4rG0a1V3GWzJlUj2/qSlvDPJKlX2ncg==
Received: from CH2PR18CA0038.namprd18.prod.outlook.com (2603:10b6:610:55::18)
 by DS4PR12MB912252.namprd12.prod.outlook.com (2603:10b6:8:4f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:42 +0000
Received: from CH2PEPF000166BB.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::73) by CH2PR18CA0038.outlook.office365.com
 (2603:10b6:610:55::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF000166BB.mail.protection.outlook.com (10.167.252.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:33 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:33 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:57:27 -0800
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
Subject: [PATCH net 08/10] net/mlx5e: Validate neighbour events before updating IPsec SAs
Date: Thu, 26 Nov 2026 23:56:12 +0200
Message-ID: <20261126215614.792598-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BB:EE_|DS4PR12MB912252:EE_
X-MS-Office365-Filtering-Correlation-Id: 686f07ee-79cb-4e2e-001f-08df4c084b48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|261022105027099003|261102123227099003|10067099003|56012099006|11063799006|261021130227099003|261026135527099003|261026140227099003|261026130827099003|261022115727099003|261021133027099003|261026121527099003|261022113327099003|261021135927099003|261021121427099003|261022075727099003|261028144727099003|261021123027099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yCFpN7uAvsUcaBMkECNTRPWhoGKooscY6QoabHOjmVi6ZIjCMCzuaYloQGcw8yWL6fh110jfIrRBpDCXluJEPsPou2vOM9jSR7r72oLDqK0KOOwePA01AygfwIJcD3ZOalEoNbhOKc/bDQixXXjbKq/aHTMw4wxX47w55vLYd+CTIZGNj8ETU9TIeQP2tm6JaVms6Y6jLniG+j3xQ9q7jvDG0nCxwD/l4JZ1KwlNbCQgbD1zq4I2o7l2R2HU1wZm7DorZAVTiJ6CYwC1v4XJusBTNlgiaeY2zY+gpa/DENSN5zysVZH3OiTphdp3jtEaJj4oq4azjetzU725ryOlRAdivnIktLxF+PssZchC+9rFUjhEZaAOH1gZXwS0YLiOQfcI2u1axgmc9EuchoNnn2xJC/21wRSwZQCqQutGJGGCwAjIl2Qi9fH3t7qCgUyyBtnyZmimPiWo4hCv9m6pNDu0pW18jg226wPIQIjYdq62no45VVXx4NsHc5uWQgFdqJh+XdrQU70N9kM3JJSnFMRnSe84eJAdd/oAhMBDudz/bTWzDuuUbLBklruCtbF7oEZxyZHFByyZHSDBcJgYbKhIa7XAccjtvxagO1/QGUVS+vYWw4QYwc/qh98EW9GRfwhOxWG7aqcJN5gi2jJPUk6GIrpUQG1psK6LbeBRZDK3mD7CloJ8TeRMejXz8Hba
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(261022105027099003)(261102123227099003)(10067099003)(56012099006)(11063799006)(261021130227099003)(261026135527099003)(261026140227099003)(261026130827099003)(261022115727099003)(261021133027099003)(261026121527099003)(261022113327099003)(261021135927099003)(261021121427099003)(261022075727099003)(261028144727099003)(261021123027099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZgCxvtzJ2vAIFfpF61H5fRgpVG/X0SE8Pn1zn6dqS+IIRXR2vQNqXZkPBryzHMrWxw3N8btXXPc86WOtQYF00NgJKawmRwuiSIHJrgb1kyoE/g7a8ujpM6NjCNDwrqz73apFqo/So+J55bDJXl5jK0LdiPSFSocy9oCEYuKT1LMK/FW6FYbE69vuuiKJS4Rs+eB2CwpFaJ3eezrbsdcqiGoa+wFJCbxBBQaEvrrUV6eIwEaKcwXjrtlOUUPFYYtqjkRBFOboZvP66egKPhJev89JS7xTu5XlRXFO9+POYP1zPfftR+TzV2AMTi/YGpQbWmzApULzKy1S0cyC+kF+56bmZakmVL6Ip1UI6tmI1wYEp4yZm8m780P4eJm22lw+s7MnRSWdSp7rpUvvCLqpNE8PP4yPMNcXHotS2YbQsTyOB6WqDfDge2SD/+GN5rbh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:41.4732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 686f07ee-79cb-4e2e-001f-08df4c084b48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB912252

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_ipsec_netevent_event() runs for every valid neighbour update on
the global netevent chain. It matched the event by the SA source or
destination address, which is wrong:

- a foreign neighbour (veth, other netdev or netns) sharing the SA
  address overwrites the programmed MAC;
- for a routed peer the MAC is taken from the nexthop gateway, whose
  address never equals the SA address, so gateway MAC changes are
  missed.

Snapshot the resolved nexthop (table, ifindex, key) when its MAC is
read in mlx5e_ipsec_init_macs(), and match events against it. The
neighbour tables are per netns, so matching the table also keeps
neighbours of other namespaces out. The ifindex tells apart one gateway
IP on several netdevs in a netns. Save it only when the nexthop is on
the SA's offload device (xso.dev): xfrm flushes the SA when that device
goes down, so the saved ifindex can never be reused by another device.
For any other device, e.g. a bond slave when the fallback path is used,
save ifindex 0 and match the key on any device in the netns.

This depends on "net/mlx5e: Copy back only replay_esn after an IPsec
ESN update": without it an ESN update replaces nh with a fresh lookup
while the hardware keeps the old MACs, and writes it while
mlx5e_ipsec_netevent_event() reads it without a lock.

Observed on a ConnectX-8 Kubernetes cluster: a pod learns its node IP
with the host veth MAC, that MAC is programmed and the peer drops the
tunnel traffic. Reproduced on ConnectX-7 (fw 28.48.1000):
- neighbour for the peer address added on a dummy netdev: ping loss
  100%, 0% with the fix;
- routed peer, wrong gateway MAC corrected after the SA was added:
  ping loss 100%, 0% with the fix.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Co-developed-by: Elliot Edmunds <eedmunds@nvidia.com>
Signed-off-by: Elliot Edmunds <eedmunds@nvidia.com>
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 48 +++++++++++++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  8 ++++
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 4084f8a88695..cc75fcb0aa15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -256,6 +256,17 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->lft.numb_rounds_soft = (u64)n;
 }
 
+static void mlx5e_ipsec_set_tnl_nh(struct mlx5e_ipsec_sa_entry *sa_entry,
+				   struct mlx5_accel_esp_xfrm_attrs *attrs,
+				   const struct neigh_table *tbl,
+				   const struct net_device *dev,
+				   const void *pkey)
+{
+	attrs->nh.tbl = tbl;
+	attrs->nh.ifindex = dev == sa_entry->x->xso.dev ? dev->ifindex : 0;
+	memcpy(attrs->nh.key, pkey, tbl->key_len);
+}
+
 static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
@@ -263,6 +274,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct net_device *netdev = sa_entry->dev;
 	struct xfrm_state *x = sa_entry->x;
 	struct dst_entry *rt_dst_entry;
+	const struct neigh_table *tbl;
 	struct flowi4 fl4 = {};
 	struct flowi6 fl6 = {};
 	struct neighbour *n;
@@ -360,6 +372,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT &&
 	    is_zero_ether_addr(addr))
 		neigh_event_send(n, NULL);
+	mlx5e_ipsec_set_tnl_nh(sa_entry, attrs, n->tbl, n->dev, n->primary_key);
 	dst_release(rt_dst_entry);
 	neigh_release(n);
 	return;
@@ -375,13 +388,20 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		else
 			n = ipv6_neigh_create(netdev, pkey);
 		attrs->drop = true;
-		if (IS_ERR(n))
+		if (IS_ERR(n)) {
+			tbl = addrs->family == AF_INET ?
+			      arp_table(dev_net(netdev)) :
+			      nd_table(dev_net(netdev));
+			mlx5e_ipsec_set_tnl_nh(sa_entry, attrs, tbl, netdev,
+					       pkey);
 			return;
+		}
 		neigh_event_send(n, NULL);
 	} else {
 		neigh_ha_snapshot(addr, n, netdev);
 		ether_addr_copy(dst, addr);
 	}
+	mlx5e_ipsec_set_tnl_nh(sa_entry, attrs, n->tbl, n->dev, n->primary_key);
 	neigh_release(n);
 }
 
@@ -973,10 +993,20 @@ static void mlx5e_xfrm_free_state(struct net_device *dev, struct xfrm_state *x)
 	kfree(sa_entry);
 }
 
+static bool
+mlx5e_ipsec_neigh_matches(const struct mlx5e_ipsec_sa_entry *sa_entry,
+			  const struct neighbour *n)
+{
+	const struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+
+	return attrs->nh.tbl == n->tbl &&
+	       (!attrs->nh.ifindex || attrs->nh.ifindex == n->dev->ifindex) &&
+	       !memcmp(attrs->nh.key, n->primary_key, n->tbl->key_len);
+}
+
 static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 				      unsigned long event, void *ptr)
 {
-	struct mlx5_accel_esp_xfrm_attrs *attrs;
 	struct mlx5e_ipsec_netevent_data *data;
 	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct mlx5e_ipsec *ipsec;
@@ -988,21 +1018,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 
 	ipsec = container_of(nb, struct mlx5e_ipsec, netevent_nb);
 	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
-		attrs = &sa_entry->attrs;
-
-		if (attrs->addrs.family != n->tbl->family)
+		if (!mlx5e_ipsec_neigh_matches(sa_entry, n))
 			continue;
 
-		if (attrs->addrs.family == AF_INET) {
-			if (!neigh_key_eq32(n, &attrs->addrs.saddr.a4) &&
-			    !neigh_key_eq32(n, &attrs->addrs.daddr.a4))
-				continue;
-		} else {
-			if (!neigh_key_eq128(n, &attrs->addrs.saddr.a4) &&
-			    !neigh_key_eq128(n, &attrs->addrs.daddr.a4))
-				continue;
-		}
-
 		data = sa_entry->work->data;
 
 		neigh_ha_snapshot(data->addr, n, sa_entry->dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 6c17bd997a0c..d60c72df0bf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -119,6 +119,14 @@ struct mlx5_accel_esp_xfrm_attrs {
 		u8 dmac[ETH_ALEN];
 		__be16 dport;
 	};
+	struct {
+		/* Neighbour tables are per netns, so matching the table
+		 * also keeps neighbours of other namespaces out.
+		 */
+		const struct neigh_table *tbl;
+		int ifindex;
+		u8 key[sizeof(struct in6_addr)];
+	} nh;
 };
 
 enum mlx5_ipsec_cap {
-- 
2.44.0

