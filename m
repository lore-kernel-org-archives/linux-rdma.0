Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C794ABBB7;
	Thu,  8 Oct 2026 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466219; cv=fail; b=JHgr3gyZGLMabExdRJ8WdkmGxSnrCid5k55j0AIL+qUs3kwJxy/flJTwr+DqLe+KQKeuRpmPuMv68YW7PVL5AXKU16AF06lMoEWvZoexyUukfKhupy5T5KTT2XzFrqVxxChC3uSXtJJt/XL/YV72FNai1AhKg91kkpHO7h/k/Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466219; c=relaxed/simple;
	bh=8pwzRNDYWqISAZYKPMRX7QWYOLngJiXHpw1f8+9Qdkw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDXogfE9wBKCOj3VtYXjc/6swbUbM34i1UbVy2x/A9NEvH8Nrvo9rEwbVR/k/hzlFe7kqRYJACU9jhplqhArIcxDTEgCdkxWFsO4+j6srsgicjNmiYDZ9BJO5YrZeCQ4mVkT6AKHH0uaKH0RqKzh5JXcaGwyfR9tTh5SvfxwYlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aUFGSMb1; arc=fail smtp.client-ip=40.107.200.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aUFGSMb1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZzIsFWNr9VzWkwTCl8juv9b6lFbm0B3h64ISA1vJU/swN/PsQ5aXQWhwh4RJS7Bw5BU4a/0hYe0CKMcXfl9wUY/85urjRyTl67WFIqfwbSDynWw96izmU9vROqLFu/ea+wqaMl0PIegi9h6Zp3tRipo9i9BVKHdmGixLa4Zsml20UCvd5vhjzO+CP9K+Y7NRGcmt+1yWY4nzo1pYE6jphy/E3SzBk3ZIXfkwXgBTfihSWhZ6ucflfLsAFGct34yC7PDYz8rW3COZE2BdqtS95rJY4GGJ2PCtWi0v9FwqtT2KvKC7FieQGVCFTznyN8E8xdvaMX2ycbqybybKhk6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeZmkXOLKNw6JkjFbr2vzDSkYYgx7TRmNmvSQi27b0M=;
 b=jpU64YtLL2Y2D6UyNIhJOR6XNM8ooKM0wsUS+RqJAieaqPMnsf6GrVVAKSwZEVPQTCdpAy2OT5jjOKZAMTNZxIOvtZt4dJ5ti0V/mHC4E/RnaDkwvSxH8V49KK2i+p2wEC493wtHEgNZPCmP3XkYU6+JW+5zkrWoxl0FiuyrBwg1l7AhMjT5OxFRRxwg11E4Zw3YNbvAaH/38ocKbQZxetzdcgrel4qtQRQje7ikvocqATGXb01+E1VQR4jBIoQ1Pu371/be26MdbgDz+8KN/C8G06R94OfT5sLrgwjQw+TMThrUxaGENay+OOuCvmHf+E+Bkqn4P79nAElNrJU6yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeZmkXOLKNw6JkjFbr2vzDSkYYgx7TRmNmvSQi27b0M=;
 b=aUFGSMb1F79y2EskWc2ksWR95RNqLWrOFlKAYCtnQcg4a77pquGSyIkV360Y0tAXeka1bQBP2mZU5hiqx5MIeLc0RKXjRFwJAMX0JMSHxl5V/0kzEOrKR5+q0mWOvMu5hYVCpJO2SQKdM5VzV+ntwr2LAhcNAXjk9Ob3jkG43fE+Pm6P1fX6iMFsqldX+0ILKebPIxEygEWrdw8HxDI4SKhxp0wNRivrB6+GYvhRbcktD9TF1HJTntbyMBrXbIqc1VT41gD74wHGHfu5oFubK9ZaTcfx1NXxAS7KRUVJP5KpoFNlKtcm81zWYxUnXISkrYznJelzNN5h819Ubp+j4Q==
Received: from DSSP221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::8) by
 IA1PR12MB6281.namprd12.prod.outlook.com (2603:10b6:208:3e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:30:03 +0000
Received: from DS2PEPF000061C1.namprd02.prod.outlook.com
 (2603:10b6:8:3d5:cafe::24) by DSSP221CA0011.outlook.office365.com
 (2603:10b6:8:3d5::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 13:30:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C1.mail.protection.outlook.com (10.167.23.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:30:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:41 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:29:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:29:33 -0700
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
Subject: [PATCH net-next 10/10] net/mlx5e: Enable the data direct netdev feature
Date: Thu, 8 Oct 2026 16:28:15 +0300
Message-ID: <20261008132815.654147-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C1:EE_|IA1PR12MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: 20dddf42-2fbb-4331-a5b5-08df25404203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|36860700016|82310400026|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UZzDvJLEzljHad2YsbaJylYQJRPvwtaW9eCu4rHrBxcWsYeyfyjzkR4P3Qya1/Z0aCZLFoM3UJFYH9EM3thOvbFEmpAPMZaM32AFSSWCVleS3KpXwdg2UxPg2YfeOblx5V3cuLzFPMLPf1oT7LgtdzRtIBQ7lBu+m9KbyGjV1OC/9lANPINpNPgcF7RM1WQ9GGY0CuM5ggB5wpdhTMLhXlELkPz+tW4nIMzwexI2p0m5LPSWdBzu4nGSh7t7foRWgGgG8+Nqw96E4c2sPaObH4i/pSDcrBPaCnE1X7pqStGohd+xcMDIKaRjH0e1QQp5cQbLpKZhLr4t2iwvC7TU1sTN9Qj1nWHZUz371MY4Xg+JrE5LxFIg5KYwuiHuIub4yvq8PzTlgVGM1t5lJRyRFyCmAacG1u/ZorKziqO0NkGIOQiWWHfKvoRT/KDgpQZW0nuqbjRkxK2FiWczZEY5mGBiI5IWhbeNS1Adon1zMKys0z0VtqXANeSU0arCttPS6Fve+eCNHuMukVXnuyWP+szL1Wl5hUQKWaFdM4Cmk7ryYAYn0B7Aipi7fasloWrr5Z6zosmmM4IPfbOQhcZaBVBZhP9zFQs9A6cxvu0JkpY72NTc+O6dzIJB246EU3omvJ2riV3ls4Iimre6K8UW9clBsAFVMydkg3ilmk1NcHoBFXrKiyg74aHgMa+EV9KNcDYsdUyiKSv6hZio+VcyHg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WflPdj6rH0Np0JCukjpnQ5lR+m8WrCZ4nHGs6lmVMN09PocoACjzErJM/oZ4oXoZmzqXV5OCVjWFrCrvy+PVbO7FRXdlOFw5rvZDhK0rFU594LRZPkM04N7ijnwUqt4nXic3K9XzCCObH4UJ0wFu8P92BbOCl4F/GFlBqvbgPCnbzmK6FlGh2O0Y8CUbp6twZw/ymyvEbld7c4S/Ue4tP3iGitVRw9DWtUb8QW7tirvlXNPFBS0A8HKjc4j4TwI6AHnww9paJdTYPJNTfTtZ7vvbMEGidtwbvT9xwxt0zLuc4TQ6cddlQDG1ttPqoO0OJyeJYwhvRO1n13azXwj1LJgRFcpF8/1u9A1jIHzlDdpH+tkbNX5AQxJUcwBPtSvXsuPZ0HXLWFlMME+qgWmR+voxtLPRcUdxpkYFaitsNkSpvDF60OFUOXagnaXbdxZU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:30:02.4137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20dddf42-2fbb-4331-a5b5-08df25404203
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6281

From: Dragos Tatulea <dtatulea@nvidia.com>

Add the implementation of the data direct private flag.
This enables the feature altogether.

Do not allow state changes while dmabufs are still bound
to the netdev.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index b3eced1dd43f..8ab1150ce3f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,6 +32,7 @@
 
 #include <linux/dim.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/mlx5/data_direct.h>
 #include <net/netdev_queues.h>
 
 #include "en.h"
@@ -2402,7 +2403,40 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 
 static int set_pflag_data_direct(struct net_device *netdev, bool enable)
 {
-	return -EOPNOTSUPP;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_params new_params;
+
+	if (enable) {
+		if (!mlx5_data_direct_supported(mdev) ||
+		    !MLX5_CAP_GEN(mdev, crossing_vhca_mkey)) {
+			netdev_err(netdev, "data_direct is not supported by the device\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!MLX5_CAP_GEN(mdev, shampo)) {
+			netdev_err(netdev, "data_direct requires SHAMPO (Header-Data Split) support\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!mlx5_data_direct_get_dev(mdev->data_direct)) {
+			netdev_err(netdev, "data_direct device not bound\n");
+			return -ENODEV;
+		}
+	}
+
+	/* Changing the flag reopens the channels with a different DMA device,
+	 * which would break any dmabuf currently bound to this netdev.
+	 */
+	if (netdev_has_dmabuf_binding(netdev, NULL)) {
+		netdev_err(netdev, "Can't change data_direct while dmabufs are bound\n");
+		return -EBUSY;
+	}
+
+	new_params = priv->channels.params;
+	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, enable);
+
+	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
 }
 
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
-- 
2.44.0

