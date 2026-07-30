Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744FE3F54C6;
	Thu, 30 Jul 2026 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403156; cv=fail; b=aBZO5gH01N9MsVtmPs8Earsyag/FxstzFeVi9r7b5Osc1/zSrOyo7zy9ITSBTfR3OpZe8oQzELYTyMrPgZZ0+3z/Eej0HfJfqH6ILPlhl9lGuFstN+9lkk4zLGdF6k2lAeYKZLYgTW2lV7Q8hJsvoimKtEPuRHtClrhjv0gUqtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403156; c=relaxed/simple;
	bh=qeFRiCic+mGtSPAV57nx6XrXVLjcTWxDab3n49sOJaw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxu7LaAY8NRWpDYhRIgSLbIEY2m1sUnHMzay3maEiNFBPGDVxw56i7bNYshAGTrYrAO1CWbm5TVF1uLoVz8L1AxDJpIGbzy+4hDF5BTtvpDeD6MTxoj32nLiV1q9R+HZLHEUDJ9Re6v8r4UixInneIYIQVXkLytVPjrEAFXw7UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SUzcSvFt; arc=fail smtp.client-ip=40.107.200.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SUzcSvFt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/KRHISvcV3E7VYMFWXxElpUI6JZbvIig+xa/56E27RiwadKlgiVhZoHbYoplSrDANHS+9qEJpclgK3eKcy97VDGmOzIdFN9U0qT9cpXYs5nPEu7SkNwiZLtqNxy0W1RxNqek4TRgvOz+syzRHqxYJpS/Tlbk4tB51e7bkcVP8Oer1Mb7v6ombgMMWtSLT6RE0XaCoArlzy5NCgHJhavqecYBT9Qj/3NanTrWx/IEBIyvrIo9Gebe7vFpjP2zekzUiHAyxOCo06L+RlkRordvGl1oR1J7/xqDvXkgK0xwCyZkenr5HDoHwRY4dXm+bVNyVnci0ZR3G2Nbx1STFUGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=GPDnYJYKOTzs94e3BbjM3zDDcPjoVsDrQuJ6x9eWCF/JM3czVh9ynN/fHPUHnEOgtGCLu/wSsZ2N5VQfaK0zltxlTait93pi0lnfbJL51SMeTer7NuDaNagxQ+QSBgQZbtvINnh4If3YP/Cr4hHwxy/QP9Vyur9G3om2dZrvncxiTKgknrXKuW8qcfldYgEeQPFsBzrdMhDIQEZa8Ao8qUjaxGUyRMe2spjKkmCo29/xbq8tfWLrOptxeKJuaJiH9B24D8vACQ3TTXbBeh6jcciyppkQKhj9ODScpIdobGElVSlStg7uK/6vLnWjgUcRwOCtbu2u1yWmU8XVFAuEdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=SUzcSvFtlLKjo6b1YW0GAihEXCtAwrXwuctT2N7jLR7VQy8LvIoyyH73kAXMjQo9W5RrjZE567Y7vbfQxERnQbhG59GnF+01wq3xpdEgfq4mvawWIuQMaaLG/x9qi+DlmMafUbVUKo570Zpfgqe16GmMphWjBU35kML48HQMWeHMhypf/e9F13K4je+QtyKoh09taCPipBEkrjzoaOxxrsUCvsPN3XLx6c22Xsu7Ji6wQnFhqp8DUEcx6ZoTuyK0dYtzb0e/5gqOsxHb6Em+HgUrhmCDDdLd2GhHczI24hvUCdC0SnHdS4GNVOADy1Q6fB8Jb8fVxCVD0DLykmBbFg==
Received: from BYAPR21CA0020.namprd21.prod.outlook.com (2603:10b6:a03:114::30)
 by IA1PR12MB7614.namprd12.prod.outlook.com (2603:10b6:208:429::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 09:19:09 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::5b) by BYAPR21CA0020.outlook.office365.com
 (2603:10b6:a03:114::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via Frontend Transport; Thu, 30
 Jul 2026 09:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:19:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:18:53 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:45 -0700
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
Subject: [PATCH net-next 04/13] net/mlx5e: macsec: Block TC offload when MACsec is enabled
Date: Thu, 30 Jul 2026 12:17:46 +0300
Message-ID: <20260730091756.2543777-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|IA1PR12MB7614:EE_
X-MS-Office365-Filtering-Correlation-Id: 82a57d80-641a-4a2e-091a-08deee1b9c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|7416014|56012099006|10067099003|18002099003|22082099003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	qQd2+Nd0AfKi5RkAq8EFclsy4U5WUciZY/En5ojvIWo4Muoi6WOigpjjQmHbBpfOQ1fHcg4Gg9PGE/NDfRFyvgQcC6/6oAXCUiTd9WHoh+Ll1hbVW7gIWGZDDIL01tsFe3WcTVbzZ69G44YAkT5QqjnhFeKcAjwG7rgiIaNIxl+DsGLwnsP8nUwD4U/TDdMkbc+Kxfu8M+ihq7oQC/qbP2A9zfuQd225my6fva5+P4Mxj6A6I+YvP1SqgxAe3kjUPQSEgcmusCN1iQwgJDdPOGdnwhz+M/WxVtIt9klr1oE6Z5GXtXSsI0qeoy9pEpb/8hHiGH0GGD+i483VElWDTAFXiUO/7OB23qcAVZ+Mq0/KUsXeAkv102YYlHUfvz3UjlH2piPg9mv/Xgzlw9sFhQ1kkyvxknoaJhogJr24s4IjM1H3agWg5vknIt2NlHQu8quQdDVt8psXRhfhp4FUbASJAo07UdJn8fZerG/DXv2Xv6ZND0m4F8Xs/v91jo9Ge/PtScHO/24a4yADiA04O0zhUniVgGleXsnGjxCC7MkJUbj1zSup8GVfB/RA8XNCNalDeQFAb7UUbuWd0/Qn3Vc98YZL4hK+zFtx1Rs/C2fBF9subiCxwu5yMutFAxxqLTtzjW4ecPbdBXBysbsTYjoF0mNe0l7DGHG9peCFqH1O3rcp295tRxgfXUCcBVk4ckJMroBPHk9K0r21NN1gZw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(7416014)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dEZjq0Zjkoxh6DN1K9xScEFlnTCNnb0sv4sRn3uTe29VbbNOAWBJ+qCa3pIwUIZ8kIpFw8AITJoyS8puvFmIQjb199q+RJkWn/3z9u8K1PW5Yd9QDD1G30lZPmeG1SK9tkBT4838fyTo/Obt/aBc99YUzeJ+M4rbjwVc4cu3sKDRFJr/yE6IdIBqfW95d/35I7eWWSVDbLcUFrPsYZP6el45NVsA3cPKWr5+EbiQHl8VvVBdCGcFy/9cTrBlNidMTexIC42wHYy8k/uGDabHLyR3D4In3B3QpYvT2zEDKtMENKCtE0WF0T5H0b0tYHaNL0sZXlEujV3HxXI4h4rRs4XKcBEnJeMBovb4BQE0DbXl9WXbtb9k3ACGXgWGRLh2k5ivu6I8G4QGhlz5XFqIksDvpZ3KdbKASnqjMnZnH65Ekl/1N6jMyhErNWYauNWy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:19:08.7077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a57d80-641a-4a2e-091a-08deee1b9c53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7614

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

