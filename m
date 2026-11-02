Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793614791;
	b=T2qgTxq6WHNLN219fCcYNosDvEVsoOnIr9rObLtAbQFpQ6uqUh/5jwdTiSFxe+qGsMD0
	 vAaHyJQjG+32qDkXOuEHBCaR7YvRL7QGio9V/xqz7CSFYE2fMAcel0fC0tVBt/2L6JGoj
	 iZk5vHzHoknWQ3H+NnquvOb9bcx/EPl+hVAC+oIgmQ6bjTTj41y7v1GH+w2DnylrrASL+
	 zQJcTIIgEg7qlOzIXTuUzR1YtR4C5a4C9leX//UsOnGNL1GI3bTVEzc/Tf/Ayqzo0Br4S
	 zJvEeQdcbl/j6GS+5+w2/3hBsUakAEbtxl8yesDU+IoKo1ZJVVwsY7kmb/Dgiza+wYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614791;
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
	bh=YBhA6DGImoi/VDB/R5+pvme42pugoDZi0YrG0E1FEas=;
	b=w0DmVVLxphQNo2IU06Ifc7L2CTMT7AHD23WztlusNHXZ5unSbyqnOnfTd7YyI9MQe1Dc
	 WBkciTGPR1Q1DIzeAB4Sf4HSOxV/jWiyjCFCY2Lzn7aWyKhuhJE+6UgI2BOCKs+QHG8CY
	 TxG/l7Ue9gwJDYSCvSpggYXMy38r0BXbH5LDub1kOm3lW7eAICcZ3VDzt9HR+DRQuvksm
	 iS9HZ/0ZZRzzYNbexKi4roLBsCQU1x0M8OIiltQ3YrRpEgAoOIIDNMl0FltfkYduOwEsD
	 thPwubfrB4KZbNQQeiTfwCPn1bnIXC8d2O5jTAvOdYKJkKIDZsJbBJtnT/MM/AFBHMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E+b4wVjs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.52
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FB2606A339;
	Mon,  2 Nov 2026 10:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8FB2606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E+b4wVjs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/x9hFuMCuNE87MtIvfbrlPL4mwSGRp9ku2+DuhGxq+MmIoHfWcYsdXruRNhSG0CpGSd7CZOaeEF776S51t8oinUtUrq7JUFdM1FeheZqwmTmzksrmlO+PDQNjoQ5EU182T23jZiXi9lSB0o/atcIHCn5jW80c4mQEvzk78xjI1s1QI90usthCVONS38L/WyFuLke9IrmLN+jMbBezx/le98V2mathBw5vEJw/XlQ4liC/iG1Q23jcn7E3bi5kzyp1Isdbtd6xqAQOke9vLHe8lwZgGqh3N9B0O10Bq0oyW3s/tyxEuMi34dGtrG1oZegZK1/I23DBqEVa97Iso2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBhA6DGImoi/VDB/R5+pvme42pugoDZi0YrG0E1FEas=;
 b=lu2UKtxSceEPF8KcC4UCsOgDmZfo/3SCIJVJx61mrc1vgDi62iuwRxBHydcHmEWlKQb+/8cWDZygshsGmQAHYGv0jnh11uJwCKMHwzL0eIUirrhtyDzFUkHL7/FHyYYX5Agah4m92b442LXT6mTKe83i0v66/N7YFouZO4nmjr1UUl4QoBCb2sM6ZTAe4avdBMhfWJq3RjwE21YZ7VWCiScnuRcDYSsFoygWqn1IBjlei3LTyQtCEUxus09DnRaU6id1OeTULT7Og43xU1qPyN7V64rRM48syo8tlM8ns8J1YND+TRy2G7Y7KNOVMV1k/l97CE5GB/qDzT+xPUTxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBhA6DGImoi/VDB/R5+pvme42pugoDZi0YrG0E1FEas=;
 b=E+b4wVjsy6kwKLOk5dasnAljx6iSsTna+vqhBh51kingk5aJL+QFYr6LYgFXxvjxsBz9X6K0fCTcwfZzqA9Eu68R2/u2Z3fQMlVA7kSCJn0/GTkGSWG451E8Lzc/9KH9WCmm6qz6xY9uaBBP7+mJP7IfzbVgv4V7k1mKYbkE0wIRulLOZ6jfTVm7HwuPrtZgdjJyrB45C1vPniuSnabLs9ltXRkA41DKg9c1VWSp927OueFMDzaln5UZfCunNvbBkdebWY/HF0EukjfvlfUqpJcs8Tq5l3hIXCIKxwddX1IvOxroahYOR8b29riTP3VBWz/TMgYDFCRzrOVUJPrqJQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by SA0PR12MB4479.namprd12.prod.outlook.com
 (2603:10b6:806:95::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 10:19:48 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 10:19:47 +0000
Message-ID: <60624007-533c-4180-85fd-b8d234bd47b4@nvidia.com>
Date: Mon, 2 Nov 2026 11:19:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] net/mlx5e: IPoIB: Fix race in QPN to netdev mapping
To: Binbin Deng <18983559317@163.com>, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261102074107.32859-1-18983559317@163.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261102074107.32859-1-18983559317@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0299.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::10) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|SA0PR12MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ae4ddc-4ea3-4254-f295-08df38cad289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|18002099003|22082099003|921020|56012099006|11063799006|261021121427099003|261022075727099003|261022105027099003|261026121527099003|261026140227099003|261009221727099003|261009221227099003|261009220027099003|261009223327099003|261009223027099003|261028144727099003|261021135927099003|261021123027099003|260925022911599003|260925021911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	HPO9NEhhw7STjlKLqKjEFz+Srqqlb4V9ub8ONzXbePX7WhFHh2JOa4RUeKKsbAGBfyFN+YnNvcy1tbX9/iMNLP2++fWKUiF+qkvNYcGiASkR/FZZeUp7KYpFZy7JOsS930zjt9hG+8Xfkj4sTFCLJIbxcDrwss2Xc5vYmumOTwKzpNSBjY8G7obXCGov32pns7h2CWTkTjOc4qxUBXQIPkbhCgakK07AAXMRRBPoxH4jvUtuXdCUJJEkaE94aM8JqJzoi7afLij2rrEUqQO0OAC4cuEp1fwxYOwQYNEQrphCpNqYC9eaEdXws+kEiDIAncqE9t0PAi2uwZVK/nWZcI1oKqx+8roG4RAjOXQlpdz9Gr/eC5URgZpcPp8leS6qmZhtNaR3uWws8tLSIRzQ1WktNgN1w6rseBtyiKNGRIqkX3cC4WptF3JgR00DQPKqCwHHyytw+6Y5b22T+bumeQM8Z58K5F4nPRBgS/vmlN/KWeilBPeOOi2UrcemDEGKsG8m1IxjQpzLlCSIJ7olkkEu4oyxAhuEi4xk2GiTE46G0brkfERfk/weQMJzFX2vsDq6vFgLnws5+EEfaYwRT4oc2eIwwbpaT5akiRWqnZhSV+7FZSna5/n2K4m/Ue528Z3073u/6GswjMcCpc7riKYqO4q6MJIL/BgGYOwDSSCcRaMwgDytUP5WqV+kkmtXtiCFvkICmTbPUA+v6NZR5w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(18002099003)(22082099003)(921020)(56012099006)(11063799006)(261021121427099003)(261022075727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261009221727099003)(261009221227099003)(261009220027099003)(261009223327099003)(261009223027099003)(261028144727099003)(261021135927099003)(261021123027099003)(260925022911599003)(260925021911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjRTSkZ4QmV6My8zMzBtRkNsZU5TL3NFV1hjR1kxVW4wYnpkay9EL3dBa3M4?=
 =?utf-8?B?S1RId1NSUkFkR2ZYL0hjSGFMZlREYUFXWlVjUFM2UUNNd0lGdFp3ZzNnU2da?=
 =?utf-8?B?NEJqeGxrYjdra2dodVVCdlQzUVA0WE1jOVoya1BTWHJkaWRkZ3dXYlNtM2Z2?=
 =?utf-8?B?eXdVQ3YrVjJoMldveUV1TzJHWEQrVzE3bXhDZHppazVjYXpMam1qcStZaGJS?=
 =?utf-8?B?bWczQnNpTkdyTXIySnM4SzFEZS8zQUhtaE51eEFTTkJNVi9KamJhUDF1aGVs?=
 =?utf-8?B?eUlGbTdxeGZuamVCTGFXUlpGNFBGUlhIT0gxK3JUUUNOTzJ1Rk44NldYcG1N?=
 =?utf-8?B?TUhJRnBLb1RFRG8zLzhYc25sNDh2anF1dUFoRU5GM0ZJdys4T0d1d3hodFk5?=
 =?utf-8?B?d0xjZW03RUFCdS85a1U5UVBmMXp0QWpLZFhaY2xOQW5DRzJsU3ltVkJJcEQw?=
 =?utf-8?B?NjkwR3NvRnJNKytqOVZFeDY0bTFERDg4Q3NTVFhRUEZXL1NKL1FHLzRIa21B?=
 =?utf-8?B?c3l4QWNXT2w3Z2RhR1AyeDBFV0QzbXI1S3BvYXQrZFFTV091Sm1Yc3JUbzV4?=
 =?utf-8?B?ajc3SGZOTWVYT1pORVNJVDdUOGdaWUpiV1VEakZmalEwbzRzNFJDUWlUYTFD?=
 =?utf-8?B?cWdRcjVFRWtTM29idlEyVENLdmVlbUpvTjBVV1BIejZtTnd6MnJOdElBRWcw?=
 =?utf-8?B?V3NtR3plTmZGM2ZoanN0NTRQOCs4SGNYa2cwMzI1UGVYMUpRcE95Mno2Q3Qv?=
 =?utf-8?B?UmFaa256RnNIK1pkSTVoMGdPWWlYaUliWnJqSzYzL2tXaUhBNndsQzJmZzEz?=
 =?utf-8?B?RUhkaFBOeE1wRXEvZnQ0VFdQK1pwYUp0NEJ3RnVQV0RJbWtxRU5rd2pSdzBF?=
 =?utf-8?B?OXB6WVNkRmNWM08wT25RWWVUb0UvQVNCNDk2OS9IdTQzeWRJaFM4cllOSFhp?=
 =?utf-8?B?K1VEekJQY3Evc1hieFQ2cWhEdjkwN0NFaDNUMXprRlhQb0JnLzBZdjRhMVdC?=
 =?utf-8?B?QmFzRjdMYTJxWnc4a2JBWUFWbytlWUZCRW4xVVlqdUJZK29aRm83dklIOFZR?=
 =?utf-8?B?UWJ2bkdWK3U3SDBHZjJvZG9TQlZ1M3lrMWtvcDVlTTA5MitHQVRnT0Q4aGtv?=
 =?utf-8?B?amx2MU1mb1BFNHN1UkZiQlEzeEJyVXRmMlU1MnlYYStUWVRYdTdITjlrWWJX?=
 =?utf-8?B?TDJaOUJIV0lwZGJBeEJBRkhLeGF5MW9yM1NHai9oNTgxWEEzb0ZFd00ybGM0?=
 =?utf-8?B?UlBmTHlDcGRjWG8rV2Vmb2piakRCUkdDK0VwVS94NTc5b0lhRVEycGcreXRs?=
 =?utf-8?B?RDVLaDlGVHRXYVY5cHFoY2xBczNxZlpOTVRpOFozTVpMeVdqVmhkRXl2N0M1?=
 =?utf-8?B?TWpGU3I0U0RJMnpEUkNEVHlPcTRGN3o4WU05cUZ2ZUU2R0NUbkV5Y08xeWtQ?=
 =?utf-8?B?aXVOVFRoRXlZR2sxWkw4VTZXWHQvOWJ3ejZVTHhNVUZHK0srWWRHSGJCeXp2?=
 =?utf-8?B?TUdzQ2ZWaG9ZNnlLSm1jT1ArdWZScGtnMm4xQXNYT0ZzbmRNandRL0NvbVpz?=
 =?utf-8?B?NjR6L3hOU2Jmc2hWRG85TnBDTkhmTXZyN0hBZlNaRFJSTS9oRS9YcFkxTmN2?=
 =?utf-8?B?QmhtT0kyZTgxNzdSL2FXMXVqd04yOFc4KzEvYmdVMzNERTBlaGNUNU91N25p?=
 =?utf-8?B?enRFdy80S3cyZzB2Mm5yRnRvKzhYLzBJSmRmZ2h6T1MwMzVKK1VEYVdHR28w?=
 =?utf-8?B?dzYrWXBIcEJVeWVBdTdDK2xNZytlUFY5RTVpem1mUzNPdy9ocUtIWlFUUXJD?=
 =?utf-8?B?ZmVnaEdwdWg0eWRpSHZnMXhIT25yZTdWR2ovSzVZb2QrUHlMN3ZIU1l6bDda?=
 =?utf-8?B?SWg0NlN3d3EvUzVZYmFQd0RRd0ZzTzBJVEMxNWpHWUgzeUlhME1FdFlJT1lM?=
 =?utf-8?B?Qm1mL3E4ZHVHeVVodVNlSUR3TFNJRXk4czFOSGZCcEtaZVJYWnE5c0tSYllF?=
 =?utf-8?B?S3lhN1pkc0xBdnN4L0d5V2pYOFk4bVMvNjEwYXREQ1V3Q3BzdUEwYTI1bHov?=
 =?utf-8?B?V0szYjI4TzFoZm5SZ0svTm9NUk5sb3Fib2RnTTdqQ2RnN0s3ekZJVGhKaks3?=
 =?utf-8?B?aGVuckJiRjRRYWwwV3B2SVBaS0JFM0lqcEdidmVqVVhGTDl2aXpPODAyWXlN?=
 =?utf-8?B?NXRycHByYVlsWlJDNkdFV1grdHR3Q3NSTEJ4ODJMdDNJdURCaFN5aG5pSWJz?=
 =?utf-8?B?TGNWK3R6RERXZDJBa3pFeEN0S1daN1NMdHREaGJhUEczdmVyOUNhY1hlUHVD?=
 =?utf-8?B?QWFUdmRPKy9rSURsMHlGNXlQSmVvcGJSTzNVYWNMb1E3ZDRGeS93QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ae4ddc-4ea3-4254-f295-08df38cad289
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 10:19:47.9147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XINVLQyqUF5MKIQ577IMSHrgyCyzmIGHnMXEVs9UaIMAAZOrNW8uTpuXyueUGvJLnFhRAcoOWcaSEwTH/v0hXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479

On 02.11.26 08:41, Binbin Deng wrote:
> The QPN-to-netdev hash table is protected by ht_lock, but the NAPI lookup
> path traverses and dereferences nodes without taking that lock.  A child
> interface teardown can therefore remove and free the node while the parent
> RQ is still processing completions for that child:
> 
> CPU0                                    CPU1
> mlx5i_pkey_get_netdev()
> node = mlx5i_find_qpn_to_netdev_node()
>                                         mlx5i_pkey_del_qpn()
>                                         node = mlx5i_find_qpn_to_netdev_node()
>                                         spin_lock_bh(&ht->ht_lock)
>                                         hlist_del_init(&node->hlist)
>                                         spin_unlock_bh(&ht->ht_lock)
>                                         kfree(node)
> read node->netdev or node->hlist.next
> 
> At that point CPU0 is reading freed memory.  The race is reachable when a
> PKEY child interface goes down while its completions are still queued on
> the shared parent RQ; this is the same lifetime case already described by
> the RX path comment.  It can lead to a KASAN use-after-free, corruption of
> the RX path, or a panic.
> 
> Take ht_lock around hash lookups, and keep the deletion lookup and unlink
> in one critical section.  The NAPI path copies the netdev pointer while
> the lock prevents the mapping node from being freed.
> 
> Found during a static-analysis-assisted audit: candidate sites were
> surfaced by a Coccinelle rule, and the reader/writer paths were
> confirmed by deep code inspection. Due to a lack of hardware
> infrastructure, the issue was not observed at runtime.
> 
> Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
> Assisted-by: Coccinelle
> Signed-off-by: Binbin Deng <18983559317@163.com>
Already WIP by Prathamesh:
https://lore.kernel.org/all/20261031225749.14214-1-prathameshdeshpande7@gmail.com/

Thanks,
Dragos

