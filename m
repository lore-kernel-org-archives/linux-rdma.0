Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935545;
	b=RHmdS+ekV8lR2i+Cg/aIP4sTNpIEg/iGGZm3Hy5Y+S3OngbZwdyBmYUd6a8c7faN4DVa
	 xG7aGwnEY5V665spGyZCWPaxR3t/rDUrkBz/2SAma7SVbCW/jWZ2waduBNV94/D4gFbP3
	 Fwmw/ZZmOX1uszTZBbMd4vgkf9QvCk/hAtJ4uO9+Y3idxlniJ+9QUuTL27USIz16g/n4+
	 VYEjskLHHkrgrgLxqUxm510ywQFX0P2MznXGjH1MpxpCYHY5RnCW/Daue/YoPSUV/dyFe
	 nRifIY+rb6KusNsyFJOts6bNlMZC8yl9wwTk6Cf3omO04uNdQxcj4dcMGrFT4Po5jfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935545;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2RpLx56+1lu9wdXB061E0VJHaBSBoI3IoqPuuPmSTjQ=;
	b=pTHM8k4AUiUE7N2Q4njWSfoyeN91rheTAMog9RgBIFHTmIIX0nTXaJIVjyKuMgRiaKQI
	 N6pt7HR0MTpnFPMZJEsv9dRg2iuGNcWdDZc/mn3sc0b1ff+7m9504henG6/6IZmNmqWhv
	 BA4aj3ZC2098PwQxB1VXBGP53fZ0nFnsWTX0EA65VKBaAyvqlUkp9xMZ7zKI7DjBdUsYy
	 coR0zCfe7jPxFyY//km0AMampzQnvmH0tKDT8O7QmPhA4YMICECWgfZMHgoGdE46VO/Rj
	 g34yeCps6QortLNuGUGmREe5QQjwWf9tB+wbfEDmtOtodPDL2MR0oavLfXXVT0c4Iqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Zt+obAnG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.12
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD5606A32F;
	Tue, 17 Nov 2026 17:12:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50DD5606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Zt+obAnG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doiKZIPgGqOz5BeKX1GX9OdBbdY9QoCw1qb+mOJPHD9iu1rn/x+pdS1Yofyxt+N8P3j6N32tCHLYu0lUka+WjfiWR72J40DNz+qo70AEmxwns4oNSGv/TleJp7iFIqWdfCZahNcOsyBQqAU3xot6fRVUPxqPOhTou8uBAc0GyYuEifKYefz//avSxh9lKMxzfmitSaszgldHbRfp/7Xkh1I2u0x2MzAvk+qfZApn51bOhA6sVELxJOlPzXRkztaigC72KJGmLPZQNN+NixXSqr4vl0/VY+xcLKOy7waYPkaVcF8fL+/hWz8tGF3Gb80cKbFrU5CcQ7nUqGaEYTksnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RpLx56+1lu9wdXB061E0VJHaBSBoI3IoqPuuPmSTjQ=;
 b=CIBTyWFj7D38DVujiJlJMSjlPnvE14BkucfQyxkF1kBUXKp7/Sa/zg5XCD6vDrc9Zh7dUFOcmyrHEpyzVIMkFnrn+G3SSmW0vTYVc+ZDzLWibe1SgEceOMZgx7L8PpooVeeDtd81gwyhsKX5e0GpmJ6sgfpVC6cLiN1Lp3XRpiUdXG5hgfumq7+rVpZMfCOrdWfQwFgbbiDN7FsH4RA2RTgixt+bSosBw4Zi9WR9pfni+YbutUpk8IX6xRMqXh7dDRytWlmHFZSQJNK8iu3WhsPO2/aAPaK3d0mrWfi8r+Kh1FYb6KHatOSL9Qu5/N2BJnyH9IEVpz1gE4VDFI/t9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RpLx56+1lu9wdXB061E0VJHaBSBoI3IoqPuuPmSTjQ=;
 b=Zt+obAnGz5XfW2enNq2I7n1ctJqEtx4l0AW7JiWPgeTegcFhLdsJIvD65MYpyXrYdCnQUSDzbXwR7JiQ9ej6wPDxD9xwIjSSsilcKK4W+adT7MhpHudixS95aOYrKYE0rG+ldgekIqmptAvy96Go9TEmRsEJGFl35tlvGVbgH7LGgI4lG+L9/Ho+WZNxo7rrl69QIhdh8GxPjmVHx6H8mFH1OR6yh4k3WIBCy3ldS0JfgPPCRHz7rTdpjiOxoZTKAmuoLAk/45W+iDnFO8mcNqkffUvyuFbriF29ZEwAOyOMVSGCaFI+E/6QLxWikU9ArpUAOfcmo+HUlEP/e1YEAQ==
Received: from DM6PR06CA0085.namprd06.prod.outlook.com (2603:10b6:5:336::18)
 by BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:20 +0000
Received: from DS1PEPF00053452.namprd04.prod.outlook.com
 (2603:10b6:5:336:cafe::c) by DM6PR06CA0085.outlook.office365.com
 (2603:10b6:5:336::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 17:10:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00053452.mail.protection.outlook.com (10.167.23.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:09:52 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:09:52 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:09:48 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 02/21] net/mlx5: Derive adversarial mode from CC guest memory encryption
Date: Tue, 17 Nov 2026 19:08:55 +0200
Message-ID: <20261117170914.27410-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00053452:EE_|BY5PR12MB4116:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb10695-ae91-4016-7c7f-08df44cda7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|6133799003|261009223027099003|5023799004|11063799006|56012099006|261028144727099003|261102130727099003|261102123227099003|261022105027099003|261026140227099003|261022075727099003|261026121527099003|261021135927099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	U9O9iYs7228LhuESj38AFMYVsg/SEp436yhxloq7d4NoXRfjZ8wT29oa42vSeEYAk11K6YGQXkdwo1bBfGSE5FzLo6Jwz3Q1ojWdD2Yk+3Nb9ircV19rmHjXb8l0r5b30HfVip1uwQl0T7Qepr+T4r9EF7oLGNlMTeDiea5GnrzLXT7iro/5cmXVgah6/7Oi5bNy6rCmNa42PzSCqW40bkkvBeadGIxI11JnYwGLLxOS7L8vIUC2Axnv3azA4f3xBTLwrHJIefihgkWNphtVZ82gqMIyAhWHSnrrNCAp4cD2QMAdl2VVQOo+S84oJg+RaABpNO3jfYsdnaJGCXbk0RPfwnV1F2r9fh3QtqBJnN37WZlnoXv5yJRxhRRosPEtToFauzMxDMCIEWVsQSksOlzLkWHL2gR3dEyPyTMSw3wjziPyScMthaLLepGQduj56Q4NbWADzNNhJCyrscsl8qUff17kwQEgBN/EnZmMC6UWpMb0baFsn6AA6vUFaedVf0KvajZ9TktT2RkeyF+/vHRtRuR1YWDEVNFe7xlKhGp4vJtBBZrRCWyL7eI20ZfPiccRuxYBJLfsbN3rrLVgR7lROy0JiC2RirSaD3rX3jQM3r9qDkpQTybj/SAXUbRKrMCCnjqlcmJv6xOYmAP/G2CRLw3z2aYuiRhzd8wHTIcbbacZBT4+VMilTgt4XWlHMPTufygZkXhbCbIqINx/hQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261102130727099003)(261102123227099003)(261022105027099003)(261026140227099003)(261022075727099003)(261026121527099003)(261021135927099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Re++lV1SH7VCkRRKI+U6tAKrzp2A8npJixjTRixyi4LTWfmszFU60pLabArBiQaAEoV7xHtEjOzt2+zUyBAyuEUSEFHILy9LhzqwvCXku9pRcQqn93r/wioUkVJyTsrqMaFlRZTNZ/doUd8G+ngCTkat13MwLhuJKN4YSLSl4Y1Qf9n4DLkyPq7s0bnTFcXOFoZL77zIiW5ix29qvtqeqya3xQeNnj+DIsyPI8ea8urVToRYLuXRhlDRkC1hO6XgdRaNfgGknlV+MAZNc4yKRw93wLr3lvws+xDKtvD0uGh0USR04JvPHkhcfkDZ5UcJz5PQGxKAWCsZIMYXAfMnQ5MwgeFTipGiTH2cAi7UO5tqiUji1g80SjoxO7zH+W6LevmpsX8UUHbU8NlNRU77lGwtGLBWJ8QntnbNWSA+GllSm91zamfC8X3xgxS7lDrv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:18.5237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb10695-ae91-4016-7c7f-08df44cda7f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00053452.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4116

Add mlx5_is_adversarial() to report whether the driver treats the NIC
as untrusted. In a confidential computing guest, the hypervisor and any
passthrough device are outside the guest's trust boundary, so the mode
is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) when the PCI
function is probed. An SF inherits the mode of its parent function.

This turns adversarial mode on automatically in such guests, without
any administrator configuration.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 +
 include/linux/mlx5/driver.h                             | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..0fee5db2b1d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/highmem.h>
+#include <linux/cc_platform.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -484,6 +485,12 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_is_roce_on);
 
+bool mlx5_is_adversarial(struct mlx5_core_dev *dev)
+{
+	return dev->adv_mode;
+}
+EXPORT_SYMBOL_GPL(mlx5_is_adversarial);
+
 static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	bool do_set = false;
@@ -1961,6 +1968,8 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto adev_init_err;
 	}
 
+	dev->adv_mode = cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+
 	err = mlx5_mdev_init(dev, prof_sel);
 	if (err)
 		goto mdev_init_err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 4391ef0bab5d..90c6c99d1f07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -40,6 +40,7 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->coredev_type = MLX5_COREDEV_SF;
 	mdev->priv.parent_mdev = sf_dev->parent_mdev;
 	mdev->priv.adev_idx = adev->id;
+	mdev->adv_mode = sf_dev->parent_mdev->adv_mode;
 	sf_dev->mdev = mdev;
 
 	/* Only local SFs do light probe */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a1275e6aa6c1..ff1fe480307a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -804,6 +804,7 @@ struct mlx5_core_dev {
 	struct mutex wc_state_lock;
 	struct devlink *shd;
 	struct mlx5_data_direct *data_direct;
+	bool adv_mode;
 };
 
 struct mlx5_db {
@@ -1328,6 +1329,7 @@ enum {
 };
 
 bool mlx5_is_roce_on(struct mlx5_core_dev *dev);
+bool mlx5_is_adversarial(struct mlx5_core_dev *dev);
 
 static inline bool mlx5_get_roce_state(struct mlx5_core_dev *dev)
 {
-- 
2.18.1

