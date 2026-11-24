Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795522131;
	b=Ycn6i9zDnumSOUu6cfPJxDRaF/HNqhoZbQ9yCvYPFG1xTGwFNv+PdUsIkkU29LvxPR+d
	 0yIuFMyFTtZpcNWQ9r+4yLenkYe4IIU9WisgPyirgWNrDYRggednINqkeuNLgi+qVP3YE
	 WMaBP9VraLITsqvyWWTxL4xENeM7LEraLWbDjC+CZOuJPSepz8kgniUcqpWVgfrbbYGy/
	 V5BaNQpcHM6sXiNl792MyYfRjI36WBt1IpF9QDjQcSdCPB7cZ0r4XpJkk0aplr+okblBu
	 UH8kz14Akd+KayYCXli1Jpzlrh1duKr/z94CK5t+nPtslNB+3lyCu9Xsi00Hxx2A95w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522131;
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
	bh=sC+pPYfzoJshrKsBRt8f5AJDY2YKQ69mh0arLJY96YU=;
	b=rZvRQJg5onqPZFkcKDSDlfJBY5r2sApU8CHw9wgO8cz60ISsF8hLx5R6yrD3pmJvlSaF
	 /Y9chst2gWRTxheM451nK1vULds4BpOUQmghFL0caCzhDxQ5Jba4v8YuxG947Ixwg5U5B
	 Vo4IaKN+IxJwiBRNpCAoQzMxXO7UcvpYATFQqlCSfmnDjTJgDuwgJluSMvqS04d2wGwST
	 cpcJT3KvjIpYMjrTdSX0nrwU0OdFut9mO/1itWXPLIuB2Eyvva51Cb9XtiQyyf1g74t9T
	 MAi28bqLP69DLhMXDuVInlsNAs/pupVez6g3NasUK3FkNyfyiaETayRUG1UdNEPQ42Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DUK7ShfU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011005.outbound.protection.outlook.com [52.101.57.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D41E606A31E;
	Tue, 24 Nov 2026 12:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D41E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DUK7ShfU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruG3K+C0HQqbLuf5TqFx4A3W3TPQCLOkqgjEqem9peBXY/cOF5K75bSqzP3QLQrHIzCUR/dH0h1vfLIPE4w/Emje12NRYA6BzzwV8G+SBeqltX6bY0v1NQZQsYtLnr5fbvSxugpLmMu8E6wBoCeLepv7ZvxpvWomeLfQnpAurzoPSpUZvz4D31c0Mm9RizG9YE/SD8lsvXNWzmd731bzoktAmRghqsnBFmpHAco03dNgbN/9CTmDQ93jbAfs0LlzqKeei2woMooiJyT1NOr3DO3HYr4nVkThhWQkNhqxw76OsLn3u8u8s68ijGk74Q6NGwaP4tHqJI+GBTNL9YEDwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sC+pPYfzoJshrKsBRt8f5AJDY2YKQ69mh0arLJY96YU=;
 b=RqDLz2ywHYCEhXvJKSEUR7dIkiYlPmiMXt1wcoUNJ/tKNOd3t01dVQQydPlZq/fVYgqHIzWELgRlkbyktK1Bp2QMC8a6o7uZY6sXiVFfz/7QuHkjvLl7R1y1d20Sx7QLz4AXBR+DPHOqqs8Zu3C0cLfwFLsfbOmBlm+e/0YYJDorUWQ9UXDzEcLvvityAsqOn4KR43Y0d0W8Cd0Vq2pbFdL1ocxx2BHURDxMkVvYEr+1NhqGn58gySWS1YZt5gUMlc3xSGfKvBItLYoymQtBx1YaMkAIaXw1NyaOBOGm72ez5AtWN05LWHV8UGyGu12ro5ufBDnlK5UIEE4ILd8JdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC+pPYfzoJshrKsBRt8f5AJDY2YKQ69mh0arLJY96YU=;
 b=DUK7ShfUwS+o/kMn1hAk6AKIoFI8r7YItAJ5hF4UWTmTVmTaHq5pWw1x5m1DY9FLKWeohFmCzxfta8bOD4O0mton1ZCJjS0fkJivsXpQHX6hvu0D6eHfG0/6AuYC4UlUomnURNVWMtjbSYjjxGqXQ+fcUeQJCiLq6ZXZ8eKSaKFS602aPSMcudsZlYRb2ljW3/uVJzyq74C1ledd4TJjrM/AuOxIRUH5VEfWECIUNXj6hq0YF7OvAaPmBcQdtlmYO2plAWtRg0u9u1Qazu8ixEzw2GkCtb8ml4N6w0Tqxu6duBNK51O81bSdQOgiJyDERr8ybyFnzOxakkbkjuGJCQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by CH3PR12MB9316.namprd12.prod.outlook.com (2603:10b6:610:1ce::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 12:08:42 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 12:08:42 +0000
Message-ID: <fb13f8ff-41ed-4464-a182-cabbe7028ffe@nvidia.com>
Date: Tue, 24 Nov 2026 14:08:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 4/5] net/mlx4: track whether a TX doorbell is
 pending
To: Paolo Abeni <pabeni@redhat.com>, Joe Damato <joe@dama.to>,
 netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-5-joe@dama.to>
 <add5a54b-eaa7-4507-b089-6a6c330c39b6@nvidia.com>
 <9fb09021-bd62-4a96-9218-7c2e0739734e@redhat.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <9fb09021-bd62-4a96-9218-7c2e0739734e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|CH3PR12MB9316:EE_
X-MS-Office365-Filtering-Correlation-Id: d036132e-e1c4-42a1-14f7-08df4a23ae6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|18002099003|22082099003|261009223027099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261102123227099003|261022075727099003|261028144727099003|56012099006|10067099003|261021121427099003|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	wj4x1o1uY7GwCA7gGw2VQBrsbCoGQXXZyy/UVv3FBbKzP2yTuOAIQGwKZCYQddVYmnkywjhA8DWB2UdnhCm9hQCd0/uuNrX6uQM2K8xsMpSxjo/1Vj3yry87Zw930blkNH/9KaUSqAOyVN6vKRlTlIn78dbF8hByF5hr4BVVPLtZVyi5hY4vWQ3MB5z2pohVERmELD1kIhl/BmpTqUyg6aeicLETttS3SvPol8QTsLOhffI5TyJ9oBdTWk04JlR3g2pLV5uQfUxYG/p7QyDcUYBntuxHRe+3f68KoerlOJBLXGA4jMuw+TsYCvgp8IVE8yo1mSe1gJxLK1mfNTTy4o2eLdKvzfPgDWGixtETfXvMgvG0aiRXqZsiw738n8Jy0FECN7k/Inwr/KjQJTdA4Qi2u5oU0tv0cdX7NH0nex8IUXF/07eziwon4Itra5rLJe9r/dmR05yeX1R1Hq39L94Cs5+YqvLVQ7576hYAqAA41KNNji64Pj95wZedMDXSSkyZKkg7v3E03O2TEDy+4whkSUT3ZH2u1WzBuuVo/7e7fDPccdJttNHIeDnd3W9fiQS1kc+YKMmOI/Io+3nIqSmzx9mvhkvkMywWiulJJex0od7kPYIS/1tAEDNNeONQ/ZycaWBrwJ9PtkIJdU/cpdmHgctuIxe3MzwO4W27CFM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(18002099003)(22082099003)(261009223027099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261102123227099003)(261022075727099003)(261028144727099003)(56012099006)(10067099003)(261021121427099003)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUsxcXJEcHE3bUQ4RFN4eTRYbUZYQk1kTWl1ZkhsT1RCamtFQnR2WTRBaE1x?=
 =?utf-8?B?djJoRTlHbnlSdWVsSDJZSTlVdVBKcS9LRnkyYmtpRlkyV000U2E5Wnl3dEdx?=
 =?utf-8?B?cnpQVW5RQkFKT2h3NE55ZzMxQTlHZUV6YjE3N0l6TjJzSzhxQ3hiRldWN3Rm?=
 =?utf-8?B?WVNrNmFBd2xzcWJ3bWpmajNjQmYyL2FvN1NUdUFVeHo0dlpITVQ5ZkJxdkJG?=
 =?utf-8?B?UDFwZkhxaEJKSTdLc1l2ZG4zR0ViMW9YR1NPc0QzdjdZZW9ocTZQQVQrV3Fk?=
 =?utf-8?B?TGtHZ28zdm1RUjNKb1JEbFdaTUZNTTU0MmROZkQ0VXhWamZNcGVMU2RjS0RP?=
 =?utf-8?B?cWVhZlE0RDlZVEtRenAwclNQME1FTlpJd0VjeXhzMlpNcFhsa2J4S3d3QWxG?=
 =?utf-8?B?SDhwQlVaQi9LNjdwRTJRbFJFMTcrTHRtQjQwSnVTTmRZL0Q3M1FnQ01kSDlZ?=
 =?utf-8?B?dDJDN0dhTFJaSzFVbGdlWllGck1Kc3I1NlFid2ltTTZqdW5ldDZpeWpRcW53?=
 =?utf-8?B?Zk0yaFN2WGFDQXJjaDV4bXBHcitUQlpaN09hTTJ6WmJYWHpjNkRPeitBVGcx?=
 =?utf-8?B?cld3VjIwV0svTVdkeVRnNXVZQmdUaldhc2txV2xJcExzYVdpVnFaV0xad2lD?=
 =?utf-8?B?WUpYd0EwOExwSnhjbFdlc3BESlhyMnY4VlBrbzduTlh5dkxJMFBIam92V2h4?=
 =?utf-8?B?NEVmUHJ0WUlubGtGYVBYY2piOXhYemsrckhBSUc4eXp1YkYzMUp6bTdTMWFy?=
 =?utf-8?B?ajEyTkNDRmJ4TUs3TkEwTmJZY1h6MHMvWTh2ekRQOVVYQmRHOXFCbFJLYlMw?=
 =?utf-8?B?QUNubnlWd2ZnYkxBb1NWZkFKMjQrSjNmcHFQM0VqYUhBcGl5Nk5KeVVxWDNq?=
 =?utf-8?B?Q24xVGtFNzg2RVA1YmZyT1RZUjdCVWtCTnRiaEhhK2l0MW8ybDQwS05QY20x?=
 =?utf-8?B?MnNHYlJlT1RsNFltU1ZMSmpzekhpak54cE5SZXRJRy9rMldpUld6b0diYmJP?=
 =?utf-8?B?ZjFkaDJiMGpjK05BWTVqT3ZHb3E1YnVhUTFYVE13NmVLN2R2bUhpUFFtNGNE?=
 =?utf-8?B?R3JYTFVjTkJpcEkxWUZDNWdhQWFRcitWRDJ2Y0xMSzRoYkIyQWtSMlkxS0FL?=
 =?utf-8?B?UTBjcVFzbEQ0b3hSWDIwZG5RNkdZaE1xb0FnUTdtUm43SHAvZVU5d24zL3A5?=
 =?utf-8?B?VDFsRzZXcXhFcWF0Y2YzNmsyT3d0aFBLRWc2UC84Uk1YYXJrZ0tTZEFMTU04?=
 =?utf-8?B?VzUzSU1ielJ3UVhhUjVPSUc4Tk1SRjNFMENTU0lkcHJPd1RqZEw1bVF2UFJC?=
 =?utf-8?B?L0ttWHBWbHFkZStEV0FCRlJiSDJyMDlBaWZOQUJvSHVqKzFqSFdoTEpiaDQx?=
 =?utf-8?B?L2g5Z2x0cHRBL1orcFR2c0ZNd056cHRWNWFZYmlSNlprTHRnZGN6N1FCUUln?=
 =?utf-8?B?WGVlR0VSQ21lYm85UHBoK1FTL21lbjA4MHFMdjZseHNibk1COC9TcEtEemc3?=
 =?utf-8?B?UVMvVHZVeTVBV2pXWUJCOGpyOFRKQjBiU09CN2Z4eVQ0ZDZCem43b084NjJB?=
 =?utf-8?B?a2FKdXFVUWdXcTVnL2ZRMEFmVzZ1Q3cvWTRYbG92V3hzbW9IT1JjcDMrQzBF?=
 =?utf-8?B?T3ZPODJXZVgrNk0rYmVSbTB4MDNNdEdUR3o1ejNPMWE4YjQ4blNqeDFzNHRo?=
 =?utf-8?B?UEgwSmY0WHZxdVppbWpLOTZIYkZrdjRzck92TVN2bVc3YWdKaUFtMnBadWxY?=
 =?utf-8?B?cDF4REY0cXVHbkRnR0JlVnBPM0RLSnpwRjJjZW9sYytZWVBuVTU0dDRCeUly?=
 =?utf-8?B?VTE2anRva1VlRTlRTy9hWUs5a3RLZUVucG9xbThhYXFNcnJnRnNNdE1RNFlt?=
 =?utf-8?B?Vkphbm4vcmRqZHBOa1JmRk5IVzlON2d5NlgydGVrWFVaNzMrcUZaWGJjN0Vz?=
 =?utf-8?B?eEpJakJiZFovUmh3d1o5enNjbVNlR2cxVU1qOGVaUUxUMkFCcE5VMGpHNFF4?=
 =?utf-8?B?MlRGdTF2ay8vK1FUUTNCWGxPYjRZVWdqcnJxR2xwZ09lbmVEVTREVXBzRk9z?=
 =?utf-8?B?OTB4a3RCUzZCVUtKRzhjQ1hPTXY3NVZmVXUvSmJUUlNNNnZJQjJ4Y2xVVW5r?=
 =?utf-8?B?Y1N4S1V0UnpQNFg0dWQ1YkE2TTFxblZZdVo5ek8ydVkzc3RrcGFsTVBzU3Bw?=
 =?utf-8?B?RzFJUTNxR0d6QzBNY0YwNTRmaGV4M09rS1czeUxDZHZFWEkxbmwrT1NlaVBz?=
 =?utf-8?B?V2ZsV0hQMFJzS0d2VTJXaEhFdm8rclJKYXl5UUVuTWVCcDNRNmtNUEZEcHlC?=
 =?utf-8?B?SnR2S3VRUXZMZGNlRGJ5TTdHcHJvckhMWEgzS0xNME9GVm5aaWJPdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d036132e-e1c4-42a1-14f7-08df4a23ae6a
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 12:08:42.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5RHzBvYakOGB0x+TKTevgLZajA+n1gCVJq8abkp0SsptnfOpKCpjdY2pFHXtlcl7RUda1x9tLlCWvkDiwLjhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9316



On 24/11/2026 13:55, Paolo Abeni wrote:
> On 11/24/26 11:46, Mark Bloch wrote:
>> On 17/11/2026 17:53, Joe Damato wrote:
>>> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
>>> relies on a later call in the same batch to write it. Nothing records
>>> that a doorbell is owed, so a path that ends the batch without writing
>>> the doorbell leaves the WQEs posted before it unannounced to HW.
>>>
>>> Add ring->doorbell_pending, set when the doorbell is deferred and
>>> cleared whenever a doorbell or a BlueFlame write is issued, so such a
>>> path can flush the deferred doorbell.
>>>
>>> Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
>>> prod. That line has no room left, so move tx_dropped, which is only
>>> written when an skb is dropped, to the end of the struct among the
>>> fields not used in the fast path.
>>>
>>> Signed-off-by: Joe Damato <joe@dama.to>
>>> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
>>> ---
>>> v2:
>>>    - doorbell_pending moved to the area of the struct marked as cache line
>>>      used and dirtied in mlx4_en_xmit. In exchange, tx_dropped is moved
>>>      among fields not written in the fast path. It is only written for
>>>      drops and is read for stats.
>>>    - Update the commit message.
>>>
>>>   drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 9 +++++++--
>>>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 3 ++-
>>>   2 files changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> index 97f27e005810..123071a47bed 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> @@ -194,6 +194,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
>>>       ring->prod = 0;
>>>       ring->cons = 0xffffffff;
>>>       ring->last_nr_txbb = 1;
>>> +    ring->doorbell_pending = false;
>>>       memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
>>>       memset(ring->buf, 0, ring->buf_size);
>>>       ring->free_tx_desc = mlx4_en_free_tx_desc;
>>> @@ -757,6 +758,7 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
>>>       iowrite32be(
>>>   #endif
>>>             (__force u32)ring->doorbell_qpn, ring->doorbell_address);
>>> +    ring->doorbell_pending = false;
>>
>> Can we keep this in mlx4_en_xmit()? XDP_TX calls this helper too, but
>> tracks its pending doorbell in a local variable. If the XDP TX ring
>> stays full for the whole poll, this store can dirty the producer cache
>> line even though we didn't post a single WQE.
> 
> I guess you quote the wrong slice of code and that you are referring to
> mlx4_en_tx_write_desc(), right?


I meant the clear in mlx4_en_xmit_doorbell(). There are two paths to it:

skb TX:
mlx4_en_xmit() -> mlx4_en_tx_write_desc() -> mlx4_en_xmit_doorbell()

XDP_TX:
mlx4_en_poll_rx_cq() -> mlx4_en_process_rx_cq() -> mlx4_en_xmit_doorbell()

In the XDP_TX case, mlx4_en_process_rx_cq() passes its local
doorbell_pending by address to mlx4_en_xmit_frame(). If the TX ring is
full, mlx4_en_xmit_frame() sets that flag and returns NETDEV_TX_BUSY
without advancing ring->prod. At the end of the poll, the local flag
causes mlx4_en_process_rx_cq() to call mlx4_en_xmit_doorbell()
directly. The new clear can therefore dirty the producer cache line
even if the poll posted no WQEs.

>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> index c5d564e5a581..9d8a4ea473f1 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> @@ -1074,6 +1074,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>>          send_doorbell = __netdev_tx_sent_queue(ring->tx_queue,
>>                                                 tx_info->nr_bytes,
>>                                                 netdev_xmit_more());
>> +       ring->doorbell_pending = !send_doorbell;
>>
>>          real_size = (real_size / 16) & 0x3f;
> 
> AFAICS, preserving the state across poll() invocation is needed
> for correctness. To avoid writing the cacheline in the XDP case,
> mlx4_en_tx_write_desc() could return the new ring->doorbell_pending
> value.

The proposed assignment still saves the state in ring->doorbell_pending,
so the next mlx4_en_xmit() sees it. Returning the value from
mlx4_en_tx_write_desc() would work too. I suggested using !send_doorbell
because mlx4_en_xmit() already has that value and it covers BlueFlame
as well. Patch 5 would then clear the flag after the drop path flush

Mark

> 
> /P
> 
> 

