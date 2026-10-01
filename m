Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E613932C9;
	Thu,  1 Oct 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866151; cv=fail; b=eLwtghkBfx1aCBHU6iFZQDFYYTfuVvfcwqmBuLNR/B7aNn5gkIb6nsgjKMeIsoBwUazQC/qdOwlvtwbcPSlsPacOtUyAkSNtVQ1Tf9/MQXFU5mcmPPx3fg5avmtQNqZLjBIy/ZeWJniboprVQ/M9t/v5SfZCDyXcKIIom9sAQGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866151; c=relaxed/simple;
	bh=bbhpZBg7ikzFc7Tj7PIaxOTy6i5x0tnsPjMZRv8W8W0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ua25LxeLWalLECAf2UbHzkDJ3apgygqc2o0s7igVFfr6pjRydQCdwZOIM2ebkXkttP/vV3/GaXmCsWYL1hThsP7vspeepfqQiVcDSQbWRE0PWhjcsGsPxHbkoLCWSda7ELl+uCTV9YqDYeDGX/00QLp+zGNmYiY87kP7d1rNG0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K/Mub/x0; arc=fail smtp.client-ip=52.101.53.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K/Mub/x0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6+k0IvZJaTnJJ56oV0UDQSU0SABixTbQn8aFqCFVMFSRvZY2NDvLXkqMy11WKPV8au3W2YkhQgfUHpSbNx2OvtxcpGjrFG1xXYwOQk2hoy8tWuorL49bz/XfGo3/Ces+Ag3UAQCIf/trDL9EO0HWK7ciXoBWvOcIRyPUKCio0KDcJKHqKNayKQEikNcRekQBOKqycxYUNbRZ/7OKiM8OUv85EcRzb77JObRhRAGC6yKkhkJcAy72ndmKM+KOa7ZFgf4Dtz2KltQAVVSGXp1slrMSa5BiuYYTgmFXppUsqobK66jy+dBo6miD8JfyCYjpB5qh2XX2TAtGbcl+lW5CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bpu2Rpka2LHPp5Sc01hjKZl0TbpXJxMOVMlP9AJoIk=;
 b=EksmLx2lVbs6+nrYhz9F773pEheg2fN4giIMTYX+PU/95ql7xutYrrroMkGbhLPiSydcQOpnmjgOWs83GqwpG0TSfvfAiNmMJmClmB/2+ChKcLs+H2uXmRjjKcScZIhABUIgROMIMhgP37or4ZxgoqoB41NpS7hF8aWnKFVbfCwsODjN0zpnnAVnNrCNwSGUr0WhtqX5VJGX+O616aaLfFr4dmro4oV2YaGqJsoGZPVD2xUD5GjdBiDADuFn9tblutabC+hRAqV/z91Yl2BSnhSJNVa/RNvMkgijO6wTsPW3fE+tTQZS05Vmd5ifwzZmwnuXLkhJqr7RHrdFTkxc5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bpu2Rpka2LHPp5Sc01hjKZl0TbpXJxMOVMlP9AJoIk=;
 b=K/Mub/x0kXdnYDnLubeT2HJdgs/WuHNjWBVlSNRsZGH4cjw09y0yeL95/CE9JoJ+vttyx2OYzFQtjJxWoTe73GrzWcMG3rB/LdJTZkYOywY5fRS598wPuHFWVfM6jlxIIpvH4U/qobhyaL4n6NLhkO1Gz6ckve3jp0pkaKqejN6ydDQQmuJYVucx9qYwAMD61+O2ZGUBXd8E932uApvaxdoYb1dDGpz9emeH3bZCOCgGleEskB2Zjvvrs4Lhzs2YVFINw3WVydZPnibXSJamMFhZKrRcp4iFlWvcxJ8+jNYBi2UGJSqgx9Z6r49Vbgem4lPYX+7ano9hQpxEmR5ovg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by DS4PR12MB9612.namprd12.prod.outlook.com
 (2603:10b6:8:278::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Thu, 1 Oct
 2026 14:49:02 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0451.022; Thu, 1 Oct 2026
 14:49:02 +0000
Message-ID: <fe3cddf6-17e2-4f78-9944-ba723ed15fd1@nvidia.com>
Date: Thu, 1 Oct 2026 17:48:48 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/5] net/mlx5: Lag, reset vport speed on teardown
To: Jakub Kicinski <kuba@kernel.org>, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 netdev@vger.kernel.org, pabeni@redhat.com, edwards@nvidia.com,
 gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
References: <20260910102432.3845360-3-tariqt@nvidia.com>
 <20260915015122.875353-1-kuba@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <20260915015122.875353-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYPR01CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25b::16) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|DS4PR12MB9612:EE_
X-MS-Office365-Filtering-Correlation-Id: 89eaac1f-f048-47b8-8c25-08df1fcb2232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	ffOjGiKtrmic1cLIJs0Jt0iqDvYIFRLd0mhxgbv+oqWItCh4BYhZFpiBciBhZLWNCaOiXHfs0B0Ebqh7yx1kU4UrDcsQs9AsKGxZJ5hVWikNyXm/Kt82F0Ka0bUnTkTVegV/JnxyVq65FTUztegYmdoxrch3I03g67XZW0EvEzugR6HXxEplj6ClQfA3UHOzimbeTS2ZLqrLTdk5GZmokqY3WG+Kav9R2qwumAHoiRcR+tBqIzs7yB5eHCttfGVtQAGnOMMhti6BdUrKfaTyuKRh4SYQQIwGh/S2cKL0v0yAjQm59ahOiz54rfs0xpAinPO1tRyD3l+EVBNZmAm5OCeqxR04/G/BjdBuQUNQYJnSuLANtuKj/3EKLTs0o/rNBh/BKo/+ZXeQwIgE6AB03NSPKOEyO7zbestAZaMt0J7cI7342fKEXzvSqH3H86sn1DVe0VAKfLk4WBKq6UxnjSKbmv800RDj1ic2tB/4tijuYJ/JgI+89w2yOFg9D9MMkw5iFV14IqMwQbnPye57yAmwHcCd/IdGiDWeTy6w2ZLEnKb+dbX0BPDaZmjGsGwvH/FhaGiUIyqpoKhjYKSjjnLUfqhgz/3uInfIzYUaMHI/8AWAOfbrMjdAwADKL5gBoSjiyVKgm0wL8S6vqdiHVp6FmVdbBTc8Sso51a1iY+U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eU5FZnBHRldKSzF5S0Q4RGNxSTZMakkyMUJtMElBZ1BnK2R1VWpFNitwNGxz?=
 =?utf-8?B?NlZMb3pzRUw2SXBYc0MwcXFsbHhSQlpYYWxEMVZZQ3lEY3Qwa3dpaUF2N0d6?=
 =?utf-8?B?eVlGWUppUVErV0JtZVRtQnc0V1NLVHhoSU96ZHgwanRRemtvdVdrWWtmVjJ2?=
 =?utf-8?B?YUM2SnozWHFSUGNyMkxzb1BzR0h4MEtjenNhcDZMZnpPQWhuMzFXYmpmUXVw?=
 =?utf-8?B?dnk2eng5L3l5NlRxN3AxMDMwZUJNQjA3N3RMWG5HQlZwS2gwTy9IOHB5UFpK?=
 =?utf-8?B?ZC9YWGVncVNoYjljdS9sc3ZNRk1vdjhSZ0ZPT1NRN0tnb1hCSk8zV2pleG1I?=
 =?utf-8?B?YVlMV1JZZXl6d2cxV2s5aXJUcU5sMDliRlJ3NzAvcG5JNUJrZGdPdFNMM2pC?=
 =?utf-8?B?cjdROE5xenFJdW9Oai9SZ3c4QnBTN1RXbmpKQjRRaG82NU9oeHh3T2pQY2hX?=
 =?utf-8?B?VUNSd2kydUVQbjIrd1hYZWpmOVBsMUxuYjNWVWlWYzdWUlBsc3EyVVlzYWFX?=
 =?utf-8?B?bWRXQ2Vnb0laSnVmK3A3bzVGWEZ0dHZpMlgyYW5nNU1Mb09uaTJzOVo3dGpj?=
 =?utf-8?B?TXpNVC9QR1B1NkFFVDRpSzdXQ3JPNDk1M0c5NitHR2JDT2ZGWCtOa09saWR5?=
 =?utf-8?B?K3FpbVhVUGovRTl4bjA3T3NITk5kTHlkRUVUSWRPRTdiQ0N1NHFNL2J5N1BJ?=
 =?utf-8?B?UXFTT0JFT0dBbFZLZ0VXcWpUZC9ZN1AwK04yTW93SVo1L1g5dVdDRDJiOHJI?=
 =?utf-8?B?eEtnYXhtbkJLMVIvNjNhbDNFTjcwR3oyMjE0bWk3QldVTDdQMXpOSnd2V1JL?=
 =?utf-8?B?VHYxbzJ2K2grb2F3RHNENW9JQU5ZZGo5bTdJd1Y1d25laTFjUTB1UFIrV2ky?=
 =?utf-8?B?bDJQOE1aSEVoelpYOUp5SE9DTDJ6dC96RVJ5cFl1TE9iUmlvUlE3VXlpVGRC?=
 =?utf-8?B?TUpIa0lmM09WMW5EZWhKZEVkY2lRbmtnbkVmZDFqVHRxamJNcVpWTDdESU5O?=
 =?utf-8?B?dTV6MFkvbEpJMEJvNW81akVhZkdjZ1U4dmRzQldQMlFZeFo0YytsM0M2OHU4?=
 =?utf-8?B?Y0E1c2ZhTG96YzV1NzR0ZFNwaDRQVlJ2b0IvZmE1YjdGRDViYU1PYzVEWTFG?=
 =?utf-8?B?RVJmRGZqUGQxajlKRWU5Z0hNVmx0K1NRYW14OWJ1WFlGaTh1MVNlMDdabzR4?=
 =?utf-8?B?MmtyQWxpLzhJam9YdHVUSzdTRFRiMUtMWkRhc1JCcDN1TkQvTFYzRXNGWFJH?=
 =?utf-8?B?TW1tWDNTQWNNRTl1Q0ZtbnU1R2ducE5scjA1blRkVGxlM0t4SWh1ckdrSTdJ?=
 =?utf-8?B?N3dXR1RIOFlYTXdBajBxZUVsYVcvL1YzV2Z1dU1vWklJeGsvREVpaFpaOVJv?=
 =?utf-8?B?YXY5eWROakpGdm0xZjNJazJGTjJIUW8zQytWOGxiMTdBd2FBRk5zbXJ5VWxS?=
 =?utf-8?B?NFdQTXpmT1E3VGE1dzNUMXRiVGNtNXNKQlRiRlRZLzZhM2FIaG8wZ0lyY1Jx?=
 =?utf-8?B?b0U5WUw3bXRjK0hMYTJiVkNQeTNydXBzNUM2U2xPTGsvbHF6T2VTb1V6RDIx?=
 =?utf-8?B?SXZQdE5xeXdrSFg1SHowTlBwL1l6RWZUcUJUTVlJZUtaM0JIUDFjRWQ3RWRo?=
 =?utf-8?B?enE1UncveUZsSzNJanhBaCtjWU1OQ3N0bS9MSzBvd2VsbHQxNWh5aDAybTlu?=
 =?utf-8?B?S3BhLzJtQVVaZVRXQnd5NkIzWDNRNzFqZlk0bndwZkE3TTNxS3NtUzJiUlE0?=
 =?utf-8?B?aDAvRTJSSU1vYmhKREFtUVd0YkFndUVzTTNkTnViUTU2TSsrQk1YeGRmeWtS?=
 =?utf-8?B?eWRyVzZZeFNobm1sc3ZQbEx5ZkUyWTdtSERFbHJZZy9LdnpselhUT0p5VVo4?=
 =?utf-8?B?Wk5UU1N5a0N2UjJPd3hyUGJ4NlNOdHhNOFdBTWlqSGxJeFJtQTFLdmVUZlBy?=
 =?utf-8?B?cW5DSkQwRlIzeEg4cXE2RDdYVDI5blVjcmo1cThMdFZOSVkxeW4xMyswOHVk?=
 =?utf-8?B?eUlObXhOcDFHREw3NEUzMVUzZFVVZVBpZlVidzhxc1FpY00xVktrS2VSdXFN?=
 =?utf-8?B?eEI1dEMwbmdPYkwvRTJ6c2JBbXlLK2trRGFNU0pHdFlWUGordVFQeHhJNjRa?=
 =?utf-8?B?RnNZQzNsL24vaGs4Z1RiOWo1YWdrZzRSUWNMandqays2YXhCZXpMbmNDSyts?=
 =?utf-8?B?VXRqUys1TXNEaEgrdlZvSVB6RDRsR2l6NlNxQnIxL1JmenZxRUEyaGpQRDZC?=
 =?utf-8?B?aFYxY1UrbzYzcmNsRnFnbjdUK2hGaGhiOTRVUEQxRnVJbHVndHdqQm94cEl0?=
 =?utf-8?B?dkw2WWNrQ05CeG1sUjNHbW02RWZuZklZVWJwNjIzQmxSdTE3cXZXZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89eaac1f-f048-47b8-8c25-08df1fcb2232
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 14:49:02.5970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx4alECH/EjyRQz4IxAOK1sHF2NILSWJzd/v7kNmGy7P/bFM6Gu/VyL/zjvyDdInbAkCf95HutppKtGYQYvw9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9612



On 15/09/2026 4:51, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
> 
> 
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net/mlx5: Lag, reset vport speed on teardown
> 
> The cached agg_max_tx_speed was only reset on the regular LAG teardown
> path in mlx5_do_bond(), so MPESW teardown left stale values behind. The
> reset call is moved into mlx5_deactivate_lag() so all teardown paths run
> it.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 5aa9d5c98fe16..c2f21eb4ea7cf 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> @@ -1075,6 +1075,8 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
>>        if (master_idx < 0)
>>                return -EINVAL;
>>
>> +     mlx5_lag_reset_vports_speed(ldev);
>> +
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but now that mlx5_deactivate_lag()
> is the single place claimed to reset the vport speeds on "every teardown
> path", is the helper it calls complete enough for that claim?
> 
> mlx5_lag_reset_vports_speed() skips a PF entirely when the oper speed query
> fails:
> 
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_reset_vports_speed() {
>          ret = mlx5_port_oper_linkspeed(mdev, &speed);
>          if (ret) {
>                  mlx5_core_dbg(mdev,
>                                "Failed to reset vports speed for device %s. Oper speed is not available (err=%d)\n",
>                                dev_name(mdev->device), ret);
>                  continue;
>          }
> }
> 
> For that PF, vport->agg_max_tx_speed keeps the LAG aggregate value written
> earlier by mlx5_lag_modify_device_vports_speed(), and enabled vports keep
> the aggregated max_tx_speed in FW even though the FW LAG object is
> destroyed.
> 
> The stale value then gets replayed later, in eswitch.c:
> 
> mlx5_esw_vport_enable() {
>          if (vport->agg_max_tx_speed)
>                  mlx5_esw_vport_set_max_tx_speed(esw, vport);
> }
> 
> and is also used as the fallback in vport.c:
> 
> mlx5_modify_vport_admin_state() {
>          speed = IS_ERR(esw_vport) ? 0 : esw_vport->agg_max_tx_speed;
> }
> 
> so an inflated reported TX speed can survive with no LAG present. This is
> the same best-effort handling that came in with 50f1d188c580, and moving the
> call site strictly increases the number of paths that attempt the reset, so
> nothing is made worse here.
> 
> Both mlx5_lag_reset_vports_speed() and
> mlx5_lag_modify_device_vports_speed() return void, so mlx5_deactivate_lag()
> cannot observe the skip and still returns 0. Would it make sense to have the
> reset path clear the cached agg_max_tx_speed (or fall back to zero) when
> mlx5_port_oper_linkspeed() fails, rather than leaving the LAG aggregate
> cached?
> 
> Also worth noting on the caching order in
> mlx5_lag_modify_device_vports_speed():
> 
>          vport->agg_max_tx_speed = speed;
> 
>          if (!vport->enabled)
>                  continue;
> 
>          ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod, vport->vport, true, speed);
>          if (ret)
>                  mlx5_core_dbg(...);
> 
> the cache is updated before the FW command and a FW failure is only logged,
> so cache and FW can diverge during teardown too.
> 

Not related to this patch, will send in separated patches
>> @@ -1676,7 +1678,6 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
>>                mlx5_modify_lag(ldev, &tracker);
>>                mlx5_lag_set_vports_agg_speed(ldev);
>>        } else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
>> -             mlx5_lag_reset_vports_speed(ldev);
>>                mlx5_disable_lag(ldev);
>>        }
>>   }

