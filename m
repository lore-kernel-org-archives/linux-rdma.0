Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF173C0A00;
	Tue, 22 Sep 2026 18:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102256; cv=fail; b=fdD7iSOu9+aj7AUpsfijzrANvvtXb/y+zkKiciCMY+DOunWhOmc7gYroFc027y79xb9f2eIz4P8/KQBBheQXJi7sbt+bRgySa0y8VhimuZ3fscZwFBWylWRKCHF8QICBcKFUC3pMy9IhrxNzzSEK6uTmlfPV7umeHDSYxVB3cFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102256; c=relaxed/simple;
	bh=3hssyeeJfnLMlZV/PW9X/t+eys+qZwdLpLMV+PsTh7g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i4zn4AUP6mpNSHiFww+L/4MjzWxcTo224SGx+M/DIMVmnWLKVGHvl4MyzlpewuB7LrF7dZUR292xOv0K3NN9wDQw/xCM7yJnUSYBOUv4ALDaVi9k4XCiYU/ffD1u7adNekdOf9ydCS8nx6dWKioW1AyP3BfD1/K1m4Sp3XY8Zuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jotu5Jvk; arc=fail smtp.client-ip=40.107.200.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jotu5Jvk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qTPlFCI+Rl928AlIU2Fw219j7B2S7iX20E7AD1HZt3BOPF4C7sLFeyCeURzpzG4j0TCDVKWwDiggK30BW2UDmYo1lBvHnsmIRK/vXzz1tylhQfJv1ln3t8VjhECvO52jVxJx79XrKdObLry+xsFW/feSP/IOn4+q9vuj/sNQuKtfDy3GE0WXJ1Ax0Bet3hNFiFoekU7WBN8QhIRfcpgOed8FP8GyMEZZxE5QtxDScJOosTI4KJfilD5hsyBCRgJlnjUdSO+rnRIebOqcY4h2W22ShyW7xZeumEaJk8gbDyu3ADsXfBIzoYl8T38L/cjPpTagNwCm3CO91q79UiWpGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXs7RcrVZ6aKZatAq/YOwWd7rdl64xqH68XAytsYO28=;
 b=eHyclkQkLUeOsjjfBp5Oq2NsQsPUJl7fvfwU2NDFaAXN6u0FgVLAqGK5IwOVkDaBOb2gRkc3JfUv1LJqCQd0adJV8q70Kk678Zk8rGREnrdAINzo/FXFjOjc9Nlw64e43E/EH9uEIZzfHv2PBdXZLcfdv/syf3qHxrh3aAfoLz8QgGg6siXSOcgWsFE6GlsK2EkhmFEHl4RExfrSBtaaXCT8us6bGucrSaRbq2D+AhnfQFHn4I3y19qxSo0JfEQIKP3BotBe54pBLPJmbNg+qAdtzYIqcEZ517Cx/q3fSGtMZkjbvwSHwa+7sS5iVRgh9ArU0U6ZnPQloSfg/7Bgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXs7RcrVZ6aKZatAq/YOwWd7rdl64xqH68XAytsYO28=;
 b=Jotu5JvkPRSd6HvG0rYJwZsEBOtXBLfGMJTYfHKZTc864ucKu0AGtznwcG6ujs4/ZS++/CASXy1q/7YXFXriA23VQbXIArU7dcYkKdY2SHRWE/19Quy5cyYrLko0VH/mTm92FIhnc9yI/ZpaaoppztQ+nFAUIcUogfyp45kVR0iLfcrQYrNCXrKaeHLjvu99dYnBsKlBxw0vj6yVRHPkvIKk4sdiqo7VcuUrD8EGO4qMLRORP5DhFgqLqcp8aIEKx5LoAcryhF4LEcezxF+INx2eJ5hnCTqsVbY9nAPj5iU+GcZwL+QtzNwLuo6vkkF352/lqZgI8IGKO0BqDhZl1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by PH7PR12MB7209.namprd12.prod.outlook.com (2603:10b6:510:204::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Tue, 22 Sep
 2026 18:37:30 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0451.012; Tue, 22 Sep 2026
 18:37:27 +0000
Message-ID: <188aa61d-ca17-4888-85f0-040f7857be88@nvidia.com>
Date: Tue, 22 Sep 2026 21:37:23 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Fix slab-out-of-bounds when handling team
 device events
To: Anirudh Virdi <avirdi@redhat.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, shayd@nvidia.com, ohartoov@nvidia.com,
 maorg@nvidia.com, linux-rdma@vger.kernel.org
References: <20260922135123.46205-1-avirdi@redhat.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20260922135123.46205-1-avirdi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::17) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|PH7PR12MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5601cc-f9bd-4a66-2209-08df18d88d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|6133799003|11063799006|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ssNTra/28Vjtr9GnSm0aTNEYgTKlwmDe9bpJIHOotViJd867GkxXtZPq65pVyIJjmWz8WHOl0nlx1kdcUlI88Mxs1rnRm7nrILvsR5Durm1wBqzQDIhlE0015L8R5T1OvauUjdNg4vnOpK3tPIayE36PDyEEoxvD6LwIpFPj/idWAVPLhH/3GSEYEtMTNKHY4ZxwEp0BaYLckL0elh/O781fvK8kw+mk96OykDZM2sEoLmW3JDShFu6gUPnZc1RRla32NBdtFAYYm09/IpNonNjCCqK7qxuRURMZt9IqO5wqc2N42Xpd3nQQEvaCCTwwKeuzDDTeP/Gr08YPlr/Nw26ODrG8lByNSWNEJUM4wr2agCLebHVaRINTiM13vkn/wGHRnoC6v3L8jsn/nnrwtxqHodvjFlF464VsGaz+c1c7lfumc51xBjpjjlFppCoLcnEpdjnUpTNwBdme+hlFNNbYJgIhwOMKOmfPSc5yFRUgjcLB6StKb2ENYYP5/+jX2eF1EfPn4nz/4yO8joskLRd8ZX+JwpVdXLTEkHiTxp1FVhI7emzNSS+0IbDU0O+kyoqgcldgluw4CVcPHtYSE4WgcK5By1QUzINUP8cWlE3TVyY7Nh7cp8EgNXLcUUXmSd1+2PuXSfxRIB5Y/pD7mV0etaRI5aaRuceJKR/jz+c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(6133799003)(11063799006)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFlmREc1MWZZRmE0VkR3S2gzQUgzbTlrWkVoY0ZyN3VETkNvMjZsK2lrTWVD?=
 =?utf-8?B?SW1UTVpHalR5OHE0RVBMdnJHcGJTSjNUYm0rZXJ5Z1IyTXE3THY5L2NuemxY?=
 =?utf-8?B?ZkVKUmVPN1VzSk91cVVOcHkvd0ZxVXBVaTFrUHFHd3RDTldYZ1JzRi96T0xy?=
 =?utf-8?B?ZU5UQitYQmwzei9uZEk2NUliTlNxcGFCelhqdzkvMVVFL3FkUVd1Wjl4M0Jm?=
 =?utf-8?B?VHJ2WkQ1aldtYnhWNXNoM2sydTZUUmpoZlVaVno4NXlSNHF5TzlzcC95MnBR?=
 =?utf-8?B?V0RKZGFHWUZmZ2FzVXJsd29hWDBKOWFPUmVUYkM3ZGoweTc3MVdGR2J3ODda?=
 =?utf-8?B?Sy9IMVUrK3Ixb0piVi9RbFRJRDFuQ1NYUVZOYmpBbkluZEhxU1llbDBtQllR?=
 =?utf-8?B?THB6NDJScE13VWN0UmQwZ1UzT0I4NjhtQWVCazJZVVJpOUltOUFGL0pzVlJ0?=
 =?utf-8?B?TnFXZmlCT2xqMHZsN3Z6b29aVmZGaml4MU5jSHVMVkZLUDNuQy8wWERCR2RS?=
 =?utf-8?B?bmFLd2YxK1BlU3lwc0xQMGFUZkwvNTlmVmpiWXJPM0xPSVVEQUtoVElhYUpS?=
 =?utf-8?B?TnR5L0dvUTV2elFDWlI0VE96TnJiamtqak5WTzBrVTRaUXBLWHhTaEVCaWlW?=
 =?utf-8?B?UVBJYXExVjR0N3htcDNVSFpOWFRXRHgwM09YQmQrcEpPSHNiaENacUtGV1Vr?=
 =?utf-8?B?eXpDcHBtS0hjVm1LczNzNGNVL0dBckpVcmhNaVV2WXNhRitGcHdqWFFOaSt3?=
 =?utf-8?B?WWx0SjlaQXpkeWFvQW9MOWtTQWFka2JKRVFGbDJTTVh2bFJIRUpUZjRvbWZ0?=
 =?utf-8?B?WTdJWEd6NzI5b1g5L1F6SXNOQU1MYnFNYkZWdVNBSUs1N25icGVka3VvcDA0?=
 =?utf-8?B?UUpyT1ZJYXhvUTZkN2RHcGpOaUlIMHE2T2EzRGdVT1ROZS9RSXJ0WUtpWUZV?=
 =?utf-8?B?OWpvK2pGcXYrUytwRTByeUVOV1dCQ3ljeFA0OHhOZDVvRjZEZWxYVmRxMSty?=
 =?utf-8?B?b0ZSZGtsdUxidFRRbHlRVVZLajMxYzhXSWZVellKd0FPZllhUUFmaDJqN0tz?=
 =?utf-8?B?UkJmekR3VzlSMzdVVFJWZ3BNSUhKWVZIU2tweFhPeUtqUGpxaWlWZUZycU9I?=
 =?utf-8?B?cWVUdXBlaFlQMHhlcnhhWFNMbXJaR3o2K3RwS0Q5dnE4WTNsNERUcVFHMk1C?=
 =?utf-8?B?SVZrSTZrVDZaOVFOTUVJek9rYVFZSzVRcTBXenZqZkVqWTIwblZPMWc2K2VU?=
 =?utf-8?B?aDhWdFFrQ3hFWElHUmxQdU9IeGtSUVo2REhseWpFM3A5bHNpdlZWcnVWSjhT?=
 =?utf-8?B?eTlCNG9mQXJEUEw3bVJJL1QyN3EzMjR1cEdKYzA5cXcrWHVmRmtHSGU3SFBJ?=
 =?utf-8?B?NmdiNGZKaEd4bnp5R25GRVR4T3N6SjVPbVRuMTJiT3pra0pKYU9oZnNPZlBB?=
 =?utf-8?B?cDF0WkdDSkd2VFZiVXN6ZGoyNGJyTlV5SDhGNzdVSmQzc0YrWXc5L1NIZUVN?=
 =?utf-8?B?cmZkVEV1TzhNcC9BZUFxTVoybnpzZkF3Z1FOTngxaEhJNW0rTnV5bUZrYzVB?=
 =?utf-8?B?ZnorQVpsaGdPa1h4OWM1dDdpbjI0YVpxMW1HczNkYXJkUGZhcER4K0QrUng0?=
 =?utf-8?B?WG9OTjFhOU14Z1NvTEVPRmtNRDdkMENrZUVic3RMUS9UMlR2NStGc2Z0Q3do?=
 =?utf-8?B?TzVCWjBCUUxkZGc4Uis2U0I1aTlYMGpKZ3pzbTBoTW9pY3FTemJLV1RwOGtE?=
 =?utf-8?B?bzNlR0JvUkp6dXF1SnArSStEeCtYdThTaTMwazV2dzhSRTZjOU9tYzhRcURx?=
 =?utf-8?B?NFlYbnVRQmlzUlpwWU5IOXVIbHhkOWMvd2NhY3A5S1lXT3k0MWVYWnJhUHJV?=
 =?utf-8?B?MEcreDhMNU1iWjk0QWF4T3R3R2t6ZWVkVHdkbWREK1RMN1IwSXk2L2d5QXdz?=
 =?utf-8?B?dWN4Y2xQNk5rYnM2N0g2YVhnQXkvdGZMQkJab1c4VTc5cFZxSjJtKzloc2xD?=
 =?utf-8?B?dGJUdHM4MEt2aVZjNWV6OFNLRUp5TmloRlN3UW8vYVVpajRGVVN4R1J2czNB?=
 =?utf-8?B?YUVJQXlsUXF1eXVCMml1dk9RR2VKdktiM1dMbWhGTUhNZU1wNkJJVzhQZWFz?=
 =?utf-8?B?MWV4aVc2VHlPOUZnLy9nN2NxUlhzQUE0WEhVRWYvSGcxT01wSzFtRUpUZnNX?=
 =?utf-8?B?TTVoWDBOemdZWGZRb2hxc3VDSXcydFpWczFKMFdhV2U0eTh1cDJzTEpZQy9h?=
 =?utf-8?B?dVkrb0sxd1dOVndRdWlJRmlKMFVWL0s1aDN4cmQvd2lSRHBCUTNuUlNlTllB?=
 =?utf-8?B?SjhUZWtXN053UGpIYlNWWUVCSTl6YjV1Q1Bob3ZVRUJFZzBld3d6UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5601cc-f9bd-4a66-2209-08df18d88d4e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:37:27.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TE8+6KcsfUQu5co03ElJQRR/29WqdONLIr27TTfx+BeytsWlY2SRaN8UHEb6S5hKTdpB++nqUQaaOJRodPJnrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7209



On 22/09/2026 16:51, Anirudh Virdi wrote:
> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions assume the upper device is a bonding device and call bonding-
> specific
> APIs like bond_slave_get_rcu() and bond_is_slave_inactive().
> 
> When a device is enslaved to a team master instead of bonding, the code
> attempts to access the team_port structure as if it were a bond slave
> structure. Since team_port is smaller than slave, this causes KASAN to
> detect an out-of-bounds memory access.
> 
> Fix this by checking explicitly for bonding devices using
> netif_is_bond_master() instead of the generic netif_is_lag_master() which
> includes both bonding and team devices. This ensures mlx5 only processes
> bonding events, not team events, preventing the invalid memory access.
> 
> Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
> - Bonding: PASS (no regressions)
> - Team device: PASS (no KASAN errors)
> 
> Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
> Signed-off-by: Anirudh Virdi <avirdi@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 28d16fdc3f06..022a69cdebaf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1897,7 +1897,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>  	int changed = 0;
>  	int i, idx = -1;
>  
> -	if (!netif_is_lag_master(upper))
> +	if (!netif_is_bond_master(upper))

I think blocking teams might not be what we want to do, what about

@@ -1923,9 +1923,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
                      }
              }
              if (i < MLX5_MAX_PORTS) {
-                     slave = bond_slave_get_rcu(ndev_tmp);
-                     if (slave)
-                             has_inactive |= bond_is_slave_inactive(slave);
+                     if (netif_is_bond_master(upper)) {
+                             slave = bond_slave_get_rcu(ndev_tmp);
+                             if (slave)
+                                     has_inactive |= bond_is_slave_inactive(slave);
+                     }
                      bond_status |= (1 << idx);
              }

I think this works better.
>  		return 0;
>  
>  	if (info->linking)
> @@ -2004,7 +2004,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
>  	bool has_inactive = 0;
>  	int idx;
>  
> -	if (!netif_is_lag_master(ndev))
> +	if (!netif_is_bond_master(ndev))

I'm okay with this as mlx5 doesn't handle state for teams ports anyway.

Mark


>  		return 0;
>  
>  	rcu_read_lock();

