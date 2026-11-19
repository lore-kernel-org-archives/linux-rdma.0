Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795112929;
	b=qcYWbTElZLaBvAlbTG0sHXcEQ6w+wB610oE9RXIuMTzCHkD2jlzQc/FaNI7WN3a3CvTv
	 TgPZXW2PjMqNa6Ig0xYDiEoM1sBOBKS+8v5GVbML7zppiooE7l57QYu+0Q8EZO18kUsZo
	 dOkvJnIeSc7VLfl+X5iYS9KDcFuvOsvPrkj/Ru519VCjoZW47r8Qpj1Z3GP0uUiNi2Y4y
	 zD5atCfl163vNxegqy42Qv4vj1OywJiKzvWQqBIEuTY196F9XDboWyxftHNcEj7eaqcRG
	 EKQZROMHrcILOEpmJP5OeahSIQPtWtioaxKafZu9mxp5noLuYByngEGy54KD+P0dA6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795112929;
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
	bh=xMHYv/3PQ1dDfJ+rtiKztMzQh4qN4g0xk740mDLwxPU=;
	b=hkUsMZ50HAfyYD0s4NbGyy5HHJ6RAc7SdGBCus8TQ5iKgL2qtOuliFG+xYKFfUMluJSN
	 +iEXsh674qROkFQk67sNb6thHd+VIiNoqysrMyktaagUkTO6NDsYFeMtVgs4X/nnhgCQv
	 EGIcZo7OoDA3rfmeFWgXUdkO8/JIDLPAR1y2ejsHUYUdi0TsM1zfc3lcmQCtEfavGhgwV
	 0XIuSTsieDOUBK15IThhKzqLQXhhkFsMLxMx9N0PNH6FxwHsJ9O1kmIZ2ty7EULIQsXKz
	 E8X2hD0+mKFGSB/BoCVL0od9FNROLbXgg4GfTyHA/G61oYUdUloFxA44XEMk2rf4QGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T8kxm6kB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.56
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011056.outbound.protection.outlook.com [52.101.62.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362F560A2602;
	Thu, 19 Nov 2026 18:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 362F560A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T8kxm6kB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRmRxfmFHGXSWpNpbhRLGFqnkA7WmKVt6d0Z1Z41apbeU7J/1ID2wf1y2towGOtYdovVn2sCVUsaEuQtAQw1OUDkkvbs2pXonGAFNiYata70fvZsWp6/l0C+uwiTsFtzUS7uEEVUTPw2B0bb1LMPtJO0EwLRd7BKvgiAw8f7a50E7yRZ1Rq+IfrXVuKUlcOQFraGtc8jNzBYuriirSjTlj9neFi0vI3T7/IvxbG5eJi9A7K5VYD8E+swM8/mXOfw5UdUo0BhAi0oqfBwfblF1BjoqQZFLnkIFbrxTvcMDu/mKU0WrAl69QOkFq0a14DnS9uSCXZtHeWVHJsfOmw/GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMHYv/3PQ1dDfJ+rtiKztMzQh4qN4g0xk740mDLwxPU=;
 b=XEHq7b0aXcZ15LxwBmE7uFpCzwbIv5+bYO45Ft733/XiyEnfSuFRDzR2uJKvfhlsl2aYlC0qxFsD7ycfB0CriVY9PxNoawPXMHYALajz1RSD1doQhc1AHh5mgDA47nOJOW3yYYWkT+U+s7U9eea2UP3m4GzzxxuywnPOX8/WGIOpGLkDFY+qK7CiF8DC+eLdzrP+4up4yz456E6ZG/TfwIyF1qMC2d5PHWh2GxYb8h92Zb/68zZ3GY+l14PkjZJY0RXUYA7HBg9XlHYbX18WJG17+C/4OItY0V/Fpr7m9cKb5JwLTJP9IbNaa2oSxrTz3mzWq6tkVsevIyC6TCL0lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMHYv/3PQ1dDfJ+rtiKztMzQh4qN4g0xk740mDLwxPU=;
 b=T8kxm6kBnQj3W9I/+oyBl21Jb+tithcS+ABCfTuPr13sJ5DGItpEz7oIPMUp+sDAfByITPbqGxG1eX6rzKEcxS2g+VsDQ/ZdtJzmL2w3sV8eQQi88jOTmutYwSVryY9+WnbBfF8dWob50ypOwwBWWH8PLycqHRBAVKYgjklsLFq72JMFob60K3T5D2FCIUCaQcV+7xk2sQtssS+W4c3TCZ8bmaw3+53zA9FEjTkY2jUjWQkE1GKRiP9EySGIO3UTluICHFxWhhzSPDuDWG77jDKt167cNPkC9lgVoQsEC69bo7q6u2cGXR8TyEh7ZtBnCgzCpHCNho/1EMCHLCfVQg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 19 Nov
 2026 18:28:38 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 18:28:38 +0000
Message-ID: <7e94f48f-f352-4809-a96e-d5363b8be273@nvidia.com>
Date: Thu, 19 Nov 2026 20:28:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Skip hairpin entries not ready in debugfs
 dump
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261119012707.555494-1-lcy8047@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261119012707.555494-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0002.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::8)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|IA0PR12MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d14b1f2-04c8-4bbd-c66f-08df466aedc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|376014|1800799024|261022075727099003|261102123227099003|10067099003|11063799006|56012099006|261026140227099003|261028144727099003|261022105027099003|261021121427099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	b4m+0te9BjIKjC4DTS7kY7irr0NSA6406ZRvTqAQOajrOYkvAUgFdi3eYYLCVPrRrfesW2tvFOCoa2qlWMe4cQigXio/MTumdvKcI8YllAyZDxsQuIhNc97U0+EBcdnEswUITkhfadvSJjvJuiT9nw85di89M6H/jYLu4EJz3pkf9w/YS/FMTArHnRYHnRt7zgUTMA8fryZvAYAIEgNeAk2JY5/93Qu03T95n5dUv1ufxlRgTcal6HkJ7ycEwSrp8QYds/067mxmZt+8//CDX/+GKGZZfuBi/2t16TNaj7q4D/L5K62He3M4FXq62zXwvegdZbF5Ap92wfDLDJz9ipBiJuLYhU/kPEy02vCQwzgUcsUxXIE6HDZgWO9M0/boFd542/pp5q3CJA18dWlLTJvYxuPDp3GdwHFu6MyVjN3flg2Egp/pk4HIv9dLZSJ9a+C8pMMYYO3gmDoxl5ukjgnrVBI/ky8DXjDzkkZub42h305qfLF3KQcCXxayTq5PVgheCd6RryB0lN1n3uVBjezdPj4jp8gfKUHT/1hUTV0hRZzw2zQg3EXeTUS9G04UgIuEk5RrqqwuibxTp7O94hQd2y2K+GiUHEnpq9XU9VTe3/sCgtU94SoYtwIc562G7bNukLYVT16fl8YZDH2ZbNco4Sphj3JPDWsSd3KtKqE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(376014)(1800799024)(261022075727099003)(261102123227099003)(10067099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261022105027099003)(261021121427099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGlEelNqS1NURXVGSGFQcTJnWWNrTWlZck5IbVdIOUx3UEcwMTNaZE5nOXZQ?=
 =?utf-8?B?d2p2T0ZMd1VmdkM5RDFKcE16czd4Y1BkVVcyM20xYXg3L2FKVG1MY3prZDhI?=
 =?utf-8?B?d3JCVzhSK3hoVGtxU0tESUM1U0lROTRRVmxRZThGT2xWQW40b1FkaTR4UytX?=
 =?utf-8?B?UDdaUHNCY2p0UEViQ0xSZ2N1Nk81RzVHUGdpRlhFUER0K1pQZThYYldGempo?=
 =?utf-8?B?emVoLzA4ci9jU0x2L0lMWnV0SlFBRFdGTm9ka0FreGdsVENoWUdvbDdYWi9v?=
 =?utf-8?B?bzhPeDZRTFhZazU5YUl2TUJzU09YcXZhWVVsNkZnMzFsS2hFWkZ6a21nUUF1?=
 =?utf-8?B?SlhMWjU4MTJYNEFEdjlSTmpHbHBYb1RidmI5Z2ZHaDRNTEtOZ2ZSdkVsaDR3?=
 =?utf-8?B?eHNLakplZ3NCUnNpTE9OV2xheGxzTUNkT2FUZlMyME8yUitSZ0xsSUQ1bndX?=
 =?utf-8?B?NWNpTHNHeTlHWFV4dU1wVjhYZFA0bEV1UU5tV3c1c25VZE5IQlRGUithZjNm?=
 =?utf-8?B?c0wyZEtZb3RGakVWNUgvWkdaR1FQa0hhZkd5c3hjVjVGTFRyVmEwRDJ0MFQz?=
 =?utf-8?B?dDNubTliZkNMcVZoQmhPb05nMGo3Y0RSdUdHMXVKN3g2VUhLeXdUdTRUR28z?=
 =?utf-8?B?R3dlcXhvMkxBM1h3M0VQa0Y2RGprS2VEREpVTXVCNlp2VUQxdEd3bDV4anJN?=
 =?utf-8?B?bG9RRmwzazc4WnNkWDRLbUhyaEpxYnlhVlp4dlAvRGh3anU5T2VHdzJiUXp3?=
 =?utf-8?B?Y2tubjM1UFZURGcybEhpYkdkcGROZjBTN3M2cnRkVjhSVzFWUkl3Qk42RzlK?=
 =?utf-8?B?WHM4citGamRadERxZDFEeStNdEY3TUhrUEFsQ2RwSDRPSnh1VFR3ajR2VEtI?=
 =?utf-8?B?ZjJML0VWMjFMTmhoYlBOSitJeU1pOWVYemVsTzBzVzhIc0RFemlJWTBQaEk5?=
 =?utf-8?B?SFNxamZHUFZpV2tPaDY2MHVhR0FtNjBPWFZTYmlKTnkyS3BGTFBqU0VwTGlY?=
 =?utf-8?B?UXovRnBXaTA0eEFFMUJVbEdhMHlRTXZERmFDdERzbEdQNHY2RXBRRSswUmVL?=
 =?utf-8?B?cjExOHFEaXVkbHkwK0pNRXAvTSt5aWlyTkttTkt5WDdRRlVyVDZDVUNaaWdK?=
 =?utf-8?B?QXFBbjJ3Q3pkcVhIME9MaXRPSDZSNVBrb0Y0aGxBbEF1Y2pSYjA2TVhmSjdO?=
 =?utf-8?B?SW5KRWs5WmZMSFJndlJkUkgzTW1VaVRabXl0ekRTNlRWSFg2Tzc5VTBGTVZi?=
 =?utf-8?B?cE5VdzBYQlBFd3pySXJwQlJLWmJTaGc2VWg3c09OQW13NHo0SG9DRWh4Z29l?=
 =?utf-8?B?MTNEekhyRE9BZzRwSVZFYjc0S01oWDRrSXg5bjJubGFrdDc5S3I1S0Z2U0sy?=
 =?utf-8?B?ZEpzc0tlNzBibmV2MkFGQlpNYURWOWg0ZTB3Sm4yUkFQS1BSQ0IzOXhQNXNU?=
 =?utf-8?B?Tmk1MCtFS0lBRGVFWUlveWllWFU3U2IzcTlrZTVMNE05SVhJUDd2c1Zac21H?=
 =?utf-8?B?ckR6b05OTjl6Ty9vRSswZHNvNXRleU94RkNVeXV3RmtDS3Z0Tmt2TkRJN1BH?=
 =?utf-8?B?OHZoN0Q4dWM4SGFyMndZWWxtUEFPclllT0pMeWlEeEVZTndFTUFjVVN5b01q?=
 =?utf-8?B?VEVpem1MUytOeDRmWFp4YmFwSSs5S2toTHJSWmdkU25rUzVNbTBScjJ3YVNa?=
 =?utf-8?B?dUo0OWRLZW9VcnEydXBndDdYTSsvRnFlai9KelZubmdSOEo0NnhTTFFXMjd0?=
 =?utf-8?B?bWVPNzhqRnJxaGRSZm94d0VRYVZ2SThQbDFkWEJCN3RBcXJxSzA5aFZtdFZk?=
 =?utf-8?B?WlZjU3l6QjRvYjR5cEl2T3NIZXMrQVo5eUM2NERWdlM0VW1HVWs3dGprdyth?=
 =?utf-8?B?ZXFRNEh4eFdjbFIrN0hhZUdFVEZnRzdkQUlRVUNMekJJYWo3aWtscWxscjZK?=
 =?utf-8?B?UXdwaDY4eXU5bnhYc3BhNFNiRzFIM0hQbnJnNy8yL0I3ZWdzK2NRa1FkWGpM?=
 =?utf-8?B?eUhFdFhERmllZGRYTnpxKzZJdW9BcU1wSGNHOENkdXhQbk1QUXV4U0ZTSmRs?=
 =?utf-8?B?RWJBdjNYdFdCdlZLTERPTnduZDk2ekZBZHUreVFoWURENFBUOUQ2eVQ5cjVv?=
 =?utf-8?B?U0kvY0pndEllNE9MK3U0d0NvaExkMEZIcEI4RU9FU2crMHdqY0R0SlRLY3BH?=
 =?utf-8?B?OTVyQnpoUHYzUHZpTStvMklkd3ordlZScHZyYVBlNzRJSkhUY3IxVXFjN3VJ?=
 =?utf-8?B?QmtBYWVlTFUvQXJQeWRDVlJ3Z3lJY3RMUFp4UHFkSXpGWWJCMzhwczJOd2Zz?=
 =?utf-8?B?UlJsdTlScWdwRUQ0RjFiSHVXYjN5SUtsMzRPZFFHMHp3NCtRNGtHQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d14b1f2-04c8-4bbd-c66f-08df466aedc6
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 18:28:38.1867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Vd7unTCxo+ol0QJ/uIIS+pYCv9WeUvuKzPZxOfIGSG2qUXlSS0P50xpLBQ1rR63+IJNCwKemMWRzboPgqGbxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8374



On 19/11/2026 3:27, Changyul Lee wrote:
> Hairpin entries are added to the table before creation completes.
> Reading hairpin_table_dump can therefore dereference a NULL pointer
> while creation is in progress, or an error pointer if creation fails.
> 
> Skip entries that are still being created or whose creation failed.
> 
> Fixes: 0e414518d6d8 ("net/mlx5e: Add hairpin debugfs files")
The dump added by that commit printed only peer_vhca_id, prio and
refcnt, it did not touch hpe->hp. The dereference came later, in v6.4,
so this should be:

Fixes: 8a0594c09610 ("net/mlx5e: Add more information to hairpin table 
dump")

The change itself looks good to me.

With the tag fixed, you can add:
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
