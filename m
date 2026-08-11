Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B9A459AF9;
	Tue, 11 Aug 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786469840; cv=fail; b=WUfJ0HlKht822leUo/ICQg5L9hqTtVYnD3bcAG3IhGQ+w0d0KUvWabF1piQZOWvVuej0xLmka6nnMPRXEpXniq09mKtkGzitaCndCAV7gjpl9phWfUFFIA+uj78di7XhcUsGmr+WMrKqFx5pyDLcHinYHa2lzXTDYpqVKHVh5EE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786469840; c=relaxed/simple;
	bh=7BjJghfx0pZo0FiLPwFcx5rqPUYM+44qOM+gv/IzWCo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cbiwbNXP4DWTaBuAvgPjebgMlCe+0JuqweViyutnH/xnZ/KTVZCRmfgFM2DISbtTwA+7Ajuopb3G12ZxnGgaCbKjM4VL7rMx12YIUM8Y9j6x0eQuNvNCM7XV0dNlkOsjhM+tfzBT8uXWV3be1a1sg8xwRV8ifjg3z99jYU8e1rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pqI7WxCl; arc=fail smtp.client-ip=40.93.196.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pqI7WxCl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pl14Z48modjXwyy0ktnCL50+MthdTqhbE39wWoMBHQ4QMNrQM3zujTL84x61La1+wsJH4vsRSGMQWd058Qv+MbkEnpWiB2/1MSjduM5aSIw+f+Vw3Id5kq1/6bf8mURm+3VdFv+rvSZsgnqvrMZ2I3GA1/N9TxiDLVqMwehKOpJtHODvQv68peY43nJXR2OYOW4Vl+7/Xzdoi7dIgeRYZJ8c+JHaC2aangfj6twQmPt46QiaGR6pKuCa1hllbcPqNvf2tuy/rGBeBmsXY0xyP+FfoDnx+OjlkS77MpAQE+Heb+maCIKzH/R0qTIecynAtxo1IwUHRvjvpiSQogKV9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45pDaxJzQbzO1MOeIx1wC0X9yp72ueGTCMAvF7LuCko=;
 b=RUtRR8erWENQAf4/+MgudA/ftVinjNGBEL8AdM70cOLqDYhpM9VvovO3moVPw5HPiBlylVhvg67kpWKLZjcS86TNO7yfWfLKnbtBI/HSaLYfEP8X5eFdpnfeNRe/EE860pfnEaW1S/ud5+bk/KVHvBJ5KLJpV0EXkrUA9d4yCY9QEfXtTE+hQdd3RAUtlOHWb8lnQpFH1lwYf0eBHqo27vcLz13vpbKlaUYGCdeE3EiMrc9KibmLi9PdRGoYqjLx6VC9sK1mtf0GAMXynrDDWXjEh8qsWbrIcBSjGCZxGSSXfTYnE7EnxGC4PMZCLhHoV//aUIFJaHxeuh1eaMBKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45pDaxJzQbzO1MOeIx1wC0X9yp72ueGTCMAvF7LuCko=;
 b=pqI7WxCluiV6dNm312SujgMzp+dLGv7OAIihbWH4ZFKyIckgXSp/Ya91rZaYM4gjofy5xYp6xLE+Y+e5N+1f6g+AlecWJQaGDQGvhzSHH6icMseOOnNJtDcj1zF8js5nkCvMC+wwZoobsQQG7Hwijlc6yPRoG8FN83O6YfkJVxqWIe0hK7YBXm+XUdJP1a7Dxk2lVjrH011Pp+S4mSDl770MVda4OmId5UCclgDfexossJL3b3EzposjNubTTAfmhL7UVa4Z5oA7bTQH551BHexIh/7psWlhHB5aXtqu3kqmMQ9/tMmnKMdlLttiuy+0rzXTc06idQPOGPA/ral//w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB9516.namprd12.prod.outlook.com (2603:10b6:806:45b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 17:37:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 17:37:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/ucma: Lock the handler in ucma_set_ib_path()
Date: Tue, 11 Aug 2026 14:37:13 -0300
Message-ID: <0-v1-80246720f33f+13d-ucma_path_handler_lock_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB9516:EE_
X-MS-Office365-Filtering-Correlation-Id: cd034a02-1ea5-49e9-88a9-08def7cf2eb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	pZrh983JRl8TU2f4oG5nb1bJopGDOQyV7bSeuI4U/7NKiy+nc1R04kw4WDmZheAFVvK6/2cpA9gF9N8jhh5TsVaC1qb9j6hO6Yy+Dqn9yQ2xBTu0jMneR0zRdVi2Nmrnsev0T/omxHMolGILXDbtCBwV0KKmtStf2kEHpJDUcTaS1pDxR3xHsQn3XoOg4G/7rYxq74Z6vlWG1q8CmdDEaDGNuoAdjgKSmdwRxyjqypQM96z97ylcEb+LgGHE826zllpak79BQZKNvyJha+4hA3cvoUP/I9Vrn9KhKIGLElxYwB2sBjOxU5LUWoaEDN7oGjM5euN77Lds62YBx+M1oEgghsuws8CRK+ViF/7B4U9ft/02R2U+aY/X+hT0udObzVtI9NZ4ODcqISMBZljo2SYf6DFkHplM72lIn7pXFfjUXR6havg7L00GeyPNkGqfmdjmLwf/L/eG+9R1Hf7QGMXGJ7HKS/faALax4nLYrr0hHHbYhZNYxvuI64qy52wDkfumeEZVLBwykvF89ri1GFxfG7UZzCnVma2c1BIfZnQnnWnIJa5Ri+TgSt3beu+5M24DP0WLiIdlcuZSVeaaJgSkEkrdjPEMDBPGt1ouUkrttET1exk8hdeVyP7KyPvbDIpO9PHZSo25qFYfoxib+ij54KJYBfFTjkGkVjWniIc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xQAxK/X9qmyjKQmz3zy1nxQSPXmOe7fcN7F9CEddWrXjkBYbocqhSMozIkmk?=
 =?us-ascii?Q?1Wtq+HW6/R2wFVqZNM86+GAdpmYIaJaIWMuB8OPVTfe3z3tGtt2Xz5vYt5qa?=
 =?us-ascii?Q?eThRgPlTQp72vq+DF9/9tbPqqzoMCYKd3g3LxIub9d3GRygWGOeqi+yzi6E8?=
 =?us-ascii?Q?PvQMx3TqRdVat046heYZSA8370Fp87if8MZoOT/aAP/OryCu/Rs5MvvQbth0?=
 =?us-ascii?Q?UTEaunWtu4mNW9Cl9lf5OmqTu6/eRUGzqa7ezEqmuhf+t/yf/NzEoC1uabZU?=
 =?us-ascii?Q?mCBqh2O0hux0AYnElYh4zWvoKT1h/StMSbgyyJytHE8qNSpLdoy2ZELPRHQ8?=
 =?us-ascii?Q?iOK6nQoFyTQoxeKl3b/1NbfAI0lfdQWuJKhRMl6X5KGx3HLcFbamJPSsRwcW?=
 =?us-ascii?Q?HakSzq5BP/OSXU6ElDUbBfjoibNMm80EDV8WrofM8B57GXVCj+ymEfnsBIVg?=
 =?us-ascii?Q?2gm7w5W/HoVIzqGYr3tkShbVKwXp9e/R99FscL6O0q1PUfKNE80o78RU5yk8?=
 =?us-ascii?Q?kgInALgjeh1DAK8Q29ZYirTWIKZWbNaDk7zcZ7mgofzmGdC6jKc958oklKMt?=
 =?us-ascii?Q?CGXTXjp4wMdERTY+QdPkAC2EOEd7EjEibVRAn+AZyqyWwHFakazasgW85J7z?=
 =?us-ascii?Q?6pl54O4CWnTRhOwBa/+S7dDx78Fra7sAnWjGwDeR/MqPQP5js6n9ldSqHIe0?=
 =?us-ascii?Q?A1WEVoptpsL/ID1TZ6VaO0AuxZCC1KkcErnzmw1OulCL+XRIk/QJOI8mhgQM?=
 =?us-ascii?Q?/Tn6paXKraEJVuiExZSK/lfAs4By0aQUJVGIQdj1YsnqATZARjupAUbwkUq4?=
 =?us-ascii?Q?77QxNigGFWW3+o9VCxgRvKxlAKWI6jmsoPgDiINPds2pg7F9v5V4GVixn7rj?=
 =?us-ascii?Q?4bhOB7iMsWSMCU9B6EB6/YTqiLgazNEEvnqZeQdmyd8sglF1bGCPMZpxFDtT?=
 =?us-ascii?Q?lZ8AAQl5pqaFQ9fd0ROx0SeHB44ROn+mVBctNcHZyRKYKT9l8h1xvJUxBQcz?=
 =?us-ascii?Q?gFZvmxlxD851WFM6XeWWF/y1UVqViXnzkgN7W7WD53fs/SdZZpB4ms1izNCQ?=
 =?us-ascii?Q?EqmhSFYid+n7IBN8dO3MW+rbirm16gjXRsYk9se1vM4hcGhkfQDDUgsizGeV?=
 =?us-ascii?Q?B5i5OiEefhHcoW1BOYPkcZgz7OnzXpw0J9b+gVQ8uQbdpOkhF2S0IpoymHHM?=
 =?us-ascii?Q?/u0s10aBOnUmlnN3Yzici+pKtCgxCLV+VCnWVuatPitIp6Q8mramegrkEeu4?=
 =?us-ascii?Q?Z4LuGy8E+KYV+RuJyvd0R85nptTW/OteHkFu6D5xx7mtkwbR5/P5BV4mVSPP?=
 =?us-ascii?Q?erphp8Hk7za19uxUXbejE6YfyerKWty3cMor8InR8t8IjYMin+I9TQrcGkt8?=
 =?us-ascii?Q?y9+FL6Lm2z127rx8kVQToFp/uo7m+qYtQVIfXjzBjLKM3bugzQvcFZ//DxGf?=
 =?us-ascii?Q?mWfCgoF9sOELmOU8gf6qwJloYDb7BXPebCy6xRDJe6Xhio/9hV4Dcajb4r4Z?=
 =?us-ascii?Q?LDB+DG3OxPhl1M+euveGYKSD/LAgIm8HGe53mYwE86y5s7ooQlQ2q7QMQlDT?=
 =?us-ascii?Q?25gPjKPYB4Lz5j4OFTPplk6AsJSfhC4rbrA9N+AO94yt80XBqdyn3ZQ7iS3D?=
 =?us-ascii?Q?+B8tJqAdrAyeFpDe0DwoBJbYl3xIoXtnsTXBiMEs2iVFWY3X2QEMJqa3Xyrl?=
 =?us-ascii?Q?a/aUnw72XAgBIxIKFItQ1snI6LDuW/q3/bCsRuF/wTg7kF6bvIGBZhLxH6aQ?=
 =?us-ascii?Q?lbH8T9natA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd034a02-1ea5-49e9-88a9-08def7cf2eb2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 17:37:14.8550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EqVAK2+Gvn4MfOCu7iqsNHq517ruYG7UF+WMkCIBPEPI+b0bDx8zIaFopyhqWNst
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9516

ctx->file may only be changed under the handler lock and the xa_lock, which
is what stops uevents being queued for a ctx while ucma_migrate_id() moves
it to another file.

ucma_set_ib_path() was missing this locking prior to calling
ucma_event_handler(). Normally ucma_event_handler() would be called from
the CM framework with the handler lock already held.

Add the missing locking.

Cc: stable@vger.kernel.org
Fixes: 09e328e47a69 ("RDMA/ucma: Fix the locking of ctx->file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/ucma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index a29f2d4b8d143d..ac29dfa69bb3a6 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1404,7 +1404,10 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
 
 	memset(&event, 0, sizeof event);
 	event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
-	return ucma_event_handler(ctx->cm_id, &event);
+	rdma_lock_handler(ctx->cm_id);
+	ret = ucma_event_handler(ctx->cm_id, &event);
+	rdma_unlock_handler(ctx->cm_id);
+	return ret;
 }
 
 static int ucma_set_option_ib(struct ucma_context *ctx, int optname,

base-commit: f4cc21c6a8e9d392871477f9fd98d68e5ad80272
-- 
2.43.0

