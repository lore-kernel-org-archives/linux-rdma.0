Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795522165;
	b=AuLH3rDaBAM/tcZ0L4bhQm22fWkDPsggTBfcTfVRsJQXQuuWsNqG7cNodbLvPijfPwsd
	 k0NZ6D0sbN2ADC6rHEXbkJHRazrQDEnZm5waVK6czZLsXWZBKQ6dsAmXGiWo4aFR0HvzL
	 DP5rNfWmz4IxBEmAic5UNNMQ28SdRY585HzLrmj50K20U8Gt1Ic9Bz729jgnYlgKy09fq
	 QznjJcdbuDsrZQKawphkY5diM1Bt+Qc/2QIfeIpo3rWlO20M1O3kwxbGV7Ux4EtBF8lLS
	 ZcM5FlbpC11bv495mP2O7Zn1Y9+HWuvb0kN021lzxaJmmq6oVA973EHlPuLiRljgT8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522165;
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
	bh=HdgjBig/fuuCHfnCRi9iQaZhpjOs0rQCHbdTLzT9bVg=;
	b=dZwluRYllGn1uFp5Z3XgiRjatAi82bO2DBg0qgp1rRtvmA52H8jbdlStqTzR892cPD9p
	 UzgYaYLzNXPH2xSHjy6hWlj1yd8X2ILsisX47fbqhgexuoohfLB52d4MX5iejlDNpP52y
	 5pXemXQz+yS3OEQwHcAP2Nx/Oe/XtQGIa/r+jiJyUB6hxcrNjtISlN6OPo2rdVmJAIsoh
	 mF4k7gZaVHnbJAjEU5eSVAQfMerbSPPIn9OlyRHjgefVSM7AqmJzuBSnRZDNEOdGtUeid
	 1OzcCtadpO6KKu+O+NSAfdzUa8kHLPnRJCuxRVWf8IlGSthLu6pqrVWpebebuGTWbjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WwpqtmY+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.26
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013026.outbound.protection.outlook.com [40.93.196.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3908A606A31E;
	Tue, 24 Nov 2026 12:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3908A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WwpqtmY+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+ckdG9mIJsIS2WuOXHAJ3oR5jTV7yf9nA0nymTk/S6pfZC412c3v2WmbZ8fcrLSfQlMXpF9etAuUFTQwb7YtfkNoN8lvgHc4lLvOabNbsd5g90AiOHCkkIspWSqOd3TscECvdnoRbKgxNcxtbIp4ctcI4/7QlRwln43J4AznvqBEO+XQ5j/jlMWuEfgFM4w8d8ho2KKsmPpNp9qRc72S6S1GY5WhxssPJpfKSZ30HEevkgbjps8ApY64ZXkRmkR6H62amJxLeERP/mNSilh5m5x65mXK58yaFXSjBdYdkvhSYKTIJ52zKt122xov60MqkoTDAaRWKmwQ5agjEfKAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdgjBig/fuuCHfnCRi9iQaZhpjOs0rQCHbdTLzT9bVg=;
 b=WyRusaNdKP1v1aWPesX5t0MhZ9VIoQU0Q8y1mia+3gkuaeBe33ho0s/5RWnC0IvjuIwQlnq6Qcf2/sZVzjF60YaUmMEkKuE5tWLK6ls9y5Q3RUBt/VdEwm32voLHs/HyMQnrgdbJFcWq+yfWdhGzHU5nNdc30vpiQs+iGLqUNC73uKWyzSbjIH61ngSKKonIQNsOUULRiJfTZ2sD6GJ6kf26ZPMOluXpXKioFR0REcDhB56o+XGS0uNWi1igDrAOEqBR5RQOOhRFNmM3utvGAyJXIPyw4ywe/gbWyaeIKu7eBCioz0LZ5WgNw9YahaQMqmFnYMqbODme8exrA5MUCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdgjBig/fuuCHfnCRi9iQaZhpjOs0rQCHbdTLzT9bVg=;
 b=WwpqtmY+wFRyXH7XoE2sdtsWtytW44y5i4WvW0jG8p+xMZukJwVyGO5q4OAagStHFsXgM29tWOjqoZlDGkgMl60VE5OZ/WFQliviAlScJiu2f2iip5M1CdUpZvQvfqxW+mHta3dMWvywLF8r9qN6SkkEYWU3Hjss6tXpw67LlN6bbolpGlPYBro46XNb3GC23yKutkhjawZrpczc+JGP6u68qpI22yNFc2PWq5qtVVzKcUqCHVOPRd2yLmN9oZDuqvpHcSV5U7zQvdd6cBb3JlGMz3F+KLrd/5lzdwef+zszOLTMmipAcJ1ajaFyU4ckBeH+CJ11dCYy2OIVplyKZA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by DM4PR12MB6133.namprd12.prod.outlook.com (2603:10b6:8:ae::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.14; Tue, 24 Nov 2026 12:09:20 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0662.001; Tue, 24 Nov 2026
 12:09:20 +0000
Message-ID: <ac346bab-3e2b-47e5-9426-a55a60b7dff5@nvidia.com>
Date: Tue, 24 Nov 2026 14:09:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: HWS, fix action STE double free on rule
 update
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Vlad Dogaru <vdogaru@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261123221310.4045513-1-acassen@corp.free.fr>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261123221310.4045513-1-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::10) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
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
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|DM4PR12MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5a9982-cf83-405c-efeb-08df4a23c4ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|11063799006|56012099006|261022105027099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|261026140227099003|261021135927099003|261102123227099003|261026121527099003|261028144727099003|18002099003|22082099003|6133799003|3023799007|15866825006|41080700001;
X-Microsoft-Antispam-Message-Info:
	zZD967hqatddSbMKiOL2kU0+lnVWiZKxfDFtKvHpqrCJYaiCks+Oq/GNlY0eU/zkpzVf63dDwxD4Ae3tFNatTyVeGHCWc5Ho7SVCh1FzrX3Zt5kfbwsBDJ3xwmEfQGN+fS+Y1vuNIzUnWrt6KiKCwH56Wm6z4WWALts0IqeOqyl77Hs1qpBi78XaLBYbMrPytfbdcs0Z7+F/MXxGdq/7XG+24MF+D0LKrsMR6ettVwAbAWnlNkv800f0sT91e7tPH2znR8y8/KEke63gL5vS3mT2Zogjj6Pkde6O7y434q/DhwlRpWhpaAWtMu59PeVHSmUOopP9IdG0E9yZ35qSMEZAGyJWtbrYZH+QiAvU0gTB86u4ZNSefvgbfIRV8zARMLjmHsf1QE6tXrq1t3NrgBZdFD9B1/y4/9JC8y5N+PZJSYIT4nN2j89uGAeS3DVEioLtD4JAh9UAgzxIePfXBcY/0muNKzRuC8FAc6wFsF9HBT1GXEIhTAQHoONFgY5XYHaWBnR78WI4HywXb4WZS0LxhqAfZjtdORAFB9PnbhWg3NvFQ39ar6vVnKN9BOcrIfWo7Zps59ndBfV2jslKWxN2YkZ9Myleo6hpl0OWBheTGKUsLFQhLeu9F53e9CbqCfEnOlKC2i/rsBsSYm02u76R5nuwpJ6suUUfxiVvb9yHjpi/zR4kzNbgDMV8i3IwSjVwY9mKnYFzty0hy3XPmC4iT8P9U3bBRv0mm8it1BwzK+0q7Pr3fKeMs6UnV1GX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(261026140227099003)(261021135927099003)(261102123227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(3023799007)(15866825006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGJYd2FkNEVWNkdrZVBtOW5YZTVCanJlNVdRMUx5S0U5VkdMRDRacWU0SzFt?=
 =?utf-8?B?c29Bdmp5Z215Ukh5TVdTUDkvQWJjbkRUdW0xN3A5d2syRkRtdEY5b1hQLzRj?=
 =?utf-8?B?T0RPcllsdUZaVjNzMm1zRm43ZW10STA1Y0JGa2FSM2Q0dXUza2tkeFJlTmQ5?=
 =?utf-8?B?U0JFRjhiYWw0WFhOZUsxeWJoTWdyUXZSTGtqVWNOR3NMUy9mbzNoTTdDZFQy?=
 =?utf-8?B?QWFrTXBySlBIbTgxd2ZxVkwzelZPV2xBQmI5UUdhMTZaTkNUQjNWeVliaXZL?=
 =?utf-8?B?UlJRdktQckNxMHVtc252S2E3MnovSFR1S2hwZm5mMStWZXFuKytGbkRLRjZr?=
 =?utf-8?B?Y0xZTjRjWk45T0g4dHFZTFkvRlIzNmFiS0ZucnFRSHFEaU5KMUZ6OVp5dlV3?=
 =?utf-8?B?cUNPL3lmUE5zWmF6Vnd4MEdoQTlGNjlDZU5aU2NDMHMyY2JNM0d2eGltU2s3?=
 =?utf-8?B?Rzl0dzNaMkkyTmFaaklGNGE2dnJrcVhJU2pSQ21neVljRHhmb25YdTVyQXFw?=
 =?utf-8?B?TFBuZ1g0N0FNTy9iQmx4eE1zb1NvcFhKbHpVS2RxbzdFakpmd3MwdHpTeG8v?=
 =?utf-8?B?eWJqazZJb2Z2clFubFYxRWs2aU1OdmVDeXRQMXdUa1VXWUhEck5IN3YySVV4?=
 =?utf-8?B?bUtxRmxDUTNFNUxQTGNFaTJ6T1IvL2FvVUNsNDJFYmZ4bno5cVBaazVGODNx?=
 =?utf-8?B?Vmxmc09EdU16dXltS1pMbStWMFovR3ZnL0xPQmFvTG5OTzN3QktuVDZWTi9G?=
 =?utf-8?B?azhPU3AzQk15QXdsWGJMVDVXZmdUMzhWeW9nMHdjNnNCRnNkZ3FaWHljWWpi?=
 =?utf-8?B?UGc3azJlSThzUjhhbW5TM3BabnZGZ05nQ0lsZW53SXliK1BBNkdQTkwrVWV0?=
 =?utf-8?B?Tk5oVlAvYThrWEVWL2c3RU1CZUpEZmwyQ0F2S0V1RTBWOUZFdkZjQkw3RTI0?=
 =?utf-8?B?TTFkZFBPZWpTQ3J6bDRMMGF3cnpvN2RLd3c2VWZpUkRydzZsQnZQWVEwZXZv?=
 =?utf-8?B?ZHBTMm84Uy8yUEphRjhwZTJESjJ4cEZOalNPTnYxaldGSWpjeHVDR0xzUktG?=
 =?utf-8?B?Zk9FK2hha0hybHMvUjlDT3Rub1UrRDZuKzFKVTVBZ3UySGRwZXZkTGoweVJy?=
 =?utf-8?B?Q1pUaUlSbTV0TG0vUTRaL25uOER0a1RtTGlRMDdDRlU1YlRreUxqcFZjZkMw?=
 =?utf-8?B?VTljZjg5dWxwQVd2T3JNRDRXbGJlem54R3pFU1FyMXFNRVpIVXVGQm1GRTZ2?=
 =?utf-8?B?ZnZJU1Y2OGlOZlViOXliMm9RcGUrTitlZS9mRWxEbytsVXora0UwM2FZazJH?=
 =?utf-8?B?WXpkSEZOZ3daUlhEMSs3aXYvWFJtRVFnYVVnUU9pSnZFbDlWM2dTVTFRejZR?=
 =?utf-8?B?WDNReFVtRDZQUCt3bkRjNVQ3Q2IyRHlCaWY1N2h5Z2ZVL05PTlJvYmF6R3h6?=
 =?utf-8?B?T0I3d3FBMXNSczU1QzBDZnAyR2RYKzE1U1daSnorL2JGSWExT043MWR0bE5K?=
 =?utf-8?B?Sm14SXVnamVwdm9qWEp5dUVhQkhIZ3RQODBiYUVXVGpYRFNHeFVLTDlRcjYv?=
 =?utf-8?B?Z1o0WkYvVU1wbzBTTXBJTXloNEtzZEF2QklYblZXNThFY25rcWw5Mlhwck5X?=
 =?utf-8?B?U2lYSWEvazV1UUlsbUZpK2xhZi9CL01SY3p5NVMxanc1ODMwcUhUUG5zWGph?=
 =?utf-8?B?ZW0ycWlSblZQUUUzTVcxcVlCckVzVTF5RlI2czhqUHJYMVFkZE9qSmtQd2hD?=
 =?utf-8?B?Y2NCUXBMcmZFSmJHRVdWRklGc1NZTHZTMk1waWtHVi9aVUFhbG42RmZHSDRQ?=
 =?utf-8?B?VXFybEVCSGJlaG9iT1BLQ2I5SmFWMFU5bmNYbHIxaFdsRnFCTEl3NHZYZEhu?=
 =?utf-8?B?ODdYbFBkRWxGSlRrcFVWdk4yWnkvWHFkS1JnQmEwM0duci9YeFdMM3hlMFdr?=
 =?utf-8?B?clRwWnFENGpjSTFMTXNoa1JWM2czbnVocmdNUjBqS29XWm1TYXNUWHp5c2ps?=
 =?utf-8?B?YUo5eGpsaEpSNmZyRkFTcnl1OTB4MWxyYm1IcnVhcHc3V2tpWEZEa0trSnUv?=
 =?utf-8?B?ZmdtY0JlNHZNRkk3cGY4ZVMxbjRGZ01JRUR0WFdKanJuWlA4eFU1UXNjUWVk?=
 =?utf-8?B?YmRLN3FTbThveXB4bFE2ZjF5ZERLSXlOeVpMVkhWaWJkWndnQXlCS1piMlJB?=
 =?utf-8?B?VG9welBMT1VBaXVaRmxGYXFXcHA4Q1E1M1JyWUVEWTFwNXA5RFlsamNFdWo5?=
 =?utf-8?B?WHU0MTlNWnlsUUtzMmZ3aVRMU25uVks1VjR0aENoTGJpUXo1WVE5ditObzVw?=
 =?utf-8?B?TDh5VWZHTWtrekVaRGdpR1p6NFZDOVdYZjRDdHVBOFJ5aXluSVRBQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5a9982-cf83-405c-efeb-08df4a23c4ea
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 12:09:20.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ln6bPfCcBTpwS0XXIF478/SphAb4res5SUor2arT/16c7GrjS8J/PsWJ4ZCFHdqheBNo4V+aV7XL8pkxhf6tIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6133

On 24-Nov-26 00:13, Alexandre Cassen wrote:
> An HWS rule keeps the chunk of its action STEs in rule->action_ste. An
> update saves it in rule->old_action_ste and frees it once the new match
> STE is written. When the new actions need no action STEs, the rule still
> points to that chunk. Its next update or its deletion free it again.
> 
> Two rules can then end up with the same action STEs. A packet of one can
> get the header rewrite or the meter of the other. The second free can
> also dereference an action STE table that the cleanup work has freed.
> Neither was observed.
> 
> The buddy allocator counts the same segment as free twice. After a few
> updates of several rules, it finds no segment where it counts one:
> 
>    ICM Buddy: failed finding free mem for order 0
>    WARNING: drivers/net/ethernet/mellanox/mlx5/core/steering/hws/buddy.c:93 at mlx5hws_buddy_alloc_mem+0x11a/0x140 [mlx5_core], CPU#34: tc/449154
>    Call Trace:
>     <TASK>
>     hws_pool_buddy_db_get_chunk+0x25/0x50 [mlx5_core]
>     mlx5hws_pool_chunk_alloc+0x30/0x80 [mlx5_core]
>     mlx5hws_action_ste_chunk_alloc+0x85/0x480 [mlx5_core]
>     hws_rule_create_hws+0x860/0x9c0 [mlx5_core]
>     mlx5hws_rule_action_update+0x81/0x140 [mlx5_core]
>     mlx5hws_bwc_rule_action_update+0x10d/0x200 [mlx5_core]
>     mlx5_cmd_hws_update_fte+0xb0/0x140 [mlx5_core]
>     del_hw_fte+0x1b2/0x390 [mlx5_core]
>     mlx5_del_flow_rules+0x10f/0x270 [mlx5_core]
>     __mlx5_eswitch_del_rule+0x5c/0x1b0 [mlx5_core]
>     mlx5_eswitch_del_offloaded_rule+0x10/0x20 [mlx5_core]
>     mlx5e_tc_rule_unoffload+0x4b/0x100 [mlx5_core]
>     mlx5e_tc_unoffload_fdb_rules+0x35/0x80 [mlx5_core]
>     mlx5e_tc_del_fdb_flow+0x2ca/0x310 [mlx5_core]
>     mlx5e_tc_del_flow+0x63/0x610 [mlx5_core]
>     mlx5e_flow_put+0x3a/0x80 [mlx5_core]
>     mlx5e_delete_flower+0x29b/0x460 [mlx5_core]
>     mlx5e_setup_tc_cls_flower+0x7d/0x90 [mlx5_core]
>     mlx5e_setup_tc_block_cb+0x58/0x90 [mlx5_core]
>     tc_setup_cb_destroy+0xcc/0x1b0
>     fl_hw_destroy_filter+0xa1/0xe0 [cls_flower]
>     fl_change+0x1bf1/0x20a9 [cls_flower]
>     tc_new_tfilter+0x432/0xea0
>     rtnetlink_rcv_msg+0x384/0x460
>     netlink_rcv_skb+0x61/0x120
>     rtnetlink_rcv+0x15/0x30
>     netlink_unicast+0x2a1/0x3d0
>     netlink_sendmsg+0x237/0x490
>     ____sys_sendmsg+0x32d/0x350
>     ___sys_sendmsg+0xaf/0x110
>     __sys_sendmsg+0x93/0x100
>     __x64_sys_sendmsg+0x1d/0x30
>     x64_sys_call+0x821/0x23d0
>     do_syscall_64+0xbd/0x570
>     </TASK>
> 
> The pool then holds more free elements than its size at close:
> 
>    mlx5_core 0000:31:00.0: mlx5hws_pool_destroy:386:(pid 448599): Attempting to destroy non-empty pool
> 
> Forget the chunk in rule->action_ste once it is saved, as the update
> flow did with the action STE index before the commit below.
> 
> Triggered during an endurance test of a 5G UPF code, on flower rules
> that lose their police action in place. The reproduction below gives
> the trace above on a ConnectX-7 with firmware 28.48.1000. It only
> uses tc and devlink, with no kernel change. DEV is the uplink
> representor and PCI its devlink handle:
> 
>    r() { for i in $(seq 128); do echo "filter $1 dev $DEV ingress prio 1 handle $i protocol ip flower skip_sw dst_ip 10.0.0.$i $2"; done | tc -b -; }
>    BIG="action pedit ex munge ip ttl set 63 pipe action csum ip pipe action police rate 1mbit burst 32k conform-exceed drop/pipe action drop"
>    devlink dev param set $PCI name flow_steering_mode value hmfs cmode runtime
>    devlink dev eswitch set $PCI mode switchdev
>    tc qdisc add dev $DEV ingress
>    r add "$BIG"
>    for n in 1 2 3; do r replace "action drop"; r replace "$BIG"; done
>    tc filter del dev $DEV ingress prio 1
>    devlink dev eswitch set $PCI mode legacy
> 
> With this fix, the reproduction runs clean on the same ConnectX-7.
> It was not tested against kernel selftests.
> 
> Not addressed here and not triggered: after a successful update,
> hws_rule_destroy_failed_hws() can free rule->old_action_ste again. A
> failed update can leak it now also when it needs no action STEs.
> 
> Fixes: 3fc44ca44d7c ("net/mlx5: HWS, update flow - support through bigger action RTC")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> index 0d4cb2b2393b..cc94d3149d76 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/rule.c
> @@ -243,6 +243,8 @@ static void hws_rule_create_init(struct mlx5hws_rule *rule,
>   		 * new action STEs and a corresponding match STE.
>   		 */
>   		rule->old_action_ste = rule->action_ste;
> +		/* The rule may need no action STEs once updated */
> +		rule->action_ste.action_tbl = NULL;

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>

