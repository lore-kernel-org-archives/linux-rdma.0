Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795350934;
	b=K7TmaUoVYizfXauN3nPza3CgXLfUmIzaV6mHF/TOjgO65a3AcS1w2ZwKYOu37POtlazd
	 YzF55we5F6NjhyRskuGHL3cTXbS3UqhO7ENr6+n5ylBjaCxEbs2KZEycPTGe/sN3HGIgS
	 g0xTR5GuHsj8n9r5XHvSjyUHUQEi1YPr82BNDxcAJ8VxJVtXH/ow+sZqhId6ZVL2lgf2p
	 VtK6VYQDGJv54tyIv2CPTpzzvhVGUnYpd5dGL9xl/1uodAdgx/40XP2sqiDtMRt1zTzvc
	 NwHybG2m5wKb5+yY0be8ozU0xBfnQS4HIQ74O6DE0Yzd6q9F4iV6mUbfB8OO6DJYbxg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795350934;
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
	bh=3ouhIVKSEAE6Iu/774+YGeTnhGggllrzAFxyel8GLO4=;
	b=cP8LFrEYfQKCNLy41g4IXLusiPMGvG7iKKVw+3RjHG/e0ZKoSxb/SJKrUMD/8V4fYF9Z
	 t3OkskoE6C+pN7CjCCLBNNvtNihikdc1iN3KnAG/H98R2CsHjNAQS4fmgxsbV2ruy3gcV
	 ANg9yJzccKArFslq4u9k/qs3HA5rbqbKATUfNDOSAhr4d7Mf6qRW8+O3FHx3L8MmkY8jK
	 +W1lyL9z8U5FK0ul1qpyttGEEHPFPl3rspqhYCd7f4StqiAtHI3ZK5dQ40RyGkQn3y+sS
	 oQzwZVB8jGUMUvi9TWLuPQ9sx3VVtRqRerpwFxaR2E994OzaulX/1qcdRWIAHWAlBiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=etmFSBxb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.15
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010015.outbound.protection.outlook.com [52.101.85.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE7A606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:35:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FE7A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=etmFSBxb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMyCQM7HgtPZ17TOEegOQ5bgGQz+FSDv58BcWG+iGSSYe32WgUlCjMIyakq1dpsE6lTvr9OiVWieAHQP7SQBABNxJIUW/OOmgUOzUSxYCybA4PrhRbFEelhbss6u7ZcE2SsDIxFmoLVpp2pdWvHlilnIpByRkx52OvJ5pi8+JXwPvsxiVgWH2Wx4zxjebZYKu+BN4UbUnP97XGE0c+Z/TxcpojbrwoJRPBOkAVwDMwkuro1tr5+gXTwS5GDV/8GNMjxHpi39pm70P0yA8N3VlfsKNIokOJSAVQ9KnH5H5SyD0iqZNdT3seJBl+EcovV4fi9NMyGqDFYJ6agBOM73+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ouhIVKSEAE6Iu/774+YGeTnhGggllrzAFxyel8GLO4=;
 b=SLgnLnbyttOTx0Q0Fq946wlWQ+JulH29V/r6Y95Ne2Ou4ca81r5wZbkn0vr+dthm+zcAAJJCvgcIHnCA8QXfFnTJRpwkKdtBVCSoU7IUEowFR8Hws17wuq2MOhcf/EnXnywwCSVH4qj9GPn/HjNe3jpk6CuEfcmuIBP8wFqfiKglyShWvHLxsFuolaCdAIMISIHIbgMt2yDpzfbZsTdHGN++S0hKBptg9KOWByD6mfpzLK16e+WioSf+9Mb6p9eD2wtjPASkfMhxW+SpvxotXOygKzXTIN6nWSZeTGvGOp3Jqk34oEb3flnppIiCXCw1hbB1ltmHrhdYpYL799HVyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ouhIVKSEAE6Iu/774+YGeTnhGggllrzAFxyel8GLO4=;
 b=etmFSBxbupMRhGAsXhKU6rQdfF6s8jxU/z0N92OmglTKeTdNwfWNSQTsBJ3vGTqoKEX+TooeCF+c+jPZwMhbPJtMk2nwFAIglu5CXroZV+mPNy9ToihONimNdmk7Wv5KGgH6WkfMyRvKTLFquZWjzYe9k1Z6mm1lwq6WiuG8iMIMo/PJMreX5rAUGiGb2PdV29MR/uNJwO+mavsL2NWpbmbwMMqG1tX38zk+ZLJNRTW9skTEsHojrqFIdCf1TYaNlrb+6wz77dMrfipzftxP5EVOYOmo2rgm8y0MwaAsim5IV8wBzMjkaF3J/BbZhkvNqy3AN1rA3VH1nJd7ezq0Tw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by PH7PR12MB8015.namprd12.prod.outlook.com (2603:10b6:510:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 12:35:30 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 12:35:30 +0000
Message-ID: <b8d363e1-da38-4f5a-9bb3-82722e75ce62@nvidia.com>
Date: Sun, 22 Nov 2026 14:35:26 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 07/11] RDMA/mlx5: Select the QP core device
 through its PD
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-7-8efd124c7895@nvidia.com>
 <sashiko-outbox-221136@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-221136@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0011.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::14) To BL3PR12MB6473.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|PH7PR12MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: 082f6b26-8685-4ba8-b716-08df48951852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|261021121427099003|261102123227099003|11063799006|4143699003|56012099006|10067099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MElD0cdRTGKFjAhDcwuBBTkNpa6UTSuPL8yeXJrgpTxWmU5KbcBwVfOkIyi5QEJsSxi3qNogK5/wZN9M11KF4Z3H9nsTbSIUsEvKfaMUajpSsqNr7CoTb3Iu5DpQ40D23a+Dxw6oNLyvWQu+6jukgqb5y0wza6lRSDCSh4rKfKWmyorZDXTUjbzFSCGpPyXmF1Ya/L3JWM+wMDDNqvqPF8TDhS04zyTn8O02fR0C157BF7IkIhZ7VwpJQjWI6ZMQ0Q0D0n00iDp7j6YTQz0dVodaJXD0CMHHZBm+8XHMT/KafhIVtrnFzlHwAhKFkfZHuQSQbj33upiSGPjo4O87K7Rv54p7Ox9nihqIzX5L55lUJVJMUa/qAQbteSSTHICn/VO/V6XtF9vlvydGE9ppfe3T8EL5QtHyyR7ZqNkYcn6njXdUR2hnLK7XZSXDpBAUVdtXBUkZa6E5FK8C+WhMsfeOZPKq3s9Bdi/eFgXQU44mwXEkV0ORR5er0zDiuntCXbLy2EEqp090QVQ/XCubigVyCItOkPxumegj7OD2BR9GIeDN2wlmxA72FKHGQL4JHS8eLeGIFidcBLCg5ozsvbKBvB3cTICTlkPe9lgvILuo0QTV3hTKg79bTb5GjHZagIHkc3++iAb6tAxVYsvEoAiso7wGj3+3PvT3SJ+Uv88=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102123227099003)(11063799006)(4143699003)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFpkUExIRVkyb1ZQTDlPK3ZIREZ4RFZ2MS9YakYwam0yd3pRU3Z4d0hXWnFp?=
 =?utf-8?B?cm1TRitwZm1rWDlLTEd1d3QzMm91ZVJjMXVuMXRIUXFWdWpPc1lRY3AxNWkz?=
 =?utf-8?B?K0lXUkc2UDg2RXNObjJvMGwyblBCTEw1L1NiMVYvN2c3VUwxNFVrdlUwclhD?=
 =?utf-8?B?ZFVoSHVEY3prTFZ4NGl1by9ZeEsyNWVsMnMyek1xNlNEVmwrU05sT3pvSm1V?=
 =?utf-8?B?VGNlTktkTUZ2WDhPNytPdFVxYzh1cndQZGVFbzd6UjQ0b0l4cDUrZzVCMThJ?=
 =?utf-8?B?Y1RPU3VyMVpFeWNOWXZ5MXJoejRvQkh4M0VaOGdna3hHR0FhWkJreTVzS09P?=
 =?utf-8?B?ZTd3WnBMRUp0U3JKYlE3Wll6MWNaeXVDUHNRNkdCeXQzNy9QZlhFU0RiVy9Y?=
 =?utf-8?B?K0NIcUUxbmhBc05rWS9CeUoxYWNiRGdPTnJkWWMrOE5BcHhrczdSYlRoUlhq?=
 =?utf-8?B?RTdXN2FhbFJ6NW9pMXhtNGZ0NUdJT3pQVk1wRnNQMFRDNUlCUFI3QzBPN005?=
 =?utf-8?B?THIreG4yTGhXeDNZak1ENTVva2k3bG5CNXYzRmQyY0YyekkycUNnSitHeEl6?=
 =?utf-8?B?QnRaWXQ0b0JZYXRibVo4bmhQWEh1clU3YUhXaG5aYllkVE9OZE8vbDJEV3dq?=
 =?utf-8?B?U2F6OVZ4Qk5CQVdjS1NOUmlBTWQxYmtmZkhTQzgrRXI1QVYva3JFQTVDQ2JV?=
 =?utf-8?B?cENxaW1IcXo1T0h0eWh4TlNUL0UyQ2l6akVmdldXbDQxV0hEelpobFJTOGxw?=
 =?utf-8?B?YmRhdkl4aGM4dUlEUWxmL1E4ZU9iWXo3YlNwNER4RjRmL1N2S2dQZnFxbTVq?=
 =?utf-8?B?d3AvZzZBdXdaWUxCSUltRUtRVTdWMG1Zcm96Tml2SU9XamtxZ2tWcGQwRy8z?=
 =?utf-8?B?aXllQ0NrT1UxOHNlbitlYVpNdTVaV1NVRWdDanlZaHRBL2dKR1VXMUFPWGdO?=
 =?utf-8?B?RHdvQndjRkV5Uk9aQkFJVEVsQ1pndE82ZXlxVVgvdDdZKytPdmVBK3YzaUhM?=
 =?utf-8?B?NmtoelBqRGhSRUZxcklhZFJVajlhMnEwQjMzN1VWYWF0SGJ4a09wR2dFUVl1?=
 =?utf-8?B?dExhN3lNVTRzMWtyVTRNUnBXTUlQcmNUYWNlTUdtWnBIek03Tk9QcGt4TzVr?=
 =?utf-8?B?WExEWHAyU0w0cTZZSEpDNURUYm9ENWdzOFZDbk5BZFE2KzBaNnFwV2hnR2RC?=
 =?utf-8?B?djkrNXZrZExKZGxFYlV6cWtFdERzb24wdGxnSGJzK1htS1g4Wm5NOW90Z2Jx?=
 =?utf-8?B?SFYyZFFrOEZISmFHd0s0THJleHY5YmhDZURTdDlIVDAxajM2Y0xpcFdiNDhj?=
 =?utf-8?B?eG0xUUcrRmhYdUdldWNiVjJjNVd6VVRvekQzVTRvT3hhekdoMzRDYlB4RHRu?=
 =?utf-8?B?TndpbE5RbmZCQXNqNFJMeWIyMEtnVkJuOVVLYitQaFFjSHRvaTRFOUt2QXdG?=
 =?utf-8?B?NGtiTWRTcUg4Y3hPbkRyWkMxZmsvRnBwYjRDWTR5b3ovcWhJYWV3TTBIMXhO?=
 =?utf-8?B?MFlzUEtZT011MGJQNzZXNXJhaDg5T0Y3ekNGMTM2ZkdianBjWkVrdEVBNjYv?=
 =?utf-8?B?SXhlNVQzMGNtbWdWVHRYazkzRk5hM2Jrei84SEY1amdYcUt3aGxxQVF5QnZu?=
 =?utf-8?B?c243aVF2NWtPZGtyL1JZZ1JaMmM2RkdpdUlXNm4xSlhLYmo5UVlZdjJqb016?=
 =?utf-8?B?c2xSRUNuWE5OZXBReUR3eEdZZ0doMjhLNjYrU0YrNzJIRWk0MHlMSkZFQS9j?=
 =?utf-8?B?dTAxRmEyVlM1bnpRVVY5U3NuUytVeTNQckFrd0FZaWdGVTdpNGlZU1E0ZzVo?=
 =?utf-8?B?ZTB5cVg2aDF2SFNkRXZETmIvVXk0MmkzYjFNK0ovbTQyeklmUXhsNWw4eEwv?=
 =?utf-8?B?TmN0aitkUk1NclRCUkpaQURyNTJlc2RpQUdkSWRoSmNub2NFOW9NUEVxcmRp?=
 =?utf-8?B?NFNkdFdIbHA4VW1EM0NIdzd5cVFsSFJCVWlYUGkvemNTeGpINHgrRkZZbUZq?=
 =?utf-8?B?V3krR29jalJZdXNQZS9PT3BncGl4azVWd1BXUWlpL1lmWlhqU2VxaUdCQ2FS?=
 =?utf-8?B?cHVSN1A5bERVVDFnQVZyN2d1NEg3dGJzeUp1L1ZGTUlsTFlpNDNLQ3lWTGlJ?=
 =?utf-8?B?R3IvZUkvNEtneXdlSHNEUml5L3VSM2xxZTBCOXVsZk1iK2NtY21QazV3Z0ND?=
 =?utf-8?B?V2Z5ZmZrQW9nNXBqdExoLzNDNzhoOW9zSUVNSWlQblh3ekhSL0NsRXlpN1Yr?=
 =?utf-8?B?ZnhHSG1yNnBhWUlXL2sxZnVjb3ozRjYxQmRiTjlydFhmemVYTTFWZUwxODN5?=
 =?utf-8?B?a1FnMlI4NWpJQTlWcmlEdEZJYmhBTE80azFZd1JWUUdlaHZpWGJlUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 082f6b26-8685-4ba8-b716-08df48951852
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 12:35:30.7198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRmdrb9P+nCKYMCd/N7RHNfFG8xrscIqgsrhSVw+Ku5xq6X6+YTV5CJTLd4u9IoHi1UIxo34eN6Lk5Ng9HxmmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8015



On 11/18/2026 4:04 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] RDMA/mlx5: invalid qp_type check for DCI in
>    configure_requester_scat_cqe() [1]
> --
> 
> commit fd0bed19b1450b572f53f3dc5f8db9cab84d4594
> Author: Akiva Goldberger <agoldberger@nvidia.com>
> 
> RDMA/mlx5: Select the QP core device through its PD
> 
> This commit resolves the mlx5_core_dev from the QP or its PD across the QP
> create, modify, query, and work request posting paths instead of accessing
> dev->mdev.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
>> index 2709e5465d331..1135e710e3398 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
> [ ... ]
>> @@ -1957,11 +1970,11 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
>>        return err;
>>   }
>>
>> -static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
>> -                                      struct mlx5_ib_qp *qp,
>> +static void configure_requester_scat_cqe(struct mlx5_ib_qp *qp,
>>                                         struct ib_qp_init_attr *init_attr,
>>                                         void *qpc)
>>   {
>> +     struct mlx5_core_dev *mdev = qp_to_mdev(qp);
>>        int scqe_sz;
>>        bool allow_scat_cqe = false;
>>
>> @@ -1977,7 +1990,7 @@ static void configure_requester_scat_cqe(struct mlx5_ib_dev *dev,
>>        }
>>
>>        if (init_attr->qp_type != MLX5_IB_QPT_DCI ||
>> -         MLX5_CAP_GEN(dev->mdev, dc_req_scat_data_cqe))
>> +         MLX5_CAP_GEN(mdev, dc_req_scat_data_cqe))
>>                MLX5_SET(qpc, qpc, cs_req, MLX5_REQ_SCAT_DATA32_CQE);
>>   }
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but should this check
> qp->type != MLX5_IB_QPT_DCI instead of init_attr->qp_type [1]?
> 
> Since 2fdddbd5c966 ("RDMA/mlx5: Move DRIVER QP flags check into separate
> function"), process_vendor_flags() sets qp->type to MLX5_IB_QPT_DCI while
> leaving init_attr->qp_type as IB_QPT_DRIVER.  The condition
> init_attr->qp_type != MLX5_IB_QPT_DCI is always true, so creating a DCI QP
> with scatter CQE enabled and a 64-byte send CQE on hardware without
> dc_req_scat_data_cqe support sets cs_req to MLX5_REQ_SCAT_DATA32_CQE and
> causes the firmware CREATE_QP command to fail.
> 

This one is real. Will add it to our fixes queue since this patch has no 
functional change or effect.

> [1] https://sashiko.dev/#/bug/linux-c5534546-da56-41f8-bc32-0fc827b3c22e
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com?part=7

