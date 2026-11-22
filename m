Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795351407;
	b=eB8/KCQWCUzm90tqwt8NUZ2FuUPVSKtU/2pvWYWRzFWfrA180jwY0UCpUT3bUPLaVix6
	 1p8T3b2r8D29x4ClTL4XgSJTUh9vA/uq0l9z5ufoKyNhKaIsZ+4Tn2o8X7ybPwZGchU6l
	 atBBgR3kOo0pOnXwy+K+r/Wq8up6PMv45tVDPJeEvNW02qWttjYS4VLOrVHch9AAOesi1
	 g0C4p61+Hlafwy3YLFcKkLAdkUykHbUcwmP1UY1FpXXCtnR0vkglbg0/Jc0AgOEa1NVrN
	 Re1HmWTsOz6W1DoYtZRP7EWCshHsbhVl0F/4QMNbuPedL9/+BFw4g3UxwHcdt+3yIrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351407;
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
	bh=XH9AipQmF7tYinwXG5aRlsUimKUMSKokotD/nbvHXdk=;
	b=MbVWnby6ODukMDRKKrmBfALtLx0etqBSuUnRKzkO23ZaFBH2YYZBLOVb3mnXJgFURTpt
	 OvVlQ4TNvslVhWzLTHhZKJroZ1mI3akA3WkOQjAwKKSsYFJqHneVdywLM5GzE/w4wasBQ
	 kU//KGk+YuV0ol6mma6QBYLmIwrDJzCvZ7zE9EInFVslqR89CaZ54lOvjt5nw2WI/73gB
	 03Xgvmr9PqKVd/Kveaz52fG6R6qRpCjhHjRQOnTPiab5BkKsmepg4sJSGm2OIzpywe+7I
	 NeIKpZrd5x5yXAi9dvpV8gimSQPJ/7XJLU2ivMJJ5ubksR2k5FuWB8tkMyEqGaLJOYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QBHaLMBn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.71
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D850606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D850606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QBHaLMBn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrkuop4quYnDNTjnmnj7WEXpvJ8bUsmyig8IffLqZeh1O9yES8mE1MabUAbZ1B4gsbZY5S7vQN5juWETnBMYifxkf+KR3o0N2MD2v3yKbqHKEGmOpzqGE9ONWq7332df8VWC8gJ1caCt+JQOSgVI3MTnXycFq10CMNQbcHQ0Wi3vq8UpjH9gO5iKk3BXzznRCjyYmqddyGZDY5hvQOfhQA4W6DRgH8GxH0ijUYhBBJwByawOSXqAov1cAn3njeo9KNXPEhD89+VYO2OcgG+yM5rYXR0XxnwAZChWQIu+5PPVjjsIb/cbfU61vtSk10Y95LYN0rrqg3LYKoSaPHisIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH9AipQmF7tYinwXG5aRlsUimKUMSKokotD/nbvHXdk=;
 b=aekKOc6GDhbdi9v2KPjG7qdyMhtcXiPp56BYro1eFtHbrYuA+EONzBvQrsgVikqBSRcqkuZ6G7jOKzYyitkcsu4FAMs3OaRO6H6sh2QFJaj51Iz0h62UOQv3bDTMKZgdv2rpOXls5IUOjveeuaoXX/J1WVYefrUPIgc6nU208e4HihTxz8j3TeSmhONRJv0+9276UFasEr9weuss7sgdPmpBRbE7RIB4qs/z0C06Nop5TFByWhNwDZDCfwrgUEr2iY2OLvA+LLoHNDuALPunBWwFtGSfXMBoA6sZCEUCZfOGRQVKPlb5Bx2+QOcLalFxyG9poPYJNOaeX5jsp7Lsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XH9AipQmF7tYinwXG5aRlsUimKUMSKokotD/nbvHXdk=;
 b=QBHaLMBnXCIhFbfJ6y6a3H/lCRB2mit+5enUQN5Jzy11vqd+fluEjrqAB2lSxucU4yGzU0DISKitH5euF7fned9zmrwWlo4NDMGUzR3C+gKTwV1mx/Hn82Qhg+VEJa5T8QCwL4Ga19opUivi1LksiZZfVaOhiEuBbp2GVfSDYCN3Bq3pPGeJk6BfYlBL9jAwPaNhFVQTPTN9w2SwpnVG+jKVBLaLnbix89b+t0N7CCaURKAd8Bk4kxSHCM50Wflns9r/ix8AB36hEzY/6u99MmY+6JSsMjxzExrmM9kFLsRfac8ZjgRBnRVfnLLd0fsgFLGIz2Zp8Zm95pOFRhN0rg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SJ2PR12MB8160.namprd12.prod.outlook.com (2603:10b6:a03:4af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 12:43:24 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 12:43:24 +0000
Message-ID: <43d2f395-7e36-485c-bcf6-e9ce0d981256@nvidia.com>
Date: Sun, 22 Nov 2026 14:43:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 08/11] RDMA/mlx5: Resolve core device from
 ucontext for DEVX resources
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-8-8efd124c7895@nvidia.com>
 <sashiko-outbox-221137@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221137@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::7)
 To BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SJ2PR12MB8160:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ff2178-b4c1-40a7-2060-08df489632a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|11063799006|4143699003|261026140227099003|261026121527099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GEXH0roSKyw9EDi6EvXD9KzDb5kqTtAiY5b0mz8QHl2RkwC1pO6oZKgBtp74tWGGo1yP0LW5NKLTDzdd/d6dzqYupvyCOPK7D6IO7VKaQP4GY6m2ELvG8Kp4U2fnGxm8r7WAaB2TtRVmoXlpOqdC3+EjTVQYIZibx6xq/ZxHJOUSc+ZU6nmi8P+Kt6Pw+RMD2gWwd2BSfR6loE5AtDntmrYPWN3K3mMWp9EPs7vVJ1hCdWfj5anEKoIPe+uvo/fYOvIZnlYIJXRBf8mxUJEXVuN+GeJ36K3p6OzZHxzrUa+ImwaXVxn9+YPM8aSMuHVp9dHqZZ56Z4MB6rLegGRCVEk07QOW5p6lZYmPH/shUEpz1UQIsG9UbM3W2kq007WUze29gPugtZGvgNOux2cxvbIYSRuHckp79W6oVu2CjVu364KM+0rEvgE4vaHQOXj4YJNjXO6dgQ6su7IFSxNiULNYSOPHZ/27VtMsEQOZz7cgLUE2ZVPmfGvCqjHuXSniKs9n54Z//8ub8T4y+Ae99UgnD6MWGYjfxMDDlkWsCPBCyY1OgH3/ppaMcl8My2HWeoirMK/6z1jRMtQ4sL/tgyulk4Fal6RSjMt9suCgN+g6po6sULOwH84Svb5X80NZg/ejuPudz6FkhqqoHYpQ8Rc3MOmbmEhypFMDblC+T6A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(261026140227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkFXYkJDenNrd1F6T2g1dU1KVVJyVE1LeXJzR2JIREhsSlNZeENBMmg0S0tU?=
 =?utf-8?B?STlvVUZNYU44NElRSmthT1psSG9sbGdKUktqRXRSU0E3Qys2bC8rUUhrV0x0?=
 =?utf-8?B?TTIwQWJxV1JzMW9Kc2drQnFUSEpsU0x3T0lrcHRaL0pucDV2QnowNGE3ZW9U?=
 =?utf-8?B?UzNKa3E4NXZDRE1JSGRNSjVQbm9vWDd3SEkvK3NFSHJ2YmpZZzBuR1dBckM2?=
 =?utf-8?B?OUsxeHhLbFhkK3oyb29xMC9Yb3JmV3plcGQyZ0h1aFlITW9Na0MrSkdacHlp?=
 =?utf-8?B?dGU4Znc4RVZoR1VhRFZFSVhiWUl1WTM2ak9zTjJVbE4vdnVOVlBnTlN1d0ZE?=
 =?utf-8?B?OUNsRTcwcklhZjdQNjdhdHJIV1hYNk9DclI2aFU1SWkwWG5rZ3VUWHRRZzVP?=
 =?utf-8?B?ODVMSENtR05kMjM2TVpLc1lFbTlubUIyeitPaEw1V2hwOGd4b2hsR2Vzak8x?=
 =?utf-8?B?eWVwRHVEanViQ2JFTEN4Um1wTUxzZXF2QlIwd0FnMDBtbjRhTVJQa1M1QmNV?=
 =?utf-8?B?aVMxOGZBVWdRT3BFTlNQdy9UbkphZ1FjVCt6cDc5OXM0UnpmMkQwaVBaK203?=
 =?utf-8?B?VXdCekYySXRFVm5hb1h1L2RJQ3U0b3prU2xXZ3p5ZUt0dEZoZkdHNUh4ZlNv?=
 =?utf-8?B?djFWdXcvYzcvZkRObFFrekozK09pKzBDK2cwTmQydldXamwrOXdBT0daVXVx?=
 =?utf-8?B?cVhWU1RkSFJrQmUwQk1nUDE3RVZlYTJMbXNPWEJ5Y3lTd1BtL21XaEJWRGR5?=
 =?utf-8?B?blg0NklWbDJzUkhjeDN6M1VLWWVMaUtDY3ZHL3I4L1Axb3BrQ09xRUw3eGR2?=
 =?utf-8?B?clcrSWRCeDA2S0cwTHhoMDI4cnpLUXlBenNRcWllczc2eWduWk5pUnY1SzVS?=
 =?utf-8?B?Z3hjalVDSmt6cHNNRmRFbUJTT0taNXlZQkVsMG1jcnN1T1NBV01PaXk3L3RZ?=
 =?utf-8?B?ZmpidGg2aUZvSkVPLzZQOVFtamFSRG96RkVSaVNQL3NwSGl5eUdQVmNtSGxE?=
 =?utf-8?B?amNiaUwwTTZhaXBrUUI1ak9IV0wxbEdBNzZXNlYxVG42Z3pweGwvamhpbmFO?=
 =?utf-8?B?SkdnYnRIQ2QxakcrVWkzUDByc2ttc2JzeTRiYjNpUFE2Mkt5UkNQODFzS0xS?=
 =?utf-8?B?SExGQ1VwNlV6VFBaZE14OVJSaS9UT1oxTWdZQmI1MTJ5UEJ1Z0xNc3g3c09k?=
 =?utf-8?B?a1o1V0tFWWc1alV0SkFGZU9YVjk3ZzNia0FQVVp0VGVaRVVsQktDdFFnQVBZ?=
 =?utf-8?B?OXd4TXBsWlhOZ0lIdm10UXRIMVZzbmhacndPWHo2eU9uT01DSkhvRkZZSmtG?=
 =?utf-8?B?c2IwWTBmSGkxd095YmJFTTZmb0hVaGRXemxQb01QSnArd2Q4ZGlSUTdGMTc3?=
 =?utf-8?B?ZkhNcE1IenYwS1FzL3ZnWUxDT2FJbE9lVHM2N3l0cUxacitZMWpFMkRuQ0Mx?=
 =?utf-8?B?bFdueE5VelpWYytMU1E3K3JxQ2dCcHByZGVaS3FIamxHOFk0LzlvSE80T2Mw?=
 =?utf-8?B?ZUZKNHJJTVJha1NNSEI1ZDBZUndKUFpLR0VxR2lRbFpMeHF1ZjBjWkU4Ymc5?=
 =?utf-8?B?RlVWMEZhODhpWno3MktZcWJqQnd1TWxXVzcxakt5emcwYkdyS3JwdnZSYW9O?=
 =?utf-8?B?eVJ3cDdkK3o5YnppZkZHKzZjalBXeEkwRVV2RklNNHg3ZHo1cGhhQXRoNTlh?=
 =?utf-8?B?Y21PakI5NkhLRGhZb3JuV21RSXJJeVhRcCtBZ2RXNW5Wdk1mUHF1T1hicFdX?=
 =?utf-8?B?Q0JQdTRONmVkYTN3anNDRE02aHJyZXVYRmREVFFza1IwakpwTlBzaWhKTEty?=
 =?utf-8?B?Y2FrMmhZUExicW1xZHR4VkNHRElMZmFxZ3cwNWV3b2M1anFjazdLcU1kaFRt?=
 =?utf-8?B?Vy93N3NLSTFzbXZFTHlMOUJTRGdWTkJCekREdDFSMHVQWHBWYzdBaG1SbjBm?=
 =?utf-8?B?bUpMY0FYM1c0ZzJlV2Z5SDVMY1krRitjeFhRTzlrRG5aNXdzSkxDbFpjeG9F?=
 =?utf-8?B?SDZESFJJY0pxc290ZXRyT2ErTm00MTB1TEtxT2NEaGJGNU8vWGJLanhLMndi?=
 =?utf-8?B?TW9DdEVEL3RBeHZzRTNGME9wd0k1aXA4b3Zpcm0rQUFUcXpNdHp2dnkvclVa?=
 =?utf-8?B?cmdHS3pKUGtkaC9yYzNoYzRCelg5NnpuS3R2bWVScmtoQUVaNkU3UGFOSElQ?=
 =?utf-8?B?YzNHc2FoZWUzMEdVa3ZmZ0twK0FTZkxCdU9USG1zcmhFWnk0ZC9jNU1aWUxx?=
 =?utf-8?B?RzdpenVlZWtXVU5RNk8xbkxlQ3BHU1JBSm9OMldNektOeVl6c01wNXcvWlVX?=
 =?utf-8?B?VWo1Z3J6aTlHajlLZGVreWJlTndwd0RpWXhLMmZEWTdpNHZDQnB2UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ff2178-b4c1-40a7-2060-08df489632a3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 12:43:24.3766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KrsiMTkVtUbBUjCoN+QJA66BllbshBgErYDJBhZCj+IrKW6JW3/InYG6g+VXwvDDd2Fye90rqkuEDAaplmfiAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8160



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] RDMA/mlx5: type confusion in
>    UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)() [1]
> --
> 
> commit 9b620675534530ff6a87e491bd8226b49883a88b
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Resolve core device from ucontext for DEVX resources
> 
> This commit introduces a uctx_to_mdev() helper to resolve the mlx5_core_dev
> from the user context for DEVX resources and removes redundant mdev
> pointers from struct devx_umem and struct mlx5_ib_pp.
> 
> [ ... ]
> 
>> diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
>> index fbb46d821865b..31a7c0f72b40f 100644
>> --- a/drivers/infiniband/hw/mlx5/dm.c
>> +++ b/drivers/infiniband/hw/mlx5/dm.c
>> @@ -209,6 +209,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
>>   {
>>        struct ib_uobject *uobj = uverbs_attr_get_uobject(
>>                attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
>> +     struct mlx5_ib_ucontext *c = to_mucontext(uobj->context);
>>        struct mlx5_ib_dev *dev = to_dev(uobj->context->device);
>>        struct ib_dm *ibdm = uobj->object;
>>        struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
>> @@ -223,7 +224,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
>>        if (op >= BITS_PER_TYPE(u32))
>>                return -EOPNOTSUPP;
>>
>> -     if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
>> +     if (!(MLX5_CAP_DEV_MEM(uctx_to_mdev(c), memic_operations) & BIT(op)))
>>                return -EOPNOTSUPP;
>>
>>        mutex_lock(&dm->ops_xa_lock);
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can
> UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)() cause type confusion when
> called on a non-MEMIC DM handle [1]?
> 
> The handler casts ibdm to struct mlx5_ib_dm_memic via to_memic() without
> verifying that to_mdm(ibdm)->type is MLX5_IB_UAPI_DM_TYPE_MEMIC.  When
> userspace allocates a software ICM object such as
> MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM, handle_alloc_dm_sw_icm() allocates
> the smaller struct mlx5_ib_dm_icm instead, so accessing dm->ops_xa_lock,
> dm->ops, and dm->ref writes past the end of the allocation and corrupts
> adjacent slab memory.
> 

Already fixed by commit 4fbcc12ae887 ("RDMA/mlx5:
Check the DM type before mapping a MEMIC operation")
https://git.kernel.org/rdma/rdma/c/4fbcc12ae887c7329b06b2fd1eb1244eda035a16

> [1] https://sashiko.dev/#/bug/linux-56314797-6963-404a-8cb9-efc7a99eb571
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=8

