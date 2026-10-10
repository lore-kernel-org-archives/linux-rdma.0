Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010057.outbound.protection.outlook.com [52.101.46.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9720613DDAE;
	Sat, 10 Oct 2026 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791640851; cv=fail; b=uQIz4lg9iML89b14eZ3Tf+ql5NGNxvexZCTib/2EqwmOvdWMkh8x9TTT2RWkmyrEV0221lJYSwLMYn2JUnenKwv95Al7dj7+aNqU6c+O5uJn3069rDeJZPkfhEldns0Y9n7VInjNUXy8tH3kx2Ps4zRAP5PE6em4ttuNWCOwLvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791640851; c=relaxed/simple;
	bh=oRqq9t1zPnFEsNr3VYDOoe29A556Z5JB1aXIiaWNERw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G1Oqq8FsSMZ9p8tRb2Xxe7DGzktNgwSPCHMLRKJ7GV1LzeEwAmYZG70Fdt2J+6HUol69x11fEN2M9DxrKbgJI3EgXGJfl3vSohTzGhVwPIWaW1f/dQvTP5YrneQOxg8OaQSyNqLXg+SPBknuA0YkKSgcCqbtuQRl0psUlRhtsA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HNQek1N9; arc=fail smtp.client-ip=52.101.46.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HNQek1N9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbAWQOmkw4ZG8ChxgAGSz34PTptZ0MgHoGa8vJNdwgbD+799JBd17gMor08kRbG6svoetlZmZ80BTTAR6FX7n3jA3jtIvPPk3CyRt3t5avQvIsoPs/XGI9j9QlrhDVzQKgqf8Etq3Kha6ZH3EqV0OmpnA3UIySmOMHlj9rJ2QXuXf9vOuhOzjEFC2j8oUF0yyFQVtj0Lmt4kK8k5tb0wb5mHdw9yWrogy220AtQO9AVKkknxGCJZ1everuJ+kY3YK1T5Qd/36mPvXk42HBxzlLuR9WjFAySRWCZslOPHLVMUDFUVPJ/kJmQFecM7Z6iTumCQI7oy/bPadpikat2//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIKaHiT+vl/C/jjTqlktnodzpGJ8waRz2zBONlUkpfA=;
 b=H1CWdM5dKwSnIXjeugto6LY811OYigbo7lEpYJTfZNS19gaHMQoh048D3faUVNHVYKL2n/nDl7iyJJxQjxems15yckJ+5pcDUrq12oSluIHyVKwKiGcFgXmavgcwPDy+pLflx6LFuNTELouSdsZcmnVs5sTU0Q2OCeWZvJilfOiaGAfNj4XjmPAJeawrBqQQcOUDnI95H42jGB7UTJYOvEcY2ZNpUazeZGYkbXRPJUFaEeklCgJL975moFOLZV1GqJIUCD/Kj7GhKRIeqyo0ggLrCo7MNM++ts4MYSbn0kWqUHRW1yg/HbFAyP5Lv2in+r+qzMmikzghSULNHLPSEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIKaHiT+vl/C/jjTqlktnodzpGJ8waRz2zBONlUkpfA=;
 b=HNQek1N9qqgAEDhmp53OupHNfdRiZVSmguB6S01BKKuaoONundgGA4ff/ZmrspiBgPUKGN//XnTSSHyjxzqv8zTyEPDJ7VeG2MtTdvuNlFa+an2RoeBqUo9pNDULvRSHPjy0jcApTr6pAHb7adgkYAMhaE2aIquwIl451B7Cug1fGtE+k1pBhGM3BIDFS50mlmxAdeUQ8PISToWEz5BNCKac9KBg8Q8eQAVOmmPgXPLyfIjd2HximrY//RfzB2uFXXckBYTC4Gjum9v69JGmVytfFWunaYWi4WRsfr9Ouse0yW+ooSo8D5Y5KvDUB0FwQ7IIjKpxDNUf7KXFn2z17A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by SACPR12MB056849.namprd12.prod.outlook.com (2603:10b6:806:543::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.18; Sat, 10 Oct
 2026 14:00:47 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.019; Sat, 10 Oct 2026
 14:00:47 +0000
Message-ID: <59e1612d-f9f7-4f1d-a050-a6da8aa63ec0@nvidia.com>
Date: Sat, 10 Oct 2026 16:00:40 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net-next 08/10] net/mlx5e: Recreate netdev channels on
 data direct device unbind
To: Mina Almasry <almasrymina@google.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Yue Haibing <yuehaibing@huawei.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <20261008132815.654147-9-tariqt@nvidia.com>
 <20261009235615.3825992-1-almasrymina@google.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261009235615.3825992-1-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::7) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|SACPR12MB056849:EE_
X-MS-Office365-Filtering-Correlation-Id: 7afc5b7e-e39d-4c51-0e2f-08df26d6e23a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|261009223027099003|56012099006|4143699003|5023799004|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	pKQFhFDnZjfD+rNUOwNvPNCM2RGCQBH908pjusAruM1sCdVui6LLsb2QIgO1RLt25ANrlg0XulXemYZbiRLq65F1E8GRzhw5Qd4jkPqBavBpJhXpC4ZMbpVhiOyDVpmowCyDF2rSF1KavcJLP5b2ASxMjeaJ7BftvHZ4R8z6Gn9tBUJIMkMuCFwNaXtyQHtGc9XJRSfWodJrsQeNbtl97btb7th2oxKJCgLnNErlMOBYSjmDOiwFrAg+SNMBobtvzK/wUjh2rnqtlEQxdMOZl09EROOTBLfYWeno/NdVybtby7+EvuhewavMd2gEcKTCplEfSPYt4puLzOxDdd1ZZqB1wCKfilFRjD4SuhaPVMl5jovsxw71bWnO3f17wJa/mG6c11NJrlJvnwYOKh2i4QKDjsguJ8TtUjvsCXN06kMMf75EZqDKIijipna0+YcdRfaZiaj0ytm9ceC3N7Di0nTMNDtgCZRI2dR4+9Wr3agZMsHuHACW/0wunjZi/sE+HBweS12awVW9G46aNuy+4CBN+Tys7gel+gzkZhWrjLd0OPIPL2IrzLxnsyo5wGYbg4WtHhMxENUqXiF9OLUho1OPQ1O4Yb0yhrlfNbDcDu+F1LvD/6nmV7YbVhms8JUenZBqoQomyGtcpCCVodbV2yFfcdo6cO3TR5j33hB7VOU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(261009223027099003)(56012099006)(4143699003)(5023799004)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXlQZXgxS2lCNmovVGNEMnUzbGJYamI3N21kbUpXM0M1cHRTZSsvRDBCRnpB?=
 =?utf-8?B?MytBSW5wTkNEUnB1Y29aaHQ2RGxmSjBRV0Z1aEsybDFpak9iS2ZlWk9nZGxZ?=
 =?utf-8?B?WEIvMG1VSmRVR29Md2VxY3BPRkIzUGhBUWxZWTBuU0ErcUFrM094MEhLc3FE?=
 =?utf-8?B?Qm1ycHVhMW1paUFlOFMxbE5XOExBU3JWeGpBeFZGaVI0SFBTNVVLR0ZXWEth?=
 =?utf-8?B?cC95VHB4OWtCeGxYdmdTMlE4VXVWd0Jsd2tBdlBvaEcydXJUeDBNdVh4MEFE?=
 =?utf-8?B?NUlRSXhLWGpYcWpMVlFObW1iSlEwRTV2MVpTeXZLN1RWQTcweHBxTFA2d1NU?=
 =?utf-8?B?RmRJSFBKVk5VaDU0MDNMQjU3emNRdWlRUmVIS0p1ZjR3eEs3UW1jZ0tMcU5j?=
 =?utf-8?B?bUFGRG8yNWNtN1VKUThtWkJXblRYM0xDU1BwNG14NFlxZjJRYjdyTS9qV3Vn?=
 =?utf-8?B?RkdmVlZoU3JiUGs3a1cxWFltT0ZaV1RZVnBZMGFVODdEU2FoTnNMb0RlUlE3?=
 =?utf-8?B?eG0xR1lCL0pOWCtSa3QwUis4bHdkdkM5SFljNFZCdHNXbW4zTmdFbWdZd1Bs?=
 =?utf-8?B?KzUzVVg1cW02OXJkV3l5bGJVSFliRmEwenB4Z3hUc2ZRQmlCd1NhTExCVmhm?=
 =?utf-8?B?VHR1TnFDU1c5Yy9QSjNpdS9TTERZa0hxTkxUeHlOSXhtZ1BvYmx3NXN4MkJi?=
 =?utf-8?B?MmlSVHB2VXdiQXJwYzY1NUVvMWUwOFgyb1kzbytnSUZwblB2Y0RuWEpDYURr?=
 =?utf-8?B?Tnl0Y2N0K2M4bFdvaXR1TzY5blFkUEZQbnRvNUhKdEZKM2NDN2FFV29ua1Vk?=
 =?utf-8?B?NUdDZjlUSk1MamZDeU1uYml0Z2ZWMVUwOGpualNia2U3UXZ4RGJpTnhWSWV0?=
 =?utf-8?B?NXM0UnM3VGZtYTMxU2hRUExFZ3YzMTM2VmJiZk9DUkJtampSbHZybm93L2Fx?=
 =?utf-8?B?aWxoU2oySThGUzlzc3FIVWNLR29SUjN6K0RNUTErcC9la0VMVTZJa3dFKzl0?=
 =?utf-8?B?a0dGUmZhOG45RmtJMkpxY1FaTDQ5cTg1eTVCTWZ1emJjWUt3R0k1UUEzZ0Jr?=
 =?utf-8?B?S1RUdTlNdDhaL0NmRGoxalNVTEJWN2RQR1JCbmJWL0NlK2M0emRQdFhJOC9k?=
 =?utf-8?B?MDcwRnNRQW5pd1MrNU1WczZpazUvNTNWb0RscG1sbkMxUCswQzRZZFdheWxK?=
 =?utf-8?B?NTZPYituWUY2d1l5d0lBUzVCbEduQWZIVUQvUkd0MncvL0J4eUwrR0h0ZkhJ?=
 =?utf-8?B?WGdFWjNDUTZkeWRBbk50WDNKL2VIRldzZjJEZi9tZU5ibjhWSnZvZlZEYTdJ?=
 =?utf-8?B?b3ZNVlFub3FDQU43UGxpamduM3EzNURWVlpleVk4NUZKWVBhMTh6bVpqQzFI?=
 =?utf-8?B?RFdnWGFzTnJIaEpiWjh6Y2FjWm8ya0VvaVVsSmlKZ0lBUGFMU0FYMzhkaFhh?=
 =?utf-8?B?NlV6ZnJ5Q3BMRGowSld0L2VJUWlpdEJHb1RUWnRtRW0vL1h0a3JEQzZpZ0du?=
 =?utf-8?B?VS84S09LWGFzQjRPMjFONjFzNHF4VUdBRWN1WjdUS0lLOW5wMURLNzNGZ2hr?=
 =?utf-8?B?RDVIYXJ1Y2ozbGp0R1RCMlB0T3BIOXQram8vZkNLRCtTYklydkJSc3BhRHJi?=
 =?utf-8?B?eUQvdzBFeEYrbGhGUUZkcjc2ZjZsRWoyY0I4d0lXazltR2NwWndnN0tub21S?=
 =?utf-8?B?bStla1l5Tk0wVSs4UEtIenNpQkNvWk1EdklGR0JiSzVXdzFUMG5LbGxPSjJB?=
 =?utf-8?B?ZFFEblRFK0Z0NU1BY2RVNDdqcmRPK3M1UzBVd3l6RXc2SVdUb0Q1SkQweCth?=
 =?utf-8?B?eWYra1ZIdHN6VFZoOXBBWUtTVDdLVTl3M0M3UlU0Zko3blc5UGJJR00zWkM4?=
 =?utf-8?B?andYUlVIWXhuaHEreTVpUU12MUx2V1dyNzdlWEc3ZTNWbVo1eDJLSlBYSzR5?=
 =?utf-8?B?RmVyZWUySU1oNk9vUUxLVWk2T0M4NnlxOVl2RmZ2WTZBUExIUUNwQ25hZHZo?=
 =?utf-8?B?b2ttQ0RCRWhjUlRHUHhhOGJ5a3Q4M1lTRG1DTkY5ak4xS3dwSjRDUU9aRGZn?=
 =?utf-8?B?U1pmQUtEekZObnB0eU42M1JRb2FFQ3hjaXhNL1RScGlBUGxRWEtZSTdVOTQ2?=
 =?utf-8?B?aHZvbk0vYTMvQzdJaDg2cUJsUmFjOFBzODl1enlkbmpXUFpTTCtTRGY3RWVu?=
 =?utf-8?B?d0JNQUR1YkVQZlhhK2dtREpmYTZOZE1hWm44SGlKTG8yMWlKWTUxdUxzNi9X?=
 =?utf-8?B?cHVVZ3BLdU52V0s5QkF1QVJlREp0K3kzOUNyYVFLS1V6aWVRc0d6ZkFiUmNt?=
 =?utf-8?B?Ynl0WHNHWHAyWThRbHVJVENBOGVsR2N6b0NVcnJHczBzbHZueDJ1dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afc5b7e-e39d-4c51-0e2f-08df26d6e23a
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 14:00:47.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: df/s4Ui9OycwADtec/BwoSCSlMVhp2F6YT2sf7TBAvnynaaG28I8U5CNKhrYHADSZokr0nKbhktWsv298onvwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SACPR12MB056849



On 10.10.26 01:56, Mina Almasry wrote:
> On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
>> From: Dragos Tatulea <dtatulea@nvidia.com>
>>
>> Note that this does not tear down dmabuf bindings attached to the data
>> direct device; the recreated channels will still pick up the binding via
>> rxq->mp_params and post DMA addresses from the data direct IOMMU domain
>> to the PF, causing IOMMU faults. A devmem revoke hook is needed to close
>> those bindings before the switch.
> 
> (Note: LLM-assisted review comment below.)
> 
> Rather than shipping this known IOMMU fault window on MLX5_DATA_DIRECT_UNBIND,
> could we add the core detach helper in patch 09/10 and invoke it here under
> netdev_lock(priv->netdev) before mlx5e_safe_switch_params()?
> 
> Specifically, reopening channels on the PF without detaching active bindings
> leaves three issues:
> 1. RX: reopened queues pick up stale rxq->mp_params and post data_direct IOVAs
>    onto ch->pdev.
> 2. TX: active TX bindings (net_devmem_dmabuf_bindings) and in-flight or
>    retransmitted skbs still hold data_direct IOVAs while mlx5e_xmit() switches
>    to sq->mkey_be (ch->pdev).
> 3. DMA unmap ordering: binding->sgt / binding->attachment stay mapped to
>    &dd_dev->pdev->dev until userspace closes all sockets, after
>    mlx5_data_direct_remove() has already returned.
> 
> If mlx5e_data_direct_event() calls a core helper such as
> netdev_unbind_dmabuf_dma_dev(priv->netdev, &dd_dev->pdev->dev) before
> mlx5e_safe_switch_params():
> - netif_mp_close_rxq() clears rxq->mp_params so reopened channels use host
>   page_pool pages on ch->pdev.
> - Clearing WRITE_ONCE(binding->dev, NULL) + synchronize_net() causes existing
>   validate_xmit_unreadable_skb() (READ_ONCE(binding->dev) != dev) to drop any
>   in-flight/retransmitted TX skbs automatically with zero driver fast-path
>   changes.
> - dma_buf_unmap_attachment_unlocked() + dma_buf_detach() complete synchronously
>   before mlx5_data_direct_remove() finishes.
> 
My plan was to address this after this series is accepted.

Thanks,
Dragos
