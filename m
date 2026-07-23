Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F8C3DAAD2;
	Thu, 23 Jul 2026 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784790326; cv=fail; b=EJZURrc+2Oo3lwe3YqDIaRLDJ2ehvsy2lYbCcI1WqGkzR93cAVjdp7k0EdXFXXm0eN5iw+fJtFj56XVodY+cTEIvBjo0tPO8HZeCczBrAdVq77euRHGNs8nWv38Npl4zKBKGk+H0uAfBF2ZbzdYwh5Vw608h2ZbjnIHY5OXWTuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784790326; c=relaxed/simple;
	bh=QwSAiP9bjEJBRwgALZS0lj3y2iXJOyi0vl9pDESOJ/c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LzRi55gNgLG/PDAZO8FUE1fqkCmkqVHBvOH45Mg8oocMitV6MfX/HykumE+rfNhisobbmFZQFO5FHGCkFNSQ8vRTGGonFH4UFMt33G6xYVtA7zylXBahDof43UH505BiBjLjZ8jC8JQl8Tqf6DqKIL6SREXKySUNeFqsZ7bf2FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ro5XkP1W; arc=fail smtp.client-ip=40.93.198.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ro5XkP1W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLAzvPCFrLity/7inOXodonXj4HDDuoWU28zOUCinM9ggdyp6yymsxM0BqzxR6mijdApzVVvWPI8Z5lfqsgwS/rPIxt4D7xuwg+CwWxSlBOCSA+P+M2ROS7oJzhw2nI/7/ItheAUmfdoP/lX0Bz9RVaQXLbkZLeVlPBL1CHvl5hCRsiEGSl6L57w6mIG9UUfFmWxvUwLUcn/sTJGjapUClW+408Md9EA22fJh6VH28SqFuDMY6JNdVMujI1v8iXJudg90SM52WwIhvGmTUTrJwBpXDUiWFxMsTmUx+UQVekEDHO4H38jNssXLOB9VwX3Rc+yyAi3anj28iwKB611VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdX35RZAzoHOzWC2cRS2SJJt0sGzIH55BnP+KR7uEZk=;
 b=dVmoKgZ6EbJXwmsqiKtATVbASQDTXCbpL60BHdkaOnOPuFN2RIZRzSsbzFg2mSB21mdGFpoXjaoYY0mZeBdFwS4ny+mXJ451b9ute2xJiEVmaidYLQfvhRpJfRwZMTIIzTaCWdisgtH5otMXfla/0OkHeWC0WGCWcNGS+AbJfpqj53lJXaQVam5kBIp0pnOjmt+2zOyv11b3jbVT+47iU/lIV+ASEHGYnuzq8tZ2r+jjYD4oddkW42h3K13odE6d2PwYehWKdQX9ON3bQcEQsGjKYiihC2Ga7Cz0YauXK3j69qTVDfDxHKBgP9tK3Fu2EJGzpi9r6PXGEIXNZZVaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdX35RZAzoHOzWC2cRS2SJJt0sGzIH55BnP+KR7uEZk=;
 b=Ro5XkP1Wzo/LjVQDkncpVIwiK/EnUdd106H08VBWrlK0GsG9zIY/69zCGXiPH2yywRTsSWrBwgTQthIbnOY+1N0HyWuV389OBZEZ6nWboncsmzjf8WEq5GJzUg5W3SBpniQAH5quF1eq7la0w5p1TFX7rWkhu+nXE9dNtXkgYRztOCP8pcixsa2HWhDjtN0Gk688i1+OkWRQs7DXzoLKrv+EvhcuGMOwTsBCTUSitsdlxWoh97pIDmBtS4+qqDk2hxt6lqY7FdMquPGPugBvy0ciCl2uFh/DhwVio1ex5I39OHQymP2T8H4JWHFKcI8xOAqms2T4S/voaWVCY728bg==
Received: from PH7P223CA0026.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::31)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Thu, 23 Jul
 2026 07:05:13 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:510:338:cafe::1d) by PH7P223CA0026.outlook.office365.com
 (2603:10b6:510:338::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 07:05:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:05:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:04:55 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:04:54 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:04:51 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yael Chemla
	<ychemla@nvidia.com>
Subject: [PATCH net-next] net/mlx5: E-Switch, defer fwd2vport egress ACL allocation
Date: Thu, 23 Jul 2026 10:04:27 +0300
Message-ID: <20260723070427.1861502-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: e4eb3220-0910-44aa-58de-08dee888bd93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|23010399003|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	s+cDQayPSIHAyydZDdBblkOxuSm0xuirWHmq9YyrewIzs59R8UyyL6E0Zr6WyQL3u+fzP43g2gU6B0toSiq4+LGBZexkmOEYjQGZ9mjwxy44UADuLSbmsCuvowDrpSYzR4VAQuWRzK8RblLUCMva2ArX6UXhDpy7cp72tFzoPVwhD6VEcqq0DpFgf0jmcSn1xPqdwuq+UYqtUqwC01dXMyPaKLLmpXK9QywXswpSJeZlg/0nDvykDkZkyGMRBwElAzCcVXptgabXlaI2QLO5ji5DmkuZEVoJ5diXg7ufeFTv5zInNu5En6eGveVEChKAM97pefwZkpOnpP5B7jNk6T1h1NQ7c56U3zZuhC6+rKUlB9ABnjQNu0frpR31G4SSbAvLz9OzsM12tZl3XFeDciKXQpnN7zS1uc8yN4kWCCdlCK+fojYYwIMiec7IkWyyrpCCJ2iIC+5XuwdA2k+5SPylIPME2QXGuvXUTAiHBSIUIQWCvmiDEDOHFw4/AbjmXPE3wMKjvCU1ZlC5IwrYkwINLM5czwIsm0qQcXkCcroY95+xBRZUINnm+c9MdeB5GB83UgvyomA2GtJ0agPNo3BtAQBXIl6o6egXegyr51NMYgnCd2yA8Hq4PIktemlhSo9CCwwMG04IvgSvXHfSiyW8PPIS8m/yukTe/JZiolY8M56bQVEyVdVE9wVm5wiWgj3QyoSIGL7k9QYgJoW4Wg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nQYONMd5BMzByPXqB4WseJvflvFmWO34pHfdH0z+e1fjrhBH4CXKB4qIWx+wAPnUcu+MdHynBDid3NlBpXt+g6stimzmvoJL0LeIVEyO297C0+YgLFlJlKN8FhNVJkhu8BP10uitXDB5pF2RkLnEVkKs5E/1euSKnDEItbdRbgNyf5B2KFxpukyNm/YaMN58hMxCoYlNaMSSKhXpdx9rSNR2rOtEeFKjzvEtt6kbO1jZoR+D0A3c3T5N4WFgWvMtOFKQnzqooY8fg/ubBYpAbV351krkS6WAVyCAyVvanhvSP5oFhZ2T4YzUfV75aAlmdESqO+Zi9CaKK2JTdle82nRD+iyOEsYHjghsrPnEEFeVDoX/4RTtcJRM5otEw8fIqD68pUK++xXYTYES9qIB3VhzTvvzL34BemskyNZGoz2DuM4wWBjanf6o0yRQzKVD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:05:12.5866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4eb3220-0910-44aa-58de-08dee888bd93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

From: Yael Chemla <ychemla@nvidia.com>

On every VF/SF vport enable, esw_acl_egress_ofld_setup() allocates an
egress ACL flow table and a fwd_grp whenever the device supports
egress_acl_forward_to_vport. The only consumer of that group is the
active/passive fwd2vport rule installed when two representor netdevs
are bonded - a path that almost never fires. As a result, hosts with
many VFs/SFs pay a per-vport flow table and flow group cost for a
feature most ports never use.

Defer the flow table and fwd_grp creation to the moment they are
actually needed, when mlx5e_rep_esw_bond_netevent() drives
mlx5_esw_acl_egress_vport_bond() for the passive vport:

- esw_acl_egress_ofld_setup() now returns early unless
  prio_tag_required is set. When prio_tag_required is set the
  flow table is still allocated eagerly for the VLAN pop rule, and
  its size is grown by one when fwd2vport is supported so the lazy
  fwd_grp can later be added without re-creating the table. Only
  the VLAN group is built up-front.

- A new helper, esw_acl_egress_ofld_fwd2vport_setup(), allocates
  the egress ACL flow table (size 1) and the fwd_grp on demand,
  and rolls back the flow table if group creation fails and the
  helper had just allocated it. Existing cleanup paths
  (esw_acl_egress_ofld_cleanup() -> *_groups_destroy() /
  *_table_destroy()) already tolerate NULL fields, so vport
  disable continues to free everything that was actually
  allocated.

- mlx5_esw_acl_egress_vport_bond() calls the helper for the
  passive vport before installing the fwd2vport rule. The active
  vport does not need the flow table on its own: with a NULL
  fwd_dest, esw_acl_egress_ofld_rules_create() is a no-op unless
  prio_tag_required is set, in which case the eager path already
  built the table.

mlx5_esw_acl_egress_vport_bond() and mlx5_esw_acl_egress_vport_unbond()
now take esw->state_lock for the duration of the operation, because
they may mutate vport->egress.acl, which is also written by the vport
enable/disable path under the same lock.

Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  | 103 ++++++++++++------
 1 file changed, 68 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 24b1ca4e4ff8..981ce4463582 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -113,8 +113,8 @@ static void esw_acl_egress_ofld_rules_destroy(struct mlx5_vport *vport)
 	esw_acl_egress_ofld_bounce_rules_destroy(vport);
 }
 
-static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
-					     struct mlx5_vport *vport)
+static int esw_acl_egress_ofld_fwd_grp_create(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fwd_grp;
@@ -122,22 +122,12 @@ static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
 	u32 flow_index = 0;
 	int ret = 0;
 
-	if (MLX5_CAP_GEN(esw->dev, prio_tag_required)) {
-		ret = esw_acl_egress_vlan_grp_create(esw, vport);
-		if (ret)
-			return ret;
-
+	if (MLX5_CAP_GEN(esw->dev, prio_tag_required))
 		flow_index++;
-	}
-
-	if (!mlx5_esw_acl_egress_fwd2vport_supported(esw))
-		goto out;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in) {
-		ret = -ENOMEM;
-		goto fwd_grp_err;
-	}
+	if (!flow_group_in)
+		return -ENOMEM;
 
 	/* This group holds 1 FTE to forward all packets to other vport
 	 * when bond vports is supported.
@@ -150,16 +140,15 @@ static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
 		esw_warn(esw->dev,
 			 "Failed to create vport[%d] egress fwd2vport flow group, err(%d)\n",
 			 vport->vport, ret);
-		kvfree(flow_group_in);
-		goto fwd_grp_err;
+		goto out;
 	}
 	vport->egress.offloads.fwd_grp = fwd_grp;
-	kvfree(flow_group_in);
-	return 0;
+	esw_debug(esw->dev,
+		  "lazy-created fwd_grp for vport %d (flow_index=%u)\n",
+		  vport->vport, flow_index);
 
-fwd_grp_err:
-	esw_acl_egress_vlan_grp_destroy(vport);
 out:
+	kvfree(flow_group_in);
 	return ret;
 }
 
@@ -185,22 +174,23 @@ static bool esw_acl_egress_needed(struct mlx5_eswitch *esw, u16 vport_num)
 
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
-	int table_size = 0;
+	int table_size = 1;
 	int err;
 
-	if (!mlx5_esw_acl_egress_fwd2vport_supported(esw) &&
-	    !MLX5_CAP_GEN(esw->dev, prio_tag_required))
+	if (!esw_acl_egress_needed(esw, vport->vport))
 		return 0;
 
-	if (!esw_acl_egress_needed(esw, vport->vport))
+	/* The fwd2vport FT/group is created lazily on bond events; if prio_tag
+	 * is not required, skip eager FT allocation here entirely.
+	 */
+	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
 		return 0;
 
 	esw_acl_egress_ofld_rules_destroy(vport);
 
+	/* Reserve an extra FTE so the fwd_grp can be added lazily later. */
 	if (mlx5_esw_acl_egress_fwd2vport_supported(esw))
 		table_size++;
-	if (MLX5_CAP_GEN(esw->dev, prio_tag_required))
-		table_size++;
 	vport->egress.acl = esw_acl_table_create(esw, vport,
 						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
 	if (IS_ERR(vport->egress.acl)) {
@@ -210,21 +200,21 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	}
 	vport->egress.type = VPORT_EGRESS_ACL_TYPE_DEFAULT;
 
-	err = esw_acl_egress_ofld_groups_create(esw, vport);
+	err = esw_acl_egress_vlan_grp_create(esw, vport);
 	if (err)
-		goto group_err;
+		goto table_err;
 
 	esw_debug(esw->dev, "vport[%d] configure egress rules\n", vport->vport);
 
 	err = esw_acl_egress_ofld_rules_create(esw, vport, NULL);
 	if (err)
-		goto rules_err;
+		goto vlan_grp_err;
 
 	return 0;
 
-rules_err:
-	esw_acl_egress_ofld_groups_destroy(vport);
-group_err:
+vlan_grp_err:
+	esw_acl_egress_vlan_grp_destroy(vport);
+table_err:
 	esw_acl_egress_table_destroy(vport);
 	return err;
 }
@@ -236,18 +226,53 @@ void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport)
 	esw_acl_egress_table_destroy(vport);
 }
 
+/* Lazily allocate the egress ACL table and fwd_grp for a vport that is about
+ * to receive a fwd2vport rule. The table is otherwise created eagerly only
+ * when prio_tag is required.
+ */
+static int esw_acl_egress_ofld_fwd2vport_setup(struct mlx5_eswitch *esw,
+					       struct mlx5_vport *vport)
+{
+	struct mlx5_flow_table *acl = NULL;
+	int err;
+
+	if (!vport->egress.acl) {
+		acl = esw_acl_table_create(esw, vport,
+					   MLX5_FLOW_NAMESPACE_ESW_EGRESS, 1);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		vport->egress.acl = acl;
+		vport->egress.type = VPORT_EGRESS_ACL_TYPE_DEFAULT;
+	}
+
+	if (vport->egress.offloads.fwd_grp)
+		return 0;
+
+	err = esw_acl_egress_ofld_fwd_grp_create(esw, vport);
+	if (err && acl)
+		esw_acl_egress_table_destroy(vport);
+	return err;
+}
+
 int mlx5_esw_acl_egress_vport_bond(struct mlx5_eswitch *esw, u16 active_vport_num,
 				   u16 passive_vport_num)
 {
 	struct mlx5_vport *passive_vport = mlx5_eswitch_get_vport(esw, passive_vport_num);
 	struct mlx5_vport *active_vport = mlx5_eswitch_get_vport(esw, active_vport_num);
 	struct mlx5_flow_destination fwd_dest = {};
+	int err;
 
 	if (IS_ERR(active_vport))
 		return PTR_ERR(active_vport);
 	if (IS_ERR(passive_vport))
 		return PTR_ERR(passive_vport);
 
+	mutex_lock(&esw->state_lock);
+
+	err = esw_acl_egress_ofld_fwd2vport_setup(esw, passive_vport);
+	if (err)
+		goto unlock;
+
 	/* Cleanup and recreate rules WITHOUT fwd2vport of active vport */
 	esw_acl_egress_ofld_rules_destroy(active_vport);
 	esw_acl_egress_ofld_rules_create(esw, active_vport, NULL);
@@ -259,16 +284,24 @@ int mlx5_esw_acl_egress_vport_bond(struct mlx5_eswitch *esw, u16 active_vport_nu
 	fwd_dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
 	fwd_dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 
-	return esw_acl_egress_ofld_rules_create(esw, passive_vport, &fwd_dest);
+	err = esw_acl_egress_ofld_rules_create(esw, passive_vport, &fwd_dest);
+
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return err;
 }
 
 int mlx5_esw_acl_egress_vport_unbond(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+	int err;
 
 	if (IS_ERR(vport))
 		return PTR_ERR(vport);
 
+	mutex_lock(&esw->state_lock);
 	esw_acl_egress_ofld_rules_destroy(vport);
-	return esw_acl_egress_ofld_rules_create(esw, vport, NULL);
+	err = esw_acl_egress_ofld_rules_create(esw, vport, NULL);
+	mutex_unlock(&esw->state_lock);
+	return err;
 }

base-commit: 1df10cef2d1e7f9f2fb7eddb67fc70d3abf101f9
-- 
2.44.0

