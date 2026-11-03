Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729629;
	b=IybSlA+SuBoHK9DdcMbH5J9blInMoR/3h1tjdoIlpJQqAM+jItdNYSeAyWp4J7T+voZS
	 oMzffZja+WO+dDmllOH9XR3vcpsDYeOO4ergx5/fj7d1c1H5tEb0V6YbJrtaut0bZOCux
	 gR5dfx2qBIVuoyxZAqJqqFHbfDuDSHrnnHZa/rJvrPrFhS7PHVRoUibBLQin3l/0jsH8p
	 NBQU+K7hA0WZOkq3WhW5npyLjqTo3qLYBSnszUSxOca1tl9ZqhEwaJEmsfsfiLdmiyLeq
	 t/iWn0ylzsWi1zqVUcaNyrzJUKxvvLMHluPQnaWO0zBeCk/eV0Zsksxob7kjpIYTotA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729629;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=oeLYvLrN1xQIXWm8R0xah0Op5WNKgwndHeI8PaDD5a0=;
	b=4jlPoa0G/9TcjbIE0SGOaIvvMk92KM62JRcKz07CcxUVdFL+LMT6Z8aSuAaC9KdYzEgS
	 7b5Z2wrDsKtHawKZAmuGfwo4dTSkPy0SbXZ9ev5vs1mtSZxDCSNQr39tjqo8ThflDz4YD
	 iEj//3qSSiI7hyTD0/cjqDiOzHWK063KD+y7/vVE2iuuz4WmYfeY/a6hsrbPo3odcuLhO
	 pJBHnw7fljPQ0dUftN17i8Wa2sgJuL0xPw4uelHuiqbD1FomeKgKicfk3cPI3Y776TjyG
	 2dI9ZfB1HA867mjRMYNHnmPRlGrgewKHbxg2U1DOBCAsAAu6LVzdvGlXJfOXwuHwbbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="oEaq/oAb";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E4606D816;
	Tue,  3 Nov 2026 18:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 981E4606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oEaq/oAb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXE2DDUuwixne0E0vDIdANP0B8+u/X1ZlKLXUMvUQDqQFe5Fe0skCcMnzwaAAY+A9rAso0K0uGFG4n++qqZWkoWxLfobX/j8su00QoISz13u9XPAvMOYpHhI7r78gWdYJt1SEGZZC9A/0nbfwADPYU+ii8x34b/Zb3Jfzc9AvtAk7AeX+FvNP+EUl9hm3/RcNOxuZ6aAVy6I+ioryFbkmr2/8W/85NrnDivbyYg/zeNiSSnWk1aoKzvEfg35c8HIIUTMWYruhS0wqsCe4tvrmaw6ZSSzRYhZVGi9zf9Z/fmGi8rhhml5tNd9bU0/HIp8m4QgOL+SrWUMXZuMZiRuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeLYvLrN1xQIXWm8R0xah0Op5WNKgwndHeI8PaDD5a0=;
 b=XET9KViYDOtm/B6cif6Hcvtp2F+ayI9Y3sTwvprThZxp99rAfX418M7gRdhVE/J94PAcJSl74NUmu7na7DJStkGV8ML4QJJLwVsAPdRhhnt48g3bRU0wpVv7ai4EL1cfrwXjiIS0982J3uwPvO8BlLzxOW2d6q5aWpGId25mnjxPlysUPrtmR/lhVqXBt5GQ5DRNXYigLbzO8TT28lmkPDaUEAZVBK8rsF5qwGoGTb9POa6XzZzNsQl4BzhEz9rZfzjUcqcVN8EkEpk5p0wmJAUG4y1ou5zTMp0nZvRYtLszHycyNBEJOuoyCDhkxUXEK+nIIiFbgp4TtvMg4rFcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeLYvLrN1xQIXWm8R0xah0Op5WNKgwndHeI8PaDD5a0=;
 b=oEaq/oAbXf1hfQPBq6ef8NBn1ijs0pQCap6WZj67hkZHSnAMJRtRQ3fj14n19/7PTcCg4GtYVYvSL58VpIWYxB9p9adaHtSG9eLKWco8cf6YksfOcY27X5PBpux3LqPkc62ljy0s+zDK9DNMrbgJjAvtkuIOTAAY+6hj45lKSFruTc23+R7kE/3o1DmHOXiacuDNMBhMgekOLBr+gFZ6LjMEZNi46wjNZQr84LxiN6P6KA8rlINNQ2IvgoMvlEIP9FbMiK2x6svPl8cPGceyzM9FKyQQri75wO8TfAxZqw0VnplCzolnIVqnGWqiZ6ugsICRuDnwxswROH7lLqbakw==
Received: from CH0PR07CA0022.namprd07.prod.outlook.com (2603:10b6:610:32::27)
 by LV8PR12MB9334.namprd12.prod.outlook.com (2603:10b6:408:20b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 18:13:45 +0000
Received: from DM3PEPF000265BA.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::8d) by CH0PR07CA0022.outlook.office365.com
 (2603:10b6:610:32::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM3PEPF000265BA.mail.protection.outlook.com (10.167.23.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:21 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:13:17 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH rdma-next 5/5] RDMA/mlx5: Expose NIC_RX_CLASS flow table type to userspace
Date: Tue, 3 Nov 2026 20:12:53 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-5-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265BA:EE_|LV8PR12MB9334:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f7f8b9-50b7-4be3-476e-08df39d63265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|82310400026|376014|1800799024|23010399003|6133799003|10067099003|22082099003|261102123227099003|18002099003|921020|261021135927099003|56012099006|5023799004|11063799006|261026121527099003|261021121427099003|261022075727099003|261026140227099003|261022105027099003|261022113327099003|261009223027099003|261028144727099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	UQucaIM6/vaytm0+C86nnLIdNYqFbNYSCifLkDchtkJE596aAFpTC+30x/nlDMc989ww5T6Vs/IW663YJuS8ddzs59w2Lfi5rqDwYSR7QBVlTaWtyunJYFesrlel5ohMqMzREB4HoRqOJHCF1yKpBjBzjpdMLSRxgHsNj5FlvcxV+TPB2wdhhiYHx089MJ61Uqqii4LYxa1NrRDwtATWZsgIWu9da40WVxPKCqvHaq7AWMPtD3HyhjUcWawjfqJdnfJiSxSI0ftyjagahRTiodyEf/V/szktKlm0BLk5m7nJNmRthkRxiHDpP1ChGV8BIhkXQkjdHabQPx4kp5u8OmoNzY3flmfJcMVfOGUJ+QoDx6dYdQbX9Ge5kryOAP30agGB8l+e8E1rO0KuN6ExwEdO6gwAf/+UvC9rLOi3ew8GVo2Sc7uCzYOvrFdiaIIJNzipUU3GsFynxN4RVFBbqIJOb1SI3fj1CfM548zMCPb6IYCf08/r9MSbayU6wvKbgCaHmJma+YkdCRRZjmtmcbEmVJ5Syz9FcVbVHJw2K0L/Xcz08fGjK3IPePqbVHdS7KWSRCpm47g/ig3rMzgUMNgob0hCzdiY7UsQCWAUhuDBMJiF9byKXzFAKzGsRcNYDgNez/4R+sTaKR+xyxykVUQLWXyr2khRJNJZbUhw+HMztE3IyBc4ojE7sfsZPh5PYQN0s6MxJ2NJ9uZbE4om3NRxIpCzD0ti110p/qPH/LLqJ2K3GApGFNCymxdrqXxD
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(82310400026)(376014)(1800799024)(23010399003)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(921020)(261021135927099003)(56012099006)(5023799004)(11063799006)(261026121527099003)(261021121427099003)(261022075727099003)(261026140227099003)(261022105027099003)(261022113327099003)(261009223027099003)(261028144727099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DR9FitSZBkhDfNXlvthrVBwe/CocaCjcowMgVge1A/tynL9lPBcWFzIUvcSihcUkmm1LDFPOBtaZDZ2ZlieSQ4/UO+Yi7qOvhD/0Fb5V875PT2WCPG8BztpijqeFdJqyh4SBuedsyKN1Jl8Okkb0EgYodjecmrKcK6hWHeuawXo/Ko5Fhx90s8Vx91RqSZ58WT9bdMNtwGiLAzTQ6bOfHnsda+YwBqGX0Kxsw6jjoRS4w8wfjWFqyVNndH6uLMzQYyCBKXZKitDXPtS0+enOoPBwKhysbyH3Yr7I/OqKmq+L28cVWxkgNdVkCPD9ntSQ5lhrFRNxTGFYsnnao2nWI0gL7Onw3mecunj8oBRKtCQl4/abQ0BpMaaEDlUziKYUB29tsvaMAv2x1dOT9m0E/8vF103xhcQzksEKLwnLEDyIHO+KQXzNYA6n4I6T4rM+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:43.9774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f7f8b9-50b7-4be3-476e-08df39d63265
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9334

From: Michael Gur <michaelgur@nvidia.com>

Let userspace create matchers and rules against the new NIC_RX_CLASS
domain, the same way it already can for RDMA_TRANSPORT_RX/TX: the same
per-vport ib_port targeting and eswitch-manager ownership model.

Classification only tags a packet: a rule matches it, optionally
rewrites it with a MODIFY_HEADER action to mark it as RDMA, and lets it
continue down the RX pipe rather than steering it to a destination of
its own. ALLOW says exactly that. It is the rule's terminal action,
telling the device to proceed to the next steering domain, so a
NIC_RX_CLASS rule carries no destination. A flow counter may be
attached alongside it.

Expose ALLOW to userspace as a new flag, matching FW's ALLOW FTE action.
It is limited to NIC_RX_CLASS: no other namespace's rule creation
accepts it, since its driver-side handling and uapi flag are only
meaningful in terms of this domain's semantics today.

Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c           | 59 ++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/fs.h           |  2 ++
 drivers/infiniband/hw/mlx5/ib_rep.c       | 25 +++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  1 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |  1 +
 6 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index bc2c15c7172baf3ee726e6b1a9bf794e4c982a35..07486885e046a9a527371160206d3cb2d911b6c4 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1967,8 +1967,8 @@ _get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX:
 	case MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX:
-		if (ib_port == 0 ||
-		    user_priority >= MLX5_RDMA_TRANSPORT_BYPASS_PRIO)
+	case MLX5_FLOW_NAMESPACE_NIC_RX_CLASS:
+		if (ib_port == 0 || user_priority >= MLX5_RDMA_TRANSPORT_BYPASS_PRIO)
 			return ERR_PTR(-EINVAL);
 		ret = mlx5_ib_fill_transport_ns_info(dev, ns_type, &flags,
 						     &vport_idx, &vport,
@@ -1981,10 +1981,14 @@ _get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
 			max_table_size =
 				BIT(MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_RX(
 					ft_mdev, log_max_ft_size));
-		else
+		else if (ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX)
 			max_table_size =
 				BIT(MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(
 					ft_mdev, log_max_ft_size));
+		else
+			max_table_size =
+				BIT(MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(
+					ft_mdev, log_max_ft_size));
 		priority = user_priority;
 		break;
 	default:
@@ -1994,7 +1998,8 @@ _get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
 	max_table_size = min_t(int, max_table_size, MLX5_FS_MAX_ENTRIES);
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX ||
-	    ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX)
+	    ns_type == MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX ||
+	    ns_type == MLX5_FLOW_NAMESPACE_NIC_RX_CLASS)
 		ns = mlx5_get_flow_vport_namespace(ft_mdev, ns_type, vport_idx);
 	else
 		ns = mlx5_get_flow_namespace(ft_mdev, ns_type);
@@ -2024,6 +2029,9 @@ _get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
 	case MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX:
 		prio = &dev->flow_db->rdma_transport_tx[priority][ib_port - 1];
 		break;
+	case MLX5_FLOW_NAMESPACE_NIC_RX_CLASS:
+		prio = &dev->flow_db->nic_rx_class[priority][ib_port - 1];
+		break;
 	default: return ERR_PTR(-EINVAL);
 	}
 
@@ -2281,6 +2289,9 @@ mlx5_ib_ft_type_to_namespace(enum mlx5_ib_uapi_flow_table_type table_type,
 	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_TRANSPORT_TX:
 		*namespace = MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX;
 		break;
+	case MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX_CLASS:
+		*namespace = MLX5_FLOW_NAMESPACE_NIC_RX_CLASS;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2348,7 +2359,8 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 	*flags = 0;
 	err = uverbs_get_flags32(flags, attrs, MLX5_IB_ATTR_CREATE_FLOW_FLAGS,
 				 MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DEFAULT_MISS |
-					 MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP);
+					 MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP |
+					 MLX5_IB_ATTR_CREATE_FLOW_FLAGS_ALLOW);
 	if (err)
 		return err;
 
@@ -2357,6 +2369,21 @@ static int get_dests(struct uverbs_attr_bundle *attrs,
 	    *flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP)
 		return -EINVAL;
 
+	/* NIC_RX_CLASS only classifies packets into the RDMA path: it takes
+	 * no destination, and ALLOW is its only terminal action.
+	 */
+	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_NIC_RX_CLASS) {
+		if (dest_qp || dest_devx ||
+		    *flags != MLX5_IB_ATTR_CREATE_FLOW_FLAGS_ALLOW)
+			return -EINVAL;
+
+		*dest_type = MLX5_FLOW_DESTINATION_TYPE_NONE;
+		return 0;
+	} else if (*flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_ALLOW) {
+		/* ALLOW is only supported for NIC_RX_CLASS */
+		return -EINVAL;
+	}
+
 	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS) {
 		if (dest_devx && (dest_qp || *flags))
 			return -EINVAL;
@@ -2477,6 +2504,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_CREATE_FLOW)(
 	if (get_dests(attrs, fs_matcher, &dest_id, &dest_type, &qp, &flags))
 		return -EINVAL;
 
+	if (flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_ALLOW)
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
 	if (flags & MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DEFAULT_MISS)
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS;
 
@@ -2963,7 +2993,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 			goto end;
 		}
 		if (obj->ns_type != MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_RX &&
-		    obj->ns_type != MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX) {
+		    obj->ns_type != MLX5_FLOW_NAMESPACE_RDMA_TRANSPORT_TX &&
+		    obj->ns_type != MLX5_FLOW_NAMESPACE_NIC_RX_CLASS) {
 			err = -EINVAL;
 			goto end;
 		}
@@ -3106,7 +3137,9 @@ static bool mlx5_ib_modify_header_supported(struct mlx5_ib_dev *dev)
 	       MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
 					 max_modify_header_actions) ||
 	       MLX5_CAP_FLOWTABLE_RDMA_TX(dev->mdev,
-					 max_modify_header_actions);
+					 max_modify_header_actions) ||
+	       MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(dev->mdev,
+					       max_modify_header_actions);
 }
 
 static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
@@ -3477,7 +3510,7 @@ static const struct ib_device_ops flow_ops = {
 
 int mlx5_ib_fs_init(struct mlx5_ib_dev *dev)
 {
-	int i, j;
+	int i, j, k;
 
 	dev->flow_db = kzalloc_obj(*dev->flow_db);
 
@@ -3498,11 +3531,21 @@ int mlx5_ib_fs_init(struct mlx5_ib_dev *dev)
 			goto free_rdma_transport_tx;
 	}
 
+	for (k = 0; k < MLX5_RDMA_TRANSPORT_BYPASS_PRIO; k++) {
+		dev->flow_db->nic_rx_class[k] =
+			kzalloc_objs(struct mlx5_ib_flow_prio, dev->num_ports);
+		if (!dev->flow_db->nic_rx_class[k])
+			goto free_nic_rx_class;
+	}
+
 	mutex_init(&dev->flow_db->lock);
 
 	ib_set_device_ops(&dev->ib_dev, &flow_ops);
 	return 0;
 
+free_nic_rx_class:
+	while (k--)
+		kfree(dev->flow_db->nic_rx_class[k]);
 free_rdma_transport_tx:
 	while (j--)
 		kfree(dev->flow_db->rdma_transport_tx[j]);
diff --git a/drivers/infiniband/hw/mlx5/fs.h b/drivers/infiniband/hw/mlx5/fs.h
index 7abba0e2837cf8a8d40053b7855faba8224fae8d..9d6f966fa4194053362429d2797fb137d674cb5b 100644
--- a/drivers/infiniband/hw/mlx5/fs.h
+++ b/drivers/infiniband/hw/mlx5/fs.h
@@ -31,6 +31,8 @@ static inline void mlx5_ib_fs_cleanup(struct mlx5_ib_dev *dev)
 		kfree(dev->flow_db->rdma_transport_tx[i]);
 	for (i = 0; i < MLX5_RDMA_TRANSPORT_BYPASS_PRIO; i++)
 		kfree(dev->flow_db->rdma_transport_rx[i]);
+	for (i = 0; i < MLX5_RDMA_TRANSPORT_BYPASS_PRIO; i++)
+		kfree(dev->flow_db->nic_rx_class[i]);
 	kfree(dev->flow_db);
 }
 #endif /* _MLX5_IB_FS_H */
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 65d8767d1830c630f5aa2a2a693110e2c9bc9e48..249acc9b7cd55b88fdded606b0037fd88b0edc4c 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -62,8 +62,12 @@ static int mlx5_ib_set_owner_transport(struct mlx5_core_dev *cur_owner,
 {
 	int ret;
 
-	if (!MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(cur_owner, ft_support) ||
-	    !MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_RX(cur_owner, ft_support))
+	/* Each of these three domains is independently capable; only bail
+	 * out early if cur_owner supports none of them.
+	 */
+	if (!MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_TX(cur_owner, ft_support) &&
+	    !MLX5_CAP_FLOWTABLE_RDMA_TRANSPORT_RX(cur_owner, ft_support) &&
+	    !MLX5_CAP_FLOWTABLE_NIC_RX_CLASS(cur_owner, ft_support))
 		return 0;
 
 	if (!MLX5_CAP_ADV_RDMA(new_owner, rdma_transport_manager) ||
@@ -77,13 +81,20 @@ static int mlx5_ib_set_owner_transport(struct mlx5_core_dev *cur_owner,
 
 	ret = mlx5_fs_set_root_dev(cur_owner, new_owner,
 				   FS_FT_RDMA_TRANSPORT_RX);
-	if (ret) {
-		mlx5_fs_set_root_dev(cur_owner, cur_owner,
-				     FS_FT_RDMA_TRANSPORT_TX);
-		return ret;
-	}
+	if (ret)
+		goto err_rx;
+
+	ret = mlx5_fs_set_root_dev(cur_owner, new_owner, FS_FT_NIC_RX_CLASS);
+	if (ret)
+		goto err_nic_rx_class;
 
 	return 0;
+
+err_nic_rx_class:
+	mlx5_fs_set_root_dev(cur_owner, cur_owner, FS_FT_RDMA_TRANSPORT_RX);
+err_rx:
+	mlx5_fs_set_root_dev(cur_owner, cur_owner, FS_FT_RDMA_TRANSPORT_TX);
+	return ret;
 }
 
 static void mlx5_ib_release_transport(struct mlx5_core_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d1deaa82754cda088b2c67c7575d1..5f444044ada3aa5f1d3c75c5ccfb9c34f4a84e93 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -310,6 +310,7 @@ struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	opfcs[MLX5_IB_OPCOUNTER_MAX];
 	struct mlx5_ib_flow_prio        *rdma_transport_rx[MLX5_RDMA_TRANSPORT_BYPASS_PRIO];
 	struct mlx5_ib_flow_prio        *rdma_transport_tx[MLX5_RDMA_TRANSPORT_BYPASS_PRIO];
+	struct mlx5_ib_flow_prio        *nic_rx_class[MLX5_RDMA_TRANSPORT_BYPASS_PRIO];
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
 	 * only single add/removal of flow steering rule could be done
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 3528743e385865aeb69fce16a491c32b9968ff17..ba0d3435c7d33b6afa202815a146bdefe6064bfa 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -305,6 +305,7 @@ enum mlx5_ib_flow_type {
 enum mlx5_ib_create_flow_flags {
 	MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DEFAULT_MISS = 1 << 0,
 	MLX5_IB_ATTR_CREATE_FLOW_FLAGS_DROP = 1 << 1,
+	MLX5_IB_ATTR_CREATE_FLOW_FLAGS_ALLOW = 1 << 2,
 };
 
 enum mlx5_ib_create_flow_attrs {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
index ef295b38a1cfb371922eb99ffb6c44886fb4f7be..ddf05cdae8ebdda544672f370981f582a6d90340 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_verbs.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
@@ -47,6 +47,7 @@ enum mlx5_ib_uapi_flow_table_type {
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_TX	= 0x4,
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_TRANSPORT_RX	= 0x5,
 	MLX5_IB_UAPI_FLOW_TABLE_TYPE_RDMA_TRANSPORT_TX	= 0x6,
+	MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_RX_CLASS	= 0x7,
 };
 
 enum mlx5_ib_uapi_flow_action_packet_reformat_type {

-- 
2.49.0

