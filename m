Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB94C396D15
	for <linux-rdma@vger.kernel.org>; Sun, 14 Jun 2026 08:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781424597; cv=fail; b=dmEGN6x27knxxQIi3CzcsYxZ2UxjcgOKJ/H8hmrCPo9fPzxbUdTprhrcfV6OkGuHaq7cbF3LF8vyhMS+C2iv/MpRLFDuO2zqrzHDtZWnwVaYvFGZSt9rDFUu72ygHp+8iM3XrcryhDBr0u8gXLqXinsQxRmvYWTajOtE7P0a+NM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781424597; c=relaxed/simple;
	bh=3q76lSoJarg5OIBn4DtC2TzCndKqh2BkcuckYONjPnE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SpDFMcpB45GUxL3fclCKzJidSjVStzhdjCQrURehQqeq5zml/GCRFtznZkvs4p/TWGRuduHwmdE8GlzjVPb1axSyzQ0vYzqy0UEuPjzdAcXmHLgbuFLw8cjO08jrEPrtK+h2k9zMD86jpjptCdO4hAY7Sva5kKZLLEPftgLUxOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UtCnl9wQ; arc=fail smtp.client-ip=52.101.85.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UtCnl9wQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Si+6M7SIl54vxxHoTLiel/9oPK9d/vE/P5K1dLY/gxi4X0UC6WMENBt7iI3hB0/RlWMbaNpgco2JBI11VZeUfUnbiwzlzDAGG/Uts4ztQr/Pqh7aGclGq+c0Sgk6VV8WZ5JywlvzPI0VrowjKYofhpLjIbzo1AsSxr9m1mn5wR4zum/fNYYZfcQCejdaXqWSvrcyplC3cPfJ+1UPClP13zQ0aJpz2kce4EP/COSEf7NOyZvRRn06K4K2BwnXBvVAATOFPlsrbl1KCDUeKPvXNBP1OW5WEM3mkQXXjFvKiIBxS52YH1BI7lSn+xPe9ApbTYIwqEUh2eGHe2YkHgKFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afO/RksiyGZpPdRktabF6yH0IgANSi2z33R45tHq8BY=;
 b=HuW8l1u0ZlrtZ1GooP3kQWH9EFkVkJfaiOIsVfShGkfr5CWGKxKfrK08wq9wvqaI/n6YiRjPg5en9KpHoqZR1QkXSJqLNsr/Nk2YPwe7eAvugM4/J1Zg1DqEWVZ51eHV+Uk4DwDPLbhUaagNpFIIXgZIKPIEgyGGf7J6LPOr1dPcY0210jzAg0cmXKffcIjFZgAXKVH5e2bPKlF4OtWWlY/Tj/0M1Qs3xeDIz/YF/mT2Gqwkj8ZPuhUxvzsdrXeNEW000/YBESkmCGSTu51hF3z1jtyXRyDbtWZiLLUswrn5cvLSZEjravv9Xjtzn/b93zoKPWvvhEoLMdfR2NhweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afO/RksiyGZpPdRktabF6yH0IgANSi2z33R45tHq8BY=;
 b=UtCnl9wQRcBWlZMA7samTJMWpXmAclfhxAV7SN/x2GXYWvkh0xGY5scM1S6zsl7anDaR35HVZNGD09AY5wiaAlEpbsyOTmBVnAg+SvOCBZVyGB2Q/W9tfh+Lxb1ymetQ+ejtUtQok1xJySHrufvqSlN6hdtMJ9a1Gp09+duoMuwkL5jNoJzmnMakqIbJjXpb956FTzgTJF5oVXx9gCO9KNJQSsd7wDJO7+gdD8sOo/yvNMecDRZy/Vncl2EAU27WK6dvATQCX1VLrRxBnFaAEWMFxEb63TbCvuS3Snrm0ANfNaIWAwMlbB3Is5pUpcw49SwovNenZDkNVbFyAZJw1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by DM4PR12MB6110.namprd12.prod.outlook.com (2603:10b6:8:ad::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.16; Sun, 14 Jun 2026 08:09:51 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0113.015; Sun, 14 Jun 2026
 08:09:51 +0000
Message-ID: <6e79ac63-ec08-4033-b8ff-77a40e302e32@nvidia.com>
Date: Sun, 14 Jun 2026 11:09:47 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] net/mlx5: free mlx5_st_idx_data on final dealloc
To: Zhiping Zhang <zhipingz@meta.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Yochai Cohen <yochai@nvidia.com>,
 Yishai Hadas <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
References: <20260612170406.3339093-1-zhipingz@meta.com>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20260612170406.3339093-1-zhipingz@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|DM4PR12MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: e538767f-0464-4b2a-2d61-08dec9ec4f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	trmc/p+srsaY7G5K9l1nT3EsG33fiqi39AcgUPRXX8ZJdIghN1ro7WvlWJkJlAAJn8bwgIIpuOySBAxs3ydtq/VMEidCE8Q4OH+ctAUMA2FtiRkmjB3AtGIcnNz9N+jCbVVZCuCO2BIbEC0XV/OAj8LHMquZo3yRB9rXwJU7j6kVSDw6ki3E0qmROy74Ok8RdQa8iQglvGj9IrtsEAvNL3XC+yfToVvka8E08/vRpTOZ+LH65hpVAFRNloFs41S2iixGDDo38sHnbrJPZ04OMFKb017zvEmiaWqfhgzZZgmke4qyGWZz81klTtSSAfVYzVfD8MWE0UvyVU17gpyf0yCpyEmqvf74XRyTji3ArWZDslwf4mv9ylOWuu2MqCg13rxo2KAXbTyU+Ny1NSHNBwBCpdK5SLFcyaCJvXVEfCYy4r3SlT9uB5t9d75TcMIKhUScqoM1+oeRar1T19SYj1rrp68CYBP9n/BjRhqXfSovLlmmzSuIJp+s6ncdIsqWipB+eS/FnehFJWbXRLyreY95FHNq6T0/OrG6eG59RLIL53uJ83N3/ONDjVWNKqstJV5mzk7nHFetCKWkn43tSvQBasImIc36Wzj6aTrcgMPwj6C8Su0Bk8OneShMxH3WKZVx2+cb/ibP2Zw/r0+Ezs9VLpGIKStXD+hzPft1YW1wqy7PhlhkMUiSIHzbR7ST
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFhrZHd5UE55cDgrM2MzZEhISHhBbjY1N3o5U2x4UCtycDFGdlJpWG53RW5Q?=
 =?utf-8?B?RWphd2gyL0MrODZvaWpVWExhNzhWUnNoMlpDakN1bU90ajhFM2VOVVdVbDlJ?=
 =?utf-8?B?NDdZbUFNV1g2b3QwVEJCdE1YYkIycnlVS3pnbjNqcERZdVh5SmNqanFYM2Nx?=
 =?utf-8?B?emg2amxXc1ptSndJNmtiQkR2d0ViTFZCajJZdldBVkdUT1A5UEpQci9YdXBl?=
 =?utf-8?B?Qmd5eE9QUEFmTnRQVkEwZjZ3MURFNXZkVkt0WFpRM05zNnVBdHJhRllNOExB?=
 =?utf-8?B?a2E5K1R0MXFtTjNKTFJYWkF3MGdOSXFUMWtwSmRoMHlpWFQ0UkJYcVZFemMr?=
 =?utf-8?B?SUE1ZTZmN0xvN1g3VGxKMXFjL1k5Ui81aTZFZGZHM3Z1aUN3eXNXcEsvb1RS?=
 =?utf-8?B?Ny9vT2RWbnV3SEhXQzd4UUlEK0RVVXVaWGIvU3BFYzNZY3RxUFlIakp3NzhE?=
 =?utf-8?B?amdLTERvTjd1Y2lJMVVQb0U4ZHBwUmM2OUVCZEUzbExpejFiSys5dnlzdTUv?=
 =?utf-8?B?WHhISzRNTjlSekJ5STR6czBqY05YY1pYakJwL0lUeDRDUEpRcnFhZU1NTFZp?=
 =?utf-8?B?VDBlZmVOREQ4dWJUT1lZaUZ6OWZZeUNMNExIK0cySDZ4U2hWR1h4ZTR2OGRM?=
 =?utf-8?B?YVVSZyt3RGIxbkdVdjBYQ0lZMGR0aHlCMkkxMWRBVm1CRXZxUXF5ckdSTzVG?=
 =?utf-8?B?Z2JMSndHR1FpdjFBSzRQbWN5Qkozc0VGQTlJaTRPSlllUzk3QTdEaWxsV3c0?=
 =?utf-8?B?UUdCMXROTDU2MVZFZjkrS1A0VUt4QjUvUlJkdkkwbVIzS21HTVFzSzZWZ04r?=
 =?utf-8?B?Qlltb3BoQm1yaGNPV0pZSU9EYVpUcGw1VDV2akpCN3cxZEQ4V1pUNFFwVExq?=
 =?utf-8?B?WmZncmgzd2dFZ2Y0T01vbWNNdi83ZFFjMEhnSklWcElobXRldWJPNlpGWW1z?=
 =?utf-8?B?NzcxUUxLQUJuMFF1Vk54ZENDVHRHV0k1dm5ERXhoSEI3eGoyc0VMN3RwdEQw?=
 =?utf-8?B?S3EvZ08rZW1QMXBiOXhuQ0tzNWo2YUhWY2l2bnF3WUE4L0NaZmlPUXE3Q3pp?=
 =?utf-8?B?a3RKZmEzMjQzTnp1MVdLMkp4WG5nOFpGYjQzOE5LbUtaSzF4T2ZjVFRNaktX?=
 =?utf-8?B?aCs0cHhZaHhXaHNtS0R0Q01OOFI2VkQ1LzY1MDNobysvVTlmbUNYbTNLSlll?=
 =?utf-8?B?NTdHUnJDTFNVQ3lmWEdPNC9peDJ1S1Q1WXdnNW9pcFF3cjdDaUtQTTlocEtS?=
 =?utf-8?B?b0VzRDVzNGV3c01iTnFOTjFJQkRDSUQwY0REblAwbk4rVlpUNkRlQjR0SGo1?=
 =?utf-8?B?QnBsSXRlbEt6UmdsWDhzR2VIeXBXb3AzRjNYTmZpRmhnRFc1SDJOUW1wSFFz?=
 =?utf-8?B?RjdsUEJmS2FoRUR6MHpjZkRXZXFQa3VVNVlGSGJxOWVjS2Fmd0VpajAwRFJ6?=
 =?utf-8?B?bmdqeXR5VE1TTXhJSFZJSlVsc0JSVlNETytieFQ0dkxXMnhuNkozSUlUQ2to?=
 =?utf-8?B?UHMzOHNabU5DRE5jT3ZlcFVpN0ZoeDZvaWVmc2ppejlieHRWTEFFZXg0S2I3?=
 =?utf-8?B?UWgxaGhtOGhOZFY0SGpOc3ArMEtLSm5YSmJQVTB5cGFhTWU0cWtGY2FZREhr?=
 =?utf-8?B?YS94ZTBVYndPdjhOZ1hGQzNZRUl1SThYMnVkZWVqdWZTVUt4TVZaSng4VVdQ?=
 =?utf-8?B?Z2JOazFtZytvYThkbysrRTEvMnlXTk5USE4zMnJWcm9FOUdkakxJQ1NKUEor?=
 =?utf-8?B?WnVDejRhbWxRSVQ0VEZXMlFUZDVCZ1dFNllSYUxxbDN2VDMrajNvYkdJOEI2?=
 =?utf-8?B?UXVHYTdjZUNqUDdCUXYvVU82U09zRUdYbjY2QXBPeEorSDYzVlAvZGVGY2Nj?=
 =?utf-8?B?MytnWFhDSVlyVHVRT04zR0g5YXJEOHhTODE0anhyR2FUSmR2UlRya2F1V3I0?=
 =?utf-8?B?dXRBL3cvUkRPRzdNUDQwVjBGSGpWNmRRcERET0FXcXVxYWhUUTZtYTZ1Y25z?=
 =?utf-8?B?UStkSUtwTEUzQkhpMXdKRm0xaGlDMlZqQUlSclRzbm1LV08vTXZyTlBaVHZI?=
 =?utf-8?B?RVFtVENTS1puY1NSTGlNMG14MmE3UG8zbldhdUc3L1o1KzV1d1Q4STE0THoy?=
 =?utf-8?B?NlBHOG85bVNFdUdOTE5XbVdpeU5WeFFQTkZYb2ZCdUxBdHlGKzFlY01EL0gx?=
 =?utf-8?B?QldocXIrZFkvZ3lqQ0owWHFCWDVqTDN3K3IwU01nMGRTVlp6R04zR09ieWRu?=
 =?utf-8?B?QlVOZjYwZFlVOGRTL2VIS1lJSmhDdVg0N2plLzRzeG1RczUxYTludExHOVpt?=
 =?utf-8?B?KzA4Y001OTFUMTZmem1vTU1UNGVhRkhneGNpbHBzaXdlTWNRTHBRQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e538767f-0464-4b2a-2d61-08dec9ec4f08
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2026 08:09:51.0244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLctxN553s8+WTNH509P0Wyanz+eqg219Toy0LpBKgoFRWozEh2Mfy/b1LOnM37LW6y1MYbfyN9n31e5crrzGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6110


On 6/12/2026 8:03 PM, Zhiping Zhang wrote:
> External email: Use caution opening links or attachments
>
>
> When the last reference to an ST table entry is dropped,
> mlx5_st_dealloc_index() removed the entry from idx_xa but leaked the
> backing mlx5_st_idx_data allocation. Repeated alloc/dealloc cycles
> therefore accumulate one struct mlx5_st_idx_data per cycle.
>
> Free idx_data after the xa_erase() so the lifetime of the bookkeeping
> struct matches the lifetime of the ST entry it tracks.
>
> Fixes: 888a7776f4fb ("net/mlx5: Add support for device steering tag")
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/lib/st.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> index 997be91f0a13..7cedc348790d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
> @@ -175,6 +175,7 @@ int mlx5_st_dealloc_index(struct mlx5_core_dev *dev, u16 st_index)
>
>          if (refcount_dec_and_test(&idx_data->usecount)) {
>                  xa_erase(&st->idx_xa, st_index);
> +               kfree(idx_data);
>                  /* We leave PCI config space as was before, no mkey will refer to it */
>          }
>
> --
> 2.53.0-Meta

Reviewed-by: Michael Gur <michaelgur@nvidia.com>

Thanks.

