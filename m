Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795161658;
	b=DobcYxNFND++KLuvY6ZcV7SHwTDO7kNrOIsS1/vY1jbGhAREuJx0WpUEl+Ia97AZLYtE
	 SYhdw63fyJqrTDwQc839W25OVIbMxXuWdhcriLf4R5Ws/PEjckAxQWTbN0TTrFUx9a+Pg
	 ewyvTWLt02AKqr9WWtGsyvGeQBrXZXMuGv+NsV/wT5fzXp/8WGjoWLhACqZckAT6o4Ygq
	 9cSmishlVzHD3xdWPYlrSv98J3sUXRLvpHBOqVw2XmpB3PP8GpxtAxePDZ1PfWRqqfs37
	 feTXTYHdivayvA9Y/bJofDYHDfrRKP8XZ4vZAi3F12qwy9e1qw1cVvKPGg74X1F9M5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161658;
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
	bh=al18FLTYuDDQE8oPsvwHfgEo+v3E/icAvIrhFzZWPXE=;
	b=Tyf7kZPZna3EX/GQ5xq5uHlJR53JCXA0Uyxol/cTGc41wGxULF/kUf9Iio7voZN+6xXe
	 qnUrbFbCLqNvml6RkWSglp5dfKTTBlS6x6EdWLGwxjPHRz8NV5FcXfsdsWlIXylNHRXUk
	 sqN15mKgMJTPXL99ztW2/DaXig/10k/gnr86tuLcslDiAdf8YPSXt3S+rYhHsPG6FZtgx
	 SiAiBlX6KquwL9jqu5aSNNFtORzPX4vCSMAihwaFey3kMJuWMDGs/kaaz9gxTDDTLODI2
	 gglRJFI+PAXApt8lrzqEzEmQ1QqKMnq7Pv5nPbluLJOd2yrAANaS9QelICZ5eTu8h0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iSzfK6Wm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.54
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6A606A326;
	Fri, 20 Nov 2026 08:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09A6A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iSzfK6Wm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ySvuUEqgMRwBddzqUbcJDhmopV7Y0FGLG3e3YF4XWqZU45qaZsKD89BCEnVGuYlC27GXN37ab38xNc4oYKhpOfWEuPLsH5QG7AD5HicdZr6AuoANJ2PGQvvy9wekqDqb68A54Im4zSVQbJjLl7MIUCuSUvxh4A8W5HWuyfCGTi6HnxynZGOpYTlgKrFsh52rasUcX3h9oNjNLQqxb7DcZagnZC9AZ6DX6YmDa23IZ0visWkfOQzI9v1Hs2XvmfkWSxHrkdddb1paqOzODLn/SazzQtMszTNaBNMcoJUr1HGnS8k89Ewm2Ol2JWsRv3uhkwE3q+YkMI2RV2UctnhqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=al18FLTYuDDQE8oPsvwHfgEo+v3E/icAvIrhFzZWPXE=;
 b=Vd5LPdTLXzO2BXqaDcq3pgDgMZDCiHCL7Dk74LsWmWK2rBUrnBwdOhmPp5sgqIcovtt076ytvsTs28ZjsPiyYY3Jn+C0Mv9pmw7QfN5l0IeeMBSSyK6kVCyxGj9jY068AhxISyY+XUntkO3oWkSDf2DpknfVM9GpTFEGDy9t3N/oVcSpoM/s+EwhvlQmwkML0TkOyPofXKxvMquex0FFpeaAltY1psUMQ3O6ZcQI3H2OPqRc4nOCgC9AMdehK7vNroJoHvGT95Opqgzl5FHsM5MahfE4Hq56JoJDP0lTLf6tt6hEF6R/DvpKHAeP6joTmqhtniChQrlchJtzFYb8OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=al18FLTYuDDQE8oPsvwHfgEo+v3E/icAvIrhFzZWPXE=;
 b=iSzfK6WmO9wKDQ1D8gGzVI/hUbNgsqmtID6vcJUIMksNCpoTR9yWA2NBGnmVVJ04yDlZng5GEZKokN83VoLiOxU/fwn63CUFjIhTRUOq3aXr/oCfF4/M+pU/weiqHLOR/50SlVvgGmzol7yroI4JrqYQ3gPu8uQdLS+BE+UH3g0neWwx4HzLCULQ8v8F3HGLv4Ukn4E7rUBoiy/I3/psr0cDwB4ETED9sTFKixxshADNfpKQoDHoaBl8o6wz1XvYQE4y6Rh5pX6jLd7RCGpUhoyAdg2dLeYROLlrK4CzZcWtgDWD4a2JgxWgTwsDLTon17ilO2KBp3gj2NH0fZVcCQ==
Received: from BN9P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::24)
 by LV5PR12MB9754.namprd12.prod.outlook.com (2603:10b6:408:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 08:00:52 +0000
Received: from BN1PEPF0001854C.namprd05.prod.outlook.com
 (2603:10b6:408:13e:cafe::9f) by BN9P220CA0019.outlook.office365.com
 (2603:10b6:408:13e::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Fri, 20
 Nov 2026 08:00:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0001854C.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:00:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:31 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:00:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:00:25 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 2/5] net/mlx5: E-switch, match master egress rule by vport metadata
Date: Fri, 20 Nov 2026 09:59:55 +0200
Message-ID: <20261120075959.2533702-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120075959.2533702-1-tariqt@nvidia.com>
References: <20261120075959.2533702-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854C:EE_|LV5PR12MB9754:EE_
X-MS-Office365-Filtering-Correlation-Id: 646a35e4-46f5-4e8a-ff60-08df46dc659f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|82310400026|10067099003|261021123027099003|56012099006|11063799006|261102123227099003|261021121427099003|261009223027099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Gz2EI5YOH3hQfjoS9HB74uoc16+WcuJkeJj06RYtZfH+Cb2uQCrHxEf+r9S4gsGJys+96LF6InlpqMcG1rCPUaA78qS4EFDsxHtqAWvRDx4hp4y2i/gSjJTgdAsWrqFWYiVAA4x8b6fcedRWXAy/yMRCkfGs0Q+SBSNQm47DH6II8cpDWX5IoSgSXECQgRbKYvgJDi/p4wupwMP3zHjZ4gqwSnhaqcH3i70ZTcNKnM4vHsjTWh2w3aGoIpnqJZXdF0WG/Y3eV8FSYGCQagw9iXVFOTBZ2FBsB99F7E75BTV2JOMhFPx+LDanwYC/ysAAG/M0uHjpkSJX5xbSlaEl2mvpPxBmyV/HStGr0A///IVawhTVT3su0dy8oK0nq2oiqRnDCMx4Qzyu6BgOKBmxOQYGdK3LK4FPJOVKoWM4vxGYJVxcAWGvQvQ2HAgoPk4Y7pHhnTdatVmylwjH0zcTk6SHsol05yPXvjsTvV9VeCaCd6myuTCZ2MPisb3PcobRBFZiYAPCaet0uhbxrAiNpisiwElMJ/od/ONGp4+eVDYi11NUdVpio17ZxuPr52FWBBa62+djh+SIeqe614YTjPUOS0uUTPWl5M6wIhbxsB8l1/laBp90bA7LWZi5Az99JExB+QvEESDwzpzqey8jTvOyPi7bODXAnb7PyikZJN+Mg6Fi2gFUeLTAU/fkjlWbMdJT+cui+N+hj9tNiTDANA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(82310400026)(10067099003)(261021123027099003)(56012099006)(11063799006)(261102123227099003)(261021121427099003)(261009223027099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8YR6qkNn6FhWIEFA7fSMwAViylj2TDSrfRbvLpFHgphech1s6PJ3CoNkAobAFeEf5vrBiP4+38787AJ4+sHQE5MgpyOsBgzhNWT+sTZj/UWLdsxLQRAjmVL5OkaB6xzRAy51nQbAiILq65hwLOpyJmykCBdbyCwmJQRyTHwu3OtsHysRAu6pXk0iC60ScwsGpqwKVTeNjETITDaBGreeny/TuEAaFtkiPUVrTBY5ClP04/BEz6hRG7VTNNEjgVVQoa1qxfLJWYpOwEkdFY7i+jlVliezPGLSrAplJLJqAqXJ4g0dV+v5qjnGjJsDgVc6zkdUbmai+4oZfIE0Wht9tTk7DcSsBzfiYGIyOhez+6/hbCbmsCnR8cKQd6zXDNx5T+f0OWRtFUjgdFxOWGeVKTVIHtO1J/vx+XLmCdAR59ljvZt18p7+miluznWXl5rX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:00:51.9950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 646a35e4-46f5-4e8a-ff60-08df46dc659f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9754

From: Shay Drory <shayd@nvidia.com>

The master egress-ACL bounce group and rule matched the slave uplink by
source_port + source_eswitch_owner_vhca_id. Virt LAG master cannot match
that way; it must match by vport metadata (reg_c_0).

Virt LAG only supports MPESW, where every uplink has a unique metadata.
Hence, use metadata matching when LAG is virt LAG, and keep the
source_port + source_eswitch_owner_vhca_id match otherwise.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 78 +++++++++++++------
 1 file changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3c1355f91090..57f58e79478e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2999,6 +2999,26 @@ static int esw_set_slave_root_fdb(struct mlx5_core_dev *master,
 	return err;
 }
 
+static void mlx5_esw_set_spec_source_port_vhca(struct mlx5_flow_spec *spec,
+					       u16 vport, u16 vhca_id)
+{
+	void *misc;
+
+	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
+
+	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    misc_parameters);
+	MLX5_SET(fte_match_set_misc, misc, source_port, vport);
+	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
+		 vhca_id);
+
+	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    misc_parameters);
+	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
+	MLX5_SET_TO_ONES(fte_match_set_misc, misc,
+			 source_eswitch_owner_vhca_id);
+}
+
 static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 					struct mlx5_core_dev *slave,
 					struct mlx5_vport *vport,
@@ -3010,22 +3030,22 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_spec *spec;
 	int err = 0;
-	void *misc;
+
+	if (mlx5_virt_lag_is_supported(master) &&
+	    !mlx5_eswitch_vport_match_metadata_enabled(slave->priv.eswitch))
+		return -EINVAL;
 
 	spec = kvzalloc_obj(*spec);
 	if (!spec)
 		return -ENOMEM;
 
-	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
-	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    misc_parameters);
-	MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_UPLINK);
-	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id, slave_index);
-
-	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
-	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
-	MLX5_SET_TO_ONES(fte_match_set_misc, misc,
-			 source_eswitch_owner_vhca_id);
+	if (mlx5_virt_lag_is_supported(master) &&
+	    mlx5_eswitch_vport_match_metadata_enabled(slave->priv.eswitch))
+		mlx5_esw_set_spec_source_port(slave->priv.eswitch,
+					      MLX5_VPORT_UPLINK, spec);
+	else
+		mlx5_esw_set_spec_source_port_vhca(spec, MLX5_VPORT_UPLINK,
+						   slave_index);
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
@@ -3178,6 +3198,21 @@ static void esw_unset_slave_egress_rule(struct mlx5_core_dev *master,
 	esw_slave_egress_destroy_resources(slave_vport);
 }
 
+static void mlx5_esw_set_flow_group_source_port_vhca(u32 *flow_group_in)
+{
+	void *match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+					    flow_group_in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+			 misc_parameters.source_port);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+			 misc_parameters.source_eswitch_owner_vhca_id);
+	MLX5_SET(create_flow_group_in, flow_group_in,
+		 match_criteria_enable, MLX5_MATCH_MISC_PARAMETERS);
+	MLX5_SET(create_flow_group_in, flow_group_in,
+		 source_eswitch_owner_vhca_id_valid, 1);
+}
+
 static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
 					      struct mlx5_flow_namespace *egress_ns,
 					      struct mlx5_vport *vport, size_t count)
@@ -3188,13 +3223,16 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
 	};
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_group *g;
-	void *match_criteria;
 	u32 *flow_group_in;
 	int err;
 
 	if (vport->egress.acl)
 		return 0;
 
+	if (mlx5_virt_lag_is_supported(esw->dev) &&
+	    !mlx5_eswitch_vport_match_metadata_enabled(esw))
+		return -EINVAL;
+
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
@@ -3208,17 +3246,11 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
-				      match_criteria);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-			 misc_parameters.source_port);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-			 misc_parameters.source_eswitch_owner_vhca_id);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_MISC_PARAMETERS);
-
-	MLX5_SET(create_flow_group_in, flow_group_in,
-		 source_eswitch_owner_vhca_id_valid, 1);
+	if (mlx5_virt_lag_is_supported(esw->dev) &&
+	    mlx5_eswitch_vport_match_metadata_enabled(esw))
+		mlx5_esw_set_flow_group_source_port(esw, flow_group_in, 0);
+	else
+		mlx5_esw_set_flow_group_source_port_vhca(flow_group_in);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, count);
 
-- 
2.44.0

