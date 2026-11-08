Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794141182;
	b=SzakYRjS1Q7Etg2/d4XIY+EZH2nTGeruBMQhHssvjYfnX8xKUOj6jByu+IDkz4Lpxw/w
	 B9iw3Q2tjMPqvId5WBkz2ROYAtjCCBUdsecBzuH7F9gy6kQwquvvXH9s8S8X2W75DEyaO
	 yZnL7YZHJ2KcCPA3i/NrAJi5lblvNZ0BD0gWFnFf6BMmB857V5PUbNtRuoQRXkXFN6BFD
	 JDqAuUsg8/2W/zBAbmuUWB9hAuU4dHdkO7yvRK2sPqOeIL2LgWA7V3ShtZeEFRrMwWpLa
	 Z9ccQTFGoTvZ5LySfq3RZ6cwDudV7nA+JudPMNpauCc03TpzSWKuNx8UCmDulPtxR/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794141182;
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
	bh=5tFx/XmrPq9cE7QowIQKQPkRgRd/hNVbjnQIFgRsRc8=;
	b=aN3/0gunlwpBONMWKj6Pr3iC/2MVz7fwPfiIuTiP4plFuKCpDtHb77Zab8yEjRgybvlt
	 l4aWavqfA/99gej3Kr+c8We349U/MV1q46ejKj1fO6yRc+D6AJ8anGRJgOwYEa8Iv96Wh
	 8Q2qI9jexvYBKQ5DMEICv3aGbWZbJgitaynjtwgfQeiUvQNqJwEc2odXSl1PaYo/pRNQE
	 pWTSxnd5WIhO9PjYw5JHkHlULGTRxHz+ZNGTpJzKv4WeK/eEvtO/PI+h/nkEEG1rmsO2j
	 ZBwxkU+Ksplux/KQ9vtxYNb6yhZxy86RabkqoJ0+AfMNFwQZWiIE0wWRnRWw3eZhrow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aamJ1nes;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.31
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F16606EE8A;
	Sun,  8 Nov 2026 12:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42F16606EE8A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aamJ1nes
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YAX0Gyeil0GU58lN88H/fQujqG4bLN0wjvVSMYis2m1w7tqPYAfHA1+eIfledfFZOGcl5lrVPpFeCFPfu2WRzKi6LgOocqU7dVBoYagNjjn2napQXdcILF5XNm5tDqvHKOeWNCt7HpUdirEsVZI8jeeXNRDjON6LoPj1mieZrWHUKnWIv1en4opZDlBzpQ8rkoKxKpUcHhNsveh5qrzZ910jwYhRdJi03NsTM5hWYwsy6u9yJeIP3D5+LuiG/VLe/RNjMOhyinWnORzEiAjVQ5hPzq5WOvKuqlgxKLGW+BnPiWDeosPDJokBJbX5RF3xwQubbIha2RhSJVwQolWntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tFx/XmrPq9cE7QowIQKQPkRgRd/hNVbjnQIFgRsRc8=;
 b=hxhoPl543R9yicnSaenc0Wi0JQaKxpeEBXew1ZNKQurqeHFJNT/EnhY3vwmq+cRj+QUN+fh/ufsJLrdP2Req5EcQce/FEGBsFl21QEyXIP1V3g0J/22z57tqSniAkG1lgGwf4kx8zH74aLuEq/Z2cfQK7CCvfEVY1xFzXW8Fou1Ml4k3SomsjsX1Aiqb62epo6TnIYAWHMs/kJcFDHQqEGHWG+kRa7Jr7O3UvP+rHQlCR78+c5//jMaW8YXaxQM/CjM78QxN3zY+tH4DkbNyqOiz5KP6rHZwMkzT7nKDZVGKxg/J/HceWB9+fCIvwYBROAWS/h8cEIGboypEQ20+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tFx/XmrPq9cE7QowIQKQPkRgRd/hNVbjnQIFgRsRc8=;
 b=aamJ1nesGVnig+WXy114gogQ4AOItDGwS+8UHFX2YftPK8yboj5X8Ajv434edorPPSEpysxGEsVuizMS8ZUtdP9wPfdGV9HePg/0jpDjqIhznjubmaPFd8aDtV0s8zbZ9rc9GjwQEgy4P9vBHT+XhLaganvvKsp/9U5T/34PJX9JWXquNYJTv6rUc/nlhbLBF0x0peIofG4t3Hgrgz3NYkQZ/9PSS1+z/F0VHPCHUoStW3y4X6bPYSwjcpQialhEIOOexoNm9Psf4iHfJKJ10bb/5SHLWo2lbtJxtwypGnXOpM9dJyHMYtGicQg2Dqu2yAHgbfonnlujtNPahcYshQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by LV0PR12MB549960.namprd12.prod.outlook.com
 (2603:10b6:408:3b6::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sun, 8 Nov
 2026 12:32:58 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 12:32:57 +0000
Message-ID: <fc44a751-ef19-4552-8968-c1f6a53b9f63@nvidia.com>
Date: Sun, 8 Nov 2026 14:32:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Fix queue stats access to queues without
 stats
To: Breno Leitao <leitao@debian.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Joe Damato <joe@dama.to>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
References: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0017.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::7)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|LV0PR12MB549960:EE_
X-MS-Office365-Filtering-Correlation-Id: f87d1ae2-3c64-42a1-aeb8-08df3d946b30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|261026121527099003|56012099006|921020|11063799006|261021123027099003|261026140227099003|261022075727099003|261102123227099003|261009223027099003|261021121427099003|261022105027099003|261028144727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	J/t0/1cnT6oEQY6heOCTMNmRlR7UeW4wyrZPZa+IyE+QvuLyE71j6bQYgZLusgUfYejE/fiDyydDzpRLJShEl/MOeEfQ+ql+rxloo+eaVcfmsG3Lr8b/iHH2H/bu+zMrsRM0aKglAy9esPz87EJGPyRELyXjNUAo2tLVHvqYkKLMCk+zkvLISHQNLhHeJfQ3aWgnkuMOp3T/QqETIq3gUEh6lcBrMs3MaeweI1qHBl6WD7r74RVxHVVI5HRKZvb143qbAwP/8FbuW2FSH+ZoeUFrbzzto/7eYmZNwAQY41PyO4eEmjlpr6EA0TknOwwxre4o6vTbnhj7rqyOch8v20LS7NRFwmaNkuikSQwdl0Dvtd2MlXNWBfkMZwbGiBzxLDy4eBFv0TLLKgduD8wfM74jvU1y/5v0OO8nvfllrIiq4okvAersw/nlVAyZIPhA9N1FlTkubNH4T3n2G46OwJpsgcr5QVNW30dL+TzLr1s1AKOwxhoB5tyUnMJAgrst+82pdFcnsVjq6RScjG7xcaffD6UULL/Ikg3WkgVE4eyH8uXobGSQ2CKQafUzvGeBE0yGbJj+CpQzCziKoEG6bmiYh33icYXso0t8RDgFSmzEGXWq7HL1niWIm8VOPBgyHLsMDG/QPuPySLAkXMnzs/mPMWzqIKCjrjVmafZdGXyiPHYh+6H3pq81iMQB+gmoqs/VfjFhH71F61ageKTdVQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(261026121527099003)(56012099006)(921020)(11063799006)(261021123027099003)(261026140227099003)(261022075727099003)(261102123227099003)(261009223027099003)(261021121427099003)(261022105027099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K20ySmRnU2pWeEc2N1NIQS9sTXEwaWM1QkJQNldKN0hMK2tQZUF1VHFCUHZD?=
 =?utf-8?B?YlNwWmo3QjNRRmRqKy93UEpzLzIzb05LaFdMdmV0WHZTU2RLN0o1ZUx5NlN2?=
 =?utf-8?B?YVByZlNadllyeWxpeHRUc1QrZkF4aGtTbklPMndFWFdBcHZpVERRSGJFdVB4?=
 =?utf-8?B?ckQ5UnBZRFVWQ3N0ZTMyZmFMaHM1TUlsTm5GeEswLy9sbVZqcHdwaG53dkhU?=
 =?utf-8?B?Zk9IKzhqeURsYTdRMVl2OXQ2c1M3ZGVCQjZWbURCRUdwaGloM3F6bnBKa2FT?=
 =?utf-8?B?eksxbVBjYktCdHppNDYyZ29URWhFNS9jU0RHNkN6UDJQYTdBWVlhZWZsMlRy?=
 =?utf-8?B?SGVMUnFhM1FOcTB2ZEtCMmFzQSsyYk4yZmZqcnhscFpNKzdQbTE4d0FTL0M5?=
 =?utf-8?B?anFlQ3pKc0pwYXV2R281K1EzRW15Y0wzRVkwR1RGNGxoOWd1cnJ0bm9lMWN2?=
 =?utf-8?B?WG5xRVRIemxyTlIxazdOMnJpbVZlcHZVOEZDN1pnaU1pbEsrSW1ib25kbElN?=
 =?utf-8?B?ZnFPdHpjOVhaWVZ6dDJ3cVl0djMybGVmWU9GZ21tSGVuUXZzanNkbkdCYW5J?=
 =?utf-8?B?MnM3bTNmV1BBMTNGaDBDM3MrbnNuTng0eVZaSUpHWlRzampOc0xFU3JOVVNu?=
 =?utf-8?B?Z2dvdWVkZ3c5RFg3bUpORVkvZUdJSjNMMk42WGpyWWYxVnMrVE5rVzFNTmwy?=
 =?utf-8?B?MUpraThLSDFrNGFxNFo2ditwWFVHK1NVYzRocVZCSUVjVnlDci9nSjBQU2h2?=
 =?utf-8?B?REwzcEtCKy9lZmJJSzEzOWhJRllYczhsVHNrWGR4SXEyRWRwMTVpbEpteEcz?=
 =?utf-8?B?ZUZBSEVXd25QQlFVNEUvbVVkRUdUd3RzeTdZNmIzeWNlWU1BSmtKQ0cvMkQ2?=
 =?utf-8?B?STdWbTRPWHMycE4xb2l0bzNnWFVPTHY0YzVKMmJXYmYwSVR4K05ndjJwVmhi?=
 =?utf-8?B?bzBRZVdRbytKUTlZZHRuR0tGUG4rN1RCdDZ4RDd6U2xDNGY5N005dmJveEtu?=
 =?utf-8?B?V2J5RC9WanV3YVRSK1BoR0hUU0hwemJxSThkT0RJRUU2TVpaamRsUjgyYVpu?=
 =?utf-8?B?aVZ4bTZHSHFsRFZ3MysxdGt6clRSS3pwck45TUtndGhEZXg3bmxwWm5lVjJ2?=
 =?utf-8?B?a0V2Rmt5RUlodnNwdUdzbXZtckR5eVIzblNLRitKa1B6eTNBa0FsTlF5dStH?=
 =?utf-8?B?SVUvT0l6THJlTWxQYktIVlhQV0RIRzVISXZBdmlIVGEvL0s2RnlmcGwvTEFJ?=
 =?utf-8?B?TWtFdzROOWlyRjBJeUwrOTVscGZLd1lrbnZBbmI0TWZrelZybXJzZ1VPbU5T?=
 =?utf-8?B?NkQ1dk9WWlR0SnFlUEtVaGNrcFBhTU9ZM3dYTVVnWjlMVXlCbmlsUXB0MXpT?=
 =?utf-8?B?VXFrdGVjU2JmYm9RZkZ2OVZteThuSHMzQUVIUHlZWGlkc2RaMEQ5WUlZTjlh?=
 =?utf-8?B?citJckJPWldIZUZpaVdBb1ZQdk5rZ3N0SU9lQk0wYmJtRXJHa1poRWJCc3VB?=
 =?utf-8?B?cWdYSWNFQmNtUENtUTdaZUpyOVExQTVaYUptV1ZsTXRnczlUeHRxWmw1YndS?=
 =?utf-8?B?czFjYVZiekI5cm1iaExrQWw2eDZlaGlvQXF2YWZyOGFvdXZLSDhPS3JXSzhX?=
 =?utf-8?B?MjI1cDhxL0xqRkVUS0ZLcHNqMThOVXM4NG1ISWluQ1kyczR6djhnUkZIZmw0?=
 =?utf-8?B?TVpLVFV1Z2xjQVhaaVdLU0wxUXdBbHF5a2Fpb2YzNms1SXpVRExXOHEyc0Vh?=
 =?utf-8?B?VnloYitNQWJFMHNjNWh5NFMzeTNSS1FqSkQ0cHluVW4rVVUxY1FUL1ZyRDQz?=
 =?utf-8?B?MWJEQkJNdE5YQWFmemNoK09sbzc0eVI3QVQ1Uy9mSE4zK3RYWkhoeGgyS2Vn?=
 =?utf-8?B?bEh4ZGhSSjJRYzNHVE81M0wrckt0UWcwT1lpclZiMWZlblpSQ3o3cWlPNXZh?=
 =?utf-8?B?Z1diSzE3eEJMNmd4ZWtyUmJodGtyTFMzb3ZRanVZcGpVdEtwZ3JEY2FpWUR2?=
 =?utf-8?B?bDVtT0Nib3dYOXZhYTJLajdtU1dFZlpuWVpHa0pWeTZrTlhSVGsxUG11WHQy?=
 =?utf-8?B?d0RxSHVqeURFaFM1Tk9sQlloSFpRS0U1NCttdjhzaThlQnFTdWpqYTViUzZN?=
 =?utf-8?B?S2xBbFI2ZzZiSU1vS0hVbEZteUdsUmFGaXhYUjVUZHVXZzNGT3BFdFZkSU42?=
 =?utf-8?B?M0ZjbmRUSFFKbmtadUFJL2VaQWtBMXdoeVFBUGFsNHNHeWVJMmRrdFJyVTZI?=
 =?utf-8?B?ZWlEbmZ0dXF2MjVSSWIvR3ZscWRIYlVXL0pxVktHNDN5TE1QbDROYzI1c1hY?=
 =?utf-8?B?RUFlSDVuZWx3dE01dUw0R0pWSXVlVVlrN0FUU24wY3NkNm8ySXVWQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87d1ae2-3c64-42a1-aeb8-08df3d946b30
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 12:32:57.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHsm/It47fwpk7ZhAB7aKycms55ekCpJ7rRJxWahLXGSFfb3368kgrnIm+dO1cxG8H8B6AJNQOY4lUxCQ0B0Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB549960



On 04/11/2026 19:04, Breno Leitao wrote:
> I am seeing the following mlx5e crash in the Meta fleet:
> 
>    pc : mlx5e_get_queue_stats_rx+0x4c/0xc8
>    Call trace:
>     mlx5e_get_queue_stats_rx+0x4c/0xc8 (P)
>     netdev_stat_queue_sum+0x78/0x480
>     netdev_nl_qstats_get_dump_one+0xf0/0x268
>     netdev_nl_qstats_get_dumpit+0x7c/0x1f8
> 
> When dumping device-wide qstats, the core calls the per-queue callbacks
> for every queue below real_num_{rx,tx}_queues, regardless of whether the
> netdev is up. Some of those queues have no stats behind them:
> 
>   - RX stats live in priv->channel_stats[], which only has entries for
>     channels that have been opened (stats_nch). real_num_rx_queues can
>     be larger, for example after the channel count is raised while the
>     netdev is down, or after opening the channels failed part way.
> 
>   - TX stats are looked up in priv->txq2sq_stats[], which is NULL for
>     SQs that were never activated and for HTB queues while the channels
>     are closed.
> 
> In both cases the callback dereferences a NULL pointer. The dump needs
> no privileges, so any user can trigger it.
> 
> Return early for RX queues at or above stats_nch and for TX queues
> without SQ stats.
> 
> Fixes: 7b66ae536a78 ("net/mlx5e: Add per queue netdev-genl stats")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
Thanks for the fix. IMO this is the right minimal change for net.

About the Sashiko finding: right, with HTB configured, the HTB TX stats
drop out of the device totals while the netdev is down, as
mlx5e_get_base_stats() does not count htb_qos_sq_stats[]. But before
this patch the same dump crashed, so it is not a regression, and I'd
fix the accounting separately.

There is more to fix there. While the netdev is down, PTP TX stats are
counted twice, once through the stale txq2sq_stats[] entry and once by
mlx5e_get_base_stats(). And the stats of HTB queues that are no longer
in use are never reported.

For net-next, I suggest reporting per-queue stats only while the 
channels are open, and everything else from mlx5e_get_base_stats(), HTB 
queues included. This follows the netdev_stat_ops documentation ("only 
currently active queues are queried by the per-queue callbacks"). The 
per-queue dump would be empty while the netdev is down, with the device 
totals unchanged across ifdown. The comment above the new NULL check 
would be reworked there as well. We can send it once this patch reaches 
net-next.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

