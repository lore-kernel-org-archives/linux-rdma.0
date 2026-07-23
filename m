Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE3F4322F9;
	Thu, 23 Jul 2026 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800510; cv=fail; b=MG9KqWm5ETQjC0k3SbYYfYSyQxkNNF5l45rMgOvuR0aeIVYU4Zy/0Xtk5cmhWp/Yf/POO/vlSP/+ncXmItEUIWYa9qoph6A6cI6UtM/lCHbUKAnZbOr8lNTHUXepAIfQRQTXhtbVBVjj4u7ayzSqIn8rWHN/nmylYIAV/eXETGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800510; c=relaxed/simple;
	bh=FJTS/B7R95jR5UHIsdsptKHQRMtpQG2tDbFLwhGKZHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNZkUmaxMC5vJFh6WDurngowm/CllEC0VMKLXyXHioaQ6OWXTL2xsYMp8cCfOIZI7DEIbYy5AITjTGisXnrVv8J8FBSRn4sTz2Jc0OuolOSLOsoq+GlgNpoZFQG9yUyz7izUcnpEae+JIFP57AVa8NZp1uNjA+8jaIXO3HhooUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WswOrRH8; arc=fail smtp.client-ip=40.107.200.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WswOrRH8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvERqhXtlJClkQ2F8vB0VlArG/BzdGih/xGdf9kfhAmEZwyq7Rz3IK6VKMuDIN7pbhgLn0vds3mOxnO4Dsa8reHjnU8KxMp3ARUzOYMa1/C3mbaL3sPzzU7zfITDIm8YYqfqDDRJPCnjrDU7u3MdkI/5WDk/L+OHWgodGOEz5HwAeo+lCgCnO3bOQp+EefWuMQA0tSFDJEMfczixKvqynEv9md9y+0SLMkSV7op78coKnXderC1m3dx0xwdm5oN7NMp+HibEmuuAlGNeK+Z6rd3ap6Svy3n2WanykVWlbrCrKHBaK2UVKilLUQtFln9YEaIcXDajmoRNsO1FztNKgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jgfT/ZE9xqPDL60vfhbKjiojprsy9cdxhR2JdmPyns=;
 b=XaCWfzIRNUHNKIDN/uXvoB0S/gZ/FU2iUiQ/IreIpONEPT3lbVl/nKLBMJ57LI9DSqcVccHtwye7zbbTEV5M+pVB/E6ksNJN+wkw7Qi7Q72jDgWJGAEjdFSe0ypxmjpLRlbUf7O8dH+DbLyk8wRu9exdS8MKNQ3hEdTDM1+4a84T+GlwXFU58uXrL6qVECaYf5rar1JssxUmb6EOFq5xOXTG3rMHEeLyjN5ZuaE+7qLdQtYkwCpqCRw+kmMGUK5I/M7xVFNU20hJQeuAq6PWxQ/k1BcQaezLfeef3NQ1GRmtyxptWR24Mr1t0F8MgwSGOV0g/muzWw65tVsbZ2mrYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jgfT/ZE9xqPDL60vfhbKjiojprsy9cdxhR2JdmPyns=;
 b=WswOrRH8AF6Tv9i80LBKx5Z2c5dQNMDoAbC3SCLIUllboXoavRTg4uLnHgesDJcAX36/mUQGh/iexTnJDwVxNElP5uSXOrcb5HWlEh+4ppxxx/PXXSvid4kppztVwIbIn/YZZ7Rt33FKVKw6FJWHjq9Aw8+Gers70h7/BPsoJ1ZncUaUV7ya4vMB4R36p0TJdGD+Br87feVcJIUtYOIvIElMQGHRV5+7TsPXacB3LvkZFCWlFMgs4P1QaqZz0gRuH9CZidR+YV9Ns8gZ2gK8XUB4BkeQ783Ytn9NMik/YswH9zPBlE0BZmjMsOEYXI1qDHI6QtWO6NBYP6h2A9ev0w==
Received: from BL1P221CA0032.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::11)
 by MW6PR12MB8835.namprd12.prod.outlook.com (2603:10b6:303:240::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Thu, 23 Jul
 2026 09:55:04 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:208:5b5:cafe::71) by BL1P221CA0032.outlook.office365.com
 (2603:10b6:208:5b5::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 09:55:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:55:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 02:54:48 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:41 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 5/5] net/mlx5: HWS, Remove redundant FW command when reading caps
Date: Thu, 23 Jul 2026 12:53:49 +0300
Message-ID: <20260723095349.1890983-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723095349.1890983-1-tariqt@nvidia.com>
References: <20260723095349.1890983-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|MW6PR12MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: e33c0056-9c5b-4c06-8e8e-08dee8a077cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700016|23010399003|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	jJbA8iZ0zjQnLalT2YGm6PRV+kTN7F8yIC0C6bBGlO7uIoprrcPXiTqWVPEmkN5ZNMjKRkbIU+YA50hyLJ4bhs7LVeMkc8eks+zL47i/9L0eckmg2JLt6bLyF8Rp3ugiZPlWhjdfv/ZdnfDnMXiSMsI6f6dDs+MJdBbH+Bh5I8xxpJ4+992+6Z52P5AznMNSFbQybZzpBxw7apjJYHZHz6qc89yexbi/Aj2MYsL5idVXGfOUyH/s6W60tQXHyAqxZMN1Btxrvf+AZZibM2b5d4p4/O5wEFtZRPO/PqHsog0c3okrjQcdgQvj3mFR7JzVxVicIAjd5ZCjlHy98TA8+lAJ245BB2ZxSXOi4dnHZ6g/YC9qf3YUJ+yoElg9uC4a5s1UtXDiONE8/O8NYHL7xd4MxriKdjgdAzIfpGcsGkH7rP+P0g43H7386/Jstwnj5PYYm7Urhq5vwXOtq3oB8TQ/VAiG8JvVR5+bmx2/y01ymhpTgqEbTvH0DI97BPSe7TXwJmNmUUJJtIMHkgOvNFZhDdCGyB05Jd77lkh+sIiRFwbQVJHXyxnsXNLrCUlG41yQErrbYc77D/uxWrnhl4YZBFa9nwyTMROu0Lnkt3WX/RSzIZpUnudRXY15UNb7rCeyE0x4U79nFJo+V1mzHKg0NWmVns0lmkkacTIpQYHogS+l5u94UXgH3sjb19jRLAqkGKXLY/c9SSj5+zw6bQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700016)(23010399003)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	//uWMbYen64uCyIvaFoG5QNrUF0T8t5dAFVgNqKFK22YQ+XEQJcIJrCA3GhvzKSWpWMyiLnR9RD/hNssYccn+Rr83WnD4/GnCQsCn0ubUVZ8YvalU9BstpfbvZndgJVObLheqom73rQqrS96cLAqx2MKqO/NpZRS+WCYphykxXIvrFC2y48dp/F9yhxSKJloNz3mHhBWj6+y76kJeQaHumxD3OUDe4SnNQI95dqmPwgWjyl4lXG96bCgiPZOgbOCP7iFcqqXmBXQOi8QC7g9iMTjU2tclJP/11oKAXcxgWMPUSoJP9CR/SOjmmDfeQG8AoOA/6LdHtQe8W9CB0MugnEcPj7jG7KoWTrET0e11QqcGqyd7x/08ejtTM2krNTfiDuG6kJLBFHIOd+4z6sD5Str+f+FEn7bY9nXZniUG8Zd7XdMzE00d7m3m4zB/jxS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:55:03.3762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e33c0056-9c5b-4c06-8e8e-08dee8a077cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8835

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove redundant FW query that isn't really in use.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index c645b7e4bd98..afe5818294d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -1182,12 +1182,6 @@ int mlx5hws_cmd_query_caps(struct mlx5_core_dev *mdev,
 						capability.esw_cap.merged_eswitch);
 	}
 
-	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, out_size);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed to query device attributes\n");
-		goto out;
-	}
-
 	snprintf(caps->fw_ver, sizeof(caps->fw_ver), "%d.%d.%d",
 		 fw_rev_maj(mdev), fw_rev_min(mdev), fw_rev_sub(mdev));
 
-- 
2.44.0

