Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658895;
	b=YXKP5pKttlJ901+d19UrpBwsPxn8TmK6lCORn4JhtSIhbJPdV7va+yY7/TYIWyoPcGvY
	 jGvrFxa/LfvPwIUpxmFg60NSCa+6cNEoG0I0RvOHTqv7Oos1DEKCI7Vn+3D7dBh9yi4ks
	 xM4xz6WTk0PQcJaz1PtOJlSsDCDLLqzGQ6bghMEYOCe5Y2aMPhlz+qNzVwceFZ8nWkQpc
	 FmVs1rdwL88riThUjo5TU2Jn2u/YTdT2eZu4E9pPgjF3f86u9n996O7GIznFCxj5e/lgh
	 DUlvvX5gL5Rrl8DD7Dm0dMHbWIJ7ZR24DwvnmcTXHECgQxoAMuT//3oyZEaBxceZCtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658895;
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
	bh=zx9djlypU8UiagUF4B4d8VE6i/5t60aEqXk5bqol4Ic=;
	b=4viE6eGiqKepl3yaQ0fOchYtBfHI4uXtdbu4/CA45Yr2DppBRTR6vBx9auWIj0OhQw84
	 H8Fv/RildwPV29YZXRZaDR/3Cm0ISkjeX5vtS8D01BTl7Q/uyZBTknd8HPPRu5gqH8USE
	 7i3+a+PybyzHoXVma2qOgjbbncdQVbVOipqMI2pwVMFj9F9HfgxT4Ge+fj+vMnin0RaFk
	 I3K7YbzHfx2WmCVhudi6x1Js9+72KMXfheX/n5RoHc+mKbarWK8wX/y6eAdPmI9xDz49x
	 MVMMw0wDLYqeZj5q0gqmg9v7mBvKlBNLhiMj9U4ltLGKwNBSLrjKLdHhhjLs30GiDLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b8yCUuzz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.39
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010039.outbound.protection.outlook.com [52.101.61.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066D6606A33B;
	Mon,  2 Nov 2026 22:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 066D6606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b8yCUuzz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNUZAQUHX6qtcZXIhRppf+x8Ci5TAqx203cbmw/hQ2JKic6uUJOGJL5ITpBA85M8SdhPiVTfE7/gbWIQLyqPrA5F752YAJjibL1qde3fY9DFQSqeGBa/Dwwd2eBf+ZTaMr9cQSYID5ozW9jQ4mtyX2Cx7cqdvFJ1TCq7Cw9GqHCJCX6jBj8hM19jWgUQHRhf+ItvusUDeOwu3/Z/7oKpvMeeIofI3/m9oAZliiE9prUpoO4HOqi3tHAPwxnVhy3lzSYbCQz+nqML40hZyLxy+OlRuP49qrzWEcpL0myIH90yOnjt95/SzwnOzHfu40ClBP64Poy38mV87bJiGjRbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zx9djlypU8UiagUF4B4d8VE6i/5t60aEqXk5bqol4Ic=;
 b=ARrNIBND1H+6jNiDprCXmLRiz4xYg6sv8Cf6q+G4LHDbuwa3xwOu4KWXCKXdoGPwZzEKW4x/es82a+LsXAfFwTwEew9LI2OyVc1rxff4lb9XfConIyWAXaCWNnX3hyEG3EOaYMMgUvdbDKe/7292gewWv18tYgqLCsqq2egql3feFBKOcFpHen/KUI86wdPU7hn0bKlwV9J5PqYdjXkIiOUJdRytTrW6uTiFTYeumxYaDiMDo8DIh51Ik1TFe+FfFP4nADnSvtbJkOGK62wHFtfqhUywNJX3yCDQ8fNP15YUYUzp0bdhPyHxDU7gK8/vLs5b2HHsmLPTawryvPhySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zx9djlypU8UiagUF4B4d8VE6i/5t60aEqXk5bqol4Ic=;
 b=b8yCUuzzFPkx8iEoF7o+ypuAvI1tIJqxWb7kO0qt7v2z1NKoMkwu9+4MegUTS7hN0gO4/cqY0fVfDJ+wuKKXsRf543Tg8cj1atkBjtP7CEWq3BAGwx1UaemKMLZVEtXKqXCyuPbdFAsJ/Q1Qxt0JBNWSLYNdz646JDjI1nBIev+pynC7reLwcPPcwF8QfJov1tI+2aQwSZ8QtC8NiK0XcWtVj8nrJjpvmgMtYDXYdEddsflYy/MceA7TaU0X3JfJxg6SKBfV1EwPUso1w8HmJsqyR98Dx75l569n2ikIczIzLoXumQu8a6u2E9BdoNOqZT6mFOPAdzdbs3tC8Dkk+g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA3PR12MB196577.namprd12.prod.outlook.com (2603:10b6:806:533::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:52 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:51 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 11/15] RDMA/mlx5: Enable relaxed ordering on ODP null mkey
Date: Tue,  3 Nov 2026 00:33:04 +0200
Message-ID: <20261102223325.2115128-12-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0156.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::17) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA3PR12MB196577:EE_
X-MS-Office365-Filtering-Correlation-Id: 018feec9-cfae-4a6d-a91b-08df39318283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261102123227099003|261021121427099003|11063799006|56012099006|261009223027099003|261028144727099003|261026140227099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jfBVRaNGLjY21HulLlZUq20Y+eHSZAjquSHDlzyCaGDoIE4nK8DkQ2n7bJ3EmgkUlprmISJHlc6yQG1GlxtE6lWX8Zw4WP4n8/Vji6r256XX5yr9MN48XL3g3OtK/+02qfBVvqstJBOUEK2q8Jd/H+4ClTKtexC8GNUL8r27UHa1sJKaBwPOosDjfbb+xJVUKwHGBNitPHdBXV+qohy7RjfA1cdQC/iaIEX1987WY4O9V74Va3Y6ClOR+qP1OTRmuiZgtOWgvBP/jBrZqJfatR2fmp0RXpIDZeEkiB1lsMo46sfU4KPs99rRYTLxz0SdxDKn92DfvAbyO+zPmYz9ulQI615iP8GjghpOivZDBxxTN58EHCWySHcfaFUy1jgEd32j4Yo/v/+pY8YXq95o3UEyTagPZ9AM94jAW9d8tiu+KoFPbNlnhMATZvfF16Nt7e41tw2SrqUOynhSCTKFgP9a4mkWCbtLTrlErxmzC71AMYfBhPVgDxKX0Z52DNZCDq/BzaRYdxdGHbwZ0NG59TBpCxpnALvuwIH0rwqHf+1tdY0hrVKWSRTA/BYlvousno5gBlN6xlLN1WIVyj72ePa3Zs3lt0X6uEh/FW64UL6zk8oihQVi/ObSdDqfAvdhqpRJgbEeObm8XVYBE/EVp7zupWQWBnKDsXgaJu5S1iw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261102123227099003)(261021121427099003)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261026140227099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2aqPcpA6glxBp/p/cjbc1gEujojgFoF7s4DS3+614z7YzJ27fhh4JpWa8UFM?=
 =?us-ascii?Q?btt7K/jMc2fWaZUr31ohb7I05xkXtE86p6ZtzCMLsB96Ux8K8U99MusImlLo?=
 =?us-ascii?Q?iLjnva3tksuvsIob4BAmxnytq6H27yVGidm+5EGlSdeNV8JCOwcoXWtRKxrX?=
 =?us-ascii?Q?MeLQPj/LiuOOjNVgbOQI819ou9TviF9d36TRpZvr0xh9lE5U1px9Hze92Ft8?=
 =?us-ascii?Q?dLUAnIbsl9E21N5lsG7v79OxlxW7vhkM6828HM99pgYuQp9cDaFBH/DYHJd5?=
 =?us-ascii?Q?HW4snPx3bfrHLNIt+Ef6rcuoDZqk3USxIYoA906lZ7IopNCIKXgl77jTKzBP?=
 =?us-ascii?Q?mXBjcw3MblG+E1jem8gBxZFE/zEcEphxBDKVHVUGPmYhYLm6atYiLFB1clhq?=
 =?us-ascii?Q?qWMf4j3+kuIFjQUV+QLJ3YyVD4RmD1Dy8hrPalO0oY9e7lgHw/st8hM/IDpS?=
 =?us-ascii?Q?9rzR+uIhMQI+vn8vZUKyP9XPjs8+KdVp170EQ4VGL1sWyzTOQd8bN+CznsZQ?=
 =?us-ascii?Q?Bq570kT8mSqKn5V4D1Kc9RWg5eWsqMylnrZH5nEFHv/bWT8HXqpAQXdircx7?=
 =?us-ascii?Q?/9Bo8IskWwUS0j93zy0QqQfpvjl3koAp5Gzg1X/QbfBqe7UNBmMS47au2sW6?=
 =?us-ascii?Q?/UzcNiBsb7fPZWtfXfCHFbDfkDXv0/+6SLZakFgvoHAa417BPwb19W9qwPhP?=
 =?us-ascii?Q?vOce0pNVUjTnfG7fZKcH4+Z4Jy7ILqHg8l8Qu0n+BKZjWRiuvThLOheFG5MY?=
 =?us-ascii?Q?0Di/csfn1WZGBa3deezD8iahVlkE4+3FAowhIvwHkLs5pp64GONODh1eXP+r?=
 =?us-ascii?Q?9ygmJ8ynrc7H6FlXSCqO9R3HyeNsSBUMNK6jDp/MsSXMdP45DLWE1Fo0dBan?=
 =?us-ascii?Q?gXxmuXYMUHnCRvM3d+DWxyvvYIt2hSAz9RBoeddc2L0n4K7MqvwdNo8xJiuw?=
 =?us-ascii?Q?TApouXyH2oHHug9e65mRfoueXYpCMF9ZuEFTI6a+MrMUbgYJ/papKR/Z77aJ?=
 =?us-ascii?Q?TMFj+ikTcf5J5sgqG/krS8njHbas6mzXl4/+D0v9YpLfjDKbBlsXs9skpGra?=
 =?us-ascii?Q?aTbeTTH7BpJs9sx5BaNiOA4Fay1nQfeweFdA3mnzDmIiJArk9KFt+xoEQaOa?=
 =?us-ascii?Q?dKIWiuIPC60ALlvUYvPNOQ9qwB6rBTBRtKIAIrtJ0IX8fIToR/ttaKXV4YNp?=
 =?us-ascii?Q?PeydwJIfm0DYCy6Ycm1QVimGTvrzxUXBvPfs9j3iv0PFhBWooUMEAPN8hCg5?=
 =?us-ascii?Q?a4K0f1UW99PbLEaMS6DPG4pv4SJwfzdX+Ki+Xk0tHuNhbhJXNZGl9oqXWJol?=
 =?us-ascii?Q?y+EbqR9IPa/XtToXIyLm4DGxL4ykzqY6J61Gj6AS1q3zhCJ3LkV0k8YTTyOt?=
 =?us-ascii?Q?NI1PcB4iz0n8pYAtfJXoqFz0zT+ZJDAVmW75BzT5+fYK1RzxXIPNlev3pBkh?=
 =?us-ascii?Q?5n/2+oT0HP6/y4qdF3VM89VFFYvHf0e3eeQiBh2RdbhKAU/CCz9Lh7YjCsGH?=
 =?us-ascii?Q?m8UGBsLD/SCN5U/zhBpbYi5Ngd5zZgkx3kYLHaJgdyd2mmBYXSMv5ZKQL0yO?=
 =?us-ascii?Q?okEoN7lLykppa0D4wnGhUmF3syxohwDbkpH1Aim4Rp9F5vnP61W7+1aASGJH?=
 =?us-ascii?Q?5JlKnLJaylOfQ2jv1KIGtH/oIam1kFsluFkpaSK1Y5QZHNFii1Bi9EdhcVTD?=
 =?us-ascii?Q?Xh2BhHM+++sJO+AU2Pa+rjNQnKxXjhv6weYlSk7oWJDGhmJ6AO2G0AX8jFV/?=
 =?us-ascii?Q?2EO2o8QZug=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018feec9-cfae-4a6d-a91b-08df39318283
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:51.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcXFNpKiuTFPTXl3jGayrvz18X3geOFZavE502ymG60TtPDLpaoXFF0prugeJPXLkBbCAZh1riHhEwy7jq6uJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB196577

Enable relaxed ordering on the ODP implicit-MR null mkey.
This allows supporting implicit ODP on HW that restricts memory
registration with strict ordering.

No functional change as this is a null mkey with no memory mappings.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 9c91e76029d4..b2643ff871a3 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -579,6 +579,7 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, mkc, rr, 1);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
+	mlx5_core_mkey_set_ordering(dev->mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 	MLX5_SET(mkc, mkc, free, 0);
 	MLX5_SET(mkc, mkc, umr_en, 0);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-- 
2.52.0

