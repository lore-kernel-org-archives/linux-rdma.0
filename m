Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794403210;
	b=IQ1wD2nJaD7alkrqv9xub6e7CZB8aj5ZmYxcQxxjSNxjLYci87utLcdT1kMUS2qJzJuZ
	 55mb0la5UOgSk5EA7AXyyIMdyVO3lG4VjZcWj3aqkdR3+LGJrp7xBQoTQzjudqsnFK3nG
	 GSoor/wZuFzaLmD/JS/7ZlJxBjH9SrxhYmz3cW+e3kvyM1OY78BLbzgBGU1xSWO5JJI04
	 s4mdFz6dAyAs8nnYElTYXRgHiTYAqVzrfMIEJGHjZvZe5UYdIpTiLq8odZrwr5HPzWitn
	 4YfvYzpTmMLSsTIDfF7XaKDtFO9BLB78lseZNM/lRUfGOS+dQKARBkNQ8XU1bk99azw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403210;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=dsReUE53pO1I32r99j5Ar1o9U59lN1pHcSDYGRq1Ims=;
	b=EBY2inzr187a9EG6VrA9y2J1o69yYRn1skixoCC9kGRItnBfL9pgprRo4J/Xl5MeUy8f
	 UVi75mmnaAOoZh97UR6pjBlEXHtzMUr5j+psESCznGbFAR0SmyVrGBpbeiLfB4VRpcuQ/
	 11WKudJcb6U/hBHvQEPBlk72F7ryXWe8MES6DjzJr0H1inZ11ky3TLe510LBT5KBQ/dFH
	 5lUiC2bixw1m8xT60A9Mb0BtGwxW6RNTo6ZXyPRbHzs4Isr5e2QTJR2SHLy3nWW25zY79
	 bzqpZoxW7x54cNdoEujFCcf1jyDHV+L1BauIitGAlkgBnYsmgiVYCQWjy850+3Kxm9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Mwcx4V08;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.27
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33ED606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F33ED606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Mwcx4V08
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbLHp3VwhlArIOlxM7g6FsFoX+ObIExrSqbDihP1edIunahC5WZwNGVxQhY8v54+xwPC7F0ooK8OTVgX4AX75OYHKoQ0jomlwZfYQTiWpep2qW4ffJmgvLhOY3XD43dIdNng8tyHdqlG6D7aCKaKu1qnvidMujNVzzGSLMuYju2nq5XAymQvqjoRwyE3SSTe075ieZdb1I+gDuSFrCekzAZ7ovrGaA+N01ZNgbPUBQtDOAFaJq1SZ1FTdf+lSPB3iBtlqlglTtUIuk28uvQx5ZlaLt+szPjOCmwURea5uwO7nBPWYcify7elN83KV1qv9DrkKIA0yTq6XawyuS0+5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsReUE53pO1I32r99j5Ar1o9U59lN1pHcSDYGRq1Ims=;
 b=GZwJLztE49rPvf4E+R3chpBEtxLx8r90RhOxXYE4ZoeOwcmYhhgFWrm4bpB5uI22OJeR2gfbkiYLbuPHzYecrNI0oku5Lw+u9JKoFehvd+NLqZAuiA6ubJ8X5Tkv+v2Z5tRdn74v8pqhfcD53eU6m0k6/KwTzSf4oFhCYPSspHQsU+Ftx1rwVMVVAtqNQufglqqc8gOl42JpteWr4P51RGkrMXGUMly/t2TkTTsGZwo6SZyzedm1fk6vN0Xn22oJa191+yrWfohWoyii4MU4MQ1khRSPUUzmh7DTm0Jlmg4naToDu+h15sfSMrq9VSRotGEb/303jXxpl/IbcK/YAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsReUE53pO1I32r99j5Ar1o9U59lN1pHcSDYGRq1Ims=;
 b=Mwcx4V08/XGNk7cI41gG06Cb18NZy80ys6Xc87UmvzX+HLFBPfDDKN68ubX9mhI5BY+BUvEqDKXl24iYgq2uLG/73490Lg24UVHMO/Dp0ubtyUEXpnyTQKv7MO9aOZ05kHyYe+dxDqrzyhMnRALAdUTj+mU6GxvMGmxJmMr2Unjov7wTqRmhpG0Hk/FZLlbmVYmEfDlvC4feLVfLXQZgaBlL/MYnygNFFBnDbhReNyBn7MRumEVSSR8zLUHW3qMWWTtjdVVig2r43WhnXvhmqimJ6d82qWRdCMkkB/vOnmYgVWQVXud08rT3E4uZazlkCz3pj92kIPtKzp8zzulnmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SA1PR12MB6775.namprd12.prod.outlook.com (2603:10b6:806:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 13:20:06 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 13:20:04 +0000
Message-ID: <2c462e71-2097-42e6-95c4-42ff31436b06@nvidia.com>
Date: Wed, 11 Nov 2026 15:19:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 1/2] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
 <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
 <sashiko-outbox-205134@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-205134@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SA1PR12MB6775:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c5c9110-d748-4428-5c45-08df3ff67f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|11063799006|4143699003|56012099006|261021121427099003|261026140227099003|261022105027099003|261022075727099003|261009223027099003|261026121527099003|261028144727099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NL7KpMvzK1vGihhHfVlZe/juEosA9QTHheabBwHoo17rwfMvDRQLD7T0uvbl/PPib96sjpkY4BIU84lhQR+BS+X6E6LbtK9RVIsTGq/YZi/PI5VUs/UWWO/MGhgeqnztx/C6auPtCeFEqBrjkaaVCZC1F2sM0mwPM3WzaTeuO0CbxZadan29RvysBZePPpVHiTasGLYmlI23nGAPNOJGuPyCnzhSoUzDFb8mVrXLY4he07SNKmpy1HAI+/8SaaD48Zbe3FVF2sQKKXBM22YuVnu7Uv7PEgJpAkJPSJqJgeKh4LUhXGNLZ0JNOHebVAmsZzHkfgq97DceWMPA7nVpdRcJhMediJXWUy3ktwO/eGkELh9rzk7VDJmkEs/S61JPBAvuEz/R7IJvwpypz2FU4pUHkr9Xt8reoNhMiFpP6DlrzWr/C76aV1HndoVoFmZYnyXHJ+wwIgXa97l2Qpjs8PFFqASw1G+erAug+5r+kYo+mTWa026SxQQnFVj0U8a0XlJuQMaEbyzoMfkOPBKI6YdRT0cimv935izk8fTS/pnIliVVPXo3b3Zbezl5+yFo9wgpAyFlov9m64uL95wrPnJPaaEUOSf0duiPite5B0XTqBS/2iV+W0NxvpP6JODNVhSP55jSatjPCWBPxqWeisNBZNMA3h8PAkPAS+CyJ6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261026140227099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnB0YXA1aGlsUHdlN1B3MVFtZWpOb1o5YytLZUREVm1RdEhGaGM5RjhvZG0w?=
 =?utf-8?B?K3RiclVsenR5b3ppQ2dWUS9TV3gxa2laa0s0S0VHK0RIaVlrT01VM01pZFkr?=
 =?utf-8?B?THg1a2JxQ0tHdEptRHBzNUZDbEZTMGtEWVJBbEdDZFduSSsyRW5YQ0h5WVBF?=
 =?utf-8?B?bWtBWldYNHJqbFRBZXlTRUJiaWZSRkVhblZSUjdHOWFsbFJyWXZwUHFuSHAw?=
 =?utf-8?B?eXJaZ0pFL3JkQXltZjI4enJNR0R3STROQ3RObzBYNG1Od0tvRytwVFNjUHpN?=
 =?utf-8?B?SldjajYycjNocWZJZWkyd3d2VmJuanA0SmlOS3dKS2N2SERtRUk0SmRsd0t5?=
 =?utf-8?B?UkU1LzFMdW5jUitENnZMaWdxcU5SY0JRbndrNDZQeHVHVkM1L3ZrMnAxQzA5?=
 =?utf-8?B?ZkZJSEltcXpCY2FWVS9ObXlldHdXbVBhcTU1YjJ3SWl5eHNYRklJSGw5R1Rr?=
 =?utf-8?B?QjU3MHpFZXVORUUwL3E3QTk0RVh5SkhZWHJnaUNJVTI2OUVVa0VybmY4UzRj?=
 =?utf-8?B?Zk5hb2p0bFQ2a2lnbXlsbHFTM29EYVMvYVVEeGF3MkJLM2VzQ21aZVVnK0ZL?=
 =?utf-8?B?dXlLYkdycjVWMDZWMjhVT2lrejVEazhIbHpmcWx1bXRiYWdSeVl6a3FnbUVz?=
 =?utf-8?B?SWU4U2ZlT0tTci9oYlNrK29Bd3gyTmI3RTBlNFFxTlBYbEFOaWI3dmZUdHFj?=
 =?utf-8?B?cllRZ1RTbzVSakhyOFlEVklBVE5hcTQ4MHBoTmg5NXBhLzJ4bmxUdjVVN2ox?=
 =?utf-8?B?OFEvY0VRRTJwY21IY0tvQXhRcTFHYlhGdGo5N0pmWHdjQnlKTDljaW51VDY2?=
 =?utf-8?B?M0JmY2xxOGVRdlFmSHQzcGQybVpjWVBPRStqLzU1TVdtRUVvNG5Jc3ZZeHFm?=
 =?utf-8?B?cU5nc2cwblJ1M0xUR3BuTEc0OFNQWTgwbGxuZDlSSWpmUXo0Umo2NWE1ajRG?=
 =?utf-8?B?K3VTMmJ5TURvSm1oZEFjSWlpYzF1SVBld3lVZmFjSXpTdGxHTWhqZjZmWDlF?=
 =?utf-8?B?VFFNTnA3QklvN01TWUV3WW50QVpNZzRWYXB0N1ZMcHI0bTZGSStVZmU4NXRP?=
 =?utf-8?B?UTBFWlVTazlCSkF6aWE5WHh4RHkzZ3NQNkxqRlp0bTNPUHN5RUVKZkF3ZTV4?=
 =?utf-8?B?MHJpOWxBdVJvQTVVaTBxNjg4R3BhWG90UVJQNnZzd2JIU0FFM096aEg3MkxW?=
 =?utf-8?B?QkphQkdhNEVQWXZMYllZRDNVV1E3dzFMNlVmd1RaRlkxZGwrSExVUFJUYTNl?=
 =?utf-8?B?M3BRMmZ4YlAvdzRNRnEvNlRQQzVhS2hPYjlta20xYW5OY0VrU3c1T0o2ZTVY?=
 =?utf-8?B?ZzZiMmRrUEREOEd5dUtVNVRvcTY0VCtGWGJCa0RCMEQzRnhTUmR2OXczNXRL?=
 =?utf-8?B?NzFwUS9mWWFCWFc5RG1oR1A1WGtVQk13cEJvMGU2am91ckRJd2RTNXREalRi?=
 =?utf-8?B?aTdBMHArVDhrTmNOSHFxUUo2Skw3N2NyWkdTdzNEVE5YbjBHUVFXODlqM1hv?=
 =?utf-8?B?KzY0b0dvOEtOajREU3MwRG1IZGFpdmFJSGw3VmpVMUwzYlJBNGlvRklmV2xl?=
 =?utf-8?B?anpoYzMvbFJReXNRaUxReGJGbGtTZjdKQnk2Vi92Y01ZUGZKSCtHMXEzNEZX?=
 =?utf-8?B?KzRWNlJEUGxvOVNkR2NYYVZIWnMzSFNKcXdIQ2lkV2FmUlRpcEpjQ2xaUk1r?=
 =?utf-8?B?Y0haWTFVc2hkWUdvL2FoNVlLWjE0Z1JMOStTbWdPbVFWb2xrMTF2K08rZkJ2?=
 =?utf-8?B?b2J0RlNxVU5NMnBCbDJXWU9zS0lka2ovV2xPTkNRVzVMdHNqODl3QjJSTDVp?=
 =?utf-8?B?anlyWjBJdUZLY0tILzdvUWJBMlV6SWlydVBGM2RyU05QVW8zT1dWWG50Rkpo?=
 =?utf-8?B?akpZcVFZTjQvbXZVZnRzZnpxU1lUclRWamlPeGNkRjJZVjFGeGxVUndoaThC?=
 =?utf-8?B?cVFzT3hoQkRsblh3SHVQM2Rwc21qM0VDMzRtd2ZhMlBWc0tXUzN2WGZzNlVm?=
 =?utf-8?B?RGxjL0FxZm1FdDFXaFRZYWlmYTNDLzFJL2tLQlBxRUcvcEM0bUMvZjlvZ0xK?=
 =?utf-8?B?eExIa3NCRDY5Szc0aW1FRGxXWkgwWnd2TDNVaUgvQ20wWFIyZzlVK0owZjVu?=
 =?utf-8?B?Y0FLQ1pkVWF3TFVPaUlxV00raXpyazg1WnFkbjcyQis0RGtXNWt0RXdKMzY3?=
 =?utf-8?B?K3haMlBERlU0Q1ZXazE5M2ZCRmlMUVQ2d1g0UHkzakdGNzB3YkRTY1pUUVB0?=
 =?utf-8?B?YVV3VG5tUUNDYUs1M1FRQTRlcU9WTmZZRUw0YnlNTm80VWxmNVRRQVVwKzdY?=
 =?utf-8?Q?Up1ZrB0OsDuBF2XioU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5c9110-d748-4428-5c45-08df3ff67f3f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:20:04.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZzVuXTynNwzJDWnd6G6fmhOKpCNT52u616tTT+WEVmdBWQyBoJPR3HWY/r42AbdViZSL3Lkougt6da/urJViA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6775



On 11/9/2026 4:52 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] RDMA/mlx5: devx_umem_find_best_pgsize() ignores pgsz_bitmap
>    after halving page_size [1]
> --
> 
> commit bd5b83068caa4612b47dcf836a1a42f89cbb5cc5
> Author: Uri Dar <udar@nvidia.com>
> 
> RDMA/mlx5: Fix DEVX UMEM mailbox size truncation
> 
> This commit changes cmd->inlen in struct devx_umem_reg_cmd to int and adds
> overflow checks when computing the CREATE_UMEM mailbox size in
> devx_umem_reg_cmd_alloc().
> 
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index fc6f793dcc658..1da6c0e440d6e 100644
>> --- a/drivers/infiniband/hw/mlx5/devx.c
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
> 
> [ ... ]
> 
>> @@ -2361,9 +2362,12 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
>>        if (!page_size)
>>                return -EINVAL;
>>
>> -     cmd->inlen = MLX5_ST_SZ_BYTES(create_umem_in) +
>> -                  (MLX5_ST_SZ_BYTES(mtt) *
>> -                   ib_umem_num_dma_blocks(obj->umem, page_size));
>> +     num_mtt = ib_umem_num_dma_blocks(obj->umem, page_size);
>> +     if (check_add_overflow(MLX5_ST_SZ_BYTES(create_umem_in),
>> +                            size_mul(MLX5_ST_SZ_BYTES(mtt), num_mtt),
>> +                            &cmd->inlen))
>> +             return -EINVAL;
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but can
> devx_umem_find_best_pgsize() return a page_size that is not set in
> pgsz_bitmap [1]?
> 
> drivers/infiniband/hw/mlx5/devx.c:devx_umem_find_best_pgsize() {
>          ...
>          page_size = ib_umem_find_best_pgoff(umem, pgsz_bitmap, U64_MAX);
>          if (!page_size)
>                  return 0;
>          ...
>          while ((ib_umem_dma_offset(umem, page_size) != 0 ||
>                  (umem->length % page_size) != 0) &&
>                  page_size > PAGE_SIZE)
>                  page_size /= 2;
> 
>          return page_size;
> }
> 
> When a physically contiguous umem is registered with a restricted
> MLX5_IB_ATTR_DEVX_UMEM_REG_PGSZ_BITMAP, ib_umem_find_best_pgoff() selects
> the largest matching bit regardless of DMA offset or total length, and the
> loop then halves page_size without checking that the reduced size is still
> present in pgsz_bitmap.  devx_umem_reg_cmd_alloc() then registers the umem
> with a page size that userspace excluded instead of returning -EINVAL.
> 
> [1] https://sashiko.dev/#/bug/linux-6cd20db6-58c6-4b3d-8dd9-c9ee893d4041
> 

Sashiko is correct. Since it's a small local fix, I'll patch it in V2.

> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com?part=1

