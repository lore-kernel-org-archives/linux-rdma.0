Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154226;
	b=Dqtplr0GuioGngBcuCtP9ow3gKpj7l9dzso5/VD/WkRiLl+7bxAipMumd2EYs2MlP504
	 saCMgLq0TY3Z9v8dUnXTllwsPZsytao6D5GLSJ89Bjvcyuw6Nrvz7P8nD5eBCQva0Gbgj
	 qs1Vl/t8/ZPdvxyXhuOAneieftmfWL1jRLoQZ/Z93zU5C1EoJwgQ0wMeK83LHTz4BLnJe
	 4fH4yphzKjGxM5Am/NGJyCs+2s8DgBTxZ94DaMuUqF+B7wPkteeX3zo4bvPgtgtkuX3ii
	 Tlthz0rFBUpztHksweEw7wO8EU9/7iOltpsspFemkepMcMBKyjsFO21DhPisc4D47Dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154226;
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
	bh=v1XLlkXl0hzFNaeKTA0jIv/OVmh+E1VF/AqgQ5lNVHQ=;
	b=w/8qGF0ZRVVbA0kbpJO6sTZd2MSvGn4+4uAGtVTzxD+jVT2ekYkV5SWaM8blHgVB1DMs
	 vsbe3KECcBp/TgNgMa0i/PfhUijN3IDMuYDhOjOzMji/A465ftho1SuI7kYvZpCVMzig1
	 wTSUm6YbFw22eovkzyGHUOhHQBcDOVLpRKixnSutyHFgdJ0jZ5HuIIbIwsyW2AlMyelh0
	 2M9WS5UTaMyFhOY+5H154MlivK1R8z6r9WOf4ZF34WsPI4mSbWPVEtL9JaGfCsfLymi6O
	 ij5pTwd8kDBiez54YwGHo357E/bdqx/+xcn0vSaR4q4WE1nv4Rq1fU3XSGN/A407oCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HNGZXnuK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.24
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A443F606A325;
	Fri, 20 Nov 2026 05:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A443F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HNGZXnuK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cfbKvxklgHlM840gCQiZ8jRWz6O1pc/LeGEsvUB2h5FAdJoHvsNHjnPymnXUA9c/9H6IuOzo8iC6rsSYMGRVYBbFsUUoEH5fQfWAne/olaavv2ROl0E+t7pLBo6TLW5pdk0+JuBXupwlUtmouZHlpqe5EjcafVRHbIfwMFIEyQ4BCUC/WvZVO7qD7CETX0NmP8Hjq4IrTekQo56/pKxrhuu4SmGb30f+8s3+0OoUg3sk+gWI+kw8ZxvYM/c353dBif6DNmc7t8vhBH403KTffA5Zn16BDGhUKkm3cINlf4Vi5hjpoWghAyjzEoSuQgI9aSJNYsmVwWWevpZRLIA6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1XLlkXl0hzFNaeKTA0jIv/OVmh+E1VF/AqgQ5lNVHQ=;
 b=yl30Tw9iAYHsQwL2p3aIu0LEJRLBhIsyzhcQIW78MSNLQL+CZG7oGbVJSuB0xG7UDIWXukMGz0QpysZlgKVDLJXUnbtP9Be93JmT+2k3Jc0S+piFdVwYhTbFe+Ea0ZaXuenJsBcXz7yFjViS89xjOQx1qnFhn0IeoMiuwIHIBb83Bt8jAw2ob3yyHG0+zJnx5LWyldNg38YZQRUCKeTGuUJ86IQYoESVTNTog1HC9l7GAzCUPhIohsw+0lc8s08r6FceQa9JY/7PuN0jpKqmDHvVn+mPCMLSV6quOirBUiyt11v1yWGFzfoD695WfaOnyO3paBhxTVt7mg0IeRb1Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1XLlkXl0hzFNaeKTA0jIv/OVmh+E1VF/AqgQ5lNVHQ=;
 b=HNGZXnuKOl1hI9mXxgbqubY1zcUoCH6iD8l7f0RXO1ZEaR9Nbzrg09UcvYY6juA7eKriXo36JOAy5ZvAmibw8sdig56BWJpBCInS0Mo3yITggYprW1irvt09ZQ7YzX+Y2AVweKDyHM9BhGvBCG7LjwZLG9+BbjegoznYvuhW0lH9GYP9Nf+CxVYml799jq9NY80oYAGiJFl3KQ14STrMBsTY2yjWg89pdZVQ/fdSh4UpI72ly6SajPB3W2fXgCIr7KB7tO7QsGIwWwTB1wDeoxJrscH25aInUvTgq/2QiYluAtzCdpz4TCIgP3DVFF1AQZ4Fq8CWWYJUgWzia46/hg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:56:52 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:56:52 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:42 +1100
Subject: [PATCH v3 04/24] dma-buf: Negotiate the mapping type in
 dma_buf_dynamic_attach()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-4-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=7489;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=gLMYGQRqSfsf3MwD3JGwbr9zsgm6U3ScIshA5ISpbfA=;
 b=myNGuHsqrMv4QvT+AtIhntbaQGguj6pgPqdas+IoB1ognVgR2t/uxPJftM4yWuJPr6X/WqFRV
 cwiRPjdol9jDxze7MbPX17CPKM73QAZc1q0mHOYpvjmFygc5dLTPgRo
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P300CA0002.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::14) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: b8825d0c-b1d7-4000-9a68-08df46cb1310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mIwrPUyFD/Jj0EvZvzfIsM6pfoujCS+aGhEzJAMgSswxThIkJ+D0niv19T985wh0XUjwlXqJl3rVfeek9YSbeXDAHbfLc8eRxnWf3JJB1UfnioGPIO2DYTnIixd8pVdDjoLUWfyfuxAGfXloHWIBZ9YX2px/95Ex9I+ylkJCRA9Ded5D+uu7pVKVxKE5mpW2DEZwM6uaW5BY/oWC7WUZzHRKQ2Yw7vmo7JgRWQPK38r0o5ESK89HzC+KywNthQkyXkEg13YTJG//e15ICT8RyNUmhxTAkfLn4TFd0qAHOyDkcTvQGBtkUacojWK5y+cXFe9VS+L4iVOSujrVpLbeX30B64SdWzmH5wLfhDmtNLUwVzw6xGcbXKlA9hRtGmJbfMAD/1RieX6xx1C5JxA5XzmSVYKh9AsJ+7Rrlc1W9GNo8Y2Yz2RkaNUZcUKoS1zj6WFfLLk/xF1aK/1lygx6yH0WQKf1N4rPiMkiRymIa0DXyyRn5PaJmTetY9mdzeQuAUsoSWKe5icR9P9saQUBBPSWoj99jIbw+Q/PQQiMLu7bGfttgGYQOjonfpTQ6uDlxgQnRiIJEhN9cFqiEOhzzNWoytnUxzF+qkkPR7FtZtumBSIHn1bt/5v3eplbkfx28y50ImZ6n9zmPiU2pFrHDi4FCs/L/R2pt+eDfUkBgaieL5XTsvqu3aOUKjn6fg5Bi7bi+TAq/adxjvbDD2H2oQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjF3RUxXWGg4THhTOFpyVWJIVFc4K2M2eEJUajkxdGYrRTdsOXhtRHRNajdo?=
 =?utf-8?B?ZXNFQlNSTHFvSDU0YXZZcUhxOXVqYnBGTDBRMHdIQmFWUnFYRVRUSC91Y3Q1?=
 =?utf-8?B?ZFAwYisyMmhiZjROK2tJZTFLQmxXS3JYY1d5SlFTdWkzWmVtRG8rb3d3cnYx?=
 =?utf-8?B?SzNwWU5RZGUyMFlVRHVtMHVneXJzM2NLenB3VVhlb1FBcUhENng2bUdlbThP?=
 =?utf-8?B?cHREa25SM05zZ2d4d0tkZGE0MmR6OWdlOUtUUmhld3ptM0xQZVFPR0I1Y1No?=
 =?utf-8?B?YSsvKzlKa3FPWGxBT2VCdEdvNlg1ZlNJc2RTdFBPV1ZLZHFkcFVZWTRjZWFO?=
 =?utf-8?B?SE9OYTNlNlFkUG16OUJMNzRrdlEyeFpUSlpPZGxyc1UremNaRGVRbnRHRFky?=
 =?utf-8?B?UVhRRE9DS3A4dEYyQlNVTnpHaUNPRGhYZTZCY2x6LzZ1Yy9iME4vSEtkWUk2?=
 =?utf-8?B?WWg4WG9TUThkbExGQzBObDR1VnRQUmtHQUt2NUp4bmRNbXhpa0RPSEZoUGhi?=
 =?utf-8?B?WUlacFFyU3l5dWJLdHZ3MFY4eXRibHVxN0dFSy9sbHdBUVdQcFVmaVVxN0cy?=
 =?utf-8?B?UDNBN3BBaDQxMHpIT0Z1d3J0bExyMG00Z0luMmZRbHRWRmsxWnZlQ0dkZkU2?=
 =?utf-8?B?M0VCcjIrN2MwWVlKT1REbTlLVmdaNmxRTlVLck9zTUxOcm5oQVFWcFhkWkhw?=
 =?utf-8?B?Y2ZtNkxOY3RSbHYrU21STzlpSVg4Z0JyL2RhNnViWFc5QjljckgvdDByQVBU?=
 =?utf-8?B?ckxJUEJiK2t6L2QxUDc2WWU5MjhXRFZYRjhrNmxlYzhNUEcwNFpwTExpc1Zh?=
 =?utf-8?B?YzZGNVZoZ0ZDMVNLcXJabmovZkV0NmRjWko1YWErL2FjMVQ2RVhOY3kyYjF1?=
 =?utf-8?B?OTZiek85ekM4K2VKRFRnMm1PRzNrV3VUYU9BSElCYUlzS2ZpQitJSHF2dGpZ?=
 =?utf-8?B?eDdYTS9yd0xSNVN3aVYrREFKd0REcEVKRVFSUjVrYlVvZmdUbWxrVFY3UFVC?=
 =?utf-8?B?eGZGMmZrYUhjTmlGMjdpT0JBRW95NVZMS0NLN2dka0JseS9CSmR6RXlkOXRt?=
 =?utf-8?B?NllISzdNako5bVVjc2ZMZHBDQjMySzNDYWM0L0hRWHlNcUF0QkFGSjR2NjJ4?=
 =?utf-8?B?aGUzZGRCQXhoVGxJdU50cXdrUEJMZU5KRXBicXFxdmU2bmJJM3U5VEJJYzBW?=
 =?utf-8?B?WEpLQUp2MHh2dGFMaVNBUzIrWjIxbHZ6MnhLVU5ySHVra05xZW9jS0NacitN?=
 =?utf-8?B?aEVYSUhmVEV2bkxWWGxoL3hjMDI3TTNrTTA5ZnBwVkFPaFJMa1crbzNQeEZD?=
 =?utf-8?B?QVZnZ01pSkRZR0VKM3lrSFdaZnFCZDNxUm9nMFl5RVMxTmdVeUwwSS9wZ291?=
 =?utf-8?B?S2ZXMy9rKzc0RllyajhjcW9CV0hwVS9DTVI2cHQxSlBlVzd4OU5qTTdIa2lm?=
 =?utf-8?B?UFVSTjAzcytGc2s5cUg4QjVEMGNXak1JOGNYYitrN0RNNHJuTmJTU3dreExI?=
 =?utf-8?B?b0NuN0FpZm1Ra3ExNXBNNzIrVHliTEpyc3IzK3I2d2FLeHYwTjBwUndVcWZj?=
 =?utf-8?B?bGN6VXBmbTJFWVdJWEZDaWRQemU3WFNKSmw2OHpFTXlQOSs5QVNRaG50eExw?=
 =?utf-8?B?bWI0RG9RQzRJU2UrZmsycUp0NjI3bjNuQXNISlcyRlJmZzRFLzZEUmhjWENT?=
 =?utf-8?B?Z3R0SG9kL21iMEgraElDNDQwMmlXT3YrRHZLZjdyekJPTm0xdFB5eWpaVVFZ?=
 =?utf-8?B?OVd5R2dYUHRnaVZMM2pvcDBFMThrQ2JPL05kdDlKeklMTFQ2RVBrYWc0aCtP?=
 =?utf-8?B?V1hJRE1jZ2xRSW96VXU1aXJkSE9wZ0NlUlRianBUZ2RYRkV4OVpra2hNMC9t?=
 =?utf-8?B?QlBQck05UFpYTS9pcjkyTVJVRk9UMG5Na3pwUlJmdEJXTHJNQ2VBclpQSkxH?=
 =?utf-8?B?YXlQRVg1LzR1WHJvWXpLamhyekdkKy9QU3lSQ0IzQ2N2eVpVMWpBMXhIZzB1?=
 =?utf-8?B?czdNWlE1d05kU2VSU2hIU3U1TGduQ0xxNHo0bUNNcTBLU0g0UkJDWkcxV094?=
 =?utf-8?B?TytqQmpWMllVc09ObmQ4UlVsVExUTGFFZzJGQ3ZnVFJsMHpXVTJUaWVVbFlx?=
 =?utf-8?B?aUhTM2ZTRGdsSTk4RDVFaXFjU0prL3dDUVN1bG1zY3ZwYi9LNE80ZkZmU0tv?=
 =?utf-8?B?R2xtZmlCWmwyQm5MRDJXaFQ4RU5SdXJPZjFLMDhzRDhQMi9OV2IwdWIwSXRU?=
 =?utf-8?B?WGNscDVobHFzWnJCdUtPUGRJYXl0bUV4Q1BUZ0ZzYXF5dW9qUC9xUEI0ZkF1?=
 =?utf-8?B?a3JOdUdGQUpMVzd1ZEJkdlFCTjNLNEtTUWIxOUppelNkSElyWVExdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8825d0c-b1d7-4000-9a68-08df46cb1310
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:56:52.2787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sleKbPV4CfAn4vpyGFQ1cByGuWjBzjeGbWqSP17UWmZ9aJfE0ggKpVSVYeiGS3iya/UxhoSOqpTgsbfArMQycA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

Mapping types need to be negotiated based on what importer and
exporter can accept.

Add an optional dma_buf_attach_ops->supported_mapping_types table that
lists types supported by an importer in most preferred order. The entries
carry no device so the table can be static and shared by all of the
importer's attachments.

Instead the device passed to dma_buf_dynamic_attach() is passed to the
mapping types through the match callback arguments. Importers that do
not provide a table continue to support the SGT type.

dma_buf_dynamic_attach() checks if the exporter is mapping aware and
calls its ops->match_mapping() function to get the exporter match list
and call dma_buf_match_mapping(), otherwise it falls back to using the
SGT compatibility type. The resulting set of possible matches is then
stored in attach->matches the exporter's priority order.

The actual match which will be used is deferred until map time as future
attachments could change what's possible. Exporters that need to behave
differently based on the importer's capability can declare two exporter
entries with different map/unmap functions. This will be used in a future
series to negotiate PCIe P2P mappings.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

Changes for v3:

 - Move P2P negotiation to a later series.
---
 drivers/dma-buf/dma-buf.c | 54 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/dma-buf.h   | 40 +++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0dd8d0999a92..4aee479c4a7e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
@@ -714,11 +715,19 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	int ret;
 
 	if (WARN_ON(!exp_info->priv || !exp_info->ops
-		    || !exp_info->ops->map_dma_buf
-		    || !exp_info->ops->unmap_dma_buf
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
+	if (exp_info->ops->match_mapping) {
+		if (WARN_ON(exp_info->ops->map_dma_buf ||
+			    exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	} else {
+		if (WARN_ON(!exp_info->ops->map_dma_buf ||
+			    !exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	}
+
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
 
@@ -1027,12 +1036,24 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * Note that this can fail if the backing storage of @dmabuf is in a place not
  * accessible to @dev, and cannot be moved to a more suitable place. This is
  * indicated with the error code -EBUSY.
+ *
+ * The mapping types the importer supports come from
+ * &dma_buf_attach_ops.supported_mapping_types. Importers without it only
+ * support the SGT type. This records the types supported by both importer and
+ * exporter in &dma_buf_attachment.matches. Later attachments do not change
+ * the set but may affect what type the exporter selects when the attachment
+ * is mapped or pinned.
  */
 struct dma_buf_attachment *
 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		       const struct dma_buf_attach_ops *importer_ops,
 		       void *importer_priv)
 {
+	struct dma_buf_mapping_match default_matches[1];
+	struct dma_buf_match_args match_args = {
+		.dmabuf = dmabuf,
+		.dev = dev,
+	};
 	struct dma_buf_attachment *attach;
 	int ret;
 
@@ -1043,13 +1064,40 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
 
-	attach->dev = dev;
 	attach->dmabuf = dmabuf;
 	if (importer_ops)
 		attach->peer2peer = importer_ops->allow_peer2peer;
 	attach->importer_ops = importer_ops;
 	attach->importer_priv = importer_priv;
 
+	/*
+	 * The exporter's match_mapping() may look at the importer side of the
+	 * attachment, so initialise it before the match.
+	 */
+	match_args.attach = attach;
+	if (importer_ops && importer_ops->supported_mapping_types) {
+		if (WARN_ON(!importer_ops->nr_supported_mapping_types)) {
+			ret = -EINVAL;
+			goto err_attach;
+		}
+		match_args.imp_matches = importer_ops->supported_mapping_types;
+		match_args.imp_len = importer_ops->nr_supported_mapping_types;
+	} else {
+		default_matches[0] = DMA_BUF_IMAPPING_SGT();
+		match_args.imp_matches = default_matches;
+		match_args.imp_len = ARRAY_SIZE(default_matches);
+	}
+
+	if (dmabuf->ops->match_mapping) {
+		ret = dmabuf->ops->match_mapping(&match_args);
+		if (ret)
+			goto err_attach;
+	} else {
+		ret = dma_buf_sgt_compat_match_mapping(&match_args);
+		if (ret)
+			goto err_attach;
+	}
+
 	if (dmabuf->ops->attach) {
 		ret = dmabuf->ops->attach(dmabuf, attach);
 		if (ret)
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 6b423e22174a..cfbb800aa12d 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -29,6 +29,7 @@ struct dma_buf;
 struct dma_buf_attachment;
 struct dma_buf_mapping_type;
 struct dma_buf_mapping_exp_ops;
+struct dma_buf_match_args;
 
 /*
  * Upper bound on the number of mapping types an attachment can record as
@@ -303,6 +304,24 @@ struct dma_buf_ops {
 
 	int (*vmap)(struct dma_buf *dmabuf, struct iosys_map *map);
 	void (*vunmap)(struct dma_buf *dmabuf, struct iosys_map *map);
+
+	/**
+	 * @match_mapping:
+	 *
+	 * Called during attach without the dma_resv lock held. Allows the exporter to
+	 * build its own struct dma_buf_mapping_match[] and call dma_buf_match_mapping()
+	 * to record mutually acceptable types in &dma_buf_attachment.matches in exporter
+	 * order of preference.
+	 *
+	 * The match set is fixed for the lifetime of the attachment and so every
+	 * input determining match compatibility must hold for the lifetime of the
+	 * attachment.
+	 *
+	 * It must not depend on the set of attachments or on current buffer
+	 * placement as matches are static and buffer placement can change at
+	 * any time until the final location is resolved during map/pin.
+	 */
+	int (*match_mapping)(struct dma_buf_match_args *args);
 };
 
 /**
@@ -486,6 +505,27 @@ struct dma_buf_attach_ops {
 	 * required behavior.
 	 */
 	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
+
+	/**
+	 * @supported_mapping_types: [optional] mapping types the importer
+	 * can use
+	 *
+	 * Array of @nr_supported_mapping_types DMA_BUF_IMAPPING_*() entries
+	 * the importer can use in priority order. Entries are static so can be
+	 * shared by all of the importer's attachments. Any required dynamic
+	 * information, such as the importing device, is passed to each type's
+	 * callbacks by dma_buf_dynamic_attach() for recording in the
+	 * negotiated entry.
+	 *
+	 * If not provided the importer only supports the SGT mapping type.
+	 */
+	const struct dma_buf_mapping_match *supported_mapping_types;
+
+	/**
+	 * @nr_supported_mapping_types: number of entries in
+	 * @supported_mapping_types
+	 */
+	unsigned int nr_supported_mapping_types;
 };
 
 /**

-- 
2.54.0

