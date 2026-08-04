Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011021.outbound.protection.outlook.com [52.101.62.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023243B495;
	Tue,  4 Aug 2026 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832641; cv=fail; b=Cvjgt1F0JP2nFo1XBg7XCTQnTbxf3qyQeoF8/jeu8gPmIlZsUSunr+qX68pQgexOtxYTNZdYLccOU0rE6P9jI/ubdYkpIXvs8cCpm5k1W7rsynGXuFpWS7Op5AGsU/+zM6OliKmwAmyQ86Q5ccQGBVV2Kg4lTXDGCYInKx+phI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832641; c=relaxed/simple;
	bh=IIr0K0BnQakrfZ+rTMnbrLtKNmLiI8b52LuQuaTmOMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oO+o93EBLcLNqgi3v2eAQBT/SeZIyNFjKyMyO0vm4+HGSUgOiJ6SF6PcOgD2vp/X7aGeCUZnKC4jI4aPLvR2fT9SXdjkK8peFLQdhtVrxxuxDJMO4z8TefwKrXTk2N5UCJ2ueCBzA8JM76jEtxY782tMCmlkm3m3yaZX9rtWR80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TFVZu3Qa; arc=fail smtp.client-ip=52.101.62.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TFVZu3Qa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkArlDqGfdlvtOQBAKgMCiJZW8TTIJ4LJdXDhYoEs/ZOw5WmaiYpDqhsu0uCXGapiphVRUDqKkSgrqW8A/1du+3DKME+wO5L6zyzAmGKpfuB84mtHaTRB6ivHnDatoQwyVpm7cxU51rnbhawegPGkpSN9mdwoXyd0V+vNULTUbf90FANcJH5LwzHog+C9QTRgj7bclb2hiL7gOX5TcI1Fr6KiBujFCw+tSPFcdEIPhPFNc+QsnP/Y/vgZ65jxIX+asryPzRS97gMIa7w52zpltJNcsBC7x8DDgGSmRxfLYm4xfbxqRQ+zc5PwB7gXWztBUT+AgZnV0DjFz4mlSWuFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VDKCytwk+PDwH2DIYibsqkK5dHGQnNzHXpkcLg7jMg=;
 b=la3hK8f4nW3jhrVGLy6Pa61zSxKaCtlK5WePRiR82WKDKWYI+kVaCx1/EQZrj1Oh1mUqbGB/a8yGnS/I1mCG5lx8iQ+QQSdsPKdUMXeOOpdbf3gLZVdk8FIxbMkJR5fG+xibITU4IzeZK1kGXbsDoKOdrs+gy5Z8V0ByBZz5B0anyTrgBYKpc+OPVJXi8jJ8HRV5qOF8g8D5Y+vERGyqbzbB1HATrk4Sj0Xb2qCI6QEw9nVoEUykoTj8afr2nmcycx8h0clxAiJnouRm5T209KLAEAM5eBX+nE6lrifuZiqueLSFomGl+1pFOVTmOHPEa810xLwwWrUpsbqlgcuEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VDKCytwk+PDwH2DIYibsqkK5dHGQnNzHXpkcLg7jMg=;
 b=TFVZu3Qac7GTJH+1lMzjVue+UIzRGI60Y/dJuTKNhD3Me3ZNGncblwDu3n/EFS9s/9bXMscg1y+zQSweHlBl2htdNrj+iyWhlFGKDhVVgsBpls9Y6HFh6J1rgls3fanMIOnpwdN7fDBRs34fcMY1hdaoSoSlcHDPa7MrqpIVS9wweAOkMwzCeEYH1dmMI+EXdubDwnqpZVs+wxFKPCkVExLc/b+mAyop71QqLEdxUF6mVWPZBXl1tJEo7+NAw1L9jgZi8uU/spOjhMeVxKXvsnXS5rHN9K8PqUT8HP7THx+lJOgTJzVG2dXWhS7QoH8gkzd6jGxs5e2m9GaSs9S1yw==
Received: from BL1PR13CA0127.namprd13.prod.outlook.com (2603:10b6:208:2bb::12)
 by MW6PR12MB8915.namprd12.prod.outlook.com (2603:10b6:303:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Tue, 4 Aug
 2026 08:37:11 +0000
Received: from BL6PEPF00020E60.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::40) by BL1PR13CA0127.outlook.office365.com
 (2603:10b6:208:2bb::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:37:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E60.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:37:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 4 Aug
 2026 01:36:54 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:36:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:36:45 -0700
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
Subject: [PATCH net-next V2 01/13] net/mlx5e: Generalize TC <-> IPsec mutual exclusion
Date: Tue, 4 Aug 2026 11:35:23 +0300
Message-ID: <20260804083535.2946459-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E60:EE_|MW6PR12MB8915:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b00a0e7-8e69-4c1d-418e-08def203939c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|23010399003|18002099003|22082099003|3023799007|6133799003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	n1NZxQX2Xy10jaTqLY9+Apoyi5T6FGjXQZb7C70Xw68d0bCFmXfmPmjRbbA8lJgsWxw/zCDkcdWj33k1y3JFy1StbyIsg417jxp/OKUyDqsGK5rvfY/7BAnA5lm+oz27V/W0SeULIEw/otKNPmzWqIGg8XC7rUkQHPfik5tryyOZcxdaZdv79UEAQrftdne2191+VeWun8DyOYji4x0ONOMSyOm0PD+zFwbEs083CkX4H+Hgb8GV2SgmEZxcTjDViXeqrgPlK3EIJIWcdsdb/tTgBPn8h9yJfpgcZIpZQpLYV8Cb4EGcVRdQHo9HbSmt3hx2G20azosQpQY3ltb6trktPNdAv1X+oHMA7EAtVlS807ox0aB/tv8X/ufrVNosv9xIQuuKpvgJTbDFAG4siGV8cLkH+m3qNnO076aNvPfLF/mWehz2VKEg3DPuMNyst3CxZ4wvOK6Bw3AwMbGFSvk/XpykARBENLFUs37vJT0ZzlgpQBEqdokSGo18gE6sIq5IH2B0qGjEBXFFlynK6bgbVwb6Q+JiW5IkbSAierbJPhvt2GmdmChdO9KsrBI1H/5f62XVmpSZ/CDb4RMc1xXaRNIEy0rc7N438cxPHsbrA+6Q6AsE2en1GXDDZN4jRynRU5+M4yUv6Fh1XIkPLpAHo/q+QCQ9vYZBJliNY365Rb5cDhBFuvQHlhk7k4XutXkMxBsCP2mDVM5ecqdeAQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(23010399003)(18002099003)(22082099003)(3023799007)(6133799003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zQX4b9nxliFiL4JFlKjCsGr1LkC5AcfQqCa65K5kKlHhBAJhONe3+XqQ28VVvFygdoaFjsYr6545HV2HmYVPfi5NySbLs4laYELUZXXpzQGzJN8lNRbA1J0hWGhxfrqC0x6FY5NW8HgU9q252ozntfI5985aGH08w92/zCAKxb3akSMr9g5aj4W9COcT/iZk82Smk9Owr7f5lwtuW2TMVyilZ0PGtopGwIKkq5aZIOtYjh/NAgKpsrvFhmd8pyaatRTU5LOshlWG7ZRjA7tLD2wJ7+/crb+oR67JSQb/Zx+g54vHcwCHF34PbfCF3DDEHtxg+ybATUE0qM6yZXd18oFf8rweibUIwUiuq8QGsIcxon5+Z3pbZWs6iSOREAyXsmAmthWz3KKLdlQ+u3zFfR/jgvjaXiZ+UuirDK72lhJjOtrL7hOCjOt/LNasr12B
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:37:10.6641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b00a0e7-8e69-4c1d-418e-08def203939c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E60.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8915

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
- replace the condition use of the esw write lock as a protection for
  incrementing the counter with a new mutex instead. The esw might not
  be available, and it wasn't used correctly on the decrement path
  anyway, allowing races to happen. Using a dedicated mutex for these
  counters makes it clear and avoids races.
- add underflow warnings for the two counters to catch future
  miscounting bugs.
- move counters and the new lock into a dedicated struct in
  mlx5_core_dev named 'offload_block'. Now offload_block.num_tc means
  the number of tc blocks due to accel rules and ofload_block.num_accel
  means the number of accel blocks due to tc rules.

[1] commit c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually
exclusive on a netdev")

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 22 ++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 54 +++----------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 46 +++++++++-------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  3 ++
 include/linux/mlx5/driver.h                   |  7 ++-
 5 files changed, 64 insertions(+), 68 deletions(-)

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
index 1bc7b9019124..70195fcddfc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4811,14 +4811,14 @@ static bool is_flow_rule_duplicate_allowed(struct net_device *dev,
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
 
@@ -4828,27 +4828,35 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
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
@@ -4863,7 +4871,7 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	if (!mlx5_esw_hold(priv->mdev))
 		return -EBUSY;
 
-	err = mlx5e_tc_block_ipsec_offload(dev, priv);
+	err = mlx5e_tc_block_accel_offload(dev, priv);
 	if (err)
 		goto esw_release;
 
@@ -4912,7 +4920,7 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 err_free:
 	mlx5e_flow_put(priv, flow);
 out:
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
+	mlx5e_tc_unblock_accel_offload(dev, priv);
 	mlx5_esw_put(priv->mdev);
 esw_release:
 	mlx5_esw_release(priv->mdev);
@@ -4955,7 +4963,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	trace_mlx5e_delete_flower(f);
 	mlx5e_flow_put(priv, flow);
 
-	mlx5e_tc_unblock_ipsec_offload(dev, priv);
+	mlx5e_tc_unblock_accel_offload(dev, priv);
 	mlx5_esw_put(priv->mdev);
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 643b4aac2033..406c0f7e63d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1810,6 +1810,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->offload_block.lock);
 	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_init(&dev->wc_state_lock);
 
@@ -1898,6 +1899,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 	return err;
@@ -1925,6 +1927,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->bfregs.reg_head.lock);
 	mutex_destroy(&dev->wc_state_lock);
 	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
+	mutex_destroy(&dev->offload_block.lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b1871c0821d0..2d9bc752e431 100644
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

