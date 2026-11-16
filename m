Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825080;
	b=dMVxhabf6AV27QYlRW8KL9B61mOai4Xu/yrD/OB/qKOVypWlIIrKtWTnJkcwZtznbDG+
	 bVhuDyCo+TrXMV0q8SevKa1JQKHAoKgQmFmiPCqIcF/5PkC2TKZpLxLCe3ljZe8uhHsU5
	 PEHO3KtRur1VDL+UObFevx0r0posgBU8Z192LYV/dQx8VMDdK0mNp3x68bNlAB+rFxPX4
	 kVUxQ7Xpu9R18vsl3Ei8QpIC+EXI+7l9/rc9mY4zgprahQFJ4/EfGZQJ+AgyEGmytfaaP
	 mCxxrFGz7ALQHEQLuO4ggpUI7aHARe7GL+FpzwBAltmXZaFLNU4Ocx+Nh8fEsiv+pkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825080;
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
	bh=51Aj5/AFU8mbDHdQILhwkB1NZw5LsuGMjgqzqjhIGBQ=;
	b=z04SnzzrbDCX7cVulWdEbQ1rP+pMbFjv78agiG0uyjtCqe9fO9xMjBWzvrVBskWrEHz2
	 edm1Bhr9IaQcDmMwur5pQKcXS3wKJ9wpyOpvmwDxTK6dSYYG6ied2y5O611PNhnyy7N+C
	 GzK66YuTqvRSq0E03/nFEe9SsPxm0t7Qi3Qx9gWNRyD3RxM2S794i7ubWBPnGR+vIHGbe
	 OOL47HVw2XJ14HiEqnG9d9ziyVyAFJ6I/o/pONTNO1eIPwmlBpJ0GRv3b5neNBVN3PDPt
	 0eVWk3TTax2l30Gry5WL3gn2VxkLYWt7KUVG/eoCXXzesHFIie6/84tScut1q/JR2tA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pf1KPXjF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.39
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874E7606A31C;
	Mon, 16 Nov 2026 10:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 874E7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pf1KPXjF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VyFCj4D4RI4ewoi15SLy8RXTpKktFDTUpN+lFzDVrF4NTk5uv3tSk8eruT6e6U60qMn8aY/mfUnarCJUhQHek5UxYNxRxhhIlnbndT5Bgl7x8ML3z7DBSAFnovr9XcMcIhqFWMvUgcwBiW2dEw8GSov758rvaGm2DvBwOy7HXd/QCva3sRaz19nOETYnskbJneWML9gt9c55WpWGGlS+kqaC0xp4HdEkln8udaUMDoJQbwuASwe5u+7hcOjLdxf84IIcRUKc9oIvca+9GLtMuS25Bm2aS+Uu3gfXh6tdSxl00GB0JIqWQUt1c+3ns7nzEYUaIKdc1awNJ4kTX2hfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51Aj5/AFU8mbDHdQILhwkB1NZw5LsuGMjgqzqjhIGBQ=;
 b=veio6QeDEng28M3U3nNRfzQ0VFrbhW/LUFbE8OZWFC8jNVeElBO6DIpLkbG/eP3ETrY1F/pwyi0e27EZ2a7OlEkejDw8HSHmw8u0iZEpfpXiqGoNI93CrOS+f8gGoE+MTCgFDWYSkkd2TnckgQRMrvPNUGV+ksH+NARXRA7c580BCdGjY9TG1VSsdw121VkmcVqsQfDn1+npOG4L+P3d2kxk2qJVc3d8Y1qKecTJ45te3XRtK3+dNF9Y8A5Ow+m+8WgzVx6upwT5XAp4MtfQNTKaF16HtK2XTohUZJhfig9n4FNedMAmEfwM1vtUPWBUzV2QAC3NaubpI4kv+Hb3Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51Aj5/AFU8mbDHdQILhwkB1NZw5LsuGMjgqzqjhIGBQ=;
 b=pf1KPXjFSks9bNK4u7/X16wAJ3QxsdXfd5eazoYBuaKtdELg4Lf+Jxij0zTbZNyQHDw1lT6zKbhX3KM6pF3en622lqgPV48qteRVcVMe10W/uDv7f/tNhlAfRo/oxsDuB6nteF3U4GjAXFZxi7AkhZLu5hy6NXspzPSdKOGPzjkWefYnML9lBdOZq2AxlBu2QzH+YLCskmzX74Ei34rYB2GV0xvm0ugBPXgHel/BK8m/gLHO0Dxh1+3QZY/Q4bZQ41ne3iKkSGzpLzU3e9kr+TIRL+ILkpYzVwpfdz/dvLfxA/nFhWs9a6fBkdGouHL65jgUTfO/6OrWcBI/GNCvgg==
Received: from DS1P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:454::18) by
 DM4PR12MB6421.namprd12.prod.outlook.com (2603:10b6:8:b7::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.10; Mon, 16 Nov 2026 10:31:14 +0000
Received: from CY8PEPF0000005E.namprd21.prod.outlook.com
 (2603:10b6:8:454:cafe::8d) by DS1P222CA0005.outlook.office365.com
 (2603:10b6:8:454::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 10:31:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF0000005E.mail.protection.outlook.com (10.167.247.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:30:58 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 16 Nov 2026 02:30:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:30:53 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 03/10] net/mlx5: LAG, skip phys LAG prerequisites for a virt LAG
Date: Mon, 16 Nov 2026 12:30:03 +0200
Message-ID: <20261116103010.1129666-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005E:EE_|DM4PR12MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a35b3b-624b-4ec2-3682-08df43ccbd79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dMVkpgAdBBVzPFb+7v4n822Rqo4f3hoqNAExIhMoc854dgFAubYmrfr07idbLAypnXcOwAKPGvQQdEn8CNOQbLflMAio3BgWh+XQjlncfXq3X50MOtrS/1qdDPlKgXP7Wmg0AbejOirbWnuPwhVUXIgR5TnVP6EPs1kSK6OZleobV1IJi8UxM0JeNPwIeQ/QoZ94ZCXLl5p1HlEIq6nNC59n9DAxCfFsnHRwHEW+7tqzWuI+gyZp41t90Ii8wCymgP0dP4Ny8URUB8v2J8FkBG+VITBzcez4UscKT5uF5H375n3Ik7vOTHsGYT9kr9MjU2ym7OmQAebJXxpgNzlWj0+BBmqkDQZ4uCfE3v68890LNGmpPwSOwCKMMisEE5MSDEZWUjL0VRNaN9ika5dYfrrBW9YM3N8Fi8hrOUPCddl4YXD2bE1XZvmcVm1c+DfMrRuHvH9lEDedCeEhHPkz8wMBVIxE6pNuQSq8QsCntFatNfYDJ+sMtHmZPDOWZ+KfU7XxZcWGPzmYv3LQRovzMetDjzxe2/7uGfapQUjAYT9CmmscTuyscPxTogGtrPDd6z2ksuW5ghF0LdAXy/6hkz9uyz7SEOqs4uvRU4Q2LJURHnRP1QBHEBDQqq0ZFXmqZfcDMSNmKlLQCG1IGEGdWetuzgC1jGjCVuB1G6GYSCclQ/D7nuo69m9BuzUJvwkam1aPGyUb0WpO6QGDYwljLg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/Uvjb7f9AcpstbfHP+6sm9hp2mGRvZ5ZtXzYRTZy3WBa4gJY2VRPonPqgdIkuUxm+vYrB99/ROWrNadHdxAlm+2VP98rPIQUW1oKnlOynxpKKhYvuo3yTaHZJmea8hqoz80NEqBTfPZ1oTZigkE+chlTtuN9lX2uj+pWhA2zgpV3My85ZpI/YvVGtqRWPC/gLUhc8AY9KByRp9KDvmkTtU8tepa25hgNQAVNeg9AhhqrYTKOpmU51dF6Bn1IcRIJ8io0XLBAZWtDgev2HnJbnKSR/5W5yDKtkXGBvZSMx502gUYHFSRvrOjwCt5KvNEDtYqvxf3qMr4u6A/iz+5adP5jeFfCHSmaFCRKmp1e5UOqk79QIXydVwciSPXNfzeME+QRUUCV0xMHV5xKBkU0fkWesSVXdYvcRK2K05POCrJiuOkCb9+MAySPw6U+imJD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:13.9880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a35b3b-624b-4ec2-3682-08df43ccbd79
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6421

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_enable_mpesw() gates on port_select_flow_table and
create_lag_when_not_master_up, and on mlx5_lag_check_prereq(). Those
describe the phys LAG: the port-selection flow table and the
physical-LAG prerequisites (e.g. member count equal to the physical port
count).

A LAG of VFs/SFs still issues the same CREATE_LAG command in MPESW mode
from its master. Issued by a VF/SF, though, the command has different
semantics: it does not create a LAG of physical ports, so these checks
do not apply and would reject it outright. Require them only when it is
a phys LAG; a LAG of VFs/SFs instead requires port_select_eswitch.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 0bf5b4754a44..fd70fbebb1de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -107,9 +107,32 @@ static bool mlx5_lag_has_sd_group(struct mlx5_lag *ldev)
 	return false;
 }
 
+static bool mlx5_phys_mpesw_validate(struct mlx5_lag *ldev,
+				     struct mlx5_core_dev *dev0)
+{
+	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
+	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
+	    !mlx5_lag_check_prereq(ldev) ||
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
+		return false;
+	return true;
+}
+
+static bool mlx5_virt_mpesw_validate(struct mlx5_lag *ldev,
+				     struct mlx5_core_dev *dev0)
+{
+	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_eswitch) ||
+	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL))
+		return false;
+	return true;
+}
+
 static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0;
+	bool valid;
 	int idx;
 	int err;
 
@@ -133,11 +156,9 @@ static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 	}
 
 	dev0 = mlx5_lag_pf(ldev, idx)->dev;
-	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
-	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
-	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
-	    !mlx5_lag_check_prereq(ldev) ||
-	    !mlx5_lag_shared_fdb_supported_filter(ldev, MLX5_LAG_FILTER_ALL)) {
+	valid = ldev->virt_lag ? mlx5_virt_mpesw_validate(ldev, dev0) :
+		mlx5_phys_mpesw_validate(ldev, dev0);
+	if (!valid) {
 		err = -EOPNOTSUPP;
 		goto err_clear_master;
 	}
-- 
2.44.0

