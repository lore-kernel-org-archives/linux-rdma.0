Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724187;
	b=yg35bo1e6SEADmuwKBcQiPXZkkEwI6KZacLxRHFeQ6i6+V73ThtvAPP71rUIW06R3FrF
	 RSQRJl1pxYD8d//clv8+PW8e0DRWRZEzdKLjfXt52r0TgZi8MUl9jjhMYdjHAggMprfCr
	 e4lP3RErrOn9zZXsq5Yxv3r/RWWPEJ6nxBWqIPmDu/g0vVHRWPuyGqh1hW2UM+tBzw7jg
	 aOSE4snS4AupvJDdk+vH5ljGOejtNBLY0utDrXOguGnZIlygPBVew/Q7BF71EkxOM/dse
	 6Uq69EoogIWftkYpWALEG8aDHCxmZKeyqSOpsgn+bZKSb207zFT1/ptOmSnDJcs3Atg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724187;
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
	bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
	b=B/1w5WnHg133YuwC5y9y/2PtvK60V/165SlnqiGpz7VLn8mvMmPUBaMPJVMj5R3GYbut
	 iRPNMNTRjCZx8CfMxuq6VHhXkrxMTAK2NATM3GqziEEYRWb8/R72ZF8cCQxWRlnwRIf0x
	 bbtXTlFjsUQoPuWCBtQGVLGn4CEvPl7DhS1G9bxA/kqPsJ1TsdmyoYEQF1eAYGb+pbI3S
	 IYG46mxXJUMim7+g5ULU+Dk7uEcoBDq30wsjkF6WeOpF1LFkrbVjaMvO8kSxOUAeKKeVH
	 2poewWKxpi3LFOT+ShxcEiacYPlQeYzIhFYQ5pFKdmnoJy/frEeL93CfWHC0gid4JwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=U+TDMYJx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.46
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB1606D82F;
	Tue,  3 Nov 2026 16:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BDB1606D82F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=U+TDMYJx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eedRLJsENV6U8nE78WR8PXcf2z2b1SxXzsWcE4ocXk8Ad9TQ9XaH55F6axO2HpshFfUbykmPwLpXbCNy9xTuLKWa+8b+wxYyO9j2s10xEYZL5wEIFqt5kRmPxB8/vI5YDu6n9J15UJlqj5e6A0pme+VQKF5mII2Lrswuh7L+zuCUQ65tqXnM+SnJiqkiSMi6/1Ff7cHGkh8SCHYb2nEbkm4wqc//NBCYZYBnKK4j7PXfqhvug225cJSSd+86fB9jwBAzFotT3lYgohuXmkPRqDtqdEwKAqeNQ/N56vcrnHNPqB4bGL8c55WXgyt0SnjuiEEtLFasJA2Dx/wpt2GNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
 b=VNgQd9u2vYoedhs1Pi94niecb/m7OLace6Y2BPiXw9G1DsMfgTTDgPC61fkDWFvgdiRiTqOHnqGgZUjdFdRgaq5DBtSMjcMMqEvwEC13NxRJdwmGUsO4wjoE3YSPCkl9UwCpQFP1Q65YUpkvgEtNr+40pJuN7R4vy+CEP6TfVP/jt6pZPsOibxLoGhpo/fN2YlRvy4SbXEOkaV37pL2LSClLyP9VCW4Cw2/EzAkC0pHzPr6mjXi+W6wCjOMSPvZJvv5fCUu95SpsNxKbfKS34bfG7+sR5MK+bKYyJmfanMCWgnfpZslzxw4EtdtXUVVD2kYl/dJTffRHMtBo0pQDzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RU4Uffwdzx4hHi86QC03U+wUmKtadevXp33b2fxzQk=;
 b=U+TDMYJxfFh45mqq1PcA/xqz64z4MZSMM/LdgT2mmhqjvj8qKjXiQL8CKJ2mFtA5p2bykuJWSwg+hPhWiFtem1nfNJbPDVihZxWuw7Vp+RyacLEC6p451Gt/l8NPbmSztZAWb0VbHJij2T9qsFss2Q5jubHjkHVom+kq+zbZh6PE4+9Y4VGHkp8XRa6Qth+1SFyInJMEQLRJKIG4/dfufuB+DxKohrL1eEmNo0t1JDCAXb2ZA9glzDDzz/bNTtNgPuag9pHxK1d3tOGH5eLSUpXIzHIyiHGv8goe9Ey6pvct/bM5uK6NMxMO5YvALleVOLV6fxY1WUHh5WEINiMIsg==
Received: from SJ0PR13CA0106.namprd13.prod.outlook.com (2603:10b6:a03:2c5::21)
 by IA1PR12MB9523.namprd12.prod.outlook.com (2603:10b6:208:595::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:40:57 +0000
Received: from SJ1PEPF000037AE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::70) by SJ0PR13CA0106.outlook.office365.com
 (2603:10b6:a03:2c5::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:40:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AE.mail.protection.outlook.com (10.167.244.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:40:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:32 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:31 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:27 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 02/23] net/mlx5: Derive adversarial mode from CC guest memory encryption
Date: Tue, 3 Nov 2026 18:39:28 +0200
Message-ID: <20261103163949.1554-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AE:EE_|IA1PR12MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 53de2408-5853-4b11-40e4-08df39c93c4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261102130727099003|261009223027099003|261022105027099003|261028144727099003|261021135927099003|261021121427099003|261022075727099003|5023799004|11063799006|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	IeWBP/ro3D9a2c6Xis7Uf+qwySqh8Y2g/C8a+/n1QT4PddMBPJhpSgP5nqeSd5+jniU/4L7lLS7d6dIJFbaMn6aiUIHwvodeWJ/3qGRlNTpsM/ZfbIdUZwVbDGiSU2CVp15sg79Mp6OE9syAh6ZTSdCYBLQtKJ+y2cyvO2t0Cn9Xzid0kCJhLWL47N5kVnEOt9OB7k4oxX8QgD+nMsT+8XYkP31pHRq2SS5scMGx3iBCb9U9IvhMDtzMTetLnOJJcOCRJQtFVb2kta0YIu3YVg9Gld01C8iiuWuJpMR4iLVUfUQFIQDMI70GXZwlmboDlRetWX0waXOXX4vMMpDf2mPjpdmlCzI4SULI1ntCLzxxjrnOL5SWSE1PjwQYcEFHdhMIdAz4e+np9Jn7eO0bKs+c5sCsV8a0r1QUuuwqpUsseRB3X9yNQGoVyuaj58XEeMFLScfQvH6d4wEUAcQ4tF/ivA30lgthYcz4MUIFH4U4ne7yDHGZDfGCd0e1HQ5r2bwKRcChgrhl5dvXqJ6xlIJ1Suqx+ZzmmGQKTQ9nqRjxI5f9MEB3Q1TXFBmTL5TpNcgkFtKri7d7vwt3a2P/9HvyJ9/HVSXfVxxMV5Ezz3mE5+UrP8Z4wFX5I4nV2IuTaCpw9pMM/8MHYvc16ezJDdSydgPPwaIk7mtcFjm1DPHvYrmkzKk4gN3pWqLVqBLGIMQ7UJ9riO4Z8Hf0ny7/gg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261102130727099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021135927099003)(261021121427099003)(261022075727099003)(5023799004)(11063799006)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rXyT/7xwzp9NuavyZzKorMrvA95HEuKhFnGQfA4G8ybcl4HZsr+XfRpt0deEbo11rwpcInRvNlwg6cuZI7lGGI4nEmvcmCL+PCw/vZMpALyxr3tDpWKVyUgYUGpDpxuAISAzYLXaZgjQ1LN7jVLHt6GJM7drNW6ZOl+SecFQmvK0MunSvAYzQhpiustGpeYJjoqlnSWFU8uxtziWSmw85eBXUcP1/9Fr3DaZj8EtpP+sOVrWl+QVUgP0SI7c8iIetqtvkO1bLkunt0/FNX6N2kufCtepp+bZpYiX3zuAvn6qqQDwOk8W9/hWWefsqqQzcNqu+Ig4ectHujzlHlekS4xe3kDFeIY/Kn6M3CpfDZ6EAuTJVO2V/kVWAK8M1bqUzXkpJz89icMEF7KdC9HsgnVoIcI1eWdW6tvmzHWCOgTxJ4/AgX1yNvtNE2R6rOUv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:40:57.1482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53de2408-5853-4b11-40e4-08df39c93c4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9523

Add mlx5_is_adversarial() to report whether the driver treats the NIC
as untrusted. In a confidential computing guest, the hypervisor and any
passthrough device are outside the guest's trust boundary, so the mode
is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).

This turns adversarial mode on automatically in such guests, without
any administrator configuration.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++++++
 include/linux/mlx5/driver.h                    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..f9e10464a71b 100644
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
 
+bool mlx5_is_adversarial(void)
+{
+	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
+}
+EXPORT_SYMBOL_GPL(mlx5_is_adversarial);
+
 static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	bool do_set = false;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a1275e6aa6c1..3d3bc16e581d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1328,6 +1328,7 @@ enum {
 };
 
 bool mlx5_is_roce_on(struct mlx5_core_dev *dev);
+bool mlx5_is_adversarial(void);
 
 static inline bool mlx5_get_roce_state(struct mlx5_core_dev *dev)
 {
-- 
2.18.1

