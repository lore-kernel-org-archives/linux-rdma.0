Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011053.outbound.protection.outlook.com [52.101.57.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C590F4FD296;
	Mon, 28 Sep 2026 22:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635456; cv=fail; b=Cf97OjrW9WgFTbI2mR+7sF1utAyefRY5GyokKD2IwojBT9EDlNlV73dawe7CXoPWp/GZlFBjzPxgQX8T7g+w1KasDya+KC1IyBp1yvhh4L0Ue/N1Osr4w+okCW5BQ2XeA/yATBIvSLFEZ3TOjzWtOiWcsjG59xNfK4h8d30BtYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635456; c=relaxed/simple;
	bh=6wQXPwsAZGMbxTHjhZbQkGF6fUEhr+FIKzPRPzuMipc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hd0H+XxgHAsK+KUPjogW86zACCVJfOgdSvGp+B66VERDfyNaWlQ5ywSTqTs4RFJqKAOX2DsO6sw2n84lx4wC73HqvavQz7SeiZVfpWV/xwG57G9tE3QQGBAjcv6Jt80GTLxvJ+4ql3W+Yo020v8rb+SN1bSc91PZ7yESeh4KL+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sk6i1rF2; arc=fail smtp.client-ip=52.101.57.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sk6i1rF2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8cWXBHagZovMY2MtHpInvSDACXOs6dxGYD6O9OC8nADYIyQqHXlEC2e3cUHxGoPet58vBbQ8XRRrISlQDNq2k9zF/PgjcegsrzDTAABg82yPXmVKT9gG14tRaAao8nMsuc532abhY7w4+sXyVLjQU5xH5XsN7Q3+bU7j/fV5TxaKnxi7faw8GlLltfBgqKZ83XV6LSauAXTEpN4uMGa1L0Pk9RZEwRCU2dYGC7R7z4fuNTWr9fenIwGSaAUVB40auNw7ywszbWLHIsH/6N1txaI1I/DKqJImws4YVVOcoUqZ/QPz5U8gKZE24HSb59eB3SPesRbmQydeqefQjQwsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9Wk806wZLm9ojLkeAL4ygSE+zvye+7gOYE12Suirs8=;
 b=nZBfU7uDZUdZYmoThB7ygLm/4vU0lyRJY+VGR2u83655U5keSJpFA9g8qwiISTENzHAGgM+FMyP9SLdXxRp8Sw209HTKjpR72Zvsva9sA575df88wnVDKVqBpo+9V+n8lokG1FzN84UujEI7doZCuWPt6uWZpxDeO7MwYMplZ7CDiXmNljVUnFGC5RwytuENNHzbl6h2PO96Ksb2Y3p2DQwORP9FkpuuKXUubWJ4e6NQr9MIRCTGzAbUIXPFfwB/ScntETA4f+54s49F/2plaxlr7s5IntEMppZjAwkkqErkvbdZSrcv5wDhtLVsJQ4NydCFjhVMA66K3zRypHkhLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9Wk806wZLm9ojLkeAL4ygSE+zvye+7gOYE12Suirs8=;
 b=Sk6i1rF2LVyiqU5097IJZUQjjyL3Kbf7Yc6hDbV1IUB0W0FWYvKRj4bKeoC5DgDL4Xp64R/e4M/XgtzNCDlHfbUDug6dva+S9gpu7suoAWvyq3R2CCsNG90cOb+1ZFKtSuN9oU7RvDWNkvkALfTyoRd48aDeHM1gO4RSeS1gSQ4ZHOe0I9NZEY6ZsrR1QZEYqlvaazIYEuazxDr+79Smc8vgVihnFZ8uTo+zuoTNc5ZiSiLPwVEVVmKp/GQXGB2oCBoiqhzBZNiFMFfVhdIThCUK9JQKtrqm8MdoEQa2CKLadDFtT6tm0EbgNojJLvMCaLcd2D33aUsZDZ358lGvUA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6483.namprd12.prod.outlook.com (2603:10b6:208:3a8::14)
 by DS0PR12MB999081.namprd12.prod.outlook.com (2603:10b6:8:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 22:44:08 +0000
Received: from IA1PR12MB6483.namprd12.prod.outlook.com
 ([fe80::2db3:6ced:d3c4:d48f]) by IA1PR12MB6483.namprd12.prod.outlook.com
 ([fe80::2db3:6ced:d3c4:d48f%4]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 22:44:08 +0000
Message-ID: <ec8144c5-c020-4459-878f-c0000aa4652a@nvidia.com>
Date: Tue, 29 Sep 2026 01:44:04 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/mlx5: Wait for in-flight page faults on implicit MR
 null_mkey dereg
To: lirongqing <lirongqing@baidu.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260920090613.2186-1-lirongqing@baidu.com>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20260920090613.2186-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0389.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::7) To IA1PR12MB6483.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6483:EE_|DS0PR12MB999081:EE_
X-MS-Office365-Filtering-Correlation-Id: 3322791f-024e-4c5d-9576-08df1db20166
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EyAv4gE+R6dtkbutzodV//Z9/juUGkoon5GBb/sbkxJjc79hRVUKm/9Qm9KOCiaena6Kp9a4VIPxik24UmnqL52C87VEJjb6Rf218YGycvVk/OyKpwmbwqdkNesCLb7a2FzAMySdB49YoKIeXxs1nSk0uxP7ZQSP3a5sjWZZPxm36jAx7kutqz0ZpZdTOhSnqAj7z0wjetR+S4XV7DjVAsK6w3rL2b+aByUNOBLnscczRCUjYJUnf5OtCo0GPQKxzqNY47qzIHVJQ8AufzEzGK1tcGyQSE+ZqMZddq3U5iF7RQTriiHTjO2qbg8Ti7E9rwrO10UNmKRyjHYWWWi5kCIQDfwlwSB0bTZhpaTPS4o919CjY31sL1sxmJ/Mvjrvv8aBif6u0ARkF2i2jZ5J01cWU3uiVcFJd9ruDVPGqJZo7RHzPE0chOcx+ADZxkRYQD4J0YXTID7P394CywpyC/l+utXcJtuGP6JNdeL3fXmvEbVwyeiLd41JwFgU/ViTIsFv7vDqZUvXALQ9ZCEnIQXxz2QGWnGD72poyecbNubyzBBxA9lytvJWTozHM7eIuz1ZqauaFlIB4+mGbGrlJWH05vjOBtR/Owt5YF7soLN3SIZN30j1I8iOcWxcmFG8eCWPtSXuqFg3UcsazT7he0SZn7/TKLwoGeZYH3RgJVU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6483.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEhtOUp5eGxSclFYWkNkL0hhcVFoTGFiSTM4Q3RsYjRmUHI3OGNINWltYTNv?=
 =?utf-8?B?OGNaQnVoOVVmZEFDa28xd1ZoTHplNnREU0xyT3drZVVydUVjZUlFMldhTmcx?=
 =?utf-8?B?bDZPamtReU8zOVNRSnNLUitxME5pSWZWd2pXNE9WdHZNRGNaL0c5eHB2ekEv?=
 =?utf-8?B?S2pFYUorRGJQdnFneWhCU2U1alFvLzVtQzFaWFNEOTdzekF4bk03NG9qdUg2?=
 =?utf-8?B?WTRYVUdjU3ZWaFhlS3FQY281WHB3aWdGdzM2NmVicXB0WVBndUI3WFJnS0lM?=
 =?utf-8?B?K2MzTU4wUko3Rkdmb2VMS0VBSEhKYmpVSDBid2xiUmVhcFlybmx5TFJYRS8v?=
 =?utf-8?B?WVJuTm1qeDZ0NVBQOVNHY25wdGdQVU5mT0NUb2RwSVd0cUVDbW5hOERhN1hS?=
 =?utf-8?B?eXlaMTZkOEw4bTNpMnZpSzcvc0wvbGVUdXEvMk9EM2laSTQwcUMrTFlWSENQ?=
 =?utf-8?B?UWJIb3J1VmJaazZ5UnpLaGMwRGVMWmxRWVNibFlIVjd6NS9iYXA5L0xnNk1a?=
 =?utf-8?B?M2ZiM3h3bWkzUmZLZ3JOS1JMQkxCNFh2UVp3bmtPWHJhQW1DdmxuL1ZXS0U2?=
 =?utf-8?B?WEcwWjZ3a3Y1bGlZYkJ1WWpVZFk4S3JNR0dYRDVnYnplTGtLZjB4b2pKaksx?=
 =?utf-8?B?QW5YbFRJeFZVQkFueUJqdEYzb200bnhKN05kQVhNanRLL05zbVJVUndLaXEy?=
 =?utf-8?B?Q1QvU2l6WW9xTkYwTFpqZXdKV280YnpQRzA1bis4eGtBLzMrN3g0R3V5Q01k?=
 =?utf-8?B?aHNHOUJVWk56Y1d5eUwrV0tSMmdDRytoOWdNOHNEWnNJM29EN3YwNm5CUldl?=
 =?utf-8?B?N2g5eFJlSXhGZEx6azI1L3M0Z1BUYUh0VHZPamt3VEFEVXk1Ukd4SitqNHVx?=
 =?utf-8?B?R2dqMnVnbExiL3JyYUprbDJhVUo0ZWZac0RFZndGMGVMV3M3VWdleU8wcXlk?=
 =?utf-8?B?T2hCcEphdTNLMGR5QjFqcDVzdjRpanJ0NFpGYSsxaWpHUFBjcTZsZk5IdXhK?=
 =?utf-8?B?N3hqbGgxbGRTaFUwMmRNRHJHQlhoY2Z6RVdkL284aXpLSW1NU0poQmNKYlN2?=
 =?utf-8?B?K1VjUXJlaGppaWNYTGxKUnU2aDFLWHRYNUhydytWMWxuNVBiaTVHcnZIM2hW?=
 =?utf-8?B?aFZTL08yUURCZERlb3VFb1p4WDY5bFFXOUNTWHlkV3liSHJROFBKcmhxWEVi?=
 =?utf-8?B?VWF2cFo2VmphL29hR0t6TFd2WEF2czZsbEhaTEpnSWNZWEtwSnhWMzV0bzl0?=
 =?utf-8?B?ellRQzEvT1pLUFVvOS91S0NReklqYlVEdXhsYnp1Y3FmL1dqWFgxenhSY2lN?=
 =?utf-8?B?Zmt0Z29nV3VqVkFldkpQQ2ZFVjlpRHZqSG5JcTFSN1ZNaGRjbXJ6MGhDTFFO?=
 =?utf-8?B?SUJGZ040Ky9odTJNRHo2SktRaGlWR0JOajM5dzB2TXVvZGdsalAraElVdm9h?=
 =?utf-8?B?YzRDbDA5QnNpZDU3N0FaU0toTTlyUmpBMVZJMkx5R1hpK2swL0xacUVoRTZs?=
 =?utf-8?B?MDUzUnVJL0p4aytXRkx0ZDRET2NRblMxM2RYdDV5TGYxeEdRbVIxTkMzM1lL?=
 =?utf-8?B?c1hyNUppT0RsT2VNTmZyVlk3Nmt0Tk0xMVVibjdQTDJMcjY2Y1RkV0x4Q2xW?=
 =?utf-8?B?TlVhVVhRaVV2QTBYYTVUQ1FrRk9KL3JpanFrdkkzT3p4TUVybnlLbzZOVTNN?=
 =?utf-8?B?Z1Bidm9TWXEvVjJJUzZaUVRVVXVQUjgwbTRLWGovaUpaajNjdzVIWDZ0TWhE?=
 =?utf-8?B?UjRMS1RWYVB4UHVWaHhBcWVZbGdsS3lONXZrUGFTZ2Y0c0kzNkhYclMrWkZC?=
 =?utf-8?B?YzQraFFTdGZXdys0N2tXaGpvNW92bG8yTGF2ZVNRY0dxcU1NTUhIZkNEVnZ2?=
 =?utf-8?B?NWhreDl5WEJ4QUllaEJsbW9uSmNnNmliaWJVMVJrWHM0eWtkcUFlS1VibFM5?=
 =?utf-8?B?Wlk4djFEa2VzOEVhbHJnaUVlZ0ZOKyt1MGNBQWVNTXlxNWNSQkNFdXBCcDBZ?=
 =?utf-8?B?VWViaDRuVHEvajE0WHZid0FINE5wTEEyR203TTdadE9UekRLYkNtbGhrSjd1?=
 =?utf-8?B?d3p4cEpKYWQxd3JaVVlRUkxwYVRRdUZEbUNUQk1QVnJCdEZOazA2M1ZTZU1x?=
 =?utf-8?B?WUZrS0lYNGtwZlQ5cHRwczV0SG5kc1Q0b3NSMVNPVVRBQXRZNmMxK2VUZXlj?=
 =?utf-8?B?bERzYVluQXp1aURIazRlcmFOSStlOFgxTzZaNlZmMThMM0x6eW0yb0Yyc2tj?=
 =?utf-8?B?S3ZKLzFkcjlWU1lJelZUSGJnUFhxN3FBRk8xbHluOVp4dUNaUnZHaU1pTkto?=
 =?utf-8?B?Ly9ZcUNUZVBOVUEwbXh3ZmxrMXJFcWl1NFdXMlJTSjViTFRmaW5Idz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3322791f-024e-4c5d-9576-08df1db20166
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6483.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 22:44:07.9256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhwX+KsK8m99OOmB1gHIr/I7fBxlghbeW8aCCOh/jPL2PDhXq/rRy08v175B5TolK/ve4vRijTk0TOOj4CQXbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999081


On 9/20/2026 12:06 PM, lirongqing wrote:
> External email: Use caution opening links or attachments
>
>
> From: Li RongQing <lirongqing@baidu.com>
>
> An implicit ODP MR (imr) publishes two mkeys into dev->odp_mkeys: the
> main imr->mmkey and imr->null_mmkey (MLX5_MKEY_NULL). Both are stored via
> mlx5r_store_odp_mkey(), which initialises their usecount to 1, and
> find_odp_mkey() takes a reference on whichever mkey it finds for the
> duration of a page fault.
>
> __mlx5_ib_dereg_mr() erases and waits on the *main* mmkey usecount only.
> For the null_mmkey, mlx5_ib_free_odp_mr() merely xa_erase()s it from
> odp_mkeys and calls mlx5_core_destroy_mkey() -- it never waits for an
> in-flight memory-scheme page fault (MLX5_MKEY_NULL) that holds a
> reference on null_mmkey. After xa_erase(), find_odp_mkey() stops
> returning the null_mmkey, but a fault already past the lookup still
> holds a reference and dereferences the imr (via container_of and
> pagefault_mr) after __mlx5_ib_dereg_mr() proceeds to kfree(mr).
>
> Mirror the main-mmkey handling: after xa_erase() of null_mmkey, call
> mlx5r_deref_wait_odp_mkey() to drop the reference taken at store time
> and wait for any in-flight fault to finish before destroying the mkey
> and freeing the imr.

Adding the wait after the implicit MR mkey was cleaned up and its umem 
was released doesn't solve the issue.

I suggest to make the implicit MR dereg wait for its null-mkey reference 
to drop, before any cleanup, or change how we handle the null-mkey: when 
a page fault hits it, take a reference on the implicit MR mkey instead.

> Fixes: 6f2487bfafce ("RDMA/mlx5: Add implicit MR handling to ODP memory scheme")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   drivers/infiniband/hw/mlx5/odp.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> index b861861..f27ca77 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -683,6 +683,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
>                  xa_erase(&mr_to_mdev(mr)->odp_mkeys,
>                           mlx5_base_mkey(mr->null_mmkey.key));
>
> +               mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);
> +
>                  mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
>                                         mr->null_mmkey.key);
>          }
> --
> 2.9.4
>
