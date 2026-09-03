Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96165468C39;
	Thu,  3 Sep 2026 08:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425658; cv=fail; b=kinG7jATWptgDHnt7IGPgq5qolr0e4OFw0/dTnypMiGQXBqFoT+tinuaJTdxlPzLmJ8l5UWgVAPZfOtNBfdby9kSNG6ORuzvNci3+RbXGs+NqXp7ZL+ddDiQ14ZDsusjuBfZ5DQeLUpfejb91yJiDdVPnYbIybPGWn3OQODp1Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425658; c=relaxed/simple;
	bh=qeFRiCic+mGtSPAV57nx6XrXVLjcTWxDab3n49sOJaw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2UtUUt7X1Ziemzy86rIkOiYo5Loxd5R+IzGM5vchpEkkaMcrEvzGGYmULPyR/EvHizYydsjZzzs/nDIygtnh5GN2oFUK4Rf9spgTl0ikhsD/wIIeaDE2ILv2CyDggypcJGVaEhwOKTXEVzHWdfmntVsZy+ClJ9yQrwx8swzu7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gaKjer9l; arc=fail smtp.client-ip=52.101.61.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gaKjer9l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=beYoT5XT80+mmd6SLwIBx+nHQ07oVpNsjGuYS5AkyW737Y4XlXa/uFd725e5p8uVI6Tx5dBbv/6IX6POhihiZqc7ZKc/lqpASSVYEhf6KJPuW1BFcMRlfEKsa1l4Ip1V0ya0cj3+lukf0HYlkyF5XxXSEzU892b66UGgjNEy2rioCbmHdA4sHzuwDptpWhJgOM5I6U0d8TLA12Ykl89GEpH0/kPZ5EtSXoteStlE4mNxwDgAkwu9CZ3L3hNot71PIir7hrspof/zP/GdHqL0T8IJpeVgpxEl561SIWCXl7U1TJ6bg7p0whhTkfgv8uq3riBpc+0Y7qWBaKkVLA0eHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=WbjKzHSStZffEMdiprWXveH9Z9BC5R9c+O/Psmkr4Uubac3V3g5dx7vtxOprLt073FqYY8A/eWrSYzbbuqyrf++k8W7MB/P+Zpxlh6ongnpAdVk+sl8RXHZlHVmNNdG7lKxW4vX1anju7ZpEUVqFj8ob2+mzQwemIhCP28TzQXIOygS7S0s9TMYAUtboSQ0fiqhmFc3/Nm46KGOUqKJcOE0kauyDeVlRp9m72TuuR86uue8bZtCBWbBwNrIsmKAY9tRrOHarUmTxSlpdpoMkUYCDJV9dzFU1+xMtYDigW9H+cTj0FDLxZEo06wxT+AQjzmLxuZ9BhaRPtnWpDTDWiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=gaKjer9ldpjPAHIETe5WrOyU+Rh2BYHt4XeyKbjgwUbfAZx61FeW8+Ym0n3XJgRLthqvB/y7IXzHAa+S/1Hb+rySRLF8RckjkJdG0cIlOVLvpRGNWZZ9SJbbOyZq2LznqBuxXVCz9VSS/4PwCWFLEohZFwcHpawp4w5frtZtMaD0RxBg8/d4h2QAhQCI7o+1PmI5XGCneGWmFPYr91u0J64cVXGOjK9M63YycC5M6BpH0gyTpidt+nzdZ/wGVtFyWgrRfdDYhbWm3W3AQaUvv+p2lPSMDeCSHo7IszGsyjvb0EZ+azZc/2m0WFQrKimgHWpppaPjiE9abSmhYYjtlg==
Received: from BY5PR04CA0020.namprd04.prod.outlook.com (2603:10b6:a03:1d0::30)
 by DS0PR12MB7559.namprd12.prod.outlook.com (2603:10b6:8:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Thu, 3 Sep
 2026 08:54:06 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::2b) by BY5PR04CA0020.outlook.office365.com
 (2603:10b6:a03:1d0::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:54:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:47 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:46 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:53:34 -0700
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
Subject: [PATCH net-next V3 04/15] net/mlx5e: macsec: Block TC offload when MACsec is enabled
Date: Thu, 3 Sep 2026 11:52:04 +0300
Message-ID: <20260903085215.3691657-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|DS0PR12MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cf9162-50b5-41f6-d737-08df0998e8eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|7416014|36860700016|1800799024|10067099003|3023799007|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YwSvXSwtVzvf1CPMWkpOazVU0Gx+uR48kz/78XfQ48rVxz6mB5LG45jovI62GHE7VSKbbGHsJpPB8BXBJeBkDGKBci300nppdlFIiteIYnihsPl6ugL9IMX47s33B+rbaG+ieNkA/YQ0cY7fnEpgezbELo+ad9AHA4cnkHzi7p87jLzdNSOZg/2wtMItru4PGPJJEd/lnAyzvjVe7+Zi5W3Ja946r8Sg/Lub5UBvZjdTqiUKnevYmcQ9sbiKgkwqURVmTSRPCZDjWnfu9Xv64AxH0cKy/o3ld5QS10BiVN6GZedFfoK/yBEFScN4xA82Aqsl7v8zbHt3KkxbArjZ97IS4dUMva6mz6hWkjNsA2FbJBC6IA45eVZ8a0/2DYVmm8YcsPdQwRC97Luzkjj9JexTvLcbeBOfpK8OYTPOH3xWeb3mi2fXu4Ii7UDzc2uoMild86rxS3qoInrVYAHTqUU5/k5MJWAgHxwNvuVG19oM3+GYPqcCZrMe0spW1ZRkcW3PZM8eMj7f1iv4YOmolziD+Yvn8Vo1hah416WCO93vwM9Nvr1MbPI/q7W4s2agOGdkc0r4MDzjrC12ACNi/HpDrzF0wQaxZBXf2CZ4V4mT04V9Pz2Gj2JHRLIjbDzsBPtYoJfEOLTxv8DWrT/yAKvQanHkC2cILA1UkEySTiOCrOkhME+OdirRRjoEIG4zcMWy+CgUBMGZpqk3Pf/vVw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(7416014)(36860700016)(1800799024)(10067099003)(3023799007)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zmtl3ElVHQ4EQYdcBFwRbcM88IDBJahS2z2X8mq7BqFAcDEgyarDDcR0MGXLfGq4D4jmy5Q6j0vjfdv8+xIc+Cj8Sj6PL/y6A5k/k7zAwpnezbi53QOpUV2yiZ1RiFLrT/iootbK93DEbP22HbCYCX7DGpkW+Y8eXulV/MQqxFO3IBwBEcRWmqTB4uCHBg5LGtnqt39H8jBhES/xfaAZ5TVdl5arl3Brb81t13JN4D6AYBXYgjNBpA9dWpNWVvkY3qH71UuGc6MwEX//AHGCG8lvSewdpYjekVpyxrc5jwoMm6r5Mu7vQ7sFGEmXi12J0Vn38Ibk+Zv62h+5bD/n02nSVBN0cbJ746oi0i9FepKLbsQENWnv4bRUW4BQ2q99bFhRqnS9RTZAaSsfpfa2CXjSuRLX8xm68ztAKDQVKn1yJxq7WDBDaTcbwF2CSDZQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:54:05.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cf9162-50b5-41f6-d737-08df0998e8eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7559

From: Cosmin Ratiu <cratiu@nvidia.com>

The MACsec protocol marker will soon move to flow_tag and that will make
TC offload unusable at the same time as MACsec on the same device.

This patch makes use of the mutual exclusion mechanism to make sure that
TC and MACsec cannot be both active at the same time.

One extra bit of logic is in macsec_upd_secy_hw_address(), where
existing macsec rules are drained then readded. During the two loops
it's possible a mistimed TC filter add to throw a wrench into things and
prevent the 2nd loop from adding anything, since accel rules are now
blocked. Fix that by keeping a best-effort TC block across the entire
operation.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/macsec.c      | 28 +++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index daff53ba7d09..a15a0aff292f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -10,6 +10,7 @@
 #include "en.h"
 #include "lib/aso.h"
 #include "lib/crypto.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/macsec.h"
 
 #define MLX5_MACSEC_EPN_SCOPE_MID 0x80000000L
@@ -324,6 +325,8 @@ static void mlx5e_macsec_cleanup_sa_fs(struct mlx5e_macsec *macsec,
 	mlx5_macsec_fs_del_rule(macsec->mdev->macsec_fs, sa->macsec_rule, action, netdev,
 				fs_id);
 	sa->macsec_rule = NULL;
+	if (!is_tx)
+		mlx5e_accel_unblock_tc_offload(macsec->mdev);
 }
 
 static void mlx5e_macsec_cleanup_sa(struct mlx5e_macsec *macsec,
@@ -343,6 +346,7 @@ static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
 	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	struct mlx5_macsec_rule_attrs rule_attrs;
 	union mlx5_macsec_rule *macsec_rule;
+	int err = 0;
 
 	if (is_tx && tx_sc->encoding_sa != sa->assoc_num)
 		return 0;
@@ -353,13 +357,26 @@ static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
 	rule_attrs.action = (is_tx) ? MLX5_ACCEL_MACSEC_ACTION_ENCRYPT :
 				      MLX5_ACCEL_MACSEC_ACTION_DECRYPT;
 
+	if (!is_tx) {
+		err = mlx5e_accel_block_tc_offload(priv->mdev);
+		if (err)
+			return err;
+	}
+
 	macsec_rule = mlx5_macsec_fs_add_rule(macsec_fs, ctx, &rule_attrs, fs_id);
-	if (!macsec_rule)
-		return -ENOMEM;
+	if (!macsec_rule) {
+		err = -ENOMEM;
+		goto out_unblock_tc;
+	}
 
 	sa->macsec_rule = macsec_rule;
 
 	return 0;
+
+out_unblock_tc:
+	if (!is_tx)
+		mlx5e_accel_unblock_tc_offload(priv->mdev);
+	return err;
 }
 
 static int mlx5e_macsec_init_sa(struct macsec_context *ctx,
@@ -1137,7 +1154,12 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
 	struct mlx5e_macsec_sa *rx_sa;
 	struct list_head *list;
 	int i, err = 0;
+	bool block_tc;
 
+	/* Best-effort TC block across the operation, to prevent a mistimed TC
+	 * filter add from preventing the 2nd loop from happening.
+	 */
+	block_tc = mlx5e_accel_block_tc_offload(priv->mdev) == 0;
 
 	list = &macsec_device->macsec_rx_sc_list_head;
 	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element) {
@@ -1168,6 +1190,8 @@ static int macsec_upd_secy_hw_address(struct macsec_context *ctx,
 
 	memcpy(macsec_device->dev_addr, dev->dev_addr, dev->addr_len);
 out:
+	if (block_tc)
+		mlx5e_accel_unblock_tc_offload(priv->mdev);
 	return err;
 }
 
-- 
2.44.0

