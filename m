Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362DC4D2ED0;
	Thu, 15 Oct 2026 10:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792061652; cv=fail; b=LR6nBHvmBycpM+PK7r9HpMXRUlp5QCDomtiLkRy9H+VOfSktspDPYhYcUTp+JWWGXr1H0K7KwJx4lZDsn6bIrHNr6tJZvpJmnzugcgLxR2cwx77HDlnb0VQjI/RxdzFJBLeZjrHeYGwyWa1J0sQ/e5+j9QzPoGVkLCz/XpAUG0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792061652; c=relaxed/simple;
	bh=Gx4y9MUDSE2sDgBJvE5trhM5OQxpmfR5aNXNsuCLtws=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ioisKavrLFa22qmlU5Y0yomiSs1jazEiWs/ylIkajhBFx+QhoH3OTozX5VJQzIxF8w7dY/l53i2pXlesb1ioincOxGjI50DB0MJJrCPJ4HJfq8ioqNmrt10f9EEmtD5Iq0B6Bc7NytyzCwO/37vroCEl5PrtVbce/Bbb2d8OTfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dOOv7768; arc=fail smtp.client-ip=40.93.194.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dOOv7768"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clXuIJUBR4iHQk1wx/L6URu6rpmm72uliqIB/6T6hM8YqqlNi+kNL65uT3YzxJU94SIO1C9I9viSFwV6ySiCZx3ZlwG9+nHZuaRejZt3nzwspPvUoWj6odXQ0lCEdcOmeUIzTMvgvpJmvl7keMSjfeGh5Nxt7lWhYtAVETXpEcP5wmgmsJ/9ym5F1yLg9f8u7aVzBKiYtnlkl6PvUuJm3rv0PZek4G0dC0BywnDW3b94VKO4FoOipzdMqQ+dmxyw4deCeb6Ws0HfTcmWf61L33F8Zac/w6vPlNS43+KrT0zZsRe5OiigHvOvUQ5kRdi7ZiXlgzXa1MfWVsYKvdcltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di/dcpf2+IFImWIYY2+BlrknORDrI33LarWaQ5Sr/H8=;
 b=od4Mks+X1ro2k+o2cFJiFCtemDihAuZKJUcPosLeSQmjznB86Yv5vn1kPqh1l3YkK6sX75BKZbkj4Wk/fLifW8ysLpvccWkzgCa62dM8qdCrev7OUvnjjFEOyUbIUb2hv2lM7JIwSA2SsXAvLEanuZWnGQIogaNbUFXJ2c2UXrxuHVfzwClz/VqHdVzvdnx2olhM3xxAINWHtlkVU894s4j0iVysywm7rzYTRL0OdyiDxC+EApqqQJtAd9IUBwR5ADDFwS5fmS2BTIdDgqF3cxPy4uDozyjZ0Ap0sRI3i7vhjae75bkZ/wTmJuewgIB9F/S7Yy5XlXtjh4BjcQyljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di/dcpf2+IFImWIYY2+BlrknORDrI33LarWaQ5Sr/H8=;
 b=dOOv7768uN0eVZQuwMUdxLMqy9m9gzhI9EUrrpmzP919tP8B7Ccy+YCfbLRJmiMYuMoPqbymYSTdMQ5jntSR3sRbYfB7yX/aE+zPVMmS3ynkXR3DtaWkAK6+MwisnWW/UVjcSdrcBbL52G18WtAIll0sJETT28xUa8oNQFjf4wnOTAivsJBCgVx1HZbLMqZKWjrTqpPMlOF65fKY+n9UPCUkqJPtj0pgoiIVLnzVaINFlso8XEUufXU1XnpVZOj/cznsiVa9j8/DMKIjdC+VGLDCoLnCj3YJN8kGx3nheK0sFgFJUADjb8I8EsN3e/mUwZdrjuzE5JeI6xelXmZq7w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DS0PR12MB8787.namprd12.prod.outlook.com
 (2603:10b6:8:14e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Thu, 15 Oct
 2026 10:54:00 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 10:54:00 +0000
Message-ID: <662109f7-44aa-452b-986d-74ed819a3afb@nvidia.com>
Date: Thu, 15 Oct 2026 13:53:53 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Batch NAPI RCU grace periods on
 channel close
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dtatulea@nvidia.com, gal@nvidia.com, hawk@kernel.org,
 john.fastabend@gmail.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 lirongqing@baidu.com, mbloch@nvidia.com, richardcochran@gmail.com,
 saeedm@nvidia.com, shshitrit@nvidia.com, sdf@fomichev.me, toke@redhat.com,
 toke@kernel.org, amorenoz@redhat.com, mschmidt@redhat.com
References: <20261011133212.807979-2-tariqt@nvidia.com>
 <179181290697.434549.8876520561458529007@kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <179181290697.434549.8876520561458529007@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0331.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::17) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DS0PR12MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: 110daf64-c8ce-403f-1c3b-08df2aaa9e9e
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|4143699003|56012099006|6133799003|11063799006|5023799004|22082099003|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xYDYkxTfvaaeABeT37uFjZS2korAU78S0w3VoxtqmeS/rWHNzdORYj8iZna95NBVU/QoEVnWVnEAQQK1VxJIqH/IRzCHQhyNFvmfl8COwSBJhlCHjAQj1bEzeluPc+53Gk5UTM3syw4cfXWDRu7Wql2M5FNuWaZo59/wsbRvqYyAmyAnYxJouGknZ/blSSSQSRRvplUbg0P5utdOVLOx59Y1SJJQKN0ismzJ26AXKyrHbJp1sweCkgZ9PTWBUybAXxf5fAFav1Sxhzw3B3qh4tNf2Z/hhCgVZ2sZVt5zDJrsoPqMsHrkkIM6P4RZZf6pBC8ScjbWGjCAe7xUS2wewIk7/dxosQV9bMB+KEOsKHKl+7TYKrS7ClSoJrjsclph8aKyAwfG5kCothEdRfJpaZz9hwaY+dSu2VMo9p0zXhu9OSLaRgZedK/zyHjxOUvveU8d6APtgMzFbVKc/Bq8J5BXTpgH+f2iRZNwKiKHwRy6te/F0yxQ2aXjmmgNGUKYGOVslYvmbqNtozjstKekF8CKORzMZldjogmnugKU/x+uBOyp6G2WcqcLOSiza4bufnFMxVv03pXGm/wc1wJ4JyJY4OZ5z0Ws/bEYMczn6l9ejVxjxFVsla939uHjikHyNCdHuQdQwuYNgl6TV8EillxvSTdZy7IA+hkDj0K3Gpc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(6133799003)(11063799006)(5023799004)(22082099003)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U21yN3FIVFlTeFBVSmNnNXBKalpzMUNhekJNQjNJOTQreW5hcVBoR0VwYTJm?=
 =?utf-8?B?cXkyZTl3V3Bqb1ZLWE54OFFNS2kxTXRtQmRtRlRaTGpuRElvaVFzMy9maXJ5?=
 =?utf-8?B?ZDZlR1poWVhWZE5iNTVkYXJLNzNKRVVhU05aVGdBL25tVERPNDl6eGc0NC9q?=
 =?utf-8?B?RitXY3ZiSHFpV3hqMkI3dUdzUEcvQ2x0dHo0VXBZcHMwK05URVRaVEJrcEhn?=
 =?utf-8?B?aHJzdFFvNWtValkwZGU4UkZvTk9uVE5xanR3OC9CRlg5V0J2S0YyaEhEeUd5?=
 =?utf-8?B?ckUvL0ptL1hJMEI1TjVtaTY2Sy9YNUZueHVwUVpXQnVOYU9tRGl0SHRGVkcz?=
 =?utf-8?B?RjRsNzhoVWdNY215dG1PcEowRUdVNmJhc0FFRTBhanJta0JISFhwaHA1MUtN?=
 =?utf-8?B?cVRQSkthekd0cEVPUTlRZWVDYlFjVTZnbVduaXpvcmoyeExrSWROeHNJU29j?=
 =?utf-8?B?WWF2THBUdG1oNEpsTnY0L2tlNW9YTFV1MkNHNHIwbzdIRW1KUFZkVXZ0dG9O?=
 =?utf-8?B?UU9wS2EzeGhCSmhlWlA1TDFhV21BRUVGakRMTW5wYVNNcHNoL29mbHZFSDJs?=
 =?utf-8?B?bXBBMmp0aU1ZQlRGd2lmZ2R1NUlDTWp3NGlycEtIQU9hRC9mOStxTzRNQWdy?=
 =?utf-8?B?czdkMHlhV3pTN1NnM0FtWnBGejgvZlFZanoyc213bzFic3lqb1VkVjJLYUlM?=
 =?utf-8?B?MHB2Q29vMTJkL1NsRWIyMXpOVlhMOFo1K213aW9hN0RKSUxFbzB1eElSOFox?=
 =?utf-8?B?MytCanRSVjdOVnBjeFdRYTJIWGdtSVc4MVhJN1RrL2ladC9JVWRpdzZBMERz?=
 =?utf-8?B?T1FkU1g4YjhYUHpmYUZaOUNUUzBHZExySC9ja1MxZDRyQ2V1R1htdk9menpY?=
 =?utf-8?B?UWc1d1czekZHM1BLWUxFL2VvUVJ0K2xONXJaL29XeE9BMmo5ZkFZN2M2WlhQ?=
 =?utf-8?B?aCtWemVlSk1hdXd1Q0NzMUl3cStrbGwxM0E1alRobm9LM3QydTFoRWRQalBz?=
 =?utf-8?B?Ky9JQlFjWGkvNGpMMk8zZXlKZ2F1aUN3aGhkR3JES0dQSmJpSGJsRHRFemRO?=
 =?utf-8?B?MWNHaXkydHQ5aS9aRURTYlc2clBnWVYydE54aFB2Mllwd3VidUEvcFhYYlRk?=
 =?utf-8?B?cmxld28xaVF3Mk1MKy91K3FGRDVZSldlTE9lTjhVZFlmYy82OG1tTmJoYmRR?=
 =?utf-8?B?ZWNtM2VMcDdadFNhZjFEZjI1MHlqOXBHYWxDVlNhdmM2TjgxSGc5QU9HSytq?=
 =?utf-8?B?d3drdDZ2ZnVLYXV1Q0xpbFhSTTBNc1QrY2ord2U0ZUFOZmJab1VlKzVvSnpD?=
 =?utf-8?B?eWdNNTJWMk9WUjVFb2NxZytnbHJwYlVBaDYrZ09hRWFwL2FJSFAzUEFoR3B4?=
 =?utf-8?B?Z2tSYkhwYXArRm01bFZ1amZUVlg1UUw4by9GNVNzNFJuR0RGVDI0TFQ3S3Yz?=
 =?utf-8?B?emdMSit0aGhqSFBUYlFZazFoWnVNZXE0SEFUaTRkUlVCekNIbkxCMEdOTkRM?=
 =?utf-8?B?ZGs3M1EzcS83TTdFdGc0d2dwa3NiTWF2V0dSSlljdVA2MEFLc3k5WFBTNlRS?=
 =?utf-8?B?RHM0SWU1ZTNDOWZGeDlZYytQb0I3Yk1SeXorYTcvRzQzSHRZWVJLM0tVZUs0?=
 =?utf-8?B?OWcycFZDR2NXSUErRng2bEFGVG1nMjg1OXpCVlFHVUZHRUFBYTgrUEpKUk55?=
 =?utf-8?B?LzdSRmNqZ2xDeFBheis0Q0FuWjIzam1rckk4dS9tTDVjc3dEdDA0N2xJZkJQ?=
 =?utf-8?B?TStzdjhSWmhPQlRzbHpoYlhUQlhUUm9tbk41RGlJTHRFTGdyQmdyQlF0Zk12?=
 =?utf-8?B?UE5vYlpYbzJrdlFabWpSWWdub3ZUMjRDRzdpZ0tNa2R5cnJsRXlGNi9yemdu?=
 =?utf-8?B?aE45R1VYNElpSXhWRG9oTzhCYTh1ZU1hQXJyQ09PZWJXajEyRjI5N0NzOXgy?=
 =?utf-8?B?T3AxcklMRUtmLy83aGVNWDFXRkhmQWQ5SUZNbmRBcXRmTTFjZjBaNWtjT2dQ?=
 =?utf-8?B?Q0NDRFp3cUUrNlljbUJtSCtBbng5K3I2dzVpcnZ5RnNrRzcxd3lCYXBsRm1L?=
 =?utf-8?B?b3M5MFAwOW8yclBsSjY4TkZ3MjM3bytLZk92SFBRNEllZHA1Y1A2SWhURW10?=
 =?utf-8?B?L2lIRmZoNFlyS1M1TmJ6b0tpOWZYOTd6UEQ0RmRMODVoY0FqY3NhOUZPd1hF?=
 =?utf-8?B?OWRJMFNXVUZuejJYSDlvOXd6UTRlZGw1eDRMbUFqYzB2SEdDN096Qzh2VnJJ?=
 =?utf-8?B?WStVRGVpdld1TzM5QkJRSHFvQmFsRlJzcGwvc3lpc3o4U1oxaUhMaXVQVStM?=
 =?utf-8?B?c0xSM1VhSUlmM0pFNFBpbnUwZmkxRXZQWFBwQ2JHK0hyYjNNS2VOZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 110daf64-c8ce-403f-1c3b-08df2aaa9e9e
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 10:54:00.4533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RI7g99fD68R3ojHtPBEVBvuHqgk+MGPohtSTg0xD1RnKPjITWi3BbZ+XGx2fXn1A9yksb09s+U9NDxs37bxG0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8787



On 12/10/2026 16:48, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 1 · High: 0 · Medium: 1 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Critical] Use-after-free in mlx5e_close_locked() (the ndo_stop path),
>    introduced by this patch.
> - [Medium] The commit message does not match the close-phase code, and
>    the close path's safety now rests on an undocumented, unenforced…
> - [Low] mlx5e_close_locked() now calls mlx5e_close_channels_pre_sync()
>    and mlx5e_close_channels_post_sync() directly instead of…
> - [Low] The patch changes how mlx5e_close_channel_post_sync()
>    (en_main.c:3032) decides whether to tear down a channel's XSK queues,…
> 
> --
> 
> net/mlx5e: Batch NAPI RCU grace periods on channel close
> 
> This splits mlx5e channel deactivate and close into pre_sync and post_sync
> phases, so one synchronize_net() covers all channels instead of one per
> queue. NAPI instances are unlinked with __netif_napi_del_locked(), and a
> single grace period is taken before the channels are freed. Single-queue
> paths are meant to keep their own synchronize_net() calls.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index f90b5a34e097..fe4e5d0b2e9a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> 
> [ ... ]
> 
>> @@ -2141,18 +2160,28 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
>>   	return err;
>>   }
>>   
>> -void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
>> +static void mlx5e_destroy_xdpsq(struct mlx5e_xdpsq *sq)
>>   {
>>   	struct mlx5e_channel *c = sq->channel;
>>   
>> -	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
>> -	synchronize_net(); /* Sync with NAPI. */
>> -
>>   	mlx5e_destroy_sq(c->mdev, sq->sqn);
>>   	mlx5e_free_xdpsq_descs(sq);
>>   	mlx5e_free_xdpsq(sq);
>>   }
>>   
>> +void mlx5e_close_xdpsq_post_sync(struct mlx5e_xdpsq *sq)
>> +{
>> +	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
>> +	mlx5e_destroy_xdpsq(sq);
>> +}
>> +
>> +void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
>> +{
>> +	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
>> +	synchronize_net(); /* Sync with NAPI. */
>> +	mlx5e_destroy_xdpsq(sq);
>> +}
>> +
> 
> [Severity: Medium]
> The commit message says:
> 
>    First clear the ENABLED state on all queues, then wait for a single
>    grace period before continuing with the teardown.
> 
> and:
> 
>    Keep the existing per object synchronize_net() calls for single queue
>    paths.
> 
> Does that match the close phase?
> 
> mlx5e_close_xdpsq_post_sync() clears MLX5E_SQ_STATE_ENABLED after the
> shared grace period and then destroys the SQ right away. So there is no
> pre_sync clear for rq_xdpsq, the XDP_REDIRECT xdpsq or xsksq, and nothing
> waits after this clear_bit(). mlx5e_close_channel_pre_sync() only clears
> MLX5E_CHANNEL_STATE_XSK.
> 
> The other close-phase waits follow the same pattern:
> 
> - mlx5e_qos_close_queues_post_sync() removes the synchronize_rcu()
>    between unpublishing and freeing the array instead of batching it.
> 
> - The single-queue path mlx5e_close_xsk() goes from two synchronize_net()
>    calls to one. That particular reduction looks safe on its own, because
>    NAPI only touches xsksq under the xsk_open snapshot taken in the same
>    RCU section.
> 
> So these waits look removed rather than batched, on the assumption that
> NAPI is already disabled. That precondition only appears in a comment in
> mlx5e_qos_close_queues_post_sync():
> 
> 	/* Caller guarantees that NAPI is stopped or was never enabled. */
> 
> mlx5e_close_xdpsq_post_sync() is exported in en.h and also called from
> xsk/setup.c, but nothing documents or enforces that requirement.
> 
> Could the commit message describe this? Could the precondition also be
> documented on the exported post_sync helpers? As noted below for
> mlx5e_close_locked(), NAPI being disabled may not be enough on its own.
> 
> [ ... ]
> 
>> @@ -2936,35 +2993,56 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
> 
> [ ... ]
> 
>> -static void mlx5e_close_channel(struct mlx5e_channel *c)
>> +static void mlx5e_close_channel_pre_sync(struct mlx5e_channel *c)
>>   {
>>   	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
>> -		mlx5e_close_xsk(c);
>> -	mlx5e_close_queues(c);
>> -	mlx5e_qos_close_queues(c);
>> -	netif_napi_del_locked(&c->napi);
>> +		mlx5e_close_xsk_pre_sync(c);
>> +}
>> +
>> +static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
>> +{
>> +	if (c->xskrq.xsk_pool)
>> +		mlx5e_close_xsk_post_sync(c);
> 
> [Severity: Low]
> This isn't a bug, but the test for tearing down the XSK queues changes
> here from test_bit(MLX5E_CHANNEL_STATE_XSK, c->state) to
> c->xskrq.xsk_pool. It is only correct because of the new error-path reset
> in mlx5e_open_xsk() in xsk/setup.c:
> 
> err_close_rx_cq:
> 	mlx5e_close_cq(&c->xskrq.cq);
> 
> 	c->xskrq.xsk_pool = NULL;
> 	c->xsksq.xsk_pool = NULL;
> 
> Without that reset, a failed mlx5e_xsk_enable_locked() on a live channel
> would leave the pool pointer set. Close would then tear down xskrq and
> xsksq a second time.
> 
> The two hunks depend on each other, but the commit message mentions
> neither. Could this be noted in the commit message, so a partial backport
> or a later edit to the error path doesn't bring back a double teardown?
> 
>> +	mlx5e_close_queues_post_sync(c);
>> +	mlx5e_qos_close_queues_post_sync(c);
>> +}
> 
> [ ... ]
> 
>> @@ -3060,33 +3138,72 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
> 
> [ ... ]
> 
>> +static void mlx5e_close_channels_post_sync(struct mlx5e_channels *chs)
>>   {
>>   	int i;
>>   
>> -	ASSERT_RTNL();
>>   	if (chs->ptp) {
>> -		mlx5e_ptp_close(chs->ptp);
>> +		mlx5e_ptp_close_queues(chs->ptp);
>> +		__netif_napi_del_locked(&chs->ptp->napi);
>> +	}
>> +
>> +	for (i = 0; i < chs->num; i++) {
>> +		mlx5e_close_channel_post_sync(chs->c[i]);
>> +		__netif_napi_del_locked(&chs->c[i]->napi);
>> +	}
>> +
>> +	synchronize_net();
>> +
>> +	if (chs->ptp) {
>> +		kvfree(chs->ptp);
>>   		chs->ptp = NULL;
>>   	}
>> +
>>   	for (i = 0; i < chs->num; i++)
>> -		mlx5e_close_channel(chs->c[i]);
>> +		kvfree(chs->c[i]);
>>   
>>   	kfree(chs->c);
>>   	chs->num = 0;
>>   }
>>   
>> +void mlx5e_close_channels(struct mlx5e_channels *chs)
>> +{
>> +	ASSERT_RTNL();
>> +	mlx5e_close_channels_pre_sync(chs);
>> +	synchronize_net();
>> +	mlx5e_close_channels_post_sync(chs);
>> +}
> 
> [Severity: Low]
> mlx5e_close_locked() now calls mlx5e_close_channels_pre_sync() and
> mlx5e_close_channels_post_sync() directly. That means the ASSERT_RTNL(),
> which now lives only in this wrapper, no longer runs on the ndo_stop path.
> 
> This isn't a functional bug, since mlx5e_close() and mlx5e_rep_close()
> both run under RTNL. Would it be worth keeping the assertion in
> mlx5e_close_locked() or in the split helpers?
> 
> [ ... ]
> 
>> @@ -3611,8 +3741,14 @@ int mlx5e_close_locked(struct net_device *netdev)
>>   	clear_bit(MLX5E_STATE_OPENED, &priv->state);
>>   
>>   	netif_carrier_off(priv->netdev);
>> -	mlx5e_deactivate_priv_channels(priv);
>> -	mlx5e_close_channels(&priv->channels);
>> +
>> +	mlx5e_deactivate_priv_channels_pre_sync(priv);
>> +	mlx5e_close_channels_pre_sync(&priv->channels);
>> +
>> +	synchronize_net();
>> +
>> +	mlx5e_deactivate_priv_channels_post_sync(priv);
>> +	mlx5e_close_channels_post_sync(&priv->channels);
> 
> [Severity: Critical]
> In mlx5e_close_locked(), the only grace period now runs before
> napi_disable_locked(). What waits for a NAPI poll that is still running
> between napi_disable_locked() and the frees in
> mlx5e_close_channels_post_sync()?
> 
> The sequence becomes:
> 
> mlx5e_close_locked()
>      synchronize_net()
>      mlx5e_deactivate_priv_channels_post_sync()
>          mlx5e_deactivate_channel_post_sync()
>              napi_disable_locked(&c->napi)
>      mlx5e_close_channels_post_sync()
>          mlx5e_close_channel_post_sync()
>              mlx5e_close_queues_post_sync()
>                  frees sq->dim, rq->dim, c->async_icosq, c->xdpsq
>              mlx5e_qos_close_queues_post_sync()
>                  kfree(sq), kvfree(qos_sqs), no grace period
>          synchronize_net()
>          kvfree(chs->c[i])
> 
> napi_disable_locked() only waits for NAPIF_STATE_SCHED to be released.
> Documentation/networking/napi.rst notes that napi_disable() does not wait
> for the poll method to exit.
> 
> mlx5e_napi_poll() keeps using queue memory after napi_complete_done(),
> inside rcu_read_lock():
> 
> mlx5e_napi_poll() {
>      ...
> 	qos_sqs = rcu_dereference(c->qos_sqs);
>      ...
> 	if (unlikely(!napi_complete_done(napi, work_done)))
> 		goto out;
>      ...
> 	for (i = 0; i < c->num_tc; i++) {
> 		mlx5e_handle_tx_dim(&c->sq[i]);
> 		mlx5e_cq_arm(&c->sq[i].cq);
>      ...
> 			if (sq) {
> 				mlx5e_handle_tx_dim(sq);
> 				mlx5e_cq_arm(&sq->cq);
>      ...
> 	mlx5e_handle_rx_dim(rq);
>      ...
> }
> 
> The NAPI CPU could be delayed after napi_complete_done(), for example a
> preempted threaded NAPI on PREEMPT_RT, or vCPU preemption. In that case,
> can this tail touch the QoS SQs, the qos_sqs array, the DIM structs,
> async_icosq and xdpsq after they have been freed? net_dim() could also
> schedule dim->work on freed memory after cancel_work_sync() has already
> run.
> 
> Before this patch, mlx5e_qos_close_queues() did synchronize_rcu() between
> rcu_replace_pointer() and the frees. The per-object synchronize_net()
> calls also gave a grace period after each earlier channel's
> napi_disable_locked().
> 
> The synchronize_net() in mlx5e_close_channels_post_sync() runs after the
> queues are already freed, so it only covers the mlx5e_channel and
> mlx5e_ptp structs.
> 
> The other paths call mlx5e_deactivate_priv_channels() and then
> mlx5e_close_channels(), so they still get one grace period after
> napi_disable_locked(). Is merging the two into a single wait safe for
> mlx5e_close_locked()?
> 

We'll fix.

pw-bot: cr

>>   
>>   	return 0;
>>   }
> 

