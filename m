Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78C249D595;
	Mon, 19 Oct 2026 09:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401721; cv=fail; b=WEZmPoVcjAuXsvqVnL5Ie4LNpTQMdU5Z1yCLMtg9GoZ/P80oF1FGC5I6KW+DPBqnFHuGw01FmMUHAw+zGSPaS/eOJk1sWfFARRz/SW3LHDYJHlOoV2i12HXSYPNujGOoneRjf6jWmI5lh365dnUD8fuACrC3niQIascRr+azLAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401721; c=relaxed/simple;
	bh=lfQ4GTV6Sox1IiNK/ScGKJXgFnGwVMbd8KVIPiFi+Qk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OhCLpsKxGxkT3gO2KLfjJZDbKPOgBz6uu72Y4r80u06YzpGxu0FIhlBmyIZr9qcltHUwhdt2IHAkCqBlOCbaFJ1X/hMu7FsAHdzbg8s8WflYiy3U0OF0ZlA5UulQtzu8CmJiHkLqmQqUtj0Ec+rz9R3loQfIXulfClOadCzBQLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XBCzZ3fW; arc=fail smtp.client-ip=52.101.62.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XBCzZ3fW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F32xgLQ08aoJBJFl/J4YG18F8WByWuvQqtv3GmN3fb8tntvbVlnpCoN6af0FGIJ+KCVj1ESdiYZfpZkYXczi6h9ARgMQANX60s7GCcVtVKw/gTMGK/50cNbShRuwfgyJqFhGA1wEgGLBljR4nh5ACO5ReWLu2Q8neoZIaZ/OAwcxdtipnGIavqZ2ontR2FfBOqEpa2B0EiFAuHaysRBlxR472RTWvbdWneG0JVEZKRFonswtKMfR8EAtqKLILlKtrYlr8rL2k/mpB8i4daLCEVaPJejlo2GanMjN5a8C2pn/KImt2UyUoEbFH6CntUCt9C0gZSOas/wc46r+MI0zlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPaF5oB6vNQqCot2MyVJF7uKIK56e9uvZG0j5DT6KFI=;
 b=q3mFneXU0PqUUnCsoDatxL2XwFESwdD2A9xE9n4cNqeQxIkV6VTUuSgQaEQig42kBbJjjFQaWZmk2du6LAvWad9WjVnmlLj/OYC34KaPVKFgUiIPRRtcuOWybQOWIbi213TCXyPG4vpbUn+ezNCoua1gcmpwaFYz2nFdSSDECxDlglFZgiT+o8ATwPhwdVoCK7lE6xlmMiYVMeOF4Pl7cSWEk6JcM7jDCuNlpjnWkYoakx4yAxFXiM2ETNzwTz0SX2Qz+oo/t2T8an223aktqKYkeKvcwjN+kRdV2IVuvyxCpiY8xD9OfUoStNVTrJ+f3OhxDLSlsfTsuyL1GoDWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPaF5oB6vNQqCot2MyVJF7uKIK56e9uvZG0j5DT6KFI=;
 b=XBCzZ3fWD2gnfuOGkKw92XgCsXxD8/oM1UyQv5KOfPiMS6FdDa7aMnv0Ux0Bs5UH38W2U1dha3PlwjbHXm8Z1nJrgzRvuHHRxeLOiHVHuqrMgsdltPUlmFNSm+CzzLPhnaVc9nWN+iWokmMQHYGgyBzKpwvWW1jo4azRP9bkNNwHZTtgxZxESyvisqOM+uyspnZuCWQ1bIA2iqSoQg15ywzi5cB+nvpf+7xy5MLFBDX08W5QA+IwGRPmGXdE9f7bqX2pF9rjzgnsIbDVNXcmNPO7tMDUcgrZ8mZRwMkxUoFvEWWNhxZerj5LzRpr2y6O3hI5w5ebdCTt8JjmkQnu1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 09:21:50 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 09:21:50 +0000
Message-ID: <72bfd2f1-9926-4abc-a134-058918acca2e@nvidia.com>
Date: Mon, 19 Oct 2026 12:21:45 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix modify header pattern
 compare on big-endian
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Hamdan Agbariya <hamdani@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-2-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261012101937.1335231-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::19) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: bade62dc-ff01-49af-1ac8-08df2dc26833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|4143699003|11063799006|5023799004|56012099006|261009223027099003|10067099003|22082099003|18002099003|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	6XP3ydDhXGq2zf8626JbUQlTrGNTbrFKAk+YnkYNRi8TDpzRdCgkzZB/LfmauKIWjECWKZgdflzBJAXvxaohMQkLa6CqcErErSeK0TvCIfnk1u50Ofi/XzkXWOLFxboGAzX/EH2PzbYfUogi3uiwC8crlpeq4JSLsVoi8BjWTTweq9Hhet7Mlf/bk3UZaL33KlNMDOgRulrvptIItIKtmfQ3NsGd9cffZ8dWGDNBNylCliUJg6dorqTbtZJaFo6GJ4XfAt5cVi2I6V+TJY6rNV7NkMOily54kziLqLCuK09LhM48OBvjKVBqQYlsHoMXQd0oDlcVMnbzhVzqzqLRkmsem8+dWLVShh2wEOuAIPCSDXmudzkjHynU5kp8USksmuouUW8g6Onfa8LL4Et7Fkso/4WSfHNsqZrxL8sfxbA1CFQTEkFsbv8ViDlgm8oi8kAkDTrHZALxQh2OP6zuwbUob7OGwSsQ6YFDbb1dJrMD+3TK/Qc/cA1VwxUetbB3TkQyUA9vqrufe2AV/c0Hnhnkjnq9WuMONVWZam6PQ7yS03c5AsUKBwjMnlzDLGQCiqqNPbG+FjCQyDx+CFo6pmsWX96IiLy/5m/qtsQIVdIA90XgTF2EJyBOksDzmyag9e0iyuzB2oyC3vH0yc6dPEl2SREnP4hrFv8G/zr40cA9YePXMyVvHTvnMlmIbbYbdnWhYz7EUVTgm96rft765Pw26ZnV+3UjH1CMpRyqhC6hihmxYpVOcKMW91mKEZE4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(4143699003)(11063799006)(5023799004)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alhYTis2N21VMXZkdDBjVW5EQXFoU0xIYURTTUcwUGNQejl3WEsyUkJHdHBt?=
 =?utf-8?B?YkVHRkE4UVBKMzFlRFhHTGQxSy9hUGhFVldqd0V0b0ROdXpFWC90M3pNVmdp?=
 =?utf-8?B?RldrS3ZuMFIxcGcwWFYreG44aHdiQ3Z1MVNjRlVVNHN1cmZpUk1VK0lzUFZM?=
 =?utf-8?B?RVYwTkJmVnJ3VXJsQkYzbkdmYzJaT3pNdWU5SXFoeHpCdkt3cGJ2WkFHNVd0?=
 =?utf-8?B?aFRBemYvSXpjdnorcFprMXBBRG5kdkgvZUY3YnJXazhXNlh6d1R4VFhselJ3?=
 =?utf-8?B?N0F6My9mUmY3dW8ySmRPL0UyMk1SNmZQWnRLSVJ6MHVRWG5jSjZIUGNGdlor?=
 =?utf-8?B?MmU4LzRLaFJQVndNZ3ZldklVdStvMTJXU2VmK0xPbHJMN0pBMkh6OVo4SmJs?=
 =?utf-8?B?UlZwa1RROXZhTjNYUFZKRFAvZllVTHRFMkNvMmFOdnRURCtDTGx3MXNBVHdK?=
 =?utf-8?B?eVhSKzRzVjA2ZUZkbzUrcVdPR05kZHNLM2pzWkZTS1VZMzl3L2dYdU5GeHhT?=
 =?utf-8?B?U0pvei9xMFNOaDkvbXpiVlAzRnZjbWd4VjZQRDBPTHhQelFsZ1d2WXJkQUs5?=
 =?utf-8?B?R3lkd2xCb3NTc09OVmFRY09zUVFXVHI3bXYyQUQ1aUJsb0w3SU1vNytSSWNU?=
 =?utf-8?B?U0ZvRUpoYzN0bXI0SXQwS1Nsd3VCODVhaHNNcGlaZVRBOWlvNkxUOXh0VzhJ?=
 =?utf-8?B?RnFacGE2TXF3Szgza3g5SnBNYjdqMVdGYlc0Z09Xc3FxSVR2M2pKYXVuK3l0?=
 =?utf-8?B?Y1JGd29iOUgwbVI2dEM5dHdtbC9PdE5udlpISXRCWUZXWXgxUGhZTE5RVmVy?=
 =?utf-8?B?V3VzWko3NGtTeFExZG5seFpvZ0EyUkN0WHNScTFxdHg1K1JIbkwvSlljYjVU?=
 =?utf-8?B?WU43Q3ZBeFl3UUFJRytwKzJoOS9wNHpkSTBBanMvZVJNdy8zMGYwSkpydGg3?=
 =?utf-8?B?R2oySTMyQ3ovVGJpTndMQkIvTWRQdksvSXVUN3BWV29XTEdnVUVOUjh1YmNR?=
 =?utf-8?B?MVk5RnNLUjhDby9Kd3JidEljYnRTYmtvSmRlRmJBZ3NJMEkyRGt3dEpkQlpn?=
 =?utf-8?B?UnBZcWpMV29ad1YxMTcxeWNWZTBtMkFZZEo4Wjl5ZTdwUFRqQ0srR2t4N2Rz?=
 =?utf-8?B?UGhKNmo0c3JoTXFRSTlUeWVKdzNzeGJoUWd0MXFhbmM4WG9TTVg3MTd2dTZr?=
 =?utf-8?B?YkxMM2U0U0pKL3d2d3AwdktNb0xEM3N1aUZxbWs5Tm5peXhqM0JyRm55eERH?=
 =?utf-8?B?bXpTMWZLUjBQTkdSaUtSS0RWa1lRQWFtQnE0QXpOeFBDTkxZMGQ1ZUxhTTFp?=
 =?utf-8?B?bkRlTEFVdXZIbC9Fc2pBRjIyeG1WYWZnV2hBT3NxQWUvaDY1OVFFaHB6ZlFs?=
 =?utf-8?B?ZkU0dmp2OEFoRC9rcW9QbmFQbG05dXBjV2Vsbk5HNkpDUUQxVVdHcHVxZTRR?=
 =?utf-8?B?SVVYTU9sanV5TlQ1UjlNMVd4STBKNDl2d0V6dm1YNHZHOHRkKzJKL2thalRz?=
 =?utf-8?B?Mlhldjd3bHkvUkNid1laaXdUbmNXK1FIVkFWbVBZRUVzY0gyQnBadVVlNU16?=
 =?utf-8?B?TXB0Ni9MRmN2dG1pODdKK0o1aitpTmdhWFBtbXdoY3RLd29temMzUDdFWkJO?=
 =?utf-8?B?SnlTOG9EUXhDWSttUzVlcm1wdHBoUjBvSjVaa1EzblkzK2hVaHZJWmRqVVpK?=
 =?utf-8?B?bkM5NmJxcU11ZXBSVjBxdjNZeVMycC9UTGhmMEtaOW9hTGt6VUEyWlllbzhH?=
 =?utf-8?B?Smw1bENnU2lxNUhRYnZwbTduZlViQmxpejRnemdKNFBEVHJQSXZwdmp2NURB?=
 =?utf-8?B?ZGhFeDlPSVdEQmFMclozM1d3SkxYQ2xyVzB4R1FSSUF6WDdPeG1Nb2tBVUtS?=
 =?utf-8?B?SUtibVJlSWs5TTBXNGJWUXg2OU5nQXNiWFRkbU5BalV5QnJqWjNGcFBTTGdJ?=
 =?utf-8?B?TU9kZG5kZ2dqU0RLOXZUSk1VaHFrOWpnRGZWaFowb3lXNWl6Q3ZYSWd3MVZP?=
 =?utf-8?B?QjQxT05EZ0t3V3ZuWSszZ3pORVFNMTROZWEwSitNR2N0cDRuQ1Q4L3JyazRB?=
 =?utf-8?B?a3ZVK01oSW14c2RhaHljdUJDanJBcVBtWFY0UmZvdTNxODBDUVNtakd5WGVw?=
 =?utf-8?B?ak1DTmFoc29KL1B5VUNGR3RPV1BROW1neWFLMFdQeWtIcmEvaklMaDRxOUYw?=
 =?utf-8?B?eXVrQXFnWFpRdkNuSkdPQlBESlF2QnVoOWxOREdRbk9uVHZWZWdlVEVBZ1NX?=
 =?utf-8?B?b05WOWdaQmdzR2dOd0VRRlpuMmR0VzVPV3FPdTJwU1F3VEhVeVRDcEdyRWQz?=
 =?utf-8?Q?S/7B8jHCD9TdkA6FON?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bade62dc-ff01-49af-1ac8-08df2dc26833
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 09:21:50.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1BqsQlJ/tP5/Ir54jYbBg2uKH1shYW0huCbK1FPbszf160NR2mNxw0t9hV/18dNqzJii1erDkZA5pyciucMZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

On 12-Oct-26 13:19, Alexandre Cassen wrote:
> mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
> compare only its control dword. On big-endian this keeps the data dword
> instead, which HWS clears from the pattern of set and add actions. Two
> such actions writing the same value into different fields then share a
> pattern and the second rule modifies the wrong field.
> 
> Read the first dword of each action from memory instead. Little-endian
> behavior is unchanged.
> 
> Discovered by an AI code review agent [1] and confirmed by code
> inspection. Not reproduced for lack of big-endian hardware running HWS.
> 
> Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c    | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> index 9af449c2b4d5..512299b59fd0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> @@ -116,8 +116,8 @@ static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
>   				return false;
>   		} else {
>   			/* Compare just the control, not the values */
> -			if ((__force __be32)actions[i] !=
> -			    (__force __be32)cur_actions[i])
> +			if (*(__be32 *)&actions[i] !=
> +			    *(__be32 *)&cur_actions[i])
>   				return false;
>   		}
>   	}

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
