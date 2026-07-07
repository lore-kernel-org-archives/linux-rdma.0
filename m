Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3C541930F;
	Tue,  7 Jul 2026 13:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783429904; cv=fail; b=myWquUv3+ldXYerpev2szKJKO0CsgElu1HrOvebe96E055/FDI9rOkpRN5XHcqtPF3hnq1LCcnA2/czHWOEEBV0i75wL0hJjhyuxRm/6E3Va2xGlYBIzy/M2S+EPLyaW2nout0LOf12XeDkFNShV3GoXbZ489bRz1rNgVTtQLiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783429904; c=relaxed/simple;
	bh=juVS6j5XXofW3FeLAKDinnT53PehN24XV8YSL+2us8Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nx4uh0t8kV2vaYiUKF0fsj/6ZIKwnNbyNSalsU2mzmbJ+sNJ2cdV0MQZEV/pyhC989XPiG2/UogDB+Qt/Yixd4zNcUC4JjO2G5ObxsjOUyBUMnUWIswkfqU6nMCmV3/Xe/Cjzvd1dnCkXsIP+q8yhSGDPb+Lzx1J7+lOG9iahGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MXtqcbJ4; arc=fail smtp.client-ip=52.101.43.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MXtqcbJ4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xx5PwhfWAqhTnYsBEh400yUlmybZ3ILlXPEbhH8fo7AFFVZdY7bBZgSDQfGDdaewR/26PrUCRkuu4In1S7iuZcCBftsWD2G2gaZojnQMyb95eq+XSwcf4BCBAhig5h4HwPwWb4TaY1Dq+PY58Vboa/cbzEAzLbiQfYkPRbXdotEPy9dGTOEOKg5mhVEm7TOoT6hVM7ZeXsswVI3Umuv8seOBA5VXHO9xWcO7XANBF33kn0szZBvwke78rwKVlcMFJdCedBoW/z6OFeBfFBAecHRgpX8k3kFdvjYwHyVQDzl4v2+A283oF2yISHC5n0U2Tp1B/WnBeGuhwEGdIda6Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hKdzpfi3tYdymiRmrljHBFXO2GhaKCUJirEfXZ7PCo=;
 b=yu51x5OHvOEADegP5ZFcUygVFUblTaxXgVAhD7OixadZKGewfjnQRFLGriEATVlPYbXwQ8LeqZbQlUSTgUFJgVUTPgrwjB8DWOFICBfw8trTiD8sNjp3t7QFnDa3dN1JRELYvtRdJnBLAOXOwls0my23xnIyvuHvycXrcZDVrvFPsomuJmR5r4cuok+C4/nP2rPoGGOD+OYcOyaUPIvp56e8GV14VPE1fATKW0xH41ZDqlncsUylrZEuaiH8Q5O+WIQ7gdGfMtaaB8NY36E0eGp8ltBGdtnoVEDi9hXXXFr1kLJKCYqTebL9eqA+VkOiAPo0IB87N2ATpLVjcjqvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hKdzpfi3tYdymiRmrljHBFXO2GhaKCUJirEfXZ7PCo=;
 b=MXtqcbJ4rGu7cWi7C0KMiJ+QM136OU3gPVeiGRlV/CGnthbUUFIM82bhO0Kv4Mn7N29OUrIqiDUlJ9FOLiCdtr8YrC2GPBa2kZHpvHYh3MEkW3zePEpP9NaOsiKjlzdSH+k6nZQyC3uf9/rtQ/4XYGooexqsumo7Spk5V91dfgqWVuCAhLxkyqTKMi4HP4jVUDGfFWx0ywTOLfNC3srZmnA6ryybGxKqS07xi8I0A2ikC2IOz/l+4L21G5OYF7QIK0pMNylpbBlEqX5CRlKBEVbNV8OXPXm4drc8+AQlM0e7c2+FPdK5ezvzlekRuHjnpCpOLcpkoTO2VUrxuQ/9vw==
Received: from BL1PR13CA0443.namprd13.prod.outlook.com (2603:10b6:208:2c3::28)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 13:11:37 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2c3:cafe::4b) by BL1PR13CA0443.outlook.office365.com
 (2603:10b6:208:2c3::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend Transport; Tue, 7
 Jul 2026 13:11:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 13:11:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 06:11:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 06:11:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 7 Jul
 2026 06:11:03 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Boris Pismenny
	<borisp@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Jianbo Liu <jianbol@nvidia.com>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 09/15] net/mlx5e: psp: Adjust rx_check FT size and use a drop_group
Date: Tue, 7 Jul 2026 16:08:52 +0300
Message-ID: <20260707130858.969928-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260707130858.969928-1-tariqt@nvidia.com>
References: <20260707130858.969928-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eebd457-e168-4375-d83b-08dedc294583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	tibeAspP8pzWXhG6L7Xd0SwZyiSirMISXZYrUqkeimS4CI14DCFBYEq8jXARvoi0AladkZCwibj2cr0QSXI198hkdcmwS1xSGfvipgvT40N9Rppolqmj8tFFnJYKbAKYvsRuy4kp4WVo+BCQsGwCHX6DzSpc7iSADke/YRtw2+ifQ4oMW80hw1ByXNThjNmtkjhpr2dNOqVdUHdaNhcxrKDo7OT/4JmUxE1fKuDGDAnnfwrFb37f6MvrqspzaQrmDWIaSnJVNN9VHMIqmseYiLjR12B1FwmnblbBtLrqQk4C0tPERg0tAAtVpyQf2+uXiuToX+IIYiR2R+SZ5/ed2nQ43+uepYZCMz4IlMEcCByOzGKIuqZlftHKuEfoRbdl9/gLboIGaq4KTToLMyhxUFTO8H3Yv+Cf6TfTg6HSmdINnzir9c3KvxjDDD7Bz4pdiAsg63lhfOnKlLg8eu0nc1AzmK8hyvd4F5jff0fp0uACa34XwnlLtX2inD3iPp8B6FZ2l5mcaGFtQ8xWbIUZgu11/+zKdI42+UWSobJHAJ1cN/SfCoqu/ldaaGvUTWGT2f67jpW4SMFYNM9g2LRicppzwydEViTpZQXeVlS4ifetBFCRDRTeyy6WiAEgtCFw/sFQHz61pAlPLe9CIMZP5T/Y0t9hscFQ6gsmAEvJ25x4kAIJbsjYW5lQze1eSfsU
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A+OWLxlBJQHKI/Nc32gxYGFUFHxep4tPUMl+BdvdL5lfdsqTm7Hp37Za+qkzImU2Am9WT2It4cGMiKr3Br9BJAr2IGPnXx720jK43R8ZkTiVduhag8sivn1yvEGly85og7y3fw86NqkevF1hSSyT91O/TjzwKsbyekmPeZGdvSEumQIyoHpt2Kr64pHV1dgGB1vl6rs+Hu1nZv/pFHyQ6KkztOJlQmODS0YO3R4NShwXly4kw5IBboktwh1MgdvJRlMFxVq4XSnAKjdUzMhc/FEccFdrcyWNMiKDgZ0FDJvCl4DkhG6D7tJ8xTWErmRGOb1WIn9XlKadwbwa1+ZUIKUejcrTbNBzmegrs9dHH1WU34MnYXHdOajM200aomcidOJbatYhIil3rUEZVea3Pm7w+jUNuWSZecxa0lwy0WLBusCEuCaHnqVWZmpALTUb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 13:11:34.9363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eebd457-e168-4375-d83b-08dedc294583
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846

From: Cosmin Ratiu <cratiu@nvidia.com>

The rx_check ft was requesting max_fte == 2, but it created 4 entries.
While this accidentally works, it's not accurate, so change that and use
the correct number of entries. Also use an explicit drop_group for the
last match(*) drop rule.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c  | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index c83d62724ff7..f8b289c50a42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -31,6 +31,7 @@ struct mlx5e_psp_tx_table {
 
 struct mlx5e_psp_rx_check_table {
 	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *drop_group;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_handle *auth_fail_rule;
 	struct mlx5_flow_handle *err_rule;
@@ -165,6 +166,7 @@ void accel_psp_fs_rx_check_ft_destroy(struct mlx5e_psp_fs *fs,
 	accel_psp_fs_del_flow_rule(&check->err_rule);
 	accel_psp_fs_del_flow_rule(&check->auth_fail_rule);
 	accel_psp_fs_del_flow_rule(&check->rule);
+	accel_psp_fs_destroy_flow_group(&check->drop_group);
 	accel_psp_fs_destroy_ft(&check->ft);
 }
 
@@ -218,7 +220,8 @@ int accel_psp_fs_rx_check_ft_create(struct mlx5e_psp_fs *fs,
 	if (!spec)
 		return -ENOMEM;
 
-	ft_attr.max_fte = 2;
+	ft_attr.max_fte = 4;
+	ft_attr.autogroup.num_reserved_entries = 1;
 	ft_attr.autogroup.max_num_groups = 2;
 	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
@@ -229,6 +232,14 @@ int accel_psp_fs_rx_check_ft_create(struct mlx5e_psp_fs *fs,
 		goto out_err;
 	}
 
+	err = accel_psp_fs_create_miss_group(check->ft, &check->drop_group);
+	if (err) {
+		mlx5_core_err(fs->mdev,
+			      "fail to create psp rx check drop group err=%d\n",
+			      err);
+		goto out_err;
+	}
+
 	accel_psp_setup_syndrome_match(spec, PSP_OK);
 	/* create fte */
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-- 
2.44.0

