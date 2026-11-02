Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658834;
	b=qatQhsaJghhIv8saeyFuKCNLe+Esx35lZwfKyy9Wxoztill/6eOYCmUcWt8jUa3MX3PC
	 DhDgvjzS5s8QEHjr3iVbGsF9+DLqjNI+jcYVDCKDAnud4tbw8jS1loNpFTDi1dwKqsoyY
	 AjdfJMmzRPjNj2ezW2au0brOFh0GmgOnRgKT1EWm4LzCjf86s6Htg/4Yhr6V7NytpBkzF
	 KAh3AydnYp7iriAGt6++7Hc2HTkqddpKdApAt63wB3N+qt4M0wm8H3UlfauIEX78lQ/N2
	 Uv1pqLZo1ytyEmT7IxqbhqsKD8YbVB86Eel/J+wVTsE/H45PsFLWOAm2rx+NB+wwbNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658834;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=cTZ/Wpg+WPs3RgRnxjlGKxQYsxRWdSq7xlQZf4SzG5I=;
	b=n06VYCzLO5+fCxuvTdhLe6fB8yw9jndIAWJSfasrNDZwDDMAO33JKvD6Uy3zIEpnIZUS
	 tAD4UUWbOb+Dj++9Gw7cc1ixKf2dw/aK819ZAJNCImIrErpKDHO07v1xIcXHLMU26X4V9
	 R8jUWVEitv2aBgptQfV32dkbWinj8Mu0khyQGN6XAybfFtvvg+CCIuEiLutTY2HrL52g7
	 jI2sH+1gJC8WPJ65fNwhkJQ0acm9CxU68K8iZ6yqHhc2TlvrLMb8+msHbVbYDOSJ8TCGT
	 8Zj+IhuKs8bKfR09r46S5WQjkbNbmVyNn/6ge6bEMqBOw8sF5bWKvVS6SOWC7gAi2Tg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=djtOxh8y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.54
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC874606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 22:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC874606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=djtOxh8y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wL3dRZc19iVLtRNISQK0XvF0B1N6014q9VDkhnRlRKst+eo8wIbkC5Fc75gSC4XNseBatSMd4JdAXzAEQy28RZxHDWPPtdGq4Gd1ISXF+AoW/CdX2U4XWZ9arXAQ7z5zYOIf25UMPQKizb6CkulT9X7ib5wpFyWRRqOq5u7VCi1FEsCbhTMWwUs/5YOB/mEsZCTJarQRadq0h4ztUMe34dBU/exyNw7lBCemtGMRS0+0V1As6382ZGWpT8wRQ3JwareE3CXBDCI7kiyksD2ha740/1VwT7tINn1X6ooVFQqT+SvFeUsR8olZh6ZXAWkOrAxSQVjUZQ7CAz7eyruNyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTZ/Wpg+WPs3RgRnxjlGKxQYsxRWdSq7xlQZf4SzG5I=;
 b=q5UfxaopF1XXdAf4gb2iGOBdFZBwNP/w9Huah629pLMZ6euuAv5Qltn0T8XuGS3EY38uEyUxPxN0dkGySIXt8JWIo4/7muXQ+YbE0LbhiYqfLKUUlP7nNkxDknU4KfctPeWk8aTzU5lhDUhcXNfLFEuBFaUDBeZom+z+59B9IsQ0LVIdz0h57QgwhnzAlG/uBsr7QpeEOlcDeMj1d4n9jlDrbaBCM1QLxX/YZrPGF/7clWDA0CQ2NIf8mKJQ223qIjXzQbGyTNI8gmsvblBn61AnzGcm9E4QqyKqqL/TrBI460UowxarEzaNGPcGlk3ETlexvZS2a4vCX1NMswq/Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTZ/Wpg+WPs3RgRnxjlGKxQYsxRWdSq7xlQZf4SzG5I=;
 b=djtOxh8ysZza7GD7XgVvbzWAK+/NmKX9j2wNajcJDcJU3qeZ4c0rLHdfAYWrduYA2Zx7LZnVMeW80t2AMBQ2nkRMiQlH/Au0NowGEWqMq2a/q3FnzQmZJFf8ecTMn1bJxu1bjuZ8DSPzcYA3XEIVN2tQmoaLxVPAWOUgvPKu31nnsKMdD0YjS90BUYx5N6yjpmeD7J6/1EOxjG+LCgiuMiUwI73vuCd9onDD+uNS/8uqfD6goohHWI/PHlHHWV6KVJzYXz5KAGqj/m6JF62pavPWGDtZWH/6jYpugsqPjQujr+Y2Nubzgd8eP1kYtwEFWzxRZLL+mY8XkjxmK24cHQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by LV1PR12MB999305.namprd12.prod.outlook.com (2603:10b6:408:3f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:33:51 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:33:51 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
Subject: [PATCH rdma-next v2 00/15] RDMA: Support HW requiring relaxed ordering and add Unordered access flag
Date: Tue,  3 Nov 2026 00:32:53 +0200
Message-ID: <20261102223325.2115128-1-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|LV1PR12MB999305:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f102d0d-8643-4d04-7c41-08df39315e6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|261102123227099003|261021121427099003|11063799006|56012099006|261009220027099003|261009223327099003|261009221727099003|261021123027099003|261009221227099003|261009223027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|10067099003|3023799007|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	DLVn96c0pWKBPpiXPbjAHfk6z4/+pPFmwqDFONyt61SM7550BsNrLzbmffTxVzMJGodQhQkM5f7gnT0kjwOjYBl+/lELDu6gLu0zXLD+h5H/NiCHdvGZzjgJxS6msJ+am6GGsJZ1ZDobfGjFcRR5amAUPyG8HFoRUPAgRJaowT5eWux1d3WOcYDTpUDD89pDen0P4H6+1/CXdrcQNziYCod1L2xV8JwPwjEXbfqwzkD7vg4LsWZzZ4y8ARN3ccwF/v9Oclw51KQ2txwCUyxekF9TDwW70qaJUWyVOmieJ/pPJTKZU9k+/dNNRtoZzF/d8xx0ls5VfyPjNtjDoMFXF342Ot3Jx4D714Tp96jwma28Q7GsjfIGo2vC0RZvN54Tsy0OEl9mBbK7FhThVpuAimOEE8zkjzioO1QA4BR8ITvixfkBWI7Y2rVcRG2xbTEOiS6JOznm3x0O3mRAV6teUbYXf/UWi6yhm0v6XXpPzwcEA1luatIggCL5pCI4a/WUocJGH4TzLlprfZ4bGS7D6dWmIw7IN+dwMENVP7LlU0lWTXZtiJGhy4G/1uiwhIWrZZwgA4dQrgp7mGagWU4eKdpVggjkyXsaY4mEyJDZtwtcSUy1ZuPrBPpf7uQUYlGwGvAKANHGlKRP5Hd1ncR1D+nTsP5+6Zu8J8qK1//tC4w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(261102123227099003)(261021121427099003)(11063799006)(56012099006)(261009220027099003)(261009223327099003)(261009221727099003)(261021123027099003)(261009221227099003)(261009223027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(10067099003)(3023799007)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e+jq5uii5Koxwjnk1EnoPjpBSp1Ixjh6zTowYBJfP8/hpIPc4QEhFtZnUzZm?=
 =?us-ascii?Q?5MX2H3QNCAMrJvF3+0bu8Shbjta7QbgTduG1di++8swLepP+4QFSs9eUePsz?=
 =?us-ascii?Q?jzCCulwI1xEr4JN71pwlKM6bIM5Lqa1mPdP9VG1fIUeASEGv3LTqjYEBh2cE?=
 =?us-ascii?Q?uxFmGuioz8D8tgXnAkcnRrThx4bmkTN4D1Og2jxubRzs6s2dovWtmmXEtQbT?=
 =?us-ascii?Q?Seq78ceFRvC2JteKofaXja2jZevTIZ7vsOJDNcA4jWwkSk59H68ZWADsTytz?=
 =?us-ascii?Q?0MVlS3ygj8hGR4LfuEt6GIq8xArgJJlTrUGdCLRycJbT7q5cIYneApHnUIf4?=
 =?us-ascii?Q?jGuFsmnKKtXJyi2zQV0XaTvkDlr1XkLuPWlRPZbNyBineKHDOnWQOKvo/++s?=
 =?us-ascii?Q?C77TtJ25eF2bR1NEGps8d3q7xmo52z5jt0AtVUAmW6xclU5w/kJt1QF7PzRm?=
 =?us-ascii?Q?84cSzVgLIIFC9Ot890ncO8646VzeV4gCHLVMHO18pRbHEGi8Ukq25b0szM9B?=
 =?us-ascii?Q?sd31cN18LwhwzIIlaqhKTsv/rRpWswm6YFWo3M0J1A2Xb/ChaazKpkJD92+p?=
 =?us-ascii?Q?BsNUmwQmr6LiZqW/jjvnhqVCiZohC2bUoTvLjvjut491FEfdcCUELWv+pNih?=
 =?us-ascii?Q?i6PGNRKeVO+s/yuZyJW+EKDKG5Cb06W2Z33+/Q6M0XaUKOKO/c/BU7eowWN1?=
 =?us-ascii?Q?Kg5vWV6QuijZAR6GLxlKX37Q1K+hg7QWGoZY63DguTyzcTqT2ECejjHlY5b2?=
 =?us-ascii?Q?aD5GScKzISSUqxhplqFxa7EzlHYHMtnw6n7So709tt6MbS22RaymcYyqkvXd?=
 =?us-ascii?Q?4c77vo8UjOt9DoPBjBb08JOhsHtoY8jXdtasBf9slYjZl0fHN+AqrL6yCRi5?=
 =?us-ascii?Q?1i4ZhpY6EHygTWOQx69cRdTZHG00NlLlyf9HhwI5W0ijJjABPIxqnvDVa0bv?=
 =?us-ascii?Q?NNkSuI6yLL4YVjwOpPq8N8XhA4Csc9zuTIK1hGgzVgc+tvtvjw/u/nK6o9cL?=
 =?us-ascii?Q?8x7ex40t7MdxU1eg3Vb669eZb5f8wvOFak9afdRZYmHT+P4U/eg4tltVtycA?=
 =?us-ascii?Q?we7qePPBF/S9PGOLk3gZS80G5rPXCKl3zvX+waXZlly2v1smqyKHijBQuBD2?=
 =?us-ascii?Q?ejFgojqVUtg65bQvDVzze1LtRub5cvWJJPF6gTL6Zr7PcGxFDC3l2wg/9zVg?=
 =?us-ascii?Q?VXUG8lvnNlJ1yDRfmjDK+ER0rJDMHqUxJQMJdN8WvHmLoDRAgtTLpeCmUeXH?=
 =?us-ascii?Q?46Z1YGyBdb8aI0W8q6mVtNrDbHEQlp/gkGMjixh2fH6vWmeCONYzNJjteD/g?=
 =?us-ascii?Q?NQI/Ilu4QH73hkepSyP7MAw6Rbs/WA60ybkAevSpO4sCHDUIxcfttfmVwMOc?=
 =?us-ascii?Q?xKPlqgohk4wi4rLYpnBEOy6J625nwX3CjzxrIAXdhB4iqerbIaai5FmA8JCW?=
 =?us-ascii?Q?zj8MY1V5u9qNHrpSNSnW2hOcJecI6eQj0EDjeGwDX/E2Evrjbx5Qvzp3TByC?=
 =?us-ascii?Q?sPUrh2nZT7qQh3LYhWf8nSb8EIptds8NTbzpiXOctstb9ywu1FSS18IbxWCY?=
 =?us-ascii?Q?SaA2IQricpIvmSTvXNbWsC2ILRf2AHjGPFDNm8pPvqp8xuWBRcwiddRrufFe?=
 =?us-ascii?Q?KGbi9PxphaRyIfPN7eit1M6ESUpMwNZT3hv3ORGFxyCXfS3Wn3EddfFnSAEp?=
 =?us-ascii?Q?I0BY9gxeh/XmLPWvtxENVmKICKTmVtBUP5Y4AUbN70/6rsLCUW2UrLHsy0DJ?=
 =?us-ascii?Q?ly3xTORzSA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f102d0d-8643-4d04-7c41-08df39315e6d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:33:51.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KW0gQhCtEzUQV7NKBXsCf1KduaHdipWUE0hUolFSKBCRTEP/QO58VsBMgdaxDOEPxgJtZfE/6o/8ReEuGKIF6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999305

This series prepares the mlx5 stack for hardware that restricts strong-
ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
operation ordering. The HW may choose to reject creation of an mkey that
doesn't request relaxed ordering, so every mkey the driver creates -
internal and user-facing - has to be handled accordingly.

The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
as will be any future PCIe Gen7 UIO devices.

The series does four things:

1. Allow optional access flags on all memory registration
   The uverbs ABI defines the optional access flags range as best-effort:
   drivers must accept any flag in this range and treat support as
   opportunistic, never failing registration. Several registration paths
   (DM, DEVX UMEM, dmabuf ioctl, reg_mr ioctl) did not allow this range
   and would reject such requests. These are fixed to allow newly added
   optional access flag added later in the series and any future optional
   access flag.

2. Groundwork and internal mkeys
   Rename the relaxed-ordering IFC fields to the new naming, add the new
   ordering capability and mkey-context bits, and consolidate RO-setting
   to a single helper in mlx5_core so all consumers share one cap-gated
   implementation. Then enable relaxed ordering on the internal mkeys that
   don't require strong ordering (resource dump, vfio live-migration data,
   ODP null mkey and FW tracer), so they keep working on strict-RO HW.

3. New Unordered access flag and enforcement
   Add IB_ACCESS_UNORDERED, an optional access flag that additionally
   allows read-after-write reordering, and wire up mlx5 support for it.
   The rdma-core series adding the flag, with its full definition in the
   man pages: https://github.com/linux-rdma/rdma-core/pull/1780

4. Enforce no strong-ordering in user MR registration on HW that requires
   it.

Changes in v2:
- Dropped the patch that enabled relaxed ordering on Memory Window mkey on
  strict-RO HW. Following Jason's comment, RO is not enforced over indirect
  mkeys, as it takes no effect.
- Added enabling of RO on FW tracer mkey, setting RO only on HW that
  restricts strong ordering, to work around the mkey creation limitation
  (patch 9).
- Following Jason's comment, extended the new RO setter to support setting
  the new Unordered access as well (patch 7).
- Added RO enforcement on FRMR 'set pinned' commands (patch 15).
- Link to v1: https://lore.kernel.org/r/20260726092943.2880176-1-michaelgur@nvidia.com

Michael Gur (15):
  RDMA/mlx5: Allow optional access flags in DM registration
  RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
  RDMA/core: Allow optional access flags in dmabuf reg ioctl
  RDMA/core: Allow optional access flags in reg mr ioctl
  mlx5: Rename IFC bits of relaxed ordering fields
  net/mlx5: Add IFC bits for new ordering caps
  mlx5: Consolidate mkey ordering setting into a single core helper
  net/mlx5: Enable relaxed ordering on resource dump mkey
  net/mlx5: Enable relaxed ordering on FW tracer mkey
  vfio/mlx5: Enable relaxed ordering on the live migration data mkey
  RDMA/mlx5: Enable relaxed ordering on ODP null mkey
  RDMA/mlx5: Converge UMR access-flag cap checks
  RDMA/uverbs: Add new Unordered MR access flag
  RDMA/mlx5: Support new Unordered access flag
  RDMA/mlx5: Enforce relaxed ordering when HW requires it

 drivers/infiniband/core/umem.c                |  2 +-
 drivers/infiniband/core/uverbs_std_types_mr.c |  4 +-
 drivers/infiniband/hw/mlx5/devx.c             |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          | 13 +++-
 drivers/infiniband/hw/mlx5/mr.c               | 76 +++++++++----------
 drivers/infiniband/hw/mlx5/odp.c              |  1 +
 drivers/infiniband/hw/mlx5/umr.c              | 18 ++---
 drivers/infiniband/hw/mlx5/umr.h              | 45 ++++++-----
 .../ethernet/mellanox/mlx5/core/data_direct.c |  8 +-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  2 +
 .../mellanox/mlx5/core/diag/rsc_dump.c        |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 32 ++++++++
 drivers/vfio/pci/mlx5/cmd.c                   |  7 +-
 include/linux/mlx5/driver.h                   |  8 ++
 include/linux/mlx5/mlx5_ifc.h                 | 24 ++++--
 include/rdma/ib_verbs.h                       |  1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |  1 +
 21 files changed, 160 insertions(+), 105 deletions(-)

-- 
2.52.0

