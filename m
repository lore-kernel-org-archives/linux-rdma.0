Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F3331A57;
	Wed,  5 Aug 2026 06:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785912612; cv=fail; b=Hrq9pUJDArGofNbuVA3WeaGvxYqU3+iXC1CmQcH8kNSzgsktKi0j8sLCFNAcPRXU+JYf9Me96qEqZ1oveSvKJb5Xc6pfl3kwCEpK26iSQ69Vs0+daWJBuuN/iWS8UV3DF6IuuijjbUdeDQBB7uE+ot6YlhvmzlbO+BxZErSY65s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785912612; c=relaxed/simple;
	bh=MN2kJi5o1r50E4NvAamS985lMZoW3616WBBYmRdGupc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=stQz6OC4e1djoSWXtFiPNWUUU57fGtDM3iqXRM8RbusuzEuGCccx5C2mPLbCmwpsZ5/TEs5hfSFzySwdPvSZXN2vGO8eX/9xkM97ly5zxS80XuN37tXdgQBLV6YpfwbpqIe6COsq+XpE8VDK5+SYYNZrxXv/UFF0TPXWKuPoJYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HzeBlX7u; arc=fail smtp.client-ip=40.107.200.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HzeBlX7u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPTc9tUnGRY1zs2SKtBXzN3UhZrwcabcuYUts4Tct4XQbDjaIgzIxkBjRXx3J7psG8AnqrRHsH59GriyFYxo1YuTpGKg4EUANjM7iOg4nIYFyrREqK8LCEXYdLyMKuW8qRlsAazQW47ndQOWf1hZresXgu/8tjbwHPnsPpHRCeI144liYOs62tqD9h09YNurFY3ts0f639+6cs7+8nX89GrHLH8dE0USiFhiofzqUXLESOkM0ZT5nTuG2THTanUOb+W1iNNTnvhvtIhys5BZ+V8RYz8Arv58TFtLaWAEDgX5dgnPDFcJPCp7DWYUBi8LzAa8BxZF4Kw0isjE/eP5mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9t/Ka6TcLDwq8A97156+S/NOHzIUVpS2+yqyDBLCCqA=;
 b=Sp+E1b/jxzsRKTRgQV1yxwmAjcA3KEnCY6QNOSprmun7wnpPSY6M8gAxx9okQd+Z3Islylo4Ck5eDEHTo7JRUwSH+qxu+u2cXDVUVGPZoEorqTV+yGduTKe3uKnUYWJPvTEwcD+XvPN3qK5+Ui/hEwntiWPwKAetrtN2ygPT/4/e9pmai0KCxgzgiFRd4VvhXqyX7l8OxbDTYy/1QWejhJEoS0YtHECaFZCNETUz5SUt5lCy5FHNfUmwlq5MovYUHYgt1yDyASrPglILjLD/h5nSX34XMfEHJKOj2J1rnHlDjbbN/5YMHQa9EsCtBT4waHUiwp21IsitH3QgUbzz/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9t/Ka6TcLDwq8A97156+S/NOHzIUVpS2+yqyDBLCCqA=;
 b=HzeBlX7uKHlIIFxZY0RMUTW10nlBZHYLy4WJVlPjwz5YzvZhQZcCCKzqMwUeRClWxpK5Oe1fMQb/v9IyWuh5Xe/au24GGTmZku+ucFRWSq0fH95vT68XMk/6n/LR0IFdsF7fV7YajmDAC2RFYLnDidaQW9AUQonDRCCyGoJYlSOmx6wh5RVcEz/XHVL0U8yrs24ffbQTU8lWywU7UdkeDRcbP4V/JlPfnW6KA2tSHn0t4WfpxFJZBuxiF/nwerDetajxYRqVqkCeUeiQMOuCbM/oK8qvK7lnaYweEpcY5d/UDQhNdVXX9Fq5JMFew0D3gktVva1fz7V9Din/Ag6DUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 06:50:05 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 06:50:04 +0000
Message-ID: <7a4af8c9-b5d0-4354-9eb3-8b9ddeafa103@nvidia.com>
Date: Wed, 5 Aug 2026 09:49:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: SHAMPO, Fix IP length overflow on large HW
 GRO sessions
To: Tianyu Zuo <cosmosocket@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Khalid Manaa <khalidm@nvidia.com>, Ben Ben-Ishay <benishay@nvidia.com>
Cc: dtatulea@nvidia.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260729204745.166584-1-cosmosocket@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260729204745.166584-1-cosmosocket@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::14) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: 36386571-358e-4afa-ec95-08def2bdc6e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|5023799004|11063799006|10067099003|6133799003|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	0YN77HY8SIuTd5aEwGK+DKTMunG3s8XW+qY6R3sNvzUEKcKysmQ5jZEyH7eEvmlqqofB1WDMy77vGt7EHildBCTZaB1j5LHx9hDIMsqtohNEzQ6C5zchR/wcURYkjkvVPVz5L/gHc9DbuKk4b8qGP6eFqhcRke/Ae6mkWI2bkB6sPg5C6DaV9Vw3X1wp/XAm1vFBRarM81W+V3Fld0YG8px2Fbin9JCYCSUKGFcJan1wZrApJpLv1FBPE1X5tAodxh0genO/19YuN75rd7fj8ubWLECBBXS/jTQ2b0wYTJ8j9kawNB/qv21gIb/j8TbQ91P9xPT58qmJqB3nqy4sQT0VygNA5bk393bidu/0XDNPLj/atlwQoL3n6DRPoBEPmbnXxHe6mv83b5sOVDCr0pXjlRzmm8DxWIr2AtQxSQNbpCkuw6VTgcMhP8D4tOHZ2k58ZzPPY8r9YKykrAntai7zG16RxIdXo6P+ajJlC4qvfaexlUi3KV0phlHY+5aQ3Gg9bHqP/sW1FkKsSL51dNdPIYh9d531s03TI/RMrFXzekhDlY0P+dJY9cmBLVnOr2LXTMslOp/CLMH96qMC6BU7Mz7aEb9SYZwkqfVHNEUb+vMjf9nPGnIT5SNAjHxz0Zm/o7OKc1Way5yPaA1LT60bDq4VwJcgRCJVTNoWhB0WWdexKG/UHwKUwa2ESzUCyiPdV2JcvL4e6evWXHthfg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(5023799004)(11063799006)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1JPSzVSUmI0a2RUczZIbS9nU2NFZGFHWmI4aUJwVDdFWjZrMmZVNXNsS2V6?=
 =?utf-8?B?ZXo1MTg5TTVQM3IzaGMxT0R2cGVxcWZzYUxyQVYraDUzVHV5dW1EcVRGM01D?=
 =?utf-8?B?RU54cVNVcVpBQlcrYXlKVGFOMFlYS1FsT1BlRUo0TTBCZHNNRjhvTk45VFRJ?=
 =?utf-8?B?a2tHY3Y5TFNvanhlRWR2OVVpeVlHSUNKY09LVmFac3VsYXNqLyticUpZRmhN?=
 =?utf-8?B?T25yeGx1T1NzVW9vd05YRm1oc0Y5ZldTYUpQOWRRaE5JSjhzSHVibStqTjgy?=
 =?utf-8?B?YXJlT05DVEk3MG1TSEJOMXFNZ0lsVU1ZZUpTSTd1T0FTcGVIU3pUbVBWLysy?=
 =?utf-8?B?WUNpMGxXcGlaNFF3bFBkUnp2aE9SaDA0aTJwaFpEWXd4V1JOQnpCaFg1ZUYx?=
 =?utf-8?B?RGZ5Ti9XLzc2dUNVcUdDQnlQR1pib0J6VFQxN0xJMWdsQ0tpc3NUVkVzdWpI?=
 =?utf-8?B?V091QVB5UE9WZnQwcENMeU1GdlVMa2V4U0FuclA5Y2F1NnJPdmJhLzMzUFBq?=
 =?utf-8?B?Q2Q0Yytaam9jMXA0K2tXdnZNTjJpcGJRN0lpMHF4SGs5LzZJdlFqN2xtOWdh?=
 =?utf-8?B?d3J5cDg4SGhiaHRVb2hFc1M1WklHSmticjBEbmhUcC80YlVUcWM4UHJjRXha?=
 =?utf-8?B?WWhIVFpiNDhHTTdObms4MlBZNWIzS0RrVlo4S2U4NkxuZjRCT2JIaDBGQ1ZZ?=
 =?utf-8?B?YlBpN2xPdy9NNGxYbWFkbjkxdVQrOWhxeE9PZTJRRkpuVzd3bkhxRFNLUVhJ?=
 =?utf-8?B?b2N6eHA4cWVrOStBZVdXTzZMTUdMdStQTmFSMnFrbm9oUnd2bDFjUE8xTGJF?=
 =?utf-8?B?dXhyV2ZjRkgrbS9vYnJIOHlaRDlxNTF5bVVnVjVOWFU0bmZDUkQxQnoxNExt?=
 =?utf-8?B?OGg4aExCdkY2Zlc2V01oYXJTM25kZ3lmMkRMSjFYbVQ4ZWJWQnVMQkIvUktZ?=
 =?utf-8?B?d1JaMTZVNElWakF1aUtmdC9JeHNqaHQ3bkR0c0NoZklyV2JsU0NOWmdERG5D?=
 =?utf-8?B?U3NTbVhGRm4rZWNPOC9uazRLaVd5aDV2clNCa1VmdTVUNDV2cGFqTVhDSFNN?=
 =?utf-8?B?V3U3Q3pncHZSM2tidFhLYmtJa29yZ3U1bkN2SXRSK1pUdE1tYzJkZWZ3a08y?=
 =?utf-8?B?UHpqZGpXdFIwTXo4QjN2Tm96clVYR0cvNFdpODhRSXZ1LzFkZkhIYWJpY0J4?=
 =?utf-8?B?SnBoZmxqVkxuS3M2WW9Va0lCQlA5SEM0dEdRKzg2eG53bzFKR2hLa3VNMFFO?=
 =?utf-8?B?V1A4VkxZNmhMUE8rSmZPRjFic0xCTFI5aEdCK3JVc1Z1bWhGaDhHUVJpSGlK?=
 =?utf-8?B?b2xqdU1QdVlnNitOOE1IZG04cmM1cDZOUzM0aVduVGpweHhKK1NiQnptenpz?=
 =?utf-8?B?SnhQWXoxNDM0QXFQT01iaTZjYUF0aEg5S0pzajNoS1RLN1hML29RUE1QeC9F?=
 =?utf-8?B?Zkx2NWZSbHhYNkd3UVdOUlorWUdKMThDTk1QVXEwVnN5WUdwSUVkTm9XWXhK?=
 =?utf-8?B?M1ZHMXZraDJKVkNLOEJucmhBWmw4aU9JT28zWUl1U2RsMWs5TnF0NE9YYkp6?=
 =?utf-8?B?eVNrN0srekQrMWpNUnhmNGtCRXpBcnN1WWJQblgyc0tDd1BkUUpibGUwbG9K?=
 =?utf-8?B?MjdXeG9EZ0pLNUVEZHpIVU9qanFKK3RFV3QrbHFIVkpuUlpEcnFCRDZDVnIx?=
 =?utf-8?B?bjc5TmRlbUt4UzVyTnlYaFd4Z0NueGNkLzhyRHlaSHMxYUs3dWNSVkMrNjNH?=
 =?utf-8?B?Q0VwN01ldEpVUG1sUTRTakZjU0ZyWHZ5bUFIaHZEbGJPdlZ5UnIvaFhGcUJ5?=
 =?utf-8?B?UWlVcU5aZDZPTDZwSEN3NUg5RFhVb1BRdlhsc1ZtMStXQ242cVRobjRVYVVp?=
 =?utf-8?B?SWIrbHVUbFV0eTNQYkdwMFBWakxaZjloYU5MWjZoRUdtOHRoMjVwNmx0N2t3?=
 =?utf-8?B?Vy8xWVROT3FoY25xTmU1d1ZPYlhZNEE4MnRObGZHTm1vWmEzRkVmQnR2eGd1?=
 =?utf-8?B?Y0RGL2hlenc2VGhBdVdlZm1kZjR3cEVTTTc4WjF3TnQyM3luaXQveVNkZzIy?=
 =?utf-8?B?dTh4N29qZXZ2WkIvY1NIYWRLQnhCQmRuNUo3RE9DYUFvVUJNdzNnYWFJOEdh?=
 =?utf-8?B?T2EvWGhORGlhN1BtdUEvMTZZbi9BVHI0b1Y5YWQxaWErTDBPQ1kvVjM3aFNJ?=
 =?utf-8?B?bDFldGdkUTZLS054S29Ub3NYTnduK2dmSUdsUEFsMDBwUnhaaVgveUE1RzRN?=
 =?utf-8?B?N2ptSjRkcHNESHRtRTVnZFpkbEhMWTBjdW1UNjNXSXFRT3N0dWJIZkxnZ2ty?=
 =?utf-8?Q?V6RecXCuk3CYNsk+h/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36386571-358e-4afa-ec95-08def2bdc6e2
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:50:03.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzJvgixl9EgcIrhGYdzgYN1vsSD8R/tbxYy9r4geEmJpG1j87Cw0m9xoeXMwHAGtMcI981OJi08qUjWz//jfmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470



On 29/07/2026 23:47, Tianyu Zuo wrote:
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
> With nhoff == 0 this stores tot_len = 40 and updates the header checksum
> to match, so the corruption is self-consistent. The GRO stack does not
> repair it: the header is written before napi_gro_receive(), and
> inet_gro_complete() only runs for skbs that the GRO engine holds on its
> gro_list. HW GRO sessions are typically flushed on TCP_FLAG_PSH, which
> makes tcp_gro_receive() set NAPI_GRO_CB(skb)->flush, so dev_gro_receive()
> hands the skb over via GRO_NORMAL and the gro_complete() callbacks are
> never invoked. The length check in inet_gro_receive() cannot catch it
> either, since tot_len and skb_gro_len() are compared modulo 64K.
> 
> ip_rcv_core() then trims the 64KB skb down to the wrapped tot_len,
> silently dropping the payload. The IPv6 path wraps identically in
> ipv6hdr->payload_len.
> 
> Triggering this requires the payload of the aggregated session to reach
> GRO_LEGACY_MAX_SIZE with every fragment fully populated, since
> page_size * nr_frags otherwise overestimates the data actually present
> and the session is flushed earlier. In practice this needs an MSS that
> is a multiple of the page size (for example 8192 on a 4K page host with
> jumbo frames) together with a page aligned start of the session.
> 
> Account for skb_headlen() and make both checks strictly less than
> GRO_LEGACY_MAX_SIZE so that skb->len can never exceed 65535.
> 
> The check is strictly more conservative than before, so the implicit
> bound on the fragment count is preserved: page_size * nr_frags +
> data_bcnt <= 65535 gives nr_frags + data_bcnt / page_size <=
> 65536 / page_size - 1, and a single CQE adds at most
> data_bcnt / page_size + 1 fragments, for a total of at most
> 65536 / page_size (16 on 4K pages), well below MAX_SKB_FRAGS.
> 
> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Signed-off-by: Tianyu Zuo <cosmosocket@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6fbc0441c4b8..2e9676305439 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2222,9 +2222,10 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
>   	int nr_frags = skb_shinfo(skb)->nr_frags;
>   
>   	if (page_size >= GRO_LEGACY_MAX_SIZE)
> -		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb->len + data_bcnt < GRO_LEGACY_MAX_SIZE;

Please add a sentence in commit message covering this branch as well.

>   	else
> -		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb_headlen(skb) + page_size * nr_frags + data_bcnt <
> +			GRO_LEGACY_MAX_SIZE;
>   }
>   
>   static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
> 
> base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4

