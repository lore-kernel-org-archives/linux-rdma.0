Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352254DD3AA
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605355; cv=fail; b=sVOGzB24opo1mb7db4uSi7yGDRpZR5yxTHa1NIe4ZjjxKU+ywjIriSK7Ogq3NFpFaTcDu78KqsX7qsgXfEg8XmUoKMPQDw8KJ9okdHvXcQtedI05wrpVfcP4I1HCZ0/MbS5WnCS/fbgW+H4LxERsmljc5+uYmT6vSTRfqbuZ0ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605355; c=relaxed/simple;
	bh=m3Q2Mo6s1/k7IU6ytvB/klnX9oE3C0XW4abX7d4GsYc=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=Ml9yGwQXV3rIYf+03DoqEVSLq4vVjOUm3Xe1auHWYxIWfK/JXAuptq9Kozgl8vfchOTLmGwldL5BCka7lPpdZC4PEOdwbg9TSrDto55Efuwl93lFqdEBbYsjj7qwXMHpOuKGVSsh/GBcPRq//FDHqWbZFsrNvRUrQ5yIqJIIS5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cTDahEgt; arc=fail smtp.client-ip=40.93.194.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cTDahEgt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yqkgeeorz22vw7/0YPjnK25BH9xJkkgpt/Kfn7OdYzfijzhpolkzI4x2ObbJihetxVM+CUXtSdtt5l7JhgjTk0F3eYMOXJmF2fdMHqbSrhHPDr9LYA999iBjqmthQduMHnLuVzGEfXaajCHLeHD/5idfcPMDzQyPYfl+RK6eRrEgJTAarBGaAYldTgrz4V6f17yr8vgEAMegyWNqJSGqHON6vQtVdJEEt0moRak/UV01IpoVQ8MBGppX2/puh/8RL10LStaTQDnCam8ghfs/Oq3kbzP1p3O8/ZT6DTZ0k8LJh7O6pWRzMm6ZyweCLYz99kO2SX2jsL1U2dFbSUIMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWEJv/74arJGlR6/jaquV1WFXO4TYhLZe8zzoqFDRLc=;
 b=sRaODbtYLPeHaOPX5h6vsdAfWX3K/PxsFkolsh4NrSOU34fIdK1+V9AoOxnzNoaIVYubnEN30hfi6XSkIbrTP7SdEmkezTFZa1iliDkvAGxAVgMnsAKSCtWga9yfxojtgQA7Dz9Kjwlu7ta3kPNttxY9p6rSwalTjCzI/mrYNyRuZhWy7ABoif/p++LDZ15eXrVsB1S5kCaknL+aspQDfqkLmtP2hI8IHjRP7y6ZbOEuJbPq2Ea5EZQNXSm3nTdhmo5RGYxEE7+zLGaLw4owI4CkKva8TlSH2ylA5RGMljNEOf4cmiYI+8FqVCKpGo08vOB93Yu/5cUNhb7JeS2eaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWEJv/74arJGlR6/jaquV1WFXO4TYhLZe8zzoqFDRLc=;
 b=cTDahEgtM1oSY6mBOU1VUTPIvCva6aSTxBaD1Zqgb2zjoDdBdFpLI+DSHdc3swGnP0IbP8qlNT6yIvfHK4ox+2c2GP104EYyNJd0Tg+19jYR6ALT86DT+X81bY/F/TZjqTPMg5Vc0RpFEdY7GpVoWHOQ3C4GTZ7q45wu7+dwfAFPgUCqa3NgUlOXmg9hlEQ7hEI1IARetU3TFPtRQ6/zRyyj72hf94u0+bfkhjzb+DxBCqMW0YOqWFW9hXLjvSWOBlM5Vj8W+AZBipiB5XmEnyGByD6nn1It0a8OqfI+pSw5xk1Yp2JGexWe6UWB+1T6caWhTlYFFv10wxRfT2ZUXQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS3PR12MB460943.namprd12.prod.outlook.com
 (2603:10b6:8:43d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 14:22:19 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 14:22:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for-next 2/4] RDMA/bnxt_re: Prepare infrastructure for
 larger pages for Queue memory
From: Jason Gunthorpe <jgg@nvidia.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: leon@kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
 saravanan.vajravel@broadcom.com
In-Reply-To: <20260807005138.771669-3-selvin.xavier@broadcom.com>
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
 <20260807005138.771669-3-selvin.xavier@broadcom.com>
Date: Mon, 28 Sep 2026 11:22:15 -0300
Message-Id: <179060533568.122959.5263400857499789390.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS3PR12MB460943:EE_
X-MS-Office365-Filtering-Correlation-Id: f42c038e-ef33-463d-9dba-08df1d6be76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|3023799007|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BOpQ5Q+k/D0KA+HqgLHwaRByx179I2c+74E6Jnc80K37076Ztc8a9ihsS32ZM/kwOUg+rIFD+70X7BJAOXs1KsfLiFCqn9N1ORIcNEf4BKRm4+Jl0tr3OVWi/tPiVUZp1FZbYKbfICPdL8eoR6Qbp+SGClfFxcSR29Qz2UsBhpyCPknq3nmUpFFIE01ADSGNNarHDk8qeM8VihBPd+6f03gwfXGXigNwjf5UW8mxlUEsGseTbrmdc7S/7f8j3+iKRxm9H/1qn9DtqWP5BM860mjMCKC1EtpL4qoxT4HOsMEMMMtbaYphKd2FxW4t4a84DaQ5MN5e3L8wXuz2FAj7O1KJuFrN+ORMyBYiZxNewa6YjiUvGw9LeUvgNZYm7gbmYFml7tta4zD7urJaqDOpNMyqS8LDTTAZ/p9k6Qj7M4fPpN4r3AkfoG7c0oGp2nC76VRqIA7NTLUtblEK+JOzHnHj1K+rrA7hvGnHlcwVsFocCAyuPk2WHgBg5S7KK23hdiHRDKLk6rFnRWg/0Wgxtu3gGHT45p+IVivZWmU9wGtLyZ5+FH79MMSvsKMMHCxBNyvcpBEubvBNA186Z/vp+t7K6aJcT+aEicdPbnEbWo73//I7xyYkeoMqYzOBnPI0VN0TAb30hduMs4Jr3fGSClaS0HkkGAijwdXlVS6sGas=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(3023799007)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VW9mVTV5T3hjT3VjelJOSUtwakMrMDVyWkhNNFdvUXVRa3VqTERYN2Y1bjdn?=
 =?utf-8?B?WGV1WjlvYVh4QW0yU2tWVE5NUnBkMkxHbUF5OTBYdytIZUlVOHdIQjViMTJL?=
 =?utf-8?B?dlBXRFd3VEVaUHVaa2NhSWt6QnNpRkNxM1R1WFlzS0htU2dicVlIYXZhU3g0?=
 =?utf-8?B?V3ZJYWJXaW5PanlmejI3dldkVHNBaFF5MDR6OWg0eThNSmYwbXFKclZOYVB6?=
 =?utf-8?B?WmV4S1NCVGNEQStySThUYXVuWjhqZ0plM0FqK1dkQ0wvbmtwdWxkNE5IeWR2?=
 =?utf-8?B?YStVRndTMmh4OGxxTVJtR0pyeEpVY1h6LzZwa01sdW9NVnE4aFpJUktxeERk?=
 =?utf-8?B?Y3lJVUx0K053cGtIUElldkRnOHlFYXNLTTNGbFoyVnFSOXhWajNyK29ldnMr?=
 =?utf-8?B?T0puOEN6Q0pFc3hFM0RjcjBKb0tCd1M1LzJ2Y1F4QU8ySHZtKzNtRkxjdWRs?=
 =?utf-8?B?ZWluVTlhTlNjK1R0aUFmRUlCRXhnQzl2STljdXlSb0o5YlpDYjM0YzhUYnZD?=
 =?utf-8?B?M0NUT0JTTWdDOGNQMnNzVTJnQUhYNmRUY0x5VkxpZldoVmdEbUpxT0FVZ2Fl?=
 =?utf-8?B?S3BiU1B2a3hVZDlHUHdRZHl3c3hCbjROYjZqNHNsZmMycWVLdzlrY25Lbk5U?=
 =?utf-8?B?ai9rMlFQNlNxTSt1Ly9zTGtrUFZDdm53QkgyNmNsRksxaFVtK1FyNGpZeW9J?=
 =?utf-8?B?K0lTSzMwOEF0QWxKNUVkODk3UTFmZ0pkWU9RZkpvVlFTM0F5UU94QWFPMW5z?=
 =?utf-8?B?cm16UVUwSkRKZ1dGdkdqK2FheDdFVUhGN2VHMnU3RXB6ZzBWS0d4cE4yT0d6?=
 =?utf-8?B?VE44Y3o2Z2NzWW5UajNzNFhzN3pOQjd1ZTZRTExmQ0dSeFZ6TTRqZlFGcVNY?=
 =?utf-8?B?M3Z2WG1oUXI2ZlRiVUh2Y29GcmlYdDVLZUVBZGp1UnJ0QWZLdzJiZTROanY3?=
 =?utf-8?B?Z3Z3RndmUmhSVzQyakFSbk85azN2dE8xUDFISXQ2LzNvL21VWWFLcTRSdyt3?=
 =?utf-8?B?UWlrbmdkb0E1K2FPejdRUU4yaHNQZVd1bThXV1ovMU1kREdDT0JXWFMrVmpK?=
 =?utf-8?B?RDBGUkJZU0ZkS2laOGkxbWF0YklRSDVNY1lkWUlYdXJQcEJrRlpVMGY0RVJU?=
 =?utf-8?B?OWppMFZzWDBsSzYzaVRlTHFzZ2xEN0lhenhOYWUwb0dnWlJzcS9LTTU4QVVU?=
 =?utf-8?B?dDk2Uk40VlpZNmV1ZWwvZVduU3lpTzFrZzhKc1p1Szh1VlNBUjA3RjNaTUpS?=
 =?utf-8?B?N1g3ZEIzeGQvdjl2MlRqZ2ZMQmZsUmRGbGpuNlZxN2tlU1V3cFI3bGxxMzJF?=
 =?utf-8?B?UlRva2g4WHQxVnUvT3RxOEdaZGJZTnlKdEhpUzNRY3NPcnE1eGh1WFNHS1JP?=
 =?utf-8?B?STZqMFRDbk8yTGJaYW9NSHcyaVd3cFBndEdoSFhUb2RpaW1FNGVMbGs5VFRQ?=
 =?utf-8?B?OEcxK05DWHZoT2hrVS9QL0RpUTdRdVo0K2RxTGZOS1V6UTB6TFVoT0hXL0Vi?=
 =?utf-8?B?MW5DemRMUTlZNzlGc0NHeHRHbDN5Y3NNcnFCL1ZkK1ZxTS9yREZGT3o5OHY4?=
 =?utf-8?B?Z1FwSktKblB3NVZLMUxBZkE4N2orQW5UbHAvQ1ByaDU3OUlDck9VcFB6bGdJ?=
 =?utf-8?B?Y1FOTnc4b3RJaHU0QXFwbFdTRjJabCt4WHZtRzNFM1VGZmMwYnZOc3ZXN1o2?=
 =?utf-8?B?KzNOSHNCb2hyZWNCdmdjeW1FK2FqWTF3ZVJpQ2swZGxoZGZoQlRoa1FiZmlx?=
 =?utf-8?B?aFJNM2E0TFhCdzRyT1VjdE1ramJBVnJYYlBmWEZsNGsxTEpjQkJucjZOT1I4?=
 =?utf-8?B?MGR1czNzZFRhaDZ3Y1ZkMy9pQVZzZ2ZWUG04Y2txMFk0NEMveXRZZ041am1F?=
 =?utf-8?B?cllJejFTVG9UK3Vtczh2Qk1OWEU3MTZSRy83NkM5TjlXa0FBZjd6a2w5bmhS?=
 =?utf-8?B?WCtBS0dicFJuOEt2c1UybDhIenk5NGxRZGlXY1lPWERCRWlWQjNBc1Axa1Nt?=
 =?utf-8?B?NnVSMHQzSzhiUHl0VU93a3o4dGc1b2lYUGdBeitCWGNybW5VRHMrSWExOEtR?=
 =?utf-8?B?U0xLWjExQy95TDdVVDhWU0VlUjBBTmtyc1crSzgzTCtaV3dKQk50TFFrMlZ1?=
 =?utf-8?B?YmpYd3ZNRExoMHZmNC9YM2JheTQrTFMrVkt0RVFGOFh0YmxwNDg1MHVGaEZi?=
 =?utf-8?B?R2lFSlY4VEQzN0dveTR2VzlSNFQ0bWlUM3NpcHpwNlpSVWNTSTR1NzNzSFRV?=
 =?utf-8?B?ZzZ5NjZ2a2twY1BoOHEwd2RnZDljM1ZLOHZSMWFXVXd6Ym5WUXg1SHROYjA5?=
 =?utf-8?Q?C8CS1akMBQYiNpAOxm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42c038e-ef33-463d-9dba-08df1d6be76b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:22:19.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wiyfc8VSv8r4VmFuwDv+sjbFCrl0qU5q99ZdFzSdFFhRqymtysppjPAza7Q0Cqal
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB460943

> [ ... 39 lines skipped ... ]
>  static int bnxt_re_setup_sginfo(struct bnxt_re_dev *rdev,
>  				struct ib_umem *umem,
>  				struct bnxt_qplib_sg_info *sginfo)
>  {
> +	struct bnxt_qplib_dev_attr *dev_attr = rdev->dev_attr;
>  	unsigned long page_size;
> +	int page_shift;
>  
>  	if (!umem)
>  		return -EINVAL;
>  
> -	page_size = ib_umem_find_best_pgsz(umem, SZ_4K, 0);
> -	if (!page_size || page_size != SZ_4K)
> -		return -EINVAL;
> +	if (bnxt_re_pbl_size_supported(dev_attr->dev_cap_ext_flags_1)) {
> +		page_shift = bnxt_re_get_page_shift(umem, umem->address, dev_attr->page_size_cap);
> +		if (page_shift < 0)
> +			return page_shift;
> +	} else {
> +		page_shift = __builtin_ctz(SZ_4K);
> +	}

This ib_umem_find_best_pgsz() should not be skipped, organize things
so you have two size caps, mr_size_cap and pbl_size_cap and use them
appropriately in all the right contexts.

>  
> +	page_size = BIT(page_shift);

So the helper does ffs and then it is shifted back?

>  	sginfo->umem = umem;
>  	sginfo->npages = ib_umem_num_dma_blocks(umem, page_size);
>  	sginfo->pgsize = page_size;
> -	sginfo->pgshft = __builtin_ctz(page_size);
> +	sginfo->pgshft = page_shift;

Put the ffs here..

> [ ... 9 lines skipped ... ]
> +	/*
> +	 * The FWO field passed in the CREATE_QP command is expressed in 4K
> +	 * units, so the offset must be a multiple of 4K.
> +	 */
> +	if (qplib_qp->sq.sg_info.fwo_offset & (SZ_4K - 1)) {
> +		rc = -EINVAL;
> +		goto fail;
> +	}

Failure does not seem right? If there are restrictions on what offset
can be accepted then you need to feed that into
ib_umem_find_best_pgsz() so it selects a page size that works with
HW. Presumably if 4k is selected everything works, right?

I forget all the options, but mlx5 had similar restrictions so I think
helpers should exist or almost exist..

> [ ... 46 lines skipped ... ]
> @@ -220,6 +239,8 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
>  		if (rc)
>  			goto fail;
>  		hwq->level = PBL_LVL_0;
> +		if (hwq_attr->type == HWQ_TYPE_QUEUE)
> +			bnxt_qplib_adjust_lvl0_fwo(hwq, hwq_attr);
>  		goto done;
>  	}
>  
 [Severity: High]
 For PBL Level 0, the first-word offset (fwo_offset) is absorbed into the base
 address here. But if the queue requires PBL Level 1 or 2 (multi-page queues),
 the offset isn't adjusted in the PBL entries.

Are you checking sashiko?

-- 
Jason
