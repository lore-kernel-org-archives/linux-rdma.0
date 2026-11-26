Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664433;
	b=d0XEjRFAMclhIf/d6MjotB243XmPp6t//almbD1wVhuAXxKOvDhL5hYiC5VhwQ7n1mKt
	 mDNrjB0mNXj4gVHHgiEtmd0h99Edun60UVX4qAwxiYfGYjKV8rTf81Lo92pKg04LWsCBI
	 /Ufo4RrNCtj4U4My0WT2p0SA5ifto83yIoHW4PY/bxU6HmIINU4G81hjsZpC9PbC0fFsa
	 j/u7MkBRVfvzzd+86NrbwJBjMjHFTGLCl7bQLAQf/fd8+I/nlFiczU1L/QBmzN9G7qmzM
	 d37Wg0UH7iXZbXA+y6v+JsOJEIPu3vW18EJULKEM3b990RZfYX14foVzdL3h++zxL7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664433;
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
	bh=i9Hv1BvREKbKAOVT3H46k5tBz/GUlTr5/kZhE0OeLzc=;
	b=Vlvvx1aw9Nqp2bdqIqNbF8Z+/loCk5SsWdWamElk2340HIbVu4ypr142FNTHAO8uLMof
	 zUGu4VvWLq0BNMaOSkoAYDqbOCZM8VycTzDAUmavGUeP3nXijPAAZbXEkssSZ/VckKy/1
	 YFcJ1dsj/jkbjeOofMHaGFfb18ZJnrraptUUg162tBjVKNOZ+6aX+ymIaTLmgWvXyxF0U
	 8syNXd5J3CY3c/INeE2mRLiEGYnlUgg2pCL0wiQVWy6YpGmmwZtpJ7gwoCXbL7PWyK6Yn
	 O04Z+poRWMU5r9QbllXtBXTSr90cGtLVkH8iWKqyhv+nCNlYaZYYvwXAhhH96XNMByg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=epVxl1LW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.18
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F00606A32A;
	Thu, 26 Nov 2026 03:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58F00606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=epVxl1LW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNCc8UJCdmyF0xCf4i0qIgt2Ac6tuGrB33Z2gLe06Rk7scf7sqiPxBPTEynGKA8UMhT9Cpvmt0GlWFwLBNa6vs9GPFJlOm0zXDJcAbXc8IFAUheKGjzdpFNMGvc5oGpGhm8/HvLyNyKyziDb41q2aZj2aEBAfRoD3oFW4zM2W1CdTeSrDTWGuxBkYtGF+P0ZQXIb5dGoNExVwHWwKiu1zmmJsFJ5JmYsz4OA/cEr9TLEyyPIByKIKYeQY1EN+IdedrPW0Rt52lgVLJGkHu240tdLoMm3jUlttDEDHw35/A1NpTOJK2nqTXGeiNbI0hweLEvVRfU9MoLekMC8F/aDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9Hv1BvREKbKAOVT3H46k5tBz/GUlTr5/kZhE0OeLzc=;
 b=HoxyWEmmsT5XVOtvBXsX9LpMXsJCUUADKFI3Tfty6NanPKHNVW1vrIH7tAGapG9cA5gY45lTnHTQ782rTfJxZ2AH/YVu/Tm2+UP2EtVxabHtFcguqvXxEifEapKLKzNOeGS1bZVUd9yjAilRlPPStDcDAW/akz27bWzgvf1IOGnlh4ekNkMDv2Y7uy/UFuN+pWsDdCmMr44vVLnQ7AuVEPAfZNrgkB39wn1H2ZodL/+XPR9gfrzjFEULM0u517XldZvl/fQQiDzROdjgLzTyOOMGpCUdr8wtpqzmEsVxFDQItiiadyZU0oAo5Jl/7NH7zTI4+/GU+2GSZIB2SWzHcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9Hv1BvREKbKAOVT3H46k5tBz/GUlTr5/kZhE0OeLzc=;
 b=epVxl1LWA1cCGDl+Y74/4oaLNfvm0hhQ27OPGLLfNEs9XAsv80L6pqxNbOS/UOyD125csKXvxTSrfM5r1vO3e6ts+8kG7bGhjS1BsRBfju5qvixRHd6CRAJmMrteRo9ctwRXxquBR1pIaol3t2Q+Ln4PjTf8cngk8IpYSfZDDz269JyE0QLOnBMGCbiwQ9n5a3IoLb085jBJLU4AXO954pJNnu0h3ymra2sT9tzL7jyOL9CZKWIf+SGGW6cxg3YW33xKG2ft8ZdDgM/LoXyF9/gh6xDayb+GCg6wJQx9JonuePnzD7n3iQf3EhPKIqR2+fzcjzu2MkhHpXvWcaGGpg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:40:29 +0000
Received: from DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d]) by DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:40:29 +0000
Message-ID: <80ce3f0d-67d5-4453-8c3d-01f89ff64911@nvidia.com>
Date: Thu, 26 Nov 2026 05:40:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 2/5] net/mlx4: factor csum flags into
 mlx4_en_csum_flags()
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261125180021.1804204-1-joe@dama.to>
 <20261125180021.1804204-3-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261125180021.1804204-3-joe@dama.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::6)
 To SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 00122621-71c5-407c-81b5-08df4b6f03be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|11063799006|56012099006|4143699003|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022075727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hFCzlT/Z5G5qupC2RgU2hFdm3dMrDSKW2D0l8NcOYZtH/q/oIOSMTS9q0QrZXTf3UW7jCbD1LeGiPAhLfiY4mFRiZjl3C6YUPho0ZKnExV2S9JNrGsXMH2QlS0MTkAB3cInhX6BQdooWYSVWCxiK+DWrGPcm83mtSqtqPtbcVfAWgx54v0Qw5kj32w0/F9U4XPgbkY1HB3mtZOo91hKjnG4c/m4s7fWzkCtOixHhl9XpWWWXxC3Tx5Ggmvjka4j03wxyEd95o3PUC7a8CgVaKiEy7itueqsmaRxBONCGa+Z/ri/satlCKZtqenjxrRUB2IUYt5eEmOKH7eaM67s48af+dfgHEYETUrfuzPbA+ay8a0i6T7bO7Fqw2V0UgZtG6jtQu6ccmp3G1WJkXuYHbJO/BuzwxadLtJPj3Yo8y58vv8SeydE0KBSoxuHvN/8/OrSpdNqn2U04Il2Fq0PlZnTWRYYbyNe8xdcFtQaRJlczXFGkjhktsBl6FjwJJs3VN9BSOQIrCi0vAyjsisRFuILzLXro9yUUb5lCfew2TcvtAp50sWaDsrblZXJI+0EALY154/DhahXr7jKg19Wryneh/nTihVgAXi10DkUqKMR+iqzIisWfz6pnB55O1Os+GvhG3VsaeLtURApkoLzJ10w/GNiss4fD6PK9v8RLtow=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4354.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVVEZm84U3NCd2FPVlozVnZWd2haS2VjdUo0VE1rVVJTTWxxL21FTVVJejF1?=
 =?utf-8?B?NGVUM2JqOEtRV3ZrRHc4Z083SmErRmNpTE5HWVc0OTBub2hhc0EvM01wdHdv?=
 =?utf-8?B?dW5UcXByWHNGZyt1VU81MGdSTVU4eHZSQkxLc0Q1VHcrRVFxekZRbk9hbGlM?=
 =?utf-8?B?RE5sNlBST1VGSUh0RHFOb0pCbTcrMWJvL1I0S01jV1hwcENMSlViZzRRRVhh?=
 =?utf-8?B?b0NkM3RrSUxRMTF4Uldrc3lJblkrT2g0SE9QVWNDbWRiYjBjcDlKdG9MNlVY?=
 =?utf-8?B?RmhVZ28yMkY0eEJZUStZUTQrQ1pkNi8vVEFZbUVVTklEQW5sbzlkTExObXJs?=
 =?utf-8?B?UGpid09ySWxDZFF4UWUzU0dQTkF4RWlDSWVBUEV4U1czSzJUdTdhVnhnOWZG?=
 =?utf-8?B?Zm5tcXBjc3hRM3g2bTNnYnFTOFpadXVZck5rZVBxejVRRTJ6YW1ibm5Pc0dv?=
 =?utf-8?B?Y1ZPeEZ5TUhzM1YyQ3hneENQSEluTU0ySDNnNlYveUxOVmNiK3NvcDBYZkVJ?=
 =?utf-8?B?Y3NnYklYZHRuSlQ2aDVCMjJQUkJacFRNVEovOFd5bHhXUk9hWEhQTE5MaEJn?=
 =?utf-8?B?dFd5ZTZ4K1hCTkNCaEY2enhZZ0xXRFdYdFVtN2dnb2NmbjBTTWJHS1JXOTB6?=
 =?utf-8?B?S1A0MEF3bk1FZXEyQzBJdWxIcDUwMzBBREFsRkt3NVJrd3JuUCtsdlF4aDZl?=
 =?utf-8?B?WVFpYzRpejhkMGUzQjZLNXB6dHM3cDZEZ1Q1QmRRVVRLNmxUOS9jZTQyTUcz?=
 =?utf-8?B?bVlnSGdRREdSVEhXeHoxRjlSc2RnYkdaRE1aaWhmb3hsdDlVaHFhSFVENzhx?=
 =?utf-8?B?WlZpSnd5Q2pHV3FOYkQvaWJKVk94a2QyelV4ald1ZnRUaXBMVlVwQ1ArdVBv?=
 =?utf-8?B?NTZFcVBYS2RwTURGUzdEWTNGSjBnc3N6enlDeDg1NnFHVkZNK2IwT2JpU1Jn?=
 =?utf-8?B?Q2RRZW94c0dUdVJqMlJkMGsvRUl5ejVIU2tFZEVFWi9UelRvTWtIN1B1UFN1?=
 =?utf-8?B?RERzclovV0xsaW4vNzBZa3pKMGJpVURJN1BVcVVNOUJwU1VlMGRrUmxnTi9o?=
 =?utf-8?B?R0huK1A1VzlHdGFHamhWNlVkMGpXUmpxdUZxa0FPM0hzbXc0U0hUNjdIVnFT?=
 =?utf-8?B?Q0Vmd0RjWk40YjdlVGdrdFNrRkNxYjgwUjQ0S0FMMUM1dTZLb2JreDRSNWhU?=
 =?utf-8?B?SmJSM3BqVk1DT1lSSE83Qkk2RFFWenF0ME5mckxXRmtSYTdGM1U0UnpSOUIv?=
 =?utf-8?B?aHRhT29nMlFuRjEvR08vMnZWdm81M3FUSGN5bzU3OFFzYXp0Y3hXTHgyN3V0?=
 =?utf-8?B?SHVaNUVlNlJLUnNxTkNGWGVUS0E1OU41dmdhSFRBUFpFdTY1ZWtqTG5ibU1R?=
 =?utf-8?B?RS8vTlhmS0d3ZHNMSE5SV3g0MGd0TmRpZlN4M0hXSUJpUDVYa2dkT3dqRWov?=
 =?utf-8?B?L3VDTVdFNFk3M1d4YjZaNURYdExmdjZ2bzdGYlltcnVpcDg3cmEyQ1VKZEhl?=
 =?utf-8?B?ZUJydGJSYWVVS1pHZGRsLzBvcmpvbU0zTGlNV2NGblltNmdnbFhib3g4QjF0?=
 =?utf-8?B?ZGhUWm9DR1NZMTVhRWRNZzZNdlB2UHlRYmhNWHo4OWNJWmc2M2tIby9WbU84?=
 =?utf-8?B?Z3FHa29GWlQ5cHByUitmbTBIcTVTUWhUTDkwQWRjTUZ3RGNDanRmZUplNkFV?=
 =?utf-8?B?OTQwbEY2dXdoZzlRS1BTek5oSGZIV1NzV2VMWXRjT0gwVEh3K2tyL3h4NW1G?=
 =?utf-8?B?WEFZOHJ2a2NzLzJiVTB5SkMwQnlXZ1g1RndaSk1PYS9tN2VXUTJBYWJ2Vkh4?=
 =?utf-8?B?bEhSQzBjU1BBRkZyd3U2QUR3THNqQ3BhOVU5MHk0NmFSZzdUY2UvbFhTYjNp?=
 =?utf-8?B?Rkk0Vm54c3FWb2pQbDk2QjUzaHYwUHdCUlB4N21wVmtlczhkRHRid2pwS0ZQ?=
 =?utf-8?B?eVZUNmpTVFFlaTZLWWNjVTVtNXpodzdGMWZIQTJiTVF5VUdOc1RpN0tjWW02?=
 =?utf-8?B?TGNObXB6VmNVajRPSkRwYXh1ZWtTTTI1VVVIYUJvNW5aVlNVSkRmVzRPN0xY?=
 =?utf-8?B?QjlMVVRFNDZzNEVWMVk3WENxa3Q5VkFNdXpsektXV2xLOUxpWnM5NFFYR1h4?=
 =?utf-8?B?djRiZUp4Q0w4QkErSUUxRDQzT2RMdkNGR3ROUUtzMXEzTlR0Uko5TThuME80?=
 =?utf-8?B?bkh3bGw5NzZjTUI1dmljNUtRVjhUMHFDV0ZqeHYyYS9YUU1aaHc0M3VOSGNJ?=
 =?utf-8?B?T3B6VnE0U1FObE5oTmZFblJGTWtVTi9GVTU0NjUwdHFYSWRoZ0RiWVN2ODBZ?=
 =?utf-8?B?d0pCUmN6VE1Db0hiWnBTRHUvQ0JLQkJWdzlGandzRVgvaUZHR04yZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00122621-71c5-407c-81b5-08df4b6f03be
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:40:29.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgUZY/Sm4d+AOD2Ojw8Buo0BTJznFsfcaNv8FASmrHfaz18FwEwVme+pCIsnRmmp2glG+IAeWjZrnOT2s7PcTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126



On 25/11/2026 20:00, Joe Damato wrote:
> Extract the code which converts skb csum fields to WQE fields into a
> helper. This helper will be used by a follow-up series implementing
> software USO, to reduce code duplication.
> 
> Signed-off-by: Joe Damato <joe@dama.to>
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 29eda78b9977..1fb265a30a30 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -860,6 +860,16 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
>  	return false;
>  }
>  
> +static __be32 mlx4_en_csum_flags(const struct sk_buff *skb)
> +{
> +	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL))
> +		return 0;
> +	if (skb->encapsulation)
> +		return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
> +
> +	return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM | MLX4_WQE_CTRL_TCP_UDP_CSUM);
> +}
> +
>  static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
>  			      union mlx4_wqe_qpn_vlan *qpn_vlan)
>  {
> @@ -890,12 +900,12 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct mlx4_wqe_data_seg *data;
>  	struct mlx4_en_tx_info *tx_info;
>  	u32 __maybe_unused ring_cons;
> +	__be32 op_own, csum_flags;
>  	int tx_ind;
>  	int nr_txbb;
>  	int desc_size;
>  	int real_size;
>  	u32 index, bf_index;
> -	__be32 op_own;
>  	int lso_header_size;
>  	void *fragptr = NULL;
>  	bool bounce = false;
> @@ -990,12 +1000,10 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  	/* Prepare ctrl segment apart opcode+ownership, which depends on
>  	 * whether LSO is used */
>  	tx_desc->ctrl.srcrb_flags = priv->ctrl_flags;
> -	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
> -		if (!skb->encapsulation)
> -			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
> -								 MLX4_WQE_CTRL_TCP_UDP_CSUM);
> -		else
> -			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
> +
> +	csum_flags = mlx4_en_csum_flags(skb);
> +	if (csum_flags) {
> +		tx_desc->ctrl.srcrb_flags |= csum_flags;
>  		ring->tx_csum++;
>  	}
>  

