Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336059;
	b=VFrmRLSO2K2DzxvPVEWWN/3B9ffArm1rj+9N35+g1CSEYMVThE12FdlAGrt9fIFvpewr
	 S9o82AWUAD8xyLejOap+hdyow5re3ZqdmVFYWHCamhLeq4MKu90+FJS/YO8ZR7nJLhE/8
	 8/qR9yN4/Ond3uIkyEMm7J3bP7mTEb/EwY1d1OkU9N9Xh7hZPSiVijmIHYM7+cuOZX2JW
	 sk9FEXyO75vO7KWdxgyETh3uI9ow4DWr3JK0RDiIdita43MLq0WZYvnu8YWFiJJ7R3kY8
	 BwhJCIzCKweulyPQaASB4vCYBlrMMZhN/ACr/m57oi0MZTytxCiFY+OnnD7lHAL5pIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336059;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=xxbvl5a/IAbV3dMnPSV6l78AOywHKsHS0fXZzENIObY=;
	b=Hs0KDvFKKTaXnQTHKu9lHGMCcfIrR6Xe0LUgM8S/Y9Y8vmHZnMsiQJrWJoRe5WHGbmsm
	 ImMXREeu+dVT51vCH3sNqAvC9rt/7NgaKHv/Jk4K6uIlM2HE5AJCw9tjpCvjRbvgIzsT9
	 0gSmDR0rV9PYyEzyJ8Y2YEgz0oTsyuJza5+irCvSVC1h8Lw9ov+8zM1/GmfAu4oRRImy4
	 LAXODmWyrRboAhKl2C5gkJeCoL0v6QheeixbFxpka9suV0HhGFbjFN0J3CEos+TJ7gxBO
	 DHs3PyU6U6Zkxg2vl07fJluOUknivtO2pDdHk8F99jib2uPQIysvFNeQmGi8W7sFu9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OPVhWRUn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.57
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012057.outbound.protection.outlook.com [52.101.48.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D40B60A2605;
	Tue, 10 Nov 2026 18:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D40B60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OPVhWRUn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZex9EWwOP2ljWck+3rrYYSQkwq81O/CRl3gI5a66BO6J3FarPH23AYgYx2Ar6aoRDFDE0f34F0xCoaulXNazW8uOPwx/PfrRCw9szu0/s5PKLDLDXgEVZFNgAwzqeu7ehyVWRgl0ePHN1X7xXZrpZshLtO9bU2lTsNwwhqUaLkWaMZMoQqStp9+62zId2k1GvurZcMqaCQVqVxmop1No//7Q91KjTbnzej856bElNsle2MjOEQidk5grfeWgMo25MiAbdx9NCgI/sYHPAQVVyledI5K8WsThh5fEE6CYkBai5wL/dxBCfT2B2JZPluaOl+tuNFYx/jn0q76h8P6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxbvl5a/IAbV3dMnPSV6l78AOywHKsHS0fXZzENIObY=;
 b=ElZuyxgnJUmPpwT6BJ/YNag/nEjs1lYJbbz3bGuEhvtokAIssz3HtV37ZukasATnw/emcbfgkj2VneZDID5emGOEA9oikR/Sic/PGTGp/qhSQ0VZthtqaF5w7sgTOwcwZ8ZV72FVJstkg3A6wiweCeIlDROgkHZnSJCoursTriqVbolxHxqRHWxiFSr1eMeQfYa4kYTg703qnW/tyTnFA/m5i1v06WFM7x+Phchc0bq9eSviInqEQtTSFrZUxPRM4dMuyw7kd947dxVx8sCNL0Wth75kV8AjUbnLto6IxDgR6QAsFm0vskJNYKarZP1wKAAKECxtQ0KjqM8J2ezYSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxbvl5a/IAbV3dMnPSV6l78AOywHKsHS0fXZzENIObY=;
 b=OPVhWRUnUr6btsNHpxUsM8Hi1fEgX7BWkCDp5jTlk0+SV8wQ9UrKEEIm80HIaEPEDSFBt7McGpea8Uq2mTEJJJUFPj9caSqJ4RHxeyhKBlyBgVhi4xqjJP/YuhuozoQrNj2joTL+1gOCndrhPyhfqQqWujMJBcOtjGw/Cz2G3lPYdOZU8GgIThr6faExHn2R/3ZS2IFyHR62V1ycCj4VzL7uysV8B0xs43y467HMZis+2Q0hU1kaTsiEBNEK4Cs5DwSWP6xftj3IwWXODgi/2RTSeIYQanf3OnXxPAZ2hdz/7kfcUPWwEeoUVcWAtpQ3XCxle4h1SCl2Jwr77THxkA==
Received: from CY8P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::21)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:40:53 +0000
Received: from CY4PEPF000392DD.namprd03.prod.outlook.com
 (2603:10b6:930:6b:cafe::ad) by CY8P222CA0002.outlook.office365.com
 (2603:10b6:930:6b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:40:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392DD.mail.protection.outlook.com (10.167.247.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:40:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:30 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:40:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:40:22 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 13/13] net/mlx5e: Enable the data direct netdev feature
Date: Tue, 10 Nov 2026 20:38:26 +0200
Message-ID: <20261110183826.2927274-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DD:EE_|SA0PR12MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: a3218659-1e5f-4e1c-fe93-08df3f5a2658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|82310400026|1800799024|36860700016|261026140227099003|261026121527099003|261021123027099003|261028144727099003|261009223027099003|261021121427099003|261022105027099003|10067099003|261102123227099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M/ARiApQZab83VkP1fHAWDooklF1t8UTYuOi6ixguwTbKZYiEtI5ULI7E7vOaxCABXir4bIPQUmvbU6AvtzPOWubasGiiohH2WS3z35n0cURrJx3DXgxNtGnqILXPmnXNdFVk6hj8Ph9SG5CbDhLtoFc1m+bgieY59dTglzKMf2bmrAob1P6vjyvVIGr81ttCQz+CrCbq5IB1Cm7dZVrAIsMr9LhPcDtvBmYwtuAxG51cn+KMHCmvemmVPmkL2tm0bGmhipkBbE9rkvLEROP3Ed9cdDVcTm6ENbJcxgFZ3avEprn1ABlNX/EdRXcNU3HugLXYo77OEj5BD4eCdOR7J8PYpGIjwp8TBdG2w9KmanVbKjoEsETomvyN9FXbyzsm2H59S/1uGwHNbgZ/Mr5gkO439mCB2dJdH85e6dNgleievgs7Jn6yZYrv4qm1W/k+oxCopOoI0uscprLdTewBMLF1Uvp9+u97UIrp0UdrLlLGZkPEzwtF+2rYU+DDvg/4pAXHBHiu0eUrnFWl0UmMUBHTS3QC5EefxKerK5FvD3Wky1wlPidYo7nY2ku38/thCDSUaMUZPqA/XrreWMXpPAM74M1LpeZF7fURTHb/Og3S81+Harxn/QkUYseulR7mxRiEI3a+bFPukvF7CqRCdBlCrc5RpfcIHzvNShKA44/z5Ha8nxSA1iecJoAgf8BosaSeh3GF+/+8kboO4LuKA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(82310400026)(1800799024)(36860700016)(261026140227099003)(261026121527099003)(261021123027099003)(261028144727099003)(261009223027099003)(261021121427099003)(261022105027099003)(10067099003)(261102123227099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NbEDt7eOdlrhxW9mwDOJCakO3DgkR9COopAo7mmz1XTUj19st3XHdWk0pW8BJUWXPcbYpC0rzHaiBX1Q0oYUWMiQvVLDRhdWBDuwx2i44QF6rj5DdzkL/qGbMB+xGbJzJEvaE4Yt0sPLNI2Mbqbgez1/qQY+yR6+UZslti0MD5mP6aqH9nql7mLOpQRqLaWmJuRESVdkVGIkwew6VJdtoZD+pPSf5q23fdrBqYgilhwRdobd1z4QIE49UhGkdhzFQgitfi0p+S7dAq+guCbkpS/ZtXugDD2X8neQZe678YWEhhFzoARmvZEuiY1ozB3JCyL9I+29ZfJyoD30A9XI1YY69Y5p0yfWoOyIcKt7yblD3lgmmzd/zVdgW4WoXo1JVVqthtmu+JT29wiBgB15V/rCzW1l53lyfdaY7/foC8TLrMXd+CyGlwtuouBw2vRq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:40:53.1667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3218659-1e5f-4e1c-fe93-08df3f5a2658
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002

From: Dragos Tatulea <dtatulea@nvidia.com>

Add the implementation of the data direct private flag.
This enables the feature altogether.

Do not allow state changes while a memory provider (devmem or io_uring
zcrx) is installed on an RX queue or while dmabufs are still bound to
the netdev for TX: their buffers are mapped against the DMA device of
the current mode. Same for leased rx queues.

Reject enabling the flag on uplink representors or in socket direct
mode.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 63 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 23e45e87cdee..cc7cf23b5c56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1155,6 +1155,7 @@ int fn##_ctx(struct mlx5e_priv *priv, void *context) \
 	return fn(priv); \
 }
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
+bool mlx5e_has_leased_rxqs(struct net_device *netdev);
 int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 			     struct mlx5e_params *new_params,
 			     mlx5e_fp_preactivate preactivate,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 26f76449af35..2204b370f439 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,6 +32,7 @@
 
 #include <linux/dim.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/mlx5/data_direct.h>
 #include <net/netdev_queues.h>
 
 #include "en.h"
@@ -40,7 +41,9 @@
 #include "en/port.h"
 #include "en/params.h"
 #include "en/ptp.h"
+#include "en_rep.h"
 #include "lib/clock.h"
+#include "lib/mlx5.h"
 #include "en/fs_ethtool.h"
 
 #define LANES_UNKNOWN		 0
@@ -2407,7 +2410,65 @@ static int set_pflag_tx_port_ts(struct net_device *netdev, bool enable)
 
 static int set_pflag_data_direct(struct net_device *netdev, bool enable)
 {
-	return -EOPNOTSUPP;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_params new_params;
+	unsigned int i;
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
+		if (mlx5_get_sd(mdev)) {
+			netdev_err(netdev, "data_direct is not supported with socket direct\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (mlx5e_is_uplink_rep(priv)) {
+			netdev_err(netdev, "data_direct is not supported for uplink representors\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!mlx5_data_direct_get_dev(mdev->data_direct)) {
+			netdev_err(netdev, "data_direct device not bound\n");
+			return -ENODEV;
+		}
+
+		if (mlx5e_has_leased_rxqs(netdev)) {
+			netdev_err(netdev, "data_direct is not supported with leased RX queues\n");
+			return -EBUSY;
+		}
+	}
+
+	/* Changing the flag reopens the channels with a different DMA device,
+	 * which would break the memory providers installed on the RX queues
+	 * (devmem or io_uring zcrx) and the dmabufs bound for TX.
+	 */
+	for (i = 0; i < netdev->real_num_rx_queues; i++) {
+		if (netif_rxq_has_unreadable_mp(netdev, i)) {
+			netdev_err(netdev, "Can't change data_direct while rxq %u has a memory provider\n",
+				   i);
+			return -EBUSY;
+		}
+	}
+
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 63d91ef0dda8..ba4b09ab2d70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5914,7 +5914,7 @@ static int mlx5e_queue_start(struct net_device *dev,
 	return 0;
 }
 
-static bool mlx5e_has_leased_rxqs(struct net_device *netdev)
+bool mlx5e_has_leased_rxqs(struct net_device *netdev)
 {
 	for (u32 i = 0; i < netdev->real_num_rx_queues; i++)
 		if (READ_ONCE(__netif_get_rx_queue(netdev, i)->lease))
-- 
2.44.0

