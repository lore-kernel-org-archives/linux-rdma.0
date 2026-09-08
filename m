Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012004.outbound.protection.outlook.com [52.101.43.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E7F38F633;
	Tue,  8 Sep 2026 06:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850435; cv=fail; b=mVv1JEmgL1KgJjoICLrs4MOzDtg3mHVNFxVc7lByh8JW4frCrbMN8aWm/yqpvUQZ1BVbzx1g5Kvyjg74PaJTLXOyD0wECSFVZ7ME/WIpoWoJ1cHhTGf61U4RzFUQxb/zdyr/JsvdTw52A+UMRAI2BZxMRTYPWN20fRJjxomt4V0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850435; c=relaxed/simple;
	bh=X5id81YrAB66AKAm8ZY4Zducf0tjLGs2uNTvRIGfyaI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BhbS/oHWP+Ku7lcb1Mt4Qu2RWLV3zOWpWc+98rfc29x0HqnmKrPzd16HANvkjf5wITuME17ERWlH29t2+V+tsg+t8yzvvADop2Cu3hCrC9KXcGRkcvjz9rYZNtULllqORjQWkRCpGjsajHI9i8SL/uc5jnqJns4+dZ8/FLYTHrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HPKzhcfX; arc=fail smtp.client-ip=52.101.43.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HPKzhcfX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x34jrQusxvqkLVpXVNCt+RScVGaCR/mqJhFej3dIqt0Cs4fH+Hxu3HJOZZP4Z/D1Ve/lFq5LJTjCfphRm6L0TPFY6c/e6p9fXi6y6e+C6ZtfdEuJnBNb01DmM5yG1NO422Ket0Y+EP+NdWnzIvYOXpccTdtU/ukVeJ6EuFPs8uNBe6UnVQ7Q7X9KFwMLRr7NM/lXU2QhCpvqv1eXKWlznvGGUgaoHcDv/6jhLJ0+a7UwCVZJPgUd6CDrCqerN4AIuTO4d31+lI8gwmZiirKR8njC3eelC+IZyXRADq0pw3GzowbAh0ncMUElXNeIN5kOsnX+csBYMWmAOyJBhLBScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEnOODsUXFEHOVGRyiR5UCHrLtKI05wWoyYhios6ydM=;
 b=gjz4gGdl22A2a8JsMVI1zPpxziZFZg2YUYypt8w4y9YWZtXpb7H9VdEg4W3M7FT508dvAlMeDRy3uPUoXyj31E8OW50HJXPjkz+Unyq4yuIQ0WVDKi9Ub8HRk7tuf3wogATk16gUFRhEx9ZA7ietzlzE41gYG94iyfWFHKJevEP38LG0KarLtrXnUX9dDdAGFfid/gltdGObHy2ARCVXXhxJ8gIQjgcyVWAmKyNbZSEZ+ScO+b4JQRElQQzvzo2LH4MDauGTbqcX15X9LQK8uZy6thgMqQzUnV3BHyzQlOzevh75T+xfzyuQp5zwuwe5mERZRAMZ2sEMSzTP7jHbzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEnOODsUXFEHOVGRyiR5UCHrLtKI05wWoyYhios6ydM=;
 b=HPKzhcfX7hmOl31C1/2TOks3xvbWF6uLv4icLEkFPs29rZ+uQxkZPXqwSHPPFZKLFc7hET1AWG5Qh+yQ09AhJJd/ETah/pkVtXFBtEPevAh9kQUzyVIpluG56kMGOuqe08RLrhSnFfPOkr/xMqdj8tIv5WDULkEEGAZ2g7Hbk4FcZH1Rb6iZQENJAaN7T357QAZUMPGAiHmjt5XYba4sTxJceSkE1eZ2MEnQngEIdtZmev1uLfnzD02GtkpA5Clxl/F2tm5ERokapHaeWsjr4zxwsBiimHrre/nrwOs2zuNcd/FPjvuc4NdvNu23lQPquCs24UmiKpk2e8Yw+//VqA==
Received: from CH2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:610:53::32)
 by DS7PR12MB5911.namprd12.prod.outlook.com (2603:10b6:8:7c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 06:53:45 +0000
Received: from BL6PEPF00022572.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::42) by CH2PR17CA0022.outlook.office365.com
 (2603:10b6:610:53::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:53:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022572.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:53:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:27 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:53:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:53:19 -0700
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
Subject: [PATCH net-next V4 01/14] net/mlx5e: Generalize TC <-> IPsec mutual exclusion
Date: Tue, 8 Sep 2026 09:52:31 +0300
Message-ID: <20260908065244.3799142-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022572:EE_|DS7PR12MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8709d1-5747-4642-16a0-08df0d75ed06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|7416014|36860700016|1800799024|376014|10067099003|6133799003|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	rc+/xJZirDZ3VvsOtfyatZ7pG/eHWN+RtQY0OEbiPBHUudE88nG+4rrw5wbmFtzPrevNwjHB959k77fxCohWVHuxLGMOHfo4+c5ciluJFGc0k4NWzUpYgF5LxKppg8/MlIPjdU6GXcT0+SJK45FXMJLBrBdCgSNtApAYPX7704IuiQwOOuLAJmL0CTeniMz+V3kgBO7BrExO40NjjBgdjDSvExyUq/n0AvfIFgreqa0zm/HCeHEihZZ6pjMOf0VwqbyAauA+gGWDJPuUz0ZbzeVHGMHgeSOaJPPo7sOshQQ0ZTtFN7uTXxdvqvLqQ7JnjBJa1//4LLCzYDBTd9wZ+SHyA1UWzQkuHfkEyhUX9wQ9rUquWIjqJKZBwxo9MwWB8frg0vQ+hcaX7T5WIpkTbtpM+2bwlvslxLKTG8+0r9bMk9m9kOrdRhh31IZqWFsjuJqqvcxX51uo941q1W18JH6Jf/ky5u1hl+9AbB9v5MF4MIykrh3YnqNReXi0IIl3YOC0xALBOt3eQu9MM+ledSumOuAXppAFu+W2aAxCKAy3bZ0pCTOTW3jxFg2aBDhcmhDjj+7omXcHsagFfCfhgXoH0TbwP1NR3scouQJDyaJjEbgfueyehQwbIW78Ljv+XMYpIqM3oNMu8n9RmBhgtmKRuce8MF1CLOKIOrd+YRwJF/qGM9pL77R8wwmlWOaqv04MVMNkkD7WiQsfACFdlQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(7416014)(36860700016)(1800799024)(376014)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6e478pYWkgaW4ijP9ycIBkNsvA289jboHjq4aCu6Eqj9f+O31rIJDNbXQRJjlpT0RYvmHcapUNWG8Hdv8b80EK5UqM2ZnB1Ta94IQTPibjw3/qzFGD5OneuSVTSAqa0uptra9EP/qLMAnAs2psGb7IqAEJiffa/WqM+0Ae4HlEyeIYkyMzgoCj/u8AQlgD+Ep47bqvgxOD+ELbwjmtaaOYActd+IjbD1qV0QoepKyMvsl8Jtt+NYBU9ZC0DwMZOWEKLpcIz3O6E07i0yau1giuZt4mvyIay+Oc1iEYxtnIk4biaI1E16uWfSq4WMpWIN0GvDNoPMUZmF/NMHw+FVJrDWuLjG6q7lexgkW3gbQDXkLWBYDviAJRZOpVFG3A9pmBEqewhBP3u1mS7wkTfMGb0wDjEqP3TJ4ETIhSTMDZE6Ao7YENk6tnJK/FkxSTGD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:53:44.6906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8709d1-5747-4642-16a0-08df0d75ed06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022572.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5911

From: Cosmin Ratiu <cratiu@nvidia.com>

There is a mechanism to mutually exclude TC offload and IPsec offload
from the same interface (commit [1]) due to ordering issues between SW
and HW paths.

TC offload makes use of flow_tag to carry the tc mark (even when 0).
Upcoming changes to accel protocols will make use of flow_tag to carry
the protocol marker. As the flow_tag cannot be partially modified by a
steering rule, the last rule setting the flow_tag will overwrite any
previous ones.

This means that TC offload cannot be active at the same time with any of
the currently implemented accel protocols (IPsec, MACsec, PSP).

Generalize the TC <-> IPsec mutual exclusion mechanism to be usable by
more accel protocols:
- move the existing mlx5e_ipsec_{,un}block_tc_offload functions to
  en_accel.h, rename them to mlx5e_accel_{,un}block_tc_offload.
- rename the mdev counter from num_block_ipsec to num_accel.
- rename is_tc_ipsec_order_check_needed -> is_tc_accel_check_needed
  and make it not bail out when IPsec isn't configured.
- replace the conditional use of the esw write lock as a protection for
  incrementing the counter with a new mutex. The esw might not be
  available, and it wasn't used correctly on the decrement path anyway,
  allowing races to happen. Using a dedicated mutex for these counters
  makes it clear and avoids races.
- add underflow warnings for the two counters to catch future
  miscounting bugs.
- move counters and the new lock into a dedicated struct in
  mlx5_core_dev named 'offload_block'. Now offload_block.num_tc means
  the number of tc blocks due to accel rules and ofload_block.num_accel
  means the number of accel blocks due to tc rules.

[1] commit c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually
exclusive on a netdev")

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 22 ++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 54 +++----------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 46 +++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 12 -----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 include/linux/mlx5/driver.h                   |  7 ++-
 7 files changed, 64 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 3f212e46fc2f..8a2ea7616440 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -218,6 +218,28 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 #endif
 }
 
+static inline int mlx5e_accel_block_tc_offload(struct mlx5_core_dev *mdev)
+{
+	int ret = 0;
+
+	mutex_lock(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_accel)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_tc++;
+	mutex_unlock(&mdev->offload_block.lock);
+
+	return ret;
+}
+
+static inline void mlx5e_accel_unblock_tc_offload(struct mlx5_core_dev *mdev)
+{
+	mutex_lock(&mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!mdev->offload_block.num_tc))
+		mdev->offload_block.num_tc--;
+	mutex_unlock(&mdev->offload_block.lock);
+}
+
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_rx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 329608c59313..74e0aa5b6133 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include "en.h"
 #include "en/fs.h"
+#include "en_accel/en_accel.h"
 #include "eswitch.h"
 #include "ipsec.h"
 #include "fs_core.h"
@@ -2574,53 +2575,12 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
-static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
-{
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-	int err = 0;
-
-	if (esw) {
-		err = mlx5_esw_lock(esw);
-		if (err)
-			return err;
-	}
-
-	if (mdev->num_block_ipsec) {
-		err = -EBUSY;
-		goto unlock;
-	}
-
-	mdev->num_block_tc++;
-
-unlock:
-	if (esw)
-		mlx5_esw_unlock(esw);
-
-	return err;
-}
-#else
-static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
-{
-	if (mdev->num_block_ipsec)
-		return -EBUSY;
-
-	mdev->num_block_tc++;
-	return 0;
-}
-#endif
-
-static void mlx5e_ipsec_unblock_tc_offload(struct mlx5_core_dev *mdev)
-{
-	mdev->num_block_tc--;
-}
-
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	int err;
 
 	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET) {
-		err = mlx5e_ipsec_block_tc_offload(sa_entry->ipsec->mdev);
+		err = mlx5e_accel_block_tc_offload(sa_entry->ipsec->mdev);
 		if (err)
 			return err;
 	}
@@ -2637,7 +2597,7 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 err_out:
 	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
-		mlx5e_ipsec_unblock_tc_offload(sa_entry->ipsec->mdev);
+		mlx5e_accel_unblock_tc_offload(sa_entry->ipsec->mdev);
 	return err;
 }
 
@@ -2652,7 +2612,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
 	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
-		mlx5e_ipsec_unblock_tc_offload(mdev);
+		mlx5e_accel_unblock_tc_offload(mdev);
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
 		tx_ft_put(sa_entry->ipsec, sa_entry->attrs.type);
@@ -2686,7 +2646,7 @@ int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	int err;
 
-	err = mlx5e_ipsec_block_tc_offload(pol_entry->ipsec->mdev);
+	err = mlx5e_accel_block_tc_offload(pol_entry->ipsec->mdev);
 	if (err)
 		return err;
 
@@ -2701,7 +2661,7 @@ int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 	return 0;
 
 err_out:
-	mlx5e_ipsec_unblock_tc_offload(pol_entry->ipsec->mdev);
+	mlx5e_accel_unblock_tc_offload(pol_entry->ipsec->mdev);
 	return err;
 }
 
@@ -2712,7 +2672,7 @@ void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
-	mlx5e_ipsec_unblock_tc_offload(pol_entry->ipsec->mdev);
+	mlx5e_accel_unblock_tc_offload(pol_entry->ipsec->mdev);
 
 	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
 		rx_ft_put_policy(pol_entry->ipsec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369a..05c703795df4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4813,14 +4813,14 @@ static bool is_flow_rule_duplicate_allowed(struct net_device *dev,
 	return netif_is_lag_port(dev) && rpriv && rpriv->rep->vport != MLX5_VPORT_UPLINK;
 }
 
-/* As IPsec and TC order is not aligned between software and hardware-offload,
- * either IPsec offload or TC offload, not both, is allowed for a specific interface.
+/* TC offload and accel protocols can overwrite each other's flow_tag with
+ * steering rules and they cannot simultaneously operate on the same interface.
+ * Additionally, as IPsec and TC order is not aligned between software and
+ * hardware-offload, only one is allowed for a specific interface.
  */
-static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx5e_priv *priv)
+static bool is_tc_accel_check_needed(struct net_device *filter,
+				     struct mlx5e_priv *priv)
 {
-	if (!IS_ENABLED(CONFIG_MLX5_EN_IPSEC))
-		return false;
-
 	if (filter != priv->netdev)
 		return false;
 
@@ -4830,27 +4830,35 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
 	return true;
 }
 
-static int mlx5e_tc_block_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
+static int mlx5e_tc_block_accel_offload(struct net_device *filter,
+					struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int ret = 0;
 
-	if (!is_tc_ipsec_order_check_needed(filter, priv))
+	if (!is_tc_accel_check_needed(filter, priv))
 		return 0;
 
-	if (mdev->num_block_tc)
-		return -EBUSY;
-
-	mdev->num_block_ipsec++;
+	mutex_lock(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_tc)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_accel++;
+	mutex_unlock(&mdev->offload_block.lock);
 
-	return 0;
+	return ret;
 }
 
-static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
+static void mlx5e_tc_unblock_accel_offload(struct net_device *filter,
+					   struct mlx5e_priv *priv)
 {
-	if (!is_tc_ipsec_order_check_needed(filter, priv))
+	if (!is_tc_accel_check_needed(filter, priv))
 		return;
 
-	priv->mdev->num_block_ipsec--;
+	mutex_lock(&priv->mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_accel))
+		priv->mdev->offload_block.num_accel--;
+	mutex_unlock(&priv->mdev->offload_block.lock);
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
@@ -4865,7 +4873,7 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (!mlx5_esw_hold(priv->mdev))
 		return -EBUSY;
 
-	err = mlx5e_tc_block_ipsec_offload(dev, priv);
+	err = mlx5e_tc_block_accel_offload(dev, priv);
 	if (err)
 		goto esw_release;
 
@@ -4914,7 +4922,7 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
+	mlx5e_tc_unblock_accel_offload(dev, priv);
 	mlx5_esw_put(priv->mdev);
 esw_release:
 	mlx5_esw_release(priv->mdev);
@@ -4957,7 +4965,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
 
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
+	mlx5e_tc_unblock_accel_offload(dev, priv);
 	mlx5_esw_put(priv->mdev);
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b6e2c153b4f7..8b36a96522ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3022,18 +3022,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
 	return esw->mode;
 }
 
-int mlx5_esw_lock(struct mlx5_eswitch *esw)
-{
-	down_write(&esw->mode_lock);
-
-	if (esw->eswitch_operation_in_progress) {
-		up_write(&esw->mode_lock);
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /**
  * mlx5_esw_unlock() - Release write lock on esw mode lock
  * @esw: eswitch device.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c655f6e8da1c..33355a97226a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -946,7 +946,6 @@ void mlx5_esw_release(struct mlx5_core_dev *dev);
 void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
-int mlx5_esw_lock(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b..46b34c80c458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1810,6 +1810,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->offload_block.lock);
 	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_init(&dev->wc_state_lock);
 
@@ -1901,6 +1902,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 	return err;
@@ -1928,6 +1930,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->wc_state_lock);
 	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbc..3bdb0c5a87ac 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -788,8 +788,11 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_hwmon	*hwmon;
-	u64			num_block_tc;
-	u64			num_block_ipsec;
+	struct {
+		struct mutex lock;
+		u64 num_tc;
+		u64 num_accel;
+	} offload_block;
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_macsec_fs *macsec_fs;
 	/* MACsec notifier chain to sync MACsec core and IB database */
-- 
2.44.0

