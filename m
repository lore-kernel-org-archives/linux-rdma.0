Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154227;
	b=rgTdvPMnFgvY0gO4bwHLOFzxxfpAAjs0O/z4atOosQyxar7S0Bwr8m7zrNSwc05VXyuj
	 xbC1ammQ/PyCHL3v+f32DrE7gXooZVl4V2VUqhUXFtE70+7bzLhiQZlmOqjcGR2Z0ANOD
	 aNjaGEzv/mgeXkC55IeTlgYJZRYkQI4y+B8WvBqpLYbekyhNHbpHfu+sqIpbxr3EtxDEx
	 NsZmwOFlZs2hGjTDmxjDXq2dkCN0dILdYmAsJSayeAUp5oT1B+qkZQv5tTgv8gniqLOX9
	 ArGGFgGP5AVM0d9h8ZfKaZejQOTJjzITJvWDt2PLzF2hcNdE276v4dXosmmKuPr6W2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154227;
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
	bh=DEp5GVqXLGw0P9TdOLkpxWYYT/p+Idnfogsp1fFAdfA=;
	b=Bz71/7fOJ4RVutLfExPH5yA0cWhChOybYQjzq1NjKVJTspLah6LhugMGWUVyhSksQeGu
	 OB7xDCLpTLRFMrt/xh/kDj6tEcJeYyrNhMBdbXlC6qBccumKvRX9KgyjEwBrqbhkfUs/r
	 iqn9K0f4bW8GqcBn8WpPVFh4GSLCfapdpy6cO+J193nBYg1jGauY3e7SvDiktEugcDfkB
	 b/d8R8BHS7AKS/lOycqk8NLW7zmMXuaLuuv/jzql0p4Tdnvd0OiGeHrGBYAmjTVZ1PoSI
	 jUXsmbX6JJ93gM8/4w069uqZswbHyFthSypxR/s0e8fz4m3PD9tBd4lZuxQwG5BEosw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CT1GYMHl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D98606A33E;
	Fri, 20 Nov 2026 05:57:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97D98606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CT1GYMHl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=osveI9SJZhuFVkH2a2+bzfX/c0H0EIzf7d5Nb9Gcc9lJj5t2qaAdczePcF1OtCopU2yhN/8IrbY3EDnBymDy8JPbjNA1h9krlFaD+6QOV8ufACpbwTTEXUsGILvo+skG3Ra1vzwoUSY4cEr3/YlFr9nJn8ha3VQZizYRLmhyP8tCe9jBvurp3xTKdIEZdoJzHQTLypd7p3JJCxx9CgqZTI2bNEL5SgQ6Q3XGDm/v8CV8EzGRt/5No5wD4urFwRve48QgUaN2jgUpSBOdW6H4KI8gKiviscDr0/8GmqhJcUFWazCQz2TuySnjICQNO2x+pRA2ITwudQa4d7lSVxbTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEp5GVqXLGw0P9TdOLkpxWYYT/p+Idnfogsp1fFAdfA=;
 b=bXabqq/TsDHgt3DgkhXZq94Hfu4XAzUujai4Q06FKQQsoV0gfleLwn6ri4ku7UPjT027V5fV+8lgBp1rCHV89ceS//VvhFIyJYKXYBrcg8JYgt4rFT+p9R9DpIz8NwczLwIfF01tmZJ5a6D7pxCnc6k8Qkij+lKWG7FczRBPWHDiuBIaxjDRRJQs08nMaoyfBM8ODexKK8j0H8aCbeps6BIJ7+dprwQNx9C2XK7V7FsjcnRSmcE2oyyDXiy0t5Pl+b98fBXvyIDWmYowjPBkTA8yDarEhBt/L3iX6mBse+PWNQVKqlx5Zt+N/oE0+byxEfdO18fncDO0UY9Viz0X4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEp5GVqXLGw0P9TdOLkpxWYYT/p+Idnfogsp1fFAdfA=;
 b=CT1GYMHl4Nyi+gJNZQ7SrzIOuPlrKFLkM4/761DdhSyHuTMNDSfRVzm1AUbgf42MO/2+UnWF8N0HBNBKfJHbVRdkLi/20tVV0WW/4IlZjxqXe6UzkWy9HeRNWEx9S5GvdhSJ521VDLjfiFgtfMiGphwWBACxC6f51zr+J8imKKf0JMd8HrvYxIvXLXA2ngIYNjbRwUKJ0Wvumin8DdA2rW98vQqLtWAZeb6JjpA1U/Wa8JmPB55ZHtzxsafgnw4HCOAiQhawKhi0JvuHNZ3hfe5pxwhdBf0NT9aUdBB2xg8EGKkRtsCSF8wFhDplAszfOD6EmRoVPhtdvxlgVYaKjA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:56:57 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:56:57 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:43 +1100
Subject: [PATCH v3 05/24] dma-buf: Route SGT related actions through the
 attachment's mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-5-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=7161;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=AmRZ7WMiWWalUd9nTs/m2szLg2plSSgrP+CSbEA8RVE=;
 b=1VE0pNorUlHL1GzImMeOOSh3hY7T148eioVwHpu1JQMC0jwD+NV6hq4hmQxn//HYasOFLp1q9
 m6EZ4N9tO9kAFRZKZ1p+mFmNmlLI0DJiOX81ktvZ5TOs22P48X8nZR/
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SYYP282CA0007.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 23e0898b-438e-45f8-b906-08df46cb15cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	0b71jTuKVP4dxHP16a+X3tPGbc6/Juh6Jyi6pZt9vNk144arkApIishRd0Mcx3HhItmOpKmj37oDGFts+T6WU+PhW10VAgwyMNyJxNTROBAf16wjmm8twijJ04+STsxk7Rq7djBw9ZCZWWLWuUG9aeEskSph7zxjqbA6Y+U8sBJDIjhLqG1ZWkjMva4EDkQh2F4r8D5hgnnJLXt/WjVR+EUwFgGSK3MtcYfDLdAzfIdztn9fUkYTZVU/OxlF/aICckDkT/BCbDvBdYB1ut0K3z4ZBLARv0/J2t2jPgJP7Uc8GyatLo5+k5RTvUpSOfiGycfiePeIsRtXet7CFg3EgfrNJ/YQE6jZbrOo7z4k3oqPC3Q85gJk/k801Q95jVuyChNG6GpX2yu0rf4atOeYZCtyIr7ZhXwtsgy/mPg148YR+wUnoK57Q0eAbTg6uGaq5K8lCfRQ7SATZsA2hFijIbUKN/Hh+5bm2dlY73L++YSrR+oUjsGvejYv7Cs2+bTCYEadYpuv/8ngw+7O6nCpZKzVueR93YokOZY7Rf//fp6O9ZM/SN1/TYg0MMNfoYZec1G7wcYSAwutGvSc+rpAyczpMkU4LqUQWP+YsllzYrVKfB+JAeY2VkkggmIwOfoOK6T5AKC4gA05ec4bsQPbK78lKbuI3bTzyW/TxV3JCLZUL8DmCE/VCNStnclqACk901uejON84hlE4192AtzTqg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlVCVUg4Z0kvOUZoWWFsQ1BUL0FXRXpnVXcxWW1abXltM3F1dHVHREt2K1VG?=
 =?utf-8?B?Kzh5N1pDNUsvNUg0MUJIbFNXVW5zOXRHT29rVTl0R0dDVWs4T2lkaGFYK0Y2?=
 =?utf-8?B?NHIyaWFwTUlQblhWeFdMKzVHYjdqamZ2WjhpRnA3MDdvU2MzV3FsVE1JdDZa?=
 =?utf-8?B?L2g3OVNLaGdielNxaVRmS3hybkpPL1NFdEFjaDlDNnhMU3o4eEsrQ3VLWjU2?=
 =?utf-8?B?T0VLVlYvVW1Nb0lCUkhzMnlnTUM2YTRMaDdCN2pEbVFJOXhXNzdrVUJRaklJ?=
 =?utf-8?B?QS92WDMvdWRHZFowL20vdGxFVWx6dE1kQUg1a2lnVlhucVFtOGhIc0w3ZEVV?=
 =?utf-8?B?N2g0T25QeEZIOUYrM1NSS1pramtKNVFmOS9zZXl2Y2wrcUhRUmMyU1hrNWpK?=
 =?utf-8?B?anJGMVhBSEdJS3djTWlnKzVrNDRUQndaanhsL2VCTWd0QTJXcGlTMUQ2Zm44?=
 =?utf-8?B?ais3SEtYNTdadnArQ1VHUi9MNHVzQVQ5citxYlpIUXRWcVhzZXVkbXZnSmh2?=
 =?utf-8?B?OWY3Q1pDV253aWZUOUxKeVhZOHJzbTZYcEc1UnMva1UvRHJmK3BUcUFMbjFH?=
 =?utf-8?B?U0UwTE9kaVF5Z2pSbjFRRGt0WVN0Yk51TjZ5TnZUWTdzdEtDZXY0YklaVEpK?=
 =?utf-8?B?bGtCTTlCRWZOQ1NYOHl2T1FjaDhFWkQzdTNxa2RzMXZMQmp4U3JJZy93UWpJ?=
 =?utf-8?B?R1RxZ3V3VC8vLzFnUjdKdGNSNGErNWp2SnZMMkV3Y1pzVkIvT0dVV0dwZ1FV?=
 =?utf-8?B?T08wODNBbHVpcjNpY0FpUWZiRjduVDk3ZndxbVlObzZtcytSNUE2c3ROQmVP?=
 =?utf-8?B?cVJ5WlFLTldVY2Q5SzR1WEhDZHRTQklNVHdYMnMxeWV6eTF4ZDAyMWNsRHdt?=
 =?utf-8?B?SHQ0SXdBemxjeWRBNkdrYkdLMDMvZEhNYnpINzVVQ0RIQ3BqV1NwR0c5WXph?=
 =?utf-8?B?K3pZTVplNVBXQ1hpcHhHRnRlWlFzYVlPalJURGpUS0RkU05oenBGZis1MGd6?=
 =?utf-8?B?TlhMMFBXeUhDRW5pZk83OXdiUlptQ0J4UDBvZm5lWEp5VmswMUVQblppSkJ0?=
 =?utf-8?B?alhmLytZa3Qvc2c2WWZnaHp3ZnVpWnA1dm1LbFlxWkJwY3JraGExM1RLRTVZ?=
 =?utf-8?B?bi9iRVBlem1oc1kvZkVaalRoQkd3bWkxM284SjZzdHhYV3BmLzZOdk4xbFk1?=
 =?utf-8?B?MnBudFFQRVRzM3h3N3p5aGd3TEZLRHhZTmgyYWMwYjhjU2VEd0Q2aDFiRFlM?=
 =?utf-8?B?M0tCTEt0RlZoRlkyUjJITXNDeUZYNS9KWmkzWStvNWdKWDZ2K2JlQ1ZKNWpU?=
 =?utf-8?B?eDhxVVd6cnBvN0dZTEo3MGlVZER1L1RNamlUejJ4dy8reEc5Uzd4UllKVUJ1?=
 =?utf-8?B?aG0reHRUS3ZRcFMxN2ZVcG94Njdaall4a2xMSmtqbU1iejJTWCtiamVqZE1u?=
 =?utf-8?B?OTJTelRuM2R0WU9vc2hFL3BNVmhzTkFPMDZpT05STUJ3cTd6NTJ2QkF0aFpC?=
 =?utf-8?B?ZGdLY2xBVUxRRHJsVVVITmNPYi82RjJZNzhTKzE3NUdwdWJmZkZKV21DeWl2?=
 =?utf-8?B?dnNJUFR6K1d4UU9xRnVMT1laQTJBd1dSTURIR3JoMTVLUDN6UENCYlJqa2dH?=
 =?utf-8?B?Vlk0azRGSGo1RVQrTG5WZXpnNXlLZVVVSWgyYlVnS0xNbmhrQlI4TUhCaWRR?=
 =?utf-8?B?Yy90R0JNM1BLQUM5ejFOUDN5QXpKZ3NEd2ZQNEJKei82TEtPR0oyYWovRTJC?=
 =?utf-8?B?RWQ0VWZTbDFqdW1yKzR0aExRT25UY2Z5bnVycmU4SWZVSXR6UVByWkFLUHBz?=
 =?utf-8?B?OVM0VFJGS0Fqbi9vSnVnNTY0OFlvOTBiWG1WQjR5K0xUMm9WOFN2eDlvbjJw?=
 =?utf-8?B?QTNBSS9RS2YvR1doZmVXaExoRkJVT3NqcFF2T1pUeFowdElMSDNaK3dZdC8v?=
 =?utf-8?B?aGd3WTVpZStVd0xtRStYN2lmSlBKaVFFcjN0Y3hWTEkwcFhsaDJLYUhjZEpU?=
 =?utf-8?B?TXJtMC9SWHJmem56bkg2clRSdnZpUjhsOUFJWHpHdVVycXlGQjFxak5aMVlW?=
 =?utf-8?B?YTNBNW9vWnV1WWlCOUNyM3RBMGtUWmY3Yk5aUUJzdzBNTHJSek90dEt1bnJ5?=
 =?utf-8?B?T1pjREVqTHFscWkwRGdFQ2RzOTFpM1krUTRQWHNQM3FPeVUvbExHclh6Skhu?=
 =?utf-8?B?ajYvMTZqd2kxbnZ1ckxnclc0SHZEMngzckJES2Z2WFc5eGxjckoyMnNIWW9p?=
 =?utf-8?B?M2pDdCtEVHdUN2hMdTZieWNRaWRXWHpWZVZiQ3ZPd3htUDJvb0hiRVhCR1Ez?=
 =?utf-8?Q?MOIB4deyBw97eK598r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e0898b-438e-45f8-b906-08df46cb15cf
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:56:56.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70RatpRxq2KKpdqV1+fOWlu0HVQ0StKfFz4elPrZa0Xqn4ADD1zM9wHMsXwb0b0W95SbxDbRowgmsiRm4uwm7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

From: Jason Gunthorpe <jgg@nvidia.com>

Now that dma_buf_dynamic_attach() ensures a mapping type exists, even for
exporters and importers that don't provide it, route operations through
dma_buf_attach_map_type().

For map/unmap this will go through dma_buf_sgt_compat_map_dma_buf() which
calls the same attach->dmabuf->ops->map_dma_buf().

The exporter ops now return a struct dma_buf_sgt_mapping, so
dma_buf_map_sgt() fills in its header and hands the importer the embedded
sg_table, or under CONFIG_DMABUF_DEBUG the page-less copy, which now
points back at the mapping. dma_buf_unmap_sgt() finds the mapping behind
the importer's table again and passes it to the exporter.

Move the debugfs processing unique to SGT into a callback too.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 84 +++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4aee479c4a7e..76340d067f6c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -56,7 +56,7 @@
 
 /* Wrapper to hide the sg_table page link from the importer */
 struct dma_buf_sg_table_wrapper {
-	struct sg_table *original;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table wrapper;
 };
 
@@ -883,15 +883,16 @@ void dma_buf_put(struct dma_buf *dmabuf)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_put, "DMA_BUF");
 
-static int dma_buf_wrap_sg_table(struct sg_table **sg_table)
+static struct sg_table *
+dma_buf_wrap_sg_table(struct dma_buf_sgt_mapping *mapping)
 {
+	struct sg_table *from = &mapping->sgt;
 	struct scatterlist *to_sg, *from_sg;
-	struct sg_table *from = *sg_table;
 	struct dma_buf_sg_table_wrapper *to;
 	int i, ret;
 
 	if (!IS_ENABLED(CONFIG_DMABUF_DEBUG))
-		return 0;
+		return from;
 
 	/*
 	 * To catch abuse of the underlying struct page by importers copy the
@@ -900,11 +901,13 @@ static int dma_buf_wrap_sg_table(struct sg_table **sg_table)
 	 */
 	to = kzalloc_obj(*to);
 	if (!to)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	ret = sg_alloc_table(&to->wrapper, from->nents, GFP_KERNEL);
-	if (ret)
-		goto free_to;
+	if (ret) {
+		kfree(to);
+		return ERR_PTR(ret);
+	}
 
 	to_sg = to->wrapper.sgl;
 	for_each_sgtable_dma_sg(from, from_sg, i) {
@@ -916,26 +919,24 @@ static int dma_buf_wrap_sg_table(struct sg_table **sg_table)
 		to_sg = sg_next(to_sg);
 	}
 
-	to->original = from;
-	*sg_table = &to->wrapper;
-	return 0;
-
-free_to:
-	kfree(to);
-	return ret;
+	to->mapping = mapping;
+	return &to->wrapper;
 }
 
-static void dma_buf_unwrap_sg_table(struct sg_table **sg_table)
+static struct dma_buf_sgt_mapping *
+dma_buf_unwrap_sg_table(struct sg_table *sg_table)
 {
+	struct dma_buf_sgt_mapping *mapping;
 	struct dma_buf_sg_table_wrapper *copy;
 
 	if (!IS_ENABLED(CONFIG_DMABUF_DEBUG))
-		return;
+		return container_of(sg_table, struct dma_buf_sgt_mapping, sgt);
 
-	copy = container_of(*sg_table, typeof(*copy), wrapper);
-	*sg_table = copy->original;
+	copy = container_of(sg_table, typeof(*copy), wrapper);
+	mapping = copy->mapping;
 	sg_free_table(&copy->wrapper);
 	kfree(copy);
+	return mapping;
 }
 
 static inline bool
@@ -1236,6 +1237,8 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 				 enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sg_table;
 	signed long ret;
 
@@ -1244,6 +1247,10 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 	if (WARN_ON(!attach || !attach->dmabuf))
 		return ERR_PTR(-EINVAL);
 
+	sgt_exp_ops = dma_buf_get_sgt_ops(attach);
+	if (WARN_ON(!sgt_exp_ops))
+		return ERR_PTR(-EINVAL);
+
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	if (dma_buf_pin_on_map(attach)) {
@@ -1257,11 +1264,14 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 			return ERR_PTR(ret);
 	}
 
-	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
-	if (!sg_table)
-		sg_table = ERR_PTR(-ENOMEM);
-	if (IS_ERR(sg_table))
+	mapping = sgt_exp_ops->map_dma_buf(attach, direction);
+	if (!mapping)
+		mapping = ERR_PTR(-ENOMEM);
+	if (IS_ERR(mapping)) {
+		sg_table = ERR_CAST(mapping);
 		goto error_unpin;
+	}
+	mapping->base.match = dma_buf_attach_map_type(attach);
 
 	/*
 	 * Importers with static attachments don't wait for fences.
@@ -1273,9 +1283,11 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 		if (ret < 0)
 			goto error_unmap;
 	}
-	ret = dma_buf_wrap_sg_table(&sg_table);
-	if (ret)
+	sg_table = dma_buf_wrap_sg_table(mapping);
+	if (IS_ERR(sg_table)) {
+		ret = PTR_ERR(sg_table);
 		goto error_unmap;
+	}
 
 	if (IS_ENABLED(CONFIG_DMA_API_DEBUG)) {
 		struct scatterlist *sg;
@@ -1283,7 +1295,7 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 		int len;
 		int i;
 
-		for_each_sgtable_dma_sg(sg_table, sg, i) {
+		for_each_sgtable_dma_sg(&mapping->sgt, sg, i) {
 			addr = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 			if (!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(len)) {
@@ -1296,7 +1308,7 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 	return sg_table;
 
 error_unmap:
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	sgt_exp_ops->unmap_dma_buf(attach, mapping, direction);
 	sg_table = ERR_PTR(ret);
 
 error_unpin:
@@ -1349,6 +1361,9 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
 				enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
+	struct dma_buf_sgt_mapping *mapping;
+
 	might_sleep();
 
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
@@ -1356,8 +1371,13 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 
 	dma_resv_assert_held(attach->dmabuf->resv);
 
-	dma_buf_unwrap_sg_table(&sg_table);
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	mapping = dma_buf_unwrap_sg_table(sg_table);
+	if (WARN_ON(dma_buf_mapping_type_of(&mapping->base) !=
+		    &dma_buf_mapping_sgt_type))
+		return;
+	sgt_exp_ops = container_of(mapping->base.match->exp_ops,
+				   struct dma_buf_mapping_sgt_exp_ops, ops);
+	sgt_exp_ops->unmap_dma_buf(attach, mapping, direction);
 
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
@@ -1838,7 +1858,13 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
+			const struct dma_buf_mapping_type *type =
+				dma_buf_attach_map_type(attach_obj)->type;
+
+			seq_printf(s, "\t%s:", type->name);
+			if (type->debugfs_dump)
+				type->debugfs_dump(s, attach_obj);
+			seq_putc(s, '\n');
 			attach_count++;
 		}
 		dma_resv_unlock(buf_obj->resv);

-- 
2.54.0

