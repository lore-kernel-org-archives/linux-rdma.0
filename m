Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795436257;
	b=zFNfPRIP4KvxMPE9dd76O6N7I6dSBm7KUTsYAKGdp0h9FgClKEL+DThnLX5Zvxggs8Xu
	 9k13G8Xh9DF1jX0YxKGdWt39p5m0M823f84NkvF0UdO8jEXm8m6643S2g6OlxAVPFA4mk
	 /TmIfCExE1nuahIy0dzw9BOazNxu+5rFDqwawd/p9LHCPmDyvz3YFN+cJNNJT+QtdoUWq
	 Hy5LEC/RYCE4BWCp/md4wbT3ajfYnZ7GiIxYgW3fyK7heoXmPChBn7FqQIO8Q7XrnGM4m
	 EwAA+Muw3C+xaa1QZlgjN+g7kH+AcvGWlfU6LHiAJA1tCCMQVAfIQ+sP7Il6Rv3i3GA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436257;
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
	bh=ct7kQPJlN2m3mSe5kGWfiuVdiZ6QDKvCP50z5NF6brg=;
	b=cs2lgO7JFvWaMpXxzdyCiisxAHGHkOZ1qiLs4AB5F0fs8lUbwJyjTI36lgv67DVpdAUa
	 LDAR/1F4dtPYGTuHZ44yi+4IGZ7I3E7lYSD/eIugG/cD0EkjhqMNSW0Mkxi/jghLBTXCt
	 PbgFUIEB8yO8F0C5J+3tGVs0XVnS2Z/2c5PKas0FNFs2zz5kpGXm8CTyS2dW3eO36FMwA
	 om8Ow9c7zJw+6191vaWWiJFe+OO2VfTQeJrt/tH2HBa1aPTNVcuZ+D1JQ/lmPIqlh0A64
	 K8RfvsV2StPcSVi3T+LiwDSIQ4DVsOKu9PqCGWWA+j2BwnCgZHkY0Ssil9VYJeqQrGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="S3q/dVH0";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.36
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA440606A31E;
	Mon, 23 Nov 2026 12:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA440606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S3q/dVH0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/0Tu+ovwQ3HOQZRp5snRPp9VI4ALvP3twEraYB/H21B6XdbltTpV7/9r2w2ZovE6W+t+n/2Mwdy9ba8fRAO+YE1rmTIwQQHMqmvIOKURZmfIJVZTjpiOl3zAeOr4BGr6mFrtsfxaqWwhhftH3zHvWOZ+n2SqRNFKXHHvL8eqfajj2QVdG0Jn3b1+QtblvEstfWE8YisqzSAm3vrKl6uLxQiHDBowLFGF11SLXtYbnGRW4XdUEU4UoUGQy/pyVZv0GewZ6yEcqxR0AcdASAlvXZXN3/xOJLpm+xAEaG8/WxcOHJZd8y0aqi2q62gNCir8NOafs/iZuQXIc9zMavjMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct7kQPJlN2m3mSe5kGWfiuVdiZ6QDKvCP50z5NF6brg=;
 b=UlctK8NqGpZ/+bs/D1PSFb6yosiznq1lfIwWYb4jMaEpT9RpIYveDGaXInELjGS7cgM9R3o60Mkc5nuSD1AuKvynVYkvn324/NHW1qKPUCYDZOzrv52WMMGpekx/iv3xt7Dc+8y9g/GMFAAL5qCQWM44YifpA6IYMIZP/liZplEKuMpKXAcrGZd1h62FG+FIsu8gyI3XhsOBKL+7ySFWIOvXBWMti/WrplRJD+21GIf78Ms9lLTzZBspI6csrizDlHFxiZTqvjqZsuhDI7DC8p1Tug+XTFP6Tll3IsGxJxpoPX7yQyrEUPkiYa1TlI4blQgAbcuMkFi6qkkFgO4nEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct7kQPJlN2m3mSe5kGWfiuVdiZ6QDKvCP50z5NF6brg=;
 b=S3q/dVH0xS7FkJdBrbeHSitpL2ClkMVjapUtGiMA5h68QRVYhylK0N00izW78I3K93s4ZxjMD+j4u88KukU0vTLk/bX2A4MY8Wtq0nFc6sjwCNzgtu59u1ipecg6NQY4hecqmAZjgzpUDavZ2nIlUh5GTs7KzqaCa5+5xQrE6W40qfRSZAlkPNbS60TwzPAbMmBr1mzNsMG/ZjEDphHz6aQi2QlBTDCHCMjbcWOgX0taJHMycsXrW/EfQ9gW2VKIY42Km+FFKHvQ4jLP31eBDehQJB7yyOqIE/WPrXAUN2vPyivET5fcdasdYxI+SxGhz0J4OAXew6V6M9FrArUH+w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Mon, 23 Nov
 2026 12:17:31 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 12:17:30 +0000
Message-ID: <68f37077-d5b6-404e-a243-22d248eb2b24@nvidia.com>
Date: Mon, 23 Nov 2026 14:17:25 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: TC, fix a NULL pointer write in the peer
 flow error path
To: Zhao Li <enderaoelyther@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Shay Drory <shayd@nvidia.com>,
 Akiva Goldberger <agoldberger@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261118025708.86215-1-enderaoelyther@gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261118025708.86215-1-enderaoelyther@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::11) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|PH0PR12MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: c2bb9ccb-1181-4d1d-1c12-08df495bbf13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|18002099003|22082099003|11063799006|56012099006|261022105027099003|261022075727099003|261026140227099003|261102123227099003|261021121427099003|261021123027099003|261028144727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	wQ5rFuMGy1mG7cKYHuSS+pYACxB/mFh0xBs3DptsOTK+90yBv/7FOt9lRcnp8nbRoYd7a81gAflGhk+9Y5nYsL2mhWfizPW3vm3IpxDM2Hmm9aoX/UUecrAnamvwYviDZJSMQtOIYZwIiQuBZCPW/06UGkHJ84CKH4t/dAAsAikvqQO2H3pQXo1PLv1zArRXIfn62VW4/swjtKCzVlfPJUGAvfdConpNf8p4lPVTgUrxTiDKGfN35SaGleoeVTIsDAQjEouPq8T19/3RYGXXK6ChJtn59pDHxByrei7VAIaKy0CLlZemNRM8gj9nM75jf7UBj2qdP1l9+XjG64DZ7B8Jc5qCcrUexvz8fGDLFr2SyUGqKtYpJ3pEsaV2QcbweQ1p6UasGJRPCvnuZwZeUoKRPa/YJJot7zGRv6l4WrZdOfgccj3fWL8mxdwSLu5TWvUryj8HpeMqBPpytX+QYPInvOp4YhJSbwJi9XSiZdnG2cN+j6rTe85atc/ybNTY3yusGBFO6bkYc6uqLB4Syfu1cUUzIAxHaWUKdgLukBP/tUiutfhZmSSIui4am5tPXuRq+3L0Sn7SZsAI3RL9ePyZYEQKk6l9bbN35QntSNJ6FO7C11D82/8X/isVCaexFxnsKd/BKJpZEj6ROkQv+QmfOUHsYt9kMmc8r57IXX8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(261022105027099003)(261022075727099003)(261026140227099003)(261102123227099003)(261021121427099003)(261021123027099003)(261028144727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVJXS2FnaitwbEg3RGl1UnE3R0tmd1FUa0RWS0kvS2hqUlM3VVgrOGV0dkoz?=
 =?utf-8?B?d3FIQ1RGbzZVRVhlbE8vcTZMOElSNGkyK2pMcWw2Yy9odDNHMjcvZHNyVjlk?=
 =?utf-8?B?NGp2bGY1VmorRjI1d1FUeW5VWDhURy9kL0prbm5MandTL25kZHV0TFRRQWpY?=
 =?utf-8?B?ZzNaaVpmUHUrSkJZK1Rmd2RiT2dlYUFXM21tZlA2d3ZLMmtsRWcyTm0rY0s4?=
 =?utf-8?B?UEE5a2FWcHlDTnQwUzRUeE9uejRtZDYrN0h5aE5wcUlHanBzVDVJOW42cXgz?=
 =?utf-8?B?RERWQjZHa2g2SG9WZC9rbVpFdGxiQS9CTU5GSCt2N28xZDdxZUxpaURhQmtS?=
 =?utf-8?B?clozd2MxaXJ0SDBkdzhmUVBPS1hDUjRHUE80YmpvMWdncHJ0R0o5T3lUQzFl?=
 =?utf-8?B?ZWlIT1BjNnZxMWZsU0V0eEVkTlR6VjUvQnZGMEZqWHpYdDFTQWhZbm93SWZX?=
 =?utf-8?B?S01oSngxaTh2SmFEVjUvYk9nOVNQdjc3R3VwcmxUQWlqckl6WVNqYjRMUUhW?=
 =?utf-8?B?aWhzTWJpYytYemFyZzNlTnFyU0pnMXhKYVV2b012a2doZ0tXclJoQmJvdjJB?=
 =?utf-8?B?MzE2UFpVS2hCcDVPUm40Mjh3czZMY01RWE5oTmxldU5MTUdrOWdJQWNLaDFL?=
 =?utf-8?B?dkJaYlU2VnJFRlIrRExBUWRlS3VPa1p1QW9GeGtzeldEWTVLWHZrQ2p4bzVt?=
 =?utf-8?B?dVorYTNZTTNESUJBbVVlZFlucjVPbHJ4K2dFc0w5RmFmYWF6UUdTME9RZDFj?=
 =?utf-8?B?M0IyTjdXdjR4cnlwM0U1V3N3SVQxT0FtaWpaYTdyeVV4VmRyQ21vVGZMall3?=
 =?utf-8?B?R2paL3BkRGlvRjl5RjdKclllN1VWc0Raa2J5TDArUFpWcERVOW5nK1R2QkJt?=
 =?utf-8?B?RGtiU0RWVnpNZ3R3WGlteVNZRExjMmxtdWF6Wk1VSlVJT1luaVFYWjJMQ05W?=
 =?utf-8?B?ajloTkQ3YzhPK2oyTE5WQU5HSkd5Uk9xajNMRHIxaGF0c0NwT3A1azIwcytH?=
 =?utf-8?B?Ym51anI1UURkZWd2bGlSaE9PUWt3aVBWUjk3K3ZKSk5GSUtiNlBBTmZGdlQ2?=
 =?utf-8?B?ZlJxUVdrVzI2ZGplNXI4ZDI0N0FhU2VucFVEdVYyYWFJRW5kS3RCQzRuYlR0?=
 =?utf-8?B?ZjY2TlFuc0ZESW12MkZmeENFaTg2UGtPdktNS000dFlPb1VMaUl3V1o3YkN5?=
 =?utf-8?B?Z2JJSFU2YUQxWmNjRXd1dXZLdHdkZFp4bWpyaVg3OW8zanM1YTJwYlJNZVZJ?=
 =?utf-8?B?c1FUWUVIYU9WYW9hclZESzlnWTdycXVZK0JCREpWRllBS2lQbm1BUks4eTRr?=
 =?utf-8?B?SklsTTZLaENzMFowdVZ3ZXJwY0pvakZLQTloTkJGWGdDVWhWcWMwVThsc3dz?=
 =?utf-8?B?YkVuRVF6NU1EZ3ljS0JKR3VOV1JBcWNVdG12WGhXcTBsTXhNd0ltUGtZL0sr?=
 =?utf-8?B?UmNKUjVBK3NwY3M1TDdJclJhd1pWR3pueWZITXU3SWcvQU8xeDZmU0FjRWtv?=
 =?utf-8?B?a3c5d3lzQmdReFBGSWMxTjVITzB1dXN5bUpIazh3YmhFaHgwS1VpM2Vqc3Vr?=
 =?utf-8?B?ZTFTb3RTSDV5bWcvWW5aNkl5VGNTcUU2b2RlMlRXWXlYQ1VjR2JIdFgvWHIy?=
 =?utf-8?B?VEdpUG1QQ3UxM0Y0SGN6aTNJQU9XUW9UYll4bldycms3eEhjMnZodkwxUWRL?=
 =?utf-8?B?MmEyRFQ0VTJHWFgyVU5DakUvV2JvalAwT09UT0VITUV4NUEzRzlnQzBZY1lh?=
 =?utf-8?B?V2psSWpFZ0p0cGpRM3pUQjRCSVNYeER1aTBZTkJxMFhJMHNYM1UzWXdvSUFZ?=
 =?utf-8?B?NXVaWnJGNXFnK2EzTWFnWHZ4alFacS9zRHcwZ3plWDJmbDJRalZuaHYxV2dM?=
 =?utf-8?B?aStxcFRKdWpjVnN4eUJCSVNuNFYvNlBtUndQZ1Bwa0l2cHhoWnpmUVpiaW9P?=
 =?utf-8?B?SjcrbHd6cUhIektVRS9TVnFPem1VWjZJQks0WDByRTZFUVhXUzkvcWRYTkE2?=
 =?utf-8?B?cVg1ODJzb0xISHVCaUdQUEs5VVZFam5ueU5iWXpPQzRFVUx2SE4ybmt3ZWFM?=
 =?utf-8?B?RU5Qakg4NVh4cWFFYWFaT3M2cnMwYVZSdEVxOFJWcUNXZ3V5Z2k0WjFNTGdo?=
 =?utf-8?B?ZFl5SDlnOVcrUUlPbEJ6TDcxamRxVEpETXRYK1UxMm9mT3RFdDROS3hOQjBo?=
 =?utf-8?B?Y21xM1FVbWtyMXFlcEVaZVpiSkI1R2RWM1Z5aisyUzZDdnJYM3RlUjhvQWIy?=
 =?utf-8?B?Q3JlNmxKZWJJdGx4OVo2OEIveXFqQmd0RjM5dFhkNGlyaXlPcDlIQVM4VW02?=
 =?utf-8?B?OFRmbk9QNldxT05zemxJTU9iR3hHV3U0aVpRcFQ5a2lwcFc5QzQyZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bb9ccb-1181-4d1d-1c12-08df495bbf13
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 12:17:30.7976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7gKWhKqMVih2YGxXnDEdUTV0v6j3AtodUGpOg+Vhl1eOuFRNCBz+hxVFzQL7undB/C8kira+5N/pwt6ycD7ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7957



On 18/11/2026 4:57, Zhao Li wrote:
> The peer flow add path hands the duplicated flow over to the origin
> flow before it looks up the peer entry for the peer vhca_id. When
> that entry is missing, the function returns -ENODEV, and the caller
> then deletes the duplicated flow with list_del() on its peer node, a
> list head that was never initialised and never linked. list_del() on
> such a node writes through the NULL page.
> 
> Look the peer entry up before the duplicated flow is created and
> handed over, so that a missing entry is reported without leaving a
> duplicated flow behind. The entry cannot change in between: the peer
> loop in mlx5e_add_fdb_flow() holds the devcom component's read lock,
> and peer_flows entries are only stored and erased by the pair and
> unpair events, under its write lock.
> 
> Found by code review and not reproduced; compile-tested only.
> 
> AI assistance was used.
> 
> Fixes: 9d608a40c2d4 ("net/mlx5e: TC, track peer flows in a vhca_id xarray")
> Signed-off-by: Zhao Li <enderaoelyther@gmail.com>

Acked-by: Mark Bloch <mbloch@nvidia.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 708b7987ea4c..d41969117d30 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4630,6 +4630,10 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
>  	else
>  		in_mdev = priv->mdev;
>  
> +	dup_peer_flows = xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> +	if (!dup_peer_flows)
> +		return -ENODEV;
> +
>  	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_PEER);
>  	parse_attr = flow->attr->parse_attr;
>  	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
> @@ -4643,9 +4647,6 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
>  	peer_flow->peer_orig = flow;
>  	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
>  	flow_flag_set(flow, DUP);
> -	dup_peer_flows = xa_load(&esw->offloads.peer_flows, peer_vhca_id);
> -	if (!dup_peer_flows)
> -		return -ENODEV;
>  	mutex_lock(&esw->offloads.peer_mutex);
>  	list_add_tail(&peer_flow->peer, dup_peer_flows);
>  	mutex_unlock(&esw->offloads.peer_mutex);
> 
> base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a

