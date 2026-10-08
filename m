Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012003.outbound.protection.outlook.com [52.101.43.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936094A7C80;
	Thu,  8 Oct 2026 13:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466180; cv=fail; b=l0hu2NHtVKkyOx23u1J12hCLlPJhf8w7tRgine+3bJG01R6PmoyEFEubzLLfGFeF6io4KeMiNePZPPWtuKjW2BtJigeLHUk9cU4BDJGI1pOWxDOjn5y89qCp8hCownb2dOnrTx/3cpN9A5hKCeOZUaIsbUBf5cw6MiaEMTHmUxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466180; c=relaxed/simple;
	bh=xJsrLzVYgQi3piXvAzl7Fz7FBerRBtcX/rxKDd4F8uc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsnAWDSaaZnH6r6btLaUINffA3yBZdj94xKZxp6vE7Ids9MfdM9kpM/ElPoVjKtbN+p7yIRBN8u88BOZ0bkWAJ0kyC5sAcB+Dcjd4HHxD5UXFIRBdS7q05BoOpeu0nX+MoPZdKJ5UwlcMVPJyVlxL+S+EQmp7i6kgeQDa+BV5y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NguO9peJ; arc=fail smtp.client-ip=52.101.43.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NguO9peJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZn599MwwP/CcEykkKSnsF7auLKB7YcreLQLfsXy6Yx2UfGrDB8SHEmjVPtMFbsAeaWwWzBluyUo2hTuUcS1lh17EnrsHR6x2IcwGfTaudKjk5nJm9wjSyxmsR5jw1WWgCTub8AMmnx5mTxOIdQhFSvcgoNY6r6UUgt7Z3m7r67lI0HhkNCZRDvw6XDOSh6huCpJ1HkfIbraDjYgMO/T6gUSsvnogDMgAvjaIEZodMjnY+FVuSFvnJC8l0Nsdeqa2oIFhhAWk+ELSucu/acEO8FXKUY/cc64zLYZeKL3gKT3TsxNAxelgIW2Z10908h/1sEKmjJkMvQXJrxkH9IAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuZ4d7mHOTaGHYkA89Jmu0Gt6cYCq1DH4iRigE51G8Y=;
 b=LxClGz5gIYwvJH3ZZfW+dZj0rcZfF22ZWhZKV4VjL/5v+QR7/vR1sRNUP7A57rJ5wMWlzyzB9m7hTfGvRPpL/K4HABobDujpFGgbjiCGGgY9L92CcR/y7p16jmKbyPlcdBLVVhHKTPBYRncN4c90rvVSW9WJWzTvaJX2Bt9kqSOJD+oL7ytvELsf45G8TdgdICNJJG8wmyEyeQ9E9FUKtB1UnXS+wRNpyZJjwRefenmyk9620yq7ZrKT6rEoFPEqr4VRJgl5Htzp7jePGLfPH9KqiWuZ6uTF0FXtElatUM2A24KAqJG7Riw20rsDvlKtpNM/2CZUGUTUnQxLt24Q0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuZ4d7mHOTaGHYkA89Jmu0Gt6cYCq1DH4iRigE51G8Y=;
 b=NguO9peJqdHFU6S+dh6FcZofmoMcnBNifqD++4yArFV0bUoWihY+WCnLmABPdKKAYCWZEltmJyqRsZaHzG5p/uRI1x3OvQTq7Nm5D7OlPZSr0c06RA4UY+6UbapnwzAmfqMW2jhvKoSego7syv5i9oqxUu+PahiaaaRUOUgL7yH7Pof8H3ZEKM+lrMa0UTAoSFE7PQ9mLIbjmKeR26+55Mt6NaJxIqnEgrLqsw9A4VQ53P2RT81zE55dyOIxpQpau4Sa4M23fGsUbkLPVRlOm3vsdqxjIbM/Cvk/ZuU5wjQGnT6INzRKwNggxQgaeQoD96XA8a5lAu1waiaRPVwo6Q==
Received: from SJ0PR03CA0171.namprd03.prod.outlook.com (2603:10b6:a03:338::26)
 by LV2PR12MB999098.namprd12.prod.outlook.com (2603:10b6:408:353::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:29:32 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::53) by SJ0PR03CA0171.outlook.office365.com
 (2603:10b6:a03:338::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 13:29:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:29:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:11 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:10 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:29:04 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 06/10] net/mlx5e: Add data direct TX infrastructure
Date: Thu, 8 Oct 2026 16:28:11 +0300
Message-ID: <20261008132815.654147-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261008132815.654147-1-tariqt@nvidia.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|LV2PR12MB999098:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f7b7b2-756d-476d-cc9e-08df25402fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|1800799024|36860700016|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fzkm3fvlowrdUjF5o8/jEucOPVrfejmruZ27IoTqnv5aVxfxmCg8YeXYdMgb5wlSg3iwNa37NEtBGRjvt60BYhCgOT296jojCy3woGDB/RQxw7pEksuGfGt4OFtNRuBKZ7/ro0bdSaHqTBq6DWqJSnR4qAEVkM8OIymBgUmVmRG9da3F+bhFt5Ia7lcWjQ5RjgXmgF5P2pFZKR+/H314VHgjJzhOKOlb6IqJ4Qf/tkHtjBnBVxwGPhdXkLcVf0Vcp4veJYtv51MCmbWLjqXpqzh/8TpypvUhl+d39rctnVnCVavNk4A9RO3JY13WuBQWlqqRM4/kF2HU+VVFrqBEgOromzXTKV2jbD7xK/PUnIEPrBn+kl5cwotOptOkpEehdJgAPI3BSWPgNWclJ351m4+43YuFV4HT9ol/tE87MBEzTX5FT+RMyAidNTTxbdlbv3tRuA3MY+v98zGjs2HClCeAyGt/FAcfTK9YEWsV4hUGe3PoEJyZIoMreWvWwOCsJ7XBglwtXbXhPAkfZpuy+8wR7gdvkxkXGXdcweeloQk3SFDZk6r7fcEn6O7MQ17q8/EcscIX50HfRZ9DSYcHjbpoH45iiU+VqlJtsNhofJ33cecMKaB1bCBUZtXHFn/ypY09FusXyqWxWDddAtb4kD85TxG4K16IXFmcg9zZqhwonblL9gn7Ezb4i/91eQNHZMGVjKnuK4/qiRqzWrsWqA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(1800799024)(36860700016)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hLATAch0pHOlOKbclIzbZ0uIzoU6bGKqybLFCHhCxfgT+SYbHu21wGljydzqFEegG0P2XbRCbJjPKeHBAxEHHyIH+JO5FlzjRFM0Y1I/KG36+1b9ZzMLKzzAPvWNjpq/FekrxJL4RQKsnzbYualzJApBpVs7g2MFoMQygv2jMGCmcBbibvqeh/pxqibFyhIoYP8Hpm6VVmE/FOIDDkd+xmgcF17kUpYhxc0GJzB++RjOTnawaoikzfMd3gkU/PVKZMHWAWfjEYmDTrpAxpYBiTelJ+EY3CaUbPXYVY42TAN/rBME4YN7tLgqJ7m10iPSJnE3qtB0dbSTO10sYp8L+gYuw03kXWsOCyR+llpcLm5ilsq571mZYzhuVgOVuNHkvqp9zrA0KWaljxpydNRaQ5HUSsWvnib2OkTf6Vpl+26eRewZYIMXVLAC+yV8OOK0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:32.0063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f7b7b2-756d-476d-cc9e-08df25402fd3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB999098

From: Dragos Tatulea <dtatulea@nvidia.com>

Data direct is a HW feature that allows a type of peer-to-peer DMA
between the NIC and another device (e.g. GPU) going through a specific
PCIe topology.

For data direct to work on the TX path, a crossing mkey is necessary
which is created as a mlx5e resource. This mkey is used by all SQs.
For simplicity always create this resource and link it to the SQ
if data direct is supported.

An SQ state flag is added as well to signal to the TX data path that
data direct is enabled.

This commit has no functional changes. data direct mode will be
enabled in a subsequent commit and mlx5e_queue_get_dma_dev() will then
point to the right device.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |  1 +
 .../ethernet/mellanox/mlx5/core/en_common.c   | 38 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  4 +-
 include/linux/mlx5/driver.h                   |  1 +
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d716e70c6d47..23e45e87cdee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -397,6 +397,7 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
 	MLX5E_SQ_STATE_LOCK_NEEDED,
+	MLX5E_SQ_STATE_DATA_DIRECT, /* set when the sq maps net_iov frags through data direct */
 	MLX5E_NUM_SQ_STATES, /* Must be kept last */
 };
 
@@ -453,6 +454,7 @@ struct mlx5e_txqsq {
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
+	__be32                     crossing_mkey_be;
 	unsigned long              state;
 	unsigned int               hw_mtu;
 	struct mlx5_clock         *clock;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 8409ae73768f..b4a4ff877bbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -18,6 +18,7 @@ static const char * const sq_sw_state_type_name[] = {
 	[MLX5E_SQ_STATE_PENDING_XSK_TX] = "pending_xsk_tx",
 	[MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC] = "pending_tls_rx_resync",
 	[MLX5E_SQ_STATE_LOCK_NEEDED] = "lock_needed",
+	[MLX5E_SQ_STATE_DATA_DIRECT] = "data_direct",
 };
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c2d4bae533de..c1d3b2ba1864 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -30,6 +30,8 @@
  * SOFTWARE.
  */
 
+#include <linux/mlx5/data_direct.h>
+
 #include "devlink.h"
 #include "en.h"
 #include "lib/crypto.h"
@@ -153,6 +155,30 @@ mlx5e_get_devlink_param_num_doorbells(struct mlx5_core_dev *dev)
 	return err ? MLX5_DEFAULT_NUM_DOORBELLS : val.vu32;
 }
 
+static int mlx5e_create_data_direct_crossing_mkey(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
+
+	if (!mdev->data_direct ||
+	    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return 0;
+
+	return mlx5e_create_crossing_vhca_mkey(mdev, mdev->data_direct->mkey,
+					       U64_MAX,
+					       &res->data_direct_crossing_mkey);
+}
+
+static void mlx5e_destroy_data_direct_crossing_mkey(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
+
+	if (!mdev->data_direct ||
+	    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
+		return;
+
+	mlx5_core_destroy_mkey(mdev, res->data_direct_crossing_mkey);
+}
+
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 {
 	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
@@ -177,12 +203,19 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 		goto err_dealloc_transport_domain;
 	}
 
+	err = mlx5e_create_data_direct_crossing_mkey(mdev);
+	if (err) {
+		mlx5_core_err(mdev, "create data direct crossing mkey failed, %d\n",
+			      err);
+		goto err_destroy_mkey;
+	}
+
 	num_doorbells = min(mlx5e_get_devlink_param_num_doorbells(mdev),
 			    mlx5e_get_max_num_channels(mdev));
 	res->bfregs = kzalloc_objs(*res->bfregs, num_doorbells);
 	if (!res->bfregs) {
 		err = -ENOMEM;
-		goto err_destroy_mkey;
+		goto err_destroy_crossing_mkey;
 	}
 
 	for (i = 0; i < num_doorbells; i++) {
@@ -221,6 +254,8 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev, bool create_tises)
 	for (i = 0; i < res->num_bfregs; i++)
 		mlx5_free_bfreg(mdev, res->bfregs + i);
 	kfree(res->bfregs);
+err_destroy_crossing_mkey:
+	mlx5e_destroy_data_direct_crossing_mkey(mdev);
 err_destroy_mkey:
 	mlx5_core_destroy_mkey(mdev, res->mkey);
 err_dealloc_transport_domain:
@@ -241,6 +276,7 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 	for (unsigned int i = 0; i < res->num_bfregs; i++)
 		mlx5_free_bfreg(mdev, res->bfregs + i);
 	kfree(res->bfregs);
+	mlx5e_destroy_data_direct_crossing_mkey(mdev);
 	mlx5_core_destroy_mkey(mdev, res->mkey);
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 	mlx5_core_dealloc_pd(mdev, res->pdn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e0d46e067c72..d5282a301621 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1825,6 +1825,12 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_DATA_DIRECT)) {
+		u32 mkey = mdev->mlx5e_res.hw_objs.data_direct_crossing_mkey;
+
+		sq->crossing_mkey_be = cpu_to_be32(mkey);
+		set_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
+	}
 	sq->stop_room = param->stop_room;
 	sq->ptp_cyc2time = mlx5_sq_ts_translator(mdev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..62ffb41a64df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -182,6 +182,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			unsigned char *skb_data, u16 headlen,
 			struct mlx5_wqe_data_seg *dseg)
 {
+	bool dd = test_bit(MLX5E_SQ_STATE_DATA_DIRECT, &sq->state);
 	dma_addr_t dma_addr = 0;
 	u8 num_dma          = 0;
 	int i;
@@ -211,7 +212,8 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			goto dma_unmap_wqe_err;
 
 		dseg->addr       = cpu_to_be64(dma_addr);
-		dseg->lkey       = sq->mkey_be;
+		dseg->lkey       = dd && skb_frag_is_net_iov(frag) ?
+				   sq->crossing_mkey_be : sq->mkey_be;
 		dseg->byte_count = cpu_to_be32(fsz);
 
 		mlx5e_dma_push_netmem(sq, skb_frag_netmem(frag), dma_addr, fsz);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..4c8b447337f1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -678,6 +678,7 @@ struct mlx5e_resources {
 		u32                        pdn;
 		struct mlx5_td             td;
 		u32			   mkey;
+		u32			   data_direct_crossing_mkey;
 		struct mlx5_sq_bfreg      *bfregs;
 		unsigned int               num_bfregs;
 #define MLX5_MAX_NUM_TC 8
-- 
2.44.0

