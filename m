Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012013.outbound.protection.outlook.com [52.101.48.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AFE466AE6;
	Thu,  3 Sep 2026 08:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425677; cv=fail; b=ExdbKW4mF1nFhY4LE3XLfNQDaPBoF1x6npi+KHgzuiOrAAncB9Mhxu7o/fUIu9wVqLTuOny+QJ0CYQ+N/BGT5gaz2uNPD+miKhDTC80ATl79911yjzsQZK2noEin995f8LESE5inkZVrZlc5mR6wJ/rzMEJb2O6QQ6URTTryryk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425677; c=relaxed/simple;
	bh=rBWmReSdVwZI5ijc+3QvE+SuAt8O7x42qoj/Hkv1up0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeNE6wof+Q+2DjGHYc9MnQlPUdl1On31RLtCr5110m5Kyj/Le4DULtVj5V7ffgrn6R+CoT/YFlP6U21fqiBrYZ0eBXSF0iUijpmOqigi+RAGidNdvZQlVLPRVL5ERdwVgZu/3gHIe/uTJBMryy3kDwQLgpRrmKTWjE4jtmgnxxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WwH659Nn; arc=fail smtp.client-ip=52.101.48.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WwH659Nn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA9j4c6GbG1c5F/rJY1KG1zuRK7rcRPOFddtrw+BnngS4Z3Nr8v2aSoB4W5Mt/6qC36d4DRT/TMve7ya4uFxAMpiqxbHrTW0gZc8PkZRtfqAb7fBPFne5YMpsUGr3u4Ec4ZSMyKZQRilq7gwaLTgqxh4tj0OJTFTh8mtWsP6cvwYwqn820vZhMZXoL1wE6qPXfv2w+FYpyD3C5DwM78fdgaPqQCHAOYYUwnYOmbiJQdkHKwxttFn/lyuIpPmaBmBJ9jMHHPt5n/DfWlh5L7yqgSlMOfC6PuX8umqchLNpU4j2DTK4b3Tgb+S1eypAFUbUz2B3ZNaKTVQRAkLqerJKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/doE5+9l4oz7tieVzks1j2FPEqxiziktJczC8tCNBIk=;
 b=Jq2vngY+gxhlNkp+5oUUNr1G0PWgaAMjEvmxLyZirJRCMBMjbmZPVtpROsa3Z0cQNeMUSwfc1iD59okOXAfzLTuzGo4/KYg3ix3dkyZIDk9UgQQj1/M/HgtRcRKS6MLQ0uvJjbgte32MpxebGqep8uCqrJ5u3OXcL0vRtpaedG+IqS32ucUVQfqvPgcxawUrF/tolQa2W6jpO8rOkxxGSZcmQnquON2abLAZU3XGeoPYSPQA4hxAKKlmB+/tVUT+TdrLV5D/y3qTyC4FO7pnHTp7JLKP3mmMxmJ+pWFtbDhnJ94bYJ7aSWlxEFhyT4QmZzQvesoHaSBCZCDxMxJTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/doE5+9l4oz7tieVzks1j2FPEqxiziktJczC8tCNBIk=;
 b=WwH659Nnam5RsiVRFtZKkr6gIMI0iNHKawlmGdVPyBZDL6mV12LHv+gk892ojqPNJ338El73SEjx4QswJqUld9A3+AOQHqPefGSDog0QDKrsh2d7eIkAWyU3mGTKFr1Hlbsswt7bCtsBnZrZlbQHWXjR4DzTidfQRGkuSENkpAK/gdQtdI0dqlsMzIl/FxVs/3Kpl2IyllGLEeOP3h6tUNJ7jmA7tODKlIX01o32Wz7EvpgBZ2EPnEg+gKxrSJmwYCbWm3pdP3ZwFxbPo4Yryr0P5cMP+Z0b6TuKfd/jJd69C2cZSvzCabPxNdpCYgjMhapXgc4E25fPmH0ZdBUGbQ==
Received: from BN9PR03CA0655.namprd03.prod.outlook.com (2603:10b6:408:13b::30)
 by SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:54:30 +0000
Received: from BN2PEPF0000A804.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::ad) by BN9PR03CA0655.outlook.office365.com
 (2603:10b6:408:13b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:54:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A804.mail.protection.outlook.com (10.167.245.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:54:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:11 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:53:59 -0700
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
Subject: [PATCH net-next V3 06/15] net/mlx5e: ipsec: Move RX marker from ft_metadata to flow_tag
Date: Thu, 3 Sep 2026 11:52:06 +0300
Message-ID: <20260903085215.3691657-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A804:EE_|SJ1PR12MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: a28f014a-13ca-4792-6053-08df0998f728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|7416014|376014|18002099003|6133799003|22082099003|3023799007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	IC5N9Hp/SbFlcVEHmzYiQNGPsdRQqkwf2YqD8/P13zYQzUIgZ2bTKpVIYiTJSyW4fJMCQGkvCpVg4LjZB6Kz2SEjbHN5jbAqyf6Ckhvc6qcrgF9d+7jF6ipAJG84/qwALOPfMa7aStR4nICn0K8gZVlvmquJs6bfpIGdjUi83RIcnbBsAOGIyZmwUZAErabMpX5rNX87r/OQKWzmAt4ibq8I+50lSz5gCXlCApEMLiQ33htpZVhMa0q6UwRtfX+tOqstF/me/PrDDySI2AVAeMO9bPk/yZWkKX3YAehxW/i85rz2suLJqR4xTvo7RXpQ0bRCGJUIuxN6ejbIEQRVAXTghlNxYMW+gE+Hp3LjsjxaImatBQodaulP8j/OUk4+djuWGYf0x6PlnR2+0ldKIraU/az/Im7sMsBHg9uTJia0KsnRIsmESzCsHOVopdv85d3AB6LWxAL+CPlUs5DqNTCn3yHfLQVgzTbiqDZCFSVGmxEL5CVE9cwjFLqljTTUR5sFcb6VcedAyjlB5eW2GMtKi3Oioq63azmT5phaPfAzgx9jw/AAaJ5m8k08/evLqVJGWvaPSZUc66cqd4qFyJofWrFN7A4NvdiE5NuIN636ydOn6Z+ujsb15P+XOHNwIK/mago2T6EG1YtlmgMKUxsL0sORCE8at9VvnpyAebpr+GGOPrWMCdDGvDxFeQn0Tziz7lZq4IWbfIEfWbPz0Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(376014)(18002099003)(6133799003)(22082099003)(3023799007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WqAADZLuFgVPwoM40E6xmYbjhGrDeKRrzm4DBeSb+SVxjnhVCJxayQp93u6s6WBOK0Lz2qQFv3C0Yp2jL5y42qrje0z/ODcdiW9Z2egFHHBczXk7YS46kyL1KTXprOoxtyD1RBqe24yjtG2VcjzPEt7OUxSBfTZM3iNUMw9y1uVHqK2kWQYJxgrjRWGX4QeR1Voe9gH4ReKPR9We7pkl+Ofqu1+YTbpQjmOU6Z6GgcJOKe3wOYt/MjR/9PMBF+Xt+fwFR2TA3tY8WNCbjJls3EibRZrqPmqlIe0TaiyXhuqeOfezrNgG+aj0kV2fwH/XOeMIt4mmHs2nHF0eDpNhaQQsowrO45g5PTo9/LS90gXVzk62ij3vcohYSTbzWbu8XzfZbRa89X0xY9vn92vJgntvP8Gtb19KkXf5KaEcp3V9p90WwECeRrBILg0805f/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:54:29.4714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a28f014a-13ca-4792-6053-08df0998f728
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A804.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124

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

