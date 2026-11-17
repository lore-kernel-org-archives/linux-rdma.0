Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935453;
	b=InioRDB2W9jIB/M2GLKwQWvTZAfuAJmZNJTfnfTga2BqGch8oh6bxTMce/K9qSFAUcoA
	 lkw1kdpfoUFx8n1SPmANmQYeomPkTXMe0kKKHomPq0AEb+W00IVzWbE4S6IFtSEF9xygj
	 e6XvlBIXlYBjvUyR1AvGv6y3IKEcSJDKPVrLPkNtqXJpTV0RbkKegvjl6uTZ2P6IvbzmF
	 KCt7tSx/hgKZyHPr2mONtSLaVOfNej7JIpOvEzbmddyS42ru0fs8Lh4KVmg5Ld+djtuYt
	 Omf+sGbf3go5qIbkcK7dC+jnIS05o2ArGfhn4FdLWbbpAqizBi5nFQlm1zOH18z7D7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935453;
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
	bh=vlfTpe8CmRQC/7GU5C7V873rs+mcE1+GM/7WVuHjfv0=;
	b=Y7vJu9g/IyClvBPjdKPJuqut7KibuK91mAG5hZwJe0DfX/jCzeoXBSEwcpQx/7Phz8Mt
	 QW8AeiFnhrbbXkXzP69yaNIv+twi6sVuu6ajWNz4+7pR0V/VtS1BCz4mLfU6DyKeeDcVO
	 6ObtYpyeDAI+rrwdA8F+0njSj5OJjC9fMxBYO1HfVfYsFyEVuHEPt12u7T46jRMuHnGpo
	 Sdn3BTFyiqS7hgjAH8Qf9qxyHWNm33vv6YT6q5CpO7VA/qjxyZz/O9G2wh246N5LXZ9KM
	 WG2L0rIIUTSO7WxPFQAaim/1CjogzXd5M7Vh8QcNtu2eL8W0s6lOj0ZOPAYU/0XKkbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RjRxrPlD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.52
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B774606A330;
	Tue, 17 Nov 2026 17:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B774606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RjRxrPlD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCG0XJ1nWJXBc7pPnvxm9HSQhnXov1rQCcBI+rr3brfCZgVIXjnr+MG60DD6ipX9G59zEBU6tdznjEDwRP7+7vD5aGdp6o2ZfaqYvVcRnZSuybMP+UzxDohISf31oe5StfOdcGZv3COrH6aJo2a5+Zqae2NaH4hkUx8lUNyMkLF44PMtZaAClIs79FdU5sQMpxLXksK/iFhBbKz6nFAeSvaFZBnosOMxBv6+Ni88n+qiZm/gwAHxJ+BSuLr/lBFwqGO9THlWMbAj4VGlIAlSTO3rBadXWQ54L6GiwM/0OHYO/Oq4dmH8qo3MmFrQVDdz5GEUruuKYRhiwPS6g3mzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlfTpe8CmRQC/7GU5C7V873rs+mcE1+GM/7WVuHjfv0=;
 b=xttj+JCuHF9ow7onjmwsK6oS/r1YNzKFcj3Aq0V9TsUeTbVGxx/mMMObsQvVTeYPbbRCbddUEyRVRpy97EiZsnIcx0AWoKsCOUSYsrs0pfH0+445ssCs2EU/I+cWQW1KoVsBJVLIbnGA5nrRpwlaYzkfuqp9Dx+brg5WE8Tp0CXvQWYMveQAeiyOP47Hy16eMOSfkRGiiMCrz+39WOxox9QkBrc81HgXCV6mhiUaDHXjvBinx85iSefD3m7sf4zRof8W87Qh1S7Ss/QK+rB2UfVpJb2uQffRy+22h8XC/65v5cfXEVckcNJCY+WwF8mVgU+Tu2WHJFBRLTyaQeeEIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlfTpe8CmRQC/7GU5C7V873rs+mcE1+GM/7WVuHjfv0=;
 b=RjRxrPlDLM9ZTE+Ewm3X9apFqrZcmb+wOuqnKmD3A2DKZxwaORPfLNpuSOrLb/82RL/h1JYDpI+RQ/B+ffE5S++I2ZFgUL47pSOU6K9tl8AzAUOIckhyuwG6clwHImpNAPYLuOPn+GYoR0oO/0U685t7Ltnqrl2TasQL21emvqhYkGDu6dh+rq1EpnQnuEAFmk9nIUNWBr/YTDGsEiqYje4RLqSqBeki2W8cFGU53vyVXBPr/BjtpwkOw5NTf6+R15KF+B87OBqESJEvRze+f4p+u2qog0Wwq0D7QDJVPZoIKeqdFaRbMjeGXawhDBQDz4HYT+HG9TBag7aXNUPqhA==
Received: from SJ0PR13CA0130.namprd13.prod.outlook.com (2603:10b6:a03:2c6::15)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:42 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::1c) by SJ0PR13CA0130.outlook.office365.com
 (2603:10b6:a03:2c6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Tue, 17
 Nov 2026 17:10:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:25 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:25 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:20 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 09/21] RDMA/mlx5: Set ib_device::adversarial_mode from mlx5_core
Date: Tue, 17 Nov 2026 19:09:02 +0200
Message-ID: <20261117170914.27410-10-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1f1c22-c35d-46b2-86d9-08df44cdb619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|22082099003|18002099003|261009223027099003|261022075727099003|261022105027099003|261021121427099003|261026140227099003|261028144727099003|56012099006|11063799006|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	Z7dn0nFxcIa6SfJWtFt6MGqwUMtRvbNlZ4pZCBJVxrKe8TvurrszLCUjQvSmBI7z5WI/hXcDP8r9CikpBdgATvdaWNYiugzb9+BclppCUMZ1l7WUvZJLVADxVR2r/Yz72SRbCcqZlEOxXbyclrU6CaGsqkYMmtftxOWl1NLkHDy76+uryEOuyw0AJoFrINsuPDhlQigMra3Ovg9bQ10uOK0m3Fvg1ogNRV+8+MYrI3exHwQ1m7feX6RpW96D4vR7jlAFS8+UPckAhf+tHv0POGqOCuB77asjhLTFrciXE/2XxiklBzhg4pqXohMwh0swd1EG1YEGdUuV8TMVLPUhu39DBDMg0mPDmO4Csk8tPv1jH9UnSEVoxUdSQQs3dcgkPK+mQgpEkrwmLCyXB8a+3Nebqmnia6D6AH+B0dPip9OIDXLBqzZ+nyz3AU0S8plV4l+mpXWb5urcwWk3QtPoILSjptAn088mxIGfyoZAqlBuML0hvPlKtwmWY36Lb96CcQ8eKvjbeesZv+5ACW8AttRYXM2igOhg3CZGuq6+y0B6fLKZaFrp/uIqfAU9lIcpczFnLBqH+qxob4vTf7hX/4OC/XkNmZWCHD6FGuQQXf0H+DiMc1C69ngwo5yZJhSXBKemVPdBBj2kppxGYIqtmmOSb/bG0Z9ULvCAHWDCOaxcgAvJfwpM66NoqnkXHY2Vxq7qwsh8vHvpFIBljvxCfw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(261009223027099003)(261022075727099003)(261022105027099003)(261021121427099003)(261026140227099003)(261028144727099003)(56012099006)(11063799006)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1PTg/TXSSxi/xByutJm6PGly6QOMLjyd2zjE1T+5iIDkZtubrJYAmEMOoP4Jz5ljytHSjPf7Bb5pn5P6jC/0U0d983G04iYM8Zc5e+k4Wup6MFwk66A8rbaxZlZsXRck+Q023ixSXH78MVHkcsDlmjJk2DmPuMCfPPXnHmKcH/xFvagLNE+HDdJ6c9beIrInunFuncHVAWapWJN1zSQbZF3T/xhWDjT9vRUJzpXrvN7UVG1Y+quIKc9Hd2uFwqRTI9+F1K62wO87tAMd9tSj0RPJL2mvwzq9ZekmbzuhHL7u4qrWXy63PbLyzTXq5K5n186RtF/540jncoFHm/bVmghSMf2tll4XZ/tI6yIVtgYjckGm0jbJXzP4RjQUQSiTPu8ejH7hPrUMlAEZIf6gV0bvS47u0fvfn0Fwo7r4STH3byegElRreTe9+oc21jPt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:42.3835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1f1c22-c35d-46b2-86d9-08df44cdb619
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497

Set ib_device::adversarial_mode during capability init from
mlx5_is_adversarial(), so that every mlx5 device in a CC guest runs in
adversarial mode. The core then keeps the kernel ULPs off the device.

The mlx5_ib checks for adversarial mode, added by the next patches, read
this per-device field.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 65455aedd559..69e11c06bd9c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4770,6 +4770,7 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	}
 
 	dev->ib_dev.use_cq_dim = true;
+	dev->ib_dev.adversarial_mode = mlx5_is_adversarial(dev->mdev);
 
 	return 0;
 
-- 
2.18.1

