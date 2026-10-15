Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13A151616C
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071397; cv=fail; b=djj4qvS1CRtWWVU97MJvJMCaa/9j6jk4pAldiZYhNdHHZelpwdbiSFw7fiiayQmoVOv3tB8lw8VRVOAqe+f2YHBdd2n8cSMlcoRnWlmd7Z/YieEEgKXgAa3Lce5y9yQzNZjG3doEIKr1GhPzCypCvipuBCWeOVXLgXHMFMLwytQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071397; c=relaxed/simple;
	bh=dKwjGjRftw3Qk9YPM3ECxRfJIiL4ngUNOw+sFmWuFv8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EOW8xoLj3yRReOHYE4KCj0bU4Lpxly5pXeqU1dtNRI5QQTWTlIArmbqVQiL8rR/igbWOLo24YbjEZcj4xPWoIhoVVOoeiHxsMG4IyFDlcr15T1XONS4cA8CC+jkrWJT3DpUVfLltZpmyCSuoT8m80PgN4KAwrWuFG5xyAAAsiTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bYedM+N9; arc=fail smtp.client-ip=52.101.52.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bYedM+N9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VProU7Bac/eizSQ8wAK5iTP3cZfuKEzoBi6DfHdRJFwP+Cpv5RHsf8YIXwhj7AIKdwMK8CCiBNw6WhRSR3bC5GCU2P3V2AQ/OGuGDzs3JcbWVN65RUHIiBzWVPscxOWZ6GLhBhtJEPjZBwlI77HryjPqGsH5IGYQOqbyoWktgdLIIzu3QDaGBLDD8RWcojLLq4y2RqEQAYpmzM1FFGoG+uVCareRHijZmJzHVfkGFXTZJRs1puGxExND7nkOI8u5RYYDu6MP8eIjgP0pRlzZCTwRvgSUIRnXMPuqNUxvOxFrb/AP7FFBkiV9fGN9XYtmz8TPl0XNcVWfNyNs36M8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LL0dqN8HDas5yd/0NUie0fzxBuSll7ry1/kLQu5w/1Q=;
 b=ejoUTg0kjslcgMgCZHVerVWOgZDDUrfm5N0F2vWYliFtWirXtEe4/lOx48jPQIZ9uBLx7vHCx8go/RHOTRedL4xxc8XexTquqwAyucX1XavkgEIfekHyPltn5KmiHQu4EiyTI6FPiIlHDn8ZgZxX6wmENgx1ayzxoz4aoKgCWgFqPzE1yVyoovi2L8RdHV62ri9dWqpCzIdq3NQDOgUV7EDU7eUFNkRkx5ifYBWM8ejVjA++SzTy1FtdRoTx3pIQZeP4V8ZyB2zcUJW+OtxcwC+2xZqd+hwI7P0lZ+kzR6hnQRTbTlfrVvLRJomjEb9ivfrmoG1HxBZK4LD0C/69xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL0dqN8HDas5yd/0NUie0fzxBuSll7ry1/kLQu5w/1Q=;
 b=bYedM+N9SUyIfUd2Qu8yIu+tlf95lwWQHipz3xY4alAM+QAmuY6opsrGuEACqcikBLwHIknmkHlw0QMbIGjachXe+NjP1pvSvig2L1OFbIWyjXxRB6lDetWQcoH4W9lDtSx62t71RxdarEpU7pvMdaH8AK+fy7mc6NjJLvFVmXQ26DaDMioo5yIY15ddUcHegf9bbZZ9R/9v6AVHlu6hDaYlxK0jarDP6oSywD/wa0zsfdSg/ED/Q22C+0+t9DpU0ZZNNJGLrhzq7tb9dhY+RRK2VR9LS/rbSPwQlVDrECObnMANqypVlPbQKQkZeji990ecfHRrDTNFVurJVYA5SQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 13:36:32 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 13:36:31 +0000
Message-ID: <1e0daf9d-e0f8-471d-a18c-90b620a58d41@nvidia.com>
Date: Thu, 15 Oct 2026 16:36:28 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Add missing error flow in
 mlx5_ib_set_vport_rep
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com>
 <sashiko-outbox-172773@kernel.org>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <sashiko-outbox-172773@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::18) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: 24570ac9-b5b6-4c85-978b-08df2ac152c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|11063799006|260925021311599003|260925021911599003|260925022911599003|56012099006|4143699003|261009223027099003|18002099003|10067099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/MzZ1HCP1t7w4+JDxwA6BXn18vrTjICGVZborMpnZa3bE/9dogv6q+AVEqieHAPEGa+Wc4mwvLEjcfyTAFVChHzEMJdH9anz42x7UdJteZUhkJOOEusCbQ85ZtE272YTp3lxKDLXTRVVoUEYtELT7R5D3KlDmvPUmorQDE/2cMctKEDr7FUF5nn/6qwxn2Vaa04pC+TX87656IXtUVScVc8o8KRMMG2J1vLFrDFJ1f1cEF4A6PenS1qA3ieIJlKp56mSbiJA8D1aYDEdbZrLhKHn5d14+VX7WYq7PcNgltmgsoOmg9o2WOFjGpZhZYEsT5nIOR2Jn/swpVgY972z3nEOS5eaqnjYbP8KmLUc19kaN8KRjwxjXWspS4vH5CxOov629pTHL/kV01RaSWIq/6bnt1b30jLMBkqAy3/TMX7SA/JcvUTAWRExwKhhiU3Leody/DadQs7tzZOY+e/DStKsaVIrRpGTtQbLKknSckCyucQv26GQSzlEYDxrRjR3d56X6cHvLl8K2WWKwUCLMAfXKg1sa0DiFbLdlsNsFHSjW0MhXKqkAdpnn1PsFcjG9GaIvYPy9PhGSxH3dYDEswK1Rrzkw+CxlzzM0OIboYn4vYfNIsrA+qxG0XuecM2MNcczKn32BySswJXiKdaLAzOMJW1bcm9Nw+W58azBCZU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(11063799006)(260925021311599003)(260925021911599003)(260925022911599003)(56012099006)(4143699003)(261009223027099003)(18002099003)(10067099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aCtCRGRJOVYvOXpEYmpyYTBKV2tUQk1lMHlRczgwQ3VCM0g4Rkd5WDdkd0J4?=
 =?utf-8?B?bSsxdFR4UnYzU1VXRi9HNVFmVFhmZEw2UzZGZGxYSHZiZzgyL0pXYXZEKzZ0?=
 =?utf-8?B?OHZ1Q3FQSzZLSmRJTTJnbDlSUHY4cDcrd1dRZUtlSy9DNG5YcDlGbjJnNW1n?=
 =?utf-8?B?VXJuQytGSzhIS3N2N1BYSnpQYTRoYnN5NndyNzUvMWhWUy8zWlhpbktIN3Jk?=
 =?utf-8?B?dnNjS3UvdS9keGVIOU8zMWZwTy9INHZkeEZQYVROcklhL2t1a1NCMzY4b3ds?=
 =?utf-8?B?TThmdWlrOEVVNW5DcEpodG5hTHFlTDRvUjZ3WG1CeHBDVjc0b0NFbXNNT1Nx?=
 =?utf-8?B?blhNbmhvK1JwelI4cHJxYVVUOHErbW9KcHVqdlZLQXhZQjQ4RkRKenVtQUFn?=
 =?utf-8?B?NWxaaFR4elBkWEZsWVlnUFBsU2Q5VFJzNnhLS1JKZmpZREkvK3RyTVVJa1dw?=
 =?utf-8?B?bDVWMEZIYmxKZW1PTUJFdW9NYkpDa1RGSnR6UHVScmhFSGJUMGhxTzJ5djBh?=
 =?utf-8?B?cU9DRTBWclQ4RXpvTkRVQUw2TytUY1B2YjNpcXhMZGlvTi9IM1ZxRjE4QUNV?=
 =?utf-8?B?WGpKcFVrU2V6cHlmYkdORHEyVENFR2g2U2plTVp3eGpGY0xVTUVFR2pvTHp3?=
 =?utf-8?B?Uld4Q0JkK29Hd1RsTmE1TWszWVp4aTZsUWIyREVzamlJeXJCMjJOY2ZieDV1?=
 =?utf-8?B?ZHdHVjc2eUdQM2Y4Z2ZnbTBsT1p5ckJ3N1JXUWdhOTRkcjVUSWRHYmxnTFNP?=
 =?utf-8?B?eWM2VFJUQmNQek04bmFMRzdhNXppWkEzUUtEb3VNVm9QdUV0N3dGT3hoQXhS?=
 =?utf-8?B?Vm1JcldzSDJDcExiMk5OTmhGSlJoZGZmRXBxYzA1Zld3R251cVgwZ2JKWjBn?=
 =?utf-8?B?ZzhjdDZCbmlXTmJVU0MyNy9Ybys3Nlp1dlpkMHU1blZKSW1nVWprTEpwalht?=
 =?utf-8?B?NjA3eVVzRStxTmpvNWVScG45VWxUOXZ0YVhlaFNIZGg1OFhqWm5iQmRldk9t?=
 =?utf-8?B?WHp0MFlGMUJFZi9OM1NsdW91UW5lOEs1Y0Fnd203OWs2TVFudlZTQUJYa09l?=
 =?utf-8?B?SkNPdjhrRWM5U3JKQUpDTkJybUJWRHFMR2U4NDd1eEw1ZUVCSHNJR0tieXZo?=
 =?utf-8?B?ZlZKYVhFd3g5TEd1SUZwTWF2Nlg0WGZEWm9wdnpYYVM5UGhwZHByczVhNkF3?=
 =?utf-8?B?NDJpTlRQSGN0aGtSUnB5T09GYlVVQ0ptait1THVoNDRkLzhseVJxWS9rUzVY?=
 =?utf-8?B?UXJaRkFOZnVvT25GOWlyNHZBQjJaS0xWTDliL1dMSzRRUDd3T2V5RHJGZWFP?=
 =?utf-8?B?ajRoMU9QbFA2S2Y2aXVQd0VBRTNFNTNNNUVGd0hRSDlFNVBsZ1VQbmxscTNL?=
 =?utf-8?B?RlZQWW1ybTIvdlc5Q0tTNzlqbElIVkJTbHJFdVFtelNjc1F6OWZLTEtITHp4?=
 =?utf-8?B?SUltUEpEbHJ3aFpmOCtvdUJFL1YwL0dNY3VkNUx4Y2tpdS9IajBna21UelN5?=
 =?utf-8?B?TkxtV1FmT0Y0c25nRG9RcjJSd2liY1V4M2RHeWhSMFlSNld1ZmZBTm9XY2FZ?=
 =?utf-8?B?ZFdxaDkxVXVYdlRrY0pvc0tPYjFWWVNaMXFSSXUzZXd4SGUvc2hLeXFlSGNZ?=
 =?utf-8?B?aFNIUE1IU0ZtSnM2UENrRkVJM0lKcGV6bnFmbGg1aVFrSzB3czFZeDRPd0Ri?=
 =?utf-8?B?aldDZXI0ZkhDT3BXMndSWldZeTg4eGc0cHF6VGtLVWdJNDhXdnBobnVPbHF1?=
 =?utf-8?B?dTQzSU9xcHRpWTRlVG16RWRiWlV2RmM3dmN6WWFsa3pSS2lpSW1sS2w0VkhU?=
 =?utf-8?B?SWlpMElSYVhUem9vM0Y2TGZpWCtYZGsrUXNBUGppMFhWcXBKRlJpSXdRdnhL?=
 =?utf-8?B?MjlHRWxHSjBNaHIvMWo3dXlKWWhROHlVLzlRL1pFbVhWMUNEbTdPMHFOMjVX?=
 =?utf-8?B?QjcxZE5RS3A5YktDNkphOVZsb1FBQ0pUdXFCYTBGRkZwUFk4WTJsWEpnRGRW?=
 =?utf-8?B?dHkwdWxFK3MwWVRFQW9jSEVkU3F1R1RiUHYzTzVFUUV0Zml6Z1UzN2FZWnJN?=
 =?utf-8?B?MGNnWFVXMEx5NGkvMy9MczQ1ejFiQVc0bHJYTHl3R09CWnhrNnNnZm5VS1o5?=
 =?utf-8?B?elFGa3JLZi9ENkdUdVdVSzMzUVp2V2xyVkRSaHpBWTZ0U2I0dm41MjUyNTA2?=
 =?utf-8?B?MVBtNTM2b0dMbU9nemJIY0RpeXhnTG1CQzRhU0tORDVPT3FMRXl1T0ZuWCtM?=
 =?utf-8?B?bElzTThhd0trazlESTJLbmhTQzEyUHl0YTFDRWVYNy9jZVVsYTRHcFBEd1RQ?=
 =?utf-8?B?djBQNm5ocCtNL1pRWTNmaWdjODR5akMzU3BTcDl3bitlMzcrbzhjQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24570ac9-b5b6-4c85-978b-08df2ac152c9
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 13:36:31.8321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFPIbBDrXKzKhCqdnILaRPJyWZ+Nd6qZETJHEAKQNzNcKXYuUjIMJ31kqE8CxvWobI/puOkhG0t77qttSr6gHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351



On 10/15/2026 2:55 PM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] rdma/mlx5: TOCTOU race in port representor cleanup leading to NULL deref
> --
> 
> commit 8e906a48ae2be9e11d0c09a6021af6c819f14449
> Author: Shay Drory <shayd@nvidia.com>
> 
> RDMA/mlx5: Add missing error flow in mlx5_ib_set_vport_rep
> 
> mlx5_ib_set_vport_rep() attaches the representor netdev to the IB
> device, which takes a netdev reference, and then adds the LAG demux
> rule. Undo the netdev attach and clear the rep pointers on failure.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
>> index 65d8767d1830c..9cbd27063ba8f 100644
>> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
>> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
>> @@ -36,7 +36,18 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
>>        if (mlx5_eswitch_get_total_vports(dev) > vport_index)
>>                return 0;
>>
>> -     return mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
>> +     ret = mlx5_lag_demux_rule_add(rep_dev, rep->vport, vport_index);
>> +     if (ret)
>> +             goto err_demux;
>> +
>> +     return 0;
>> +
>> +err_demux:
>> +     ib_device_set_netdev(&ibdev->ib_dev, NULL, vport_index + 1);
>> +err_set_netdev:
>> +     rep->rep_data[REP_IB].priv = NULL;
>> +     ibdev->port[vport_index].rep = NULL;
> 
> [Severity: High]
> Can this lockless clearing of the pointer cause a NULL pointer dereference
> if it races with concurrent readers?
> 
> In drivers/infiniband/hw/mlx5/counters.c:mlx5_ib_query_q_counters_vport(),
> the rep pointer is checked and then dereferenced:
> 
>          if (!dev->port[port_num].rep ||
>              dev->port[port_num].rep->vport == MLX5_VPORT_UPLINK)
>                  return 0;
> 
>          mdev = mlx5_eswitch_get_core_dev(dev->port[port_num].rep->esw);
> 
> Since there is no READ_ONCE() or local caching of the pointer on the
> read side, and no synchronization with this error path, can the compiler
> reload the pointer from memory after the safety check?
> 
> If the pointer is cleared by the error path here between the check and
> the dereference in mlx5_ib_query_q_counters_vport(), wouldn't this
> result in a NULL pointer dereference?
> 
>> +     return ret;
>>   }
Essentially, Sashiko is correct.
But the same pattern already exist, with a wider racy window, in 
mlx5_ib_vport_rep_unload().
I let the AI to look for readers that have similar patterns, and it 
found in multiple different places.
Specifically here, the function can be reordered to publish the reps at 
the end of it, but it's a behavioral change and need to consider what it 
affects.>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261015-rep-netdev-leak-v1-1-5110013806ae@nvidia.com?part=1

