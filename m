Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792585320;
	b=aYzoRziSTmJWzuI0UPrVoD3uczWDnMKjrIMDCkOlfOXy2EpoV4HXywRmBEShWN0MVeP3
	 eMEFjEUsIteFiOlWeEFoSj98Htrq6+LxVklgnjnWb8Lcl54kMyMWYoPJKjDbhH8qQZ+Xd
	 40eQMnZqxsj5jBQxJhxKdlZyptv2PmRK795JBxRNJDERwmOnDJq7ll0FeLjDWzBXNtH5Y
	 3u9Lo/e0QxAPrqPDvRxrOSw+LR8Ufs98wXCi5856zmH2lq9SmwD0j6VyC/IBUm5hxRBJM
	 0pKFgq5SmrSLt9KJhuPldJiwp6hujZQr3ec6YP5EmO854d/yzXH8jquTPV57OlpuBgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792585320;
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
	bh=uTP7+05eH8A6oooFCv968svIZMyBQojFcSh5DOxeQRc=;
	b=uXKc7aLmcDODanpHoiHafCmrXp+Gk6jPQWUT3ftZc37dlZBtW9yYz2jlazLelFOf0mAY
	 6GQfPbxF8fTde22L4eQ6vYgIIiojZaf/+W1Ni6nnDeDy12inpqkjE5qBYTvTSrBuyadwb
	 qIkDRfoIsPts24HmESZ5eSJbygHZ1+p3aUhV81LBiA5wWlmQL/eLI4rpsXV9zlpQ+JpCg
	 UE3vJOw2/GeXJZBFiB8dSF+I1lNOPzSltC4F/kkfrtHu++9nAW80LfHy0Nf0M+fF98r/V
	 8sFUfITMdwXVUuAtKuL2k6ljMXlVVBalnFeQ01BNiNhb+lBJu3j4TBjiOwN41b75QUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JmA+3GpK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.33
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F8E606A31B;
	Wed, 21 Oct 2026 12:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66F8E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JmA+3GpK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zDW9WZoJhdX4CW6mwKR7EUD3G58Tco+EaCkQ0fovp5QNLyUJfFiMEs6PZrOkdt9FMI4Cj6yyKKPejGlsMEQ4fYOxE+oNk1diuvJh1b8E+Z9UeHSO+upJ5cM3+WXW2UNKYSdXLhE/VpyOM+W5/7S5Wlgau1++6x0kCA4DndvYYzkBjFR/3MxlwxTaAgAuK4ijKOSGBmNJM2PdHWjdw6jSDklqLsqz3nhtrRj6bDQHDwNmuMsTyWnQNuOKokNs33pLfFu/Aa09dGw5s+licntGQXolMRc8rYVCvDrWuBEI++WrgajSOiQJMYKmEDTWQcZfkgcyWiGf/XuaQAY2sIX1Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTP7+05eH8A6oooFCv968svIZMyBQojFcSh5DOxeQRc=;
 b=BYpf+Jlr5edyq/bjxMeG56et4fKlmH6o56WQun+w8yV8xuQF6CM2xTYqE6EVgXUOhtWtVDJg8E2qHZumqkqeVFPNqUz5GjHkKHiearfGXjNVqP/n4Ltc3mRk5dfSbniEzVBeguvPfrNBTgMHOUHeHWfNFXC76svuGiaj3AKLQVD43WD+PPpO1AhWRu4radG9DU+AlFWod2Lh4yEwAXBNt5mwHqgvcgG7B3etfxEwMPyaCrX9nksxMBjywk6Ml7w4uZFAvc0r/s113H053IxkT2R7eqaiybg4XXjrsjHFgFBBTIkpnTLzCh6Do/jcZv66QanF/FlwDcrnLFs3Qx2sIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTP7+05eH8A6oooFCv968svIZMyBQojFcSh5DOxeQRc=;
 b=JmA+3GpKamuBjEkFRtE2Nv6TBDND/prHjr3EALrdULtrgTd+sV5urqItvWqZQks+RXd6t3W9U9OLHr1HYTWIz+n21QNTHQY/pRN3xBWIlQffjg0tJL7pne9x0ddtL0BG0aCntrdPVUFjTig2KnppFBDp4jR56QF4/QuldvhgMa/5EqBjE2rXd0qYqyw+JQluXZhN4jNrN7KwEaIJXQTUTl5a84h8PIF2bD9j5ZNrHodM+ol25wt3kPS+1+3uKorR8vgdsWiy7DcYIRsI7YR+ZVHUpxeohicN7Qi/cKjTYb+yKbu7VPRhkoRFPB2Ib5mO1enM+sOhCtNsc5uCj7QBCA==
Received: from CH0PR13CA0045.namprd13.prod.outlook.com (2603:10b6:610:b2::20)
 by DSWPR12MB999127.namprd12.prod.outlook.com (2603:10b6:8:36c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 12:21:53 +0000
Received: from BL2PEPF000352D1.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::1b) by CH0PR13CA0045.outlook.office365.com
 (2603:10b6:610:b2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 21
 Oct 2026 12:21:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL2PEPF000352D1.mail.protection.outlook.com (10.167.249.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 12:21:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 05:21:35 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 05:21:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Wed, 21 Oct 2026 05:21:30 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alex Lazar <alazar@nvidia.com>, Bernardo Soares <bsoares.it@gmail.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maor Dickman
	<maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net/mlx5: Bridge, fix bogus MDB offload errors
Date: Wed, 21 Oct 2026 15:21:15 +0300
Message-ID: <20261021122115.3737284-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D1:EE_|DSWPR12MB999127:EE_
X-MS-Office365-Filtering-Correlation-Id: cc3db2d6-2375-4bd8-26f7-08df2f6de3dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|23010399003|1800799024|6133799003|18002099003|10067099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	XFIdxMkZnh2OvccgjUE6XbnNoQEvlXXsNhOVEad1REDifUYm8BFLkxuXRIweiHU5Lzxmn1Xmr9eOBVNmDuOyuTqUpCom1SEYROL703uvfKf6PEN7QIvcYuDSD7Md4aW1LNgPXg8/YaJdkIAFh9g/+3mABNi2fJbvmJDmv1ZXUEEKyEFYZtW2Z1nDBo03C6+0iqqPzQG5uC8opPF9rlHialoh4fm010Lx/KVEdhv5TAY7VIulEMrNvx3gnJ2uL+2+iiLk6c5+NTM9yXORCcENUSTsKtvYrh1ivamPKjVTcrDVGSYHFSpKfn/zL/a1NdiiQkeCphEP0dL330l5TQ9i6UCgx2AdLbEndkHNbabmuFVMe795vt2Dr4fi6BP8hmwbaHbdFKYDe4ZCl+OP2gv8FgbsI4U2/zTau3RIq+YzKxghdhSj+ijvZ9E6CM8drNugaXrkq1GcVdee0Y354UNfXwN2n91W1pe72F9umA5YtOoPVae4lSSdyecCC30nhxQY20BWxpqknAOmO/4f1qTQboGy34H30u6+IahGGo7NtOAiehwVr/DDyFC7dqwLij+2IYIGIXkp54p5kEgkpogsn9GvlQb5ky0rubfWpBjKNRo1Igok4xF/liY3wqTITH00ni7lfpgU5YLOZChgLldwKiDFFLskVrXzuuzsXwTKlwQCFQI3ZzEJMtByH96DH/DcygEQr6uvE9lRed4fGjC9TA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(23010399003)(1800799024)(6133799003)(18002099003)(10067099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6GcGQZu8HxPBxpB5BxhuKRKVs68NRz/rjw9bd1iDrNwU8RsfG2+1jlCiJdm6zu0NunESh99N6PyZPz7Ia0OrhFL42LCTGT0N2biGtkYzMFSciD12SlaJC0QVZkzeSZZrpKQ4YvNy8Hx1CgTRCs6drR787iAk5QewQVUOZq7iVT/ofPQnCHx8rFf6NxxUzVa9gh2WmkA9nctvrabz6IlAMYyktRO8p6Y8aI08Fna9XPpIg8a+0Xc2NHW4UljLcaBt73iTvT5MTpwf6FkG6m7E3D5FdMVM4aezsfc6zuv4OHWfDO62hFeASY1+5gNhnGF3rv6N4X4K/vcxS4mrfHrb9fM83fwRxQOk3Fcd+Far9nEhvDfLmHQshn7Rfn7FX2Xs7bM/4UMXIpyYSPGj3BRXY/6Z2AIeYuYJFUA1cPtxqo2j3DDepUmHuoyrZ8GepGSC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 12:21:52.8839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3db2d6-2375-4bd8-26f7-08df2f6de3dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR12MB999127

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

Skip the MDB offload and report on 'info' logging level instead.

[1] Commit 17b334a876fe ("mlxsw: spectrum_switchdev: Don't warn about valid situations")

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b4cf3c5ac0dd..7c32dc9db098 100644
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
+		return 0;
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
+			return 0;
 		}
 	}
 

base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0

