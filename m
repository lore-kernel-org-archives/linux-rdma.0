Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795436473;
	b=nZcQsjXx7+jF199c+icKc6OHaOipSzKMUAYBSeHlnK5qg5CxLWeNLc9ZQ+Lou3pw3Bt4
	 28EnjsQ6AcwmHg52GQlK3O7PKjko3CufFIG6dcHY1I5GZaKGrfkNXFtd3PCSOU7AI70eo
	 wwxov5AR4/XRD3LWughFO1rhIhc0dahW+4C5FOjn/m+3aQQA+KCMtcGmGa/m4Osk/pWV5
	 8F/zeyoIJ6SZ5o+pspsuuqkq/DTGbmHyOMeOBiQCyBGrPf21DPKUv0kylkLnegvZGt4Ii
	 XoTb12J9snI1+Ruq3rZlCpHfmEm1i7tFHmhWvbLT5R4urnMu5ayhsiuqZAlunR5dlDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436473;
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
	bh=/R0EYUJV5shC2J03W852ECBTKKBoRd1QuRFxKiDuC/8=;
	b=hMpM5THJl138wzofLAaZLRxWZqigkbbVUJJFE2Glas2lJ8T/NaDxJowYm7FxpkbBruIR
	 sJemIUGXT/A+EMykKFRISoUZzkwb2dsBbXqGk6qVOc/5LRPU7Ohe7bJkZi4O8TYKAZsI8
	 /lmsGhsQl+EoZjQ87k+71zUO7H9/5Wze+P5CzTsrdadG+qvrpmnsKxNCQiIgUO8cE/ohb
	 BYVjjsfDf/cH1V6Vh6qVFmgfUqLZYULx9ydEg7+ZSet4NE4boW12cFBnQcsAFdRkmWOHQ
	 M1Wcqa1V2i6X8ZtrpztrZjKyLcqSAj9GFIRLRhSZCTkl5Uzw46NW4MsWhy7CA0fvIjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GY62tSch;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.6
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012006.outbound.protection.outlook.com [52.101.43.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD1606A31A;
	Mon, 23 Nov 2026 12:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49FD1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GY62tSch
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hqJgAX/IZdHOZqoi9Msm8UcsCbK3d/3EHyUTfMHTDuDmmKrUZQpeDVZkr0vG6ssKIh2M6oIGoCn5ykm7gxHvRykQF09BOu2WA/Jk4XWbdSeUprT/+C5Vz6LeNQK+dxCaILMWU+Ti1mOrCV4PjCqldtwKpAMn6WLWKnFOhra+Nu6YpGsJhEjrRwOrA/Vqy2Re9ohnpk+nk82lDgYEDS5lidYQTG+zAETNfyLP6ztAItXODciOxmHDu1DscmabbyHqjqCj7rqnzD2tZxRsl7QtRFadVk4iGEa7nzSOvMVGpji/rq4i6hfOVutrsHogLEkJYd0pO5zs23KPNQ3BYP23Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R0EYUJV5shC2J03W852ECBTKKBoRd1QuRFxKiDuC/8=;
 b=KIQsB2GJsJZiUBUeLaxJnyNTsz5qjlDc6nbtnMG8wC003Ipt0lwddsms71sRKFDFc429aR9YiGqkc04G8SF56V/EyUwkol4UnrvxSN1beg6JDQaocUvbeMJ/sYuz2kJMVTlHira2K36QG80kt0EQeG/sduSq9+DyVM0T34zvjjPOmImnkslg4Qe5iR+hbiTyqN8ze/CtLfvmZ6Khtl6SVbQTkDTWBArgMrf5zw4LGCvo84FfyWH4gtwT5TQBAhH71lAuvU99RsQgXPyG4IVXIgn1eeKNhWqiiOUoyMI9gp/7uvObKZj6tT2OxPxknX5k7ptwbXdvDdCugwyybfO1IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/R0EYUJV5shC2J03W852ECBTKKBoRd1QuRFxKiDuC/8=;
 b=GY62tSchfS60zBGYpEkUYSHbFwoVQnr6f7GbMN5Plvp8yvMafh4aAVWzp8PqcXHhpNtLbVIRrhwxdxsZ2BbMi6XCz0ykKY5qUm/Bi+DWndgqGysPkz1wYcpfN6gzAvRPdac1qRHWgGz2/t0+IKxfi36GAJjn/+YjQ5t9P7WBfExuE7jM/4duuBmfZDhkv7q8rllpzl3kzYYi6VNAPF/kTlJaxLCG+lZVZVhaswxh5642yrJRcWYR+xTJIIrS5uOtfA5TP/iOjkSbK+ORwa3kEUjqRiGf+94ImuyDXOlg5CFxPGH5neXY8FcbvP33+inTawrBiRDLcpXmOC34IJhSeg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by SN7PR12MB7202.namprd12.prod.outlook.com (2603:10b6:806:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 23 Nov
 2026 12:21:08 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 12:21:08 +0000
Message-ID: <c136c508-ed03-4679-b7b4-f8fd89859ae0@nvidia.com>
Date: Mon, 23 Nov 2026 14:21:02 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5: fix a stack over-read in the QP debugfs
To: Aibing Chen <chenaibing@cmss.chinamobile.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0011.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::14) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|SN7PR12MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 00953cce-458d-41fb-8c6a-08df495c4097
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|22082099003|18002099003|261009223027099003|3023799007|261026140227099003|261026121527099003|56012099006|11063799006|261028144727099003|261021121427099003|261021123027099003|261022075727099003|261022105027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	7AHxL4lgv72TCq2bfHQOuNRxKtmg5RJRBnLROKFVp93Apaxx3eXjyborha0WpYX/ly/aDW8tlbFaig2V9ALatGCuVHnXweNfy5643cYBp0Y7Zwl8v5ahK/GjrDJ/Zsm9ZtZgAHJgL3TAxxPHGsCmB1VkMddVEyGXCGfB73v0gKLJ4UjnSb84dElf8UxvCEFyy+vlNkTvpYT5kWtMAHeCunnIbOrl8y1kTZ35xc2ttrdF45nePwHTOGnUFf3W8IM15Gssyw5GXXevynDdb26j1s8nzz8EhBTMA5W2zav4+LkymUwsLaNbH0+anYocqcK1sXcW7fWK+rcZTaEDt1PeQAPjlg7ZrcUkPJFzazPxMZfBUg7OEqDr6Irb4VNTQHjHNkTCZkrcNmAss1ETK4x3jG4N+kRswbxprWaIo7UCIAqEIgTKz1N7NQiNioxs7unGhrlAJuqW+tIVQ935iBmIeUE0KpuyJzCWnWgmHRltEThJ33xpe1eUSVgbUlQKQyPW84FqjIBxhLZ9Aj8LhK5dmWAGgU5bWTnEwkdvd7J+U0QwaBOr2GiIRV0O2/Q7Bqo1/fxlThbJs2Cr4WZpLB+pb3lrx1/9NVA9fw4b9fTLX3IdI88OSMkbxu9/xjHPDxvCefW8vIh5kLXGHp/7Typp7vbFk0BSTouUUsCkwponqHs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(22082099003)(18002099003)(261009223027099003)(3023799007)(261026140227099003)(261026121527099003)(56012099006)(11063799006)(261028144727099003)(261021121427099003)(261021123027099003)(261022075727099003)(261022105027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGh1R05mSFlMc0I1UGxtd25LYjBkWmE3YXdMZTJMU1JUUmFLd2txMUk0STNz?=
 =?utf-8?B?NWJxcllQeFlkMlp5TnoxNEY2Q2NUcmNUZ2Z2cjMyMkgrRXB6QXJCdkZDdk5U?=
 =?utf-8?B?cVZJNy8zdDNEdzN4Q2lmWStOR1NINFM3NjZiRllGTTZFWTljMzFNNnd0VEJZ?=
 =?utf-8?B?S0duNFcraDhGS2hncGVKR1VKRzM5ZTNJMFAwaFVzUW1Ud3huNUs4cGRRSmhP?=
 =?utf-8?B?S2FsMHBITkdvSjNRTC85aHA0UlJGTmMrdlFtYTB1WkZRT002YnhvVUFyZzR3?=
 =?utf-8?B?TWRLd3hFWE1mRllkS3dBY3huTWpPS1VDVEpiMm52UzZob0FVTWVwSVJ2UW0y?=
 =?utf-8?B?OUcxNFByaWNmQnFPUGd1T0Y1Y1F4Zm1Kczc0WjluRmVTWWpoSCtpM0ZpbTRE?=
 =?utf-8?B?cFBJWURHOWdCLy9Pc2szWEhMb1NoWCtzdnYwSFExRVpxSTFpYlY3OUl0SDNw?=
 =?utf-8?B?dklYV0RtSTFPZGtTVWsxZVdrQ1o2TGJtZTBtWmRWbnZEVnBrcE1FWjBWRzl6?=
 =?utf-8?B?dzRYUHlOQnU3MkplTktFRnYxMWpoaytDaCtDYStEUjNTOU1JZHVnRFF3U0dF?=
 =?utf-8?B?MlNqaCt3MHN2QVMzSUF0OWttSUZzWkU4QVYrWTVFOHFUMFdhL3N2UFFOSzF3?=
 =?utf-8?B?SEFBR3F6NnAxOS9FRG1TV2hOaENXaHpJR0Jyd3RVZi9sVDNHN0VXOHpuZGoz?=
 =?utf-8?B?RWN3dk55OSsxK29lTjI3WVpoeXYyUkZnNmpJOUk3RzBXanNaMVlDUXc5SVhP?=
 =?utf-8?B?d0pYZE1RVGxIT0dQeTY3bWhiN3ZFNFhHSXpYTWpqNlBWNVR4dGFuYUltd1Na?=
 =?utf-8?B?eTZib2FPWU9tc1MxUktsN24rWmlPMVpMWUxpeDVGaXovbkxydWdBWTM0Wnp2?=
 =?utf-8?B?L0RRRHJ6QVFaMy95UGxDUG4vb1VQUHBDYitoQjJHaGcySXh2YmdLNi9LejFG?=
 =?utf-8?B?TG91UWtDQlZYOVFYSVZqTm1MNWtyL0tzdjhaemdteUNuUUlmcVdGR25DY3R5?=
 =?utf-8?B?VmhSSDZsTTdYbTFSbVFuc0VFc2JidTg1N1FVWlVLUFhDalcwWjV2V3l4RnR0?=
 =?utf-8?B?cXNVc0VCS2YvZE04L1R2WnllTnl2ZHpyeXNCaUs0TGVWSk5ITHVWVFZyb050?=
 =?utf-8?B?OXN5YTU3UXhyWU9SS1hOY2s3WnJCWEpRQmZKWGpOSTZhRURHU3R2RGNCcXJL?=
 =?utf-8?B?RFBQYjZkejRyeGI5MStyRFRKSWN3dm9JWmVkQVdKYzVTd1FrZ25tcERsdGdz?=
 =?utf-8?B?M1N3SExJeWVtWlRReVA4NjBBRXlMNE9TMjdEd0t1TFZ4ZGZLQ2xMYlhaU0VQ?=
 =?utf-8?B?VmM5UGNRUUNoRm14dnhtNFhSN3huYm9wNFV1NjlhNkRPWFdpTytINFcvWFF3?=
 =?utf-8?B?Z1JYbm1TenNsNndhcWloMFhxWVhLOS9WL2tFekdLT04zZ0VuSkJSUHVZc3Z5?=
 =?utf-8?B?cGpqYWNPb1k1SjI0MkZPeXVxQnh1dE41QUhlTXBHU1REZlRXcm5XUUtSR3pv?=
 =?utf-8?B?WmZoTlNSU3F5NERjOVVncDdMV3NZeTJOdUF2R0V3V1QyUVhnSEg3L2U3alF3?=
 =?utf-8?B?QkxBK2lhbmNxaDM5ZEx0Zi9jK0krZFMwV0gyUllXaE16L0drN3dHSVRsc1lS?=
 =?utf-8?B?alhIMnF5T09zV3JlbDhGenUySlJBVThWNUxYaUdFUEgvSWhna0FjY1pPRy9v?=
 =?utf-8?B?SjRyVUxIU29vZE8vblZCTSt1Nk8vdm5MMFJwbFF0b2ZEdk4vUFZvc1ZxMWZq?=
 =?utf-8?B?aHJDSFlkQ1BsTUZweGZTRVk5cjJWVmxQTDUzRlR6VFg3TXR6K3doRE0xb2ZH?=
 =?utf-8?B?UG9mclpLRWI5SnRXdEo5cFRSOXovN2xKUlk3eXJhcXBxM004bnl3VUdYT3F3?=
 =?utf-8?B?SkxhRkRxZmdCZkdoQlI1WHN4U3ZKeFg0elVsUlVPM3JScE15aFFpT2hWb1ZY?=
 =?utf-8?B?eEpFelRIVUh5aTh1Y3JJOWxnT2s4K0NITW8xbzBOeWUxU25TeXQxNlV3ZWlz?=
 =?utf-8?B?WWtrTXhTakp1dDl4MFhZQnJJY29vc3RqZVN5cW9KR2FPUFRKZi9jejVtbmY2?=
 =?utf-8?B?OHliRHJVZlVtUTRHTXNZZ0ZxaG51eUlzZ3lOVnpaOHU4M3pPOXMyWTRrc1VI?=
 =?utf-8?B?Ukdpblpja0FzN0Nuak9mOHVXbmNsK2NFQ0Vaa09pVCttRWR4OWFMQW1wMWMw?=
 =?utf-8?B?N1VNVTVjUXFJdVA3Y25WQTVFUE1hZktkdkR5SXRuVkZ6TG5vV21mRVAyZDJS?=
 =?utf-8?B?cWcyRHVRVnVsK3BnYVlwMHZVSkVsb1l2ZTJmMTJKa1g5cWZZUUZpYW40Sk9T?=
 =?utf-8?B?ckFBV1NieEl5ejVVUS9kZVBUaGxLQllyd0hUTUtvUXJaVGhHcmxoQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00953cce-458d-41fb-8c6a-08df495c4097
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 12:21:08.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNWmKFwqSzVURbKqxdMG2j50BhvsZkDEqSEhzkTd2+Kts02O5XQF2aZfrcaYVUtXUAw1h1eu12Ca2DbsnEe8VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7202



On 22/11/2026 16:51, Aibing Chen wrote:
> dbg_read() formats the field into char tbuf[18] and passes the return
> value of snprintf() to simple_read_from_buffer() as the number of
> available bytes.  snprintf() returns the length the output would have
> had, not the number of bytes written, so when the string does not fit
> that value is larger than the buffer: the longest QP transport string is
> "Invalid transport type" (22 characters), so with the trailing newline
> the function returns 23 while only 18 bytes were written.
> 
> simple_read_from_buffer() uses that length to bound the copy to
> userspace, so reading .../qp/<qpn>/transport copies up to 23 bytes out of
> the 18 byte stack array, leaking 5 bytes of stack.
> 
> Enlarge the buffer so the longest string fits and use scnprintf(), which
> returns the number of bytes actually written.
> 
> Fixes: db81a5c374b5 ("mlx5_core: Improve debugfs readability")
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>

Acked-by: Mark Bloch <mbloch@nvidia.com>

> ---
> v2:
> - add the Fixes tag for the commit that introduced the tbuf/is_str
>   formatting, as suggested in the review.
> 
>  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> index 30be2b631..3e75f66f7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> @@ -496,7 +496,7 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
>  {
>  	struct mlx5_field_desc *desc;
>  	struct mlx5_rsc_debug *d;
> -	char tbuf[18];
> +	char tbuf[24];
>  	int is_str = 0;
>  	u64 field;
>  	int ret;
> @@ -522,9 +522,10 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
>  	}
>  
>  	if (is_str)
> -		ret = snprintf(tbuf, sizeof(tbuf), "%s\n", (const char *)(unsigned long)field);
> +		ret = scnprintf(tbuf, sizeof(tbuf), "%s\n",
> +				(const char *)(unsigned long)field);
>  	else
> -		ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
> +		ret = scnprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
>  
>  	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
>  }
> 
> 
> 

