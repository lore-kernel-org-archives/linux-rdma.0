Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793168979;
	b=2MebyE38ExIqWBUsjr2y5M+SL8hmLEVn2RcLG/dJwKNGPuuUIbkkx1Y96uEstgAJs9Vk
	 AvRvLxt0BHQleHN24sEFKUkUNCdZ38csouj6vi1DZeS2ncDiGL6SrkcWQocaH33d4ej8M
	 y14Xush4RmALU/hfZNKP3G9ktTiUilK1PTSQ9hjAoBY4PF/MlU87Kys+JMHWVg9e+tKUN
	 UCpLbhc3mZGv6gww38rzCpFeb/7tv/W4HhcehDNohcg9d5R3XtbuiejEyER3wEvzLVhs0
	 bRopysXtqOxrz3f7ETcsp0Zuzcs+/fnKO9G2cAajc0exE7Tnshq28+p8aFqHG+7SsZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168979;
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
	bh=95e2H3OptDVVd2ueHsy8IuYGHX9GeUhuA5+AEsURBkA=;
	b=JuIJgNZonQBhNcNj5JBRtwld7wUsY1J8wrarIqQygcmbjJ9oDVzitZOvbT0pIjDpdSP2
	 Vw71N+X0lgYktid6D0OMH7asXziJg831NiBp5Jea3uZfD6EUtyWndBE6iFVM10bmuZ+V2
	 i3LVMn+fyRLupS3A3TV3wLSYDDsaM6+orpJnJ26beRaqqD62Di9uWdv4y/3XpQPq/ruPp
	 SIrUCu330lfIjC28Ckgdy9DvmMxrxCEXXC9ps1CiSrvhyoVx4fI5HpxJRVBaZrHjmPo38
	 NAMd7Aq7T445px7GRPBhNF34PaWJor282O+y2Tn6mnQSMwZM2kxCrU/yw8F6wBDotoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mxI5SP5g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.24
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87887606A31A;
	Wed, 28 Oct 2026 06:29:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87887606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mxI5SP5g
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fX9ODAWnmWu0pacYnovTnlZC703EQhgp7oFvPYCuZc1/Hw2zSKCjUE2YHks7RvAEDE443IseImT8GHB+1OLqX+MQa7OjwHnslLEEia/BN16T7gE/CS+LU0bLfCpq5AtSV5orWeK+el2Zze42916dWIejmbAhRczqIE0LgOXpH2JPgAx0qz8mHQrFP9fB5lUSnD9a4QupCrIQ1GvtDPO6GdfaCuBwnpgNMKaZTeL3AOAKlezXIghoFqRDyYmIM3F4GUy+tEhguIKw4fkmGCUDiRLsrQYSA7oof0oomKR8OpBuz/Q5QcapUGomLX61KDxGcbX5cUATHcvmqQDISGtBMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95e2H3OptDVVd2ueHsy8IuYGHX9GeUhuA5+AEsURBkA=;
 b=E2g/JYGVxzdri+oVW+Embt/JD1Y+35yYU/6AJxJriHJYqcfHBJ58knXAjc6OqgMIR9Uhm0HJcgI1oaWTyGgADCHDk6jM3GblSEqBdhHGUAa+0l/ulrJg3TZwr21UKOswcnUvCEgdnr/fYaSXfTqNVzWb9VNdVs6y9+pmYg2VGlA1hIY3L5cBHfk3RmfiondfJMMFkSqmrXLWckfcY5nFzeN2GTTB61OLrTixAKipUbftZJf/huqQAHHdzPBU9IFS1F01DP/BWZS0WcvTS53BuEIWENGuM/LaUa61EEDIEEWd9vv/Lsg1F2eUekAwo8ZVzEp3gSfA2ZJHUoPYRDoMzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95e2H3OptDVVd2ueHsy8IuYGHX9GeUhuA5+AEsURBkA=;
 b=mxI5SP5gKzXsId3KYf92DITxL6R/kU8zvJ7+TIvJHp1S7f1AXnTpWxgTCgYtoFdalf11YmSDQ9wrF/hi2jJJwLssy2a8LikNcjctWZEsAx1NR+0AgfgASI41Wr2qPYtLV7GbXcuiKCS0Qqycj04X+G1LxZLv8UdJI/q63Wcq4+RtvOH28jYqAqnNSswiK2Zq2+l/+nDQm6t4Sfdr7JuQInSGcFC28QpHX0uHr3GIsErSRm6Do9jUhFecLp7EiHZ9MWm6cZZkswi03VSGD80+rtITbtuk6Jd07J08zxXRsHNI6qqEqZdW4FgA/v/YImcibZjdKDPyLuh4FYkRicXVug==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by PH7PR12MB5952.namprd12.prod.outlook.com (2603:10b6:510:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Wed, 28 Oct
 2026 06:29:34 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 06:29:33 +0000
Message-ID: <0e7a46e2-982f-46c0-9d77-b986e249e252@nvidia.com>
Date: Wed, 28 Oct 2026 08:29:27 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v1] net/mlx5: Use generic power management
To: netdev-bot+sashiko@kernel.org, vaibhavgupta40@gmail.com
Cc: helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
 <179235249198.3135.3606400485703838782@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179235249198.3135.3606400485703838782@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::11) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
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
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|PH7PR12MB5952:EE_
X-MS-Office365-Filtering-Correlation-Id: 97945fa6-e6e5-4cc3-7241-08df34bcd478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|18002099003|22082099003|261026140227099003|11063799006|5023799004|56012099006|10067099003|261026121527099003|261022105027099003|261021121427099003|261021123027099003|261022075727099003|261009223027099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	qkEadi74SyVUrW69E5MrjCyjFf2XYo9qEdrmYeIhdNrMP1F0zbB0RBkM2+BwrslXJbVwQp1KtbO8eITygc9BAPOqVwjLi1FyVNCC8fXlwc2Tt6luE4Ml00B8iaQnbXm4GKs1Jvp87jJBBqE+ypYQP7b9OOFvIpuDkG7mx0wQiZXOyOYw8kiuL8P788qNEDxc0+ycaGpSnOoPXN3jpdTIjeUAzwwBWayycf9tiuX4KwTnvSifP8h1uZCxJPbMJSlbqe7mTU68N74GOkBPStACB+xL3m8iRQRwmGdLmuFMEbbJHO4MIRLocUYOO4l8DMTDFLn23RwaFFM1fx7EXoH1SlU2LISTx4AfpsVd+ehhoJoYD7afMlQSWSNxjrqgBP15KQOZtY3pNmm890nnnKzZK5bLeP6gOJNHVy9nBuXnFxEQO0+IjGXTnwDFLlFeCoptQSz1pORaJbl2TC49Lf9L29UHjJpwaL1hADksIE9nrHDVTSUh78vS9tJa0T6osNUv9NZhGpctjsQ5Je5UXiLMWvvgHFwAOBHQno+qR+OopLiHFlkVFEwMRNI08cPyOuqfIWBRhsRWQTOVwqxin4G3HgL09U/2WmeIfBUp6Fhw9V7Rpd1j55RmycyWZ1k/mV7k7zgZXXT85fzLTdnjIAkI2Lnth9c8AZhjW5+Oi0zu1HU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(261026140227099003)(11063799006)(5023799004)(56012099006)(10067099003)(261026121527099003)(261022105027099003)(261021121427099003)(261021123027099003)(261022075727099003)(261009223027099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDhsS05kOEpiamxWcU1NUi94ZHhTZDJXMTVxSlJPc1kyUmVRTTNRb1Frd0pH?=
 =?utf-8?B?UmZaV0M3c2ZPQXBOM1ExNERIMGtIRWJuMllaSjdUVElFcTQ5cGNCUktCQmhK?=
 =?utf-8?B?Q2p2V0tzZ3V5WDVLYWxjbnJJdUxjSEl0SFYvUjl4WU1lOU5IQmtkd3RPOXBo?=
 =?utf-8?B?eWFVOEJJZGhEaEUvMXM4Ri8vdUl6c3N6U296VXQ4TVlzellSZnlVbzBGNk41?=
 =?utf-8?B?VjJnZldoekFnZGRPMDcvK25ucVNPandxclpWLzM1VzFmMm9wb3l6VzhZTTht?=
 =?utf-8?B?ZWdjNXo0a0JvcC8vQktuUHRvZSsxTTdKdUFxOHBVT3pzd0hXcHI4V3M3ajF3?=
 =?utf-8?B?aENhN2d6VTRMcC9BdTZnd3FtSktHN3E2VGZQd3JJZXovUG9YWmF3QjcvNEtR?=
 =?utf-8?B?THA1Z3VwdkVxaXRya1p4MlFvYnZiNG51aG1lakQ4emgwdE5pdjZrMlI3bEM1?=
 =?utf-8?B?SFpHN1BxK3BTWFFIVUpYdUFzQW8xL3ZKME5NOWQ3MzQvK1FNeVF5NjltTVBQ?=
 =?utf-8?B?Skl5VVlYVDZBbzVrbVVqKzFqOVBET3huTjBwbmNMY2RRVWNTRHNodG9HZ1FF?=
 =?utf-8?B?T1pIZ1dreGY1QTZVMWt6MEF4K0NlRVVTQkl0bHVSRUp1ajEycURoWEx3V0s2?=
 =?utf-8?B?eURoTmVHdWVKZmx4RnU2Y0JJcDVYcHlrV3cxdTM3NG41b3JIU0JxOGhvQmsy?=
 =?utf-8?B?b1VKMXBKVVpsNVlQL0NiREp5aUxYVmVqZmFaaEpSWkJlZUh0SFhmeEpMamkw?=
 =?utf-8?B?bWRFQXVhUmsvU3IyYkZJcE11MkxxWUIvY25RLzd4ZkNlcWErSGo3cDRkT2pM?=
 =?utf-8?B?V3FTNVBJOWVNUll4ekpIQlFPZlFmM3YxVnNWS0tsenpybkN2NlRSWTJUYTlU?=
 =?utf-8?B?Tk5BMW1mN0NOcW1pSlZmMFovS3Z2YS9YUW1NWmlyaU1kRjAxanpVbWgwekdX?=
 =?utf-8?B?T2xmNDd6SloycG1wZGlNN3V0akNwVGVvM0hyUWNRNE5mREtpVzJMQzZqLzhS?=
 =?utf-8?B?MnBoNkpOcjlOWWgrOHpkd3hkSmRQbWh5OStOTjZ5Tnd6dGdnVGdzQ3g0cFBm?=
 =?utf-8?B?RVBRaFZlakZaRExteCt6a05MT2piOVRnM1FzcWwrOXpOQUhCVVh5RGVBSVlK?=
 =?utf-8?B?aVd2UkJzdzZzQk5kWHBWdjNNd2YxOFNMQWZyaUFuUi9CYXFkK0x1cm5oc29q?=
 =?utf-8?B?SmtheGFWZUJzNkN0d2ZRTDlWcEM0RkpuSlBmQzlMMzRHSmZkMUxLQkxTM1RB?=
 =?utf-8?B?LzJQR0lFcVB3dStqTlJlWFJBbVR2LzdsdHFWQWZQTTF1VDRVL0ErSlJSK0hN?=
 =?utf-8?B?UTlNREx2Z0YyL2FCODB6QVdCcDl6SUc5ZDI3SjRqMXYzSjl2dzhReEhtUm1l?=
 =?utf-8?B?MXhvcHh2SVl5Vnh2WTNvb2QwL0ZjNVM3M0V0cmFYWkN6eFBPTHdubUZ4MmNT?=
 =?utf-8?B?U2o3T1RoVCtPTHZjWFVvUHN2Z2hSSjZRZzhGM3lYQkNXb1J4Y1JONkZCa3JB?=
 =?utf-8?B?SjdmeDF5QXpYbDRydWt3TWxZVnRmUWEwdFh5Z1kvV2lKeUpqelFHa0RXQTNS?=
 =?utf-8?B?RXZPcE5FeTZKZVY1c1hYL1BtdXZaaklZSzU3dXdQQThYb1ZVQzlYcTg3VmpQ?=
 =?utf-8?B?NjltMU9TR0lBZVRtckhUbE9SaU1FclluV1lZTDk0am5OditRaXNuR3BtVWV4?=
 =?utf-8?B?eFJUbFd5bWwyOEFkMXpubFBXaE16YzhTUVpGQWtvVlNqL0xkS3V6WFJINmJ0?=
 =?utf-8?B?Mlpra1pHK1NEdEZpOVF5a3Q3RmNkOS9mVVRsMm16RE9MSXpPUzJDWDJ3M2FO?=
 =?utf-8?B?dFV4cE9Mb1IxbEg1b1pPclZWRzlVNGFCbFJUbW9aaURJK2E2bDlFV1dpa1Fj?=
 =?utf-8?B?T2xEQjFNWXJ5K29zWEwvRldJcDFNUFFzeWVMQnRWL0Z2dTIzRHhrWktSQ3RM?=
 =?utf-8?B?Z0Z6Um5BZmxuaDdHS3FWK2p5UDA5aWcrTnNjYjJGdCs3aWpaSy8wK2t2cExB?=
 =?utf-8?B?QnFuc0pGeHhsWGMzUjQyT2RaejZzMWR2c0g2OFV5Zm0vQWlBWlcydEtCdTFK?=
 =?utf-8?B?RytLWnQ5UDRXWmhEVFdhQmJQcGJCa2Y4bG9RMlVhMkp4bHBMZWZMRlBEVlds?=
 =?utf-8?B?emc1TS9uWWs5ak1DY0w0eitBRmhNaUNkdExFWUpsY214bUlIbGp5WUtiTDhQ?=
 =?utf-8?B?VWpKaDh4Tm5aMkxnTmJONFpQWDVPT3Rhc1pXSzBWSU45c3RMbjlueHJ0QTFq?=
 =?utf-8?B?WTIyNVZmeHc2T1UxUjE4VlRaWS9RYkZqRUZpelRmd2o3eFJUejMwUk8rcE02?=
 =?utf-8?Q?oySMCGOAYFRK8nUR3t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97945fa6-e6e5-4cc3-7241-08df34bcd478
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 06:29:33.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CugL0xMBGRGkzq2dMx1j3u5VOer/xA/7eDVuAx+2cy/aTAmIb07iKe28cuZGLkTiPVwgl79LWIKLRL1xsPe4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5952


On 18/10/2026 22:41, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] After this patch, the PCI core puts the mlx5 function into
>    D3hot/D3cold in pci_pm_suspend_noirq() once mlx5_suspend() returns.
>
> --
>
> net/mlx5: Use generic power management
>
> This patch moves mlx5_core from the legacy pci_driver suspend and resume
> hooks to dev_pm_ops. It converts mlx5_suspend() and mlx5_resume() to take
> a struct device and registers them with DEFINE_SIMPLE_DEV_PM_OPS() and
> pm_sleep_ptr().
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> index 5f28d906c35b6..d8dba3328bb6a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> [ ... ]
>
>> @@ -2281,8 +2285,7 @@ static struct pci_driver mlx5_core_driver = {
>>   	.id_table       = mlx5_core_pci_table,
>>   	.probe          = probe_one,
>>   	.remove         = remove_one,
>> -	.suspend        = mlx5_suspend,
>> -	.resume         = mlx5_resume,
>> +	.driver.pm      = pm_sleep_ptr(&mlx5_pm_ops),
> [Severity: Medium]
> With dev_pm_ops in use, the PCI core now calls pci_prepare_to_sleep() from
> pci_pm_suspend_noirq() after mlx5_suspend() returns. That puts the function
> into D3hot or D3cold. The legacy path did not do this.
>
> Can the PTP overflow worker still touch the device after that point? The
> suspend path is:
>
> mlx5_suspend()->mlx5_unload_one(dev, true)->mlx5_unload()->mlx5_clock_unload()
>
> mlx5_clock_unload() unregisters the PPS notifier and cancels out_work:
>
> 	mlx5_eq_notifier_unregister(mdev, &mdev->clock_state->pps_nb);
> 	cancel_work_sync(&mdev->clock_state->out_work);
>
> It does not stop the PTP aux worker. That worker is started in
> mlx5_init_clock_dev():
>
> 	if (clock->ptp)
> 		ptp_schedule_worker(clock->ptp, 0);
>
> It only stops when ptp_clock_unregister() runs from
> mlx5_destroy_clock_dev() on the cleanup_once path, and suspend never takes
> that path. The worker runs on a kthread worker from kthread_run_worker(),
> which is not freezable.
>
> mlx5_timestamp_overflow() re-arms itself every overflow_period. Its only
> guard is:
>
> 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
> 		goto out;
>
> mlx5_unload_one_devl_locked() leaves dev->state at MLX5_DEVICE_STATE_UP, so
> the worker goes on to timecounter_read()->read_internal_timer()->
> mlx5_read_time(), which reads BAR0:
>
> 	timer_h = ioread32be(real_time ? &dev->iseg->real_time_h :
> 			     &dev->iseg->internal_timer_h);
>
> In s2idle, timekeeping comes back when s2idle_loop exits. A delayed work
> that expired during sleep then fires right away. That can happen before
> dpm_resume_noirq() returns mlx5 to D0. It can also happen in the window
> between mlx5's suspend_noirq and sleep entry.
>
> Would those reads then reach a function in D3hot, complete as Unsupported
> Request and return all-ones? They may also log AER errors.
>
> If so, timecounter_read() would take the all-ones value (masked by
> cc->mask) as a real counter value. It would move tc->nsec and cycle_last
> forward, and mlx5_update_clock_info_page() would publish the bad values to
> the clock_info page that RDMA userspace maps.
>
> Nothing on the resume path (mlx5_load()->mlx5_clock_load()) appears to
> re-initialize the timecounter.
>
> Should the overflow worker be stopped in the unload path when suspending
> (for example with ptp_cancel_worker_sync()) and rescheduled on load?


This is already being addressed here
https://lore.kernel.org/netdev/20261021105600.3481485-1-tariqt@nvidia.com/


We are preparing v2 of this fix. Could you please hold off on the
conversion until the fix is merged?

Thanks,

Carolina


>
>>   	.shutdown	= shutdown,
>>   	.err_handler	= &mlx5_err_handler,
>>   	.sriov_configure   = mlx5_core_sriov_configure,
