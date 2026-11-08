Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794132782;
	b=QckGKukM9f7c9Nh7zUgoDXIMw89/QN/zyJN9roy1KeEuP0pHyyaSY0hEwMv6B4FqzqFN
	 wI/YgUZd3CdgrJZTFYRbvtvKrPxRmJ7dp9nA3v0V7wBvqypfLbSxljQmGaKjZ6nMsLxMx
	 vUq8rl0EV5/FgAyLQ8od0XRg0GmMR96IsMbkQ9d0bI5QK3a6zXGuy1o256MkAm2ErnDC+
	 8AATiv1BYSxV4YSc1wlNO0t8yYThxa/99T5Jrl1yGJ+Qw1XEWwEZJqbfOwMbfh2plxSbl
	 Pkh/qqpiV9mHwrbSYiCWOuul55XFwt1xLgJ6m6gmNNj7HzCQW0vPgzoWltIbL/LrSkA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794132782;
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
	bh=8ksh18XjN31xXg5vP3s8jmBcfw7favlG3iLeKTZVOx4=;
	b=h7YyUhxNURYpwiUpCvALTjuaeJqdTIj+QpQrpNrxb/rRvbOFlP+mlnHEm2OMnd4Tm3ii
	 NJgYfdroVEJziLBGFQMey4qgWKdSr6F4kUiYtEiHa3wDYsBXNFbe3hImLlKJHbKcCwQqU
	 VYlSrPKAkyeNFEbXp6mKwEBtbYJ4ASicXmuRVCUJWHFG6ADikYEU5nWyDc7N5pAWmPqkL
	 BzdlnBXZ5vzXi2Ez840VmeSPx0FohBopC8qYAtmUT/zfNLlspPnF2bLsYlvPH48PGxt6n
	 IssSzYmgDqPQ8adGBCZKsy4aMhAgWp3FJjj9+eLljM5EhK7mnpDzH7zdl1een56GqYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mE6YxGNw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.67
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD79E606A31C;
	Sun,  8 Nov 2026 10:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD79E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mE6YxGNw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmHG1DtytYWwkTBhoS/2DSxFC02hndS/APqwHcZheaVdMpsGM45uq3H8mQyX+X77K34XJCCKLyd9guhh1s+8VMmOK/qYlsVT5aonLpkmTp8WS+5/YcamR5qLYpHx6PEmsARVKuxD9vTG5YGF+JevRiejC648otxgdWqe2dZ8qQyuN+50nQDP1Au683w7riiEsiG2Dnct6/dZC95bJc10hrhXqOd5/PJ4JYd1118ZDSQJUb4Xg36+wysovHMwIc30DDw81VPR0Y6D06oVU8lMLHB+vLwhYbXeHez4FeXk4aGRWQq81rr1Mwa4p4ZYrKpmei5mh+5I6IlBFp3Twrd75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ksh18XjN31xXg5vP3s8jmBcfw7favlG3iLeKTZVOx4=;
 b=mImohuX8aUvMo25N5HEuEskoOb7uRj7aMudgYW1YQCWKoGDiWR3gKQwBzBX0prlUqTrh4WeU6dKCyQ5qkMhNEX+0X2//RtlwTDg6Lto+4+XkehmIcv7dGnwqiFdVdRCV4U92WS7jkfD2eavLCL7CiuEUX7WGAMllKSWa0lg0a5CcnJZFHKiGf/etzSulg2QAlmRTdfj682XFX9J9Ac7MUeCPgdO1zYAeMtMFboW+oZ0qJN4Y+3SUVdwOKXknxH6Eyu8mZP+XMzemNn+2BFGKpqAU82LnsAmlz0pVcWAJyDKiG2+R2zTsM3bXmfrC56oEEtv62Jvbwl2wnm0H1VPP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ksh18XjN31xXg5vP3s8jmBcfw7favlG3iLeKTZVOx4=;
 b=mE6YxGNw9B3oZ5JZZxxTOLrLZ1zoXJneP368IOL2i8KYhoVULZ13FtoRAaI/NRdk83VqtOFw6h+9eUvF4XgGN9ZLLhBQWUKjbwP+FgmgLgTR9fl8/xLiaZ1BEWe+ylquOvut4rlTPQ9qq77BKzwVjMrbmp23P05yypc1EV4K0QQ0Mb+uzbxZvg+GecPkdMYf31eHP7JCa3HkKHSy206arDdGpUncNVrC6EXdjBFImhHYiVACO3Z02svJ1aXFxaQpF0dRratVQoDepVC16UuwkAGMwaY9sY/Z+ttl3+I+OUnoCWwi48SfXC0Xin1b0ZF72AHDVFJjnlmNMeU2R9TNaQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DS5PPFE52C859EE.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::666) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sun, 8 Nov
 2026 10:12:57 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 10:12:57 +0000
Message-ID: <04665957-efb5-4632-878a-6a45fa1553f5@nvidia.com>
Date: Sun, 8 Nov 2026 12:12:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5e: TC, fix internal port leak when a flow is
 reoffloaded
To: Wentao Liang <vulab@iscas.ac.cn>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261103102855.1340650-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261103102855.1340650-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0047.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::19) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DS5PPFE52C859EE:EE_
X-MS-Office365-Filtering-Correlation-Id: 590df0c7-0a71-4ab0-eb2c-08df3d80dc0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|921020|11063799006|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tQsBJVOkwgE3b/vqJJdn+X7fCeW0OJpQ23qJ+OViPVn7GPm52HiYgu34FsRPNMslRPmKOmmNJPe8Y6pbps1Moe5vIeeBzyeoGYWu+GUWOD8WfAEUxpukYVGDbEjPMDGZdYpgjNdMCwWKRUMDHvvUrviR9sS0JuNSnkseLwTD/MHPZo3pkvDhwLCZrNj+LoX19H094+i702qh2iiTcKl7XF7P/fcNCaeSoiBaHxwEAMdrIWWX90LCuyH4s8Z9bP0BSqWcfloOSr+eFAhPV0o1jAXTm3HD8SzVz1vYLC+UP0p+d3n2YSWbgog6fAosnq9xJ5LzMuSUuAtMRWyA7nzEKaxhOV5Wq82BPJt2H0iY4fyqV5xCdwAvbBeUbQQMD7//fMLoA3ckKtKisz2ga/86clSieTQQML4SPXi+ZAHtp5ald0vipQ4jtOQ1SK8ZdcEYAn0u22FBvNfE0u/8PcgB6BVj0YpOo7PqcDYU1OQHfXn9ih/kBmFBdzSY1rQcySXiDUp17+Fe7VBtiJZOTpc5zEt38xwn2T/0dy/soIjDnGA+RTs8chkDcNzX48GOMdD8DemIE3u2FZnddC38ufJMfdSTC4qQ/YcLZ2mAUkWWsSvrANJkAG7etIQ6JCPdRr+7rvYfeL97VxH3wa+0kLC5VsP7h2xiS5x0cGe9rVKtdNjveW21sIC+Fw0jWc6L1lEg/egKxk8K1JKQ4hUSu8t63g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(921020)(11063799006)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnFLdHBzWm5BZTJXa0pJeUtYTS9HOXhZOWsxOU5mYzRJb1ZDWkJVRXN6VFBF?=
 =?utf-8?B?aml2YWF4VjFRWk1jT25kY0tWM1poaVJYZzRmWTNROWdRNU5lbE50dExDbGJq?=
 =?utf-8?B?Y3F6SklmcDZxZGpoSkYzMytYQUhUSnVEc3d2K3FHVTFPdmltM2lMaXkwL0RK?=
 =?utf-8?B?RFNGeHlUMEJiRmJYU1hkV2dXM0VLZmlFT3FLOFV0WjFueW9QbzUxVXA0Ykk4?=
 =?utf-8?B?bkJhTSs3NW15dHpvZ1JUU1FERHFPc0NFSlI0SGxIZjA3TXByVyt4QXlTdFlE?=
 =?utf-8?B?SEo0T1kwS05JaXA4OVEwbFkyRlhyTEcyMWRqODdpY2NwcUVrSm1xYWRqNHRy?=
 =?utf-8?B?Nmp2VWg5NkhhZ3lmSmY1d3FBWmFBcmFQd1JsSDdLU3lwZGZERys4TWZld1pJ?=
 =?utf-8?B?ZlRvNlVBa05OeTRYUldmOWNadGlrZUQ4dXg3eUxwbTZUVnZTbjdxejhOU2c2?=
 =?utf-8?B?SVFOR2dvaUh0eHBadWVFazRpWnhyWDhLWEs0a0lIcFpmTWtMN2swdzU3R0VU?=
 =?utf-8?B?QXU2RTBYZ3hxbGxHSC9ZMHFnZnM2YnVhdTF6VWlpVlRYSHhkVE9SOCtTRHJQ?=
 =?utf-8?B?TkNKZzZFUXR0Yk12ajBKcUp2VzFRMHJNejVhWmJ4TEhrK2N5TEdQbHIzd3I0?=
 =?utf-8?B?MFdXQytNTE44T0FFLzFXZUlOMGtodUhNYjkxZzczL3dubkUydEhGb1BSL1E4?=
 =?utf-8?B?Zk54TGtZdUFCMFJkVkkray9RbVF4RnBzNldrTExDaS9oWUVRVjBhalJTV3p4?=
 =?utf-8?B?THViUmp4ZE9zU3p6NEJvQ2RmN1BKemh6c014TXlhN2RMeVdpVTZOS0FWVWRS?=
 =?utf-8?B?RmVncSt0T1dJMUprVU95VWxTOXJFb0YrblBDRHNuWHJQRXFMUUgwTHUvUy9Z?=
 =?utf-8?B?dWFjQXdkeG1yVzFkbnNOSDBVb3pNbEZURUpVVmJNd1g0M2F4S2loQTk0bVcw?=
 =?utf-8?B?U3V2Wk9NcVBlQ3FyYnVFc2poSTIwb1o3UkV3bkxzdUk2SlZLNFlkd1lQMWYx?=
 =?utf-8?B?dHhDNm05RldpckVKZHBaUENrWlQwZ2J0OU5UQmVsVXEzL3A2UXZSM0ZUakRC?=
 =?utf-8?B?dTZhQ0hDNVVmcUJzaDJ3dUd6Vm93STlkbUZvMGVwS1g5cmV2Wkx5NFQrMHN3?=
 =?utf-8?B?OHJvbWhaai9mUVdnaTUxY3ZOMmRHNVo1RUJLTm1EUVBhRXRaY0lkWXY4bm1G?=
 =?utf-8?B?c3JuMFhUcEMybUFrZGlkeG10WXIwbzhVeitOVjR3N3JBUXFlK2laN0hzeUtS?=
 =?utf-8?B?UUt6ZlY1OGFyZE9QNExYMVRvREh2eWd4Q04rZGRDYlF2Y1kyYlFLRUZzTC9G?=
 =?utf-8?B?ZVFhKysvR2NxUUNyR2hiTHlYN2lRelV6S2VCRzZjdkdLdjZZdSt2QmoxOGxH?=
 =?utf-8?B?Z2U5bU54T1VySklLYk0wZUl6K3l1ZHlJaGE5U2J2TmczbWVKV1lhSyszUEdu?=
 =?utf-8?B?YmdMTUhFbC8ydzZGV09ZOXJkaEtvQ0RUVmFFbkdxUXJ6REhCNFpKOG5rK2hE?=
 =?utf-8?B?ck8xaUNiZXRBZU45K3BCSWFXMmU1VE5UOFJyOTgxbWoxM0hsZ1VBVFZjVXVm?=
 =?utf-8?B?V1YzN1VKQlNCblBPTnlKeVdBbXhPSTNtL0JEM29CNVlYUmpIUkhPb0FaYVQ4?=
 =?utf-8?B?Nmg0eG5pVUdhRGtNRmFxLzczdjBGS01wbWZEcGJxM2dzc1E0bjdlcVFoZ0JV?=
 =?utf-8?B?ZHBub3FZYjVDWFhQaE5YYWRPSjB3ckxSNkR2SHRmanVLWE1hUnVZeDJiYkkx?=
 =?utf-8?B?RUR4U1Bid09vQkxmbUM3UW1YdEdCZkNDUkEydzJ2ZnJwRlQvNWk1S3d0TEJJ?=
 =?utf-8?B?Z2M4VHVsM29sT1hoQXhMOFNCYjBENkE2c1FWNVZ1QUhrSzRmYkgycHg3NytH?=
 =?utf-8?B?eXQzemgvcFkwRC9kNWMxN08xaFJtdjlOTmc3UjYvZ3BUbXRRUlUzcGNDSGN4?=
 =?utf-8?B?U2FuQjJPWENvUkp3a1dCbjZQYUk4Y2ZZSWhYN1JzLzV6dS9pa01JMWtBYjVV?=
 =?utf-8?B?Wk1oZEFYM0VwZ0ROS3VIYUtlYW1sQnhnN3AwcldpNUJuMXVYbkFmWjgrUmlS?=
 =?utf-8?B?bUk4WnN5U29BYUJEWjhMSDFSMDBxRElKWjZTazU1Tlk0MHk2VHB6WStTYmFa?=
 =?utf-8?B?dlZGajNPaXFhS2I5bEs3T1RuS2FEUGhTdEFWZjdtc3NYZmZLTW0rTkxrTUhB?=
 =?utf-8?B?ZlZrTDgvSk1ER0ZSVVZWdHRYQ2x4YnNRZ3BqU0tmUXN4c3dsUzN1aVZWdVlB?=
 =?utf-8?B?bDlsVzhKcUhHb1YzQ3NOVGthSUx1T1doK2xHNlVLVFJzZzRsWnowWU5BSFJC?=
 =?utf-8?B?YVc3dGt0T2ZyZTMwU3hrWGdvVjJEQkx4cHF3Mm5iekdLbklIQUd3Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 590df0c7-0a71-4ab0-eb2c-08df3d80dc0c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 10:12:56.8475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7l6DjHQLQF6a/Z20IitBO2uLQPEXArjJ4HsAWbrmb/0bWmCyUE9XCmUAISuycomTi87EfJCdb/kIeos5rcdkCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFE52C859EE



On 03/11/2026 12:28, Wentao Liang wrote:
> For a flow originating from an OVS internal port,
> mlx5e_tc_add_fdb_flow() takes a reference on the internal port and stores
> it in the flow's esw attribute.
> 
> If the flow cannot be offloaded because the encap route is not available
> (-ENETUNREACH) on a multipath LAG setup, __mlx5e_add_fdb_flow() keeps the
> flow on the unready list instead of freeing it. When
> mlx5e_tc_reoffload_flows_work() retries, mlx5e_tc_add_fdb_flow() takes
> another reference and overwrites the stored pointer, so the previous
> reference is never dropped.
> 
> Only look up the internal port if the flow does not hold a reference
> already; the reference is released together with the flow attributes.
> 
> Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 ++++++++++---------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 17bd92529a44..8246378b089f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2005,17 +2005,19 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
>   			goto err_out;
>   		}
>   
> -		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> -						 parse_attr->filter_dev->ifindex,
> -						 flow_flag_test(flow, EGRESS) ?
> -						 MLX5E_TC_INT_PORT_EGRESS :
> -						 MLX5E_TC_INT_PORT_INGRESS);
> -		if (IS_ERR(int_port)) {
> -			err = PTR_ERR(int_port);
> -			goto err_out;
> -		}
> +		if (!esw_attr->int_port) {
> +			int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> +							 parse_attr->filter_dev->ifindex,
> +							 flow_flag_test(flow, EGRESS) ?
> +							 MLX5E_TC_INT_PORT_EGRESS :
> +							 MLX5E_TC_INT_PORT_INGRESS);
> +			if (IS_ERR(int_port)) {
> +				err = PTR_ERR(int_port);
> +				goto err_out;
> +			}

Avoid re-indenting the lookup and pushing it over 80 columns, the check 
can go into the outer condition:

           if (netif_is_ovs_master(parse_attr->filter_dev) &&
               !esw_attr->int_port) {

Please also answer the NetDev bot's questions on how this was found and 
tested.

>   
> -		esw_attr->int_port = int_port;
> +			esw_attr->int_port = int_port;
> +		}
>   	}
>   
>   	err = post_process_attr(flow, attr, extack);

