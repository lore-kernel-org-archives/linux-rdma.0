Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E4D377AA7;
	Thu, 13 Aug 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786608922; cv=fail; b=oK9uWrMlj+YOQaSU6oG20YV089QuqbJYudPTlZy+dj0SnEm5OIPTb1wuAiNdpQm6FTakUSt5q1n9DsrYwv10badS2W8fM4mOplXTq1nRmJYLaXtNw2cDiWMKaDLfHOaA+mwsOE8fozZaYFk+SXGuQWxOmxpqZI3XVuuPdZim3o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786608922; c=relaxed/simple;
	bh=VpErrpEphgHoVDweeMb7H+X5GFNT+C7c+tRID7/q8tc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NCHS2oEcLqq1FeIRsOOif3NioJO1zi4hcCe8C6YS09dz3B8qtotNlT82HyozDxNUuOChzSeu7r0xwPlu3tWEiOyHKhOPExKR8GhdbfVfU/CtWtTmcjyaNH240CS6+aL7BGLOoqVL2uP5Llidhhjg+WFxrPFZZp+dbJEm9tAauR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZRODXhcK; arc=fail smtp.client-ip=40.107.200.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZRODXhcK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yE7ROfnHbDyvt/pjAbyShAXDb4qOjtoYnkRikMa0Je3Hdg4S9G3vWpDwunxglzPkd8phJA5dz1JzcDRJW+YO9WT4Cdfa3ji5r1x2PsH1bzODm2XgQHHmNsupF9XPi6GxZe/Szzeygw+i8yEc+/pOC+HOD5XcGw+mS5eOjmoGApXSD8ABNr11q1CPfdu4y57A4xn0nqE6Wl4u8a2N/bgga2h8324QLeWAVDwMQRlUIm5OtfKRLP2IEkXZcqEZmxXO8fO2K5vf7zZcKwx1tusWmUO8LUNhLFuuYpWDCGO8glrHh52DRUEIdt5o77nrZwbsFqikn5V+dJNJdcNogMESmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgG6N1k1C24to/Px0yrzKtRF5YdEphA3h9CowBBm5dY=;
 b=FQRVO21rp54H17t5rfJiXES3NeCpsht0qwYumFOr00QJ2+fsaj6XkmvRw5ZEYrNfVAB3NOnGDP4A21EN+VbDfPHst2MTjLK0Z72MXAPl2YKD5Aiqot7wVZj1unEDuNSZ3BGAgwPskWTvPpTjDKOv8PAvZrp1ELkge0iP6dA88Ny0yNf05JYkLe3TandseHrX7dAsM816SkxECROClczgTrl+Wk2nls57h6Q7zJWTxga7aQvcHh0e2UEWsZPp2SZNwdNHiLLUDDljuUBfFEzY6qfzBgweX0fk240xL5b7dEanSfpNt3Tx/vvszohAUlXD329mzZA0UIesCrFQTayFzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgG6N1k1C24to/Px0yrzKtRF5YdEphA3h9CowBBm5dY=;
 b=ZRODXhcK+DsfPWzD01DcSEaKf40l8pveoRukkBIcpQAw93l9lll2SVcN9Z/mR2YJs9ZIS1/Zq807vaCUQ1VHtiBCF9Lf6YslsVY5Da7f6OQHpx58no7Xx7lyTPjoAROJc6wScjaaKylhV+ILg9hd/xxVAIgyjKourDbxcdE0/X6tIZHs9j6J0FDNF/Nq9ieI/WihrcPo+XFM9drkYS0SNVoNtWIP0JJhJq1JAUgAjC854rT4tJmSsDOTwI31uYOdhNwjQCpOq2pn42q5XPVbF5UuT/DawSEr1BwFUxzlbxU4q9osUrLU525TJUGv2Pl6ErNMp4dJBQi8fkHIzaOHZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 08:15:11 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%6]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 08:15:11 +0000
Message-ID: <95c8650e-789a-4659-8bd4-61b4781ed65e@nvidia.com>
Date: Thu, 13 Aug 2026 11:15:05 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] net/mlx5e: do not HW-GRO coalesce small frames
To: Glenn Judd <gmj@meta.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Khalid Manaa <khalidm@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260806065650.2444999-1-gmj@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260806065650.2444999-1-gmj@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::6) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 4581fd95-5bf0-4611-abbf-08def912feb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	edTqr2DOal3c4qgNyomDVGRW9OF4Aa52Nxk4HJPX6r+gBRPlZ7iDmtB699Yqu4a85HGf45zUsBzTapnTKwoQ/OfIV4Qls3TZK5qvccmOBEPw/xYZsRMcSFPxpnOzYFdOtr7klSZV6MGocLRVqZQfGa5bVGuSRxpUAosbSUg+aQBaliqqyMJnC193o4BkwmdCDDgjh0TPxUt8D3Eg+s9vZ7AoTf/gHNy1UqwE3gWlSzZvUm1JCS+QFPsoFP6Uc4EOWDfkY3jxJhGsRe0PFa+T0PKlH3EgjkcxIc/XHzVtChZcjGsYfaYHJO2CY/lnpP7oc9FnQXm0sLfmBUiIDXuSRn8YgJnUZMo1g0+pusRCTTDU6bqUkl2EcNStxCqUwluAh1gu2lY2b4RgVntkKOLKayN80EGaitGOKfYPOdbeu6EJguydmOSTzNW5ql5Yu2gQUgal9hIxLA+u5Rtq/BZi3sOzPHc0tCwQKLC+050HuFvj8uXHQVkIi4sUEEgQnK9xq4i2e9Cp9uq3jQtPfPQiuoMovAK08o4AEQTXBsE3vVcVd57/SgXDIHS+YTznmUCxdexByLsv2fqEPUV2dOZ3kPM6zBRZF9/U6fSTxnWlc7o/hpamoBvLgo4O1vTrw7D54/FCcL8zmOzCtV2Z4pJwyTa1NlPSqhHtyGsTU31A7vg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2FUNXlwTll1TXQ1Sm5hL0VRUm84UkJPTzhlTTg4KzVLRTZqcVkzMjNvanky?=
 =?utf-8?B?TUFhNjhIRk1jalZYcjVMbWdSU0QyS2RvVzhrd29McHRXQzBYRWtMaUczdytC?=
 =?utf-8?B?K0RlMFhSaFBXNW5vN3ZNbFJyQzYrSkxMSTJZMUlsYzY5d3NneTZHUTZWQS9U?=
 =?utf-8?B?ckJLRkFvVlJhZk84dFJIZ0NoUjh6TTg1TnhIZlJ4NGZYb3hnQldYbUNWaUdD?=
 =?utf-8?B?Wmg0MThnckR1bW5XNEVERzRDM3JsOElBU1k2bXMyVG83anZKTENldS9hcFBQ?=
 =?utf-8?B?dndhaGRNMXZCejIxb1I5OFNIOE5DZjU0ZVk3eW1YeTEwN2NIN0NmN2pWdkNB?=
 =?utf-8?B?bXA0U0hqTnV1aVJUeVpMQzA5ZGRJRzYzeWFjVVRIU2JsZ1lQN0gwdFVPQ3hP?=
 =?utf-8?B?c3JnVDYwdG0wdWx4RG1Pa0t3R2JFYWs0T09zZzNwR01NSUdybGR3WkJxUnBo?=
 =?utf-8?B?SUhMWkZwcnQzZGVoUzNXYmpSZWxhODFjNm9MbUtLLzRGc2U4TFpYRElQdURp?=
 =?utf-8?B?MEJ4N2RlUzJuMzN5NHcwMDRSRklSSEs1SEFjYTFlVXhDeHhUV3U3WmVzcFFE?=
 =?utf-8?B?U2MxWk5pemM5aVQ1bjd1Y2swOFEzNFZuZ2xLTEtwN0YvK1pha3EwblcxaFVp?=
 =?utf-8?B?enF0YStQSVE3c0VHMGdNeXNjSVJZOGxWOWo4REFZMjhyblFlMmFjQ1BvdVhY?=
 =?utf-8?B?TU1tYXc3NXdkWTIrYUNWMU5Ma1F6dC96TEtkTFlDNmpIeXczUjNRQSt4dHhr?=
 =?utf-8?B?bnRmUmNzYkxXWmJvUmVPdTZ0bzJGZTRZNFgwUTF0NmRWRCtyaE9PdHNpdUdw?=
 =?utf-8?B?NWpmbDRIQjdpejRqdzZKVkdqZlFkZTMwc051a0xhVkFHYXZCRnY1aFZZajUz?=
 =?utf-8?B?MGd6bXg4RWlGOU80eG1yZjBSMDVwd3VqbVZWclp0RTJHeDg2ZUltS3FaaDdL?=
 =?utf-8?B?TkNVQm1JbUxUYjNBVWlTc1h3ZVd3ZVVuSm9IU3Z5MU9GdUNUN3B1TDRPQ3ZP?=
 =?utf-8?B?dlpkdUsvcUJtRThMbG02OUJpcSt3V01PNGk2WC84Zm5VMFllNXdYc3g1SkE4?=
 =?utf-8?B?R1ZwSXNLampQeWdDeG03RFh5QnBqZ3pNellBK2Mva2dSZkVLOElSNFJheXM0?=
 =?utf-8?B?M3ZoMG9GYWRyRythcGQ3L3pXaWpYdUVvNkxyeERLbjJBdnd6dEQwT0xEQmpl?=
 =?utf-8?B?dFhRR0ZGRkdJcnNnMGhRUjJUVWpGNFY2REVwWitQNlhEU2VTMnB1bGppSlV4?=
 =?utf-8?B?Q1hIOWRITVI4RXpMNDdvYmw1RmJ0SjRvSythSTJpODI4OEJWcXhvelh3N3ds?=
 =?utf-8?B?TUhrYVBWRy80a0F3N0ZFNStWaFhwT1BPb2wwRC9jaUNKZDNMamw3czJyR1NV?=
 =?utf-8?B?NlVrVHYxRHlJV2FGNE9kSzgrcnA3dnp6b3ZjdFhLR3p2anFEQWUwNGFIZDFC?=
 =?utf-8?B?K0VwMnYzNFoybU5jRDNTd3ZrL3NPbFdWWG5sYUdtOFVJeTNXWnM1aUdpWnVv?=
 =?utf-8?B?WUlNVWlqVTZCTmJXVXB5REFhWHBTYjJsS0pORGp2MTN4czY1QVlWU0k4ZnN1?=
 =?utf-8?B?OUhtTEhObU5NOXYyVVJjVEVtV1N6RW10ZDhrR2RxZ1dDanFoaTFkeFM4a0ti?=
 =?utf-8?B?MmpHMVltZ3ZIYU03ZWhhVXVrR3lFL0xtUEsxUEUzSU9IRHRURWl1bitOSExS?=
 =?utf-8?B?aTdRUGVGViszdE5GSEt2OTAvc1NvWENOLzRXMXNQcHYxaHZwMkVpeDJVVUhH?=
 =?utf-8?B?bVhaVXRqVXFVdkI1QnJwdmF2bUpPU1RHM3hHdU50eVcwZTBUanJJUzRuRVF0?=
 =?utf-8?B?WTRMekpaYkcwRlpReFR0NWZCNGxsbE5GK21zVnFWdkI0dGNFbTZaTGRGd1N5?=
 =?utf-8?B?L3FYQ2FHNklaSVVzNm9XYyt3VHlNRXU4R2llQkhmZWhHUzB0R2RiZXRKSFhx?=
 =?utf-8?B?NkI4OXBvY3c3dGpHVVVFMlNjYlNYMWR4LzRFQjJZeTJFMmdBSU9rTlNlcy83?=
 =?utf-8?B?M3dyVTRjVEdjdFhRb0sweW4rNGJ0K3lYalpDM1ZoQ28xVFFKWXV6OGFyNGdW?=
 =?utf-8?B?bzY2UEFiRFhKNUs2K3liKytzVklDRlZ6V2ZoMzdDQ3c5WlVWZkpIanQwUXF5?=
 =?utf-8?B?a3FVN2VyMktnM3VmMitjQTRlTHNBQ05MR01aUnc4bFVUd1puck1naVdWb1V3?=
 =?utf-8?B?bFpjQnlMYnUzT1V1WStiUkdaYVJuTVNnVDlCT2oxRTBlQXhQVG1xY0VsMmRK?=
 =?utf-8?B?am4zK2x0RUxlRWZBVHR6aHJtUzkrb0MweXVqRHdDVmgxL2tJVFY5UXB2QWtu?=
 =?utf-8?B?Z2tXRlNqeXJhUDR6djZYTnRxZGVGcWtjblU2S2hvMjBUb2tGdmZYUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4581fd95-5bf0-4611-abbf-08def912feb5
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 08:15:11.3877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: walQppJnQKbP80eZQc0GhHgu7Nah1uHO5Ec9CQoVZr8rBuA3EgL8IPAyFHIQirZsb7K4DqENUi4rCw1wFeeU4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616



On 06/08/2026 9:56, Glenn Judd wrote:
> When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
> padded up to the 60-byte minimum Ethernet frame, the trailing padding is
> folded into the merged payload causing padding to be delivered
> to the user as payload.
> 
> Detecting and reproducing the issue: the selftest
> tools/testing/selftests/drivers/net/gro.py subtest
> hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
> In current code, it receives {106} (100 + 1 payload + 5 pad) instead.
> 
> This patch avoids giving the user padding as payload by simply not
> coalescing small packets (which fails the subtest; the same approach
> and behavior as sw gro). This gains code simplicity at the cost of
> more computation (passing an extra skb up the stack) for small packets
> that could be coalesced.
> 
> The threshold is chosen as ETH_ZLEN + 2 * VLAN_HLEN. This is the largest
> frame that may still contain minimum-frame padding (+ 2 VLAN tags), so
> anything larger is safe to consider for coalesce. (We do not include
> ETH_FCS_LEN in that threshold computation as netdev_fix_features()
> drops NETIF_F_GRO_HW whenever NETIF_F_RXFCS is set, so retained FCS
> can't reach this path.)
> 
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Assisted-by: Meta:internal-AI-tooling
> Signed-off-by: Glenn Judd <gmj@meta.com>
> ---
> Notes:
>      v3: Per reviewer request, redesigned to simply not coalesce
>          small packets. Dropping the v2 padding detection/removal.
>      v2: https://lore.kernel.org/netdev/20260803214412.1714151-1-gmj@meta.com/
>      v1: https://lore.kernel.org/netdev/20260731185442.2778723-1-gmj@meta.com/
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 04af54b704d8..68b4dc49ccea 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2263,6 +2263,11 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>   
>   	data_offset = wqe_offset & (page_size - 1);
>   	page_idx = wqe_offset >> rq->mpwqe.page_shift;
> +	if (unlikely(cqe_bcnt <= ETH_ZLEN + 2 * VLAN_HLEN)) {
> +		match = false;
> +		flush = true;
> +	}
> +
>   	if (*skb &&
>   	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
>   							 page_size))) {
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
