Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F80045C70B;
	Thu,  3 Sep 2026 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425667; cv=fail; b=QxBOQ1ixHn25isxo3yheS/IjlS8otMGSb3t6qQk9RkwLzWqWeYXJkFg78UyXYgAqeW/NtvL/QE33NSaKY1/L07bwTGq8bvHKlqs7ywDrUR7q/rSTbMrPMCjqGg3kobK7HZURW7TCphN9vKy82+JTdc9RtqQAlFzS05cS6i2fXck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425667; c=relaxed/simple;
	bh=vwovS+TgiBV6rgX8sNDHyVwltNTXDnaIle5J2GIO2lE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8CgUvDsEhmRW2gtYnTbI42lOJB6llJ1zMnhmpkzrXupMkWFryLU1zGYtCEITIj7pnLzShlP2KcrQM9pDSxxhhe2C9aUqNWsTL7SX8o+5PL4wwLOc0bT2pMqfbNI1Oa60mv74wr17QeXSUf+aZE8hQtRpu9xiJcEV3IZzoWkUtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EI7Viu/e; arc=fail smtp.client-ip=40.93.194.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EI7Viu/e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7PAieuK1TneXOsQ847Dz7LPZ+nmVLnvBM4ewa1YprsYe46Up4h1KbskqFHbfdeJ4wK5gCQP5XVlkuXAiM767ZiefJcB8KWWPukfcXq5005JZDuo4yNIm8KRELUho1zDvvlp6gSTNFIYcKbSdmu8ZbX5YfZ1cnJOWRd4NQbqQ/luDi/AZZL6sauOZ5kPu/OU6/3Y1BhvxHc+HVx0f76qoLuERWpg2pnUJ46QZpKH0mynvN0AnI5bb+BAQhObBstjraFGjdH3BL1GxlEwUYlx7/xqGSmocWgW4kX5ZoCnEC/skgd3FfuYujkSOTJRl+QFIPrWif/sPqcsZlMxrFCwhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5o082VsyGAhcEQvMLuK0jjE5g04Cwr5kfYV//Z6U7bc=;
 b=g7omzK8osvfivqJRuu9PDs+Kjm+GvXGvi2EPhKqSEBmhTRVwDLkj2C095gxoH/FELvHwhzj3qzRnllhUb/owkBKeBLA511wtN3vSzlkW0W7RUl+hKoHhrnlKtyNvLQjJBr8FRP2qiPUTJXbF83qg6puqGtxg2XnJOzChoshnDxJ06nc7YFQ+zMOvWUMDm4vJ4h08Qiov4T9Vyq1qlL8dDCpw2fOK7lj1M9QLhZ5c2ZdCG2bmlC4g6qBDFxGzaMtxDphXac3wv7ks6fNbN6EbnjVP+MuTnh3GUfR6Oj1ddchSMn+lQ35nEdilP1E07rknMPWo8qely9TRhBehkbwnnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5o082VsyGAhcEQvMLuK0jjE5g04Cwr5kfYV//Z6U7bc=;
 b=EI7Viu/eE4mSxB19NI5OV+Xx6KQ60UeO88G0Nt5UQ7GFyi2TocvklZrj0gFn/JlhM2XyqjI+rwRfPe/SWPbSbLPewUJE3gjPzLYVmELU4Mh1cVsDrNVE+sfX84oZFnMrwLZEMjGMINpdtP11cCxZ1kq6TnjbfYFEVp8zG3EdA9UfrRI/NOwqawK8QHxB7TmPXeE6ZD3mf1N+qAKPS5UYeO+nxO3ybMboU9TAt8HVAx93Ja9E3vYz1OQjlwK6YhFyUj8DctM5Gcl2oVB5u70H29Q+T4Cn4YaOkNWA7EIqjsoHyp1wu4JrquluB4Q+bqQDYvbIVNN8ew0F0x22dL1duQ==
Received: from BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::17)
 by DS0PR12MB8318.namprd12.prod.outlook.com (2603:10b6:8:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:54:17 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::23) by BY1P220CA0026.outlook.office365.com
 (2603:10b6:a03:5c3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 08:54:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:54:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:59 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:53:47 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 05/15] net/mlx5e: psp: Move RX marker from ft_metadata to flow_tag
Date: Thu, 3 Sep 2026 11:52:05 +0300
Message-ID: <20260903085215.3691657-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|DS0PR12MB8318:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c779a8b-ba8f-4058-95fe-08df0998ef67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|82310400026|36860700016|11063799006|10067099003|3023799007|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6HEUyVJSsezXGFaoXcYJADktyC8yyUbEz3yESmy70ZFcGK0W8PzQohjrpabnq5ngNJijmj81eqLtX1BAC6pLlIzzGx3K5hUfP45sysTgosnmZXtcUfripYY9ew9MMimxk7YWloE/YAPSQT3WEze9jMdmi8PsvRf+btStQXz7lRtWDuqjfQRsmRIHx2oBvcSQWlYWQUsKzqdYDaElMWfVt2zKAyyQVnY08eZUsir+FVzfgzpHBKNH/U+RlD8/bbt5YZ8avyG+wA4YAqgqfvfrHrFsZ4adyTE0HnSc+ETpBovEX1AC+EjzdW5YsTZ655OGxeeDsEMkYE8x2POj1jJVGoAuWsrTEgaBZBXYAIefXty3Bhw6oRceYiHs1z7Gzumnz8KaCYjh/Jb+uKLSJ9oGwWLbK5klyWSXkrRWWsYCb5gW8CzR1EkbWXKC1C50AuocSWQEhMws3+TkMXTGEvr24mtCPZi1/r+AcQ5Wv/2j9uXbZkLf7L7WIdyINTf3KBQ1MK9LcTVRT6wmR0GTd/wLuYneRsfAhuZEFv9kPG/iQbdqpZ/kP1qZpO5yYfbF7Y/hQ9HU8s8DicV5CxY3OIkAsX1YtEU46hTwlXXpi6H9ylsN+jdSrQpmauihVvROj3ibP1PHQCf/Rd1i3t78q9QxnZSkOAWFZ/mn76XlC/SQpxhYnzpYYnuKxz54E/y9xiQT4z6YCR2K+ixHKXuPVt/QKQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(82310400026)(36860700016)(11063799006)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cZnDGfk4HNJLWBGdsbA4VZiw/5dsJNp5rDg3V9Z4fXUX4p/UHcG+CWH4yTaw8LOLNqsUW6g4rEVPCJ1CAYsPgb6meLKRA0e0AomeXHCkN1hBH7YA18Gg0N+Z2+ugv+STSG9y6j3HsyvEQArmzshp4HZh2j0/j8YLT3AnWdJvt9k+vh07XKFN8wzuXwrVejlhZocSYuw67VPXc5yy4T900SUeUb/IAYOx49U1uQpnZ6xClBor1qW5h/enX69NS0Sm0yoc2unRqS+E4C8pR+hUke1bnjcuif+J4GoYvVWjkRDYuTZzOZKTK4Im1tm0ibUGBP3pbm0fLcwNYQO08rxaHHseG+ObslmzrjCrNX68+bz5Z0AFieU+nZ1Wf7VeGF9F1MCtUFQsrLyA0kl9XHD9kSLp+3wvF8NGF9iApgztxEDGH/kGo7N5psk+O6XeW2Ol
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:54:16.5052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c779a8b-ba8f-4058-95fe-08df0998ef67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8318

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

