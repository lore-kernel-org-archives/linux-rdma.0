Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011006.outbound.protection.outlook.com [40.107.208.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206013D886;
	Thu, 20 Aug 2026 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787214145; cv=fail; b=HZqb4dQS2vHX2OfbPAfgs4xcd3oj2Wci8A7pVux9205j+/REkcYYsH0B/J701AirKLl/Ttoi6dviboBo8Qg2Y6s34LlBvsDw8qKIN9NiaqbFg3W/n4/s3mQu0VenLFjIBvHR6Zo76Pk8HmIqI0KRsYfTCnVVgciSdsHbYyfEDPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787214145; c=relaxed/simple;
	bh=t/g/uIATab4ejV1rlYABsKz+t3b5q58+GspNO1Rp+IE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KJi4rb1gqY1zNmClrkaFR5+/SKwMLQKgA4BPX+H9py1pWQXu+nvRJaBlItXoXX2CMDj5gvBmmcUR2hcHiUqPqWRUYA3NNkq1wfW7xdCGLdhqmCth7n3c3dzvCLT2aW5K3ax/n8n8fOesoBQW8IDrZHsiYsufsYuoJyaeu9x5X8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QQPtDVT7; arc=fail smtp.client-ip=40.107.208.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QQPtDVT7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYY+zfXGMJHYPQYKS/4NLQ+4NR7J9Er6cuoKKn6E8xL/Ya06Ukcsq3mS9KaLn9stM0r8JPIaUWrcbnWiocHQDHzqbj5qIysunUgHYxzR6FfiRYJEg2tKoHS/NLu+ZubuK4HsUwuV3dZGypI7IUHWbE5vpeKLHtKOolxZBfY1RBS4sbY3ip+j/l06BMrNBwN6rXk3fSfxDNzl/xBLuhQO3H4DvBvBRr9bHGZkNmbIlwIMQ3wRpHdPJY+nPx/R5kXbIXqQkgx74MglOgjnZXiHv/2tAgRf+LGbkJp25ctcXGpxLdVLjolUhueexJ6AaflNoSQADXHQuyTq74upMXvlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvZUJ/mpqV3H9DOm9Nw8I+oknll/F0dkpLl2K3XZM1g=;
 b=aOKtkMhwYNv7EJQ6Cw99pSkZ01knlO3525zSjMhQ7r3YsLSLRVOjxWAHHNzaAOVWmk89xx9JnnFA0EQTnG5tvS4GJPWGj39+u92PU9D4Bj+1t09Rhy4tGwxnrcY68PzVgv0900DlE4zvZ8CviLyi3hGBlxmfe+Y4ImqFrWytdH35M5LR5HNy9n3aMkvKexGMcj63MKSA5vuLtSCtjzMWals8atboHaiclh/vOXoYUJKNvr/MI4OUCAtyLkmTh4Dy5OT+dRTJFCf8rkuiCOMHpQaAOnjdX7X2k2XEBRzOpWlA4Jb9kVn2n3++wlLQpAK+KJS/lqYx32S4UAjqZcBMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvZUJ/mpqV3H9DOm9Nw8I+oknll/F0dkpLl2K3XZM1g=;
 b=QQPtDVT7pTay7SqmAA0mFqKBEXPgThBSHn1cEXKPJXyz+28Ev7ZygRgnZ8pp1wwDW+VAtAcZIeHwk3VOsT5I/6fcMX0ZNLhE7f/hqT//9X9QBQrHdyJekDv9mOD01xOO/h8F0Ts8iZjQOHt3FQYR1ANVK6C1P8kWP67T0tNdzQm+mZaDIfq8qPEuQq5w1C2e1Ns55+8ER6/tlhiw29VinagkiZ4SEnGv2MT5Mi5AtDiN4ZUDYoMrhp29jyQS8g3wGDvWRzNjFLSKJECa5VVz9foseCeIC7mgECWmU+/rKtSIhFvPBR23yQxWu4XzncFGcbs/iCeKbE5Cy37t5b5RMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 08:22:19 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 08:22:18 +0000
Message-ID: <4ee87a51-871e-4155-a279-d20fe5421dff@nvidia.com>
Date: Thu, 20 Aug 2026 10:22:13 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: Prevent stale XSK buffer release on refill
 retry
To: Jerome Tollet <jtollet@cisco.com>, netdev@vger.kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260819151320.64178-1-jtollet@cisco.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260819151320.64178-1-jtollet@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::9) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: 748fa1fa-2000-498e-e42b-08defe94265a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ukEm4EJGp/Y7LHePgfUN8/nnH/ao5KOVEmPAwsWfp4p7bbZkeUO5Jh08TKsxTbt32p0Rl7egkR++yvMbSJy8e58NjqU6H1VPMA7B381w167kagv/PQODEMiQG58WEV67w0hThW06TOuObyre95iUWAhmbgNfzW0ixyTE8SE8ECC4UBME6NEfkOHpbFUDKIbn9Jdf8Sfe4fEI5FWiRzDc1+6P1QUOW2ueuZf/a++Bs2x5w2gtOps+ori9IGEOortiz1OwZEOS7UeEOyNcSubuWoZjI11bmS/hpkh2gEmDq0Bfj/I6dA890OI5lzfLWtNp2iEwFc6SrKaaNbX9UWYWjbG0r04b7iXf9zLxlj/mNVbqe1xJ7/BgPJJ8lv1/HgIeNPnucb9cWcfgrYCZKezZy0TfTMbVc48Vq5lIXulrs5iBtHtQNyRKcwc4EU6CN88GuNcGbDzXp5i6PmjCywB8IvB+kzI6Xx9XzBgQYGrtBv3a0BZopr/c+LgzSl5h7Cij7vodWO/qBbLYnlaS1Bn+K8u417KDyr0+W8HUFW7TLD5QUzfNSqJ+it2zHzGfmD7Ht8IX0c01rdcby6rid6aoGyOyS+U5zRFnKnOhnYbP15K94//LvcM/3p5KRi121vsdEOiQWWVHKvr0hexL2KFsY6VZ8cdUs7OJbbk+Pr7XvfI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3hGWWR5cGt5bHFkQ01qTjg4aXpJN01rcXp3dFFjVWR5S3J3QlJQSnR3dlMv?=
 =?utf-8?B?d080V0MvRnk5TXBSbXFLOC85OVFGMmNnM0tpTTd4RzFvYXhYRU50MlhvR1lz?=
 =?utf-8?B?eEtKZXFCaDNtOEMzaXluZm1Nb1VMNWd6V1NPaWFxTHhEVDBsWW9aSG10ZWhW?=
 =?utf-8?B?OXFPQmFQUllVRkxBNDJjSXBId3ZpT1IzK3BQM3VPYXhrazlaWlgrZWV2clIr?=
 =?utf-8?B?ZXlUWENWVWpOdnhhQUNDbjk4MlJLNkNXdUsrODhHWFdJVXJaUm93WEk0dFlK?=
 =?utf-8?B?UmpKV0RzblpMRWRKZ3lXS1RDTGpHblVNZndobFRqa0s3QU9USUZHR1B2Tmw0?=
 =?utf-8?B?K001bWhxbVZsYng0V3ZubExUbTRZUGJGR2ZpVS9mUU5HOG5EenlOWUlra3VJ?=
 =?utf-8?B?M2p6NlhlNzdPQ1lvbDZHU2xwNlZwSXlQcGNTZkMrbGZxbzBSOUpZdWJRcW13?=
 =?utf-8?B?VUdSVjlWS0hxZnVDUlY3c1lvcS9WaVBzcHNtRWRJbDk3TTdOcnVJeTlhaHMw?=
 =?utf-8?B?akxVSUY5KzYrNGcrVUVieUh0UnRSc2xjYzY2WWgvS2lnZW0xVmd0QXFGdTZZ?=
 =?utf-8?B?dC9hYUwrK1owK1ViMnZsLzU3bjB3YTlVRDJET1ZBanBjOGRjUlZNalBtSHM2?=
 =?utf-8?B?Qkk4U3VBRDQwSVZWVVZLM2phYjNaaDZ5SjJLY0o1U2IrWVdaaFgwYityWVpG?=
 =?utf-8?B?NUtqdmlmTk1qd2FYY3hyZGIyVVlocnlqYnhpOVlpaUFUa1JGdWdxT3hQUU0r?=
 =?utf-8?B?aGY5c2JGNGpBMnJMa1Q5SEJzTWZ2UUZyMVB0ZHVTYnV4U1IvelVWQS9sRXFt?=
 =?utf-8?B?a0V3MENjTGp6bXdxdTAvdWJrQ0JOSlloOGh3SXd4ZTg5WGNkRzAxTFRqZnhz?=
 =?utf-8?B?V01OYUswUTd4eFFUMEQ3YlRMY0h1Z1dPMHFzTE1oaHcxTTRwelhNLzRqY2Ez?=
 =?utf-8?B?N0lUTVNSVjEwd2VHN3JYSjdqMzgxN1BJelBkNVU3cEdieVN1ZUVDVVlZV3FJ?=
 =?utf-8?B?ODFBbE13RVFFQWhELzFPWFVxV3M0VkE0eHBpZm5pVm5peHZmVko1OU9jWTV1?=
 =?utf-8?B?OUVYMGI5V0dSMy9mWXpLTElqMU9YMTFGby85TDFSRDJCSnk5ZDJkbXZPMXFC?=
 =?utf-8?B?WmY0V2VZcFB4TnZERVd2OGRWR2RaM0lLOXRPUWt5Ynd1TmtTSGtYNytzeGFy?=
 =?utf-8?B?K1pNTCtSTTN2ZHg1WkN5Wm54M0RxMSt0aEJrRVB1dXN1QlNJTWlUeTZDZmlh?=
 =?utf-8?B?RnBtLzhlN2QzNVY2NG9WY3NFYWplMTZ4RVRabG5LbEFMZEZMaDE4c1N4NVkr?=
 =?utf-8?B?Tlg1NzJsaXN3a3Z2RmpIM2hsZGZEalcwamVDcDZRMkNKMFlBdVpmTDZJVlY0?=
 =?utf-8?B?YnZZNkovV24yNS9zelk3UmdJcitaN2lBVjAzaGtpazNYaU0yS0JvT1MyRUJn?=
 =?utf-8?B?TEVaNHRYdjFkaE1FZXZCMkFpZ3VpWVBNT1phNXpaNzAvQkE5VmloVnRod0NS?=
 =?utf-8?B?QVdYQ2JJdGMxbTZMb1ZVNGhZallDTTRQcnJrNTJvT0U4SDZzOEpIUk03cTda?=
 =?utf-8?B?ZUQ0QytWUnBNUDZSNjlmYzhrbHp1KzNENi9PTCsreUwvNlEvSzRoQjhxcTFJ?=
 =?utf-8?B?MmIxRTFnbDdhN0gzdzZKc3Z5SklDNCtVR0p4ZWdJRWRjY1JwbVE1UGY1ZFJx?=
 =?utf-8?B?a1R5ZW8rMW1rRVhrSzJlMUMzSnpkcWIxNHRRUWNWTTJ2K1hkL092WGE0amJm?=
 =?utf-8?B?aUllZ0VxUFRyendTbWVJOFFGK3hLd294bXhWUXFTTEtxb2lWK1Q2dzMrMEdP?=
 =?utf-8?B?QXpleWhTbHlvVzROUjltWE1pbzNDWVl4QUEvWFpXQ0Q1d2wvZlE0TXRIdjls?=
 =?utf-8?B?NG9PYWc2MCtUdUJaa3I4aDg4OE1qS1kvZUZkalNjUU50QWgxV2Rqd3RhRGpN?=
 =?utf-8?B?YnhpdSttQVZnVmNXcTlITFZYNk1sWnQ1UmNQdmxIZ0NOaU43c1Q4dG1QRDR5?=
 =?utf-8?B?OXNjSmtESnpBMzNTS1pnbWdnNXRmM2xDVndzYW5NYldHcjVWRjhhU3hvNVVU?=
 =?utf-8?B?U01Hb0IzSElVSVJBYjU4MjJHcitpN0NHN2VrSDMwODN1MXR4SnhvcFREYTdB?=
 =?utf-8?B?MDREeklGOEc5QzcrYy8vNlJEdmdaeWJrMk1SQVd5YSs3b2hibU1oNmpsczVX?=
 =?utf-8?B?bktiaVphK1UxQzBoMnZFTGdQZXpBVkN0SzhIbE1KSlNKcVpFR2d3aVUrUVNV?=
 =?utf-8?B?aHhxcmR1UXRpSTF2NXF6cGZyQnp5ajFkdEZsV2E0MUVhWkRXNGJYVzViZWFa?=
 =?utf-8?B?N1YvK29zQ29Pd3l3ZWhXV2hmVk1wSnRKbjExWVFBSzEzZm9qbDhydz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748fa1fa-2000-498e-e42b-08defe94265a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 08:22:18.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhOTlCtYNoQ7gZJUYQJ85Z5yiOyp7zzHMC6nnRqZw7+tU23T8wPQNGOcv4eMQLYNCnhEp4ae62m0ChLvuHl91w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223

Hi,

Thanks for fixing this! Just some commit message nits.

On 19.08.26 17:13, Jerome Tollet wrote:
> When an XDP redirect to an AF_XDP socket fails because the RX ring is
> full, the XSK core frees the buffer. mlx5e later visits the cyclic WQE
> and frees its XSK buffer before trying to refill the slot.
> 
Is this necessary? You explain very well the circumstances in the last
paragraph.

> If a batched refill succeeds only partially, a missing WQE keeps its
> old buffer pointer. The buffer may meanwhile be allocated to another
> WQE, so a later refill retry can free a live buffer through the stale
> pointer and publish the same UMEM frame twice.
>
This should be the first paragraph. With a bit of extra context added
(XDP redirect with AF_XDP).

> Mark the WQE as released immediately after the driver-side free. The
> flag is already cleared when a replacement buffer is assigned, so
> refill retries no longer release stale pointers.
> 
> A standalone legacy cyclic-RQ zero-copy libxsk reproducer, using
> 64-byte UDP traffic offered at 12 Mpps, stopped on stock after
> 2,854,914 packets in 4.094 seconds, with 4,542 xdp_rx_ring_full events
> and 64 ownership/double-publication errors. With this change it
> processed 356,904,225 packets in 30 seconds despite 571,405
> xdp_rx_ring_full events, with no ownership or data errors.
>
There's no splat, right?

> Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
> Cc: stable@vger.kernel.org
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Jerome Tollet <jtollet@cisco.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6fc6605d2..7967a2737 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -410,8 +410,11 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
>  
>  static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
>  {
> -	if (!(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE)))
> -		xsk_buff_free(*wi->xskp);
> +	if (wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))
> +		return;
> +
> +	xsk_buff_free(*wi->xskp);
> +	wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
>  }
>

When you send the v2, feel free to add:

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos
