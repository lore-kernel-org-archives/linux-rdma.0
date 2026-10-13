Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013059.outbound.protection.outlook.com [40.107.201.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BDD4BD346;
	Tue, 13 Oct 2026 10:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885740; cv=fail; b=FTaIq3DrIlEeM+IZf++wlfWk4Aa8+cfqNs7JaCAeRaMPPMPZSWzdUGDXBvr3DtIwKf2Qmz0fbXtpNiDRmCrxXNT/gk4+I6to2KP9MHRD0hW9C5rRfVP0X2XN/9hVSiIMysMWrjLd3IU6wbqsJt3iEyJCUnkYg4isbsltw2kUGSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885740; c=relaxed/simple;
	bh=oSdaWCt3am2AHsABBnfln3JLpDJe3lpoFutGgfG2PJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eKVDk9y9vMJ1RKzFkw/Rc3XaPTu5hM+EmH7XCpb3P0ukoWwaLxCDKoWDhovwfY5U4l3LYW/0Jaz1esq/fgE3W7AcAdxyrKhVQKJRTXFAZRLRb7O221VkhFWqmUcygibvgrlSlMbSKzm2cbxR9+vXULwDdSwEEqxqBjcUMLoYCf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qLPIBpuT; arc=fail smtp.client-ip=40.107.201.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qLPIBpuT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRaKut8a9XWnL4T3t0TBkRcvdizbpoYJeB6bXyJ9HDT888S8XHBXnON3v8bxZOfhRH2oWkGk0e8i0Y6Ea4VKgVS4EIkNlv3iC/OM9A22c/9Re6H9YVYbW/7nCuJRyXYjxSYUuB6JDn4ja83H3CjZhHZY22JWuTqEHmtm8YlbtWD+fUvCpVn2Wm53DEKwGCEhDo0WTbXyJqCfY4039qFpSYYA/XLK0iHASQvS10BfpHPuIazLkUm5fI+ThDuGTUEYhWCItVBIJaU2D4lEZyHbR3q0ICvgVhQuuXvFFdvB3tlVGjAWWuElp7CZvztZCNJe2h6M1VYGw1MM1ldPHtZXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qy3yY+PUMpUueTE2NMgzBPOfbGqmLKllDDTa+SFEff8=;
 b=Uu6ukrAFF6q7kfFruSgbCXeoN7KIsKKfyiC+03DsulNkvcr1Qh+a/wU3EFLbdjDRGMW7UonF9DAIaDdHUEo61/mEFfWC4/Am3tIP7hyY62WFxL7x8Zf+qfRJX/HGAHPJ8wwKjv9IYXj2LR0DXHhIqdDH3R+5F2ghi7fWkBpQJSh8tzqggAqT33kjZmMyR4aQkP0o88T8gW3zJa2mWJSVe2U8AYuvLbALoqWq9yFNGJxxItzlI8Lob3lg1BmQcTJ6I/A/VAssP51MSeeG3lDfxuKGbYjjQSQcILNroSIky1qSlGjk7BX/QKyCFS3RUMRRJalVbKeZFF5wAw7HRrjyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qy3yY+PUMpUueTE2NMgzBPOfbGqmLKllDDTa+SFEff8=;
 b=qLPIBpuTgwEwKCAgw39H58bUa6naVSHxmT+onDbWszy56iY/2ven6GZpbJ2H7Q+skHsQd+zuWAjGJTuYmsazQTNaNzYzwuACofh3ZTTtsflorZLUe69SYlq16Y4RsrKKHJRNaI8v4sBoJ+rBMR448UcQs8lCD+Esl2+oTuBn66pflMqJuynyK+7VGbabInLuP37PUa5hx+ABog3fhzp1SzDkgkLZmoLxQOnKFLD5gE8MgImi9hkhYOURbnZnZFXpPcC1Stf4unrRqkC4VfaFCdmo1s8rG8WYcAR57o0l6D0WIZ8sITWaa9Nc6ZLXV7cA0q+jfPtkuZzSLtYG05jtqA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by IA0PPFB67404FBA.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:02:15 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Tue, 13 Oct 2026
 10:02:15 +0000
Message-ID: <5f025a06-da70-4cd9-96b4-d86f6d3ce9c4@nvidia.com>
Date: Tue, 13 Oct 2026 13:02:06 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 03/10] net/mlx5e: check for failure when
 pulling the Ethernet header after XDP
To: Josef Bacik <josef@toxicpanda.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-3-8f2bd9bee138@toxicpanda.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-3-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0230.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::20) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|IA0PPFB67404FBA:EE_
X-MS-Office365-Filtering-Correlation-Id: 6442062d-825f-4097-6ffb-08df29110eaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|22082099003|18002099003|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ymrZ3l7BC9mT6DTwEnN6BkRaGIRJGOVZHLv7Y+XBqOBU/8oByGeyuJSpG5bblbzfG5BQ3Yi4duCVBYOQ79+35xQ4igslKCWk81L9YR7tIoottftmADKpC6qDdgaNiHphUr2ePAMMRPevedNHrrKnewjKMPbhN9UMbAUVSF0OW7IHylx2H/fywEZR7+iW6zWQSAAI6WdpM9RWh0vfNIj5lU4yELB5fvKtM2UYe2tk1QyWPQet9sAIHcPInscDmwOPCV7ANMuidFjYjLajtl9MJ1CcJZjykaZnSMElnS403bBFv63FLkmMBBL+Mc9Q4pUhi2mrvlrOtKBiC5SqQPNSx0tIx1jJOfh9Ifdv6FzSkf9RObk/dCtwI7Brkbr1lhuh/w79PGgPqr/whzsAmHqEh9YuJM4h9D/SS0xlgBwSPdIsOrmtcWt4F8OvrHq9BbKuufirsOJ5Gge+jlxM4guTdyIc9qkPEAxRosBoDggzxemyWT+Lo03JKGqajrqXjCwEoF8fgu/Jk13MUplYP5CNcNYv3a3Cf6vd37R1eEMGUzKS4G7DmC7r+tGqvFK5UUYtx2zFJ7c77SGbS3pA1up+MW5pMeDnDiKhVQEFnvhpK35im8rRH08dtT4+jFOc6RGHQW72/rxmlM5238vy0gGKseEhZYKaPY892Xsnokj8cGg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzliZGlXR0c2cHkvcThlZWF2NmRyUDlONm9nMnFUZHF5amtLNDNtcDdaN3lB?=
 =?utf-8?B?YUtIa3hTMlBOVmtPMkF2UXRCbWd3OHNlNHp4VkdsVTIzMlg2YXAzc1pURWF5?=
 =?utf-8?B?TjgvRmNFMXBPeWhLbXNtN1RIMGtpZEk0ZkdDb1N4N01qb0NHQWRBd1hiQXFp?=
 =?utf-8?B?c1AyM1V3RVZqYUZtemU5Q0RweDRVa2ZQaWZQdWZIdlJkMWJoV0NZTjVWdkpq?=
 =?utf-8?B?ajhmWm8wc2V4RytlbUJrcXBDSy9sQ3pNZFFPd2V2Ylg2LzQrUjl2M3FIdjdW?=
 =?utf-8?B?L25NQU5aYVgzNHBVUzlMS3owaEF0SHFadmVRS01GZ0dNS2RIR0hwc2hpMTc1?=
 =?utf-8?B?RXhTMTliOTc4QXUxNzI1T0h3TlNTcDQyUEpGRHZETkRwWThPK2hCRVRER1Az?=
 =?utf-8?B?U3NOeGZqdFYzUlV3ak00alJWenBuNUM5aTdMb3ZoQlliQW85am03VitLMkVy?=
 =?utf-8?B?L2kyWFFDNU93ZzJiS01JQzVYSFJuemlIMmJRdDMzZWc0aURzNnFnNmlGa1BC?=
 =?utf-8?B?QmlaUDlGbDlSNHNmbUs4UllqNWxuTUdEc1FKMlNUUldvaVpwcXdJTklWbTYw?=
 =?utf-8?B?WFNuVnBxMXE4TmtMT1pUNnN2TjV2TXJRak5HSHJlVmFYa1lSUnc5UlQwOEcy?=
 =?utf-8?B?RWk5dGlBNHl3M0g4NWo3RlVoajMxTmlWRHBNZUNaWTRvRGczUkwvMkhNT28w?=
 =?utf-8?B?bGZabXFuT1ozNHo1d1pnWFpUM1hMWHZwRVpHaUdtbnA5TzB0Y0diK2ZleDF3?=
 =?utf-8?B?V3RWa2lHNFZXeVBrWGhBWFhSdUp0Tjg4UWZaYWRIdmNna0dydFU3MytlNyt5?=
 =?utf-8?B?WmRWNGVFWVhhdW9uc2xLSUs3bXV1Y3BrdHdieHA0ZzJKbGhGMTROVGNYMFhk?=
 =?utf-8?B?SlZqa0FwR0JZL2N6RUEweit5ano4NU9BV1U4Z3RGeDBocjI5ZzhNUUlocUJm?=
 =?utf-8?B?ZUtTZ2JKS2prZlFqaHhBQy9raEpMMlVtVHJwWklKbjkvTHZmRFRCdnpIendV?=
 =?utf-8?B?ZFU1dDdpdlRnMlJFdDFOZ2Z6MFVIUVBDVXc2U2hSMjZudzNybm9QTE8vYlAy?=
 =?utf-8?B?a1huNFdaZnozWFlnYUpXcWdleU1jNmVGcTl6M0FuWEpvejRxZ3BBamRiWDZz?=
 =?utf-8?B?OGlMSldOdHBqRWRJckV3WnA1cE11dFNPZk5uemlSZjN3NmRIcDhlc2xiejNq?=
 =?utf-8?B?NHUwZHgzdlEvL3ZpSzM0UzZ2VURVZEVLVmxuQXFiZUlCclRFdk5RNW8vRG1N?=
 =?utf-8?B?NDNRMVIxQytRa0ZxWnFhTkNlN2hrc2x6QjcyRk5ON0NuNE9EUHhlamhYd0NY?=
 =?utf-8?B?V1BydTVPTjJJNVBUVFowYk0zb2hFVVJKUUozVncvZnFKUFhiWW1QRlN0MnRW?=
 =?utf-8?B?ZVBoRFh2YXFuYXordDc2Mm1HRkhZQ1ZjeGErYkhlRG5rYnhGck9ULzlYaFJM?=
 =?utf-8?B?cnhNSWpBSUNsUk5Mc09EWngwVkVyQWkwOHQ2RTg5aEJvN0FzU1B3ZndmY04r?=
 =?utf-8?B?R1c5ZjUrZVRMekRoZ1h5cytISk94ekFoQVpzcXU5aitDbGFrdVc1RXJXeEJF?=
 =?utf-8?B?VStTc1JpemcyMlNnN1NCdlZZcndyMFBaeVl5RWpSWXNtVjNmNzhYSDRuR2hl?=
 =?utf-8?B?VENUUGNBNmNsVE1rUWJteEJjVGUxS05rMElNcTZwT2NneDhSbVc5VkRMWXpC?=
 =?utf-8?B?UDFUcVprZlBsMjNQZE50NSt0M1VPaU9KYlpUaWx4cWhVam0rU2hSL0FRWmo4?=
 =?utf-8?B?N3ozWG9rbTROMi9mVmQ4VExGaFFmbVJWWSt6eWhqbU0yOXd0TGtRd2Z4NE9N?=
 =?utf-8?B?eHNBZ01PSUtlb1F5Yis0MDVNQTJRbnJtbDlNTGQ1SEhaY2VyU2FUajNRYklu?=
 =?utf-8?B?ZjRtQ2x3WXpIOVdKVkpqRmVFQWZMY0FxMXBSN09FZngrYUczNlI1b0V3dHJL?=
 =?utf-8?B?R3o0NnRZdTNXODlFd0loeklQWXdCVXhTbmVYd2U2Qko0Y1NONGpaaG5uRHM1?=
 =?utf-8?B?T0Zka3VGLyt5V2VHUjFFd0I4Qk00aWs4dC9ZeGFxc0JjQkdjL1djK014cmNP?=
 =?utf-8?B?QmtaYU96UEtQaEZIa2lrWUE0aS82K1E3UHJkcUh6WUZyZ2NjNUY2T0pnSFd0?=
 =?utf-8?B?dW5KUGZwaEx5T3p6ZWFheGlmTVNUOU1VZlN1Rk1DYS8zRWVqS2xtZzhBTTE1?=
 =?utf-8?B?V0RXQTYvdklUamtIZkxKRFRjeTlyK1NVYXJlZlQrVi9sdjMxWnRKcHg2N2tZ?=
 =?utf-8?B?TTFLenlad1hYQWNYRUNzS0JCeGV3VVQ3K0hNWERKVVh6a3ZFNlIwUnNsZ1k4?=
 =?utf-8?B?WDZNbkhKSi9IbHhhd253TWRMZ3pBWXZ0MWxkSGpKVVdpMnM3enBmdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6442062d-825f-4097-6ffb-08df29110eaf
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:02:14.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bciWORfVVIrRKX1hXIJ6bGsHxUhf4C6dQSyEvolKbyLmrI63DyBiDzYAvCOGwZD/FFpUq7zBD7UWRVbHeu9riw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFB67404FBA



On 09/10/2026 0:02, Josef Bacik wrote:
> When an XDP program leaves less than ETH_HLEN in the linear part of a
> multi-buffer packet, mlx5e_skb_from_cqe_mpwrq_nonlinear() pulls the rest
> of the Ethernet header in from the frags with __pskb_pull_tail() and
> ignores the return value.  If that pull fails, eth_type_trans() later
> finds less than ETH_HLEN in the head and BUG()s in __skb_pull().
> 
> Use pskb_may_pull() instead and drop the packet if it fails.  Pulling
> min(ETH_HLEN, skb->len) keeps today's behaviour for a frame shorter
> than an Ethernet header.
> 
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 

Hi,

I posted relevant comments on V1.

https://lore.kernel.org/all/d2d64d12-24a9-4bf1-b505-3008e0e25c40@nvidia.com/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index e3f915beebe1..b1e1e30a77e2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2060,9 +2060,12 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
>   				pagep->frags++;
>   			while (++pagep < frag_page);
>   
> -			if (len < ETH_HLEN)
> -				__pskb_pull_tail(skb, min(ETH_HLEN - len,
> -							  skb->data_len));
> +			if (len < ETH_HLEN &&
> +			    !pskb_may_pull(skb, min(ETH_HLEN, skb->len))) {
> +				rq->stats->buff_alloc_err++;
> +				dev_kfree_skb_any(skb);
> +				return NULL;
> +			}
>   		}
>   	} else {
>   		if (xdp_buff_has_frags(&mxbuf->xdp)) {
> 

