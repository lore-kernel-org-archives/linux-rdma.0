Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C0847085B;
	Mon, 19 Oct 2026 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421398; cv=fail; b=Ch4+Rd2SEnXQYGP/z5GUzL++H/55jWnQZOsmVjBug8XCdy6+CBvWvEm2vXywSI6OpNtc3qVaHXlO4IJruBN2lJnX2i+0cqIk2icyHyb9CNB/D3MDHxI7ITAZqnqJwpowBMdDy4nU4MMo2JTun2DFd7Qvas7Up1xNeDhI+Ugg87w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421398; c=relaxed/simple;
	bh=o19BswcbU0xIFjrIZjALL0TVQxYRHmp1o2RQ9T0X6VI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EKsYMtRefbRQuaa6b6RzBynzq8emrTcoCIDuEXVih5gMXjvXHlX69sbK4afVC3wU3RPRPA3HDAYK53bD5/ioB4b+fYmqLBbk8o8upjE6N2bIDigiZVDpoglL7DZd8TS10stQ47GQiTdyp6M2rs6StWqwCIfrSDipaKeGWS/0Ssw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f0CyHOvM; arc=fail smtp.client-ip=40.93.194.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f0CyHOvM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=msOSBvJWqdd+cJY6oaw+EQv6nY61nCgWqyT60azpm14o7b0cZaiy6a9DVMMgCM9+1FSjGBmjooMyf4n7DSQIpHnwQG/MmSiIbPgGADZ2xguTOpjOyN4TmD+dNnV5kpganz2UeAJVAxTVqQApAtie3GgtQMODfU20KcRyMB9el/7mQQe2kK/5jEKBjy4T4QEBKy22rxRiFZtd7FWsy2fNafDRM9Dg0c2IsxCPh4+unzgPIZe6xrx1pFRdI+tyvpL/tChFq3ZWbvuc6px373J4ZaSl4aHd2IIIZ+cSDcxOEzxEfoaotLtSr9TGBMybHABFY0QRzq/oy5FgmOx2rhuT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4V6uFQlJ32io6ip78UFzPNe4bbmGaigenTHOhsaIfok=;
 b=ey6xqTmchgsN10uekyjGaUF/K7eB9kvh5ymuicwJlIFgbveG0v2sytk6pyP2/+x11hVB9k9hgmb3SS9jq5sykeFMr5nklaV5MMbrTjs+FvKkWvN+FpAlH7nRCTWOKIKVf2zTyQSv+B9AvH0cSpaMXD6+Li0sj7iq/DRMED8dwzzNB9I07MtpCwc/V4UrIU1SW2fgKxaApwtuxPxW5jiVPFTmyBqSwXc2rn+3qk3ZXp9kwgg6VWDxALZipsFoOcW6CBBXobTVlOwAoq72+dBsXnC4fIKQxk6YI0ie4I/NUvxDviH4IuxCsGN40QWhkE1gDZZH7M2CxuzcoDjb5VHkXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4V6uFQlJ32io6ip78UFzPNe4bbmGaigenTHOhsaIfok=;
 b=f0CyHOvMZyVtNfAlvLVyOYj8Cd0htELk6bxIdp/++yHFswWNiq0Vwp/0r3qDbF864AbFPb9dIvdsWWbSQnxOUf9We5bTYBAViXfLcMdRkUNesKpG0OqetdtbT05DZoCl853nmwulPPGcFBJQHg40dhxrIMo1+GmsEH0lEZg7x94Q6Ori9P+BNATtGZlYozqKFsLYmYFC7uRFuTqPPtxGYITQAOJReUQGuRjvxmt2MohJU4k0y7oSUlBPSHtbh5IeHgnSdjsuD/lMzfiDzclieyEHuMm3fflXLKfg0/GKl0OfqfPn3GTYaNDtFyRPq6RFN522JGy2fLpHAJ/gcGm+wA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 14:49:53 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 14:49:53 +0000
Message-ID: <e8623784-820f-4bb2-b097-f94ffd6bca95@nvidia.com>
Date: Mon, 19 Oct 2026 17:49:46 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 2/2] net/mlx5: HWS, fix modify header pool match
 for copy actions
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Hamdan Agbariya <hamdani@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261019133159.1742411-1-acassen@corp.free.fr>
 <20261019133159.1742411-3-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261019133159.1742411-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::6) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|MN2PR12MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e56cacb-c300-4bb1-4be6-08df2df03c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|10067099003|22082099003|4143699003|261009223027099003|5023799004|11063799006|56012099006|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	Uz9o0dHcox3+qRsoQ/vcnWjEGDGPbaQpSwLyBQs1Rw/FfsIKtqlHKn3a5YZKDn7A9raE18ABTXVbHLc1JGnnpEVXDvILAbpu/EooPPEQNHy0XIS+DU9EUraweipj6QGbotbS3KffrRrQ9cCUpA+i65HtHx26Iss+4UUh5plmW7VJo6hQ6BeJtNsbHUpOXKeT8AdMxNgj4NPMZinsws8sQlFUVk/MN65Aw9P1BI0NOqNSl5yYAHrrr4uzLEQRyTK4SbsYQz1UBHQ9Zr25k7KN5YpS6jpWRyUv9VEdvD/DO2ljgty1QVPJHowIFYII4P29GG9MyUhop0x4qnUi/K67qJ3/WVo6h6UkxuhYiK20cf3lPKuEcSZZ40w036Fm8gMX++RnpZKu2BgxVZPWykdcmU746fVy33SU+YTKtGl4EDsf9QQM/NgLiGjKnHFbdup6k9DstcDlYz8R/fK26eSqm+iNTOJhNZpBNkzQMK3lb9Hu79uJCi/gCl+4XiLqAoADR4/wlteo56Yd8lUD5arxNwLnRkXVm39TOJD98LrEZ3YLy2LFI0jRY7Bwk7/sMZ+E4eQjZ1WrjrCzacM5YAuJci9vEe10rPKnQNyjsszfJ5KS2TBA6U/Xi70XDvOy3ES/M36gCopGK0u30RMh0lG34CV0MIS6kpuAWtQ4wAKco//yIKSd3f7C5PyRocKSLiy38rNkQ05iR5DnMmY1FPRCtOlWkjf4/eBNfa9Sy5S2ZBynO6W9zd9rUuULSVfmMRb9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(22082099003)(4143699003)(261009223027099003)(5023799004)(11063799006)(56012099006)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1kzUjkzcjZqaGxMTFZSbHZkT3ZkTjRSb2RYTTlxZVZMMkxVdTZmMitEVDIw?=
 =?utf-8?B?b0F4cnkwTlgrWENDSXNKVnNORk5YMWpFM2QrTU1wMC9Gc21yQklIbERyVHg1?=
 =?utf-8?B?OStmOHJJVkhHbmRsbzNGeWQ5V2xmRjMwc1pLYmFJdzltbklsT2V1UUp4THFn?=
 =?utf-8?B?NWZPWWx2S1dBQmtkWWhJNWZGckxEdmNEN3l1SFMrb25TM3dFSlBSUEN2cE11?=
 =?utf-8?B?cEJ1UUNialV4cUZBdzNSNXZUQ3M4TlQ2d21JbkNra2dEbzN0dE1veUxDYjR5?=
 =?utf-8?B?TFpqeEYxNVdMY2ZSR2xSbWxSWGNSbUxzUEtWUTFyaGtnODBhVEVVbDBYM0Nh?=
 =?utf-8?B?TnB5Q2VuQ2FEcEw1VGtmK0ZTYXBzZlVoVzZna0VINndSU2QycitGNEw5dXlS?=
 =?utf-8?B?RktZN1ZoamN5YUJNSWpWT3RLYm83cWR0QUZtK1k0d0c2VHd6VEFzMFFpNmxk?=
 =?utf-8?B?VUhIaDdCeGI0TFFVUVE3Z1liQjJjRy9IZ3FwZE9DZlFWQ2JpQTBCMUtLODBJ?=
 =?utf-8?B?QWFYcmo5WXptTjZFWVlKOVh2Q3gwZkRXbU1LT09OV3NaVDlOQjBxdUxKSWhw?=
 =?utf-8?B?L0U0R1d3c24rNkNlcEdBbW1vRlp2Mm1qdndmeXBnc2ZlTU1XZTllVmI4N3NY?=
 =?utf-8?B?U0Fpek81eGk4eEdpSWFneXVuY2lRODdJUUkrbUtZNWVFQnVlUzRsVUU4N3Jj?=
 =?utf-8?B?NHNPVTFVRmV2dTg2LzBLR3ByYXNWdnFROUZGV3MydUtvS0k4TDlBdGlBRXJi?=
 =?utf-8?B?cTBwWTB5MGcvSGhzbkZvb08xWnBNWlRiUjZkeUpjMWkwc1J0VDNWYWZXWDFx?=
 =?utf-8?B?blM3bE5JSDEzbnlxZ3E3UnVjWGJSSTFYYi9TeE1XRThrdTlFL2RVVjMwV1Ja?=
 =?utf-8?B?bmVGeXFZWXRnK2xINXBEUGl0ZUR1eTRZZ3hoUmFWaHRWN25HYXZWcGRsWkVD?=
 =?utf-8?B?S09Pc2VTaDNCWUtYTmowRTFvSVpaNGtTQUxseEMrZ3dQcTBsYytsOGFyZDBR?=
 =?utf-8?B?d2tLYzVCV1Uvc0dIbUVRWjZ3ZndYWE4yQmY4YWpRaW1vRXBVcEtZWW9udGRJ?=
 =?utf-8?B?WS9XRDZDaEZKTVNhcGRPY1pYWlpDWlZrV01lczRmTGNDVEpaRStEcUdSYjRt?=
 =?utf-8?B?aFhFSlJwcXQwVk05NmtpVGIrOHVTYlN6aWtVa1pUK1JIUzYxYXlYMWQ3Y05i?=
 =?utf-8?B?eW16aHNGKzFEOXkrRm1uMGdNb0VHRkJRaHpJZGxoZWovRmNTYkgrUGQ0Qklh?=
 =?utf-8?B?NG83cE9Xazh2ZEJXeDhTMHNCNEZuMlA1TjFYM1JPc1hVbDQ3Yml1a04zQjgr?=
 =?utf-8?B?T3oxZUxGbXJEbVRSSDJBbU8xaW11Z01LOUdHcG1NTzk4YU5vVHRFU25ndmRm?=
 =?utf-8?B?TlVwRDlWNXMxdTU1YlJNZDRyZitiZ3U1NzVyWW9vVWhWL2dCUXNMc1BUTXJi?=
 =?utf-8?B?N3BmWXA3amUwdjJ3dkpVMmxiY0ZhTlNrZjY2a2EwdG16ZE5GVys3RHdwTW9T?=
 =?utf-8?B?b3ZsVUltcEFUT3NWU29ocWtwZFZ0WjI4NjVVTTB0czBDajhRTSszQStGWnZX?=
 =?utf-8?B?WXhwbDgxWitkSmhNY083WUlRNW9yQzRqLzlGeFV3dGc0VUN5T1BYUDAvOW1t?=
 =?utf-8?B?TEpRaGd0SmFLanlpVkJaZTN3U3F6V2hLejJkb3lXTU1ldEVuSmJXMFR0U0RP?=
 =?utf-8?B?cDVsekg1TDBZYmdWaS9rb0p5T1pkMElTUkMrWHhFWjc2VVJYeHppbTdGZWxW?=
 =?utf-8?B?YWtobHY1OGZpMllNbEkxWnpxcGRuM25qb08zZ3ZvQm9WUUpvWGhneklrMG9V?=
 =?utf-8?B?MW1tU1J4dlFCWll3SVkzRDdhUWFzZlBUdVRYNGhjVm9WVUwzY0dTS3E1b2pq?=
 =?utf-8?B?MHNiMmU5OXNJL2V5MlMzTkoySmJkdjU3VTJDUDZlVEJlY25hQWxybmdCMmFP?=
 =?utf-8?B?NzZGa3VhTVMveXQ2Z0hCaXZsYkhISVlFbXRvcjU0T2o1VlU3am9pUzRCZXZZ?=
 =?utf-8?B?L2xma3dacW13VHpudGMxc3RzQ3ZVbURhUHJyUFpoR1ZhSDZZQTB5cWxPbjh2?=
 =?utf-8?B?UTI1amp0NkpiK25IL3kyZFk0RGhScnN6QVJpb3MwbFI1cFVSbU9Jdkoyb1h5?=
 =?utf-8?B?WHRhcHY3c0VLRTJHLzNYUlVJaDdYTFkvNHdjdWtnK1UxR3o2UHA4Qittbjdt?=
 =?utf-8?B?TnFXN2RwNTNyOTFybGptL1JVczdoUy9nQkNsemRLeFE2T3c1QmFvMkhySmcw?=
 =?utf-8?B?TGRtOFQxODVkckhBeEtGS2N6bEUwTzZ0N0M0UXc4bXhYbldNMWtsT1BNbk1y?=
 =?utf-8?Q?K/HxibaQka2gftj0xu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e56cacb-c300-4bb1-4be6-08df2df03c04
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 14:49:53.3720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCeo6diCmzo+0gG4QW9al42EmVU9iUHIPMz8wGChBAnXmikO+6ShBCH6u7KgkCdk/O6FBw5W4HsurWxBcH0lew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390

On 19-Oct-26 16:31, Alexandre Cassen wrote:
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
> actions on the FDB but RDMA flow actions can. Tested for regressions on
> ConnectX-7 with firmware 28.48.1000 on a little-endian host.
> 
> Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c    | 11 ++++-------
>   .../mellanox/mlx5/core/steering/hws/pat_arg.c         |  8 ++++----
>   .../mellanox/mlx5/core/steering/hws/pat_arg.h         |  5 +++++
>   3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> index 86828e329187..05aa143fa088 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
> @@ -3,6 +3,7 @@
>   
>   #include <mlx5_core.h>
>   #include "fs_hws_pools.h"
> +#include "internal.h"
>   
>   #define MLX5_FS_HWS_DEFAULT_BULK_LEN 65536
>   #define MLX5_FS_HWS_POOL_MAX_THRESHOLD BIT(18)
> @@ -389,7 +390,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
>   			       struct mlx5hws_action_mh_pattern *pattern)
>   {
>   	struct mlx5hws_action_mh_pattern *pool_pattern;
> -	int num_actions, i;
> +	int num_actions;
>   
>   	pool_pattern = mh_pool->pool_ctx;
>   	if (WARN_ON_ONCE(!pool_pattern))
> @@ -398,12 +399,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
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
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
> index 7fbd8dc7aa18..2be7787104e1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
> @@ -49,6 +49,11 @@ int mlx5hws_pat_init_pattern_cache(struct mlx5hws_pattern_cache **cache);
>   
>   void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache);
>   
> +bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
> +				 __be64 cur_actions[],
> +				 int num_of_actions,
> +				 __be64 actions[]);
> +
>   bool mlx5hws_pat_verify_actions(struct mlx5hws_context *ctx, __be64 pattern[], size_t sz);
>   
>   int mlx5hws_arg_create(struct mlx5hws_context *ctx,

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>


