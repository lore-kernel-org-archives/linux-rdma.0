Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658912;
	b=v/4ohiX9NpvRjCR2gSD2Pud/G0p/GxmpGsoKF7fwvrphuUwcDqdw96mecA/chmbW6Bvh
	 j2DAFXxFdX+rvRp2LSF5tMdxBVG6QeB/5MeBaascrKz/TLxa7PeZMido2+BdZy72SuiQB
	 iYuN/86isDoXNh/pikOSuUfOnolG0k4lIQQRPBf05CeDTEU0XZUAJhqqikgCNEagXusxF
	 jP68IvFtlpYbczO+gsfq2WTrxrkYiZ16rGwVvbIHCVNNOzJYScnkCgcHF3W0KxMMLWh1M
	 vgTv1IMJsWRX8J/ciToIn5O55fucvcOkFNQUUo4aGl4wRl9wtp29R8+27lwFWdscnCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658912;
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
	bh=ca79g+FyleUbwpV7pwEGhJ0T8HL6+9nJv0ooH0Us440=;
	b=gbvS6cJRL+bPkjmyYkGzulCtz6v81rD6/CygF/ZFDpoGWTD5GVhHt5HkPLCWIo/Ysobs
	 HMe0E072R14jDUidMfV6+kNUoMX+09wuSHIT6Iduv/y6RLys3war6lXddmdUL6LotvjgD
	 /hZnp5eGrudidvtX6JMmVNe7muGc2zYCtrl7wse3RA5vQU1cp9+HW/37a5/T9jTWnkjfc
	 ZECIXYuAI9UfeiQak/Y9nyieFacR5y2xKPA/vVRwX+Rec3gTKx6Uk9th5H6w+0WiMSx+l
	 1FqefQxQ/BIADsu9dWTDGnt1dZjwQZZOVbNjfuqs/5L5SOAohsSj7yUqDlD2iZpqjrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="PK/Jp8YW";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.24
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5A606A32C;
	Mon,  2 Nov 2026 22:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79C5A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PK/Jp8YW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2DSXoJ83pmAWaEbk7R0jqCa1OsxAP7HL27SkCE9BaYoYqRSouuwpYWqGVxSJHdDPQTDAs7JgEGgq1h5HIla+IroIvtqYLXRZ002JOdfvuxevo9cGNVQ6Ed5qyvP2BTuKkgmFzoqcJGwQILmGJniHdwKLGnwZpoiaFgV2pIjZP4xbbWAQbIOyYwzUBx30I29b/xOx6HhDT/MnCY9rs9jMeJYaqE6LSntyiivSrr6TCC2qGEACx7ci+e9raZIt8ZwY22vXAm5Lq4IgPSDRXvz9meTJKcwGu9PQ60G9G1B8kZWizoGjgrba8Yy8d0FRtNfeDudBLii4T2qGS+1ZsaBiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ca79g+FyleUbwpV7pwEGhJ0T8HL6+9nJv0ooH0Us440=;
 b=QXC9av7JHpMnRTpHTT3QIhZr0xca85wLNFplgHEJhrj6+9JUlls7m513Z3xPPxOADbbgJkVLs84055wnwAO6Xj7RtXJqcuMaqbMPpZPTSNjD3d71RvHH1Nt/7UJnrk8p9oiudPyku70CND6SaBeE3e3e1P7lU1oRa3xRZGfBobmxX09cmddtX93Crs7ynUXLX3FnLhjz5yYlcVgxuUGEEhaENOTcTMDO6sexHpN6hI4xCn2z04ePxE9VM0kbkhCTty3MOlLUEBTCtr0UcyF8qeEbhZLu89WDmlF3CZBm4CgtrakAo0GEfmIHyidyMxi0SvsNHDwp8rBj9MgMF0vH5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca79g+FyleUbwpV7pwEGhJ0T8HL6+9nJv0ooH0Us440=;
 b=PK/Jp8YWtv0NqS0/Nu98cFmEdlZRYztT8wdyJi7/VztbzUEVT/HoCMsucpEH2cZCpqE/13ZidGESqPaHY7GvU2B8LzvWRelOwv4DbnyQXAfDDqtMc4ZbADL+39HiJVQ+nqpSjCR7ZQl0ZubrDyfKkAWtAuG8sO05cjLFv39uT7drHFLuWb12fpFuNQiCn8taYrY+WD48wrZ4FVhZ76FAI5hOdRovju5e8OhNqLR5fOIV6kjWY7P8EoKc9RufJhthiSPhCqMkfc9fpdgymoMXn0T1h5/LyG2kdbRNBurF3musyhcJ9zSUoJaznmXojiULpDYYVNCN47i1TC1unHmymw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:35:06 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:35:06 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 14/15] RDMA/mlx5: Support new Unordered access flag
Date: Tue,  3 Nov 2026 00:33:07 +0200
Message-ID: <20261102223325.2115128-15-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0006.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::11) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d6746e6-3232-4b45-7172-08df39318b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006|261102123227099003|10067099003|261009223027099003|261022105027099003|261021121427099003|261021123027099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	nb2UGswhbvqBFLAHcklaZaXGPeKVzRF0V/TgYAh4gtpTtQ7ro2kcJVzDjeKMJgS4/DxxE7DWWfg1evKRPrwDqzo0FEcRw9JH755g9azqZIGirN+GIvN4XmULuUUqxmSJ/vGv6M4Zf8MUluHTYxeD+QKH1jCORPDU3mnEHNjmaBatZ6uvW58fvURTeJWh4BUmGZoyHQEDu+Sx4R1uYJI4J6C7/hY5yFdzTa3DlQtYTC8/eROWLE/EVFVV/bYHNUPCk/0daFZ9Eih1dIsn+LHni+rYPL5HfV+kfOzPoCx+ptjNYTUgIGTWt72Yp9ENZI8c+lpi2871YdEh31iQTpQIMZqNtGZyBneF374p8j0cAwUK3JPRay/XNBogL82rny+fIp121qp+KQjFjZaw10T9/jcQeM+wbg5cX9v/o9bmfILyM1TawOoHoymZBL+D12V4Tj32VmXLY6BdQnm16z+MmRikdZLx87g5bxt1/ugJJ2Z+9Go0qd892WKvGLELNAxX6Np2R/c2fA9EX/2FN6AWkYP5Srr3gisGyH5x/tSlJlZP+g2c0lb2HVRrcuFt/QlFHDnDMRGiYV5e+5WLneZdkDgdAH/0HYY92pBj87sbw3i5aJ1tCGNgwmzVovjqaqQeSVbDcG6a7j+AEwUtsqMijS6ovGdQsxqxSqfGPu2oH6Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(261102123227099003)(10067099003)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+56rgxzxh7bS240eSqr/R6YIeaWb6I+1Y4ydNwGNSlW2J/otno4fwn8U9HTR?=
 =?us-ascii?Q?qFuEC1Nl6P782oFDWNdR2vZACZRhwRN5xZSpv18btVEjLUeeJBE4IV2NGqyW?=
 =?us-ascii?Q?P+IB0S8tbIik7OFuUjN10vJcKgxosH124aDAPyWe1vlKWtwU51kIHbmA566/?=
 =?us-ascii?Q?/7SY1LAADpKzy3ygA27PTNOkn8iJ7fr8q9/CJ3Tq7B6H9+ji2rcsZXskqnZR?=
 =?us-ascii?Q?b4CEnlD0VAgt/Na50Nr5Hj2YjREpjRKRDkXkdyZUMpuZ9MkRNjjHHHm3KxtA?=
 =?us-ascii?Q?qSq2uX+y2mQ8eVRRaXCbISDq83TgOdSTGxfxRkUrMJ9x3XELFXqxq7kp3ChD?=
 =?us-ascii?Q?hYXLPydAHM8Yp3d5O3Mbsc1xiboRy53tcfJGZfy2r34//MTvD/Xc2VJ9bQ3h?=
 =?us-ascii?Q?2n5vAZFSfqo5hsi3uFdqibivVJHap5JbsYqlSmB5pQhzvQhnNDlhcze2SlKp?=
 =?us-ascii?Q?CFbKhPE6njTmZxk0T7B79yV35JHGkJZbEa42voDZKl0aohMCACxXxwl90Sud?=
 =?us-ascii?Q?+eDUBZNbHED6BzekRFxPKYAERA7nYIfnNDm/UPWWl1w75rHgQvvr2UbXw/Oj?=
 =?us-ascii?Q?clA8yQ66LKtxLVfrNccM5iEYqs6AaPS6WWX6sKPbAry5C/jvvgYBu3POGuab?=
 =?us-ascii?Q?BCxeb5k7er7YwNb7U/oJ6mBtdholxrEc0I0a4Et/Z5tLYnfFKoyEsm3fT68B?=
 =?us-ascii?Q?Rw93/1umVhM0oGu7QjU5rk1hyUE6IaaADdPExsTt3GqV/2bneWVTx+gDlAZM?=
 =?us-ascii?Q?T6Hn6YU9g0CNZwnhkFigRZHLMwkYtdN+g5ijP2ZqLrZwnu76ufBoMMayeHb9?=
 =?us-ascii?Q?7z7Z4YUNUbts7qULJQQaBt4mccmhOuV/A4r8Aq9skTRpZwLhMJ94Yu9JoV7r?=
 =?us-ascii?Q?E5bMM0REmwfNzRoXWET7rzeq3nFyh2hevZF5RpGvFQZUbVV1kEq+8M45XUmy?=
 =?us-ascii?Q?eL1FKeOlMcMX6+UBKIyagwz3SnptPicqSQEq9A8Q4W4yCxQh7LMMnDcpam2U?=
 =?us-ascii?Q?qPfYz8sgxT8urOLl2/y+5whKo0MaHY7Az72OLjozOyJgHySfd0agp0aKRbhG?=
 =?us-ascii?Q?8IVhDo+v2qSpf/YT6wAGWc8PXz0vFadHMPNdmf6CfVF21bfC761NdA2udgdO?=
 =?us-ascii?Q?4y1LQ/yOSTZClUbWvwjgMAIzlQG448A67bJPuVknnaWu7YrPq62xiJin04rG?=
 =?us-ascii?Q?m02e6D24oGjMrAQzgY5IDvTs6ld9/kLXO+VLvdZXlb/9673lYBteD1UgDAdT?=
 =?us-ascii?Q?NxgtKv/AVlmdqV239u5WegmRK/gyYWuTRFBQcjgPmyv7L4m8X6Ry4IDD8j2s?=
 =?us-ascii?Q?1kVT88bwwu6GnQPnZDHfDyB50c9NvGfT5OsfxpUR+gEZEHaORlGBrPYqLxO9?=
 =?us-ascii?Q?oBO/n2K2u/bUjEitaahjuMuGsDASaniOv+63t6LXdCgZ9P9jw9LA9D/weeaZ?=
 =?us-ascii?Q?G7si1ikCo7yn269Z3yIOIlN9yXsclym1ePBgKSSaVedYQiygeus4HeWlP1Wk?=
 =?us-ascii?Q?FaJINXBBGaGAz/UCRRy4kqzzWLfR6YS9fH84K8hWKrXBI5E5DZUL9KJdludY?=
 =?us-ascii?Q?rK/XkDfb64EU+UjZaq3oeTG3uBFTrkaKLzyzg0ujFszMykz1fKQGBkIJtllK?=
 =?us-ascii?Q?oqKLxa2b47wjmwFYDZegbfHAzdSvbwYgNuWxs+9O+07RW1ut8iaFYejixGE3?=
 =?us-ascii?Q?wfubHbhb2zYtg2q9i3FzDsJBspfyi+GK4gLTc8qNiI5+MLc5JPsOtFdqHJdN?=
 =?us-ascii?Q?cme6E3r9Sg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6746e6-3232-4b45-7172-08df39318b5c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:35:06.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zzgry2gJwZCuIJHcR9p2LV90m/+bha6XKeoZ04eWGJfXh61p87tONAG0FFQX02l+qws4tBg6qj+pujttask9Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

Add mlx5 driver support for IB_ACCESS_UNORDERED, the new uverbs access
flag that enables relaxing the order of read after write on mkeys.

Map IB_ACCESS_UNORDERED to the Unordered mkey ordering level of the
mlx5 core helper, which sets relaxed ordering and, when supported,
relaxed read-after-write ordering.

Extend the current enablement of ATS over DMABUF with RO access to also
enable for DMABUF with Unordered access.

Mark IB_ACCESS_UNORDERED as non-UMR-modifiable: there is no UMR
mkey-mask bit for order_read_after_write, so UMR cannot drive it.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 +++-
 drivers/infiniband/hw/mlx5/umr.h     | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dd1fe8fd4220..75ea3f91e931 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1672,11 +1672,13 @@ static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
 {
 	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
 		return false;
-	return access_flags & IB_ACCESS_RELAXED_ORDERING;
+	return access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED);
 }
 
 static inline enum mlx5_mkey_order mlx5r_access_to_mkey_order(int access_flags)
 {
+	if (access_flags & IB_ACCESS_UNORDERED)
+		return MLX5_MKEY_ORDER_UNORDERED;
 	if (access_flags & IB_ACCESS_RELAXED_ORDERING)
 		return MLX5_MKEY_ORDER_RELAXED;
 	return MLX5_MKEY_ORDER_STRICT;
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index a6c4f35b75e6..78b91d614a17 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -49,7 +49,7 @@ static inline unsigned int
 mlx5r_umr_get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 					unsigned int access_flags)
 {
-	unsigned int ret = 0;
+	unsigned int ret = access_flags & IB_ACCESS_UNORDERED;
 
 	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
 	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-- 
2.52.0

