Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664468;
	b=fNejAQGs/oBfDWdJY07+LXkJLhQAh/lDqJayt6FHC4ukgWnwGHhUAwmHf6kgWYACIIn0
	 81TSp1wLw6R34rQOSzMj5qz672nIrWIkJeKtzL4TEvboQmccFZn4Hh/bBhAp+nJGVcY2Q
	 hsTQnZjb9rTgBaX/DEUhc9Z1f/dpAG9jI01apYmIOYHeiLWyTcuB14w4yJQfkygSid3UA
	 HdUtb+3fZ7bEg4uzx5xQ8fQYf1MnxHjPcxSv/U8ry6uIXumA9EVD8yNyZ/v8RN8K4Ca9d
	 8WJjymFjEwLl4R4ws/HN5DCS2puepgcpwLYD1bH9O2oYggv46A4RclRZuC2+Rrawx2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664468;
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
	bh=5YJBR9rr8Vn3DtkftOjfJBtOBKcMvHYCet/o/Tq2HL4=;
	b=c4TVz5N4vCu8FMyXNlucr0tRVU8C6ILZxKU/+oy7hqE++x282JMzi/+KHxHfZLLnjn0O
	 v9H/4x33lz8vb1Z8zewdMIUSkGbrruRL0A8S71HQLexChu4v6FlI0XatakE1L8iIduceL
	 DgF6DIRZ3kubAscP4H+nnpA/DgchwHWohzYa74PsUMvGTwsiEX9I8oithYffcyte3O2jC
	 18c4CXbhL0VFddxYGuDjWk40i1pz60Ytt8EGJXowRTGuLzuH06SSG997c666KKjlh9moJ
	 YFe3lB+/xidJgSDimKzuU4AMdRHu9FWHeHAgaowihjwH0Nqvca1hY86c5zwilYmyQug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=omfHgkJc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.57
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012057.outbound.protection.outlook.com [52.101.53.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D89606A321;
	Thu, 26 Nov 2026 03:41:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1D89606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=omfHgkJc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdul0I/sremo08STaKjF46KQJ5nlxJzZmq/6RPPxUYUPsF11ih6gLnepxBIc8W8S0PQIP5KnE3rnkt6xMRgfOHldE7VXmrlTG+wncqXcazWKdp1eLNUVzhA76Cq6swC5h8tHjZE/44k51IA+C1EGEKLbFFyJuHCX7yIU7yKRTSmXCyddEttXxJjzA89K5t2ZZsp7tM8I8+kahN36JUk2Pc0CqixrMyhAfEANrajKH0fqZx8PAKnB/0PKrpALvOtGFjbwQZVJ4WkmxwV1RvCgMKwUOetjJh8GEZ+woU8zl9XnZVUaEP6sKA0iXu1YuyzeRhWkD/3zSO/4Jw8RQ70DKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YJBR9rr8Vn3DtkftOjfJBtOBKcMvHYCet/o/Tq2HL4=;
 b=czPeFKk8xnxMBgupMmxY3rnXP6cwDCBbZ5PV5xVBkpcODYZymT77Y8veg4DNDnvTvSMLX7RrIp0Ba8oYAJWesSJATf9BHkL/ve+eEYcWPV69z/CtJzxFMbUnllzPUVcAuxcLfBLpc6kFdapB8ux/VTJKDigPZ+SnS4KPYqvEsU6CdrDkGI8lLO74zSxHiuolFVXqVpVzonPMxXdxwoeWjULa0xpb+iZxYRo/WfQqJt63KFjpi9Ln4ZPRM808I3SDpmtVtNTj4OSNkdMS/ul9mri/NntAuUk3Y6T3EUZB6CkxZaDQK5xI5OBYkr7lIp4e2aVJoup7IiUYRTqoci6Cmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YJBR9rr8Vn3DtkftOjfJBtOBKcMvHYCet/o/Tq2HL4=;
 b=omfHgkJccn+I4Wub56hw4pHzk+nhqmnbzFXSaOYVGty4HiaIH5Cu6cGsMKBSPtoIHxjELRvpQPQ6fqK+c0r7Kfvbp6bHeoMUJ+1HQ60xx7hTNlf58aKDj6Raw10/IoH7XbaqDY6s0euF9gUTSDwziTJ5FiCQeYvdpU+Zrpau5/5pcl0PYO59BQLi7eg6DMSt6j020SrxJ1v+wOMFXC5gxDuyp5luyu+E+s+uT5fXVLhtELgjDSTfFZV2ryawXf2Qx+VedhdfXllfWtVtEFn+UDRkuytIaUqDdAUPW+4F5Ttd+JhuMO0wY7bs+UV91H4yOcvh3j2HjZKvBlLMBPnMng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:41:04 +0000
Received: from DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d]) by DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:41:04 +0000
Message-ID: <a895192d-9b58-4fa0-883a-43054c9349c1@nvidia.com>
Date: Thu, 26 Nov 2026 05:40:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 4/5] net/mlx4: track whether a TX doorbell is
 pending
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261125180021.1804204-1-joe@dama.to>
 <20261125180021.1804204-5-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261125180021.1804204-5-joe@dama.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::18) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 33ae2267-6224-425e-1a9b-08df4b6f1881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|5023799004|11063799006|56012099006|4143699003|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0Z+wCzgZ+f59WaWNlsxAQUO6FRSwf7y3P3GDcAttoP+1c5eGgD1Hm0wibXVBRaQibJYCoaLFM2k0Xc76L3PQ5477oX6WirnQRf8RMtY9AH3l9Lk60UjWKIl9dM1AAgaOZmPfVs0/GXXzmN0gOig/opQbZEVKxdpQUkFPK8DlGpVXlulviaKWzoe9m3gRal5Kx0u3xRRTAzYCPNVFAKrKXhYn/b1Ld2BoupvG8LItACFqKxiql1bYLB/RWDcf+RFSJcC1gdvULJduDX/mdptzULxwFcCzVMuUklrh+UKMCmmY80ncK9qPFLlALj4a6Ifb4Uc7jYGgz2HFsAV+QQlI6GaKWPJ63QxiycC7rtMxEXMBQNNC1pRIT7M9mb2s0riZhjDIlVxDiaPesl0NiuUHXLb+WvmVLYdDwtmZ2kcl0qwkQ0gbz4OzLI0DoO5eSU1PnN1NQJbnsim4I5gnM10hQ2NNFPxZ1nQ1wkEdGYBneqOcsN50G4Tkm/gzSisbjJnB16aedyPyh+xw8YG/90QTCd5PtXaYJvmk42Si/kK6Sw5tMRoIlW7/txd2EtxfH03TJNteM3k53xZ0+wbIpvKekufhQ8eNORfVK6DG1v8CSOK2lSOl6tRPoiv2glb8ZnShHxkD5u9Fduc1HE+G3V5QsDQ48agFob6jJQIUBF7sV4A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4354.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(5023799004)(11063799006)(56012099006)(4143699003)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWl6d3ZIWXRVVWMvUk1VMlNnblJvdmlsMUhGNzdON0tHWXBlQ1pXd1dkcTZ0?=
 =?utf-8?B?WlNXN2xsdzhXY2o1ZmJoT1dDeCtGa0R3RW90MEh0RnY4S1c3aWQxRE12VTZU?=
 =?utf-8?B?djY3MUZ3dTlHVDkzSWp6M3FUYVRCVHNpcTZTc3dVdFJxZU8vYVpiL1JNNndj?=
 =?utf-8?B?OUFlbll6MmU0MVhab2RRc285ZHRHRE9tTzNHY01mQmI5c2pSbW5wK1JzcEN3?=
 =?utf-8?B?a0wwblVINnNrZ1FrSXNoOU5qS3hvWENIOTd4S1g4YThZb3d6eGgxODlFbElz?=
 =?utf-8?B?MDNYa01qbDExL0p1N20xMStRbU9NaFlFYjBxV2ZaM1Ztc3BIUjdCYnBjc1V4?=
 =?utf-8?B?aXY3bTZwRUtOa3RuQlNkNytjSFhWWitxVDRjNVA2dGIyVHpOQVgzeStGQ2Fx?=
 =?utf-8?B?ZG9abWdHNGxXbWpOMVZmUlFFeEplRDNZdWNzY29pSTVYYS84Rk1sd05nbHJp?=
 =?utf-8?B?Tys4Mkg4alAvS05zRmZBOVowd0ZvZUlzU2liWEwxbUNGN1ZjV1Bqb1JzRU1T?=
 =?utf-8?B?bDhYazEyOVBsQzFsYnZkRmxZemhzQVJ2NnZFZTU2UCsrWWdzejAzT0ViVWFQ?=
 =?utf-8?B?VE5qTTF0YlBQTmhjZm00UG9ycEY2SW1MbXhmN0ZBdWczQ2J0YllDRHFLRWZJ?=
 =?utf-8?B?ZlJobW9ZOTU4QmJ4cUpzTktWSDk1NFpaemQ3Vk5NbXg5WXlVeFJNajZpM0dL?=
 =?utf-8?B?Y3grelZ5Q2RKMVYrMm01Z0ZpU2MwcTlqSzlrNkkwSXR0ckFWS0psMFFsWjVo?=
 =?utf-8?B?QklCS3k3Y0Z0RmlzTitySW5FMUhiUmZxQjVNS2ZaSTFta3JMbTlicHN5Yks3?=
 =?utf-8?B?YUlRUk9tQnNxbXNVQThkMjlmaXFQOXFiL0lBTkJuVVd5Ry9MeDl6S3laYXhE?=
 =?utf-8?B?RHBpaUNjMC91YWpaS3JPZXFJVUk1K3R2ekp1WUg3Yng1NmZLTnFSRlBhanhV?=
 =?utf-8?B?RlcxejNjWjZlQjVJVzJuMTBOSnhiQjlQZHBTcytVeVJYdTRGS0pQWW9kMTJa?=
 =?utf-8?B?RVRFZEtldnNXb1FsenFDakh1UkxJNFF5ajNMeXNicmxXUFRZOEpDSVF6c0Nm?=
 =?utf-8?B?NmFraTVHUndQbVdNY05Ia2hDcExSV2t3RkpJcElaUnI1WFRHbmZ6TGdJUi8r?=
 =?utf-8?B?M2NJV3BXTUkwZlVuTVRGSkN6NFYvZVRWOFJxays2R09iZUxlOEJQc0h4Nk04?=
 =?utf-8?B?MTBJUHJ0Smc0SFBHcjNUbXRqazFsaGRUMFBZc28rLzZYaWpYdzF4cDdmTHFt?=
 =?utf-8?B?b2IwbnRRRGJja1BaVzZLVWhnR0RBK3F5MUU1NXJQWGI4M1NOM3pUaGhPNUpy?=
 =?utf-8?B?eDBXMzI0TWpIVjJxUmJBTkc3OWRLMkxGcFNNTzNxa25HZ3NOR0VMWEkxQlJP?=
 =?utf-8?B?Y0M0bStBRjZrV3R3T1pHeWlIMG4xMnRJRFlCelRaR1N2MkJLNjU1d1pIKzdU?=
 =?utf-8?B?U0o3MjVNWmJnYTZwdndDeVZickxuZHNqcjgyQ09mM3huWFFJNnRtY01oRE5M?=
 =?utf-8?B?S2RTYnp6NFZRVlFRcDB2OGU3cUsvQUR4a3hmK0o4SWVJNTAxOHlhVVZab3hx?=
 =?utf-8?B?Z3h6VitBSXVVaFR3MW9pRVdoRDJKMjF0cVh2V1B2TC9FdC9qa0NoOXNhUWFG?=
 =?utf-8?B?SUpodDdic29iK2wyTDVEMVY4ZXRpd0xaTmFXdHlRRTdlN3EzNXBzVkxWNDNn?=
 =?utf-8?B?UnA2NEtnOHNNZzBJaTd4Wk9Va3pVT2E3WEhRUzl0SysrRkZBMGFjdnFFbGxR?=
 =?utf-8?B?YVcrLzR2ZXFMdHpJUFk3bzVqODdZZ3Vod3M0NmZWM2NHNnMzeFNteG9WZWN3?=
 =?utf-8?B?OWgxaU14Y2xqUXVjVzM1WXBTZ1NVQzFJdFJYbENLYW9mdURXVjcvVlVSU05r?=
 =?utf-8?B?T1ZyRDVLNkhSaWdhOE5pN3d3NTlFLzBHNkVxVjRTNVpZeGRDQmpVNGYyWEV6?=
 =?utf-8?B?YVMrTGl5YkNhZEQ0VVAvTFIrQTR5eWVhRWZjTW53M1IzNnB5TkJlT0wzL2JJ?=
 =?utf-8?B?MlVPOWM4UjRJMmJsZ0ZJNGtMcy82MnBiWGVRdmliSi96bW84TXpWcFRwZzdX?=
 =?utf-8?B?YzlkVGpIL3FBaEVUVGU3d2M3clNiWGJtb0h4VkI0a0VacERHMGZuSmZTUGFn?=
 =?utf-8?B?L1VHRlJKNlZxMGN4c2VIeXpFTDJLOTEvWDA0VGZMV1NQa09TZXVSZkZrbWNi?=
 =?utf-8?B?cmdqZkRmanhETW5FU3RuNlZMVFhtZEswMURMZWJNMCs2Um5JcGlBbHpXL1J0?=
 =?utf-8?B?RlcvTGR3dUJSQlk0d2RHY2VtT1FPcjJ4czBaT2NMYkdIbmRYQ3VKSloxcHdH?=
 =?utf-8?B?REVHYU15bGwxSEVvQ25qbXh5QTltTHZ3YUw3NFBIcFlzcGpRQXZHdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ae2267-6224-425e-1a9b-08df4b6f1881
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:41:04.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXkHjj7n8T99EDAGvAmaHrCjuUvsLp29pmqjzOMkHhsYk3i5tCZzuDrqJUgYws3OomstZH4+hevHVrQcIvaC1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126



On 25/11/2026 20:00, Joe Damato wrote:
> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
> relies on a later call in the same batch to write it. Nothing records
> that a doorbell is owed, so a path that ends the batch without writing
> the doorbell leaves the WQEs posted before it unannounced to HW.
> 
> Add ring->doorbell_pending, set in mlx4_en_xmit() when the doorbell is
> deferred, so such a path can flush the deferred doorbell.
> 
> Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
> prod. That line has no room left, so move tx_dropped, which is only
> written when an skb is dropped, to the end of the struct among the
> fields not used in the fast path.
> 
> Suggested-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Joe Damato <joe@dama.to>

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
> v3:
>   - Set doorbell_pending once in mlx4_en_xmit from !send_doorbell so XDP_TX
>     doesn't write it (Mark).
>   - Dropped Daniel's Reviewed-by
> 
> v2:
>   - doorbell_pending moved to the area of the struct marked as cache line
>     used and dirtied in mlx4_en_xmit. In exchange, tx_dropped is moved
>     among fields not written in the fast path. It is only written for
>     drops and is read for stats.
>   - Update the commit message.
> 
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 2 ++
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 40dc4f6a7329..8a43c86f815c 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -193,6 +193,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
>  	ring->prod = 0;
>  	ring->cons = 0xffffffff;
>  	ring->last_nr_txbb = 1;
> +	ring->doorbell_pending = false;
>  	memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
>  	memset(ring->buf, 0, ring->buf_size);
>  	ring->free_tx_desc = mlx4_en_free_tx_desc;
> @@ -1098,6 +1099,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  	send_doorbell = __netdev_tx_sent_queue(ring->tx_queue,
>  					       tx_info->nr_bytes,
>  					       netdev_xmit_more());
> +	ring->doorbell_pending = !send_doorbell;
>  
>  	real_size = (real_size / 16) & 0x3f;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index aab97694f86b..c28d5213cccd 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -274,7 +274,7 @@ struct mlx4_en_tx_ring {
>  
>  	/* cache line used and dirtied in mlx4_en_xmit() */
>  	u32			prod ____cacheline_aligned_in_smp;
> -	unsigned int		tx_dropped;
> +	bool			doorbell_pending;
>  	unsigned long		bytes;
>  	unsigned long		packets;
>  	unsigned long		tx_csum;
> @@ -311,6 +311,7 @@ struct mlx4_en_tx_ring {
>  	enum mlx4_qp_state	sp_qp_state;
>  	u16			sp_stride;
>  	u16			sp_cqn;	/* index of port CQ associated with this ring */
> +	unsigned int		tx_dropped;
>  } ____cacheline_aligned_in_smp;
>  
>  struct mlx4_en_rx_desc {

