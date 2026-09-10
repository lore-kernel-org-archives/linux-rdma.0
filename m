Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C643E49F9;
	Thu, 10 Sep 2026 10:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035958; cv=fail; b=IzkoSjPISz+9vhbanjvCoQY4iI84/uuug7t7lH0OTanaRQODsNOLkxfMiDKiFsE76isnQ4eLuIUe121CGayUkW5glZfvE4tNr0pDlSuHUp1FtrexHcTBmf0K61mCizl1Sypjf0DEi6nl33C5vPttn00I/SY9HKPapjVh00zHWOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035958; c=relaxed/simple;
	bh=xhXlMWlmtaL/l+A3qrmYxD+vFS3orKSR4ApKKzUrnxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmwYuZa4pYQKbXQh4D4hyWnXTMvV9lah6G4AQQa1vjciqcEr/9viczePOCMWLQCAyUJtb+dcwLhDnq387ZDtqWXP7/ad2bDPVQ6pm6mUHsEEQP93bRH4Zj7H983uTU00USNJbxS8441eVBc1y3bMVNodVl+jS6i/O5LiI3ojt/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kpwv9L1s; arc=fail smtp.client-ip=52.101.46.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kpwv9L1s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3/W4/mX/n42yAjr8pHG5djjaYCJs/thirbN4VcjYSH3dHC6xPZoknCybVGbKgl5eOe8m2P5wuAfDbOgmwV2E2g/bXixMfmL/j9eiwb+hX0+FujD4eD2cTWWS4Divb/3e/YjBKQnb7vPh33UUo13GUgsxSHg7XbvTMw8ZMh+JxcR7PZFe2UoUGDk32SRKH1ACcGy9Wc9iwHdFFLqN8eXj9kr99HYrTZlYEkrUXUVtViFmxdWtE7kK3UtTHtueoU8COu6HqVMc0ctEyDxW4a7190jqSGrhhrX2NnlVUdxbsNzzdO7J/f+2DWnH0ZqMG3ZuVX6oGAaW/3nC3421CE0xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFrbBFPw5MZ/UH9isTp0UIJUV/s04mXq96fH0YCPmqg=;
 b=dg3YAwKrpvUeb35txCea/Cgg98OoKPtKxUUUCS9oe8ZrFjwR74fhhItSm7cDUviGGmWdQtUMG18hn09qEGUwGkwfdFNPcfJ6lKxaPEeW5UgQu8jMSZOiwGvVdE+wLfgFHYmzQtUFjmzxIW9xuYsfSsOGbE5vO1iOEnqZ2ZP05aOD1kg28ZW1EkE2GpyvODqrzbxmya2Kcv6TXb7ci3lNukos37Z9XXuGI6GJd9dCFR0Oub1IiTqqdLDMJeTRD6IdsxMo5oXwORhOvh/hXZplxwJKeKi3NrQ1kFHR6Q5xj442CSjV0CaAioSbutlXsT44DEzhDsn8LHb/TtkE2gmpxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFrbBFPw5MZ/UH9isTp0UIJUV/s04mXq96fH0YCPmqg=;
 b=kpwv9L1szrGbLUPalQFCvh1g1OxYPfqAQ9rPj4zBc6DG0YiMPvhxK4k//26MAwpYuV87edh1ZgfG1UwQyChCZRV+I0+tF7zPgDE14TVi9RURvBEgkPURil2yFqLvCnHgt/TgofYDoeaCoiEIDiK4WPsPHV4HJJD4RRypdl7AiQG4WeRGI/W7Pi6BvFAuvq7cERNhMGlQH3ffg18r6VUpI6tsGc8UqIOLYgEjNbYCOTDHMgxAsZABsKjml5aLMBJ2pQ5LeKpfi6sHTj9awK5+B5BhAdV7d5kUvoYl4aXvljT/C7fDirGGHtIi+XZBJX1TE3Aj2uJAZIodxCZrXNKrXA==
Received: from BN0PR04CA0088.namprd04.prod.outlook.com (2603:10b6:408:ea::33)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:25:43 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::5b) by BN0PR04CA0088.outlook.office365.com
 (2603:10b6:408:ea::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:23 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 4/5] net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth
Date: Thu, 10 Sep 2026 13:24:31 +0300
Message-ID: <20260910102432.3845360-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260910102432.3845360-1-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: bf74bd71-7f32-4112-c2dd-08df0f25de56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|23010399003|1800799024|36860700016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	h62jNqh48xon+NDO9ScloUEANG3u4DoIGZt9pTeGsiEoWQgXyslV2/g9NbBwQvQwVKWvNOw9dppfkjp6IiPeHBY0bf46TrWDDzpeA0h99RCobk2L7ChfBb/+1zS07YujS2fr/8t6+Ihi6CHSkMo/xg2aVnox7iVf132FJTUmlRMhCcV6EbnGEXRjlK6U5TCEI88o43DYrKkeJa5Jq+/Zh7xXbZ9+Qm7lzO3elhtLKvtjJilassHcEg4xTka/OpvufE7k7tlheVGY3GaNKpnGukOe9PM/uZmorkjQsGzsPq/JhwOBapHak9aiT1om7ynFsAnkmg9mWx6HmD8ZdpOMHUtSeErzNYegfI+PZvcEGXhvnql+GvXFbvaG2gV61lJiaP/za96GwpDopWSWaI6+zlEL9XQEKoP/DqS3cqH4RzTeCMP9+uFwnIPCtmjm4AaRI9pQooSl4gMjZ/jVoHeyOqpNBgwl1jwSL+Dl/S8zwwd9ChZxlj5c3sO9FbXjvBJNiXFQtNPNVU9ljogWLYB36wvTLBY0r2Ib0jIGZhAZSCaOD7Ix5F2xa8MTn7V7jEbDQRrSfMzK2f+7mV9f/L3hVkaWFDSya84D7xRYQ7ZZF3Yz0PxBiitbCoe1hS3ku3RHB87eQBd2NaflRmf15Al3b8ZhCTT+i6LybS1AzyMVvPTHooEqWivbA9ZUJpH3OOzepOdH8TphxZXz2oeLIgNglg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(23010399003)(1800799024)(36860700016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ydgsdYU61Z4bz7lGn883nRmlDuYRvZAu48a/DAht6UWqMjrSk+OejPf2GutXC/dZzdxJdZfuWjDbtKWhj0J9UfdShyBkmqL/NFVUTQWnv1CcwtOvQPkaVqVgI+4mDw3q+iCMjiOUsHpvAfD+DbzTOuYjtXJkKW0SkqvAocwJ5DzFIdmg0o8HI3B8aKP/G0aCShYAb9rL305LUUtEa0ummJ2BCYHMhDBqE3dBRfaO8EhShAyJDHnv/Oc+GTPZmjvYKOtt04xl5y34YHQTBMC32vSfh8n2YVBJZ/VNovaimSiMoSGtQBfvn2wWzOR2idBsM90MTwhtPXJm57BWv0lOHk4nHBDZO58hYH898bKKXd3NSYcYmtEp5vRkY7ZDFzA83U/KGDjVN5/egjoWnzMW9FeFOOe17tzUAB10xMKA9zTX5WXEcNrECBuJLFFLCExO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:42.6424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf74bd71-7f32-4112-c2dd-08df0f25de56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717

From: Or Har-Toov <ohartoov@nvidia.com>

FW initializes max_tx_speed to the minimum of the port speed and the
PCI bandwidth. Modifying it with a value computed by different rules
changes the meaning of the field rather than updating it.

Limit each uplink's contribution to the aggregated LAG TX speed by the
NIC's PCIe bandwidth and reset max_tx_speed to the same value when lag
is torn down.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 20 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 +++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index df2e3ad01819..81f3dc3b8034 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/bitfield.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
 #include <linux/mlx5/mlx5_ifc_vdpa.h>
@@ -40,6 +41,25 @@
 
 static DEFINE_IDA(mlx5_adev_ida);
 
+#define MLX5_PCIE_MIN_SPEED_MBPS	(2500)
+
+u32 mlx5_pcie_bandwidth(struct mlx5_core_dev *dev)
+{
+	u16 lnksta;
+	int speed;
+	u32 width;
+
+	if (pcie_capability_read_word(dev->pdev, PCI_EXP_LNKSTA, &lnksta))
+		return 0;
+
+	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
+	speed = pcie_link_speed_mbps(dev->pdev);
+	if (speed < MLX5_PCIE_MIN_SPEED_MBPS)
+		return 0;
+
+	return speed * width;
+}
+
 static bool is_eth_rep_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_ESWITCH))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 76b574fa0d7a..fd91becd6848 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1418,6 +1418,7 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 {
 	struct mlx5_core_dev *pf_mdev;
 	struct lag_func *pf;
+	u32 pci_bw;
 	int pf_idx;
 	bool mpesw;
 	u32 speed;
@@ -1452,6 +1453,9 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 			return ret;
 		}
 
+		pci_bw = mlx5_pcie_bandwidth(pf_mdev);
+		if (pci_bw)
+			speed = min(speed, pci_bw);
 		*sum_speed += speed;
 	}
 
@@ -1463,6 +1467,7 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 	struct mlx5_core_dev *pf_mdev;
 	struct lag_func *pf;
 	bool take_max;
+	u32 pci_bw;
 	int pf_idx;
 	u32 speed;
 	int ret;
@@ -1488,6 +1493,9 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 			return ret;
 		}
 
+		pci_bw = mlx5_pcie_bandwidth(pf_mdev);
+		if (pci_bw)
+			speed = min(speed, pci_bw);
 		*max_speed = take_max ?
 			max(*max_speed, speed) : *max_speed + speed;
 	}
@@ -1588,6 +1596,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *mdev;
 	struct lag_func *pf;
+	u32 pci_bw;
 	u32 speed;
 	int pf_idx;
 	int ret;
@@ -1609,6 +1618,9 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 			continue;
 		}
 
+		pci_bw = mlx5_pcie_bandwidth(mdev);
+		if (pci_bw)
+			speed = min(speed, pci_bw);
 		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
 		mlx5_lag_modify_device_vports_speed(mdev, speed);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index d6713a2ce676..555842085daf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -281,6 +281,7 @@ void mlx5_events_cleanup(struct mlx5_core_dev *dev);
 void mlx5_events_start(struct mlx5_core_dev *dev);
 void mlx5_events_stop(struct mlx5_core_dev *dev);
 
+u32 mlx5_pcie_bandwidth(struct mlx5_core_dev *dev);
 int mlx5_adev_idx_alloc(void);
 void mlx5_adev_idx_free(int idx);
 void mlx5_adev_cleanup(struct mlx5_core_dev *dev);
-- 
2.44.0

