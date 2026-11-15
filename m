Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794729596;
	b=rPaZ0XAFI83XgShLHdBaglmxqEap+s0aCntqbb2QHtc1wMLBIgoCmOwtsrzNf9aJkbot
	 EsQplHBd4Se2V0AUItL2qo7hTJ/cneNVNBz+4Ot0AVBsWEfMS+OU7/gs2tzZZ1/wRfiu/
	 NHa+oSH/G5PZXFzwzQKQRgku8jxKPPQArW0BUUAESR4iznMpTaOdle2S+rYtsex4O2+8W
	 +jIRIhCa9BCBxBJ7+IyJSKZzo7Wv1byekHQr5hs0PJdrjR4DTAaVSgZRn9tbL5i2QliYo
	 CD8xHW7k2NijazSNjdUh0eH83Ee4MpjAoc7bz3Zm9MqN0HFJ93Pw9/Isn+n1AcGJ/2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794729596;
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
	bh=KW4Kp1AEZ6gwMSV1Tz5nFF3z6uJuuqWonI0EWbfACTw=;
	b=PJjbjepVXUv64Mis/0d5u/FSx8noE0nywN/sK5p4iKyEq6+PMRxGKufZn2I2i44RBb5D
	 rAHiPqyN3rqZ4Ed94DKuMS64Cw+C4PjD5WiNTE21pDQG/GI1EIu1vQ3VHCjX4zKdSEj7U
	 NIsoMuxFuiuxhiJr28YkD1eMZSfaeof3YP83d/fG4B3IO1Mn4WAxHFNNun6nqIfpy9/bK
	 IWaIX+PtpdfYloF3NwPR1CRnztYi5TdIWmoTfyz9JpFBQoVmqq04TUrWFWwj8B9mWEEmU
	 hnkIN0aXZJRj6P818K02ZT4k/tdbbSe23cvevYVPp1z41i7udSJilVYP4mTMOKUhMXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="M2mCe5D/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.40
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855A7606A327;
	Sun, 15 Nov 2026 07:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 855A7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M2mCe5D/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBALRlos/1hRm4KGRRlRf1KkPHdj1aIO8dt9i5D51m/dui72L06SFTt580tvhliBpTHmNKK4ZD3QM92X7e8nHWOH8FhAbr79rTHG6jlT8RxOSJAS0+U7miixQoeDtBbNU73jrCVYmjVUiXGaido3pZ96LJyGF7fjiEbtEpXm++V3FujAJhHMtp0l7hiqJBbTSJJRuuTIF5y2J9xeJMNEiuQlImaHWiwIzcvTpFL0/ZsBGaAdF0A0fkdJb//tS3UBRRxCFHZaVzYRj/vcnEtY15/g+Z02ZjH1Wu+S7VGjjXuya954Y4iDoReOKeWwdN9agy/ArXAnAB4P6fas1cr7kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KW4Kp1AEZ6gwMSV1Tz5nFF3z6uJuuqWonI0EWbfACTw=;
 b=Ld5PKLclPF35qdxgzfhXW3J4x7NEvwgN99Ntse010TxSY0cAEEpxshB7Y89SVwDLbEPxMFqNZybpzhUTF/sSJf4U1CZ5yNE+6TqI56NNddkND+i4FpZOL9LeefOW+QgMDoKU8nBexhNXImhemrAt1kJ7Zw2IJaVhwRBun+kDobcvMDQ5ULLCLNoLh38VpLcj9qlP2r6TSdz0Mn5mlCHephbVpEm2ovp3jJPmSIy9Q2tihhq2bpnrF+/lY6hHVIH1Z0+xQ3p5qg7mKx4x9WITfMqsQ71wcblhoO2HTjWaIaa5gCuc3uAI4kRp0JO12qOaGJrchAqk8Tmrvt0aRgXZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KW4Kp1AEZ6gwMSV1Tz5nFF3z6uJuuqWonI0EWbfACTw=;
 b=M2mCe5D/EKWgoxhzczbRrtHTfnrou/v22INFSeEzz8aHfwYNkAew5Zpwk4P5dg5DxNcu7nfWnneGNDP8BZE2E0g9mGLxW05jFS+QHI113JG0uAWSyJCr20+ViOLfNLP4APgnCVd2mT2pCsJjaSF7i3fbo9rV1juemCM/oVZel6w9blqZEBhfVayNri4N9f2xPlSFltBbkjVteOGi94Yu+UvBdweoznDhQV+D/D527HypLB9+hWcBbrgnRuAlRtzQdniPNgQlhyC6UoeEr9V0O297PD2zlZaj3XuK6+cYAHr2KuJhIRx10RXgrLJBqtXnyvRs77Qs6QkbFXajxCHT5Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DS0PR12MB7849.namprd12.prod.outlook.com
 (2603:10b6:8:141::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 07:59:49 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.012; Sun, 15 Nov 2026
 07:59:49 +0000
Message-ID: <2cf34dbe-8965-4917-861f-b9306153f850@nvidia.com>
Date: Sun, 15 Nov 2026 09:59:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
To: Dragos Tatulea <dtatulea@nvidia.com>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
 <almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, William Tu <witu@nvidia.com>,
 Bobby Eshleman <bobbyeshleman@gmail.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-11-tariqt@nvidia.com>
 <avTdfAaW9tlBRM34@devvm16445.scu0.facebook.com>
 <ebd14110-49f4-4fbd-9dbe-1c39a1706da9@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <ebd14110-49f4-4fbd-9dbe-1c39a1706da9@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::17) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: de7f22be-7e93-4577-58f4-08df42ee6bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QuuHYf7tYvxAIYoS60CnHug9vOSlhaNExmV9qGAGklqfo+5FFuUL3JWzmIob9kl0ueyCgrFvwLujEQIcxFU1h9E/wP4D/HtDUWXEQkUasSr1ZwIF6cIxfq2mvUH1Af2lon+55gt3UxK5r2TGGmk1K0ixhJEbaw3CpAvZotjHi+9U/lQJ4du6z9MnIDM6fDrIsIdVZ0Dwd2JmgpXeUjrjwOJdULqwxBliRxraHrlF43dWQSSpMNVce3ASeWk2RBD19E3LrCyQcmm0lKk/OHjtEeT78JIEvONUB8a6Mdw52WAQvtypadUWjVYXvWtrcwOsS95K0JcWyfBNIHfqSHP0pZMcyAKN3OdL5PmReflWbEU8GxBY5IIdx5FJmpanJh+xT0+dRNVrLzQ0ojZFBwXWUPssg4xRB5wg3G9H4e2hNZ6BWH59yhbH+c+VwBf97Zzb1gwilb4M2Q+BP/SsTIxBe4gB2NNSGEuCe559kv9H+fcbm3iONs0LN4S8PuN2Z57aN3hYk9pNkCY1T/9YIVtelAlrP+JMaPm7Rr3Q7MJ1KeFRwrUWKXA22beXo0BsQR4Gbs8e0/OU2/KSphh+Cc+sm++zFdhm7ooSLPvNtsA4uGP4OLxSObtTeHb2rEcJojrZQIegnIRVOVuK66DgqzWTIYHbLbfP777YM/+LI8w2dmo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUdBdFpvWmkyZlRhb0JJUFRyaVdQRjh1dnJRMFlublowY0FjR3BsVkRpOEJm?=
 =?utf-8?B?bVFPMW52OFJjc3phVElocTNMTzZEbkI5S0lld25vWVc3UXNTSmFsYXpxNGQ0?=
 =?utf-8?B?dHpvdllsZ21HMEp2OUdUb0o4dzY4Y1J6TE44UU1qUU1VdUhHdm00ZWQzR0xo?=
 =?utf-8?B?SHJGRzRKSkcrSGsrZU5DVGtlZEM0VFYzNVNXUVBORDlVemF5THFGRk1MNUR5?=
 =?utf-8?B?YjZyVnlpUm5NenhOeEZpcTNVZFBKVHkxc2JTS2NaZUxjTVkzcTM4dHEzRE5v?=
 =?utf-8?B?dzZyZHM4QlZySXFwQlYwOEdzZStBejg2TVFkZTM2a3NVbmRIbGRkM05vbVRB?=
 =?utf-8?B?SEd3dUIzVUVaSlFiSVdwd2FENGN2TFhOcTlzdG1LMlJ1NEJ3THBTTFovU252?=
 =?utf-8?B?VlhTR2JPRmtEcFY3QmxFRXJ5b3pKMmxsVWpQZU00SkE1UVNzcXBUZ0dBamt2?=
 =?utf-8?B?eEFlRjVjZ0V6WEh6OWxsTlNDTGRXRWY3ZENzZEs3Q0VocU1hOXJCcUNIUEgy?=
 =?utf-8?B?STNuT2laUzRhYnVrMzgwa2N5UWhQcjJkSkpPdWx4YVNIdDNzYWJZZ1BreklN?=
 =?utf-8?B?WkM1Q091MkljQ3ZmK2Zvbm9xN1lZQU9iRENrVWdTeTA0d2tyZmRIaFFFOG5F?=
 =?utf-8?B?TkJBN2NoVFIvUHEzbkxubEZPOUE0NmZnbVZhNkZvVXNVRFJxNzRMSTFhaFUv?=
 =?utf-8?B?a3FLcXp0YWthNGdvd2kzYXk3eXhFWS9YQVE0ZjR4akFNc0EveERtOGxqOTRr?=
 =?utf-8?B?dkVQdnlBQlF1bFA0U3lCa3Z3K3ExNVpoczUvaWxWekhYVmVFVUh5NXpOUlIz?=
 =?utf-8?B?czA2bG9nL2ZoQWZ0WkVUQ0ZXWXlNMDVMc3pmcUJjRzN3VUROZEl3Um9oZVk1?=
 =?utf-8?B?U1lMdWUvMDNXVWFiMW9CcWY5dURuTG5LR3VZYlREeCs2TmczejFCY05QRHJS?=
 =?utf-8?B?UGZzMjQxNjRJQ1g3dEp5UlYwdE8zbzcydHFaMVNPeUVBbTdjbE9jNXNORHJ1?=
 =?utf-8?B?UlNCazh6cVRIRzFiUEs2NWhLelJTbWZJbTRtb3NNY1J3OWh4UUJ2UXNvOXRD?=
 =?utf-8?B?Y21ueVhudzkxODZJN0R4Y2tGb1R5TE13M1JhTUhhQjEyQjJSdW4xQWx1aVIx?=
 =?utf-8?B?QS9pUU5KTzFMK1JsMS9weGFlVE94L1lnV3hwekIzdXdXZHAwV1RaSmFVay9J?=
 =?utf-8?B?MWFTbG9Qa0VQMDhkZHNBWWkxcS9VYnI4UTgvQStWZGVxUzdFOWtMcnYySGpj?=
 =?utf-8?B?OWR0MjZMWllIaTFFWFY1ZjhyQXNrRm1GbjFSSGFoUWZHVGJkdGU2VWpBTWMy?=
 =?utf-8?B?aTUvM0xjYU5ZSnhhT1NmZ3djdVJDbmlXNDBhellRK0czOGFFQkZHTlVma1g4?=
 =?utf-8?B?eklLbFFGd2FmNFBJR3UydUZrZ3hib0pVMzRxNzlIRHNnbEN0Sk03cnFnQVlW?=
 =?utf-8?B?MjY0a0hGTTJFSDZrY0NNWFFESzdoMjYycVpBT2FBVGdUUmo5WmFRSGFKTHYw?=
 =?utf-8?B?ZU43SVFjdVVKajdXMHRrOEJHVmVFR25zR3YraFV5ai8xeEd0c1Z3bHFPN0Uw?=
 =?utf-8?B?eUxHQlhyL2RHV0lSNjJTcEJuWjQxRzFFbTAzUzY5T3JkanlZZUE2MU5GbzZQ?=
 =?utf-8?B?ckxidlVhVWdwbzZuY0txMnQ2cG1ESDAycGxLYlE3WnBTeloycXZZZzZLWExP?=
 =?utf-8?B?eUFjRmkzSjNUWDAvU0x2ZGlwRmN4V1lpaS9XSHFLajd1Z3F4Nm5xdDhWWmpy?=
 =?utf-8?B?aHZsWmpFcDdtTjFzZTc4WUQ5a3BQWnRiOWtycGZ5eFluanVmS0dyOUhEVU9k?=
 =?utf-8?B?ZmdkUXhiSkpZckFFSUs5R081OTRyZGJqdFh1cGJjU0pnb0xwbUNrNGtLeWJ0?=
 =?utf-8?B?MWxUTTc5RUFHUElzMmJ1TUFxQXJLZE91TkVMUDQyOGk3RUtiV2pCTzhtTDlQ?=
 =?utf-8?B?SHJJanViSVQwTlZsK1VHemM3N2FndGIvMWZNako4bjBhejhNWHhvNWZSNUtV?=
 =?utf-8?B?WnY2M29nVCtBYnlRaDdxU1BuN2JQRzFFbnc2bC9rUDg2ZDJnVkZ0aW02Vk80?=
 =?utf-8?B?ZlEwV2tBeFp6Vmpxejl5bnF2QWZaVHpBTWsrcG8zQ1gvZDFmSlRuWklCdUJQ?=
 =?utf-8?B?bE5mK3hhSmo5MnovVTFzUG5HKzBOMWRaK0hpZ2ptaE8ydkRBOVR5U2RCVW8r?=
 =?utf-8?B?bm5Dc1AwTzBVMkdhM2VEbVlHOXVtd0dFSkZxZktyZ2w0NTBEZWtDQStLYkJj?=
 =?utf-8?B?MDNZNG5wMmxLNWtndERtWHhybHA5bFBLTWdSTXdWdjFLMnNGcWJNSWxSMGFB?=
 =?utf-8?B?a0RNVE9xYW9VSUpESDAwNFhhbU9XL214QzhZMnVjOElTNHVBTVpWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de7f22be-7e93-4577-58f4-08df42ee6bd5
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 07:59:48.9501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVpMWAlvBcnASfrGZYpXVzJdbVIaA5fOHpcuzn5tZwQBduAes5SkA9AOczjlnumjv4a0401iLyrI1UtutGnN5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849



On 13/11/2026 17:00, Dragos Tatulea wrote:
> On 11.11.26 22:46, Stanislav Fomichev wrote:
>> On 11/10, Tariq Toukan wrote:
>>> From: Dragos Tatulea <dtatulea@nvidia.com>
>>>
>>> Currently there is no way to check whether a dmabuf is bound on a TX
>>> queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
>>> of it.
>>>
>>> To help with that, add a helper to check whether a devmem dmabuf
>>> binding may still be in use on a given netdev, optionally filtered by
>>> the DMA device the dmabuf was mapped against.
>>>
>>> A binding can outlive the user's unbind: it can still be referenced by
>>> in-flight TX skbs, whose DMA mappings are only valid for the device the
>>> dmabuf was attached to. Reporting such a binding as gone would let a
>>> driver swap the DMA device out from under those skbs. Bindings stay in
>>> the bindings xarray until they are freed, so walk it and report every
>>> binding of the netdev that is still mapped. Bindings that were already
>>> unmapped are not reported.
>>>
>>> This API is necessary for the upcoming support of data direct in mlx5e.
>>>
>>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>>> Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
>>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>>> ---
>>>   include/net/netmem.h | 24 ++++++++++++++++++++++++
>>>   net/core/devmem.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 67 insertions(+)
>>>
>>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>>> index fb693bc1702a..35bb6fa0f719 100644
>>> --- a/include/net/netmem.h
>>> +++ b/include/net/netmem.h
>>> @@ -397,16 +397,40 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
>>>   	return netmem_to_nmdesc(netmem)->dma_addr;
>>>   }
>>>   
>>> +struct net_device;
>>> +
>>>   #if defined(CONFIG_NET_DEVMEM)
>>>   static inline bool net_is_devmem_iov(const struct net_iov *niov)
>>>   {
>>>   	return niov->type == NET_IOV_DMABUF;
>>>   }
>>> +
>>> +/**
>>> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
>>> + * given @dev and @dma_dev
>>> + *
>>> + * @dev: netdev to check bindings
>>> + * @dma_dev: dma device to check, when NULL it will not be checked
>>> + *
>>> + * A binding is reported for as long as it is mapped, which can be long
>>> + * after the user unbound it: net_iovs of a TX binding can still be queued
>>> + * in flight, with DMA mappings that are only valid for the device the dmabuf
>>> + * was attached to.
>>> + *
>>> + * Return: true if a binding is found under @dev and possibly @dma_dev
>>> + */
>>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);
>>>   #else
>>>   static inline bool net_is_devmem_iov(const struct net_iov *niov)
>>>   {
>>>   	return false;
>>>   }
>>> +
>>> +static inline bool netdev_has_dmabuf_binding(struct net_device *dev,
>>> +					     struct device *dma_dev)
>>> +{
>>> +	return false;
>>> +}
>>>   #endif
>>>   
>>>   void net_iov_inc_ref(struct net_iov *niov);
>>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>>> index 5c7d9640e9d1..dd3987bbd9f6 100644
>>> --- a/net/core/devmem.c
>>> +++ b/net/core/devmem.c
>>> @@ -513,6 +513,49 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
>>>   	return binding;
>>>   }
>>>   
>>> +/* The attachment is cleared once the binding has been unmapped. */
>>> +static bool
>>> +net_devmem_binding_mapped_to(struct net_devmem_dmabuf_binding *binding,
>>> +			     struct device *dma_dev)
>>> +{
>>> +	lockdep_assert_held(&binding->lock);
>>> +
>>> +	return binding->attachment &&
>>> +	       (!dma_dev || binding->attachment->dev == dma_dev);
>>> +}
>>> +
>>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
>>> +{
>>> +	struct net_devmem_dmabuf_binding *binding;
>>> +	unsigned long xa_idx;
>>> +	bool found = false;
>>> +
>>> +	netdev_assert_locked(dev);
>>> +
>>> +	/* A binding stays in the xarray until it is freed. binding->dev is
>>> +	 * only cleared under the instance lock of that netdev, and the free
>>> +	 * takes it before erasing the binding, so a binding found under @dev
>>> +	 * stays alive while the xarray lock is dropped.
>>> +	 */
>>> +	xa_lock(&net_devmem_dmabuf_bindings);
>>> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
>>> +		if (READ_ONCE(binding->dev) != dev)
>>> +			continue;
>>> +
>>> +		xa_unlock(&net_devmem_dmabuf_bindings);
>>> +		mutex_lock(&binding->lock);
>>> +		found = net_devmem_binding_mapped_to(binding, dma_dev);
>>> +		mutex_unlock(&binding->lock);
>>> +		xa_lock(&net_devmem_dmabuf_bindings);
>>
>> Sorry, my cache is already empty after c4466d2c3e77.. I wonder if it would
>> be easier to change kfree(binding) to kfree_rcu(binding, ...) and then
>> we can rcu_lock/xa_for_each here without xa_lock/mutex? All we care is our
>> netdev bindings, and these are not being changed as long as we
>> hold the instance lock (but the other ones are now concurrently freed,
>> hence rcu so we can safely do READ_ONCE on the binding)..
>>
>> And then the same applies to path 11?
>>
>> (trying to keep all the complexity in net_devmem_dev_unregister)
> Done. Will be part of v3. Code does look cleaner now for both patches.
> Thanks for the suggestion!
> 

pw-bot: cr


