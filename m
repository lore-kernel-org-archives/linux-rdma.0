Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.23
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793726012;
	b=zmJ4unZ0HuPpWRZnkqP7JfVH3T/QiKDnUEZgc3faGxMlsOCYBnxh4nv1YoQtG+wAwAtT
	 Pn7b5PYqUSs0komUJcRbf50vN2IhjspQIicDjyTiGSsStgMV4y/wk+WZ+W0TtKrTAbsNh
	 g7UWuARMCjbAUIx71Vy98+qQruXvY8WNMJP1O58/gOP32dkeLMn9ucRJXCuB8a62sXSaM
	 MTfk6rY5ABCOVgaH1yOy0+Lqz4zkQhLxRJxcXXcCWJHL02DVSKxQ4fw6wPRRXS/7j/WAM
	 TBZ9o04YhEzLry/phhUrZnTpw0pG4at2qzykD1uEX1PuWgBwZqhLU4+GW1SFiaVBQuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726012;
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
	bh=A1EbrKGwU22KC4I63lhP6IP+9gmG+kZzJ2jKemMbUCk=;
	b=3szNcUf+4crz5HRZPhabGZKhB/7WG7z3ODqeODv7g9djQenWUChgifMhW+GRtVctxAqI
	 fwPx4vWGwVRJDYJFt3AHD9m3BVgQWujuJqIcR7x/8mUCaMV/RNRU1gEipE+VW+G1dmySn
	 48kk3iZhjrHjlVlEbvZ+GWYqlEkGpR/oWXeaiaoESkjYkjFzAzHFoZJcuC5IHlhM3svm7
	 bBBCrskibqkYXGj0ZOhswhdJdxS8C6giYdmR5TpOSQSKQSZaLEPwk/cBO9bTKHTCZdvPv
	 +jKoX6gZRbcSUUz2SiKpJe82/3iuBzWugth2NfcJBRVpdySUIuWZ0u2SdYtyk2x1JPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="Upl/FYcM";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.23
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C55606A335;
	Tue,  3 Nov 2026 17:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03C55606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Upl/FYcM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJ8rdtZxhw/TdQ1QfrlzLLro/EKmUIhpLkERcUvDlNR/eq6opY8BqKz1N5VtyuKQhiBcfIcJU2HVneeU7h6p2cjcsLotpFm7WUGLq0HRx/I36mdXLCx0mntKglhHAgyPQssA9TIH5tiuWH1k0Zv4dF7oBPvJK4SQdMoXzcXDMRZZJMHwondXQYXptiMiy7UdAse6cDmkQcD2y2ZwSRtvi+STFSRvx4f7H2NUp0OiH6tPc9rFhmq4x1wyGxi238Eq9lIxAkFML6P2/zUv/roBbS996quIrAjGI5mAvm1r1n93u3mGFrYYC47iRAw8ePIYgvlpjv2UynaJE6VauqpvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1EbrKGwU22KC4I63lhP6IP+9gmG+kZzJ2jKemMbUCk=;
 b=MoGNRqkNUZtLNedrDMEwFUEV6/ccwpjZmbZRLPIon/KpWBOwWoLguiPprzh5K/WpKFfL3Eu9+AzDmYb1hqKZZS4EwwxIVPf56w2sJTs8yxbNoNI7YOYpMiNjW5bP9PCE+BMv+pBw7EcRonjh3mW5cd9K1DeH7pGqM9XCJh6ziY183+ryLSgfzBKEL6TtHRKPw59llaJuhNPcdEq4IrAJmdzs2ramyFypmJhkwm+z6U0w//EpkNQV6kylwlHPNplmGcZX5HSLU8p68hTMmCQCNXMEIUnxYxGBHHPCgz3QZf/IAxuEJ3JSf+Kxz9rIlkfL9B2jyOMbmW52kEagxOliDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1EbrKGwU22KC4I63lhP6IP+9gmG+kZzJ2jKemMbUCk=;
 b=Upl/FYcMYvGNyTvD/M8/RsQgXU2E2WPbVcqEuDAcskogW7lWzSeANINPOLjKXZoe0qtgzJwwn2y8o8TPQBaqx9CptO3LBNc7MVNtMrDBewNSIMEGxmRoDNziZAeP6pT1TAbhoxFQ0nDRO+hQPu54wsqnNGwwvK0JCBhDatJIkF+VQ7U1att1gujOOCXmWrqHg48QdRRUhXYAFT/h4NGZWoSxwxocOf3xFe32GVhsZTgf1NtkTHA6gAE38z9cBYfl9Q2nT2sC3AhURv7qSiY4kPZDV6X76VcAgpy8Gm7X5uT+Nt4sCIuZK48b1QxGMPcKobd7XU4qTUOjCTpziq92eQ==
Received: from CY5P221CA0144.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:6a::8) by
 PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Tue, 3 Nov 2026 17:13:24 +0000
Received: from DM3PEPF000265AF.namprd02.prod.outlook.com
 (2603:10b6:930:6a:cafe::7d) by CY5P221CA0144.outlook.office365.com
 (2603:10b6:930:6a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265AF.mail.protection.outlook.com (10.167.23.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:51 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:50 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:46 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 12/15] net/mlx5: E-switch, match master egress rule by vport metadata
Date: Tue, 3 Nov 2026 19:10:06 +0200
Message-ID: <20261103171009.563034-13-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265AF:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: daec7b20-cbfb-4e7b-6be9-08df39cdc45a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|23010399003|261102123227099003|56012099006|261009223027099003|261021123027099003|261021121427099003|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	G/ex8a5hWGlDUt7dKk5VDCEDybyZQ7NtwD3CvMrKszOo93PTA7QhW8KgcWuw24CqEtu4RvE91B7Y7FDE+sx1eGSWCTi7Rw8R2HIgeYvcunn7JTQOTjS939aOV+ZBQbYVmsp6A69oFY4+eykWy+uQiO8nGjtW4z37N2HvEw1UF3n1k5F6wXl8ZCdU6NY/7/UDKnrC97+qD0oxBM6O9fB1QzMwLf5j+dL5hAoqpup8Lq7i7G5iCKAiYcS3GjYlqbQ8n/cT5nLdjIx5OEgjnBXdjSDIgikVhYAlLpRZCk8DlbSM7iP8Z5XxWfueu6eiexTt5cEkVwG5UIeX4g8Qgp3ZaLUK7Jku4IeJMNuxUL81coPJmiIJXq1f1sIxcU53baeJEjRfPIF0RNc8TQTliRYfReef6L7LEADLEIco3s6Y7daJvrSi3PBISC7yfEn4IqFGtEfxquBBwC6sLOUWLY0MPDw8qb/Igqdidolt2CPiIW2/iUXtBYDcF6G/P0XnjeMsAHCJ/GDOVrPHCEMezUhRblDwMXm8sJiCjo8xtWw5xWGDQCPvPzaCF1FhKf2RkocCTzZ0FaergDeI/H3vtxTDWKX7L+EPvdB5g5hhgKfeS5OSy91DVsjYSZnaAh8wR8ChIeO0O7mcq8Q0eBzR1y6P0dhRBLlexpKiIIvqxgBt3xn7aITrLZQKVrF4jRaKicpAPKRTTSe+cqJpSA9YqnsFHw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(261102123227099003)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MiM0gmUTLmrqc5ou9YzJzu1OSAxB/el5C+c1SEcrBRiFP5gX/EO7IchDDP2PDqPIMxtB9OYJNTfHafemDMrzg90QDTo5Ww+l1ER0CMXo8JZMlwtxZkYvXph5EDEf6T4TDmiWxOLj7E5v8hmuBHA47gMAJkZO5+gmIb+nbnaSmRCKkUFfwKBVrZ4xNuUyUSB1Z4yrZmYq7jM3gZqT4H6D25VcKWjJJSkMxlFEQo/tiGnalYxAK4lGSxMoq3eui4oAdSlVJCWqiSfbu0M0aMEYZvmTWdkftCVHzsndYSgvMOtySapsV2F5vx0j434xbSfSl5LqeQGquCgFQlR3EUMwR4zX+2lK4edU6rdjcyiqKzoJsNiM5eygVamwX+UcLXjwfhaCkbneHC/FNDoRFJ0jAQbScY6bzm4MaA7W0jK3Nyez+f7mh8mGDHUSFSsPAjR8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:23.3837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daec7b20-cbfb-4e7b-6be9-08df39cdc45a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265AF.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

From: Shay Drory <shayd@nvidia.com>

The master egress-ACL bounce group and rule matched the slave uplink by
source_port + source_eswitch_owner_vhca_id. Virt LAG master cannot match
that way; it must match by vport metadata (reg_c_0).

Virt LAG only supports MPESW, where every uplink has a unique metadata.
Hence, use metadata matching when LAG is virt LAG, and keep the
source_port + source_eswitch_owner_vhca_id match otherwise.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 78 +++++++++++++------
 1 file changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ef1043517e9e..d633c63b309b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3000,6 +3000,26 @@ static int esw_set_slave_root_fdb(struct mlx5_core_dev *master,
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
@@ -3011,22 +3031,22 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
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
@@ -3179,6 +3199,21 @@ static void esw_unset_slave_egress_rule(struct mlx5_core_dev *master,
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
@@ -3189,13 +3224,16 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
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
@@ -3209,17 +3247,11 @@ static int esw_master_egress_create_resources(struct mlx5_eswitch *esw,
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

