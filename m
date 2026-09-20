Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C4C28315D;
	Sun, 20 Sep 2026 06:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789886403; cv=fail; b=HP9KrgVW9h4RvAnSJD9cl8YsKgWVOututI5qF6Be9fm+TJGNPIvPuzJv/Vv8pGobWJ4ldHLbVEh9vKNjMJvTg9rsBMNBWaGcPjrA0HvXcqtKJOXBEzIs/9zNUks0yuom8eKFvWE3gnaUyaiKBHRnxmttg3KMOs8lr+iVGvjXsUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789886403; c=relaxed/simple;
	bh=KtZ7sOXvKO/W+CFLiWr/4cBQ6XYS6I/UeQdP4cWiUMA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pDqwksRzLv7TxH91KS0kTKWAzaogXlOZnsfmdWT2e7EMEHQ+YZkEbncBmBXYY1dQnu8/sZTaHard8yJ4nATaHxlVIVaABnx+GmaHYSdx945UsfxRXTMb9APDd1mcf8+deXvlds+JVIWFQ/c5xzljxXzFQ9KCEGo4BgNfoHOFIq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WU06n8UD; arc=fail smtp.client-ip=52.101.48.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WU06n8UD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpXGwwgKvx27i5O8eA1n/K2pgwuA/P67X3YFOw9ceFLCiRZhf5US5e+Z3enROR72Zmi0xcb54JJnvuWbdNkGLXEQN72Kx/LEs99FMdj8qZP5KFUureKnFPq52VdFuWMu8VjZzgNTXpNZJenVlaTTplHSxATzRZhcaTlI5YrZRA1zqKphTALlBJjEdkoCOEWjPF6KtgdQS2L0EpvoIGXbSToMnSdLRZoXAF2hY6SN/+yY3h9EhhEuxNj6KrHVvhdRfMLl5QDMUm0+6JaBXoxAucLmeG3KW4dljFC3y+OgZAy8tzMhiQTwhUXYLqQmK1+lAnjmIqqb1FfG5at35YLFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f6O6n5GkE1QoTh0OxPzINDVlRGb+nO4fdOP18w6lwA=;
 b=GTn+QuvnwIEPBrchU1x/DSfxTHRFIjB81iBDMTWlqfA7SDeHK+5Law2dyjy8EMCYX0CaaUjO6LdryNowCaDSfMKR0KS6XgQ6KKDBKEpmvnBfZypbcJk9sAj8pm5sndDTUpA2kKg8g7rxQvjn+He+ZFb5CW7GIwT8Na26keGjQG37McEzs2dhDbwI8vAZAiKtcq0tWVoinHONvgBKXAOidz0lHz/4h/Cp7C6mbJzvC7zzn/iT9GefM79mSYE24wZFEFnQT77KEUss3+TmBSOORdMPhdQImtGSjK/t3rdz5ZYv6Rl0FMd+Dw3CJ3jz19vCKavsCqyw5oJhIBOW7AYiEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f6O6n5GkE1QoTh0OxPzINDVlRGb+nO4fdOP18w6lwA=;
 b=WU06n8UD9kLfM1CEUBInSwJTWJZogosfJO6diIcPUfKRwWNCAwMVo5G8N1kFvnOED7DYCs73hVnbsujy8gFMGPPWEGPZX4F1xwZ7cZv8O/9zDuOdMGyrJomYG7+MisOCljAKbIqnaqQz1RnJRdWu92mRd3rvKFj6ww74eGnh34uf1bo76WNIgOxfoXkTnWQUa/nLzWj6ZeHaNMsrqGWoZOSYfuHdV3/hdGyedcNBFSc8qbDaFby8yUChrdcOATC1KXoGaKrs7MJmcMqze8D7H6ho0uZvH/h8YZ4U9IhO2JcL8mCZlWbvPqleJzK3vrZFx5XJVUy4jvEBSyd71ueZ5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SN7PR12MB7323.namprd12.prod.outlook.com (2603:10b6:806:29a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Sun, 20 Sep
 2026 06:39:59 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%5]) with mapi id 15.21.0428.015; Sun, 20 Sep 2026
 06:39:58 +0000
Message-ID: <53001ada-90db-4623-b892-af707bd08083@nvidia.com>
Date: Sun, 20 Sep 2026 09:39:49 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: Fix rev_entry reference leak in
 mlx5_tc_ct_shared_counter_get()
To: Wentao Liang <vulab@iscas.ac.cn>, andrew+netdev@lunn.ch
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, netdev@vger.kernel.org, ozsh@mellanox.com,
 pabeni@redhat.com, roid@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
 stable@vger.kernel.org
References: <20260917113131.2149024-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260917113131.2149024-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::15) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SN7PR12MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: dd24c942-b7cb-47f3-7f54-08df16e1fd6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	sxdVJeNk9qbkZnyWXNbUFKyJa3wFNpFNWes8SILOtQrn7ppvMLZZJ8kP1HERk//waPi3YuHMACXtAYArBfUqXN5sepk76QU6Di6u4AR7n0t0PKkLkofSYDzt2/u3D5bP2A7vBx7vCh64ScZS7AxHyO2lF3ZDpumQU/nhmlTzzkkt5jNpGZuwDl2iOarElBDlyZUTjqlnZFbbAGFLbQM2Axu/2N0cLRxjJU2IxmSXWRd2fH0hpM3FKvKJ7m2ECik6DqIjBUddyhJpWhbqbactQxgVr2xKQTiUEcBTGDE+GmUa1IZhGKY8KvwyL8mVDLy44w/difVWv8Rfi90/cmc+/F9qcRQ4mxNvMlDV7v4NJHRvuRqa7NJfD6lzLJw2ajjstCiZjhO49CpcobPD7wMEpZus1W+oI0hvYyiiaaPKK+axE6VGIBn2vY+7+hTIArQeS43ZJlWnm3IKkbk+61Pcrwcpr8jiP1cwaQX1EHMN2lJ0Dp0AuAS9CUFvsThKjhi7rvVqQl11CGrJCRxnctv1k8FzcJod74dd1eQHAtWFP4/Tq9Lq0I+Bq38cUNAj92wp0ThdtMVzcONKjIAr+OAISAt3Zt5IwgIHjMExvY1qu7ruWt9CXhhXjQLoOU2C3+4kiAnosEbriDb4QRA6kV9eO2UuGR6sxtzpPLS13uYaKFE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDJydzZaOUJrSlNiZWJOZUdTK2NSd2ppWER4clNFRUlrd0NtdC81UVBnbGFJ?=
 =?utf-8?B?cGJPVkZqbmlQbUJCdTNORUZ4QXpZanQ3WUsvbVVrcXNQeDJvWUhkNXE3S2hL?=
 =?utf-8?B?YnlVSDhNaktWZXFyeTFKSG93cUVxZ3B0cUd2THFzVHArc3gxTTZBZURnRDRT?=
 =?utf-8?B?K2U2UHFrZHhLVzNsS1NiRVhhWXNTc2h6VE1PSnJob0ZJYmtDS3RDTEhrcis3?=
 =?utf-8?B?SmlJSjdlZnpMVi9JOUxPYVY4cUFDcGdrUkt3U0w0ZWdxRXJYVHJvbjhoRHhG?=
 =?utf-8?B?NlMyeTdqTmRKMHdDRCtHUWpuTjJpd0c0SU5ZWFJMb1ZRZXAxditVYVRjUFNu?=
 =?utf-8?B?M0p5eG5udVBwcXBMWXVZVWJpN2RMb2gxRksrREZlc3Z0eDBySHYvTFlyemdP?=
 =?utf-8?B?UThVclIxLzgxMnJpc3ptUllCQlJ4WTNjWWhpTnA2NTZyL2ppazdLVElxT1VR?=
 =?utf-8?B?cWVRQ2dqOTI2VVM4SmhINTRBRVd6MWxRbmVSVnJxbkdUajhXSG11YXB0elEx?=
 =?utf-8?B?TklzRUcwSXorRzBET0FhTDQ5QjVFREdVS0xIZE96VktoN3EyejNLUndtWVNj?=
 =?utf-8?B?RS9KcllXUTI0dGVGaTMreUpJK1hNSWRaSmZyWFRGekNNYTlFLzREYXNjeUZw?=
 =?utf-8?B?QXhibE1SeGN1MnU3S2kyRHJYWHpzY0VhU2VQM0RteFhHaTMycEZwRld1eW5h?=
 =?utf-8?B?TVNpcjdGa3RXYUl4dVVYb1J4VElIQVpncmNHaFBZQjRIMVhsckRsQjBZZlEw?=
 =?utf-8?B?Q2VVTmpWUTBCRnlOYjRwcll2cTE0THJnV3FXWFQxTkl2VE1qZDBDV2FJQXRM?=
 =?utf-8?B?WElnUmt3cWIzUUl0NlI1Y0NVQlJodTVsczBsWERDM09EQ2RNUjBWbHFRRitI?=
 =?utf-8?B?L25JaHcwR29UcW9nRGdyRUUvcmdkZEc2VUovOEN5cUJCUGJyTzA3VkM1VEFo?=
 =?utf-8?B?MGgrUzJPY2Y4UFRhRW5TSzBNU1EwczcyYm5QbW5vWW44L3B6TVRzRVlUOXpK?=
 =?utf-8?B?WTBqRWxWbWY3WUFpQlBFWE1RRHBRRVdJL3NTMzlQQldVSk5tL0xpbGdzQVdO?=
 =?utf-8?B?NTFQV0MrbGNqRnMyM1BJUCtkbTFkVVlsbWh5U2FIdFE5NC9BV05xdFZFaENw?=
 =?utf-8?B?TkFmVGh2RkIxQU9qbEhrRW5ZSTFjOWJCY1Y2b21ydE5QZVg1SXR3SmEzalBE?=
 =?utf-8?B?dTFFVTU5dnUzd1orM1o0ZE5FT2h4Ri9TZmxlWCs1ZXdxcG4yQnVXTE52cXFI?=
 =?utf-8?B?d2J5b29ocUZoaTlUeHB0bzl3cTExRFVrR09HRVUvY0VWM25qZ3JtWHMwUVg3?=
 =?utf-8?B?Yis1UE9rdTk2QjlHa01vMFVWcTZNZTJiaG5qZko0a0c1MWNKRVAxRTJmQ2VO?=
 =?utf-8?B?YmtwYkZsNjRxWEMxVkNWNlovTVZ3TENxQkpSRUFMVG5QemkvMEt0QkE3dkY2?=
 =?utf-8?B?blBURk1wMDQ2MkVOUkRnWmNvT1J2ejdlTzk2QVE1ekJaTHAvTHZPaTNtZWpn?=
 =?utf-8?B?cmFYTEYyeCtMTnRDdm5URUpkQkpZTWVPaDNaUG51aEgraGdDNTZQSGNUbVRT?=
 =?utf-8?B?cW5vUi85WDhuNDVQYjRuMW8yZnB5Vm45VTZBVWYwdXZsVFlYdHV5WGNKVGNu?=
 =?utf-8?B?eDR3aEdSQlFPWldqdUVDSEZrQXp2OGtST2hXTFlyZGRiMWUra0NXdjFneU5G?=
 =?utf-8?B?Q09KUDlDeEFPYkFUdXZRZVpmc2VYSWRRbTJSSFA3dTVXTmxtVmR6RGFjWGxY?=
 =?utf-8?B?WXVYbVVnUGZIZXk4Z0NTT2lOMlMvQWVicERMaXlHWXo3VWlVb200ZWFKU0xZ?=
 =?utf-8?B?T09nTmJadlpmZi9DQi9HKzQ2ZzZLOFF6ejVldEZlQjZERnluWnU2MFNpeXJB?=
 =?utf-8?B?K2FMVitMQWVLZStPdlJHR2JpTHJwT2JNMDhnTnZkMG5mZktVK3JNcWwwOGxQ?=
 =?utf-8?B?M0lrbVFhbXdCeDNrWVZIODJPQmx3YzVyMTdCbEdzSytIWnJTTkQwNVlMNnh1?=
 =?utf-8?B?V3lHTjdUNmtMWXB2bXRhN0JXbnlqYUVFMkVBY0lldThtbnBvTnppRXBPRmhC?=
 =?utf-8?B?L2lpVHU5dmIvakpMb3ROdVdURnovQUEzN1RUYWtnUlhDaUxmNVpudkdsZ2J3?=
 =?utf-8?B?bzdtUXNldDZHNnU4Y3EyT2RxUEJwUWdUcnltM0U5ZkZuUEV3RjNwc2cxZE8x?=
 =?utf-8?B?L2NTckVBWmw2UnF4T3E3Mk13VmJ3Z3htaURUd3hmWi9nVHYzY3FpQUNYbDU4?=
 =?utf-8?B?emJMUWUyNEF1c2I4U1Y2VnBGa2h2OEFBYVdCaldNRElkdEVGRXBSeFZzVkZW?=
 =?utf-8?B?UTdHcTRwSWN0azVCNHdrSi85NGF4NXFFd2d1M0VzWXRJWmNnRlBaZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd24c942-b7cb-47f3-7f54-08df16e1fd6a
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 06:39:58.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTZd7Gi948vGSdBQjZwguZW4DDEat4AUWxjNJ7Li9LDVADB5JXwdmVh3JcnTQrNXntW/y/ikR3Bu2u+NF7poug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7323



On 17/09/2026 14:31, Wentao Liang wrote:
> When the reverse entry is found but its counter is already being
> released, refcount_inc_not_zero() fails and the reference taken by
> mlx5_tc_ct_entry_get() is never dropped before falling through to
> create_counter.  Drop it so the reverse entry is not kept alive forever
> by a shared counter lookup that did not use it.
> 
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 6c87a1c7db09..c1841ce74d9a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -1082,6 +1082,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
>   
>   	spin_unlock_bh(&ct_priv->ht_lock);
>   
> +	if (rev_entry)
> +		mlx5_tc_ct_entry_put(rev_entry);
> +
>   create_counter:
>   
>   	shared_counter = mlx5_tc_ct_counter_create(ct_priv);

Thanks for your patch.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

