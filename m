Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1BD43B495;
	Tue,  4 Aug 2026 08:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832659; cv=fail; b=L/R9beqS14ANKSHfNtM8jha3IemZp6ewqf7c6et0M3da0wI1CxPFpPylPUioJdSTwd+ArevuifcZVuoMHUxClwmVIV5/4a8gi0WvVCutnXJwlXtaRyHiS03q125FmJPEX7UQbgIQjkWkoMauCBeradSRbhgxdwWXbZYgqxzEgXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832659; c=relaxed/simple;
	bh=qeFRiCic+mGtSPAV57nx6XrXVLjcTWxDab3n49sOJaw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=go0vCxJecR9mmwp9EcHzcqRkOFQ0UcimnVqcY1cUbX8s1wplNosfOzFqGAWG9SdTVt721NXPsJegsRzCUR0frtM+rSIQeym/uDmHJ6ftIxqmTG3t9AcXeD+jejUZdWuXHQLshh5YKEuUqNfbOlTyCAHyRQ+DhJ/X57zj/np/njw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A0FxRHa4; arc=fail smtp.client-ip=52.101.85.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0FxRHa4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/k+Pk5mXJYl7joxgHoUa/N+RwNDPEFJYGsj6TdN0qAa0SOvt70KlRI6fRL8t8r4k+odWOneq3Y1dGDbDlI9cNwZ2UyEPfnz2dGWVba2KfFwZvKjSriJLxWs4YyArsUcQ0aBu/AG792ICu+MKzVy4YmPitvmGJXvWOdhDMjfmN34fobf56i0FnlSzR32pEgDhR9CFoAalysC9ihh3VNtSIVQYDnNacaLhpWjZuBHkyt60c3GTduXtrzLKqcONHOxQywNjpSLi1oIAt018SZCWIKLOAc/eN13wobezceltpj+PIB9OHUxQIaQmGOqhQ57F4ABpvPSYow3I5hQNaXSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=c0NMQ46MQOnlLDCe7tpRZtyPBVlKnlqZ55SXaOEMTYeRGkOu8p+qHIjfhSVpi0zMyah2gKq3IOMHGmuC91lWElM3dAsD3Yqb37HKZrG3OfSGFUiwTHIv7yyXQfPNeny0iSSc3RDi28n9FRSc/hWvB34bmJpL9vSRantGSlqhmk5EJeuNyUWTTDPZX90VQ4kikjdh50/DQ1soclMwnxmgMkEPohMJy4uQ34p/gGh2CoB3QEXN1cf5jLBT6+uHAxBVeIwzCxE8G+0/SCDOns8ChUJte6pdEl4Wohnc+DRgJYYa9J6rbP/3XAkJ34HID07pqOnBJq9EgwqMVrGQ/mqPaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgenrtbmBM7uKo18CtVEVQeizlrtxMYTw6HIT8pCGDk=;
 b=A0FxRHa4xBsetCvqvFjEVSOs0CfzuMEZOFHCOGHAOwendmF4FSd7yYoMgJ/7rhwpfhWOyQJYu58maKXhAjSafoSOvuheNVyOA7eHUhpMAC9xPc1L8qPHQgjw0SnFsMvrFp6kKU7AEgTCr9nXVbTgs20S5ebC3NpcNT+NAmdudpwi3KZFNS4rxoMO51pMkzO/lHyDZ5Qr4UhG4Nj+xMkrUYdtTN9qfBgYMRTveCvF+7PDV/uWR7hDS1S6b+5KcPu9drElvWoO0Mtp8hvboKuR8lqdzUe0EbiL5bSJiKHU4NlGj2J0ikj2lNeDywx0zX/8iEkZf55W1GDdNttjrYCaTQ==
Received: from BLAPR03CA0137.namprd03.prod.outlook.com (2603:10b6:208:32e::22)
 by DS2PR12MB9568.namprd12.prod.outlook.com (2603:10b6:8:27c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 08:37:32 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::43) by BLAPR03CA0137.outlook.office365.com
 (2603:10b6:208:32e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Tue, 4
 Aug 2026 08:37:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:37:18 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:37:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:37:10 -0700
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
Subject: [PATCH net-next V2 04/13] net/mlx5e: macsec: Block TC offload when MACsec is enabled
Date: Tue, 4 Aug 2026 11:35:26 +0300
Message-ID: <20260804083535.2946459-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|DS2PR12MB9568:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fe8a22f-c520-492c-2e0e-08def203a0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|10067099003|56012099006|22082099003|18002099003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	+ee8YEvCmelo9f8GanzEghvh7/O9BTLxpgUZzpR9mhAmETa2D80aOSx0wORWHc/Qm8ZRca9JqVl2TvXHrg3/kfrMH7Qgv/sTQzQuJOy2Ji2JJ1rXeNmdeINKGaS+k7RSzPMCCFLQ4bgy50v+EzwogGKqVwdOhLNoHvHdmsjD6axpPznJfRrvH2+JOpTFr28IcsUyXhb6zsQ7FOP/mMblYgH8qK1dm1abS4XGrapQ+I9ZSKAvuImmQf16+8/L5ExJLfPDkLov4X30+dJqvcwsCaUtagKuvUFDaOpefpFX0b6aa6QbxEPk+y4IfY3q3QLqET2hRQ+CExMEr5AyeHrXxLKpNSJ1cfa/E7/5pZVsF9xuAocsyQREp3RJqU9o0dH+vkSRqRUVJ4KC3Rj1u5XJXcDKod2W+XkW+S77wRP18xKnl6RLzHiDtIRu1Df0errpjfTViLki/cqkFmJkcPsu7cPyNPm4EQfu7XdZR6JexN3XoLZ7qDkLx7XdVAaxu8Ul+W5bH9FdcmPH8chzw3p4+tMaXSrh+hRfH+FZnjOlYYOGABk8fZK2xto7XXcpHnuf9zgBvCqepioZVjoSFRE85gcWVJ+JZRLWoEjo/7IAoSa0np2v+8NzH4pzIM/PezET/ZR2TVERRfbM5hkp74RMOThJnfJ/X5KhnxOVJmyMkeIUfVM08dcNXOoVttbot7c8R6ulrMQ8okWs5Ik+9JD5Fw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BFHCP+mPa//2k75xtH1y3RDE8jz2B6lBJKTnPMzNuG4E0Tzz6oP2gjjeBjmI4FadPAx+qqsGeEdoVZ3BEit87Dg0SX3lqzC6r30Rl23weFzPHo4mrK2aAgO3L5vrg37awXS368nRoLmAVCw+xxzBjeuOyOWq+yFu4cjA4ADZWlIk97WdYI7fz3P8Vh69IpPK0kniuEUvFvGFQtTNOIR44g1Cj6nTVIHC4jdptWFq/K5F9AofTgVQsWmMLd+ZDguX4yY4TMyK0n+X68I2t8H/nk26Qpt39nXqtqDa9bL/slrkzIKIlvzsip++iaYlqZ8nZ7AKBvNrWTHZ/9vqxxt4VwjNcmQDPpoghO4nW2p5jukgYC6qN3Vet7ueJFP9zZwiLViHZOWplXh5mZkYE/33r7ZNWAu8uZ3cbBM378hx/KEKBtrtbl0EtYLRAau3BIwI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:32.5279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe8a22f-c520-492c-2e0e-08def203a0a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9568

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

