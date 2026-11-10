Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318274;
	b=OPcjAc9/PaquwrlEAgVbhxcR0BxLpwYaalW8MrDg1/tUEHye/xrUAegtaz8ejV5A+7Z+
	 dy1NemfLvVJUfPZM9I8HGMGyVxxTSqjpTML+DHMvOuN6WAglB5lUj3IvjUAK69zQTHjNv
	 eMc7LdJ+Sjy18b2/4Kmno8AMZZO4T/xIhh0CZ5A7rsNXB8bAM2+cWI+h4xUSU4cswe03K
	 oK1HSxnSKALLzjl4cd1AUB6lDNf8quBa/4jH/3fALr+nqPkNMIQIzxvE11Z78slbAWz0p
	 5DGn8jKAkA87Wk0sF7lp3Y2pfvWCIAz+7HGP+pcEesFY1SlmTn3iUxOol66vC/EXLsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318274;
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
	bh=7N34hi640H3FhTNl86qHuhDmQH5jp0pzWYIsJi2T0vA=;
	b=buQVVC5oxHaC9i2ryqDjpWOAvwVMAjpdv7u2nGv0ZHqiHkfNJk9teXb83Ans1RixUTMi
	 bxQD0lgATVuFjoLQOjThURvAPNYGhI6YEerIgdhADny5DRIIbrvhPD2FJaks0qWj1D9XC
	 s6k9doqxmgxRIFYzB7oY/H8WDm+47+4VCemGX9S9EjVeakRIrP9/qRoCQ3lSIuiVfFhOQ
	 4hejARHW+tZT3ME5ZK5htvKRaKygaM4WbI2D9WVFtdWQu4X7Cu0jxqpdQWMC9pA3JykCp
	 8r0QWp3BK8Mi4458Wfn/FlqlFXCKh4rCkisPLAhb4g8ejWjTw3BvASRRNJjbgn8gawg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HCyX9E7a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.71
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC1160A2614;
	Tue, 10 Nov 2026 13:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFC1160A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HCyX9E7a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWKqj1Yg0E5381Cw3zSWBCkXnk/Z28Zq0/4UMPuNF64QhO/GTwvbyfrrCEwrtOvKoazlAX/jYbcZ0KzJO5YWx4ovq243WpwUyab0qNcQnhLfo4RmIhGFWZFtmIhU7Ubxa5Uw+DsLW3HXX/WRIur7SAfSmBwlijg6xb9Vx2NI7nxlJrrEIHyKmHFERxf1khwKYAU5UE/yuK/92wV2Wf9EgqJHHngk//PYj1kPsLoQu1NLx5tOkXV4gLLS46TVttJ+hQmFN5Rg2Ebrz/emHkYa/PkBG8zmH9HZUt7+K4V7eX/eGZX305x/tS9+kLyNKOlYuCmG/r5m1ESLK7AJytj5wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7N34hi640H3FhTNl86qHuhDmQH5jp0pzWYIsJi2T0vA=;
 b=maKS8oul353GvgIth68t1dX1SALHOvyIU0SCOkbc9AI5NOMlCjiu/wcdBbjCEx4v4DWiLguNwIyejzsRJS7c7itz46oTZ44JQZIoa6dRSZamKPiHqM56x5IzmrEoyCge1/cBwsAcFAu9isdVZjEWgCuU5ryEhlOJH9hM5rXe6jTEbCqCZbq/9Gyzzb0O98yne0AHFlSP4E2WwSKJ70rzlTuSGn95RQdTxOfL9NGgy9TkMTbvj5IaCBCp+qO788Hasb7SuEkI4sx/og5sedv5OE+BUviiJ5VOg8yZ2UAd19NAV101mGXIXpSdjToj+RKqfxwGuSKzwIwVdxrajsnrww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7N34hi640H3FhTNl86qHuhDmQH5jp0pzWYIsJi2T0vA=;
 b=HCyX9E7aumo1UmmpozJLHhD4o3Fv1X/K4QngzTulqFxj/Jagg1nqyF4h9nuPNM6wbrRtMuGDAIEod/ddjhsjwKOVnTnK9EAbA5pRpVA8h4JpSfCukXcsty6F8NtVRjOdAQA0d0L1KN4y+pEmbbHFYGPqDIvwtrNqac0FdLJwXaDRZzC3ccZvH2sT6Vg0OaeXFyvjM4G2ytnHPitF/qHQy6tuV5YB8iNsrXEs3S5PQOI7Fbaoz9hFyEUyI8DySKIP+G/tygmUtpyTdTrT62kJ7f1JS2tDsYZHZEmk1Akht3oVv+BsJ644MiOdQ0fKXCPQoix7BgbtWnElAlXJGb51Bw==
Received: from PH7P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::21)
 by CH1PR12MB9696.namprd12.prod.outlook.com (2603:10b6:610:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:28 +0000
Received: from CY4PEPF000392D6.namprd03.prod.outlook.com
 (2603:10b6:510:326:cafe::4e) by PH7P220CA0029.outlook.office365.com
 (2603:10b6:510:326::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D6.mail.protection.outlook.com (10.167.247.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:08 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 04/24] net/mlx5: Catch too low max number of EQs
Date: Tue, 10 Nov 2026 15:43:00 +0200
Message-ID: <20261110134320.34408-5-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D6:EE_|CH1PR12MB9696:EE_
X-MS-Office365-Filtering-Correlation-Id: b69fdc8c-d969-405d-10f0-08df3f30bd60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|56012099006|11063799006|22082099003|18002099003|10067099003|261009223027099003|261102123227099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	F1uel2kpvgvP1TWs2G75YME7Hmz/lpAA/EjOJIh3E9Dsm9KlblgwsFUH82r7x3AI2rftpuS3d4nFK9KT+D/Z1AFK7jmMKPEzC0LJ/SXCpSbjbKMPZgnVNFYRsGESNCJBh5tHlsXyNT2ld3R1+/WuwV49mmiMaKQd4RxvFSLvPNhr9yqMbgJn6nfvsnCbULQ3kJmhkSZEajZKpo6opf/uyQ2gvoHWJfgHVHkFhhnyYRSsySGlbPJjUZFjhsss9T0PQ+/edyx8RThpOKmwHb5vtiklDKkxTXpeEZOiVboZSryR3JN5/d3VGGMrBDivHodRSwY9f5YJkvAnHhFQOUTWqtSGwD0Iz9W7kKyP2F73clDKf/PBrIiVaYGc1Co5rEogJnD8wwAm/znndYVGH9HrtYnHObzCmoLB6WDqnmcetwdNnTSt5gjWyfhVwY+oiun13qk/WaCjYaBWD4vwaumoYmMdIz6qkRY5pu3++cPozZXKgnNsSoVciRu47nCuU4QzWzSC5SaiQU8dYiYPIgao0ivdEfbutsicerLJaxJDLWmGAT5OX8lLzsc/Tm1uP+K+xE2wNuF3/v+jTU+U9aFby/bmODTx42Dlw9posjWX0D0iU7UjitnVGH99FG7wV876pLB8VvMUaLi1LN3tQl9DoGWpVGPf46QALHVi/XG871QpmXUxwuzypFZnxp/JiRfTX5dssIUwK2kQOddbo5tT6Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(56012099006)(11063799006)(22082099003)(18002099003)(10067099003)(261009223027099003)(261102123227099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W3vDwRsOxkU0990ba6FK2fL/+ZaCrvL7DiSuSSwKLBzTCt7kN3PdQP1F6aDQYgwHm8iP82e8Qv7ZL9fGH336l1LDS2Hs9w1Jj/amwyQHAC5zwcwLpF0M9hiBNqBvhffQ+D6+dZhxEbwyf7XUiczxWYwGrACUcVIPLxL9NGKmx0tIFwbaQ5T/jxli/w5hOuMmqFSfb2fsurTtjMfF86rKeVlF+CFIqByNJd1fhzss91dK5eqELDI6ouSfc74iGXd/60jwIo+yI55FF+lncuhmBydiiHiISBixxErbfzIb0q28w7pRCN4TXmu3SR6UI2l4xvzOMy0ANW/uqaUddBI3RbtGKwhgaP29tADkdtM44BNMJMeQUCypBaJk1+nTe9r2I4GIWKk18rEbGj22Ytq6BeHzkSgMk5KT/frQZUPrtNczM58nCwLL3oYIDov4Fjvs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:27.6731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b69fdc8c-d969-405d-10f0-08df3f30bd60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9696

From: Dragos Tatulea <dtatulea@nvidia.com>

get_num_eqs() can return a <= 0 value when an adversarial FW reports
such a value of EQs <= MLX5_MAX_ASYNC_EQS. Return an error in this case.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index d11ec263d53c..acef6cd36018 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1195,9 +1195,13 @@ static int get_num_eqs(struct mlx5_core_dev *dev)
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-	int err;
+	int err, num_eqs;
+
+	num_eqs = get_num_eqs(dev);
+	if (num_eqs <= 0)
+		return -EINVAL;
 
-	eq_table->max_comp_eqs = get_num_eqs(dev);
+	eq_table->max_comp_eqs = num_eqs;
 	err = create_async_eqs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to create async EQs\n");
-- 
2.18.1

