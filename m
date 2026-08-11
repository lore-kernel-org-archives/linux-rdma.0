Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2250343031F;
	Tue, 11 Aug 2026 16:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465596; cv=fail; b=QZTBTlf8Wxy2PffvHWOjL5bChkgbzq11zHC7jAfWg7GCt17le/+FrFLUUao/VoV81FPtzCgh7jERSjgIPsi9ZnLSeWyyLNtGhdTwgYacfxm5kMWfudM0eRNSbptTeVawx2jLBX3ySh54hfQCG/T9h24NDOjaiXWohZV4fqa4s1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465596; c=relaxed/simple;
	bh=KGO56VayPn1C1EKEr0IRl2PJH34EiJXjBuJT84YwJz0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=NCvdRkp4ORr51vYfjAn3UfE9HvNMchGJtnKLOgSd9H7nCfJ/5vckof5RbKvNWJ3k680Eif0y1nY6Z9Vgx9ENF9WjUFIfbz8w535fWvD3Rw2sMcfTr9w4Kb2apXdKIc55KwuKYvp5iyFklwc7yPmy7VZ5lfRZ/tSwsu+DEut/Mzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MPuTTJGN; arc=fail smtp.client-ip=52.101.62.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MPuTTJGN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bf9JGWL7fIo3f+KWWAwP1Fed8QaF95ct8Pkch4/jcVabZVPLkqZ1m543g5dC/GF05ynieHE4l8/AqdprJltzrW2rdv7NnnAnp1WPppwX2Grw5BVaLCGRFs8dJXlc1KGXIlOiciYxBbjKUpTH3d8/DVZe0gnA8nzvNHiKAzAYD1lfZtL0LFvxrdzePwsrcnwcD276a/2eVaosmvqOZBjUciGe8m+AXWvZH7B5tMo6+RPNFXRYfkpVd26CTpd8mLXtloQtbRvvpFquJROsF658fVI7/2bcHPad0t/4scCW/kXXLQ+ngD45eqpG1NeuyS6QL+W39/e0EFtnVvCXHLLLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVu2cKfyuubM+JnT4sp00G3iuEHziThsSEhJXwyr14A=;
 b=dEmcuxbRP4cm+MTboGBnT0qmLslBJSBYHNc6egA2Se4KbMU/8oyKJFn9MmdrSSWNhSvbXU/0ITSOk7osAVHkJPaLdqQ/M9DG/PPf1Lnw7u0CGzPZzID3nKQwhjD0OnpjfTRzOSZ6m1VZ5HNqxmsYlBRMwPRCttC1u1ah8AoxmjSGZ7pgwHIBZLPmDQW56dTq01ViOpJw7d71smaBhNma8rGlm5nmS2qYBzznYON6pUuRBO17tDXT6cJzkxWyjq7k8d13jQ2yQ0gLp+oNyM90EvCFgMbzw4AW3aPkUiVbPcNU8NAc0gxdGqQ5Sg5z0nD3Zr+LH5CXlnKALFbOB2HDpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVu2cKfyuubM+JnT4sp00G3iuEHziThsSEhJXwyr14A=;
 b=MPuTTJGND5ufipPs1FS5dM1GvRrf/IXpMh6DdrhuUf96t0slkLKuRbQrjBYhMwyBvL2XF0Fok69w2dgZgZD83Q9qt8DPQ8qRPZ3sF4Aq0MJarZiF6PxQmCMiKs0Utdsggk2WQbQL5CnhdL7WTS8rini33VuiLNvsuX9eR7HzJFqqaJPBZnLUjRMn87dOP/uyUb+ZzvUEUSQDOGbvemzMNBYaUh6ubpOpb8MQbJuwQBx0VPt/BJqgmAlWx3zyjUjhhWXPPNUeNrAVxZWIAsBbu7gbEwOnQdagO5hqCY4pkbmbIJNZVqyDjjcoqbuSf+2Jjio0nfNrEXhkh+U59rvXJg==
Received: from BLAPR03CA0097.namprd03.prod.outlook.com (2603:10b6:208:32a::12)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Tue, 11 Aug
 2026 16:26:27 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::3b) by BLAPR03CA0097.outlook.office365.com
 (2603:10b6:208:32a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Tue,
 11 Aug 2026 16:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Tue, 11 Aug 2026 16:26:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 11 Aug
 2026 09:26:03 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 11 Aug 2026 09:26:03 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 11
 Aug 2026 09:26:01 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 11 Aug 2026 19:25:57 +0300
Subject: [PATCH rdma-next] RDMA/mlx5: Remove warn on missing representor in
 query_port_speed
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260811-remove-warn-on-miss-rep-v1-1-eccf399bc6af@nvidia.com>
X-B4-Tracking: v=1; b=H4sIABRNe2oC/x2MzQrCQAwGX6XkbCBbfxBfRTws7lfNYbMlkVoof
 XcXjzMws1HAFUG3YSPHoqHNOqTDQM93thdYS2caZbzINSV21LaAv9mNm3HViO5mLpMc80nOAin
 U69kx6fo/38lLzWxYP/TY9x9wSxeBdAAAAA==
X-Change-ID: 20260811-remove-warn-on-miss-rep-df03a4050e0d
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Or
 Har-Toov" <ohartoov@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Shay Drory
	<shayd@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786465561; l=1909;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=Hc2s66niL7g5WyMhAoXkr4k2OzapfSKhYzu/rBGxfYc=;
 b=bpg7t8f0arxDmg0HV1fekQ6dVlLUtPAFFjGu/8y9Y41YiibLB6uE5xYPCloAdD2rUzkkWQUIC
 +mE41bTsziZCIfzpUt2Zbmmx5SjaEkpZCHNERo34X1aVBWRo0mwDQ49
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: f17a8010-7018-42b9-1833-08def7c54b39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|18002099003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	F/C0pZpasUGhdOVaFiZMnxypGWd2lEYXdaqZAeWcn87HizD/hq4uIGF+H98+ZwU6HXdOQU72tz/ZW+XclpSCUMvuVcjhy3uXHxsXlXLsw1Lat8INIgoglH12ok3KcMtlUc7xr0y7TgqtRATNvBysefJ7YzuGEOWcCGhq7IbmjaccoWGBFlNSM6BHjSJjW96WKn5svCMV13k5hyxa4ZsFYlZ3XdXH5Q9AXEHuVfo0k4qqaU1aiVPXxkx5bBPvyew9AGgTjEClOceEBPtfJIm9LlxtJWG4G4MGLD9ehp4R9ZCIQEuF76qfiWOaMe249I1URoohQIkEITwD+8tZVdDRQyu9izeA8tKKzwjzrVqzkT6P6AxWeu6dspLXc49y6u1z8KaWcS2QApZMCbHMkh2boor0CyytACvwewVZCMKlgkwA1vpb0/bb21jOPIQw9QDcYyYfZotjNWTDbe8+IKLTQpfr5hkeJwTbgmUvFVxLDyciwoIc0EU3TJ6yqlCoTnaC/dbCnjXT2+RMN+NJ9TAvkmyUwIRba0Aa+cJwlfAMnQ9CDRetYdi7hE3sTz103EOQ1Yqk7KdiCfY000TZv83Ixw4QvIU1tuxpK/uXC9rVnmtoNH2A38JT4OlS9dNPSGsePHOBeYZiXUTAtz+y08XlFW7NcAfHflKMZDWy1kF8+q3qVvdM1SlrfLb+hMKVgteoH1C1lVwktSrcpvAShC850w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(18002099003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3/8TSBVAZtETewH3tZXFaDW5LJDboF1hd9SdFbQnQhGU7b9Lp/oAR97GeBhHuNpEfQkLhdebqQk7wc3Ha5arVL2DJR6yEApwHnBIKCOybm3XjPqQgwpMQSh8xLYUgkrEVVGaoRWdm61k0RJvryzlr1xNYioQQ5PKaY2e0nZJLz4nCMGD2Nll5ijpsrSZmFI4DELb3h8j4dPWyafrGR18atEz+JnFfPMs7drnSAFDs6pvnZS4R5yoB/W2+a9lFsV/TYiV/j6wFhBCJp5h/mByw/VbDbmV3f2lxiwjPmi6qwPooqNvv2Wx30xPnzu/UUPT18JQbiHAxqxb/m9I5xy99KbBNu88FEvuHZ3Y491PYnENVJ/BlJxor1KOCdbUWs0sgFIDdjrrTX7Xvs4MgfB/hrCNzdiCHh7KvuWJ8PZ7m0A9WGIKo2Lky/airPOXwZ3u
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:26:27.3983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f17a8010-7018-42b9-1833-08def7c54b39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374

From: Or Har-Toov <ohartoov@nvidia.com>

The representor ib_device's phys_port_cnt is set to the total vport
count when the uplink vport rep loads. Individual port[i].rep entries
are populated only as each VF/SF vport rep registers. A NULL .rep for
a given port index is therefore expected while VF reps are still
loading or haven't been enabled yet.

Tools like ibstat and ibv_devinfo iterate over all ports of all RDMA
devices. Some ports may not have an eswitch representor, causing
repeated dmesg warnings when these tools run without a device argument.
This causes dmesg to be flooded with this message on every ibstat
invocation.

Remove the warning and return -ENODEV when no representor exists for
the queried port.

Fixes: aaecff5e13cd ("RDMA/mlx5: Implement query_port_speed callback")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index cc7e9a3e76310b626779837e248d399f84f82ec6..906e636c6408590a902bba16caa81b2aab156776 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1682,11 +1682,8 @@ static int mlx5_ib_query_port_speed_rep(struct mlx5_ib_dev *dev, u32 port_num,
 	struct mlx5_core_dev *mdev;
 	u16 op_mod;
 
-	if (!dev->port[port_num - 1].rep) {
-		mlx5_ib_warn(dev, "Representor doesn't exist for port %u\n",
-			     port_num);
-		return -EINVAL;
-	}
+	if (!dev->port[port_num - 1].rep)
+		return -ENODEV;
 
 	rep = dev->port[port_num - 1].rep;
 	mdev = mlx5_eswitch_get_core_dev(rep->esw);

---
base-commit: a12d9145145b21c50531afb6e3f711b1f34e1465
change-id: 20260811-remove-warn-on-miss-rep-df03a4050e0d

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

