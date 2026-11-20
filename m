Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795162747;
	b=BidNUfCvoFa9c6x0UpTJu26cfK//IPkOuCtYPHuBazXTkxZn6j4qnCegEuD3DNjNxACi
	 gJniADisIDeKIrfRxeOajY9mTHxHVfISkJQuh+b0eh1pMKTqMd1L562OwIvO3rj0uHXyS
	 9x/8QTUsK+ddgOhepjzkyF8Ir+k9BM1pOt3V1r2jgio57xbGVUBQeKnsX58IEfHCo3ZK1
	 4a+rsjw1xClhG39A7zkqcXHqj8WZk5FrdQUqcxe6HyEKGmWJ3vOdduoLp38mL2ozG0GYY
	 lE4lWaMuSqWzKV9IaZqTfhmKjVqC5FjFozlGQNlTxBnJohu+reBj787+E6vgNaYvtfA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795162747;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=gtip2GaQoY00o9/OjnR3yP0nnps+V0ywcGxwDzPBcAU=;
	b=zfTMSS7ivyamVhpyGrQUWFRut+JnPPwDH2GmSF5kHvaXIawc3PT9onIKRUBm2WzTT2AM
	 7up/aaA3whBYbrwc4DoUPQg7iBZSMLwMwRzJyLgjFEUbMHdlKGOYjJr9WX0qLdUt0PYMr
	 GQwmn06OlWG6cKZU9BXP+RXSP43lgFe1aWN8j3ZSvOK41QuHKRp8WshYp1C9lPv0sVkzO
	 JqSIo65UGlqNU8j1yXYdMgi9d2h7hUfZzOCazdsflgNNU/eUYSheTJt4IHOOdRKIUzjUn
	 KihHngw6nV6LJiudrVi8Lp2hEuSYPxdA/B++7xlcYJ0BsT9VD/rAL+sYBuf2xpeXPqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bN6f0wGk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.47
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E94606A320;
	Fri, 20 Nov 2026 08:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10E94606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bN6f0wGk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ll9DcYWKsCFEEot+meXSIJKHxH+qc7tV+tku8jtST2MFevPe4ofQbzGYlbGpYS60YOBdBqfeb1dYqANeJiBh4rbRPWGTSp+USLyq/wKmLr3R5GigIdWlyhzGpuOhKmdzqfP0jf9iX08vrjcDY4qINIZ/t+iIrc8QRPvMpCgXalsMyHIj5oTeKN9XXiviGHI9awb7HNRixZSc5X0zVYWhJmm722stZg/uf6gnuE2wM/5gsQP5JmYJ63nuyV58i6U7Qs+sxIkAJ/M6tuoyT6E6K59/G6gc3+Pt1VDmSLRQlqnpIvMoAOKSKLEqe+Myez136Cx2r7TZ53fJfFwHhWzhPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtip2GaQoY00o9/OjnR3yP0nnps+V0ywcGxwDzPBcAU=;
 b=saBBZveZ1PSTF0onYlpBaeZkW4NFfZlpqgp25eyLWpLw3CZVYhvnItIDMBTqhcNpzYYhAKlQCUMcMYcxcWY9q0BkJqIK7yKYxzbPbLpoWJ8q19zb7OUtmvaHiqNnCffLAhRWVnGR2dQ1GoDd1SvfFJWOXJOzZgGkrvTN2SZDb0+PA686A6bY+yaAcRZ+SP+fh7AurnpNSvLIcRaF/umQ8TCw0En6fbyFmGr/VXxkudY/XYq6maFWbToEF1L/jI70Hs7qH+ZpcDtn1+oRtenhtinGDhIzEdtEboyXiEOOxPRd6YK+myhIInExWBbxQJ72G/13LwCy3Ww+BmqmZdS1OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtip2GaQoY00o9/OjnR3yP0nnps+V0ywcGxwDzPBcAU=;
 b=bN6f0wGkpKxn1qmb5o0L7QLyI4pwoL/VjukPw8EZLSavbmOuNE8YoiM06n01QOaEYId3outfyaaEITiMbiXwirwcvaJSrh9UX0+4Ucn13a1Jw8lHuYTdH+yLiZERe+R1KEJkSXKjSEwE3t3AgElSecoihHll+9RvDGYUyMo5LZc1aj7TChTcdQyoICVRDMwUD/hrBcujzBNys2FPJxf8iSBGjLgB2sfwxTPu+53bZXUFpSjj2rwmT7b8Qo+eczWnXlpqxQ++O+9/CB99kd7cQa5/QOc01169wTIo5da/SjMAfXD18jiHFGMBeFzFFJoK8HIY3f/FyIEMRR8HlJibIQ==
Received: from CH0PR07CA0017.namprd07.prod.outlook.com (2603:10b6:610:32::22)
 by DS6PR12MB460083.namprd12.prod.outlook.com (2603:10b6:8:4d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 08:18:57 +0000
Received: from CH01EPF000BE947.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::42) by CH0PR07CA0017.outlook.office365.com
 (2603:10b6:610:32::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.12 via Frontend Transport; Fri,
 20 Nov 2026 08:18:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH01EPF000BE947.mail.protection.outlook.com (10.167.244.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Fri, 20 Nov 2026 08:18:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:40 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 20 Nov
 2026 00:18:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Fri, 20
 Nov 2026 00:18:36 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH net-next 0/2] net/mlx5: Declare no DMA segment boundary restriction
Date: Fri, 20 Nov 2026 10:18:17 +0200
Message-ID: <20261120081819.2538191-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE947:EE_|DS6PR12MB460083:EE_
X-MS-Office365-Filtering-Correlation-Id: d29adec3-d619-4161-51fb-08df46deec4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|6133799003|261009223027099003|18002099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261102123227099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	QCqXMfB2wWZyABWF/TsMHzhP+O+6FUwKewDMVjWfzTkPA9GWykecGyRoG6T0kprmNByxyH4Jt5QV2i2Jn+XtZPsruSCmDByxPaU4eIl1PRRmksfYMdRmLDb+nGHkLhfwn6U96Jmmx9t5VYG7vZx1wzmIoQpLocZQZl2MK8eyWft11UHPxcq5rwYTwar5hIwyzNG1l3gqOKfAWxhItqFKOj74d4DLEcgP/Xx2Qcxu5lJaStmcDwukUkQmRH8lKX8UZ2KS5jtbxM7sKyCeGbf+hhc4cOGGqHYciLZWvWF+QiWnWatgLEqLlF0R4pYOpggO2+VkspLfl26J8aKgRUNC4IEg5HzaTmjR/RgKa1WMOBP8hftpPjXuBfXMeNpPE8LIDK5r9Et58KNyy0d0M6oN/YVuADSTUJRkKyzlL22/GqrRO4RkPlxh4mRtpi6cvQZPrvhlGsf1jjkOIoqKW+qKt6WKBiKH3oZ1kuLBNFlKtup0YS8WuzT2jyI2tWWYPpbtOXXmOMwhE3uTk9JtQu8dGw0Xiuz1SRNC97dtlgR25a6yDY+2Ag4WrkLcsnXn6z8zwZC76fJ7eR4lRLlYA9UR138ShazfQC6zr5PA4YXfXf7xtvqGHUVpw7eXAx+MZQfTDwYqnaUVyru690D2XOr03igEhLnyIvjK6v+hGIWgVh0piHvNQG/iWLe3b6uN2/AjBiMA0sPg6fTb6IQnUeFAZA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(6133799003)(261009223027099003)(18002099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SYn5LglJb8Ubf4P8hetcK45OJcuCxnQbQBRIIRQ0ROA+mgGhjBNZu/BDGGpV0T9uzwR1PilQi42j20oDZoUapkA+99pVZGv/0res92TNREnT3HNSbdEqmuxGznef+mgImshVVyBSYXwv1hrDcdyEmXZkmbd5FpP/xLQhq2O+SyfKNuPAHckCrHtFew0SJIlFjCoveomiLBjy8Wa/YI9S5+scSVbRjz24gKS7kPnJCYciKQ45FRoMHhzw+HdAuosV8Ptn0p/zt0hPbaUdKKOImZeQNLHR3kDcKqXg3WwgGqiWHwchk6tWdErZvL+EOxbGcNwDorbyfQ8v9oWMQIp6+dByIFp/9weUKLn+j+mv+I22hz8sdDItw9+7dMkBQH9TKeXnTHXp7MhSHWaopY9gDNY/qCAoXCPXjhCDX9KMzJv2Qvmbf5QopQndA7faLmye
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 08:18:56.9817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d29adec3-d619-4161-51fb-08df46deec4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE947.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB460083

Hi,

This series by Yishai declares that the mlx5 devices have no DMA segment
boundary restriction.

Regards,
Tariq

Yishai Hadas (2):
  net/mlx5: Declare no DMA segment boundary restriction
  net/mlx5: Declare no DMA segment boundary for data direct device

 drivers/net/ethernet/mellanox/mlx5/core/data_direct.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c        | 1 +
 2 files changed, 2 insertions(+)


base-commit: 2208ab00f4f213ade91ab775e7f8c4dacdcc856e
-- 
2.44.0

