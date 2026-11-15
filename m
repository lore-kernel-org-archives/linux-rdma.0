Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794739163;
	b=nCnBNGnjCPfmPr9MCbliZ3IHS24hImyMFNQmkRIpwkp3qhJBcExlK1A6L25HFkiFhZc7
	 xDcS97OGfXRSrBuECEJheluApTK0h9jpeA6OtA0bYDSKNsIVumpbh6uRh6C6zsLJ7RNKX
	 hcEiHlKT5RdjK/VYfGUQ7hBOXJXFFIhaICAPVtPUdfcUTl6/7kemGdzN2jXpkjGsM/9ad
	 6ZYPFa2X+9ASVq8Jbd9JcnYYsyJfXeT4KfHeyQ3daeqOdr7iR+v1rsTYjCjxVuLetRFo2
	 JV2lOdf3hArcn1FnKqqMGdFTnYGLozQs4N7kKzzdiRv0Dh8vytIBmqwHdkGxBUM/YPg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739163;
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
	bh=o6e5RjUi6SxFqxQYYOh4pbeW5UuGJFIN6PorK+EKSDY=;
	b=KIQmwAlS06aGTT2q06cFvy6B5ruxzNYKbD0POc9DTvjbvmFzUCVcqnpF5+wh+c3n3vlQ
	 vBfr63FM8hekeFabnVN5PqlwUTvsV07ufkvQa5n1I+v6UwfySz1cX2ObOR9m9+lKGIMx2
	 DhM4ghfsI3WF5EUvGIx5uyvh5la0brLRQ48vMSBHa+iUARy/GDc9bHfVrXerGgpsW4PH9
	 /5KD/wqEp3aijrCWIJmu09XpBbxCTYV9+dzZu7Cm9rP0VGi84fMHaSNazyNQQ8mThovRH
	 r4Leq+3hJsHZptnyR2znB2aXtBh6kcjVqmlWESsEAM0njfMDkN/y19s7zFAqBWToZ4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Rd3YUliR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.4
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E834E606A31A;
	Sun, 15 Nov 2026 10:39:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E834E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Rd3YUliR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCnfEvphiv6j8KxaCplUFyueIGHPTj/CmoOsdt3tCaOu/npmUP5lCLKSXOIppVHnhwTd+Z7N+38pC9Y0RlPK48LBrCL4wd/eWlJYZ+zrqoL1n5wbjR001BVfPOYSEhP7IM4aHtEdZh+2w06hGhszmlbkDw0hAao8GirVxoNf2PYvugIHfRSUMoe8E4/ZGD2Rs08rAJjhY0HJzuWPU8axNuokpKkp3a5OrOjXWFH6H3d+gIu87GRUH5JEyeBewHlEDYVWliYM41N/rakfeAHGLihcP/oYtAUO8t+cUX/sE1lSq1WNWskvaGJNtzixqsTFb62ZaGk/fadUZFQAa3xtQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6e5RjUi6SxFqxQYYOh4pbeW5UuGJFIN6PorK+EKSDY=;
 b=XaYPhZlnW8oosAvHdkq4LbraeyeHMVLAhwJJFEa1TvH00d7pH9AsCbymFPEXvIx2/Ic9wQ/GJOz4dHzzkHNkQm1lXqkVV72g0WDCnLo7hBhjk9VW/bzxhGI0ioLWfJdsmycBPI9iCR6gqDtiZWA2XIDrrVkSELYuFjR7oAOOqFdFzJyh5bWy+QyGcgDGmzg4Al/EAxjXDJM9pWkq5aG6ykwQMjgzeqVsg1dZno1DMKYu4PyWcgWYwh/3rXxOWrTTYKgIgsU6V4S/o1spLjMmFyXNUMq+afZqbmFn83VW39Fl2Hqs2gh/5IXzLthCVCD2BtJ42GKdpEgJs8uvWWKHjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6e5RjUi6SxFqxQYYOh4pbeW5UuGJFIN6PorK+EKSDY=;
 b=Rd3YUliR9wIAiQ7tT4Q/7yxmPbModkF19nNghsSSL33EEgthVWVRNjSHJmybG1izbVn98ZjzvjQKdEYHBrw49d6TEZSyp67/tZlhgdSTis3I7TqTCPLsqJK+pXFwQCUbQrdQtxZfd+B7LTN3lptDCY7v6NXL3T2O93c3xxhhAKD8Q3R16W9/7x+HMnOWtrvXzo5/yMBahFKXqKxsQftGxyBbKf+MC88yiXgAEWKZzu6qkEkro0cIhvJQ5rc/AQGkw7ZmXmhVU8jsn6u7aL8qSYHRF+I85attqMfgaHsrmo25xSBwcHnJZQ5jrMJIifAiUcvHJP70Q36O0p5e2Df8ug==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Sun, 15 Nov
 2026 10:39:19 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 10:39:19 +0000
Message-ID: <baf3a990-c9a7-4bf1-a1a7-a2b8976591bc@nvidia.com>
Date: Sun, 15 Nov 2026 12:39:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
To: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Gal Pressman <gal@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0133.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::18) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
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
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: da91095d-0391-4aea-9e8d-08df4304b471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|11063799006|10067099003|56012099006|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LQJi7BCaNzaTPUSP5I3icjArGrWxrDfoOhsMiJ+zHUMONQFSUPaFWlnfZR5rV6WTO42fqrU+ntjR6m37uENY/IGZrjt5sz1BeTiWTkxhdmEN4O7aYzndbq2eJFrCSwEeHBrsscO/Yu0T08f2xfMGLRTnhAh4t1Wl4opxtch1+Eh8z1ZENtO6SPJi2//xC87xCVlK+E0y6RtMT/RBYJKm3KISAZUBcYGBuLb5YiYw5l4lR4FSe+P/DbaY2H+rmqRbM1dSFf9EiQrnOIXztna6FyJ8xC7uuj94xSahGO4XwWxD2cS2fkTMcOWnznE2wjn33T6uGRpcS8EhOjL04ZUl+IO8z2tSwDL2QZTheFr9x+72WwSt7p2JNeEOvT2aVY8I4Tkm5epIbHoSbWB/GZUc5nAFWoHjD4AjEHPM+UKrvD0bhS0uyA2Lqh02Yy6TOUHl0uvfNEg69Aol417xhreyVAcmPj+2kOabNcHHF7ODCD83JTSDj8IQ5KKMG+vbIFtmjaVpF1Mfq6Iz1STiAEjQhTVObq4145fRIEz8fpogHhFRq6uEH3gu3eQhKtBuUNFC5KrIEbMOiEnfREGz3XOCjTqiZathKvX4X51q2KcWzIsIYbLhktsnKt23qNI8xX9flZxWkGeBW2I4GQDLVa5CjmJdNQcEtZcizBC76p/ML0o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(11063799006)(10067099003)(56012099006)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTVHOWNVeUFGQ3FhZnZObHJyYlptRVVaMGdoa1d2bXU1eGF5dzlmSDVoZTVm?=
 =?utf-8?B?Tnd5Mk9OSXNNSjlydTQyVmpSUGtYK2VvWkgyajQrVjMydnQrL0dlS2JIWEgy?=
 =?utf-8?B?ODlkOFpKeEoyZmlsUXN1a05GZ1FlRFlkSUUyRVVJaUwyMG55SHFWVTVCTHFP?=
 =?utf-8?B?dThkM3NCOXVzOXlHRkIvUTlBaC92OTVuc25YNCtQZmludGFQZFk0azFYcmE0?=
 =?utf-8?B?UlRjNHJ0cXVZYThFSkpsWGJNMm1vZU9OaU0yeUY0YVdVTER2YVBsVUY3a0pw?=
 =?utf-8?B?b29SKzBEOVVzVEEvRjFhcmE3R1kydzIydi96MVJJYyt0Tm12eTRqYUVWK2g2?=
 =?utf-8?B?MlVXNnBZOW45RzNucTVjT3hPQ1pVZzVzUjNOZWpYYkoxK050Y21nZ0oySHJU?=
 =?utf-8?B?RjdzaGlZK0ZubUhhRU9DRjdZTDBabVBKQTV2KzhqOVhueEZNWlZocTdpMTFK?=
 =?utf-8?B?M2R4UC9LT29NUnZkcHpqUmFmczhmOTZ0YTR5Wkl1RE9nZDhpRzdMdWdJTUhI?=
 =?utf-8?B?aDQzVmt4OU1KQU15cDZTTEdCSU91alJBbTBQOG5UV091Y0VDWnFZSFFwUEtF?=
 =?utf-8?B?Z1Q0U2NjdCtKWHRpVFhrbDkvbmFDT0lwYmMwbGZ1THlwNXU3VFluSEd1ZDJk?=
 =?utf-8?B?VG8yQUhQOEFLNzVSQjFDK2NjaUs1SGRaWU8rN1AxazY5MnROdTc4MkJiMjlm?=
 =?utf-8?B?MHFXNzd4SDNVdEtqTmJ4V1YwbTVRcXI5OE01SXlDQ211dUw0dkF4QktlOGFP?=
 =?utf-8?B?ME92U1B3aDg0Y2N3ODZFVTZSU1BqOTlTZmgrUW04cnpBN2lDVllHNEwwa0lz?=
 =?utf-8?B?NE1YS0VQeS9sVG43SEFTRkJTYW5qckRWYjlYaE1xaDlST1lQamg5NW5VWS9S?=
 =?utf-8?B?d1d0YVd0MFlTZlNON2ZXdGcxcVpNSWlyVENkQmFJKzlJTmQyN3VqQm15UFJZ?=
 =?utf-8?B?Y2hjdFZqTFIyVERHS09hWk5vQVlLeUJtSm4vMWFaY29HTTh5UWxBMmo2U2VT?=
 =?utf-8?B?MzRocG5mTFNCUXM3dTJIRmNWOW1Tajd0SW9lRjVmaGRYQjJiMGJSZ2s5Yk5V?=
 =?utf-8?B?OEFFVFczSnVqZjNGUXZZcGQxdnhmZlpSV0lFNUxSclppSUU5eWRTeHI5QVBu?=
 =?utf-8?B?dmdOOWxsTnNVSm1rRjBOb1pQVEFseTFGSjYyc25ITlQ4WjBTNDlqTDBnZ3BV?=
 =?utf-8?B?RllQMUpobGh3ZXpoWmhiUnVUYk1DeEJpa3ZEZFNKS2pOT3lLMEJGZEczdlMz?=
 =?utf-8?B?bVRXRnc5MElLMkc4aExxSkdMM2tVMzlQZFhERHllMjRGdlFRQ1Z1WG9tTVpj?=
 =?utf-8?B?WWNQeEE4M1g5bjZ4d00wZjRRN2pvTGVWZ1NXSTN5ZEU1TkNrUzVzb05sbUNY?=
 =?utf-8?B?YkRsYmlONXhtL0NuVWFGS1lVQ3E4dWM5L1Ivb3hkYmd2aFNxcnRmMitXWVh1?=
 =?utf-8?B?UFFDUDgxU3NxOUFqZnJkSG05UGNST2dRbXdReHB1MGxVV2RpMmNEa0s4YkJp?=
 =?utf-8?B?RFlmY3liZkIwendGWjM3YnNoWXdGNzdvN1p2d0YrUjBzQ0Y4dEJDUUVTbGRo?=
 =?utf-8?B?NGhubFl3emhXVjcwQW9QYTlWSDdHNExITDJjVlIxL0Z6LzU1UnN6Y3J6cjZY?=
 =?utf-8?B?a0hpK3pSS0NEdko4ZmNLUCs5anF5VERna0JuWFBMZGFzbUY4aUl1YUkwTG00?=
 =?utf-8?B?R3pIelFNcTlIajZYMjh2eVMrY2tvcWVtejRnZ2RBeEo5ME9wR3lDZGd3Mlhi?=
 =?utf-8?B?dUJ3Y0k4OE14c1F5ZHY0RHdWdnc4OVo2Rlk2L2Vycldsa0VJTytPelgwTmJt?=
 =?utf-8?B?NjhJNW5VS21lbkkxUXRIcmYzMWw3dFZDYnhpTEpoMVY5dmdvOFNzQ0pXQVR4?=
 =?utf-8?B?YW4rUGNOWW42Y0RkWVIzZG1zRTdVS3pxMTJuZ3RySFRScWFjSm1UQitrK0k1?=
 =?utf-8?B?VnJFMFo0dlBTUnFVVEN1WU80WWM4Q2dhWVF4MTZiWkdXQnl4RWh2VmdIdys4?=
 =?utf-8?B?eFFpNUU3cVl1cDNPdTlndzE3b3daSllaOGpYK1NjMENSenFBdDBOcXRCM1F3?=
 =?utf-8?B?b2pvOVZrWW5qOVJsckZsRTRBVmorSTE5dC95TkhiWEVUNzYwdDJYV3Y2eXJo?=
 =?utf-8?B?UlhXZjJSVmhqekFPQWgwK1hUdW5uVUxhVE1GVTFoRVpwWnBnVzhYemVzVXBY?=
 =?utf-8?B?RTFaemgrMnEvUndRNDA3ank5c2pyOG5hZWV0M1NaWloxZEEzZ1NlcnRYTW44?=
 =?utf-8?B?RUJyRGRvS3gxeE01OEd4NTUvQ3dXZGhSWHRqU2FxNW5hdzFaaHZId3FlQmVX?=
 =?utf-8?Q?kvULhm1o/qKuG3taLO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da91095d-0391-4aea-9e8d-08df4304b471
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 10:39:19.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQZk9uGmkypvywY6uGpGhXJ46eRVUwzIOJb5899x5BGlif72coSviE8reR17J1FOzcuLEgWWpyxino9dqNtKZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200

On 11/11/2026 19:05, Dimitri Daskalakis wrote:
> Changes in v4:
> - Nimrod and sashiko pointed out that not reporting DISABLED for
>   tcp-data-split makes the feature look unsupported. This conflicted
>   with my attempt to block users from setting DISABLED, locally sashiko
>   found several scenarios where ring changes would get blocked.

Can you please share those scenarios?

I think blocking 'disabled' was the right direction. Allowing it doesn't
give users anything new, only a way to pin HW-GRO off, at the cost of
another dependency between the two knobs in mlx5e_fix_features().

We can still report 'disabled' when HW-GRO is supported but off.

