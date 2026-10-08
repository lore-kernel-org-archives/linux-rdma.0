Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D334A3D5B;
	Thu,  8 Oct 2026 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466338; cv=fail; b=NXJDhadzg012gVS5y/ZpRBICMzD9KDowHpOlpRT/Um/HiMoge5XIfX8Q3ST/YlcMobNoOt4/k3OcNiSloJtlCXxTz8Zo6CwHYGtqNMEuYJZnBlyUUTmsHD9pl/ffjZCfkJbKd4l3er5crNX85gGQL41evDc0KrPH3jxDZaEtumQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466338; c=relaxed/simple;
	bh=BeLjMzHOG+cRodJv4iIVMgS4moPiwuCYnmOZMVEdGjc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o+Wxr/7KyUX7nhoSgD0arVE7HdSkml/f0Cc9OgZQx6zLj0Mf6s/KvVx6VX9r9iYWIzEynTpeOXLceTqgKJZiovj9IAXF/DrpIOqgRvqu0HvKs99qMwAySD/NOlzJTcI1uKaOdNjkZg8B5mlKn3M2nt70TSq0MKJd8g47O472eWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F0QbPYov; arc=fail smtp.client-ip=40.93.198.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F0QbPYov"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUj1N/OJuVk8c3LNBFwRsAB5f86UWMQZ4BBQ2YHxnuunaWknzGWduxWLzSELJWbN9vrcrAtZogSoBXBrpv4oyZsh8gWUESDkBJ5lFeAMGhKd+1+eVsFKGWIvDXvfjtHi/TZpdf+54Z4kWJ7fIUZNdVHuvMazzOhWNLVA/wZbkdHN/LaRfwtB+MdQUJ6dAaMaxU7JMJWFkyvMTnbCWryblvYlHzjhJItD2tEKTko8065VKPK575VWlqsKm4zlZGEsHx5U/MEk01GzntJsnwj5PCJU1KHrdIPMdGliDvjHcjq7+7/gXlPg2Tj0E5p/JLQOljFkzAwZNS+z7cf8F21eBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKUSB6LC1aEU39p1SNGuX1WsuQ+uXa/EL/nWUzHMYb0=;
 b=mh8JU4HWXBs9dg6aaminf9YgcUrNaqW3F3lLLWearF16AB+xeBoH5gQYkuiZ/vvs6iEAIjXyBQbE0zc6XjFrFSmMvhdSvFL3LO8L/y98sZHJUpjJ3Xt1gDWXxavcBtDdbBIYCnDwnCYKvhm1eVk6xGRyaansYC0DTM+q9XNKobBB3wH6I2mHojahdNyLTDfBUaYiwjNOt147+nGrpFjScvSFy5mIFk+4P9pT4lV/0pC5/WOH97gUreDapzQJXxz/outyEhHe521Qfxv0ehQIPSt12DMKPe1yCFMGEQNjBet5XwISY07ImVW8YyqISFV4MANeSTaweWwvLv4mLLtI8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKUSB6LC1aEU39p1SNGuX1WsuQ+uXa/EL/nWUzHMYb0=;
 b=F0QbPYov1BnpBGYJYQ9M8wKbXs31Fuk3gZbL274l5CrG0a63f0Jy/CpMmYsxcBQa8dW7Rcr7+jmxYv+wkdtypy1ZJkUQ29sRF8cdS19sKZO+Yc5X/mYI8zLUsLzIRdvPbEs9Xj4BEVxv7Ihhxl5AnZLScsUwrXqICNlTXzQXBDOiC20YagfJLLFjBEcbXpT/djOTwKMbW8Evz1z0q1XaiS8/+/n8TfTw5T4ZcpOLI2wXH/Kys9mhQ/xA2iaw1icwVV3ySaCsnZ7441MMwJEK7KgSxBU7gIc9LE58FwsmZqQ12szICVwor5zGYeuDEbixRatu9BVw08FnqVRyNAgDpQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by DS7PR12MB8292.namprd12.prod.outlook.com (2603:10b6:8:e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:32:13 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0496.015; Thu, 8 Oct 2026
 13:32:12 +0000
Message-ID: <8d147cbd-3be2-412e-ae4a-316c880eadf0@nvidia.com>
Date: Thu, 8 Oct 2026 16:32:05 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, release L2 to L3 tunnel reformats
 to their own pool
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-2-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261007143830.1733583-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::17) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|DS7PR12MB8292:EE_
X-MS-Office365-Filtering-Correlation-Id: 74eb2ea4-95ee-4602-da33-08df25408f8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	B2eS/eDZ3/ElE6V0UPxI3dNdeRtwrB/MaKyvtblDozWy+CDZVV81kUk8sNW/ehobaRfi3Omw1iSbgT10PTDGM99OxPv/09ZgoKEEPEEQgqIqbDxU02dvWDKbY2+rBIuuxgKTIqoBTcYvbb7o8iss2k2FclVmAe9XZaQjBJH3lWaV5nO6YtNn6sggKzDdAC5fIm8q7Vx1vrzBguLCrTCPd7mfuka5c478Cq0pmenre9nNRmgGpaH63VfY0QXOnjkKrApokGIMm1P2HAwJ3qJLeSbsQjmQHvpBnLjHx/Gycttw8FwMdBAlqNMnOe1hbRIoumm1GyghiVrFY7hfHma7YF/dAAhgMJNRE2Z1w8uIIqARoCgebBXpZ5o2ZuLRumA3VoMLWiDboB8hvQExa2+YfMU0aczWFHhWll1/Wt1MJU1GJwaZD+nMRarVVITKQ2kJ1KHIDL5E7521utUpq+tfnjma1JOvMlLOlxjfkkdLGEp92NLpLuq8doK4pnlvQ5Ajn8LNVajo+n1N9pHTIFNTuFbo51hAxbCoLEKG7sEX9z787M2jlpa9HzkMGC6QjULiHcwf5/iPOcVstrhWpCWgs5tSeeclQhDTk/WqQv/nGhqEMovrJ1CtEsBNMp/W1QcJTzQP6oltmaNm22pA7+KDLC2/ELoxMGnI3YWZ4OfWRMBk2Wobutml7OWTNsUQJnWeuKDm20PGu9MLZKH8z8+912TxSQuHYoSd3nyqYCehTFExwZWFCCLcfGnZfT6wBTCa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjVEUzd3RWRWV2xKbERwbjJaZDEya3ljOStTYjduODdwUDhIZStxMjRoNit6?=
 =?utf-8?B?V1pocVFYZUpjRisyckpuOE9HSjB3Z2lGaEJ5QXp4R0UyRGgycFl5TUdkeE92?=
 =?utf-8?B?NzBIWlo0SUlWaEVoWDd5cE9QNHVDdXl0OWZSdE9vOGlFQjdrYVV0bjQ1SERq?=
 =?utf-8?B?QmRYeXM0YjA3N290eHBvc1Z3b0tFam1UaFhKYlEzRklaYWFMOWk3WlNKeTl1?=
 =?utf-8?B?QVJmNDlJR1hGL0R3bHBIa0Rqb016ZmNkaXRTSmRJVFVQRFBQSGNlVndJSlJ4?=
 =?utf-8?B?Z1VOTk1WS2hhSmZuTUFGREtCRksrK0t5ZjROcW53Z25iVWovTnZhMVpmOUdO?=
 =?utf-8?B?VkdtcmQ5T09RSzFycEgrbzhtTGpGdjJ3TGJhUHR4RGtUV0FPb1VuZ0I4RkQ0?=
 =?utf-8?B?QTcrbndDc285ZURpVlE1c1hLSHF4dGlROTVoV2FGMjJTSXV1dndOdXdGWFAy?=
 =?utf-8?B?VHNxczcrd0pHQWRMa3RlZURQWjhFcmVXQStjb2U1R2RmaExkN2lSSXhSM2Ji?=
 =?utf-8?B?KzJtc21sZC9UOFEzQi9SVWYyNkRFVGZFL2xTOTN4T2tWcUsra2R4SStRTG5z?=
 =?utf-8?B?dHh2RXRMOTVxZ2JSZ1hUM1R1ZU9vZE44T0lJMGtCOE52amF1WDBCY0M1UGcv?=
 =?utf-8?B?WGFWb1ROcTBkdHVoNlhYMXJ5K2VvR09hNmlYZWUweHorQ1NHOTEyelg1YVlV?=
 =?utf-8?B?OTRkNGNiaEJOeGtaOTRpNU1LTE9COFhSa2JjajNpaEJvZGY2NXNLazVDejRq?=
 =?utf-8?B?R2poQkFjYkNoOXZ3eExCSkhMR2pZRnVCWU9lWWxxY1hNQ3lRcmUvYm0vcWhP?=
 =?utf-8?B?NDMwbkEyanRUcXlCeTJCUWRsSFRGcnNibGpnT2FidExrRjVmTWNWNnUvYTc4?=
 =?utf-8?B?bjRKWFhDTTFMc2dXcnlJWGZtRGhCREhIeUl3bU96N3BqQmtXbWpHTjZsaklm?=
 =?utf-8?B?R2ZJWS9CSW5aN0piVWFTNFpuRGg2c1lnOSsvM2FtRjNvTHZ5aTlwZXA2c3RM?=
 =?utf-8?B?Y2x1YkFmR29UV1pHeGY3QXg5MXJWSDM3b2wreHhVM1A2THRPSk4zUGxJNDFH?=
 =?utf-8?B?Q2kxQ1g0SjFwbEFldURkdk1MRzd3OHFtN0hYcDJGWCtLaXJXMVBUL0F6L3Nk?=
 =?utf-8?B?L2dXWENYMXplZFQzZ3ZYTHNNZzJIVTJRT2dhdHFUVkk1eXdIa1VkUVZpampp?=
 =?utf-8?B?NkhVMGl3c3djWEN0cU1oSVBJQzM1Y3J0Qk8wVDVqTENtNEk3ZlFocVhwNytP?=
 =?utf-8?B?QlpiNHNsVWt0M0l0ZC9UZml0NnQzbUxDNDUyQVNmN3dWSmtybTd0YWxNL0gy?=
 =?utf-8?B?Z0l3YnozSFowaElZZmhoVjVlaWE5aFgrNnZqd3pIbTRrVHEySlllcHRKL1dO?=
 =?utf-8?B?eUN6Y3FhWUVDN2dQc2pZbnYzamw0WEYwbjRvd1ZMNXhJT2diVGhSUDlacjQv?=
 =?utf-8?B?ZUxSRDNPcStjbWdNTkpkY3dGd0NsOTJyT1pCZlMzS2dicHAwY2FvTUNSVWUx?=
 =?utf-8?B?VFEzNlB5SmsvcmdBN3QxV2hDdDZxZlVLQ3BQVk1ZcEdHSTUrUjZwQm1mWmJr?=
 =?utf-8?B?Vmg1NzYzVkt1YTRxTUNETjlxSnJjTWpPaUlHSnRBSDNrdzkvTzJROEc5RHV6?=
 =?utf-8?B?UEl0dnRkb2loZ2VMVHZzQ2oyNGY2RjhGVDJkM0g3M0FJRXNUYmRvMDhoMHFs?=
 =?utf-8?B?dm1CT2NIdHR0T1hFdCtUVW8xaGRRMXdKdllETFJRYkZEUVp3aWZtNUplck4x?=
 =?utf-8?B?Nm1pTW5HcUpJeWVMbzJSeFh1UHY3R05LbGE4M1dUR3N0UmVBeFBxM1dzN2o0?=
 =?utf-8?B?S0YxVTMvd3REOFNTWVlCVmNONmU1YmsyY2NHSGRNaDV1dW9FbE5udi9ZZmIw?=
 =?utf-8?B?UkQrc2xpMmZ3TDhqSW9VYlNraHpBVlFtWjNJbkxaUzJyUVJwS2M0S1ZvMVFL?=
 =?utf-8?B?TWlJaWlzdjRMdU5EZXBzaWhpT0NTb3FxN1R6eTBndTU5d2xiQmNYM2k3QSti?=
 =?utf-8?B?WGR5R1JvR1pXTzVaWTQ5cGYxbUVzdDVYWEQwRHJheG4yTGY4bDdjZnB5YmdZ?=
 =?utf-8?B?ekZSWC9wTjloc1Fpd3BYSTFhczIwdmptYk1pTVlIaVlBVERkNXJyWm9zenFJ?=
 =?utf-8?B?Zmsycys5VEQrVzJ1SVg2dGdBRExyTHBJbDcySTNSOTkza0d3dXY2QWEyNHBP?=
 =?utf-8?B?K3dLdTNJQXQ5S1N2MlRLa21ReGxCaUVOdUQ5YVRIRUJmQnlZRzJidEttYWRM?=
 =?utf-8?B?NXcvdFFCRFVqQ2s2UHREeXQzTXNEcXNVVkNLUytaWHd0RkdVZVJnSTNseUZt?=
 =?utf-8?B?R0xmR2EwMnZNazdmVFN5anplRXNlV2JXN3ZUS0NTbFlTN2RYN3ludz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74eb2ea4-95ee-4602-da33-08df25408f8f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:32:12.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urozc+bVdXgrVY92zrZq47DfyBQTuHrsus3oeoi98ObKZKMH7HA7LSVC2rA6hcdqxvBDmzBBkpKrdmqSuuIdEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8292

On 07-Oct-26 17:38, Alexandre Cassen wrote:
> L2 to L3 tunnel reformats are now released to the el2tol3tnl pools.
> 
> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 5a172c572a68..44b311b4532d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> @@ -1398,8 +1398,8 @@ static void mlx5_cmd_hws_packet_reformat_dealloc(struct mlx5_flow_root_namespace
>   						    pr_data->data_size);
>   		break;
>   	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
> -		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
> -						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
> +		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol3tnl_pools,
> +						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
>   						    pr_data->data_size);
>   		break;
>   	case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
