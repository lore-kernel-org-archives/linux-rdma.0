Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21D4D37BA;
	Thu, 17 Sep 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643751; cv=fail; b=BVe8oVjzOxYBB5juele/957n4lciW7T+V8IehQlh5j4Zy/lBVL1auAykiNeXN503ZxGjftkFvf6dbptAjD0J4lzNc4mmX9t4zL+OBFv9nlwtj80VQ6hZc97vWdKVxasMau1Pe1gwTiLPMjoTC02aqlZHizs5tftSUb2ROrdoHRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643751; c=relaxed/simple;
	bh=Lqr8pKoES7KZnu5U5+3cHrNi9sklSC9pY02pK10vUKo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7BxDxlw2U7+pnW+k/U2JBfB4ecuarv354NSSpaNMHiAEaJJqVuFmq/G78V3tdHopMavMkaAHomc7wDtStSNRjVWQSuDZ7iiMVx0SAMsRQQ4wpseajFhA1N7l5D+GU89HBkS8redFEdcbn5ndXHX2/eDVa1IVN8/JFVXDD++bcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aZ1XtsZk; arc=fail smtp.client-ip=52.101.48.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aZ1XtsZk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXhu7SIFvrGUZ2qGF1eREHFRHA1E6FacAKUirHgSXONAPvnjQINMhhV2z1u3lg1ZnZAzwxGYK7ehRj/omiBSxetkPzDDNevtt7C+RwtPNUHR7ti8ZWuERbRG3ZgTr5gvy7XQA19bnQMnHu7tAij4LXAHOfe49s/M3h5gCdJZq7tgJ89IKa07UKkk2Kt2F3LJoymhX8rQSYOuvuOlOodbS9TThyyH14iRM18ZeqDNaspinOwErLrkiIYREjUBK4KygbD3Xyfz/AOs1+ggv5LgG/+o9eS1M2EhWZRsl7gAQmH0A+1E+615bo09LU5mYmz3Bpu2JHlKusgRpOKszEZxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HgOdJC3GRtB/q1fUjtYKllY/r5xXeLOlKkHIbNlzhk=;
 b=SixEsVdNNHb3ffK7YjbGBCillPBhbAjg3XjJN/CSFy4NbgiYZ47U7wew4MsXvuvb6tjSJ4oSJ0r7WvqXpxBbsXFh89lr9u81jr1IaQZfoHIwabpVfmGSXGfURVlku/0ZfzZyDCEDCfGIkoH/7S7znkXU1XaVjO/OaZRpYknZKi7dq/zPXbn4Nzeub9etqhHsZkBGvY4aRSs+hIoytD7x3SHY/tTTaWdVy8cUdAJY5/HmJFvDIThg5rnMpXm+Z95+V6NAE64wqeVLKMzLUIhJ+nFNuMEeZeTW//fVwPnwOpgJm5KlYJp6oP6XaS9Hj04uWBYE4+7slo243T6h3RroRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HgOdJC3GRtB/q1fUjtYKllY/r5xXeLOlKkHIbNlzhk=;
 b=aZ1XtsZkOJXav0nhk0ZABoskNpWehCBseO/5Sr9LAQqTwdJ1lZDNFrKTqnaJEgtY0OmE4s1C7sDUJdsDgQbX33NbeWNCILbCPwPaPbP9sqK0coKmb5jkr8os2hW9E+oPwj/Q4N4EjdCqwfLEwsn8PI1O1CvqocnlVQw+f3LmdXmYVwlIBMwqJM73Ik6PMSi5QsB3Qokzn1fqN4nqqX60gUXaMWY9igsSuz2CCoQq3fncSP8QyWuCihBfi00YZELrNiZf04azQM6/eqDk5BNypVaAaC+4Be2xw7bH//tkSDZ6VU9AFxdq/Ei9pgoUvE4UYPH62PB1f612C76AMVnsXQ==
Received: from MN2PR03CA0028.namprd03.prod.outlook.com (2603:10b6:208:23a::33)
 by EAYPR12MB999181.namprd12.prod.outlook.com (2603:10b6:303:2be::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Thu, 17 Sep
 2026 11:15:37 +0000
Received: from BN3PEPF00022BC4.namprd05.prod.outlook.com
 (2603:10b6:208:23a:cafe::c) by MN2PR03CA0028.outlook.office365.com
 (2603:10b6:208:23a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC4.mail.protection.outlook.com (10.167.248.216) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:18 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:14 -0700
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
Subject: [PATCH mlx5-next 04/10] RDMA/mlx5: Give the data direct PCI driver a proper name
Date: Thu, 17 Sep 2026 14:14:16 +0300
Message-ID: <20260917111422.4054862-5-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC4:EE_|EAYPR12MB999181:EE_
X-MS-Office365-Filtering-Correlation-Id: 45247bfe-20a3-4f4d-06b8-08df14ad0018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|82310400026|1800799024|36860700016|22082099003|56012099006|18002099003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	RGPrv/JEzO/jFhtqQuo6pLbFPpdp5Rjr5MFKArPbpXeBfLAuGfTZluYhKlpODvjsFD93K+JZf/83CUIgW4JWmpx+6Hymq7mw6CIVm+eXqfn85XoBOZgT8zp0TUldTzxs3NFe/w0uOpKj1rThsnucFiy6AjVBkoJmSq0tGsDn1FhnAdTI1Y0vHI1iDeAmRPvePm0rEFiZBDHskV2xwZWimEak/ZyebmJCDiRY0+5GaYrTNNM+TkwE+TUeqS01XvC/3XC0bnQ6cOYYoESyKmUyaJm61NaWLpvNAlna+eo1xewFeaFkSdcHYG95+0LbLLb7sPCEZS/6YisUK6bvfv6jZzf5Phxm5aiFlbK7tDtO1v47Si1BuRRSFqPdNJ8m6f0y6p591AJEAmb1fMiL1BznOjr6JRuTLXSZWVVKNvAtEt+hP/1okXd0zjDD+wE3T2GdKbdlequjV7ZHm6KYkpIZ199R9303YJQA4luLsa751fAQ9W4PAnDJzwT9b3xNhS1SK5PreB4bq2MFF4EHy6ak4zt1jq+NwkOGA8eHUP/5rqbnxfFttOLV7z1viWhIs66Q4qOCv8A/2mya25glcKTDxpFceGLBKeVi5xRpA4WExZV7x7yulzZqTYmrZMTEock0F8TLBQgfmZ4MrVBa4OrE0T9q4e4Gkbwnq9yiJqwTP6+4xL0EYbndP/RILDV9gItM6TzYk3RWBDobwgN40UPmWQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(22082099003)(56012099006)(18002099003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n1UXoeQBnFGaegfnMPRQ9xDaHdy1QAaMQh3A/2EZ5cMkD4QhhxUePAlibXfhTWzHeR5Adk4rvwFxsqKFRJ5Uf7zIizH9WjpT52Bjk/XtWcCKDS+aKg2SiHruo8IX/5HezYdXQzBnZIrPCu6/2RoLWZy0BxEAqBr7FLlla1boZPWiiTyD8ITaOX56xeR62nz8+73omBRKZgJWhX2d+Hrx4dtePCSpiLjgVtEeTv+0DMA9W6acR/8v43rWGiFh2O4XsSq9bwVkn4tL3Jx4+H2fj42Z9fRLx+HGICYMqI4Kc4h6EkkXhWyQTOkL0iJf8akLi+FMj7MFGqE9WzxxNq4L1lxVUK/8LEln0XM/zUYwoPBO+HBIG+fL/pyYbhBrIeWLf+/jfYDF/ZF71wcqIPBo2/QlVUHRbAQiG8OLFHvDBwrxc2Yx7US8VRzZWrH3yIS3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:37.1523
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45247bfe-20a3-4f4d-06b8-08df14ad0018
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB999181

From: Dragos Tatulea <dtatulea@nvidia.com>

The data direct PCI driver uses KBUILD_MODNAME as its driver name,
which resolves to "mlx5_ib". This is misleading (the driver binds
the data direct PCIe function, not an IB device) and would silently
change to "mlx5_core" when the driver is relocated there.

Name the driver explicitly "mlx5_dd".

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
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

