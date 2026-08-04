Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB29A43F0A2;
	Tue,  4 Aug 2026 08:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832672; cv=fail; b=VL0NXdOFJMxVp5JDJYPFlVRI/oJ2VpIMaeZQ+wKrWiSuocivEs6r4rUFQVlnvURVlR8NQ1gf6bXKv6E/SPaACSOhN+X5Mn+BAfKyWXQORmHH3DLllDfqRuj7T77tuGRwTuBlT+NqWgqCWAIo72deVIJr8PT+Pkk7yu/aRmM8yOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832672; c=relaxed/simple;
	bh=iTXGvFPY4pfd9ioud/hs3HFb60fPoeKTgcA64diBHgI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pu4vzeJK2ZdXE3jlUaJyymrDKBnoyrpwWQ3fAfXFp7CTURGDJ9pcbW6cig1cm+E9ejMvHumZzlG0uY6uk1A2Q9yFxc+tMP36hJjatWlbsQms5hEZCSnc0uuiI4Jx8ol0R8Ht+eNF2J0BHrzWjBbC6Pmu3pabLZE0YNJk0LnjzYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZIgM0kdw; arc=fail smtp.client-ip=52.101.48.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZIgM0kdw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PhlV94ututl34kX5vzmRFu5l0Z8q1WyzCjLSmgPfSuHGrUjBfi0J7+PFkwNNdHVwpDcjXegFW3ayLvFgIrxWmv6i8kBqDY+8ILbqCGbcicgdpOKo13qwJ2wOU+HUaV5jTncpyyUXqvqG0iT5svxnpavjrfu3zDKh9uJd96J+YDkUcu63/adnhXu2+Px6cdYpEaYdOl02r/MCSzzmUGBbouryoHpwEAD0ARPEs3yM2XbiflK/q0QbcUf3d2R3paJJIPtIG+T8Ne0N8jP30mjrv8ewz4lllxhRc/HWTpjide+1nOFo8LgdwKeFfRGh7V+NHv2YhORv4idZTf+EzUBtIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svE5la3NzrcnVi5xhNIJXanR8uk+OS8Uz3eYI8eLJw0=;
 b=ul+BYdjNoPPq+rPHAWlgCwNOflF+JRpashIFGPLlT7WhSEcISvHQ40qFk8IPYmAWZaAvdcWs702G5EbsMeQy8EPSsiBKXvq7aB/CF2YULnliy1qLe+KOrEpH83Hw0sSUUApVzt7K6ykUxu+Nquebep2iSCFR/vTmJKQF6jvwpf6i8Q2lIwTegQGiraK4sn0p9/Ia6eYEGwiMIsTSkQKSnzY4uzHF90OTHWRR0mXRBbDqeN/RhHvEo/JUA78AotVVWp7IvwWUbWlIax7wmFUPtXHU8bMOWypG4GqGKx0B5hFJINV9ofW3CYSYGKvPoJ11+gEChfzQqpf9VqnSCq16xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svE5la3NzrcnVi5xhNIJXanR8uk+OS8Uz3eYI8eLJw0=;
 b=ZIgM0kdw+1vMjhguXdCwGCbZhsZd3qZ5/3QOIxqXtzZRPH3+GAWTI7G5yIWD1LExM9SAZdTKlA2tMzDNP0Q7yNwwQTSx2Cl8YXuFszUobSTkY4IkFNdt0rgwf02q5xwBkzRCMVCWbAo69jpajcduVzHdoVLNmEZv+m/EJdho1vTLr2e3w1SDtzegJ9yye33b2h1+Fp2lau1y5zKCuV5dLYImurRsqefqcE5W69sLws/60Jz/AxFO4Wy4GvNe5/LrN+7lKkK1r8WstP66aRS21FG57mIr52aV26qhKbuI/FqD7Rnf3qy4Oa0SDARbduh6RfUitjwwHhFhl+nWc05iJg==
Received: from BL1PR13CA0125.namprd13.prod.outlook.com (2603:10b6:208:2bb::10)
 by CY3PR12MB9656.namprd12.prod.outlook.com (2603:10b6:930:101::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 08:37:45 +0000
Received: from BL6PEPF00020E60.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::12) by BL1PR13CA0125.outlook.office365.com
 (2603:10b6:208:2bb::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E60.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:37:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:26 -0700
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
Subject: [PATCH net-next V2 06/13] net/mlx5e: ipsec: Move RX marker from ft_metadata to flow_tag
Date: Tue, 4 Aug 2026 11:35:28 +0300
Message-ID: <20260804083535.2946459-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E60:EE_|CY3PR12MB9656:EE_
X-MS-Office365-Filtering-Correlation-Id: d5154110-e9ce-4901-3a3a-08def203a7d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|7416014|376014|6133799003|56012099006|11063799006|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VAfJdv36InQxyMZ69hbjeFE7fohGzgsFyQPiaSzOrOu4zIdAW2d9rh70FlLkr3QZcM+XIYRYQFHvmVbRWTrfo3T/ZDY/cWKqmfsK1M/RLuPtFUqVo5olcv8we1JXRDKRXwPc0td1ZNtWsnlMZF9ShPWkUP9EiX54KneEYlqYNl9xSzXdyAAnmvMLvzYECHOEGFaeISA5cRQwEPNBQsE3EOwZwkp3RATuOmOK8FVJQ02+Gmy7EqYKu8aGaxB9kEIZlNLVi+etP3U/BoCO6RUTZ13eEUIDo1wVWbyPjYcuvCemy86znZxT27SyeyHi0GMYeqyDOXUUo8qJik/YFkgUxJ1rNExsQ0v7QRQ4LDaLC/WC0MuxZS3uXDBUUT+xGMgmPcabaE0Rg3lXNtaRm7sYfAnPxx0Akxvr0pYIYthfCVXc2Bv22mAR6fkSl7GWafhJ/AvaDu+eOyPCZDsrDu4GVg+nxI+5kTlkpQRxEW0EaPqfBM0CEIdNKoXv3BxLTuFH8HQ8cbVr3zmn18oGFVloYg13JAzJiGoA7B+S7CjtaNkXwB4IvDm7dRTUie9hVTXRLcj9GDL0cXp5O28FjaH+goI1B7qbQeLCVfjNOJnTsWAHKhw/X/PPAsog7RxE3QFvgSL9jTdsp3ID0aWG5BPp8/L+mYm8qZLYZ+pDtNoIjzgOiwWyLDEJp+8K49u6uc/4jPRfh06KoM3UI+pJA4nkKw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(376014)(6133799003)(56012099006)(11063799006)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Je7PNuQ3oT5E8keSIjU38mIqAz9VvyaBs6hZVx3hwBOGKAo4AtTk5E6hAN9h/cWi/yJQXHpDa6mxjvQObYK7RxGtfr9QCg15Q3JKOTUAitPAnVnoJZe9k6M+idgHeUe8suZfgRekDZcna/40MErWVt53NeOjwPlBxxCbuht/00OuZzhONA1e6xwNt5xRB3EMwOYW7Sfn7xXSZ+P/IP/OeBAXU9skSbD6BolEclH6BvTepCOfwuzOZJ8DaXbFOzHAm1pm65QtH+03gln+UlfLXvcACF1TlyVsziCHc98cvp+otNtq9mNzpsqCPUhn0tfQfZc5U8IjFi1/25JxnfGsaNDsftXlT2wpmxZj4U2eGNpnMRl5qv6NRsrO3OFwbRa08Vz6sq0dI+OcRissw6XBhaxNvcQJVKycdPoLeAZyj6TGkwJ7/Bj1p7FWDJCMortm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:44.5465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5154110-e9ce-4901-3a3a-08def203a7d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E60.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9656

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
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h  | 4 +++-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c  | 9 +++++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h    | 9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h          | 7 +++++--
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index 67f048ff7afe..8a02e8e9713d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -13,13 +13,15 @@
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
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_MASK		GENMASK(23, 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		(0 << 21)
+#define MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	(1 << 21)
 #define MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		(3 << 21)
 
 static inline u32 mlx5e_accel_flow_tag(struct mlx5_cqe64 *cqe)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f236672d3a2a..081cb2f31be0 100644
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
@@ -2099,6 +2100,10 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 	else
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	if (!attrs->drop && rx != ipsec->rx_esw) {
+		spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+		spec->flow_context.flow_tag = MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC;
+	}
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[0].ft = rx->ft.status;
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 45b0d19e735c..6dea5978a40e 100644
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
@@ -74,7 +73,9 @@ static inline unsigned int mlx5e_ipsec_tx_ids_len(struct mlx5e_accel_tx_ipsec_st
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return MLX5_IPSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+	u32 proto = mlx5e_accel_flow_tag_proto(cqe);
+
+	return proto == MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC;
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

