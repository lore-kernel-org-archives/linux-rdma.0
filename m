Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795343568;
	b=uH15V+jLLhmu1lazhC2aS8GjN3YSs1Fd0jrVWrSdwtt1QTx5VTSN9B9AQ6n1Mru5euNt
	 XQQImPr+d2e8CtFaoAsrvToq9QoEsqsfxdPSMuflAmke5SUQm+alJ8aUjlnbCdEkAWYB3
	 I4m9OMkMhQMwHzvfJhKmKM1zvePNInGyrw53toTeY3bcSWzEkhbNs1sRbws+YobXQNxir
	 kIB+UOTkOSIZ9xkXTxk7RFtCW5cuoQHIdQE2Ilg6+Hpjw5H2Z2BFLlTyCymknYWmZ4fjQ
	 pa+Xm9v0qoweKZF5huIc4+VR0oe+uPcg9nF9mC1nglVWPR0pfiyLn3tQGr+QQUhBGTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795343568;
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
	bh=hR3BFBLSOtA9cDEJe8Z1c+gNUkfqMfMsIj5vyBJQJTI=;
	b=XsjhGnj0vp1AthJLa6ARGkLhWfkQRV4RbPvD9JgaMrFC6kOdq49nHXzKCPyuHkCWsa8A
	 5aERF9zhg0A/WfLuI2mGtzTLZcpqVow1LEkJqzByF6WYn4nxjd968NZAd2LxnlNdWBUcK
	 onP3ssGV0xKrc1WDN6bAC6pWuBgskFAMYBCWNKfZd6paptx4SnHqCA1fkQE+AMxygJxTr
	 FNb5klT0pUeNbz4aKEa7bbUOSiadQKc/RtML+dP7b8cetSjjalumTF0dKpWcJUQcKGqOE
	 SAJxAIfqOx5+TBNWfODH4gymB9aajvBI+JxMRkFzQJWmcHeuMD0YdL64JzPS2pk1ndA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HoUmxypT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.25
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39BF606A320;
	Sun, 22 Nov 2026 10:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E39BF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HoUmxypT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXaZ+BMJLWu8ywnBLEEcmlAa81LnPrHNOZDqycuMcKh86o8zwHv+CSeFSnNMA14JKvygyiCWI87qU2lctC2PwKxrxhkOS5wNa9dakq4x5k4JNYQjWsTw63P3ZxSnSExi51kWnopgtd9oIeyXzS1Mrj/TGGfJkbDI7Wvx6RPTObHdnWIZ8vJoVf3DwZp4TlbVEDh7b4vdrfLcFEnCVugPR6XLEwvLdrh9k5yRuZ/luT9OoFC0PyXcncZp+fJ6tWiJwWun+6CQnJ+ohSU7yQ9kerDQZb0loCXsOFeS/cfZUkhwkK2cDsNKxBLEPMNV11R0zwdpBn7GUioWFgDP3740+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR3BFBLSOtA9cDEJe8Z1c+gNUkfqMfMsIj5vyBJQJTI=;
 b=hFKnct1un4hrweMawioggQh0tK+rT2Pe2DcIM/33Z+yuB+5mbIrye47exKnJQtfq6BSMcqlazcIiwLgdQ0NIA7j4LRUToDHsRwqdNODzj1dVFm56/W9e7xqgTkf4bRziP/CHLk9m02fbMsAUtaORnnoorRRo9mTateHOJjN4BWkYJ4daqGJJzc3sNghrza95lzJ2AzVqixOHom2zx6tte9qNn0juYe6gviuR+7UaFMpch2x2WK/9jD6LvqiLDS5PlMrdgWfbr/MWTOylca66YD722Ge07rRrXBv5sP+I/xNcAcMAwr+Q6jr4h1B/7avjmfkEDA/JfhZFmdxL4FGlVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR3BFBLSOtA9cDEJe8Z1c+gNUkfqMfMsIj5vyBJQJTI=;
 b=HoUmxypT3yTkJ7y+dVLD9ROGsmeobXu74kzsyRkIpuAj6zC5YTCbNwONbRycPpi56tKnrs2B0vtbGZuV/m8rnpNSus/ObVnk8z0uA7eZirKeQoB+80y5eH0Ym8RExfhhN0A7/vdbaNnMi2aRiDiACjIi0wFNrBAujDBmdwcbZL/zjjA3ae6bH0AKMTNr1OKhveoqjgDG1DGDBBw2BDOoBakIv9IHzpOAHVNwfaCa+3Taxe18B6sDENo5aU4OCmv2jrJgHVyyN9pYuZ/t+FlHjdQSpdRSJwIcTmsio683ylV3v0qItUSTIkDlRq2dbSpAnMMX89p49v9pdpz/fvz6JQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SA3PR12MB7832.namprd12.prod.outlook.com (2603:10b6:806:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 22 Nov
 2026 10:32:43 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 10:32:42 +0000
Message-ID: <0caf9acf-2640-40b5-b638-7d54db90f577@nvidia.com>
Date: Sun, 22 Nov 2026 12:32:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/11] RDMA/mlx5: Preparation for SD support
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Sabrina Dubroca <sd@queasysnail.net>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Akiva Goldberger <agoldberger@nvidia.com>,
 Michael Gur <michaelgur@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SA3PR12MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfe0274-6e23-48f3-b00c-08df4883f0c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261021135927099003|261021123027099003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yUjupytVKiXx2k0voc6bLdvhx+3IPmhfkfQWZPCt0IXHPKZwitVVm7p+ZnSTlzki/VjHweSlXlqvDg66YsEsQJgxdazS2DuWNllfAl/oZUjwQ/qUcirHcwAxpbOClMMj6WN8ofWlSEYoL65gmNfl1e8df96CMrpuZgt+9Hn2Y7gC8yu7eWzsefQcmA/yNqBa3j1+Yd63iIglq8H2Qo4kKs+8dl62w9zQPnAI1UKdfaGjZHUg6H6aNDVhvsXUVqWmJWcdhIsh7UGifS0V0IXTfT2EVKeV43hPzSA6wq1g1xvoHYOTloChe0i9/y/ssqwrnu37OY3miuJNv93GLz714N/VtBvXYnlQl06DhcAKko6gZo5DeB8VYvJJRgjmAPPFN60KGpMxVefXZlahdnbP4wciGn6Ev7M/NIldNDi3UiLowils40UEoKU2lXIyOsBTogNjtqngeFh/n//Qt3M46hOPgZuGpGE3EkFLRvRujagLuaKpcHBcpEl7HlwARtFr6gBD19JAtiQiAeKt0uq82Jy2Hw5ZTswV7NA4AwpUvo7zDQHyRN49ZsW4BBuiT8FAJh7+ZgQmOi+9RE64WxINCUFq2UU89m0kAU2rCcv5erCvUzGIxDQGf8/0T+zzB22iLTu4+FQ70YIQ4Lx5e4o3qm86CAO7FVXhNVYIRCfagqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261021135927099003)(261021123027099003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1pzeFpJZ0lmbEp5cTRxbnRyRXpGSlJ6ZmFacTJiL3E1a3NNQnZpTGlwM2V5?=
 =?utf-8?B?WDRESDJqSEx4ZnBBdjNJMWNBMm5sZVVsR3NCZVJIUmdMMFVNdUZTbk5QZHkv?=
 =?utf-8?B?WmhpeVFCeWlmTDBWa3lLWlY0VTl4NG5nMXJJQlhucktYZ0V2QmdZWUtBL25N?=
 =?utf-8?B?eUxYWjVYMWMzWUY5UloxVUg1WitnaEdmcWNXTVB5bUdPOWNTL3FVd2hRSnRG?=
 =?utf-8?B?aW1FcEtIRWs2bUZCaGpxZ0NRbndiTEdQRDVveEEzTjdZVDN4YVVaZm1nc1cw?=
 =?utf-8?B?cjFTdkZiOXRsV0xhcFpiSFR1aGJyYkoxTXRjS2w1Q2l1cTdlQ1NhUEd1emtL?=
 =?utf-8?B?OVJlU0dhQTJvc0xwVzRkNytaaUZULzlIbGZ0NWpQV2JZSHRJcDFDbkEwb1dq?=
 =?utf-8?B?SEFWWmQwbStRSnZNT0FlRlRKZ2c0ZS9yMWFjZlJmOEg1c1NNSU80TTgvNXQw?=
 =?utf-8?B?bDlUVTNKaG0rS3AvRVFMSDluOEcxejQyMTZ2WWNZTGJIU1c4Zm5rT3RqU1d5?=
 =?utf-8?B?ZDdib2FOajR3eUY0OHEvRXZlcExBQkZqQ2R3N0xyQnZ1Wm1pVzBUcnIvaGxq?=
 =?utf-8?B?Yjg0MUV6cXp0SjFTYzRzN01tb094UEdjUGtaTHhVdGV6NUxHY3hkTDM2Zmxy?=
 =?utf-8?B?aC9JZXJBL0tGY1BnaXY5SlNMK05hYmY0dkRKbEJZWkR0YXhheUYvS1IxOFhQ?=
 =?utf-8?B?N05oeFMreUQ1VzJDakdwdE0zc2ZLQWpzbm5GbUpKaWlNVmsrUHBTN2VXek9Y?=
 =?utf-8?B?MG91N2VtUkdFNmtYTDM2ZmgwMXc3dGdSOG1EeHQyNytjZXpGVURqaEw4VlNw?=
 =?utf-8?B?c3hndkNzVG9UOSt0bTVaU0pjendoZVRvSUd3SUlheHEzMzVyUEtJa3lwaUlv?=
 =?utf-8?B?dkticWNCM0tZL2ZzSlhRaDJsMkJmbm9pVDE0OGdKdGt2d3M1bGZrWWJjWDM2?=
 =?utf-8?B?SDFjOUtGWDc2N2R5YlRsaUw1YTJUZUFjWEEybnJ4Qll6Znc5RHY0USttdklP?=
 =?utf-8?B?TXBzSTdLdHEyZWlxNGdjQTNUdWYwQkYrcS93ZURNUkZhMjBRTzBKQ3c0ZFlT?=
 =?utf-8?B?ZDJMaUQ4SGtpYWdrK0tVV25YbnordjQ1ZWgvSTduQThMcldXakNQTFlWQTRQ?=
 =?utf-8?B?SjQwV0VNcy9SVTAzS0gvQ3JKVk5BWHhaZ28xSGVXQ3BKaC93bllncmxDQ3dU?=
 =?utf-8?B?NWxVZjZxS1gvK25qMjZSTy94bUNDK0h4M2dpdXJCVi9adlRGeWxKaERvTkFk?=
 =?utf-8?B?NmRheUlTTHpuOVI2dG8yMTV6a1c1L1F3cmlGQWlFdFRWUmdoYkhGejBMMGk0?=
 =?utf-8?B?NlJ5ODZSbGh5dUI4SGdPeGUraWgyVWtrQzl5Nk9za0NJUmswTjI4dnBzamp2?=
 =?utf-8?B?Qmh0VFY0VEhpa1RhY1kwNXVRZFE2TC9nQkxOTWVDbUNBcHNGVXkxZE90YThG?=
 =?utf-8?B?N0o4OXlTK2pkaG9RdExRUVZld0l6OVY4MWN1NWl1bzVzWjFKKzlHalFVakJa?=
 =?utf-8?B?cnZBclRSenFiOEtEd1hnUWdnQVZXMDk3TXcxSXB3VjhFWmQ3RHJ4SDdWbitu?=
 =?utf-8?B?WDIzWXpFTHlrMFVPaHE2aS9SRnE5RDFYcVJQQ2hFQ0h1a1FnV2xsZm9zV2Y2?=
 =?utf-8?B?d0t4ZU9NUUxWT2Q5endBZjZGZDJ0d3MyT1RpbWg5b2ZuY29kZ3Fxc0hXYXpx?=
 =?utf-8?B?RThtWjh5K0pkZU50VXNYTURZZUtBbWsya3h2bnVOTW1FUG1sYUpkTDRzU3pq?=
 =?utf-8?B?OU1GL00yb2hiZzVZd1lDak1OejZSN3NWR04xNkgvUE90blZDUFJ5YzNHN1BV?=
 =?utf-8?B?NjA2Y3JnK0VEbG9tSk1BWXBwblZxMm9aUW12aUdLeHZlZWo2WldqSjJ6QW15?=
 =?utf-8?B?Q0EwNVNUalplOXZlcG03N0swMkNKUy9IVElnYU1NYVgvN3loRS9iTlFXdmpG?=
 =?utf-8?B?WlMvdTBKQ3BMUlluVVNPUlpRbFJMNVdGRS9zQlFNb2h3UmFseDlNc1RsOGpn?=
 =?utf-8?B?RHBTUFNkWWxINENsZ0pvRFI5WG96Z2laeEZCUnVJT0RoM3IxU2dYZjdaVUpV?=
 =?utf-8?B?ZEE5RFl6bjZWR1pMQktZRXBJM2dleG9JaHZUZUlEbTNPcXowUVJYWko3a2dC?=
 =?utf-8?B?dHZuZmxNdjVRaUFxOFEwcUlZQ0hmYjdtaW0vVU92QnVOQWl5anlZRGRPSnRh?=
 =?utf-8?B?WEx6VjhyT3VVREt5aG1odytHSkxrNUNCOGtlRTM2RGpSRjQyRDZweTU5Z1hZ?=
 =?utf-8?B?eUc2dUM2MEQ3SXJDR0l4SDBrWVluV0ZhZlh4WEtyNHFRSWV6Tll4elVqbk9K?=
 =?utf-8?B?MkhEeVRTR055alRJZlpjYnlPMy9HelJiU3NqeXhjLzZsUStLQzdsdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfe0274-6e23-48f3-b00c-08df4883f0c2
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 10:32:42.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 42A8Njnz6Gi3AypRSEcz4fXpEHsG9tAjrVUA5+hSRsvB5ACZHFqen5PGbXUXj2hLHsORIk27Ypgrh1+xxMvMiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7832



On 11/17/2026 4:01 PM, Edward Srouji wrote:
> This series prepares mlx5_ib for Socket Direct (SD), where one IB device
> spans several core devices, one per PCIe function. Today the driver
> assumes a single core device per IB device and reaches it through
> dev->mdev all over the code.
> 
> Instead, each call site now finds its core device through the resource
> it works on: QPs, SRQs, AHs and MWs through their PD, and DEVX objects,
> UARs and mmaps through their ucontext. A CQ and an MR store the core
> device they were created on, since they cannot always reach their owner
> when they need it. The SD series can then change where a resource lives
> in the resolvers, without touching the call sites.
> 
> The resolvers follow one naming scheme: <resource>_to_mdev() returns a
> core device and <resource>_to_dev() an IB device. Where several resource
> types are accepted, a _Generic() dispatches to per-type helpers, which
> are prefixed with '__' and are not meant to be called directly.
> 
> State kept once per IB device, such as the ODP page-fault EQ, delay drop
> and local loopback, stays on dev->mdev. The SD series decides how each
> of them works across core devices.
> 
> This series only changes how each call site finds its core device. With
> one core device per IB device every resolver returns dev->mdev, so the
> behaviour is unchanged. Pre-existing issues in the touched code are
> intentionally left alone so that each patch stays a mechanical
> conversion.
> 
> Patches 1-2:  name device pointers consistently, dev for the IB device
>                and mdev for the core device.
> Patches 3-7:  resolve the core device through the PD.
> Patches 8-11: resolve the core device through the ucontext, and keep it
>                on the CQ.
> 
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
Since this preparation series touches many files as part of a renaming 
process and some minor field changes, it is expected from Sashiko to 
flood us with many pre-existing issues.
I'll keep fixes for such issues out of this series and send them as 
separate patches with proper Fixes tags.
I'll reply briefly on each patch to note which findings we confirmed 
(and will fix separately) and which we believe can't happen.
