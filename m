Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154275;
	b=Mx3mufj2L2FMHgYD0mj6ZSPo36MrsaNDMOVCkPKXakp5CCUpmsUkaVn4oTM/ff4i9f4L
	 Uoe+5V1udVmyeUFGwgu/+ANeckbuki3sFAq63BqQQc/Qh/wkrVM5E32VJZSJLhUVuaYmj
	 mvd9Q5jggF8TyepHoRWnS4UdFiDTFl0BZj+gv7CxQM1VJ1m1zQCxOyvPATR6R8ycYYeOj
	 K7KBnbsv8+QAuG4ojewltEw+bhItfoq2wG2kvQlNtsE50E16iSk50HSuoAQIi5K/1tXrl
	 M9D4DZt96ioZ3hlGkry314/DQLM8LLcroQTGdihZUK7Gw6BqPrN3M00oroJF5ww8pDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154275;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=mLsXexqUf358mA1pQDjjSM5M05CkS3huzFQmePfrOic=;
	b=CnrPPA5LHjqswYed84v0P8+V/gb/MdEKYYx40cO2iDVPhHdDag+QmHw+sF1nQP/8zfnS
	 DnFCa6hXwvmefb3lm/dYDT6tsTWaAZk1LMVAgkJt7E2wToAFDHyHDw7k7fNXnSk1gSzIS
	 bxqB1viRGKlRWGPUr6Iu+oVbnkyLyMrM/d2bFC0sjlKG1liZhU/4RETs6aWLTsaBG1HAV
	 EHtsz13lZeAhDEJlVUNTeUfVDVhfDmulbYAMSOaIs2soXnRB3/Ara9/lREpd9SPWJJk2D
	 mpGJdK3Mb0MgKliQECcGvAVb56JZgbh9XffiRQdhJgO8aAwkoyEZeXP0kWxAy/sxNbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bCIAKIpw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.29
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010029.outbound.protection.outlook.com [40.93.198.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E46606A325;
	Fri, 20 Nov 2026 05:57:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0E46606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bCIAKIpw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llwII2jYSKxxerQ/dLxBioPeCySwZ/nXiilAzM6AyjY4BZcdOw+Am62qib38zn43uXs/CRhFs2sbLMsFf6c0kPeJOJkUVUgkDogd3ibCvu2lTColmJDc+x+jyZuUv/XFk39II7HAgZphpyORfE58Bh7p/OIuBIAtlRhXFHunfNTNfHtiJJ+y0Vw8/psGx4lVorC7ke6vgGd+WSQWf50WDlq0KcH2VZqSUapGFEsLdnr7tdL6ZFwgkv+I/TR+pjG3xi6csfd6zxHwpu+enK6ztjJFfFBwKrEknrdFY258io/DDofMBZNnBX5JKGfJwc31V2q33pJlbbegdSTJdcR2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLsXexqUf358mA1pQDjjSM5M05CkS3huzFQmePfrOic=;
 b=KnO2HUMiJuCnJ/okJZhx9Il/G++CWoM9Qd+NPANL/EbqF/EayIG9xzb68u+45y+BiCxLvJaXGzf1yyleJF7cxzIpgFMhoJCaxVD1TStwM5ogfCmiFKE7gXIe8S8gc2bSWsSYN9snORXRkBex9D/wlBZCeNzY0bbNAxOAbyT2/DbZfOGdtzMVh6DPTzqUAu0KwwDyrgTnr7nI/+Tdb6o8DVJAGa3vO6KpcJzTQyOX6Y1QscLK8NE/aCHO6iN7RHhVbRVUHVpQgk1vo5x1uB/XHOSa/g0QjWnb3ATm4fI++pJrR1De9pjsBY86yBg/YPuU28lu/26b5Iy0ypzMRlfpXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLsXexqUf358mA1pQDjjSM5M05CkS3huzFQmePfrOic=;
 b=bCIAKIpwhXhiB0SU91c7WqX01Q1GhVuuaz3xTJlWskZ0ZIafTKKIanYHm0LvORzR6YzfvAxS8QpSuMIuFivqnSNodQ65EnbjyYxxM0mcQ2H9DxyrtSILzVOOqPbeg4CYBbZn5YztIj63vj2CPWKv9za8jD2NlZvI1Ua4K0YZFpo+RoKT6jrL77CUuns05tOe1y47j8SJ5icN6vBims1EjrJsFGG4f5XgJe9d+qtdVfC1X7hyVJkpEumC67qPT8rdU6KX9M8gYFHfKX65akIVsdvZ7a+WSlHmyEj3dv8UfQwsT6/PxaoEqciglLL5+5lDwopPXh4lzWdjxdNfJXbfDQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:43 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:43 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:52 +1100
Subject: [PATCH v3 14/24] drm/omapdrm: Convert to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-14-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Simona Vetter <simona.vetter@ffwll.ch>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, 
 Felix Kuehling <felix.kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
 iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Mina Almasry <almasrymina@google.com>, 
 netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>, 
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
 chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=3555;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=I1P0JJA8/Ip9uzr48JcFWatJnXbDnNeSYuUse0aM4OU=;
 b=3QlzG/lKtPMCh+aMAuMzqlHGrWUJcaVtoKiBv5H7KBENFtXVy1A4P4iyUdkw82t+tsdv+0b1x
 IdX+ZLhi3qfAFDvUR84x0bejfQgyx319OzRA0PfTguaAfEA3Zhy7Xa/
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0015.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::14) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 324e2681-a711-43b1-da17-08df46cb314c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4UT9vm1oxjJyCjBtsyzt/gZkH303WoDgA2BWpCIWkL07c2Cl9/7vZIOXu0qK/DaE2vBs1kvg3tKpRmhzzppFxCS/T59/quRv3ul4K9yRHSJD9l54XiCEEqoUo3mVeD7ffbS9+ZuOSOR1QU8jbS7X4aDMm0KluVO/FFcVCJbn4Lq+fcB1W3ncfNpt0O/ZAzxZTh1xPuJiV5aKMBhqIA0XMwjOU1bxjW7+qGwxGcA0nq75+6YvLJ+JggY2cJUeLnYFzNWjS6l3E0lg+Rq+MixABjQQPCyCfUPhRKFAf3YHDqRWgO5qRooZjscJmoPzc1QKjl1VRkxBA6PoDNJkC55PdyfZBYFr4jy8xn6L7rp0mF4wH3YsE4i4VZWHf04gVjwbDr9W2YB5IjbqXpnPCYIfV+HIw5pNhNowsns/Iu3Ke+bbGWJ85OceoJDq/ltaTOaI78MdSugfzudLGHj5Aomz8/ThX1HoYK3I4U+roQLMVWfKbcbppxYPb0PT+s8ljnEr/H/1LQlb2FFWwlaKIPAkmLyiGqEq3CHc++malAPN9OxjzfjitMdInRe3W/oue2PcyYxO538LzIPwjovcWkHskQU+ef0glnICKTEigJAF+qn4SvvpPxz+vVQscxxp8+7grd8olzNCYFOTgrYtsYnLgtUenIlg/K1JPK9vS+NGDDrrSpnIm0MLTX5uf2MWoXeUdV7/FvZ2bEsCh5x+9wkrsg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVBuYmdwTGpiRTRKZEh5MUhzYlRBN1E5alQxemJsd1k5bDQvRExJRm10bFpt?=
 =?utf-8?B?bHUzSjhJUWlOK21kTFYzQjFjWERWTXZoWUk0cTlxV0UxZlNMVVB3TGZJVGFs?=
 =?utf-8?B?NFdjYkZpQk1XdkhtZFZzR0JEWjFQYlV2SndYL1VYbG83WE5yQmRYaGRWT0k3?=
 =?utf-8?B?RlZ5UUNScmQ2a1gvaU1ObS9Rbmlmc3AvY2E3VW5RS1owQkF4RzBmU1lYMHNl?=
 =?utf-8?B?MFFld3ZJODF4SXNoZGdWZGhiWUZ1SW9wc2tGTjRiMXNiTkNUOUVhaXZ2S2N0?=
 =?utf-8?B?TmRNZ3o2T0xjdmZQVCtPZXErSDJBaEtHNSsvSlhTS3h4WFFzTTJiVEsxcElo?=
 =?utf-8?B?K2lJSnlrN0hrU1VPWkZsZ1pvNXNqb1E2TXdoazJ1SWVyRHF5aExXNklLZDhu?=
 =?utf-8?B?V0NaK2lMVlUzVi9ENVY0S2k0akhYRGdpaVhqWmU4YTVPWStKYWpJc21WeWpm?=
 =?utf-8?B?L3ZLRXJVNmRjcE5kSnRlWGxtTXRoYUlWZ2tkN2p2bFhMbFpuTHV3Q0lCaWJG?=
 =?utf-8?B?NDVGUHNFcXNRRExab3pYNW5SdFAyaWpTRXo4bDJ0MXhqa2VlMFV4dkxwY09E?=
 =?utf-8?B?cnpteXVkNVp0ZHhyZ3JCYWhsTmJyUmQ3Nk9kZE1RVU5pNUh3UzlTY2RKMzlq?=
 =?utf-8?B?VjBuQkVJRVllekwwK3prZmd0YXA0RUhQKy9va3NnZ0FKYy9xNiswQkU2cmhy?=
 =?utf-8?B?azVyS2MvR1VKMjZSRkw0TUJmeVc5ZlVyYmJmSHNHOGlTcW5OaXRGcmg2L3l1?=
 =?utf-8?B?d2Exd1FybXJBUkRMdXZnSkpPTnduWDJPV0VvdzVjYXNSOHQvZVpxdG1manQ5?=
 =?utf-8?B?WmxpWFdPa2dxelE5WXM3TWhROFkySndPcVp0UlNZTzNsV2hxSzZKTDI5WGRP?=
 =?utf-8?B?bUY2cHJuemJ3eUduZkNLZEhRRzJLMThmUk5JbWppU3ZMVWtVdzViUmM0eFBB?=
 =?utf-8?B?VkRLRVVQMWFHR0RqSVVZSkxVRzRmQ2x1YnFRVFFzM0JGa2g4TGw5cWhhVWQ1?=
 =?utf-8?B?WEtjVzkwbUovcXRRYjB6MnVvS0JpUEV1aGx2NktkUUQxTmNNUFFaZ1NzVW5y?=
 =?utf-8?B?YlBuQW1BQ0lzTjJzRjFZWjNBMmxZQllUenN5ZUNWMHBiNStDdFUzK2VWVkRa?=
 =?utf-8?B?eEJhUkZQc01peWFPYm9nOC93bDdYMVpMTzU0Tk83MFB0YWFKN3ZkbTRONzR6?=
 =?utf-8?B?ODMvcjFmaWhtSWp4bk5naWVxdzQwSUZMRjJGbUxOWnJhM0hjVE9pdGdXc2Nm?=
 =?utf-8?B?T00xS1FQa0pZby9zeWdmOVFRN1hjTWNKN2N2amhqYytsMkZiZmxGVFdWZldH?=
 =?utf-8?B?cVEwTGxuODQ4YlNZV1h6UkJOZmxESUVYaUZpSDBsSGFCY0FwV0d3TytKL3BD?=
 =?utf-8?B?ZTl5OGNNM0I3MkcwZy9ydVhSa2dKRXhvbk54ZGZqZjA1cjYzM21sQ3JFbTZw?=
 =?utf-8?B?ZFJLcHJadHc2Y1paeDdRelE2YStORThvaFR3RkNKVVF0M0pDT1ZYVWN4NGVw?=
 =?utf-8?B?Q2FDQ3prTUlYQ1FvL2hGY21HbVZkVUVQQ3pqQkx2UnBKYmhDM05VZUFVZGl1?=
 =?utf-8?B?VElhcndMYUtTdmxLanU1NFN6V3pTSWE5SnloTC9Za0RKSmlQUnJZcUlTNjh0?=
 =?utf-8?B?R3NrUHpXa0FiU0ZuSHNlNE5RR1ZkdXJBMFo1MUN1RzdPUlVIRjQ5eG9FT1FT?=
 =?utf-8?B?S3laa1Q5OXF2bUZ2bmV1VU1HOTFNVHFXK3FRQ1QvRGIybDBDUkZXQm1HY0hH?=
 =?utf-8?B?UDdXTDh1bTRkSkJ5bWRFOVFyL0Jvb3ZRWTAyZ2VEUFVtRHhaVUhham9ia29I?=
 =?utf-8?B?ZXQxOEYxNDIyTzlUWndQZ0xCSWVTcWhtRmFNcXc3N1JwSW4vanBnaVF0am9Q?=
 =?utf-8?B?bXZPZlhpOUtIaUpTQkEwRXA5TEdSSGZ4SHVKZ3IzdEF5Vk05TFZ3ajk3RStw?=
 =?utf-8?B?Y2FCVFZDbzNwYmowdjB2cm1QZlBkMTZXQ051NzZ1cHp3MjZiSkVnVVJLUnNC?=
 =?utf-8?B?Z1N4QVFkc1lmUlBraHVPSFA0alA5eDdQTGNVbVM3Sjd2eFRXcGdYL0lraGFO?=
 =?utf-8?B?TUZ3UWJKZzFMazIvTWlDY3BaQlllb1poR3I3cmRUdmwzVDVBSXdrbDR3R0JG?=
 =?utf-8?B?TXhZTm0vZXJJdzBiSEpoS2QvbUxtbk0zd1pndGlLVXYrL29lSFpyNFRuNEdU?=
 =?utf-8?B?YStiVW1INnVrajZYZXZBWituWW85TE1zQ01TNWtZbm5TMWgrWDdEa3hKNEJL?=
 =?utf-8?B?OGVrVU52aVcvZTAzWS9NS0VnelhrZjVVTngvdHdBaHVVZ2xYZDZRZTIxK3B0?=
 =?utf-8?B?ekpaek9PT0RCSUNYcVRLTzRiRk8rNERCQ29RZmdpL2hCOTJheHFJZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 324e2681-a711-43b1-da17-08df46cb314c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:43.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFMFRpQztkP9i+WxWRJ8/TmMXBq+nhTa+tIq2eqjZZCm9jDpRRamgYRQKeRx8cBssgzGlwHSuQ4SFq9wEHRVQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

omapdrm keeps one struct sg_table per object allocated with
omap_gem_get_sg() and returns it for every attachment. omap_gem_put_sg()
expects the same pointer back. A mapping is per attachment and per map, so
it cannot embed or take over that table. Instead allocate a small
container around struct dma_buf_sgt_mapping in map_dma_buf() to hold a
copy of the table header whilst sharing the entries.

This way omap_gem_put_sg() can find the object's mapping to
free. The map and unmap callbacks move from dma_buf_ops into
DMA_BUF_SIMPLE_SGT_EXP_MATCH().

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c | 47 ++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index afae0a56da8c..1c03f892dac9 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 
 #include <drm/drm_prime.h>
@@ -17,24 +18,50 @@ MODULE_IMPORT_NS("DMA_BUF");
  * DMABUF Export
  */
 
-static struct sg_table *omap_gem_map_dma_buf(
-		struct dma_buf_attachment *attachment,
-		enum dma_data_direction dir)
+/*
+ * The object caches one sg_table and hands it to every attachment, so each
+ * mapping only carries a copy of the table header and remembers the table it
+ * was taken from for omap_gem_put_sg().
+ */
+struct omap_gem_dmabuf_mapping {
+	struct dma_buf_sgt_mapping base;
+	struct sg_table *sg;
+};
+
+static struct dma_buf_sgt_mapping *
+omap_gem_map_dma_buf(struct dma_buf_attachment *attachment,
+		     enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attachment->dmabuf->priv;
+	struct omap_gem_dmabuf_mapping *mapping;
 	struct sg_table *sg;
+
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
 	sg = omap_gem_get_sg(obj, dir);
-	if (IS_ERR(sg))
-		return sg;
+	if (IS_ERR(sg)) {
+		kfree(mapping);
+		return ERR_CAST(sg);
+	}
 
-	return sg;
+	/* Header copy only; the table stays owned by the object. */
+	mapping->sg = sg;
+	mapping->base.sgt = *sg;
+
+	return &mapping->base;
 }
 
 static void omap_gem_unmap_dma_buf(struct dma_buf_attachment *attachment,
-		struct sg_table *sg, enum dma_data_direction dir)
+		struct dma_buf_sgt_mapping *base, enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attachment->dmabuf->priv;
-	omap_gem_put_sg(obj, sg);
+	struct omap_gem_dmabuf_mapping *mapping =
+		container_of(base, struct omap_gem_dmabuf_mapping, base);
+
+	omap_gem_put_sg(obj, mapping->sg);
+	kfree(mapping);
 }
 
 static int omap_gem_dmabuf_begin_cpu_access(struct dma_buf *buffer,
@@ -69,12 +96,12 @@ static int omap_gem_dmabuf_mmap(struct dma_buf *buffer,
 }
 
 static const struct dma_buf_ops omap_dmabuf_ops = {
-	.map_dma_buf = omap_gem_map_dma_buf,
-	.unmap_dma_buf = omap_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = omap_gem_dmabuf_begin_cpu_access,
 	.end_cpu_access = omap_gem_dmabuf_end_cpu_access,
 	.mmap = omap_gem_dmabuf_mmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(omap_gem_map_dma_buf,
+				     omap_gem_unmap_dma_buf),
 };
 
 struct dma_buf *omap_gem_prime_export(struct drm_gem_object *obj, int flags)

-- 
2.54.0

