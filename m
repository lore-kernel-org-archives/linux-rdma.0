Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FFC39E18F;
	Tue,  8 Sep 2026 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850472; cv=fail; b=aQxhbDKtx8pqVw8KJcRBxHCG/VfjVB5rwKRpFq1PNiBUrmXzVzv3ulw7HSIXtsK0JPJiac6mqocapmceoBPuTuZhJST1DJziYWaJAc3F/jpRtjhookInqqSMupoGQCzY07dhBvryJjfWS6Eah1UiUlm2TQsC/y96WJUlQQ9jCdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850472; c=relaxed/simple;
	bh=ZZXRwYS6bZyHOQy+nsmwjRrtbx98v/a1RCbqvjjI4Qo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mU1G2r73zDHDZNH9HVEZ/6dNF235dtmd5lwvhkZvf7a/xC2VSSwfCDqYgVlSMF1B9LlZohDNrlVPSdpwV2XKLNt4VHDULlZeL7XbH+mxRC98oDTp7Mjs/6HO7KGyklcxDtqgVKVsLHJEN3dRQlBpWv9KTZMJULoMny7XPkcM2GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BNXSEFhv; arc=fail smtp.client-ip=40.93.198.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BNXSEFhv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8SZj+uvDgeMGYbqxmf9/EggZ9wRWLKOXy8ePhOiTjg+s8adPwiz7rToNKgEjHl9+XFbdhMIdRcm41Bgx/Aps7d9sJ458pmAoh7NFRn8+jLgBHBeqzLyH6Exdxq6XJdNPHMZHcW9LHffvQXBF9ElJi+1qW4RDlQnjcmQpgJ+lvJeiXEaue8+cATgOmRm5jrMfV0JVureA1UJ4LO+YZXErgY9p9mz8a2LqxEnb6wHbjmxx4dOS/zGz6ryEM6GZYxGLdsm7u60uUjaL6nurM4sWCtP+Bn1Ui1leHdFivjL2EcjLqXQw5GMTaAkGylcMKBZrgzPxqT2wS/mj5HKJMYeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oU55x6T/u5LwmzEXsivx1jBvw3YYRc1+hfmP07ZVkwQ=;
 b=fnXeLicjGQJRm2y5zXh0KzEYXjNAQXJoUFhCMtq6waa+I1xj3YDP/YW4GhiJ1hD220MWYkubs2GZXSu7slfIBm58B9qTVTLL97sKj/syYd2yQbufDfko4REM2WlAkv3W69D/4hEhObEqp6fD1HnmLJtDv1opK3mZe4Ax97DLEBAs3dPCTALHzNIq5sjPdny6ZLqkZU+Jmyp26E8CCqG3eqUCEkZo0gYMtTeJ0rGsoSp0lrIiEFfyIeP0lAkb8BVDi0CMY/jm0yQ2vi8tTSfUBHDDnXypf4klQkvmLdiggfJVL4laVmiziNv16CC/RSrdUbXPgz41eabdqVvT0J1cXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU55x6T/u5LwmzEXsivx1jBvw3YYRc1+hfmP07ZVkwQ=;
 b=BNXSEFhvA9C5rnEC1ZpgUUXYNYO8J0UoxtmWP6WFGoW7hS0Z3yUW17rs+HpRTP9KqvkxlF4nHa8hwqwRZruds6ztGeau72HvqkOzPX1J2E6l9OJIMVo5QkoGCWOwkOpHoazLwILYlpDmK/Mw4o0Ff7VDewVOle/7SAEs4rzr8QshDxT17EXcHKSkZKFx3cekkq+f+xfUBRS8lPeOSn+3FUq6Zb4iVm3YkLxp6fzVh0qXZfak1YplC2dQP8sG9p2D2Daj+3+2UeFvAw6WFa7fzLXmR8Qst9G7hkIIj9YKuw5p0f+w5gXL70zaSP2QVa/hXSqUfDePh9N908dDXkvUHw==
Received: from BN9PR03CA0593.namprd03.prod.outlook.com (2603:10b6:408:10d::28)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:54:25 +0000
Received: from BN7PEPF000000A4.namprd05.prod.outlook.com
 (2603:10b6:408:10d:cafe::a) by BN9PR03CA0593.outlook.office365.com
 (2603:10b6:408:10d::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:54:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000A4.mail.protection.outlook.com (10.167.245.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:08 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:00 -0700
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
Subject: [PATCH net-next V4 06/14] net/mlx5e: ipsec: Move RX marker from ft_metadata to flow_tag
Date: Tue, 8 Sep 2026 09:52:36 +0300
Message-ID: <20260908065244.3799142-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A4:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: c803559d-b9f1-465f-f7b3-08df0d760502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|82310400026|36860700016|6133799003|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+yWdILxx3xkvAZmZJAJa12ChHbIgLgTraqhHS+JSLxATxNlLIe5BFBRyZWL0KLsakg33fDn/JANTSPc336/txPJkIb2VBtuwh33oFbsnGzLhbFKitbViLFNV4qTES1etaGde/h6Tsx6onDLeyBF+oZvjkyvZpGzPh/naxnlaxyMki/5D+iDCuioME/rEH7yLtFrVlSYBdj2v2epKWRw0vcwpc12HA7D/xhjVuUaHzlt1b9KwD/9jGud7mrdiKcAfh4WYYUF7tDC7/Kvm66mWxTdKlt2cRN1tlgphcw7Y92Lphj3cdja+56C6783IFRSCjzg9H4fxPJ29bWadJSDDTpmRcTNVB6vEFhw5hosBumkF6ijIzLdFHIuofJHzOuXuo/elAEVWVmSKYhwoKVgqZDIdRpdUTnZk4NOFyXN4aSq/CVl2GkgmOmefRCExLHLL80dnoC9wbw8NMdOZ2732le+rdMleV+Sop7LUgV2J2vv4znW9i6VWP7EgwXALNRHFV2CwjHimFnBvrtbP3CzxflmI7mxDfrRFxAHznA1wzyCkkRicyLC1VqrQUxv2aDncEkaNCvo5mVS04g6pkyNQgF7vEe1ReLM544/84Ronig7XUzpr/+3O9k8qVPwIaol2qNcFx62EA6lyL+btoewIafRYRcLtUZxsrGTU6FJTl/sdI5LGiK/avKKpTmVZGxXk+KW7a16IwGEhL7Bco1EdPA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tZaerSNLoBCitrwJ+TjFdiMbOSoSt/Q5DPJaZVRs/gbi2vxTkYUZVD/bORlaCSs0yISljBjxNxzPvfaGWt10r5utrKE/B2XGMl8gjIsSEAKG0vkO8iD/3BbGL5Jt+fdVUE1+4K31WOYK/pL1y0BkSeQ4MHgaTYcoF7H/RYo2g4W9g1MfUHoh2A/2PYi5uZfoTanUhQOTpQfC2g41q5mbYRSMywRGx8FQIFCA4OxqObquuK/n4zORKMi3Bielvk2cp9MJVi3NYZW0HWQL0bqxYU6bJz2NyBHHC/P44d4tigLTIJg8V0NrKRAQMFzl/sao8+42NJMdJjdj/fI50ZwT2mOLVJPxxEmGMjuI4q4C+OY+CR1ANkz9eA0VSJ+BP10kSkbj4dNzp/j6ABwZXJTXnwqPLrSE/owUs7AKoIGGU1Z56bIK/50lzrzj+3fokkya
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:24.9481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c803559d-b9f1-465f-f7b3-08df0d760502
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292

From: Cosmin Ratiu <cratiu@nvidia.com>

IPsec used BIT(31) in cqe.ft_metadata as a marker for ingress
IPsec-decrypted packets. This will conflict with PSP which stores SPI
in ft_metadata - an SPI with bit 31 set would falsely trigger
mlx5_ipsec_is_rx_flow().

Define a new marker for IPsec in flow_tag and use it in steering rules.
The obj_id stays in ft_metadata bits[23:0].
Remove the unused MARKER and SYNDROM (sic) macros.

This is only done for IPsec NIC RX flows. The esw path uses a different
mechanism and is unaffected: RX handling in mlx5e_rep_tc_receive() makes
use of a few bits in ft_metadata to detect and hand off IPsec packets to
mlx5e_ipsec_offload_handle_rx_skb().

An additional complication is that mlx5e_cqe_regb_chain() used the high
order bits of ft_metadata to differentiate between TC chains and
protocol markers. With the IPSec marker moving to flow_tag, this would
falsely trigger mlx5e_cqe_regb_chain() to believe the chain is set, when
in fact, ft_metadata is something completely different. Solve that by
requiring that the new flow_tag proto is NONE, since only those packets
can carry a chain id in ft_metadata.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/flow_tag.h   |  4 +++-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c   | 11 +++++++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h       |  7 +++++--
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index b6fcd4b63031..cf30096d6a37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -14,8 +14,9 @@
  *
  *   [23:21] = protocol ID (3 bits):
  *              0 = none (default)
+ *              1 = IPsec
  *              3 = PSP (HW decrypted, PSP header present)
- *              1,2,4-7 = reserved
+ *              2,4-7 = reserved
  *   [20:16] = reserved
  *   [15:0]  = used by other subsystems (e.g. TC).
  */
@@ -24,6 +25,7 @@
 
 enum {
 	MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		= 0,
+	MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	= 1,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		= 3,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f236672d3a2a..5565c385258c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -5,6 +5,7 @@
 #include "en.h"
 #include "en/fs.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/flow_tag.h"
 #include "eswitch.h"
 #include "ipsec.h"
 #include "fs_core.h"
@@ -190,7 +191,7 @@ static void ipsec_rx_rule_add_match_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 				 misc_parameters_2.metadata_reg_c_2);
 		MLX5_SET(fte_match_param, spec->match_value,
 			 misc_parameters_2.metadata_reg_c_2,
-			 sa_entry->ipsec_obj_id | BIT(31));
+			 sa_entry->ipsec_obj_id);
 
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 	}
@@ -2066,7 +2067,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (!attrs->drop) {
 		if (rx != ipsec->rx_esw)
 			err = setup_modify_header(ipsec, attrs->type,
-						  sa_entry->ipsec_obj_id | BIT(31),
+						  sa_entry->ipsec_obj_id,
 						  XFRM_DEV_OFFLOAD_IN, &flow_act);
 		else
 			err = mlx5_esw_ipsec_rx_setup_modify_header(sa_entry, &flow_act);
@@ -2099,6 +2100,12 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 	else
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	if (!attrs->drop && rx != ipsec->rx_esw) {
+		spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+		spec->flow_context.flow_tag =
+			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+				   MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC);
+	}
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[0].ft = rx->ft.status;
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 45b0d19e735c..57aabd5e61ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -38,10 +38,9 @@
 #include <net/xfrm.h>
 #include "en.h"
 #include "en/txrx.h"
+#include "en_accel/flow_tag.h"
 
-/* Bit31: IPsec marker, Bit30: reserved, Bit29-24: IPsec syndrome, Bit23-0: IPsec obj id */
-#define MLX5_IPSEC_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3) == 0x2)
-#define MLX5_IPSEC_METADATA_SYNDROM(metadata) (((metadata) >> 24) & GENMASK(5, 0))
+/* IPsec obj id in ft_metadata bits[23:0] */
 #define MLX5_IPSEC_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(23, 0))
 
 struct mlx5e_accel_tx_ipsec_state {
@@ -74,7 +73,8 @@ static inline unsigned int mlx5e_ipsec_tx_ids_len(struct mlx5e_accel_tx_ipsec_st
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return MLX5_IPSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+	return mlx5e_accel_flow_tag_proto(cqe) ==
+		MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC;
 }
 
 static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index e1b8cb78369f..53b6043e33d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -36,6 +36,7 @@
 #include <net/pkt_cls.h>
 #include "en.h"
 #include "eswitch.h"
+#include "en_accel/flow_tag.h"
 #include "en/tc_ct.h"
 #include "en/tc_tun.h"
 #include "en/tc/int_port.h"
@@ -370,11 +371,13 @@ struct mlx5e_tc_table *mlx5e_tc_table_alloc(void);
 void mlx5e_tc_table_free(struct mlx5e_tc_table *tc);
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 {
-	u32 chain, reg_b;
+	u32 flow_tag, reg_b, chain;
 
+	flow_tag = mlx5e_accel_flow_tag_proto(cqe);
 	reg_b = be32_to_cpu(cqe->ft_metadata);
 
-	if (reg_b >> (MLX5E_TC_TABLE_CHAIN_TAG_BITS + ESW_ZONE_ID_BITS))
+	if (flow_tag != MLX5E_ACCEL_FLOW_TAG_PROTO_NONE ||
+	    (reg_b >> (MLX5E_TC_TABLE_CHAIN_TAG_BITS + ESW_ZONE_ID_BITS)))
 		return false;
 
 	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
-- 
2.44.0

