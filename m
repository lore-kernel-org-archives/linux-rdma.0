Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2271643B489;
	Sun,  4 Oct 2026 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791121424; cv=fail; b=aVrCkxD1/xf3gYV7y1GVZxdmIQbmQEhrv74lOU1TrbiGvQWhxPcLzpv58f4pEWWpYlNoyGlgQdBHADxtXZhL2n75fRVeEyD9FEVP5U/cZmVuAu705eA6jSaz5F9xxn+5HQIs2UbOxcB7xNmBCsR0Q8LwUTBSZ4um4Dfqs0pdFLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791121424; c=relaxed/simple;
	bh=ix9BJVOqoj5Xb2MmZyUzlpCxGn9GX8sby7MoJKMLIRI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tq/vewJt1XKkZF/rS5wrXHhWGNdEtOMnwP78IV1QP7yLDZ6XE/iV016udMoieScUI9X3ESsyKuHox9t6QfGx/m5sDZ4T1lhZPcuLuu5YITE4bVjhlPrtP8SwWHPNdjA5HF75Xe/vE8+hxdH6Fe1QSPShvopppxDB0+LN9Xq93j8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XjSM37mV; arc=fail smtp.client-ip=40.93.196.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XjSM37mV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lu/Bjaz/XXD3NxOOFJIKRZVhuwaPbYlLp1al/ToS/d0l9n0KVPgoLFBFuB7bmuJfqLbLA9PQHE5UaGVmsMH3ftAt+vdzIygrz6ApWtkiW61e01urQdVTqYumqF2iJlaYfaiXUjpbECdyY7YSwpySKy/FrdNthL96ZUIJ1BaxUmSjpd08Vbq+TvasmeBMImYKh1KuD1LY3U/v2yOMiBU2jlPruRYL6lIXWDg79gmf00EWEczn0TiFjEdi9bc+A6yS68JuMhseH2oBvHHh8W8mmVRBzHWCviktbKWWvQtlcvZf7Hi1auX4REE7opEsaaztFC9LGCUvpvI+L3zLbSXl3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbDJQl7PwBycyjEgcasKSeYNjmgpizKZ1On35NKlZRs=;
 b=v0Px9/krm+cxKvCyYFofcCO8NAeYV3VEebEAtWhQNcMVSkO8MfxUnYCB/5CC+mRzQfblAprYfPpMk+C/DdfhX/QOO+SfDn7ktRVbEsFUDyQU5LG16jk3jKOA6mEG1cMyj9msvLToF4GMpT2kMiTfEJehussmSPdX17u8PDeW5hR0QY6Wt+62Wao/Z0Ch1Okp1fGQD6DQiQbU7NUNfTjDBwLfFAaTDRZUbPolMGFWH76L0AabHkpWqFEn+WRw6EUP4kPEFT3Ah+FZrkIaVPAw/ZC18qjy1bktePy7tryjfjIu7qflmHIHAanU6i8hLU6EjY0mIjF5F2i8sMFR5nBOpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbDJQl7PwBycyjEgcasKSeYNjmgpizKZ1On35NKlZRs=;
 b=XjSM37mVVGt9WvBoV3/ZQrgALBVV3v2Bv9AGh2+dcB/UWctV2CarN65AGM8Rk4/0TWshATBt5IiDoNbf9jcBHFq3lJNiTKwbaZwvQsg0Ylp8yf1XgC7oPaPXk7Vyz1z7j8HTT4w1A8ujT81e4bYRTbbBe3RmmE5LzaRIqTZK+MiTk8N/PS8Vrhm+3B/gTNHosnTzN8OqgJsBUe8GYNlKBdlgB0LmmmdhbyVFlCMyduJMszQGC9rYOL52+Ox2aR64alG54J76quZZmCZLph/g0FsNOP9goS3cOVuy/njUsbJu4LekEs/si3fqPSO18ooB3EYY0Mhr6Y77+i3w/c0Nrw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by PH7PR12MB5806.namprd12.prod.outlook.com (2603:10b6:510:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Sun, 4 Oct
 2026 13:43:40 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Sun, 4 Oct 2026
 13:43:39 +0000
Message-ID: <bcc09996-e71c-43af-b3f2-0d072f6d402a@nvidia.com>
Date: Sun, 4 Oct 2026 16:43:31 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx4: shut down catas recovery timer during
 teardown
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
References: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::17) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|PH7PR12MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 17fd8355-3d0e-42a6-93a3-08df221d7f32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|11063799006|6133799003|10067099003|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qbQqrtesOgWJ1FdFPMGoyjxI0kimW6puz5FFW238o0nuBz5Ulto3m9hbK8/f8lo63v6xv81lVqtmdYZWUvy+vI8Lz+cyEcIonrQ5Qm3SCi8f3/PrHcZ9mIGcYORFO4jo1ZZnabt8ogbDzcDJZBypmKwHmm2L3juc4fE2TeKdb1TQHk63tWnYTtkZjQmxAZbWESuionkI5Jn5ymljaXYWX9KAUY8kwzbcAgsnWYaEMo8nlGhyxbpiIHbo+PD8n/cBtjlhChHiU9WVVT/rzYJENw0oW/mPPn52o6y/8XJXsu8i5bT8t0HNOHfz/0diFD4QwhIua+I2pQ56ioPafoniMcYEQw/hX1g2wCwSy2wI7J6dxKNMWMz6cZ9gzHEQNVsc4E9de1/wPtJk7kelZIMCpJwmKo8WEON2XFNP3Rxi0yC0SwRQBKI8nxsSMJPFQEXyV3h6IFZ9vAAHTxCVKo3N0DKruuDmCQeo/1HFt8id6X0s98aTC0nrX6go8GdHZ7BVkM3SVQ8E8yagKxv7PXmaiIKj2Ih1Y7b0Pc4Y1osdft7pbEtZcWlQuxoWsACzDRvAhure2MzGH+lGRn+akMNU5u57ZODaK+bTc0d3TdmvcdXjN1yLvRQbzpINtsOpSYyv7/wqDLSzPwhhtpfjid6l5mziZPA0HOTbWymKo+ouUq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(11063799006)(6133799003)(10067099003)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk1KSEVMbTdXRXlNQ2JyK0RQNzhPVWdacHRFM25NK0g2enB6Mlc0R1pEUmh2?=
 =?utf-8?B?ZGFEdWJFRkxQTDZ4L1E1b1RCenIvN2VDWEphQWhsMUlJdFhUWldvdEdqVk1Y?=
 =?utf-8?B?VjNvQmZmUEthOWp0bGZjWEhqdHoyc0s3SmdManphdWZaMjVvN2I1KzlQNThl?=
 =?utf-8?B?SmJQdmovYUpCWWY4ZXJjWGNIcnVsMUpPdS9DYm5CTkxHZTZ4c0w0c1RLM0g1?=
 =?utf-8?B?bk8xanFvdDFjeEFsVlpaWlltVHNIVUZOeXRrc3AzWmxORUNqV1RkWVQvVysv?=
 =?utf-8?B?OHczZ1MvWjZOcWk4Sjd6VlludlQzMmsxc0FyNHZMU2VBTGNINkZ5WHB2b043?=
 =?utf-8?B?SnhjT1kxb1loSWQ1SnQwZ3pSaGJqaWNadFJSekpUeHFWVmhHVXRmNCtqUVR4?=
 =?utf-8?B?QzhNRHdKVjdlU0N1VERhcVVNRmhrRStVYkhlaGpYYkFwdFZ6ZFFmS2diTHRP?=
 =?utf-8?B?OTZENDIvUzlaV0lKb3pGRHBrWUZDWDRZZlVCNGJveFFkbkxGY1JHMXpsTlk1?=
 =?utf-8?B?OHU0ZUl5ZmlmQlpPOER3NWd6NXNnWERlYjJtTDRDOStFNUJybG1PdVJjY2hV?=
 =?utf-8?B?Ym1rRjVRbW5sMDNzTG96aGhnbXBqSUJDeERPbGxZcmlzQ09EaVlzT2V3TEhP?=
 =?utf-8?B?aVVyT0xwdXM2NXhJYWg0dEhWTDg5eUlkNUVXSTVHcXplaWJwRWV1OHIveWlM?=
 =?utf-8?B?a29HbGwzOTRERm9ZbUZKSjFZUUFiYUJieHJlS3J1OWlmc2FvSzArQUZ6b0NZ?=
 =?utf-8?B?WnA2RGE1MVpiMEU4cCs4L2pVcmxnUFVYKzBYTGhTenR0NnB0d0hGN2p3NzM3?=
 =?utf-8?B?KzhkUzViRHBFQnpFUmFpQmp0Ty95RmJQZEV1SjR1YjA3NW1pSXFWZ3o5ZWZs?=
 =?utf-8?B?QUUxN3JDN2RkVDFVaE41UjhZcHIwNCtHQy9zakhQQ1FGd004VDZtTUhFK3cr?=
 =?utf-8?B?SXV6REIzclBqd1kvOEdWdk9KbU5BS0t4aVdNWGUxQ0FlTVEzUHpmOCtrSm9q?=
 =?utf-8?B?dkdyb25oV013Q2VsSDFaRVBod2pibzdQbU5Ib1phUWplV0dVMThpRmZvdCtj?=
 =?utf-8?B?RzVZN1RoTFBSVXFmUllxMktVM2J3UnFqd0d6YTU4elJTZkdsTFpXVXpoOTJn?=
 =?utf-8?B?dktLVUNSTlY0NGVtdTM1T2QzMTZxNUh0enNxS1c2TlZqTm1yYU9HYWs3Sk9F?=
 =?utf-8?B?dkg3QzQ5VjAyVmVVaEIxZFJtVlVHbG41eXN6c1RiekoxV01nbnl6aitpUzRL?=
 =?utf-8?B?TWJlMlJHdkNTR2tVZW9TMldFOXNBTWQ1OHQ0TXdrcGFoN2NxZ1IvUW1iS0pL?=
 =?utf-8?B?cDk0MFZTSWJ3Ym56S2Z3OXRVcUFuSUZXWE5JNmZ5Qk10RlRDQ0RaLytkcG1a?=
 =?utf-8?B?cVBmdVE5aStISzVsM0VnZDlORDNhejY5eXNydUwvZkpoWGNUSm0vY01ZemRY?=
 =?utf-8?B?MXp1dTVtOWllNlV1cVVxNXNJNXhMc2VJZ2VSdkhaSEpDcmI2Q0t5UDByMFpQ?=
 =?utf-8?B?VmI4ZnExQ253WjdjWVM0L2FNck4vLzAra0ljUnJtSTFKRDNSODlIR3hEbU40?=
 =?utf-8?B?c1ZnZ1ZYdU85emcwL2RIUlpqeWlTcnl1dFNEaWk1bmFmR05rbmgxUTF2Rkt2?=
 =?utf-8?B?M1dKU01qWVRaTHFlTmNuaVlaRDVnUVhkaVBwcUJlTitRSHRUYjJkaVBieUJK?=
 =?utf-8?B?bnY3M05CWmU5K1BOSm1SSmlJK0pjOXAzcXNiZllhZTNRZG1ubXFEM0tyazhI?=
 =?utf-8?B?RURzcWNaWlNwYWc5NUwyS2NmaERTVnBCcmNXc3J5L2VJU053ZnpNdUd5Smpq?=
 =?utf-8?B?Y3FNS2I0MndlME1MQ3BTb1dHWWZoamlFWXpRdkhhRUhOZHlORUh1d2hLL1Nk?=
 =?utf-8?B?Zis2ZGs2UDhuZkVnYkdtRHlEUmJ4clByRThOV2IxMHovMDNsZXdTamhLdS9G?=
 =?utf-8?B?eFRCQi81KzNBNUgwNmo1UHAvYnd1ejh6Ty91SjJaWWpzOXY5VnVYdWpaODk2?=
 =?utf-8?B?KzJsTmdHbE83cDB6VU9IdDhVQ0szN1k5RUpnNGEzRU5Eai9QV2lhSHJSVzh5?=
 =?utf-8?B?dDNGeGxZekd3Q0hXMUlhWHYwek51a2dWNGQ3dlFva1Y4QUlwU25aNnFaWTRH?=
 =?utf-8?B?d3JheUNNbVpsYXZzSWtnV3RWbVplNDFiRFhMN0U4dFJVZUlrRkh4RVd4SmZz?=
 =?utf-8?B?U0ZLbll1TFdQZkJVS1lpYUFQWU5TS3Q5K3FZYWoyUnlPQ1d1cmJYZUwzTmVy?=
 =?utf-8?B?OEk0emtMQTVHRzNZaTBEbCtQdlV6SFZsbzkvZVcwUHV0WGsyV2Z2TkpNeGVr?=
 =?utf-8?B?R29JOG16R0NqRjI5aXQwbW5FemhIdUhhSmEraGpQdnhTMFBrNmpLUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17fd8355-3d0e-42a6-93a3-08df221d7f32
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 13:43:39.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubxgdz9SnO1PUlN1US+L9eceHnILyCX4ia4D5hJmYgD6WgGYuJ9/UOUNp0ha8AbqK2w4LQ1/szbfjP+po4TLSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5806



On 04/10/2026 15:12, Runyu Xiao wrote:
> The catas error timer can rearm itself while the device is being
> stopped. If poll_catas() is running when timer_delete_sync() drops the
> timer-base lock, it can call mod_timer() after the deletion. The delete
> can then return with the timer queued again, allowing a subsequent callback
> to access teardown-owned MMIO state after it has been unmapped.
> 
> On PFs, poll_catas() accesses catas_err.map; on VFs, it accesses the
> mapped communication channel. Use timer_shutdown_sync() to prevent the
> callback from rearming the timer once teardown starts.
> 
> mlx4_start_catas_poll() calls timer_setup() when device registration is
> restarted after reload or port reconfiguration, so the timer is
> reinitialized before it is used again.
> 
> The change was validated by source review and a target-object build.
> Runtime validation on mlx4 hardware was not available.
> 
> Fixes: ee49bd9397cd ("mlx4_core: Reset device when internal error is detected")

This is fixing a patch from 2007.

Did you hit this issue in reality, or just claimed by an AI tool?

We need to have a very good justification to touch this old piece of 
code now, especially in stable.

> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx4/catas.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
> index edcc6f662..62574b790 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/catas.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
> @@ -305,7 +305,7 @@ void mlx4_stop_catas_poll(struct mlx4_dev *dev)
>   {
>   	struct mlx4_priv *priv = mlx4_priv(dev);
>   
> -	timer_delete_sync(&priv->catas_err.timer);
> +	timer_shutdown_sync(&priv->catas_err.timer);
>   
>   	if (priv->catas_err.map) {
>   		iounmap(priv->catas_err.map);

