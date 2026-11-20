Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162747;
	b=rq7E5t7aXE6HCfYzg15sfwi2oW7SF2bHxARYJlELnsPujgtcMke5TcRqljSGoqvExICm
	 BL9YrjhkQMX4V4lUVA96zWBMVFnrBh3Z9HHIkGC7U9lIFyHnVbplnM8iptDli/UPbm6g2
	 KykG7sX1cFgzwBdhfWeamaXHd2kEiOGvIZyjNq1xyXJOLe/1rXWZVr4SFH+7NaXMQz7vV
	 BfIcMYG4xKWseWkpBksx32ddj3bdMS5X++Gsj47ttFQzD0tfV8UztN+Kg3PVHbNB04O3u
	 YhNXXtsMLrt6ob3f21jv7a+95uLCENzxGIIh4hFubnAMkd0CLh6yeApYqsfZlBvZenA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162747;
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
	bh=y/oBTSXkSdYWXvgoA0bJKoi32zBLIwCMAiqyz90RvaI=;
	b=cG3T3fL0SqtbxeTG2a+FizON4RljxYUXCXvt/CDOAswiuOHYHobp3fo5msZjLD8n52+c
	 faHubnWbH2orBmkW4U3O+ZtV1dZPXGxNQmFDvwwrE7B6wlaM41rtJGVJwW6sLvsKbtqoi
	 hjesJR3X5fTT76gVLRz2qrVjGUqqAP4LqVL8ujF10kmZtSIo7I2Fv8o77G2U+ZzuSA3GQ
	 M/SDJZXaU1SrNgkA50NbJATnZMwf7/Wds3Y/glsMyv17+V2KvGd/B8dcaUeuIIVdtd8H7
	 mJWXMOlWzB7mc0wpu0SGJ+7/hD6pS7EQJVUTs7FQ/q+qBw+W38x7HJfeks7eBU0ES5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bQT21Rmt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.41
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C7606A326;
	Fri, 20 Nov 2026 08:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 429C7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bQT21Rmt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkwo9nJAiDWEjoHd3N3QQoLi1bBcLbxf+M98EW73ovAR67KsvqSGDpJ6czJfznDyJDU2TbtZ+DkNhAUU1GN0CrFOXvqaiUIsWckorGuzd5qBCrGMOK3HQuPwLgkTR3JzorLegocN2xowMFuhdSraJigLNAiizAtuTDNIEA+2K236YD6zrA86nl4SvzkNW9UD0YJvHWMdHkHN7JCOagzJ7hSqx7wimxjQ+ISwFSqKdcGA20oEPoGX8d4qk36Z4Z6fiBKxcJQfjGg7JyQgUXn3cGijYgWsmwcVuPQ7mnAnzM7q5wYuIMAVt4dXbv6nozu4qHnKQzPC/4O98Go3/9iOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/oBTSXkSdYWXvgoA0bJKoi32zBLIwCMAiqyz90RvaI=;
 b=OnnKEMs3bQmSyQcl3hZg2FZYQYPB+PXpdWTOiq/iZjYLtdPId+6umDHv3jz+6Np7G9d4PBV1NkD5s9iRcXGr2nC/0qXnspBxMvFQpi90S7KC5a3+xznGpPG21bMbdJ42WXDhQ5GvQfRP/BOn6sA//tBeNB/EdKS9lKO+o49oSWJJ76aU6l1mWopVLXnAl/mV+/Kk8VYTDVLIBP4gI4ev9EfjOD+nSvsrjec4TTbNGpGqlXo/u4qqKhmX3lYNhDg5XnF/T3FbUS488/DIjs/plIY9Zk5dbEtiJ/8LDL9gfdTHG4FrEOtc/qKSDohnDXY+EWecYzPFVIjQqA3RgbBTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/oBTSXkSdYWXvgoA0bJKoi32zBLIwCMAiqyz90RvaI=;
 b=bQT21RmtrTtZlNQkFkFubDT1/dUuGw2EVBYt1WmMW3WtzsGlzv7qMgi6HhoCURNHZD1eQFoD37Cczsg/bCGsVpN7c5x/jRWx0J7ZslmC6PHhbJJWYguAFWru+cq/3a+VxTDefyuZJY7GEbfuLr4Rntajc+NP4sKncnjdStYs29WJe/B/ig/yr9ueAhcjPI27mWhbWA+i7ZGgWcQwBEAqTcm+O6l4ek/duRuowewki2Ilreae9cuP3AXZEenFG3fhVz5XNbLIy7ew6uNkcx+LwAUSykY3LmtStH0v5Rgy61jvsUgIP/Y0Lq8BaAsbknb0PnoNSIjougNnqY8vim/yFw==
Received: from CH0PR04CA0061.namprd04.prod.outlook.com (2603:10b6:610:74::6)
 by DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 08:19:00 +0000
Received: from CH01EPF000BE946.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::2f) by CH0PR04CA0061.outlook.office365.com
 (2603:10b6:610:74::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Fri,
 20 Nov 2026 08:19:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH01EPF000BE946.mail.protection.outlook.com (10.167.244.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:18:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:45 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:18:40 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH net-next 1/2] net/mlx5: Declare no DMA segment boundary restriction
Date: Fri, 20 Nov 2026 10:18:18 +0200
Message-ID: <20261120081819.2538191-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261120081819.2538191-1-tariqt@nvidia.com>
References: <20261120081819.2538191-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE946:EE_|DM6PR12MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fde913-e227-492d-2010-08df46deee03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|36860700016|1800799024|6133799003|18002099003|22082099003|3023799007|11063799006|56012099006|261022105027099003|261026140227099003|261022075727099003|261028144727099003|261102123227099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	uYUyRiYRXmtEfR3WpdvNDXsbDM5qe1yCpB1nqLPbrV6ucKURMWpqiduJpr1i8ectg1bfW9dOPkeHkm8ZeciV9lGDcnFb23/vCOXJ1ugCD2YLg5sJPdWrV5n7Pl9IVKtGqiFqM3ZjOwMsat1Z6MLw8AAH9TUKnSV0bSQMHmnaa6avtLWRk7pz5jLTLYmdQfUEUKyag6kyp8NfKo8h0IxVkSB2IkiS1jgSM+qIU9jUm496qofEbPGImFwii5xLdz8H1qG2PdDbHD1IgkVu53kxepIGcaokiSjUlCZERoXCjIoKhox3oyCQl35XlispRYy3iAW3o9/e2mxZ2ReXK4ofbVWRXMBcjIsTmHk0iNIC6HBrhc5XDB3WTvNZhj/ISNYwT3jPaxxMVarw1TXu26HDjk+xP7KjjxyT2AEgTzFWdzhVnX5as9RWRiO+7yLwRIoQUhyfMvuUUVMFfb6oYoM5IRoraMfltgQQv1W0zir9Q/9XDTi1a9V64eNlSRYEyXyKvAq58B+C24nUC6lLfFgvX+GhOaw4r5WXTzfbwBBfL+idBQktZ7unBz51CvDJFBa/C/ZpWo/iEZJjujRfe1NNEeoT5CCxBMdUZiJHcOBkrIhrXDB9749r472g2L0E+uPcSgQixcerB1w5E7E/LYgl3gQDRal4zx9S6MjbN/PsQCs8K+fut+sB0/XtMF92DgfV+QChUizIUnymGfBgfrMcJw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(36860700016)(1800799024)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(56012099006)(261022105027099003)(261026140227099003)(261022075727099003)(261028144727099003)(261102123227099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PSS4JfvABozgaz44j62ltzUjE/28sUlo29vgX2ZAvQG5Nru7F+GmRQv5xMrgcy4oDVBTZx69WlK37sL3e9nOAngFWT+UiXIfsBmD45MHRKGRA4+OVTWhu9Vio5WFQyMc8hzOxnuqEJlRf0yg6MHx4N1AqLshZBgEKyxvTbdM0uOdu3sUbXaBNUmxZbaff7e9gj/LCj5jhoZMfnHSZWVgtRtev5vSOK/ADEprzTTZNmQQoPPTzjluduY3MyfDq2xyt+qnGIL5YwpBopPb4kPPik5EgXoZpKr75qssVNGeAcVkHYCrcuEJ9guF6KiQAT11Hca/ivtlMW9EPnIVHQgND6xHO2gmL7XRMTDGt0qvE7zkqLH+qWOyEGkliMQCbIgA8aeetuB/DJ+om9zEB5hkO6TvsDiW5K+LS72Oy1TYYZzQDZ5l8FMmbBBCuWl8zbH2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:18:59.8148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fde913-e227-492d-2010-08df46deee03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE946.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353

From: Yishai Hadas <yishaih@nvidia.com>

The PCI core initialises every PCI device with a DMA segment boundary
mask of 0xffffffff in pci_device_add(), which forbids any segment from
crossing a 4GB-aligned address regardless of its length. mlx5_core
raises the default maximum segment size to 2GB but never overrides the
boundary, although the device has no such limitation.

Consumers such as ib_umem_get() coalesce physically contiguous pages up
to the maximum segment size without consulting the boundary mask.
Registering a large MR can therefore produce a segment that crosses a
4GB-aligned address, which the DMA API debug checker reports:

  DMA-API: mlx5_core 0000:08:00.0: mapping sg segment across boundary
  [start=0x00000002ffe27000] [end=0x000000030020efff]
  [boundary=0x00000000ffffffff]

The segment is about 4MB long, well below the 2GB maximum, but it spans
the 12GB (0x300000000) boundary: the upper halves of start and end are
0x2 and 0x3.

Set the segment boundary mask to ULONG_MAX so the DMA constraints
declared for the device match what the hardware supports.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 079e91c98041..b3f4d319d29e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -190,6 +190,7 @@ static int set_dma_caps(struct pci_dev *pdev)
 	}
 
 	dma_set_max_seg_size(&pdev->dev, 2u * 1024 * 1024 * 1024);
+	dma_set_seg_boundary(&pdev->dev, ULONG_MAX);
 	return err;
 }
 
-- 
2.44.0

