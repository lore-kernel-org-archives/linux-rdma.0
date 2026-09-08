Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADE3A0B05;
	Tue,  8 Sep 2026 06:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850485; cv=fail; b=Td9cUbyRHt46XtsHfzxuVon/cVqFdDlVbbH1mQJ6YU0zDZmCEGhgabWp687J/Ao0VV+RUQS20tSkjzDPNtjNUR6pPAkO+/K0rCrh/xsR8XPMKRA0IGkRdgbb20fVv4dbWTxdEvnybIUe8XKDwsnfDD/in4bjUMz5Wj70elYTx/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850485; c=relaxed/simple;
	bh=UAcf2Sp4bZGuR4voxBYWCZ7aSPtjmV8LsbRea21XIPQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vfs0GJVskSetU1tSAhocGMzTiLC2eJRN5NX4YEOqupKf9LGOfrwMLAmswPpYAibciu+I+8af9j0G2Gw999fk71zVUV5+4BvrAs6R4mPS2OLYczSOPyNo3q1/QwMF6ut4eappu9Wp8mnBFs6cGvE2uZvJt59oOGI91Cusdh1PW2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n/QXsppi; arc=fail smtp.client-ip=40.107.200.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n/QXsppi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlmMpji7HwSPpqM9+KAzkvYgV27HxlE8CQ7OU1R4alIKeJGgcrFFvf77nVgvgndttmqZrUO55eXz+FK8u9eFUIu4bX3REs5RHGT9K3Ivhj2xTcwqYD2LOBh3DP8bnWRw7czZg31tnzq7rtjTozS+63WOj1/9NP3XTU3pn0ZYxFJ6vdt+uT4RZ1Zfn91OwaGky+UzT/3jXk/1tZDE2cuEApNu0jBf0dJqXj+JTOKKhGx/z7Egq2jKTf7yPhTuLjpnGsYo09wBGJBhqYRwzpNfpHscYDCOxO9/0KcXjP9duAxttj0KnOOe+iRyfX1sYP0tHGZOApyEDHTNtGCb/pzZmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awB08ujN2Eh2PXUry1zqLh4LRGZam5mF9r0x1nWvuv4=;
 b=FAufHSzT5JWmTn1T2gufhmmFkZnQltskzMSGqNyTpB6x4pzR/KzLbreIQSvWTC0oSdp8ZBz3EYFUdrl938EFtDTqCdt2J89NJbE3a0QUomkq2BVpz1im2iVRKodacvby3FZqcYy+c807aR+eGsnEP1bFydhAUfkA2BosBk2ZcRgPhCOrgE88WgJaCpb0HUE1NHyQtAxBcAclbysaRvjSmd4clH2CEpltO6y2lNnITC4+RfQg5G4dUABOma9T9FQc/7QA/Z4LZuWyx1IwbuOKk+M2AFOq8a2TJvcScu0mQ14K0MjykzBhfGCuKLgbA9Ny7WufBWzVeeQV6vW5NOinng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awB08ujN2Eh2PXUry1zqLh4LRGZam5mF9r0x1nWvuv4=;
 b=n/QXsppiOJVqsL9H1lx4BjGI7CJ571QaiYv43NF6z+4yclVB6OhSEeDiJrUWeHZ/LCtiZGRCY6d0+jhz9l88aRrVOxiYQM62yccdOhpaTy3Z0kkZ+7z4XPIenPlC8CvR7SIrZf6RKo/XI2Mf9SXnY6H9hN1mHB+SBTkmgoJjFdEb4vjMEK2pOc+paTMF6J05/XG6xD51+R8RKk5eQUNKcHFkqVhXlWOiIwco566CaR5mhNYpEdDJDUrCk408FE06zKVOPyEoCl9z8X3O42hu48wiYMC7e0movPFtH0Lw3Ti8atyifmjL993TV3wpZ8rne3F3NJ1IXWln85/9hTPnGg==
Received: from CH0PR13CA0039.namprd13.prod.outlook.com (2603:10b6:610:b2::14)
 by DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:54:36 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::31) by CH0PR13CA0039.outlook.office365.com
 (2603:10b6:610:b2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.6 via Frontend Transport; Tue, 8
 Sep 2026 06:54:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:16 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:15 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:08 -0700
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
Subject: [PATCH net-next V4 07/14] net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag
Date: Tue, 8 Sep 2026 09:52:37 +0300
Message-ID: <20260908065244.3799142-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 18197623-9314-42b6-86ec-08df0d760b99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|23010399003|1800799024|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1VezsNlmm7o5GYUShZL1PNkrSl6BWtYWdEQtpZyJcjTQjgR2UP8UR0sLEkrYMzuyrW0vcnpaMKTkVZCQGD7fFgkO79ei16HkPTWSoMuGuefVwEnCVyJwSxQxLRggE0iWjILdRToJlQbIEj0YmCk1Qkw0X7Snd9KAcQoEcFQIagkjfIkRBd9vrjIEPzzeW8j1+KCFFGLhSngrGjhInssVaOvPjJHM/6pzHPvJO1liZ90uXyck9Qh5weOw20ARns1oHIDBhShstwLDGc21HOVnccDhOmNVCYTTbBkJIZGgR72442fCQf5xaAw6ZQUJFY0J8P0AurkKMsBx4RdDzCUEGCgASB8OlUY2ECrsbh8kalnsyHybrEQh0GWW3odjxcbPaHgiSogwUBYmxzmukZCm/uczs7ozDwkAtwLV2Z1zDgcblX/pn5KjlvKs97OSTuYcGVLRwcz4xNbJ8fUvAmCqMlYDDQiG/HxJYN6wdyd6kK9mmi2Zs3K7fU7pK0pmMrptt32nVG61gS1/ttXnF/cmh0yG9Qw0i0pq1zbQKnR95+y2X/u3b4wP9Jw7c1zeV5azj2FMduN+bTAlnVyAhBzeAH9PLuX1pQQSLKu4JO+muHwurh1qFUZpmB4ABi7XczTvgS6HTwmTFLRz9WxXm39XtLD/jCHWWx+nptCGKGUwGRW8JMccPhXLpxseKIaQWDhZDHCI6o3pPNBkyyQOdV5cgw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0pF2nqhokCUUxu6zdwGChPpeeBuLeJUtRbrVphgsF0Bh1wQCRTDACQvQN+RTCZ8C72s5jNO9OpHtyJtt65NpuNtv1xov9nlFuEgng7pNkrOebAZ4pZHWXN/Q2A25r0xJKPmQrFZpU0CKq8EHikqIMCqb4gptdmLOl3B27uh2rJ7u3hxLhe9O6RfH8DM43NvfQU2v7puR9KbM0/tM+JRiLPT/tXIkDbdxMr8xmpfBEeZVAO4hWAhN5V3H9P1+nvb2N9gBH/b2qFRV1Xp5bvfcCqs9xeoUvVuhWn0DBiYklq+RanBiZXbbHlVhNaoSgz1s0tjHnOkdskcp2JYW3g4WIRwv00Ri8AGXXI68mLfAYCcjrJt2VO8s2GzAahJuWvVokvgGfD74/LCU/dglMHwdGMfPG9q2xjEheolfM7mVrV6zBC/mM5RnfRR36X1IsgGX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:35.9979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18197623-9314-42b6-86ec-08df0d760b99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575

From: Cosmin Ratiu <cratiu@nvidia.com>

MACsec uses BIT(30) in cqe.ft_metadata as a marker to identify
MACsec-decrypted packets. This will conflict with PSP SPI values with
bit 30 set, which would falsely trigger mlx5e_macsec_is_rx_flow().

Define a new marker for MACsec in flow_tag and use it in steering rules.
The fs_id stays in ft_metadata bits[15:0].
Correct typos of MLX5_MACSEC_RX_METADAT_HANDLE and
MLX5_MACEC_RX_FS_ID_MAX while touching this.
Delete the METADATA_MARKER macro.

Set flow_tag on both with-SCI and without-SCI crypto rules.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/flow_tag.h    |  4 +++-
 .../mellanox/mlx5/core/en_accel/macsec.c      |  6 +++---
 .../mellanox/mlx5/core/en_accel/macsec.h      |  4 +++-
 .../mellanox/mlx5/core/lib/macsec_fs.c        | 21 ++++++++++++-------
 .../mellanox/mlx5/core/lib/macsec_fs.h        |  9 ++++----
 5 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
index cf30096d6a37..1b6b0b3de738 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/flow_tag.h
@@ -15,8 +15,9 @@
  *   [23:21] = protocol ID (3 bits):
  *              0 = none (default)
  *              1 = IPsec
+ *              2 = MACsec
  *              3 = PSP (HW decrypted, PSP header present)
- *              2,4-7 = reserved
+ *              4-7 = reserved
  *   [20:16] = reserved
  *   [15:0]  = used by other subsystems (e.g. TC).
  */
@@ -26,6 +27,7 @@
 enum {
 	MLX5E_ACCEL_FLOW_TAG_PROTO_NONE		= 0,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_IPSEC	= 1,
+	MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC	= 2,
 	MLX5E_ACCEL_FLOW_TAG_PROTO_PSP		= 3,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index a15a0aff292f..aa7a28954861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -752,12 +752,12 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	 * a non-NULL md_dst with uninitialised contents.
 	 */
 	err = xa_alloc(&macsec->sc_xarray, &sc_xarray_element->fs_id, sc_xarray_element,
-		       XA_LIMIT(1, MLX5_MACEC_RX_FS_ID_MAX), GFP_KERNEL);
+		       XA_LIMIT(1, MLX5_MACSEC_RX_FS_ID_MAX), GFP_KERNEL);
 	if (err) {
 		if (err == -EBUSY)
 			netdev_err(ctx->netdev,
 				   "MACsec offload: unable to create entry for RX SC (%d Rx SCs already allocated)\n",
-				   MLX5_MACEC_RX_FS_ID_MAX);
+				   MLX5_MACSEC_RX_FS_ID_MAX);
 		goto destroy_md_dst;
 	}
 
@@ -1724,7 +1724,7 @@ void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 	if (!macsec)
 		return;
 
-	fs_id = MLX5_MACSEC_RX_METADAT_HANDLE(macsec_meta_data);
+	fs_id = MLX5_MACSEC_RX_METADATA_HANDLE(macsec_meta_data);
 
 	rcu_read_lock();
 	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
index 27df72e23106..2066cb573f68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -9,6 +9,7 @@
 #include <linux/mlx5/driver.h>
 #include <net/macsec.h>
 #include <net/dst_metadata.h>
+#include "en_accel/flow_tag.h"
 #include "lib/macsec_fs.h"
 
 struct mlx5e_priv;
@@ -31,7 +32,8 @@ static inline bool mlx5e_macsec_skb_is_offload(struct sk_buff *skb)
 
 static inline bool mlx5e_macsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return MLX5_MACSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+	return mlx5e_accel_flow_tag_proto(cqe) ==
+		MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC;
 }
 
 void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index efc5167493c1..4ca3a6ded284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -8,6 +8,7 @@
 #include <linux/mlx5/macsec.h>
 #include "fs_core.h"
 #include "lib/macsec_fs.h"
+#include "en_accel/flow_tag.h"
 #include "mlx5_core.h"
 
 /* MACsec TX flow steering */
@@ -45,9 +46,6 @@
 #define MLX5_SECTAG_HEADER_SIZE_WITHOUT_SCI 0x8
 #define MLX5_SECTAG_HEADER_SIZE_WITH_SCI (MLX5_SECTAG_HEADER_SIZE_WITHOUT_SCI + MACSEC_SCI_LEN)
 
-/* MACsec fs_id handling for steering */
-#define macsec_fs_set_rx_fs_id(fs_id) ((fs_id) | BIT(30))
-
 struct mlx5_sectag_header {
 	__be16 ethertype;
 	u8 tci_an;
@@ -1757,11 +1755,10 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	rx_tables = &rx_fs->tables;
 	ft_crypto = &rx_tables->ft_crypto;
 
-	/* Set bit[31 - 30] macsec marker - 0x01 */
 	/* Set bit[15-0] fs id */
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data, macsec_fs_set_rx_fs_id(fs_id));
+	MLX5_SET(set_action_in, action, data, fs_id);
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
@@ -1778,6 +1775,11 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	/* Rx crypto table with SCI rule */
 	macsec_fs_rx_setup_fte(spec, &flow_act, attrs, true);
 
+	spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+	spec->flow_context.flow_tag =
+		FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+			   MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC);
+
 	flow_act.modify_hdr = modify_hdr;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
@@ -1803,6 +1805,11 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 
 		macsec_fs_rx_setup_fte(spec, &flow_act, attrs, false);
 
+		spec->flow_context.flags |= FLOW_CONTEXT_HAS_TAG;
+		spec->flow_context.flow_tag =
+			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+				   MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC);
+
 		flow_act.modify_hdr = modify_hdr;
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
@@ -2160,8 +2167,8 @@ static int mlx5_macsec_fs_add_roce_rule_rx(struct mlx5_macsec_fs *macsec_fs, u32
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_c_5);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_5,
-		 macsec_fs_set_rx_fs_id(fs_id));
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters_2.metadata_reg_c_5, fs_id);
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	new_rule = mlx5_add_flow_rules(rx_fs->roce.ft_macsec_op_check, spec, &flow_act,
 				       NULL, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
index 15acaff43641..b8b8b412d5c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.h
@@ -6,11 +6,10 @@
 
 #ifdef CONFIG_MLX5_MACSEC
 
-/* Bit31 - 30: MACsec marker, Bit15-0: MACsec id */
-#define MLX5_MACEC_RX_FS_ID_MAX USHRT_MAX /* Must be power of two */
-#define MLX5_MACSEC_RX_FS_ID_MASK MLX5_MACEC_RX_FS_ID_MAX
-#define MLX5_MACSEC_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3)  == 0x1)
-#define MLX5_MACSEC_RX_METADAT_HANDLE(metadata)  ((metadata) & MLX5_MACSEC_RX_FS_ID_MASK)
+/* MACsec fs_id in ft_metadata bits[15:0] */
+#define MLX5_MACSEC_RX_FS_ID_MAX USHRT_MAX /* Must be power of two */
+#define MLX5_MACSEC_RX_FS_ID_MASK MLX5_MACSEC_RX_FS_ID_MAX
+#define MLX5_MACSEC_RX_METADATA_HANDLE(metadata)  ((metadata) & MLX5_MACSEC_RX_FS_ID_MASK)
 
 /* MACsec TX flow steering */
 #define MLX5_ETH_WQE_FT_META_MACSEC_MASK \
-- 
2.44.0

