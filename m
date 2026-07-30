Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F23B3F1ADE;
	Thu, 30 Jul 2026 09:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403134; cv=fail; b=P00VSx3CUisSCJG+2Sro2wBqneudzdme778mF9J7+wWQ6UrLHnrI71ZAk7AU81cX7QUPJEWo+UMAgYbRQonOeCpXvCWqJH2Bw99VVoJIHMrBOwWXKBNPSZBosA8QnAjzuS82VQhkX1Ij593bSOjKEOXGbA3D44TbO/OVAwk2lTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403134; c=relaxed/simple;
	bh=IIr0K0BnQakrfZ+rTMnbrLtKNmLiI8b52LuQuaTmOMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMSlRbjxKj4Vhpm0FSG/Z+KF4UcqgSCvFihA9UjzD85KhMJJFp0+YOAkT31feq322FnyAN28nBHFLskitQU3ifEQ5TVxZhnxohMMz0f6xrYTQvP00uO80cAPY1qued3teuAwY/lLNVOF09K3Su2UhuKiAYeIFH9jXN9amXdieQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qoTK3xRu; arc=fail smtp.client-ip=52.101.53.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qoTK3xRu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gaeS6qCvCOa7oy3fvDu6KLlUpoWLNDIiD7Q3sFsH92rPGlkewybieaJ3iNdGztJ+nZ0dFRUcM4VCtV6Hl/OVrXC/i+pd+xl0ZxW+eUBY+FpkG5KP0V25npr61M9KZ+XDqOFD+gqPQgf3KeQuZrOKyrdd0ILTZTNGkrWii8/ZlYF+JtJ3U1jYPFuLCtBLXCOomhXiVPp/Bz98VwmAeW7Cjfr94pc/eVlMDsYOHlfouW6OmU6qHnI3UflB1t7gVkV1glb/ynzRnqpTBPWs8S5dFn+Vkvocz0pPco4UCMbB3F7oLSweKadQAKTcbis4zlhX0gmzKiC8pDkg/0jQuTEnDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VDKCytwk+PDwH2DIYibsqkK5dHGQnNzHXpkcLg7jMg=;
 b=S+/DIHGqA2vHn5ZR0Wtea4aUS/Inr+TAIlUbI2jaNdsb907y4S9pHIvsaBXJC1AFkPR2HDYd8atqAxeSjee4lfVQSYFQ+sAY3EFnsvKpCUy8ij3jqw8YWmcnvdGMZZ4bWou8cje7GzOyUOsVn0Vd34BFO23IvMwBtHx+Z0fwT5wSs187ellrSOKCA4QO4Q2G5yRl53sAq0RV4nYaPRnVV3eD/igdq+2C3t+ys98SpcHwwgW/5Dnk/yS8GGwfidoRvqHKUwXwmp6+ZGcjFJAjzB70ViASaXcFKI7T9OIi2t+6FC1S6UBpcT3MKYX5iVzMJe6miF+6QANyKb8ZtuBOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VDKCytwk+PDwH2DIYibsqkK5dHGQnNzHXpkcLg7jMg=;
 b=qoTK3xRu3KD98NkbvqfNKqPzPvsx6IAsHF/MOKjuenXn61Yjgg2ntjsDUAXYss3x4kHeaDMSlbrqAxApEoM+NOKCxkXpZ5MBHk4kDprkM9sPwq9bZbtDbYHIVi75Udcdb/pm/wMSQzPRF7B+6yhxASh8DY4y7JbcnKWokR8usEPq3cIPVETlNCrgNeKFogTrRL6Ilao3hVLrrddZRPhKZmhr4DkLU0/6cKkUlO/fXsPGsj0kHvsnYR2tQilf9oN9A2Iq7EY07TX3Wi8B1+wjncJofplAV7ThCCkWQCz6Dkz/N/ww/va1V6KLEhCSDtdLFlJAptNUf9W1x07yquce2w==
Received: from CY5PR14CA0029.namprd14.prod.outlook.com (2603:10b6:930:2::10)
 by IA4PR12MB9811.namprd12.prod.outlook.com (2603:10b6:208:54e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 09:18:46 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:930:2:cafe::2a) by CY5PR14CA0029.outlook.office365.com
 (2603:10b6:930:2::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 09:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:18:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:27 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:18:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:18:19 -0700
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
Subject: [PATCH net-next 01/13] net/mlx5e: Generalize TC <-> IPsec mutual exclusion
Date: Thu, 30 Jul 2026 12:17:43 +0300
Message-ID: <20260730091756.2543777-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|IA4PR12MB9811:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d40ec39-a33c-48dc-b931-08deee1b8e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|7416014|56012099006|10067099003|18002099003|22082099003|6133799003|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	ZdgxaQGVvXPLbyspZUvS3evgUExWvW4bP8yujX4n5uMXLNK5byoKAfCxZ3z7woRbOPsg9Tkxd75Avd6Cyupe471AqVPriCWXhuCSgJmdfSlviLZhkbfCRoupjJH51jX2JezxZ/mha/xhfkj8GlNmPhXKJKYq8A/cq+5IDrIMi9+1nGz5seMPIsz4ZGQDsScOFleCFybcNBfZAeTzmkBbUJ1V8D/PQlxtvx7YNAPxnXWOua5AVttkFkx29HeR4OQF0kB71f3N0o6s7xqzu5GuGgw0Ln14q249fi64pEUrfc4mzWl3naX2iXcPkTJc/osk+91omqIE8GS04CL/8twipxYBL9KN6TFOsdSHwKdXf+yk9T5NZJGVkMp3H9EnhNOrp13xDx3Hax06eIdNVMkD0J4SJAwhOTb/sr8gli1aDPFR1+PD9/rGYkKmMOx7LcQTM42ZWbs7lSbXKRQCUtgaS8+yCMPQOBtLZPy0UvVKA3T8qgMlC0CBmqw/WsKzH6A/YXVz/QTHI5BTwBka/vo9bc5Hf7Tk4B1YRXLihzL19DzAzQNRzrdWR3HSECzsp43ldtqjmjgv5Uebu7ojNN1/EPLvzHFhU5lvGd/9HTOxjpB4d+R4F/4i2GQKH7za/gSgcg/CzADgUENDDfiGlqvtLLU19D68hLYKalVcDDoqzRbKk87KvnzlFGs7KPoYKDkOVNlqj8/h0ceQ4Djw8IyvFg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(7416014)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UbNHlpbtl5GQaQN112ccSPJOvOmn9coe5Gl/qW1Mxj6W/tkiZijNhKkOOPaJg53+76Dmw72m4Ve+S2qjpK2NNArSl0d19WTRQVLfHr8hGBPGch6c3GcfMF8RENpc0+xie5PPyeu/vmCBsSit1DpTgqrq27ImRlCrsoXlx6ni4R4InHcLNaVOgdti6jXmx+EPtr0nhytTBi8GHzaLgGkJLTtZLLUtAxix3hqqRXX64FNdPcxrLCqVVxo3luSF5Ws8Pk2mpXHNS74H9xXqm1sDxogV470PVOhvb8uD5kVQ4wdtMTWvDXm4+zPBME/L3vypehvQ65CNF3qoFuXjl1pYVSIk+dRqvi/1kyU6uZk+u6CLuHTFNID34rbPTaE0zeX0edwMaUCmOWhPnNbMTA6jRLX1hKVrm8Zx+ad9Xt9y0V8VyuEDgzFxw6kSYUYwSHAg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:18:44.9013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d40ec39-a33c-48dc-b931-08deee1b8e2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9811

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

