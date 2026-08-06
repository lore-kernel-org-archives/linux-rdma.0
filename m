Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE23D9667;
	Thu,  6 Aug 2026 07:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786001514; cv=fail; b=ftuPOGe9nJnnqZBLFCTtm4OR492KVpgBRDZIskY67OmsFH8Ho59+I0qmQxQw9PV3yUxjTyBJlxehUjelCI5hJjrd+9E/RJijK4fFCljhAFVAqIFOLWE5UqgR/9pbTPSj8cB78QNWkuHhhJ5CIp0yRtJZR9KTT31JtNFGnornPag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786001514; c=relaxed/simple;
	bh=mNlWDmXQSQvCPDseUxeVSUWlkomWAhiCdFReSzzMKZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apfZSiBTruxjm71Iggxjbn+jKp/zGnS8f0f8F89KTl2spYwBhOZvJL5PdTavr0kzpMSbtOzSv+O+irf7rrNRA4+TZZMnyo2vAhRmrm0C/JcpmmNfl8V6KDO6t2TW3s9ujjvzq8FVDpidoTfXIO4soVjo9Jyaurh5gudGOVDTXfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KfqvtaXB; arc=fail smtp.client-ip=52.101.85.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KfqvtaXB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sa3k7+uSrRLU3yao3uHMZPwCheB3VUmP/82HB5vlhmzZFWfUKUpumzdhT5aJhOfPHHRfXHFSDC9Kyxbwu164LW61RtEgXZG6tUxNlnUwJEhoe5njce0mjRJh083LLX1GK3acF6FckcjHYXUKNln9Vtp0JWtqmS/6xFT0GGBln5znCU1u+L7hCzQkXtNw/LSqIFuVeNofR87+HIFwc5AGYSY58skl4RNeeCNjroSL8lqwhoBBInHi/X7baxfQdGxQ692Oc4NiEcTFCU8/HuVU9flo4SQcJBghnxq/34O8OQq8SazkW8utuW0YsOuQHmjpyukS60XUbf6cGufTxlsByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5iV971gij4boQVbRG2sCFbBs8h9dBYLQiUOZ9LcSys=;
 b=OgU4uOhjX883bCC8/24uLqDWHLQLV4aGIS22Lop0aeAPU/YX58em0ftOCG50i0gorp/jjRPIooUi/Tk07U821sq5EcChdfs+CR2iBxlpmWc/T74ObBACkY4F8OBHzveDYOks0Od766eJq2Z9PJnAkioSZH0Rd5TvIHLWMYjbPaQ8QgV/gRdRbjg0lJTGkun8k6seYp9jgdgqKp3es6P7/+wILd1+OV/nIJhV/zk8QgaTlOCZCfoYhGIqy26mZZJL0uqfP58SEY7yKyNmyihiUShkrCaIXSc511reC+AJBFAIQRtVitl6Dv+kts8K7myS5fZZfVH/uz69i3TUI0E98A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5iV971gij4boQVbRG2sCFbBs8h9dBYLQiUOZ9LcSys=;
 b=KfqvtaXBMnIRfNUmrdP4LQAUgBEiJp4ZBf2VRh/6fA5kKtpXn/15YqlO2USurLLHU3YnO/4BpIPyJS06up+XNByveMAHsAyghbAxFvREHiE5xGT9gtYbOBLP17JM9stL7ROP4Pm78aM06/IjIC8t0ecw4lPQtxbX9/D2x8KQabn1oB2xhe3QObKO67B3cgl+7v9lw+8+q6wMV4agEjRXTD068fQB1Vrl7qpHxQpYiN5W5mbG0ZHbD1AsnR70fi8+P3uK2b3MEjdYGEfCK7DnYioPgDN50Xab+WjLKHIeVmyPqs8EwB2aXyY/Sln0fPjFW5aD+69ewZ+A0nOXGrZKOg==
Received: from SN7PR04CA0218.namprd04.prod.outlook.com (2603:10b6:806:127::13)
 by SA1PR12MB7245.namprd12.prod.outlook.com (2603:10b6:806:2bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 07:31:39 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:127:cafe::75) by SN7PR04CA0218.outlook.office365.com
 (2603:10b6:806:127::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.20 via Frontend Transport; Thu, 6
 Aug 2026 07:31:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Thu, 6 Aug 2026 07:31:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 6 Aug
 2026 00:31:19 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 6 Aug 2026 00:31:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 6 Aug 2026 00:31:12 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexander Lobakin
	<aleksander.lobakin@intel.com>, Arthur Kiyanovski <akiyano@amazon.com>,
	Daniel Zahka <daniel.zahka@gmail.com>, David Ahern <dsahern@kernel.org>, "Gal
 Pressman" <gal@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, Jiri Pirko
	<jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Nikolay Aleksandrov <nikolay@nvidia.com>, "Nikolay
 Aleksandrov" <razor@blackwall.org>, Petr Machata <petrm@nvidia.com>, "Przemek
 Kitszel" <przemyslaw.kitszel@intel.com>, Ratheesh Kannoth
	<rkannoth@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: [PATCH net-next V5 2/2] net/mlx5: implement max_sfs parameter
Date: Thu, 6 Aug 2026 10:30:37 +0300
Message-ID: <20260806073037.3001886-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260806073037.3001886-1-tariqt@nvidia.com>
References: <20260806073037.3001886-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|SA1PR12MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 43ad870a-0ff5-40b1-15eb-08def38cc0ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|18002099003|22082099003|11063799006|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	zp3Z5HRsOyzFEkb4lZ4ryUbsXxnsJ/3PNzUglUtx0AKVaC0MqaKcVmm1zmEjsoEjxkTreqw/2haxCE/4sIfJkSUsrtXvzw+IRhrzTsJeG68kSTUJYZcPwXNmoYX3cFzPLKjQUp+Wy47GPD+lavWO10Qrp9AuVXFc0pi/CNBJkDnRX8WgMx63pnG2Ah50w7garODuchUSki1LKfa9/cv7lsgYwtArriXqBPJKqG6NnGLsA6AQF7pRd9DMZnY1anZlNZTkqzQP/mIRwciKKo1/5s64BORPYYp9qX8J5+uFrdHrm//6hBdR40sWhVR1Ha1hhBexrcdVqa9eubd5Tfx269XWwz4koT76Z/XvOg4GzDDNq72DjOpWH95P3+uLwIPEUi8XWofSF0xcCAu8ndiVd0quY54RGDDzSdNpVBNUVVI9lZvuMHiPRrrcGl+gO1il8l66z8ibTqWwJbSRw4BgysjwOeMbe7ZJOGUGz78nCqynX9KONv/3ce4vsEmk5XgH8Ie5Tx5sKhwYC3L+qIw8dPRtlm2qnPuiPLBaJbiFz0rmpg2uuS+RV/kglKS/NYLSfHOj7Xkqkx7QNC0UXihokWewRI/ncHiXbYeAe/FhayS0mB7s4sBCTyVDmWPQKELI/su9bK/9UAOKoIRBPatca9vPGnOPXsLT60EqxArsp0wCD/4GdeVh4OsiEcwJMEmm5zJVbmOrzuTXQ36YdVzTyQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5bKTvz2+tiMb3rS8eQICgfmkWgkmvn1ZpXJlOwkAAcuc4GN+ZxPzCPuPBcCBdZByrYSyDjK5vCtc7J5t58Pj+RAWpbAdIgzBCRIlUiGzEOdG5EI6KHocnI0EjwjIGYkigCLpF54MOidOt1mRsiC7DFQcw/xIXIshlo6udkhvjvBfeFUhoZfTfRz2v9pA8thVx78BDDJ/DY0esf0j5hG2QsWMbW83CvrlUvktfdFDr/2UopeJOTgUy0myma8/Toa1vp/y4Wiv6h9eX4glpQ/TaMGMTxrWwryk4aAOOk32leH37hx5Y51JrP5l5JGGQPH8hbGO5Z3wM+ClTe0iXmlsJz0TJqBB6yRiStwA8D+MZr3z0Rb8GBLptQUflSjFQ+rn5GLoQ3qv9gf+bsTwBfJWmWZLjAuLMMvOU6IlLaIWzY7D9Dnt3sw7gsPxevDgQAaH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 07:31:38.6231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ad870a-0ff5-40b1-15eb-08def38cc0ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7245

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Implement max_sfs generic parameter to allow users to control the total
light-weight NIC subfunctions that can be created using devlink instead
of external vendor tools. A value of 0 will effectively disable creation
of new subfunction devices. A warning is sent to user-space via extack
(returning extack without error code is interpreted as a warning by
user-space tools). The maximum value is capped at U16_MAX.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |   7 +-
 .../mellanox/mlx5/core/lib/nv_param.c         | 125 +++++++++++++++++-
 2 files changed, 128 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index cf1dffa67669..9421c89951a0 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -45,8 +45,13 @@ Parameters
      - The range is between 1 and a device-specific max.
      - Applies to each physical function (PF) independently, if the device
        supports it. Otherwise, it applies symmetrically to all PFs.
+   * - ``max_sfs``
+     - permanent
+     - The range is between 0 and a device-specific max.
+     - Applies to each physical function (PF) independently.
 
-Note: permanent parameters such as ``enable_sriov`` and ``total_vfs`` require FW reset to take effect
+Note: permanent parameters such as ``enable_sriov``, ``total_vfs`` and ``max_sfs``
+      require FW reset to take effect
 
 .. code-block:: bash
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
index 4a7275e8b62e..72cc8da5f119 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/nv_param.c
@@ -68,7 +68,9 @@ struct mlx5_ifc_mnvda_reg_bits {
 
 struct mlx5_ifc_nv_global_pci_conf_bits {
 	u8         sriov_valid[0x1];
-	u8         reserved_at_1[0x10];
+	u8         reserved_at_1[0xa];
+	u8         per_pf_num_sf[0x1];
+	u8         reserved_at_c[0x5];
 	u8         per_pf_total_vf[0x1];
 	u8         reserved_at_12[0xe];
 
@@ -93,9 +95,11 @@ struct mlx5_ifc_nv_global_pci_cap_bits {
 };
 
 struct mlx5_ifc_nv_pf_pci_conf_bits {
-	u8         reserved_at_0[0x9];
+	u8         log_sf_bar_size[0x8];
+	u8         pf_total_sf_en[0x1];
 	u8         pf_total_vf_en[0x1];
-	u8         reserved_at_a[0x16];
+	u8         reserved_at_a[0x6];
+	u8         total_sf[0x10];
 
 	u8         reserved_at_20[0x20];
 
@@ -158,6 +162,8 @@ struct mlx5_ifc_nv_sw_accelerate_conf_bits {
 #define MLX5_GET_CFG_HDR_LEN(_mnvda_ptr) \
 	MLX5_GET(mnvda_reg, _mnvda_ptr, configuration_item_header.length)
 
+#define MLX5_DEFAULT_LOG_SF_BAR_SIZE 12
+
 static int mlx5_nv_param_read(struct mlx5_core_dev *dev, void *mnvda,
 			      size_t len)
 {
@@ -755,6 +761,115 @@ static int mlx5_devlink_total_vfs_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int mlx5_devlink_max_sfs_get(struct devlink *devlink, u32 id,
+				    struct devlink_param_gset_ctx *ctx,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u32 mnvda[MLX5_ST_SZ_DW(mnvda_reg)] = {};
+	void *data;
+	int err;
+
+	err = mlx5_nv_param_read_global_pci_conf(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to read global PCI configuration");
+		return err;
+	}
+
+	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
+	if (!MLX5_GET(nv_global_pci_conf, data, per_pf_num_sf)) {
+		ctx->val.vu32 = 0;
+		return 0;
+	}
+
+	memset(mnvda, 0, sizeof(mnvda));
+	err = mlx5_nv_param_read_per_host_pf_conf(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read PF configuration");
+		return err;
+	}
+
+	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
+	if (MLX5_GET(nv_pf_pci_conf, data, pf_total_sf_en))
+		ctx->val.vu32 = MLX5_GET(nv_pf_pci_conf, data, total_sf);
+	else
+		ctx->val.vu32 = 0;
+
+	return 0;
+}
+
+static int mlx5_devlink_max_sfs_validate(struct devlink *devlink, u32 id,
+					 union devlink_param_value *val,
+					 struct netlink_ext_ack *extack)
+{
+	if (val->vu32 > U16_MAX) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Max SFs allowed value is %u", U16_MAX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mlx5_devlink_max_sfs_set(struct devlink *devlink, u32 id,
+				    struct devlink_param_gset_ctx *ctx,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u32 mnvda[MLX5_ST_SZ_DW(mnvda_reg)] = {};
+	void *data;
+	int err;
+
+	/* we don't explicitly disable per_pf_num_sf when max_sfs is 0 because
+	 * another PF may be using SFs
+	 */
+	if (ctx->val.vu32) {
+		err = mlx5_nv_param_read_global_pci_conf(dev, mnvda,
+							 sizeof(mnvda));
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to read global PCI configuration");
+			return err;
+		}
+
+		data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
+		/* always enable per_pf_num_sf because another PF may use SFs */
+		MLX5_SET(nv_global_pci_conf, data, per_pf_num_sf, 1);
+
+		err = mlx5_nv_param_write(dev, mnvda, sizeof(mnvda));
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to change per_pf_num_sf global PCI configuration");
+			return err;
+		}
+		memset(mnvda, 0, sizeof(mnvda));
+	}
+
+	err = mlx5_nv_param_read_per_host_pf_conf(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to read PF configuration");
+		return err;
+	}
+
+	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
+	MLX5_SET(nv_pf_pci_conf, data, log_sf_bar_size,
+		 ctx->val.vu32 ? MLX5_DEFAULT_LOG_SF_BAR_SIZE : 0);
+	MLX5_SET(nv_pf_pci_conf, data, pf_total_sf_en, !!ctx->val.vu32);
+	MLX5_SET(nv_pf_pci_conf, data, total_sf, ctx->val.vu32);
+
+	err = mlx5_nv_param_write(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to change PF PCI configuration");
+		return err;
+	}
+	NL_SET_ERR_MSG_MOD(extack,
+			   "Modifying max_sfs requires a FW reset and PCI bus rescan");
+
+	return 0;
+}
+
 static const struct devlink_param mlx5_nv_param_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV, BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			      mlx5_devlink_enable_sriov_get,
@@ -763,6 +878,10 @@ static const struct devlink_param mlx5_nv_param_devlink_params[] = {
 			      mlx5_devlink_total_vfs_get,
 			      mlx5_devlink_total_vfs_set,
 			      mlx5_devlink_total_vfs_validate),
+	DEVLINK_PARAM_GENERIC(MAX_SFS, BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      mlx5_devlink_max_sfs_get,
+			      mlx5_devlink_max_sfs_set,
+			      mlx5_devlink_max_sfs_validate),
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_CQE_COMPRESSION_TYPE,
 			     "cqe_compress_type", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
-- 
2.44.0

