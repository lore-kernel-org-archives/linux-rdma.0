Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793104394;
	b=vQzzioUgpFQnZShh5d3q9Ri81UMmOYjFYB9UevbcTd+Q9WTrdBYNHWDIen4C8lio42Zq
	 o+7LuMw54JQf5VHbOeQdRiwFanLEzvWl62l+Wq390kvu0B3m/u7rjlefMszc08jlvsPyF
	 fmHLnIJ52L/tB1rke8Mw+JvbYIEAdMv6eLbUI9YqXRxP/FLf7TB8tLYGNcow8+DzNsMDd
	 Z2QfhbZLfK63s0b2QGWMJFIpbv7B5hxqwmOl4tbbNcMsBA1WeN61ECYhAtga7SpvisFDp
	 eF9y9BWD/I4I0QdLTaLl9DWHM8w+Rrhp0mPeLp6q+HE3KKGmEuJ+5o04I+d42iE98Ww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104394;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
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
	bh=A/g4U7u9b6r0aToEzspjQ6gpo2V9ysTl/7IBr3mB0M8=;
	b=w3gGtLK6S/y3QRMDwMFt5CfkrCkhff0et695UjvvCScBIp/BOuLY5S0MrM/DT473SBVG
	 wzXyV/rmela41gTOhQCKXKf7JQt3uQgdTCSz2qnHDCnTTPcj8PxtoG7IlQmEyV++EmpMv
	 LS2oeEtCO4mZn2Nc0+LMRMggSidntDnbl0+Yy+Ddm36JcORy5ZwZnmbng2/G4LgAgxXNz
	 xTIX8PPguqbrGFIfnx/FLLp/cSUKijQQr4Sk67B8zfLGnS/MzbAvx68QO5wA6vnqnlLTZ
	 6Nhr8+Hj8U43pe23RjemuqU2AEaBTVaDmjFd23b7NSyCmYrSCCSMOFHL4YXZJHLZBKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AA4iuq4k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.4
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEB0606A31B;
	Tue, 27 Oct 2026 12:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DEB0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AA4iuq4k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLgMqCjS838gFypZVW+l36Ywl5AAB6n9L/2mplSMK4P0OKQMqhOBseYdxJra4JEj+PPJ0s/kbD/NlWysoF7BH9m1izFZzUbSESBEyWftz5GNnCWxwaFN/mEZGgByjIPex2TCP3m3HC0W6Bbvwfuj8wZIQeqRzfPAvUGGYfeA9uQnaDCe6xov3+GtSHr257j47fQfQvRS0aESWkmlm6bXeSOdIdEsYtJ4fCOZVcLaDnlyimO4CCmVJYECjV53Tjupi7oIMiymnV79HCbZNuZfN48OWliS9lk5F+cSUzfpzV2rx9f3YPbrHBnxZ/HSAfbonz2ldNA7XIJgxgndwp7MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/g4U7u9b6r0aToEzspjQ6gpo2V9ysTl/7IBr3mB0M8=;
 b=kk9SVTKeuLtyDwqZecOgy6m6W2sFElHdBpqs2RjcGOt7b1yJlhO/BgoZe+84zFL68VJrZaEBE6vj13E5/GS4sA4GXLuqBaeOqFgSD+2KeQNPkt6Wfm6PekQBtBFjrs3BzWDZKikG6JMOteiN2rO2kFgbXQedUgkV27pG2Cy29zpbw6fYNqni0RYXZcgdYZqKhP6Bj6BGR6/v+oi7sCOySpPoCDlgkXjB4/rsIr70ry7WGP6Xhr/l3FRLm4BihK+98UyyKDddmwfdTdeC/aZ4yvKBNWs58GVOOOiWZB9PahRDCTupvSyakhBKCg+FBgt0+A+qg5pP+RyCODV8rb3uFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/g4U7u9b6r0aToEzspjQ6gpo2V9ysTl/7IBr3mB0M8=;
 b=AA4iuq4kc7Uc6Ios4/vjkdx6bsnVKasf8Ub051cZj+Nu8x7Fy4oY4EFn0R+QVA2eHtGXyUnlrt856O4ayZRfGE/qTBx32VKf5aGecNRq/NzLCtfhhG8MOpZdMrCYGj8YC5qw1mYF79VJCJ20YG7kgQfpsTMM8yvIddqcrlwugOoagCIi3stCFR320FROtBZR/nkoTKPotCQCBwRLc2hUd5BCSTA/oc8/cHW2v87mx4e9mtKjLDojGWb6p5ayNsSbW0h787QSW3HWMpBp7A6tP441rJ6w6Layv0WNAoWDSWwE/e93pxZYCbzqoY3iPJ1wcFhmvWJQgNKfj9zfVmqlAw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB7449.namprd12.prod.outlook.com
 (2603:10b6:806:299::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:33:09 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:33:09 +0000
Date: Tue, 27 Oct 2026 09:33:08 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
Message-ID: <20261027123308.GC1671235@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <auAIO0y09SXk34CN@gmail.com>
 <jB0baKUEStaR7DFEykw_Qw@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jB0baKUEStaR7DFEykw_Qw@nvidia.com>
X-ClientProxiedBy: MN2PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:208:239::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: b5146766-1cfa-4565-01d6-08df3426754e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|22082099003|6133799003|18002099003|261026140227099003|56012099006|4143699003|11063799006|261021121427099003|10067099003|261022075727099003|261022105027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	PlhO8HyPICiiQevxWewSORiDWk0B8bkM+amuXUtdEJz0gne4wotVgkPU13BydXiS1na6cX9aZWGPt2VfYd8upes9EwAXTd16EhnFE9KAOe88doeR8wMSycCo67tboNHcwKg35vpJcaoY6A7AgQvjqVJwybOgJkeIibdqYEOCi2rUPThegSFeSkHK1dO1827VCNpE9eNcaNzMwGjazwR5J8ocEYSS+2K51G9LDCWQUQgEcI0AojTR+wCiW8vCBk8POpqRuLBMsImB0vo37/9RSUklStvpn1vxTowtMd6QYutK7YTn6xmaomvVNfcMiDA6oSHu8Dv+p6oDGKCyYUzzgSaPo9lZUvYFdsJaehP2HoF4kHGS+k2FoNUg0RpbaYC5JEb8XCyV+Vr3po1sX55vz2DRH3YVNm+fmaWnWOuTtbiK5IsEfxm5XYPrPmtZErc04ItPbrkIHVS8jWZL+aTZJfUN9zpIYCezQBu8E2met879tHZSZLLEMiNyfBD6IJRYlC2M5G9Or8fEm2zacpF5fpoy3HOUmWWOZ4I7hwNG42zQwgufbLwqyPViLQhhURknBGLAOrv7VFRE3sa/iA/pmDI3YAvNR2j8vXDE4mS9VRbz/+3Q9lUxXhj+1owtvhHiKuGJHsHiGFtD4xf1w6bqYDp26q64kYJKi4cGIuwqXvo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(22082099003)(6133799003)(18002099003)(261026140227099003)(56012099006)(4143699003)(11063799006)(261021121427099003)(10067099003)(261022075727099003)(261022105027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J1Ha5y19r47IwPQUrSiT3wnIX9C8NNFPzyg0w+utciwSv7PZGmrSaSply0tC?=
 =?us-ascii?Q?k5Xhm/eLqe2MM7AFevOqlg2RmVSy4D2flWEzDlJtMQGIWGttIa312Ok/8k1G?=
 =?us-ascii?Q?7oEXm1gCLyR0AMv0x/5cm1YNKEOrqFf+bCbVaQcxw/CK2yzey0bCnkTY7IPN?=
 =?us-ascii?Q?C8zwEEq2rY6KjLQeB0Mph68ZWZziTfZhU6ujLDPOJ5/AUb8N69pIt6kDpZP4?=
 =?us-ascii?Q?qfcr0rQgjiFyqJkm6tDjCklJy+IPwIEyoPdtKKtyVccyfzlmumn9Tgg8gscd?=
 =?us-ascii?Q?Ea1Wta6uyWQj+RP3mn+kjcjP+htEu7xsYDFG7YTxLag+M3/ekr4qd2gc7B9h?=
 =?us-ascii?Q?i8rQjq2PXQzaRnkyk9W4aeaGoKWbIJKqBqikcAiXvxMxMiLCgdsPhUnrwjFo?=
 =?us-ascii?Q?xC2n8CD3Pp2sbNxDugcZRgAHDHzQpZrn1fKT55jjm4W81ymLqsPJ5fsaVG0Z?=
 =?us-ascii?Q?NXutqsEMEIzrklVspnEQXeN6OzY+463d+DO9mk4ekyD3MNKE4BruqMpN4to2?=
 =?us-ascii?Q?N9y4qLV7SVFyOmWsxSoWOwqOZM2b9MBVUIy7sCQYVSXzuKbt8xa7TkU80TXu?=
 =?us-ascii?Q?Z67CvO0EHSbEM6J8Ez42Ffyj3h2lGctNiWYJy1gFnVDYoGrG8X3pRdlzCEGQ?=
 =?us-ascii?Q?ExabQEND2F2IOu39UiMO28uoTMP9NyyeySH9UswcJmQZ91slnS2ndLfp+/7G?=
 =?us-ascii?Q?mzBhsosobjE9cDFvGviVw3LKMok8cKmPr3jdtl3GtUGxXVraNWZZrJNlB9Ko?=
 =?us-ascii?Q?Sba/mrvK6BEyeixguugSNf7zhvTwpqfFIdESFa1F58V5Dun2kYvWNRuniXf4?=
 =?us-ascii?Q?/1mSB+7pix5DIjlP/5Fj8VnNMhas3NUA5LDSaFOpAmlHdQ+EjEmQ5ZblDb6O?=
 =?us-ascii?Q?HA7Tb0VcbUhEG7MNspXxEmev4QYhi25Vv2MCfYCtgg/rufN+LqoCPT8R5ZkK?=
 =?us-ascii?Q?SQ9e5HsbN8vro0jOq5HFD4x493Q4MHVnPLeWRa/XYO5G8+Jfan183VK1NgRK?=
 =?us-ascii?Q?LBfjd/DaNgPmI18hRagCH/DbaJISQ+UvbV7fuDUaLB6iBq8RTLLjT0voFZzz?=
 =?us-ascii?Q?0H5DHOrYAONaAxywguyjHxk3OfEJBtc8d3yaD5HfoqMytXJVr5Nzz1v4Wt3f?=
 =?us-ascii?Q?/ixkJqITTLfeFdch8g5t2cnH3RO9lmPpR266FzH59EK6+QA6iUODT0aqxy4s?=
 =?us-ascii?Q?DDWPr8scPBm3vxG6VWedaURZFW1Ao035i5GaVoK5pleF3JX0egqU7/zZuhkZ?=
 =?us-ascii?Q?8uD8D/LDGw5G23LJgz06oLuLEgzmDSTHDNG7GCrvojXeiTIqQYKrVLAM8+Q+?=
 =?us-ascii?Q?KXzMTfBOAx/a7vKWhs07URGluN4tCmYQl5Ns+Y8v4T8fNx2UCL5WM8r2Dkn3?=
 =?us-ascii?Q?JwcAoXWMiEQx+BxCH7aL07X2UrxTfu+gWGL8H3yKA1KtWk54I5hwFAzPEiQX?=
 =?us-ascii?Q?zyOMsyu7rWvPGE6SnY2+1rRZaiWn8GAlvwYC7dU/Tu7U0VQWqBFUlhlIwYVB?=
 =?us-ascii?Q?Fs5+JH4PUoUGKAd/IcR89Z22CR3hQSw5CNliSWD7VLUcALI0e//4v21sFMbc?=
 =?us-ascii?Q?u21db5KWvcQT5bcS7isCxay8xabf+f0Lmkx4G85DIWvIqIJ8QcGMf4fYOh6w?=
 =?us-ascii?Q?eEOkU0B5WRQGDbheGQTeEmhN52Jdpgp4x5+JAsSNjmbk67sdUyctZfLe+uGV?=
 =?us-ascii?Q?8Qr5TTWtq/gvX2ZqaOFcUgFGANtUJaIhuzezg+i3Y51mgphb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5146766-1cfa-4565-01d6-08df3426754e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:33:09.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UABjo5sT57RZDvQViATsWuiNycyTtSBlIiJWUg2a6u2NzdTy5C1oKSzdzQkB3qPf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

On Tue, Oct 27, 2026 at 12:42:32PM +0900, Mikko Perttunen wrote:

> > This page-side use predates the series, so the fault is not itself a v2
> > regression. Is dma_buf_sgt_attach() valid for this call site, or does Tegra
> > need a page/physical mapping type first?
> 
> Sounds like a bug in TegraDRM; we should be using the DMA addr/length 
> for the explicit IOMMU mapping as the sgt attachment is for the dummy 
> DRM device explicitly intended to give us physical addresses.

No, you cannot connect dmabuf to an iommu_domain. It is 100% always
illegal. DMABUF does not support this. Do not pass sg_dma to iommu
functions either.

> I'm currently in the process of removing the whole explicit IOMMU path 
> so if this only occurs with CONFIG_DMABUF_DEBUG enabled, I don't think 
> there's a pressing need to fix this before then.

Yes I think this is probably the only way to fix it :| You have to
always use the DMA API

Jason
