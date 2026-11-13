Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582164;
	b=dXhdh8oRUuoA9UUbMOnD4oBYUVQm3ojbQHEzVHIET67cV2tr00sw53otAWzYnpDilC7B
	 Ig8uuOt7XNNjKgw693YEnIqMJOSXyzAJBv1+3u0PfG6M1CiOZ0ygBxStnongBs6os53pU
	 bvoTwV1hBnXd7dKQ7z6EmTAYW6Ga5hZ4F6C2ydTa2Qb0hmuZ9VNfgRypzJ51G64tF9C/4
	 dADZEENDb7noDbXGBGuWXeXSUTokQq6eQTlGjHneTzu6fjt4I6IaIygF0vPUoyddjyjno
	 yq6FEEPLWmekGQEpMZHFlOfipzvl7SBWFECP+pAQTw3jztgectguTddYGXiYSVignRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582164;
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
	bh=Xv+/3nothVTUPc0Xa+A4bmcYXJB3zgXX4tR+xqqvfHY=;
	b=r/61FqA0+x041IRPW53AEiCt/p/sLS9rLuPbdfyNY+Yq+g+gFHsv2UYNN05OWY8Rg76q
	 SYyNAgyfVnU6sSmXDoW5fSrIEc5PVxZaZ/hhV3SlEaf8PZzI7lvpyYdKwSv2l52dlwQ7D
	 MK6hOR2u9pkSprSgTsAeXhx6DJLEU49VF/A+noWAWO1FxGyh6kHBOj8+CL0k3J2zoSCr8
	 03ukwDEwu/WQfpnf4l2e7MvGhIAFVxaxWDsCzYMf+yOo7daJO42LW1wZD6QYdLr9eg5XP
	 7wFexQR/K0K5Uat2ffyk/UGOOaNrPXwfVjWuYWsPTRmmsTRnwlbp28VObmZmZP/yi7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cXLQKeIx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.19
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940E5606A323;
	Fri, 13 Nov 2026 15:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 940E5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cXLQKeIx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m+victs6rPwzDTCxPmUbgEk3sJcgCl3va2mcOCemuQbINc6LeN7HN1e4psvRTJor/W95XZMoUI/MVoyWpOb02WMT+KnRg9avQpDlcE9JuJVylqwTq/LzGY3wzkOWbCuc7Ymqjy+7Ilhk/NdXbNV/2sQH3C4ulFnyGxfyp4W7AozuCIh9QU+2Gn1ppOQJOZVx9iEbw5H1Pycz5c9aMQRdbtvhE9ZqE2VZcrxUrzc5p8qcQZLMFdJhyOXXox+pajSqk7kSaU1iY3YE5Itz9L5zkqZPzhXzurXl+JBCcDmlpeAfSJglhlPabe1ZQVy31GyM0cc63YFCkRXVZa4O3DvlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xv+/3nothVTUPc0Xa+A4bmcYXJB3zgXX4tR+xqqvfHY=;
 b=gf/hmrUP5CzX8mj6hoRyloqMgsesl9OWls/jV5Rfyq8c8ra0pXgqrbqs6RIq4M6P8mqtq8NWNmhiakd6nzb8yjfa6fuEnBTa/XhIV7tF56iwjv7J+T/ZT181xxLFgmzvBj6hTXnei54QhWxgiHvkkrsaczFgkLt9Dg4sAxwfkqGMzFx8uqNaOe0t/4Q4o1Qo332yj/7xPEEoyOtlBJ+/oGV/NJGNwdUnTXzifdSLIomNEXYnfBl/AsXG2ujMFzWVZQBIdhU9fEkVT8hA01OlGgyztZTutmkyJGPWyz0+jKnxKan4TBt00JVEl3IhEY4sIsd09NfkN0WY8pTc0ni6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv+/3nothVTUPc0Xa+A4bmcYXJB3zgXX4tR+xqqvfHY=;
 b=cXLQKeIxP9ulDTdlcRygK0/vg20uxobYtJrEdAdQuXbSLEMaaL34eOzZND6vk4gJgAtOagP2EIKUlVeNGV3XFBvcceSxEBQ2We0AI3QpIUGQKO9msYoUsfStC2sFnrW1t2CPG3jEqKqGYzbaor6z3GoZkQolYfqlXEtpLdc4qyCL8dUgZPa8OowUL/2GbK+nKVX6LLYRJEBfuzLSEcl8mxxnZZdCHkSALbv6VhAA6kWwlpxyhCH+zDFH8hs370YyTT3zyyWq9momEibGyGxsT1EYl5coRPvw+Us7B3ExjNSXJuOkUNLt2qtq8lnssFsMVPWm95lbG6Qh6lIpthbpxA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by PH0PR12MB8776.namprd12.prod.outlook.com
 (2603:10b6:510:26f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 15:02:23 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 15:02:23 +0000
Message-ID: <d4e4ff99-cead-4f03-b726-9454a1f28618@nvidia.com>
Date: Fri, 13 Nov 2026 17:02:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, erfansh@meta.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kaifengw@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me, sdf.kernel@gmail.com,
 witu@nvidia.com
References: <20261110183826.2927274-11-tariqt@nvidia.com>
 <179447641258.2199510.921186677435570994@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447641258.2199510.921186677435570994@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: OS6P279CA0122.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:3b::14) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|PH0PR12MB8776:EE_
X-MS-Office365-Filtering-Correlation-Id: 8600e902-9a26-44bb-8c5c-08df41971f23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|10067099003|4143699003|11063799006|56012099006|261026140227099003|261028144727099003|261026121527099003|261021121427099003|261022105027099003|261021135927099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4LndIuXhsRGdmIPV3vU3bGeO/eJpZblbguOktNnLPz4i/3v4BcBC5JvJaBI0r6LPRub6nXc4rIFAI/T+BRE0A6Fo4tTjYQ8igx3p45wn5W1L5EGBvWuv0dWQ5kil9bV+8iPMfUovQ9d+OawoKe33wp6hTwGxbgIccQGGspN3YoJkVkKut8PJqZPHRSb1rVeLDYZi3cfsw2TJIhd6TtyfAKL0IvnMXruxuo1dbxWA77X15XObzSd4IoJQ6xDGDEoxL+W1xUFKh53HnZSJCeVMS7iMDR6xZlj71Q1JtLSVEAaO9ccw65hrj57KIFV9t7LfIhiWCQ8u0Pwlm7EfI9kEI80h4ypamNwEbeZXImxtaIFQO4NfqqlUMPc+Yj1+gXp8vaR8YSm1wv/YCPA1LHcOBprE9VYOAPcJc6YV7zFk8AM5HcacJBsizAuNaKh7mwKtaEPnRQIx8pX08B2x1SMX6juKtERMpU74xWgGY74GhtnzNYxyr7juDyao/5CTJBbNEv9u8Q/oHHLPIROTO3MNmhmkA2I3uNjbTy21w81Gz3iTYyZbmoWMaeGKBdJ9K2mqe7iXrFL/zSaibUcqOP28XOpvtxBdKI9MSOnZ5Vd2KnV/cgsYQz5vNDjC79hJugXQKB2OXMEDwzzM+x8Ocw/gGnFpYogqg1wy2FlMo92Ck0U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261026121527099003)(261021121427099003)(261022105027099003)(261021135927099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NElRVzJzWFBQdkxpN1BpMDBBS1Nhd2FsYkQzVFBTeWR1QWJrTVFSUWpNazRq?=
 =?utf-8?B?TUYySVEwMWZpcVVSUTlmTlNlOU5TT1JzbVpSTlI2SFU0U0N2WEhMMVlkUk1I?=
 =?utf-8?B?OU50RFFHZ0lBU1lqd0JtRU56SzR6Z1JGdjQvWThISE5BUHhsV1hFd0pSR1Iw?=
 =?utf-8?B?M0xZWERTa2dCcGM2NCtkK3F4T3lrU1FQc2FZWXpGdGM2WWVWc0IwMEJCZUFU?=
 =?utf-8?B?eUhtVEEyd0lUM3dyS3ZTMi9HbE5FWFFDVWpzSlVlR3hIcGF1NEZCR1VGQ3NH?=
 =?utf-8?B?eWxTL0RwSFZXRkZFT2xGalF3VnB4ZHM4d21NRWxMRjl1SlFUNTBKdTVkcG5i?=
 =?utf-8?B?K3FqWHMzaGdCdld6T1IyL29UZHZiVUsvTTNRcmlQRE5jNUJrTUhBTFlJNnpj?=
 =?utf-8?B?WU5pNk5xb2cwaHR2MEdTRXVHOURiZEtYa2hDcmp3RkprdzBzMWJYMWNzQmZS?=
 =?utf-8?B?bVRsSWxjeTBBVnpaaXlYTXJaWmg5YnptNVcvcUFjeTZZN1FuY2NvUFBVQnhu?=
 =?utf-8?B?QWgvUkVVNHRvdjl2cWE2QldjOWxTZjRpdDFJaVMvOG04QVhjeHNJdGMzM1Mz?=
 =?utf-8?B?Y2t6MW9MM3lBbHJnRTN3ejhuMFFPSDJYU1Q0WXVBYkFkUVprQjFxTFNGWmk2?=
 =?utf-8?B?LzNYVTBTeXBFMzg2a0lucTkvQUlicjlwQy9lSk5HYi8rRkRMb3VWa0ZRbHFl?=
 =?utf-8?B?TFk2OVVid05qNFBTNXlaeXRyWVVMMHJ1QUtWdXN3WHJGNUFvaGRTenBNM1VT?=
 =?utf-8?B?bDZTVUZmOWVsd2poRUdLcjNhYitmS1VwY1RaczMyQmV4QlorNnFxVGJNaGds?=
 =?utf-8?B?UWtMbWVQM1VXS1lPRjUwZzFuc2xYZjdEakFyQkpWejFmWnY2ZzlDNDRFUys4?=
 =?utf-8?B?K3V3TncxN0d4SFRTZXpITEw5cExPWGxQQy9sSTRpemNnUGprKy96czZPZU51?=
 =?utf-8?B?ci9udmg0RHFnUVpvc255UVRjbnc5TERHdFN1eDFad1NJWWdUNWRVeG55bHdn?=
 =?utf-8?B?bUJLNmp4b2g2VTdLdTRtQlN1SVozRWw5cDc1K2l1Y0U1SEh0VHZ1Vk9qYlZR?=
 =?utf-8?B?cUVrMUlwRmVtR0Vmb3pqdmdqR0dEQjg3cDhHMVFGdjVOZ2wveS9NSjBodGFZ?=
 =?utf-8?B?aG9rbDVEdUF0cVVocHJIeDdqbWdITU14Y2Z0eWhIRWZKLzQwK2FBVWc3M1h1?=
 =?utf-8?B?ZENMN2diUDlJTERGM25RWk9UbGpHOFZYQ2pjRWp2N2ZROTVDSm1aOEJaZFFp?=
 =?utf-8?B?TVN1ODFscjNoK1FaeVEyM1llQVo4TjFLWG8wVlVSYklvNWQ3bmNtMGY1N3Z4?=
 =?utf-8?B?eURpZkZ5elRCS0lZRlNiRGd5bVU1SW1RV1lQZjNNNmlJRzcvazViZzRyTDdY?=
 =?utf-8?B?b0ZxVFY3eGcvZmZhK1J1Mkx2OVVsNkc1bWtQRDhXRFczdGllemw4TmlybGlL?=
 =?utf-8?B?UnB4Wm5FT1NGbGFYSXlFdlVkUGdrbElHY0xQOWxzMGtxc2VidHFXK2Y5NEd6?=
 =?utf-8?B?QWYrL01nSjUxVmphSkdCLzgrRDg5emM5TTh1R29rSHBBK1ZzRTlXU0xzY21m?=
 =?utf-8?B?b2J4dWtrcUVEd0x4UDJJK1VHdFdBdVJobW0vSkJhMzBjb0tMa0trZ2FuZUM4?=
 =?utf-8?B?ZllORHZwWERDck5BZVFsSmFydTE1eU82RzM5TG40UWtvakZvVlZydnZnSXM1?=
 =?utf-8?B?Q1RTRnkyNmtLcy9QSkk1T1FTSnppeGRJbHE1Tk1xOExWNTBjNVVmaXc4TjZs?=
 =?utf-8?B?UlkxUjNjQzNHNlpnbHEydzFoODZKbit0dkY0Sk40UU8wYWVocVhaeHhabWw0?=
 =?utf-8?B?MlZ1TzZlOVM0Z1U5VXZqbk1GQ3pEUHc2aG9xL0VkbTBlajBBWmtxRTkvMmE5?=
 =?utf-8?B?Z1NhbmxCaGI0WUNuMTZXdjIwV0JTQjBIdm5kYlhKeXIvU25HQ2VVM2V0ZnFQ?=
 =?utf-8?B?bWZvaGdvL1h5TlpZZzNZTFdWakljSDJPSkRNM0RDTVdKNVlHK3MvM3FYNVdG?=
 =?utf-8?B?d2E5NThUaXZwMk1WV3hlYm5WZnFKUzI1YnhNcEEydlMreXM3TzBrcFZlZGpC?=
 =?utf-8?B?ZjRGNnBmR0VpR2tpNnlBMUgzMUJGVS9teUxmWng5WlRhVlRHdHU4REZxQkNl?=
 =?utf-8?B?UEoxMEpwNENlU3BhTjl6alMwR2gweVBESFFaT1UwQnVvdmF6SHRHYzdJQXND?=
 =?utf-8?B?bnhYckwzVFQyWDl2d3BmT29OVG9qbnV6aWF5Z0sxQ3dWWXpIQ3cvOWEvV3k4?=
 =?utf-8?B?QU9wOGlDTytIK3lUaFNaRzlZQnB5bU9ZaVhMMldVV0tOdWU5Uk9BNDR3NXNF?=
 =?utf-8?B?SGtQSkZSbVhBVlY5UUJLeUxTZFBCcHBNaDlWY21KT281aXJEbTIrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8600e902-9a26-44bb-8c5c-08df41971f23
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:02:23.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEr2HWtTFdh+fLS6gSrEK4f/pCivHPH+Xn0yvyLg7LSVS39bg/fv2esGEIldpMr8quooYAxpKdssD/IQCTY1fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8776

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The kernel-doc and commit message promise more than
>   netdev_has_dmabuf_binding() actually checks.
> 
> --
> 
> net: devmem: add netdev_has_dmabuf_binding() helper
> 
> This adds an exported helper, netdev_has_dmabuf_binding(). It walks the
> global devmem bindings xarray and reports whether a binding of a given
> netdev is still mapped, with an optional filter on the DMA device. The
> goal is to let drivers (data direct support in mlx5e) avoid swapping
> the DMA device while in-flight skbs may still use dmabuf mappings.
> 
>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>> index fb693bc1702a4..35bb6fa0f7194 100644
>> --- a/include/net/netmem.h
>> +++ b/include/net/netmem.h
> 
> [ ... ]
> 
>> +/**
>> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
>> + * given @dev and @dma_dev
>> + *
>> + * @dev: netdev to check bindings
>> + * @dma_dev: dma device to check, when NULL it will not be checked
>> + *
>> + * A binding is reported for as long as it is mapped, which can be long
>> + * after the user unbound it: net_iovs of a TX binding can still be queued
>> + * in flight, with DMA mappings that are only valid for the device the dmabuf
>> + * was attached to.
>> + *
>> + * Return: true if a binding is found under @dev and possibly @dma_dev
>> + */
>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);
> 
> [ ... ]
> 
>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>> index 5c7d9640e9d14..dd3987bbd9f6c 100644
>> --- a/net/core/devmem.c
>> +++ b/net/core/devmem.c
> 
> [ ... ]
> 
>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
>> +{
>> +	struct net_devmem_dmabuf_binding *binding;
>> +	unsigned long xa_idx;
>> +	bool found = false;
>> +
>> +	netdev_assert_locked(dev);
>> +
>> +	/* A binding stays in the xarray until it is freed. binding->dev is
>> +	 * only cleared under the instance lock of that netdev, and the free
>> +	 * takes it before erasing the binding, so a binding found under @dev
>> +	 * stays alive while the xarray lock is dropped.
>> +	 */
>> +	xa_lock(&net_devmem_dmabuf_bindings);
>> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
>> +		if (READ_ONCE(binding->dev) != dev)
>> +			continue;
> 
> [Severity: Medium]
> Does this check match what the kernel-doc promises, "A binding is
> reported for as long as it is mapped"? The commit message also says the
> helper will "report every binding of the netdev that is still mapped".
> 
> For leased RX queues, binding->dev may not be the device that holds the
> mapping. netdev_nl_bind_rx_doit() passes the netdev the user named,
> which can be a virtual leasee such as netkit:
> 
> net/core/netdev-genl.c:netdev_nl_bind_rx_doit() {
>     ...
>     binding = net_devmem_bind_dmabuf(netdev, NULL, dma_dev, DMA_FROM_DEVICE,
>     ...
> }
> 
> The dma_dev, though, comes from the physical queue the RX queue is
> leased from:
> 
> net/core/netdev_queues.c:netdev_queue_get_dma_dev() {
>     ...
> 	hw_rxq = __netif_get_rx_queue(dev, idx)->lease;
> 
> 	netdev_lock(hw_rxq->dev);
> 	idx = get_netdev_rx_queue_index(hw_rxq);
> 	dma_dev = __netdev_queue_get_dma_dev(hw_rxq->dev, idx);
>     ...
> }
> 
> So binding->dev is the leasee, while binding->attachment->dev is the
> DMA device of the physical NIC. That also seems to disagree with the
> comment on struct net_devmem_dmabuf_binding::dev ("Physical NIC that
> does the actual DMA for this binding"), which this helper relies on.
> 
> On top of that, both teardown paths skip the unmap in the lease case
> but still clear binding->dev:
> 
> net/core/devmem.c:mp_dmabuf_devmem_uninstall() {
>     ...
> 			if (!rxq->lease)
> 				net_devmem_dmabuf_binding_unmap(binding);
> 			ASSERT_EXCLUSIVE_WRITER(binding->dev);
> 			WRITE_ONCE(binding->dev, NULL);
>     ...
> }
> 
> net/core/devmem.c:net_devmem_dev_unregister() {
>     ...
> 		if (!netif_is_queue_leasee(dev))
> 			net_devmem_dmabuf_binding_unmap(binding);
> 		xa_lock(&net_devmem_dmabuf_bindings);
> 		WRITE_ONCE(binding->dev, NULL);
>     ...
> }
> 
> After this, the binding stays in the xarray with attachment != NULL
> until in-flight net_iovs release it. The check above can no longer
> match it for any dev.
> 
> Could netdev_has_dmabuf_binding(phys_dev, phys_dma_dev) then return
> false while a binding is still mapped against phys_dma_dev?
> 
> The only caller in this series, set_pflag_data_direct() in mlx5e,
> already rejects installed RX memory providers and leased RX queues, so
> it may not hit this today. Since the helper is exported, would it make
> sense to either restrict the kernel-doc and commit message to TX
> bindings (or bindings whose dev is still set), or to also match
> bindings by attachment->dev against the DMA device(s) of @dev?

Ack. I will change the commit message and kernel-doc to mention leased
queues.

Thanks,
Dragos
