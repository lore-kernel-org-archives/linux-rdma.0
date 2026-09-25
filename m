Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97C4052B3;
	Fri, 25 Sep 2026 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790321633; cv=fail; b=dMqmnlXZwqG/TpffsGpNbdyX0oFgvkQ4QasoRrBqORfvHyic93KO4dEYIoVegTE0GlyE8mHJE1KVveFKtOc9q1PF3gtiIullwSCljRWqGuss5YYhvrdaBTE8SeMk/oT15DNI6fgULldYz21vgGF/5PG/iupMxv2a8Z2nXxLeBOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790321633; c=relaxed/simple;
	bh=U1RiXBWJU6rot4AxYsYRwtLDRIAMLm94D5bOupfilS0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eHQkSOs8d7wM38G+Vb6E3wNwSs2xzoPVZTzA2b6Ai8dD+nBTkIz9wSmWy2USOeKk9nS+Or/BzHfuqiwQsSxFTjDV+8/aTWMHvcJyTioGGqi4mOqPa+XXOyLRvFX7cCSDzqukrSz/HghwgMmN1rqwXeNL2iIRZ/LPY2x67gTSx5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OKUSNnRp; arc=fail smtp.client-ip=52.101.56.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OKUSNnRp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnDPO0UtG6KiQ1VXzY2BqcEOP3K83Xy1kJeRHgS2+dGg5kFGMvwKLpGMcvNHCztzWnwdJf7zu8TXzglTU4vtO0JQXwMUgDQcWU9Ze7v1HZ9AqxWM2X34gSSxUl5PuGsIRKCZZ1bNjrKrLt5a1Q3Yk/O37EdnNmefJw37aDwa+EkwLRbpVa73Q5NisJcZIAsdSqFiRKxQf8PzKuGnHuZgDAzlMRDltCD92sCNGfpDdFdmdb2UzRSIVCaH9Ltlq1ONNLta5XAZRLyd7L/W7v5GKGd1i4ff51KvImZO4WQd7iMLLisFViCF497mgEeqTnxDOyptaW3Rhp+DJnPQvsS7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6ZnOSCY82e9/HdCeA3Idq9xX+qIdx5bpVXcJ/Meh44=;
 b=ilIcK2dizloC4UuULWuZZSgGOW89Oqzb+7g2v1Fbpucm7qBwCDv/MP6NvWwlZWuvbTdTuVIcoiyd7BwunwxRA9StJOwXoSwnuRGQ201eYpjYQE7MwgacM84Yh0Q6atJ6/Iw3lBnFb86oESLhlCLJqDgBR/Xc6oHDJ1Bbuk4MQfrD99nmnJbq25iUoowH7/pqtrYHq4ta04ruFFSDvR/X4mf/RjI/Isuzo87N/0UgDSZ2IC/e3pEft7SukGpIPeCH12j8qwPz5RLKdq1KoA8V9MB1lgB3O2xYUQ8Nik5cFArev4CbncZc5+Xs6vCV9lCDMMXcar9VocDN28YYG9U3zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6ZnOSCY82e9/HdCeA3Idq9xX+qIdx5bpVXcJ/Meh44=;
 b=OKUSNnRpx+htpMbQkR9bgocbFnU6W/bJCVXfP47KTWFIaFxUm7HjIbyzTEt5FcdfvNT7vh6wYlXStydjX0bZHMpRxzKsZJ+C/wPONRRNPANcgMgCFo5wDbGzKKVC3KK52nS+QCpIqS2tndMwx8sdC2xvibi0LinPao0bXutjhBDHQYRld/uHY9NwF474dKKk0nuu/OvMUCQZh4EowCh5RfUKuUgFsgLl9EVjKW8MU2BoFXtVixpFrBEmVlezt6ly88jFPAuasEgS6gTKwMoW2xXQOSyRp7MdaB1j4KImZ7noia4hQ6cgxm7ZQignvf1jKSjsJGZ8GHXoadpTjQ5poQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 07:33:44 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 07:33:44 +0000
Message-ID: <40b93490-8d9d-4efd-bd4d-0c3a3eeaa869@nvidia.com>
Date: Fri, 25 Sep 2026 10:33:38 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5: Fix slab-out-of-bounds when handling
 team device events
To: Anirudh Virdi <avirdi@redhat.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, shayd@nvidia.com, ohartoov@nvidia.com,
 maorg@nvidia.com, linux-rdma@vger.kernel.org
References: <20260924064244.94045-1-avirdi@redhat.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20260924064244.94045-1-avirdi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::12) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 79bf46aa-d9f7-4230-732a-08df1ad7540c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|11063799006|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	zKiVJSzY0YQUefgEuLxJO5eh80587rmdGlMOSyr8VIO/1/2dUw+cBDN4TlWolQ7gT0k6IYN17uAegEcFFrgIrrlVcbMUasElDwlLlxSXsyt+/NvCDNcMocHBducKzg5L8RyPa20sb7PTqb30Yz7ctK8NxOZiJVoR7BDqC4LINCqCDzTiOP3fOXOW9wmaaW3lpJ7O1SrFGdKC/R14riXJ4sEOlNDAsam7mKBWnwomVW1p2mDugSNhdMQyffceLJzg3w0tRtCa97934RuavgP3Bl5b9/ysiiDM9lKLAUZjq7wLkYgjJTJYksHXwKbCO+8UT+DgPgf586key9M4iHAKsPWzB5jjgnbc+cWOa/VYQ49XooA0mlBiiIIHvbWJ1dwdMYxPzzIoX1PwEsSYlioI2LbXa3Y2XQbxhUtAqbuNnhXxDun22KDPRCoFErLio4xyoqo1HN1OIU3X16SLRzjt4UmQadK+IOVkqdrkBPjyJollHZoyFKvGVsYawvwbY9Aee6QZGN+bEeXMgGl5q4HUrZrI4ftZwMuek3Q8+/BLAKLwpokwk4xAZE5vPVqiTl0dZPb5IZBsVGdThJDNFHAXhAUWsGMQ74LQDllCV1FadLUrutOQlnOwdR8UXMyJ8v3x/e287Qutv6vSYiUPPLVALf7+P37f8JshCW7RjIoXTg0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkxKaGs2aHBGMDBibEtKTmJtWFo2UDNXMHpKQUcxNCtxcHRBQnN4NUtUMFlB?=
 =?utf-8?B?SXpCTU4rMmp1WHJSR1grT0VUZVVjNWNuTnNJMjZWM0FrVmtjNGV1VU1BUEkw?=
 =?utf-8?B?ZjZnVUd4dHRHVzJoNnNjVFF1RXg2ekdTYytEVWVOWWlwNXZXSFVFNkVZQi94?=
 =?utf-8?B?MC9LcjMySzNMTHNXSHVXdzJLdXFwRllPeE5MQmx4dlR0L2d0N3djTTM2Tksy?=
 =?utf-8?B?NmlWL0JUK0w0RjJwbnVLcTdJYnphSkJnQ0JKd3RhUFBER1dGNENQYWdMK2V2?=
 =?utf-8?B?UGxEUlQvZ2VHd1dnZzhxRU03eTdLcHlCb2ZDb0MzUVRydk4xRHo5eWlxZHR3?=
 =?utf-8?B?RC9VbWJ4UHNvMGNIZUpWelRUVWJQbC90MCtRbVhRR2JmL3hyRm5YRUtuZlg0?=
 =?utf-8?B?L3ZiMDl4b2JTRzRISkNSYlozZXpMcjZTbFZaSFhMWEw3T2lydHRUR1RaUENZ?=
 =?utf-8?B?WnQvSnM2UGFrLzVIZnZZUWl0akdBeXgwdk10WWQ4Z3BCRnZiRUNYMmN2QmtY?=
 =?utf-8?B?dlpBMFRKQW5LRzlXbEU5Z2VjcDhqRVl3NFR6aEtNM3AzaC8zSFZJSUJPL2t3?=
 =?utf-8?B?TVVVanJzd0g2Qmw2YVpaVnpLalRFZUtTN05tUUJEczZ3cGZYQUVvUmpCa3NY?=
 =?utf-8?B?Znh0RDBRVi9mcEdxSEQ5QVphZXRkNDFjNkhGUEMrdzNxRWowT1B4MFBLSjdP?=
 =?utf-8?B?T1Ixa2tCOTF3OE1RZ3FuRGlmVW9naitYQ2ptYkRyNjYzSzAwTDdvV2tJUXZC?=
 =?utf-8?B?V2NmKy9KUHBMYmRldEgyWFFORkVnK0s1VTUxSWF2VFJhcTBIeC9QM1ZyTktk?=
 =?utf-8?B?Yys3a2FtOFRSTk5yT1RQMFF5Y2JPTExySjZXQUJVaFZqWTF6OWdiWnh5cWkr?=
 =?utf-8?B?NFphZE01SVZqQU9jMG5LTXhxMTRUNGlwbFVPTDVIWWt6NkdpNXhMbDAyTStG?=
 =?utf-8?B?UTZWTnA5dWY3MHFBdmRtSlpteVZEWlJ1WU8rT25nRmNDVkxtdlpmZ2tBWlZV?=
 =?utf-8?B?L0ExSTRWTTdkR0ZXNUlFTXdKTWt2czZTbnEwdERwNGhlQnREMkIvM3c5RFpG?=
 =?utf-8?B?OEZKUzBhUXNKZDNMMm4wUzNsSmZucnVsc2gvVUdpR1hTWWZXckgxOFBmMkQx?=
 =?utf-8?B?akh2SHA5ZnM2clBhb2g3a1M0VlFoQWY1blBlY0NFdnkvRlMwTHhoK0gvVVNv?=
 =?utf-8?B?Y3lrNVJtWkZpOHFoR2Y4aUdncjZsYXpzU3Q5L3pkaWhmVkdBb2Q0c2ovK1p6?=
 =?utf-8?B?Vm9PaE9MZXNkcGk1UStaNG5LNDQxR3pkcFhFL0lERWIvTkZBQ0NUK29vVks4?=
 =?utf-8?B?ZjAvRjN6eGtpdXdJOTdndHBSZ08wZVlVZDBFQ2RpU21mcXN0TWZ3a0xKQ2s0?=
 =?utf-8?B?K2Uxbk4zTFlqMHFmV2UyZ210K1BYZmtVTjdMMzNrdnlqZjRFaVlWeW9LRHBW?=
 =?utf-8?B?cmVGUW1kWCtRV0JaMTF3QnJ1MFRYSFRFTVNTUW1kbG1mUXpOVFUrM2tNZGlz?=
 =?utf-8?B?dUFROUthN0ZuR1hNNGd3NTUwQkNiL1lNZi9ET3A2dUNJek1MdWxiNGx2b1ZF?=
 =?utf-8?B?M3A3emdIRUVTemJKQnRtY2VaSnR3TWhHYlJURDZ6R3FmVFRieXpFR0tmZW53?=
 =?utf-8?B?V0xYYi96c0NBeXV0RHljb2ZOK2RiVjBmYjkvWmg2UnAzbmh3c3ozcTFTdWY4?=
 =?utf-8?B?VW9scnY5SCszL0VZRFljV2ZEdEVCVUlxNGtrMXQ2anJGZXdmdWwrdTJYOVBC?=
 =?utf-8?B?dWpXQkJSMjJiUWFYWkV0aGR0ZzdJT3NsdDNsRGFoUnNkSkJqMzEyTVp1K1I0?=
 =?utf-8?B?QWJpVitaeW5rSUFnNWZpK3NZUVFEQk0zSjU1bGVYMnFxcDVFckdDSSt2WWcv?=
 =?utf-8?B?eUlJQ0ljQjlGYzZNNTNKUUJNUjlEMXEzK3ozZ0NLQ3UrRGY0d3VNaW9JR2Rz?=
 =?utf-8?B?b3JtNng1bkRvNnBNQ0RjbnVUM0dhTTR0RjZRVUVyWFhXaEUwZWkvT3k4VDM2?=
 =?utf-8?B?MEwvTmVvek5Hd3QxZlN1VDRlbzBIY0o5WUs4V3RPMWZqSVpMRkpnRnV4ck9w?=
 =?utf-8?B?eUZoYm52UkxFSS9tVzlVZGh0U3dQZzhsNGF3WE8yZHBVRERzcDhjdmlLeU5j?=
 =?utf-8?B?ZkV2THVqSDJXRlFhZVNDVExzdnJ6V2FXV2pJVDAvUGhwNjRiVUtpbHRHQUI1?=
 =?utf-8?B?RjRGTmpETGxiK1ZaY1lpdG5IY3JtWlk2VTNrZmJSR2UyUVFRZWNEeVJzRkpy?=
 =?utf-8?B?NnN6WEJLK2QrczZzd252L09XM1ArQW9sWlB5cURYWWs2eUYwQU5CS2gxNTBq?=
 =?utf-8?B?Rkt4M3dtQ3E1VHlGdnc5anJOamVXKy81VlBaeHVIQUk2b3hnVlU3QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79bf46aa-d9f7-4230-732a-08df1ad7540c
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 07:33:44.3388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urp+hCyY2zf88tZIBhTDWfW5Khh2YW2g/COvZYzf34V/YSZ1Fr41PrGkBDd4E+6ftVwqoh+1tVUvaBRQ5PbXqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263



On 24/09/2026 9:42, Anirudh Virdi wrote:
> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions check for LAG masters (which includes both bonding and team
> devices) but only call bonding-specific APIs. When processing team device
> events, calling bond_slave_get_rcu() and bond_is_slave_inactive() on
> team_port structures causes KASAN to detect an out-of-bounds memory access
> since team_port is smaller than bond slave.
> 
> Fix this by wrapping the bond-specific API calls with a check for bonding
> devices. This allows the function to still process LAG events for both
> bonding and teams but only calls bond-specific functions when dealing with
> actual bonding devices.
> 
> For mlx5_handle_changeinfodata_event(), keep the explicit bond check as
> mlx5 doesn't handle state information for team ports anyway.
> 
> Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
> - Bonding: PASS (no regressions)
> - Team device: PASS (no KASAN errors)
> 
> Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
> Suggested-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Anirudh Virdi <avirdi@redhat.com>

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

Mark

> ---
> Changes in v2:
> - Changed mlx5_handle_changeupper_event() to keep netif_is_lag_master() check
>   instead of using netif_is_bond_master() at the start
> - Wrapped bond-specific API calls (bond_slave_get_rcu, bond_is_slave_inactive)
>   with an explicit netif_is_bond_master() check inside the loop
> - This allows both bonding and team events to be processed, but only calls
>   bond-specific functions for actual bonding devices
> - Suggested-by: Mark Bloch <mbloch@nvidia.com>
> - Tested on hardware to confirm both bonding and team devices work without KASAN errors
> 
>  drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 28d16fdc3f06..1c4107d9a408 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1918,9 +1918,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
>  			}
>  		}
>  		if (i < MLX5_MAX_PORTS) {
> -			slave = bond_slave_get_rcu(ndev_tmp);
> -			if (slave)
> -				has_inactive |= bond_is_slave_inactive(slave);
> +			if (netif_is_bond_master(upper)) {
> +				slave = bond_slave_get_rcu(ndev_tmp);
> +				if (slave)
> +					has_inactive |= bond_is_slave_inactive(slave);
> +			}
>  			bond_status |= (1 << idx);
>  		}
>  
> @@ -2004,7 +2006,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
>  	bool has_inactive = 0;
>  	int idx;
>  
> -	if (!netif_is_lag_master(ndev))
> +	if (!netif_is_bond_master(ndev))
>  		return 0;
>  
>  	rcu_read_lock();

