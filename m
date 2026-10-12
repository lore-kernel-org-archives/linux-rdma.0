Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FA839A4D6;
	Mon, 12 Oct 2026 21:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839565; cv=fail; b=RnPf58e/8vtXfXNmKxaujCPfWE++qEPzjRf5M5Jd/JwzVUUSvPrKdnhSqmCbOubCfMqZblRyW/3EXckt5eH2RiCSwee/RGh2TZCJjGt/l6nPeK6pI53g6C2WIPcPkhpP6JwRdcD7uGcIeKqvVT7USyDtbNfnXY9j26j8qbZcSSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839565; c=relaxed/simple;
	bh=4vmc6RAl+R3/ItYX3BfgC8zivlkK2Q9S2J1HO/kw4M0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=duN4ApcH/thA/VIJQobtnn3uHQWrxbAPXBPeLHDmvvRfeuRdfWix0KRCIPzxNDSzqqi+Ut6oQQ6jFtvh4USYhk0b5Pbbbb938Qosff78I7lF/YO3mf2PsEGymcoa1q6C/eoG7xI+35CZd41Ll85J/b0dC+k80AmANQK9hRAVFx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jfObQLU7; arc=fail smtp.client-ip=52.101.61.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jfObQLU7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpNm3VC2BrYH141VoNprDWQ2WCaE/S1qCSO7eHebrUhiXAM7S/OzGtn5fgaCgGPh/X1HJt5NEbXVX08gkLAg9oq3M3r8eHXEpGFnDmSLv5CPJzfp27ryAFUl4ap5+VoF4w3AsJ4iFB4mNKqFXW6OvuLeOgBKXseluZTU7JRxwZdzxUNGA+TyDIoRBucqgOZqkx4H/CxoxqGSdT+cuwnScQjrA+iYwtGPVty2d9oH97H65j7amSBUqXZRirb/Xzu0iag7ZC5AjbE7deV3UX2RVFYm5iAvBaTW3Tjp5lxC4t01lnSTFNJdEJ7ryo+jRIqzlJ30mEBAgS7x8R8HSn+tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ja9ntG+tzMYb+Vs+gsr7sUW+0KSJ9yCDv0HIuAXjetM=;
 b=yp1tcLPQbuSyQixDhmfUNx/rCN3NjeGYY2/bNg9Y8z/1wmwTU6r2L0Wi30VDJMJ+r4QoBJPN6RKy6yvGV73J0EYynDykp2xv36SU/a6Y5PWcH1oQynxCp8sdOWuxegUAKNXHUrZ0rxvO/IAuNGVd0B1m2XFEOPLjVhH6rRvvVeEv/Fy7B8xmg0JIXCvRlO7mHxFRu4HuzQT8c+ehAd+iAjXQniDlRjdufHYuZBp869D4FwX+5EU5Nsp/lgGefkwzP2RhmVg8x3UwDKO/uDnPaWW9OCVwoG9VuhvL3GRIGhqz7a/K8sydmvb7CRuZrNCoEWqG/W64bFSZboJ8/LYKYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ja9ntG+tzMYb+Vs+gsr7sUW+0KSJ9yCDv0HIuAXjetM=;
 b=jfObQLU71JQBGpaK/e0bKE6PonycCn7Z8wtopyBhmQ+E2tUaS3bgQp0RNiluwkDMQLEuCFB4EZQF7/nhSR+NqN1bIziuSy5wYBMVQgt9xCPqIJjzrw8U2gMtH9PRn1f8NNulfGpDlKuTmtZWzC5KU1Fzy2NDq6OJtwqDA8RI6TyxMZVnJPDARV27DMmZfxuKg/6U6+ZSq0kFmQfDo7YZKtMlIzcy/3H+hkwUey/4/L2N9jCh3ux0yNye1Ax0qQ1p1FtJOm9dzRR1S9whgpxxPeRcvPv3lSa7bmfxO74QvLy5Aetz4474WEWXUAmIAph63zN8PQWqEbJGema62HvlWg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by CH0PR12MB8463.namprd12.prod.outlook.com (2603:10b6:610:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Mon, 12 Oct
 2026 21:12:29 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Mon, 12 Oct 2026
 21:12:29 +0000
Message-ID: <d2d64d12-24a9-4bf1-b505-3008e0e25c40@nvidia.com>
Date: Tue, 13 Oct 2026 00:12:11 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/9] net/mlx5e: check for failure when pulling
 the Ethernet header after XDP
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
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-2-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23d::20) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|CH0PR12MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: bec223dc-9360-4aac-46eb-08df28a5858b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|56012099006|10067099003|18002099003|4143699003|22082099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	cjliPQprRqxIENv5FwbXIRVzl9VsWNT+uOZVP68pJbUlmNjEs8XNv86krvj+1mzxvfO1vPyXrmwvmYjiZNerEB6IyQFRCsW6T82SuZodIzP8tUqUFgbZFpWoYk+YosIeNXLlfw8g21opXHYCfv2GIU3HCItU5Fog8usPevR3tiCckg7JwO8K4DPBCSs9qOpeiq9Bav6aQ/3DdFqncYXpTvzZLdTw+SGeQb/jJzGwsJCrRATzcW6V4Ir5MhpdoOjC89cGY0C0yTWD8LBSNwHRQ7PAC+g6pL9hkEDFgFD60faDrXg8yhXni9XawEz0xlWIUX5eqATqyrQ6nUymVI/upbAxLmo4xpVAFOT1wbFqlcvZyK/YzXAkEsrrjCrwyDu71L9TXpq4isez2JxCLSaiHa7V23Skpqp46hJiFdE5b7OFyNAgcNxifof1nlIkvTQIwTCyVTMFfAj5zZWhdWwoGAiz6EGmIsB8VOsfA1siVINeq8mLAj1+vfQNHIL7I1a2L+rJNRWFM3GAMawEMdLfhr4Eg40C9UvKr7dKTS+vTzcqMux3HZ9ajColbWxWoo/ly52khzpNibL/g7eJOIQueU6iKeiV8JTxUCb/SoZ24GC88C54lWAyj3gAjhgo3erFori9SKaLMj4Z3a5cEikZM3kEpLvMQwi9RZNZ/jp6ZO8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(56012099006)(10067099003)(18002099003)(4143699003)(22082099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tm1NOEZLUUpyd250ay94d1EvblZUUnovZUtDS1BJNTF1UW1CK0xUMjFDam9I?=
 =?utf-8?B?dFAvQ1RqSGh6amlyYm05SUUxSFBrNk81eGd4bEcyVHZZWDNaS3ZxMU5sdWJD?=
 =?utf-8?B?TlU5YndmNk1OZ0g1SndYNXNhTm1lV1l4dGtxalc2YzV3VVh3c2RWdVo1N084?=
 =?utf-8?B?d0R0amZxV1EybTh6OUhSMm8zWTNaQlNTODlmaEsrNWhqNVFla1o3MElySUxZ?=
 =?utf-8?B?SHQ2NTVQVTlUTWgzUmRWL0JQUTh5WVVhWXpkUWV4cGtKTWFrSXRrZ3JIakEw?=
 =?utf-8?B?ZEcrV0xFeEREZ0NlUXdpbENLbzNBMk9JR295KzM4ZTAzbHRlbFl3Y0F5T3Ar?=
 =?utf-8?B?TXIzUVJrRTNJZTlweUNKYnJ0cHZmMUFNRzM0RC9ObkJGMzRXbTZ3L2lSb1RF?=
 =?utf-8?B?SGNtVlRmZUY2VkwrRlE3d3Z5aUM1bzVuNmVqWWhyTVk2RU54cmJObnFBM2Zs?=
 =?utf-8?B?TVk3L2N4Sk9kN28ybXpYRnlxQ3E1M2hQMUJyb1JJZHREV0FrQWxOM2RqOXps?=
 =?utf-8?B?aGY5RkVYeWFieU1LN2ZkWWhXK3RjS3AzQXZsSGp4SEFUdlRZWEs5UE1DRTNJ?=
 =?utf-8?B?NGkwU04xRnNKeGJmMkREaStIcXk0REI5bmVLMkF0dW1ZMmFEUkp5dnBRaUZm?=
 =?utf-8?B?OU51clA1VGRzQ0d4a2Z4WUFvSGRFT0hiUjV3alk0ZFU1QnVtRGY4NHl4MG80?=
 =?utf-8?B?dFR0Wk8xY3l5NTVCdnlMcDJZYTZZc2VabCtwU29RUHdkaFlLSUZhWjkrOFBM?=
 =?utf-8?B?QmZrUXkyRDVNRXBFUXAzU2ZlSWlPTnFRTDlVNXR1YnAvUC9nNFFKMU1FUzli?=
 =?utf-8?B?LzV3NmxsdS83bnN5eXFacSt6T2l2YlJ4eWVCR28zWWkzOE9SQTR2MFNXT3dT?=
 =?utf-8?B?MmdxMWhiTEozQWhCQWh4T1pVVVhsQU0zZWR3blNrSGMrc0RKOWhjZU5jSWZM?=
 =?utf-8?B?Yk5GMG5qU2l3S3dWV3NWbm1mbVNqVHF0ek1lMVdNUFEvSVJISnora3IvbHhE?=
 =?utf-8?B?ckNLOGpaMm8yZS85emRRV05TRkdjZHFaOThqZFJTVzZDREVsWEhHUlVrU2hn?=
 =?utf-8?B?NVc4WlhDM29BWThmTUZzR01pbTNvTEdkRm9xeVRJQnlFRFF4L0hxa255eGRH?=
 =?utf-8?B?OStxWUw2dTVSekNVbFI0c2tBY0dUeWd1WXpvSHR0bjZXTjlXaGdCNXFjemhu?=
 =?utf-8?B?b3dOS0tTK3I4dnhHKzB4ZVdYQUFOaC9lTkdrZmVNK3JwT0NTSjhWNExYT002?=
 =?utf-8?B?TU9DYlBtQkNpVDJpM1VBUXd0a3l0T013Z0U2MlZlQTNPbEcxVDZRM0IxdDhV?=
 =?utf-8?B?dmxKdDdhejVlU1o4ZURCTTdrdTNQaVgyUFZLNVpDWC9yWFB3MG9SWTFDYnNw?=
 =?utf-8?B?TnFjbW41SHpWaTNXc05HbEdHb2ExOWFxK1diZ2M5TjFtbm5oY0wwaXpSWGZB?=
 =?utf-8?B?R1pNZW9pTVRWNWxlQ1JnNUZBdnVrTElBQW9YM2hJWFNQMHVxSjNidy9hY1cr?=
 =?utf-8?B?OTlGV2svQzRoQS9QcUt1ZzJGSWx3cmUvY05BQTFCaEJ3bjg5U1AySFg5S3JV?=
 =?utf-8?B?VTl0akZWZmlwVmlhekt2VjVmWVNhRnJXVWJqcXZLNEZDcEVwSExTSTM0N3Az?=
 =?utf-8?B?OExCVEFvT01hWERyekltMkNxUXRnTEsrRyt3b0QzaWlvUHByalh2cDAzdGQy?=
 =?utf-8?B?VG8wd0dnVUxCWDhmbjgwQUtpRWtqdWJHd2c2eDdDTVFaU0NIVEl0ZTgzVEpa?=
 =?utf-8?B?R0hsSFVydWVyb212K0JzcUVHSThsbmFXZTZmZXFuSFRmYVRHV2NHbllER1Ju?=
 =?utf-8?B?SGtJRk42c2NlWFVaVVl1MHIyVkVHOS9xbDNBck5jTmNkWDN0c3VSWDl3T3Yy?=
 =?utf-8?B?V3A2NFN5SGg2YVRsaTVYbW1qelUzVlFsWUNnVHB1Y04xNk5BRmdGTWFsYURk?=
 =?utf-8?B?ZVZWVEV6UDNqVUxBaGRIdmRTbjE1cndLMVpXTjFZN0pJTE52T09zRWdVRUVD?=
 =?utf-8?B?a0M4R2U0VGI2ZXFBK2JvVDJ5THFmVWZ2ZUtFL2JOcmpUOVl5UzdmMlUyZFdN?=
 =?utf-8?B?TnlqaVdHRnAvcnpxaitia0p0Ti85VHVtWjM4V3NvbTI3Y3l1cW9rbk5rZVZl?=
 =?utf-8?B?RGJ0eEdVd0Zqc0VXNllHMENZZTV2T250NEluamxRNEJIdmYrYlZqZFVZM2xC?=
 =?utf-8?B?ODRocUl3bEEvRmFxRE1EN3lQeTdzZDMzQW5BSGNnOGt0NmN2azFMVDVBRlNR?=
 =?utf-8?B?Q0hiWSsveUFOSlhJeTc4T25pVmRQek9NbWF1dS90ZThVdE51dVppMlBhZmRo?=
 =?utf-8?B?bUVxTkwzTS91Uy95amV1TDRaY1VVT2lYV20rMUI4Z00xSUlER3ZoUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec223dc-9360-4aac-46eb-08df28a5858b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 21:12:28.9246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8wjkk7or7Pizk+UU9bvqv+O3BPx30Uxcw/S0X7L1JWWg9KVag9NxRDIkLF92eCMv/Z1FLOVpSnEpU6wsBBWGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8463



On 07/10/2026 21:16, Josef Bacik wrote:
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

I understand that the real goal is the API change, not this branch.

As of today, this is dead code.
I'd at least mention this in the commit message. You already do so in 
the cover letter, but it vanishes...

Something like:
   This can't fail today, since the head always has at least
   MLX5E_RX_MAX_HEAD bytes of tailroom and the skb is not cloned.

> +			}
>   		}
>   	} else {
>   		if (xdp_buff_has_frags(&mxbuf->xdp)) {
> 


