Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239DF3E9C1C;
	Thu, 23 Jul 2026 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795273; cv=fail; b=IssuQIZKeO7f1tGY0hVSY2Vaa2Zwp3j2GgQfRNMzfFYbgm8jgsYUdzJrCwafvdahx+Gkq37VQ2c1yPpbXWaj1XZotIOyDHxD8Ycp0DKg3SHykBFuyAg8evboZr+OnSWi9Wkwk/TqDWsiu+XUQJcPtGMKvMG9kxAiOt2KhtoBTFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795273; c=relaxed/simple;
	bh=b+5nVri784yITZLIWV8GML4ZnCrSc4Eqi9Rpb+dJi3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Id2Ec8i1tQwjzRAXongxk1Z+9aFYG1jgA2fGfaDHls7gn67igdDyczaMX/DAln99abhnOJHOUTFQc6eR9QW06TPvZeH0pWq/k5shG+63bkYb3NsZo5iFJTXcQxT/g0h0ZZ53Omhaf613jGxGRItvyg0OOTjARwHdDTSBcCzRsDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=frtTZWRo; arc=fail smtp.client-ip=40.93.198.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="frtTZWRo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRZpv3UguRo6UidxbtAIgNv0JwdU/q7GVjlzRpRf2kNwrlizamDrMfVftmpYzaU9kEjP0wYGlB356Jj0kfoocGJ7uOFFtx9lhHFONTvU7P0TA3K1KNlskJ03SEdSqb65ApPHPORPwEzmkavR1gBmdojaqou6P5wUThUqHnuhsnTl6PapvTNs8HD/fTzMjulUttvMDCvahjT8sxw2I2K6LDJURu9AD6fv/srSwZrNZeKMz5U//fLl/hkeu7PhX90OVKEt4saci3iVQcC2ErhcGKm4d0xu80zq8NVD92USkWx+fOQ5/HsgbgYVIRjarng6OMUGA1MQ2QERaD4LxYgV1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2K4tlNZ9Ckq+fnv/Xi3pO2Lpy38kZMBWYsozJI1w0s=;
 b=FedlUiruZcgJ3ndeoqqPak+1m+Q60e61TqLV05DXZQTxBTRnzfHdMQ13e0k5J8BrfpQG8kWpRoPEOUctY7pPQyzfYgURe7a/Gx7OIGisChKmxkgt901Qligg/pvXLfpExTug/CY9LnWTgHRk0zQca4+hkI/NUNvzfjxW+8JlupHR5MYFcAW+x3X0brzIwsgy+5bnuEWRxOLdXZYmzxlxS3Ccc42K27Lw6WaaVCMz0ExVoo8Tn0n1dDF1SCrHpgnO3IhuRC0JxH/sRoWgVxgyU77uNy7CKvIyWOYybuWxclBk6Xzs7LhEVFCOKYZEl2VGjz3MIOHjLXbsQ/V+iq955g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2K4tlNZ9Ckq+fnv/Xi3pO2Lpy38kZMBWYsozJI1w0s=;
 b=frtTZWRo8NzPfmeyR68w440rvj9aYtM9scR0h0lHOP/Pa+5WTngcqgtGrFRInjtvTkvAaZ9+l1K3zW0WmQGeiU4m0s2PsgpnnspWhkX1yfopaZjtse2Rk4swMuuF0e31yYTDcjhUNrE8wR3YpejWYnNjCdCDTNO8OY0omr7wcaoJdKM+6Pir1VpoRIfSFAwQJdtqADJNzXeVg1E8mCQUt1DrpULgl3ZGs3/NY/70d+LcWfam7cXGw/NYh8kVbVhfPmYbNbDNrdDoueqhUWzqKCcq6VTOWDqLR3SEIJGHS2z+krk6BeaMPsfutaYvAL3jWWkAHk0J4dhNenaIMACGaw==
Received: from CH2PR02CA0016.namprd02.prod.outlook.com (2603:10b6:610:4e::26)
 by MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 08:27:45 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::3f) by CH2PR02CA0016.outlook.office365.com
 (2603:10b6:610:4e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 08:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 08:27:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:27:28 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 01:27:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 01:27:20 -0700
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
Subject: [PATCH net-next V4 2/2] net/mlx5: implement max_sfs parameter
Date: Thu, 23 Jul 2026 11:26:43 +0300
Message-ID: <20260723082643.1870844-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723082643.1870844-1-tariqt@nvidia.com>
References: <20260723082643.1870844-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: aca507f8-1a17-43a4-ef3f-08dee8944552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RlrXOZks7RIK57B/YsVELHG6cYp0aRhFcZ7OKW0NOtPKL7J1pjD7tMCdRqRC2v/YTVp10vUgza8Mw8nSmzcMBfhMtP8PMumrF8zml9D3PKXqOJCOd2Oue2Qydz86Svu4dWSjVtllhudxLla8P7MZkf/CJTxp4Q2uO6ZPYOl1sC9yzkwf1rFgNRyg8O5E+Jb34TyjJ8oxMQNq2LLjmPPLQrutStz42/C3UdQb2FfZ5awGBwMWOMw9DlMnzoKFl1+6MDCuvkWcffUfNlYTIhOj7+y8MqW7PxGYzmAXI2W8vZHhVjb8MGFZ52TQVZqqeCbyeDxDcot2w3o9cjf5LHjwXxlUP2DlSdXouRc9IS3NqoWHZf7wBlw3TTyHlslik1j9wbhmXq3NGtyj2KEOcus5gvHEVsGwj+9YOnhBfMPqTyKZKFIlZ7rFFHwiONPqHXpxkkFCzvhe0IKuRBsVEP4wFVXiGJPuYMKWy0WmD8pD3UbJQITxLOq8RlwbFEsie1qJKriyXr0l08t+rFyxwJQDkx9T7NmIUvagT6Ych7cSf+hmFSsZ9yJRtgkicEniwTPVJp5YjDuhqZpKEiaVA36W9RR7JmJ2WprurhMZsot03Fz1KWS7hVq8TW/batymG3azkJp/zV7iGkvVXVQbuTcZXVeBN5MyLLW1DUN1nqJGJ1n1yWzVrprGE4nPR4bj7ptnwzzkF5NMc+3QBXANVGbwTA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MJzN7w1SY0H+ivaEC7yIWzhau+QOJBYy2PyAEm5cpBlJHG9LZvpFU9fYqYFsSI1YDXik72IFXmg+w7X4QvukuTmsZ73czCiNEqUuRCUWDXHMJUmx6kEZyrme6nZzhi6UXaIFbIAuATXCa7zcqWzZTIO0L/uv4n3OdaZLuQO0j7drcnLjprM9/13PWdqvAtnJ0Sgw2VQmh/DobUNiwNGylxAaZzD55pbrGqN8PMbWetMsIu2bQaTLx2VAB9geegFYYHRw5J+Qt7QjOYQ8zU3HknLPTygOUIfbGnLoKlrE7Z7+kp8K1xK1ARZT+7rUfYpa9Fsw9AligLi5jrDeMIhRe9uwIt8vYIks4JtWZHCY12sKoQ4ZwIoyG1dDe4/Zu93U0MUmgOt8yRFBseY6MmsNf4UnzBrADPuMY6FR6H5ICq/7Ovls14dCh6fCA47ZE/7I
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 08:27:44.7467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aca507f8-1a17-43a4-ef3f-08dee8944552
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836

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
 .../mellanox/mlx5/core/lib/nv_param.c         | 118 +++++++++++++++++-
 2 files changed, 121 insertions(+), 4 deletions(-)

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
index 4a7275e8b62e..492ae0d56a97 100644
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
@@ -755,6 +761,108 @@ static int mlx5_devlink_total_vfs_validate(struct devlink *devlink, u32 id,
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
+	err = mlx5_nv_param_read_global_pci_conf(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to read global PCI configuration");
+		return err;
+	}
+
+	data = MLX5_ADDR_OF(mnvda_reg, mnvda, configuration_item_data);
+	MLX5_SET(nv_global_pci_conf, data, per_pf_num_sf, !!ctx->val.vu32);
+
+	err = mlx5_nv_param_write(dev, mnvda, sizeof(mnvda));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to change per_pf_num_sf global PCI configuration");
+		return err;
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
+	NL_SET_ERR_MSG(extack,
+		       "Modifying max_sfs requires a FW reset and PCI bus rescan");
+
+	return 0;
+}
+
 static const struct devlink_param mlx5_nv_param_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_SRIOV, BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			      mlx5_devlink_enable_sriov_get,
@@ -763,6 +871,10 @@ static const struct devlink_param mlx5_nv_param_devlink_params[] = {
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

