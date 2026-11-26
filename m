Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730231;
	b=X8gIfmfuZPsX2C/wta4Q3xB3YnsgOF+y0TPp9ZKH+OrCPtn/iYS7q9I+nTZcfAaHPTcz
	 E7BRvb+nSGbZS1X0oCXZEizyqg9sOz+KgLnqNusHMcKBH10BtVkRnaOrJWva9UB6ssgdh
	 2yKl34a2wP6ZRBRXfBloQdEF3ZM463p8NWqeojsCsO9Uiel/9snFPZq/sf8fLv37fW2g5
	 z/H5aJ+SF1O1DPJd6P4n01rPyzSsdfLBuA6Q1VIlxgr5dMJMOKzkP2gTwoDUugbQldYdy
	 us7SmJ4dkQSRo6hbE4tzxpIzTcbK4BOJDLpPbeZWQjnpkX3xHpkWyesnqzmj7ZcVSzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730231;
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
	bh=0nLp4bTayUsztw7bnIu/3QCKgGSUwgg3k2oKbEDs39Q=;
	b=AcPEny1raMaN+etDIIe3ROX/IHqjwuswuZ3oPhVc+28DGvC8qxqdpVYQoNAqDUMEYUMf
	 RwoYQZxxQh2MwZPdx9YfzrQG8qKXaEUQHyb/QPnDIRy4PwW+3LErEUJwu+7IVq9LY41OV
	 84GJUShg6h2T4hkoT1HWJfFXtwiDnX5mltdeUQkOOJaND7utnqTeBMptm0LIGfIg79M6R
	 W1wVqVhLSjp8k2jYGavGqMb9nmNBSqk7T78/DvkIj1JmJJbqa/K0yzWEp9SWLMYGRH5KO
	 awgJlwd7a/K3yt/ssXHAyEdJ5pmzi8pR0cSyG9FYcx2FVNEoq402van/SKJpTP28AsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WrnDhu24;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.27
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BA606A334;
	Thu, 26 Nov 2026 21:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 159BA606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WrnDhu24
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nRYBW6/i7prUcEo/zSDDLQ0TCl5nI2A9DO3yToiQIzFSWTXAlN6d+gAm9uannCpU897o4UPp+02Wxj+ymG7oRYWKhR182TofVFaVzuzSVvRbKe9wBIe6nyNgNN/QtOhn9tttQ0gWbH4WJE+L4/n0RnE3+NfNHw9EZzCjkguwcV3YvJkFRNAG9+7kJq1soBK5bAZnlDR7CP6w8L3WASHBOVxjLX+nnx5PRU+pxUH40ntW0T8AONHXygNDRZ0xrfeeB5kot1YPbFtsBmIzVYh4NDPU/Pq2T5E3fVE3wm/cYQSPmQuE1kbeWlzHEM/nOkgAePBSKuM5O/f6pPovEo2iuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nLp4bTayUsztw7bnIu/3QCKgGSUwgg3k2oKbEDs39Q=;
 b=JGgIp3L8mX7ReMG1OaWSn3GJMjutEkm0/IZbiQdkCdFItgtt/+coTeN5bG5z4ezhOY7UlxY/Ela57fwuQdRcLjdpZhCGIuHT0i+oMJC1xqKtJgg6R8j5QA/8yXK1qCYvSj6dsSHKhYMRdIJKCwVRWHJ05i6+k64d59ysX1wBljr60pw0oZW4P0Ihiy6BhNNsN1Z6SqE36SSlBta6fcLZKEV4wxfrX11n7DCAOJCGqpsTCsLfeqc/PxnTdBehrnSDSUdndWY8Bd1u380baguU/DSI2cWixLLkfbcWRTJ1rw+XJ3hByHDa6IJKK/xyaOSFELUWc28SBTQv94m148fSLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nLp4bTayUsztw7bnIu/3QCKgGSUwgg3k2oKbEDs39Q=;
 b=WrnDhu24ZkFLPrkXuOONrQR2/MFE0Zh4Yj1MT18XHAl/F5Yvb+SMfMu37NqYm73xc/MQ2Q8jLzuTds9XZgsz8UK1kgXYovIWkFJ5e9sNHIjwxTeOwqirLnNaGWNE0ZH4ynOBhT5G8jYF1Efwf4yOw8SrpeQlBx65LUly/EPZEYZ16YIYVHKo+DpfwSUZxG5UCGl+BqsWS0N9R4jkoEPnFyFLTD4LBLoGjvURvuePMG1uZPQAyWNB8Cf6Ql8fDtrCWTpCSgvc+Qbunq3Bx3Ym2mRlSYNgJJTQpLOoNzCFwqARyCM/68BZSE5uxTEoGA0wIg4onhDxgHc810Ge2nVZIw==
Received: from SJ0PR03CA0243.namprd03.prod.outlook.com (2603:10b6:a03:3a0::8)
 by SJ0PR12MB6941.namprd12.prod.outlook.com (2603:10b6:a03:448::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:57:06 +0000
Received: from SJ1PEPF000037A6.namprd04.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::18) by SJ0PR03CA0243.outlook.office365.com
 (2603:10b6:a03:3a0::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 21:57:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000037A6.mail.protection.outlook.com (10.167.244.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:57:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:57:03 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:57:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:56:57 -0800
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
Subject: [PATCH net 03/10] net/mlx5e: Fix IPsec SA modify/stats update race
Date: Thu, 26 Nov 2026 23:56:07 +0200
Message-ID: <20261126215614.792598-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A6:EE_|SJ0PR12MB6941:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d0240de-10ff-487a-94a9-08df4c083604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|7416014|23010399003|6133799003|18002099003|261009223027099003|22082099003|3023799007|261022075727099003|10067099003|261102123227099003|11063799006|56012099006|261026135527099003|261026121527099003|261026140227099003|261022105027099003|261022113327099003|261022115727099003|261021123027099003|261021135927099003|261021130227099003|261028144727099003|261021133027099003|261026130827099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	+4oTRO9nhu8Onb+2gDyUJXXFjVb0RVYb0lO/Q76FVMcSOksQxjEu0Zd/OxVyUOGtWZQHgbqNfqmJvnqbUSPeabvmZe3QnuGkLdunH9xo4phibRuchFIBTGj8SihK8NrPux7wDa2EIHmubxwKpgUE/qiG6P64zO1RWf1N4j06Ja+hUGHN9Fxp/CQbMH1dUD4cyIW8xRX6NEC4hETaTm7qhu0Sn/pDe+xPrKEx+owUmUMNTfgRjOUFbwGypeLP8R55l2iN6tGKocSZUnH9SGDrDz7m+2M0wB1cX2pMkxi4NOTWlP7wKWrmyGgFW7lqJxNQeLJKoNTXp2BcDt7oXFBix0pAg3kC5GS5PzhBkr6zqBDQB9/iGvfgVbP6W+FaEKO787j29ZKWTjzaBBc135XuCaQ6/dYltNxePT3wWp5uIVh9m8YvAYny5vMMkoAgyWo6eWQpdJjHtcLQ8GD2i+o/sFyXwNh8DoCBzI34IHf2EWkeM9G9S/oTV5+hdJvKZH/4Pp6J4KPYThL2dI/ekvDDhTWM2eRQQ+3ARd39Gw8qpvnGBZrdhwPbgtHXH8VTy+LZ4l304SCH0ybU8WIg4dplSCQMt4r5+Wf3HDp26UbuKfjg7c2TBH1gfqNYDq6zkKPtSQSMSrqoUDa1ZlmBHNHEdu5uv0nv/Hjk4iGyaWUwQFzHqfXLUv6ZSXjmWT89nDzfXZ62m6J5My082cHNWINxhg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(7416014)(23010399003)(6133799003)(18002099003)(261009223027099003)(22082099003)(3023799007)(261022075727099003)(10067099003)(261102123227099003)(11063799006)(56012099006)(261026135527099003)(261026121527099003)(261026140227099003)(261022105027099003)(261022113327099003)(261022115727099003)(261021123027099003)(261021135927099003)(261021130227099003)(261028144727099003)(261021133027099003)(261026130827099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gyR3xEBiICDKCBdZK5wbBULZ1Xp7X/MCVKK3NtB0LWgQ+Q2QIad1nSsLpBO2dxsz2mvmxaj3IuyESz4wYrP+BlHP++YuVRiPegrXvcJ/ezYttmiOF3RxCRBAadA3KqvxaEs5Id+dlKtCJfaI2eAeVMaEltp4rTgy5eJBW7e8/Go2B3OmAc2HcVZWDEIo7rEnawV4nD/0KZxOThv5S13NNxSFzXiXeBoId1qYX3iQo5FFG/wBBr4hJ2X3ZurEEkN1NhMQQQF5xaXTPTawtyMZNRauyKrG2vxKLY5Kj5K/qs5nz5hfastVi3MK5PY+y8VxC0HewwxM3e9EhFM8GJHSmGtGe5YImsYVPGWisRDAcA/5guK8OiN99AHATu9n2GhgRhId5QWsqcfZDWxJTm/Z3Kq0MRXmYt5g1XenFrkMMkyDRlfNGdKvJuW3PzkVWnWN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:57:05.9412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0240de-10ff-487a-94a9-08df4c083604
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6941

From: Jianbo Liu <jianbol@nvidia.com>

mlx5e_accel_ipsec_fs_modify() rule update races with
mlx5e_xfrm_update_stats(): The former removes and recreates steering
counters while the latter reads them.

Fix that by:
- moving the eswitch RX mapped id into struct mlx5e_ipsec_rule so
  everything related to rule creation is in the same struct.
- swap the pointer to it under x->lock to avoid the race.

Discovered by Sashiko. Not reproduced. Tested on ConnectX-7 (fw
28.48.1000) under KASAN and lockdep: 10k neighbour updates, each one
rebuilding the rules, with concurrent SA dumps and traffic. No splat,
no packet loss.

Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h  | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c   | 7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c    | 8 ++++----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index f4b2d7b950c0..9bbcd9e4c319 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -215,6 +215,7 @@ struct mlx5e_ipsec_rule {
 	struct mlx5e_ipsec_drop replay;
 	struct mlx5e_ipsec_drop auth;
 	struct mlx5e_ipsec_drop trailer;
+	u32 rx_mapped_id;
 };
 
 struct mlx5e_ipsec_miss {
@@ -286,7 +287,6 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_work *work;
 	struct mlx5e_ipsec_dwork *dwork;
 	struct mlx5e_ipsec_limits limits;
-	u32 rx_mapped_id;
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 0facc5477155..d0f738fdeff3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2845,8 +2845,11 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (err)
 		return;
 
-	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
-	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
+	spin_lock_bh(&sa_entry->x->lock);
+	swap(sa_entry->ipsec_rule, sa_entry_shadow.ipsec_rule);
+	spin_unlock_bh(&sa_entry->x->lock);
+
+	mlx5e_accel_ipsec_fs_del_rule(&sa_entry_shadow);
 }
 
 int mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index f8c97954b6ea..2615bbc89a16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -85,7 +85,7 @@ int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 		goto err_header_alloc;
 	}
 
-	sa_entry->rx_mapped_id = mapped_id;
+	sa_entry->ipsec_rule.rx_mapped_id = mapped_id;
 	flow_act->modify_hdr = modify_hdr;
 	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
@@ -104,7 +104,7 @@ void mlx5_esw_ipsec_rx_rule_add_match_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 		 ESW_IPSEC_RX_MAPPED_ID_MATCH_MASK);
 	MLX5_SET(fte_match_param, spec->match_value,
 		 misc_parameters_2.metadata_reg_c_1,
-		 sa_entry->rx_mapped_id << ESW_ZONE_ID_BITS);
+		 sa_entry->ipsec_rule.rx_mapped_id << ESW_ZONE_ID_BITS);
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 }
@@ -113,9 +113,9 @@ void mlx5_esw_ipsec_rx_id_mapping_remove(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 
-	if (sa_entry->rx_mapped_id)
+	if (sa_entry->ipsec_rule.rx_mapped_id)
 		xa_erase_bh(&ipsec->ipsec_obj_id_map,
-			    sa_entry->rx_mapped_id);
+			    sa_entry->ipsec_rule.rx_mapped_id);
 }
 
 int mlx5_esw_ipsec_rx_ipsec_obj_id_search(struct mlx5e_priv *priv, u32 id,
-- 
2.44.0

