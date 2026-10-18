Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011028.outbound.protection.outlook.com [40.107.208.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F80361952;
	Sun, 18 Oct 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792359827; cv=fail; b=p8dzukNme8v5voj5CgI8aZvCx3tMguQ6COZcEkjaGgVTrgdjzEx4bPotTkKzlR6BmLfGAT804fw9CYSlkldN7BMuD6m5AqJCzypR6V0wijytZTZiKM7CHpY2TNykQEq2VWB7Ln0TOXiRwgHnzr+WGgZDk/sNg6dz5w+8UYIsBBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792359827; c=relaxed/simple;
	bh=HWuWm9SFgFFtJUjyNY2hoT9aMm0liNYu672wSr8a8/A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mK8qnW/+hldkBcwZb6dWj+yWktaHw55eWnEVEEF4FRUBteLntidyK8TBuD2FFA1wiGI4BG5E/YngwLgYeHozKaXHYvzPWktkJqXGEz+V5YBIDoFCEtXCsehufyfxkk1H1Ya6onKkaLL7wRSfjx2Fu5rVXYv8WaasVIXmRu8sdf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MhOCjrLb; arc=fail smtp.client-ip=40.107.208.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MhOCjrLb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSzspg8O6eBzpAbo+/U+4yHLoxGNbJAYVAGk6PfWOKJi9m45P3tkQ5QoUxSbxk8xXaiuur9Jop9M79JwKH909quZrEzEM/ySMrlDd2RrnWK5N1dQxTH+ACAL1NbN1V61cI3Oqtu6S3PnRfX1ljzxnyke+Z3F1NQ6THsf953O101OY5+rYqrUUZEhqhh7ZUeT87iNId7pbU2xZaJlnJMgTmRpsX6ca8Ljt6mTMZL7/tkhlqo58jwEFuqgQaX3BfwHtjhkRcoqWOfvc87WW12cZC0BGRIi5aVspOk4Qln5f0+/OjAES2DgJCp7mcFKn1tDdCDxv6VgHlttKDq0XuuSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHjS9f1zRMASDHliwAaEAVNXH1wT/KSRmHgXTYKCO1U=;
 b=epuFsOZ2+y/hl8Nk78Nz3gIs1NZQhJN33w/a1RFTzqmuXqLvQYkJsKjQWX3sgYVar0Yxc+mEdYA7v/mxLFFEc+AK6fTPNbyGuUOctZS1/Pp+sjpOEd5YsYw/iDn4UA77a55ZkAY7Hr5jqqKJ+elMrx/eBfg4XyPZ4T4IrPrU17llQJ+Fxw3yv/B/DplHTPty9i9QcC7W6F06GZAyk2Zrw+geo6FQGnHhzi7PA2RUwA3zIczEPtsRN/hvBN9hV6xEobeIurXbKHAKjiFy5lV1TZBuRsTL444C3rBf3F/WPD/lFe58JBv5Dzaim3q0VTPzQVbgbsCHPwIivmTF3LqnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHjS9f1zRMASDHliwAaEAVNXH1wT/KSRmHgXTYKCO1U=;
 b=MhOCjrLbNVopUQOEx0S5gh1vmL7M8ewRgb9L06isxFX/3GfKtyJvZpUfP9fXLsEPS+OGA8WhEcZKfOtYiVHn31XedOaXZkB9fCqZxgMbgg0XULERHh2ZSLeFjHVeb05jNgJhOms1qfdkH713OGMaValufsKMvY84JAK9vSpKpCmuIo6cK/Lr1TyMs82/vT3IVB7NwXovt0GY1LTHx4hs/Eksljl1iv2zMuDK+0UjlOy1G9DtJoYgkttV4cQm9aOvmumkqf3pdgGy9GlBAeQ+bhRM9uBwHzojfY+xXI7ZyWhry1GRHMhN/THu7dgRWtcsHY2QYvFAyfEA5SvkfcwT0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by DM3PR12MB9391.namprd12.prod.outlook.com (2603:10b6:0:3d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Sun, 18 Oct
 2026 21:43:40 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 21:43:40 +0000
Message-ID: <b3e5ce46-b6a7-4b90-b92e-2ee737ae79cb@nvidia.com>
Date: Mon, 19 Oct 2026 00:43:27 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Hamdan Agbariya <hamdani@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-3-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261012101937.1335231-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PEPF000067F2.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::31) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|DM3PR12MB9391:EE_
X-MS-Office365-Filtering-Correlation-Id: 85116aa5-3b3d-46e5-1dd2-08df2d60df75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|5023799004|4143699003|11063799006|10067099003|261009223027099003|56012099006|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	76GPMbF9TsENltZfs4rJklXMXhxpCDoGAakXc5767A+/tBXEwxDcTanVGo4wCvcc8JoWlu/2I+T7ro6CoUwantIPXmdZHLlBY+sfcEEx4Eg+yMRQshWNwvZMi5eZri05F/1nxMmFF/hW2ulT1NzfnGSr1TwOB1EjQiITtcemf/zKz4saXmZcReU357PEg88M7bvqVUh18/5NCTNfaP7anbHcIJoLxA8B5ASnwjx3V6FtTASJzDM6a6tZHNOG7wpZ5a1KM7VQ+4aAtXivunMCrpxMdOyOdveM5Ykrxl49xAz/yFULohjxEbN+EXVnnFlTe6KDWyHk6ZiZ/aBYB0aNd7HQyVPuo2mbY0qaeMwwU2YLrP2A9U+L0G60vLnlK7xZAvOea70pcTcfVzMR0Jo1kaMiZ1DvrwOCFNbNW5Es9MuVlc85jtfeCxUNs9IA0gbRhGQERBbecR1IlZ/Y09sBt1nk0vLD1iu42neXP6FM4Pve+H/04gJisQs3iP7NKjJ36y+McVr7mQ0J1WNGs4gkTvzyvtdzRrNHgz00/Hu0Goske/uL0t0Qu92VKW3XS9wMTUvN+Ydn+fxdZgdLO/zqRCDTa2sYfVNuEdflOIpHFSXFU43dBYKbWHtoqb1kyc+3Is9G/0IU/LJcPFvsbWuRq+fNd9XIFiftSQeFhPBv7Fqll3qpmTpyG40zt3h8ZLBLrt7tQuIt1S66BVh0Yn1mxutkEFWmmGIYdteJHhCuhMiSlpEKvnBQDDpASyw5N8ux
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(10067099003)(261009223027099003)(56012099006)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THh1VFFiRHJiRXpnd1c0bnVCYWp5OXdsMUJsSGp3cFpyRkh6SG9tcWJFNzFw?=
 =?utf-8?B?V2c0YkpuQ3Z1WWl0TGtyVHFuTXVxNTcxL2VVRWRGaXlQendTejlJclNjajJj?=
 =?utf-8?B?MzNPSE43L3M2aitTWXlLWHVKTjNWa2FSc2sraEVNUVJLZnlKSW9XRXQvNDNV?=
 =?utf-8?B?QkVtTEd5QmpYVnNQV2ZUSjBSSk16WHVNbUo1T25qSzk2Uy9Sd0VrMlFOUVhN?=
 =?utf-8?B?eWd2Zzl1YmhLN2VEVHhoOUlMQng3RXY2blVEdm8wVGtIL2Fvdm5uQk1XeE0r?=
 =?utf-8?B?S25acHNESjJyM21NeHYyb0NNbDIxT1A0M1J3VGVTWTJROVhWemxXS0kyazll?=
 =?utf-8?B?QjRVa1JZTlhMWVV4dWN3TkNRdmZFRHBEQW5FK0tIM2JMOXpoaC9mdkVTVHlU?=
 =?utf-8?B?ektDVGkxN0ZWcEpxOVRUY21PTUZ0MGVhaHRSdkJaOHR3eVhVTEhkTnRpbisy?=
 =?utf-8?B?eVdxRTMxOTB4Q01WYXdIa3I1bVJOdFRlR2hIM28wbjVrTFVHeURoU2xQNFpD?=
 =?utf-8?B?clZzRStFcG1Ya2tRTlZ3UDVtNGxsbDkxeFlxME1zYnZ3dEwrUzJqT3ZYbk1K?=
 =?utf-8?B?ZWN4VUVmSm5DVE5HQWczajhOd2lrUVY3czgvQ1FreXdYc2oyZVQ2bytuS09m?=
 =?utf-8?B?dmhmYk9JQ2w1M0RiQWZ0UVJZQWV4QUpyTGYra0tzMWVyRW1ob1NtVlpZT2Y2?=
 =?utf-8?B?MmU5aFI4V2RBU3B6VE8wUnBJejRPTGdnTFVoWnhLQ1gxc3A5eEZPakltZWJS?=
 =?utf-8?B?MG8rbWxMbjhHL0RaQUVPYzh0SWVZNXF1V1ErWmlKNHN2SkcvVzIycTdja3RV?=
 =?utf-8?B?dFV5OEpaY0NJdFBqWXhyeTI4c2JzczgyeldqMVpNK3hTUnpLUmNicTRtdzND?=
 =?utf-8?B?aG1hSHlielcxWlN4U2V1dUNFY2FkcTVZMDlQRkFhT1VyUkE5Q1hqdUI5QjFR?=
 =?utf-8?B?eHJETnY4VWpYeUhPT1lVVXZiMUViWXZFVU45aWdMeTRad3JkbU1QMUMwcHdw?=
 =?utf-8?B?RjRXR0JKU3VLaEdFZ2FKZnZ6TE1pYlh0eDlxR0h6SUVwbU12UFpRZGNoYVEv?=
 =?utf-8?B?V3Q1SDkvNTZldUV0dzVyLzU0eGZZRk8vMDBZc0dDTm1Uc1g3QS8vVExzbUVo?=
 =?utf-8?B?ZngzeVM4eWw1dlgyVTNkMDhSb2VMSmZnZXMvQ3I1M0M1bXlNNVZiS1NvVmIr?=
 =?utf-8?B?L095YWRla1EyV1I3SC9hVXVFYWZhYUdvd0UrS3htL29jRC9BWlhNQ3RFdmVC?=
 =?utf-8?B?Tk1tM2JHN3JzRUV0ZGhGOTgxYURtWU9VWXBKN0hReE9ub3FiTkdaV2k1VExP?=
 =?utf-8?B?QmpzSVRxK0Nqb3lqcmNNT2w1OUdndm4rVjFiM1d2Yld3NjFnZDJrZ0VCK2Fv?=
 =?utf-8?B?ZnBuelJkc2V5Kys1Wi9uYTVlaHVnUEVTUTk5RDE3bStvbzdaUVBCZkp1VVY0?=
 =?utf-8?B?c2dVdW5OMkpGTmtvbW54anlUQ3psZ3hDUnV3dTlyZUxGLzRaQWIyckJaV3Zo?=
 =?utf-8?B?RjRwNlZPVmNhVmhFM0xhSW01cVhHcVBpbWgxRjZPejc0NmJOVEluOVVoSmJG?=
 =?utf-8?B?d0hlS0RPUUNsendKT3FCN1JPZ2lCelVxczFLM1hlbzFsbnhMN3FBeW1jNEdn?=
 =?utf-8?B?aGJqK2E4WGpxZGFwVjN2ZU5SS202VEw3dDV6OU9iREo2bWlxd1BqRE44S0tP?=
 =?utf-8?B?ZkZvVStYazBOWFMwUFcwMFlGVHo2elNmaEQrOS9Rb2k5dmwxek1Eem9kMldr?=
 =?utf-8?B?VURIV0pYMzN1SGphVFMvVEY1cU5UOGZrOXFneVd2UXNkcWs0K3JmeFpzSnh5?=
 =?utf-8?B?cS9FSHFSTzZ0MmtQN2RJM041MFpWaUpSVk5GVlFTM2V2TEhNNkowM0hRMnha?=
 =?utf-8?B?b05rNUJTVFBXdnREcmVvSmY0MENSWm1RZmFSbzMyLy9xeFdUdUNqajVhWE1t?=
 =?utf-8?B?R3NuNkVSQkJGVFNwVVZ2Q3RqRWdRWGFHUjYxTWZvQkNiK2pKd1N1Qnc0WitX?=
 =?utf-8?B?V1RBcS9RK2xOS0RPaG5vV3YxWjJkYzhCenpwbEZIM2JFeGJ5LzVNZjUrbVNx?=
 =?utf-8?B?bFhzMmRWRnZsSC9QVlF1MkJoVTNBa1BJVlhVS2Jrd1JKT1FFOTJMYzBDanc2?=
 =?utf-8?B?RHh6eENZWGs5N1Y4R3ptdTgvUUt3d0ZSL2JMZndMRWNDYTVRSWhvWTJ1NG5L?=
 =?utf-8?B?ZTFEVWJhNWxxUVJidHUvcUt1YlVZTjZVRUE4emhycVRHWmw3d0tCdTg0cThH?=
 =?utf-8?B?Y3FVSkZuOU5SM2NESU5zczF4ekM2cktSQllKcElITGJsaDRlNzVrMXRHUEky?=
 =?utf-8?B?R0JnWm5kQzJxeEhKU1U3NU1RNlNuL21RdzBFRHdEUGZXWEVTaGFsUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85116aa5-3b3d-46e5-1dd2-08df2d60df75
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2026 21:43:40.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ztk53NYwWz58l0VCpwbnJh/MRzpJfguzkOkAsD2QenzkJCroS1I0RFipX5V346kpIPAmQ6deKFGgB6qa3H1Xsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9391

On 12-Oct-26 13:19, Alexandre Cassen wrote:
> mlx5_fs_hws_mh_pool_match() compares a single dword of each action
> since rules pass their values as arguments. Copy and add_field actions
> keep their destination in the second dword and HWS reads them from the
> pattern alone. Two modify headers whose copies differ only in
> destination then share a pool and the second rule writes to the wrong
> field.
> 
> Use the HWS core comparison that checks these actions in full.
> 
> Found while checking a Sashiko AI review report and confirmed against
> the HWS pattern code. Not reproduced. No in-kernel user puts such
> actions on the FDB but RDMA flow actions can.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../mlx5/core/steering/hws/fs_hws_pools.c         | 10 +++-------
>   .../mellanox/mlx5/core/steering/hws/mlx5hws.h     | 15 +++++++++++++++
>   .../mellanox/mlx5/core/steering/hws/pat_arg.c     |  8 ++++----
>   3 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> index 86828e329187..cd888756e942 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> @@ -389,7 +389,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
>   			       struct mlx5hws_action_mh_pattern *pattern)
>   {
>   	struct mlx5hws_action_mh_pattern *pool_pattern;
> -	int num_actions, i;
> +	int num_actions;
>   
>   	pool_pattern = mh_pool->pool_ctx;
>   	if (WARN_ON_ONCE(!pool_pattern))
> @@ -398,12 +398,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
>   	if (pattern->sz != pool_pattern->sz)
>   		return false;
>   	num_actions = pattern->sz / MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
> -	for (i = 0; i < num_actions; i++) {
> -		if ((__force __be32)pattern->data[i] !=
> -		    (__force __be32)pool_pattern->data[i])
> -			return false;
> -	}
> -	return true;
> +	return mlx5hws_pat_compare_pattern(num_actions, pool_pattern->data,
> +					   num_actions, pattern->data);
>   }
>   
>   struct mlx5hws_action *mlx5_fc_get_hws_action(struct mlx5hws_context *ctx,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
> index 1ad7a50d938b..13e9cdbc5d47 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
> @@ -688,6 +688,21 @@ mlx5hws_action_create_modify_header(struct mlx5hws_context *ctx,
>   				    u32 log_bulk_size,
>   				    u32 flags);
>   
> +/**
> + * mlx5hws_pat_compare_pattern - Compare two modify header patterns.
> + *
> + * @cur_num_of_actions: Number of actions in "cur_actions" array.
> + * @cur_actions: First pattern actions.
> + * @num_of_actions: Number of actions in "actions" array.
> + * @actions: Second pattern actions.
> + *
> + * Return: true if the patterns differ only in values, false otherwise.
> + */
> +bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
> +				 __be64 cur_actions[],
> +				 int num_of_actions,
> +				 __be64 actions[]);
> +

Please move this to pat_arg.h instead - this is not really a part of HWS API,
but an internal helper function.

-- YK


>   /**
>    * mlx5hws_action_create_aso_meter - Create direct rule ASO flow meter action.
>    *
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> index 512299b59fd0..a49115f04025 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
> @@ -96,10 +96,10 @@ void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache)
>   	kfree(cache);
>   }
>   
> -static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
> -					__be64 cur_actions[],
> -					int num_of_actions,
> -					__be64 actions[])
> +bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
> +				 __be64 cur_actions[],
> +				 int num_of_actions,
> +				 __be64 actions[])
>   {
>   	int i;
>   

