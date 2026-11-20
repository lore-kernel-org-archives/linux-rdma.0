Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154302;
	b=0Ovo42p2ikeYmdc1pesptq2WlwadKswKF7a+ETZsNwRLumR39uepYyZt5kmwv9dwA4pb
	 fQ0D7YX2m9o+mgcZ32oSdqV9ulPNYZamN2MXtX4btdyJbQcVZa7m4clD8Ki3CcaPoO98R
	 az8GNKbMMgB98F+26l+J1fydvthnsWFgjD9MnbJYsg4Rg+lu+o85xZqrobnZ+GL/zdlW0
	 UcQUQ3sJG46WZ85+J1lWiynvLX5nPBRviua436XcaGlgV/Nw7iO1eganN++Jw7per4W4P
	 7afRdxhGnX0lgpl6qTGcmJOCYvs5YVwOeIK+FUM1yaKG7noWMgFNEaz1NEUJxSPwr/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154302;
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
	bh=50h45EZgJ2afSNmkhgHbENXkoJjmnkRE1MnS3yexJ/U=;
	b=3HQ6k3VToP2gBuASXakN/1bz42ATFz9VT0h8pjWCvd8asIlia7PSVsrA8RCA/c1IlyVK
	 fjMAX1v7Kmvj3ysv0lEQ9Msc6Goh/9pxsL7f2mWovq2heunK69AOUtJbXOYCDScxoVPmu
	 YIqqvmQEyOvdZ+X2VOy2IxPCQHkBtJyi6G4x/H79lYn08xTT/kg4IAF7YVKK/ujSxwXp5
	 ko39SyIMQmmq0QGP3ioMlSyssOfXmM74cj+z6JIGCT9rXUVaMaqlIJDNioZeSOWpKqEko
	 fCgYWcXuMDEIuQ3NNUaQEFr+4qakr7WlYiXut624XKdigPpUeTXMlhPRs+N4n7TbM1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OiivRZEX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.19
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648360A2614;
	Fri, 20 Nov 2026 05:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5648360A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OiivRZEX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7lv3wC8VoxCyA0fnbvwGsnWEufKgYnO4rIlpqYEaVc4UIm4vjma83iuFWvyP2Bldf8DzpyqOm3V0uNluvAN4prNFFi7PQ2AOlQzcEOBQ4GscYlpvlLImV4hEHKE1x118J6MEl+/0TY97g8iX+//5tOGn86QR1Ne0UC3ZaOXWo1bYFwk12ifn0F0hh7O+YB5APkxgY3py4s5JbgRgHjJdXzU2QVN5+nu2JmbfVNRhcfrkDfPp3vOXJ/9A0ahKLDZ02ildYt7ZL0gRovXylMhGQwg59MdaYs8DUNrUn++dpz0Wnxd8zwNCY846IAtQeGgL+S1gUMGjZ7HKdjuxDadJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50h45EZgJ2afSNmkhgHbENXkoJjmnkRE1MnS3yexJ/U=;
 b=V1tiPpSM1Zh0RNuDd+e3w9rugddh9avhm1mU9bd4uLY89QDYh/0AxbkniZ7EQHMFEe6rdb52jYBk6h0XBfeo816hMGhiTwpM2JOiAsJ0yv7jKG4WhWxyepbc3P7y8IkOkhtGubO2tz8iIKn5SsUqI+cuAnSC8OcMc9d7KIiedgRQnjHigy+yYJO69XV++m+QbsugrSedFZ2r5kRlQio3I+5Efmm9ugT4RjqvJZEJVV/GHVeigb6D0efwfFfkTcu/PwYW8bq3KnTUnjsTv/dqd920q2e2a3sOu5jTqpybU0trTRBnDoTaH/i8EkI51AFlf0ih3se7siuIkc+5GvXYnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50h45EZgJ2afSNmkhgHbENXkoJjmnkRE1MnS3yexJ/U=;
 b=OiivRZEXTzWFUgpG62QeqiUSD30jtpaIgj9MJ6xspMTktatB+SY54NcEtHlasTYQhKn76fuCsw0f/9UwfHA2A6WbUxhiZqRQtr2L4oEVOSSPvOFa3LT614C6tsgRN1qKHYXzoyKX1Ed7dwZg72pjfrN4bKZA4ufoYjEm6qlgvGaFyePbZe9kZxTr5PhETtCeGGqNXjPNoeTRm08qKVTfEv/S7SAfR8zTCbCpukaZONdujGhkiIT3Efa/pDThYfBVZkB/091fmhnyOMDC1UVGIrRLDFaXF4ad3oqCuMpo+ZyS0pGxigjH4j8D5NBDChyF3kw2zjImG9JqVEDKauB8Mw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:14 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:14 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:58 +1100
Subject: [PATCH v3 20/24] dma-buf: Remove unused SGT stuff from the common
 structures
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-20-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=16539;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=7lWVZ6329SFjs2YHppRQHp0mh2+ugVSsC9glSq2B3qU=;
 b=0CocuNiUicSxNFwX7HshtuH7dLfflpJ1bgPf6DkQAe6YaYS1EMfU+bNjBVSEtB7rN4mB/hu9Z
 Nq0BBCnz6qHAWpCjS12z0ZVY9Scwh9mE2LkRdue5fumDg18Q56/Q+Iy
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SYYP282CA0014.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::24) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|PH7PR12MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: c6231111-edac-496b-95b0-08df46cb43ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261021123027099003|261102130727099003|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	7ZEwCWtUfOV+MMy+NEOiat7oZh8GvyECU4ldlZQ/gdGYmxjtY9o50MOfungbxosfEsbsCvQjgZVdQdWJ3J6ZvuG88dOndgRq4Y5iLUUFCVrWiIdtxT2p97uxjyHX2rElAW8Wbm7A0kd9wpTIMz/ZzY7bgUbZZDA8ukfRFEbUd9Bs/dSuWxttYpgJc6CGPI+CWcb1YMVFvBVYE0L8xfKgiunkE++L4oqzBHvnvmmlKnO35GBzXaKESH9sRT4oq8sxaivdjrgvkrRVmAHLTsReednhHNB7XLo3++OqtHyZ+OdiWfw7sn6PJVmMkPMcCuGWvFOcBFSbIOdlK4XJGmvTOcddDAsx3+aK7s9kdMH/REmKkJvYbNjlydaSvlS+Jja2CJeNAqHdc5/b2s7MffFWviwfXZ7HKNvazzjfLH8WS3QKlYCiKIE4x5duqy/+BvcanTBez/Hl1db7+DDZkfflqD7xAV8z53+XnbBj2IHKMECFgpv7BurnWlX1OjRBKs97PMJouwqXCvcQvMZKeb6UN1DTBr3N/tawyh5962DRXLRkvu3Uz3mtnwIcNOzE/zdcMW3bRd18dEY8LSekwFh7egZSya1aEjlRF2yu8EFj1sKMu88qsFS014J6qjBN0IruMgmZxJTi6KnvpCofLhVxi4XfoJVja9gepDXGHB0PyPhFSz4695GkrAGPyamOSAt1QzLncLAF5iMkcMNxXH97Wg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261021123027099003)(261102130727099003)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VU5hZVF1V0JIemdhM2xGMlkvK2F5TmZEdXQwY0Zadk5hSFhYWEJQUk1TSnIr?=
 =?utf-8?B?YzVvdjBMNURPYXRjZFdXUk1rdDBRVFQrR2sxKzRoZjNmNG9WUzhtb2l4SG02?=
 =?utf-8?B?bjJzUFBuZ3pURndKMHhEK2h6YUdEdlkvK1I0Z05qckhHRW01SUpFZjI2NWk3?=
 =?utf-8?B?Ym1HMlpGYjlXUVFDKzNVc2VwdElUK1JPcnIybDJ5NXhGem5BUlYrOElLcTNx?=
 =?utf-8?B?Q2xyQWJrbEMvcnMvbEJ6Tmw1a3c4MnRyeUVBMzZWdWpoKzhjVnpDN1hPUnRl?=
 =?utf-8?B?T1J0YjI3NFI4UWlrOTF5TmFmMFVhbVEzMjlrWUduYmEzdGdjYVlEME90NlJw?=
 =?utf-8?B?Y0xWWkN2QVZzZmFrcHZBWUVLS0ozQXZKcmlhY0pvakY2RFEveEdrRDQ2ZzA1?=
 =?utf-8?B?Y0Jpemw4ZndHd1NPMEFoQ0R6SXFhdGxDNjYvemMzc3hXaE8wcnU5WkxqZkFa?=
 =?utf-8?B?bEFkZDJvU09kdjVNYmoyVUhFbEtKWGdwblZYY0pXR2JBcU53RVJaUHF1M1FW?=
 =?utf-8?B?dEtob0RLWkJVNFZvajMzSkdhZkdicTl0UU5mQ1ZBK2VZek5zZVFqY1FkUzNZ?=
 =?utf-8?B?RGEwTG5JUTBkdUhUMUFNZ1BTU0xUdUJ1MVlyL0dEWThuUHhWaGZxVk1KK2ZK?=
 =?utf-8?B?MzZBMjFqeWRIeUVZcXBuV1ZuNVdubXRTREVlWWJxUGlXdFErMWJxdy93YXBY?=
 =?utf-8?B?T3JiMUNpS0xpMEhPTTRGSEcwSWM3RDh3SGhTY2E1cnBNcjFXUHBjLzYrU2lk?=
 =?utf-8?B?TjMvK2tFcXlZVTFIa25qbTMxTXZMM2dkV0Z1UE1oNDZjbjBqWnlZQTVXTkFp?=
 =?utf-8?B?dG9ENHZ0amZjNmZ6OVErNEo0UXFiTit4RG9GNjhlZXJCWDBPZHhVSm5kcE11?=
 =?utf-8?B?TzJiN0V3NVA4VzFEUEcwalZRdDF4MGRWWkpzZHhoNkpSeUY0SVEveXBRdzUx?=
 =?utf-8?B?L3pwK3JyU2gxdG1xK3FuOFdGeW9ibWR0UUdJc0Z4djI2amxPcFpMTzByNlQw?=
 =?utf-8?B?ZG1NVVlITHN5YUs3NHRQbVptUXF0eHRxeStLaDFtcXB0Nmg3ZE9zaTVKNWhL?=
 =?utf-8?B?RnUyM2lOeHFSMjc1eE5aUE43UWt1QWUvYjZCaTlKVkJQYjZ0VXJlSWpsODJ4?=
 =?utf-8?B?ajM3NldlY1Y1WCttZ2I4Q3BncFZ6Q0IwTkhibXFtWXZpZjZhZGlHeXliTmhm?=
 =?utf-8?B?YmIwN0lSdFBVNzJianBUaWtJbERpWnZVaWpucHRadTlSUkhkYnVsMGtZcC9s?=
 =?utf-8?B?N0FCVGNFZGY2bzV0dm5IcEFjdFJpOFdIbEtuU2ZhVXoyemc3NnVBL2RsQldS?=
 =?utf-8?B?dGtGUUdENXppTlVZSnJDdW9Uc3lEd2ZyY3Q0Z0pjeGQyY0pnb2lLNG5sY3Rj?=
 =?utf-8?B?R0Y0dlNBR01tNU9tNldlbVpLdE41Mm0vS0pPQjZzUGNaemVOU1pSTm9JVjRR?=
 =?utf-8?B?OGlXUjgzUFFoZWRaMTV4Um56aFVwSityTlZWV282WU1tOEQvT2JlNXkyNE1o?=
 =?utf-8?B?VU9iZzh2MHNjRGdIeHRwbHRHMXdXMFRLZXFhWW1SR2NQUlJMeTdvY0dNNC9n?=
 =?utf-8?B?M0s4NmIxTktTT3FBK3l1eWRNWFpNZ0NSYXMzWFFQVGxndmpXaXdKUVczNGxl?=
 =?utf-8?B?Smt0MmgwMHEvd2ZkRHVMbVA5b0pCWm4vWDNza01YWWNNaDRPS3BTZGtESzJN?=
 =?utf-8?B?akZralBJY3AxN1ZsVjhGVVoxdVZlKzhNSTQxSDRFeWpCN05GbHdlKzJUYUkv?=
 =?utf-8?B?Z3RSUlIwdUJMdjhVamhnd3IwMmFZdXVPVFFLY3MxRE1HbnBrMVZwMGNkbE9r?=
 =?utf-8?B?M2ErUWhIWmRBWnRDN2Q5R01YY05LQkZ1MlNiSmU0cC80emJ5dHFVNEpOWDZS?=
 =?utf-8?B?REFVczhVQ3VpTWxDRUhGRWp0ZEorbnAwZ0xEQWNpWG1LL2FHVS9heVFyTlF3?=
 =?utf-8?B?VXR1QzRWNStxa20xbHlkV2ZnUGMvc3Z0SDkxNHptYUozWnJCTitNdHBwU3Zh?=
 =?utf-8?B?YlVhU0t5TzRVc2J2Ynd4WFI0Q09mcHBDWHdnM1dEN1YrYXNMR2dsL0RJZkJy?=
 =?utf-8?B?eXNydm1DaE93SXJuUk9URnJpV1pmUFJzUlFSZm42VW0yclhqWGNOdnVhRFRp?=
 =?utf-8?B?YUpVdGtlL3VhNk96WGZRYjR6WWxod2R4RE81Ym1FcDR1MkNDZGhNa2JIU3ZV?=
 =?utf-8?B?cXI0MGFEQkZjeEE4ZkdteUo2NGtNa0NOV3dmZkIyVGhCMUhNQ2RxWDBGOHFm?=
 =?utf-8?B?V2hXazh0NkNjT3JmbWNLZDBJUGo1SE1DYjlaeEJIL0VYZ3VHOEIwMHZXamp6?=
 =?utf-8?B?ZUErMzRIeStuTE0rOXkrY1ZKM3lKM2Z6UGd6MmdqSDFhUVY1TURRUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6231111-edac-496b-95b0-08df46cb43ca
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:14.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSqTE8Kx9GazT7r9S28+kiX3wQzhz/20REa/HdJfyXXC86bp5kw2hZ2D9NZQ6LinF22cM8JnLz+v3aLTmZPqrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

Now that all exporters are converted these compatibility things can be
removed:

dma_buf_ops: map_dma_buf/unmap_dma_buf
             Moved to dma_buf_mapping_sgt_exp_ops

dma_buf_attachment: dev
		    Moved to the match set entry's sgt_data.importing_dma_device,
		    accessed via dma_buf_sgt_dma_device()

dma_buf_sgt_compat_match_mapping(): No compatibility exporters anymore

dma_buf_attachment: peer2peer stays until the PCIe P2P mapping type
replaces it.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 75 ---------------------------------------
 drivers/dma-buf/dma-buf.c         | 33 ++++++-----------
 include/linux/dma-buf-mapping.h   | 73 +++++++++++++++++++++++++++++++++----
 include/linux/dma-buf.h           | 73 +------------------------------------
 include/trace/events/dma_buf.h    |  2 +-
 5 files changed, 78 insertions(+), 178 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index d2730be4a9f5..cf3d25aa3884 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -335,8 +335,6 @@ dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			 const struct dma_buf_mapping_match *imp,
 			 struct dma_buf_mapping_match *match)
 {
-	struct dma_buf_attachment *attach = args->attach;
-
 	*match = (struct dma_buf_mapping_match) {
 		.type = &dma_buf_mapping_sgt_type,
 		.exp_ops = exp->exp_ops,
@@ -344,14 +342,6 @@ dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			.importing_dma_device = args->dev,
 		},
 	};
-
-	/*
-	 * Setup the SGT type variables stored in attach because importers and
-	 * exporters that do not natively use mappings expect them to be there.
-	 * When converting to use mappings users should use the match versions
-	 * of these instead.
-	 */
-	attach->dev = args->dev;
 }
 
 static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
@@ -366,68 +356,3 @@ const struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.debugfs_dump = dma_buf_sgt_debugfs_dump,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
-
-/* An unaware exporter's sg_table presented as an SGT mapping */
-struct dma_buf_sgt_compat_mapping {
-	struct dma_buf_sgt_mapping mapping;
-	struct sg_table *sgt;
-};
-
-static struct dma_buf_sgt_mapping *
-dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
-			       enum dma_data_direction dir)
-{
-	struct dma_buf_sgt_compat_mapping *compat;
-	struct sg_table *sgt;
-
-	sgt = attach->dmabuf->ops->map_dma_buf(attach, dir);
-	if (!sgt)
-		return ERR_PTR(-ENOMEM);
-	if (IS_ERR(sgt))
-		return ERR_CAST(sgt);
-
-	compat = kzalloc_obj(*compat);
-	if (!compat) {
-		attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/* The exporter keeps its table; the mapping shares its entries */
-	compat->sgt = sgt;
-	compat->mapping.sgt = *sgt;
-	return &compat->mapping;
-}
-
-static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
-					     struct dma_buf_sgt_mapping *mapping,
-					     enum dma_data_direction dir)
-{
-	struct dma_buf_sgt_compat_mapping *compat =
-		container_of(mapping, struct dma_buf_sgt_compat_mapping, mapping);
-
-	attach->dmabuf->ops->unmap_dma_buf(attach, compat->sgt, dir);
-	kfree(compat);
-}
-
-/* Route the classic map/unmap ops through the exp ops for old importers */
-static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
-	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
-	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
-};
-
-/*
- * This entry is used for unaware exporters that do not support
- * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
- * type so aware importers can transparently work with unaware exporters. This
- * does not require p2p because old exporters will check it through the
- * attach->peer2peer mechanism.
- */
-static const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_matches[] = {
-	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops),
-};
-
-int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args)
-{
-	return dma_buf_match_mapping(args, dma_buf_sgt_exp_compat_matches,
-				     ARRAY_SIZE(dma_buf_sgt_exp_compat_matches));
-}
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 6188cd11b004..20e397683826 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,19 +718,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping ||
-	    exp_info->ops->single_exporter_match) {
-		if (WARN_ON(exp_info->ops->map_dma_buf ||
-			    exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-		if (WARN_ON(exp_info->ops->match_mapping &&
-			    exp_info->ops->single_exporter_match))
-			return ERR_PTR(-EINVAL);
-	} else {
-		if (WARN_ON(!exp_info->ops->map_dma_buf ||
-			    !exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-	}
+	if (WARN_ON(!exp_info->ops->match_mapping &&
+		    !exp_info->ops->single_exporter_match))
+		return ERR_PTR(-EINVAL);
 
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
@@ -1009,8 +999,8 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *
  *     - &dma_buf_ops.pin()
  *     - &dma_buf_ops.unpin()
- *     - &dma_buf_ops.map_dma_buf()
- *     - &dma_buf_ops.unmap_dma_buf()
+ *     - &dma_buf_mapping_sgt_exp_ops.map_dma_buf()
+ *     - &dma_buf_mapping_sgt_exp_ops.unmap_dma_buf()
  *     - &dma_buf_ops.vmap()
  *     - &dma_buf_ops.vunmap()
  *
@@ -1098,13 +1088,9 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		if (ret)
 			goto err_attach;
 	} else {
-		const struct dma_buf_mapping_match *exp_match =
-			dmabuf->ops->single_exporter_match;
-
-		if (exp_match)
-			ret = dma_buf_match_mapping(&match_args, exp_match, 1);
-		else
-			ret = dma_buf_sgt_compat_match_mapping(&match_args);
+		ret = dma_buf_match_mapping(&match_args,
+					    dmabuf->ops->single_exporter_match,
+					    1);
 		if (ret)
 			goto err_attach;
 	}
@@ -1166,7 +1152,8 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 		dmabuf->ops->detach(dmabuf, attach);
 
 	DMA_BUF_TRACE(trace_dma_buf_detach, dmabuf, attach,
-		dma_buf_attachment_is_dynamic(attach), attach->dev);
+		dma_buf_attachment_is_dynamic(attach),
+		dma_buf_sgt_dma_device(attach));
 
 	kfree(attach);
 }
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index d73bff5d6853..850a76ffba14 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -172,16 +172,77 @@ struct dma_buf_sgt_mapping {
 /**
  * struct dma_buf_mapping_sgt_exp_ops - Exporter ops of the SGT type
  * @ops: Type tag
- * @map_dma_buf: Produce a &struct dma_buf_sgt_mapping for @attach, with
- *               &dma_buf_sgt_mapping.sgt mapped for the device returned by
- *               dma_buf_sgt_dma_device(). Called with the dma_resv lock held.
- *               Returns the mapping, or an ERR_PTR; NULL is taken as -ENOMEM.
- * @unmap_dma_buf: Unmap and release a mapping returned by @map_dma_buf.
  */
 struct dma_buf_mapping_sgt_exp_ops {
 	struct dma_buf_mapping_exp_ops ops;
+
+	/**
+	 * @map_dma_buf:
+	 *
+	 * This is called by dma_buf_map_sgt() and is used to map a
+	 * shared &dma_buf into device address space, and it is mandatory. It
+	 * can only be called if &dma_buf_ops.attach has been called successfully.
+	 *
+	 * This call may sleep, e.g. when the backing storage first needs to be
+	 * allocated, or moved to a location suitable for all currently attached
+	 * devices.
+	 *
+	 * Note that any specific buffer attributes required for this function
+	 * should get added to device_dma_parameters accessible via
+	 * &device.dma_params from the &dma_buf_attachment. The
+	 * &dma_buf_ops.attach callback should also check these constraints.
+	 *
+	 * If this is being called for the first time, the exporter can now
+	 * choose to scan through the list of attachments for this buffer,
+	 * collate the requirements of the attached devices, and choose an
+	 * appropriate backing storage for the buffer.
+	 *
+	 * Based on enum dma_data_direction, it might be possible to have
+	 * multiple users accessing at the same time (for reading, maybe), or
+	 * any other kind of sharing that the exporter might wish to make
+	 * available to buffer-users.
+	 *
+	 * This is always called with the dmabuf->resv object locked.
+	 *
+	 * Note that for non-dynamic exporters the driver must guarantee
+	 * that the memory is available for use and cleared of any old data by
+	 * the time this function returns.  Drivers which pipeline their buffer
+	 * moves internally must wait for all moves and clears to complete.
+	 * Dynamic exporters do not need to follow this rule: For non-dynamic
+	 * importers the buffer is already pinned through &dma_buf_ops.pin,
+	 * which has the same requirements. Dynamic importers otoh are required
+	 * to obey the
+	 * dma_resv fences.
+	 *
+	 * Returns:
+	 *
+	 * A &struct dma_buf_sgt_mapping allocated by the exporter, whose
+	 * &dma_buf_sgt_mapping.sgt is the scatter list of the backing storage
+	 * of the DMA buffer, already mapped into the device address space of
+	 * the &device attached with the provided &dma_buf_attachment. The
+	 * addresses and lengths in the scatter list are PAGE_SIZE aligned.
+	 *
+	 * On failure, returns a negative error value wrapped into a pointer.
+	 * May also return -EINTR when a signal was received while being
+	 * blocked.
+	 *
+	 * The mapping is handed to the DMA-BUF code and comes back through
+	 * @unmap_dma_buf. An exporter that maps an attachment once may keep
+	 * one mapping per attachment and return it on every call, see
+	 * &struct dma_buf_sgt_mapping; the core does any other caching.
+	 */
 	struct dma_buf_sgt_mapping *(*map_dma_buf)(struct dma_buf_attachment *attach,
 						   enum dma_data_direction dir);
+
+	/**
+	 * @unmap_dma_buf:
+	 *
+	 * This is called by dma_buf_unmap_sgt() and should unmap and
+	 * release the &struct dma_buf_sgt_mapping allocated in @map_dma_buf,
+	 * and it is mandatory. For static dma_buf handling this might also
+	 * unpin the backing storage if this is the last mapping of the DMA
+	 * buffer.
+	 */
 	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
 			      struct dma_buf_sgt_mapping *mapping,
 			      enum dma_data_direction dir);
@@ -242,8 +303,6 @@ dma_buf_sgt_mapping_dma_device(const struct dma_buf_sgt_mapping *mapping)
 	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type, \
 					 .exp_ops = &((_exp_ops)->ops) })
 
-/* Match on behalf of an exporter that has no match_mapping() */
-int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args);
 
 /*
  * dma_buf_ops initializer helper for simple drivers that use a single
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 5c8f090a9b8a..b1d1a239fa27 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -66,7 +66,7 @@ struct dma_buf_ops {
 	 * @attach:
 	 *
 	 * This is called from dma_buf_attach() to make sure that a given
-	 * &dma_buf_attachment.dev can access the provided &dma_buf. Exporters
+	 * importing device can access the provided &dma_buf. Exporters
 	 * which support buffer objects in special locations like VRAM or
 	 * device-specific carveout areas should check whether the buffer could
 	 * be move to system memory (or directly accessed by the provided
@@ -140,75 +140,6 @@ struct dma_buf_ops {
 	 */
 	void (*unpin)(struct dma_buf_attachment *attach);
 
-	/**
-	 * @map_dma_buf:
-	 *
-	 * This is called by dma_buf_map_sgt() and is used to map a
-	 * shared &dma_buf into device address space, and it is mandatory. It
-	 * can only be called if @attach has been called successfully.
-	 *
-	 * This call may sleep, e.g. when the backing storage first needs to be
-	 * allocated, or moved to a location suitable for all currently attached
-	 * devices.
-	 *
-	 * Note that any specific buffer attributes required for this function
-	 * should get added to device_dma_parameters accessible via
-	 * &device.dma_params from the &dma_buf_attachment. The @attach callback
-	 * should also check these constraints.
-	 *
-	 * If this is being called for the first time, the exporter can now
-	 * choose to scan through the list of attachments for this buffer,
-	 * collate the requirements of the attached devices, and choose an
-	 * appropriate backing storage for the buffer.
-	 *
-	 * Based on enum dma_data_direction, it might be possible to have
-	 * multiple users accessing at the same time (for reading, maybe), or
-	 * any other kind of sharing that the exporter might wish to make
-	 * available to buffer-users.
-	 *
-	 * This is always called with the dmabuf->resv object locked when
-	 * the dynamic_mapping flag is true.
-	 *
-	 * Note that for non-dynamic exporters the driver must guarantee that
-	 * that the memory is available for use and cleared of any old data by
-	 * the time this function returns.  Drivers which pipeline their buffer
-	 * moves internally must wait for all moves and clears to complete.
-	 * Dynamic exporters do not need to follow this rule: For non-dynamic
-	 * importers the buffer is already pinned through @pin, which has the
-	 * same requirements. Dynamic importers otoh are required to obey the
-	 * dma_resv fences.
-	 *
-	 * Returns:
-	 *
-	 * A &sg_table scatter list of the backing storage of the DMA buffer,
-	 * already mapped into the device address space of the &device attached
-	 * with the provided &dma_buf_attachment. The addresses and lengths in
-	 * the scatter list are PAGE_SIZE aligned.
-	 *
-	 * On failure, returns a negative error value wrapped into a pointer.
-	 * May also return -EINTR when a signal was received while being
-	 * blocked.
-	 *
-	 * Note that exporters should not try to cache the scatter list, or
-	 * return the same one for multiple calls. Caching is done either by the
-	 * DMA-BUF code (for non-dynamic importers) or the importer. Ownership
-	 * of the scatter list is transferred to the caller, and returned by
-	 * @unmap_dma_buf.
-	 */
-	struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
-					 enum dma_data_direction);
-	/**
-	 * @unmap_dma_buf:
-	 *
-	 * This is called by dma_buf_unmap_sgt() and should unmap and
-	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
-	 * For static dma_buf handling this might also unpin the backing
-	 * storage if this is the last mapping of the DMA buffer.
-	 */
-	void (*unmap_dma_buf)(struct dma_buf_attachment *,
-			      struct sg_table *,
-			      enum dma_data_direction);
-
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -540,7 +471,6 @@ struct dma_buf_attach_ops {
 /**
  * struct dma_buf_attachment - holds device-buffer attachment data
  * @dmabuf: buffer for this attachment.
- * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment, protected by dma_resv lock of the dmabuf.
  * @peer2peer: true if the importer can handle peer resources without pages.
  * @priv: exporter specific attachment data.
@@ -564,7 +494,6 @@ struct dma_buf_attach_ops {
  */
 struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
-	struct device *dev;
 	struct list_head node;
 	bool peer2peer;
 	const struct dma_buf_attach_ops *importer_ops;
diff --git a/include/trace/events/dma_buf.h b/include/trace/events/dma_buf.h
index 3bb88d05bcc8..13d3a82856b6 100644
--- a/include/trace/events/dma_buf.h
+++ b/include/trace/events/dma_buf.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(dma_buf_attach_dev,
 	TP_ARGS(dmabuf, attach, is_dynamic, dev),
 
 	TP_STRUCT__entry(
-		__string(	dev_name,			dev_name(dev))
+		__string(	dev_name,			dev ? dev_name(dev) : "none")
 		__string(	exp_name,			dmabuf->exp_name)
 		__field(	size_t,				size)
 		__field(	ino_t,				ino)

-- 
2.54.0

