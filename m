Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793108407;
	b=kcQr20FYphIGFViRPcy++1J7YaF2UsR4y6pNdxDR7F0x4iNg3GFbg8mt1xKHFIsrcvsx
	 ZCmw+hQNOdfzpXY4KtCY+Z01v0mI/D2XvNoideY8uggsSzwd7/iy8+8RBwyT46YBhuj0e
	 r39EqEdmLBSiXFt9saue2mvp4KbO874kfgPVRmqacXpcXhebEC3eti5dGarvtK1Z+051/
	 P5tNqyo+CXm1KCH8puraQ0JkyO7nKj7g2mKeXAlZ493HzhmgF1zvfzFlcnA1N+yRMAfpi
	 RfBrbw1hv2OgtHho3r956xqCD8BkZmtBSVA/aXSY0FsIZ2i4KswH/r0CPH5GVP1qmtQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108407;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jm5Pvk9LJFhmcF+EPkcy57oZc3XXAhxPOTsMuUZuVTE=;
	b=BxozqDUfE8ZZqgha/Ds9d/02Qw8l8DROQNukElSOS9XF1LwhcvvI8ki/ksKxfUv/zuXV
	 Li+ARpB0M+cp6Aqtm30nTTdd04NQ46K/Cw+sK9asbV4TWR0mbTkBoo5n0XQpUtJ0w07YX
	 5Ob5GShYsZBYgLEXT/7JLR9bswBixIDzsQ/fa7eoIX8UHlXUhQuLZyNjI+lLvoAKvUwYM
	 K8vxoucXpYQ0CYQHx3m5mM0pgAXaZP8qN0v0YYnnU1hiCQJ4kF3u+742kgX8s+Cowek3H
	 mwOiPbHD1/NCEgw5ulwTS2E45xOj5P0AzPP6R8ggUtoi3t8fYT+HZvtVJDM8nmTZ+9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="bWoW/dcU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.50
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE7606A31A;
	Tue, 27 Oct 2026 13:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDAE7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bWoW/dcU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIajvYqiUnioSv2UwOzmABMLPzH8O1mOjm3IFGlG4YHungSNx1qKCu2TTYFf3598LM9OfZwWL2N2rJPsjw7JoSjhpQtQ3+Rr5dYgSbyxZRSjZHxQIeLGE0jTOLOVBRYjW1brRtltYgc8tMshB6fKdT7X1Bk2dUF6lh/SlErIp3S6zXkauIfqICZCLYY/mUIv80bYd/eOEwZoE+2eQF+8K6t8EIsqgd5RTOGaya/dxy2AnTHbMxAHf/0mSkqAGOVoX4qiDlxIUqycqyWwtP6EAVvHjy8QS9Rd+C1y4dQvclU7A8Xt0b6X3PjWPiXs86LlQmRGYZ9O6Dd+/sptr7OTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jm5Pvk9LJFhmcF+EPkcy57oZc3XXAhxPOTsMuUZuVTE=;
 b=iSFeTSz7oIhxrkR6izekIoNNznW5NJLdv/j2zloGZtAbP1n5OVQLchlBR97UN5/uauuqEOBL1K/2tfbHHoD7cgKmbfs1lky67N9HxdCcHRbL0TL+Z36yRVIP90BYo8WxlVmKAJPGTA+aVQVGmjggVde1eq6JDGamUxAyUjzyNElGcCoN/WN0X/RuPO4XJCXcssQLQLlCGRZbdUTtywYgjrHULIORQljpztPUoOmpQum7I/FFq1uES4VvAcbrrXY+19qmZmcSeiMZQ5kv4Xn3f76C7wREG3Njk4aymoXcGTqXg+vt62p8pclO9/0QlBAVEWixBqwTSIoy9Xiw5eQbgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jm5Pvk9LJFhmcF+EPkcy57oZc3XXAhxPOTsMuUZuVTE=;
 b=bWoW/dcUiB9GBykLBubgOKNbsBZ9MXURremdZiKpH/dxGiPI7b0ajTGBgpZ/JyTYa4bvnJq3YbGVNPwrhm7aICKdni7iplz/Wrt3g7KpMNvDlMhvUixXYKUPA7AaQn6TF9F/jrhxUHTuMBVcvvBQqnYZqEBhfAe1tPiOplz49RginUtaXNed3V1zZmUd8OucplDPlo/S2qsdv3InEQCmuvTtQTyJuXgJFXadvE6vjy7lrsCjpMy8xvQOHVOyYToB1Lw1psddJ9C+5VMfnK7fzSUZKJu+yZ3UizavBhBUHRQjbOvD9p4Qug01rsv+gL+d3ZYx+xNNVoeGIp04Gw+Kfg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by BN5PR12MB9461.namprd12.prod.outlook.com (2603:10b6:408:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 13:39:59 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%5]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 13:39:58 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
To: linux-rdma@vger.kernel.org
Cc: Alistair Popple <apopple@nvidia.com>, linux-rdma@vger.kernel.org,
 dri-devel@lists.freedesktop.org, christian.koenig@amd.com,
 sumit.semwal@linaro.org,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling <felix.kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, intel-xe@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, iommu@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com, Karl Mehltretter <kmehltretter@gmail.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Subject:
 Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to dma_buf_sgt_attach()
Date: Tue, 27 Oct 2026 22:34:46 +0900
Message-ID: <Rajx42GMRO6ivDcA4gzBaQ@nvidia.com>
In-Reply-To: <20261027123308.GC1671235@nvidia.com>
References:
 <20261026053623.202642-1-apopple@nvidia.com>
 <jB0baKUEStaR7DFEykw_Qw@nvidia.com> <20261027123308.GC1671235@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TY4P301CA0114.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37e::12) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
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
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|BN5PR12MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 25ea8d64-a9d3-43c2-33dd-08df342fcae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|23010399003|261026140227099003|4143699003|56012099006|11063799006|261021121427099003|261022075727099003|261022105027099003|18002099003|22082099003|261026121527099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	IkRHq0Nc1q02Dqf2CCi1KtToxqxx+3w6pCM5uyE4+EiOiqDkZAXS2T/DSS1eqr2AEOgCyQtOxwHYRNV+nFIvvqi+CYc8/uoP3RPPQyzDHn7jEzhlJs4Z7k6b5Qx2vXX5q3GGEkKeA+9+JehM7MFTNLnC9bZPw+pzKUwDW9i8ReLUeL9kr1N1ggt2J1ocKnLAc0PP7iZWpP0s+3To4agE4l4RlKHhFvFMWXaYIvb/RBy9WNlfDiiNgMy68wWbWrB+pzrb9psXH2YM0ingSkgiMKW6eNL44xQivPjfCyXS3CV+g36MchcAll+Mgbx+qlgNscT1Y882enEfkkR3BGfspPAYlsx8+efCYwcsqF/MmhJ8QVjhlCEk7Y5ZSq1aSyBlx95lB6nNfMv4BaOAyriobknjotXa15zGi3s1RnxC4UX8C+iGn8rQ0LEqYvp4IqYM5ACvj3gzjHSPmemc2eFyRAQG0VaXTLqwpSXfnVLfiQmxmU+YtblARsoubVMGwT5Z1II4DzhXZ9uHBpMqEUpVPgBNwBGfbSkg9DFSbV1yvxTVmBeOPEinobsV87d9gqLNSkkumEj2D577ofrWUAqe+M9w6CXNq//z7jaupRK+Immj6yq597Vu7IqZv2pz5AJ2Fzf3vgY/L3J/eE2WosslahkPTl/7gnV8KiWciV37KUA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(23010399003)(261026140227099003)(4143699003)(56012099006)(11063799006)(261021121427099003)(261022075727099003)(261022105027099003)(18002099003)(22082099003)(261026121527099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0FEU0xnYXNORXFMRVcxRXd3Sm9KcXlMM1NHV21oZmRMWW5mdGR0WTVBU2xK?=
 =?utf-8?B?RGloMURzLzREaGxkcWN1bGZBR3VwNUg2Z1VrRnBEOWJjWndpalY5SlYybm9O?=
 =?utf-8?B?SW9WT2YrdXlXZ2M3MklWZkRSdlBoeUpXZkJmMUphUDIySENER2hBaUpkTFBx?=
 =?utf-8?B?MU5xUmRxK3FTNG1BWnh5SXQrQzFtNi9IZU5BcGdFQUN6WHY4SXd1Ri9OOWsz?=
 =?utf-8?B?aXBtemlNQzB5NmVBcUNPSmNtOWdwNzhRb0ZqUFZaVy91OFNUVWZKYzBqbVdW?=
 =?utf-8?B?QWdEMmdNeGRBMlA0Y1h1WmNFZDhEcjQ0eUtCc1hWbUQxbGV1R3pZcG9CUGtL?=
 =?utf-8?B?cHZKTWN5dFR3bnA0N0QrSGtEdUgrYzl2TnJhVzBmbE1uQnNQUkdieVBBN0FM?=
 =?utf-8?B?YTQvVE8ybzFPRHd6ZFNvVEVBU0NvWnVWUXVnaHpaUlkyN3BOVWhQa2tack9L?=
 =?utf-8?B?REEwRTAxYkY4OUN1VDhLdTIyUEgzU1YzNHVoTHVJRm8vM1ZPUDVQT1RldHAy?=
 =?utf-8?B?RnVqU1FUTGlnVXBkTGlaUHVVRnlyUjl6cUx2VlBtVlVhRTAweW90T1dUYjV6?=
 =?utf-8?B?MHhkaHRITkhLQklUcXAvRWgya0Fwd3gwa2pGN055NVNGSXI5eDltbUY3Tyt6?=
 =?utf-8?B?aFAxb05ra1lISWVXWkhGL1NrTmx0VG9YQ3pwK25ZMU1zMGZGaWZocUUvdmVt?=
 =?utf-8?B?SUlBYU84dkZhdUVuelB2K0t4b0ZJV2I1Y3NVL1pSNlNINHIwODJSSTh2bm13?=
 =?utf-8?B?YW9uUGw4TU5QR2t3NnNja1d6YjVpVWpoa0FmLzN5aFVwOE9GSWIxVlovUjlh?=
 =?utf-8?B?M0NQMlF4enNWNHdXVmZveEFtejdUYlMzMGswYlRCc0VVd2oxWEtlTXlEa244?=
 =?utf-8?B?YW5lZ2FpY043cncyNlh6RVdNQWZnd2hBU3VwbU55aCtkZVdxOVRNR0JIeG1J?=
 =?utf-8?B?Rkx2UGsyc0kvdzVHa3pQKzc0TVFtbHJ2Q3dqeU53SEdDSHZTRVcyQ2FJUkVL?=
 =?utf-8?B?c3ZwelF2Mm13Unliczh3ZTE2UkdIWTVlSk1nYkp5V1B3NXRYUGtQKzd6KzI2?=
 =?utf-8?B?d1dQWjVndTd6SVNmQlFNOVRpMHBhQ1lsM3V2ZWgrU25nSkVOeGI3S0NUT0pi?=
 =?utf-8?B?N3VlVlFvYjFVV3RBMzFiWWdmc053RjJIays0VzZ1U2tORHpqUXJLVkpyWFcv?=
 =?utf-8?B?K29PckdFT09vZ1RJc1ZRa2owOHpta2RMMlRFYWJ2VzBHSkQyRDBHamhiMEMz?=
 =?utf-8?B?QWxwS1htaUZ0MTNMWG1FRGUrZDJiVWlMekdJSkRvVnhqc2hjWnNXc2F1eDNq?=
 =?utf-8?B?UUxpZUlMWngvenFKWENOMTJMRlp2bFBPQmpLTUxIeEVaUm45TElwMTdsdmND?=
 =?utf-8?B?eVRXRXh4K0VJTFowT0NaT3cvdmhxK1pIN21raFVXN2VrVWg1Ym0vMWVQem50?=
 =?utf-8?B?UkEzNUUxbkQrQWo0MUJ2U2VLeXJhZ2dvRDZ3ajEyOFlkUFJSOGlSaGZWNDlM?=
 =?utf-8?B?M3VZOGZJNWxLa2xKODJjVS9MZk1TMUxva0MvOWJ2Ynl1TVRTNGUzRXA1QU5L?=
 =?utf-8?B?dkcvZ0dzMjNOOVQzNUdwMEMvZUJEN2FFS21VTW40bDRVNjFkODVCb3BvSFNa?=
 =?utf-8?B?RC93a3BSOVMzV0FzMzlkTFpQTzRJQUhxOWhjRS9iKzdQRlV4TGFuclFxQ3NK?=
 =?utf-8?B?c3Uva2R0bnBqN0cvQ3ZwMVZ1YlFLVS9laHhUb3JBUzZaSmdlMFBwS1lldzZL?=
 =?utf-8?B?UUdZYi9xaEV3dTlJRlpxZFZoNTJsbFVVL2d2S1pYVnZOUkg1bEd0ZW13V251?=
 =?utf-8?B?dXFENlJ6Znh6T2E1TDhHK0dIZkJOR3NMSlBJVHZmcmJhWm02U0haOExPRkJl?=
 =?utf-8?B?aExPZ2RUNkVteHVYdnlTek8yNVplS1lhRGpCWlFKdFNTTngyMm1RWkppNHM4?=
 =?utf-8?B?V0p3ODB2Zk5KQzRQL3BVbXFRa1FtYWFzS2Y5bHRvZm5jU1I4ZjlBQjFCd242?=
 =?utf-8?B?ZnloYSs4VjZVZzRNaWVqelVtN2NseGVTdDE3cWNZRnhSWndZU1hKY1plV1Bi?=
 =?utf-8?B?VUpnM0pBbG9ya0ZHaXRRTHZPZDBYU2xRaThqRU1QS3huaHQyaitFUWF3em03?=
 =?utf-8?B?R2l6b0JPckJDMHpibFFJTy9nV1BDRldGMlVTeitBQ0NDQkxBdWpxY29DNGxH?=
 =?utf-8?B?NGViQlZ4Uk1leUlsdGxpODBOUWpJbjg1UllHYklFUW41bGJ6dERCNE5YUTlO?=
 =?utf-8?B?ZUxpY0tGdHlmODNXUjRmMFljYVVDb1NwQnl3bGE2TVZjNDRRc1F0THB6Q1hr?=
 =?utf-8?B?Y2plYXUxb1FpQlNWUFEzbTFXYVdtZWEzd0tvNkd1cnRpdG11cXV1RFNGMHdS?=
 =?utf-8?Q?J8vRcQSt31AlFiIiP66CvRLKJftu8m8r4/ptF09Z0LloW?=
X-MS-Exchange-AntiSpam-MessageData-1: YY3ij5IJLNGxaA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ea8d64-a9d3-43c2-33dd-08df342fcae8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 13:39:58.3992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtifhMYk0vH6JUgW3DH1qUDdfE8iCFe0M2YToHfmEM7d1r6aPl/ghqgyrKeOtjMqzeScoksocSalBBMzfCe9Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9461

On Tuesday, October 27, 2026 9:33=E2=80=AFPM Jason Gunthorpe wrote:
> On Tue, Oct 27, 2026 at 12:42:32PM +0900, Mikko Perttunen wrote:
>=20
> > > This page-side use predates the series, so the fault is not itself a =
v2
> > > regression. Is dma_buf_sgt_attach() valid for this call site, or does=
 Tegra
> > > need a page/physical mapping type first?
> >=20
> > Sounds like a bug in TegraDRM; we should be using the DMA addr/length=20
> > for the explicit IOMMU mapping as the sgt attachment is for the dummy=20
> > DRM device explicitly intended to give us physical addresses.
>=20
> No, you cannot connect dmabuf to an iommu_domain. It is 100% always
> illegal. DMABUF does not support this. Do not pass sg_dma to iommu
> functions either.

Sure, I agree -- so let's say it's a bug on top of the baseline crimes=20
TegraDRM commits :)

>=20
> > I'm currently in the process of removing the whole explicit IOMMU path=
=20
> > so if this only occurs with CONFIG_DMABUF_DEBUG enabled, I don't think=
=20
> > there's a pressing need to fix this before then.
>=20
> Yes I think this is probably the only way to fix it :| You have to
> always use the DMA API
>=20
> Jason
>=20




