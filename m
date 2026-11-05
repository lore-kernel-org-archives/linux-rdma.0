Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793901009;
	b=ybj6DXKpAuwfsw2oXOQ9eR63ZnkJ9Q9q663J/poYUYq8oT2qEqnp6DTnQ0RriVjoOym5
	 H2bTOH4Nl8uYBm9DMN2GarK1WjBD9ht1+YYlngt6luqNt0Z0ChY0xzJFNWIpSd2yONif1
	 mGAcF/s7S/dce3sHHYHkV5CI3631PrGJlSkqFH74VIDXshx/EmEyDxLsojMOR5BjaqLyA
	 VBG9FnH4fjrrYk9lhKU2I5hmSUS+Q6XLgNXuSUv8XrFmANpnJK+HCAHLVmTYlBxTv4+kd
	 dzvOW0aoCQhep2BCPIqoa2TkS2TSI1JwLe9aNQesQSaCMEAEG122eNEN8azC1wDeimA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901009;
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
	bh=eZnWirRlMHSgoXB/QOID12hIWlHPwcyU7qgwfHS5iWg=;
	b=5Yx7MO8re9Anmh3z3crCHAg1yFSGblkkDoVVV/T06gsVLE1ln8YzufgaPOZQ3gI4DrkK
	 dhaRNl26CV/4yX0BGr86VO0TpZ1KN+2N46/oY0svCkUGJrQGG7ohC6mRCgRiDP++zDDg0
	 y30jrbwjRz3vqRiI2kYrW5X4Ol+KJo01Ezg6BrJxLMb1wVIz6RU5ZBc3ZSM7bQn8ypNuc
	 YjKocCHo2M/IV1z7yayy91a8ajjtYJCNyvoFUvou27/OUdL791mHD6D1WS7r7T3N9HOxe
	 07xknQipIllfjov6uC6J9U5DNovuJNNcP60Lx5SOpIZMZLo4UoKqF94p9sTGSf6OhtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AA3Vki6s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.63
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC915606A330;
	Thu,  5 Nov 2026 17:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC915606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AA3Vki6s
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQljh2JRAZyyBBJjd3R0gEuwy2bQdxd6SzWoAgVVdOsr1nVPZBCWebq9zvY8LY52JcYVSH6B6ciGju8dDwau4/91W76qNqsNis+PC2j3eIjkk59228VOYdFE5kEjEC6dvTZR45emYNUeoy42VDy002r4R/+iaczCTe4LfEMx83LdoacK8U3o5Aa7030ybfj76HMlti4tOxTEr9zRUvKIGf6NU/8m3DfoJvxZJKB1peL0otr0xWpbXrnBRdJ6mGiZusBDbFSS6BOl9s6uN1U5dfqvKCeN+JFNi7FK10D1eEOrp6ZA9wXW1BEqra+fGfqWU/R3eslJH2v5FbF3YrmWJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZnWirRlMHSgoXB/QOID12hIWlHPwcyU7qgwfHS5iWg=;
 b=XnuKDJS9XaXzHGwiYf/Yqf2mcIwmij0PijVO8MC+nWdk1Te0iHyPdpR838BTsMMOZlBMYqyAZQWmWEglOtNv7J9EriOrXffSnJNIJcKwuvs9z/jcwsCSMseJkZORQFWbSCZGSZzDgp353cknVxrmsN5bmZvT1IkFXQxKsDh8IZYi13Y9kM5v60TFdI746+4Fe3aBeOtbZMfwuOB3Vo4bzhSFoStcpgQrMtQPpdPoGoskRaOKXj/XiQCN7LNTQT2o6Olac52vkH31lzNwF4E8toAsusRqdE+yLKgsNHehaymxrFZ//7ZvcYFwFF950tjNxgT9nUXG2z5NoLX+Zg/dDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZnWirRlMHSgoXB/QOID12hIWlHPwcyU7qgwfHS5iWg=;
 b=AA3Vki6s7mifgwcM0qDpICWIFhSzLErsbm9ANrGXG53zKYzMxXGshP1Ejp/YnPvsZI/2BXHqsdoVUfsvkI5uzmwrXwzQYigheN+Jos+RW2Dbu5aLqaz7fTMFPwfisgC2iQZ68wlzZRAlzdLFdyP5LXCHYaJ+ClZTD5bMOHUz9EZEs4AmKPVN/Dv0F1nX/4dzVBcsmRaqpH+xpQAyl/Zg/xNpXye5kdoP6YzIt676kRajeuF88cOn6NXMEUDNJHV0CSN6K8uBlSsazB5uCa6eEMDMONqAqhRe6UW58ujm44wdEcc0BpNZZC4xv9nLbgbTRFV6sZoFC/A9ObIInd+/YQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by IA1PR12MB8520.namprd12.prod.outlook.com
 (2603:10b6:208:44d::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 17:49:38 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 17:49:37 +0000
Message-ID: <c27e8ceb-c0d6-4801-a53b-837545dc51f6@nvidia.com>
Date: Thu, 5 Nov 2026 19:49:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v1] net/mlx5e: kTLS, Fix missing error unwind when
 enabling RX offload
To: Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>,
 Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 mbloch@nvidia.com, borisp@nvidia.com, witu@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
 <20261029134019.GG257209@horms.kernel.org>
 <53ba3677-af71-4d8e-b445-39e08eea8b2d@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <53ba3677-af71-4d8e-b445-39e08eea8b2d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::13) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1610b7-ae2c-406f-dee7-08df3b652924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|6133799003|10067099003|4143699003|261026140227099003|11063799006|261026121527099003|261102123227099003|261028144727099003|261021123027099003|261021135927099003|56012099006|261022105027099003|261022075727099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	oifzpk3JiaJWWRYeN0+zkX6UpQ1sQ+BgxQAG0jCuZB+AHZG1f6yg4WVgbLfPCmaACUD5UTn7RUGk/MbGDbS4ZEYDuLbPz7FzDuoEp2sjOpycr4uGKgHe9ILFcWygyD8UfqZ1bT7YUaCkWbTfWfmm6McMMEGjG9ABJCn7ls9a1Uj0x+URQyHziB/P9iIggPJ+KS2OMWRk9Nfy5KjqKX1Bp/2kQW5ie4ZfH9Ap9dOS6SQqBLTejct+wrtEKe4hchUnxY4v2LYyQM2j9CzwRz08tHWBbUkTOqKFrXjryhQCxpCY8SynO/TIOI0dDCVGw1aZjSspeUrbFqneur8aJ3mXalHzkcJm4VXqaD5CgTB8KdKLf4NuPqFqePzArsHOiCcE1/Xwu7BCqbkCDTZ9oOSj94bhVU0p+iH312c/7RDWv/LCnvvSujKNfIHSfbonVF1Hn412uLrA1DshSZWUzjXhYHJ8nsj3xr85buVLU3nCBBWZJ6YMgY0+sE6X2B0Kgo5uG58B+PEZ1Zue/vSMNnduz3+M3H03zXrjLyQDw1GqCiS9LGepU/wtmUVw5i2NRzbKKjg9Wq6kSeknltZMaWhGuUp3U8UdEPWFYOgBajKGURkh9nlAyW2C8K4rLkU5gsBCFxvcYquVYpdmCqc2VoaeFDvpOL1l9FFldED2Dwv7NHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(6133799003)(10067099003)(4143699003)(261026140227099003)(11063799006)(261026121527099003)(261102123227099003)(261028144727099003)(261021123027099003)(261021135927099003)(56012099006)(261022105027099003)(261022075727099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEdtZ3BiYUZ3T3BuTzlCblhMWGxWQldZZ1dnOG5NOVRWNklnYmU3TWRPY04y?=
 =?utf-8?B?bWlSRllIcllSaU1sUDloamJsZ0tTVnp5VktIRDRHWlgxeW16MUh6WVRkM1hX?=
 =?utf-8?B?NlJEd1V0eU1JMHNTeGJnWndsSXptVkQ0UDg0MFk4eWVCVStHam11VHd5Q1ZL?=
 =?utf-8?B?c2tkWmVHY3BjZEhOKy9UMkhNc3h3eHlUWGNZU0dlcXNmN2RIaWpMS2h0SkFx?=
 =?utf-8?B?SWxEMEpNVXcxc2w5WGdCSHhVK2hSYmY4TFFOOGNQbkE0N3JsYjNBeG1Id3ln?=
 =?utf-8?B?TnZTVU5rTFFEZXJQTXZZWjBtUlZwczRxdS9vTmpwMUhQUVVtd2VSQ1lGd29k?=
 =?utf-8?B?RytHRVZUYzVVQi9CYlZCMkRnSHo3Sk04NnJPVjRXQnkrMU16UlVYOTBJZVVu?=
 =?utf-8?B?aHpFcXpSNFpOYVc1RE1qcGVycXBSVkxqZUNxZUJxMnpsN2NBREZxa05NazdB?=
 =?utf-8?B?YmNkWEsrUDZicm0vNHJlVzdFWmVEWWxkZDRQWmY2QllSRDQvUEJXRjVDSHRw?=
 =?utf-8?B?OGlVOWRoMWV5aW5mbVVqdVNXSUZwYlBnMVV3SjRUQXpRVmVnaFdXU2dZYXdi?=
 =?utf-8?B?djBieTJUczZDdDl2NjZKYmF6R2RtR2tNRi9YTDdkNFFtais0b01BL2dhRkth?=
 =?utf-8?B?aHZIWkd3cEZUTFhabHNTeFVzdVA4Y3ZsVVFCNGplMWVnTmZQN0Z3aU45eXl2?=
 =?utf-8?B?a1lmaXN3akg2OWlPcVlCRmlUeXJUTStzWWxpSGpETEhKN0x3YUxUT2xpcW0x?=
 =?utf-8?B?Slh3Q1NKSWZhQU9MeGRjVzkxK094b0NRNyt2QU5uVE5qREdCOExZN2kzTEpx?=
 =?utf-8?B?UU1XTkx0UFA3dkRxVWpBSGxESGdpdndtWHdDU0I4WDRucHBNSVhIeGQxdXd3?=
 =?utf-8?B?Z2dMZm9YYlBJN0NFVU5EVVlGNDE5REFVMlhlay9nOEFuMHVPSldURkk0d0Zi?=
 =?utf-8?B?TnUxS3Ywb25nSjQxZTlBMlRsYUZ4bVZranZLZmJ0Ni9tUEdOSVJJcVZWeEtZ?=
 =?utf-8?B?Nnl6aGcva0d3SjEzSHdSKzk2MU1rdFc5dEFJNkN1MEJEOUFXZTZ3Z3VyS1JW?=
 =?utf-8?B?NUoxSGE0SkZjRC92QU5hZ3c2YkJxbmFVT0ErcGdjaE00aCtiRG14V0haWTBk?=
 =?utf-8?B?bmJ5ZjVLRDJPMUJjOTlxOTJvRDErdHZPWkhrVzNmbDArSnlkSng3bFcrdEhN?=
 =?utf-8?B?L08rTDE5YUtWckQ1NTlvRHJ2R3R2WVUycHo3ZzRpNkFCbHVCZzVXbk5XQy9O?=
 =?utf-8?B?TEt1MFV4VXlqMXV4N0FtYmRLK3NqVU1WUVlydUdvSkppa2F4d2IwVHFLRDQ5?=
 =?utf-8?B?Ums0L1k0UXh6L2xJQVg1TXowM0twR3M0WE5jWlkrM2tTQUZla1ppcFh6ZjB0?=
 =?utf-8?B?L296elhQeThKK0lJbGtCRjh4c0pIM2lUS1I1UDZNL2xTUXB5bVlCeFIramFN?=
 =?utf-8?B?R0xUb3dxZEJsSHd0RFg2azJRRjBmVjM2aHV3OCtXUExnbjJLS3R5NGJoRWtG?=
 =?utf-8?B?TTUzTHZGUktnWTRQMC9MSGxqOVhPNkRKLytwTlYyTjJRNUhDb1lwaUJvNEtP?=
 =?utf-8?B?ZTdkOXlCeDdrdVdWQS82STVmbEE5WFVvcnZFaERWSTBJQ0ZCZm9tV3k4dDdh?=
 =?utf-8?B?UGJYOWw5S3pML1YxWDZ2a0VEKzNVejdzcWNKN2lzdno5bk4ySkNlR3p1bHpM?=
 =?utf-8?B?eGZYb1kxdEJoZDlmaldJQVRXQ1NXTjAyN1pSUTRmdUVJQm5qd1h2ZzBMVTJI?=
 =?utf-8?B?OWk1SDVTUUFpeGdOSjI5U0M1dzVVekZvcFpuMU10dG5IWFdQOXNsYnlZZTdO?=
 =?utf-8?B?RnEwV0h3MVJPYnZSRFhtZmF2KzRucXZvVGpMeGVmSVlSTERPK2hsNUVNbys0?=
 =?utf-8?B?dVZqMkhTd0pzeDFqb2QzWEt3TzlTVW03WE9BQnQyQmVrTWRMYUJ2YUpNbUE4?=
 =?utf-8?B?WEtTZE5XTTZtUTZadklQYmhuaTF0bmY4aGhzemN1TkpXK2oyblVBUE9ZSTNU?=
 =?utf-8?B?VkRXNkJhNG0wNUxyL0ZUbDJKdG5nSUMxdHh5UTkrQStyaDZXU09Xd2ROL3Fo?=
 =?utf-8?B?bWRtdkU2Q3lyRk5pemtzVjl4VEl1TTN6UHZrMjJudkZ4YzRFc0NtQlg5Sngy?=
 =?utf-8?B?T2pPN0x3MGg2TUlTS2g4SW9PV1RpME5RUU1mWDNDNjM2bHhWajF3U1dMSHJZ?=
 =?utf-8?B?UC9KSTRPamlJKzIyNlo4REN4OWhLUCtlU25RaHdUa2lhVmRXNk00bFhMckpX?=
 =?utf-8?B?bk81b2VMNEJxUytKc2ZHRkxjUE5OZ0h2cjJBY3Z2cXZmajRWTDFqYURMaGdy?=
 =?utf-8?B?Q0xrbmR1azVlRGlQUjhlVS8zcG1GVlpHTi9QYmp2L1B6SWR4Vm0yQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1610b7-ae2c-406f-dee7-08df3b652924
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 17:49:37.8814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTtL21gBF3vw6PEscn7oxS2v0P/PXHwUfYCuFqXRH6ljR40lwyVO+jwhX8rYsRUBNtlQ68Y22gvmNOUtbZOzow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520



On 01/11/2026 12:41, Tariq Toukan wrote:
> 
> 
> On 29/10/2026 15:40, Simon Horman wrote:
>> On Mon, Oct 26, 2026 at 06:53:46PM +0900, Xuanqiang Luo wrote:
>>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>>
>>> Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
>>> ICOSQ"), the async ICOSQ is only created when an XDP program is attached
>>> or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
>>> the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
>>> the channels so that they get the queue, but it ignores the return value
>>> of mlx5e_safe_reopen_channels().
>>>
>>> If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
>>> which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
>>> enabled. The next offloaded RX connection then dereferences the NULL
>>> c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
>>> not help, as the flag is already set and the reopen is skipped.
>>>
>>> Propagate the error, clear the flag and destroy the accel TCP flow
>>> tables again, so that the feature stays disabled and the next attempt
>>> retries the reopen.
>>>
>>> Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
>>> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>> ---
>>> Found by code inspection while backporting commit abed42f9cd80 to a
>>> downstream kernel. I do not have a crypto-enabled ConnectX NIC, so the
>>> failure has not been reproduced and the fix is only compile-tested.
>>>
>>> The crash itself is the one described in the changelog of abed42f9cd80
>>> ("async ICOSQ allocation is not triggered, causing a NULL pointer
>>> crash"). This patch only covers the case where the reopen that should
>>> create the queue fails. ktls.c is also the only caller that ignores the
>>> return value of mlx5e_safe_reopen_channels(); the callers in health.c
>>> and reporter_tx.c check it.
>>>
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> I agree that a minimal approach to addressing this problem is appropriate
>> for net.
>>
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> 
>> Reviewed-by: Simon Horman <horms@kernel.org>
>>
>> However, I do think the logic of this function is becoming somewhat
>> convoluted and would benefit from:
>>
>> 1. Handling error paths in conditionals while leaving
>>     the main thread of execution unconditional.
>>
>> 2. Use goto for unwind.
>>
>> This is approach is complicated by the function needing to
>> handle the enable condition. But at any rate, maybe a follow-up patch 
>> do do
>> something like this would be worthwhile?
>>
> 
> Agree.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> index 3cc1213c2f68..0f5dcd1b822e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
>> @@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device 
>> *netdev, bool enable)
>>       mutex_lock(&priv->state_lock);
>>       if (enable) {
>>           err = mlx5e_accel_fs_tcp_create(priv->fs);
>> -        if (!err && !priv->ktls_rx_was_enabled) {
>> -            priv->ktls_rx_was_enabled = true;
>> -            err = mlx5e_safe_reopen_channels(priv);
>> -            if (err) {
>> -                priv->ktls_rx_was_enabled = false;
>> -                mlx5e_accel_fs_tcp_destroy(priv->fs);
>> -            }
>> +        if (err || priv->ktls_rx_was_enabled)
>> +            goto out_unlock;
>> +
>> +        priv->ktls_rx_was_enabled = true;
>> +        err = mlx5e_safe_reopen_channels(priv);
>> +        if (err) {
>> +            priv->ktls_rx_was_enabled = false;
>> +            enable = false;
>>           }
>> -    } else {
>> -        mlx5e_accel_fs_tcp_destroy(priv->fs);
>>       }
>> -    mutex_unlock(&priv->state_lock);
>> +    if (!enable)
>> +        mlx5e_accel_fs_tcp_destroy(priv->fs);
>> +
>> +out_unlock:
>> +    mutex_unlock(&priv->state_lock);
>>       return err;
>>   }
>>
>> ...
> 
> Makes sense.

Seems that we need a resend here.
Let me know if you want me to do that.
