Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1184A2A57;
	Thu, 17 Sep 2026 11:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643752; cv=fail; b=jlOhGfSD+AHMkcZ/JMAFXivsHBxMCM8tCZZRI96qBy5o+d0cCj1fe8092Rb/jtEMbenf7rQK0WhlPiyBbCyTCGl6p8FhyYROiJ6jDxIbyIQO+NF3n1hWqjmhSY9FuDOYws2gjuNzfz0iaiuv9CkYZ6hBcS1aRIJSF6Pl5iX4nsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643752; c=relaxed/simple;
	bh=MPyuWeoOucJMDoHSRQXDuXzvSNo+jvPnqSVg1f2OAnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CALYzFemQbVjhjc+VpwScIbbmU3Y5fy/VpvPJrxHJebQkqFbD9lcyTun1/kik/udnp+S/dqp8Dh8+W195xLdZjC5QeIutMrFfY1aPPyEKvyuDpB3lFpinjzcNLkmwwKComUvuPHzxxY1SLFyqEn3WSUnsioK2aETLFFG89GVebc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N4t/wH7+; arc=fail smtp.client-ip=40.93.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N4t/wH7+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zv6Ky3wflwFXdFnEK38+FpeIccasif59Vkxr2DJR6XkKd0qZR5gI4wUKAVumpUVTJewOagolyCttcEwFtHRrZUFa4dHswVqlvFXDJgimB4At6umP7zhsBQdjBCtxTvD3wMPZFZNkJLZBHlAg8k/UyFEGBtIwPelX7BVuGkPFYVc3CjD9RVbPyRW3lFF4F0GQaAeXxTZiifsagy0zMgsTyZDNmZs+MTWQxbw8Ou7a7PAhvVka2UAh/4Zz9cYW8ezbg28qyOkuyhBSXgqcJiRHAzvH7d16/pUfxvWxRjmziQLl8zQinzvJRYDruELUMjvdyH66nscBOXsa6ne5vIg7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJ9fpG5wLo0LEzZgCr5TvT9gXP3JVh6CW411j/fee+I=;
 b=vvJ/3zZWhu1XLOrxPHVxduuiZnGfwo2nSINgkgTfjxOjZU3x75j1pBnylgf3H3z53AAP2Ijis9I2LtFafe8v3rSj4SBBmFT+wDFiuF9GulkCjVl7td4YxscJ6jjDoSeMHliqlIvyZjahYIf2tAM3VDQ7nZ0SbeOecYqBnTFS/mjuwZEgT5s5+SQerUALbVUuLQGWwbrjEYY0oI+f7bIAqihzcsVEX+U4jaPPRykKby1O1k7IAdhNZ/+ui8ZSnyqXzQ3zAA6rAoz6HHRAJYyACUV4xRa1Ys1N3/m5xrtyuKDUvSZtEbMHqR+yOEz2I0w26pvDN/OvTZhxw9zYBBG8IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJ9fpG5wLo0LEzZgCr5TvT9gXP3JVh6CW411j/fee+I=;
 b=N4t/wH7+PcyrwYLlmy49JMVWSKf28h44+SsUUhrgM7Ko6GV0pO4IODaTSMc4nFbEOeDUwL6Rz4GgNnjqgc7Dklby5DIwY7Q/Dd0QfGf9DhGukTKPiW6IZtbbpDMqlQ12XGI5WLlEgX1N3uKCjQUFaJIFhPUcr2wE/5nqpYfb1CgJCAeSRd48Q9Ye8nh0uBHhUFqV2qRd6HNRhewG8p7cWKpIpHeGb5oCp5dzmLHrK3/LKzaxCqz5ZyYyJSpxqrX6cVxVDGSpGRcFgWuWNZ2BPrA3RQjdpDf6cmL9QTpwhLhKCy/hn8PYPONq5gi3+sPJCbu+MBvOhOsNr+/e8B8C2Q==
Received: from BL1PR13CA0028.namprd13.prod.outlook.com (2603:10b6:208:256::33)
 by MW6PR12MB8708.namprd12.prod.outlook.com (2603:10b6:303:242::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Thu, 17 Sep
 2026 11:15:31 +0000
Received: from BN3PEPF00022BC2.namprd05.prod.outlook.com
 (2603:10b6:208:256:cafe::37) by BL1PR13CA0028.outlook.office365.com
 (2603:10b6:208:256::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.7 via Frontend Transport; Thu, 17
 Sep 2026 11:15:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC2.mail.protection.outlook.com (10.167.248.213) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:09 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:05 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next 02/10] RDMA/mlx5: Add mlx5_data_direct_supported() helper
Date: Thu, 17 Sep 2026 14:14:14 +0300
Message-ID: <20260917111422.4054862-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917111422.4054862-1-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC2:EE_|MW6PR12MB8708:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fb1272-693e-4c9b-9fc6-08df14acfc20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|23010399003|36860700016|56012099006|10067099003|22082099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	BR/3aJR9lC8HegLhran5dz2sJmzCrBK7l+imbBLuxQ06hi1pVem1TS0YBvTa7lM5Bmaqu2SIm8fRbase+zJG9eiyA1Rn9KfTRp1bFgWqsrXJ+8TN2Hcb5SzRUWm102lGrelM7Pm+uYJF0mdAJmhFRceDEJvoyQaA0kzJuebyq6xIb9pSwAjoAwI4mZdZqk38P+Bo6P6+WsEwu1XTT/hgcXIHnqzh0QYUZSpvZgHjLnYqUSmwdZA5mJoEo6zWyvhhBToq7fWPwZttHgEuK9gF9a0AZd37tnWp/2HoVIoJgfHkej//NZhfnQpRuEq5SWAVbzanQFLBMqIU7X0up+itrD7BfGZkhbuYBe4aMiGnKFPKssEqy0aSpeY+b2N77yYYwWT0suAzc7FTDZejRHKYHDy5bkVmPaRnhIbohYsJOSygwajENZs9adMKGIgWzGHxajkVUQJY9OA14cCG5tuMnra50BzP+LD0/A9D6oGcd6PcoGY3rkgg8qMgvATh0Jdf+RZxxVu+wSiE7sMVPuyvxE7XvwGOCCL8NP5EByLU3eq9PzeVM8k0xFqRJQTKx4Th9yyLWA/h8sZ57r+hT7+jyraWb4UexFqcfypDbUYICLCsnvlmg85fNUqqFyb4nigmklRwo7/WJRodMTkC9YfifrRdwQ7ySpU2jyRmb6+DZGg9FTzlerQvokaCSi8vZntcrZPiQQb9JXlTMO5dGiyOWA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(56012099006)(10067099003)(22082099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eCR21Zq8CxRZIfIctuwNyu6HPuvyAmmNpujuFu4KlL3CdBKvvXVGB4hloOaK9ylu1v92kLy5rOfEl520JtmRdtP6Jod12rE5VGVSg6Igg2pkKSjpkyrcA5Q15dApJreZGSSMcondhgHgnqihoVxymDDdiW7XTNGfPJtF20q3vOgKaBKcxODdcD+WVBryVnjU0eB3aB0Pb7LdLrA0TM2o7XaZZJTRZc9uJ/kZcGsvgN8nWKwbcQPa17nJw5UpwAjuFex44sWF23TQhM3aSVLTERkITBD0JsxxRF0jFpTK8fbMQEXJijzBPitHwoq+vqYi102fjEswNZmsJcARY1+Ey0T9XYfC4jT4UJOcjk6ZZOtMQNFNKen4imtR56HnEQ9T3Sr/lkHmseBQ4tl9KJnurDun4nRBcpMb84DvLYzVkF4EusRmM++0TbDCr2nGhWI9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:30.5054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fb1272-693e-4c9b-9fc6-08df14acfc20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8708

From: Dragos Tatulea <dtatulea@nvidia.com>

The data direct capability FW checks are duplicated inline in
mlx5_ib_data_direct_init() and mlx5_ib_data_direct_cleanup().

Wrap it in a mlx5_data_direct_supported() helper and use it in both
places, in preparation for moving the data direct matching code to
mlx5_core. For the same reason put it in driver.h instead of
data_direct.h.

No functional change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++----
 include/linux/mlx5/driver.h       | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 547275dfa40e..0c57cb39ae7e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4036,8 +4036,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1] = {};
 	int ret;
 
-	if (!MLX5_CAP_GEN(dev->mdev, data_direct) ||
-	    !MLX5_CAP_GEN_2(dev->mdev, query_vuid))
+	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
 	ret = mlx5_cmd_query_vuid(dev->mdev, true, vuid);
@@ -4059,8 +4058,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 
 static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, data_direct) ||
-	    !MLX5_CAP_GEN_2(dev->mdev, query_vuid))
+	if (!mlx5_data_direct_supported(dev->mdev))
 		return;
 
 	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b1871c0821d0..ee29f95ead18 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1395,4 +1395,10 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 
 #define MLX5_SW_IMAGE_GUID_MAX_BYTES 9
 
+static inline bool mlx5_data_direct_supported(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_GEN(mdev, data_direct) &&
+	       MLX5_CAP_GEN_2(mdev, query_vuid);
+}
+
 #endif /* MLX5_DRIVER_H */
-- 
2.44.0

