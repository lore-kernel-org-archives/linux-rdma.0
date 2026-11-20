Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162751;
	b=lZegIBdSL2/e/FFYdlilGi4avI7GTZnEErGZjudlcBj2kRducIxCFagYXJX9Ic7qmRmd
	 SXA8yYzgp9wEPLlc0DFi6cr0Kn8Xlttk7EukhsUWydfGgU156M+TZaxyxTuDjXYhnTtY4
	 5FeLZEVhd/aM1CatgKo6/9lN0Gcl+Ym+oF1Yna+kPGDaTkICJ1dHVIZmK2knsKnrwxLIP
	 HHoAUxsphBpl6pkRKFXNCGZ/vG8o94lqCRgXQNwvNqAePXBV7e62DR0tKiy5lLltWesal
	 7sFYTSqTzVy0X78dsWUVx6H0RIziePWh9/c4fkSB3fGpERxQXoezWWg2WAnIUtdqMZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162751;
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
	bh=hyzOgf2rSKZiDZAmMHpItD/Dui540lIfKxYmk2ixTdg=;
	b=W0KnEKb0SFzQPL13Q9qLoUeG6YqT+B1yTOpXpZlge5zZ/objB873rSI7wsK6xaxN4Y76
	 AoH4hyjIQsTGuwkrVqtuNKWaOMjP4X5IQ7vBUTSWgjiYruDSSNa9/F6PNcmDYF97E8VKz
	 reRqwmtgxyR0SFCns0tpzQteFfgKlJXc2DwYdSTPQLT+hcLsyhZnFZjKN4zDx1X1+Qqz4
	 5HJwMTXInCCfxDwZUVjpCnA0zVa4JlqgEXCyE9IdevXIYBiXe0VYY9NHz1yVEFXU+GLyP
	 Ed+mcS/2zv3c4q6LsofBdlp/b8jvq4nUUJofm9U+a51j2D1+/A9fj18nWY7YAhfgVIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jB+427H4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.0
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDBD606A335;
	Fri, 20 Nov 2026 08:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DDBD606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jB+427H4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dYkhRP6bP6xronw6/vbQ0aLZWWB3K91QMsJdD1SUAbPfKAlaSknhSa8ro0WhKTRsLFWgfBP2vSCQ2Hl6qXg2FjExluYlacy5jq7c0CNu95IMl51PUBVJoGPP5U+i0PzAbRhe0ejeWh+vCw3bTr2jRqPeRDjp7MSJE36Tn9p08EEIbfQDHeHwi2VhdZvQhRdfWB11UAMDuCLfKWCVC6o0MgREOXzR6sPThNAShfNs4pauM4RrOPoDf3GnM4H+RoMb78rN46hj41ZHI4+QOmfMp9FkgtxPYl61X+TpWRm6prcaHTczHrfG4tP7o9s3n1uiN+7orbpFUpsFG+/1tHnSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hyzOgf2rSKZiDZAmMHpItD/Dui540lIfKxYmk2ixTdg=;
 b=FV4Im4K33R5bP2FRHYvK9wcObsWD6NH7XNz5tZz1nEkSQVgjBJJxQO57nw1aBDRY1VJjcMkAoen/dVKwBVsn+fShzuvjJe2yGEAOTLkC3FKCH45W/fizKI6CzbYl7gxRrVFN8gx0gKOuAGMMd6nueN3rYWXH2JypMCg3X8KHVyMnYOXRhlEx1jSZnpRxGNN7i1g+eh2GKfxHhSYQVUUBFCFHRgVBUEL8gNN+77Tgpd+shbJl5n2w2Lbj0BoqiDr9A1AdZlF7gYKrw1serc0fr7qN9HADBWEofEdzQkkcZcf9gyvSl8qNgr2Jpivz8SFHiURKfwLN2H+D+uW4jvJqig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyzOgf2rSKZiDZAmMHpItD/Dui540lIfKxYmk2ixTdg=;
 b=jB+427H4VMG1KkyhAFCZgN4NHVtadTNhjEy8K9AJ6ihPuWX4zTO8sjETkvjHLf+bR8QoK/8PyLxuD/gBVGmB6d/E7jR76MSycjKd2YwIpCwd0cuWDbGBCJCVg5+WAp0HnN5STa2fG/jWvraChe78H8O2gwJ5JLbPHZgrgVnKYq2C2Lqz7a5lo0044oeAJ8bQzlSZsG7gvI7i4ZeG7MxogK7tESrTa7aFzrtNntoyPIyJPZtHueHsQLzhQUm3K30MP4/7U7180YYdTJevJTLBU+t92XBGb3yZD0wc8ZMXBxGLhYt633t49+KDIcpxf3aF93QWaEjXXl0oirTtk76UGg==
Received: from CH0PR04CA0058.namprd04.prod.outlook.com (2603:10b6:610:77::33)
 by SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:19:06 +0000
Received: from CH01EPF000BE94D.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::a1) by CH0PR04CA0058.outlook.office365.com
 (2603:10b6:610:77::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:19:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH01EPF000BE94D.mail.protection.outlook.com (10.167.244.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:19:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:49 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:48 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:18:44 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5: Declare no DMA segment boundary for data direct device
Date: Fri, 20 Nov 2026 10:18:19 +0200
Message-ID: <20261120081819.2538191-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94D:EE_|SA1PR12MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c099c5e-da02-42af-0e13-08df46def12e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|82310400026|23010399003|10067099003|261026140227099003|56012099006|11063799006|261009223027099003|261102123227099003|261028144727099003|261022105027099003|261021121427099003|6133799003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	scAAzkkH9gNDC8oW5/oANUVHHWaGZr5+2jvLLbxkiYJJJbffFC2crHCKYndn3spT6GaBFQmAL6XAevctw2x8CLk6bcJhGSKr4Sy0skNy7oQIxUCHoRjCiKz+8GuMhwTfmWJqWmNvPdQ7k/1VDjmVayn7UbKFFOUywK4ptbSF4Iqv+Z0xcEhfIikqJXoZ8iSiCoJpQyetWMiP7fhfGPCVxmUiKVmIy1KgW3GHQucLTC/Rfzi1TlBnm+xOehqxE0vMRcOAe+DzJV5y2/gJp96OEw3Sv25XJnlIe/rmI7xbyjGgKMxKgq0OfPPzRu6kf0UBI5ziuF3XAq4zQmhz6x7xfow1ZV9kIm0YoLQfgQi6O8+foLg/ald3a3mNfjbjsClAH0QpTStaSBMWhP7sZFQwf54FsPGtpylfzfFRHK0ACYglaoBtaurDo4CR6SmQfhdMFRduycmo53XSnGVw5kM0+SwkBdEcsmgoCpdjKdJv4fQZhUgOp7T8TN1s9ToTtrVsojbGUma48kwCeCNe64j5eiZItHkLy9Y9jAuAU6VcdkmSJlny499Fd9VOAQy59ZKhQTaO1jd3EcVTvYhpcK3SsrK3PkXWqgOfNfBfYJEa3FxocQe9NiiHk6Bz+dGmCysxzkCgORFChTGf43LmAebw6eXK2gYYzQ9CSwE6LIh+iwvBARdODwBzuTZh/c6sOvTmTZZCYUHNGc40bBvLtWaNog==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(82310400026)(23010399003)(10067099003)(261026140227099003)(56012099006)(11063799006)(261009223027099003)(261102123227099003)(261028144727099003)(261022105027099003)(261021121427099003)(6133799003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ylLJhKoND1wMOgDieL4sKptVlLQzPYQ2zFB6eV/LEMdP+U0zGbJZDflsUP/OGaCNOnLp09iLjgB9oxB8my/BjErReaGYLUMrqQWna475JGWCzFMG43UF4g9eywlsrMguJdj1FNBj9aueLxEeSijigiQOfdAaSUABEewV1gxTD/jB4RzgxgY7S7ZpvqdMLw6pLLbDb4o76B80V0HZAcHW8E9iUqw81RaLV8bNnUugU9eZz1kOxmHebQ81wloe+FltQjflCrmDfAyiz6BEiHMTM4nbWe7zM7KL335ROD1Xxw7og3HzrptEJ3pjBUb1Iw4+DkCmNinAYbeladqrTTOkLMKDw42Oxdgl6sXX1uxBicj6iA8/YSg2l4gosLk/PVYTZwcKzUGnViPKHlMT36Z97k2rJWgagxKdSVBJ78OS0mx/+39lBZ1bp44h7xMXI6P6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:19:05.0853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c099c5e-da02-42af-0e13-08df46def12e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7199

From: Yishai Hadas <yishaih@nvidia.com>

The PCI core initialises every PCI device with a DMA segment boundary
mask of 0xffffffff in pci_device_add(), which forbids any segment from
crossing a 4GB-aligned address regardless of its length. The data direct
device raises the default maximum segment size to 2GB but keeps that
boundary, although it has no such limitation.

Declare that explicitly, in line with mlx5_core, to avoid a mismatch
between the declared constraints and the hardware capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 5afb11a2a9f0..73eef8bbc327 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -103,6 +103,7 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 	}
 
 	dma_set_max_seg_size(&pdev->dev, SZ_2G);
+	dma_set_seg_boundary(&pdev->dev, ULONG_MAX);
 	return 0;
 }
 
-- 
2.44.0

