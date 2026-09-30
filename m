Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2474BD780;
	Wed, 30 Sep 2026 12:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770371; cv=fail; b=kbi82WV4xDHg5FlaAJfucrwJD0cRPHCJ9kE/bci3gYjovBSY3hzvKuz8k7PP5yqvMOpKk0/vBWyz28cujsRj4Z76M28fsKfBmxKFm/S/cqH7tTFDEPe2IltSAEdZQHNT0QO0HVC804216zPW2NpiYVQ1pWRd+mH9g2uZIobdpZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770371; c=relaxed/simple;
	bh=OtSoLr40rId+YW59ezioBxWf8UsTpUHxNegfPJcTetU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YShg7xjZYS80yPu8XevEQyj2tJ8RorsXXGH6I0A4Fz4oMUke8Pu7dZkNzuGLGpUsWmF5Cqrtn4UIhGqh4a1CwzSzE1fgiYoNy+ueBjCyLC/8XV7Qz8z+nyqmXvlEielmw8o9VGuNZOEnKUvX+l+V5krIaKrDFebdYO8ZneFZrDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GB9PhPW+; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GB9PhPW+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AqL7p18yxy1Dfzkq/EMKuGoy9gK3uipjImSGR4dS/xUxfjKg3EHEldesnPFyI3+zbpaLMygYmMakcrXN/A5MJHuhF4TxpnsKAcOH519zBiqWWxgBKmmlAxyWWB88SQedY5pT+SYFroQ+bWd+lmlgTWY/j2XGIPIHnw5tDD9QiqHisngLr3m8ARe32cveeEux0+8d9YcBZ59CNiZ5yp6Ela/PtZeV03gojZtzpaxhIKrTSm52xFU3uFstI+CB+q/mZn+eeV+8uJz6Q66OR4MMnK1u4p+wAkSBV0RjMimdiLgeVdErCb7fhb251C3R8Ph9B6eGI+twQwx62U0MeYvqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiCi3vCnbq8RHRVbGcCzx1M+d5wbB9nQt5CHxZRl8Ng=;
 b=gk+ehWnWBHbPkHbQOEhIcTM9VDuI4KgIPzPnejmQezyWRn3CiNbUVgwXUQdiPCcQKgLvulkCAG4GbGE8Ob9a9xaQwbOfkfgi9fMUmmMyiy5XZXNay5BUrPKl5hYlubFzWyV+8BePm1oVm5mL9C3LKrZ/nWvanDbDpMIBuKmOfpJ/vXQkOReV1J8o4v6t46FulaKmNGtqllABkygE+P8isBT1LIfQOePYs94Q8MdxKuTUe3FGqTcbCjCn+6NVg5MmimTpY252umxbftcqZdfZKg/MyIRyFc1GneDbdLhzcXMHW+ESGKSUFkiGBBYGHhfQVeCthpkEnHLrqVDBTPQsYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiCi3vCnbq8RHRVbGcCzx1M+d5wbB9nQt5CHxZRl8Ng=;
 b=GB9PhPW+HsJU4VMWf0ZwwDK0UD1wjWITZFsvNira/cFUFjLfDCJpXETghsh66rxguQNk39gLuKRgL/fFYfJjaDpoeLKOLzqCqsValNY6AE02/omdz0sfyJdGXOzfU+mvIuGKXH69jILbY8rholJyhuqq6avLBiBeL/oBucqKeEvKKpH2gL1L3xKgBCSh1jsDIn2IDWuj9SEam6tU4jdpuReNFLokrZjIs0tvD0IIpheZ/J/Q6R6gbxK//Zh8Qa8xrqFTnuSjzNe8FJf8r7MEd1kcKIf4F7hR5gjxar0lUiDe+euqO6fn1N9kMEdRx911Xc86GCfCkxeurneTabxaiA==
Received: from BN9PR03CA0091.namprd03.prod.outlook.com (2603:10b6:408:fd::6)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Wed, 30 Sep
 2026 12:12:37 +0000
Received: from BN3PEPF00022BD1.namprd03.prod.outlook.com
 (2603:10b6:408:fd:cafe::45) by BN9PR03CA0091.outlook.office365.com
 (2603:10b6:408:fd::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 12:12:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF00022BD1.mail.protection.outlook.com (10.167.248.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:12:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 05:12:14 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:12:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 05:12:07 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Steffen Klassert <steffen.klassert@secunet.com>, "Tariq
 Toukan" <tariqt@nvidia.com>
Subject: [PATCH net V2 4/4] net/mlx5e: tc: Tie esw & accel blocking refs to the flow's lifetime
Date: Wed, 30 Sep 2026 15:11:19 +0300
Message-ID: <20260930121119.141953-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930121119.141953-1-tariqt@nvidia.com>
References: <20260930121119.141953-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD1:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d207b1-f6da-48a4-20ba-08df1eec1da2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OsD+42NfUBDJs1vzuZhNm6/JHmT52zDfs+t1wpUAhExQH3sywL21Kwg4VIvDbGXTafgoylvJc/niyowpVmPLWk25qmfKPwKdZ0uYx/ILysp/rauvpKGWL+jQU+9rjc8Nt5/IYXiGLY9dx11/gLy+gRxeyKfGVby1FA1oHpX9HiOrOjtWvVXZ7OiDq5iK0aIXmLa0OLy023/0NDgHIZXfLGwQX7Jy9/1UVQVyw8rF0gqWS5QPm6n0ACD8hyBPXp+pC/Sxku3bxz3iwiihSFZ1eZMgn0YzVG4eP8Rw0Qwr5ocpJfyuOWxfOuubxD64stHNDPCy/VlpPSCu1bFiHeEKgGvvx3oy8v9k5DW4cSF4wGi0Cc77IdF4Cfu6Utkq3FUsSfClul7h4L6rCDBK78kotxpKs71dkrFrmS6/JG/kT+0yToMOx0xigw/OoIAQakvXM7AhVY7DsXWopPy1HcEH9wXFibGX6XAT9p2WzWj55ESktigpU4hJFTlNeSanPUTU6FYgrZM4PTCt0HByrO+Ze2g1hx3Uc2qP0VKuqW39olQKqi9sxA1rGdQ1+IGZKuT7iAaKRGazbRUHnMoJMJgvDtsEXIADTZydxLg00XuGop/W57FrOQJq6q/1mrim9RFNduTFRNKcUE1sOJ60RnD0qpnEuBTFFC/dBT6Z2KoSc+tW0gmtx0Mdi+3sypNm946eCC+L0J0u8K+oqRLMHjsEWA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	42SSwaCLLdjfxafAwStk9BzKBV+YNwY5ttqVshnC7Xllzr53Bh/t5CoHTDPhj0K7cPl4ZszTWXmWLigzfCUiNv8Fuzmp72RbV6o+aXCgo00EPLUEOytAGtX81EmEyOniTECGjvOwjSG3k2VL2wXdW65chKWFYofOoQhQdkidnxgRYbX4v27t1MRVpndYfqYhD2p7Bv6vOszYgXok2eAWxLP6au4au0AT/xZcIlEiOxeRneicag0PGOcG8WJIMaAIcfIW8VWJUE9NyIDk3GbqQM+BU1ikA2yemnS0hxNB4pNFuY5v95+f4Z5blM3SJsqLcqYXXDnFWgoyoWlMrtV9PoqGpKwNeol1Qg2dSkZ8lhJWKcmqZTvB+rAMxZdF4o8aUwjm2diz0tianOqmq7d6Yg/45OWC4nP+Npf/L/EEJm7wLoW5cYPNuxLYGz0M3F+I
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:12:36.6343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d207b1-f6da-48a4-20ba-08df1eec1da2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345

From: Cosmin Ratiu <cratiu@nvidia.com>

TC flow creation acquires an esw user ref and, where required, an
IPsec-blocking reference. mlx5e_delete_flower() releases these, but
bulk cleanup (mlx5e_tc_nic_cleanup -> _mlx5e_tc_del_flow) destroys the
remaining flows without releasing either.

When bulk cleanup runs during suspend, the core device survives with
stale counters, which can prevent subsequent eswitch mode changes and
IPsec offload.

For the same reason, two more bugs are that the refs are dropped in
mlx5e_delete_flower(), before the flow is actually freed, leaving a
window of time where:
- a racing esw mode change could pull the rug from underneath the
  existing flow, leading to use after free.
- new IPsec objects might be installed, violating the restriction of
  mutual exclusion between TC and IPsec.

To fix these issues, this patch moves the reference acquisitions in
mlx5e_alloc_flow(), before the HW objects are actually allocated, and
moves the reference dropping to mlx5e_tc_del_flow(), after the HW
objects are deallocated.

Bulk cleanup still bypasses flow reference counting and can free flows
that remain referenced by asynchronous workers. This pre-existing
lifetime issue requires changes to worker quiescing and resource
teardown ordering and is outside the scope of this patch.

Fixes: 7dc84de98bab ("net/mlx5: E-Switch, Protect changing mode while adding rules")
Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 48 ++++++++++++-------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3d2850e2d76e..89463d18880c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -603,6 +603,10 @@ struct mlx5e_hairpin_entry {
 
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
+static int mlx5e_tc_block_ipsec_offload(struct net_device *filter,
+					struct mlx5e_priv *priv);
+static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter,
+					   struct mlx5e_priv *priv);
 
 struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow)
 {
@@ -2158,13 +2162,16 @@ static void mlx5e_tc_del_fdb_peers_flow(struct mlx5e_tc_flow *flow)
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
+	struct net_device *filter_dev = flow->attr->parse_attr->filter_dev;
+	bool peer = flow_flag_test(flow, PEER);
+
 	if (mlx5e_is_eswitch_flow(flow)) {
 		struct mlx5_devcom_comp_dev *devcom = flow->priv->mdev->priv.eswitch->devcom;
 
-		if (flow_flag_test(flow, PEER) ||
+		if (peer ||
 		    !mlx5_devcom_for_each_peer_begin(devcom)) {
 			mlx5e_tc_del_fdb_flow(priv, flow);
-			return;
+			goto out;
 		}
 
 		mlx5e_tc_del_fdb_peers_flow(flow);
@@ -2173,6 +2180,11 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
 	}
+out:
+	if (!peer) {
+		mlx5e_tc_unblock_ipsec_offload(filter_dev, flow->priv);
+		mlx5_esw_put(flow->priv->mdev);
+	}
 }
 
 static bool flow_requires_tunnel_mapping(u32 chain, struct flow_cls_offload *f)
@@ -4463,6 +4475,7 @@ mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *a
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		 struct flow_cls_offload *f, unsigned long flow_flags,
+		 struct net_device *filter_dev,
 		 struct mlx5e_tc_flow_parse_attr **__parse_attr,
 		 struct mlx5e_tc_flow **__flow)
 {
@@ -4497,11 +4510,23 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	init_completion(&flow->init_done);
 	init_completion(&flow->del_hw_done);
 
+	parse_attr->filter_dev = filter_dev;
+	attr->parse_attr = parse_attr;
+	/* Non-peer flows own the reservations until final destruction. */
+	if (!flow_flag_test(flow, PEER)) {
+		err = mlx5e_tc_block_ipsec_offload(filter_dev, priv);
+		if (err)
+			goto err_free_attr;
+		mlx5_esw_get(priv->mdev);
+	}
+
 	*__flow = flow;
 	*__parse_attr = parse_attr;
 
 	return 0;
 
+err_free_attr:
+	kfree(attr);
 err_free:
 	kfree(flow);
 	kvfree(parse_attr);
@@ -4558,11 +4583,10 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_ESWITCH);
 	attr_size  = sizeof(struct mlx5_esw_flow_attr);
 	err = mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
-			       &parse_attr, &flow);
+			       filter_dev, &parse_attr, &flow);
 	if (err)
 		goto out;
 
-	parse_attr->filter_dev = filter_dev;
 	mlx5e_flow_esw_attr_init(flow->attr,
 				 priv, parse_attr,
 				 f, in_rep, in_mdev);
@@ -4712,7 +4736,7 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	mlx5e_tc_del_fdb_peers_flow(flow);
 	mlx5_devcom_for_each_peer_end(devcom);
 clean_flow:
-	mlx5e_tc_del_fdb_flow(priv, flow);
+	mlx5e_flow_put(priv, flow);
 	return err;
 }
 
@@ -4739,11 +4763,10 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_NIC);
 	attr_size  = sizeof(struct mlx5_nic_flow_attr);
 	err = mlx5e_alloc_flow(priv, attr_size, f, flow_flags,
-			       &parse_attr, &flow);
+			       filter_dev, &parse_attr, &flow);
 	if (err)
 		goto out;
 
-	parse_attr->filter_dev = filter_dev;
 	mlx5e_flow_attr_init(flow->attr, parse_attr, f);
 
 	err = parse_cls_flower(flow->priv, flow, &parse_attr->spec,
@@ -4871,12 +4894,6 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (!mlx5_esw_hold(priv->mdev))
 		return -EBUSY;
 
-	err = mlx5e_tc_block_ipsec_offload(dev, priv);
-	if (err)
-		goto esw_release;
-
-	mlx5_esw_get(priv->mdev);
-
 	rcu_read_lock();
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	if (flow) {
@@ -4920,9 +4937,6 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
-	mlx5_esw_put(priv->mdev);
-esw_release:
 	mlx5_esw_release(priv->mdev);
 	return err;
 }
@@ -4963,8 +4977,6 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
 
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
-	mlx5_esw_put(priv->mdev);
 	return 0;
 
 errout:
-- 
2.44.0

