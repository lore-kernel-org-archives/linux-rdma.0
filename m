Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E8B439349;
	Mon, 12 Oct 2026 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825162; cv=fail; b=RLfEj5GoHHdwHwsCxecTMLAb9t/+gzIcUYqQ/c+yqTBs3H6ZSMc0f7Z56B5lgxemSPniPfp3tcD+ZSe2aCzsPCAK0KgAeEayiri/56D+nQozj8SzFZhokGWRBG4rW62PduxEetTy+PZrYBiYujEpVz7evqoEwNBq3/0bPYb6vu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825162; c=relaxed/simple;
	bh=5eXbR8jKkZJaC16+VMI5+cS/wSmvIzmB9lMmhY2ivTs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=okpLhNkJH3YNpEDC3RTryEJjaUpFdYQ2vyvMlnrzZSpC0ryS+q/MqZ1g0pIhfUFq/dozNE2cUr+TnSrupA4ZN7NWl2a6t74eGzfx3JRvxdrlW0kkm0ah43oBwnhKsPdtn2KbjvYBFIPe1qIv5Kcic1ED3Yrvf+k92IkaoxximN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KXMN87H4; arc=fail smtp.client-ip=52.101.193.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KXMN87H4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlNhhW6i10exz2vsqPrUocPye/fOgYHu+H5xWnCEer9LW8T6GyeeveLozkOhd+pWx7D62swgNiFoi8PHnJvmFMNQn9cqCEIAWAMggOUmh8tffjPnFPWsJKAmbTJwZFAqup5a5Q7/5LBOnxDUE08qnK/evNKeGPkc7XBv0lAJxtkoqKX0LSc774Co5JW7gRvoHwmQA1FBkONh1y8GqjuIjRyReWt8DVJ2/3LJeeCdm6ekaWCvxNHN6bowSJqmUlrZb1twbeM2YVF8BgEhiORGv+0PUEI7xyFB9/oMYKEQITRSbKP9g0iRLfmJFA1heScKBWaSHY7UMQZlTElsu1r3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nZel3G7ZGkVCxtWIluTzNz9t8dPlK3tRN+83Bt+XD4=;
 b=Yqsh59CwMNnlrWA9TTJp/M3jRAdMqDEbkVUp2T+I+fizjiDo8CJ001JgX98oTZSeJY0uGJ/RdX+vcokyYppgAyMLamEXXm9u/aUX8ZmNTYTapoLQInv2fCotYtrUikyMQEx3Kzg2O/B352H9T7hpctB5bzl/OxozvCET8kSm3CEl6eV0PfKxZcIl4PP+EPdzXey4l9iLNqJRYivOYUKFIHmYIY4kHE5yvvfhrhLQhwdU/SA++yiTCVaNhoXWNe/gwD0Gjzc4ULIlmPandf7KdclXJVeQyBZF5onK9Kqd5UgCnd6ITQ6wJjJQR9bYjaR8M3tcc7tOky5U8dgW5BnmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nZel3G7ZGkVCxtWIluTzNz9t8dPlK3tRN+83Bt+XD4=;
 b=KXMN87H41CzAlu4cESQVT8YPfibb66Oap4ZTJtim1XH1MjbWh795Izjq83k05VcYKvRV4gKhXoh+siPCX/3ntaJSU57NgHryIsmARjuhU59NwsfwrGIzppBpbQb+8kMljDJYiiLHQPxmjC5rpJbH1QaiRy1IfLXbfZe2A2IZHhMGkbmstv5abJDfC8FHdXNZ+sP2ecLE0Usd4J0xBNxz1dF+/WRB0p44Q68jibO6tfjhTfRv1lraEpOoSGZq3XYkYFstTyRE2CBaFJFLzmA2gW9tA00Z0PEn/KNmGgsfb4DnQJK6Ht6gb2pCY6u64lq0MAeevMQdW8K9BnIPh8xgTg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by LV0PR12MB659346.namprd12.prod.outlook.com
 (2603:10b6:408:608::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 12 Oct
 2026 17:12:37 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0496.021; Mon, 12 Oct 2026
 17:12:37 +0000
Message-ID: <86c77644-df3f-4d6b-b7bc-14e7770da580@nvidia.com>
Date: Mon, 12 Oct 2026 20:12:29 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: Remove max_external_SFs device
 resource
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, cratiu@nvidia.com, gal@nvidia.com,
 jiri@resnulli.us, corbet@lwn.net, kees@kernel.org, leon@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 rdunlap@infradead.org, saeedm@nvidia.com, shayd@nvidia.com,
 skhan@linuxfoundation.org, horms@kernel.org
References: <20261011093828.784454-1-tariqt@nvidia.com>
 <179179804565.434549.2194696630956114111@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179179804565.434549.2194696630956114111@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::13) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|LV0PR12MB659346:EE_
X-MS-Office365-Filtering-Correlation-Id: b492f510-7a85-4cbb-fbe7-08df288403da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|5023799004|11063799006|4143699003|56012099006|22082099003|18002099003|6133799003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ebSCw7j6jIb4I32JeWwklIqf0HctbEtUXT3+7TriJjEPoG2FCdJRFPt0RCd4OZUUhjALvORQh2zYc1pXSfm8bo/9Dy4OiiQJVDX2Vr7jvr9TLc1W/v2QtzddpFTvjSDI3tT7ryTSv0tv9Qkdy3ndXENHAQkHDeEdDY8KtnFKpi37rrePhuTHrDx9Dkikm/PUZiN8ggbBIU82/H5Vf3aDSJDDecgu2F55haKQEHsKGMGXuQqKUDj2xOQgmSKkzyzUFw6hZRDmT3K0bU0oAAiEvOePERogSLsuLE9ChTANm1y8WnBuGQItqzIiQBlGcJvlL7oAzpbASv+n3+yBcDy/JxBbGjZyAEH+3szYzLwprlXxp+JL3hFHDS2HlgE3Hh2edmQ7pMEIj7BUbVaHSbwoxk2BtjMVJHArlPcgq40m56TnPHo7femfyS6YdsyEJ5Kz0C0WDteNd+7tF6qd8YM7KQpETBNo24xZlWtOttziddBgd8OwD+gozkL32PDufjfCnEqIAIv/5DAVdOsocOwun3leyGchqBTGb4uG6RfyeBGvYlrZBVMPwSXg2y20V4Cqlp67YO/K624Dn+GvijTvVuxiO0vQw8an+UMs9lgaI2V+xVbRFMINCbCiZqpdgTiHGwrcuFAVMDknmCBytBwqiTznrbcsEO0e505uJOhTS6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(5023799004)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(6133799003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWNtVmRlNEFUUUZXZVZqd29XdzlOV25YZ1Vod3VyZ0ltQU9FV0xIU3VOZnRC?=
 =?utf-8?B?OEZNeDhqWUdnUEl2UlRkSzdjMXFsTEJzV0ViNTdmVDVKUzdyZlp6R3N2LzZ0?=
 =?utf-8?B?NmdnNm5DbDlvR3RSZnFQVmlFU1hmSlE3TXVaWlBYM0xsZTFrQmpYZUFaRzkw?=
 =?utf-8?B?M3BGVjBZSmN5Yit0eDd0QVF5OWVTMFRXS0hBb0lBNWhMVmN4aE4zZ1N2QlY4?=
 =?utf-8?B?ZHBZeE5ERG5PRUU1K3lBajJqSWhVbWVBV2NNN0wrV1lPbnA0bU9zRUhqUjRW?=
 =?utf-8?B?ZlFQaW9BZGNVM09mTEk4aDFEamVYRGh2TVc0alN4eklRNHhlOWhlOGVxaHFU?=
 =?utf-8?B?b05odkQ1WFo1VkRpRTc5ZUNvWjRrZDRnVFN2VXppMk1qS0xFWmJmSXl6anc0?=
 =?utf-8?B?MnN0Z3hNSGhOcUlLblA3YlhKNTZpUFd4ZHRmNkJ0R3BEeU9CeUdQUkVRcXhB?=
 =?utf-8?B?WnF5YzJYbkdqeTlxVG9LK1Jwb1FEUkpIWW9DVnFsM0kxVm5DRXQrbjAxS3NO?=
 =?utf-8?B?MlgybElid2Y0OUo3TDBmOWVwaHNTaFZLMGdzbWUyR29nKyswRWQrcitnaSt0?=
 =?utf-8?B?NjZQQWd5dkt4RVdrNkY3NE9sMHlHMlhVdkNadXE4VHJxbmdWK0dSZnA2ZHc2?=
 =?utf-8?B?eldoa3dTMG0va2N4QU8xQndTeTRpNEdOb2Q2RG1uSGN6U0tpa2RnNTVuM0xi?=
 =?utf-8?B?Q3NVL0dvUkhhbVUwR2ZMOUdJRmgvUTlTcjZBZ0hYR2dzVVBpTVQxb3lCdWZN?=
 =?utf-8?B?VHF6UHdrOXZiYnltMXNOejdxRTM5YmNML1BjeUZ6cGZnMDU3UkljVnBlK29a?=
 =?utf-8?B?WUxySG51WCtRZ05HK3VuYU1Cb2h5WnRlbnBqN090ei9LRjhnOGdYVnkvNE9Y?=
 =?utf-8?B?ZjVpd2crRTZYSE5TS1YwUzRJTmltTVVhUm9sQkc2TitTaWJWTnQ0MVNCYWNC?=
 =?utf-8?B?MlZDUnBRVGgrWU1aZ2FQczZ6NW5iWGhxeUJTY2w0Zm1SbjN6NmFvbjUzTWd6?=
 =?utf-8?B?TVViWUZRUDN6OUxUZzNOUVFpVXkrbUVLVmdpRmlUQUVxajJZdXpQcjEvNDJ5?=
 =?utf-8?B?ajNRa29XdzkwemRHcitmc053ZkwxYjMwME80cUFZamxXZXIrWTB5SEdLZXVH?=
 =?utf-8?B?RTd5TXd3QkR4eWNoSyt0L1dqWDNubmZ1Q1h4UzY1VG45MGdSOExHbk5Jajlj?=
 =?utf-8?B?WU4rZWZxMmYyZzVXd24zV05pM0NVR1pVM3kzZWxwK1JXRFB5YllVWHcrUU9r?=
 =?utf-8?B?cW5sa3NrdXFYQWo2czNDMHRQeS80SFdDaUo5RTdEWktGa3c5RkUzY1VuMXRW?=
 =?utf-8?B?YmNnN3Q2QXRFalFidjVkTm56NTQ5eFl5eCtzSjNqcUE5a2dpaW1zYjhpVnB4?=
 =?utf-8?B?ditHZmZpUlc1QStoZjNZVVlWRHY0ZzhJWDU4cmFqazlMZUNReExJTTZEa213?=
 =?utf-8?B?L3ppSEhibVlHcUpxcXBFenZLU2ZBZk1Cb1gzeG9RdzhvVzJDRGs0UlY2TnZP?=
 =?utf-8?B?SkhwRXAwVnBYdXJZcEZ2QXhCdGJXQ0hSVURkdDE3TDNBR2NPYUNFbTZCbTZP?=
 =?utf-8?B?cUw4ajNJZFpiUjhNUFdram94TFlYcVkwWHRBT21yZzhOTHo1VjFXZUVvSm5T?=
 =?utf-8?B?SjFwKzFOaExDbWJQT3ltKzA3eXJZYkc0WFpyVUxmWG50RTBpenBla1NweTRQ?=
 =?utf-8?B?VE5GOUVrVEIyNE1PNUg3NGNwa29SRGVteXZTbWZpSDJYVkZ1R3lMdExVTDhH?=
 =?utf-8?B?Q1d0NHpUbW4xcTlTdmZ1KzRmcytYOUFENXpyNDQrYjFzbEF0MzdrTy9jU3Bk?=
 =?utf-8?B?YldRSjhsd3BjR1BkeDRDY29DTENrbFFZNjUvLzFpTW5SUVJwTlNBT0ZaVklI?=
 =?utf-8?B?NDcrZEdsSmhIOFdVaGJVOXZuWG1jRkY1VHpEdXJyYmU0R2dENXoweCsrcU1H?=
 =?utf-8?B?cnd4bzlBWFNhSmVCcmVSUFdLZDljTnJzWVNVSU1zODZyVHRiTEVzQWdPQTFj?=
 =?utf-8?B?eGpiYUMyTzN6YWo1VUZ3T1RrOEJ0YVg2cnhmR1djT0lyRldnUEhjTlR2aVNZ?=
 =?utf-8?B?UWJLb3kvR2dNOXhKcjFFNmJEQXd1VzIxdzZrdXMvdkdBMlJuc1BmY0ZPN0hk?=
 =?utf-8?B?bVZOVjBJTm1mZzI4dENaNUZsMVd4Nm9BVXZkWVNIdG83YXJFem1BWjdDRFFu?=
 =?utf-8?B?Z0xPU083NXFBekhoYXV5bnp2WHdVOS9lRHI5T1NsVTlmUDVMNlNvVmd4VnJ4?=
 =?utf-8?B?MUR6Sm5Kci8vd2NNaS9SR055dExDTVdTTTU3WFJicDBKamxhU0Z5R2FQVk1M?=
 =?utf-8?B?ZjFSeXY2OUxab0RvYUl5enFibmQ3SGRaVGs2Zi95NjRaMUpQRVJCUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b492f510-7a85-4cbb-fbe7-08df288403da
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 17:12:37.7562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8phCaAk3WDO4kRMLWc4lVjMZgyvrFSNkkzHbj3o/M/FQ+r/aMVZsPvhnUWiwFFVwrnwiXpx2W9ygpOIE/3zk2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB659346



On 12/10/2026 12:40, netdev-bot+sashiko@kernel.org wrote:
> 
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The patch removes the device-scope devlink resource
>    `max_external_SFs` (resource id 2, MLX5_DL_RES_MAX_EXTERNAL_SFS) from…
> - [Low] The commit message says "Users can look up SF limits per-port
>    directly via 'devlink port show'".
> 
> --
> 
> net/mlx5: Remove max_external_SFs device resource
> 
> This commit removes the device-level max_external_SFs devlink resource
> from mlx5. The reason given is that the per-port max_SFs resources on
> each PF port representor make it redundant. The devlink-resource.rst
> examples are updated to match.
> 
>> Users can look up SF limits per-port directly via 'devlink port show'
>> to correlate with controller number and pfnum.
> 
> [Severity: Low]
> Is 'devlink port show' the right command here? Port-scoped resources are
> returned by DEVLINK_CMD_RESOURCE_DUMP in net/devlink/resource.c. The port
> get reply does not include them:
> 
> net/devlink/resource.c:devlink_nl_resource_dump_doit() {
>      ...
>          resource_list = devlink_port ?
>                  &devlink_port->resource_list : &devlink->resource_list;
>      ...
> }
> 
> The devlink-resource.rst updated by this patch lists port resources with
> 'devlink resource show pci/0000:03:00.0/196608' and 'devlink resource
> show scope port'.
> 
> Could the commit message say that the max_SFs values come from devlink
> resource show, and that devlink port show only maps the port index to
> controller and pfnum?
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
>> index 1724bf7e0e7af..c36dbd7de8778 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
>> @@ -262,24 +262,17 @@ static void mlx5_sf_hw_table_res_unregister(struct mlx5_core_dev *dev)
>>        devl_resources_unregister(priv_to_devlink(dev));
>>   }
>>
>> -static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev, u16 max_fn,
>> -                                      u16 max_ext_fn)
>> +static int mlx5_sf_hw_table_res_register(struct mlx5_core_dev *dev,
>> +                                      u16 max_fn)
>>   {
>>        struct devlink_resource_size_params size_params;
>>        struct devlink *devlink = priv_to_devlink(dev);
>> -     int err;
>>
>>        devlink_resource_size_params_init(&size_params, max_fn, max_fn, 1,
>>                                          DEVLINK_RESOURCE_UNIT_ENTRY);
>> -     err = devl_resource_register(devlink, "max_local_SFs", max_fn, MLX5_DL_RES_MAX_LOCAL_SFS,
>> -                                  DEVLINK_RESOURCE_ID_PARENT_TOP, &size_params);
>> -     if (err)
>> -             return err;
>> -
>> -     devlink_resource_size_params_init(&size_params, max_ext_fn, max_ext_fn, 1,
>> -                                       DEVLINK_RESOURCE_UNIT_ENTRY);
>> -     return devl_resource_register(devlink, "max_external_SFs", max_ext_fn,
>> -                                   MLX5_DL_RES_MAX_EXTERNAL_SFS, DEVLINK_RESOURCE_ID_PARENT_TOP,
>> +     return devl_resource_register(devlink, "max_local_SFs", max_fn,
>> +                                   MLX5_DL_RES_MAX_LOCAL_SFS,
>> +                                   DEVLINK_RESOURCE_ID_PARENT_TOP,
>>                                      &size_params);
>>   }
> 
> [Severity: Medium]
> Does the per-port max_SFs fully replace max_external_SFs?
> 
> max_external_SFs has been visible on pci/<bdf> since commit 6486c0f44ed8
> ("net/mlx5: Expose max possible SFs via devlink resource"). It was
> registered at probe, gated only by mlx5_vhca_event_supported(). Anything
> that looks it up by name, or by resource id 2, will no longer find it in
> any eswitch mode.
> 
> The replacement is registered only on this path:
> 
> mlx5_esw_offloads_load_rep()
>    mlx5_esw_offloads_devlink_port_register()
>      mlx5_esw_devlink_port_res_register()
> 
> Both ends of that path can skip it:
> 
> eswitch_offloads.c:mlx5_esw_offloads_load_rep() {
>          if (esw->mode != MLX5_ESWITCH_OFFLOADS)
>                  return 0;
>      ...
> }
> 
> esw/devlink_port.c:mlx5_esw_devlink_port_res_register() {
>      ...
>          if (vport_num != MLX5_VPORT_HOST_PF &&
>              !mlx5_esw_is_spf_vport(esw, vport_num))
>                  return 0;
>      ...
> }
> 
> In legacy mode (the default at probe), or when the host PF representor
> isn't loaded, does any devlink resource still report the external host
> SF capacity?
> 
> mlx5_sf_hw_table_init() still computes max_ext_fn through
> mlx5_esw_sf_max_hpf_functions() and uses it for MLX5_SF_HWC_EXT_HOST. So
> the driver still has the value, but no longer exposes it.
> 
> Also, mlx5_esw_offloads_devlink_port_register() only reports a failure
> from mlx5_esw_devlink_port_res_register() through mlx5_core_dbg(). If
> that registration fails, nothing exposes the value at all.
> 
> max_local_SFs stays device-level and is always visible, so the two
> limits are now exposed in different ways.
> 
> SF port creation already requires switchdev mode, so in legacy mode the
> missing value is planning information rather than something needed at
> runtime. Even so, neither the commit message nor the devlink-resource.rst
> update says that a user-visible resource is being removed. Neither says
> that the port-level max_SFs entries exist only in switchdev mode.
> 
> Could this be stated, or could the device-level entry be kept for
> compatibility?
> 

legacy mode is not relevant for SFs and when no host PF rep is loaded, 
the external max SF showed 0 anyway.

> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011093828.784454-1-tariqt%40nvidia.com

