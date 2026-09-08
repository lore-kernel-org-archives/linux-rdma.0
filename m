Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397F390231;
	Tue,  8 Sep 2026 06:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850456; cv=fail; b=Uk41KGl4oyK708dqYRcS8nNYb63d648MT0W0OoY8XKgmA6eXNm7ujeR96wneRGxVyWm2+35P/onY/Uw8l40KgG4RRMiyj6lEdID+wm9QXr7eSIEQH7Y+3doyC/A+/vqfwxvawEDfgLv5GNhgpjzI8sEVweZRhDF/WyYgvDLaxZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850456; c=relaxed/simple;
	bh=c/cDvudEfAtWLHMJxyIeXmIQUonuz+wLS1vdDZHwKUI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ON8b6cW2UI50znKZv5CWudaxAGYcIxMvHfssSNtmFC6Z/cLiY8rJQ+tBzROyfruQzYFHtKDVonltn8XMdJR38wO04j6H7tXXqY2cz5j+/lj5v7D8zNguzkDg0qPJ9WEodMx1waIjovNiNYf5KDZ7W1CYHv72ovJWdFolzqciJHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JKbmPaCu; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JKbmPaCu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5WBOwwnx8gjumuVQiQ6TUwOGh5TwhixlzCFdvuJGFc2iXY49cFYKdBarIV88ZotZhLLGkA0ubnEn9mDkapur6tLVD6luqYJpwr4QxYe8AhYuhBqpeUhwNAAqml6vvdNxUYB2U2y/fxK+982Dhn+sQx6PMIJ1I9O1HDTVKNKEIzQqXMWFxSOWMvfgYTvKoa7qv4MlgixiCcnXSMlUSMXhNK667+uq8Ttbch1a2fs1Wb5oa9RdtxsNGGq391sh1wnadYD4y4CJQxxKV4OZBuJRpVUCMtB8V48JLovS+2fAvD5YhlpmBS7FGrCZammmQDqKj+eIic8C6UGWlwvi8lq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhkbsKVRuq9xnJ7k97WJKvOK842GuAnnaGf4ZS2tjTw=;
 b=IGABCYyJx1lD3ayxwyjDDDOyev3Esy8FC0+6ILYMaorhgmMe8S4No5UTFZ2KKL2BIyO/r0MaewagswC/QHI80Ttgrmh3CwTFDwji2Qkz64jXQXTO/byWcJixmAVqOTXMerzPvoDNyV7vbEqOy27HJDU1yje9DKkpzr0mul3eMRkyrh0i4JM2TJCChEuwsbOqvLn8Ifr0CA7IWZ4FiEgheqOmwCl6T/bDhCQFlgr+pReKrpc89vlIzaBpj3/dBv7Cxngs8U85eJKXcJd8nkZfVAo8PVFJ40Pcjf7CvyzmCp2/H1iYiTXFhbVk56qGtWyKn9naiC+3ErrPNa2RTmVdIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhkbsKVRuq9xnJ7k97WJKvOK842GuAnnaGf4ZS2tjTw=;
 b=JKbmPaCuRBvIaV98b1wlGqga1945IfNSUlxkZD2e4zpsmhsQx6RLwidllhsVcekSytpBD9GoN7vyntS+m/sgc0Luf273T++UY/VHPWuRu/i5aKXq0SL36+YCFOwDpmopx/7AyMl2XKJhsFsFYuDUS8fWT3NIMzinzhpOZTSFUBwh6GxAGq4Vv6K0OjFAtJizYmpw0K1dx5Zfm0cny7bZvqa51CnZWn3+QrosTf7REWELUhNATnErs3bGcxEhjy8QrDHpTbrPWAkKlDhlTzUugNsaXhd7u/fX5z6UUglhfgzL2xPIWsohmvViYJ3eQPrOKFplkAVI7L8Dz9TEDh49Kg==
Received: from BN0PR04CA0005.namprd04.prod.outlook.com (2603:10b6:408:ee::10)
 by PH0PR12MB5647.namprd12.prod.outlook.com (2603:10b6:510:144::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:54:07 +0000
Received: from BN7PEPF000000A8.namprd05.prod.outlook.com
 (2603:10b6:408:ee:cafe::28) by BN0PR04CA0005.outlook.office365.com
 (2603:10b6:408:ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:54:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000A8.mail.protection.outlook.com (10.167.245.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:54:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:52 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:44 -0700
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
Subject: [PATCH net-next V4 04/14] net/mlx5e: macsec: Block TC offload when MACsec is enabled
Date: Tue, 8 Sep 2026 09:52:34 +0300
Message-ID: <20260908065244.3799142-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A8:EE_|PH0PR12MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: b6121cca-5d5a-46aa-ad59-08df0d75fa22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|3023799007|10067099003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	zdpDYWsBIZ34fMche1UK8uaLDsTEn+fzazYd3O6x1F2ZkKdCIYpgpM7FCMLTYE3Hgt3RXAJl/LJzuZ3aqbqL4NuiQwUBFzxFDAFEF75a2XnII9lZ+sPiPdxh+3Yn1xPgSwtYJpTABc2e71U5Pcm0yrMXt3BORiozB8dskvmlIQpwNRPy1Xu1GUJJHXEfC+trI0sy6Cq1E3znj+BRHPdCKt0tC5IxvIL/q0RKUD8+rdnQ/OtB9rkrJU/wfrQQRlAMrrbZLUxuLcbvAZOA7n8hLKOLESdXpZjedSjOaBskx+wZplX7joRit74Bz253gLeMp9fuhbB95c3y+Tl45FsxzhGNV9Xe9cB3pdHFUZRg/pEWgPaWbSuEKVk6xStJNJloBrV7F5lVgIb0fHEPL6kxRjmPQrPo66AWUKFl2kiHRM7r4iMihMW0yjyyaylzYi/zGBayAnsxHb0hbu+MX8zUU+yRrHg6Dox9aS015syWGrSzPYxjxfVzMgKpsrr0J3JKuZOyHS1pNbdLUZzn6K2yEhmMaf5BQhwF4xzG9mEbmt5J1fJTcS+FI2PerDFNeeD5+AvoPGBLn9X18+vqPkEQtXMrHS7lxx2SuJBowKj8e+VuTXdSUOD6Kb2MHRg3FB3G1eK5U7v1cJgkVF5EMr1XQlFWi8lRM6zJbJHx6LwRYpG7No+vtcQPqqSjag3z9HgUMyWBqCwFvPkEFlN6N15tnA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(3023799007)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EoUasMKioRHlhMwUxX3RZ5amCcMMwqUGf+QcvDX++AUlOzjU416gtTyoOAam1s4MZJoT0PsGt7GXX2XeS1ZNUzavVMl6Z8UO3a4JnlvcbZOR+EQXWIPBeZEB3QdUZthg9P0niS5bs4J/mSb7doSWhFCB+bmvgfnLTXURo4w/8hHUVCk3ADA3ruqVuFMkxPPVTiY34SlUaCtWcPaF9kGYGsgI9oNO5w7CGId2NMhk2Nzkyhb8yf+1ATuunge+RkOJ5QBnHVHlWxfWJqeLyvSEaAq9DsxGmEc83fQfZ9Ns+VxNewZS1iXNmzhqv1OcD8WJrPN/0xnjkP94gQwBE5sRwxZ3jqvVP9aR2LCFoyhE/3gWxHAwdbwyW2o0SIxPXH6cLqgmALkkFqaSJHSqwTkgNGsKt2IRJhydVHTDBz6Vd8QVY0KAvIkUabeZyskxWmm+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:54:06.6960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6121cca-5d5a-46aa-ad59-08df0d75fa22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5647

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
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
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

