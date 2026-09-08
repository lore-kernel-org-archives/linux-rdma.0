Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13C2392836;
	Tue,  8 Sep 2026 06:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850467; cv=fail; b=auc9B4o3gcX9K2aFAhd7Lpotcmkf7fQzP7Kcg1GQOYTHRNyeqddvcO17moOKL/Iq+NjJDdA4aRYdtfNJ2tdmIRZoPjUQYh01iLWskR0h5A46hhVbaAXcQeos19xoHwBDUDJa9zWcQysGtDkObH/shIRlIAo9umxhxJH7FEKyJLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850467; c=relaxed/simple;
	bh=vwovS+TgiBV6rgX8sNDHyVwltNTXDnaIle5J2GIO2lE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yq20UGcW7MXrIN7HGGQTcXqfs5Vr5vwEvcO0cHB3A/TMY9R5hkVg0YYP8iduGpJE304BUsDQna4gO85dP/Ccf4u0q4lMg14SNkeZ0ut9jc1F6ejBSiIfKopKVaHXncom4Az5Xb5fOJ9K5e2+MPDKDR800ky3IL/N78rIr3SiLv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gEhKqbWN; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gEhKqbWN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSNUKwY8CX6I0lmcDS3LIWewzkz+BD900CAEZkYNYvBXdbeMmjiuPCeoQM/NMpoLhcV0k1YM0A1gE5NeCpuQZmWzt1p+UBTIiL9AUzSLBig31eTckd7gcev3pwylP0zJqNY2JzfvlyDzgJEE3luj6Tbkylu0qjz5RBjb3OV4xamuy7JG2Ask4lnfAHjkY09477k0KXwvYyPGQiSNue/Yl7wbZZPIUDCdv0lL56xnZeAD3jyGKp068DFi7TUqocz/2+hy0CmpECQbRL6rIseRZXOMHf9hjrMtZ0x6DS1J5tmxp8SU3qGap9nEW2BGPtx9sRKsn1UDezbIDLT5bYRs3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o082VsyGAhcEQvMLuK0jjE5g04Cwr5kfYV//Z6U7bc=;
 b=yDXK/I7h2yMpICnzGwPPquhxlFl7WIemuehWtZEp3vfyu/aN4WrPNg2VlrgodhmsTpG3yXXwzsXa+vFPhYit4yYYUrwREvQ0mSYSCOlnGcDa3mHtJ9IHOliOGBtitO8CHMoW2NC6aWTd2q10FC5zJutwLsdJu9NRkUfNZpOEYfukppNYwlSJ7qn8Ch/Cr6zLsst9XMAzT9UcJ5D/Kkk8usrkTOWxMGsuOChK+VVc/actcTDyF1/rNh/mfVesb3tXdmO/grodVTejK91iOe+yrPHv72JF54rNtadTUGx4tY3mzFtiK5hG6kHgNQtsGa3kvWIfwc4js0TsJY25GvMSyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o082VsyGAhcEQvMLuK0jjE5g04Cwr5kfYV//Z6U7bc=;
 b=gEhKqbWNAZdZWEZRF8gc/2bmqwaGsOl7Qt8xpCggGk+6nj6ihvpxxDTeCbkbF/OsoN32GhJqjnpK5m2KFHtu1eHpUPtufr3cZUxgb02DeUnEFGRB2XYi+JZFSxFTq8PJA1CnXAL7xwB9uyOJhRfsoR0z3PSVzjPMGg5gYyMo4aRYl4zfDGTtz8lWk6lJxK7X9iVBhAsnkRtvA72qGbAoChKf8vchi5rOl8AGTtiEA6MeWm1J1chgflwAgVFIe/YtpGdLII0k6j3O8NryBs6lYuQvhgHkCYEaNOZVrrx8rfcfFn2sdlV/eDzKDm2M+odYSqmLeqIK6XV8OxX7mnzNXw==
Received: from CH2PR17CA0006.namprd17.prod.outlook.com (2603:10b6:610:53::16)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:54:17 +0000
Received: from BL6PEPF00022572.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::9) by CH2PR17CA0006.outlook.office365.com
 (2603:10b6:610:53::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:54:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022572.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:00 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:52 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 05/14] net/mlx5e: psp: Move RX marker from ft_metadata to flow_tag
Date: Tue, 8 Sep 2026 09:52:35 +0300
Message-ID: <20260908065244.3799142-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022572:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b1d629-dc9a-4f25-0a68-08df0d760093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|1800799024|376014|10067099003|3023799007|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	kMRjm+AKez1i54RdS1iqJcjPsBAdFXKzuW2s7tH12AdPjooqu2mZ3CdzFiFyAXakS4C5ksVTgVQoi4ZnvDFySaqgj5ExjLb+vihlfgviqVS2Thb+P5xlkiodEI3xHzY3kRK5q+rzgZmgpNCGUWhPL9ahbmGT1DZv1WrseOws+5C04/P+0nzBLUsyvmy0A/UOIr49v1gn+DBsnXvGGRQInqLXXYvLoNKjS3UJT+CS7fhBaUODfDgJcdQ7F53kZs1RaSAZeOplZFmmwrWKtDGxaPNPYEqjz0JX3Fr9mDDM2jHXm/1IcSJbL8lCRWPPkk/LQNGsKfmHEm6tbvynHiQmx5YAIWgTGscUSv01blrbf66ShaMsteY+ft1iUlGcn4GZv1sHhQGLKE0RTGFwFBCiVww+XZGLMcBmpCHngYLm9V2Meih42fryDwmQm3RCH/metXua3x34hEkSt9JYL4ln9uG6JyB7hEZKVM3L6ozQuwTpRXlE+1lQO45q4rIoNBNAklHUAU9UM/Ygos2reSPR4h70B3brlxEFgCbZBTxMVWvoz4CjTws8aNVKZhidNA/A4bt/cv0PCpGIIcqbtOQ1aL4rGqINyS/DHRHMmd5sVysTztfLt0vECFMHJF5TKEB5X8hn4KFH2iFmQg67duDMndiIz4metNRllsGsFD7Y36MpMN1vTjrr1c+Tr5/OnYiWVfHsIKTTpA+wuxBrNSOz7w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(1800799024)(376014)(10067099003)(3023799007)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cSAEVSWDzAh/IzLaikaLBu7v1aaTEN03waaoQopKNFYhM72si4ifi9j9M8Diz94SqnRhlKbTj0bF+idFcpuvPs/RwFplGQnHKBh/hTF5DxfF2Gr7QseFKhxzdCjqDPZ97uTdso4m8tsSaatcmfbyw7s3y4ZsHYXGGsfeKAk+4PkLfhTFNwTg3mOHcGlRaSojTeojItNz3U9/V53NVB+k8Uj8kGszqnFXCtgGht2E1xoXcTaJrfDH8Nh+Mxrmg7MggBOdCqWFUvzV0f9eeUcd23HYAXtTmvYsVrpbUhtxjc6d8OcyX5qBkbOAfVu34TUgR2vifrVuLJEtGVisKdlzgcjcOoIs9Xq/IP2G5TQm16jXtUVS1DjV7+DskOkPQfV9aigvypzVdqHyB7A++EdgsWadYf2Sm1AVNfJuDit0AIN6qmxuNJjNXR3mE9EYCDZe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:17.4917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b1d629-dc9a-4f25-0a68-08df0d760093
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022572.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220

From: Cosmin Ratiu <cratiu@nvidia.com>

Move PSP RX marker from ft_metadata (set via modify_hdr action) to
flow_tag (set via flow_context). This frees ft_metadata for storing
SPI for future decapsulated PSP packets.

All mlx5e accel protos have to move to avoid misinterpreting packets
with high bits of ft_metadata as IPsec or Macsec. This patch is the
first step, defining a new header, bit layout and macros.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/flow_tag.h    | 41 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/psp.c         | 36 ++++------------
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    | 10 ++---
 3 files changed, 55 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
new file mode 100644
index 000000000000..b6fcd4b63031
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5E_FLOW_TAG_H__
+#define __MLX5E_FLOW_TAG_H__
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/mlx5/device.h>
+
+/* Unified accel flow_tag layout in CQE sop_drop_qpn [23:0]:
+ *
+ *   [23:21] = protocol ID (3 bits):
+ *              0 = none (default)
+ *              3 = PSP (HW decrypted, PSP header present)
+ *              1,2,4-7 = reserved
+ *   [20:16] = reserved
+ *   [15:0]  = used by other subsystems (e.g. TC).
+ */
+#define MLX5E_ACCEL_FLOW_TAG_MASK		GENMASK(23, 0)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
+
+enum {
+	MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		= 0,
+	MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		= 3,
+};
+
+static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
+{
+	return be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_ACCEL_FLOW_TAG_MASK;
+}
+
+static inline u32 mlx5e_accel_flow_tag_proto(struct mlx5_cqe64 *cqe)
+{
+	return FIELD_GET(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+			 mlx5e_accel_flow_tag(cqe));
+}
+
+#endif /* __MLX5E_FLOW_TAG_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 6cc4b9d54f6e..20d7f14fb4ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -8,6 +8,7 @@
 #include "lib/crypto.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/psp.h"
+#include "en_accel/psp_rxtx.h"
 #include "fs_core.h"
 
 enum accel_fs_psp_type {
@@ -42,7 +43,6 @@ struct mlx5e_psp_rx_decrypt_table {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
-	struct mlx5_modify_hdr *rx_modify_hdr;
 	struct mlx5_flow_handle *rule;
 };
 
@@ -408,10 +408,6 @@ accel_psp_fs_rx_decrypt_ft_destroy(struct mlx5e_psp_fs *fs,
 				   struct mlx5e_psp_rx_decrypt_table *decrypt)
 {
 	accel_psp_fs_del_flow_rule(&decrypt->rule);
-	if (decrypt->rx_modify_hdr) {
-		mlx5_modify_header_dealloc(fs->mdev, decrypt->rx_modify_hdr);
-		decrypt->rx_modify_hdr = NULL;
-	}
 	accel_psp_fs_del_flow_rule(&decrypt->miss_rule);
 	accel_psp_fs_destroy_flow_group(&decrypt->miss_group);
 	accel_psp_fs_destroy_ft(&decrypt->ft);
@@ -431,8 +427,6 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 				  struct mlx5e_psp_rx_decrypt_table *decrypt,
 				  struct mlx5_flow_destination *default_dest)
 {
-	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
-	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_core_dev *mdev = fs->mdev;
@@ -482,28 +476,16 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 
 	/* Add PSP RX decrypt rule */
 	setup_fte_udp_psp(spec, PSP_DEFAULT_UDP_PORT);
-	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_PSP;
-	/* Set bit[31, 30] PSP marker */
-#define MLX5E_PSP_MARKER_BIT (BIT(30) | BIT(31))
-	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
-	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data, MLX5E_PSP_MARKER_BIT);
-	MLX5_SET(set_action_in, action, offset, 0);
-	MLX5_SET(set_action_in, action, length, 32);
-
-	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL, 1, action);
-	if (IS_ERR(modify_hdr)) {
-		err = PTR_ERR(modify_hdr);
-		mlx5_core_err(mdev, "fail to alloc psp set modify_header_id err=%d\n", err);
-		modify_hdr = NULL;
-		goto out_err;
-	}
-	decrypt->rx_modify_hdr = modify_hdr;
 
+	/* Set PSP marker via flow_tag */
+	spec->flow_context.flags = FLOW_CONTEXT_HAS_TAG;
+	spec->flow_context.flow_tag =
+		FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+			   MLX5E_ACCEL_FLOW_TAG_PROTO_PSP);
+
+	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_PSP;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
-			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-	flow_act.modify_hdr = modify_hdr;
+			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs->check.ft;
 	rule = mlx5_add_flow_rules(decrypt->ft, spec, &flow_act, &dest, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
index 2b080c39cc37..a26faf7cfc27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
@@ -9,10 +9,7 @@
 #include <net/psp.h>
 #include "en.h"
 #include "en/txrx.h"
-
-/* Bit30: PSP marker, Bit22-0: PSP obj id */
-#define MLX5_PSP_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3) == 0x3)
-#define MLX5_PSP_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(22, 0))
+#include "en_accel/flow_tag.h"
 
 struct mlx5e_accel_tx_psp_state {
 	u32 tailen;
@@ -82,7 +79,10 @@ static inline unsigned int mlx5e_psp_tx_ids_len(struct mlx5e_accel_tx_psp_state
 
 static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return MLX5_PSP_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+	u32 proto = mlx5e_accel_flow_tag_proto(cqe);
+
+	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_PSP;
+
 }
 
 bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
-- 
2.44.0

