Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0C04A8A18;
	Thu, 15 Oct 2026 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050082; cv=fail; b=agxTN/sCL76yl2+UH/XlZNG4yjHVsBL9LO5+3G8egkNkahA3nZwJBd35ysHK2krXBhHQJg89ASgqVOX1Z7yV0FWrizmI/HHuyz2jgf1I2ma+y9Ch72hgXjaO0tuv4LK0v1TmDMZ2KLoYc0BF6xts+lSY6Ek55nfvlNUgo84ANOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050082; c=relaxed/simple;
	bh=0wFeM8X4sSYe32Vy0hum5X0evQm6Rk2rTXd2WwnR9ME=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mje61RINJVVB+m1c2fI6IJ9lqppmieh9jn3Sy2al07epqBPA0586fs1YxVRdEMXHu2Qt/n7KBDIYzaNtTNz2N2Lf2SroIpfXyY2l28/bzBRoAfu2PX6Z9bmPWPKtZ3PB56QA7/XEL4YyPYrauxlWZ8mCkhpy3YyQDsKu5Mfd5wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wk6SbFSM; arc=fail smtp.client-ip=52.101.62.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wk6SbFSM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BWglD3TrNx7HCJa9ZCH7lwcdOr0neVvzj38JKH2IbRQ8zOU8UXPCX7MAwOGRLDG/J3TEi0bdMMb+Bl1qE+D/r3DrHRMlSb1TJ4JMZKAYzrzL1eg5wLajc8rVVkUtc/FhgaP2rPKadNAXTqZ+a+54p65e5HJOxH3V8BF3BGDdyGafkl4UD8ktSnt1iaLPdB6s4TJHpStT67G8qUZE1yZ6vmNkKSaHzeJY+W1+XgArSpy50vfrIyR8wxvGyO1y02P+V16p4opQnugGxRFwkmKK6chCfrVBAwoUb97t40jQPHx6Vh5fB9xBHS3LPiaWSDBgefNGpHHmLCjXz+OzWzCcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lp6L0PchFFvvd7tydw+T6voo11KP+kIWze7aPPbmcQ=;
 b=jRxLDPavLHvJ161/O/jAccatknle839ZpbJ8KUh0cIZMOOVd9E2G7ZIMybcmfOXohtWeYm3lX0Ho4lUh/Q48vNlpdai/QWiPm/uxL0ZLqteYcsiFLnt4P011lBvf5/0B/kw59p6c3BsA4FFUhmRceNV11nuzgWSjfUf6+vRBeWAB3yCiJrRe1B8Hi15OShGDDWctfIOewd4xvChkejqANccrLM+0itpYVKziNo9uq1EcP00Y5vGAEKRvPXY76QIxRvSx2waFSQloxRbgkYIVPS58OuqJ569jWuxEZxtRyR4Fd9CPZhhnh0hAUZj5hzZo7fD0vMXfSHLw6PR64OOe/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lp6L0PchFFvvd7tydw+T6voo11KP+kIWze7aPPbmcQ=;
 b=Wk6SbFSMvsSna9JBygfshY+XWlEiG7Gpc5eXx6hVyDKy/ktFEOMJkXEUUVcARAe+htMN37EfZSYaG3N64NaokL5O63o3qIwWgNxghpT7tiTUljM6GgTyxw1n6D05wWHSzJ7jbZS3opFZHoDsD6MezeM+J7kM+kfiIyOsUIncsuBgmvM9WLs65DtY0SrG40SQQXqpvkHjihewG8TEQbJukzoFckApv5FT4FNETiz29pkhNxXWSXGs5Uao+1i1mXJF6cJagJZoYAyIu9NMIivXyReKcj+nvNc0x4LxrkDe5mpGF5lTgmpoqKolu6qrO1AftcHZ36azTdC4t2BBolxEHA==
Received: from SJ0PR05CA0012.namprd05.prod.outlook.com (2603:10b6:a03:33b::17)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 07:41:07 +0000
Received: from MWH0EPF000C6188.namprd02.prod.outlook.com
 (2603:10b6:a03:33b:cafe::a8) by SJ0PR05CA0012.outlook.office365.com
 (2603:10b6:a03:33b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 07:41:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000C6188.mail.protection.outlook.com (10.167.249.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 07:41:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 00:40:54 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 15 Oct 2026 00:40:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 15 Oct 2026 00:40:49 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Carolina Jubran
	<cjubran@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jiri Pirko
	<jiri@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset scaling
Date: Thu, 15 Oct 2026 10:40:35 +0300
Message-ID: <20261015074035.1092340-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6188:EE_|DS7PR12MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c714d1-bc34-4fda-9536-08df2a8fac78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|7416014|376014|82310400026|56012099006|11063799006|261009223027099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5xtNRBynzHNPpDXh516OmDaU0QiJXyhA+nJQCaM2RUPovtHkHzD0i68knmCiFQmPJmKzYqnTtGsb11oGX6uKN/QpjN5BsKo+ymj/iGq94WV2+dB/082Vav++YvOItQaOMnfw506+XDSTzNjLujnN81/NGtTGQMVwG6iIjlvR0XAaacsXwSrheehL4piO7TQGMVJW/vK039XOx5a7PgHZnOYLcdXj2tbGc8s+gT89iLCG1+Et5wCp/mUD6PrdiPJv0S+9wncvI2jrX39qpKuQrUbDmVAn+X7gVzRocR22CQ8mNbnmXU5u8nG9CmbB+9HYXSv2E+MKsVhkF0zycKMgqw4elF/BRJzoutluGx+5LOvrk6cDH8GMvC1XRZODv8fcjDBMluwCZbICwFTeAyDQytp/fAfESrJ6niZMopSKdtOot2RiCFJkBAWqrzWhUO8Tf6kmSe5oNcQFcQmsFUyg47hhs8ZKiQZTFU07Uf3s9rZxFmj+X+GkQGyzDe/+okA4p3cnjLUq2PclzZWyUImCAAaXT8Cbux1w5kdVxew2pEADPAQeC3BxIRcbOdfV9cdTs+1HSySMoWSmM73D4zVnt6/vnf1PUpSBwR7nIRW8liIOuOeTGkVqUoKGveoItsru2kHB4XppJ14CSg+OKkXttEhvFNtehSr1ryesyYslIO/4MoLWMCvbgrRIJphlnRBAUJPGA4Z8QA7x6+ALZgcyTA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(7416014)(376014)(82310400026)(56012099006)(11063799006)(261009223027099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iuzxEQbCXa+0H3TMCI6QEJCZhA0gAqLc6xT4CfCwxHiuUmfpo7h6hfKbGppDZZLsiaOjLPfGVZ1iammnDqVCVU/Uume9MJpx/7Uw8wBZrlWPtK3fsXrjZKXNFUx3U+66Doh0NTC12ahgxsugNSlz5gXDi8wfdWBkdpdoQYPLcPOOmuZq7xgK0WpnzLkNJ7Umgpz0kvonpypfqytWxS1Zba1jFbBdnCEJZczQhg8dSsOVcv5i9pHtBxy2PCOt/FvcVoeUzMcih/BPGav6BRAjDE+Q7BvYgzt08j3qZqTQZgPhzc/2jjvzITkHtYn+xxX40hWaRkc0CaOpGaCCnLkydnOj1GlYhQEV4LHDLkpBAoWJZn3/HQTF9yisQD/OK+ZGFkLrqY2PLd3DPkvJxGuqL1aDyBqTaWVf6Zm+uou45BQFfdmMSUgPA59VJYGoRWNb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 07:41:07.1002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c714d1-bc34-4fda-9536-08df2a8fac78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6188.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006

From: Carolina Jubran <cjubran@nvidia.com>

The frequency_diff is reported by firmware in parts-per-trillion, which
is exactly what the DPLL core now expects from the ffo_get callback.

Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
switched the callback contract to ppt but assumed frequency_diff was in
ppm and scaled it by 1000000 to "convert" it. Since the value was
already ppt, this makes both exported attributes wrong.

Report frequency_diff as is and let the core divide it down for the
legacy ppm attribute.

Fixes: f035dca34ede ("net/mlx5: DPLL, Implement fractional frequency offset get pin op")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
index 7c69d9029bfa..54ba7c330d66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
@@ -138,7 +138,7 @@ mlx5_dpll_pin_ffo_get(struct mlx5_dpll_synce_status *synce_status,
 {
 	if (!synce_status->oper_freq_measure)
 		return -ENODATA;
-	*ffo = 1000000LL * synce_status->frequency_diff;
+	*ffo = synce_status->frequency_diff;
 	return 0;
 }
 

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.44.0

