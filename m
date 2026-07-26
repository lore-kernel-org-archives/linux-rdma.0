Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3637E5D9;
	Sun, 26 Jul 2026 09:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785056996; cv=fail; b=I18KzzGdEADA7s7UrRjLZLRb8TcdYHdNg9+BhnIXvkgY/5GxaHSBI/gycrZ5c37p5nSW6Ex1A8p4gPiQTLDDDibAgcdOKXKLRy5Ipm/b/cDojvDdP66hT9bywbiFklr9hQyUi3O4i0NjDw9AZrXlsjLNaZ9hN6H1N2lni+7Zsco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785056996; c=relaxed/simple;
	bh=kz4t9BnKnbBcCMHaMiPkA95BnHN5Q4Hu2KQ36u5No54=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=AUBhNWJ4UxSZlbBcVDotIvbMr2BKmnqjEG3Kg+kpu50H3BrPv+shzYrUUUBruqiYwj6UAoeiEkUFsYG9nYGg91Tzzc2Gr3846LyjgfA1tunEU7RBix9bDzbY54o1zRVz3u1IMWPbr5WxTtFuPLzE5zTtGScXX/XelalaUfXHNhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q5l5qfj0; arc=fail smtp.client-ip=52.101.62.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q5l5qfj0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XU1D06GQKk3eRcP7acccOK+lWapsmrAOvych7zXrfYrvTKP17njdHXuNrz+IszYR2ij8OjokD2PYvx59h2eat7gBFJozEtWO3IVExrHMRXxz4FbzC0ETzCSgxIKtySSS9Yf4LLXFEcRRhlZs43UZda+hezbiuNvY1r71qKk4W+QT4++j6+kU2NCF5RT1kTwUJlcyeMjsEMkh3DVM7GgjsWStE1xAy//o3gRE6lSC6uAex8nIqRZXU1dVmyFt4rmu+l+2UwuFGOuPSjsSXIqM2lWSy0uIX9MLYWVHBPh3BkC61UpcXc2yvcXe4keQmUzpXNpIGwzwBrgjJ0hLuWrNBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1zEDp0+ULfWdwO3THSoImW39/EPHQG/5Fec/8GXni0=;
 b=WOMJhT9qm4SZPKty4pHMwTRB/TTvsE61uBFqaPiT7NbGKPOE0Ea1NahTWHo1hizOhb4uRqs0zb3zDqJXSQg6WHao12yt0vIZ4tLLL711wI1a1Id+7OT8NRKc47OUSINW0PhZkppDa3E/GJU6+eEd1Ue6eXC/ZHmP/OLF29VohFAFK9u9sDfL9Mqhz41uexTEgQGUEMg7o0zlPD0Glyn6DrLfhX0iGQASIf1iNJh7WHiZlskInxTIICDKDjJIs68WpuJKCIhw4S0D6Q8LeyoXipiAu88HJqUCu5sqSnxs3mHaO43jDez5fVBZ9KwIzxkgB64j3udB9uUSeq8b0lX5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1zEDp0+ULfWdwO3THSoImW39/EPHQG/5Fec/8GXni0=;
 b=q5l5qfj0bCJ6TG492dgcwMg2E+WSyOyzQacXkVWpBq3+BNOX5tmElP/Mv7jqPUPSZmJP2SvNwsn67dP+e0vQsudLY+u0VRxHaOHgv7wZMwOcO/J/7g+usFINeozKyDVnza1nj8U4QQ/4aV10LouGf+hWDaPFGpvNR2UeGsWX2/iM0EjCavqCDM4C1wm2vN1kohb8wHHLZM9WpreJ0PkkY4X6+DoiTRI0UJBVUByXh0b2PZEgqtWAFojzq4LAo87CGU98NOdGgRNyvnkQmI0PMEul7mZJVabhVbPjOmwoMOOVKI85/Vpa5nA/iMwl4rlC9RLFgzUA4w9482QIQpEs8Q==
Received: from BY3PR10CA0018.namprd10.prod.outlook.com (2603:10b6:a03:255::23)
 by DS0PR12MB999263.namprd12.prod.outlook.com (2603:10b6:8:424::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:09:51 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::98) by BY3PR10CA0018.outlook.office365.com
 (2603:10b6:a03:255::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.12 via Frontend Transport; Sun,
 26 Jul 2026 09:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Sun, 26 Jul 2026 09:09:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Jul
 2026 02:09:50 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 26 Jul 2026 02:09:50 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 26
 Jul 2026 02:09:47 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 26 Jul 2026 12:09:40 +0300
Subject: [PATCH rdma-next v2 1/2] net/mlx5: Add
 qp_latency_sensitive_disable cap bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260726-deprecate-lat-qps-v2-1-5e0c2ee55046@nvidia.com>
References: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
In-Reply-To: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Michael
 Guralnik" <michaelgur@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785056984; l=1218;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=RAwjiPG5kbk8qhEcH2/e1oCvYrsCQnPpeQYsz1LV8Uk=;
 b=FYTWy4AqecNWXz+8ycabW0fxpPeVVD1q4Igd6ZBCYIARK1B8+/v5+pADP0JPccMoJsdr138xo
 jKKZRAyxukjB6+PSgvamqLJd1JLxTcr0z3oz9smP7OywRE3W9f1kqDM
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|DS0PR12MB999263:EE_
X-MS-Office365-Filtering-Correlation-Id: 55feaab1-2b7b-48f4-671d-08deeaf5a686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|22082099003|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	bkAdzvnPxBP7IPfp5H/k0fCBdgHEgTbaBlh10EPtBLBXqMjI4sP5l3WGg4s/TOlWSu0B6jZebqkw2J43kem2RFKCmfW4O3YGkUGuRTUAgMIYsGZaiYnbKVtnPwm0E/LLdmPJcHazAGvpr5dkVNpMQq9V/2Wfn/ISosRbZBL5PPUJXXkxp/NGrZmj5eojdVQFYYwB3Mba9xh5+FqLOYasuzLRNpV8OZdNj8bSKBowKSTnsFCvrp1Qdz9bI/JX0OB9aIv4vCj/59bbIc/x1YS5zqtKEhODuB35fbIQwLN4m74L+bk6XtBX2RVTOHdr0tA9PqPXHaQE8KNZ2V2T6LFg9jmkcqZ1m4nZKWUM0/0BnO45qWTX7z76/6f03Hi44sngeEoISRD5UTWZlhTVJkTEj7VFzsAq3MGdT3ng2XZi8eZLymsI6+c/wW9lPw4uBjuLswnDrh5N3SyuI6Mik+DsBUDjuttt0vpLjS8h4QnjoWNSRZVVLUihymyu6XeBJMsDFdFUgX2PLlBnPWtOzRk6I/6vI3nbZQGubQZjRZhcc2NIkpcLI3trMTM/T28vyvDqp/rG8ak2F0EFrrdGXdSOz7MNopPrvLd5Qb78wWFya6uzcnyHtw92d+ovaZRuyfP0DYjy/hPfZwA7+9Y+ltAr4Rp+Ig9KJeyfYVfxctiWpNTX+T1DTYLHUgTP+nD7N8Ky92lR2clMvDiiljijQztSjA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(22082099003)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wH/gFDs3+tOKEiihGrs9nLo/E0hmd+uL6zk/fnsM+wQV2AOVXr/k8U057gopjONbzw4EVPA41auGqnD2JCPuEFjyxMuPyR5K33kZWksYJkteJfh8Wclk2LbLlUm6sgnVoK7duMQGaEouC66ZXmvZlGDkxZVI/WNlYCw2919tBacS/ZIJ/Y1d9E3IesBPap3cYSssPCGW8XZMlW/Vpz1rdn1m908+q5lIXVsoIGnOt3LcyX72PgrvtbOtkh6xQ4bcw+b2wMpvOs0fKk1Bzse3Yrwcn7S3MP1aIRT/Bn3hBWyZ1TjzGdgUSKB9+H/Mb4U+yASVFpWI1b+fyWv0AkkyRupW5qohx0Jabg/PqITzPtXU/OkSEwzb0p4UR2hoiIYU4tUdDON46v0BiG5fAi2eh7VDxfI5uLZ0wix+myiFnq6LVbQLqBlsYyMobY446nUS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:09:51.4707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55feaab1-2b7b-48f4-671d-08deeaf5a686
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999263

From: Michael Guralnik <michaelgur@nvidia.com>

Introduce the qp_latency_sensitive_disable capability bit to indicate
that the device no longer implements a separate class for
latency-sensitive QPs, so drivers can stop programming the
latency_sensitive QPC field and skip allocating the dedicated
fast-path bfreg on such HW.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 695c86ee6d7a3f15945fe7af092f63d9121da47a..28582c4d94d4335283009595f6a278c4d17c7eaa 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2005,7 +2005,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-	u8         reserved_at_3b0[0x3];
+	u8         reserved_at_3b0[0x2];
+	u8         qp_latency_sensitive_disable[0x1];
 	u8         log_max_stride_sz_sq[0x5];
 	u8         reserved_at_3b8[0x3];
 	u8         log_min_stride_sz_sq[0x5];

-- 
2.49.0

