Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588FF45A284;
	Thu,  3 Sep 2026 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425702; cv=fail; b=g7PgNxoPbmhO3Ch0ckeVWQxndUVkmVFVyxMuHd9WI3cykTDt5oatlVeIm+vHudbziyNr3SUNv4VdrsjS+fCzSkXDPLGpyLgTzN9tUNetxOufNMhEfNI3rndpGC4pGWtj1QGwsohaYQkXbgRQdC40embw2aMVDAGNmihLnDwf1aI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425702; c=relaxed/simple;
	bh=WT4WOdVjrQbnZ+QWg+Jq3vKJUxb15zA5iQyTNRW3ynU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIJiSixyTr8BfG/o/uRFKg4TltShjLDvoV6XZZCsGH8UPKf5n+LK2jk3x/17BJoYpiWbgxc923ZZMpY/lBmD9WQ1hsjn+fBj3hXHB+fIuarIKggsnOS4LF51aV1Gq7K+dnC3Glik2wiTZLzOZMaEZH/I3pXHPb39D8W/wjTth40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kuUL8dKr; arc=fail smtp.client-ip=40.93.201.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kuUL8dKr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncv6Y0Rd4NRQeMoSCuPftHTmU/DNKSZf+Rm3N4FP1gPVrwHx/wEYE8YvFiX1GAtNHvtn6UHd65MSXG8E+5w+hgZTW7r2tsd9AeVtIgZc9CcFHglK7aYpg/N9EjUWixZxtt0bn770O4MZ7/Raolh90oO7tLRYDZ5hkqIP1TJegOre5tQSKgKyq/vHqSxszQGCwYIcb8gQ7+Qld+SMrLoJo1b+USmsRSnOWut0V4cjP/9RhxZHIQdjhvWhOOaT/5tBxdG0wyegc+N4Xgr0AfVE+drAz9t0/niZU2ZBwprwcJ8Q0pVUoySpQ6r8CfDMFBjZaMdFq/Rgp1o2jDpR7PmZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoU+y4hJmr6waZFTlrdaxzZYG0oeguDmR/p3wVT2lyQ=;
 b=dQKDdPo61Cm3ctDjUuC3qsCOqysxx6//L7/lprVWDWErINCupP60fBfkRrUR1GcC7sX0DfjeW7kIXk6AFUhtTHNaSPGaEey5I9tOl71tHT2pDizZlSsjwHQd51u7JkxPphwDk7ShkFIMfCEiCh9aaxtvJW/nScoX8PXm69N20RK207fCA60SwiCiQfBFhfyrR/ShSwNr+RiSgDv92YyOKWUZSXuGfxTBAyE3DV0scM5hOLp1onDtQvJoSU3+61LAfDBUgdKq8snw4EXWzKgnkhRke5ryEcXWaOlBVgUxrLAQpr5U+O5xKhM7Hk64dG2s96mBxO6dvm66TJvXsgWx3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoU+y4hJmr6waZFTlrdaxzZYG0oeguDmR/p3wVT2lyQ=;
 b=kuUL8dKrY0QwCLUQ5DPOnHEK8xLkH/1nLFFY7iFYrTsOYFn0gjh5up539X4S3qshnueBGAF8GVb49ITNxDZjbVIvvr4nA9mPcobW7JawJI3CgA6nVL6/N8sEuNgwC3+NuD9G/DxuDHrURuOewZva0KzrJ9GdLkuG51X7d8IEcfSwnlZtb6yIZkPFJ1G6XmHh6e8SODO0Xtq++I8pDed1RSWKNHw7cXKVDUPpCKMANIRMLxpXU80dS0owH6j5plX/1DH74ymDnyhWfCfK4EjCmp3pglTmW4fOacTnWW5odPhbYYyFkerPX6fvXWnl7cfhw4tfmub+t378Ft3lyHUwwg==
Received: from SJ0PR05CA0144.namprd05.prod.outlook.com (2603:10b6:a03:33d::29)
 by DM4PR12MB6661.namprd12.prod.outlook.com (2603:10b6:8:b7::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Thu, 3 Sep 2026 08:54:49 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::8f) by SJ0PR05CA0144.outlook.office365.com
 (2603:10b6:a03:33d::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:54:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:54:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:23 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:54:11 -0700
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
Subject: [PATCH net-next V3 07/15] net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag
Date: Thu, 3 Sep 2026 11:52:07 +0300
Message-ID: <20260903085215.3691657-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|DM4PR12MB6661:EE_
X-MS-Office365-Filtering-Correlation-Id: be92d28c-615c-4145-25af-08df09990288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|82310400026|1800799024|10067099003|11063799006|18002099003|22082099003|6133799003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	xcGK1zoBjlgAnrVBE6BMxhZB1YujRBqQfQmy+9GpqphhUZtAWJJJ+f3TOhjVsLJjxPsbJXfu6vUCwFE4dvFFgaSZTAEJxlBRnbFAGGv7sF3ihHPI/EyssrvQ63YO9GcFEAOwk2PjgyjZ+GaKHiVxIz5QJ1w7gYpuSrK7k6mcVe+eLvh2aQdOA9Vzz6hSKVwGjebk7xqEXmxvHgMCkAiRNcV8S5W3ZCmgpXanZjG2skkPw+cKQ8TzDEhGDZOtJTGrQIZEFIq7xe9w9JB6cllczlGTKilQXtzXRlbfF6imvcBasoGH0UqMwk7SrpR5uwvDMsjOdbgJ8Z+FdUWExu2ycmqUNRAK772j5w7bvm0c2Ca+m3IYVwW3IrZ6PJaf32XwyGZFR9iFCw8P66FeK/VbJ/wZBvsdC4k0zTzNpBWNewzd2/xWXb9VOPsT6I6b4JbVDctXT2YhIBCwxd9kzs2wnjV9fa+SbZdukyI/QG1N96Bd+wgeXn+/1O2c6z541lQyOsvLH0czqCchvpN2klpqES6RlUode3fg6M2CE+05FfAoSlNPijyi0PpWWwmfOnOQXkvbeMEfcPzwYgCvpp9AoBWtcY61KXDiv7G2iER/VamMfBBjY5EtnO42UnMzEp/1qA62BI24mAtjmpepC8yU2Z0KjezBNGzbsmz9OCzYLTuBBEG0TG/RpG+inJYHffRH76F6rdW5gDdBR3Wgr9a9Jg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(10067099003)(11063799006)(18002099003)(22082099003)(6133799003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FAQDgwkPElUZCWN1pT9RnFBVRZsyWOh3aZ8q1mjdQDS8izH6yWegzH6h3aa+dXxclP/UftcZSduinzpilLAULjXp+JenSC/2uNGGK04it2tjzscOnwRKTToxF4QLwZSxXBTY/9cPtTxU1o9TvExbTrLFetRl07zUyVDWqE238fzAFagNIm54WAYklZVRi6xVMw5L7jeLIZ/spQ/ceetBW6SlZaAshe9iYIpXDRgVm6D1ZCsDN/hgJ5y14ufonOfMeSGvcUiVPpCF6OvO37w+aGsNrMZc7IfORVLsrHqXAl8aScw0n4jgF96atJL11EcjO4p9Ta+DOcXNZqvu5j3tQ9Hp3aU9XRH5lgyjLjGmrmnin1rU9m8NQCAZzL9DzpAcYcawCCo7/4yEjr0S8Y1sC1nworMwten7aDsH5hjj1wzORGDG8dX51vDe6RlVWbko
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:54:48.5433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be92d28c-615c-4145-25af-08df09990288
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6661

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
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
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

