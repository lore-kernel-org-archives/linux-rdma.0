Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993091;
	b=kAx4dWf62gMoHqKbSTQCIclmkqlrb48CBj6fRJatwZjqs5rvjV3/IQPqbCQ2RZYuSDtR
	 dVbmihX1VKQ6lyI9rndM/T91iqVnk84mz4Jq42Wrm+yIny/oUAMW1za5yBUO2U8qu9F2Y
	 8rUVbrbMbZuaLjd/Vqxx0rjhd/THRsL/GRtszxYuD6IbpiZ6GoLm6DzXWPqhR/zrBBhyk
	 ZO8EBmWslCw28Z41hxPsaRnrU1jDYm1ZVG6+BNRdgiJhI4ylmQyNshz5GtB+AgnK28nWB
	 Mn89ccg8vKA0BW417h3qO+ZgodhBMAIjEXCijFOCjJarVIysahjgI0dCg7YjWU7wu2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993091;
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
	bh=6OIQuM6JHm2V/4VOJ2oejd4oJYlN/6RQkxjydvWja74=;
	b=HFNWa19zoxn3wlavl2dU6+dx1o4apNkEkBs+qKJei/hOJWJCGvQI6YA0XirShA5ROYJ2
	 ViJc2Li5+a0S+cB7QNBX4pXCnjXaveXwFBg0VujHel2FXJQM8r/f/Q+3+p2G9miG1VR7f
	 Yo2WIpsydTZ3Y2ZbbTOhae3133TVnQjfY5Qxaq08FKbglivhzxLos3iv/ZiD8xXyUCs8h
	 ZTOn7DpLU3Dru1yM58zDqGcrTG39PqQuUwS7tc5ZTVTdwE8v9di5est9L2AhtJxGVFfsA
	 Bl20A0Ys5Lx0d4yvagFWVimkXUvjCDmcAuXdyFluiMBE2Hsr/Gan8O04EVwXZ++lJkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dbuQaWyI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.34
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1786606D310;
	Mon, 26 Oct 2026 05:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1786606D310
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dbuQaWyI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3JGBLnbtNmwld45Kpc7Is6AahDEcKxTE2H5z2OoRQs8/dxhsCL8CJeHaoMvv1EIKAUjgZXUQpaciB3Uj7JZHTu4dHApEz1Y2Ky/L2JaRR2sqGMl2YJpbHpdOGae3h3bL5LFOK0n1OzLDd1XADrbkZwcug+TeI4L7Ca0rhQkiwoomAYFnP768Qsvo6Xy4aZPtEJrdxal0eF45ds6ZLEmZ+XYoqzWRQjevVB5ML2EpEFukXECkXbRptDPw8c2eRLHtPf4l1PCiZuzwQs9yBwT+7Qwduw90S0lFtsPlYboStQxsk5eCq1+suJbnnL9tks0dTMIIqPv6s6+0zifOMnflw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OIQuM6JHm2V/4VOJ2oejd4oJYlN/6RQkxjydvWja74=;
 b=LmkLJDSGeNNySImS07pj1QhsBhqn2DUaDXjwRby3fAIh2yN/z6OG06O1izw3oJABAmE/6dl8yNtlEi81H7TXnjNevaS45kZffCVI7LwmhAdYmdXaaIOezzQlyNKxx2+HN1PU1z+3pUoGUhfStqfV4Iwz5rHCI/UEe19AyvJUGpPfLE89iaaTx/ZXzZMvWREMXhJNwMIkeVSHlNKYD5gzJGTq+4jDufalHKBgYecYZe/SvSKeejNkrPZd08XaEsLzmS24TV2/EfaPt/bXcHHFrKvvEF2dttdmCq9qKXRxEsBhQHUcsPMRuCEiNtRZsh5mE6MgKFibVaFAS6HOWUbKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OIQuM6JHm2V/4VOJ2oejd4oJYlN/6RQkxjydvWja74=;
 b=dbuQaWyIGZE3l5TU+jBWlW7hgji/QPB1eXTYXML2kgD9WSImT5EE6qEMTQ5jTjFZujZ++TmIxuiocFUf1IJ3wi9PTDs4qGZSZAa80Anb2P6w79ieg2eprpzXPNXMIJWVATY2Cf1IluctKLdNvPCi1wZ3hwpOM3XmfNbLVuy+1XLpFOKc/iGXilhgu4LCAIBjH4k6BKxZLXSBQfx1oOWWIUOxLXBQz6krf0BCaYj08sLeK8IKUTFKUYINpe4PGD2fe9KHvAN4Va06FUl9LDCGOYILsCOEOWADyyjY2bekjXiA0H56yfbCRoSfF71x01OaK/8Jyv9OLp1azQtu2SwkLA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SJ0PR12MB6967.namprd12.prod.outlook.com
 (2603:10b6:a03:44b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:38:07 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:38:06 +0000
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
Subject: [PATCH 18/26] iio: buffer: convert to use the SGT mapping type
Date: Mon, 26 Oct 2026 16:36:09 +1100
Message-ID: <20261026053623.202642-19-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY4P282CA0004.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::14) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 14ace1c8-b36e-42bd-803a-08df33234ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|6133799003|56012099006|11063799006|261022075727099003|261021121427099003|261021123027099003|10067099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	uQbntHFBLw6S+KaVkkyqgd61DihuEWeXhDLD1VCWhB9AtyUulEPYS/2QA/4WjzUEmdCaZ8bGxB4mS23eOluIoxtYPwt7RWVEE+Fxj9Le40ST02s/OtsJru7tckWbiyxIC0RDTmvzKRaw2ixQ1Jy8uaZqYc8XBJfec7gXT11/1yiaDXg3Ksk9czYUG+PFj95J15lwjAx4pUDuQu83duylqqeZepfbbNkbVq+KKUKC1JDnWvrF+HKmZFUEsgMHiIEPIf8JuZBY9rcVRONQ6zsTl2Bi0xdS5428zh5vfiSFE5NorYtuM5e+GVlj1Lj1mW25j+Sk/yVzqk3aDqysNOJv6hrBiONn0VPKZe0l2jqWuo25zSNJMFjtc82+VOJ+GBelrxo1eyjHtoPe5U4CiX6bnJTgi0PxItvGgUTuF8SplSvm/EuBjz1kuikzNPHmlXnXfdzDw8uU8JURYJp3BaAPn1lNLEHyHBaROkrmdj2HpI6Nh9+OHEvsHlYKcDdLFgDoSoNytl9DsAusEwQ29m+SmMhLpeCx6hnW5KfZvlDyJCPQI5Q5ijRyxRDmduInHhrSrcwzQAqWGGiK/WIUDulcBTLh/ZX+tUQ2qhwf7FizZo2udKoiP60BhQQkJvh+Hs8Uykqbi7ibMA6CMQBgKJvj3pr1NF7O0eg3/CCPV2Wn8IY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(261022075727099003)(261021121427099003)(261021123027099003)(10067099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/vLey65gAEn7OdcPVCoRWM6q9ReacDCSoktrEbzkQ3ZNsFoGjWE0C2+3vq7d?=
 =?us-ascii?Q?zRL8ny7nAeOACiGE0p/fxv7fGJR8bXF6/ZIJSabZykTBvnHNTRT6bh3m49qL?=
 =?us-ascii?Q?mclyVXiLEYwrAN+rrd6hhI5J2Bbo8BlurHvZ9VI+c1HhhsCV7GYGrmsOp6Vd?=
 =?us-ascii?Q?lYg0bfUYToCkcZ9vzynjNLUJuzRGMLZWVM6Z5jZJXRYhhQ3Qf6PnhgRZE1n5?=
 =?us-ascii?Q?rkfGx79Tnwg+wEgFCVVZGK4SJYqfjrtU5hz0I1/3o90msFg1llHNc2EKb+Z5?=
 =?us-ascii?Q?5CNwwrTt1bfD6WSNUo9GfEcHrM9H8TGUpt7wD17Hf6f/tcz+66+gXqmSSRZf?=
 =?us-ascii?Q?Iqbzft8ngHJDfPQ7620yFAxrnHLt3XPKE0eXPnsx+kUe39sR/KqEoEu65ItW?=
 =?us-ascii?Q?GsHFQPrW+NFspPPAUsS+ZkClkWm0oZxmYh2+TFoLJ7qNpiBsb73LvJK42APG?=
 =?us-ascii?Q?OVinRzMXBUV57v6ZOMnzDeez3l0WY64jTcNNldfy/dcVp1Dh4EBhDzTO+QIq?=
 =?us-ascii?Q?K9GVlnz3ZTydeJc5lwdp6LT+9FEhmgrlG0ajq3Aa3Kbc0NID6qmiJIHr9e60?=
 =?us-ascii?Q?nm0TQJ5CzBqqhSEy7Ow4zXXyowm6AIQLZ+mBirvtjlYJoPYHFAB6U7jUnjpq?=
 =?us-ascii?Q?4pXUggTlMehcAb90km2p53IAQpeWB4g9gy5VwU5CqLQFMF7rkmGPEH2IF/P5?=
 =?us-ascii?Q?NbJHfe4bOkaGL0Vr3ANFgpNXnZojrR9eTi96wIfncJyhNnfCtkqzM6FN0T90?=
 =?us-ascii?Q?Xxyr+WV9M80fKlwRnCWWcGhsV40wGEeEW4Z/w3aznCCyr3qT3qdddsPW4wgQ?=
 =?us-ascii?Q?UAsQHFHuJ6I1T9ULdbj7UY+JIgP3J1+LPk/MLhNZzbWUAxHHKU0gPrV392mS?=
 =?us-ascii?Q?LOzfK4EXUfPEuUQRhWrYam8j4frN7BpGgGmW/+TGTtlHuRTqAE+JmNM4+Tbg?=
 =?us-ascii?Q?6c6uh++S7yxLGDomzuZu2PK4dERDAtYYNddEWzJzqoTJnRjOmcd8/jzUcolZ?=
 =?us-ascii?Q?Z9el8jAz+RsxSepxLQqVufN9gWipTZaAA48ry3VUMgW2B1z/nNu8ItGVqC9b?=
 =?us-ascii?Q?qXE7TSpelAGm2C20gYI6p5BIKtAYDEIFCRNaAxpHHymHXvpMFjgVRIvk89A+?=
 =?us-ascii?Q?7tqhyWIsEbHryoQw22npGhX8O6sEnDcWJKyF08M8AuZjOVfFZXiP3CU6IKZ+?=
 =?us-ascii?Q?JKcv37+bvmDfZFzFVZfHZ9pYmJDk1NIosPAX/iW7Am7rKiXliwY0aYw6mTL5?=
 =?us-ascii?Q?u5eGXdzwloPDA8UWjHfSsLymU7Y5Uw0Q9vD1jMWjd3R3Qxd4IWG6R+PLgK6U?=
 =?us-ascii?Q?ZIAymSKNi3nNI4mKzkQED68pa10ULvg+UIU/bBP1q8XCPAfOvVdWQhSP8+jv?=
 =?us-ascii?Q?//U2fJgw/CGf2TYlyRRAgzdVAb/+mEFZgzXsZPoXLxXmAKb+4cOCVN0u6WJE?=
 =?us-ascii?Q?Ss9Oo/RR3xj7w3HzHR2dK4hsgbsGyG7WWYNsxwM3ewhiHrf3XxCR8xFdQzYP?=
 =?us-ascii?Q?AlSSMjLe2XD9xaboQGJ4HaBCiB/1/o1AJPtSlbw72mJca6OQGDvmBhZDN+nt?=
 =?us-ascii?Q?ofPFlUAL853gYzpoF9f5uaY/EGw2+vHJqrrb7V4XSp2eqP6+vlkHplbLcpDp?=
 =?us-ascii?Q?WGwFWCJRCNn3HG9zHjkNVP+sUvlkmR3u0KfT/UHdYDBbUivDbpVPslkAsk3u?=
 =?us-ascii?Q?YnCGcsojdkw1cTN9hU0aitM+cdWaAxbU8u3ykbmG32W/jjfmKpuil+vQGkgg?=
 =?us-ascii?Q?8gjC61m6gA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ace1c8-b36e-42bd-803a-08df33234ffa
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:38:06.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FmOeLjXZ22FFTktyMEd9tA0hYS2zbl5YSlfQWqdNZhtC1bncN/Dc+aZ9kMyOgGpP2iyZTBtB3tv7Q1LwQt2zuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967

From: Jason Gunthorpe <jgg@nvidia.com>

These importer helper functions should call dma_buf_sgt_dma_device() as
they are always working with SGTs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iio/industrialio-buffer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 2c9ec93dff47..a00985c92251 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
 #include <linux/file.h>
@@ -1672,7 +1673,7 @@ iio_buffer_find_attachment(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1756,7 +1757,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	 * combo. If we do, refuse to attach.
 	 */
 	list_for_each_entry(each, &buffer->dmabufs, entry) {
-		if (each->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(each->attach) == dma_dev
 		    && each->attach->dmabuf == dmabuf) {
 			/*
 			 * We unlocked the reservation object, so going through
@@ -1810,7 +1811,7 @@ static int iio_buffer_detach_dmabuf(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			list_del(&priv->entry);
 
-- 
2.54.0

