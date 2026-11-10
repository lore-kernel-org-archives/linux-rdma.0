Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329650;
	b=lUcP2/3Fx8e0yiGm7VW17sa+TDQsE9s4ldpRteko589eF0WapuEyVor/7HPK5OYUjalU
	 pw2FEmAVeZJshS3RQ2nVFD/DSn0YZP5UjN4kX5IB9iFP0oPbrymp1/YiRVHBQMMRtOYeX
	 kMeUXqRxR5GD4KRmGzmsxJi11Hg/rNfg8qypgZxph3rgjTrCLeLmKFn17JN5GPoM6arru
	 lwaWkb/Y+f3hZp8l6fPxAg6m7xx9IOKPeJsfB90/sedmnZzXXiYyDpEyV8GTox8TBx9PS
	 m7o8ZAn5/b2Giws/TkBh7WIZ6hD3NlUdlABl4umlrwdEC7UIALQ/Cw9BfSGZOigs3yw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329650;
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
	bh=C/WXdAKCMNWUFAalZEI6F2WnHWbYDJKuZa4ZNF8Z2lQ=;
	b=3p/SDOdgi0siN+vd96XhVsnCLRvOM1VUFurQ7eIS57JFx6a0Du6vhPBaUs5BCKn0RnO/
	 xqsc/f+m8CwNjus0V5Y6fzAyaFjeF76WNB2IlBife1wtrCt3MFKLYBU4GaelFWPoitLxV
	 Rp6vW3bcooOV14isKWRdGNv0jRvxlq/B37hfmP+XWapKpOv7/shwGa9DUm8L0k8DeUSuH
	 4dzxd9nXjv9A9mBSUxXN9SlCq68nM3+oPVB1hq//pWCPePyV8w4In420AKCZggaXd3YeH
	 wleoJsmIihPJ8XAXKWDh/+xakOmC4ntEJtzQMUuAjSO5VwqqTylJl6nKwA4syH1dqVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QvjWrp9y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.68
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010068.outbound.protection.outlook.com [52.101.46.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F8606A32D;
	Tue, 10 Nov 2026 16:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 347F8606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=QvjWrp9y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDlMAKGjtlI1oSKhizZkhqYAx3zYHwqW16GXQe5K/H02r9u62WWagVjaT4V5D6rxddpO1rqaX5K9cTKNTUykmycGAzZJ9pOR2gToxAEn4GSOdgaGsTsp3UiWLn2n9Gb7vl6gq1YvWxNylJL50JXqlh9aY3XboicF1cFys4eguca3b3mYuXzLXoqcSwMoBPhrcpN5SvcTCOB3syp1ZHIehYu/zxuEpcefjzptNPOOP7fOd2GzkZIl69piVO78R21alfwuUSnSSm8cqxuJTbHnaleU2OZFnss4sQu7OIIySH83XL5tsO7Idkl6X21CFpT0fA41w+v3bgMVpCUENV4Neg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/WXdAKCMNWUFAalZEI6F2WnHWbYDJKuZa4ZNF8Z2lQ=;
 b=IcOMBgd28II0BjrhXxFZNnWwuXba1XOhdKk+OrEvKu94nU6urBj7mniqgnWhIjky+cbwVH4BP0OsAjLYI7OwNA7Zk9VwRBpmrLsa1RTME2ThYP3l25WgJgJA1feCrgNDlIJ0Eco7GPtpAmZiPImXNJfb1Bm8kv4J2oQG4/SlilQpI/aB+g6U+8lGDS6rNVuxHHOKkyjSaQY4NQc8pOBIttwGO5qOwzxO5NEwlq6ovvw0ddWrV/6CRy48fdWFODVhsNpJh5cuAKBwwObmblRMsZgGWI/Nl5OsOiIT8pBOuliNDADbIMaUiwWBf6xPPsphPGgmM7TiZ/EQl4Nt8WVGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/WXdAKCMNWUFAalZEI6F2WnHWbYDJKuZa4ZNF8Z2lQ=;
 b=QvjWrp9y9fyUgZIEFVJE6HUB9tRg3760C8qGaQtLZ85c5TmyLOkJq2zTYwU2gkkbtkJ5L6U5Pxyw22ZKdZeOmEpJZC0ImVcrc1zvQtZX59VOHGEW/yI05Aw2JHBrsy+vNNjKi93PSHO2e2DN8LkL06qvoKPQOJdJVWlS+JsB+n058pNFlQJDqFlLi4kTIrxHWQgdN+DPgbx+NaQzeJa25qsz8Kj3a8ckGQMxGCNIJPXlLtO5U6gso2PB1KU/Qri1MaGKglJiPD7mYPZjqBMo6wG/ricaw3PGXlGHocKqAqhtJFMo43McvlBnIAv7HkMK+pKSC96srFBEweKkVRMCDw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by PH8PR12MB6699.namprd12.prod.outlook.com
 (2603:10b6:510:1ce::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 16:54:01 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 16:54:01 +0000
Message-ID: <59db66e3-d689-4af6-a2c1-c03287b05afc@nvidia.com>
Date: Tue, 10 Nov 2026 18:53:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5e: TC, release meter if rule offload fails
To: Jianbo Liu <jianbol@nvidia.com>, netdev-bot+sashiko@kernel.org,
 vulab@iscas.ac.cn
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261103102856.1340672-1-vulab@iscas.ac.cn>
 <179405671897.994134.13525993179862980932@kernel.org>
 <b1bd7ac1-be7c-4582-96aa-b9e982921c37@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <b1bd7ac1-be7c-4582-96aa-b9e982921c37@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::14) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|PH8PR12MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 87df3f6d-4b8b-4273-7128-08df3f4b384e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|261026140227099003|261021123027099003|261028144727099003|261022105027099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4Tgtz+mt9xIBcn4Wc9QqZcO4XkUoUrLOjVZCWSfGQE/o9Rkzc6YNCB1EdkD2hqRq6B/dDuNjbvNsxKMcmE0Vpkq3+WqLpPLtcPr4YO22tzj85eZrOfSJb6HVuWN6I0k6MZxPNGUL1fKp2eaqvMHRIfAyTekcevFznLWE20+Yj8UQv1E9K6s/syFWXEPL5rmZYDJP8AmyzuiszDsdujjdg3g66HjKeh49iGawDRfTXjTzS/1LADHQw5INWiLobCat09tzFz1/wrwcQtA1sH3ix9qMAcvkSQGK2KriZtE1MmtQ1wCJ3hr6Xqd1wgRSUCX3gA4U8RM6vE8k6l/7iI1NLhG20zzpcr5Eh3zw+6gHMl7Y+drpoVeSBYgIXAujlkMYL+T/0jZTiejkkZXgaOTxHgFkOamsMbnTsvjTBy7J4c88fP7FBRWyCHQAno4joX2Ntt4qI9iLtRzrWlkqvi7QkiWj0ZA4+A9ygPIMCQB+3lY/l7augyuSxWlSbj9LFi93N237W33eHt3ZFfMmulKn2pog8PAH+re5yQqJ7hKP9DMqEmYlQC4etQFZvbNHFSD8c9lY1S9H2I8WsgklotbfFtGvupo6gFCMu8ygQ6NKn4OE2f3YTFsgVVO91k4ZPt9OZVRjktDZmwJiA9gEzXpcYA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(261026140227099003)(261021123027099003)(261028144727099003)(261022105027099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVp5TzlxeDY1ZzlzSlhrbXpxSTRjWGppaG5uWkRFVHZ1Y1RlL1RwV0V5czVD?=
 =?utf-8?B?YmRqd1RFSnRJR0QwQWdRRHpMRExUL2VmODVaQkVycnFYUkhscUVRTitiNnVR?=
 =?utf-8?B?emFwVGw2VlNxdEhGdStjSko1NTNnYjErQytnMlRBS2l1aWhkM2IyWTI4dWFZ?=
 =?utf-8?B?VFRQZDFFSkhRMkc4a3R2OTl5cDNjS1pSbDVQSzlSZmJ4T0E1R0dFWWN1c3ky?=
 =?utf-8?B?VmhuMks4Z0d2RzFPUlcwSEpuaElQS0Npd1ZXT3pSWkxhNmhDWHhjQVNRZjk1?=
 =?utf-8?B?WmRwQXZZcXljYUZwKzduYjY4U01kcGJiTnU4Mmc3ZU1IVGlvd0xUTEw2TWhD?=
 =?utf-8?B?WTRJU3VGZDYvY091WVRxUTdJdzNuTWN6N2U0L3VTR240UmJ6WDJ6TzR4Y3lk?=
 =?utf-8?B?eURYbVBWTEpLL1Y4MW0zSERhNzZqSGlwMG9qL0Iwd3Z0Q3dQdUUyV0lDb2F2?=
 =?utf-8?B?bkNxbkZrU2dxK0hCSmsxOEM2UVMwUE1QQW1RWEl0VkVXV2FXbElBdHAza2Zy?=
 =?utf-8?B?WG80UnFYSVFzeHFNTWk4TFYwMkdwL0Y5TmdlUE5CR3laeWNsckZ0ajRub1hC?=
 =?utf-8?B?OTI2SE9DT2tUUnNVelBHUEV2eEQ4c0E3bHYxTEd5dG9obzAzZEVWckRuUVda?=
 =?utf-8?B?N2t4WXI3dSszRjk2enJISXVXQWhCd3hJNDJZNXdSU2NkYVRheWp3UXlrZ3ls?=
 =?utf-8?B?ZVQvYTE5VVBWZWJyWW5PZCtmK1FiaGwvUG52R2pBby8yQUhCOFIxei9PRita?=
 =?utf-8?B?NHZDTjAxNVhZd3NwaWcyRHZpZWhEb0VWVmlsZStjQ0x0OW9NYXZ5czI4eHRR?=
 =?utf-8?B?OXNHNE5JVStpMEwxc2VhMGFDRWtROFoxZVRTQTlsclRpNFJkTDlqYWw5Q3dJ?=
 =?utf-8?B?YmVldVNQUWk5SStxT2hJUFN4dUUvTFlxdDBEZWdjcDcxMHphNjl0RjI0R1U4?=
 =?utf-8?B?VlU0NVRCYWk2eFU5aHpKQml2dG1kalQyYXZlMnZaU0I0MzVhYVViTzZFcVBN?=
 =?utf-8?B?MGhSaEEyd1VhekMyRk1kRTZ4RG95MHFsRi91VjZNWDJtVWFpdGoxSW1hWjBn?=
 =?utf-8?B?V2dJUGFsQnZ1eFlPRUJDSjYyZEk5YjVhUWlnSE9raExYSHZxc0Q1L0FWL2Ni?=
 =?utf-8?B?aGVpN1o0cjlJYzJRUlRGOXZZV3p0YklJbGRoZytaWHJXWHFkck85amZva0p0?=
 =?utf-8?B?cGdlUUl2YVYzWUQrVjFScndUWURWOWN1aXpUOVJmRGVCVGdsd20wSFU4Yk43?=
 =?utf-8?B?TDdTczBVQko3Wit1SjQ1Qk9yWUtMR3k1V3JNSWtDOXRqaXpEME1VQW53UU5s?=
 =?utf-8?B?WmxBRVRZeHFYaXlaanRoRUw4MU5FYmt0TVdQZzNHemFnNWxXNDJmOUlaUmN6?=
 =?utf-8?B?RHlBL3ArTW5xK1RFTzJ4WVlDSkxNejc5em1EcnFGTGZia3Ntek5nQ0xINkls?=
 =?utf-8?B?emhuN1hMVGJpY25KZHpGaHlqV01SYXQ5REw0WHRFalJUdE5oaUlyVDN0SVdJ?=
 =?utf-8?B?SnVsTlpqTXB3MEVYTWR4WDBtMG9RMDFncWFObTJrbHpKc2N4S3J4dTl2Q3Yw?=
 =?utf-8?B?Vkp6S21tUkd6SUlRVnkwY21Kc3VoZXZFTEkrVmxEVnNkTG9xTzFaeTNrQzcz?=
 =?utf-8?B?ZHBHMG1QUWliNmd5ZlhZMzhJenhEY3BNVzVjaitQaGtES3VWRFFPa1V6b3Jq?=
 =?utf-8?B?Q1JZRFhSbEkrVTFZdkRXL25BVmczSVVVYU4vMjFkZVRmaGtCRHU5R082eUM2?=
 =?utf-8?B?dVNPUWszTlVFUnhWNUM1WkluUFF4NjQ3UDg0dmFQV210cXFCcnIxSkNwemlp?=
 =?utf-8?B?d1hvWHZ1VmdmZjc0c0k5Qmh6TkZjemtuUSs4ZlNHbVI4OWh2NFNZclI1azZ4?=
 =?utf-8?B?M1o3dlpBQWRnb0RWakdmR3lVMEY5WWxCb2k1TFpzQU9aUkc4WmJpcWpibWh1?=
 =?utf-8?B?OUZjM0hsMndwam9XNnRhMm1zL05OVGFWZnFBYlFiNDduN0dDZGE0V0R4RXht?=
 =?utf-8?B?VndnRE8yenoyV0FPeC9jMENtRmNrWnNCbXBRU1czVnZFd283bjFTSndiOVd1?=
 =?utf-8?B?cmo2NVdKY2xrcHRsdWcvczFQV3gwQnhlZDFVb0xLQ05PS2s3SHd5bEtNVEtp?=
 =?utf-8?B?a1hJRUI3dnJja3hRRUowazBraCtuc1RLK1NpNU1VMmplZ3JpLzR4MXRKU1Fx?=
 =?utf-8?B?eDByMlRST1BEeW42VFh3aW9jSTBqcnpsVFp4UkkyMUJ2RGN2Vk84ODZBZ1Qv?=
 =?utf-8?B?eExtY1NrendrYTVVWmM0dTdZc0JmZE1QUTBDZC9nbDJYN2ZaZXE0OVpCbzhl?=
 =?utf-8?Q?E4nz0PFexeNRgHR+SJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87df3f6d-4b8b-4273-7128-08df3f4b384e
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 16:54:01.0362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Frw7O+QLUm0A30zHrAP5EbRyquQg5LlOnTS8OMqSUgS4radWdfRbvqzKfzqhg0olreJ1fVZe0XcIvyA5fAIeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699



On 10/11/2026 5:45, Jianbo Liu wrote:
> 
> Hi Wentao,
> 
> Thanks for the fix, the leak is real. This comment is valid too:
> mlx5e_tc_del_flow_meter() leaves the pointers set, and
> mlx5e_tc_rule_unoffload() releases the meter whenever
> attr->meter_attr.meter is non-NULL. After a failed re-offload in
> mlx5e_reoffload_encap() the flow is still marked OFFLOADED, so the next
> unoffload releases the meter and post meter a second time.
> 
> Please clear both pointers in mlx5e_tc_del_flow_meter() in v2. The
> dest_ft part is not needed, the next mlx5e_tc_add_flow_meter() sets it
> again before it is used.
> 
> Thanks,
> Jianbo

pw-bot: cr

