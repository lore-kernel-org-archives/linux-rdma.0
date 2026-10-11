Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCC63EC823;
	Sun, 11 Oct 2026 06:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791701502; cv=fail; b=nGYE126XXjKAs0Pwpn6uR+9fZpWcID073RcLPDeF7ZGXjrSE29K9E6HinFdHl5m7T0UC1Vv38YzmYl8Xwc7TnkdSvGMyyJlHr1uA0jm0Refnqmqez+Cka5bFwkFPDqI9n1Vggj6Pncbx8Ssvl7Cn71vXHvgE88iTVeDTN/+li70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791701502; c=relaxed/simple;
	bh=uSMfdxfIhOT3MzyinsUqnCVamw/4AUmGh03q/uZcgF4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XVBHBnW68CxrSn2SpKVtpEFfoIv8Fc3xhDwsRIX6+w4+m6saZmbCPOhM/swdn8kNUuukB9Ge7iMlSTqktYbtQmfaHFD/DN8xgESaV+0eIaSQ8PRqJZac2CM3T6bVsoM90MrkmPbygr2tpl6KP/QQucLcYpbEf26Tv7QKkZuG/1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vys4vYY5; arc=fail smtp.client-ip=52.101.56.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vys4vYY5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T9K1w5/HA2EX5p0NLNcqKyHe761RESx9coAB9CNxqy9WcTj88mV4Yv7v8ygHo4EqFpDhvl0Y4BgKsg6Sh89G18IOa6We4M+icEOEb25XLQTS0iNvsjMmLkMCWxYhrX7Re4tbt9mGGSiDgJ6UEFjlf3BtGLvpV5h9z2Nz5Lk+eSovUCPyGkRIxlCUAnfPwaFeG7qERUDNSI2RKK9NfJYB0XK5K2PKKertcTHYgIpBR/6P1MnbUZc+loKg2dt77uQFu6j9hYQDrX67XNX6kKsyyMKYiBowkdFwgE708lu2Inia7tSvz4vtXiJvCmT1TrUWuxZ99zI4lcXvQTrSbma7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAqUmyQtEuOxIqet++c/aMbdPQY1lvWhpey7OWc4AP0=;
 b=V3x4r+CgYLDCQi7+UGWi2/ltA9aFZl1TeFXxZRGabs3aL5KJwQ8JbP2I3kuHCu8przs/cg42QuzNYCGx/Lg/F79XYqc7mhfRBRZ1lXeau6OF1HcYYOspTiJgMP/3C3s3Y3xNRr3yZOW00/AreEBdKqbpHKT0fcddmZ63wkV4btKd2XBzoZZKJOgdvzmVXv79Y6/oX3XcXORT9uwVJyuxdiVpz5FQZxsiNBIRARWa1yhOFajAZlZzB/ohUMZftfMe/s3xvDlsol+mizB7oqdWmAeP+uPeGrQ2C4Uh6o6uA4Sj1FbMNYANEIb2KDrm5OhHV0DXj+CE+kFK8+yR5D/fAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAqUmyQtEuOxIqet++c/aMbdPQY1lvWhpey7OWc4AP0=;
 b=Vys4vYY5tcl1ewP+QYBzveRs62zOZaQtCOTH6RIOWlVEOl1htvCxi3v3P6mTaoxOQYrkp9vsIA30obaqTUQFU9FGD9DNZPce+qcVDcJaH15obDnUla/MXXt4jxUqRKCyK+PHJbcJ0E0hWzG8PEKsMfBosDTB7p84Tmz7aauYqr16Cfsae5pwxb6YFW4vSMqEeVmlhA0za8kq/F0pTm3NiT9v5a8huFWggkrKiNwArs7ZuM+IxoLVisXOGaFZH0rPcv4J/Ueb2OMqX68uiZmnlo3Zzx6C58QjLNf3R8foY4m2AAhA1MHtdTzr6BOMtFJwj4hXXiD+BHweVJQqiwsx/w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sun, 11 Oct
 2026 06:51:33 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Sun, 11 Oct 2026
 06:51:33 +0000
Message-ID: <d6dbce50-1f2d-42dd-86a5-cc7528323da6@nvidia.com>
Date: Sun, 11 Oct 2026 09:51:29 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, release L2 to L3 tunnel reformats
 to their own pool
To: Yevgeny Kliteynik <kliteyn@nvidia.com>,
 Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-2-acassen@corp.free.fr>
 <8d147cbd-3be2-412e-ae4a-316c880eadf0@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <8d147cbd-3be2-412e-ae4a-316c880eadf0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0013.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::20) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: a757c59c-97be-4d51-c374-08df276415f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261009223027099003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	MZLLauaLod3eYl66xVJLRR3gWSebfOZU7majP9dBSyOGI9NM3gkwfTwR2wukVD9YAzSSurC9AbXCEvbFybCehIKyNudIsbnYj00CKFTW4wrcoMpiAtlpj5WtNOE/vRfJv/SKxKgmrVPFHvfitx2zEjypjgN5pO3DX//CDyXbuwxqUy9GIl44Yd/Nh2elux5bAzSpecZLyka+G+/8qiXGv1RLp4sd07HZPA9w78+H8o7jtxIHlW4ctfqjLFZfPRXyRlWJC4WO20XxIuuuNEFMAdNHWPBP+xJJYPc3BotXMkqGu/CF07sss3cwiNq5B9+jHM+AVjzMjoWpszCWf92PXzoEufcOi9tllzbzXk0LgBkzHAv7icv3tfIzJ0irl7BAyhKYFBn/7RyvX6h1hw1oiRyDjqoZutfbo7VrtT+d5tjwcFpE11K7VeqB3S2EXVTiljqEvhwdnu/sI7rR9aU1+CXFRaTxUB1pfJ6UkbX8VO7Ru12I2RLfdpYDjctMUHjTEiKgkTsho9Rs8RJ83kgYtXd4sWj8SOaZekdivIHfcgPPLlJ9hWuAOTkz5MJ2Ire1SFDN0lf0y5LQcsSxahk+Fa7FOb1EurisAg10VKTFPEIA2KW0J0d6IapSiXTWy9OA/rXGqh6btf1sCnJwQ8QOHeMiv4b1lvD9Bdm6McLEfreQSgDcB8ekj7rob+FxVX47DKvfSrj0KrwFuOKzXEmPc6C7WhvkvSXEv4OqBzB9smPUbzGnlnap5a1vn56dZEdT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261009223027099003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1dINUNMWFhMbEllRlBnVE15ZEVRcmpFV0FwaCtsejBoRlVKa0dvMlBJbDdy?=
 =?utf-8?B?U1MwOGJGNVFhVDB1Z1AzanFkTWhndGQ4bkNKbnRpN2EyclVQdlM1UVluZ3lK?=
 =?utf-8?B?THN4ZVJuQnJMMmFmQ00rSW1nemJWT2llNVZOQ1gyUm55TjFvNDBDSlFXZXp0?=
 =?utf-8?B?dzB5MFdsVFFUMGdoRnlCdjVTenFKOU9UeVBzOU41Z0c5ekZwbTRKdnd3d1ZR?=
 =?utf-8?B?eUo4WDE1eFgzZjhrQXZHUUpuR0loaHg0dUVMTmtlRDA0ZzRBRFU5M1RjZmI2?=
 =?utf-8?B?WWEyY1lLOWlBZnllQnBNdTlWekpmbUZLamsyTFFYSG81S09ITkt4Y1VVWisw?=
 =?utf-8?B?elE3UTl2V0FaMUJlSkUzQmU0ZHZtd3g5SWMrZDdtU2JUb1h2Tm8xTEg0dHoz?=
 =?utf-8?B?WnBaOTBsbXVUSStjVmdVTXRWYXBPK0ZJQlFBa0ZQbGlxMXZyc01RNTdySUNI?=
 =?utf-8?B?cUpWVHRZTm9jckJXRjNKVWhkSzRWMkp2S1dVV2xxMmg0Zmw4RGIybk1OdzJN?=
 =?utf-8?B?ZGRpOFlWM2p4WERCSHJaa2F2TUlLbWJBR09RZG10Z3IyV1lhbVhFUEZCQy9w?=
 =?utf-8?B?RUZyU2M2a0ZRNCtNWXZrOGVVSWhmdjJ0TlhIY0VGaXJNMWhjZnQ2eGYzSzdm?=
 =?utf-8?B?UVVkcFU0dXVqZWhQeCthSW9rY2JGblpQbVI4Vk5vRkE4eWlXYnpzQ1ZYVm5M?=
 =?utf-8?B?UUIzVnFkTTEzbUVvd1pVZHlidmtaNExRUXVhaFgwQ25VRUZtTjZKZHcyVUNJ?=
 =?utf-8?B?SDl4bVM5YzA3dnZqQU84U2thbk1GTnVnMVdUSDdOMlNzWXpBdGFQOUpUTkFK?=
 =?utf-8?B?UVU1cDh6aGRnNmJGTUZQYXM0RzFCWEQ3d2FjZWJOcDFvdGhjSVBEQjYvdEp6?=
 =?utf-8?B?cGNWZWdMNG5GL0dCbk4vNnZqWU1QbGQ2ajlPODRFeUxENFJkMGowWmpTTzh2?=
 =?utf-8?B?dU91ZzlRaDF2bHBoSG80V3ZPVTlIcmt5ZWdob1lWOU04SnhuK0hRVTQ4M0FJ?=
 =?utf-8?B?UWdvZWE5RmNiL0cvbTBBWmJaN1pFV0JwdGIrVEpDdjV1TzhhdmhwV1djOG5m?=
 =?utf-8?B?MVhOWlFpZko4N1ZwSnhaZXFqa1ZPVkM2Z3k2WEg0aHBobFdnSzI3TTdqdEpC?=
 =?utf-8?B?RmtNTG1MWGU2TERRZzc5WmdpeEpWblowQzMvQjNtY29wMytsc2FveXBoTTFv?=
 =?utf-8?B?ZzNJSDllMWU1MVZyRGc2OE9yUWdSdHkxNTNCVDhmMG5mYzVYMGRPTmtuNEM0?=
 =?utf-8?B?V1lYVVpESENpV2w2UUlwaC9ERE9LdTdNRlh6Y1R4d01XZEFhcC9VYU1LaTFo?=
 =?utf-8?B?Z24xUmFRblc2UDc1czdxR2RvbU9RcjAxL1BDTTkwMDl4UndBaDlHU0FjcllC?=
 =?utf-8?B?UVUxRlBBM05SVmswd1dmM2VIa2ZpTjNYeloranY5amhGL2JadVBlVTRwcjFw?=
 =?utf-8?B?R0h1MVdDYWU3NmNhaG42Snh1bGJ6cUhqSGhvZ2pQZ1prczVFNFdNL3dhcFB5?=
 =?utf-8?B?VW9LUEU2bmRLaU4xQ09ZRVB1Wmttb2dwL1NBVjlVRzM3OTYzZHdEaWRDVW44?=
 =?utf-8?B?Vnc1c2VpNllqQ3FLK21kdStqTDNGOFFESWVRU3NJUkZRa0t6MFozUEJFSk01?=
 =?utf-8?B?NDJWUVpiQldFUHZhOXplKzVRQ2wwSGVybWNtSTlpTk94cjk3SlA3am5aNFFK?=
 =?utf-8?B?b3JjMWExQzNQUVU4VFhMSlZOSHdqaTJUZ25wV0hkRmZpUXJzZ0JZMDNIZE1F?=
 =?utf-8?B?VkphYkcvNkM3bk0xQmtTcndoRzVkUmFYYmhzV25WeVl0SEh6bEEybmF3akRL?=
 =?utf-8?B?bURHQ2xyblE0eGlXUklPV0xmOUZNOUFsTHVienMvUU1sZWg2R1A3V3g4ZE03?=
 =?utf-8?B?YTNOL21DT2RxMFZWN2Myd3hJaGxIcUtuUXFiMzVOOHhLajN5VG9NTVh5WVFi?=
 =?utf-8?B?ckVGWks0Mm5zQktEMWFHdGdqeEdEN2pBWDZmZ0hRR213TG5rQ0h4TDlYYlF2?=
 =?utf-8?B?bWpuS3ZTekJnNVVYK3RKVG1zMi83eFBoSjJoTThiZUMwZjRjclFpd2I5cFVI?=
 =?utf-8?B?QmpuZVNUWDJibG80WDdxUGpZcnhZSDZWM2VPTHVJVm9JdHBmL1hUODdndWd0?=
 =?utf-8?B?aUY5RFpTRFd2UkN2dk1XbzF6YXYxS0RTMVNPNjIxOHRUQml2WVMycElmTmdP?=
 =?utf-8?B?c21kcWprM1Z5RzJRTUJJaWc2YU9qQXlGZU1lU1JTUzkxY3FPVU14VnRaQkZT?=
 =?utf-8?B?eXhzZklGemJNY1FQOThGR2lIZUx1SWpSU2VLaDNmSS9HZEhkOURjYU9pcE13?=
 =?utf-8?B?UGNuZTVLT3dHeGpISHcvREQvYXAvK2tOVG8zOHJvVGM1K0cxSnBRdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a757c59c-97be-4d51-c374-08df276415f1
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 06:51:33.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyHZ0+JhNv6qdAVsxftSu/y7wzbMaNLe/hX15y646qj8LVcOaBJCIbnXm2QFYBF1ZKPyG57NXh/Et71g+euiww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930



On 08/10/2026 16:32, Yevgeny Kliteynik wrote:
> On 07-Oct-26 17:38, Alexandre Cassen wrote:
>> L2 to L3 tunnel reformats are now released to the el2tol3tnl pools.
>>
>> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API 
>> function")
>> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/ 
>> fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> index 5a172c572a68..44b311b4532d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> @@ -1398,8 +1398,8 @@ static void 
>> mlx5_cmd_hws_packet_reformat_dealloc(struct mlx5_flow_root_namespace
>>                               pr_data->data_size);
>>           break;
>>       case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
>> -        pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool- 
>> >el2tol2tnl_pools,
>> -                            MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
>> +        pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool- 
>> >el2tol3tnl_pools,
>> +                            MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
>>                               pr_data->data_size);
>>           break;
>>       case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:
> 
> Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>

Acked-by: Tariq Toukan <tariqt@nvidia.com>

