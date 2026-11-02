Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658893;
	b=QdtC5Sz/ucSfXMT2dGfipdgYe4cSZ9mAh1b1Aj7wdfosK9RdsEIoIJY1kATUUuDONpyz
	 GtN1uhHhAmPfiYkNNMJ/kgaQwGsiB7z+cjPPIiZfcxiix0BGTVBYuyGCieFTe/o7sv6GR
	 JT+/n+btAzAxnWCpyGZMhHjcAFKu9TNmlzLv5V4WQ3VNQ4sgpJ4nY/kfglvQHJ07sypmb
	 tnFc8pUDMZPdrmvYL/aKFVw/rs20blx9PgYKrAL+ZMPUBTgEOu+NFwB69+Hd9NQpJvvbP
	 RafoI8jxZ3q6Nn5sYdxZ9r9BDyZK5SjW3NWav40Daqf0tsljS305L8sHvdCbVW5csgg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658893;
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
	bh=WKXbu6NKzSroaScMy1gpqWj1NvCEUxFbwaXso2G5hsU=;
	b=LzIOitcr2MEWS+HDLR8sjqTaWJgfiSfT9AepKcUsNzHykxOMIuNXvhrt2a8uYLBbEgjW
	 uvMAyS0sp8hvqfxe7DV1otcP+CKqNvz6A7zJXK9QtU0oNDOlGAwTtQZLpAIppkTom3Qkk
	 omHFj32yjLB8WOAaHMhPSvwU9PIT0v3pBpTZd0Xol6e24ROtoKZTJal90PHkq3/yM1j3t
	 bNlOy9FK8zw1QBfmGMo1//oZXyr2X09sCS0WpHgyAXdQvD+AEJjhSncbzZKdUOy7t3rpy
	 d9UVcKroaTblIb1FIYgeSf7RKwvfKI3ZQJ5vNkRwojb/blSNk0GsXAAteztwmwzPySQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BPcvPLEz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.43
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DED606A32C;
	Mon,  2 Nov 2026 22:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74DED606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BPcvPLEz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HC6zGnp9p+QF7w5qDnctww0083wDVdY3hUxzzdZWuL7NJbjDdcKdUn381mb7sfg6qckRLHIeyffKIlTjjrkxPur303z3so4Fi3i27x+pA6p7lTa9Bz5c1HwiIRVm28dg+1vuTpey6g7MZcPpRrlWx4WrMJ3XkPsP1250M4vcpAt/hilLUadthqJKbWsNMXVhpFiym5z4+SfbocRj92GjNw3Z79reuS+U7uvPzFe8KrkH15tXgJ0Qqey186DOefmiYK7jQcp0srGgm9KgRGi6Ez+eH582ai5e220Q+R/lGx3kprc4jmfFB9ZxmhTvEaQIl2LtVbIH3ED01txb5D5DHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKXbu6NKzSroaScMy1gpqWj1NvCEUxFbwaXso2G5hsU=;
 b=Ta9MqexGmDq5JdUHPsEcTCPbo9DAp5od2ebBVltMbx20s2YGThG0fAt9RqYRlexNWDwTwakHYeNBNOmS0v2BhqYPJABVRtM4wKt5/jeJBRvTEbwRq+9bRGdynr9PwOjIl6Fe8Tx2MXXytjZdDBXXoI7QrQQMJMsBlVBW7/ggX4APp7KlzwUC101AkfbVYcIdnCfNeRP3eYaQiB1DyQEoFKMHIzN2DNbK/tHHkqDisczpLowFAMHencvCG9bqLqj/iOr7TlFqzT4wQuu6I/2fJO3m1Njszv8QKDlzueOWYIFlnwiSaEvJ/ac65VmUvC7wCWoF244NILTlbCmVdz8rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKXbu6NKzSroaScMy1gpqWj1NvCEUxFbwaXso2G5hsU=;
 b=BPcvPLEzlozlt3NbqrfIfjszkPw81o0l6M8UyFVF+P6ob86QvIIVjmKklKp/vkxGkmhAYUmQpoGVxDgyQDu87si6QzWWnsVGldua7H6eCR6VWnoGQw43L5muhGnERDjX3J1475eB0cKrDmfc22hrR+OY8+oSbCH+bOugQXO14T46akOp0lfM2S5kjE9hSaR8UHyrKtlQBNS76zM1SN/vVxoOsyqJieaccb4VjOSTO2ZJOsAhqDOLn8jaaCUEaSeSQ3MJtdisdXvXdP8pviPa1BljEzzDwuN3hEg96O5KHC2jX4bno5JDBUa+1WTg1VQIChCSRD0rjz+9eip4kpYk+A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA3PR12MB9227.namprd12.prod.outlook.com (2603:10b6:806:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:48 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:47 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org (open list:VFIO PCI DEVICE SPECIFIC DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 10/15] vfio/mlx5: Enable relaxed ordering on the live migration data mkey
Date: Tue,  3 Nov 2026 00:33:03 +0200
Message-ID: <20261102223325.2115128-11-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0204.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::20) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA3PR12MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: 780418fc-1bed-4ac2-9fc2-08df39318039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|56012099006|261102123227099003|10067099003|18002099003|261009223027099003|261022105027099003|261021123027099003|261021121427099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	rh56A/+oqHfct8SIYM/wCOV8PYfuShrnf6ypUVq/GqSv9JMDykSZHhsRCqLC3Oc7XaenNxiZzV9B49+QDsDqcTJzHp104j9f1pwjXtm+Egg16t8dCqfr1DPXdA1ZMky75Sk9oNmJg1YjSbdYWyXuumTxXdz06Vu7nN1mioXOTS9Dcfq9F16ffGvoUSsnQC2hRHsx1wv51f14AH7kVd9bIJdDr7ybBBKDid5FW8TUaB3zcojkmpzD4dEgbasL042MSenqfmpDWmprNY5FccL3Aa2iDslaW1dUiFKQlCsOC0BKuEkKrvOPthvQ+94eNXEDDXdP23IyNkNLR1ffgzQLCO+QBUpuSYqhtliV94NawPt732/oFmI8914VmVz3C5LW4DaYA/rYj1lszMlBq/cqCFypXlDx4B7slQQ4mpKXfe2AdksxFgGaEpFYktcFI48t090bELooDKSTeyBZKjd+qf25R/Q8UWQ+BmqNRO0Z24GqFKZeLta/OfWZq+GCzNwuowh0VN2IK229EtwKpWEaPmM+0isN07DL/gx3PnSjyT1+xZHTF7qT3cLnHYwAVDfBj9k+AyyM14Hft0JWXntBAmB/Fikndq+X7MjL0uLfguX2UXaQFzDrhqO3h3L41JXLVDm2tRHFWKcQUiSbiZaxtok3FxB5y86oojSxWjGs3ns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(56012099006)(261102123227099003)(10067099003)(18002099003)(261009223027099003)(261022105027099003)(261021123027099003)(261021121427099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ZRfVHtXOaoVCPoJVFC1L1nGarkYdBAra8S5JzXVXNjRRqAPRCyiyJsfHXEJ?=
 =?us-ascii?Q?PrHzMHM1JECJfhHdcMoACmJo7Rsm+6SUYfk7D751EtCWzHc12yPqOCqxYVcM?=
 =?us-ascii?Q?4SH/9DO/i5a6g+oOOLxR1rc1nJ+CHrqXiDLOy77qgKfrC9OBIfPiRccQ3xIG?=
 =?us-ascii?Q?uuKDOIX5UgeKGj/EcqKyQAkIJmZN9oN9BDkF/LUu0oWnvQPu8+p+Qb6WJ69B?=
 =?us-ascii?Q?awE4Pu5Mb/HSWX+n3xyLWDm2u5+lpIgmGZXP76hD2KPSqhiZqQjWb7/XYLo/?=
 =?us-ascii?Q?p9hDvo3cqbqdDpa9K9F9ceoq4tU7kmg1in4E+7NJnWL7hUfAnS8cO4kXXKfl?=
 =?us-ascii?Q?hEk/zrgvz++p/+NXTG4YDIjv1POOWn9uAePd+lfhBUwi4BW+DnbeB66BTpwV?=
 =?us-ascii?Q?Fw3XPdQ3O1cvxwoTydi57dDcyh7nsXHzH73uc0Z5JfHqFWv2E/tdWVQZEIBO?=
 =?us-ascii?Q?OJrVi5PxrEmk87FpzBFOWbDuiCK4luHTbvjyT1zKN+jXVue5pyMZr6hSGaj7?=
 =?us-ascii?Q?YLMVNMXNfYK6pmOiywuSzSZhaVV9zsux71JIqAWp6d4vNhJXV44xGIWPSQaf?=
 =?us-ascii?Q?mvgPpzj2hcW9kgUsgwc31JU0qWXdwYEH5N8a9XeHw/Zl8mWTjxOdoGmv5aDe?=
 =?us-ascii?Q?bVUVApNpg5nzAg5bslaLL/WFoVSluzQ7GL0LjzgR5kT6ojITny72tcmLyTOI?=
 =?us-ascii?Q?WaL9GnGP17SKZClbEQEGyNMDRt1KSpeJEvBXIrtLgygvQHLT/R7HQpXsgG1P?=
 =?us-ascii?Q?VM1rCG7Ln604cY7+uAPQMuE6CYdYWw/Kpcjtad24zfZ8mgiMnqlRZi9bg4vH?=
 =?us-ascii?Q?ulFsW8skrRD/R6QykeCaSIhJyAQDXL73P2q1qB42TEsXFC+a8cYXtNUusMom?=
 =?us-ascii?Q?JmB1D0Ey5ksuyqEb23ixrSEROUpvTGSpjLu0KrYfFIOvkpVd23nAIYBgJeYt?=
 =?us-ascii?Q?J8Rr2MSpHbjCiI9nZvvgigs29FLiQOhmkKB9E4fKVTMxT5I2NJXthu61hCQb?=
 =?us-ascii?Q?XiPhoStOp5a6xVYvOVj9QZMQmlZhIZwfI/r6cY6NGPNlTvPo3cAn6BMBMn1w?=
 =?us-ascii?Q?mZpX1q4uvopa4SDdKZXfWG4Xee26aevySg3oGgHOOgpQoIKLve8dnkExII3q?=
 =?us-ascii?Q?qS0+E2E+E0FR9Wmbx0+yhVon8wW6F9LY+7pDl2xWauh8yE00qJEvhRglJbxv?=
 =?us-ascii?Q?/pCsn1o1CzWkkSDCF3eY1SKv//L9VIr/XpdpDTcLLfh6m9WKhVgrfGzkhdzY?=
 =?us-ascii?Q?e8g68dmRbLaHg74ZqrAwSuhjjC35fiyIL/fx5Bmu2U0RCBctjbZdgHzIxTns?=
 =?us-ascii?Q?rxcS1iwNhWJm0j6oxSmYkdW344QlPWOcspIqSf8TTnLAB7gBvepOS2/n/hNH?=
 =?us-ascii?Q?4DJ/5m+LA2U0kp889fR0WZAcIr19aU3lX1EpoTApHjVuFQlu8529qtX7JZ0O?=
 =?us-ascii?Q?I6SnxGcwcUo3jXUaQFqZoaHInnMfiSVDYbQGb4Btm7W5NN6Q9gicb4uwuzNs?=
 =?us-ascii?Q?KeTflESlB9VOTBS4eAQqDhhJAOa1tEQ/T2O+QR0w9egKYCenb/mH5Kc/lgd9?=
 =?us-ascii?Q?EgmtEB0owTf+rfpE4U6mhOVAmiJ/QSnmq1xNTf9O2/QJiPTAYFjrpaFpGvZG?=
 =?us-ascii?Q?KoeI0lJll03FaXgHmknhb2PDPVQLo7T0EWyAtInbarOAQ+ve7E88fX06xVPN?=
 =?us-ascii?Q?AcHNQK3lTzsrh5CmLbo26P6GkSLsvULZSuTnV7K7SgB+defsJtmRba85wC5C?=
 =?us-ascii?Q?lvlQ7K1FxA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780418fc-1bed-4ac2-9fc2-08df39318039
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:47.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73dSJzH368DNZdBkS9jU3Av/rGUCQCzc2zBYA0iEdyabJMZSg41xxJ8zS5vdXEEmuwfQ6gDUQ1a3LaEPEbmWTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9227

As firmware guarantees that all device-issued data writes complete before
posting of CQE, there is no need for strong ordering of memory accesses
on the live migration data mkey.
Enable relaxed ordering on the mkey via the mlx5_core RO setter.

This allows better performance and supporting vfio live migration on HW
that restricts memory registration with strict ordering.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 04180035a7fe..335284037c7c 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -320,7 +320,7 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 	return ret;
 }
 
-static u32 *alloc_mkey_in(u32 npages, u32 pdn)
+static u32 *alloc_mkey_in(struct mlx5_core_dev *mdev, u32 npages, u32 pdn)
 {
 	int inlen;
 	void *mkc;
@@ -348,6 +348,7 @@ static u32 *alloc_mkey_in(u32 npages, u32 pdn)
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
 	MLX5_SET64(mkc, mkc, len, npages * PAGE_SIZE);
+	mlx5_core_mkey_set_ordering(mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 
 	return in;
 }
@@ -439,7 +440,7 @@ static int mlx5vf_dma_data_buffer(struct mlx5_vhca_data_buffer *buf)
 	if (buf->mkey_in || !buf->npages)
 		return -EINVAL;
 
-	buf->mkey_in = alloc_mkey_in(buf->npages, buf->migf->pdn);
+	buf->mkey_in = alloc_mkey_in(mdev, buf->npages, buf->migf->pdn);
 	if (!buf->mkey_in)
 		return -ENOMEM;
 
@@ -1439,7 +1440,7 @@ static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
 
 	recv_buf->npages = npages;
 
-	recv_buf->mkey_in = alloc_mkey_in(npages, pdn);
+	recv_buf->mkey_in = alloc_mkey_in(mdev, npages, pdn);
 	if (!recv_buf->mkey_in) {
 		err = -ENOMEM;
 		goto end;
-- 
2.52.0

