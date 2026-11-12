Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794485029;
	b=uIK5GHMzGs3sqZw8HdZ7CKNqqRuZrWOYOe4YieHxnAQxKDxcqzKrZUFzBXELC5/X5CFi
	 ytAPOOYwHFnyVcUqD0bEQXxsatub9H1UmDM8vSznoKzDak+sKZJ8xrj71RIMJ7JHOuYNT
	 Au44skf/zlix51AZ/BPdqEwlhFV0ANMEhgI/dkWoxIKLo59oixAf9PugA+g5SkB/PiGrA
	 nzU7ffONkkjzhh/nhtLL1Bb5gicey4o5Ibhgsoh8pef4Bbg1gLQ8660GCNZ1NZZCHsJiI
	 +QTlpqp7DYYo7CSRATi5fL/I2PBrUC228E3WGBLdw5mYRZ5PFsL/LmQUgLXlm+N0asg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794485029;
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
	bh=L9q9+InKtS0Cqi4coaE9qIKMVwRwm6EB5ikDwX3yRFg=;
	b=lgvvKaOBHvqNJ9WfoN20V8/Vhdmk4OErbddD7DY9wOVm+yuaI73ALuZT6N/ezZQ5W/fF
	 Jp8P4PEFBjKsQzbF16bmh4tointXst3Tae6LkykvRW3AhewbOoysCqbQPtIxFLMJQlLVs
	 7o+13C4fZKemsBg0GOon6UkEBK1o5EH+OrbvOOEGtSxDqo750V6I34yrkACRDBNT2Kc/P
	 xc/uFfVl9u5/e9GIWuV1TibL6XbcuRefF2tQV28Acr4VGtn8Yu7u5AnEaHXx7s6mBUsuj
	 Iuovy8q223MG8hxtcnFSNOdkoNcZJvVzGhuQS3ODzBGPw1WpoUNMBp8haMAFXbUFP2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aIj8uFI9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.14
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCC2606A31C;
	Thu, 12 Nov 2026 12:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BCC2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aIj8uFI9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZefj1J0DOIcSnkdZIImRARIxUX47x5XOPgtvtt1mphkNi/XAyO3kY38Wiyy5TAqtvGzk/v9VJKGOuSo8XWTreyc6Tm7JkXny1UHufYeSOgddrcw2YDny+/4941FogqHPRuACTFhqc4E3JhiqvL1P2q/L5oedgIwoK9XNlj+bfe5tcsTOuhqS7FB7rSJuywUfjRGxMHibs+bRybWWF6MubckFe13vyLO8bt1Gk+mzlzoxxIatJp7K2eeSx95/bVas08LNiXDawgDnf1lYNHPhtVyhUaaQMvjI/xXukrvzERtOr3oS++CH0MyGr7saY3i++vxMy46rivmfCOZlCwYSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9q9+InKtS0Cqi4coaE9qIKMVwRwm6EB5ikDwX3yRFg=;
 b=ySMKypiSBKc02VTRfKjKTi9Beukzjmry/np7Ch6ssdBI9nfFxDwZgWtgeFmgMFsx87ZeC594nCMaerCnvyd1e75wbxareWjV1/Eb5tAPIg2RvIsA0cp4EJ96UVFJmNUuDMU8xKpwDn1Va4ZFkoL5+ozqe+TlIxuuxR3Gs2kpqmJnveg7wvKLM0jDa3S0LAqNoI5yCzg5eFZql+ZakKPlgabfppz1Xp5SVn6/Wg+aHBEJWeDqTzVB0Zk4LwBYDV+cXzhDBKWzxjpslzo+X5Gj5weegfN7etzJBV+iJf5ZT/SeMCYu2uFyKwAebiDVc6i4AsInkkQaPTk4nn4KnAKdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9q9+InKtS0Cqi4coaE9qIKMVwRwm6EB5ikDwX3yRFg=;
 b=aIj8uFI9ioVoFVk8zC8DTc4aEpuCmHGojzgYFg/NH0cVKxN64CZAGityofoFFsQo0Cx7TfEipza9dBTqN+seV6Hi+x51WmlWAuHH38ZF4cDVFK0avuXh1gmANf+m0vHFdX5eZzzRWmcDDMC0hJyT0nXaoAUb11Az5sE51Mg+4iR13momoiFhZFhxHiZ/MWAwttWX8WW4GhKG93WdSgnZCaysR9d+z6zgh3ah5njWmVz1zVfKp2rYYPgF461LigxlonHJsxpw5p2jkh5sdkUdtq+hMQxYrt0Dhg1yU+Dbf/7ziUT2mr9U02jOWfJkQ6LxZ5Mmr16ruq/qR1T66Bpjmw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DM4PR12MB8498.namprd12.prod.outlook.com
 (2603:10b6:8:183::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 12:03:45 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.009; Thu, 12 Nov 2026
 12:03:43 +0000
Message-ID: <11a22831-1a10-4137-b0a3-7893c60c0042@nvidia.com>
Date: Thu, 12 Nov 2026 14:03:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ipsec v2 5/7] net/mlx5e: Use the packet sequence number
 for the IPsec IV
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Sabrina Dubroca <sd@queasysnail.net>
Cc: "David S. Miller" <davem@davemloft.net>,
 Boris Pismenny <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-6-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261108142652.1330952-6-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0020.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::7) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: b4bb8f9a-a621-4211-9a79-08df40b4ffa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|3023799007|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261026140227099003|261021123027099003|56012099006|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Yvnk8uk5e6fTHw4XjnutMr7cQYtT7g+QbWqiqMYEPvkQ7bJYYWhp3NSyZoHaak6t+7BxQTATGXRTv5c++xCkWUb7GZ7x76BtaHo5QOgnTtn2UNyLvESYz98ixv7cDmtAFJkNBsmPbH0OTJl21D+/HOcFOArrH2f2+oghAT0nIvQY+dke4Gl8nor+Ze2fZeTPMxZrhcMzmaK9eQ0lkcr4IrwAjFRWkSTRPerSw7Dayk6Bil0V9TgL8Yg+b5agUDIhPInGmZpE27zdb3Dh+IErU8OeMOa4xeQIRLiye5bDwr60HSB62MCNkv+nEZ8tnCo+yywYYjAvjGQVnunzEhq3/315Yv7h7DzKiW5u/y+KyZlXm8LgZdaXtH5QHBJ19bVRkSVX5v6jhPakTE9S8vTIeycdA3z9DFkWW9xeiXJXca5RiCURfdAXIr3l67du6597uAWtOYQDTqWfvcq1bNCauS4AhMmErgN9mWsW/2J8ufAQBwv2JAogqt2eYypqDACVtgNuKRcQ6eOEGv7WH3qFNScy/c4yGKitdE5VW1s3sl18kNMHMv/wuLW+/eH6vqkO1X1nbPSTXcM2zzFhrVVwlrFFaJOvoUJ8W+7+tWIuIJ95TFJqFQNM7LbQ6QvKmB4Af2SwR2ifQwXSsWtJ4SldGONa5p8pYp8UVYotAD7hHtg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(3023799007)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026140227099003)(261021123027099003)(56012099006)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1FqRzQzVGV6b09iY3BFOUNNY2FPbzFJMi9SMTNnak9qbitNbnV3bUtyMWcr?=
 =?utf-8?B?TXQ5Tk5zbU5NVjgxR2N1SVNnSUtodDN1UHVLSjkrTEdHK2x4d1JabzY5ZmpW?=
 =?utf-8?B?ZXFwQ2hPQU1SMmxtbERhazB4a1loOUVjYjVNRTNBN29raytNYmpDVUZDdnlk?=
 =?utf-8?B?c1V1TDhRbEZJRmtjNUhmZFBYOGxuZG1kRFdUVWFZRzFncm1BZnJOWStBZTZs?=
 =?utf-8?B?aTZ6V0FkUmNodGRJQk5DU21lc3d2d09aVzdscjBZRU91V21tUGlnNzFPeEpR?=
 =?utf-8?B?eHkxNWY1WDJOOVFKRDNSMWpOdDIrN3RpVkdBVmJaeFRZUmRhZjVqVnZQekJj?=
 =?utf-8?B?OTF4Y3RBOWRsdGZ6d0xuVm9KbUtDNnI2enBNQlhMelBWVWNOdmVqU0QwQitJ?=
 =?utf-8?B?dnpETDAyNXNBeU9SU0RkVzZBMzZrUjJRdC9qNTZ0RldVYjBlcFU3ZHJ2cGJR?=
 =?utf-8?B?TTUrYURGTzNPbExzdGVZTU85dW1ZUjJxNkhhTVBPN1JRMTFiZ1NhOXdTb3Zp?=
 =?utf-8?B?ZSs4ekd0eWk5dlJRWGFoOGV2MG03OWVzQnQ5RVBGQWhMQndvT3IyT3NqSm9P?=
 =?utf-8?B?THlhTG1xaUoyY0NadnBDU0lJRU5McUEvT0NUeEZ3aldSN2xLZlZ3V0RuRC9K?=
 =?utf-8?B?UVlYMnRuNjh1a0dBMjd5T0lWK1FNQ01FVm5LRmFhSFFBOHJHcGxIam1OZ1la?=
 =?utf-8?B?bThRamxNbU42ZGF1KzJOazhKSEJWSm9oRkh3N0dHMzZnZWNJMWFmYTcrck4z?=
 =?utf-8?B?RzFRVGN3UnlaY2pvMWlxK3F1Q0hNTnM1d25YdGxJV2djVW9Na2ExN0VSUW0w?=
 =?utf-8?B?TXZOZnFaYjVybGRDUXBqTEtkQ01wWnpVN1NJMUJsbW8xcGxBMlJhVEwrZ2hl?=
 =?utf-8?B?QkQ3K3pMSUFCZzVrN1Q4M3hJYS9yUlI4MzJ4b21yQWF2VDNMclhnYTZUSnR4?=
 =?utf-8?B?MStJTFVuMEc5bmtoaHBKeEZia25xOWlGQ0RVbFE1RjVFUlNnQUZYRDRpQmpK?=
 =?utf-8?B?K013N0lFNjgzT2tJMDZ4ZmRBd2lVNVVRV2N4MGFvQUpLb2wwUUI5S2FJa0xk?=
 =?utf-8?B?YmFqNk5lNWcrTXczaEZPbHlqMnJ1T3ZrQjZwZy9UZjZiQkRtVDYxTkVwZjdQ?=
 =?utf-8?B?UlVpZlFNNDRWZ3VFUFY0SWhUL2V3cUh2enFlQnB1Z21ZMU5VQ1E1Y3ZZNkQ3?=
 =?utf-8?B?RDByZC94ZWdlUmY2TGJXQ1hmVmhWbGJrVjREb3R3NTlqa2pNSFEwWXJQd2k3?=
 =?utf-8?B?QUhNWXM2UjZ3R1NRWVlrR0ZFVmM1Qk0rVHI1Q3piWGVYRmFUakk1UzZGVWtn?=
 =?utf-8?B?MXZkdUZMUERjR1I0OEs5OEI0Nm9LRUpuVUwzVHhVRlNxdmlRS2hLV1lHaEFa?=
 =?utf-8?B?R0ExU1NwbFRYQVBlN3F5T21KVGdRR080VjUrclhWNzN2M1BXb0RUVDk5WG14?=
 =?utf-8?B?d2tpMjVIOFBIazV4M05SbWpvaEJBVEJCT0ZBQ3JJbnJ0NWlma3JjRUh6bE9j?=
 =?utf-8?B?bDg4ekFxT01GaFA3UURqeXNmNENlcGhNa3Q4emdTMll1UXROZC9rZENyd3cr?=
 =?utf-8?B?ZWdpYllQMG1IQXFpelZtYURkNWNsa204UEtYRHhsd28vSXlYT1p3c2h1RGtq?=
 =?utf-8?B?Wlp3c2pBTmFjcVI0a0VTamdCT01kc3VhMEg2aUQ2OVFRL24waUtOenY2ODFV?=
 =?utf-8?B?aDZlZzMvK2s1ZFhxWWwyMkZ3UDRBSHVKUkZEOTcrYmN4UWtMREVrMlFIVC9o?=
 =?utf-8?B?dU4zVWlmMld0R2VneTlLYVNEZGlGNW10Z1ZucXhSS0J6N2RTMUNjaGt4aTVQ?=
 =?utf-8?B?WXlaakpqbm9jQXBQYjJiZ0xyeUdjTkNMZkQ2eEJUb1hldlFEUTZOSGYwZlRa?=
 =?utf-8?B?cHJDVzhzSzB5N1ZDL3RCUnE2cXpLVFcxK1hQbmVHdHR1Nk16MGF1TlZiZEo1?=
 =?utf-8?B?ZW5EWTRiVlZYNWhlSy8vb2tTYXBlcDJyREw4d3l5TFM1azcvZTU0dUlKK1h0?=
 =?utf-8?B?SVJQZEFMNWNLaHhSaVVjR3RqU0xZUFd0aFU4SkNGN29pVjlNS0g3eHFVY3VN?=
 =?utf-8?B?TkYxNGtGNzBaKzhkWGhvT2RCZ0VxRXNsYlY3SnhlcGsrUDZZZDlaQ0phTHQr?=
 =?utf-8?B?SVJBT2hxMXBQeVNqbUZROUlaY0FoZDVqNVNtdFYwZlNITllGRkR0YUZpTFlv?=
 =?utf-8?B?SUk1VldLdmlqeE5YY3o5Qng5STBlOG45ZU1JMnFJR2RWZnpSTlVZT250T3di?=
 =?utf-8?B?dUIwS0tVYXN2SFdyejk1djV3RWFXWDRvaFBrZjVHMUhkUWdxdy9HVmFuVGlR?=
 =?utf-8?B?VGt5dzF1a2J4SVZQeGt3QllzOFQ0UG9KNXFHZGQrLzF6VkhPUUNrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bb8f9a-a621-4211-9a79-08df40b4ffa5
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 12:03:43.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yH+EaMykunU+IIGBOTCo/r7QzjSiEDreOOuAISczIwnlL6j4Uob3sxkR8KDAFs/xJ7HMTMz/2uK1R6w2/V34Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498



On 08/11/2026 16:26, Jérémy Jean wrote:
> mlx5e_ipsec_set_iv_esn() may decrement xo->seq.hi for a GSO skb based
> on the SA's current output counter. The metadata already contains the
> high word for the first packet, so this can produce the wrong IV.
> 
> For a three-segment GSO skb starting at (H, 0), oseq is 2 and
> oseq - gso_segs wraps to 0xffffffff. The helper then uses (H-1, 0)
> for the IV instead of (H, 0). This can create a situation where GCM
> reuses a nonce.
> 
> Remove the high-word adjustment. mlx5e_ipsec_set_iv_esn() then becomes
> identical to mlx5e_ipsec_set_iv(), so delete it. Since there is no
> longer an alternate IV implementation to select, remove the per-SA
> callback and call the common helper directly for outbound crypto
> offload.
> 
> Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
> Changes in v2:
> - Simplifications in the code (removal of mlx5e_ipsec_set_esn_ops and
>    set_iv_op function pointer), thanks to Tariq Toukan.
> 
Acked-by: Tariq Toukan <tariqt@nvidia.com>

