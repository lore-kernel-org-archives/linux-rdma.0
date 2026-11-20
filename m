Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154228;
	b=uYI4FHGSui6CTMkjpa//P/JB8gZX1CPr8AtDxT8dMVfYZXMoNNHeqPTCNuoEo+xo/qlC
	 +CBnzHtj/sKE9G+8TdxPbF+1xf4RFYL15fss7d4obqfKFaum8K2t6RVumAPf835RILZZH
	 5YCIBuEiE1kvdsxujEiN1HImEhQiYyMA/sH738Oq5w7phH/Knp2wZfnkJfjzyUF1mq5QA
	 P02YbVC5MtX1uECXtX3YgGLbc88okSrupPXYNo+fopHLJFQDdaDTTbDXx7oQQUmPJQrqc
	 w94qN4ZDGaU8l3xofILWKPtDovGJVuC9sOhdG74bQ/2OiXlePfeaCgniI7W/8izlFHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154228;
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
	bh=oOZ4wG+0Cg9BKkrk9WLpii0Cfgl+7VKPVXylWrAei4U=;
	b=lf/KNxSnDCe3vPsVgUPzaFRKaIx6yauHevZlnsglJoxLD5evMMP0rbJAq2c7iHwATgnD
	 vvJhLYqQZInTCGlnb85Zf2NG2nyd1rhU9KapL7mVYAyet8CcuynTGo/uRs7SrzIzx1eVV
	 PvMlYsILhe0r4UcJc3GggcMC9YoF44SmOdEIOgjyNg+3gJElf/n17VybgLx4uQ6XKkcrC
	 A3sYD9YiU8mu9BFfHuU56Xo/vmPdp324a6sg/cd4ziqEgrDX6t+15No3NPHc6yujCpe75
	 5DFbO8WLTJyocCciQPstkTWEqepeUa17Lp8brVrNxjGuV4+m+DQkUdzLpb4dLKyjWLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dr+Y7CZI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F660A260E;
	Fri, 20 Nov 2026 05:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A9F660A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dr+Y7CZI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X2tUmwnLRHkBtr+GlbZr2Lp1lkOtXm/V+8+DUD6bG6oje7N3pYfuRNf/8tWWprvHTR9IOjwporWaLxp4uKXS7FK0ZXS1i8yOFuRqD4QqkmBkUPC7JGeKGtAZYstnyB6Yg0HsXBJKMnbQ4/n2s8hlejaUztA/Ltwmqs5q18XriOUYUfP/d87kYFAOJJwwfDVpqax5aQBeGw1O+zWYAAGY/RCrFg1WtuS8tTu1b+v4YtE1PXmBpo+DwiBeoGHmvkR+RDRDptLYhxPxwtnlxNGVmw6EeefMiFpWxdkyjMegMYVO/XBCvk90+o2NceKuqlWmdAFYB34skE8ueCVXhGZGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOZ4wG+0Cg9BKkrk9WLpii0Cfgl+7VKPVXylWrAei4U=;
 b=IgzDQFvs1xkeozxXqEVK8nLnZVvGodY65naLYP0FGM41qBbj+UucDQT8gQGaTzBoKNqzEkIr+qkXQr5BhRGXgxiQc9eqUXTgnF2WC801pp/zGLMBFvbg0k3IFJt+TJ36rBCg32QaTM/xwfnG8jfCcC/c20AcHPX+n3Oe3kO36kXrAc0E5GnJ6sRuDfIX8BmiFGYvZWrW6dHQ20IsYRF7/t3ScJPCA7L+eW9Eev2CkfJZO+u1nq+PcHQPYvL9CmEqVVIgI06IydjXgimhItjQr2NXtCM0MmgBQAdqeHc+g0ClOczXJI+mv+Em3cmZbieEHdQuFcf53RNJ0Ge+Y48dbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOZ4wG+0Cg9BKkrk9WLpii0Cfgl+7VKPVXylWrAei4U=;
 b=dr+Y7CZIAgHe93HLge1Fhac8dqsnD+hxD15xbkbXzQy+chjHvoa1ZXO3omk95WQkHmwapiZcQVm59+jChAsOpkZmR3qEAsN3xHoFkOJvBDe8TuzQpqoe2qFETDzIX75YGnnNFspsY0A8ZoeFM5IwKU3dU9g/nM9QVYcZSLd/huhrCHMFMcJRZSBAkmrwWDk7KWhCI08vw5LvLWEzjrwn9URRNpWtZEsJMqfPWEHyEOtW802HuTNGumWjrb8mIgZRC6ggjerTRjnYBEEXNW9kHLYVwi0Uls5s7FTHZrNjBH/H0TbVXHiYXHu24sTZ6gsmABdBS1e6EiOR1FeP+zDvzw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:02 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:02 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:44 +1100
Subject: [PATCH v3 06/24] dma-buf: Allow single exporter drivers to avoid
 the match_mapping function
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-6-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=3763;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=ZslO5m00dMh/hWP0sxl/X1iuz6bKgsA/EKsffZkJLQk=;
 b=cZ5iipJZ5nLWchunXbwRQMHn2CLivMg8Hg019YoGNDtCqjE6NspFmc1lP6VeglZrckvJKI5Jp
 tbxzqCTMfkwBm4qQzweWDFi49WmOGZpHQ+DSKUVBEiL3NolUlohGchD
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0028.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7d9bee2e-aad3-45c1-a99a-08df46cb18f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022113327099003|261021130227099003|261021123027099003|261028144727099003|261026130827099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261022115727099003|261021135927099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	BF01VW+oVEJe9gbHvaB9ngMCMtcd08k1i4C6UUIte4l5TA2/9/bJ9oNMFd8QbWZoBscxVoMQXJKIHrG6PEFF8wWrhkqXUUbSfdF94G9j2KjJWT78XG7QfjDtGXXBzbINX4i+naOidJRV1wpYmyaAgwkh8UkQKIEWuQtPQu8lM00DYc7R7N+KpKAzhyB5MObaRQYkCHkzgfht2lvbRgkIc+lvoZ75siP11lKev9e1Fs0wyij3YCFSDsQ5ZLrMJ2K4iRSY0Zk8eieDB22WYnwBOWrG166XSRieHkstlMAY58ZlpIfvZwYGVH0ZtMkcqFrbLtqfpWXp0D7JAyoh+9BjqyPpotFuen73WvPbzJbuc9V049yO6XlfxWlsuYjG543HXarqcMNrigKOdhIcrRK24ViFsG4jJp27YtF17TqRt3FAG3z/VJqattfLojMC3nBysmyifDFJWZReMZeFr9mzHERD0NFOmTTpoiKheaKCq7LjWjvKLYCGCnoAUBN2jOxfr7XuI5USGMrul8HMQW8SLKSWe6049SPeBdpUME92XCim2fca7RTf1VkRNZTNsGPJzOiEWTPLLUNaUAipncEc1Kl0JvTk8ySyBi6Pcz5MTD+ieoy6V7H8vQ32tnF0AdihzFsGAF4HjmPXx/9b1esK2XkDQHDomOx4LjPTf65eUINn/v1pgaQYyiyazUEc7cLujxwJS/mXlmyJHwhzYa0WYw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022113327099003)(261021130227099003)(261021123027099003)(261028144727099003)(261026130827099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022115727099003)(261021135927099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTZXUkdsZkRhOUgxT0h4NU52LzlhbjRqUGsxdVBudURkaEhRL0d1ZUt0bWtv?=
 =?utf-8?B?bWlEbEc0Nk9yNmRTenVYcExPOEE2SkpBaFBNb2pLWW5RZXpsS3laQ3NaYmQr?=
 =?utf-8?B?S212MDlhRkUrWHlDVzlaOTVDUHV0OW5uQk91MFBTbmlmS3k0L0w1Smt3aWhL?=
 =?utf-8?B?RE9lK21ITk1kRXVPa2RYQkJuN3p1U1plL1pKNGZuYzFxMEV5Qnk5c3JxeUhu?=
 =?utf-8?B?c0Jlb0xualYxTGIzay90T3hRem9BTzhKY3BZSmtuSkg3aXNtYTNSQ28xVFgr?=
 =?utf-8?B?ZlFLT1ZJeEtQV2IxdjZZcTZHN3RNMkFiQXg1V1doN21ibFoyVkwrcm5SK1M1?=
 =?utf-8?B?WkdGUlJCSmg2aVVoWVIzWk9mczlTQUNjSk9KKzhRS1ZwdEt1ZDh5ME01TGtP?=
 =?utf-8?B?N0hmSW1STzFIQ0pmNWR4SWdEQ0FkUldTWUdlc2pNazhxVU5GZ0VSd0N2Y080?=
 =?utf-8?B?YUhEVzRDNEpIbkRxU1FKdG5pbmllMm1ueEcyYlhvemp0eUFkUzJMUnNsZ2Nr?=
 =?utf-8?B?eDVoMmFRUXdvVEdZT0VITUpWZWZ4QVgrNGlYZFU5NGJiOHpXRW05VDFDbG15?=
 =?utf-8?B?dDV1OVA0UmlqaVJXSWpqbnFUMnVGUUZPNTB6cU5LSUpMaWl3My9jLzNXYnB4?=
 =?utf-8?B?cEhjeGJWZldwSit2dnJSOTcza1hhV1R2V0NvTk9TTjR1T2hVRFZrdTh2eWZF?=
 =?utf-8?B?d2VFN2RqR1Q5SHhpc3Q1Q0JDbHd5blMwVDh2M3A0QUx1Z0kyMUhMMktqM2dt?=
 =?utf-8?B?dEM2blM5Mm9QdkFXUTVta1MrV1ZCNUpmYTNJY1lVam1HanhRTDN6aWpUTWE0?=
 =?utf-8?B?TnhGZzM2bm5iYndNL0Vtb29xTExEWVhXWmliZ0g3bmxCSFR3NDlHRlRVVUNl?=
 =?utf-8?B?enc2YTU0M0kwcC9EY0tuMk5uNllpWFZhUGJPZzF5TjZrbXpqZzVzSGNKZTV0?=
 =?utf-8?B?VjAxdWQ0UDN1cFNWeEQ4RGdXYXlhK0dROFBzUm5EbUhFR1hORTFxaVl1WGJK?=
 =?utf-8?B?U3Z3NU9BalpGbFNHTlRCVlVXRUl0Q2xOcEhUYUp6TmRmaTNieXZaMG5pS09X?=
 =?utf-8?B?aEZCR2ZJcDBvSWI2MVpUY0RvcmMwbVJ0aVIvZGZnZFVkVC82Ui9tMmt4QTUz?=
 =?utf-8?B?SXZuZDdXL21ueStQSE56aWVlcTZ6dWhRWjVkNjMwdTRkck9PcHJxRmdVcXVO?=
 =?utf-8?B?a0JBMFF5V2tiWXZ2b2NzOEwyL2x0QzlPUExyTnQ5WGFmdjlibEFaVWpBV0pR?=
 =?utf-8?B?VGRvbk9YYWpTTXNwTHJIOWhmYmlXeWFoMVhyd0JLbTZkNGNBZWYzL1laZ2Vr?=
 =?utf-8?B?TTZtSWgxQnVrNlJET2MyVExFSmsyVjNxKzBKM0lWUjk4OXo1UEVHSEQ1SUR4?=
 =?utf-8?B?ZDJaNENCNlNNL0thcFdRSE9UNUVRRmg2RjRGWUZEbVdWcm9CWnpCcGIwb2xk?=
 =?utf-8?B?NzZJeVNuN1c4VVN6NGdlRktFZzkrR3lOTmZaL0tFcjFIOHRweWhPRW11MDda?=
 =?utf-8?B?dTFnV285L2kvNlFaMTN0M3F3L09rRzBlNExGSC93Zk9LS3hrRUNwNkZwcE8z?=
 =?utf-8?B?NFhKbmgyZ0FBcWZZREcxQmRFUmt0ZVVmc0k2Wkt5cVZUVkRmUkUzMkZvYXJL?=
 =?utf-8?B?RElQRFBLaHU0MFNiREkzcVZTSjdOK3pyWHR5NnVpai82RnlaeVl6RDU1TUh1?=
 =?utf-8?B?M09ZM0N0OUNjY2V2Tnh4T1FOMW56Ly9YNjh6TVpGangzSURiSTJKMjBPU2FT?=
 =?utf-8?B?S0U5SUxVV0V4cXlxUk13VXA4ZHB2QitKckNyRlJVU1JtTjBVc0hWMnU4N1Zp?=
 =?utf-8?B?TmtQY2R1bWd0cHJyTnVyYWJsK000dDZOV2VyU25YZVZ6dTE2U2JGSDdkbGdq?=
 =?utf-8?B?OTE3d1ZaeW5ENkRHOVY1UjdFYXVmZWNQN0ZReUJtUXhxVk5Tby9Pc3QyczRL?=
 =?utf-8?B?UnVBa0ZBNXlBVk9FcENZeWdZOWExNDNjS1FGcnN0eElPMFU2QmJKVnVnSUI1?=
 =?utf-8?B?NXMxUkJ0dFFZd0hxVnJzWURBZlA5TzdQMEVzb01YTnIrU0Rhd3NocGIzRWNG?=
 =?utf-8?B?RlhDVFhncjBRR2Nja2QzZFNlTUc1QjAzRnBhbWdIdGh5S2szaDY1TUJ2MkNm?=
 =?utf-8?B?SWhYdmJoQktLa1YrYkV2VHlUeHMydjZEZ2V4TDMxYVB3cXoxSjdCQ3ZoZ3Ir?=
 =?utf-8?B?bWZHUkpCejI0cTRMWTVyQzJESkx5RUNqNTZmMUp4TlRXd3c5SlBQU1h5cG1U?=
 =?utf-8?B?UGFaNFFPTWtQVExiRWJTYUp5dFpCYmVWT2piVlNoK1VpSVNEMVg4MzVxTXlB?=
 =?utf-8?B?M0ZaMytvV2pFUFJoY0RXRVZNbHF0YTFiN2F5VU5GZnp2T0hWaHl3Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9bee2e-aad3-45c1-a99a-08df46cb18f1
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:02.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wxf9bawyWbeg4jQw5RmTimEM7TLsEfzkRauINkUHNLGbYBco5fMSzMdbPZFhmnpwKmm+ED32ups1CMF4iEdrcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

Introduce single_exporter_match into the dma_buf_ops so that single
exporter drivers can simply set it using a static initializer to use the
mapping type APIs. Provide a helper macro DMA_BUF_SIMPLE_SGT_EXP_MATCH()
that generates the initializer for simple drivers.

More complex exporters, such as those offering more than one entry or
that need to look at the importer when matching, implement the
match_mapping callback instead.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c       | 14 ++++++++++++--
 include/linux/dma-buf-mapping.h | 13 +++++++++++++
 include/linux/dma-buf.h         |  9 +++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 76340d067f6c..6188cd11b004 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,10 +718,14 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping) {
+	if (exp_info->ops->match_mapping ||
+	    exp_info->ops->single_exporter_match) {
 		if (WARN_ON(exp_info->ops->map_dma_buf ||
 			    exp_info->ops->unmap_dma_buf))
 			return ERR_PTR(-EINVAL);
+		if (WARN_ON(exp_info->ops->match_mapping &&
+			    exp_info->ops->single_exporter_match))
+			return ERR_PTR(-EINVAL);
 	} else {
 		if (WARN_ON(!exp_info->ops->map_dma_buf ||
 			    !exp_info->ops->unmap_dma_buf))
@@ -1094,7 +1098,13 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		if (ret)
 			goto err_attach;
 	} else {
-		ret = dma_buf_sgt_compat_match_mapping(&match_args);
+		const struct dma_buf_mapping_match *exp_match =
+			dmabuf->ops->single_exporter_match;
+
+		if (exp_match)
+			ret = dma_buf_match_mapping(&match_args, exp_match, 1);
+		else
+			ret = dma_buf_sgt_compat_match_mapping(&match_args);
 		if (ret)
 			goto err_attach;
 	}
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 8be03b4ba6cc..e442ed0ede71 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -244,4 +244,17 @@ dma_buf_sgt_mapping_dma_device(const struct dma_buf_sgt_mapping *mapping)
 /* Match on behalf of an exporter that has no match_mapping() */
 int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args);
 
+/*
+ * dma_buf_ops initializer helper for simple drivers that use a single
+ * SGT map/unmap operation.
+ */
+#define DMA_BUF_SIMPLE_SGT_EXP_MATCH(_map, _unmap)                       \
+	.single_exporter_match = &((const struct dma_buf_mapping_match){ \
+		.type = &dma_buf_mapping_sgt_type,                       \
+		.exp_ops = &((const struct dma_buf_mapping_sgt_exp_ops){ \
+			.map_dma_buf = _map,                             \
+			.unmap_dma_buf = _unmap,                         \
+		}).ops,                                                  \
+	})
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index cfbb800aa12d..5c8f090a9b8a 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -322,6 +322,15 @@ struct dma_buf_ops {
 	 * any time until the final location is resolved during map/pin.
 	 */
 	int (*match_mapping)(struct dma_buf_match_args *args);
+
+	/**
+	 * @single_exporter_match:
+	 *
+	 * Should only be set by the DMA_BUF_SIMPLE_*_EXP_MATCH() helper macros.
+	 * Exactly one of @match_mapping or @single_exporter_match must be
+	 * provided.
+	 */
+	const struct dma_buf_mapping_match *single_exporter_match;
 };
 
 /**

-- 
2.54.0

