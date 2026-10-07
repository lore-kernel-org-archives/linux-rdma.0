Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86CE3C1D62
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 06:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355142; cv=fail; b=Xzg5DVS0zsfg663N9F1wRU8eRig2xiXWVAg6hPfC6KcLet/oZNrlyYApdMYYzC03Oay3KOg3IcHuWTb1uHAC4/vmp7a+/zNkD9Dbh0QP7grd+gnGlTonurFAWRrKBm+ctnvoAYgKsol/lLWzEmnePcqnJHKgRjpGdETWgaC1dZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355142; c=relaxed/simple;
	bh=UD3kAqBTk5scNkzI2EM5EGwPGT/UKEsxZy6kSvIFhx8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QH078FCIJ+U9+bpKixpA+foc9FLjt/6mzR5EgCvHKNK9mKsHvf1NuD2lZWR0H2Et90ZJ9Ymz/2OrVkhoY5i/xGKkdplgWRw0hzRXJNkNPOAJ1K9tXJMh7pI7yvmZNFZzBHzucD1W2jkeVm/d2I8Q+0tL8O4rxUXKWh0ncNSfivg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GLUOxL4o; arc=fail smtp.client-ip=40.93.195.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GLUOxL4o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGlvmU83ndZB3c0iL/zPDgoHN4aBOp8ZUiPTKcCJwa7bPxvHLQ52i94t1g0KiMmYiHHu5WPkBCPWydVicb0B8Ufo1HEyu+5vPqEEnDPwaydu0hrBpIfz6H91GUAjG3FhkiLvRtVg0x8nKR1BqPizmjJrFYsiIMhQ699mfXmyQTo/BOi9W+fUCplWyUp76odr0u/WUwUkaeBaozAvyOY1XEKGlj46P99TMrymOUlsM6+KtspNQ8gRTIyJGoG+W0+Lo88EpnD0RCBzy+ZBa8Hf9gl2vHxBAUYeVZbDyKGlOzbkvwBRDoL3Rl4F/1NccEii6Djj0aDXZhIz7OQq3v0NMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyra8q6xYGi2dCILEjN5H7K0Hm/Yyfj3Xgf/xxxZj8A=;
 b=rx34Il4kvvDSJ/jMLEcCcAU16rmtjZY9ZdgRA56U2G3tMSgICkygxPq8HcmWO/4tP4V8UgEwzblpRQiY21cJYwYK2yV17ScPUNv4vLUCtw4dieCEJRDmuAjkGGs3M5wF+5dxUah/kUqhgSBqhGU7VO4mhh9ya2uB615oBpi0jxF43vHoTQHi/2O5Qm/ixL4uKjbTgdbQD5eNy+UtM16hfxCnPbscgbbZxNHDmuSYJfr9ba9MR+uscQ7je8zx0qrUWqCYV207RapynwcF7Vbo4t33RfbhZ/oETH4IbDHCgpJjSbzG8J+rqdH76GDAWCttplgOaV+befhuXcBNlBWC2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyra8q6xYGi2dCILEjN5H7K0Hm/Yyfj3Xgf/xxxZj8A=;
 b=GLUOxL4o0VjcDQRAkLNVIM/RUdSkRBLNuIbl9Xv2YsswPGM4USeM7IaWZeeeqqqyuFzcs7hmavdy4P24kyMyEpPCHIJapSs/TcWTXcCwBpzKUst+gCsxaLtWyz3Xwqwu/DwoGdBlxJ/Tzt1XPt/5ErpGtLY6HHmO82y1fDWo61nSiwDGlxeFBX3TZ+4mY12He3RfUBLTDFKOLRCUw9DF2S29L3t03eHjiDjytyXA3xwezlf5daJvd6B+ChSNLsZiAWA5TacmO+38SvwuVCbec4pGWkBuAKj4ipAS/GNgNJv4xMjlkfKTlccWAeZewBlrWeuDrI/GizrO2Nxm25M2Tg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by DM6PR12MB4106.namprd12.prod.outlook.com
 (2603:10b6:5:221::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 06:38:56 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 06:38:56 +0000
Message-ID: <ef3568b9-f5ca-421e-b719-4774e3bbccf7@nvidia.com>
Date: Wed, 7 Oct 2026 09:38:51 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
To: sashiko-reviews@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
References: <20261004070246.215239-1-tariqt@nvidia.com>
 <20261005070328.AAAFD1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <20261005070328.AAAFD1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0388.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::17) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a544603-fe8c-4781-0ad1-08df243da91a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	XCwKf3eskPohVcppBxHyFrAUvb1JaEId4muhOtWEKmugeKeQrsyqdHhBcWHIAyKkn+DheY3jSLa1e4FFumAkZo7OISnOGF7TunGjJGLzj93ogYnrDUtMR5x457/mB88v64cnpaAylvggJlE8rl5YBj+Xl7hu7kzs6m8nfTotHBHWpnToJlOTPfY+p3RRhWoHWj7TuCisMHPO3WRcxVjlpF7bLxTATPH8Hzen4Yp2TFi08blcdo6Pr2GkWsXgYVdUBgywg3/Dugw/B33tNvN3RkPp6Iw3EVGUhOtSvV6sCuH8Eya1sMtiUxKzXHcOGb1XWAZisajIMjZ5dxYjO456eT5h2QpKMq0hn2Z3qFEW9mSkHtBxFIaAQ4gN1nAgfe94k5x/mJIrZ3cojeUmXD/Zkv12q9Z6/7Qu/9fSfGcu43WzlXMyM++ivImOagosHhGExxyjJjwMxyjmBEkoSfzXR/xi0JMpgozHCDHuO9NbMXjcPZjfVYauxxXSTg8IF7ArIW02pUV/OagU6WbfXfHkewidJb1ui1n3+JMao6qHA8jqdJAfJ+nZLVd0Y4c8iLVwIKGA4vRF4FXy3oJ5t8e3bmFiMuIOq7eTLqXhaMRr1Xcw3IEwyNUnOEIh4wVLYYV9aF6AbqERyuyv2vWAnnzYtcW8wtDAiGVY/RPr2OJjK+g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3hZOWpxY1M4SjlJM001Wm9SUk9hTjM4Q0dYN2xuNVhZd1M0THlOY0FjK3JX?=
 =?utf-8?B?WnZmN2pmb29jMmtEeDM3N21uN3pIdnF5YnJqRm1meGFKV25jbXhCR1Vhck5I?=
 =?utf-8?B?emhKM2VrRFJvZ01VOXFVQVZGU2VXdWdCSEJSU1dZWEx1QUc0b2poWStudXRv?=
 =?utf-8?B?L3Vwa1FXaWkvK2xaT2puU1pHNXFOU3d0MWxuTHdMZWpKZTYwYitiWmtFRWpO?=
 =?utf-8?B?NGsrM3dJYVAwNVpBRDhJNGV6V2lGVFZlbEcvV0d2S3dBQUZ3ZEpJMXBxZXQv?=
 =?utf-8?B?T2JkMjVlVldhN2lNZEhWNExuM25lUHV6UUxEc3JHRlFmOU9XbDdCMWtpRTBr?=
 =?utf-8?B?OGs0d21EaXd6Misxa0I0dTBsaDdlWlVzUVJJQ2EvK2Q3MWV2amhOZ3NxdU51?=
 =?utf-8?B?VGw0dmRvU2FDclJ1Ulk3amQ3ck56UEJIWFFTNTkvY1JJTGEwR0Nna2MxRm1u?=
 =?utf-8?B?Y202ajcxd0oxZGd6SFBrMzUvdk1oNDFRdVplTEE1Sk0xYU12NHlodk1uOElk?=
 =?utf-8?B?bUhtQlNyandqMU12em1ZRTZHVnRTTisvcThZdDlndEpJR3JMbm5aWUpnMUxK?=
 =?utf-8?B?V1hPS1dhRldvZm0zejIwekpsamk4eitpTjlxOUxjSFhNdzdNZXB5UUJZc1pi?=
 =?utf-8?B?a3NMbTRWUTlaQm1Yc2hueTFqVFNJZWZ3dTQvUDFHUFBYREcxSDRVbThEeFFX?=
 =?utf-8?B?N3gyQWp3b29BQmVDeG9MMU5Sd2w5VXVSZzlQeHVaUkR3Nm1CR2Y0SnlvOXpH?=
 =?utf-8?B?NlcrSHR2Y1VkNkswclNLS2dKTG9FTzFCT3hxT1E1VkoxcE41UmdlNllkbU55?=
 =?utf-8?B?V0ZpYkJxVEZ3Rm5vem85aFZsSjAxMlZKNVUyd1pqaTQ0bmUyU25xcHRORFJk?=
 =?utf-8?B?QXhzM0tEK2lSWnZGa08rTzEwL3pXS2d5S0RWSm5XY001Z2lZS01hdTZ1R09t?=
 =?utf-8?B?cVFPOGhtdFB3VGlUU0xralllV1JuRE9rSkR0TjlOQUZ3RC9tV1FGam1CR1JY?=
 =?utf-8?B?Q0JGL3BwSG1VTnZRL3o4SzU3bjNxOU5oQnR6MmJiZHhGWElJUnE3QWs3ZjRX?=
 =?utf-8?B?K1JZcmRLbE9UbURFNWowWFBnUGh3ckUvUGdGQkpxazVER2UxSTU0MDBZTi82?=
 =?utf-8?B?eWovWEJpT0h5QjRzeGRBdTN2cllkalV2Q0tvRmlBZjR5UXR5L1FieEkwZy9w?=
 =?utf-8?B?L051VDVtZHVIdTNOMVFzcFh3S3ExRlpicU5HeWR3UWVvWWw4OG1LL2RsdVBh?=
 =?utf-8?B?eUkwM0hxWm8zMUJISTNkN08rUDcwZ2pDVGtxclFsakJqME5EdDdQTnhMamdC?=
 =?utf-8?B?RFBLV1dIanEzUVg5RHJEekRoUVlhQlNsVitsK0RLd0tRSTZIL3BXZW5Id1Ji?=
 =?utf-8?B?WkowMXh2bkNBdjQ1NUc1V3kyM1BvU0ZNYlhtRTVRbjNacFhlMUxMYU1pTXhK?=
 =?utf-8?B?YlIzdU5JUm82MkpIMnRuSWNzaE9PZW1MUm0zVGdlMHI0aWpXVXhQTXVDSHJv?=
 =?utf-8?B?dWRpbmVIRHNvZUFKb2Y1cmtTMEh4eWgya0JtbGhYWWpDeFdFVE14NDV6TWNi?=
 =?utf-8?B?amVHRHVzQy9jWkhFZWMvV2I4T2c2NGs3aXJyTFJ6Z1RNQ1JVdFNGaXg2Mnla?=
 =?utf-8?B?QTNybCtGVHNxQWVvVHJqQW52RHFxZGZvNW9XTU9kM0VpUngrck5qUTlsOEQ5?=
 =?utf-8?B?MlpuLzY4U1hVZEl2dGxtWHI0QTFsV1o0cGNVdTR6anNoQnUwVW5VdkR1d29y?=
 =?utf-8?B?b0NVMnA5ZDdDMjl0ZStENVRuOVJvZ3N6UlM5NTd5ZkxrbXNFQkNQMmVHVm5a?=
 =?utf-8?B?UHN3cXBudkVjSFJTblZGOHR1UkRpRkUrQjRrdE0rMFcwcUdUYkRYOUJIVTgr?=
 =?utf-8?B?R2dIeHlwejRpSlo4aDZjWUhMY3V5SFBPaDZTL1VZc2lNblhSZlRLZjhrYmlL?=
 =?utf-8?B?T2J1VjE5MjhFV053aWVaN1F6SzdodlcxVVVMUFBnV3o3Ukc1a1RreXlPL3pv?=
 =?utf-8?B?MVdvc3pWazhGeXljb08zWXhzcmtZRE9TNDlvT28zM0twV0RwQ2ljdC9ENzJ4?=
 =?utf-8?B?cVFtTnU2SUlsQU4vdFI5ZEpnSGN4SHg0OHFXNlZrWDFPSVN2WDBybGh6QlRT?=
 =?utf-8?B?TGNubWpJbDE2dkd2SnE3bVhsaU01L2Y2aE9xWUxSMXFDenFmNzJvNmVocHM0?=
 =?utf-8?B?Z2JoWjh2Q3oxSit5K1U0TW9zY0pIOThuZHRicEYyWlhxK1Bta3psWU5DWjcw?=
 =?utf-8?B?NUJ6cFYxc1o0MFFIbGtOMDdaU0FBWkFVRVZjRXdablhWTWMraVhTNUxqdzI1?=
 =?utf-8?B?ZUM1cFo4RFlzbEhCV3cvMnVTN21ZZEVycjJRb1krakhpSWNnRVZEUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a544603-fe8c-4781-0ad1-08df243da91a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 06:38:56.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1OUkhnqZenRr+kRTRZCNn1EVIhf+qDdo6v8hygXKWS9Q9RVHSrfo5qJLrbKxkYjAAJGcSe6oCP0xTU5TAi2xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106



On 05/10/2026 10:03, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] net/mlx5: rate limit dropped due to zeroed max TX speed fallback cache
> --
> 
> commit e0ff80bc97aeb275a4ecdbc780d58984bb55ac36
> Author: Or Har-Toov <ohartoov@nvidia.com>
> 
> net/mlx5: Lag, only cache max_tx_speed that FW has not accepted
> 
> vport->agg_max_tx_speed caches a max_tx_speed that could not be pushed
> to FW, to be applied by mlx5_esw_vport_enable() once the vport comes up.
> 
> Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> index fc197d1dc9dfe..f8c220bf7b5ca 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
>> @@ -951,6 +951,8 @@ static void mlx5_esw_vport_set_max_tx_speed(struct mlx5_eswitch *esw,
>>                mlx5_core_dbg(esw->dev,
>>                              "Failed to set vport %d speed %d, err=%d\n",
>>                              vport->vport, vport->agg_max_tx_speed, ret);
>> +     else
>> +             vport->agg_max_tx_speed = 0;
>>   }
> 
> [Severity: High]
> This patch sets agg_max_tx_speed to 0 on a successful push, but multiple
> fallback paths in the driver rely on this variable containing the actual
> configured speed if a query fails.
> 
> For example, in mlx5_modify_vport_admin_state() in
> drivers/net/ethernet/mellanox/mlx5/core/vport.c, if the query for the max
> TX speed fails, the code falls back to the cache:
> 
>          err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
>                                              other_vport, &speed, NULL);
>          if (err) {
> #ifdef CONFIG_MLX5_ESWITCH
>              struct mlx5_vport *esw_vport;
> 
>              esw_vport = mlx5_eswitch_get_vport(mdev->priv.eswitch,
>                                                 vport);
>              speed = IS_ERR(esw_vport) ? 0 :
>                  esw_vport->agg_max_tx_speed;
>          ...
>          MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
> 
> If a max TX speed was successfully configured, this patch clears
> agg_max_tx_speed to 0. If a later admin state modification triggers
> mlx5_modify_vport_admin_state() and the query fails, won't this fallback
> logic read 0 and inadvertently un-limit the vport by pushing 0 to the firmware?
> 
> A similar fallback path that relies on this cache exists in
> mlx5_esw_adj_vport_modify() in
> drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c.
> 

This code was removed in Revert "net/mlx5: E-Switch, preserve max tx 
speed on vport state modification" -
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=86b785b18f8f4a6b4a7392d1e2b29d6bb095011a

>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 3b34bec559e08..7cee78cb47df9 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> @@ -1502,17 +1502,21 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
>>                if (vport->vport == MLX5_VPORT_UPLINK)
>>                        continue;
>>
>> -             vport->agg_max_tx_speed = speed;
>> -
>> -             if (!vport->enabled)
>> +             if (!vport->enabled) {
>> +                     vport->agg_max_tx_speed = speed;
>>                        continue;
>> +             }
>>
>>                ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
>>                                                     vport->vport, true, speed);
>> -             if (ret)
>> +             if (ret) {
>>                        mlx5_core_dbg(mdev,
>>                                      "Failed to set vport %d speed %d, err=%d\n",
>>                                      vport->vport, speed, ret);
>> +                     vport->agg_max_tx_speed = speed;
>> +             } else {
>> +                     vport->agg_max_tx_speed = 0;
>> +             }
>>        }
> 
> [Severity: High]
> Since this successfully clears the cache to 0, wouldn't it break the fallback
> mechanisms mentioned above?
> 
> Additionally, this logic appears to overload 0 to mean "no cached value".
> As seen in mlx5_esw_vport_enable() in
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:
> 
>      if (vport->agg_max_tx_speed)
>          mlx5_esw_vport_set_max_tx_speed(esw, vport);
> 
> If a user explicitly configures a speed of 0 (unlimited) while the vport is
> disabled, wouldn't the cache value be 0, preventing the unlimited setting
> from being applied when the vport is later enabled?
> 

Speed 0 means unsupported and not unlimited by PRM. User can't configure 
max_tx_speed to be 0.

> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261004070246.215239-1-tariqt@nvidia.com?part=1

