Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210832;
	b=4qkLHsWDOByB+ZThFnM4Dh8rPMWVXE8E7z1S0Te2NtYZ1ciKg8wSYRh4B1cdHGo1O4P5
	 Ku7BrQ4hOk4C2kq9pY6xld1+m6c0Vr5hKCA9OOFYIvLScabmj4ej1wZ9UtojOmMAcww5+
	 gEfHgYxBdgSwRMXj7ye5G8Vn13Q0Qjx2YcmAQalVXsAPz/KPgaHJv/Z89W743UHNkZ8qK
	 V24VNDRvRxl/g7WZpB8JUs+P49KIO0tFkXR2BYplJB5+SRRzIqRNWEHVdo3gwoqN5HoCs
	 uV31oIslDOvXgefZqc3j5VflAP48yWhvKCefblce5cn+6f3z5gVHxasEzoXcl6XjwWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210832;
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
	bh=o7CuThGxbb+3RZ8eNOb1+Y++d/2EmQhnfLv2xJpTdSs=;
	b=WarggEhSCdTWYR/ftqaoN8nvMBoT/XHLMHeR8Gqr5NZixb7th1EdGwpb4GvkuryBefzM
	 XGKwvv38P5MC8AlpRva4gAUF3kdtVpm4s+oSFMa8+37PslheMjR56EKzsHnvz3yymuJy/
	 h2Ra2z17t6uZqPbJF0EgwXTwP1rfSUFWhvdNxaoe//Nz/lz/FPcmOw4XRXs6pOWDxDlVY
	 OKUkjU+H5VwBNXSWsR3th0G84rdzs57Qc60vbVsNPSbxsX9gAq3rER24PywB6fykFxb1N
	 uLbzNQO1eYqTUi1G08ud8rnykRIcvgYBsX5I+JrrajZ509fp+N7L/HzXY9TLU619nSw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Djb6svpc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.6
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE13606A31E;
	Wed, 28 Oct 2026 18:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CE13606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Djb6svpc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UvXTfYMZiCyuVEc6dLVaoDZl7VDr2gSYcZGzrc2vBH/Q/i/Fhmgn0+EWUITDVmp7rgq8srqcAyW0Ts36m8JSvVBABKrr9pNA7IyPT0xsoLyQ7SUZ0YR0b27rwr2fHX0Oz7ntIISKKOv4mDruiSCyVW2k42Zb6zln6AhZucfpCFZP6476rsva/iK0gNK7p3H1QB4W068m6fztcTJLmVeccuA9FReD8E/VU8YJUgvCwH59DEb2wfD8lCowsvvlLBW/1RPb/aOCM+bho2fNhqB0hnon9MfT9rq/sNV7nDQn/vt8daVGjfGiDpkz3uJ9ktFKZVx8eXG60OoVLGV2X8WoGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7CuThGxbb+3RZ8eNOb1+Y++d/2EmQhnfLv2xJpTdSs=;
 b=dZl16xE/nHCvfv1RYTR5Dupo0E0dJswhoETyU1pYU+yc0JhmoLYb6h9XX51EcCpihG9eXtNJWbU7jJ9/A4SRsDuxdBRvNDave64k3E79Xr4vcm1R0I+Fxytwb9Y+mVSh1xnuQI2keA2mvTaWId+FIThy+odEUdJEGtCDGLKuNCI/Bf5R7C9h2bYjH45MCcYzYYx6BqYZqqXRUyDuJchWv8ln30lAWZ3US8L80jnLHLmSHZnTVu7QwIJcfv9vTgn7T1dtH/M7oO8czjrNuEVA7dW3LEr8ipLoEUttpDKVnHiViOjrq0/Br8IPjOQtW5KnCsY49npEBsgBGndez0QJHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7CuThGxbb+3RZ8eNOb1+Y++d/2EmQhnfLv2xJpTdSs=;
 b=Djb6svpc7AxreSvA/wNp8ZBnPcA2L7IZnDBtNonnGNVBjYA/e1/plGngbish+0CP0+P+kbJfPRLPXfY0t5yput+4jJZ5z2dM19NwA4lX0rBsQqZSzPl/iRU6Dl5/f4PgqRdW4fIND1d800xKV7dQXGS+LFYMmz/ALJ/9/zantnrsGLjD5AAaa0eD7fJTCuCZzFZ2Jp48E2S/YeDwFBH5oiqBVpgoxf90UECG4+Ri/rQm10Gl1Fecp1ByeCxb9gExPWhtPxnlzH6BBf3UmLeSLIgaAMvj1oqkfZE1AyNIzaATnCKEk3hMMYhpfIlhJa6YosZUdBQxUOJ9CrsLi+ZucA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by LV1PR12MB999327.namprd12.prod.outlook.com
 (2603:10b6:408:3f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 18:07:05 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 18:07:05 +0000
Message-ID: <a3d02f70-c141-4561-a053-b408e94c6047@nvidia.com>
Date: Wed, 28 Oct 2026 20:06:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 1/4] {RDMA,net}/mlx5: cache and use TX-enabled
 aggregate speed for vports
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
References: <20261022193053.3815866-2-tariqt@nvidia.com>
 <179304672765.3134.1208806064407803696@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179304672765.3134.1208806064407803696@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0009.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::6)
 To SA3PR12MB239779.namprd12.prod.outlook.com (2603:10b6:806:5a5::7)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|LV1PR12MB999327:EE_
X-MS-Office365-Filtering-Correlation-Id: de0b46b8-f4cc-4590-a84e-08df351e4609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|261028144727099003|261026140227099003|11063799006|5023799004|4143699003|56012099006|261021121427099003|261022075727099003|261009223027099003|261022105027099003|10067099003|261026121527099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	qOi0l6/tZ+Ey1Qy1FKptFC4LZxGgeqgAM4aablc2+dOMmY0HIHpheveip7HXI5Hxmj380hwVSEzWOsI5lWA7BBLUA4UkMWTTpljBv/QnECZQcPLxBKx5Pc/iJhAm/2JJW1jwxm4BpkddrgfhkAI0uFujRWkXe9QvJdYUuGgXrRajvdt32a2Kv2lvwbrms4P3XRwLrSMp+0P3LncTLGGpwQWzOLT8aXJih6WOVvkMw7STNPiF3aEFazIZFtogm07FOzSF6DN8s3Kh263wHrIyRYKOe8ouHxtUQ/7PTaxjOtfo29awJBP1urqvIWTWvlDyjfBxOQ6vbsY59HHyuXkfFADv+tnoOkwTe9dVEqk9qZN+QSlc7JW0y4bVUv80yYCIIj1eBsSE/Q/THm1v9d/EFbVfgNmmvtVfDJyhzye7ek9RcUMaXR2wrrZLKSbIUt2RT7gYFHKV/MeZWHRga9kAmjJ92K6ub6yTeh45N/SZfKvIicQBIn/lWAUFjO3dYG91s1hPUVZGW2fXJK5WV6c0Mq+SpkicXtA5pQ0iLwuDG9uohvxVoiD8Hd5lJ4Zl/atFoMHt+VX1ILHEq8GmUhEyg7BNPzJc9H9h7Z22MooVFtXOyapTtaffPuTSPDnD2l938+DyGpYPJad18stJuhFKDhd4hzMcqK36uk1iT3aMy6Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(261028144727099003)(261026140227099003)(11063799006)(5023799004)(4143699003)(56012099006)(261021121427099003)(261022075727099003)(261009223027099003)(261022105027099003)(10067099003)(261026121527099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlRORSttLytqWkhISVZxZWN1QjdQaHBvcEx5N3BWMFAvQ21pWjNtRkU3akYv?=
 =?utf-8?B?YTltNWdwQS9pbUgyWjNDc2FXWDhFYnRJVkFMTG54d3dWQktsSjJoVUQ4bGQv?=
 =?utf-8?B?b2U5djlmVWZyYllESUtNc2hYRDd4a2VZQVRlZWVpNVpjb1MvT0RkVFk2S2F1?=
 =?utf-8?B?dVA2K3Evck5IRE9TemY5Yk1WVytBaEhucVEvano1YWlyTERaT0NYMFB4VENQ?=
 =?utf-8?B?VkUzTlFFS3FaT0JVdkhoeStXUlNrS1B6N2tCMnlVbTY2RmEzSi9DazF3NnJH?=
 =?utf-8?B?YUsxVUVqWEtKYmlxcDU5OG9YNTBCbTJsUWJTenRMSU8vL0RUdjd5ZDRzNFd3?=
 =?utf-8?B?NHVsbmxOaFdjZk43VXEvY1BjSnNjclEyZTZOYXRMTktlYWI4ZDhSM25ZSFlQ?=
 =?utf-8?B?SlhoZ1NaWXIvT091ZmVsRVdrNG8wT3k4aEN6em4xQXUrbzhiZHRTTnNreDBh?=
 =?utf-8?B?TExHK1IvUHp3TnhicG8veWpnR045K05WQVduc1hlcEZFTEpoaWg2SXJXVWtT?=
 =?utf-8?B?TG1wRUdIV2d3ZXJDRFFNNHkrRXVJbDkrSHVUVkVlOVF1Vkp6bjI2enNsMnBr?=
 =?utf-8?B?ckpwMjIzMHR2dHk0WmpQeXBQVjZXN0R1RVZoYVRobG5xZDhiOEczYlVwQXJ6?=
 =?utf-8?B?ZGpOanZTTS9VRVRLeTVFcUZFd2xqQnhWV2tVUGlKZGR5YTZlSFh1WVMrbFUr?=
 =?utf-8?B?WldXeTJKeXo1NE1SYUdOMm81MXpFR1FDUkNjMXZFdUN2WXU2ay9jRHlGMHFC?=
 =?utf-8?B?MkZoT1BHTndFRGNxc2d4U1Z1RHNQd09ocUd2TGMrVkNTaGxkMmkwUzJPaUpt?=
 =?utf-8?B?VVR3T1NpL2VjZGhkVUVzQU9PaWpZSzBTeHZFZXlYbWRsSmhWUkpRQkVPRXVF?=
 =?utf-8?B?U2VBc1pRVUpnRDhaaEVnRUt6czIreno1WTUwNUh1TlhsbHVPNzBDTEp6OXVz?=
 =?utf-8?B?RkZpM2FFZmN1eGdGTzA1bU8zWWJEWjVySkYzM3Jsd0JheHFCcnN1NmYzY1hR?=
 =?utf-8?B?SlQ1MnJ1OCtUc2U0RmVkcWhZVWJnY0xmN0VBbWxsU3lQN29VZ2E1SnJKRXJh?=
 =?utf-8?B?NUx0bmRlM01TZVhiV3dUUXI4cWRmTktYQ1FSOUE0S1FmSDZKY1BuWE1IWlJy?=
 =?utf-8?B?Ni95Qk5MK3Y1a0g0VnpnWEZucUQxY1V6Sjl0K3BTNHhkUlNYbmVId2xaa3lO?=
 =?utf-8?B?OENTdG0vKzdaZS9IZG1qTi9qNWFORFlnVVFsZUgrdU9wR3JQRlowSjRLWEdB?=
 =?utf-8?B?OEVUUWxwRzhLU0ZERWEwbUNHVG9ORStxbDk5SlgvQ0IyOFVNM1FLQ2lNamZw?=
 =?utf-8?B?dmxXNVNLYmMxM1o4L3lnZ2RFVUFEb2dCWU43eHN5MXJSRFN0dVJGYU1pWW5G?=
 =?utf-8?B?bC9WaThIQ2NBYjh4NU84dkxOWkw5NFVBTFNxZ0krS3dzSDRuSzVvSzYvSGIx?=
 =?utf-8?B?TjFnTzRMbjJGeDhLR1FkcGRhSXNYVTExcTNIcjJZcXFSVm4yWnZDVUVSUndJ?=
 =?utf-8?B?bHJIa0Z6M2t5MjFPM1dhZ21NZlZJMEcyYWRIRlc3T1RnUjljYmdLUnl3ZFow?=
 =?utf-8?B?ZlJEaDNJa1FHNlAxQTNzb25HL1Q4aEplSXFhTEJoTHBjWC9LOERDZDhXWFZi?=
 =?utf-8?B?QnMyUklSdG5IVVBHK05ibXkrbDFaNEUxTk43dUhjOGxmRCs4OE1uZjVMNjZT?=
 =?utf-8?B?a1c4OEh6RVViWW14SUZuS0grckl3WDhRT25GaURVSjNwUm42MzNabzdBdmVY?=
 =?utf-8?B?OWs3Z3E1ZVBpNm0xYXhId3pvNTlsMVJDV2pVaVJ0STJNUHc4eXB3dDN3ZXBt?=
 =?utf-8?B?cUdzMWc2QXJjaElTN3JGTnIvR2lkUFZBT2dxdkdWcmc0ZHFYcUMvSHgreHZW?=
 =?utf-8?B?VXVpc3ArK0NndlA1K2djMkNsQWlSNmNWUWpGUTRDMURzNU9pL1dYSnR0UmM1?=
 =?utf-8?B?LzF0bjZDYVp2dWtyZCticFgrSkMrQXRHc3VuNjJrRURmc0N3WmQ0bHBmVkw4?=
 =?utf-8?B?MFEveElmY0o5TEtvZFJURHFMQW9oaDA3L0lRZlAvdjYyN25PV01PVW9QbnBX?=
 =?utf-8?B?R0Z5czBQNjlJVGNzRWtibWZFdDdEVnRHZVBrcXNEMTl3UUY0a0k1OWpyNkhS?=
 =?utf-8?B?UWdQTnBFbWhZWitFc3gxSDNuRlhRR2JLdCtTM1lnUDl0MkNqM2FMeXVWK2Ux?=
 =?utf-8?B?VDZibW43VHV6QXdRT2JHeFVwNFJpYUkwTSsyU3BrU3Q4c1NYOEdwWTFOTVdh?=
 =?utf-8?B?d2ZlcFcreWdBaGxBN09jSk5HQXNBT2RUSW1IUkRNTVlIc1JtRVBDK2QxTjNY?=
 =?utf-8?B?K01IbE1waVVwQ2pIT1hZbDdGaHRGK2lUSWNEQUxYNFlTQmxpNDNSdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de0b46b8-f4cc-4590-a84e-08df351e4609
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 18:07:05.1320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ngGhMSPq3e8/YWG3J3+B1yLGSiMn5Pj8WaywjN7+mCzL1f74C5+xI+9HLo0EB2lD2nrHml0OKBGgBymo8yQ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999327



On 26/10/2026 22:32, netdev-bot+sashiko@kernel.org wrote:
> 
> 
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The new ldev->agg_speed_mbps cache is invalidated on only one
>    teardown path, and it is filled only after the IB device is exposed.
> - [Medium] For regular (non-MPESW) RoCE/SRIOV LAG, the patch replaces the
>    bond's ethtool-derived speed (tracker.bond_speed_mbps) with a sum of…
> - [Low] In non-MPESW mode, mlx5_lag_get_devices_oper_speed() now reads
>    the live ldev->tracker.netdev_state[pf_idx].tx_enabled/link_up for…
> 
> --
> 
> {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
> 
> This patch caches the aggregate operational speed of the TX-enabled LAG
> ports in ldev->agg_speed_mbps. VF/SF vport max_tx_speed is now programmed
> from that cache instead of from the bond speed. The exported
> mlx5_lag_query_bond_speed() is replaced by
> mlx5_lag_query_aggregated_speed(), which the mlx5 IB driver uses for port
> speed queries and which returns -ENODATA until a measurement succeeds.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 4e173b08cb37a..57755ceab8a75 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> 
> [ ... ]
> 
>> @@ -1452,15 +1453,21 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
>>                pf_mdev = pf->dev;
>>                if (!pf_mdev)
>>                        continue;
>> -             ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
>> -                                                 &speed, &state);
>> -             if (ret) {
>> -                     mlx5_core_dbg(pf_mdev, "State query failed (err=%d)\n",
>> -                                   ret);
>> -                     return ret;
>> -             }
>> -             if (state != VPORT_STATE_UP)
>> +             if (mpesw) {
>> +                     ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0,
>> +                                                         0, &speed, &state);
>> +                     if (ret) {
>> +                             mlx5_core_dbg(pf_mdev,
>> +                                           "State query failed (err=%d)\n",
>> +                                           ret);
>> +                             return ret;
>> +                     }
>> +                     if (state != VPORT_STATE_UP)
>> +                             continue;
>> +             } else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
>> +                        !ldev->tracker.netdev_state[pf_idx].link_up) {
>>                        continue;
>> +             }
> 
> [Severity: Low]
> 
> Can these live reads of ldev->tracker race with mlx5_lag_netdev_event()?
> The notifier publishes the whole tracker while holding only RTNL:
> 
>          ldev->tracker = tracker;
> 
> This code runs from mlx5_do_bond_work() under ldev->lock and the devcom
> lock, but without RTNL. The lockdep_assert_held(&ldev->lock) in
> mlx5_lag_update_agg_speed() therefore does not exclude the writer.
> 
> Between the tx_enabled/link_up reads for different ports,
> mlx5_port_oper_linkspeed() issues a PTYS command that sleeps. During an
> active-backup failover:
> 
> bond work                              netdev notifier (RTNL)
> port 0: tx_enabled, count it
> mlx5_port_oper_linkspeed() sleeps
>                                         ldev->tracker = tracker
>                                         (port 0 off, port 1 on)
> port 1: tx_enabled, count it
> 
> Would the aggregate then cover both ports, even though only one of them
> was TX-enabled at any given moment? That value goes to RDMA and into the
> VF/SF vport max_tx_speed, and it stays there until the requeued bond work
> recomputes it.
> 
> mlx5_do_bond() already takes a snapshot with tracker = ldev->tracker for
> activate/modify. Could the speed calculation use that same snapshot?
> 
>>
>>                ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
> 
> [Severity: Medium]
> 
> For non-MPESW RoCE/SRIOV LAG, this replaces tracker.bond_speed_mbps,
> which came from the netdevs' ethtool link speed, with a sum of
> mlx5_port_oper_linkspeed() results. Does that lose the fallbacks the old
> source had?
> 
> mlx5_port_oper_linkspeed() picks the PTYS encoding only from
> mlx5_ptys_ext_supported(). When no known bit is set, it returns success
> with a speed of 0:
> 
>          ext = mlx5_ptys_ext_supported(mdev);
>          err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
>          ...
>          for (i = 0; i < max_size; ++i)
>                  if (eproto.oper & MLX5E_PROT_MASK(i))
>                          oper_speed = max(oper_speed, table[i].speed);
> 
>          *speed = oper_speed;
>          return 0;
> 
> The old source had two fallbacks:
> 
> - mlx5e_ethtool_get_link_ksettings() falls back to the legacy
>    eth_proto_admin/eth_proto_oper when the extended admin field is zero.
> - get_link_properties() falls back to 100 * data_rate_oper when the
>    bitmap cannot be decoded.
> 
> The legacy admin case looks reachable through
> mlx5e_ethtool_set_link_ksettings(). On ext-capable hardware with autoneg
> enabled, advertising only legacy modes writes the legacy admin field.
> 
> In that configuration, would an up, TX-enabled member contribute 0 Mbps,
> with the result cached as a successful measurement? RDMA would then
> under-report the port speed. If the whole aggregate is 0, the VF/SF
> vports would get the max-capability fallback instead of the operational
> speed.
> 
> This assumes firmware reports oper only in the legacy field in that
> configuration. That assumption comes from the ethtool code's handling,
> not from a firmware specification.
> 

will fix in V3
>>                if (ret) {
> 
> [ ... ]
> 
>> @@ -1594,6 +1625,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>>        int pf_idx;
>>        int ret;
>>
>> +     mlx5_lag_reset_agg_speed(ldev);
> 
> [Severity: Medium]
> 
> Is this the only teardown path that invalidates agg_speed_mbps?
> mlx5_lag_reset_vports_speed() is only called from the disable branch of
> mlx5_do_bond():
> 
>          } else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
>                  mlx5_lag_reset_vports_speed(ldev);
>                  mlx5_disable_lag(ldev);
>          }
> 
> Other teardown paths do not appear to reset the cache. One example is
> mlx5_lag_disable_change(), reached on eswitch disable or mode change:
> 
>          if (__mlx5_lag_is_active(ldev)) {
>                  if (ldev->mode == MLX5_LAG_MODE_MPESW)
>                          mlx5_lag_disable_mpesw(ldev);
>                  else
>                          mlx5_disable_lag(ldev);
>          }
> 
> The MPESW disable work also calls mlx5_lag_disable_mpesw(), and the
> shared FDB path goes through
> mlx5_lag_shared_fdb_destroy()->mlx5_deactivate_lag(). Neither path
> touches agg_speed_mbps.
> 
> On activation, mlx5_do_bond() calls mlx5_activate_lag() and then
> mlx5_lag_rescan_dev_locked(ldev, dev0, true) before
> mlx5_lag_set_vports_agg_speed() fills the cache.
> mlx5_lag_shared_fdb_create() also rescans and reloads the IB reps before
> it refreshes the speed.
> 
> mlx5_lag_query_aggregated_speed() reads agg_speed_mbps without a lock,
> and its IB caller only checks the LAG mode. Could a uverbs
> QUERY_PORT_SPEED in that window return the previous LAG instance's
> aggregate as valid data? On a first activation, it would get -ENODATA
> instead.
> 
> This seems to contradict the commit message:
> 
>    "Until the aggregate has been measured, or after a failed measurement,
>    mlx5_lag_query_aggregated_speed() returns -ENODATA."
> 
> It also contradicts the v2 changelog note about resetting the cache to
> SPEED_UNKNOWN on teardown.
> 
> Later patches in the series do not appear to change this.
> mlx5_lag_reset_agg_speed() is still reachable only through the disable
> branch of mlx5_do_bond(). In "notify IB uplink on LAG aggregate speed
> change", the stale value also feeds the speed != old_speed check.
> 

already replied in another mail

>>        mlx5_ldev_for_each(pf_idx, 0, ldev) {
> 
> [ ... ]
> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com

