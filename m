Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794322708;
	b=oUtsY8gOcl4cFFUfKAEnzvGHnXayWIC8qgQGZLV6JKZ/pNEfxFKssCwWakUniA0iS3kr
	 f0aUaoQbC9o0DpQBFDkiydC0C4qeTBW7HEQjkCDKcSCNS5ppVgARsLHaUilM+T4SOqPr8
	 pAtwfkEbWef4nFMmzFqW4M+Xl1klLgZFgDTzsCY0ImbuChgg0xn5o3FJpmcAjIVo1OHxm
	 ZGnTj2DZbsRzihleStLDuhKzHF0v+y/XrI5PNTELM9kg4KSYGiIGo2fYEUECEr/djfGcP
	 Lai7PeS9LP4cxouc2U4UrvPHQteR/521HUQKKGhQwZ/RII9pH15y9ZAxoIy2FjmAlhg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322708;
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
	bh=1fEWVB4s8dxpy7WKjeYRypYyTAh25nN2QNj1LosPIjA=;
	b=DiE3WS+M7eBzzqJBQZviyCg08CpPAesMLzwcUtgi8DqW5cBPxBlhU1lC2ZQi59tqHP3H
	 Ufn59vgOjivvExrxr1YjZiPqNpmOhNHp6dDRNLUsOz2dqHnwDLESt/XEhFZooCf54KxAX
	 ipEQoxbBOe+DK9GSIDkOW2IdV/+3hOjqwAxCmAYRviMkJDhkQDHy2Z72n15rrZZoQYacY
	 xjL7GfyybqlcGrDm+Dxkqt9pU8Yf+jBk2C8n6+iG6YotfxEcRzQhs3yP+YzSZ1zrx/vjG
	 lNht8foe1lMpD3iTdZkKDRYWDYtaS6Cf5X9agxHYMaAG7CIgEi70EhLfLZAuukce7sg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZT2Vdl+F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.69
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013069.outbound.protection.outlook.com [40.93.201.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288EF606A32E;
	Tue, 10 Nov 2026 14:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 288EF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZT2Vdl+F
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YW1soDX1RI1GjOOfOFd24YcXUpY+yb2XumymfVOErJPCjLWxJ+OP9r6pGdkpQMdIroZPbgsSZ5QNm0CdiV26yyMS2vy4M2+Y+w3S0mDidvstNq1KWx6sN2ITS+PIKnvtJJcu89W/9t8DPKi+2jvW/OL+xNwteYeRfsmmYXi4SUVqjL9kh4JWri4Mz0wB8A7DoWVw1/d3INOJ/Z9/0s2/tNt8UtOrXGYHhonIpFvdvxqUaEGkNkegEe9pzoNdC68Sr6zQAVw3z5xDLf1zUKmVT4M/Gywy82V21buAB6Nikgb6eC91MVPTyjt/m0pxXTPhOG5wzvzTqDqmhHMcnK+dwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fEWVB4s8dxpy7WKjeYRypYyTAh25nN2QNj1LosPIjA=;
 b=bdVpa/bOV3/38Uft3+ZmuMB8oPm8FvQMbz0JFxfjomPRGzChqEkYqTrFZsFDQ0AR05BFh3CCjgY2/hP1SO5+E3wH1vMAPeNJP/nbfYdmkiSH8uDIKs2H4PlNRTmVm8sDYq78pHuj+4ZnL9oxbFQeuDS3ISPlNca9OSLZKZDCnmcKbW4Gna72XOwo9HXPQ3TJGK/buczXg+WO1FPP6S9EV0sy/4WuiOzaag9c22a70mjlCFnBzuQljj2HwfOqLPLQj3S3aPpxyYkn2CzlgBfcCkLlrSCUJfbhPIHoipLSZIDnDO4aX8efjxgzb10z+9ZUTqQWs0oeQ0W0v8KMhycuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fEWVB4s8dxpy7WKjeYRypYyTAh25nN2QNj1LosPIjA=;
 b=ZT2Vdl+Fx9I8nrxMMMCc0og39ud24jw11IlnhGJKm0N6eryRIudOybN2JZ4QcjwQ/90CMF8Y0O6SUxN7D13uPWH9zaLQp0E8R/YFewULTrZTXrsxp7bQdh4BMdEPAEgovFi50GN0JwLAhtzHM1nAiUDU3nrSFLGq7V6XCQ/MBSNQuKf5GTK3uTn2Hnfo8yxjcVBU43m7zRqOvD5WiinHBwGr50jca1l1OvAphA7lZVFkyvJaOscd0xnxap7pXkqbk5Z45Q3koR/EZgznZX5q40jce1IkpUZvmTtptq9D5k2zF3lrKIIC89v6ym7WUyvEdqklI4i0APppP1KHk1H7cA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SJ0PR12MB6990.namprd12.prod.outlook.com
 (2603:10b6:a03:449::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 14:58:19 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 14:58:19 +0000
Message-ID: <a483f6bd-3fbc-4b9c-9262-5e4dc0d5e849@nvidia.com>
Date: Tue, 10 Nov 2026 16:58:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC net-next 7/7] net/mlx5e: kTLS, Keep a TX connection on one
 SQ at a time
To: Rishikesh Jethwani <rjethwani@everpuredata.com>,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Neal Cardwell <ncardwell@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Willem de Bruijn <willemb@google.com>,
 Alexander Graf <graf@amazon.com>, Aviad Yehezkel <aviadye@mellanox.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
 <borisp@mellanox.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Costa Shulyupin
 <costa.shul@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Eran Ben Elisha <eranbe@mellanox.com>, Gal Pressman <gal@nvidia.com>,
 Ilya Lesokhin <ilyal@mellanox.com>, Jacob Keller <jacob.e.keller@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky <leon@kernel.org>,
 linux-doc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Martin Karsten <mkarsten@uwaterloo.ca>, Randy Dunlap
 <rdunlap@infradead.org>, Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Tariq Toukan
 <tariqt@mellanox.com>, Wang Zhan <wang.zhan@smartx.com>,
 William Tu <witu@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-8-tariqt@nvidia.com>
 <CAKaoeS2w15yqv-yd9t8KC3aZMJH1VXM=oepk4sR9h1pPjerKOw@mail.gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <CAKaoeS2w15yqv-yd9t8KC3aZMJH1VXM=oepk4sR9h1pPjerKOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI2P293CA0006.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::18) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SJ0PR12MB6990:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e85f05-98d3-4ba0-f91f-08df3f3b0e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|11063799006|4143699003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BcVI3kgi/ff/RSJ8JVsbmt5TcmlMCfM4TAuSUf9wSEQ4mUNhsQZ0f+SP+7xxwgkVP8n/JJ8OTF2wbeNLKvECRtky3pNYP2+xKc4rn1Y47gojTJtY7hibeVTvhvPF35C74YGOGc+0311OlmC+VuKLT2GUejPH8I3W6RdR7dSGf9akUVaoOORZfpwBSIWNRF4Ft46kPH8euBen2w1YJC5Dkk/iEXikTNLdNSqJP586Aos5yQfJsJBobcFmwxwEgArc6+7OVNxkYRJoRpkX2yvig7FE/YdOs2CDP2LZkH8cG2wW2NYRqFAqQZnkB5aHQzK3fBQ1Qbnk95JCBP/yopLiHnnUMe8Q/UTaInPUnaAt6WeZuYGR39wF8Hdo+sX0oaT8o40YA3NuMsZ8RjKB+PIexNXhz+ElULeSL6hLrW2ILRbF2heczQCslaGmn4vIzmfDT+6OjtmrqBORx+4xs9sXsbnfVqT8Blgzu4WEpFn9A37tkVb2w0Ssy3INkrNhbi+RdTa3hcjVXQ8Ekj2doffKLt0ixIfUNaM9NsWPkiZ9uwiom95gOlZr0W35fnbvZxYPgNSh16vcVxH4Ppq91/7XxhcNlfpiNARIOqYbHogOYATJiGkbLUliR623Ih4lgniyLDVm3OwWuexLBW9vw2HK12rt1uMXJZjEGJ+epkapVDY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(11063799006)(4143699003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bE41aUQxV01UbktJNE8xYWRwb01QTDlSemlGNUhsYktxeGZwRmM1VUowQ3J6?=
 =?utf-8?B?T1ZqVFJ4WFZsRFg0WCttWk1KOWY5WEY3bVQvRHRtNERqNCt4dWpTUWlKbW55?=
 =?utf-8?B?NHk4Vy9Uc0REcncwMFNiZVBCSjF1c0xOanlxMDFaMDExdEVjd2M3M1JBOTMr?=
 =?utf-8?B?aGVBM0pRaUJnVlRQcTZXNU9INS9LY1JESXhxdkN1d3RHRW9LR2VKaVVJS0RD?=
 =?utf-8?B?UDdXL0lPRGRKa05PUGxGMFJsaVZjOFNzMUpWOTNXYTdROEhidW1BTVRxTUZT?=
 =?utf-8?B?cGlPMXlPRDYrdjZJejVVeHU5Mk5TWmNPZUZKRG43NkgvTUZLTFVBL3I1aWNY?=
 =?utf-8?B?b3BJNjM4V2pCbE5CYnZUWEwwa1ljNnRhR2w2L1NmRXErWDYzVzk0U2lYcDNr?=
 =?utf-8?B?RmxjM3h5YTRzRUZVcnJ2L3N6dmRGSk8wdGVCeUhQMDZDbVBRTURjUTFRMHdX?=
 =?utf-8?B?TW9RNDMycmY0WktjTHI4T056ckgzSWRXM29mbnI4ZXBWWWxqWTE2R2YzMlh5?=
 =?utf-8?B?Ty9ZTlFza3ZOZUdtUjJWU0hFMVlTazduK2pMUXF4VC9raGZoYmdKQVk0VWlM?=
 =?utf-8?B?ajl6SGJMY1BXODlhZ21NRE1BZHYvYUMrRW1LRTNlT2VTSGlqR0lIcVpCdGJJ?=
 =?utf-8?B?M1NEMHM5N0QwbU9BUS8yck9RT21RQ09aMFRXS2VERHZBRFJRTDBzNExjSEJD?=
 =?utf-8?B?cHQ5eEJQcWc2eXhVUVBrV1NxYm1ia00waU9QNHd4SFhqMDY3M2FxNmNLaGd2?=
 =?utf-8?B?RlVwSytwRnM1Nm1IQmNueEcvcVQwbWFaeEQyVDZZbHZkaUN5eEllaU9jalh5?=
 =?utf-8?B?VHJOM1p3Rmt0bmgrMFI5dGF2amJ3NkUxT3hPUTdsSy9ydFhIenl4UUNGaGRn?=
 =?utf-8?B?c1F1eUQxZkxwemZpRWNQVGVHNjBqeUFJSkNZQjVYWTFVOWRrWWNLaDJYTzNn?=
 =?utf-8?B?TVB5RG9zS3BzWGdmSkVXalJsWmIzZjcvc2ZVbmE2c2ViamtrSWRWS2lKZnNz?=
 =?utf-8?B?UUJHZGhhUWJwMXplaHhQSzJzU1V1aG9sS3VlTFZoNjdoc1VUTWRaY09NcWJZ?=
 =?utf-8?B?YU1uMjR4TDVDS2drQWV2QU51TzkwV3dkQUJqSitxUWx2VXcvNlE2UDdlb0hX?=
 =?utf-8?B?amZSK01kUUZONm1QZXJaQU9wM00zRVFTNzQvTWU2SWpkUDhraURwTkprd3dN?=
 =?utf-8?B?VnRLSHBaOUx0SE83WjgrKzBqcGdrZG5VMGRnZEJ4L1dzZ1ExSk9McFBPajdo?=
 =?utf-8?B?dXQrNmIwTEVBZTFWSGttUkVIMGNoeTJkc01OdEN5bnVwY0xPcTg0TWNYWXdK?=
 =?utf-8?B?VFNNeVdmT0tsNjdsYTlpRXFpTUMyNFBRTy9PZlppTEduZ3JsMi9RWTgyVWdI?=
 =?utf-8?B?ZSsxa1VicHdxTFpJTFlCampIS3VQL1BkYkN1T3RBaXVMVXdLQ1EwVDBablhj?=
 =?utf-8?B?UTFtTW5vNkw5RDNjWndraHhabmRrVXBXWWRSa0pqMSsrUjV3a0gvVjVMUFNO?=
 =?utf-8?B?WHQrZzZmemR0a3RYOGpuMjIzbDBBTzcrMzJtWkhUL2F3UnJzdnZ3R2NOSE1G?=
 =?utf-8?B?Njl0V1EwU0VFQzFhYldsVWRVMzRybVhaYUZ5bmRYeG94cjZ6b0NwNW1ORnYw?=
 =?utf-8?B?dkMxSUNXYmQ0elVyOTZBWUhUZTlwMCs1N1ZBQjBxZUYyeUU0Zk5VY2xOcDJ1?=
 =?utf-8?B?VW9Fd1gxY3hqeGtrVEdoSjNGdmRNKzY4N3VobmFJNXlqS3BsMEVmYnEvZE1W?=
 =?utf-8?B?ZFJaM1AwZFhzdzlHajl0UGFSMUFtcWFsUXh3ZS9EclZOTUt2bm9mYXVaVFJy?=
 =?utf-8?B?ZzNScVJhdkFSY3lad01KdU05aDRNNE1Mbm1YWkxBMkhMV0psKytYZ2dqcVIz?=
 =?utf-8?B?MDVrSUdQSTA5Q2lqM2JjNzZCbVNHekFnNEpvaUlOUWlUUXEvVk1VTU9uamE5?=
 =?utf-8?B?b2pxYnBUbjlGZW5EZzdzdzdYRitKdTlWUC9yaDlRTUo0YjB0aVRaYXl1TWhV?=
 =?utf-8?B?dXNTdjF0elRqak1IK3pPQW92ZkcxQWN1L3pZVG5hS3BDaW1yY2tyalNDZ2xs?=
 =?utf-8?B?QVlIakU5S0dFVmNPamlCR2JGZDNHRlRzZ21Cb1JFai91aFVhblNGdkxVOXBX?=
 =?utf-8?B?VnBJcEU0Vi93ekp6SjFJZGJ5QlpUNTFOWVRPTjRZSFJ6TVZYQzY4K1dBRGk0?=
 =?utf-8?B?OCtsaDE1OE5IYlRiL21FOGxRb0Urcjc5aldzajdpaU1WVzhKbEs0aWpsNG9q?=
 =?utf-8?B?bko2ZzN3OENHQklQQXltaDcwTnR3d2lHTS9PY0lXdDFFQTd1V0tXcHpmM0lh?=
 =?utf-8?Q?M6ZWZzd4dbxQTQ0k+D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e85f05-98d3-4ba0-f91f-08df3f3b0e7c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 14:58:19.0921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfjCFefMzXC9VjvgVfAawK+peprI3qgFrsLFfq1YstEFJJXx5LdHU0w3+KVacG1yyhMj2rBCWibsq/njUteD8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6990


On 10/11/2026 0:15, Rishikesh Jethwani wrote:
 > This write relies on an earlier may_move check in mlx5e_select_queue(),
 > without locking the old queue or rechecking wmem.

Right, I assumed the socket lock serializes selection, which doesn't
hold with an upper device's qdisc in between.

 > Selection needs the same initial-claim CAS and locked handoff: recheck
 > the owner and current wmem under the old queue's lock, and leave
 > ownership unchanged on failure. Locking only the write leaves the wmem
 > check stale. Preserve zero self-charge for non-decrypted, possibly
 > partially orphaned skbs.
 >
 > A failed transfer can fall back to the owner's queue, updating the
 > cache, if the index is in [0, real_num_tx_queues), still maps to a live
 > SQ and is not a PTP index. Keep the xmit ownership guard.

Agreed, v2 does that. Selection and xmit move the connection through
one helper, as you describe, and a failed move falls back to the
owner's TX queue under those conditions. The xmit guard stays.

Thanks,
Tariq
