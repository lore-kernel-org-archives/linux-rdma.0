Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3DC4A5C30;
	Thu,  8 Oct 2026 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466194; cv=fail; b=NivrA0Y16UIbRXHi+TOfsIapkURtvQ3moZne+N1Ous/lrrFUHgY7cDGrO5di5a/crdvJJAGLqrG7srCP0BwCsK/UcSSeLw2PtLe3wGBcG1277bUJAu/eM8IXgWsSCACNDWC4Fzi33l78Kiq4IJ7BGAvUnnO3Yv3R8OtpA99mxNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466194; c=relaxed/simple;
	bh=yYFiR8zk8/ScoK1w1AssC8U7OSlUOwkGK2YpLTOJDgE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUZQ7aFYmXUATptb5DEKiuj8DpUr7U8obqnrk1EwMvWMsBngtnZWwPu1Sa03pZfid5DNci/7U9xJywlwnCAVl2IP01Ue3ddRw3igppFBP7Ytj6qGCYPZ03DtKBXv5ZPBUSHm1nnocAnZ/8btDekZx+jB15LOWDxINvbxNZWP/lA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G1kuBbH9; arc=fail smtp.client-ip=52.101.193.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G1kuBbH9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTV/+hye/6Qvbd9MDHa9HXwnUFBg0iXM1SyoL7SNiUcIpTAxe2W7HxxPx7ZE0ZYM6DGGYRm2vB33T3/kKl3Aaz0+2pXAYg3Ir4CXbRQmHtKfS+98nYqEc+cBOih4eqsy66JurqX4cBMzcZxfnNfpxZYAun4tEWplpvYZG0mMzRRbIkDZkSY8gNJ5OVtGmrOyK17uEtD+vWl3L9o2JlbwQgZasKlq45og98I75ecRvtW2HysDF/3Og9Fbxj1xn+qoMFpFNzvVYP95S2nEfKXMU4OAq6fheAKacVYqWI6PNkBKQUhgpY3Gx4CPNzrlDUojhcsBlZk0e2eefzcmvyqztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mc3IAkUZ5iLKKlShWkv6wbaUWJgRgEIeIOaQyyWIws=;
 b=B7FR3/he1Vz1AD/9RkcNlQMwyaTcjRYtcZ58kfVL4xjDU7gi+VQZO7AvgBHB4wEMS3vCcKpUgVzQew3Z2qXWDXiCMHC6HbZLIXygl6120uq0jpt7J4AkFX3xfJLUDXH93VxQXr1ItRgFQLg/jnNZlRThFASL3IzF78a0rilXfWkBXL3Gua+VT7Zzui2QY1SeH+bbIcXoIv+ozbh/oU4/Z+czQAYuggPpYBb8V67jtk80kC+wJvsiisz3CsXiwMmRPSaO2P6L9iSbUBlwM52izjIqaiyntstK1AqnxwT9E56gSu6Jr0GP3ERkoZwYKME21ClCJ09C+GQfe1EWhUC7Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mc3IAkUZ5iLKKlShWkv6wbaUWJgRgEIeIOaQyyWIws=;
 b=G1kuBbH96P4j8DXPsyMBrBkrb3pjAXW1+BuqFkKCGV7nap/aPq3kACkbm/KNcTYPonSE9VXYfe7/gZ8otilMntwU3vV+Xk7mu/9lxMUIsShBWP6d9ODW8nYZ+sq0+q2AWfXnCBBOT+04bKE/XVJs8Cbx/3h6BpMMxGP4/ElQaTbTCVRst5REQqkf7L5WvqXitjhLQHIXbThLjDBnxCM9GhGZ6KjLlFh6KAw+OBicqe4VBeITHwmnBpgCbapPTfGf5e5PSszxADm2AgaOsQdJB4g+rTiRfWGU3izFIHGte3lbIwGbS31L+HCMda6pGfSPyjengkdcTVkmKgbr99ZZkA==
Received: from PH1PEPF00013304.namprd07.prod.outlook.com (2603:10b6:518:1::16)
 by PH8PR12MB7303.namprd12.prod.outlook.com (2603:10b6:510:220::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:29:44 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2a01:111:f403:c902::f) by PH1PEPF00013304.outlook.office365.com
 (2603:1036:903:47::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 8
 Oct 2026 13:29:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:29:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:18 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:29:11 -0700
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
Subject: [PATCH net-next 07/10] net/mlx5e: Use the correct DMA dev when data_direct pdev enabled
Date: Thu, 8 Oct 2026 16:28:12 +0300
Message-ID: <20261008132815.654147-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|PH8PR12MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 57a3c705-9d09-4c82-f6bc-08df2540370e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|1800799024|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dXRM91g+WxVtHl8jk60bwY0I8LU7jsmp41ZkqbOXfAoGx49wW8ebIsCv7RQK/VNdNSjM8sPUGJczUtuYIrsvY15B8nitt7fDO1vq4SPPRjdQOD/axuMMNA3xKpWWyI9DRzOIy4AWWoAVwFhDZDBZ8vp3JRn3rERYVoP53L2g0oii1IJbCwXCNitHH+yOOlZF3c8KrmJ6HX5gCl1+h60oy+3ZNd4sf4TneMJeUF4DsQQUSZXv9bfoMOu+L+ggfhCsc2azsTfbqkiJ9WTlyjGFncdEGpbF+cJKRhT2gBHESpN1v/VHZ6KTlDkAc4fboHazDChbLOmiTM2J70bRNLyKZV6IAdjxySIWWVCKEJT6jPR1uiQW90Qvfm253aO35NcykBAO66Y90gEhoo7pQIq39SL+wOIWIFsYaMmqamQmU4iRQMyZF/TSejTsyurDoZJxTW8HO1G64sLySymq9FNMioBw2WpzRTSX0VY8ALvRML+99QEsgJ/AeIgGetCoFDXskyb2ivtbdbTl/APC9j9ziR0aDWzeIe363SDeKKep13jrHetmSHsjf2Quiu5B4s6dPvqWQEuBlArAUKttcAFq6H84CEmddpEci4ZvuX6LPCoXh801lf7XoHtUxWLU6NTXdfZtKYCa1vaJL7rDYBbgpcFxN++UgZxpl7HJ+YdjTmux4d2j8qlx1Cw9Fwn/UOo1yb4B8ZyiE8WsrOGzRiTxFQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fXDXn7A4Z2QPjhIAWClXM5ux/KNsqCl7u68kUkMVKjZ+W/NEtC+pRVaLh8feyqGnrbCh2kmmZ3Qytzv76GenJP6JZanwxMOZkLCQbKsM6uHTf+gfmvocjHCFkJMU3uc1beetE+QZiJz5wL/vXCf/T9tHon/8mxzsS9VBR3TToihC1xK/vgyPacTVuyu3l4GV6i28sePYguJKX69IbilYFFZXSG/lpJq8JCfPyhICW0oRsKBolNSYNXuliJPNE8hDy2fzYVI4RAMcf/VsiF9YwzHsu8JLCdGRfSCuS2F67bBdfMIjDQEbNkUlC5RUZuTrqTCk+L2/O3wXRCQObRomhOCQAT5jRLsLyeEnRKKlS8wBbW0DQ0BG+fibZ2Urm+bVVbZjAb88qtkg+th1tOr3lu1iOeyvHHPcJaqH2RVLoybEjMTUKfwT37zxIRkOIMWY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:29:44.1419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a3c705-9d09-4c82-f6bc-08df2540370e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7303

From: Dragos Tatulea <dtatulea@nvidia.com>

When the private flag is set, always return the data direct
PCI device instead of the NIC PF PCI device in .ndo_queue_get_dma_dev.

Rename netdev argument to netdev because there are too many confusing
"dev"-based names in this function.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d5282a301621..6476baf71bde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5897,10 +5897,10 @@ static int mlx5e_queue_start(struct net_device *dev,
 	return 0;
 }
 
-static struct device *mlx5e_queue_get_dma_dev(struct net_device *dev,
+static struct device *mlx5e_queue_get_dma_dev(struct net_device *netdev,
 					      int queue_index)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_channels *channels;
 	struct device *pdev = NULL;
 	struct mlx5e_channel *ch;
@@ -5913,7 +5913,16 @@ static struct device *mlx5e_queue_get_dma_dev(struct net_device *dev,
 		goto out;
 
 	ch = channels->c[queue_index];
-	pdev = ch->pdev;
+	if (MLX5E_GET_PFLAG(&channels->params, MLX5E_PFLAG_DATA_DIRECT)) {
+		struct mlx5_core_dev *mdev = ch->mdev;
+		struct mlx5_data_direct_dev *dd_dev;
+
+		dd_dev = mlx5_data_direct_get_dev(mdev->data_direct);
+		if (dd_dev)
+			pdev = &dd_dev->pdev->dev;
+	} else {
+		pdev = ch->pdev;
+	}
 out:
 	mutex_unlock(&priv->state_lock);
 
-- 
2.44.0

