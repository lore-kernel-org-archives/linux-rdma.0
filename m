Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EE943CE5A;
	Tue,  4 Aug 2026 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832669; cv=fail; b=NZCa0yosSFw+Y9swluoVPugHEKF21qPr/oeXh6I88tryENB4BGktlkQwoLl29x144Uz6Nwk7ly5yh8kU0eVUhXpMJvmR4PczcaWTTc83J1AHGdn/VVFENqcu4SNiY0WyZEopu8Aq55RA77fwDXex2lZcKOSmszaZI2KWyhngw/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832669; c=relaxed/simple;
	bh=QMQ6SgZtjcAEDVTjNWx0BF7ZyeuPaaJ3iRHfn+zY/zg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2wH4+UIAdFW8vZieXWV2dX5C0LYyZSVKYJZLvNRenwuE2GSy64q1Vl4Dl45jWm31vPr/1KeXbW8RN5qKRc1FG8wxrvoP/e+lW+qu5Iu1jg6xK9KM1iogdl4kEGMNRyHBIdMkm34oyjY/b7VoqbjdCFQL508d7idYhc5TSYO3dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ieGHE6wu; arc=fail smtp.client-ip=40.93.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ieGHE6wu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsydT5zFjvMNCKdHfRwzODwDtzNdGTHzR6FsYV0SbvvsvpsvPxnCCPTAjcGzqNr4XWE2jG6gQLtSLss9TJ0+yZyPU5WAdD7OsJ7r/o4SlyRwcfyL1pgWR2X1tqA8ar/geDUy8YL9SyEvmMrRDmTRpaEkrDa9IBNwuNBQ9HD1MDN2IwWgvkwtx6meWEnBQce+SOQ7vbdl80/Vhv+bHqcXSPMNzg44prM+mlDNEom6CckrqKmhAJ0xNwga9v4gtO6s6ieW9WYNZtk2NiI9i92NOyW/1t/nU33ZrYOXUAFN3bogYlJACOBlBkmvV4BaP0D8T0bonjmGa0BjCK7BceV5NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0T3kHu5Dxp8P1gSH1YIztIlTioNvLdwxtGqJt+SeVos=;
 b=m14T7Tg1LsZPtuDctX+v5h7vh2D2sqO5DZHfZsYW9RLNFMU0QgdhyGMBr52MyYZNvuOaSCuLaXgqu5yzffr2MsmzHtpGKS5/avlGmtcFdzkty4ZxrNsQypRdIHztBVNZfu/0h9TtpIxVPAzFlhRJ1U82s46pZ4RZ3mRtn26DIc0Ev+bH5GIAdqhgvRB/bvc6ueox63URyoMj+mfFVWC2LigB29CuMxd2izLlGDqbdSp7M9GjvjQiG6oD9TdWYtFYbZ8OB/i1k5YIyMziTx8l6xi4h5o5wORz2l9W0qhqIDwvCP8Ks2Erlxsv6SOA9mby03h0JjbDy8WqRhIm5wOHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T3kHu5Dxp8P1gSH1YIztIlTioNvLdwxtGqJt+SeVos=;
 b=ieGHE6wu5Knb0RHwKW/Cm9L8A0rdMd0UxsQpazbj9DZSCfzf/e4gHFlCTdOEHWWWz4x2zob6s6UInQkLG0USW6tbTLAVKViJuSjzmR4LJKC996VvnoWRxiYoYW7tNefGtQdrxJl4VDDyJFW4X4XjGzReFnpJQM6XEk/P9e+fDyyvtw7GdqtHiyCOeG5CdynpQcUMZsG7RxMVvcBvI4vvTwCWd7RgY035YV1PU4rKwZyF5aaRrtg6MV6neLZUimu0M2H1XzAbxZYd+0PDPPdf77CMxvbuVdzou93u1q0SzB2IfqBjkGAbYhUstA1k1vgmMFJ2mJsdZTLwfri34CWNeQ==
Received: from BL1PR13CA0378.namprd13.prod.outlook.com (2603:10b6:208:2c0::23)
 by SA1PR12MB8163.namprd12.prod.outlook.com (2603:10b6:806:332::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 08:37:40 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::73) by BL1PR13CA0378.outlook.office365.com
 (2603:10b6:208:2c0::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.13 via Frontend Transport; Tue, 4
 Aug 2026 08:37:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:37:26 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 05/13] net/mlx5e: psp: Move RX marker from ft_metadata to flow_tag
Date: Tue, 4 Aug 2026 11:35:27 +0300
Message-ID: <20260804083535.2946459-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|SA1PR12MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: cb68771e-6e9e-4e94-490b-08def203a535
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|18002099003|22082099003|11063799006|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ts2MAj/5lJwBu8CVboPEccMHaGI34/gL9+UsPyMqrbyyU0dz+utxonvq2vTS1I9EfLjbqrfoq3RkImA6HQAPgwryNIxAIqhr2s5y9KEoGb43Ac7vCqmsRjE5qSzqmq4j0cqzyQaZ8A+qwmpHGVMxFNVNUZZlyEzgEOeb+GCcq0sUqFpjAk3AvcbGAInVNiyMt8eNVagkSDg4XG+dd5HiDThFjKMYLrF2JESmjIzaLShX/80LVAbUSRMkUVsVxBaG0lN5OEJOCh6AGSm899+xB2flANRCv8O44pbK4fO6050WmUsM7HqxPZpBeiHByByBvKLXEXNzmkWRoWzsWqGRXCIwVXOPX7vrSjgnz4w24C7raHCqqMdAEe0rQ22YjuJ/dQEML0ZzwPSCJzq6oq8j6shCtGsE/X97zaDBjDCQoVBs0v30ZFc24JHBjAJqHC4WEnMatHjemMaf328uBQA5Gjgo7h/aeDBUAHk9ECXw2rro5WaEMWhHOoXi05uAJRab4Mo0xgGe/CfijiKHSiGbMmaSulblOOdpXc5kiyLzw1s5quVRdnXiq2INcAvYFjyak8yKnfI+o7ZGQ9ZmoSn9kwFqVP/nBIw8py4CLkq5Qf8MxptcR2xZ3+ZN70WOdjX/GHkHbqYn4iVZw5PiB+sfojEKETJm/76yNKLEdKf+pmQwKK7FgMXtuwnGRP7mRi1sLhgaxuHui8lSue/QQIXOeA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ED2hA1gh8TiNrJ7ThARuSIKyIssl3AsPYY9U2DyguQMd2tVg6HOKdZu6gM8fKk0wIMsZngBU2p/sCDErQuUueGgUn8fp1++jWt2E8E1QPZWlORunqwIe7fjv/LbJu6B6mUZ7f7Q4t3LlfcIiEPXBWvCtJkIuntmaTmBpjO7vK3zxbO51fORYCcZB7Cj83eRVx38JG/lmYthcDXXA5a9KMI61iQArgHJm2ivx09DKZk9yqr9X5DAb9C1w7Y7r+MQGI22Qe5mlHryDeFjFuJCcM8ve+XR7SmUE1EXwG//vqptYhZ0PsrcgW+o9kwGPRVxtpd6wChNTm+Hy+C8XFcSRCvzR5kao4smPKiN4gw1gWwwd+aOxZLseDxekVfNWqgokmiuL0sMNJh7Fa/ECqh0SnO2fFUb29RBmSq+NEEFkAmUmehYGc9PGFLek+hPZsY4S
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:40.1844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb68771e-6e9e-4e94-490b-08def203a535
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8163

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
 .../mellanox/mlx5/core/en_accel/flow_tag.h    | 35 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/psp.c         | 34 ++++--------------
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h    | 10 +++---
 3 files changed, 47 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
new file mode 100644
index 000000000000..67f048ff7afe
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5E_FLOW_TAG_H__
+#define __MLX5E_FLOW_TAG_H__
+
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
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		(0 << 21)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		(3 << 21)
+
+static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
+{
+	return be32_to_cpu(cqe->sop_drop_qpn) & 0xFFFFFF;
+}
+
+static inline u32 mlx5e_accel_flow_tag_proto(struct mlx5_cqe64 *cqe)
+{
+	return mlx5e_accel_flow_tag(cqe) & MLX5E_ACCEL_FLOW_TAG_PROTO_MASK;
+}
+
+#endif /* __MLX5E_FLOW_TAG_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 6cc4b9d54f6e..ca5bb60f6d16 100644
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
@@ -482,28 +476,14 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 
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
+	spec->flow_context.flow_tag = MLX5E_ACCEL_FLOW_TAG_PROTO_PSP;
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

