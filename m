Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A613AA4F1;
	Fri, 17 Jul 2026 07:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273500; cv=fail; b=bmggkDh9Edq0GsRjLc0NI/T0oMArmzkqGs3ELNQiIv18KU28Od/q9Nx8HlwkEribTOXsp5QJRLA6sRn/7zeCjDFi8hTqA7aLz+KO9xxUn7gOJURU8r7D1qO9ihVyJMuti5UDopVE3l13IXSJ7UQdM8XUGooEzJozQUNwN8OYgV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273500; c=relaxed/simple;
	bh=FNYAGputA++qY7Z8mhFPdtmPH1/GffT1hHX921Q7I3A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TQIPRG77RaTkD3Soyn0h4gm0GqnlGH+6TnptJNjA4iqxdvyKc8hLFJnpW3/ZWcl+wu6h7NH4snDGQOnVHZdTxb/BtuBFqFHy073VRXDJRD/TOKyqipEGKtB5NoHJ08O4uMUHlIniMq5Qo9uENEhwuPIUzEBDUpEoM/2CSpDPpgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QuAMQesN; arc=fail smtp.client-ip=40.107.209.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QuAMQesN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHoPCGEivcWb9aKdNgty9cZgrEajuuhutyzDFRhZbCOE5KvxiD+qV0oHxSu7SiiYd308/hcb2JwaUTgMtcKKouEuulqLpHA0YgHOiNBgFRBWD0gWqft+qd7GugkWiCaGfUcCE0FsMaxjPlpK9m4Kd/PSMDtu5YtC9RU+mrkZTDnfP9G9Bt6Y63HSVzom+copDFTnzj/NUjvIXdtKdkSa6qDOsDIGpqPOoIkYLERX3F5UXP4XO1h9szi0zURfSF0LxjNoFPY8ooIMcxvhojD80rVS64s0Z/lkxgwDkFy6OnQhs6ZOYsnsMIoKFdA+DoP+san0hyMlOj142EuCQck/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGLzU7HV9oNfD0ynBESvuodrk4sOo3ZjX234Mn2GrFU=;
 b=Dy/CU7z5KAv8iLJUQm/eSif5btJ7obRpy/+Hjl5X6TcRo1kZDtbhZgDKUzd85kiZEgXNGCM0ysZbFnNbbqzF85vHY3hKXW7pkIgyZLqduCyWexA2bFxuTjdO4qNLeJ6zKkGH3EZVsLnNj7RA0UiS+zH+bTmz4e1aA8U2Cv3eweAeo5Co7r7OGIKqUTF4PzuQ83tDoqVfvRoP0vLHblkgxyiafkvXZa1vjFfV3Aea7ryae9f5X9bcTUhXMEfPsENlXYIYkVZ01jjw2sBYW7kDi4924WXGXrO2br2srd18RgOb5OQaH/06Uuezvs2vZ88V+SWtZL7emalqyUxTpDfazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGLzU7HV9oNfD0ynBESvuodrk4sOo3ZjX234Mn2GrFU=;
 b=QuAMQesNyi35WMb2f/cXylA7lfXAaKWI8RFZXA+jw2ae2W6xvQDR/zr0iYoRUAtRA+q8X6x2jjl7Mn9ilwzMDuypqfebE142kJzthOXrjlC0sAHmKwhics8lCj1qQ9zIhtztWdQLbHal/TBaDVUTaoSFhpCe8MEwE/gURTZ68rCWVBZfU4CcG6Aa6VPJBM9dIIYIUXEaXHLpgiHvKIwkkqaHnmPsNd6KTWrzX2tIfQ6rNq9LaUur9mb3OPKVfjspu6I01c/hG0kfL6IabSu+7JoosiTj0e1x8IzCRPFB7wX4HsR4gMqjbdMMdgND71tcd8JzENpcAu5Dk0dzAjcoHQ==
Received: from DS3P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:45f::14) by
 IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:31:15 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:8:45f:cafe::c) by DS3P220CA0009.outlook.office365.com
 (2603:10b6:8:45f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend
 Transport; Fri, 17 Jul 2026 07:31:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Fri, 17 Jul 2026 07:31:14 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:31:00 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:30:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Fri, 17
 Jul 2026 00:30:56 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
Date: Fri, 17 Jul 2026 10:30:41 +0300
Message-ID: <20260717073041.1241894-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: a57fe8c4-cf69-4cd5-9b61-08dee3d56245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|10067099003|6133799003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	T3sCRW5zu5Dhey79l7gmrirnF6kIhwe1hm7dQXXWyCtJnCOd2P99+02VGvYxiAxx3rppAHXREunxKX+VjLq7XnbZAsg93AJDARFmmliwerdITdqvL9nR+9Cycm1OW1pKRiBK8YCUk6NCqr62sx8LDZwNK5qecRGpfw8J4LjZZUwX7t3oc2J9/INeNAdrxuNvnqEN7p+f3jqorUYfryftjUXawz0TqS1KKxmOLYWaTGJq642TRWzoF6n1quOAeBTak7LCy1U6a9nn7jjwtgBnOWtk4BinI2Usg5SngYZhez8YICcuWspjwolTjKsHg/d5ED4SRG4Apo+bgWQngZVtm1spXjf4XMXFjLSOrLUdQwsUNWhhEWCLzM+G0XOh6RBYbSUfnP+QhZncqi0zrVeVb9GiZ2t2efpAzVqS0g6chypxj2MTDQiNTiPfk2PYFpobgIA9x2mpSpdlxT4aDiwMglkrPTjsrVkuQYEZvEBWOqFkSoBU9UImKbfa8lYRL1CRuP8sJ8hdgSG3rLbe7Tkz1voA4ctL7FMXpntOEuS8hVsku8cQe6BfhT8sTRGOV6VUKXCQaYCtSvNyhSbbMyMxBn8O8ODJ7VabHGI/we4I0W1R36DYa+M3d3CaAvLRgEfd6KBu1MgQvuHZ8Mq6SH/g2j1W/VoAgAEUoBTtSwgQEUZB2QA659vdUSzM/UdrlxIeu9MJijlWIwEsGgB9F3NphQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(10067099003)(6133799003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	q+SOtpmbf1PaixuoDPvqVfbWwiim1lMGRX7NnQAAKzvhMrOCgSdhKHGtRy/aJS7lqHClsJ1LcEBLy+Ew5zUS7jENQovQVxqgQOeO0Op9NZ1VmjzhjgP+CnBp0sFmwsfzrk/D76dYeNhWhC7rUxmjD9ldtpZ4/N9tBMIA6IqHfiwLBYAFFs0JSZVC5kJ64HYXP41/WiIE+u8DhVZyShCjgGhFdQMQELpWfAO0YrPLaFHZ1qvjyjuUXug3y+blc3uhL58mtg6+8iXgyRQTWOM9SgMkVj4T9HjL98YtgWRbi3WJMbKN+r34HrHYXi2RO/x4v3HmWolvvWN9eA0LijIrvlk8stShGcXdQp+FOrtZHJmZb8P55gC4wIo+fNZev/Hd1WlTnYkaSTmkXt7ATaXhyMvXDzVi6xElS7g267zKrPy1vTmmdrXjirLYigiOAIAQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:31:14.8025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a57fe8c4-cf69-4cd5-9b61-08dee3d56245
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862

From: Shay Drory <shayd@nvidia.com>

In case __mlx5e_add_fdb_flow() fails in lower levels, the flow is
deleted via mlx5e_tc_del_flow(), and mlx5e_tc_del_flow() is acquiring
ESW devcom lock without condition. In addition, in case of peer_flow,
__mlx5e_add_fdb_flow() is called while holding ESW devcom comp lock.
This results in an AA deadlock.

To fix this, introduce a new PEER flag that is set on flows created as
peer flows (the duplicate flows on peer devices), and check it in
mlx5e_tc_del_flow() before acquiring ESW devcom lock.

In addition, rename the existing DUP flag to PRIMARY to better reflect
its semantics. The DUP flag indicated that a flow has peer flows on
other devices, but the name was not descriptive. PRIMARY clearly
indicates this is the original flow that manages peer flows.

This makes the distinction between the two flow roles explicit:
- PRIMARY: the original flow that owns and manages peer flows
- PEER: the duplicate flows created on peer devices

Lockdep splat:
============================================
WARNING: possible recursive locking detected
============================================
Possible unsafe locking scenario:
       CPU0
       ----
  lock(&comp->lock_key#2);
  lock(&comp->lock_key#2);
 *** DEADLOCK ***
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_deadlock_bug.cold+0xbd/0xca
 __lock_acquire+0x1671/0x2ec0
 lock_acquire+0x10e/0x2e0
 down_read+0x95/0x430
 mlx5_devcom_for_each_peer_begin+0x4e/0xe0 [mlx5_core]
 mlx5e_tc_del_flow+0x11d/0xa70 [mlx5_core]
 mlx5e_flow_put+0x99/0x100 [mlx5_core]
 __mlx5e_add_fdb_flow+0x409/0xf00 [mlx5_core]
 mlx5e_configure_flower+0x2a86/0x4100 [mlx5_core]
 mlx5e_rep_setup_tc_cls_flower+0x12f/0x1b0 [mlx5_core]
 mlx5e_rep_setup_tc_cb+0x153/0x750 [mlx5_core]
 tc_setup_cb_add+0x1dc/0x470
 fl_change+0x2f4d/0x626d [cls_flower]
 tc_new_tfilter+0x79b/0x2310
 rtnetlink_rcv_msg+0x778/0xad0
 do_syscall_64+0x70/0x960
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 28cab4bf525c..7bfe7cdc5770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS         = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_PEER                  = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1bc7b9019124..b290beb4369a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2161,7 +2161,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
 
-		if (!mlx5_devcom_for_each_peer_begin(devcom)) {
+		if (flow_flag_test(flow, PEER) ||
+		    !mlx5_devcom_for_each_peer_begin(devcom)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
 			return;
 		}
@@ -4628,6 +4629,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	else
 		in_mdev = priv->mdev;
 
+	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_PEER);
 	parse_attr = flow->attr->parse_attr;
 	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
 					 parse_attr->filter_dev,

base-commit: 3f1f755366687d051174739fb99f7d560202f60b
-- 
2.44.0

