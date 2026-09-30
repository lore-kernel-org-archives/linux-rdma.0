Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051264CA787;
	Wed, 30 Sep 2026 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768649; cv=fail; b=Ilq4Z37S07C7Yw5xWyNC/rzOgZ86mjCt8thfTPhZCzvOdKWeIw5ocQ9Vit7EHH5p6nqguckzxPseDSaPb18o4hEW3yKeTM4ilGXW9xCJhqSGEJtwf7e0rbHa6EDiUTq4ePCLoMQXsnrbje6gw5Hai/RDLdO6cE/D6yV9ZNLBu3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768649; c=relaxed/simple;
	bh=EEfXapcjoEg/waZ57/1bxfdXLKLB/AzmsOZCLiYllGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nfv1GyKuJrdb//OceYhJyq+ntWYnyqvutv1NabiL+YVd6xxrHsQXpvJxdG1REJMFk6HPYzTgwOw3RqsYAJz01CWjKW/zp12kTAQTW3419GxQ7vvNS3KhJXBEQg6Kr8gghlp8olLPmxSIi/7ZrHkmyk8mQzgfoJrGYSUYXLMFEGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JTcskAvq; arc=fail smtp.client-ip=40.93.195.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JTcskAvq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uA8OIjhDtG0rwitFdm0ff8IiYsErHfVYHLQAl5KHPYgB23+Cx3STlWXvKdlobT1dKM22FIUS3UeGK5pKCkTCwF5qWmuM+dheFZaR8QOXkITPclBct3bIuxYW9uj80GwMqDp9C3HMNMENSTo6dvA8FdoiZderbO6WuVinM0jXH4d/t2+cVKNBpstaJHlQuCgNp7N6cdnCR5sKye2Q3Y5ubLbZJQ3Lw2uvZkh4bR8vrW0HMpZMf7Xq8OXX/J63x+05DoE1Zt6DQs1tZOlPMea+TxQ17tdRH83CYIX+ifKO6Pt2Yw7+MkBFyfJTTS3QDOR0UcqQ7YVYjb3Qdz04D3fZ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IaVvTPKfRB4VYQpZ1RkbLGbBve8/2tupY1pW0JbfnM=;
 b=L3XCJRlSaciQyMZIcpcykr0/GlXzUNBn9URiGDki0sHP5c1ootOhcQH5EJxx41pKltNrZK3+1vUySJSG8foBZyVa5I9/sM+T+C3/qLI0Q8fP685LMm+v/mfqwNkNjySuE9GQjvjpqNscp/wnt/gTm6naPpfj2otXzFa5l4G+DvsbqOLrqtM++nOvmcqGA0mSwZoXILYEe6Kwv+HScH6Zf49ae8KUkOjtnxX5095ZbFS2mXGGCKgVpZnA/bLgNqiLKZm4NAx619OSAsYZ48+YbWDuwD8HxD4G/7gtSVqBzU9XZuiAswepHDK0OrCiOLQDg+Tiiazn4f/REpX8jf44rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8IaVvTPKfRB4VYQpZ1RkbLGbBve8/2tupY1pW0JbfnM=;
 b=JTcskAvq1GE/5+m3rXxJRz5cVI/ps7NOUblKLpEIEp1w73Uy6s7jMBt+e3Owys6WrtWM9IhsQxNgHE4ZfM0YH475NSvf5GdtJ+eom9AVG1VgCThIVfZpxNp2TFIM+4PmT9Ncl+n09BSa43CUfjDOvO8WJ1WK1UO8YrWHRULLfR9jAZ/5eynQT9udJNBO86l4+sQEJeKLu1uSycQNwieoKzrWpK+/MajLFH1ujtln3e6N21MUuNOuzr8mj+SAXJi0j/srX4GB2sUm5Rm7xzP7hDXd24WLzh4Ee3iexb2SGLkTo70qt4dqYoBTOCpygmCPc5TeGauyc4N2vrMOQw3/Bw==
Received: from BN0PR08CA0024.namprd08.prod.outlook.com (2603:10b6:408:142::14)
 by DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:44:01 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::3b) by BN0PR08CA0024.outlook.office365.com
 (2603:10b6:408:142::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:44:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:44 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:39 -0700
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
Subject: [PATCH mlx5-next V2 04/10] RDMA/mlx5: Give the data direct PCI driver a proper name
Date: Wed, 30 Sep 2026 14:42:21 +0300
Message-ID: <20260930114227.139274-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930114227.139274-1-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 13601914-6406-4474-89d4-08df1ee81f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|7416014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NttCZBKu5Olb5qk8g4H8Y8TqYmhMWQBn014mm0lxO5QvTKw69H/QLmr6SbXUVBUpnDmxPKrmGn+upKN4P3sFjhsmy1Sd4nescm8hteSt3WG7EJjIpavo53KdaGkxTpoufwCUPlDHb3tLA+gpx3jwBW0hi//oA6Gy51LKrpy5+1A2vABbPRIGNKbP0TolGvH3bMOlVYsYhk7ZZX01jLFqvsKr0UCUAyc3R1Tmampv3zRiFxeO9bkOyEUQwRhuFXEHz32fHfZD+Hj3aMjJuDle579Ske/Sb33F55jCCzLoLzsDZAm1TLpe1T1kNIBSQitxGZS19hqtqXnrUkTBaU7CuEJWFcRSMi+U274VGBKJbmjgS4qOZDXBbofHNlUO4xeJUcpXqWTd8BkJtvQSrK6DUth5F7DuUZ3MDqQ6+wCR4yvkp55h+saW+x89uFExhAXDeXbvmGAgKjMsp0wndmd1U22lZe62eNr/f1sDlp00ZX1xQF76iNTqvkDI+49AlQM7I932b76ofleUq72XOSI6VQJCI2o3IMAjQCOxveZoCibKt9OCLcT420LMxo7wz2whC281DS6nvYRn+4yt9iM3Gsj02dZlYO4m65Ky0ytX/GkQb7Q3Yjyo8QzLyt6oDLYE7Cm1aDsCB07uLym4/zoTbY3Kfihl61HVA/1Q+CNUNB4RrVO5Rw7709WTGV3I4pyI+tS4J8roLDBYo1SKUlPzDg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(7416014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7jX1MQRYo+FbNGks1wnD4rPEgLuwlUXDpE5z4QUfCV98yM+e6rQsZu65ZRgb9/nXKgzbrPP+32Tyybb+MDfoRdZgwk4m7QynDjoU1LnFZvG2zzvZXHyVNsEuYeLsRIRj6SzxL4ebZ/FVgwvE2WGeAXHRLfEnUnq/anVwvSQPPoOY+TD1b4ylNk4EC71YKpVuQ2fKx76T3DwprCD3Gu8cwEBX+NxF7bpa2+hM7giF7XE/2+QUmhYL2y3BlkGDsmGrYz2pcN1ZiEAFJjTQ1NDxzHfApu5vXvBB6b08u/bH/y2Ud4nOc1Z949ddjPHGrqGg9pd518rOWdzGkPrXt/71kVo8KpS3EVk4/myJYUzrsH3QyujuHzElV10893vqOW+javuH1HeXW8vEmDEJ/L0eJj9io/mGNPTKdQD8Zbj3egijwv70bxNLCTHek4jTZ4Y2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:01.4792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13601914-6406-4474-89d4-08df1ee81f50
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154

From: Dragos Tatulea <dtatulea@nvidia.com>

The data direct PCI driver uses KBUILD_MODNAME as its driver name,
which resolves to "mlx5_ib". This is misleading (the driver binds
the data direct PCIe function, not an IB device) and would silently
change to "mlx5_core" when the driver is relocated there.

Name the driver explicitly "mlx5_dd".

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index 8d006b611c63..a80778f2b9b2 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -240,7 +240,7 @@ static void mlx5_data_direct_remove(struct pci_dev *pdev)
 }
 
 static struct pci_driver mlx5_data_direct_driver = {
-	.name = KBUILD_MODNAME,
+	.name = "mlx5_dd",
 	.id_table = mlx5_data_direct_pci_table,
 	.probe = mlx5_data_direct_probe,
 	.remove = mlx5_data_direct_remove,
-- 
2.44.0

