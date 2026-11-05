Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793909852;
	b=auQvLX9w5uJAMwipIo+MHimBRnElRvXlV6MdrDa7XPOPGI81KNGPS14YGo2cjnTLwHKE
	 rGy61tR85wIb0lGhMU0TH3sMDZCbEB+DhwRPOP63niC15xNZwT7BpC8i3oumG0I3P2xOg
	 k5HMuCdEMvvH4SEBNmMZZrVJCJKSSDwFykXpuYU+dG2jsRCUMK0+9HbKJ7RJo2O3ioOQd
	 tEpLYb7AtU+dnXmgSLns9XglHVSWDfi4XxwIhklm8RP3g1WXQt6Yv6ngC/jWmdEQSzpG4
	 M3tVQHvjq7c74rBIhCZpWPcTXmCWWZ3s2v2KarYdm9hM4A0yLXxrxUj1VYYPVplhcBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909852;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Kn6fT2xJLzCCyoJOOxQgLx2Izft62XZ9M4EFNOmV6R4=;
	b=aE9TPHhxM2Td908/W4gq/t/oInNDSjg0d87cRHVDtIEADEQ3qwBRpFUNYhkNeHAKS1gO
	 pfPF90Prbf5Lv0YcNnu3zi4jvbHezFYQE/cXED/ufsgsw39vwCDHwP9qt1adp50XvNtYq
	 kgdDjajepKKqKSjlbdelTOMtp5BHr638o680wvwEWgSfJ0Rf5A4nPodZo2tgalzYa93Dq
	 IrCOG/nyGH3xstuusWhRtoc0GY5Ogp4R5sFpNFmOmdmfKRIOO0/HKtIxRIjrQA3IqsfKQ
	 h4dq0kGyxrVPhIKJPsX9U6Z1M+yy83N4svZOWXbWBqWYn4fZEoorxkuVroNLD/elnlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZDd7whRd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.8
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012008.outbound.protection.outlook.com [52.101.53.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCCE606A31B;
	Thu,  5 Nov 2026 20:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CCCE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZDd7whRd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vX5A7khAy5fiSUO2Kb7jblCZRMKnhs4ssnheVvTWRHwkxdSESNvM3qnE3C1ZwYRu/SpO56GfHW6lr2U6q8xn2824y14jIEpT6kBGtkijVPPmMgOHSX+83duKaijXwZj53pPQaEhv+x7wQyuhJmBM+h4boaVrkxEkUXsnuhvSixtucHV1wnSBx7lG9fgF67xQ6oR4YKNIdsuD564kRXCvNzXntI+CGicULm/iG/BfRTtjuAJNZXoCkzyx+EY6r62LTmkAX0yaOzg8qVSPohOfol8J2V/wU8ToaAgu8gX4kYKPtNkQB7U0XgH1JQgHXoHqPB7PRqV40LM4CCQg2I+i+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kn6fT2xJLzCCyoJOOxQgLx2Izft62XZ9M4EFNOmV6R4=;
 b=JK2X0DnkcaC6Q07MPD1XLR6O8u8iZZHbucACz26YNbk89QCZWDTJj5AVe8y01Udf6oCga/p0wVXWubeR1dcHcTQoyAH7lbA+Fc1FrqAIOu3Qp2Djuzk1RK2S7OjGme9Jss7gGOa72TyTt5vpsMfndWR3e2obeJQDJiZANfy0gOyF4uZwWsO/DjPyi+U2SOsGrf0GUIHHrU9JDvGpSLRSYj5XEl0ttlhNW2IehS+v9TtK0ZsX6zSKI/ZNPaHzJMnNEEmJcyEK3WLiJTXe/nVVVDrLNTf9E0sxMl611PESlMmj3OAeBRwEapNEolNC6eJda0Vm9JTRrYqCMZy56LtORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kn6fT2xJLzCCyoJOOxQgLx2Izft62XZ9M4EFNOmV6R4=;
 b=ZDd7whRdWG4plHrxpqVCdxImbU9cnLJGo6qZ7C8AvsQIeqpPh3OECcDIrYqS2bd7HczFYJyFClFQviVJ4/4IW73AX5yRR2JDnYa8GGGMnxSXQpjpeAT1j+u9+9LQWpf5KX00fg6NJPPjBRghMXxUNj/86r8pJ/zEkOAB9fXWmshkKvhQf01phGtuFtwKVGkbSCP58lhOPFtEbpWEGEtwDefur9kzTqSQ9QORzpdHgMFkq114olM2YLxUYEeBA7NooFz+ZPw33RLb91B6WMYzpvCrTGU2MIN4PpPHBCR31TGS3jjQ7bUzJ/8BqV3FpN70F9slWiFunxreiNazz9jpCw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by MN2PR12MB4254.namprd12.prod.outlook.com
 (2603:10b6:208:1d0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 20:17:27 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 20:17:27 +0000
Message-ID: <371a0db1-0da2-40b6-ba83-60eae9bb211c@nvidia.com>
Date: Thu, 5 Nov 2026 22:17:23 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx4: drop the unused is_supported callback
To: Peter Morrow <pdmorrow@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: Simon Horman <horms@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261103122109.1798144-1-pdmorrow@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261103122109.1798144-1-pdmorrow@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::7)
 To IA4PR12MB932075.namprd12.prod.outlook.com (2603:10b6:207:12d::15)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: aae8555a-e339-4fb5-6859-08df3b79cffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|18002099003|22082099003|11063799006|56012099006|261022105027099003|261102123227099003|261028144727099003|261026140227099003|261021123027099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	JOweGkhaCwCVwGcHwTX54Lj7s8mlLQRcAG33CeG4/cQbqfFQaDriGiBYvlO+8p2sNkM3Bcdwn949GTztYpox8pzIdaztu8u2kToRjiSxo5zdRyQOVcVEcn0jlXuR5j7A78b7NtG16HWKZ14KFIZvoFrYJH5B+aArO8cQPUollSfEH94QRqgm/178f3LKvxvvviSURUxiziqiHm4fq1Lpv2E1IVWRA3dbDjMvnj3eKSLLBAjpFKT8MocCUDRjDN0KJIObwBGSM3HL5D7AHr5TJNPWLWedTPeiT+UZMGwjTOmvWsXakkyHPthVeBuk5MAYU2OWf00/SM6x8ltcbVikn3jD528Z2x6RQL1l0hHHPjWDRUG1/sum2pCOamD/IXiZwoScj7gykKzvale0gnMfvTzTeiyxxgw3/ontAVdnJbwG7BkP7HWudWFQo2IvNsHPWUfmnlWcld+YmKDdG8MPkhoX3ZL7SobxWm3foYH7caoPF7wQxyW7B9swnZjcYDqp81XzZU2TllvtbGfqsem4auUqMsGq7kTQ/LMQe460UjdadvBoUYbdjEA7uZqj7Gi5lPeJegp/5NzxE/NTdZyIZgYczzph6UcxdS5s5fMHAhE16JDs1MRs6zOPabN475Zgyw/DdxkcMmyM6PPinmZNttX5r4s3aLXHT7+tfy3hK/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006)(261022105027099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021123027099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVpVa0hxUCswM2xlT1BtRmFGVjFQVWVIK1FKSGVXK3ZrR2dDeVFvS0s1eEJM?=
 =?utf-8?B?b3lpcjRwSU05bmh1akpGalAwVlJ6aUFkanVPcW1DMW5hZFVvVEgrYXQ1MWY5?=
 =?utf-8?B?aDhjNWNIT3VQdjF0S3VpTklXY2NkMGhwTEFmQ0xMeEFuakRIWW4yUG56YzFO?=
 =?utf-8?B?bGJaTG5kTUtXVVlETXMzYTRmanRlaGo4UHBoYjBwUUNpaWphNWVHSmJ4MXJH?=
 =?utf-8?B?Ri9uUHhnZ2NteitlNyt4WjhBMXViait0L3NBMm96ckNSbmgvNTFhdGhhSEw4?=
 =?utf-8?B?RVR1TkZlMG9HcDI5cDBocWlmTzlWbnBwODZoOGdDdTZ4bVZma0RKWU9Wd3Vq?=
 =?utf-8?B?RHlCL2tDcWpWNi8vdml2eWNXZzJDSWFyWG1jczB6Q0t2emsxam9OTER0b2FE?=
 =?utf-8?B?OU1YTjVYSzJaYW9hQmp1Wnk3VHo1S3BwZHZSQjU3clBydStvTFgwUGRCVFV3?=
 =?utf-8?B?RjdtODV0azA2dkdPcUFiMTkyUm91NTlReXMvRjNmaEJNbzNBdjZHRjFOdHNH?=
 =?utf-8?B?eTlJQ2ZPdTdTUStmd1RadWtSM05xaHhTNk1qam4yMVlTeEFSYmRwU3QwRGMz?=
 =?utf-8?B?RVM0eUYxNTJUeWs3anNRSjJaOXk0QzJxZnQ5ZlhPY2dTek9Td2kzN0JaWVFi?=
 =?utf-8?B?WFdSeWVlYllhUGNxV0JNWjdHSytmYXduNmcvKzVpd1BqREhYVTM3bGRBT3NT?=
 =?utf-8?B?N29CSlQxT1hkTmVoOFYzRFMvYkpQUDdjV2lVUG9Lbzl2YjBRY21CVktscUh4?=
 =?utf-8?B?YzVkclhhQWx1dnhnMUZzSFNuWFhONHQwRmZrQmwwSGZjR1ZCeUxwaUczUnhR?=
 =?utf-8?B?UVp0Ry9wenh1RGpnMFpUbjFLbUJlRXFzTUhld2oweWZOcUtmL0ZHUi9JWExp?=
 =?utf-8?B?SkxMYnFZQVVGenpocW1xRUlNelkzWlVMcFZHUUJBRTJRYkRBdHpVREl3K25W?=
 =?utf-8?B?OTY3QnVod1l6ekVHVXBUQk8wOStBSlk0QnA1ZjRoZlRiK1ZOVVVEaTc2TG12?=
 =?utf-8?B?ZUxJS0E2OEc5UDRxcUpPamlTRDUwd2tuY2E5TzlCaXJSdXJaQyticDNCTVJJ?=
 =?utf-8?B?bXpyT1RKTy96WDIwa2lyNzlmcUNwYUZlMEVtVUxQMXBBd0dnb2k3b0dzOUZj?=
 =?utf-8?B?clZJdERGKzN4NUFNa2xQdWk3UlU4K2xrc09MSHdDYSt2bGtIMllWRjRjc2hk?=
 =?utf-8?B?ZFVGY3NQai9uS3pGT2k1SThYN1FMSksrRGVKRTZZY3Z3MjFEZWlvTGEyQ25q?=
 =?utf-8?B?SVBLc29MK21QTFlMYWR2R0VOUkIrU1hYTlhmY0hpNjEyZDFsc05iSmxSdmhn?=
 =?utf-8?B?UG5VSHF6SS9PdTdOYlZoV1lUNkQ5UDZ5K3kzQ3pXMmQrcmpTQjNWTUREUUo3?=
 =?utf-8?B?cGk4RkJWZmZ2R3lZNXlLSndNREJYMkpTOE1rNnkySjJNTHpVUXR6QmpiUUJt?=
 =?utf-8?B?TjNKOFBoMWhGRGlqT0FFeE5aWGhaK2cyUmV5N0p6enFBbGtkcFNteDE2VHBO?=
 =?utf-8?B?NWtucUdPQzVvZFlTa2dzeXMyRTh5OEtYZEpoSjZMQTM5dUdjd3NPc3U4V1pF?=
 =?utf-8?B?eDZ4bUlTV0hIWTEwMXppb3Fia3NWdlU2KzhTVEVjREJxRGZuU1dzMmYzeVpN?=
 =?utf-8?B?aVZXai96MUorMVdnNnJiTUUvOHdKZDY1WGhoUGJHQSswVUxZZFFoYllGOGth?=
 =?utf-8?B?bFlITjBnNTU5dHN0aitJeFJORWNDRFdFSkNyaHVVcFpyWkxyVG1BU2tBOVhG?=
 =?utf-8?B?bkg2d2NsVHgwcEtub2ZXWG1zMDMvR2ZOZHJuaGZNaGpUQnZobmxxNzZGM3BS?=
 =?utf-8?B?SldTZ3BwY2lXTEcvd0ZCU1hJZ2pOd1VoaHE2THllY1dMRUFBb2dXNGJldEY4?=
 =?utf-8?B?Ny9wTTgxQmZoTHVxc05LUEswOHRsT2c0ejczWjNCaWdjVEttTGdPK3oyellH?=
 =?utf-8?B?N2hURmVNSTdHWHpCYTlVV3h1djZDbnVGTTV2aE41TmNWUzhUUWVhQ1BhMEEz?=
 =?utf-8?B?dWkvZWFkMzBqRWFqS0RBUzNOTWVGbk13N2lCNkVvVnNzU1FNT05CWk5NSlg2?=
 =?utf-8?B?ZGQzTkxyUDRuUUNyR1FvV3hERjZ5M0QvM0JYWHpvUVFYbXNKZmthZDhUNUVa?=
 =?utf-8?B?MTkrQXJid05BYmZuUTdEQnFEejdJNjVjYzNRRGQ0c0JocWJlVGlEZ3BDVXFK?=
 =?utf-8?B?eWs0VThQZzZFcnFQNUFxWUFhcE9IdE5BM3dPTzZDUFh6U0V3Zm1kZ1VGOTVJ?=
 =?utf-8?B?OGRjSjI2bkFSeVNFTzBSR3FmT0puSXNCVktJVW5mczJNMjhXZlRuejVwN1A4?=
 =?utf-8?B?NFRZV25KVW1nWTM1NXNDSDVWTVh5blh1N1lHaWtSQjZBTlBzRUhUUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae8555a-e339-4fb5-6859-08df3b79cffb
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 20:17:27.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQLzjUF8s62PmbwBiFpjc8VorzJMbGODrGE+K8JC28kWulw3tKKIbY0IiVoL+N4XGuhUsLNz5hiUyoFgeshHuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254



On 03/11/2026 14:21, Peter Morrow wrote:
> Since commit 557d80138618 ("net/mlx4: always create the eth and ib
> auxiliary devices"), both is_supported callbacks return true, so the
> checks in add_drivers() and delete_drivers() no longer decide
> anything. Drop the callbacks and keep the aux device table as an array
> of suffixes.
> 
> Tested with this change applied to 6.12.113 on an Azure VM with two
> ConnectX-3 VFs: both auxiliary devices are created at boot, and
> removing mlx4_ib, mlx4_en and mlx4_core deletes them cleanly.
> 
> Suggested-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/intf.c | 44 ++++-------------------
>   1 file changed, 6 insertions(+), 38 deletions(-)
> 
Thanks for the cleanup.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

