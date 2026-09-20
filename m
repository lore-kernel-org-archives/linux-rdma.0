Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012001.outbound.protection.outlook.com [40.93.195.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DA2E0B5C;
	Sun, 20 Sep 2026 06:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789886858; cv=fail; b=ezbY04FJXGObdZCDDBTmyWOLxZ5f0CerTQ9OM1NxqvFtaA7EHwjI1jC6/llzEgns0JhFPXxhCfzncAqz4G3xAoi+LMfU6ntlTVD1a6WwvUF6xhv0VP/RvZCSKgme5tmYSWXD3IhBAWGQ0271ybgAwrug9z1A6MyZpl055a1DGh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789886858; c=relaxed/simple;
	bh=95tFPlwGvXFAa1OgqBcbciWeiZyhVNtdMI00SiJ8ObI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HDtE9mGE//M4QRCv1Rcz4bNFU45FB/KNI1yJzTaS33env3MSMYib91woAiSIdcgE5xVxv/k13aRf/0vCBAtXPdHY0DgFZ3AUpIF3d8dRfCljR8Ir4HkIwXw4MlT5dRmuyeCg4ScCo6c5DNOXlF7fCqmH6AWrezd5AEvfR4CqxSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SrrWuhqa; arc=fail smtp.client-ip=40.93.195.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SrrWuhqa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=axbzBob+v189zD4Cog3u29qCWBfY5jrbmOBZ3WXLweEIw54r/0bvSYQ4AO+OIai8QFOXgkHHE+w/xMhXgKcJtYXBpXmPa8YSqdZiEo5JPG3ALpvzeZobqnwVXCDi+bqxcxizkuixuhlOFTZRr74ekPZxPVp+kYrUd9O3XaB9y7ghdRh+/5M6xt7HAaACOOnRZPaePxkQhnrROyZxok5XG3WVA+iEO6Ws24xIsYOq/aIo96NxWwVigtA1DZWOxPPopjATFf3lyQO0AKgogeooiXTiVhaMUVM9l+0MozMG1+hwtwY+HTNXYER0n1MHyHP8b6XQNeGJ0maVbQCh+1PJ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQsDZMvudWONqfExXU0dCpMji5EWVHIwz1D9KoLXF4A=;
 b=AVEK29t24XIFNIq2h6xeWONzBAPd2nb5TzegLmx1sHPoeFLhrvoo2jFCFtBLEHIJj/cO24dQcKeLuPrJ//w/YSvu90LQPDKVcPRovpLxVrPlIQ3JXCHTQz/4x42aMbVWdNW/y2YCGXS9VJA4k4yotZBA108GlOw1X0433Cuj2C2UMtdCdr7zFkEhImWJhwM6KYwonUvkJFVsqT5x7U8/EES9H4FgtfKUwWhBI8xwTRX4EdHNvaJVJYBMj5FvYjnILWu+X3H89SHX+ZySbKNHvvRkvyQMH1gcNnWmuQjNwNRXDkB+kxFNjuSxySSXEwuYR7zXXPkp0Q3+pH1DwyAoWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQsDZMvudWONqfExXU0dCpMji5EWVHIwz1D9KoLXF4A=;
 b=SrrWuhqafheBnSdjoUURSKKXQuSkkcYzsAfow/6hUbspuEtVuyL8f046QLztaon4v4JPxNkXGF/NUq3e0MUXI4Dp01s91y08cCbHHH6Bbjr1cMngcREPV12YqOsq9y4030s/6r5NvnYt2TUolUJFzJZTke4ZzeEEzBUJ3I/a270Lma+kD77ifP6v3h9pgm+BLhQIZCjN7ceIgvCtN3X/fLrQb5Ms+r55YsU+O5gd8qw0xStG6Udk4CU9+EaQI0iNeI7r1LfnoYhXSjAu654Qn+qV91ajZxKHbmPvPPKJKAYuGPZ8IVflDP6CbZQAmcmY+rjGMiIzub3Zy7MXecf6mQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Sun, 20 Sep
 2026 06:47:32 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%5]) with mapi id 15.21.0428.015; Sun, 20 Sep 2026
 06:47:32 +0000
Message-ID: <1ebf7c3a-9c45-4b33-a418-0f37537a411b@nvidia.com>
Date: Sun, 20 Sep 2026 09:47:26 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: fix swapped IPv6 IPsec policy masks
To: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny
 <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260917115542.177675-1-parri.andrea@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260917115542.177675-1-parri.andrea@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::7) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SA0PR12MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ec6a01-a2b1-49b1-804b-08df16e30bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|921020|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dj9Ee2nIzOg4w7cNLfIFX3v7kFDYdbzaPBM3lQby4THOEnSkJqwa6/dk3U814qdbS5J1x1AS70OoeH2+T8ENMVXfh+piUywVHBZF4eTv1Ja5ts+uTu2wNyim/8s5ui+wFvWdRfd3n59SpPUqfETKaVzjT9C7AfJAM7kxkaKeWYeFUOOiTFG0aAy5wog6rKR2w/aD1ixJ8Y5Y/IONIvb4RTjzCb3/uM6vwbnTwR6zegZjcfKO4O+C3eejNRBRkuj9Cjlgdm77bol2KgEcCEMn1WDYyC71spZsGFNkt2A4D56+pFhdI9jXwZJdItC2X2rrTZmBcKGVPt1VnjDI3z8mFgif0O3SZovfor1061xcgu6BI0kp40UdrPTSRPuH2c3/v0dcI4ZlMof3FArFj5MENFBlfv1VWQb1wMF7vwc4aO2CPALKRx5+9RRc4Rpy/px1lHrSb1qz1a//mRWH6P39qg2H28X2cWa6llz85M0nYmQpsfx7REexMjRd0LtHIPClX4GZBQMlSRf0XC8ndaptlv4L4b8HNLqWQ7tZWV00oUhITJRG/Fe1rNW9RiQGVDpqHQfeCiWH64w+i76XF4aiFiwEYGUUAwIdfEzR3StRBKomP/gdyoEcVDoiNKJLEQiHp/acIRTkdpCg92iNrGg6j6Iwkmg1s0/sQcsKle6WEnRl2OCrdf5FQ4koXJMxMcoXU/pQZv9ksyYdxsmQkXUAVA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(921020)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWZ4bGczZzdwaGFWVzVFSXVPNFBTQXNydGo1Qno2RzQrN1FIMXpDbjJGcHYz?=
 =?utf-8?B?QmtLcExPTmpwU1V0R3NlQlZIcUxFZExJa3h6U2VGdVc2WUdBaXdQU2pTL2Nx?=
 =?utf-8?B?OGdBMkQxRHVlYVB1WTdiYWhwWS9qZFdTZGI2OWlSdmN0MGkrM1NkczlIYy9U?=
 =?utf-8?B?T1ZWNGF1TG96Qm82ZUxRTVBjWDBYMFNPVWg4VXlCL25lZ0kyQ3ArWGd2YUpG?=
 =?utf-8?B?TmxTUHdXY0dvcVQ0OFYyWnYvSHM3d250YkJOMkZnMEFWR3EvQ2NucklqS1pL?=
 =?utf-8?B?REVlUGlOcUl0RlhaeHJyWDJwa3g2cmVjb3k2TStPOWlJVkpvbG9IYUFacDM2?=
 =?utf-8?B?NldOd2ZrWUNQOHQ3bm5keU1MTHlaWUdXL01vSGxaNkpmenp4aVltUzJPd1RC?=
 =?utf-8?B?TnFRZjBCcndYOEIzU0c2UDdwVTEwTkhRdmZTaTdIaDFDOUxsMURFWER5bGJF?=
 =?utf-8?B?T0FuK25BWHVpY1Z3OEhnN1BDWVBJMGhLRzFMTzhUMVRnQ2I2cE5PMHZsMzQv?=
 =?utf-8?B?QklCbTI1emhIU053TEtpQnZwR3VsYksxVlBLb1VLY0sxamswUUkxWHFzSjBk?=
 =?utf-8?B?V1hhTUVaQWZBN01sRnAyZTdPdW42R1dkMExqU29FN1FBMEs2elpvenlwYlVU?=
 =?utf-8?B?WDh4eDM0eGFuZDFDdlEwTFZlay9iZGNtOE92b1BSK1RxZVhHUFZ6b1dqQW5R?=
 =?utf-8?B?TUZaYVlrT3NwV2lpY1ZiZEFSUnd2OEdESW9wWXNRRHpienFxM2V4elg4TWJv?=
 =?utf-8?B?VHQ5SjVwakFuZklBR21KZlVtOW1UN09JNC9zRFJ1MHlJU2dSSnRZYVViMUVP?=
 =?utf-8?B?MEJCQVJqSlYvd2xibzgvZW5NLzVKZ0hvQ1hjY1hIenpLdGdpZ1Q3ZmE4enZZ?=
 =?utf-8?B?Z1pLcWluTkZPaC9Ua3JXNVVuVE00ZXczWENQRG1WZmlFQ3dUbDZIdlZQVE1R?=
 =?utf-8?B?SEhFTHpPeGhCSlJJMURPakdlS2VmdDNQcmxuTlNEZGxidVZ4NlE3Rnk0M1hM?=
 =?utf-8?B?cVFTU3FGYkpFa082NjVPY21RcmM2R21wVTBuaVJaWE1VOHZIcThEaWFhN1NM?=
 =?utf-8?B?Z0J2SmpGc3hWVFdvWEZCWi9QZXAxeWx0S0NQRkN5enovLzZqQ1FOVkFKZUZt?=
 =?utf-8?B?eHQ5YU9BaGVMZm0vQWJNYnRQbTRSVExXckVZUGx5dDRncVJpQUt1Q0pWOWpx?=
 =?utf-8?B?dW92NldJbEgrajNhT2tENWpOL3NhMU1KbnVocXphQUxTSDhLR3FraUhROGVU?=
 =?utf-8?B?VW9CUWhMSlJoUE9PcnltclN6KzFiNStmTHlnSkhVZmlkd1FDSEJUemFFbE1p?=
 =?utf-8?B?Yk5MeVdncHZxaE94bjNkT3FGRUQ0Q05hbWVDUkpxMk1sb05vUkdRcFpxSFh3?=
 =?utf-8?B?OXIwWXJzbzJ6M2RscCtrbEszMzRLdEpxV3YxRC9RUHZMODc4bU5HS0JIYU5J?=
 =?utf-8?B?dVlqQk9UTmt0ZVhza1hRWG13NFI2amttNkJBb3ZMZ2tURzdyOFZoZ085aEdm?=
 =?utf-8?B?WXJjYThDdVB3d1R6dnd0cElVK3FFem9tL1NKbVhFMUZVS1M4MDg0d3QvTlFa?=
 =?utf-8?B?cVdxaEFqcW16cUpOblRqT0tIVC9JY0drN2NsMVBlNk41ck8wMFRDVE85ZSt3?=
 =?utf-8?B?M2RVVnlZWUFFNUxLejZMNDB0bnNRUmVQSzFmSk93RGxzVXRiK05EMVZWRFU5?=
 =?utf-8?B?STdQWjExcTdHeWhpU1RsakRIem12N1YzWGo2U3U1REh5a0RjLzE1U3VYSTJz?=
 =?utf-8?B?dHBJVVJjYU1nL3I4b1JZaTdmQnZiQnB2eTlHUk44T3ZXaCtrL0cxQUVCeTRk?=
 =?utf-8?B?bmF4ODRjMFZCMVhCZ28vZ2dqdVJUUXEySUR4dmFyYVRJSjZESU1OM0tGSkRR?=
 =?utf-8?B?NUdJQmQ5Z0JvTG93R0piaTlnbWxuakhHbU41N256OWRFdHpvRlVJOVFGSGQ5?=
 =?utf-8?B?elk5NjZYQmxnM1J0OXhqQXdNMjlhZWRFeGYzU2N2c2dHQ00xTEMyY0RFRFg1?=
 =?utf-8?B?UnEvcDlzV3dGRitBVEZ3WmZ6QXJvVGRtVCtPZll4VDBVT2tKcEkxSTQydUsw?=
 =?utf-8?B?Unlhb0xWUXRqdk1GamJCMFRtTGNyUWlBREpHb0xmdXJudlNPK2k0Vm4vd0FI?=
 =?utf-8?B?TXY1dVI0VFJKZi95MFVvcW1VMXFKMSs4RVF3bjRocmd5cjJEOUJzSGpMN3hC?=
 =?utf-8?B?QkR5TWRTdHN1WGtkVjE2M2E2c2FVWUFBQ2g2SW9OL3NtUWJyYm5NR0dlU0sr?=
 =?utf-8?B?bm1MU3VVTDh4ZmRlWmE2T1h2bE1KK0VEVE1jVjNMc01ReDQ4N2xqMnpjd3c5?=
 =?utf-8?B?Ym9IaGZvMHhpbmdwVkRyL0p1bXo0dVNqV2Z1UE8reU4yQmx0Nlptdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ec6a01-a2b1-49b1-804b-08df16e30bfb
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 06:47:32.6884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uk0ylGRt5AER8VAYTvJBElMJciPmi22x/ewXUojJjFm9sadjWF+CJ8VJtrSnRd/BLnzQyLJMDSOIXXFQ31NgDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479



On 17/09/2026 14:55, Andrea Parri wrote:
> IPv6 XFRM policies may use different source and destination prefix
> lengths. mlx5e_ipsec_policy_mask() builds the corresponding masks
> independently, but setup_fte_addr6() installs each mask in the opposite
> address field.
> 
> When the prefix lengths differ, this makes the source match use the
> destination prefix and the destination match use the source prefix. The
> resulting hardware rule can both miss traffic covered by the policy and
> match traffic outside it.
> 
> Install each mask in its corresponding match field.
> 
> Fixes: ca7992f52c2c ("net/mlx5e: Properly match IPsec subnet addresses")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 329608c59313b..8ffa8068e90ac 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -1564,14 +1564,14 @@ static void setup_fte_addr6(struct mlx5_flow_spec *spec,
>   		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
>   				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
>   		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> -				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), dmask, 16);
> +				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), smask, 16);
>   	}
>   
>   	if (!addr6_all_zero(daddr)) {
>   		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
>   				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
>   		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
> -				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), smask, 16);
> +				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), dmask, 16);
>   	}
>   }
>   

Thanks for your patch.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

