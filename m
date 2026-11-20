Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795194334;
	b=vMTjklqmQdhWfEkaPE2E+S/9FzQn5jSE88tDv/n95uOoC5Qd488o8O5GxFEKpghsNTZz
	 uODldrBApPt4s/V3MOPRxJouSB3uVShd9lnKz8rw1W9tsOQYvWtr5xgfn3b/x3zkbAQsC
	 4KZCKnl8HwM3YWdt3xYToqbt00IPSitlC2ROC81TaWp07/5+Zq5CQZsmi3zHy1ysE9IMm
	 hhFcaafJf81BU/+6T9uz3EnJJOObXKejGJ2nW311yYUSuWBticgBQlFgAXThZtwcMV5E8
	 VRthlAExkflifSLPyuS1/J5voFSYqlvT2Jjr2pNsyreJUGMN6tGt0JegrvnxzTWAV7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795194334;
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
	bh=Vy9F2wYXSQHUcJyAZBDZgAabaMsKd3c3iwgzE3yYquA=;
	b=hCQI+H5YW/YmJ6h4QSkqprCKaoQ8f6+xDUpGT1W7BsSpBgETLGSChlZ0PHmkIe+3cfZ0
	 ohYMGexLiAivFyE023qWZZOOel9u2WwTtKHpGqXIpyv4HvA6vALcDNA7EhRkZ4bZ2qZOs
	 InCZ/u9Pn6QeLxMttXcfWha+4r5SjEafo0QFx2zneulqm5qo+W8JD3gsK7+44tEGNTpAz
	 Z9zYM/XdVAl22Oq78R3ePzEI4N4ta/aMgkAK5YtHyXvrC4HkwodgS+1zN+kZpbmvq3OD7
	 JN5wkqJGNzKvC8ALWi3zGrviSuSJAWMy+lXOWm60W9Xjy4zbACHRYbfE8G0nCNc5wHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="oY/+lSI9";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.56
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE1606A32C;
	Fri, 20 Nov 2026 17:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60BE1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oY/+lSI9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OwNSQR2ReRJZR38u0LjCLVU+8uTAzi12oN+rOI5uawauEGT8xPUjpqJlg7uhoNN5alsTw+wz9/Qz1yrNDXOI/CIwb9q8VAfmZYaq92GrDCI5ojkGxiQtZp1AxSquURk2BHesovttv6WNucnaVIS0gS9ggmU4qZ/b5C18P5hmPKXLIwN/uq/kfFjVLammSfKeW8w7aP04J/httNdUeU4g5sKV85yoZg2DJIi6Q6kR8AmWV8q1ZHNDt81mA5HvSBknS1Y4GP2TY1xavX36QqQDtzvnm/++Cw1PJQP4pGvkRESJpy1ZhXSrsLPENsw3hSX1rpfqiM0YN1NFyvBkz8mS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vy9F2wYXSQHUcJyAZBDZgAabaMsKd3c3iwgzE3yYquA=;
 b=Lubk46eguwFZcfBVf+ZXcCqcPR31uOJxqIChslSVPzMvP2RaL39FiDHcEcq1bFY17g0YZOIDzKa0MhrutTvBNAIqBBLWF4/XWt+08idO+V+w5o6WgixdmLZD1HQxxcGYkDyzo4wYGXiR2lscVLTW5eUAxCg+lbnMB/NjonLAoRUkS6U6ozL54U1jzaM5kE+69JKDaG6J47Nx8Rvg/JIFRoX0t5euKmkA9myXyWuJg1m42mxWnwskZ58udpWZOCfQoeQbONZjJduVwwjDXcuvlT5W1r2q/rZPP6ad2dssz3PjfHwmI4yeOEy9jz7jK9TIqZ7Ud2Nb9qZH7N6KY1K5dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vy9F2wYXSQHUcJyAZBDZgAabaMsKd3c3iwgzE3yYquA=;
 b=oY/+lSI9Y1jIIYYMWWii5LSx1ShYCtUY0RD//vuySq46LY1dfnIRi7TajEwK2+DgwomTledcNaH10BPgCC58acmQ0cRieZAFcBvCFmigbbpzxI/7z+almuDIN6b6ABKvjEe38wNVT430gqVClsoiDNvjMy+6mhH3HY76SlKw5uWSyogQE2s3PZzdi9mjulKOnNxkpPWbvMRJQFmqdFcs3jARxWyN+lSLwr7DDtLmHrWeZADB6Fpmk1INCops4XFTuLCRSQXvSVHB6biyEPC+LEGGALLkoc26GxJf17BpVN5nDWpbZm6Ztz0MjKjlxYdLOI+drCdaQ/0JdibLXBzsaw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by LV8PR12MB9405.namprd12.prod.outlook.com
 (2603:10b6:408:1fa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Fri, 20 Nov
 2026 17:03:20 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 17:03:20 +0000
Message-ID: <0a1be802-1c53-46ff-a08c-614c3a2d6f41@nvidia.com>
Date: Fri, 20 Nov 2026 18:03:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data
 direct
To: Mina Almasry <almasrymina@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
 <CAHS8izMhSVabXgMmNbHHLm8cYqW_EVQbpXME2z_tUEJuN2BTnA@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAHS8izMhSVabXgMmNbHHLm8cYqW_EVQbpXME2z_tUEJuN2BTnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::7) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|LV8PR12MB9405:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e40b29-b997-43a4-5d85-08df47282d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|6133799003|18002099003|22082099003|4143699003|261026130827099003|56012099006|11063799006|261022105027099003|261026121527099003|261022115727099003|261026140227099003|261022075727099003|261028144727099003|261021121427099003|261102123227099003|261009223027099003|261021123027099003|261021135927099003|261021130227099003|261022113327099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	wk/tD6+/cU6PcDMJJ1R8Sp5xURr/C5/SEbOIkLIVcjnnj3gEylshjy7Q+lreGotUpWM0lFZ3+/o/WNrPIJXECddhhtphFxYb4F/IkimCjquzejf2GvlJ6vmAY9GEKYIWDOiANo54TjW2zblELEdUlx/Ev26BAV+WY3R52kYQU0xZa1TTutAjdMlCgOiD6FbaEamubRculUOiAsdPUeA4xGfwWpt6XoZYC7NLI/60+I+lGnPP9LvBmBCyiVVpdWZKh30qIzks9vFOOVQwJrpRIEhBe2zQuVurGwxNxBk+2FMctcepf0E1Ei3AqdkyVALoDD13JRFFK84Ar6fQXdSUNgHqwAAXSSYoO3+DT0vZmWLpXgb0O5d86rAowSGjQZVXlNDUNFL4eFzgw0+8FBO7T2fJjo0Fe6TzN2ElhTHNCYO5ZXZK+6GUkH3nzXQv0iocJ8pnXirbckgNm+Kp4/noNxEukPkvHq1+P/IGzUM5qBblcgMX2yumqOcMgAxJk9AVfGJLeRqR47W7kMOoqZQ8YFuLWTdQ4gWZVxV9J3AgSNgRoYShZY2OzQvKMa3ESCxfx4j2Nma6ho4JD7yumPfbvytd311UG2TcEBMA0/p0Njg+4vTMt8VdYmHqQVT3nzcYT3+77GkEYJC/2fRak1ddis208zas06Z72/P8FyAzI2k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(261026130827099003)(56012099006)(11063799006)(261022105027099003)(261026121527099003)(261022115727099003)(261026140227099003)(261022075727099003)(261028144727099003)(261021121427099003)(261102123227099003)(261009223027099003)(261021123027099003)(261021135927099003)(261021130227099003)(261022113327099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFRLa0NBN280SGtSb2U0OStKWVdHTS81aCthVG1WSTVWSzhLZTB0aTVxMEZ0?=
 =?utf-8?B?SmNRZHdnZ3Q1RUoyOVFlczdpUksvVW5wdCthSmlabkpDQW5tTVF5cU1hUlVu?=
 =?utf-8?B?cG11VHFiMnMyKzB0cE1ORStIQjdEd0RKUExrc0ZENzY5WDh5OGEwWDR4WWRs?=
 =?utf-8?B?VFpEVUtXOUpxL0tybU9wVVA0dFY3RU1OM2pIaWpyOTlkYnlReWdHSVo4VDRL?=
 =?utf-8?B?TEYwajZ2ZzBCTmVUM3BldEJjVkNlNjljQ3NlYlV4YkRRKzB1WGg3Y00yTVpq?=
 =?utf-8?B?TGM4Nk5QUDVEL2JraTloa2U3YTBrWFdFNityblEzUjF4QWVhVFFaSGVTK0Rs?=
 =?utf-8?B?VjNza2NsZkJ4Sit1MUpQWEE4UG1SWlZXd045UUozSm1FTmNVVy9SWnVLM3VP?=
 =?utf-8?B?V1lEdkkyMHlKNUtUd1NGRjF2NUt5d0t4Tkp1VndmaGlNVUpqd21QRFQ5RTl6?=
 =?utf-8?B?ZjBwelp6VWZ2b3d1Y0sxVDJXbWJLNzlhUTZXRlYwb3llYy9SRFY1Y2VsdE5z?=
 =?utf-8?B?RkVOVEM5eTRkYU1mNTd3SGVuODZrZ3U4K3Z2a3FvS2NxcDZTMkhpK0tFWDY0?=
 =?utf-8?B?VUFKL0tGTEZIWlRDaFN5bmZrYWtNUUJOci91b3A1aXMrOE84a3B4aDJSelNp?=
 =?utf-8?B?NThJYmxqaGlKTzY1ek9kazNvSTNMcytYL3p3YXIrOW4vUHpMeVNTM3hKejFI?=
 =?utf-8?B?dDBmS0FJRVdUeFpkODcwK0plUDlNNHJBcUlwM041MW9BT3RPckI5RTZhTVY0?=
 =?utf-8?B?aExFZG83YkpiQ1N6Mmk3KzV5Si8wbHZHS2NIalN4ZHBjTSt1MEFMMnZsdkd0?=
 =?utf-8?B?T0ZCa3Y0RFBNSnJuanZMaHlCTXZ6YVk0UFQ3OGlnNThBN2xBT29jeE1MOFpm?=
 =?utf-8?B?RVZJWWZiV0t0V1dhT2g2YVBUbVFUSnQwUlRqeG5Qb1ErN1NveFArb1MrVklB?=
 =?utf-8?B?dDFFZHA5WUowQ0pRNXhGYWpmMDFXcDkvNERkVmw0cS9SS3h5eGdxKzlZaHRG?=
 =?utf-8?B?ZEVqZi93VzdiRVpndjQ1TTlIVW1ZZ1BicE1STDZrcmt6eUVOWWc0eVg2a2tj?=
 =?utf-8?B?OGFLaS8wWHJsaTh0bGtEeHIrUFgyTzFleTZ2U2dYS0laZ3FJN1V4cnhiNXhG?=
 =?utf-8?B?bkJpNE5ES2h2RjRhZFlNMFZhMno5eWFIS2Nmc3NtVVJlcTlrMWN5dVVoNm52?=
 =?utf-8?B?OGpGWG0ySG9ybFM5c0krZ0k5bDhDeTdyMU45SzZ4RVM0RGYxZTJpZEZWdVNV?=
 =?utf-8?B?YlJNNWFaT0ZOeFNwRXVPcnRVUDE4MVdWRmVSRkwybDQrQXliVmJmVTA0NHJv?=
 =?utf-8?B?UjVKSGlIWmJzNzQxNkgwVm0xZjZQajd1dFFqUi9qQkxYTU1MOUhmUnRhaVYy?=
 =?utf-8?B?REg2cllPemo1WDJmZmZSTVA3bGZESmlKVUlJYjU0RC8vVisvN1IwSFcvMFhs?=
 =?utf-8?B?TE43VUJUMTk5aVBaS2lIUlZuck1mek1NUXUvWlljQWs3YllvK05aWVdacUla?=
 =?utf-8?B?UmprVTRpd0tJVVR3anZZOFp0clhIV0ROc1BIcHpMNy9BU0E4SzJUcERlM0RE?=
 =?utf-8?B?YTBWTHZ4WG9FTXROakdxR0NzZm5Td2F1WEJMUTVkcXRwQ1k3aGEwYS83d2tu?=
 =?utf-8?B?STVja1VzUjJheHhoUkFnanBlckZsZWJJeWpBcDAvK0FxNHMvN2dzN2xIeVVR?=
 =?utf-8?B?c2J4d2JLMDFxL2dxWHdqSWJBREw0ZlM1QzAwY1VQeU5hVmJZTkdNVVdRSENF?=
 =?utf-8?B?enFEazVmNEFEN2lxRmd0ak1aVjlleWFuSm9hOUZtZEJkenhOWU1sbGM4eVZJ?=
 =?utf-8?B?SC9GWDBMUi9MeE5XMTJ3MXgrd2lzYXFVc3VQR1pDSzBPOVBWcWtxRGt3UTYw?=
 =?utf-8?B?TXVVWXJjUm1DSWpwN3hndE5KdlB5VHBEeThDYmx4U0RjQU85ZSs4ZEIydTd5?=
 =?utf-8?B?QXFHZmYrUEVjN0c3ZDY3OFY2K2d2ZTFpVEtQYmV6RUFqQW8zeDRRdkQyVVdo?=
 =?utf-8?B?T0hNRDU5ajdwZC9CZ1RteW1ENXpRS2xjNzh3SVdrQkRUSDNHMG1tYStOTVJr?=
 =?utf-8?B?ejJqcHNhUkRHMXB4Y1BRVm1XbWsyMzZpS0lUSW1RRGZKdUhXT2MycUJ6SGlj?=
 =?utf-8?B?UlRqenc2Tldkem16QUMyVDE4VitiWW0wcWtYeXdPNDJ2dnlFTE9kUFNsODJK?=
 =?utf-8?B?ZndEdWJzekV6OVY3Z0x3RExTbGMyYjVGSm1zNjl2VENTZy9oQXQ1akp5QUha?=
 =?utf-8?B?MzBYWXVURVV6UTZyNERCTXFHcnhjRHBVdnFDN0hjYnh2bzV5c2djRGQ1Q2dZ?=
 =?utf-8?B?SVg1U2ppTXVxT2E4VDNJWEh6UEN0Q3daa0JaM2trOVRoYVZXMEdNZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e40b29-b997-43a4-5d85-08df47282d71
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 17:03:19.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF6y/VFwgbX+M2IIZmPA0nnlqzAWHABA/gozX22u3lBspdsD2NPHIQXWYUXk7DPAv90UxlhZ6rqrr+/AlDU3eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9405

On 20.11.26 17:38, Mina Almasry wrote:
> On Fri, Nov 20, 2026 at 6:39 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> Hi all,
>>
>> On 10.11.26 19:38, Tariq Toukan wrote:
>> [...]
>>>
>>>  .../ethernet/mellanox/mlx5/core/data_direct.c |   9 +-
>>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +
>>>  .../ethernet/mellanox/mlx5/core/en/params.c   |  18 +-
>>>  .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
>>>  .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
>>>  .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
>>>  .../ethernet/mellanox/mlx5/core/en_common.c   |  38 ++-
>>>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  67 +++++
>>>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 253 +++++++++++++++++-
>>>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +--
>>>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
>>>  .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
>>>  include/linux/mlx5/driver.h                   |   1 +
>>>  include/net/netdev_queues.h                   |   1 +
>>>  include/net/netmem.h                          |  24 ++
>>>  net/core/devmem.c                             |  85 ++++++
>>>  net/core/devmem.h                             |   6 +
>>>  net/core/netdev_queues.c                      |  51 ++++
>> While working on V3 I realized that keeping the core part in
>> this series is not the best approach. Initially it made sense
>> because the change was small.
>>
>> I think I should re-spin it in a separate series with netdevsim
>> based selftests for the new APIs. I would base it on Mina's devmem
>> leased queues unregister [1].
>>
>> Any reason not to?
>>
> 
> I honestly wanted to comment that you should base it on the leased
> queues series from me but didn't want to be annoying, especially
> because I made you wait for the previous series.
>
I realized that quite a few changes were needed after your series
so I decided to base it on it.

> My series creates binding->bind_dev, and binding->map_dev, and core
> will (should) handle things correctly across both devices. This seems
> perfect for you, because you have a bind device and a separate map
> device and their lifetime is different.
> 
In my series I am actually skipping leased rx queues in
net_devmem_unbind_dma_dev() because we need some kind of notification
mechanism + netkit implementation. I think this should be added later
if there is a usecase. For now mlx5 simply doesn't support the combo.

One note on net_devmem_unbind_dmabuf(). Posting it here as I don't
find the right place to mention in your series:

@@ -234,8 +234,17 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
                                busy = true;
                }
 
-               if (binding->direction == DMA_FROM_DEVICE && !busy)
+               if (binding->direction == DMA_FROM_DEVICE && !busy) {
+                       struct net_device *map_dev = NULL;
+                       netdevice_tracker dev_tracker;
+
+                       /* Leased queue: attachment readers hold map_dev's lock. */
+                       if (READ_ONCE(binding->map_dev) != binding->bind_dev)
+                               map_dev = net_devmem_lock_dev(&binding->map_dev,
+                                                             &dev_tracker);
                        net_devmem_dmabuf_binding_unmap(binding);
+                       net_devmem_unlock_dev(map_dev, &dev_tracker);
+               }
                WRITE_ONCE(binding->bind_dev, NULL);
        }

map_dev devmem lock is taken to prevent use after free in
netdev_has_dmabuf_binding() when called in parallel with
net_devmem_unbind_dmabuf(). As this can happen in my series I added it
there.

Waiting for feedback from Stan/Jakub/Paolo for a few more hours and
will post the series tomorrow.

Thanks,
Dragos
