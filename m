Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013050.outbound.protection.outlook.com [40.93.196.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1103D4133;
	Fri, 17 Jul 2026 07:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274729; cv=fail; b=Fac8NWtOaxjoZQ8y/YGZfWyeextNox1qArx2rsHy4o0eLN7mINVhsThMirHheXOrlPD/yQT2NB2YNcJ+6p3c2iw4q/DafKKYjapZGJ1T2VnjINcI0qfGUQoCyWMhza7P7gzB/RwpiBJKWFkd5NIStOIxCkC7VL77ttPlJdNnEvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274729; c=relaxed/simple;
	bh=cpHRX9UYhOVjbntPjZyOBu3J1/1s/9fta4WveM3oul4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXpzQjAkkRsilWbopMrQ3IK6PB4J6FqoGFM40cTBA6F6z84BAFVCQCkO2uqJ4pDo5RhGnbumOncgmJPlJggkv8UworoSi93Ypo4LKrOI3ZoDmgWH6fTp2nDK3cwxwKcMmJrjx9rOS40PXvNYD/4uU8HRIglDgkfQhU9Kejb6Fas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eP0/7zCl; arc=fail smtp.client-ip=40.93.196.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eP0/7zCl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bsrHM5eOe2otiYqocrEcKWNUS4jxvubBO8o0oQPSO0V4gkVWEwp/EHbBJfcikIvl9/bQrdptoW8POLpuNwpIgHZ8sRa0kEl+Y0ed1DMCYB738d5z1Zs1BTEQvlpkXpsqb+9QEixFTT6m6SCvdy2SAEfoLiqUGTEar4OQxh8YHaSI7V9AaQiAfXnjfzrxqvnGKwxesWN2DBLXTuQMvNnhx7pRMnRSoXE874OlH9xARK54KevgxKfnOIHRlp366Xvh2cJUraWAvEgGo/czspgjC+hj6GBIhImsSUJ1upQyE7dvER6wtKNz/x3FXu9IQBgMY7Nzfc1Nhv5L+S2M1vFWOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxM4swEmkHPmTuIHwL+zrg3xk7u+1Ath+oyeyAYRk7I=;
 b=GKeVPc53zMALN+FCNhos/GEjZKZnqR7s6BrPZBAbJggK5nWbDYBCSH82aiTQqR9Q7WJGEZPrftC+3T1Tv2J87xbBkQuj0w9s3+o9Ug3bgp+nzHdQHRkqWOsSo9dvFdZsG17/RiILyUIKj2B97l6tQv6SbWuTXjTeR0SMOd0mXcu+PkE+3ijp8x/kKUmnYy8Fgrq/HkVdlQ66Q3ZSrbCZVpUynuW6kG5JT5YAjUFnR1yOYGX2fTjJpwTN8hgpq2+Nj1TyG773tP82Aj+22V/dA3xppkVgMByrzo0nN67c5dUAn47TSwX89pVOISfADtj18U0oyMpUKZn0/+T89tM0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxM4swEmkHPmTuIHwL+zrg3xk7u+1Ath+oyeyAYRk7I=;
 b=eP0/7zClpw+P6YgTtuc1YGLQaGmDEUn9VXy3/421YudXSOSE94U9moejZ/pvykhWbDI84G5h0Uknrb9MOrtcJJjXIXNcbrxsaRVsijUa7t1IgfEU3qeX/UK9pvHTCZIAxpukjUy2fEvejXKvWu26QbxudrzRJL/WPsRZewBhY/F5GtVmyMXCfTmNoe08oWOBa+IZ/G3bvN3UvC8nxbd2hHYXV5pFomXtuzX29sfyZ8q5mkXuKoWIrTqqpRdoTftM56stvY4SOuHbb+Z7CrDnbdyADjq8AaeQa+VFyPcSow6O94qHd32CqqVyZmYanD43q7W45kGMtEpAxql0tGdJeA==
Received: from BN9PR03CA0868.namprd03.prod.outlook.com (2603:10b6:408:13d::33)
 by DS0PR12MB6440.namprd12.prod.outlook.com (2603:10b6:8:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Fri, 17 Jul
 2026 07:52:01 +0000
Received: from BN3PEPF0000B06E.namprd21.prod.outlook.com
 (2603:10b6:408:13d:cafe::3b) by BN9PR03CA0868.outlook.office365.com
 (2603:10b6:408:13d::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.12 via Frontend Transport; Fri,
 17 Jul 2026 07:52:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B06E.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.3 via Frontend Transport; Fri, 17 Jul 2026 07:52:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Jul
 2026 00:51:52 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Jul 2026 00:51:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Jul 2026 00:51:48 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexei Lazar <alazar@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Pavan Chebbi
	<pavan.chebbi@broadcom.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net V2 2/2] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
Date: Fri, 17 Jul 2026 10:51:25 +0300
Message-ID: <20260717075125.1244877-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260717075125.1244877-1-tariqt@nvidia.com>
References: <20260717075125.1244877-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06E:EE_|DS0PR12MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 20744077-4bab-49fa-f700-08dee3d84911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|376014|82310400026|1800799024|6133799003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5rk/HuRHhefZxvjR4Z+5GhLy54deKmkCv5Dr6DwkfuOHuVhcL3d1TyhDYioe0E1hMhUaP9qrqoNAeGS2lRBJpjImenzQs43KNr4PfOyNPz5TjH09uhiqIRTcJDDVuRbi6LeCDb/LeZJcfkAbuArD/o6kRjpKQgcAO6dRHt+XteijsCKXxnzdhZ8Zypd+gDwhPyF0ZYjyRYGGVgWN6JxvA7kHVg19R9ESWPRYtSmLGYux4+qhORYPaCWBnZW734q15lYSUKUL8/fD2AqSdwYDH97JJ/6kT0e079dsLmR5iqsc4WNJEELwJAtyUv1hWkom6nLolMRqdjBmlXdxp3G/HpNSN/bPOBFFB3ufKxL/wRaV+lOa5ahIvFaKfarHJanbrcWhDpYQ6IRva7TWaX07HSJV+XSbQoDSlW1KROdVIM8eZCisZEFgizGl/5w+z8vjZHEhmYrEJjEloIKF1M98WUwRfof6S0V5jbTl11boEdjQgqreT04owuHAMSSTHFAyn50gA9LhCHkHVScFCW+DJvEx9nW1XTG3AzwMDk6dwmGUhA+CQ2+YF8tHKqM7WY4XmDWOmB16OjG04WnDTB2zjm1SscXEIxF70HwsHH+RGOrnl8v4D11Wil6oA8LaCltH/lWBvfzXIWRB3mqSi7zfdObwODerhntPMgp6UohUowN5TBRzqgHJQWgmxjZ7IkdaOguebMhrIk7WBZspyy8XtA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(376014)(82310400026)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NBpZEPXHm/I0d4fhgdF7EVnSR5lvW+TNw3NBCQABnAVMBKb25SZncmsFV0xAWrlpUqD4iZqz0gv6HGaTLgCLhVCC8O3KAxu8y4WwP6lVAvxPkKU2OYc19setJg9gQ3yb8mDhCQ7VA6ouCSHoGBW6u409xdREeNvXeYUMoPpvboTP5RPaN2JaCrWduI3Hu0G0ZWpHGUKgVz51hSg5E16Ka3bRUQjG1N7XZYAHE+CHx8gLxEhhJ5pRvIsccdXAz5zZ7Pf99yw8DgW9fE4BRIQK0cgvNzcPZYqRq5w0xOZ2Gn8pLuOTu5ltd/Y5o2NGZB3Q6jkxaKoWzb3d0fvDUOF9qVXsKdOYNETmDT59nZdxznyBI9UcdiX0XSSIAkdRc853ucvNBrSe1Yp8LjH5fzozGydvACCzhYM2d+yvqTk9qFFtbam3zr0cM+O7obNUhadZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 07:52:00.9589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20744077-4bab-49fa-f700-08dee3d84911
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6440

From: Alexei Lazar <alazar@nvidia.com>

Credit Based (CB) TSA is not supported by the mlx5 driver, so reject
any configurations that specify it.

Fixes: 08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 762f0a46c120..00e706e1ede1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -324,6 +324,14 @@ static int mlx5e_dbcnl_validate_ets(struct net_device *netdev,
 		}
 	}
 
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_CB_SHAPER) {
+			netdev_err(netdev,
+				   "Failed to validate ETS: CB Shaper is not supported\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* Validate Bandwidth Sum */
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		if (ets->tc_tsa[i] == IEEE_8021QAZ_TSA_ETS) {
-- 
2.44.0

