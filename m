Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012026.outbound.protection.outlook.com [52.101.53.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75D4AA013;
	Wed,  2 Sep 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367262; cv=fail; b=RfnW48QVbogh1cFcxiu927JpaQVQbnmz3Fl6Z5ITE2bC8yPLU5F/dTFUhp/ixUgH+v6XRmXQQSQaZ0mSBBCZ57XiRthfVnkR9OMfEsDYH+l5DtRnSVYqEJGr7ubsawef9kM3f3eY7LxnVHdO4b/PTtFhCLn40U4oQTQdov1h3tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367262; c=relaxed/simple;
	bh=ylClRsC5Sp3zN8Xd30lUqPW5XbERBmGZJNIlTP2CrQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NU71XK47yBSiYQYrDiP/jPn1vCAqhqBPIbPvJVnylqgoL4cd96MuQ9LMgUw7YT4Dc/V16QaRBLuDbNOTQEN9IYyUNf4TJdvf45jsb0vAbJ+IAhy3QpqbX/ym0DFjvTB80MB0TJLhhxxLGuoVyOQrerx9E38H+G2xIobAJbm8vdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oxQ/4Lnp; arc=fail smtp.client-ip=52.101.53.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oxQ/4Lnp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W9rbFKUjJ9GApPQPsQzWR7n0Ynqa6cJtyx3hyrmtXD+vDZrXqBGokB3ViF9NNSTn+yx1np/BbhzbZ7dCWVPDqdaswaGusednHU9IJSsO8wYjRFQPzR5Feh3o8ySjQWmmK57Ds4n/9FVq3KNVWxQpM0zklYqpsgyjkLUqxRu+d61JcW1+UotYqndsS+pkQutB7BLpbhCI5UdEpekl6XUa0paacgGPfTozWQUiqhrQcJ6PZ/21WcOcp5m9fpyB+EsHeZ3/PpdIkZBRKMOTlIXCJpBd6ZWgZlBd0POpN7AXPCJgFF4iZojQSxgMCDQZL9l31SkRrnQpqYkIC2/Afpf8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=olHBaqhCkf6YD3pHTjjgbO/sRBFBiEEhGJ6vkoURa1L1LqJjumTYFv0LuJWBXFBDf8ohqGeY2fXOoa8z+e7kP8wF3XXrmFuN5fjAFjGOVqaQnqgs5E3wc2aLOeeCnE9Xedl3IOFWpQCFVPQ5F87C8oQZWrQfRQlPCf69FEvv/rERR5ZJpc2bmHsxSJjQ4SfdZPbNtiWCWnzHY/RM5OWp9GnMuxBX9d4ADqWMuHrCoLl9vQb0mKYZ+1Bnq3OteKeNgPunsCcv4tgOweMIAkqs3ujzK71x3YwoVtPMpBaa1rlgIiO9Dv7unIDQMzWNalQ3zPMVM2TFp6A7Mah8fX0mTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60O3CEEx81ew4Yc1qsDRTpiNdTdgDRQPRJY4e24VZtw=;
 b=oxQ/4LnpKNclMGAzNUjBH2XjEQ6xAL9V9IJF5Kmv6lS8ZMpgRBrzqmYim+HgrtcqI8fVOv/0zaZ7109sxEAiRop6cAp+rauomanoUgbajFl8ddFb5iF2hkx8xfAlhigfAGK6F2bk2wzyogFS0zkliL5YFA40l9VprMzLRHeYeMW8InvatlDJwG8LtVTQ31ntiuIef82vy90IurUl3tB7Roh1Mv6XsqaE3R8b6Msnir6ao6vpfktEt6ohE6urGBo9JmVgLxxFFXhPoTwvwZIjrAeeSEgXZuxIiUT+G+JcaoEkBycEhsSpp4qNbiaw1lMfJeKghHj4Y1stX/oKKM6prQ==
Received: from CH3P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::25)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Wed, 2 Sep
 2026 16:40:54 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::e) by CH3P220CA0027.outlook.office365.com
 (2603:10b6:610:1e8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:40:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:40:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:40:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:40:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:40:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net 2/4] net/mlx5: devcom, Base component size on linked devices
Date: Wed, 2 Sep 2026 19:37:14 +0300
Message-ID: <20260902163716.3656279-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260902163716.3656279-1-tariqt@nvidia.com>
References: <20260902163716.3656279-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 02991cb5-5d65-4e2a-e72a-08df0910f499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700016|23010399003|82310400026|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3ZZe+lPUL1LYwstnc9H0zHqG3Vhq9mextmG5Z+Sxio5m9xlXGxt8/nN9bWEFOf4Cn7ZUNli1ef/hpPdwXypbvWPjapaXuOz0skm43vEH6q+S+jZhn/6Xrtwl+xLW+zBmBffrYh9MfA9QplIUPTYOLK05hhz9YiGDEp0A+/Yw6Qig/WSiVBOpn0ixMfFSnSRExz8gl4SXrEFqKuA25qeCN0oiojGOkGnIZqFVqK3l22cfGj19a5mgtm5ui8LpvMUpOvrtBxAUX2J2iJp0Mp0Ov1Iw4/JzuF+2Q7hSDrjd8vXS+JG5mSGo4Ond0ki6xPEkndLLFP85DgK562+0cSQ9VEl8E+aRMBdM3Xd7BPCNEZbnxlPQwgB4c1wtNNAO58WJ/q3mSQ/CM4Goh9DDDuV3721SLDa2RvzdniYZuoRvQiVjolDG7dAwb5UPWC3ftXHaG46BP8DIWXbzLtrjlfkFBiudoDvUCunOvid9XHCMWJMJor0tgZ5ix2z4/bQ/UfodmqywmTJMGTtRzsyLQdCOW/O8aLDgq4R5St/5x/XKarSlFlzgnfKb8UiJN3CwVFTP40iPM3GP+Oj5IROptKu7fbCFsfkw4IeQZD/bEo2BryeMNpxcqmoXwIP19INVnci+XQAernaJk0KKBaydXVRA90LWfYVAXo7dadm9xmbRxDPwyFI6i07t7/wH7E0Q82oMOpEhHnTnzYqgLt2ZH496/w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700016)(23010399003)(82310400026)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4LFnNeu1t7azm/m0I1ytjVJYkIgQC2OhnmoUR/Lpye45YRTX6g+ilXqIbOpgcr1h8Nu/FRnTCT9krck29N+gWRN3ZUa34nKlFvMXsRnBdaDyqA9TCysuH10bcFi4RruOSS+YJUqDLAEgJ9+A4l1VceFJGIE8brPZ0Bf+x1F2xUcJQq5xALvJARXcbclg3oIGBBBRVLAJDWm0JOcH/ZTHjeiyAVZd+4sjHfECoqavRvfSJ46WKVvWEhdSJTRy4mSZIJI1WmiecWsym0ZsIpd5AQU7BCdGUCtnYGFShBr9rj6kpwubE51Nhx9Z2vD1ocM+vKVQiA5XwmRl/CNePxCuZOy3ys6VZJdKOjmILiTgw6I9r5xCuMjssSB4KOakuefP2DN5vQLWyC2bQM9jLjzoa9YIziTKpjXAeJb2JZ4kuweLL+BCCggXULEvIGvM2cDO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:40:53.6241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02991cb5-5d65-4e2a-e72a-08df0910f499
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412

From: Shay Drory <shayd@nvidia.com>

mlx5_devcom_comp_get_size() returns the component's kref count. That
kref is bumped in mlx5_devcom_register_component() under comp_list_lock,
before the comp_dev is linked onto comp_dev_list_head under comp->sem.
The event broadcast (mlx5_devcom_locked_send_event()) walks that list.

Hence, a caller can read the expected size, but send_event won't be sent
to all peers. In the SD group registration path, this lets a member
broadcast its role-election event over an incomplete list, electing a
primary that never completes the group, is never marked ready, and
leaves the group with a stale primary.

Track the number of linked comp_devs in a dedicated counter, maintained
under comp->sem together with the list add/remove, and return it from
mlx5_devcom_comp_get_size().

Fixes: 9bb1ac80738a ("net/mlx5: devcom, Add component size getter")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 64f92427602d..75855481522b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -37,6 +37,7 @@ struct mlx5_devcom_comp {
 	struct mlx5_devcom_key key;
 	mlx5_devcom_event_handler_t handler;
 	struct kref ref;
+	int nr_devs;
 	bool ready;
 	struct rw_semaphore sem;
 	struct lock_class_key lock_key;
@@ -170,6 +171,7 @@ devcom_alloc_comp_dev(struct mlx5_devcom_dev *devc,
 
 	down_write(&comp->sem);
 	list_add_tail(&devcom->list, &comp->comp_dev_list_head);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs + 1);
 	up_write(&comp->sem);
 
 	return devcom;
@@ -182,6 +184,7 @@ devcom_free_comp_dev(struct mlx5_devcom_comp_dev *devcom)
 
 	down_write(&comp->sem);
 	list_del(&devcom->list);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
 	up_write(&comp->sem);
 
 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
@@ -284,7 +287,7 @@ int mlx5_devcom_comp_get_size(struct mlx5_devcom_comp_dev *devcom)
 {
 	struct mlx5_devcom_comp *comp = devcom->comp;
 
-	return kref_read(&comp->ref);
+	return READ_ONCE(comp->nr_devs);
 }
 
 int mlx5_devcom_locked_send_event(struct mlx5_devcom_comp_dev *devcom,
-- 
2.44.0

