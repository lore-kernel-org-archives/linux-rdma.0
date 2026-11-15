Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794727462;
	b=uyS/XUg0YVP4pb561zrRVZF1Z43eyTTt9k/138ar84TTrKxRjxEkCY3QmTC14CDkedTq
	 00Hw/iFaww0jQqQWfH4XUr7Bam4JmL3BeZKxAg2RxBmOSFsoOsJrkJTaJUsOdyZO1YxmK
	 clv3AaHKAF89mGxfJoMD3guA1aV9aWMh+SIyZAwg8KbZ/eQWJfd4eu4V9j5EKZPeU1YjP
	 JugGvPQnXiQ3DGoUP0Tve7n5ZQnjtiwzyInIJKM/7o0xnO2Xdeyf8STG18juZ8rLLQD8z
	 zTJ+8vNNnRxmiHW6XZLkkLNkfJbUrcVJ+ps2C5C7Lo7wutyZYkopwUxkf5vo3m/t1yQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794727462;
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
	bh=wo8vvqXzb5QCrZMCEF5Fe5NsY4QdpznmI/9Iup2sIv0=;
	b=HG3a+ND1WHlM7r7wVzD2TP9wpEbaYn55/CptWK33jrHjhRXjmuj37LXaRPQ7+RZozd3W
	 i4E0VN+wS3jHQ0i6QXOjBaN5J37E2fciL8DarL919mKkh7cYy+k+5F+HD4OxfA7tEY+Ot
	 HhONwVPsm8myMAQEMb0oRu2KPi5a57EL/kj3FJSRQ5AuqilUk5NtwGDJkmrBsJRC07hJ9
	 CIWe3W/lUG5blGlK8UQoYb4PF+c3g8N8PiiN5RZsS6jEjJc3EQVY3hbOW56xi0r239aaV
	 Wov++CWZrmVmO7Ju8EbfNPEpxji2ceih50J8IlcSeYQ5SqlqBJN33VFLF3cTFtdi5sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aSZevQbT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.11
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB808606A31D;
	Sun, 15 Nov 2026 07:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB808606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aSZevQbT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkQ8PGZBTZl2ziAdBqPNLLslSARMhnJx34tE4f1sDaAq/EUtURYWWbXsPMwp3SzKUpBQ052PJ3grWG0HAzNgNaNKSuHTsjJYT3R4/YzRtX/r4Fqaccbdi9V0yXPsc/FOmc41gFnGgkudq9DZlyoKmUv5RiOCWCj7/v+U5sNxRRfhixDvsChVB5vB47tQAFSHBpQiHYfbrBoz1EKT8QtTiy5M2su4a/nBl3fhQDttxA/dRtuYf9QNZ1K8risfSmFVmwGBcMOBqXRXP7qajQ6bsq6ZlHTBhscoS1NLPwxSpNvkgeECI5KlB6YIOmPtyD2rbCXZstuBGgJgLllDz+DiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo8vvqXzb5QCrZMCEF5Fe5NsY4QdpznmI/9Iup2sIv0=;
 b=lgw3uwGXtOWZQB11iVfEGdZ6ooQ35oGAeVzpB2qx8VvhawEAsuszL01yPROjd/5rkx79qLxLOXBMq11woq6aXMN1hVFN8nbEooc5zGWd+zDNQnjPbyQI0WNfb5RZEHbhA9lTw2/Xzv0IiAb3j2Vnm4emqbsvmgTeEOoOFrKjshODpmPgZAKlXcRC65bXukEWB1BB4IvTGmiQ8VhJFm8uHFEd0C9A7ifvPGdgmQxsjyZ7ZZBPYWiaQsNPGnzFTBsoPPcjXAUD23c4MPeyhSuiCvcQvYJWPgJaPDzF78D8LhMq99yQvuK++uLTGAEW359oCTG5e8eYkpLt5Ug3S3PdxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo8vvqXzb5QCrZMCEF5Fe5NsY4QdpznmI/9Iup2sIv0=;
 b=aSZevQbTr9XRqOlggh3kFtq/OB0QCgftOKW16y1usdWKJjHk4OfoUFC09MKPMenySTQbINfSG1Wiei/tfYfz1FdJDA0Rp+/1+jSxnTaAB7T1tF2X0+IJlWx+MayQDBBee09TBmuC907p0mD94siLQkPR1Keh64lY/av7rVPxJXG4AKiiGhodE2NibZbYYSkDh5Bu2BgMYx0ItP6ZF1d2ptbMUXpUzwkrloRxpo4YtlTeWZAE5B4HKQplc7gKpH8GSXtW00H963uAseFpA7UviZemOlmFPuU+BtmOKY6bKsw+kqLrMcodgMF1yyQDht6ttcOdhLGVhTn8rZ7doKFvPw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA5PPF9176ED2F1.namprd12.prod.outlook.com
 (2603:10b6:80f:fc04::8d7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Sun, 15 Nov
 2026 07:24:18 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 07:24:18 +0000
Message-ID: <4d975312-4d4d-46b2-9510-c5a3263a330d@nvidia.com>
Date: Sun, 15 Nov 2026 09:24:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: E-switch, Query port function mac only when
 vport is enabled
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 ajayachandra@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, udar@nvidia.com
References: <20261110092648.2511196-1-tariqt@nvidia.com>
 <179443255917.2199510.5948232347809644575@kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <179443255917.2199510.5948232347809644575@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0009.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::6)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA5PPF9176ED2F1:EE_
X-MS-Office365-Filtering-Correlation-Id: 6115b851-e2b7-42a0-f2b1-08df42e975e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|22082099003|18002099003|6133799003|261009223027099003|4143699003|56012099006|261102123227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261021135927099003|261022075727099003|261026140227099003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Y3JuzdCKiqerjmKPznKuX6DkkTsZm13admLkVjdCWEz4nYNGXPTS9Zq7rK+M4iIwa1YHDEVyd63PnNFPUqkPRb5YJt5oCDpO8pAoOJRjRUC+y11acGQMAD6a7oxeP3eSx3rtCMuzpigptRM7IOes8EQ/zXTUHxdbO9nmVWGWdTm4t1XfgL4TFWItgMEgQhogkHP4MyYg72E+syPNoojNQlLS6R5ooqilfkWVJKFxkgF1HeCNwRYSb9QcOHq0Sk/6NOk5BbeicgSAODUArPL7D89Z5w9lDAlW1O2HLh6/LFIVMbqA85z0/RC2ntpOwtWly2GJOUXre/vdSX0niCNBONfyIw9DOCrXhSRg1YD6TqlZLME3cuC7Y3f2RWIddBz6aKSAohuPcKwLNi2CO8yTM7GCpSsQQEojH1OCQnFP+AkYS8Ck2CrUGooJW67niysOaqu+irq5THZq6W7DKeClXOgWZYJpu4Krm/16HNox0No4INKTZ3ok0Fk/H6kj81pe/VJbJR9NGoLTEOS+jWN6XXv3r56Mu7k/26HXJPowdjptxiIjAEmXuwUYdbwb5AGfrf8XYriz5Rc9XEeQvw5cDn5ElTuwhna/268WtqvYq85ict0tMD80421TIz4kcujtuaC61d7VneEhIJ6TfzMiH5guhAeBWE7vh0S+qgsU1Ms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(22082099003)(18002099003)(6133799003)(261009223027099003)(4143699003)(56012099006)(261102123227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261021135927099003)(261022075727099003)(261026140227099003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTZIeGZKRzc0WlR4M2tDVUtDZGpieTQ0ZGpLelA2RHVZbzl3T2F0Q3UrTTR0?=
 =?utf-8?B?SldWVEo5bWdwUmRjRjhxNjlVdG5KNXQ4WlpyRzJJOWY5TUYybVhTQ09TS2FW?=
 =?utf-8?B?S0wybGhsWXd2ZTI3REJHbUJUbVlnTnB2dGtoV082N2F4MUpuWEFuLytyRkQ0?=
 =?utf-8?B?Ni9TM1IrRWVEN1RwYnIra3pTd0cwbjNaa25mejZReWM5dU5Ua2NsVjkxWDFj?=
 =?utf-8?B?TmQ4V25EWjF3QXFpV2hDaHp2K05USU9NZktFdU1XcmxKbmNpQ2ovT3F1YUdi?=
 =?utf-8?B?ZFlyZXFvTmFXNnMxOGlTZFRGYW4yYVhLdkNwWUFHTUhYZ1JsTVVUZmpONm00?=
 =?utf-8?B?SURmYVI3QUlxcUVyckNxWUdNaUdCS1U2NXdmZzQ5UDVNWDVaVGdpa3hMa2NR?=
 =?utf-8?B?T1lKTndSRnZ1Tlh4VzFyY1dRSnVoQ1o3M1ROSmYrdk55QUtUZEQ0SFRWWW5N?=
 =?utf-8?B?VE5XeUZSZGo3d042eEFGOVEzaFlpa1hNVkthcEMzYUNKVGJwV2Mwc1ZDYm45?=
 =?utf-8?B?b1lNYzdHT0QrSlJxSnpXK0xTK2ttQ05mazRhTVZxcjAxRERKZVJxM1plQmRk?=
 =?utf-8?B?c0I1WlJncDVUeFMxei9HZFpUaFM2NWtZaGNsYUJBbEZNQVI2SFhsRDZINEh3?=
 =?utf-8?B?WG5yNTd4TjlST25ONnhpV0RlUzZlL2JZODZRaHJiTW5ZaklUNkJIVXdFVlQz?=
 =?utf-8?B?Q2xtNnJZZURwb1F5NjlFNnpuNmJZckR3WU9yazRpRi9zK1hQa3Z5NUg0emZG?=
 =?utf-8?B?UlNNYS9NdWtaNmJ0UlFtbVJyVk9xVWk3VXRYU2R0TUFEZ0d5ZGduc2FmMjBr?=
 =?utf-8?B?LyttUGYzU3ZRcGcvUEdBVjBWTkNvNnVnUG5XbjZ0dUhtY1hONmcyWXRDazhS?=
 =?utf-8?B?U2xBVUZDUzFUclNobkEzRlRyam4zYjU4N0NiWW14RkxaeFlaQjh4Rk1xU21W?=
 =?utf-8?B?ME41YmJhVXJrVHR4WmVBZVZYL2JMbVpBMjVMMTNoYTM1ZkNoZy9Lam9qdXZl?=
 =?utf-8?B?WVRJRnIrK0lWajJtRFlBMi9lOHpqWll6UUNTOVBMV1Q4TFNRWk8xVVl0bTha?=
 =?utf-8?B?S0twODBhSVkyVGw0dFNXL3V4WWE1WUlkZ3hBaS8raERJTStOTmN1WlRQSk13?=
 =?utf-8?B?NWczR0JmbEpIMHNZTmpsOEY2N1NzSDMzT2ZlTUNlT1VqQTlvUTdzYXhRdkFw?=
 =?utf-8?B?RVpRdWF0R3NOOVkwZXJvdU9XeDBocmxBQm9VL05JVk1HdnF0OTVLNWxTMFVL?=
 =?utf-8?B?Z1hPQ3RaZE9OQWgvY25Ea29mR3Z0Nktkc0VwcEVTOWErRlF0dG93WU9GNTc5?=
 =?utf-8?B?UmQ2SzdGVmV0WWNpUFpXV0lFVEoyVFFvSzE1SVV1dVBnK1g1T0F0QkdzbG5k?=
 =?utf-8?B?WXphTzEvcTVidVkzVnh6eXc0Ykp2SWpXNlFPUXpVNnF3UDVmUnlnVmRkbE5I?=
 =?utf-8?B?RkdnbEhwVGMveGpVMnQxZmlnMTZ0aXgvQkI2TnZmcEU0N1JqZk9NT2lwUmFR?=
 =?utf-8?B?RkdkaXVZZ0VsUXVqb2FydVhGUXFWOWVaT3d1eTlGOGNFVGpPTzE4TmNkdUJr?=
 =?utf-8?B?ME5QRUx6dXdzSlh0dTdudU83dzlmYWVHeng5NlJOSDNqcTdRWWpDMVVtY2J1?=
 =?utf-8?B?NHczSzRURzZEZUlOb1lFMFlmcXBMT2QvMER0RzYxREFMVkUxM21nSndBWjJu?=
 =?utf-8?B?clAwaHhCRDNjWGhVRFhNekd3OW5CR09zT051VFV6QW1PaWhOQktFaXp5OXl2?=
 =?utf-8?B?cXlwUmR5b3lDTjdZMHJsYmdOcTg5SjlLS3FFNDUwc1MzZC9PellTZGVOS2Zr?=
 =?utf-8?B?cHV3R0NlZWo2TTNhcGwyTjd4Y2VzTDdJYTJZZjZnMFBrdFZHWDk4aDFxRUFL?=
 =?utf-8?B?bkJ2T291T0dPMFJ1ODBleGhaN2tuWlJKUnN5dW5HVmJ1clpMQW02bGpmZTlX?=
 =?utf-8?B?NllLM0FTa3Nuc1RLSDlEVERzd2JhR2o0MC9rUWNvTk81UWxnWmZNRjdNNTU4?=
 =?utf-8?B?SHZ3blNja2dwNS92VjI5QldtQ1luOUc4K3dORUFYR2x5VURyeEVnM3B3elV3?=
 =?utf-8?B?Z1NWaXFJVzl2Q0RpRU5DTzNlUy9ESkxHbGQxY2dsRXVsYWEyYlBPZEd1YXBo?=
 =?utf-8?B?Sy9JSXdSUzc3b2xPV0FSRGljV1ZGU3V3YVR3T1NDSEwrTjJwdldZSTFrN0hw?=
 =?utf-8?B?N1NaVG5mbndvWXdFUk1EbHUwQlZ5TGU3eVRsdHRacHV5bnQrV1BXaEYvcitX?=
 =?utf-8?B?d1BaTDJmK3hPWGFJaVpDR2JkRW80MDQ3TTFXR1YzOFFPTUJRNTZLbUtFM0RC?=
 =?utf-8?B?N2hQaHVSTS8yeHkzaldKTFlpNUpkc0dYaWNQN3RySkRIS1AxTVQwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6115b851-e2b7-42a0-f2b1-08df42e975e3
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 07:24:18.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/wHcQfas8tdWeRSc5hZgrTKdi77urydyaPlS7kcBRNreOevGUU+C4l5y/55euth5D3MJshv4gm+V55flW5ntQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9176ED2F1



On 11/11/2026 23:29, netdev-bot+sashiko@kernel.org wrote:
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
> - [Medium] The new `if (vport->enabled)` guard in
>    mlx5_devlink_port_fn_hw_addr_get()…
> 
> --
> 
> net/mlx5: E-switch, Query port function mac only when vport is enabled
> 
> This commit wraps the mlx5_query_nic_vport_mac_address() call in
> mlx5_devlink_port_fn_hw_addr_get() in a vport->enabled check. The goal is
> to stop QUERY_NIC_VPORT_CONTEXT from failing in firmware when a port
> function is dumped while its vport is not enabled.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> index c712848b202db..b83c6c02670f8 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> @@ -5121,8 +5121,9 @@ int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
>>   
>>   	mutex_lock(&esw->state_lock);
>>   
>> -	mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
>> -					 vport->info.mac);
>> +	if (vport->enabled)
>> +		mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
>> +						 vport->info.mac);
> 
> [Severity: Medium]
> Can this check ever be false here? The commit message says "A port
> function can be dumped while its vport is not enabled". The ordering of
> devlink port registration against vport enable/disable seems to rule
> that out.
> 
> mlx5_devlink_port_fn_hw_addr_get() is reachable only through the
> .port_fn_hw_addr_get op in mlx5_esw_pf_vf_dl_port_ops and
> mlx5_esw_dl_sf_port_ops. Devlink calls that op only on registered ports.
> 
> Those ports are registered in mlx5_esw_offloads_devlink_port_register(),
> via mlx5_esw_offloads_load_rep(). That happens only after the vport has
> been enabled:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_eswitch_load_vport() {
>      ...
> 	err = mlx5_esw_vport_enable(esw, vport, enabled_events);
> 	if (err)
> 		return err;
> 
> 	err = mlx5_esw_offloads_load_rep(esw, vport);
>      ...
> }
> 
> On teardown, the devlink port is unregistered before the vport is
> disabled:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_eswitch_unload_vport() {
> 	mlx5_esw_offloads_unload_rep(esw, vport);
> 	mlx5_esw_vport_disable(esw, vport);
> }
> 
> mlx5_esw_vport_enable() and mlx5_esw_vport_disable() are the only places
> that write vport->enabled. Rep netdev notifications that reach this op
> also run inside the same window. So every dump, doit or notify that gets
> here should already see vport->enabled == true.
> 
> If so, would the quoted QUERY_NIC_VPORT_CONTEXT "bad parameter(0x3),
> syndrome (0x29d722)" error still occur after this patch?
> 
> One possibility is a vport the driver has enabled but firmware still
> rejects for the query, such as an inactive SF. In that case this query
> still runs and still fails.
> 
> Another candidate is the unconditional query that the same Fixes commit
> eea31f21dce1 added to esw_vport_setup(). It runs on every vport enable,
> including bulk SF creation:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:esw_vport_setup() {
>      ...
> 	mlx5_query_nic_vport_mac_address(esw->dev, vport_num, true,
> 					 vport->info.mac);
>      ...
> }
> 
> This patch leaves that query unchanged. Was the failing path confirmed
> to be mlx5_devlink_port_fn_hw_addr_get() and not esw_vport_setup()?
> 

Ack.

pw-bot: cr

>>   	ether_addr_copy(hw_addr, vport->info.mac);
>>   	*hw_addr_len = ETH_ALEN;
>>   	mutex_unlock(&esw->state_lock);
> 

