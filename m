Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9D3B058B;
	Mon,  3 Aug 2026 20:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785789070; cv=fail; b=no+oXs4yg3cP9mFQprWqmXuwAQQMWJHgRdu/jXtZ2GcxnaRutnIxj7hYvVbIOMG20LuKHyB3zFBtDr2w3BD/HUUZBIPu4rfcz4pAUcZgutcivlS4YbmoiOZ3wpI5oyHCFe7DtC0zvQJ5FKmBush9BtEuLNq9SDFj5Kegac8VWwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785789070; c=relaxed/simple;
	bh=69eMnrkUS/Ukt8I+p4vMIf4BrOL/VqwOBkp7YL22h/s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rodQmKO/eW6JJP+xuR2C36460Uqj6nAcqaWWrBaaMUw4QrI0hqt/07HZmPFMqwZiSUqGuvvTBen5qOc0beJMUJPrhRUhkaFy17WojgDVh3loVduXQ50kEzI4M4vna4Mt65PX3OtWGDmhxkKpig4zU0iFGBj5iuLXS250X1A7IGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mb35T/gK; arc=fail smtp.client-ip=52.101.193.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mb35T/gK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=re0wNlcbrXld+W1fCQgHRqSgiYA7ZG21k2mZ4ngRLrNKnVigGCm2h/IK7dMKps08xozsCSD4sLZymAI8ZCLYozzYjE5+N7xFyCo0PTHxqiDPQDEILbYxuNQR0PYce0cx2aY4wGHKv32x2GR2LEbPM3tDnp3ZzjlH7XynyXy1cJKa41asBiyPEFdGYOOFWn9JjPXLy3n0vwBbfFllIJjD0R/xX4BhZcZBgrPeVP/NhiDGO1pmJhv9tSV0nvDwF2NpNoy8XVkdlGh70+vZoDR0ca2TxUfpHV5QP7uUyuaP0I/UekPvR/Z34Z93Ra/UkVt/P6yUVQoHdPUnClqqCA9Ezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b64jT/Vzb8ySFErfgWXZ568QqojWshpYpUc9Jy5wYmI=;
 b=XPkCwPnekV/kOYgrXopCpdcoNXBJ/oMt58zPaiLlLIYsP8txq53MQ3uxc0PVgSJwMGj7L9g3SZuO4bG9MPdRVyX09zAZRLYA3Jjpx7ua2kTgSPzcrTYY9hgLtsGYrqPyKyyO+RkeAJDjsB0K3byAVmbL43cgH2mX4nWnzTIA6bjXxu5BePPgHVAwYxAx4/nFKNHOIr5AF21zDlvDPuhKopD9VeK/XvlIpIe1P7TmpXLa/hOANdQDlxpl72US/PTVFnZTdJNlq6MmXJc0f0rXGYubIcTTQnXVXgBZUsqcXBUdM/6Bk2Jpl+l1zE11bnoiQUgviYjZiDpqq5yhOa7EGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b64jT/Vzb8ySFErfgWXZ568QqojWshpYpUc9Jy5wYmI=;
 b=mb35T/gK6oaxo4yK84GcD3gSyklIYJxEN0xtGhjWOA/kS6oPUGu2MxuODhjm8YvoBJMgCmbgymMGkI8WUBz5fM6ROT7+eaEybW0S+W15YwrWKodGnf69PlqW+5cXzBYVfJctGK4c+qjxJtLijO6G2uG6wmBbwkh+HrxNVRPYgVkJqFvblKuzdSFwCeRkwhyzAWmQtutj5UE0AZesE7ngwMxcpAFwHyGST+J73qEVNbkQzdreyLVNhQGcZUQ4lLH15RSm7H6ztN7GWfbfzeRCN1I5l1g3knNMy5gnG3OaXqpqofM7MRBg64R4QCLpvVxIqOdk948lVtyetivsXPnm8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 20:30:57 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 20:30:57 +0000
Message-ID: <39078a1d-f4a2-435a-8921-24919a46ad54@nvidia.com>
Date: Mon, 3 Aug 2026 23:30:51 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: strip runt Ethernet padding in HW-GRO
 (SHAMPO)
To: Glenn Judd <gmj@meta.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Khalid Manaa <khalidm@nvidia.com>, Ben Ben-Ishay <benishay@nvidia.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260731185442.2778723-1-gmj@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260731185442.2778723-1-gmj@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:303:8e::21) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 11646212-79b0-4276-84da-08def19e1f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|22082099003|18002099003|11063799006|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Tryitq5guNWLa+U8PgwISnoGNZES07SRZKgyNAxiO1Fr1oegQGt3NnnCmLT1EP/jWyfqk/KR9MEjuwwNJwVKvqUjdCi9dvkPUI08RxuI+lhfdLtD9r+a/UKFeVnmwnvEMyy3/DryK/+8I8P70nlh2tktUKwjGLRaRjA0CDksufvXKVpl/W6vw2xiWGNX4V5dfAWxyerHJDtVYryDBOgNuJAh24B0ClvfHPAl6bNumcaVJ4jLePXaJgtjrf9/HSz3MtbGCvIAr8DRonfNGWuDgLVICIXThpV9H3zEPiNFQonPxeB2vL+NVFX3S0R94A4+uMj0eNWl5jRwZmUo4zJnQ9n8t/4af9TJwXZoR6MvbvoW8z/4kERPSO1MoLuVrPIcMQzTrvntYqZUszrdyes6N+4NQ+I5nOiociEyHQcoK+LPufiHaIrM8pNlNFphsu7yBeVnDUx7lj1NcmarhnMtL6D/EnZRCfSRHGJcQTjTvwM/qVJkXAhlc+ZFVsaXOPnjembCnibP2H8h0ws0UciLHoQb0J1uF/abPzlbroxKVXtigYICn1l7Vs2bIVqN4bapxuUx8w8X0No6wayKDgYMlLgVcTI4d6T87ZWNXmXav/RBMtrZwlKbcFVGYwqbrILJ1fv9jxHqLGKhCOqi324I7mjD8ikd0AYsjrhpjOze1hk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjJ1RzBmeW53ZzdBZHhGYkZEYm8xNTJlSndRRVlIaVh5c2JZb1o1cmVrRVlz?=
 =?utf-8?B?NGZtVTJZQ3Z2NGNBS2J0TXp5N1B0Sk4rZXRZSnhMRDBFM3BPdnpqMCs5eFRh?=
 =?utf-8?B?YmlobkJWRDkxemtYci90RjQ4RjFZVlpROUlleE5DWk4xUC9WcVV2RzJ0UVB6?=
 =?utf-8?B?cVFPVFk1K0xvQUI4QkFpbUFCQ2J5OWJ3TFIrVXp2Y3hacmZURXhvcjRGemht?=
 =?utf-8?B?RVMyTzd1NUdwQkpWZ2Z3KzQ1NEVtVXh0ZHFXQjhENEszQ1dhM3FOUlpEcVRZ?=
 =?utf-8?B?TWtVZmdIb0E0M2VpSHdzaFMwQzM1Qkd3RUpNV0dQSE5rOWpmUHR0WkJXNmF5?=
 =?utf-8?B?L2doS3FjclJoV1hFRGE5SkE5RDNMUFBHQ3ZaVFNBeU5KNEJHUWdLemM2VzVx?=
 =?utf-8?B?SXdBL1BTU0U0ck5SZzNwZmp5TzFFYVQ5Sk0wN0NpVUoxNjVZM09aZHFaRzd1?=
 =?utf-8?B?TW43YmFNZmtaK0tEWUFBOFJraDRja1B1VzVPMUZ0TzZIOVdvKzJhNEtIVGFa?=
 =?utf-8?B?ZVdoWE85VkdCUWloTXdLNjhqcTNxeCtETTNiT0ZReGt2bTBZR2lkQzl1YkRP?=
 =?utf-8?B?WHZmL3JqV0JrZm9mSVBJblNYMEpJWmc5L1NkQ2lETlFTeUZpZndnbTJPVzhL?=
 =?utf-8?B?cDJvdE9MNEtQbnFMZzRxRVpobUdOZ0ptV0ozVVVmTVdsSENhdWNoUnFFTitn?=
 =?utf-8?B?RllKT0pJTHdVNzVKMGh5N3AvMUdaVWtWSmg3UVpIY2tjdjlPeVJLcWVMZjVC?=
 =?utf-8?B?R1ZUMjBETzVITDdwaTllb2E2elJqRGxUSnZpcUNNcWYrMUs2Vnc5TXlFQURW?=
 =?utf-8?B?UlczVS9rVHhTd2RYR2pZNnF5eHMxMngvL25XN3J6NHB0eGpibHI4Q2pDWWN6?=
 =?utf-8?B?M0xxa3Rib0lxaGpPdCtQK0dZZ3Z2MXlacDZ2Y1JBVzBLbTYzWG5NM1E3TlA5?=
 =?utf-8?B?WnNUTHdiNzZRYTc4clJsN2lqUXBOdmNoWExDMllvajlRU25OUFQ4VlpWU1lu?=
 =?utf-8?B?UW1sMkxod1NvbVVWRnEwLzQ2RUU0NDF3VnBicm9HaG1RZkhkTWRZSkpOUTdo?=
 =?utf-8?B?RENURjQ2NjJvVmVQbytyMUV1SllQNEkyMy8yamRjNUtCSldzSXI1b2JZbVZQ?=
 =?utf-8?B?MHIrbTNCTURURGRWa2duTnI2WHh3VEJWN3FoL0VGRUFHTHlHNmphc3VlUE1x?=
 =?utf-8?B?WWdjQ2l6eUhZRms1WHo3VUU1TkRnMjFjQ3ZQR1ZXNE9CclVJclQxemhKdmhD?=
 =?utf-8?B?QTJ0UmhNQUdtcE9pdkN3UndiWDJrSFd0QUw5Wm1EbW5vemxCNWlyR0V4dk16?=
 =?utf-8?B?WVByZHMwZWg0a1ZqSHR6bExiN2lKU0RNYkdMWk5CSjI3RklLaU1oL0EyRXg3?=
 =?utf-8?B?Q3JrblNndXlQNXE4cVFNclFMNGZ3K1poc1NWVkViYmFWSXdNVVZoMGUrQVBi?=
 =?utf-8?B?Z1hhemNsK3JmMTlzZWVCVmJ5QjNnM1A4Y1hzV3ZPZHVVUmFFd1FTaW5XcHNP?=
 =?utf-8?B?N3NkOGt6OENWY2w5eEpwVHRNSVB2RFJwbEdsVm1tWnBUU1lXNytoaTVWNVdU?=
 =?utf-8?B?OEZRWlk3UkM2eVlLU3pGVjM3OGZwK2VMTU91eG1OQWw3RGtOaGtYRjM0V2pE?=
 =?utf-8?B?bFZJRjhmK3JTSG5DTVB5bklKdnl5SjU4WFNTSllSYWhqWGF2WXlzcTVnVmo2?=
 =?utf-8?B?eWpPSkRuVmJxc1hKZzBJeld6UFNKZzM5WmhRVm9uWm1kMU5KU2VVRFN3cE5R?=
 =?utf-8?B?Zlp5YTJIRG4yUjZYeEloMldycjJhelpUWTR1alQvejdqZG53YnpFUDdqeWp2?=
 =?utf-8?B?NlE4Tm9wakFGZ3FzSVFESnhSSjdXaUhBTDllNndXdkFBUlJoekR0QjdBRkN3?=
 =?utf-8?B?a0RFeU9lQ0prTVIwTzBNdmdNQ1JYMDNMZlQxQm1TSEJsNEdKQUc5bHU2SUV2?=
 =?utf-8?B?bGlyZVVkUGRHWCttVUJhWUFjSlhBWno0eEdETlUwWmNyNHZlQWd1aWYwaDVU?=
 =?utf-8?B?R1dTVFFCNG14Y2tjTUtMR253ZldwZU51cy9Nek9ncGdYdm9ldkN2enZUVVdX?=
 =?utf-8?B?UU5JSnNXM1cyRG1LOGZ4OFVBdFlzZGE4WUEzaklnYllvdEdNS0Z1NUhQdWdp?=
 =?utf-8?B?cCs4TUNPaWxjaDI0TmlMUmwwQ0ZaaW81STlVYWFTYkRtWlArWnBlSXczWlZ0?=
 =?utf-8?B?TWxGbDF5TVQ4VnJYbUpicEdDdGtIcDBONkZucHltQ2tZMG9mUWEwbjNsNkxq?=
 =?utf-8?B?enJYMEhMMTh0ckdTL2FhZTNmYW9FdXg4aG1TbkI0eVZnOU4wWVEwcXB5c2NB?=
 =?utf-8?B?WmdtblZFVkFMa2VQaU45VmxEVW9sbExuSHYrT1V6NHM1NGk4RldFUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11646212-79b0-4276-84da-08def19e1f96
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 20:30:57.1694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kTevfkw7RdtPKM6y04wM+21jBk1jqU4x1yumSYV+xdTu5oS9krv5TTeJ8lfU0qGU88QKdaRJ/wld59CrNRsZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789



On 31/07/2026 21:54, Glenn Judd wrote:
> When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment
> that was padded up to the 60-byte minimum Ethernet frame, the trailing
> padding is folded into the merged payload.
> 
> The selftest tools/testing/selftests/drivers/net/hw/gro.py subtest
> hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
> In current code, it receives {106} (100 + 1 payload + 5 pad) instead.
> 
> Fix is to compute the real (unpadded) frame length from the segment's
> IPv4 total (padded) length and drop the padding before it is merged.
> 
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5.6
> Assisted-by: Meta:internal-AI-tooling
> Signed-off-by: Glenn Judd <gmj@meta.com>
> ---

Thanks for your patch.

>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 72 ++++++++++++++++---
>   1 file changed, 64 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6fbc0441c4b8..0b40db3d50aa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1506,12 +1506,41 @@ static inline bool mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
>   	return false;
>   }
>   
> +/* Real (unpadded) L2 frame length, or 0 when it can't be determined. */
> +static u32 mlx5e_shampo_frame_len(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
> +				  struct sk_buff *skb)
> +{
> +	u16 head_size = cqe->shampo.header_size;
> +	struct iphdr *iph;
> +	int thoff, nhoff;
> +
> +	if (rq->hw_gro_data->fk.basic.n_proto != htons(ETH_P_IP) ||
> +	    rq->hw_gro_data->fk.control.flags & FLOW_DIS_ENCAPSULATION)
> +		return 0;
> +
> +	thoff = rq->hw_gro_data->fk.control.thoff;
> +	if (head_size < ETH_HLEN + thoff)
> +		return 0;
> +
> +	nhoff = ETH_HLEN + thoff - sizeof(struct iphdr);
> +	if (skb) {
> +		iph = (struct iphdr *)(skb->data + thoff - sizeof(struct iphdr));
> +	} else {
> +		void *hdr = mlx5e_shampo_get_hdr(rq, cqe, ETH_HLEN + thoff);
> +
> +		iph = (struct iphdr *)(hdr + nhoff);
> +	}
> +
> +	return nhoff + ntohs(iph->tot_len);
> +}
> +

This function is costly as it inspects the header. I'd limit the header 
lookup only to cases where the issue might be relevant. i.e. call it 
only for short_frames().

>   static bool mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
>   					 struct mlx5_cqe64 *cqe,
>   					 u32 cqe_bcnt,
>   					 struct sk_buff *skb)
>   {
>   	struct mlx5e_rq_stats *stats = rq->stats;
> +	u32 frame_len;
>   
>   	stats->packets++;
>   	stats->bytes += cqe_bcnt;
> @@ -1525,6 +1554,13 @@ static bool mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
>   	if (!skb_flow_dissect_flow_keys(skb, &rq->hw_gro_data->fk, 0)) {
>   		napi_gro_receive(rq->cq.napi, skb);
>   		rq->hw_gro_data->skb = NULL;
> +	} else {
> +		frame_len = mlx5e_shampo_frame_len(rq, cqe, skb);
> +		if (frame_len && frame_len >= cqe->shampo.header_size &&
> +		    frame_len < cqe_bcnt) {
> +			pskb_trim_rcsum(skb, skb->len - (cqe_bcnt - frame_len));
> +			skb_shinfo(skb)->gso_size = frame_len - cqe->shampo.header_size;
> +		}
>   	}
>   	return false;
>   }
> @@ -2244,6 +2280,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>   	struct mlx5e_rx_wqe_ll *wqe;
>   	struct mlx5e_mpw_info *wi;
>   	struct mlx5_wq_ll *wq;
> +	u32 frame_len = 0;
>   	u32 data_offset;
>   	u32 page_idx;
>   
> @@ -2263,11 +2300,22 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>   
>   	data_offset = wqe_offset & (page_size - 1);
>   	page_idx = wqe_offset >> rq->mpwqe.page_shift;
> -	if (*skb &&
> -	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
> -							 page_size))) {
> -		match = false;
> -		mlx5e_shampo_flush_skb(rq, cqe, match);
> +
> +	if (*skb) {
> +		u32 gro_bcnt = data_bcnt;
> +
> +		if (match) {
> +			frame_len = mlx5e_shampo_frame_len(rq, cqe, NULL);
> +			if (frame_len && frame_len >= head_size &&
> +			    frame_len - head_size < gro_bcnt)
> +				gro_bcnt = frame_len - head_size;
> +		}
> +
> +		if (!(match && mlx5e_hw_gro_skb_has_enough_space(*skb, gro_bcnt,
> +								 page_size))) {
> +			match = false;
> +			mlx5e_shampo_flush_skb(rq, cqe, match);
> +		}
>   	}
>   
>   	if (!*skb) {
> @@ -2311,10 +2359,18 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>   
>   	if (likely(head_size)) {
>   		if (data_bcnt) {
> -			struct mlx5e_frag_page *frag_page;
> +			if (NAPI_GRO_CB(*skb)->count > 1 &&
> +			    frame_len >= head_size &&
> +			    frame_len - head_size < data_bcnt)
> +				data_bcnt = frame_len - head_size;
>   
> -			frag_page = &wi->alloc_units.frag_pages[page_idx];
> -			mlx5e_shampo_fill_skb_data(*skb, rq, frag_page, data_bcnt, data_offset);
> +			if (data_bcnt) {
> +				struct mlx5e_frag_page *frag_page =
> +					&wi->alloc_units.frag_pages[page_idx];
> +
> +				mlx5e_shampo_fill_skb_data(*skb, rq, frag_page,
> +							   data_bcnt, data_offset);
> +			}
>   		} else {
>   			stats->hds_nodata_packets++;
>   			stats->hds_nodata_bytes += head_size;
> 

I agree that getting the Eth padding into TCP payload needs fixing.
But proposed change is really invasive..

IMO it's much simpler to avoid SW aggregation for all small packets 
(without any inspection) rather than running costly and complicated 
logic just to coalesce a small packet.

Besides the selftest expectation, did you check what does SW GRO do? 
Does it strip the padding and coalesce, or refuses to coalesce padded 
frames?

> base-commit: 8ba098e6b6ff0db8edf28528d1552be261af30d4

