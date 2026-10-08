Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586264A1DED;
	Thu,  8 Oct 2026 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466146; cv=fail; b=lhIwIUK0dgsnEvRHseKpEokEJRPSmY9AblD0qayX1brXGiwUPYdDMRrkheRr/VuLB6Y54dUcTZkGveO/jtjMLayGblzbiFDtIvxny85EIFDVdUOSqk1xytUZSfYhmJu+epCkPG2hR6fKHj5R7E4xulgG9Icg4vnZXMrQQfq7gCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466146; c=relaxed/simple;
	bh=OkRavgvKxBP5eMUZYRlX3YwlOa3J5MtzCFK+a1KSj4o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7PryKvRue/AZ5ksWf85DRaquitFlzBfhHxZ/pS4s2meCSMJNhhffaz+gWuz7rJNrD1cDjwnMJLG2fu9n5vnmH/hB7UdknxvncX9plZ/C4raI2viWze+Xf6ThP0lGLCm+3ra10cORwQMBFLbxv5QWEzF9cXTd7abSi7p+mOPgVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WeLV5XZH; arc=fail smtp.client-ip=52.101.52.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WeLV5XZH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjC7F3u7RD7xBlfYSfE4nHCN/+FzaGuaPyKRHV6oCbA9yvufUJHuW7DFyi5rQZiMu9DdVhmBUBbvHEDUXgB/wdJ6vFttbE/W295pwkPQO58CxsnNj1QWU7oVdXezZyPQvcrR1A9HU+OTYPqTfyEoZZRZzFUiSHQ2SeUBj4b9th4XPmOh9HWTt92AlbivoG+Mm0lkCmWcPB1/kdDq5suK6nUFci8GhLfEQVP0+qnsyFX0v86hQBFMPJjvzTu6SvzUZ3DnMtHxsAGKcdBFe9Br75uTqmZUnro1AcVZlOrAypR5bH7/5+Ax6o7hMzXIbeKJp5ZdzPN3h5R5YPd88cPecw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xfvNs7k/Wry1W9cybwhy5u8nfHXfVI2ywzx1JGu1j4=;
 b=Y/VQ2Kpm3Y+EcSdljgoLJNagJIxdXWYtdGi2paaWBJPW2fTVGbSTRewmkH89HHKa1bQIDg0pC/Vfkiyl66omMdwv6rj1r9PKYMKD6elNqQuNrkVzMjlxkG4wVWiLUejWvewHA4b1OM/yOU0YWWqMtfpWlY0rxVGVgm4Gi3W0Z4T8JfpOdouZ5vmu8Zxcblfnh5IU5sBDk5fw6llvvhhn7VsWNhE096BapWJTYujKv6dGs8vycEYLlgZDW8pSTTTLOJZDP4iw7pKM9bCzw3v9raUKzjBdsjjn4dK0OF1CF5JZAyXfzJpuckGWeHedTEA5j0VtbvL1i53JlvFTQ/0urw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xfvNs7k/Wry1W9cybwhy5u8nfHXfVI2ywzx1JGu1j4=;
 b=WeLV5XZH3QuRSwH6jTBuCcQhQntveKELYs9shFMWVwfcjZWwDRnDHA33X8yf2t7Mw8iSI+EWM7C0Nl0K4VMtbKu33VT1VPajwLzQrRHv+JA40xfHMfFJctVqn4UW5KvEEGFFvY0XD4xNBSXXrguf/hmRjzubILw7guIMXqnZ99beYRx5Po0PF+3KD1oy9vAnRE4TzKdYuveTI1aCoT5ZyKuykGRBhxKo58f5TnmPck3FSJea7cod6FBVABdnO67rkxMsnJlU0ldfCZ3iYuwb5iVcdB/7GYj1cnzNtrBJWHIAeElAaPtZgiOMdBktXlSKUQILJIvfN77yclA/Ab+RCA==
Received: from DS7PR03CA0257.namprd03.prod.outlook.com (2603:10b6:5:3b3::22)
 by IA1PR12MB7640.namprd12.prod.outlook.com (2603:10b6:208:424::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Thu, 8 Oct
 2026 13:28:59 +0000
Received: from DS2PEPF000061C3.namprd02.prod.outlook.com
 (2603:10b6:5:3b3:cafe::73) by DS7PR03CA0257.outlook.office365.com
 (2603:10b6:5:3b3::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu, 8
 Oct 2026 13:28:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C3.mail.protection.outlook.com (10.167.23.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 8 Oct 2026 13:28:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:41 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:35 -0700
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
Subject: [PATCH net-next 02/10] net/mlx5e: Register supported netdevs as data direct users
Date: Thu, 8 Oct 2026 16:28:07 +0300
Message-ID: <20261008132815.654147-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C3:EE_|IA1PR12MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: af1b804c-abbe-47aa-39b0-08df25401c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|82310400026|36860700016|18002099003|10067099003|11063799006|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	EebiGYMIXNa+mU6caLx1/Y0JSUNsnmxjwPdU5ne7jD27DiSB4jcraBL0ybY14MeqBZGZo6xtfn1yMH6Q3inRV6QRK3+FLixZGLeJxkP9SVsPxIdHGl0VzLRw8VXXF1KVNzkGsfIipkPUQ//bRXfMjE20MBpJIhgL2zpEhN0p6Un4TUJD+JOedBJQrqV+HBj0lP8mxcr5WthTRhWpRtsu4Vud/ufw2T7DkxNimBqSPLJgzrxYS6NowEkkRwfYxZtAEzi45fieCd9gFK1M0zobXI3WiQ9EekM56/ZPL9JthKm9AgccWD8uQOyLEj8pQICaywsQpKv00jems/By9GJQi6nwn4c5vmHUIeyyFG2igKQycTuyyxizaGvRLLGcjPL/3sAyKqQvEqxPHfKyWPHrYPpZ7Vkfi1xcJkhZZHZBP5mzEVEmlOK7msRpsZsakbDIWKU2OhRHZfGtqZB0+YjyK6SxZAenQWQ1ZJOYWjMwYU8ng3VuXiEyTmwT+1oeV4WgqOAKpFzRD12J5yCItWrpVexEjmHJmS0VwtLg2oc1tt/fJaFcPgqmzYxfvF5EpdkjGcIpYyZmKWSbncQ78D7WMeMyS/gbnUPNmVilvI3/j1jplsw8jqKv1vBmKHXT4xqIiWp30oE0+LDl98jZAdpBVi3CKiI4YWl51u6FjzU/tANy+x0aUwRY4aIMN1R6NVP9e1lzB8Dz5aNJfQa4kqnp1w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(82310400026)(36860700016)(18002099003)(10067099003)(11063799006)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pBUvIDaEz6jjdXt3/LDUgmMLCoo5B58GHumiVRLQIfVoyd33tVSG7VCICI0cuqYiYWLg1mijCt9e/V+bBHtJzl8X2lLumDANK98WuGCvHqOtui/WvMEI5pgxg0Eip/EHO1IeeVkqd9vVZnrOS05SM4D73aRRlTkjfn/86V3E7DVjU92zo/3zxvI5IEwS7XD9FEtsu3q6HC9N83ukxoLIrA170ts9QyiMp0wqD5c0HE+coPcFfFgBPub7YHUPo5F/pBcF4g/3nQuy64qvi8yA9i05op3kw35u3GnZ+VhoC9V+HvxgWluw/KG4B44ldhDIfWybA4mJV/wkn+9jNNaQMxMVrAbdBgDAU5Ly2ZAyHV6KCwmoB5pothTqFoQErH1zQmvd6JgLKBJ6jc3g+aHaHqC5b1ZSf2AN+qXzjyX/rRmWjqEr8wFV79MkSfECwszX
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:28:58.8081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af1b804c-abbe-47aa-39b0-08df25401c1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7640

From: Dragos Tatulea <dtatulea@nvidia.com>

Register the netdev as a data direct user so it is notified when the
affiliated data direct device is unbound.

Register during NIC enable and unregister during disable so suspend
and resume follow the data direct registration lifetime in mlx5_core.

The notifier callback only traces the unbind event for now; tearing down
the data direct datapath is wired up together with that datapath in
later patches.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454..78cf6aedd04d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -984,6 +984,7 @@ struct mlx5e_priv {
 	struct mlx5e_mqprio_rl    *mqprio_rl;
 	struct dentry             *dfs_root;
 	struct mlx5_devcom_comp_dev *devcom;
+	struct notifier_block      data_direct_nb;
 };
 
 static inline u16 mlx5e_stats_nch_read(const struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f90b5a34e097..a2b3ac3011c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -33,6 +33,7 @@
 #include <linux/dim.h>
 #include <net/tc_act/tc_gact.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/data_direct.h>
 #include <net/vxlan.h>
 #include <net/geneve.h>
 #include <linux/bpf.h>
@@ -6023,6 +6024,18 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 	}
 }
 
+static int mlx5e_data_direct_event(struct notifier_block *nb,
+				   unsigned long action, void *data)
+{
+	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv,
+					       data_direct_nb);
+
+	if (action == MLX5_DATA_DIRECT_UNBIND)
+		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
+
+	return NOTIFY_OK;
+}
+
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev)
 {
@@ -6225,6 +6238,12 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 	mlx5e_pcie_cong_event_init(priv);
 	mlx5e_hv_vhca_stats_create(priv);
+
+	if (mlx5_data_direct_supported(mdev)) {
+		priv->data_direct_nb.notifier_call = mlx5e_data_direct_event;
+		mlx5_data_direct_register(mdev, &priv->data_direct_nb);
+	}
+
 	if (netdev->reg_state != NETREG_REGISTERED)
 		return 0;
 	mlx5e_dcbnl_init_app(priv);
@@ -6251,6 +6270,8 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 
+	mlx5_data_direct_unregister(mdev, &priv->data_direct_nb);
+
 	if (priv->netdev->reg_state == NETREG_REGISTERED)
 		mlx5e_dcbnl_delete_app(priv);
 
-- 
2.44.0

