Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81A73F9A04;
	Thu, 30 Jul 2026 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403164; cv=fail; b=PSUiRLOV9D4ljF1oGV32stEpoxpOlAjJaKrihfpKsTnyy0S7RxCn5eiKfyIvuQ1QqAE/AUrrxZ66nEik56HdnGUvZK9vGCKJKRlLOxsKNjjMZu+Hu5Jjq4BcgI14Qr9YWlbxrSgc7bFRcBjtUAl7LRmoPIpOJ2aPz5fPQiH66EQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403164; c=relaxed/simple;
	bh=QMQ6SgZtjcAEDVTjNWx0BF7ZyeuPaaJ3iRHfn+zY/zg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nx7933kMJ0NgYoZJtluAPhbmEb4DmKJlr1tHNdK9Qw1/iA8Xd5pVgkc0nL1n+0gy3SxDvzcZcwXWZGoEtObXL71n23lmy6ciWPtDJaItIjU9YmGo1WCGMzyMdL9RXg/0un27IbaqBe1qpG7mWleYSm5RfJ/+cy7pL077oOdqfSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h1/dKzOH; arc=fail smtp.client-ip=52.101.56.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h1/dKzOH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ptd3FEv/6UGJBX0MFl4dAhJUgqZ+/P46z8/agsh/D+OFPD8b31kVYGWWtOUczY0foFbI+k3Zp9EtUZLD0fIXgBdndwUU6waOyWwoPiok1KW76sJ4c27gWpaH9aAKxG5xMW7dJVvkyAah5EDAeSiZmTKF8Jxx2E2078JcwLbGF0IzfnIahO2f7LF+H4ZPCis37ycNn6YbB+XkfkSt8q/9LoIknudpTT0mPYmIb2g1Mj0/7jujkq05jE6t15Npq0+J/vMpiG+LLh46/DltMtwEuQctOUPd1vXW7HKYZ1iKVEZxdeY8oobAwmpzoxHk1x1afPxA1CBy6SKY7kb5qU2BeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0T3kHu5Dxp8P1gSH1YIztIlTioNvLdwxtGqJt+SeVos=;
 b=CNT2Hzizj0ilIBlguJpV3zajFZLFgb++NUhna6XziOhk5j1tjE9CMR5gR6R8bEgXOC8KfrSsbP+skECp6fMMSv93IdNw8eydri8NQLNlDQ2e+NPB4ceTp8vTMyjIsnfzUZsGWTKStFauMqvERko36db8+83VnNYJqNzBX8LJ5DeXi4W8S7MOM2FvrGNLDEBN7VSlCnKSiY0E9LvZ7PZI/lZwGjpwr1DPyvl5eBuHj6/NdTOSil3ZBv/kUKsGIV43hylLcI3N+6/OikNwByqBwfUCBFMobRXh7j20NNLHNYDAiYT93kIOmMzJEGgZMe7ZquhtCxTFSWctc8D9LVVT6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T3kHu5Dxp8P1gSH1YIztIlTioNvLdwxtGqJt+SeVos=;
 b=h1/dKzOHwGES5nhdHsR77V357bEHwkKnHNEc6wlDpdkNaXhSsB/1z5Ym/JDiHRojVjb0LH0ERFGZfL4m8Gm1le3aRK3KsDlDbvHwNjuE2bBSYa3H+ekEGRoXis7DNjyBpMP+KCF2dEGLc0BmxJGC/4uDQPMamJJl5u0dj2OzmQuRMrpgCODMwkwWZybclr2lGY/QPwJ+BighDuq4e7IBSQZDZucp8ulCW1Qp0FWqtWxxZBaslBcm8OKsmNmmFbkVtvZtGxrGxOQuRfjOzjW5acVrHcFqkHJzTlVbFZh7DWbD2wQe7NQnJTv3wo7j9umEFIKOo1K69YOjAO51G75czw==
Received: from CY8P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::28)
 by CY8PR12MB7193.namprd12.prod.outlook.com (2603:10b6:930:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Thu, 30 Jul
 2026 09:19:15 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:930:6b:cafe::53) by CY8P222CA0001.outlook.office365.com
 (2603:10b6:930:6b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Thu,
 30 Jul 2026 09:19:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:02 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:53 -0700
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
Subject: [PATCH net-next 05/13] net/mlx5e: psp: Move RX marker from ft_metadata to flow_tag
Date: Thu, 30 Jul 2026 12:17:47 +0300
Message-ID: <20260730091756.2543777-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|CY8PR12MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: fb41486e-ef7a-41eb-8955-08deee1ba01d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|1800799024|82310400026|3023799007|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	y6betIgiQ3FUhc5HES/hq++/Sz9uJ1p4UjkcwmqWCD4SVhyFB2KefpTJcPORnnTLuByQCDQDABioGfnnmx5xS4Uksrs6JLw9Bw7x+l5ZHvkjYR6bAE2EcB8tyPIH7KwvJT9d+/9QswakoHUFuqCabMqrZYvDM1UemxjRi+ITh1c+DMjECrFrYVBF975lZD7j/FFy8PEVwQXMu3zu4LT6wiemFoufvyMtSN3ztN+YOXIlgbarBFJ+iwIQaf7AtcNfgn/vb4aBpKHb2CuXkrdCz8vIjKRP23uFCDsdW83eywLeSL9c3sM+Z/OhctCdimVQl36bPPveny+itcO5xe4/emATPP5IpURp1mh31hrncPYeWx3YRD6WPKzwWvKi8RGONKefe8qbGWFXUIjptxPp1VfiFQyrmw5o/zY+gR5oaWEjxbZg1gq7nfxyvYyrn0gd+3qfSP05Dq5jMxhDFyFkj5XqtHt7kRmycMNT8hfcvuHm/FnRvWHWxIXnbZPMp742GNLQK++IeloaRKCBQuOK9gBuLeEXsJh9FBpI67wGwBVHUzXgipaWFeG+9FaKk6qDk8Zw7hEatFBOjMD19oPaFxuaDe318MGXJBSZbmRx8QPAK12D1PWDKNux5R6puy40962cP4kOZITtP/dVg8B5ra/phFBy5PmzqfV35rEVQUtrNB6AbcU+zOov2FYJFZ8oQeaOgfcOkUQfRLOzDwJmvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(1800799024)(82310400026)(3023799007)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0WCJ3BtKvw8hb8cGzVkXSaRQ0eRh4UG9cYs3hU5c71Zsyi+6QVRTOBX9wxnzUv7NhvwsfAr0WPKqveQirwBP8/YpI+ljEuzKV/SpsFedl0LOki23dP975dKaB0L9504qIGmjPF1WaB4BLjEfES6m46Kok9N42LtSpKfD69OScw8zxdga8c5wOHZ1vB/BGojYtFa4msgJjdrxhP/v3ps1pFeYyblzRzva0dHKDVICNDNol+VNIeAl3H21UXCi6I9tlpEsl7fhP2HrJgEY2VBaAL5XiCBQBCE5aQ7Ycvgmn5d91kj5zzmDbnjCtw36q2cwgUR1Cex4a7hj+RHMsawdsB8h8E9GeKaExnZJOiCJNJQdQiMymp9wAg+2zz4DyYpmv7Jjj3Zm6oAWtGQolRJ+VW3nM8j79BIB35mMKSX0yIyCDbo4JkY+SzawJOs/GZDz
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:14.9958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb41486e-ef7a-41eb-8955-08deee1ba01d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7193

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

