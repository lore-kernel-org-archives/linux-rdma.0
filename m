Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795200154;
	b=uBNJ/6Ie3gYUtu0fUgpkLgGq+LL0kuWiZ6QT5EB0dDGhvKYbmyOxWkT+ADbRIrgE9gbb
	 lwiTKVisGWNXQQSgQft1KdQwcPii2L4xAaag3EuaM0HB0C6EU7S3m8GY/XQMNqggrwTOz
	 vU8bqNQDgIXzPcYNq0tV9bJ5bajBhiwT0wae85BK4txXDQEY0BAtwGSlesL3XxyB+aJTg
	 zCCzNSXCyCepGz7iYk80UNeB/3Mg8wirqDiP8S/pw40FOMMPp0ij75BwxnKCpxnuu7X/y
	 uUvBkn5nZZp7b+6dnnjjjP/Yr3hEEbkaarAY+wJnrv22w+WdUrf9pWeg/Kj5ctQdIGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200154;
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
	bh=XGvzxP2BZBhJcie60rEu/LaVj4GRscX2Ieh3jF8mvgw=;
	b=HWYMuYgFZhpfEykGz2P9/J/noXWjyAlNVZJ/H5GyKxwwhJFJsDral3R6KzCBM+1aORKA
	 dq//2O7UV0Z/la8pEGkX3+5KEU3C/H8xJrr0bp7NF2Ov9Ue2HhkVCMERGsujhv5oywhXX
	 OvufhdEREOgGqGWDFm2SOFmOWrEORN8PnrMv93M2vSb9X7+jCl09U5AxIHxjEjrgBkOoF
	 pSN+qj53o5S9jTRgu78Rly/uHb0BRSCyG/oEsrDg4ws8xZUqZIr9a0dt1evElwTz1NP20
	 x68UCLqLF3mQZAUbJcEfDPh2BT3B4qbFa6pVmCCK3JWDxhjCf+3/ByFU6l5MCyjUKuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=prWmzOsx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.58
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2E160A263E;
	Fri, 20 Nov 2026 18:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB2E160A263E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=prWmzOsx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqJgzgi/ei8ElkpPISmKtZNE8manBlqhExhvJLvC7UjfhNzLKtSUgNWyQB4NPU7ucHuP3X/5B9ZNFdCIdpfaCZBeLMC7/HU5ztOZSgK0csolbQ/nZ8pgJwv5TGTvMH+Vw8Cd9Bo/AnX4c3W53w4g/7AJeVQNuwpZABDtubIvIEzHZz8OcV+FMLBHdcQ+eezmBQfIOdNq3LJ+IUdbVuyCckeDMSP9s2CmFOB/eqbdmt9n9XuPHF8ED5rzQCDooQYdYHvvQKI9fH39ks67jPgOxmtz1tgui/uXeb4j7lPviinZS90hF97RKx8Ux/VIrLJ9MO8jRqIXj5uFvj2ZJkMfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGvzxP2BZBhJcie60rEu/LaVj4GRscX2Ieh3jF8mvgw=;
 b=gkp49PD5dPturPQQcUPRffAX6SQXLHr7AQxTbx7bAIdaHPDN7h0jz7y/4BBj6WnKvNba5B6a75mzJH2U7VmCzR9hRr1q778m/SgpVXH9d5vW3pWhz8TuBiag1VoLyFzcV8OR5gHL1A2mpkx9JzQ7sE3g8SlwyD+lRUK/iXBrg/Id+bCIiugYDyOWKkkFKSfDISeQruGfc5z1jCBwM3pG4siV4sQdkFFEZT/JnYzyjJCzyQSkijkBhg+8BIqkaKFZ0UPyZ4DzbNS2x3ZqC1QuwGDiXxdXSRXYC7UMsdvRfHtH+EX+5mNdD7gzauSrX0uAUlk93ElUbusJktmR+Dj5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGvzxP2BZBhJcie60rEu/LaVj4GRscX2Ieh3jF8mvgw=;
 b=prWmzOsxAGozR3Qb14H9GsXnreep25d0bUUkpZfh/gJrEMm7lIM3YQ9T9SVp30AqrMQJCknLfxgGyOx/5f6fCM2DZbe9E/Dbl5MexkI7y/KYpE7PQ1ovJSMO5s9IozTcnntrGYQxMcsmhmIfu6i9qnqi5TYXQQpTSa6mNmpzRowKb9VeZ4scYBr45DBV392VfoyGarzCFB4upk+Ca44Sk5EBkiG8+bhwsuntsWvL31tY/wlvof11ae422Cp9Z/6Acfpc3HlG6o0l8x8bQt1eTwjxQ0mKm94fugeHLIfS1JHrS5NBC7i2jzZqg6QYBgt3xhqlcUBySDmFd8Ru0ecJLQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by DS5PPF7671D5CC0.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::653) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 18:42:28 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 18:42:27 +0000
Message-ID: <1e629c2d-f7bb-4508-9e7b-cfb7b23344fb@nvidia.com>
Date: Fri, 20 Nov 2026 19:42:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data
 direct
To: Jakub Kicinski <kuba@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
 <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
 <almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
 <20261120101402.44f66da2@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261120101402.44f66da2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|DS5PPF7671D5CC0:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f40b1b9-8320-46ef-fe33-08df473606bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|261022105027099003|261026140227099003|261028144727099003|4143699003|261022115727099003|11063799006|56012099006|261021123027099003|261102123227099003|10067099003|261021135927099003|261021130227099003|261021121427099003|261026130827099003|261022075727099003|261022113327099003|18002099003|22082099003|261026121527099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Roau7sZpf8jp8vv2xWumGUYikPtbNfAs5eJfmtXVPua4V/Ov/cZU1sHhYQz+wxH20IgliSul7vQW2KzQWra7Sy2FXbduJ2/cL3PwD4oGXc4w4ZE//iBYysJ4Jt2EDd8I2mx7Ls1rSXm63pvegDj6P2tM10dzmKU/kSCLF+W5gVleEO6hSrMwMSFlR6ib/+2xxPgs7bQSIodLJt3o0tH/FlclJp5+BpaycuL1IoAdx6xC8eDv0W/Q6iJiPWDBQqzo4Qymh0ttKHh2+Nq+YGfi59Z3O8EgCPVamCRkZkkgJfbsH1nlpoo++q2YoM9swO/SM9SKtZZ8+FJAlv3sff96NwzBQZyRxyDeJPEdfjT4AuiLuwbaQ1g1RsYc5tRGZDUA9+e97+SaV1mrAFEq6S/IGRB0vxxzTiyWf0XbND4eX+kenDWyQsI6i0MmTkjDBzBy5/vU7PRAn+ij+qHBKzB49yhQ7ccYyoUVFb8bNOnGAOzd+KGLUoUnT1Hc6J3rvMNmWFQJmfz6qmJTyUaP2ZuTab7Kk36u4uORADTspbiwg1G6Q1rdfKWCzo65UItUhuR6b071dHc0Nx347NRm9S5yktd6N5Kq6GPRVTxT5SxDNIWApAq+EiLcajLn5JUTqNMJpSOJjQUBg3phIy/PffC5KVanPV11KvbnbFvnFNehSpk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(261022105027099003)(261026140227099003)(261028144727099003)(4143699003)(261022115727099003)(11063799006)(56012099006)(261021123027099003)(261102123227099003)(10067099003)(261021135927099003)(261021130227099003)(261021121427099003)(261026130827099003)(261022075727099003)(261022113327099003)(18002099003)(22082099003)(261026121527099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bllyNVhJR2J5cjR3Q0M2bHVIQmdYdThFbFJBTWx4YW5XN01lUWVVSEdTaTBu?=
 =?utf-8?B?N0w3R250bUt5WjVaMHFSQk5WeWhPeEIxbzFOY2IwbitRQmpyRStkNHo1VmZk?=
 =?utf-8?B?bEFvQUxDWkZTcHkvZ3dnclZQdk44UjhBOGg3QSt3OGo1Vi9wMWJYS0Q0enAv?=
 =?utf-8?B?VE5FRHliVjk4d3FSaGFINC9uYUZndVlUcElpT1gwVXdpZFcwVnlOZFd4Qmxp?=
 =?utf-8?B?OFFad1ZySFNvS2lMTWFIV0MzbEFtOWxrTS9UNU5jTVhoWm5TZ3ptRFY3MkFs?=
 =?utf-8?B?bkdJWXd2RmpONFlLdkRlK1h4NjJ5bklNa1FabVJMemJRTXFjdkJIMTVZTDJI?=
 =?utf-8?B?UEYyd014c0pTTlY1WEp6OHM2NmYzY01WaCt0R2J2cUN5cUtYdjlYdXhJcmtF?=
 =?utf-8?B?eE9FQ0hhZ09LMXdUaFZhdE51dFNzSS9YK0M2MVp2RlNFWm4yL3hYNlBOWk9n?=
 =?utf-8?B?VklQdVpkVmRYbkl4TnYrTHNIazB1QnNWa1lsVmE3QVBvbER5TTFGYnBKbXcv?=
 =?utf-8?B?MTJJUi9YZEJaRTIvdEl0cE1IdkI0UXhONjYwdUl0NmZUR1g2dDdGL2pDdC9K?=
 =?utf-8?B?aUMxV1VrSHJySC9iVGcxMWtUd1JqVnMzT0xvVXlieXFKSzJoVWFEaVpQVkVP?=
 =?utf-8?B?YUpuTDhCeHVrdThMV2ZKQkFLWEJwWVhma3pqd0pFZDZRcVhiTmJlbEFROFl1?=
 =?utf-8?B?ZXdTMFJncUozekRmLzhWZ3ZLbjlsRS9ZODMyZ0s3clIxaTZkOEgvQUthUHdv?=
 =?utf-8?B?T1JKa01SOHNXbTUzMWZQUVFIeE8xNS9LVjBobWtNVXdsc2hFSnVUcS9BNVpP?=
 =?utf-8?B?VVNVL2xJVHVCWXpuZkZPREI5b3VGa1U2Z3NicmtFa0xKanJicm9URFRmd015?=
 =?utf-8?B?ZEtSbWR6K2RkaDgrd25hY3FpdXcydTIrQ2ZxZk9uRmpzRm56TDZEcGYrZmc2?=
 =?utf-8?B?WVVUdWxuYVdXUjBCRGlHaVozdit2YytjUVVQalg3ZVJCRUozRmNpQWx3eklW?=
 =?utf-8?B?NitwcW1QTTh6d3E1M2hMeXRPUE1JNnFyK3N1THRIdkpvOUFnYVlZNDIyS24x?=
 =?utf-8?B?YmhlWUxzc2Z2TmFCc0RVb2pqUjYyYllmUzFVZzFBbFUrYlFyTnZOckhqbXRQ?=
 =?utf-8?B?ZkovdElNMjNOWHArdnZjMmo1ejZRMlpzOXlWOUk1S0NzWndaOGdZRmhRUGpi?=
 =?utf-8?B?MVFXS0RNdktVblJyVW43cmM3eU9HTXlydTBsK25RNlJBMzhSWGlwSjZ5b043?=
 =?utf-8?B?Mi9Pa0ZvckN6Z2JpLzJYQURLd1h1bUZ6ZlNDd251OEhkdHlaN0ZXZkxmeW4y?=
 =?utf-8?B?K3llOWMrQkplVU1FWm5MdXNQYWtNL09rdkNFclAyTUVNTEdESnRxYWoyUFoy?=
 =?utf-8?B?TkwxaERKODNzRkdEYVNhdVFzTTdXVGk3NkFWVkFyaXNIWFdzSHBCQVdmMVZm?=
 =?utf-8?B?ZXVyWjlJY2c0KzcvUWZBM1BEbnNnOG1mNXExdnR5TnpZejFoRVM5WnplSnM0?=
 =?utf-8?B?cHQ1Y2tPTFpyaWszUzhsRlhuYWFDYUEvY25FTWFKMkwrSG96SURsU0l6d25X?=
 =?utf-8?B?VEpxeFp0cUlhWi9hdm5mcUsvNktTMmxES2x2c2tJVGxHN0pQbE9zVElwOVc2?=
 =?utf-8?B?OUs4UUkrbHdCc0dHSytZbzEzSEVkZWdBZWY3SUU0ZVdHNENER045R0FHZ2VV?=
 =?utf-8?B?YjR4MUNzSXFnNnFFWXhmOFFZZUp4blMwaXh6QVRMcE9WY1hBTjBzaHhta1V1?=
 =?utf-8?B?ZE1XTmJrWktkcTZSdExmWGNpV2tiRUMwODhZNmQ1d2NwV0xRZlBkQmFNc29s?=
 =?utf-8?B?eHRtdmNYOC8xWnVkUWZVTUJQM2RoM0hnODhLK2F1UXdkZytOMFBWZ2NzZHQ0?=
 =?utf-8?B?NExualh1K2FnTFdJa3RIRWFucjVSRVpmR3l6TTlMZXBsSE0yV0dRZWRVVDlH?=
 =?utf-8?B?VXhDTGJJbjV2VUo3eGd1NjdPVDJXVE5aakU0K0xOUC8vR2hqUnhZUGkzSUNY?=
 =?utf-8?B?aW0wQVJ0MHRNWGpXbHF6S2RnbjVOSHRTazJEK2o5TjZGQ3FFY2ExZG5QYjd4?=
 =?utf-8?B?WEJpZTNZVTZ3OENHRWtZcXdBcWl1dE4wN0s4QkVpM2lNdDRMOHdsSmhvKzdu?=
 =?utf-8?B?M2xTeFcyQURtbHV6akZwM0V3RERwcnlUZ1BWUmhpckFlS0VJWFZWTEx5QkRI?=
 =?utf-8?B?dFJMR1hsb2hzZS9Jc1BLNklBcUY0QjluNGpwZHU5R3YzcHZsdURIQzRSaWVv?=
 =?utf-8?B?LzNHVWlLMDRvTktuTE4zaHRZL3p6ZWFhZHBRcE5leUxidDhXR2FpL2dVcDFV?=
 =?utf-8?B?bWJkV2l2UGtFWmhGVi9MUGJYenV4MVlPM3VSS2dqcXdiNFRDM3h5dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f40b1b9-8320-46ef-fe33-08df473606bf
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 18:42:27.8989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnD/dCQ8Wf4m3lnyyOSmipf7umu2YyqWr5YsODNRtHjlQY6GiALODXnJ0rLHsMw6QF7oubBepq0YtwREzrpH0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7671D5CC0

On 20.11.26 19:14, Jakub Kicinski wrote:
> On Fri, 20 Nov 2026 15:39:21 +0100 Dragos Tatulea wrote:
>> While working on V3 I realized that keeping the core part in
>> this series is not the best approach. Initially it made sense
>> because the change was small.
>>
>> I think I should re-spin it in a separate series with netdevsim
>> based selftests for the new APIs. I would base it on Mina's devmem
>> leased queues unregister [1].
>>
>> Any reason not to?
> 
> Hard no, please read the netdev maintainers profile. netdevsim is not
> a sufficient consumer to merge an API.
Ack. Will drop this approach. Will keep the added APIs as part of
mlx5 data direct V3 series.

Thanks,
Dragos
