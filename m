Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725867;
	b=XpZsDfr2In/ert7HTxLbE40YirE6ihCgJANSChNkZZbaUb6WnSyu5u0jy/1S3rB6Ek9u
	 XMB6Bd6WL2mk18U1L6KDizQlLFpZP0mD1DGly/F1ZHqI424/BrToYD4ek4SZlk8AHCXn7
	 hRmH5+aybLdn+njQFAlL9WbsINtMdl5Pfh9PA1rdmnVqvLCfr/sE8okoj3kfec0fiNY4B
	 NNPrFJl7uxEe94tA/I+zUWQERlWBLE+2zsjzzT/EkA/r7KFCgq2/O1LQUx/YUU4PRk4ob
	 X8/7OqSSKByRLpYndNlPvH36gD544ue/Cn2FW8bKJQbzTwYmTCUIrR7kiAO4mCE41yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725867;
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
	bh=zp/bTwdff6VAKtIn/+RrxwAsSEZkSKmqa2VC/z/IHCg=;
	b=lwsEotTEOvEHJhqBgs8p8tsUWKNzvDe0zdkaHwkW0LYNepfZ3gaMFQamrAE6FRtz4X2r
	 SJ4EPnCAf9rIDbEV2sUhIK4BaL6q15/LAwndi/KBZRI8A5GLm0xXdezHfWP7YE1cC639h
	 AuJ06to1oL2DsDRCoyqffJstqtomsOCNlS7fY2EGyKvCVqH952Dp7v3+YXCGOLlfGW67b
	 3LkBlTV5RtQS6yZg1TaVbhNK8IgsZtJO3XHLNXHpYi2XcGmvqKBxMNy8MB2KiQzFtEmcM
	 MxjFAUgLkTntus9QmBxy0o37oV89Le2VATwPIkjAhEKLUfbf0OYudto1Zlda2017FSQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JIggy3in;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.66
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB59606A324;
	Tue,  3 Nov 2026 17:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AB59606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JIggy3in
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfUPLJZvgCHCJvbTe6XlMWigAXUYNnz0Uu+TRGCo49ZFuRL93/GY0s+yOeJVmxDUCnaUt4GdOy5865xZktf869uTG0tI7WRX6Z6mScQDn1129cJW4kk2f6CRYZ5yG2cyIryH5CiQNvHi5rXjNpm+8O7M5vEGRZJNC9H2/aoLfhWeM850FiX5PAv1rl01SGZl4WNsPb6akZ1XRtmAAvPRjXUvLCKioSmP3IXqE86aJbas0oFzftweWUXgTtPsaTeBWzsYflERngEvZp55PMQYJvttp1c+3ko9+cKSvgqu4/i9wZe52ZQ3thv1WJ2vzvM0RDPMOPGpdux07KqOLaoUyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zp/bTwdff6VAKtIn/+RrxwAsSEZkSKmqa2VC/z/IHCg=;
 b=aEqSSQ4uA6MkpXzNx4GHrRIGnC8pbBsvPWV+WMOhEvAB/AFYvcCgMUOgm4nKFxByme+PXYoNAwuDevh+YtjMKFIiWx1tYMuTGk2elIgT+mEkCJ5dYSB6p39U9cJyd27M/dgWm0z2yu7nyOd06Fge4kbSyXHHIhQ4tHq6ip+j5kxDpdzkd8fQPECDuDzKoUnmmrEGKPgwiG+m1ujQOFpFu4bdQdWV9qSErMoxS5CoQ8XgmvO9cFwHc4eEJqzThpmuvEXAVc9lg3nQoIsYp342Ergyc7fXJ2Sat3TQadf/Lz3a6dNOZXqJbpaE4Ymx6dJTyM3p5pqNKhKdm2+ZspWTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zp/bTwdff6VAKtIn/+RrxwAsSEZkSKmqa2VC/z/IHCg=;
 b=JIggy3inUydit0yPmrEbEb+ayIHC5y16PxghiQuiur+LiPVbDLyA2RTEdi2P3bbrxLpaUkMevoVXzOMORomxmBKyb6rwsE5A2ZJHvXCpyxqclqV3ntZfFa9f5PdIkNnmnaWT8u9NtTYztXXYAzAySobgR2+9eN/fwsqC7xwfPKZ4KmTy4BZx/gbLMfv73RidvcmqzJNembUAG0t+v8BPhs/a7DkkMxNIxPjqIUReHMiUljNKgDXfBKQYpyVMRCtlqKNoqSqG+X41X1F16D10HbDPHkh3QxjqxyzgROibKZ9HpAtfhxKjiLb2m3+vWJ8R40adkUNiXr7QbxVcwwSBsg==
Received: from MW4PR04CA0151.namprd04.prod.outlook.com (2603:10b6:303:85::6)
 by MW4PR12MB7437.namprd12.prod.outlook.com (2603:10b6:303:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:11:02 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::43) by MW4PR04CA0151.outlook.office365.com
 (2603:10b6:303:85::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:11:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:11:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:10:40 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:10:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:10:35 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 01/15] net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping
Date: Tue, 3 Nov 2026 19:09:55 +0200
Message-ID: <20261103171009.563034-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|MW4PR12MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: bc04a039-77ca-4ff9-683b-08df39cd6fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|10067099003|22082099003|18002099003|56012099006|261022113327099003|11063799006|261021121427099003|261022115727099003|261021135927099003|261022075727099003|261021133027099003|261102123227099003|261021130227099003|261022105027099003|261026135527099003|261026130827099003|261028144727099003|261026121527099003|261102130727099003|261026140227099003|261021123027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	LKLgiWyicL9/oOjLTJ9f6X+nQqkwO680D7LRDiVmp6zCsniBegM2cI7W3Q/rSSMrAlwnAFdjKIm/mk+eHUkwCTG3ZtuFJkl3bNon+438OEnmb3BDdEMPeq0p8vD3VpcMdS3pdkTSYMXu734786d4kHMp0oXyKpcwKaENv7yKFFhKa2wbga8+I9AiYbYfnAADOrhrKu2+6nON8NgIXQxpdEVVmF0zafRJ5h6a3stSAn/HswrvTZXtkTKorsVEK65H3h2SfU5E/ETuCGkfVm7UxIrGEGtlI9lvWd46eJC1nlEXokvousXMzy11mM15QQvUghINPrfJ17O7Bs98XLx3CJWnbE7ijTe7GURMLlG+taSmxDrID6QbiuapUQZOgF8n2CxKmSOYt8DWjCS2TIpv8zumt7uwqvV9EIVtA4TLfFI6MzYaukUJmJ/gUspJ3/O9mwpd947/JCbZfAWTmysVRQQaU8o7CEdQYeEEWGzFLlksACWCzYbdcIKa2hHspatsNYV05BBVfMDsL403HHlVvnI50/T6GOtq1idCHX3Fq4/2X26fVnhlXVy1D3NSA0+yj/4EEatusHnAiQtopXpkROYnGU0nVSwxose41DhVvoTkYg7inL2ZS8X1dzZ14prfxcH34/DvSTh/0NnwUTS4yXtW/rsnmXRh0cIrFGLvn1L369m2QopS746BW0xdGRpzOsYbP9bUXY9UvajMPpnfoA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(261022113327099003)(11063799006)(261021121427099003)(261022115727099003)(261021135927099003)(261022075727099003)(261021133027099003)(261102123227099003)(261021130227099003)(261022105027099003)(261026135527099003)(261026130827099003)(261028144727099003)(261026121527099003)(261102130727099003)(261026140227099003)(261021123027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QAIldzfndbBIe2EkP6z2yIYTplmGjP1+HiewFS4cu5siNEOLK+VZN6tFpBKEZj7hU6sVbAMFpyHfuHtM2JAt7Gz2FXytFCHlTMCQmg0zWZRF2yXz/HKF6TiOa6Uc7LMP4w8XBjHR85j9BULwup9bq29MT8fFiGRsozyiKlGDxoZCSxZSY3vUCm5qdGCvYUG9bNuBAp4MOvDTgweRR7vU4OoCLyYxQ6sTT7ec/7wnDBxm3S8OPp7+ZASOkPQXpj5jQPKyiaX4Z6aDYvonD2bGBZt5V1yfBPtfp4wLeM7kHWvRUUvjHHP9g7fQSIeQMYH+2SDw/mng0cle/jhzzkBKhAO3I5x4OYErUKtestIcTxaSt33g9OHMpv7d/uKA2q68XwLq91JedKNGT4arWkx2RH6+SiCeM9BVMUw/sRp8CmU3+hqLTNrN5QtS/cme2hUP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:11:01.7855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc04a039-77ca-4ff9-683b-08df39cd6fe1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7437

From: Shay Drory <shayd@nvidia.com>

mlx5_query_nic_sw_system_image_guid() builds the key used to group
devices that may form a LAG. A PF and its VFs/SFs share the same FW
system image GUID, so without a discriminator a VF/SF that can join a
virt LAG would be grouped with its PF.

Appending bare discriminator bytes at conditional offsets is not enough:
distinct capability sets can collapse to the same key (a PF ending in a
load_balance byte of 0x01 vs a VF whose marker is 0x01). Give each
discriminator a fixed position instead, and add the VF and SF as such
fields. Trailing zero fields are trimmed, so keys of devices that set
none of the new fields are unchanged.

Set the VF/SF markers only when mlx5_virt_lag_is_supported(). The same
key also backs mlx5_same_hw_devs(), so a VF/SF that cannot join a virt
LAG keeps its current key and is still identified as the same HW as its
PF.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  9 ++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 41 +++++++++++++++++--
 include/linux/mlx5/driver.h                   |  2 +-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 8552792b9035..0ff337983a6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -266,6 +266,15 @@ static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev) {}
 static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev) {}
 #endif
 
+static inline bool mlx5_virt_lag_is_supported(const struct mlx5_core_dev *dev)
+{
+	if (!MLX5_CAP_GEN(dev, multi_uplink_eswitch) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) >= 2)
+		return false;
+	return true;
+}
+
 static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
 {
 	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 78f3d15b599d..50d2609374c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -38,6 +38,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "sf/sf.h"
+#include "lag/lag.h"
 
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
@@ -1308,10 +1309,37 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
+static u8 mlx5_sw_guid_load_balance(const struct mlx5_core_dev *mdev)
+{
+	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
+	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
+		return MLX5_CAP_GEN_2(mdev, load_balance_id);
+	return 0;
+}
+
+static u8 mlx5_sw_guid_sf(const struct mlx5_core_dev *mdev)
+{
+	return mlx5_core_is_sf(mdev) && mlx5_virt_lag_is_supported(mdev);
+}
+
+static u8 mlx5_sw_guid_vf(const struct mlx5_core_dev *mdev)
+{
+	return mlx5_core_is_vf(mdev) && mlx5_virt_lag_is_supported(mdev);
+}
+
+static u8 (* const mlx5_sw_guid_fields[])(const struct mlx5_core_dev *mdev) = {
+	mlx5_sw_guid_load_balance,
+	mlx5_sw_guid_vf,
+	mlx5_sw_guid_sf,
+	/* New fields should be added at the end */
+};
+
 void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
 					 u8 *len)
 {
 	u64 fw_system_image_guid;
+	u8 trim_len;
+	int i;
 
 	*len = 0;
 
@@ -1321,10 +1349,17 @@ void mlx5_query_nic_sw_system_image_guid(struct mlx5_core_dev *mdev, u8 *buf,
 
 	memcpy(buf, &fw_system_image_guid, sizeof(fw_system_image_guid));
 	*len += sizeof(fw_system_image_guid);
+	trim_len = *len;
 
-	if (MLX5_CAP_GEN_2(mdev, load_balance_id) &&
-	    MLX5_CAP_GEN_2(mdev, lag_per_mp_group))
-		buf[(*len)++] = MLX5_CAP_GEN_2(mdev, load_balance_id);
+	for (i = 0; i < ARRAY_SIZE(mlx5_sw_guid_fields); i++) {
+		u8 val = mlx5_sw_guid_fields[i](mdev);
+
+		buf[(*len)++] = val;
+		if (val)
+			trim_len = *len;
+	}
+
+	*len = trim_len;
 }
 
 bool mlx5_vport_use_vhca_id_as_func_id(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..d9d91faa0a1d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1395,7 +1395,7 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
-#define MLX5_SW_IMAGE_GUID_MAX_BYTES 9
+#define MLX5_SW_IMAGE_GUID_MAX_BYTES 11
 
 static inline bool mlx5_data_direct_supported(struct mlx5_core_dev *mdev)
 {
-- 
2.44.0

