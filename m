Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8D2381EB3;
	Sun, 26 Jul 2026 09:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058261; cv=fail; b=sFSHrL9U5rdpEFF5Fwzl+skM459ZtmRmcCoNI74PMl2rFHuidjsXEMsLI0fSb8/433JE8y3vZEMg7XOERfFe58ZdOU3qJc6Wtwgae2/VCWdExDBLDtxcClYAo+i753/n8O1frfwHJ1p5l6T8e1WlBJPC6q+7dWWryw++rx2ur5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058261; c=relaxed/simple;
	bh=dTkrxLponO6X5vVm07+KIdB20tgKqsjOjOD0p2I8N+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UkSX5iZMx++M9RoWMwhAmkg5TpIMJnVToG/Q29cq77jD2rW/MY2ME47LPuMSncBUsOQwtQhC4yBjkvRm8CyfvQVxHu+xm1/hXJBr8C16tN88qOOt9k/uGGNA2kWQgFkVdSEgNB9AT893JC9bZw9lmLBB1U3QvxHhIBugHKtLx/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z8L5OKqo; arc=fail smtp.client-ip=52.101.62.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z8L5OKqo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=el/xz5lLs/kZkPFP/GvFFtUiYXaQH93gPSJYRfoWjRHTeqBQz9zI1GTY+t2xKpSJxOJFACQeayPlrlBwlsHYhOPSf3/ji+ld3wHNDFG02TV6r6smhWljpu9rJNTK8/PnccsAkdo+sxSBktl7hMuhPLvhnMD19G8YKdhyjb7eo7si5yFMCIXz84VJDSB/SXV5dZxe6pTGsD/ZQYPYjdzHYCbHZATA6xReqH5yoMBB7arN3NxCZQeK80q1L9HH+bYvjFQvcyY0unwrJkmYzW0XIKAzCF4fAOUufnTor83+How+M/ViXhomVcjfhMBob6z7KFYO30AigZWdttEiEEynQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6pWGzYOQxQBUmb/21vVUEi3Pwc7psn1nOc2mlyA624=;
 b=CW3vuzWHx/lzJ3UcNdsgsiSOrk0geBd3EiNrMoIcusOUWW5otkcDbHSSfy2jQ0ZUmULAyj9rbLZ3CrpI+dAKIJQD8VnBJvW9cBf3dUH6ErDgzq+Wt8cjpYd5CQ3X/TSGf2TIebp8vCqELfQJjKyzFJg08OMVTlOCQ7o0FuSsVxhoW3FtZwhYA8IH3Hxhtx8UXclQDVZMvODpq3SsFtxRNeptoaTpF+b/LF4mMUdLl2j2OY0+r1puCB80stiUBpgTyaca2F2JcOsiuO7j4WYu2JpDoriePh2pEzUawXYVHGGl9QNPrvaY+Fyzo78WdiT4BL02de9cZBnANy5KFuqh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6pWGzYOQxQBUmb/21vVUEi3Pwc7psn1nOc2mlyA624=;
 b=Z8L5OKqoNRPfhbydRrZMCqK7YeJ+FokygMX70BJk6FCYy2hMfVlwVS8hOoOOpg0DnCUPq/WYpOS85LHh5CyUaYob5aFov9lLpYMJASod3CZN+z3KlOLo/C+ZClEimWwejhs0rtNS9ygRM/bFJ8sfdZbWCqOTqYdZBWgUvxGZSsNGJdNRme0e/VL09IvKPzr6QFOm/hprvCdYr/ogGUVwgw4/mMpqLfzOdsCd67AvT5gOXoxZVfCxizH6smZI6zs7CM/aIRRrcR3xdAeDY2qAtyeCoKh0onKviLSrmhqXp3QGVT+56zLlIuqCRpkMSPZiM804BAIM7bbluV/7uL7tNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:56 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:56 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 10/15] RDMA/mlx5: Enable relaxed ordering on ODP null mkey
Date: Sun, 26 Jul 2026 12:29:24 +0300
Message-ID: <20260726092943.2880176-11-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0233.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::15) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eeb3fc9-b6e3-437f-0590-08deeaf89860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	vjpbRLWAeMcMvxfBr/pZYPhz73sJNlbzmfV7Y6yi5ZfK4jvb9D9EB3UHlp396vHBwkKnWRUVEor8ikez56tqN4f8aATfbwDdWdlZ+Q74ArHHgaa5bGnkuVT8mHDNp+2xwvNPQNMyvb9SkibJ3yOz3kUtLgws79A8VbO0XVpVuBcOJ3XTViHExmxudmRMCpthyMSYT9u7fzLZb1tvgm+staZgA3ad4Tu3q5hIgcF+zxXyWmupHpos6iDiRyvue4yRhDNxt6WFMeZ9SnyKLlbG9oE9ra07FPTUj7BO6KCZcLtLEMenmgTDSRmdCOrEBVg9TRUGLKXFWmZ12iEB7GvBhn5kviaunK3/ha85i444m+Z2Hp5FN4GcMPOB9S9lJfQS1GEfiQ4C260Z5On/0PnxOjaVCoTp7gC3qmkwVjqIIn/0H/V+toBoGnqWZIJWvH51dlfXlKc8MoaN/BJTBhGrqlzM63JntukKYBf+RHEoHurw4zNUhzgQVf9CpLe/Qu5XEmpAYJcqjASXhYRzF/xNK3LkhKWr96G99Xp3jsFUEec8/QYgHRND0d9tBcmEVj4rJcyeKPKQtnR0qFMKzUzLJMzlX9//E+piKdz2xH0WCuIyFWdbkGJzC1BzN1BA/6eZaI8PLEXwyS8U6q5WLpiX9Z71BDaQNeu3jw+dB9Rwh5Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lFxT0l9sakS1AMq0m4CSLRr1/vtShjnMQHRF7977LwW56xSU/C9Z6P2C4D1C?=
 =?us-ascii?Q?pP1BJcxSELQu4pixdY4WkokADVHjqUB1JhQaPWAF7MVRYGoXixRfJEGoMyGN?=
 =?us-ascii?Q?rq7L9GM6LDcYStbKZXa5PSOW+URHJTOY1m4Rur2fatyMcdlRUajQnerk0kfm?=
 =?us-ascii?Q?vZfB/7NXC1m6bmlT9qxDEZeZF42t+TVzadBKR6pbhgwQnn0TIdlVBDI/gISL?=
 =?us-ascii?Q?zpKvCU+q6DhgIpOK38rh18+K/w7fd8jkHkHIZ11DAxdD0wqi2NRCCmnJXqFR?=
 =?us-ascii?Q?sBbM4fwo9+EzqYH2OPR4G8yHylhKyGbYDB1uSXVK00jInzI+elG3tRcjMi1U?=
 =?us-ascii?Q?PP5gLx3pSIJGG1te2e3MZSDvqEl3ziHAeUBC4uT/+AXjYTNW58nfuxM1xCvy?=
 =?us-ascii?Q?P6bD+h50+hl6FSjh4CnKio9oBA2xIB9Hqb++/KKhObb9MIA1j1wkzOadrFgG?=
 =?us-ascii?Q?ce6gNHyhQjNrxsyhQVo0HUfY+5xLhc3PoklgOEGX27Snkrpi0tmgM3CKkVhK?=
 =?us-ascii?Q?d3iSWfvyGeNpGuK8YM3bIWD/VGO6O+wcPJiIto/yFaa8GjZ01qGMZzK2eB2p?=
 =?us-ascii?Q?3lhYFN6oj9bB+rnbPqpqwsyj6NQS8/gW7Uruhc/hKyF+K5MbgP5F3GotEspf?=
 =?us-ascii?Q?u3uEg5XjpCFIXLST3RDuAty6R8i89frjj8E9dKOZDDOThuO1KlNzcc1XoJzx?=
 =?us-ascii?Q?TN4R0Zce+tG6dbY2EPMFTMLYD/nHbIq81scxWGfj7UGkLrhndi8hz3oFK1Qk?=
 =?us-ascii?Q?96ZxGJK+NY8X1+UivfyRYgVevXX7+KGTJcVxtYBJLT6IngnijETHA8dX5jNH?=
 =?us-ascii?Q?m6Jm+Rv5I+wkzOxFrJZShNGp9k6+ulG2zcDvveW+eQNyaGhE4OQEBg2p/GKG?=
 =?us-ascii?Q?TC09ThH1n0fGUOuau69ZqUQvDanr6x6XTWkkv/XkvrccIvoS9Zp/e6rYLeFk?=
 =?us-ascii?Q?N4Wao0wRipqpXQeBn6N/dEy2NiJgT+IXsE8bgR+f8lkiIUKi3QImlq9TEaQz?=
 =?us-ascii?Q?9qexfi9i6Hz7BuNtftN/7M5+RxE9i/45ekpTbbC9mheVizo1B1tdmx48ZkwQ?=
 =?us-ascii?Q?0kUM7u4dQ0J8BTrN7qwXhK/azq7Nw7b6kOolaFE6zcFgo/rNKBs7NAg09UZn?=
 =?us-ascii?Q?kRg7nGFL+LOZPzsReCudj3Sxr5qW2c/fSYMh5esBn1PYy0kmWoror/ZITLKc?=
 =?us-ascii?Q?kJ52ozCzCsekGM282wo5sc/rds/W9nkLNqOHQZvPS9SAujq+nwHC/sfWtIAv?=
 =?us-ascii?Q?eu2glm40SdlcoFMbAMZ60q4Aj1/qAR4G31CbacavBwVzNEsZTG9jG8ZIhC50?=
 =?us-ascii?Q?hoLbnKRzII7gyFE/TDwuA2MD4suQhu1E7YuYOrIr1hgnXaSPZlHZ/r+Otjm4?=
 =?us-ascii?Q?7DbXVU+r/7CX0oLdAH1a3hxrmjdvl5zUoTgBhZp4KHNp7ci9bfAb11ez9mQI?=
 =?us-ascii?Q?kD3Kn92mTUXhomoOjEnmYgbtxO7gkKWIhkRwX5b5/2erMSocoBtX3I91MFWL?=
 =?us-ascii?Q?YoLoczPC5ZyykkNMjilCDoIDJQ5e9gYuDyEktMVjgdUDVxM5R/y9kd3tAXwv?=
 =?us-ascii?Q?WWLvXpkJMzVX0afRIJ/P6uw79QrDi7aKcnPQSODBDkatT2Qg6P/xqnHMUgZ7?=
 =?us-ascii?Q?GKDURp+DL3+pWl8X4zVW6rRxTtcTbVdEBpRZ0ws/NAzD6GBdeHdYsO2wLV4u?=
 =?us-ascii?Q?OPRNKj0M7noPyunBcxMfwU/XbrNBwhIvRCG5dzVG/lcfUA2wccC/z62ZFF1r?=
 =?us-ascii?Q?fe2xyg6fgA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eeb3fc9-b6e3-437f-0590-08deeaf89860
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:56.3518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36hYtie/OFcBfMoc2OXJN73evDqmnUh/7ncsfvk8kLqIG5a8PMeim5aFA06J1c/o9FB5/Tp6aM3ceZOO/NjX7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

Enable relaxed ordering on the ODP implicit-MR null mkey.
This allows supporting implicit ODP on HW that restricts memory
registration with strict ordering.

No functional change as this is a null mkey with no memory mappings.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b8618610737a..34dbf7a79ae8 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -579,6 +579,7 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, mkc, rr, 1);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
+	mlx5_core_mkey_set_relaxed_ordering(dev->mdev, mkc);
 	MLX5_SET(mkc, mkc, free, 0);
 	MLX5_SET(mkc, mkc, umr_en, 0);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-- 
2.52.0

