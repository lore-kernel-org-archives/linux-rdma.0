Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DBB3F4DC5;
	Thu, 30 Jul 2026 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403176; cv=fail; b=Cr2+bO0gAfNtz82kYBGzOcDjda6f5CSYusyt3xmu2vyQ7AfN42WAGShUOASXM3lZfoVmphzqL3TBsdjYAQsYw6TV5BjJ+K1vBW0GET0FbU7hst4117T9A6ho4MA+Z3Bz24tWSY3rIzaZLvvpiP+Zqipxg2e5Q/qCPQwTsf8Pvs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403176; c=relaxed/simple;
	bh=wi/eJJbpPsYyg3ByoR1xMrE5FcyuPC+n3Z2bOkma4fk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuBm4f68PNBkiIpz6hvH/nt+/Z7j5TK9AxxssqEvTHnQ/gFNUdoPXwqmMsNMNWWICporviZPZqDV6cuw+UgG03OKwxlDlvpUqL6k2gYsoa23PsnFX+bvymxP5w1cijr3tDblvVHRUoUaEt6m7/wLKtaBaT2AF0BzGP2KZxuAc0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XeFUeRlx; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XeFUeRlx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iykfVRKMZIyFa1X8igfEU7g5L2AVNrCOXRVjojfdS+Vmb/1gUMrRnMcQU3zXnFp703gZvld1lAw4akH1P6KZL+w5HmK2a4cbvPT4ASfWaVaaogSIu0ZdmMmxX3h4LKm7c0AQGCWVUOi3UX2n5tBcmhzPzSoDB9UfZQD6Yrg5+iL0BLPSQFFBRKe0REKR7+1HwdgBik+IS7x3K8THw5YckcZ5Im/MNneDrV1x08Z8TcnvdMY6IyfUOtzslU+MogGoB9PUg4+0N5DqsLwDibUFe6ar7ZPaRrU+oGB9VoN73QjGot4cX7HCCprGIYonKIWf48HYZYgr2BLbW2jepitB3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDSoY5Cx5kUuFiir41iinvkqHTcGqEKcMmFVWLFWmmo=;
 b=zHLo52NKNsp/Kqf8XNC5CEx9puMfDvWbGF10uqdzmqhL7R7gVL0XlO1CswYU1893WgPJpcculoHjX1FAARqT+y4j4G5+vKq7yhFD9uGNeCe1fP4+qQgwKf2LXy/8eRuR2nR4KPR60JKWtFS+0tFO5InWT5BOLNLR4bAyv6zNhw2Q9lWwxIEpc4VRjWkDVnk9MAFkNLnX5nJCBcfv0DukcPEhyzLZAgM4l20Gl34qjCP1lxxAvp+13JeJaTZxzKpiaVyJQrRMkV5s/z45tdbQ0kBNjZZz2BaQPTqLChNoNKej5n3PdyDc6m0hRGeBXaQ4VVeOHDNzLZzp123KYwQ3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDSoY5Cx5kUuFiir41iinvkqHTcGqEKcMmFVWLFWmmo=;
 b=XeFUeRlxfIjpWTbwJxJ/mJmWXT7DI/HIOZrIVQpy5cwjQnj1+h4ZyDwi2cKyatrHqQXslgN90ZvB3oVQqrXpm4v8uwGwY7PlEASDEeufVPT0T9YavCMKyafICADVUysDk88GNUaT1YpCgsJrLp8reQSJSFkuOGYk/OW52b7gxS2f0SCy0cK9zVJ2bCS8hAfeHu5hVE17yihidO9F3tFwp98bnK6AVJBxAkp7MCJpLBOYHwm+gDbw3BnGbQbPegdn4F3hFNNmJj0ikOnie498vPI8doMRm7B1lRwzZLGApvglWVfPtKFmKhVl8IgnL4Lg4KPmP1icJ9jEP7F2VCTjsg==
Received: from BY3PR05CA0028.namprd05.prod.outlook.com (2603:10b6:a03:254::33)
 by CH3PR12MB7644.namprd12.prod.outlook.com (2603:10b6:610:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 09:19:26 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::42) by BY3PR05CA0028.outlook.office365.com
 (2603:10b6:a03:254::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via Frontend Transport; Thu, 30
 Jul 2026 09:19:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:19:10 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:19:10 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:19:02 -0700
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
Subject: [PATCH net-next 06/13] net/mlx5e: ipsec: Move RX marker from ft_metadata to flow_tag
Date: Thu, 30 Jul 2026 12:17:48 +0300
Message-ID: <20260730091756.2543777-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|CH3PR12MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b24ffa8-c7f4-4f19-3f10-08deee1ba666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|82310400026|1800799024|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	8q2awHKkc0ioSQqF9YB4/adfDqtUqbFbBQaBrWsTEyJ24gp/9c/aMUFT0y7uLsG7cr0VGhziEbmcVPZIlXGvbRPHkq2e6jF8FajHQqJkGTTKbkId2yHxTDnsqCDR1hg0loUGp+qm0fp7jt2KhlIrs3jMytmD+mJvv8qQQud/pJHk0Eh0KALCgncu1UgM5TYjncmVrS7OWiMW+5+xAlAGxdoLr75u350VwMf4DFVziDuVbm93rOTUn4KQrLahgbjQzxk9WwPmK+g51F3MeGAN0/QZY5+2I8rsTVYvnpfcxCbsGQ7vMz0dYXHBoxGWTzZuTv1049Y4Xp4GC2KGttVB+XufgwDovmbfc6JZFnlb0uivgKuXQtCPWGnbarHnKIwxMPwsstji3447fHeN70y62izrw0UOsOiytnJszmZuz3l6LHrMY1BgpcdnYTNhGy7zKznCZp6/AUhKmi+KUVkOXbn1U4lLVxt1trsFmgRFpDiOJdC6dWCLpJid8ORhPyyTOKJcXGKBDjau4MgPl/TpHQYY6LS+WM9gwfz5LygIz7QxowqvgL+v5O/R+8toA/zSgSCc1+q0o2DyDYoVc/WRxsUqxYetK98NBhqt1AFMS8W17efnDJSGd3RSvLiL9vn1BghI52yb9eFiUJi+IbtQGff+dDy9tB8wgwJ6WW7dpAEYN8k9okcnTShwtuWyt9OblL3gRa1rlfueRu47OBxA+Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(82310400026)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/Fr9wKXFVsUWg7hz8H914BuKPhFiXKje1+/BlH4m5ov1BbjUOSe3SArDRZ/ijcEPLWzSHF9bFZqzxHEDDYyoX12wo/HrkbsGaHEnme0fJC+/DaBCw206C2PO08+688a5wvN1EHDIdkFJth/eXA35p0IyXVlIgqlVo/hJOcWU89mLPOHEukikZeLYR16/N/VwK37MXP037m+9BzLcleGQ+feuaulDbGRsgjd3j9Otg3n+lJEYliuf1URzgEJPf2p4irkMBYoEj/E8sNp82hsd9A2Epw6z6aP1hla+jyMe0yJu4iv918TNZRLPLV0ide+TQivscXEkk7z2u7cFkDa4ssJv3XYJiFfRT9Dpbo8h/xI57OAF0tjq+mkdr7+xJ9zV/Z/PHppkqOQP7At+UJKKrb1LD+SNXomppOXLUBkEfxGS34W6bofpLTh8YMviSCmZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:25.6017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b24ffa8-c7f4-4f19-3f10-08deee1ba666
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7644

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

