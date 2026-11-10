Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318361;
	b=SpgBFj4Z8ff9h3yOtBKLh/urKtjO44NYHfAMB1lR942yBwcC9Sirw/B1qRGVe+9b+7Y/
	 eXyfRDm79BbcQ4nmoZ6LJl2D+Dd8hExS6ordTNx2IQAdP4sRmJA6gNsvW/Ao6jIsWk80g
	 w/FPG1QEBYvbltjT66w1oZkeycYsLWE2xZw/rr8KacPSxSSuBtr3XQnqchQNxkH3HeC/I
	 +VRY1PfddLT3R3PwWYUERbEn9gVg/RMylpQlSougFctQGS0kr7gkUQxFELGeFjAVazwnO
	 2nXCvkxMyqcuj/IT/QxljoT5ypO82PnVg6MB7ZjZHlFfq+VgNsSPl3mncd8epMxko4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318361;
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
	bh=8xEyeX89EwKuraatt/4BvsHVwJZGlEhvoU7ndJUQ+lE=;
	b=a2BdsTxTN+Cp3VNs/3B16Z0tf4rLcwk0VOnR0ycfirT6Iad+p/GUwH2gxGAvv2L/Wdvf
	 PmDPRb8/8U9efSPryez4iVtzM21cMlXoS3lAFDlTZuBLAiNjsHSSRXNXhWqQbctZH5Pfc
	 VW/kaCqrXmlv7wgUnAxAamSlCGw0wqblLQw5x/suukmrQZZ4tmNvw+akOz/QRMdQtmdPL
	 YNl/rbfR7aN6S6dlpUbqtMSRcbezoRaiOUNL0db64vYTF9cBs6R2A8uBcUJzn/Yqd2heh
	 TulI8bpIOq8awZYRa+QBmMyzWFC+OhJxuF4Lmt0pLDp0PqlPyRPCxZOCS1PFd9ot2ng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cNsDjMOG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.35
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013035.outbound.protection.outlook.com [40.93.196.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D465606A32A;
	Tue, 10 Nov 2026 13:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D465606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cNsDjMOG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x08yr/otZfEAvyTnAEPIp9eIzyUrv0B0hisc35/v8UV57+CKWOUWnyE/aNt+Yc16xu5lu/b3l/1xV/wZ838wxqQHNh7q84AeRiakqA5BZQaY8d8qXhfs8PJSYIHhWLby6BxfMp6edbNlztYcS55aRvMkXo/ZjbiManaJHU1R/3+uIWEGfnhs2LV5I44TjA8IzgkSk+pD3aFGHF9iop7XsfhDjuBxKNBaAaASneycM6kYGftcucoOVsn8UPnJOxEXrEoNogJhX36dnl6QC8yv9vHfWKDlYaDKs+Z3Zd/4dFlAbJOBCyVloRUW2QVecOk3tEXq/kt68RgTByBMqzGHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xEyeX89EwKuraatt/4BvsHVwJZGlEhvoU7ndJUQ+lE=;
 b=MJGZPUWhf+/HWpcI8X2FSEOr5uKMf8C+g/yXY0RKK4mEFcxLaYQchWDWlfdVs/eDdScQhCyG9pSzNS9umLWisDo+YjpY9KcFyqidGNVb6FT5bYXwMQDGO97gy3Bb4hYpHMyoHaJuO8d0+kP8n7YO/vzOa4SRurw1n32gmRRZ+Qj7PRlR3GGkXVzm8nCQDseElnkVcxL7JutarlXW5ZMIzbmyOf1Jq8wSMhQHNmJ7TAcmwDfO+0TuEbGTYjUnII1zT1eHeGvu706bAaHSXH6xC++LZM8ZRy9pg8A+bl2gJlEpGcLCftg1ZSGFlgbthzTdDggB4AsTMMuDQpnkCqZhSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xEyeX89EwKuraatt/4BvsHVwJZGlEhvoU7ndJUQ+lE=;
 b=cNsDjMOGtkNgnPI7C3N+E9eQfJSwYX3bvhCmVVOBcTFouDggIs6PhCrtQrktUX9NiGf+cd0k0kR2WKwGYWkrsATYMiu7xYtX78gE/W3YrRdEC7N5GB4FEjYDqYCea8jbhye2TIJ5XwTFkudn4veshT32HAQ4VC4hBRnKWux24Nx851cYefK4p0BnK749tqXsKCRn+3EHwojBqFu4vgoWNs65PbV3/1jwejfBYxA4q41UMK9ykSvGI6hBf1y366TsFAd9b0YVHRoAVTFz36zwb6TvW9Vde2RxL+th+39QQszT0bAN+sAFK8psiJtpF8M8WoxebgrGVAQGol6u4wzMGQ==
Received: from BY1P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::15)
 by LV1PR12MB094641.namprd12.prod.outlook.com (2603:10b6:408:505::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:57 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::1b) by BY1P220CA0019.outlook.office365.com
 (2603:10b6:a03:5c3::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:38 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:45:38 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:45:33 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 24/24] RDMA/mlx5: Advertise adversarial mode via ib_device::adversarial_mode
Date: Tue, 10 Nov 2026 15:43:20 +0200
Message-ID: <20261110134320.34408-25-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|LV1PR12MB094641:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a790d3-b1de-4da2-2f7c-08df3f30f2ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|10067099003|11063799006|56012099006|261022105027099003|261022075727099003|261021121427099003|261026140227099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0qDrs0gJ18bwioB+jiO01+MaNR02FdK+Fh3lGKIQ/MecfE9rXoWzgcd/xnLajmZrV3t79tw7qpfjZ9Vrykn05T2zgJFP1kA0j0n4xRxQtiU7+XPCIKV9Gk80/ituwpjOOVSWhyjPf7iqI9uhn1BS/XxTtTrguxg3MTuKMJT9s7bnIfvKSkXUio9ILBnqhdJ1pgmjk2RUD1aUIHa6YJBR+XynVqFg4bJpk9DRmFJMZ8o7A98Wau9J7owWgpNPlvbsaryB20T4VVTKGKnDgsR/9bqCFsdGwH9WoZWS7Tq/+XpBfhPbY8us0CnymRFYhr+3zfPuxGNfSzLT5xUgsxYRSg4ETj+jgMDB2Yi9YNRtIOmaM0fP45FBvzA2OOkmjoi2uYH1tOdStyr0tuPknqcT5MkQvI5f1VGJ2D7nI2zok4cfsUtOp3mwyVSD7Jc+9pzCqjElvW28XFjdBREJvblRBirZzopndDqhukCJKLCyNK8OhRj9TFTxT5qKdzwa7fWqJR/pkKnXrhDcRA2LgyXM7peu+eybR8HgODIVSJpqk4hrsQEn9YqmMWGygDKxPp0xPf9m55cAZkXaao9KBHv+7k4TEM66vy51eO6xJgJ3yxrIaC1ZihAlA+cpAMGGcmootoP2CJ5rW/at7SLO5efjwWzGKMh7hk6PccTeEjh8CB8AwawiWYLjUNE7ni8G6naUUJ97KxbO/IC86znbW4jn1Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(10067099003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lD1x2q7lWL9DRdIz9KUfZZU6r92BzmxMvojVcy1EQtAyw+GtNhL2w+UsyDDo4RtpmO+/Hq0NKBZk06ynIQ+hQ8z30lxqaitLUU7vb+qDH3rEu1NlbYR/cWdo02LQkRSUa4S3kjOxiEA7UfmBJo18LNuaomsdUdy80kUlZ744dyy62FioGSLH9knA06fVTXM5FmbMkp30D29eSicyYlONL4g9TGxqWbUhmfueXl9F6CRSr0DimTox5bUThs6ciK0E8d3KGXoOHwEhTc+no1Zh7u7623+SphZUaNLEO67B5M2UlP/YuQRYHWalCcQ+3Wu+6MOyHq1NuSzj3+xsikpIXKMgVWvkxtVXv/RZFfEtzJ9g6ZDcdVhpWVYtFMxuP5g4iqMuQ+hef0G++QkiP8qvZm+vJCIJaA2IanRGiJcIIsXBLmxzUd1J3sqpl1C60PNi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:57.6139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a790d3-b1de-4da2-2f7c-08df3f30f2ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB094641

Set ib_device::adversarial_mode during capability init, so that every
mlx5 device in a CC guest runs in adversarial mode. The core then keeps
the kernel ULPs, and so rdma_cm, off the device, reports adversarial
mode to rdma-core and lets only adversarial-mode-aware userspace open
a context on it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index df42a04799ec..7f71ee60c399 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4777,6 +4777,7 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	}
 
 	dev->ib_dev.use_cq_dim = true;
+	dev->ib_dev.adversarial_mode = mlx5_ib_adversarial_mode;
 
 	return 0;
 
-- 
2.18.1

