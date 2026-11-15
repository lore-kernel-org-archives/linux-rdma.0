Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794755099;
	b=rYIlsYHV6fj4uHkNVi5UOZKJUBfRIk61/QytbxRLh0pAwsLJjMEZkWUvf0xyNFHejG9e
	 mux/V6y4ktqF2MGYwck7UL72QRsebBibLhFWwk80WsdRkJ6uO1x/JxrpR3Rhjus9NWhGL
	 jWIG2eKaG3BdWk7G2+cBJM44v4926CZgmxnlyzFtQ+pzJtiVWbQtH0lIhxVPGZTFuf68c
	 QiCQoexF/x1hEiqOsTK4Hq94pjbTE8hZEcl/xnkR7Jeq4WVQtiS7TLnwqqrG9Y4xk8e0b
	 yKaQZ+IkCeml01AjiuRd34JqhYt+vPr2EAkRkCP3tx5sZvasWUGFh7vr1+DGKBX76RQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755099;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=MEteDLkwjFBOjuQ0wBRbQAGiBL2CVyEirc6h3mwPyx0=;
	b=El8K4H/dtagY7iNC/f/ogI8wZGRTo3TGe/THzLcWFVOsa9YQ9yuDF+Cd9kmMRsnWkUZ4
	 lj2+6f9ephAVOlpn79HcMP9xKOCc/PqNiDPItv4ATErFTdfGYFx8ehWyrCXnCwGVlV6di
	 cZ2y2UukIUi2IrONcZiBzI9PjaxD7++2wa1cqBUOuJkIMTwNJnGYNNsbaB3CmOFvCy5MS
	 8JIpd7nblY7GDI1vFteNMMrTrq79g/RKFbaM4uPdZiySRa0UAKFVXkd3+cSDs9EM2G1RN
	 P88mgQwU2yVNAVCh8i+KqKDDtxgtU4082058RKVaVjkTpNFbJx48QA0LJ5dN/dLZdYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=di+yooP+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.44
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B358B606A31E;
	Sun, 15 Nov 2026 15:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B358B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=di+yooP+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JoZ2pODl3x2KQedyRvY4LLeny0ElHpmV9ZIUs5aRLjTVogX6oBcyGFIQrcY56RC93TCaugMxazCsFzUSGTJHxxUXqnwwczmFgna55ZmHsbO2WQG1IjEhHaDbnVSRCv+ffXKmq5ysEz6e/yZZi6FQA/bbQBh8XdFUNauNkBi4yDWL/zBZw1cVC/YOrLhSCZKSYaZ27r12XRrECyRgjceysG/hdA77rbtE89Hj9+P2mHIgevj3iGgETkO6lqDYimFo6UjGpJ3Zwht7Dc4m0uuaQk1VYamUPDB+EFz4uz6bOMllAcam3YyF8OjGc+KUf4fYnuyjP9ru4QJkGGqNKW/myQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEteDLkwjFBOjuQ0wBRbQAGiBL2CVyEirc6h3mwPyx0=;
 b=gTpXcVs+VDZR6y7ljAguzPXg63EGW0+2Chf1CLr/tBSiN9CTOnUvTwlOs2xxTL+QWp9JbnYH8i75xCrVTRHbGs2j4XcTaKwfJoQl8tNzu81EsmCF2toT2P+oapVltKecnB2EZ+vdjyq52ntHMyVYOWs6LvqwlWhdR9FoJ9VwC9Tul0MExRgOjLkmjjjItvZIQdYHuv/cMbEoT8ATMkIYGzj2iZHB4osME0tI3xEHNhxH727zG4PVKbR43kjvD6WqDNIBqBBrYHvl8o2uc4SRuEbFK52L5ipDnTEk2eJrimx6BtfctYGCVP7GmHUno6Nd+wsYNz6ALF5JeehXbsbQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEteDLkwjFBOjuQ0wBRbQAGiBL2CVyEirc6h3mwPyx0=;
 b=di+yooP+kKHQgUluZXYk4GrHb/HToP8uG8G3Ijl2ioa79Sb1zwoZXvL5CLyrfmT/4ShCwZMLFTgTWCKVthGmERr7h52bAsGk7a93rcFRRgzrkESjc1x1os+FNtOXgqBt9yOpaG7IfI25dUyC4h12ymO6bqBfKHQBIdqR2lLx6uqd9TM89zy08/Z/c1Ti+rdXfzN8GE70oB5tX5taA6qB93a92h697QkMzORJx4NifDeFBsAcSquiG6GtEUotGk2/TcprQsv9O61NcnrfXUC0wmzSi2PXmMQFblBGzTBjYVa9dct+zFogh4JCHR+cb8Wn5eIU3fOsNG/GExF1ks1tSA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16)
 by PH8PR12MB7111.namprd12.prod.outlook.com (2603:10b6:510:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sun, 15 Nov
 2026 15:04:55 +0000
Received: from BL4PR12MB9723.namprd12.prod.outlook.com
 ([fe80::218e:5de0:e859:4146]) by BL4PR12MB9723.namprd12.prod.outlook.com
 ([fe80::218e:5de0:e859:4146%6]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 15:04:55 +0000
Message-ID: <0bb25f5b-ef11-4d04-91fb-a99d8c13e4b0@nvidia.com>
Date: Sun, 15 Nov 2026 17:04:47 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net-next V2 1/2] net/mlx5e: Batch NAPI RCU grace periods
 on channel close
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, ast@kernel.org,
 bpf@vger.kernel.org, cratiu@nvidia.com, daniel@iogearbox.net,
 dtatulea@nvidia.com, gal@nvidia.com, hawk@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, lirongqing@baidu.com, mbloch@nvidia.com,
 richardcochran@gmail.com, saeedm@nvidia.com, shshitrit@nvidia.com,
 sdf@fomichev.me
References: <20261110185005.2932568-2-tariqt@nvidia.com>
 <179450940555.2199510.18034823087861989713@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179450940555.2199510.18034823087861989713@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0175.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:58::7) To BL4PR12MB9723.namprd12.prod.outlook.com
 (2603:10b6:208:4ed::16)
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
X-MS-TrafficTypeDiagnostic: BL4PR12MB9723:EE_|PH8PR12MB7111:EE_
X-MS-Office365-Filtering-Correlation-Id: 0650213d-80db-47a5-b0de-08df4329cebc
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|4143699003|11063799006|5023799004|56012099006|261028144727099003|261021121427099003|261022113327099003|261022105027099003|261022075727099003|261021123027099003|261026121527099003|261102123227099003|10067099003|261026140227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	gCPlXsF66+x5wct8dXqkKqYyJt9AQ1INX5l1HkiEfwjofhiqqh7Y4r4IVXaEGfMrzd8JXBm84/aQi2ZzcMIjNoqTIHRgHqUK2VjxzS1IgU0/Rjbv8Jwv/xoVtzfY548xn2RdLX+741FleXRbjIgZGF+k/DHP/3qvsgzYipvmVV6xXjOZ/w4iIiKOhTU/nNzO/Grbay3n+ZAD/DKNWCCTthyHDtGN9dOAXzusjN3Yu1EOmPRzFfwYEx6h5FTCk7Njm2XUJVoo34N5AI5v0eZBT2d0toE2nKuEHzfTFa7gKwOfnYJoG+UqiozaiCnQoRGqYQaUmM4SqQ+xxpYtRrPdzUrdxcO+ougR0w+UUK5hQbfpJpATqx7/NIU8KnOvTsZOCru67qBMfR9Cr/UJuNB0s1s3PmujzHZWxCPrGkKcTX1BMAES7sXPazL0SGdpW/T1PXowdA5K+MKNwRzUWtYFHVg60mYG5BFwN/IeZUcBa7aHEVUnU85lXX4sfww6t7a1zbupxw28dy4bX2NDCzro6128+ndMD32zUesAxtGORNaCL3L4ZajhqZnCGE8d1lWdndGbj8HWVnxuv/8JbExBFbkIhAyJELbhyYqKK/bL6IRBZJMp5FviSiJ50DFzRCkN1VtJXEwq1a3UZ1Ht1a1OGl/Mnk87qRq6dN6cMNmuNmM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9723.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(4143699003)(11063799006)(5023799004)(56012099006)(261028144727099003)(261021121427099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021123027099003)(261026121527099003)(261102123227099003)(10067099003)(261026140227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFI3YXQ4MGZvT1ZYVVU1TktZSTErS0VqWlprWWk3WkgvZWlmaU9sN3VxeG1U?=
 =?utf-8?B?YXZKdGJjWU05R3hjTTY1NDY3STBjQklPZGVydjZ2eWxpSk5NLzVCOWFDRDRE?=
 =?utf-8?B?Q2pkTWgwZnFLREpOcVJscjdYT1dnbEo0c05jc2JuWlJzaXBrcTltTXFGNU5L?=
 =?utf-8?B?K1ZnVmlSeHNQVlZwdXZvUjc3QmVWakhYNjd6M0U4YmJrc09jQWQ1NTZDNVFW?=
 =?utf-8?B?Q1hFSWpxWktUaTVhTkErVFdhTTYvNUhFenZFSmNNQTdsdHlrWEZjS1ZrU0FD?=
 =?utf-8?B?UVFLeGU0UVJ3cSt3T1VmT2lzU3lHbXZoT0k1NmRsOThMWmN3Q29PUUFIeTBR?=
 =?utf-8?B?U3RtNk5uUi81REVMQkRabG55UjExY2orY2FCek9ZSGZNTnpISWV4M1dIODZQ?=
 =?utf-8?B?V1dDd3d1VXZWZ0N2ZExrc0MzMGxzTitqTm90ZmplQnhQRFQ5OFdEamtwZjdD?=
 =?utf-8?B?dlgrbXM5OEdFOXl1WEVmeVdoZHdvYmNvYzRBT2V1Z2ptYUJ2OWxlSGFtTXZo?=
 =?utf-8?B?MzdhdDk1ZWxCYWl6dnArbks0S0JqYzJwSGl6Wmx0SXpLWWNvZk5WWTl6NFZ1?=
 =?utf-8?B?b1VTZERKQ1BpVGFPc0t6LzRUd1QyajZ3WW0wd2FjWG9aV1c5d2psWFY5NUtp?=
 =?utf-8?B?YWdzRis1bUN4VmxNVVIzdHJwUHJ1M2tMaEZ2UjVhd0hXVmZzU2tyQUVwSDZi?=
 =?utf-8?B?U3Q2eXFGTU5TaUpXTmdmZHZiRTFJd1pCU3Rrb2VpSXQvd1l1U3RsWEtVbGFX?=
 =?utf-8?B?a240dWhlWmF6RHdpK2FXTXlFYkRrdlFBUTlMKzljYnJTc0Fad1Rlc3Z5K2M5?=
 =?utf-8?B?YXVzVFJ6UUlZaGVJbTg1b1F0QzN6UEs1dXNackpia2tIVUVvZGdtWVB3R3Nu?=
 =?utf-8?B?a1JqL3VXN2NMdjBHVm9TRDd3WHdVOWlKWGdHMjc0Q1hBVU13UmRGMW02Q1VU?=
 =?utf-8?B?Z29oN0RmRW5Sc1Mwb0Y2d3VIekkxZWZsb1Z0YzNqV3FGTFBVckdYaFd4a2pY?=
 =?utf-8?B?ajJHZGhWa1JaaUdZUDBZNGg5L281bkpzOXpSbW5zL1JUZUZ5RGoycUYybEgz?=
 =?utf-8?B?ZGdLenR5R0h0dmNkYkZLazRWaUl6UXBHNzVOMnNRb24rbVRRaXlvWGxWYjFO?=
 =?utf-8?B?UUZHckdEazl1aUZMdk8xaU9Zd3BURmNDU3hsaFpZbC9JeldVbVFFOUppRzF3?=
 =?utf-8?B?eUhleG8zNStjNlVVYXkwa0JDZ1VXN2pWNjNzMEJsb0M5SzNHbnlPelBpUHFt?=
 =?utf-8?B?UmRBc2ZlcGo1akZURmlZZlZzM1JPRHFnbXhkd1c3d00xYmFLT09DbzZ3dzVv?=
 =?utf-8?B?UWZjRTRpVDB0UkZQUnJSOEtMQk1va0pYVi90d2NqTEVVSEJGK3NoNTJlNUgz?=
 =?utf-8?B?RVpQbm5wdHk4M2IxWFIyc0puZWxSVjUzYWFXOVZwMWc2QlZtMWc3b1VZZGF1?=
 =?utf-8?B?UWt2Q1V5a296U05uQ1IvWUZJWThveXVoY2Rsbzkwb1BCQ1JwbGVWUVZtZXha?=
 =?utf-8?B?clFEeEFnN292RE5kdlVaNGZNdzVoWTVxM2Z6UnBpak1CSjBKcVlZTGZqV0R6?=
 =?utf-8?B?cmJtbS9lSlc0OXFTWDU3NzA3U3hUNjFLcXB3ZjcyckZpQXdjaHRxalRvSXdy?=
 =?utf-8?B?d1RVWDdjaVR4QjNjQVI1bkpoTmlJNkM3cW8wQ3MrWFNqdXgwKzVNSW5qeXdq?=
 =?utf-8?B?Z2FtM1JVV3QyR0l1UTNRbXB6eWNkNmRtdUtBczBYZEVsNzczWjlBd1paZ0I4?=
 =?utf-8?B?ZVB2NUFkVER6ZFY1VHhnMFdoTC9SNk9Xa1dOQTJ3ZVJ4THRqSGthZU8xS1hS?=
 =?utf-8?B?Ym4rYytTaFBLOGEzNUw4UGJNYW5rRmd0Q3FzK0lPeHJaVDFITHNxS0hrZmxZ?=
 =?utf-8?B?UFVDTVN3dHByc3Bqd1hrL3A1RHMzemFaTi9iRHZNQkVHV3V1Yi9DMWdZVDE4?=
 =?utf-8?B?WW1oRHd2RmV1TmhZNy8wVFNWa25mWU1uNWNhd1J6REJBQit2RFYzSHpRbUpz?=
 =?utf-8?B?b2RBcXRIY1c2bGRnVnNEZE8xcjFwbFBLUkhHRGlRMS96TnhzM3JsMUMvcFE2?=
 =?utf-8?B?ZUpPeVoyTW8xVEI1dU80d09xRGFhSDV0ZFJwaUx4anY2WHd0bzBhQTNBbU10?=
 =?utf-8?B?NDNyQ3RTVTZMakJhQzVzNFU2UjU2bXM5c3l4WmR5TEdvVDJpWHk5TTI5MW9H?=
 =?utf-8?B?b1cxQjhTeERKNXhQLzlzTy9xa0Z5aER4Z2J0eDUybWFDMmNYb2FUNkR3dDlo?=
 =?utf-8?B?YW43OHBOdGltQlJXMm0wdjBSUjZtRWkyQ0daemlYNktreFFpamFWSHFxMEcv?=
 =?utf-8?Q?vv3kL5Uy/eIvDE1D2k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0650213d-80db-47a5-b0de-08df4329cebc
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9723.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 15:04:55.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHakpu0P0PIoEJX8gF7ZOZaNbLDPbVLGgP1uINE+0XZzsMaOS8qJCrk6GGAkiYWCXn3AZXuO/fmlE3f4O6EXZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7111


On 12/11/2026 20:50, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 · High: 2 · Medium: 0 · Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [High] PTP SQ recovery loses the RCU/NAPI grace period that used to
>    separate the PTP napi_disable from freeing the PTP CQs, which can…
> - [High] net/mlx5e: missing grace period after page_pool_destroy() in
>    channel close
> - [Low] The patch adds an unmentioned change in XSK teardown state
>    tracking and several copies of teardown sequences that will have to be…
>
> --
>
> net/mlx5e: Batch NAPI RCU grace periods on channel close
>
> This patch splits mlx5e channel deactivate and close into pre_sync and
> post_sync phases, so one synchronize_net() covers all channels instead
> of one per queue. NAPI instances are unlinked with
> __netif_napi_del_locked(), and a single grace period runs before the
> channels are freed. Single-queue paths keep their per-object
> synchronize_net() calls.
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index c3c2c5720c6f3..73b504ba8c8c6 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> [ ... ]
>
>> @@ -2936,35 +2993,62 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
> [ ... ]
>
>> -static void mlx5e_close_channel(struct mlx5e_channel *c)
>> +static void mlx5e_close_channel_pre_sync(struct mlx5e_channel *c)
>>   {
>>   	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
>> -		mlx5e_close_xsk(c);
>> -	mlx5e_close_queues(c);
>> -	mlx5e_qos_close_queues(c);
>> -	netif_napi_del_locked(&c->napi);
>> +		mlx5e_close_xsk_pre_sync(c);
>> +
>> +	if (c->xdp)
>> +		mlx5e_close_xdpsq_pre_sync(&c->rq_xdpsq);
>>   
>> +	if (c->xdpsq)
>> +		mlx5e_close_xdpsq_pre_sync(c->xdpsq);
>> +}
>> +
>> +static void mlx5e_close_channel_post_sync(struct mlx5e_channel *c)
>> +{
>> +	if (c->xskrq.xsk_pool)
>> +		mlx5e_close_xsk_post_sync(c);
>> +	mlx5e_close_queues_post_sync(c);
>> +	mlx5e_qos_close_queues_post_sync(c);
>> +}
> [Severity: Low]
> This isn't a functional bug, but the XSK teardown decision here now uses
> c->xskrq.xsk_pool instead of MLX5E_CHANNEL_STATE_XSK. That is because
> mlx5e_close_channel_pre_sync() clears the state bit before post_sync
> runs.
>
> For the new check to work, the error path in mlx5e_open_xsk() in
> en/xsk/setup.c now does:
>
> 	c->xskrq.xsk_pool = NULL;
> 	c->xsksq.xsk_pool = NULL;
>
> The commit message mentions neither change. Could it explain that
> xsk_pool is now the liveness flag for XSK teardown?
It's documented in a code comment next to the change, which I think is
the right place for it.
>
> The patch also adds several copies of existing teardown sequences:
>
>    - mlx5e_close_queues_post_sync() is a near line-by-line copy of
>      mlx5e_close_queues(). The original is still used by the
>      err_close_queues path in mlx5e_open_channel().
>
>    - mlx5e_close_channels_post_sync() open-codes mlx5e_ptp_close() as
>      mlx5e_ptp_close_queues() plus kvfree(). mlx5e_ptp_close() is still
>      used by the error handling in mlx5e_open_channels() and by the PTP
>      recovery in en/reporter_tx.c.
>
>    - mlx5e_close_locked() open-codes the same sequence as
>      mlx5e_deactivate_priv_channels() followed by
>      mlx5e_close_channels(), with the same two grace periods.
>
> If a resource is later added to only one copy, either the batched close
> path or the error/recovery path will skip its cleanup.
>
> Could the single-object variants be written as pre_sync, then
> synchronize_net(), then post_sync? And could mlx5e_close_locked() keep
> calling the existing wrappers?
>
> [ ... ]

I will change in v3.

>> @@ -3060,32 +3144,67 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
>>   	return err ? -ETIMEDOUT : 0;
>>   }
>>   
>> -static void mlx5e_deactivate_channels(struct mlx5e_channels *chs)
>> +static void mlx5e_deactivate_channels_pre_sync(struct mlx5e_channels *chs)
>>   {
>>   	int i;
>>   
>>   	if (chs->ptp)
>> -		mlx5e_ptp_deactivate_channel(chs->ptp);
>> +		mlx5e_ptp_deactivate_channel_pre_sync(chs->ptp);
>>   
>>   	for (i = 0; i < chs->num; i++)
>> -		mlx5e_deactivate_channel(chs->c[i]);
>> +		mlx5e_deactivate_channel_pre_sync(chs->c[i]);
>>   }
>>   
>> -void mlx5e_close_channels(struct mlx5e_channels *chs)
>> +static void mlx5e_deactivate_channels_post_sync(struct mlx5e_channels *chs)
>> +{
>> +	int i;
>> +
>> +	if (chs->ptp)
>> +		mlx5e_ptp_deactivate_channel_post_sync(chs->ptp);
>> +
>> +	for (i = 0; i < chs->num; i++)
>> +		mlx5e_deactivate_channel_post_sync(chs->c[i]);
>> +}
> [Severity: High]
> Does freeing the channels here need another grace period after the
> page pools are destroyed?
>
> mlx5e_alloc_rq() creates rq->page_pool with pp_params.napi set to
> rq->cq.napi. That is &c->napi for regular channels and &ptp->napi for
> PTP, and both are embedded in the structs freed here.
>
> When an in-flight skb backed by that pool is freed in softirq on
> another CPU, page_pool_napi_local() does READ_ONCE(pool->p.napi) and
> then reads napi->list_owner without any lock.
>
> pool->p.napi is only cleared in page_pool_disable_direct_recycling().
> That runs from page_pool_destroy(), reached from mlx5e_close_rq()
> through mlx5e_free_rq().
>
> Before this patch, mlx5e_close_channel() ran mlx5e_close_queues()
> first and only then called netif_napi_del_locked(). Its
> synchronize_net() covered any softirq that had loaded the old
> pool->p.napi before kvfree(c) ran.
>
> In the batched path, the only grace period runs between
> mlx5e_close_channels_pre_sync() and mlx5e_close_channels_post_sync().
> At that point pool->p.napi still points at the embedded napi.
>
> post_sync then calls mlx5e_ptp_close_queues() and
> mlx5e_close_channel_post_sync(), which clear pool->p.napi. It then
> immediately calls kvfree() on chs->ptp and chs->c[i].
>
> page_pool_scrub() only calls synchronize_net() when
> dma_dev_need_sync() is true. So on DMA-coherent platforms nothing
> waits here.
>
> A softirq that read pool->p.napi just before it was cleared can then
> read list_owner from freed memory. If the stale value matches the
> current CPU, it would also take the direct recycling path into a pool
> that is being torn down.
>
> This affects mlx5e_close_locked() and every mlx5e_close_channels()
> caller, for example ip link set down or a channel count change. The
> single-channel mlx5e_close_channel() still does
> netif_napi_del_locked() after post_sync, so it looks unaffected.
>
> Would it work to destroy all the queues in post_sync, issue a second
> synchronize_net(), and only then kvfree() the channels and PTP? That
> keeps the cost at a fixed number of grace periods. Or is the
> page_pool core meant to provide this guarantee, and I am missing it?

Right. In v3 I unlink the page pools in pre_sync, so the existing
synchronize_net() covers this.

>
> [Severity: High]
> Is the PTP SQ recovery path still safe after this change?
>
> mlx5e_tx_reporter_ptpsq_unhealthy_recover() in en/reporter_tx.c does:
>
> 	mlx5e_deactivate_priv_channels(priv);
>
> 	mlx5e_ptp_close(chs->ptp);
>
> Before this patch, mlx5e_deactivate_channels() ran
> mlx5e_ptp_deactivate_channel() first, which ends in
> napi_disable_locked(). It then ran mlx5e_deactivate_channel() for each
> channel. Those calls did several synchronize_net() calls through
> mlx5e_deactivate_rq(), mlx5e_deactivate_icosq() and
> mlx5e_deactivate_txqsq(). So a grace period always followed the PTP
> napi_disable_locked().
>
> Now the single synchronize_net() in mlx5e_deactivate_priv_channels()
> runs before post_sync. mlx5e_ptp_deactivate_channel_post_sync() calls
> napi_disable_locked(), and nothing waits after it.
>
> mlx5e_ptp_close() then frees the queues before netif_napi_del_locked():
>
> 	mlx5e_ptp_close_queues(c);
> 	netif_napi_del_locked(&c->napi);
>
> 	kvfree(c);
>
> The call chain mlx5e_ptp_close_queues()->mlx5e_close_cq()->
> mlx5e_free_cq()->mlx5_wq_destroy() frees the CQ buffer, and frees the
> doorbell record through mlx5_db_free().
>
> Meanwhile, mlx5e_ptp_napi_poll() keeps running under rcu_read_lock()
> after napi_complete_done():
>
> 	if (unlikely(!napi_complete_done(napi, work_done)))
> 		goto out;
>
> 	ch_stats->arm++;
>
> 	if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
> 		for (i = 0; i < c->num_tc; i++) {
> 			mlx5e_cq_arm(&c->ptpsq[i].txqsq.cq);
> 			mlx5e_cq_arm(&c->ptpsq[i].ts_cq);
>
> napi_disable_locked() only waits for NAPIF_STATE_SCHED and
> NAPIF_STATE_NPSVC to clear. Can it return while the poller is still in
> this arm section?
>
> If so, mlx5e_cq_arm() could write through mcq->arm_db into a doorbell
> record that has been freed, or that mlx5_db_alloc() has already given
> to another queue. It would also ring the UAR for a destroyed CQN.
>
> The other callers of mlx5e_deactivate_priv_channels() look fine:
> mlx5e_switch_priv_channels(), the ipoib paths and mlx5e_queue_start()
> go on to mlx5e_close_channels() or mlx5e_close_channel(), and both call
> synchronize_net() before freeing. So this seems limited to the PTP
> recovery path.
>
> The later patch in this series ("net/mlx5e: Batch ICOSQ trigger RCU
> synchronization") does not touch this path either.
>
> Would either of these close the window?
>
>    - Add synchronize_net() before mlx5e_ptp_close() in the recovery
>      path.
>
>    - Have mlx5e_ptp_close() call __netif_napi_del_locked() and
>      synchronize_net() before mlx5e_ptp_close_queues(), as the batched
>      close path now does.
>
> [ ... ]

In v3 mlx5e_ptp_close() calls __netif_napi_del_locked() and 
synchronize_net()
before freeing the queues.


Thanks!

pw-bot: cr

