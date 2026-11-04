Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817478;
	b=MwTlqIKIbRl6evOXNFQwFF9WHHGwtBFTA83Jwt2aOg2n8OOHU1MnedpWecDCTRdV0sld
	 plrk9Y8roJLucbO61FsSIQrhO8Qk4EDNMRGSb/Q+8NkO/8mWTI0uHk6MHBvt/rl8UZk4S
	 JFcTL+5CR2b0oNWiliLG2ucxxCpVvwTjH9700qG9q7RIX9fFHe3C4Wowd8vGrGoaZC31X
	 l+rnAEU/Vw8bZo5qooNkGP5ipMB9IcTG90oBVfVbQIrC1BfYrJ3BC0dEY4kxtnmy2qTqs
	 KJaw38kMZxpOoyma2OU5uZ6u8P/Qk9tuuVnh772c6gRu3e5R9OpjofG5bAIgSpIM1tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817478;
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
	bh=spKCF8v7idcwDq2Wbnn7B+2mcXNQvjRbQ9yB9e4oEGE=;
	b=5VckKXntOYBtM92VVUp5MRohqREBgDuPyCmN5k0KEsE9d40PgnztrHw2IWY1A6/wpMs5
	 ACurQHQ+keEeES1yCBISCTQvnIgPWqhm2kYTrHkbWX9cyr7QoJ1Z2UtZFuaYqKsyQdBKR
	 Q50676zgGt1eIf9SFgn/YyIEUkU86tOUTFYZOrqGXfqBe/aOCUEfUoHK9qaRe22bRgxpD
	 jUXCcLP0ouNyP4avR8+1/aSFJp9XUIjbsy+SyXgUdoBhJ/3QetAhAdKowWp+6J8YI6bv1
	 82qgX4UUr+RxCmo9e13LPADj7dFNxdIUqDXeENX5jQZeDpU1TpLbjfmc/C6i04SjEEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qQdliL8F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.19
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F0606A339;
	Wed,  4 Nov 2026 18:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 593F0606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qQdliL8F
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EnXuel8dgdg5tvZCUjAMGDljmpFzf7mWnEZR9LHjNJ+heqwdZ0hCKINEgT9Cvu9/LBhOUdk3BqttDn0CE7ZjGrv6xg90vs74yxhYKwoLyhJBDLTwZMskGccJ6FVk+Mlom2erw8ZT2/UJpOHg6+r7/PhBqg8/wnoxJ51m0bJ4ejQao/p31BbJvimcm0iJv8Zl/+u94Gd0kSzJXzYYCeOuGyHGqofDsns6kP+0i9E8pyWClsEV+o4T3L5eb3wEpmmSF/l+KJ8OZ10OSe+Xs1BSj2Klv31OfxrXAHzNeZXkkffhVWPqWM8N5fsS7Wk1iFSdYYsaH5DI5lEnriubNrAbvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spKCF8v7idcwDq2Wbnn7B+2mcXNQvjRbQ9yB9e4oEGE=;
 b=Syu5UGHXAlc9izgHjDknEbv8Lg8emhDIn7lelrxYGv5vaFJ4yvq9u72uUTCTFk4yTnn5+e0z087gmQcpdNJyqj43PHZg93cSiA4vJPl6pjW0uHO95hkCB8RR/hWFdQQlrni1N62OpS64+fLUXCI/UbM2iwc/f1KXGOGfdD/yMMQC0xLARlp7IY4HTp6hQreIrdxMYXJoLnrJABjDSJVpkUfvBzcA6v5d6X73LQ472Whm14Ag2Vm1p5G+GUbqoKYaY2bIFmqDkdIx4T9h43aAMDGLVMG3ahy4YxqIUrpHiHkV0ETr5atDe0EcO6doO8oxq0f6nbY8KHkr9/HVexeyYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spKCF8v7idcwDq2Wbnn7B+2mcXNQvjRbQ9yB9e4oEGE=;
 b=qQdliL8FUvXga/hKIloT8CCEOBb0rjPC22jMp4PksawWxQnKTILMCafZdJBZRP+EdfLaxTzeVUkq5pNcNS4ONALAg977+iYEzmV2wxSFhRPcvQw7/gMn+5mjRbh3BAmPa48ikkdrfu5iTW+cTDMKfsKMMCJ1Z1WcnA/JR/hsYbrb/thDkNkqI6JNGdjgHNlRzGX+kOeXZK8ZJMijhZfbZ7qiSTNXvJC0kkQH8bVIZG9FyC4rlqr8DmHRYzfULWINvOE2Zme2KgVdJx9zTf6PARkD79Wf1O2FxdRApQByhCLOqfDRPyg+itK2ZuRLHsW7OMnHtro5nBcZNnY6a67LUQ==
Received: from SJ0PR03CA0267.namprd03.prod.outlook.com (2603:10b6:a03:3a0::32)
 by SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 18:37:51 +0000
Received: from PH5PEPF0000002C.namprd04.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::5) by SJ0PR03CA0267.outlook.office365.com
 (2603:10b6:a03:3a0::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Wed, 4
 Nov 2026 18:37:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH5PEPF0000002C.mail.protection.outlook.com (10.167.243.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 18:37:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:37:29 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 10:37:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Wed, 4 Nov
 2026 10:37:24 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Bernardo Soares <bsoares.it@gmail.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maor Dickman
	<maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net V2] net/mlx5: Bridge, fix bogus MDB offload errors
Date: Wed, 4 Nov 2026 20:37:15 +0200
Message-ID: <20261104183715.771390-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH5PEPF0000002C:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: f60c8687-3121-4ca7-3a55-08df3aa2bb58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|23010399003|36860700016|1800799024|261026140227099003|261026121527099003|261028144727099003|261009223027099003|261022105027099003|261102123227099003|261021121427099003|261021123027099003|11063799006|56012099006|6133799003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rjPtolmlmS1FtAJEF9CnOFtn17sNxiGYeF/Es3yli5JB5QyScOvaafYxJwYq4a6OIwdJ/MY8t6VNYnvoODsTs9D3wxoABa472UHV4v6tyyaJjLi/I4qf8RPW3klW83w6h2NpSVz2lAzO6Z7yatKD9z7L9jxRak8bOZjdJpRdJTa1eNq71SNmoyst+xcgTrdU2QCAGYDLItV3HCfAJQ9dPxq2mwYYT2TucEeOiI9mZjH4+95B2IrNI+hewno4rsGu0f1mFyqf4ej5rcHH2Kzt3gd5UJDCVcc+Mg1rpjzq0DUAPnPkXnRR+/Hms/wgWU9UD6Bxbm8q7n71bqfMyBR8BUgdMOeiA8Sd5zCcMh1rojltc4dCpHcY//w0Z9KjFHsYBZA9109/1mMfKrwz/2PWP1Rt/uGWrqGgFfNMgg5PvCRzS1aaXy+B+go44u2bV30QWDUx0dyNh2G//ET1G6PN+apo6MskanE7RX1FsjTxVt3FF1E12s2w4/uMiR1/MJyrVjufSXNg9zTdJX3raze5VphsWEwie5rWGoGbuyclDxBx1i8OcxAZR6FIdQIENN3qJ7JewJwaCO9ETuaK28CEL4/t+YnCSsYbAPEnH3D2fyBkJtUCdzJMasufnoYvhuIZ5RShLiceLWxBWj31EJF3v2ctZ/DB1jqu2RPTibDxNJ+8Gna//mAoFJwB+bOGgd/aksMD19siLvwabgtSDCRMIA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(23010399003)(36860700016)(1800799024)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003)(261022105027099003)(261102123227099003)(261021121427099003)(261021123027099003)(11063799006)(56012099006)(6133799003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eqdHTkicBcDC2zTCYE6Ys7f6J6joSeac2HVDRRHzvittvDNNdI+NQoI7tler28INJz4CB++p4Vx8HOXC3sE0dkA2J6OKMkaaCLY4qzGQYep8cA/zXcAEP2aPkghNQufYoT9IRuj0qB/BW8ItjWpi539pLutGA4b7hb9GwcXvZEsrTSxZX+Y3dWbK8MYfXXP9s7z1wz9CyHuuBfK6o8QKG2+Qhw292DVPJCRICbxyXnufL5Yf7HbPQh8uy9F1zuL0twrzLYJC2zN+FByCpXJckMR79TekKK8KV9QC0fietJxYFuJQYovOi0wGpu8Of+SquX9oFbReKuaa3xuMXZEN0OJcEbwZ0n98/tZTp4sRp1koTJjtUBJhZN5n+rUsCNDeiQbSteNlPCe82ShR+JGDOfyumudj/KP43OFq51GvcNtRKKrM4JUGXynbJAUDZuP+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 18:37:51.0688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f60c8687-3121-4ca7-3a55-08df3aa2bb58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH5PEPF0000002C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369

From: Gal Pressman <gal@nvidia.com>

MDB add operations are queued on the switchdev deferred queue
(SWITCHDEV_F_DEFER), while vlan object deletions are handled
synchronously.
A 'bridge vlan del' can overtake an MDB add that is still queued, and
the vlan is already gone by the time the driver is called.

The two operations are independent in practice: in my test, the MDB add
is triggered by assigning the VF an IPv6 address (hence joining a
solicited-node multicast group), while another process deletes the vlan
from its representor.

Racing 'bridge mdb add' against concurrent 'bridge vlan del' could
result in:

[ 5390.967651] mlx5_core 0000:08:00.0: E-Switch: Failed to lookup bridge port vlan metadata (vport=1)
[ 5390.969120] mlx5_core 0000:08:00.1: E-Switch: Failed to lookup bridge port vlan metadata to create MDB (MAC=33:33:ff:12:00:05,vid=2204,vport=1)
[ 5390.971676] mlx5_core 0000:08:00.1 eth4: Failed to add Port Multicast Database entry (object id=2) with error: -EINVAL (-22).
               Failure in updating the port's Multicast Database could lead to
               multicast forwarding issues.

The error cannot reach anyone that could do anything with it, switchdev
returned success to the bridge as soon as the MDB object was queued, and
the errno only flags the entry as offload failed.
The end result is correct either way, if the MDB has been offloaded
before the vlan was deleted, mlx5_esw_bridge_port_mdb_vlan_flush() would
have removed it.

The FDB path already treats this as a harmless race,
mlx5_esw_bridge_port_vlan_lookup() reports it on 'info' logging level
and skips the offload. mlxsw did the same in [1].

Skip the MDB offload, report on 'info' logging level and return
-EOPNOTSUPP: switchdev_port_obj_add_deferred() does not log it, and
br_switchdev_mdb_complete() skips the port group flag update.

[1] Commit 17b334a876fe ("mlxsw: spectrum_switchdev: Don't warn about valid situations")

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

V2:
- Skip the MDB offload and return -EOPNOTSUPP instead of 0 when the
  bridge port or VLAN lookup fails, so the failure is not logged by
  switchdev_port_obj_add_deferred() and the port group flag update is
  skipped by br_switchdev_mdb_complete().
- Added Jianbo Liu's Signed-off-by.

V1:
https://lore.kernel.org/all/20261021122115.3737284-1-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b4cf3c5ac0dd..9fac6f985a86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1867,26 +1867,27 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
 	if (!port) {
-		esw_warn(br_offloads->esw->dev,
+		/* MDB is added asynchronously from the switchdev deferred
+		 * queue while port might have been deleted concurrently.
+		 */
+		esw_info(br_offloads->esw->dev,
 			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
 			 addr, vport_num);
-		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
-				       addr, vport_num);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	bridge = port->bridge;
 	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
 		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
 		if (!vlan) {
-			esw_warn(br_offloads->esw->dev,
+			/* MDB is added asynchronously from the switchdev
+			 * deferred queue while vlan might have been deleted
+			 * concurrently.
+			 */
+			esw_info(br_offloads->esw->dev,
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
-			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
-					       addr, vid, vport_num);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 

base-commit: 647b81ddefc6364290e67bf33c89d54971f8995e
-- 
2.44.0

