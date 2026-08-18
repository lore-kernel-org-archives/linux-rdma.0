Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012029.outbound.protection.outlook.com [52.101.48.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE30449EA6;
	Tue, 18 Aug 2026 09:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046262; cv=fail; b=pArU5aBdulA4CjnOGU/SgpYSMfPyLT5vilJ+6WUHnZ2Bxed7XWpyhuccr7Q0CCSXcLnCKABVlTXbbYDphQmbDgjvFaaFaKaSHM8Sw/DiegA4RB9fChUKL5JzFR6UYly6SxLHmz7xVI6IOKZzI3bLAD65KNK0c+Wxjh93u85G8uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046262; c=relaxed/simple;
	bh=j+8UYfz9NoRk9y+whJUJ8mjJf6QioxZH10WUJr0uDmw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=loD79Kj+7MRoiqcU84YsBzZ6KSjGx8FZgowUUX0P6vPUgV9cRdLje03WFAffHCbjbtpA2FwtA0QrV7WU4nA4pixpEi/CJG7BxdPrf+2NPpkuw2q90zmx26luuIZYF/0mmLLYKyvsdeEb8qkSjR4V7h3pb+APuY0kpgO3QtYoJ+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WfgRQR8z; arc=fail smtp.client-ip=52.101.48.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WfgRQR8z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vqdp/5s+PzdY1quUmWWNc/T9reMO7DwoM/Q2i2qrlI/HXLNFIhd+dhLw9DHBgyWYZliHuflBcvQanxFwnwiuwzkThB9PPPzl+aBBfDpzhsGi+GcNOKUsgIuns62SkW3kJAsg75U0gxf0zJRCSMDJbAYPVAVXBd+JwB9i1UdSNZYeL0ZE32GUV3rh73sfX/5629IM1h0zVxQd+0WsHRbvNz7igis3/k/ZcPohUTBi1guIKoi1hwxDKjruEermBjn3YLnSPvcM7A8otOD0ajy+KDIhNkgyEA4AmkfH1pVT6mfF5twdA+F4ozAdylOfRZkiSnkRmtjchLUTgeqhFSo4tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM41Mca1iAaUHNOmoXqId/DtuuU/KBO3OcJPcaqXduI=;
 b=K+sglX8vwo7BbvfxWPAm9GDrRILDQO1V3dG1c71CWuj5fnWP2a1nhqsPEy2bjHFKgHot2zdNwDlgY4dSfTpglHvGrvWoFwanj+xcMRfV1fwFfsQ/ZkXW4nnE7qytyIIRrPoe/6WdYnpombQHJs24SnsHI493kN+Z0+nFNymUy4v53TJHT8MNh/jBiGfT+20S/xRJdW/frpuzBA12D/IvmpjlSCb5zamO6dU0eRaHvC408XT5a3ivkshaIWwMXMCM7n+12xd2mQTS8fyBOJyy0qPgvGdkhMFXz5tUP/w9uYtu0lJlBJFPB4qli9TuWlecL4z39tGt8/vNG3EduVBejg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM41Mca1iAaUHNOmoXqId/DtuuU/KBO3OcJPcaqXduI=;
 b=WfgRQR8zKijGVzSflxqnuMzWX0UgBSyMS+NOyG4cmXMqiHrYl9actYcXWKw18LGz/ymaksSCEIjFvoBRe1w2E9+2ehkmBWIGd1MPdu0cPHBoygf7PAX7pA0OufZqMD7OxS0fICc1QETrpi8LP0p4uLsnwiIkakE9xzTlxJ4q6+xCnjjftZMUEd8bjj5S1+cQ9hdY8KciI/NnxTdtm1cQmimz5gm24UuOnaCtGwprwrplY5JYzoLnFt9k7HVSwHF+rtWJlSQS4GG1uNvi3Z194usGXQZ9mqrH0W4vwRpPx7Pj30GfsmgwP4xFKpB7PoGzXgLObEoA7QQFHnwTpqsm6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by LV8PR12MB9135.namprd12.prod.outlook.com (2603:10b6:408:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:44:17 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 09:44:17 +0000
Message-ID: <6dab0f98-70b8-4c29-8993-bc06fefba2fa@nvidia.com>
Date: Tue, 18 Aug 2026 11:44:12 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v2] net/mlx5e: SHAMPO, Fix IP length overflow on large
 HW GRO sessions
To: Tianyu Zuo <cosmosocket@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Khalid Manaa <khalidm@nvidia.com>,
 Ben Ben-Ishay <benishay@nvidia.com>
Cc: Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260817181618.2786456-1-cosmosocket@gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260817181618.2786456-1-cosmosocket@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::7) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|LV8PR12MB9135:EE_
X-MS-Office365-Filtering-Correlation-Id: dc83fcdc-694e-466e-8e5f-08defd0d455e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	ZUuPAiNgWQ1r7XnJPR5pLIIdBfbtSZZZduqkRVh5lFCOnPPq7vK9Lcprq80LbjgZPTPfIoFImg3F4meoFiY9AoXUTVOZfF1dUOU7jgk6XxCvSvoUYO0Cx2PQJ6SikB1AoDEIGSHZghLV85Fbh+/z6kwpy8ITANgpdS50YWDbdBoHCrhlPMU0/dPy4ztc1AKXvKqQXDflhKUS2u118CL74kcqAFjIXLzNtRDy4lw7IpHgP1OxcJz1h9nJHy4sgnJlhIJwPzbnMOtpkYGz7VfYMrSYCBCEZ1ZI62PGUQg92q2o1CaftvWO2LKjr+HVxvL8/XSUBBuqMQ617nl5oUamqmIFxqeliNxk0Phw2uTsCdzHomK5aATEH4vTzt1XeSnYQXrhVC2rQxIkUZm6mJ5iirz4dvGLReeXg0OIL6C32jysZe9AYTq7v+YQIoxdz17mOsx3cx0p18j6dqOIc5BORyjhYAaUXw+yZOFozo2Fv34ljl3sHOh6nAngYvHyEp7ZjG59pQZ0oU7eig1XwndukPNKOcvsUpJSA9i0fjbFsY/1Xd/BR/XLHkwL+KrD2Vj92Gfbk/ZPFxSFUciU09rtuRxJtwWKXeT/Dw1AObFv+6qIFTtfOLUqqTPzN0/3WbsRyCP8XBvz2dcIAlUHjaEvpwBCSRdzvodulLoHGIf6mz2rLxu4BHVePvDNwIUGNz593CLU7ND7IZbkjS7GMEkG3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTNaaktMYUx6U3BNejVFajVxL0VSbWU0Z2ttNjN6amppRTRpclN3WWFDdm1T?=
 =?utf-8?B?M0x1MFlva1VIK1hyKzV2UTlQcWcwT25mV0g1Z2pycDRwY1piUWw3d01CbFhy?=
 =?utf-8?B?TjZQVS9EL2ZCai8vRGJZa0xRKzMyaVhEMXFlWmx3b1ljOUVTMitvNjl4WlZx?=
 =?utf-8?B?azZRTUxGaFFVazVabHJ3MG9PdkFWWU5qclJ5bjNabktza041dHBtcWhvV3Q0?=
 =?utf-8?B?SDlSd0tnNkcrVnoya2VTenFUMUtIRTBwWnpQbnFjZjJrSk8zeHZHa241bG9Y?=
 =?utf-8?B?K2Q5eDdNQklwVGxpcHNjc3pqbHJJWFNkVzBac1NxVC8xaGFpU3BkakMxNFNv?=
 =?utf-8?B?Y2lUVDRaKzZyc2ZmNFZSazhQbjdVM09rQUp1V0VMZldJSUZLNlM2Qk15MjFG?=
 =?utf-8?B?emcvMUd3NGtUamN5am40akFwdTltNTd4K242dGd6YTFoajNOWUZNRVN2VjBR?=
 =?utf-8?B?MUhQVXo5OUI5SnhSYmhITk5ZaGsvWWZIbDdnSDF0L0ZkU0RlQTlSb3piK2ZE?=
 =?utf-8?B?ZjVhM3RkN29MK0dmbWxaZzd0SUM3YTdMa0Q4dFVDaEV6RThnVFRsK3dqRStS?=
 =?utf-8?B?ZHVYQWpsWWMzbUNQeGs5NEE3SGNSN29haEFZbE1KN05kOFQ4UlpiVzE2cUla?=
 =?utf-8?B?a0p0ZDhNT2ZlUHltVHdhRGd6ZjkvRllxcTAyR044UUJGSEFLa2tvOEQ3RTBS?=
 =?utf-8?B?aU5sZ1hGZFB2dEVudjdTWUwzYXg0VmRNMnNUM3pmRjVDS0IzcldaY21aaFhI?=
 =?utf-8?B?MU8yRGJKTS9hUVNma2c1TXBWcnRsS2x0WGgrc0tmRWl4aFRCYVJjZm1ibVZM?=
 =?utf-8?B?Z04wcjRzck1vRkJkVm5kL2NuUVpDT3RoNDQ3eFN2RWc5ZXlIdVhEbWptV2Ra?=
 =?utf-8?B?dW0vUnhBYUswYVBoSThQb050LzBaKzZxck5MQzhSd3paVFpGTG5HbXZ4MDVS?=
 =?utf-8?B?QlNLWGJSM1Z5QkJGWDJGSHJyQWdFRmNuT1lCelpiR09XREplOTloWHNqNmNq?=
 =?utf-8?B?NzVqOU90ZlZTRmdoZ3pZVmd3bk1tSWI3Nm1MOGJldENMdFFlelFGOFNRdURs?=
 =?utf-8?B?dm5zN0hIa3o5RU80d3FuU0Y4blM0c0wvMDZQY1dkVmU4MTNYQjVLU3IrUERh?=
 =?utf-8?B?QVhUYTZpcFA5YUEzZHQwMUpHb2UxUHd1c1FNWjFXRmd6VDBaNFNlNWtDTkRF?=
 =?utf-8?B?RHFwN0tVcVJobTA4OVhSNDJYRW5LVk5rc1hkK3V2am5CaU5QUUR2MDJCenAz?=
 =?utf-8?B?UGJqOWlERDJ0d3duZlZzc3IrR0VLWXVXY09mZENVS21COTNMTGZWdGxzc3Zh?=
 =?utf-8?B?ZmI3bGh0SngzTXlrbUhobTJBbVZmcFd0QVZEejJsejdIQUV2UVEwL2tTOG1Z?=
 =?utf-8?B?UXU1MmVNZjVPdjJaRkNuclgvSlFnVWoyWlNWelBGaG8rMVRmRUQ3bnR5ZHlP?=
 =?utf-8?B?NGpjdzNBOFJuQWZwVUs2Mlh5bGh6M2ZuVmQrN1ZhS1dUTWlnWDIvckZoUWsw?=
 =?utf-8?B?ejBqaGJjWVEwUkNEbmErc2VBNHM0YXBLMEd1dWpJWVFka25JWkREa3NxV0Nt?=
 =?utf-8?B?a1pVS3dmQ2c4ZzV3OEc4eXlRVEE0aEc2WERPTTNkQkRlcVlheHNuaG56bC9x?=
 =?utf-8?B?OGNiUmNXa0J2a2VuOVpRRmpHS0RWWGdCVFZsQTBrTFU3d3lFR21jbll2TENH?=
 =?utf-8?B?NW9iMFN3RFZPSlJOWjBpMFVFTDQ5YUVuQlJ6ajFUYW5SeUhxaG5icFhES0tP?=
 =?utf-8?B?a3RVQU1NTU9sTE1SUjNUNjJBUXVRRjE5ZW1OZGc2RWRxdFZmZk1RMGl2a2FI?=
 =?utf-8?B?UDF6RmFIa0VQUkdVUlJxa3JBakxrZnpYT0o3Yk92V29wQWZab0kyanA3anhm?=
 =?utf-8?B?Mk5oVzdOYzkyRWkrSzJIY0RqYkwwOEhxcGlzSytnQ0w3U0xOY2IwWE1oYlpk?=
 =?utf-8?B?WFhMVjdraTB2TWdMYXlWTXVZSnNLUUtQNnhOemxUckpuSUg5TW1lNHM0ZzRy?=
 =?utf-8?B?aS9LN1RudDhEaDVHQW1yZkNLcmRpT041RW5ZTzl1eVJ2L2hXSGpCSmhBUDF4?=
 =?utf-8?B?Rkk4Mm04RVRHM2dzY09ETlJmNDJPMXl0bXcwZlZVSU9uSlNYeUQ4ZzBlU1Ew?=
 =?utf-8?B?Y3BYdXc2RHVBMmszRzJna0Rld2dCMlhrU3pWam0wNlhpWjNTN3JKRGRKVjNC?=
 =?utf-8?B?eGZ3NnMvVmNZek54UWd2VFRnSVJ1Z3dMc0VSZGY1QUhuUE9vOE8wNW5RQ3U3?=
 =?utf-8?B?bXByNnhTV3Vnd2wwSmpxYVU4SGdGR0lmbjI4VXIwYk1mZk8vKzJjNmttaFpr?=
 =?utf-8?B?S3g1RXNqUVVzeTI2aWtmWXNaV0g1YllmZnA3ZlAybTgyMEpPRFREUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc83fcdc-694e-466e-8e5f-08defd0d455e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 09:44:17.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2x/aGI2t1pMFOqRHY/m7P4hPTcZaO6kv7W54I5OiRyjTC4U1FAi5jAQEKH8pWMovt+8ZXEgYGpmAhBU0aAk2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9135



On 17.08.26 20:16, Tianyu Zuo wrote:
> mlx5e_hw_gro_skb_has_enough_space() bounds a HW GRO session by the
> payload held in the skb fragments only. The L3/L4 headers that
> header-data split placed in the linear area are not accounted for, and
> the limit is inclusive of GRO_LEGACY_MAX_SIZE.
> 
> On a 4K page system a session can therefore grow to 16 full page
> fragments (65536 bytes) plus the 40 bytes of IPv4/TCP headers in the
> linear part, giving skb->len = 65576.
> 
> mlx5e_shampo_update_hdr() writes the IP length itself:
> 
> 	__be16 newlen = htons(skb->len - nhoff);
> 	csum_replace2(&ipv4->check, ipv4->tot_len, newlen);
> 	ipv4->tot_len = newlen;
> 
> The result wraps. ip_rcv_core() then trims the 64KB skb down to the
> wrapped tot_len, silently dropping the payload. The IPv6 path wraps
> identically in ipv6hdr->payload_len.
> 
> Both branches of the check are inclusive of GRO_LEGACY_MAX_SIZE, so a
> session can reach skb->len == 65536 and wrap tot_len to zero. In the
> page_size >= GRO_LEGACY_MAX_SIZE branch skb->len already covers the
> linear area, so that off by one is the only problem there. The fragment
> based branch additionally omits the linear area entirely.
> 
> Account for skb_headlen() in the fragment based branch and make both
> comparisons strictly less than GRO_LEGACY_MAX_SIZE, so that skb->len can
> never exceed 65535. The new bound is strictly tighter than the old one,
> so the implicit limit on the fragment count (at most 65536 / page_size,
> well below MAX_SKB_FRAGS) is preserved.
> 
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Signed-off-by: Tianyu Zuo <cosmosocket@gmail.com>
> ---
> v2: commit message only, per review from Dragos and Tariq.
> 
> v1: https://lore.kernel.org/netdev/20260729204745.166584-1-cosmosocket@gmail.com/
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6fbc0441c4b8..2e9676305439 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2222,9 +2222,10 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
>  	int nr_frags = skb_shinfo(skb)->nr_frags;
>  
>  	if (page_size >= GRO_LEGACY_MAX_SIZE)
> -		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb->len + data_bcnt < GRO_LEGACY_MAX_SIZE;
>  	else
> -		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb_headlen(skb) + page_size * nr_frags + data_bcnt <
> +			GRO_LEGACY_MAX_SIZE;
>  }
>  
>  static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
> 
> base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos
