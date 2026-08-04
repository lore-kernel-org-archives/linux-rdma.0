Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A93E558E;
	Tue,  4 Aug 2026 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831847; cv=fail; b=Yi8tgdiVEXIhoalF6KCbeqBZeWf6ueD2A/YIsYvAh8TBXk6uizmdDiVlk/n7ujT+fUoxxTBs2Arf2SBKr0zuWNqKgUGEt5tPYeVqHrYQQV6PorLUEk2z5RaYQXGFmNbMvGFoRKUGUAF0lo3CbAEh6eQafmW0C3sHjvdGVpXeOzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831847; c=relaxed/simple;
	bh=5kI31accWe/8EyL/sAnoolMwvxfUGIQQk8SgwMgSYkc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sgLx59li4tnXILQ6M9BYuf1A0s/dEq8A0ip0vevbuiZ73gTaB7xJlQZX3hBKCD/ju45Bfp4Xs4mm9KGD4fsFIzhYCFY+w8DkSoJAgs6P1JpUF8wNyUJxxeC/7BeyAmbWeVXpqmxk2IgkATNB7gLvHSCCEpM3KxzK4DBAPnffOPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IAKqjala; arc=fail smtp.client-ip=52.101.46.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IAKqjala"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZHi/6/ZcKc7ueXbs6LpxOGfNb5EguMK68Vv7YYENYkW2Lx1gpbldU2Pf8OleVm7dJBJ+hcaSgKneflRg6v48zyQnrok29bO463N6XPOSM9vpMgRdL1O+q1dQZe2qW6HYqePEpmUrfwSePz3LAz8P2wHq8HI3ojcU95zPCw8jEOCKfj2svNtBxEhzQ/oRlqybd7QhinY4ICHaXw/aVI6XzpxMtJOXNlIHV1okjUGejnAPM1ra+Ogu6KsIweOrwVZKEpj9T6bLDDT4/tUEiYcdNuLtlGLVFrkhkDii4ycXYoR2uACJ42IcupQBzedj9f5/bFpDtuUN249NgCL+n3FDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvdrmateK7pio8Cr3bWXjEv634ZNsIViiPMZOD4NQbQ=;
 b=tZLYQRB3xCzWumdTY/j9/So0dQcoBZHWx7VY88SCW3TrJBJVK4HRwhwsJ16zgmvsQ79aPJQPLGPBCL15KUdbA1Phbm1CXvnG8mtKZAc4ox9nsfens6HuJv7uqkwI68hDIigPZz849S5oJTJG2qoAU+tpfHPe65fDqawRqgGUa+vp2vdbDwBsDq9++nxt7HS1C5w8nvmad7pAp991YWFr0b6R+NwE57Qgsbv247xv6gpMIUyd1zmmRcgRV0N9m7+0eN3+BChJjdUgWDhgm+ybUe7eYom1M7BuBtDFnRA1G5+suQQUDj59Q+Wc/y8zjrzHrLqVve8S4gE663K4uKMNww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvdrmateK7pio8Cr3bWXjEv634ZNsIViiPMZOD4NQbQ=;
 b=IAKqjalaS1MDHubYuy4HzqGITKxMrjK1XbrXst2Et5nEtxvWSQpTkBSj3q9Z2yuoP3fExRbVrA/5saQ441/MsLE71NPK/zvUdugpy2kqb/p3txld4BMFQLVpnt17G0uOrvD5GFkQMwKR87myzzLjtFWW5Po2cMk8hbOmaKZCZ2By5R6UvEqT0tCAXYs9Pep3UTUq56FyhKABVEQa4efY9111a3gev0rjnM2ii1IFdUf9MlIV9C2ZwKih4y6PWKrAWQZVaEmh4XDXVjF4eRULR/bxhQywCQhPw0BxLm9a3qZAps+1dcXkQ9MxSfdN7XbU8pV0ZvHvfIY/IjFnebUteQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 08:24:00 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 08:24:00 +0000
Message-ID: <6ac643bf-c6f4-4ff2-ba57-964a645d9323@nvidia.com>
Date: Tue, 4 Aug 2026 11:23:53 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] net/mlx5e: fix BQL reset on SQ re-activation
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
References: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::8) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e4d46f-a7bb-4848-0f2b-08def201bc13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|921020|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	RxlNr5mNDnTAagQvMcN3RH3u7gFkc6UrHaVRiaK2NB6HSQiPQzPFPmYwjxepbTr0C83VG7cJuwbo2+JkByw0VK5conbYg4K/v6Tb/+YFXuYwdsTiGTbFvGwt9GawCRTapj7dEFZecvBNzNhc/ZFWr0rYJGy37mDOtnm63ybZpIG1B2Mg9ceB7gF+hinyUjvaOwadwjP2TH/JShH8Gj7j5rs6aNWh2m2w19YMZwGYyhbxW0VfTx251wnOR/YtDZDhx6vGq2UB1jISh3y6yjuH/uu1nhHb2sXJmxT+uQjUYdeiA8DAfELzvUjsejVZZGUFXdVxS+kEFlbBnnTwsNlo8ZLK/s8q0/aC4+XdpcSWiImRq5kMrwEmTce2IeCIotK7L8HUcklVSti9vvUpcrTlWrwmxg7xco+EzNFnrYaoYXsPHt/DxuFJbjSpmSpfV6jsJfWJIM+dCOhooxMhjfrabKxQxFapCGBATA0Q3Bupy9mMAN05DknKa8MprRFqzhqOrV5d44hIcof09McCXiNiOuCsSTTBzdvadPizfdsYi7O+urrgKg8BtFGP0kkzybUrM7mXuPX4+XTL/R0I2mx0xr/2uh4/lWMBXiul7ZukiYvLPcCenQURrVtTnUJ78S6o6Jt15YdpSvGcUOQ8ZFu4Tcz41F7Kkxvgt3rOgEV34PHL9O8E8abznlcob8frsR4Jr7vWOBuXUR+n0fk+MZYDjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(921020)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZG1UVUhRdUd5R3RNZzFCcmN1S3QvTmMxWWV2RmJGM2xMNElLeDhTcSthNjQ2?=
 =?utf-8?B?U2d3emVDU0tLd0ltY0lNUlJrN1dUbUZsMW53aDU5WWlvc1AzVFRHNlphK3I4?=
 =?utf-8?B?QW9JdGFSdUdER3lNdE5tbjU3dmtQTDQrZXgxTWZvNk5JWXdLaHJIWi9CWTZP?=
 =?utf-8?B?VWZ6M0V5VjB2TngvejBhU285UXZjOTZPcnJMZWl0dElKZW9tdDRnY3JCRHpS?=
 =?utf-8?B?eVBjOVFtS3NhVHQ3UG1OcUJuVFRLa1JydGszMFVNT2RwMlVSbHIvdW1RK0Yr?=
 =?utf-8?B?MzduOHNqWHNRRStMK2I3Y3orOEQ0K0R5WHc4MjNRVDdxaWdjUmNkN3dlSDBq?=
 =?utf-8?B?OWtNVVRMUUNBMjgwaWNGN0FtOWNiRzRxYXZjdlhEaDVwWGpKTHUyM045aldp?=
 =?utf-8?B?cTdpdVNpQTNCUmVha0FHdHVuTDdTdXMvSzNFaEYxcU4wK3NEalh4RkFpRHZL?=
 =?utf-8?B?cFAvQjY3dlQvdzRyR1ZxVHVTdDBOWGhPRTNPV004aXMyZEtjT3czQTdPRnV1?=
 =?utf-8?B?WW9BODNPOU5zQVovSW9QTmlqMFFid1FKWVdCdWFEdVJiVGZBKzFiNm9oRHRM?=
 =?utf-8?B?VUJzZEhYa29aUTl5bW1TdU91d3FsK1RQeEo1YitLcHlFNVI4bTYvSDM2c2Rz?=
 =?utf-8?B?ckpNZFQwT0JXZnA1UXR6N1JhaFZ6Vjd2OVJjbkVnK2xSRm1Xa2RGK1Qyay9J?=
 =?utf-8?B?dnU2Z201K25sVUlTaU5wM3FxR3o2UCtpdEQrVFd3SEJlSXpaZ3ZtN2dETFlY?=
 =?utf-8?B?NUVNVFg5N3Q3L3ZMcXlhT2RtTmw1elk0TkE3bnJkRHJ6YjhQbGIvaXhnelM0?=
 =?utf-8?B?cnJYSTZqMlRsYWVHNG5yNERPa1VtWExvRDhBcXRGaUtnelNRY2NCL2FZdDVp?=
 =?utf-8?B?NlZ1dkNBMWVGWFNwTkJGWS9TaDFIeCthcXA3RTVDeldQRDRDc0hwWDlFL3h4?=
 =?utf-8?B?R3pBRkpMZDV2cTJsMlJvTXluQ1hlRUVTb0NFZVBMaW4wN3JORTRIbTF2MFgw?=
 =?utf-8?B?OHJTVGUxQXUzUXBGY1htaVRHR0FwcFhreExDM3RXb1RrVDR5ekFlUEcxdENL?=
 =?utf-8?B?SDFhSVVuNkdabUltU1Z6eTE5YzJLQ01zK2Q2RUJoQnFNdFdBTTVWQzJISUZt?=
 =?utf-8?B?OS9tZjcxM3NERlhJYXAybmQ4a0lPdXlKNll2SmJCb3BCemIxaXNPb2VKS3N1?=
 =?utf-8?B?UTBkMnR2aW0wc3lPMCtoYTFGMnlBRUdJa1B4RHFmMkNkSlRZZ3YzM21sSjZm?=
 =?utf-8?B?ekxQcGFhbGpqeWFOY1ppcHBId3RSV3loVFF6RVk3TWYwU05zK1pWakpEMnM4?=
 =?utf-8?B?R0NHalFBYVpqTEg3MFppdGdYVDZNQ3dJVDhQLy9ZL0NJc1BNMEZocm1xeFV6?=
 =?utf-8?B?UEpZcUxSUllpbllybVIzWGErcXk4WmZqTFd3RVJPOS9iVHJpemgvODl1eDlv?=
 =?utf-8?B?M2NtNUJmRUFpQTFmTTl2OEVrY2ZsRlprNExQSTZaTmxhcU42a2xiam80UnhZ?=
 =?utf-8?B?RXJMQjBMU0hqQU1XY0tIcllqWHJ3dVlYelBpRmtpTnQvaEZzYXVjZlpYS0tw?=
 =?utf-8?B?TDRDaVhXcWNJdGJIQzMzZm9HK3ZnMFUrOS9XdFZCeGt4MzVIYUg1VXl4QVJJ?=
 =?utf-8?B?MjlrR3dlL3diTnVOSU5ZREJVR21UWEpHdXNCL1RyeG1lM2oyZlR4c3JFN0g0?=
 =?utf-8?B?ajdxRzAvbnpaNi9LWkZuU3lyOHhWaForZFoyRW9GNE1FVTM1dUUrT0xGUWww?=
 =?utf-8?B?U3FVb1RDUWFDWlNHMWdObUd3eGpnS0lVRzMyOWphR2tpTVc2V3R1M0NINXh4?=
 =?utf-8?B?WVV3MVlnS1FCZGV4b1Y4eG02SWVCT3hVbDBGMlZVeGcxQzRGNC93eHFIelpk?=
 =?utf-8?B?dnkxcnVBbmtWTG9peWlnSy9nbUhOQXdzdFRHQUdBTVhYYmxVTDdaU0dabyto?=
 =?utf-8?B?TE43VkNmeXE3VVF1cWpEUmF1ekN4NmlxYlQ1Zkh0L2M5ZEFBZ3J3TjFoQUJT?=
 =?utf-8?B?WW5GU2thN1I0YzhSbERWTHNCR1dMemNURXQ2aU1aNGZGMEd3NXJsMGdRdDJV?=
 =?utf-8?B?dFlqY013K29WZVZrSUZWUmd2VjA2Um1BNUhqalN6N1loVjZCU2htdENmN1JE?=
 =?utf-8?B?MlVJbkMyT0grYWpCU3ByTm9wRDVtTkh5cStsRXJkbUJtWk1ySzYrWGczeVRh?=
 =?utf-8?B?czF2YTRySUdPNkVYeW5lWUNRbUx0VFN4K0U4MmF1N1lOdEZJMzZDRkJFZ01y?=
 =?utf-8?B?SnZtUzczV3kyREI2OThtbEM0dEdGdVh6MENscVR1ZXhyZUVsbnNZUlZmY2Zs?=
 =?utf-8?B?SFlGazU3MG50ZzQ4b1pVakpLUDNVQjBqYkx6ajdwSS9tK3JQWXBhZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e4d46f-a7bb-4848-0f2b-08def201bc13
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:24:00.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTvZUA8hdRHwM5Wxw6BgxAmLPwKvFuOZFIWy1s2NyGNCDosMEGoLvR/ln/j38ZSI7+H9F8WJWX0eJyg34TpFZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128



On 04/08/2026 2:47, Bobby Eshleman wrote:
> From: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> mlx5e_queue_start() deactivates and re-activates all channels but closes
> only the queue being restarted. mlx5e_activate_txqsq() then
> unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
> of channels that kept their in-flight TX WQEs. The next completion then
> over-charges and trips the BUG_ON() in dql_completed():
> 
>    kernel BUG at lib/dynamic_queue_limits.c:99!
>    RIP: 0010:dql_completed+0x23d/0x280
>    Call Trace:
>     <IRQ>
>     mlx5e_poll_tx_cq+0x668/0xa60
>     mlx5e_napi_poll+0x5b/0x7b0
>     net_rx_action+0x15a/0x580
> 
> Reset BQL only when the SQ has no bytes in flight (sq->cc == sq->pc).
> 
> In the case that reset is skipped, the outstanding WQEs will eventually
> complete and rebalance the dql. The dql->limit is carried across the
> reset.
> 
> Fixes: b2588ea40ec9 ("net/mlx5e: Implement queue mgmt ops and single channel swap")
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.

> ---
> Changes in v3:
> - Sample sq->cc/sq->pc before setting MLX5E_SQ_STATE_ENABLED, so a
>    concurrent mlx5e_poll_tx_cq() cannot un-charge BQL between the check
>    and netdev_tx_reset_queue() (Sashiko:
>    https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com)
> - Link to v2: https://lore.kernel.org/r/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com
> 
> Changes in v2:
> - remove misleading comment (Tariq)
> - Link to v1: https://lore.kernel.org/r/20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 7d47a1da8b6b..f0407a850ea8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1939,8 +1939,10 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
>   void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
>   {
>   	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
> +	/* Reset BQL only when the SQ has no bytes in flight. */
> +	if (sq->cc == sq->pc)
> +		netdev_tx_reset_queue(sq->txq);
>   	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> -	netdev_tx_reset_queue(sq->txq);
>   	netif_tx_start_queue(sq->txq);
>   	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
>   }
> 
> ---
> base-commit: d1000fd7995e51deec872d154e0a40d82f7a539f
> change-id: 20260728-mlx5-bql-84e02a5a46c8
> 
> Best regards,

