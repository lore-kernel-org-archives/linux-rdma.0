Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320151531E8;
	Wed, 29 Jul 2026 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328398; cv=fail; b=Vae+nSK0sQY/W7VxuFJJ0oFj3Wc/6ji0V+R2wmzGOOx9se6zpzmBzUAyvbGshI9zYMhp3o6ZUclGoLu/zCYnMykxdW6ZcmZR1eJs4r3bbNyaKkis2kPhkg0gLk0ZAEr3wstY0m6/975lxu3nvaewjOhsUYNUWivN06p3vAj8lsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328398; c=relaxed/simple;
	bh=LdwrbYCj+mV3mg0Cbv2F0LL28WG2jlqVOVkPGgr6ih0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o+/WV7OJ6KijoaR7z9T1XIh+bQnOKbHSDHq4uNtOOueFcq6Yz4JXcZPCQ+0JBxFIMNGqLxJhJwZB33L4Bt4O0R92XLEo3XpbS9hp0tDe+SMIhplLrwmKnSwvFrGF37qEjSaGoQUIGtEFKQciXZP33UIfll1EOix2O0cqqODZzdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nnxvyzdn; arc=fail smtp.client-ip=40.107.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nnxvyzdn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSvhZ+QuzaHdkWLH4S82ZX0s3be1l97R7Nf+pXcJjKdI6n8SH51q739/DHkdq/LkdTrcedFWOpvCN7sTAwtQ0Smr14Y86nwYMKWCZ5gQ8I8l1Y3HU9JytKy/cbWfwhGBwIbI1u6Ca6/YnJ8DnwqyqQQTuFN5Jh0FdkMzRaaM5UGDk5iKyixhTpE8bazXAAOYoy+wfAmqs2FwfNIokBmZrzLSc+EFG8ZNV1Mg0Pa85Z5uZFQPpxwpsMwi5LNx+O7CIAKGVt2D3YkHEiCKfn+Ka2hgNwCzbMOf7DZM5x+qk+nVMHPssarFZU+L8r4GF+V8i5gS4GP115Ga5GToUChvvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elGiwRabwLYsyaeSoEZUdpCV63CgtnJ2Xu2wBnJEa3Y=;
 b=hZd9S1TCNaWbXbUGyriQuWbKKsYxG5atMr3SJ4ZDTB23jLGOZYKo/JzzCgWcfqC/fj86kBxwJKzyaDQ2VZQSZqaQm6Hippy2EsDrcGlcXECoZGiRqvJFD1a99HK9XcyO4DnQGHV2PMHvFs2oegumwAJ1jgh1/4PekcP4CoCpmSfT9psuvFXyDERrZfgV5SUc66BNhFq+7kPZ6FmO5rVkpQrl8MCz9NJj9bPflyqptpiuxKbRPTwiBdXhQcOKb7SlJQw6JffbmUFD4Pr1GhEr2e4uRgm7h5/otLi86nco1pbs9foE8A1uztvxAUqE4FiekJHb6BfJiy2tcg5/ukJUAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elGiwRabwLYsyaeSoEZUdpCV63CgtnJ2Xu2wBnJEa3Y=;
 b=nnxvyzdnK+iCJvROO+RHqHP2Avnwq56u54pk7mq7jwWa89w1IFaSCr+5VS0pDETuWy3457bx5QyoPKbpa44GaF9HNDU4w0QvjF4bU6Ux4V4BfXXboRO8kb3LymAxLfeqF8wMgsv0mP2AK6g5PRYM+kxN/fo5okb3xcdpVjRGu8bBzROtRckpLUUv+6qtq50izWEZa6br4jx+ImUyOc4rgkUd4tE2GK99Mrk/Ppj5hrZBIyjqMeOe+vM0ATPakqXvKLREzB/23VmvqGjfn4iyRp81kX/e/UDXPPYScCHwuKEagfIwYPB7Do/Zg/U+2UFUhJLizwr1Js+ntLtvAdHueQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by PH7PR12MB5949.namprd12.prod.outlook.com (2603:10b6:510:1d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Wed, 29 Jul
 2026 12:33:03 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0270.012; Wed, 29 Jul 2026
 12:33:03 +0000
Message-ID: <756e9c86-38f3-4a94-833f-afb0559397a3@nvidia.com>
Date: Wed, 29 Jul 2026 15:32:56 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: fix BQL reset on SQ re-activation
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
References: <20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0187.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::9) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|PH7PR12MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 0481eeec-0b2d-4e7c-0b56-08deed6d87c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	Pz13Xew1rNVS50n5QhmYuNqFe0Ii1Y4UIRIyznrLWmNyC1DOBtsQ9YSziOS7yKR3zz96KZTD6h2FOdNSPfRPFGihwoa2ranlRfwI+JWzGB1B5bcvOEr8eUm/ufuAl+8S05y3wl3lVpNlI5aSBiyLwcFXR5RgMH5q5523LyjU95dGoLHrpKo7pr5hLYNBt3ktbvqoqmPYLXMd8rBFqAaVSxsYRQn6V33PIwCte0QpQbS8XYHoepwdw/3+PJHhQz7NgOtEbiCunaXX6eCtj6uQr+X8HB79fAuglokV7YLwCxSq/gIyMA8KGIkheFVZLvhI0IPgr56feXtAxQxgfloagSHnL3lgF9ufSnJjaau0HN1PHtAnClvVJo+2i4TdSbXXq5NDwwyVLIpRlivXmzG3EFFoM1u6GBmN6QW7CcvS2nrjE+gJGTUGPrEVhsuiUyjFfo4FkfbjeQgkz8CENGh3pgGlFPx2yVPYfNvyXQvV/XYd/G6VL6W31/YgPcbSs/u0U5wPhpWuYibb9ovNwqKi7JJE/TLwy5ggJR4n+hLIW739MnbyDBKAO+OktBBJMeXLuaqQkLLXu4q8F7hiIw+Vo1k+tQKlONOcgOfBDDOI0Qv5r3X12x+SL18Lc4H4eZfKd/+mKy4ioFCyV1cqj/ZxduZLC9VaosFwypfqGrV4oZjnqNkhV4PVjdYdvyzmPpXvK3L/v740SrYJRfnQaVPB2A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkJ5SWNhUldSTFc1OExYNytVOXNSK0JlcHBEZjdaRTdHTnZFMW1NUjJBN1NY?=
 =?utf-8?B?NmlaTDE5Ym9pVmw5UlFobDU2Q0djeDVsVStSZ243Tkt3bXVvSmd5bzBCYVp5?=
 =?utf-8?B?WXFqMVRTbjJDalhmbTM1WjdjNUZ6aHFuRjZZbUprbkpHamtPaWdhR0FOWGNz?=
 =?utf-8?B?ZDd0aWI2Uk9jOXhNS21OSmpUeVBnQko5TVh5ZWtVMzZzeUcrSEpTbWxxQk9G?=
 =?utf-8?B?OFY0T0p0YU8zNHJ4RGhHbEpUV1pVTm1ialZqeEFGT09DQWFXZnFSdDluem1Q?=
 =?utf-8?B?WTZ1VmJuOFVQMXliWks4RWhaYytCZlRkbm01bytXeEhyM3FRWEF0U3hYTjhO?=
 =?utf-8?B?QkRlL1VqMkxDQXgvWldPOWVsZHlJS1ozQWowR2RmaTFXWUNacVNtRkErNFJt?=
 =?utf-8?B?U3BqVnEvdzBobDdBTWtYTUp5ZlRCTnI0dmVYcjRwZnZ2RW9Eb2VrL0ZaUnJw?=
 =?utf-8?B?ZUtpb1ozYVdoWm00YzgxNTBDcDR1cm53eVlzVHF6OVZkeE02QmhZbEdUd0lw?=
 =?utf-8?B?OHErMWNRZjNzbGRFUm9LOTR4dGpsTUZsK3FRNW9YK0xBQ1dxY1dXSWJqOEZo?=
 =?utf-8?B?VUY0Z2djSG9RbGxnNHQ3aSs5Sm5hWnJnTFpScHZ6RTZrdzdzRVpra2NuYWZP?=
 =?utf-8?B?YjdCcVRNL01sbm1wNU4vck5wZkJFem5OSTNIVVJKUnAwRG9FS2xxektpaGJp?=
 =?utf-8?B?NFpQMDJBQ0hPTEp1cW9ZVVhMUlJOdHpiTVMzaWxTTjNuVVl6L3pzek9PQ1Qz?=
 =?utf-8?B?cWdOQ3R1Ny9vVmtwZUlsdjNrM0V6OEFhbThKOEdnMDhqaFp0ekx0YTgvd2kv?=
 =?utf-8?B?dG4renhTQkVRUkxUSDB1S0lKcjQyMVlrQmpRRVRxTFdxWjRVR0MvaTl0Y0dJ?=
 =?utf-8?B?ZVR5UzVyTWxtSzExNnZPc3VkMHpPWnQ3OFBEYWZqYXk3Q1BkWU5YeXg0WmVi?=
 =?utf-8?B?aTdlTjNDMUFBZFd4THd1a3lmWCtRazBTaExtSk5PYjVvbnNRWFU5V1NMT3FT?=
 =?utf-8?B?cUx4Uy82bXpNY1BCOC9IZDhwUERXVFlsbkNxOVNXVEpuSUhQSTdWSzJTMTdm?=
 =?utf-8?B?L0hsS2h4TWVOZEdyYmJoblVhRm9WM3F0U25RblBwVEtJVlk5ZDhTY0dRdWtC?=
 =?utf-8?B?cFVmVEM4c1MzYUo1S1grV1Rpbk8rc25GdUhHWWlvOG5mOG5uckZPQmhmUHFz?=
 =?utf-8?B?R0djRmxHaUU5UHU5Um53SG5hTUdlM2w2TnkrTU9KMDVpY05wU1lVeUVrdmpw?=
 =?utf-8?B?OTV4Q3V3VlEvamppTWFJUE8yVndBN3ArWTlzT0pqdC9STkFSZmJRVnZKTGlq?=
 =?utf-8?B?NTY3WE93cFhVcWJQTy9oWjNEZ0Z3c0djZng2alU5aWZhOEZmcmZtbE9iWkJo?=
 =?utf-8?B?M0FqOUtheVh2dlJoUlVRVTNKbXlPMHFNL3Z3ajMxQmYzU1YxQ1crbEQxZ1c3?=
 =?utf-8?B?REpaS1ppSkIycDZMRHEzeWZhMkcrSFJNNmZ4QWtzYWhNZEoxa0RpQ1VzMjFB?=
 =?utf-8?B?VktWVG03dWFKeXdWdjAzL0MxK09oQ1VEdmlRejJMbTR3ODFHMlAwZHZlemRL?=
 =?utf-8?B?QnRYYTNKVmFkSjYvOHNYUTJoSGFaZnlnU3h4cTNxaVlET3N4dW1OTWRVRzEy?=
 =?utf-8?B?NklZakxBYXdvWkVMV3VkczVTQWt4cHFkVmdzR20rVGRaZDFUdFRFQ2RGenQy?=
 =?utf-8?B?Wkd1U2pnNUdWZElpemh4VkFoZkFRQlhxbjlLTkw4ZXVvYW9mZG1iby9Oazcv?=
 =?utf-8?B?b3pLSFBBOTBWN2JmNm54RmJ5YzRMMHhlbllLdjhRWEJqRzVGVlVSeFZ4dUxs?=
 =?utf-8?B?M0w1UzJjUzJUbWJqWTExMytyaHVhZytFQTJrWDA1cVlROFZQN0ZkSzR0VXNk?=
 =?utf-8?B?d3FBU1A0ZzhHZVh6ampkeTZwcVNCQmV4dmxpYjRvenVNYWRaRHAwSjhPR2h2?=
 =?utf-8?B?R2lIVVBMaWYvNXo0WGxHTStybmZwc2c0Njg4Q09YOWloR3U5NzhzWGErUU1u?=
 =?utf-8?B?RDdqN09ObkdIMlo4YlpVc1hLTHNYbVJjd2w2VGtEMGRXcVZuZHdwWGRhMnJB?=
 =?utf-8?B?U1RnUFdzUXFhSk43ZFVXTThscTZQVEtya0htbEtJYTZBdnYrZTlrZTlYRWl3?=
 =?utf-8?B?WXhwVG1hYXlGalhDOFhyK3ZQVDNnVWlSQmUrTlhSbnBPaXZTR1EwSE94TnhJ?=
 =?utf-8?B?TEtaZzl5TzNZRFlEaFdtcG9yN2xCWnlzeEJHd2owa05QWGViczlnbk16dGh2?=
 =?utf-8?B?WHd2anlWd0JzS3dudDFEbmEvVEY5MFBOaXk5ZTFZVWVNSHZMc24zVkQ1RzVj?=
 =?utf-8?Q?k1iPF8ORsQcm3QgrME?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0481eeec-0b2d-4e7c-0b56-08deed6d87c7
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:33:03.2630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhpXxE8o+BDE0kHsCskJNBHw5ZoLfUl9MM9oYi84Zu5N/IGTfkRMddDtduwsug4G0JEaxZ8SArq0L0zgy/k4jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5949



On 29/07/2026 0:47, Bobby Eshleman wrote:
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
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
>   drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 

Thanks for your patch.

Overall the fix LGTM, just one comment below.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 4a8351f95b27..44834890a409 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1940,7 +1940,9 @@ void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
>   {
>   	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
>   	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> -	netdev_tx_reset_queue(sq->txq);
> +	/* Reset BQL only when the SQ has no bytes in flight. */
> +	if (sq->cc == sq->pc)
> +		netdev_tx_reset_queue(sq->txq);
>   	netif_tx_start_queue(sq->txq);
>   	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
>   }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 0b5e600e4a6a..d0ad1b8d6988 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -909,7 +909,8 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
>   	sq->cc = sqcc;
>   
>   	/* Do not update BQL for TXQs that got replaced by new active ones, as
> -	 * netdev_tx_reset_queue() is called for them in mlx5e_activate_txqsq().
> +	 * netdev_tx_reset_queue() is called for them in mlx5e_activate_txqsq()
> +	 * if the queue has zero in-flight WQEs.
>   	 */

Please drop this hunk. In this path the replacement SQ is always freshly 
created, so cc == pc == 0 and the reset always happens - the qualifier 
invites the reader to worry about a case that cannot occur here. The 
original wording is accurate as-is.

>   	if (sq == sq->priv->txq2sq[sq->txq_ix])
>   		netdev_tx_completed_queue(sq->txq, npkts, nbytes);
> 
> ---
> base-commit: b515dc54795ef370be3cb396e7c12ad91686b6d1
> change-id: 20260728-mlx5-bql-84e02a5a46c8
> 
> Best regards,

