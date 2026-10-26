Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993095;
	b=FjCvIxha76433cX5hFlarIW8VODxptGYslD8SBbyBCZc87ySqAzKNJfOakxExZY9sZK/
	 NmekwnBFy6S7eVvcPzzb9Z9Q9+/lPt9cPyXDbGZD06tmU+HTIIMhlvSg6wSRpwrpYo0/B
	 KbKvUpft5ElaoOoSp66CTtRqCF00N+CiCbksV2HSbdfpjW2K4tJ9lVcM3TV71N1yrViDv
	 iy18EvsHh5YXLEbVKvR0zl9XNhHnq4ydNkwPi4f5jhXbQ904wzqXWCAllxgX68xwxsZhh
	 7UJoEwBDRhw4gscBlV9I/lKAndYbi6CKOPeWze05/jdQji/6WrLPKyG7o9jLGhZH8jA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993095;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=wJHMM4Ct+6jHSBuFeof9bQsEXGthjsM59Q+tfxJzSxI=;
	b=dszu0V/RmVNIGci3aNOtkAP79UBE+piWPq2MalakZbxKN3okUroO9udIHJTBaArDnCWS
	 t3odRSp8SAQy2Mx0rxlAI0Jh6pASjAa6M5nRmgjdI6BJSwpkzbXSYsFhfIDNhi2SbFND+
	 7S7/FIldSwn82S2G47RQfwd9xRXtIcz6M449N33JBysTjQjgOl6zEmry4EIr6wY92VAy4
	 rCC2oWoEOQNDT3KhAYRLSt54TPslRPa+Rt/Gf34wzpvPor50o7qve3Qb28k5IVtWaLNZy
	 nfNZKfG0F0iDfy2pJne309dyphyBwyvPeUZq540YThBfL4pW39Ni55wr3bUcUmMZpGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NmD4IyEB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.7
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773EC606A32F;
	Mon, 26 Oct 2026 05:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 773EC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NmD4IyEB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t31NR99tSRAICxvaZ+aXbPsRoQNjGkgWAHaqNHjqkPM+rADKi8mt/sIs9+LwbMrcp5DwfEE0ISP1SDLZTuB6rUkgrBYXh2WNwD5R28ERMD1YYHVIVnQ+4OgIXzPC7PLedEytye8oFqrecyNjndIFwwlIrMfbrlFcq13UfL6HuFchhhDZlm7HovEndoXYiv/GjC3HeSSxEaDoaG9glMw1QEWFZn6Jo8rdYFJOoBnIpO4och1M7XD1r/IjD1llBtUvAHH78WB3qjisFWisSpANH6ix2punhDeP+7Li8nr/VgLhusrdr1G1txWBS5hPlQgboOxzSJtHPwSAE8G5IOZxvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJHMM4Ct+6jHSBuFeof9bQsEXGthjsM59Q+tfxJzSxI=;
 b=VBwm8vdjuXYDEMI5pylLsVr8INQhqM8WBrg0UCPE/vjoYS404+G1jP5vQDXa6hZfbCacRwZ+T+8x1khBOx9+lqF68auVH4D4r8YjK8V6pTOsHRaDw4ftjaYLZxg88v7K97GCXd2YBte7mValoMQWvV3v0Xz5TPMNbWOSfncKziwJFO4+OA8pb6cKNYKS8ZXkCi5Ijf9STqRaUrlRkz7PZ9LZYnxqxmlYWj5J2WGIGIaEJZO4oBROWZ7dJmOtRJFVmqmyq7lvQAtttZ+Y3JjyWWsSRHFCDrMMma1bkVRH8tORzKoAVNZ5jY3P9Ky40hT7wxe90s3zYsZNu+sEm2n/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJHMM4Ct+6jHSBuFeof9bQsEXGthjsM59Q+tfxJzSxI=;
 b=NmD4IyEBzdVOgIAgUshIRTZXLDHVl0Hh1Wzt93u+6JJ1rykFeOBL5eE2DDZNA7S81TnQP83ulmCUL9MPDOY53yDq74ij2QHzXMIG7qIHwm9tYQFxGQ2otSk3abPuWr+Tw3jDknIAZHl0nJoQJZQU808+f5J833UdFOb+l8EwDPmI9ZeRVOFRzj9iNPt3qEG9GQDAws4OaXbNQSUVscgibpBrWm7VNQefgR3RPPZ5FsD0glowV8Ydcq31QtJdMY5E+/lS7FpJRFQqh0eD+i7FosHQ8CvKjEyr6KR4rLWEtCeIdRR0RqljYTj2Z6rFaykOOSG8/QpExpOQXQmQqjsmOA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:12 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:12 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 19/26] functionfs: convert to use the SGT mapping type
Date: Mon, 26 Oct 2026 16:36:10 +1100
Message-ID: <20261026053623.202642-20-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY4P282CA0012.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::22) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SJ0PR12MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: a06a7dfc-ecd8-4ad4-a899-08df33235307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|11063799006|261021121427099003|261021123027099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	zmBU36njIDLwJzq+DemEtpEDqsJjgQPZsQLB0UpjtLStwwVW52Pvt1lXY1C1tnsnomTodm3B0okjvj/xUAvd8wmewVe3i8ZCEfqBMKxf2y8f/YmzubMqvCl/GW4BYK4gmTLB7NwJKVgV5vUu//SB/lOE4kBCPxRZe65z8ARGenFIxQdUA3dkUmQiF/KVi/U78RCCPuPLqraYqxKlwtGS+BjLaWnPfnS38Dd9kElz7BMUsaxgTQA8QwQeVefpa4ehkvxqjtGFj9BozvbaQ6KKXVzAK8y74q066OvaiOQf3AvIH6o6jC+fYz/3BsjYAhnBPhqkvBGDcnslR3BEv5T/9cXGIUqXEsYj66lhgrLzd5luthAyawrQM3/dZ7I3FNOhOmnasWo0J1fK5DJmstvibw4pWdjWI+dlnyT3HemuqbmfpQe9BQAC7oTvRYb9Fd9OfzykFe8stke17sQcRIfPwE/gZsAVn4OSR314M1zSca+I4dCeCRRoIuAurs3SVTuEwQqVOatmHTH972NFGvY9ZyMduNck8G8Z0hqGdHcrGr/RiBgc++85b0o+Q+PptV1Gnnpq75duPB1KfbUPrkunvtY7gC3tcTB+M2+8L14E7TcwUFBYhpb0W2wSeeH0XLLT+m++HGBscjvF0Ep3D8KuGR50mHpxQYsZRbIfyEoXc5s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261021121427099003)(261021123027099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OU0Z3VpDCX4l9GWVeuzyX+Y6OTaAzD5c9q5h47tfV/cyx+tAHV31K2yLnISC?=
 =?us-ascii?Q?tDIIM31BK8yF+yuEDUv2dpw1LqKTbNJmK23vb6fGs33sm5XclYwzUm9CEhnl?=
 =?us-ascii?Q?OqxpgpN6fyPlz8A72xPIt0NV6EYaBjwnNo1BexqDi9isR58PNMxGZ0olsdT1?=
 =?us-ascii?Q?2IYlF9yAYP2+UjNhg0mt9W/XOxEJzSqdK7/Fwc99OF4GToJoZ4LyOdg/vZQc?=
 =?us-ascii?Q?l/2u/lZdHEU7KnXr5j/srb7isglNzpUsIAfofXbwHZ2ugeWnMgU5R1/jY6vf?=
 =?us-ascii?Q?R4GocrEhM80z1gN2EVbJVmE0/S0kccocDxdIdPfrkrEoLj5t0jhzeF0MuYQG?=
 =?us-ascii?Q?xzuzDmhlhp2ucSSjd1w85nff6yrc3mT8SsF/Q/VNArGOiAfuFe8bmaNUqwnH?=
 =?us-ascii?Q?lWmGz7CAst8wyZ5s/JE6JPHVRtv9Wyl8lX7iV3rk71sn10s6a2IWrcrjadAB?=
 =?us-ascii?Q?iLBEqdv6KrW7pw1WO7hTaYWDXWZ3D1JN6a1d6cTD504jZeXYUPWjl8sUAH9w?=
 =?us-ascii?Q?lBiPX8Rmak4DjIAYNdSuD1hM7YcVUUHt536EEx31NoJ40aCubtDq5+hBDFUy?=
 =?us-ascii?Q?xopdY0Wu6McqmPN3gEmc2jgzQRHB99716ZtIOpqZy5y02EhwCFOuylCavHVP?=
 =?us-ascii?Q?QFz0JeVMHEuOpTcy0965EsSNPLBkvl5OnhDQj6xObYTR0tMgIZlDXKRqMroc?=
 =?us-ascii?Q?hkvwa6VASmqDluONnt3+qo1kTalowKy73Hjv1zXCVhurPAurt++UoaFsbLI9?=
 =?us-ascii?Q?+YkXOCzgfMfjVLZ5o6SUIBWpHes/r2ZcYG2RRJgOaV8X8oZeT7TyNbZJ+PXu?=
 =?us-ascii?Q?esIVyRFCA8azVYBhv/eXqZ7+qxbqiEs5iwlhFANfe/+lVEsTUngrHCgkEMUF?=
 =?us-ascii?Q?QkKwkUkcykl98iFVABOqzZyK3VxcyJ9vmiBWPTz2EpSoQxvApsiGBLZO7M8c?=
 =?us-ascii?Q?u6TB6T9LMzijPkYqV/hw8cqB61wqK7GH9LrVSX04boYcjWR+NaekPQk5AUZC?=
 =?us-ascii?Q?+2Wpk+2nUGH94/Qp+toAEXaglcmWlTJhmWXCDlhpvX0OMCa0l5a9ynfuFh5T?=
 =?us-ascii?Q?fotfjzaukoUY/8vZt/6pZP/K3vCJOaa+e6Ccx+SwYuEUv8Bma8gVGSFYCdW7?=
 =?us-ascii?Q?oCBhlulGkSmHoGg0d0LVN18kd7M/lbZ+XveEAqnwIUoa5Nk1PhdqhJIDaChu?=
 =?us-ascii?Q?/OPTm0vOVzIx1H8tbXhp2KGGxpm8sG7WBGo0a+RD8Qiov/IkBb+bZWo84uCU?=
 =?us-ascii?Q?9TaMoKoGE60BmEIqIlLRIVvmwuUtx5I+13KrXaeKrU5WmRVqEl2zPI8E3m9C?=
 =?us-ascii?Q?bAv+G9JEA5gdhA3ph7LKazje68xnCAr8UcxP0wE4AznbFGISxS1DSD6k81jQ?=
 =?us-ascii?Q?+Sf/M6fa2FsKbwAkCKkxmd2pbQRaA4O0y/6gHWEXO818EcSl8f//3KdaxoXv?=
 =?us-ascii?Q?8HDcr2dfGf+w9CzzCw8IlmME4oIGQbLE+TtpXAaJB5wp+skyx3qz5yDtjYmo?=
 =?us-ascii?Q?aCXksFUBGuHuZKAJH3pqjrcnJ5jnORnxcsimTWI/2O2xmDJ3upESe5lE9SJ3?=
 =?us-ascii?Q?jnjXW5tLoyYU02v9ddViN4bo0V+6RJhGjfarq2wd7Ooe6zjTLntVETEkVfnr?=
 =?us-ascii?Q?qXfgreFdQUFHLp0ZH+8FQGpEf2bueCjmHipOMWLcrGHjLvhSvR3H2l8P1tG1?=
 =?us-ascii?Q?x9ablb+SDAzTF3hdXGfbN5qq2nNuoWcuSqM7kboRkhwWK/P3ZGIWhtJHZnnH?=
 =?us-ascii?Q?qYFDSQHZcQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06a7dfc-ecd8-4ad4-a899-08df33235307
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:12.0321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pj7EqxXxzhIZYPbImAGsWSWEdNTM9SJ/+wESgtPF9OSnmb/enmuGNfY3Gioyxx3iti6urMppyMC01PQSxPHOow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

These importer helper functions should call dma_buf_sgt_dma_device() as
they are always working with SGTs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 43962e05eacf..09680534623e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -16,6 +16,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
 #include <linux/pagemap.h>
@@ -1514,7 +1515,7 @@ ffs_dmabuf_find_attachment(struct ffs_epfile *epfile, struct dma_buf *dmabuf)
 	mutex_lock(&epfile->dmabufs_mutex);
 
 	list_for_each_entry(priv, &epfile->dmabufs, entry) {
-		if (priv->attach->dev == dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1616,7 +1617,7 @@ static int ffs_dmabuf_detach(struct file *file, int fd)
 	mutex_lock(&epfile->dmabufs_mutex);
 
 	list_for_each_entry_safe(priv, tmp, &epfile->dmabufs, entry) {
-		if (priv->attach->dev == dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dev
 		    && priv->attach->dmabuf == dmabuf) {
 			/* Cancel any pending transfer */
 			spin_lock_irq(&ffs->eps_lock);
-- 
2.54.0

