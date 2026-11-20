Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154318;
	b=1cVCw0sxqQMKCb++QRrHMetoGx+mR5l+byG7Abufht4yEPtz3VZo53G1VhEIvdHdXHp4
	 be1zQzm83wvN4VXxivVx/MYCWru0Ji7Y++Esa4rGSJqOXaKQ67KbPBPbK4s7IX0aMTpVl
	 66ulHoi69lbeF2s8P1UcbTkZWW8euX5plU6/7DdtzFpoO+xqohvB8G5fhusPMEe64CquC
	 04VJ7UBXhZvYHfN9MGRyD+P+96a/fgNfi2iR3YqTsQaRb4U/DlPkyAZu1wPxN0m9BByaC
	 FzBXP9DKW2Jwxb6U6C788HUVLmNm2FVDZwmhL9HyqLNIbn7F3yRYy1e6nruGalf/FWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154318;
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
	bh=O4smh2lywxAeSgrEU2dSdFGrnTOP9GCSbnR04stSMzA=;
	b=k8MCdWvmfHTTo1rSTHycjAf5Bfy12NFqpQ9fqp+T/MFmef61MXE9ULKrGy++qXVRkaBx
	 dYNWx50ZpkRct1NBpitlL5nDB0uPttqVtgzYAmwMhlQgRw3edB71PVlwNdjnAcqakIu0Z
	 BIaZ683iw2S/v8wrwz7lrc23cuMix6yneEv9kFO9ASJL/3+1ITbQxPILBo3o09sx7eUis
	 FueHZ/OgEFg0SBp61Qw2q+PHwCRehUolK/Ul4auqwR1ONMy3wTd4qGN9uVOBvl6UWPPtK
	 RZParwwA3oX6cedDuKgzPcYQ9J0hi2s9uV2nPC0ojL4grhpxNulLFQB340f6/Ee92GQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=d9oDuQbr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.60
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95560A2610;
	Fri, 20 Nov 2026 05:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F95560A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=d9oDuQbr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ks861+zvwPrO07z9uENUmjYb7f0JpIzDLi9rauUAjg4aNg6SaxRzyO6h6gx30f+dg42E9fhOpSdCu5NRysgjlvUCVSeqqBUQcsEUj4EtVB11XJ1kUBQ+oDXiwSal6ow7NpQjgqeUXtyCWWpLOlIS10IuHSsJiGBC1iJqBmnGvuFoAyMiO+ac2DpmXJMNwGRMSlkd7SjQ2gypZUstkMern6hN9bRQ9gwLrJPDfubqFOa0TIurGwfeZ4uHT91Z/WyW8Wxo2UyKnCcVDB6lvSoZe/wPFJh1qxFLzOej/GX2QNBWfuGVfpMSGeKH8XAonQr/5f48QN8hP4SQ6L9XxFyLzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4smh2lywxAeSgrEU2dSdFGrnTOP9GCSbnR04stSMzA=;
 b=iaX8zsqVKg3P0TogqqdEY18AjNYH9Sxgbxz2ao6HbVJfdtGtRWGileBxf7RwIRK6eyFD94zptFZBaHBuurH0wpVs3ns49n7TPh+0/g93G7VVh6iJFM4lwTEgzDZP6K2Zk76COrIqFruyT9E7OOHWd/u3rKe/giV7if6xwcbJYdRY8cU7f8JapZW0pS2AslbKKlnL9OL8MrWP+u5k/hr9dalWzGs2BJXo8YbE5oqsrXEFslSNPzHx8nET6jBCcFWhIw99ue7OFJtd1dKTA3HzD6/myk38R8Vc5pELTwRr0+G8uW1gY6H1JxUAmF90Lo+4ztujsqVIfOVhtmodWmLWwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4smh2lywxAeSgrEU2dSdFGrnTOP9GCSbnR04stSMzA=;
 b=d9oDuQbrGbjPcYPAo3PxtQ+GNxzOwwJGXMxiVMcpO/X1WVGLoQ00Kzge8c7x6juIH3QnbU/60jcjqVFHJV5TOykxWV0cgnvlMESqbPh9SF5BB9xnrWPvfKk3PAQBZRhfxsbB5AtewCvJt/J2nTED5UntMuQYO9CXk7F0MFvBnCsxbzbQYuM+aRoPYZ0m0LwaAjNjUNRBAx4sKWcHfE7mckrPI36DUu/HK9KIcJgk77VykijSPcVpL/eQbXvWWUcfRktuupN8hE0L7rMOmqRb5TxkUUXVa8lhFBlk6TxHDdrrpcbq9noC9yrCyJ48kcVkvv4+I+y+z6I5Fz3H/QCriQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:28 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:28 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:56:01 +1100
Subject: [PATCH v3 23/24] dma-buf: Add dma_buf_mapping_map() returning a
 type-tagged mapping and implement it for sgt
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-23-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=14257;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=iVm3wX+XWzWC7Pszt86jBly1uS9Me0MmjQ9G+1ueuGk=;
 b=SbgSb23yao4O9XZJqfWmFc0Y9S2ZCLz0WKLjfapyztM1cS/x+a9hcYva6IAjQQxUzt8npTwGL
 DYlAE7WyeiZA8y/BR8cIqkfYjJi1Y4sEhydv0+tPdpI/rpBmsGXRCX2
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0132.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::13) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 3b53fffe-81ff-4e4e-33a6-08df46cb4c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261021123027099003|261102130727099003|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	8Uh4Cnvkxtunm8eKkFRXVTupT8BSkau4uvszPBn/PQ/7tSDVOFbyKLEWiU1DQnLcWsJ6GCKW+dOd1irQ+xsAJQHgyBGkn189GYMfGTlYNO7W75A5RGXc2gwiu8juiAYqvKMCashernKzz5Ot+r91BklBPSGHZWOUhXT+W5xcmaDW96Ewur5htoSKi5aX41/yZotKpgE0HmxTVTpmhG+u27VHVdHdnAEREQ6AuYBXHHF7tJ+w0MwPYwRfgHuLvwJ5UhjOTU0adBfnm2brhJMWBhVaoOqDKjDB+5fXHGVcq3tCNZYuN1QjM0WgrtWbH537k/cy8cuVZikRhuXyzCF3x/7csJKsKBqLZuPWNTSLtEwrrs2frGoY1NLrqPCNjT2AMQk5iiSqsGEYh4I9iYPKfSaYuBRythXfbaCnKXHFp4jyYvwSMj5VT8pPDpgX23gFtI8DnajH7JR5FT+Bm4aZX7b2pbr+RcwB73CTaHYtIFW4KBwI68mtZOaoM4kW+UhI7ndRWF0wSeCBc+OL+21N5UtMa19dU+CuNHPRAor7q/ENqlTXh+zicpYshY8NJaqE2p92SDOF7m9H0KTuyPqE6LMdmV4XtZNWgH2AZ/Tkg/UT2jpltXNCMzJhL56OOW/gNSAQeDTtE0mVrUguUsHJyKmJoGL+/bCIGl4623IE/CqzvNYWu3uzhznPfYLu2ydeKgGerMvUqCmjtPXd/rxxNA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261021123027099003)(261102130727099003)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VCtTMDhxMThiamxZVFdaSEtUVlA4a1BCUE9vcEVCKzNoSVU5NGxjaWw4TTV6?=
 =?utf-8?B?djVkNjhhVmlaMVRVRGlVMmcyQ3JNem84V3I5SXJXUndKZzNibnJTVldqMndy?=
 =?utf-8?B?ZVZHSnlpaG82U1dGdnRTY2tvZHMvdDd5eG5oU1M1c21nTVJHOVBTemIvR1Zl?=
 =?utf-8?B?cUYzNGRQYkd3VVcvajJ1ZEgzR21nRDBsVDlBUWdlZ0NFbEU5UW92Nk1DT1lM?=
 =?utf-8?B?MnlsQlg1UVNYb0VBckVnT1p5dEZ0MDlSZTJYM0Njb2pZWGZPbm9QbTIwUnFi?=
 =?utf-8?B?VE5SOFJDa1I1K3NxUnBycHd0UTB5Nlo3dHJkLzhpOStuY3VBQWxjc1gvcHRl?=
 =?utf-8?B?SlZLSGdVR0w2dmNQQmV3TmdkSTQwT1NpT3drUE5oMDF6aDQ2Q0dlcTJFLzJa?=
 =?utf-8?B?VEV2MFZTQ0VwcWkrOFdpM2xCT05sNkJZVE0zVEs4bkdqWkZUYUM2VXhqNnE1?=
 =?utf-8?B?aGVFbEJiTHBORi94QkZ1NXArTTd1Vnc0WEF0K0pWZVFGbktxWFc3Rk9MR1Bk?=
 =?utf-8?B?eWVnekE3RGZyMFhPZHZpTDhSN1FlSTVFTGFFRG1OYXZ6bmp0bWMvUUlTVGVN?=
 =?utf-8?B?ekdzVG9ET1BqWHY5Wk1Ic25CS0JpUDQ5SjFzUldPQVJMV1ZnT2d4bEo4SEtm?=
 =?utf-8?B?bDFqeFd5ODR1UDlQQ2ZYTTJFek9HODNFOFpiR2l1bU1ib290YnZySmovN0xS?=
 =?utf-8?B?T0xOS3dKbDhkWXlGR2tjS0RHMnFNZ2orMWxmL0hlVjMwcHJKakRTT09mVVZG?=
 =?utf-8?B?SWFHNnFlcEpXMU1JKzVLdmlTK0VaOGpXZlUwUXFWZTZFL0hsOXNlVFplSnRs?=
 =?utf-8?B?Y1hMQ3Mxd3lLejNjaUg2YWE5bjVXNTVwRjVwZVQrZHdUa0Z3eHJZeXVwTkRF?=
 =?utf-8?B?dTZIL2tRSUVkYUczRkVMWTBNcTNVcllaWTNVT1lNNzQ3b1JVVmIzQjU3akFX?=
 =?utf-8?B?RlExTm9XZFMvT0wyVGVoYStWTVI5b3RJUFNYNUVCdE1RZDduRjhpMksxcURa?=
 =?utf-8?B?NU1oRDcvdUlWNGU1Q0MzcDhacFdRK3hhbFYxbEttbU9mbllkSjJwNExRT0cr?=
 =?utf-8?B?VnpNNWs1eXlsclM4Z3M5b3lJeXgyT3lpOUF0N245c090dWsrVm5NclFwMXkr?=
 =?utf-8?B?UHBNMGdQZkd1UXIzRFZHWDRiYlBDbVkvelVBQ0dEaUdpaDdYVWsxN1VIM3VG?=
 =?utf-8?B?WnNSeVBFeStBWHllU0ZuWlRySm9QeklMQjhrT05vRi8vc3RVamZqbkZOcUVY?=
 =?utf-8?B?NkJVa2E4UjlGOStoeDd1Y2xLVklHUnZFRWtqUEczeEwvSFhuU0VNQjFlRnVn?=
 =?utf-8?B?SmZ5V1BuR1lReWxGSlZDUXVyY1F3d1gwUkJiaUtiakdUSEN3akM1aThCZmpP?=
 =?utf-8?B?NTJSY0lwWlpOK2pRU3NSU2R3YmdnSmJFT2xtWUhWYkY0SWF6UUxadmkwUHQv?=
 =?utf-8?B?L3JtdVNaMmp2UjFyMExNak4xSHpxU0hWTS9sU0VWcXZnZ0ZGQW1hcmFIS0FC?=
 =?utf-8?B?azRkWi9lZVRjWFo2cyswaXF5U2F6dCt5Nnc4MUxKSFNwRTlkb0g1cE8xeVIw?=
 =?utf-8?B?cG1KM0VKYkgwOE9kcDJMeTFidlhDSjNFeE96SkVQczFPZzhlYytYanFVTU1v?=
 =?utf-8?B?bDVWMCtrQkFHSHg4a213SWtvOURIVTVmaXZ5ZThQV3kyREIvdGV3SWc3QkhH?=
 =?utf-8?B?VEt1cTVGSUVOcWExVmE5VFZCdEYrQ05Nbzh0a0hSZGdHNmNxb1FvWWRFQ0pr?=
 =?utf-8?B?U3dNRDBqRHlBbWk2M05YMnVjYlpnVXNMbENubzhxVElXOGtqMzk3RW1xY2N4?=
 =?utf-8?B?dThOcDVHMUEvemVKTXBSbTZUbEthWVNOY01mWjd4NlVlOXlUR3JVcTFWSHlJ?=
 =?utf-8?B?VGV6QUVIaEtDazUyOFNlRk9TN2daZXZGVlFwT0c0Mno3ZnNoVWp5ak1IVG9a?=
 =?utf-8?B?M2FWaHRmcm0vZDdvbllWVjdtejVjWWdDSWRWWUNCdldBcUMvdUlMdFd1OUVG?=
 =?utf-8?B?dndQUkR2QTdwSnJuRUVqQ1NZRXplV0M2UytWSDlyY1YvNVJUMkJwc0ZZQXFZ?=
 =?utf-8?B?M01IREJUVTRTY1NXeWZZWkcyOUdmYkp1My9RT3Y2dXhlaW5ydHVtU2UrSGJ3?=
 =?utf-8?B?cXVES0I0NDlCM2hXc1hvQTF5K0R3U09zNzhmdWFzV0hXSmdSWWkwcy8rNmxr?=
 =?utf-8?B?N05zT0xjNVZTZCt2Y2RxMnlVYm9KcUFVV01SbmZySjRHYVNjelB1Z0s4M0lh?=
 =?utf-8?B?TlpES2g5WjMzcjlQN1ZRTXV2SmdacXIraS90Njg0NUV5b3FteDVsVTBSL05a?=
 =?utf-8?B?L0l5djNKUThod2lrN1hWajZocnQ4U2J6bWp4dVpNR2FYdGp4Vnpwdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b53fffe-81ff-4e4e-33a6-08df46cb4c18
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:28.1339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZXzGJajTxfhZ2TcIG/q02dFXFUDAzbrIxG/s+unoeX6PtFED9CJdWGU5kGjVeBHoTyEBzxoE0jrv4/4BurfOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

An importer listing more than one mapping type cannot know which
type-specific map function to call, because the exporter selects the
type at map time. Create a generic entry point to determine the correct
type.

dma_buf_mapping_map() selects via dma_buf_mapping_select() and calls
the correct map op based on dma_buf_mapping_type. That returns the
struct dma_buf_mapping header embedded in the type's own result.

dma_buf_mapping_unmap() calls the unmap op of the type recorded in the
returned dma_buf_mapping, so a mapping that outlives an invalidate and
a new selection is still torn down with the type and device it was made
with. Selection therefore only applies to new pins/maps.

The SGT implementation uses the existing exporter ops. The existing
dma_buf_{map|unmap}_sgt() functions call the generic functions
instead. Their result is the exporter's struct dma_buf_sgt_mapping, with
dma_buf_sgt_mapping_table() returning the embedded sg_table. A future
series will implement a new importer type that returns a list of DMA
addresses instead of a sg_table.

This will allow existing importers to be converted over to the new type
without having to convert all at the same time. Once all importers have
been converted the current SGT import type can be removed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

Changes for v3:

 - The SGT type's result is the exporter's own struct
   dma_buf_sgt_mapping.
 - dma_buf_map_sgt() and dma_buf_unmap_sgt() become wrappers for the
   generic functions.
---
 drivers/dma-buf/dma-buf-mapping-internal.h | 10 ++++
 drivers/dma-buf/dma-buf-mapping.c          | 90 ++++++++++++++++++++++++++++++
 drivers/dma-buf/dma-buf.c                  | 63 +++++++++++++--------
 include/linux/dma-buf-mapping.h            | 54 +++++++++++++++++-
 4 files changed, 193 insertions(+), 24 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping-internal.h b/drivers/dma-buf/dma-buf-mapping-internal.h
index e1337db2b205..568788fbafa9 100644
--- a/drivers/dma-buf/dma-buf-mapping-internal.h
+++ b/drivers/dma-buf/dma-buf-mapping-internal.h
@@ -26,4 +26,14 @@ static inline void dma_buf_mapping_commit(struct dma_buf_attachment *attach)
 	attach->selected = true;
 }
 
+/*
+ * Internal: .map / .unmap of the SGT type. Implemented in dma-buf.c using
+ * the exporter's &dma_buf_mapping_sgt_exp_ops.
+ */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir);
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir);
+
 #endif /* __DMA_BUF_MAPPING_INTERNAL_H__ */
diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 248ac81f616b..062aa61acc05 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -395,6 +395,94 @@ void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
 	attach->selected_idx = 0;
 }
 
+/**
+ * dma_buf_mapping_map - Map an attachment with whichever type the exporter
+ *                       selects
+ * @attach: the attachment
+ * @dir: DMA direction
+ *
+ * For importers that listed more than one mapping type. The exporter picks the
+ * type from the possible matches and the result records which was used, see
+ * dma_buf_mapping_type_of(). Must be called with the dma_resv lock held, and
+ * the lock must be held until the result has been acted on. Importers that
+ * listed a single type keep using that type's map function.
+ *
+ * Returns: a &struct dma_buf_mapping to pass to dma_buf_mapping_unmap(), or
+ * an ERR_PTR.
+ */
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir)
+{
+	const struct dma_buf_mapping_match *match;
+	struct dma_buf_mapping *mapping;
+	bool selected;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	selected = attach->selected;
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ERR_PTR(ret);
+
+	match = dma_buf_attach_map_type(attach);
+	if (!match->type->map) {
+		ret = -EOPNOTSUPP;
+		goto err_release;
+	}
+
+	mapping = match->type->map(attach, dir);
+	if (IS_ERR(mapping)) {
+		ret = PTR_ERR(mapping);
+		goto err_release;
+	}
+
+	/* A mapping handed out again must have been made under the same entry */
+	WARN_ON_ONCE(mapping->match && mapping->match != match);
+	mapping->match = match;
+	dma_buf_mapping_commit(attach);
+	return mapping;
+
+err_release:
+	dma_buf_mapping_unselect(attach, selected);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_map, "DMA_BUF");
+
+/**
+ * dma_buf_mapping_unmap - Release a mapping from dma_buf_mapping_map()
+ * @attach: the attachment
+ * @mapping: what dma_buf_mapping_map() returned
+ * @dir: DMA direction used for the map
+ *
+ * The mapping is torn down with the type it was made with, recorded in its
+ * header, even if the attachment has been invalidated and another type
+ * selected since.
+ */
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir)
+{
+	const struct dma_buf_mapping_match *match;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf || !mapping))
+		return;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	/* Torn down with the entry it was made with, not the selection */
+	match = mapping->match;
+	match->type->unmap(attach, mapping, dir);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_unmap, "DMA_BUF");
+
 static void
 dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			 const struct dma_buf_mapping_match *exp,
@@ -420,5 +508,7 @@ const struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.name = "DMA Mapped Scatter Gather Table",
 	.finish_match = dma_buf_sgt_finish_match,
 	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+	.map = dma_buf_sgt_type_map,
+	.unmap = dma_buf_sgt_type_unmap,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 8124e7bcd5c2..35863bda6ee5 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1228,10 +1228,9 @@ static struct dma_buf_sgt_mapping *
 __dma_buf_map_sgt(struct dma_buf_attachment *attach,
 		  enum dma_data_direction direction)
 {
-	const struct dma_buf_mapping_match *match =
-		dma_buf_attach_map_type(attach);
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
+	const struct dma_buf_mapping_match *match;
 	struct dma_buf_sgt_mapping *mapping;
 	signed long ret;
 
@@ -1255,6 +1254,7 @@ __dma_buf_map_sgt(struct dma_buf_attachment *attach,
 	if (IS_ERR(mapping))
 		goto error_unpin;
 
+	match = dma_buf_attach_map_type(attach);
 	/* A mapping handed out again must have been made under the same entry */
 	WARN_ON_ONCE(mapping->base.match && mapping->base.match != match);
 	mapping->base.match = match;
@@ -1336,6 +1336,10 @@ static void __dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
  * therefore users/importers should not hold onto a mapping for undue amounts of
  * time.
  *
+ * This is dma_buf_mapping_map() for importers that listed the SGT type alone:
+ * the exporter's mapping is made the same way and dma_buf_unmap_sgt() finds
+ * it again behind the returned table.
+ *
  * Important: Dynamic importers must wait for the exclusive fence of the struct
  * dma_resv attached to the DMA-BUF first.
  */
@@ -1343,40 +1347,54 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 				 enum dma_data_direction direction)
 {
 	struct dma_buf_sgt_mapping *mapping;
+	struct dma_buf_mapping *base;
 	struct sg_table *sg_table;
 	bool selected;
-	int ret;
-
-	might_sleep();
 
-	if (WARN_ON(!attach || !attach->dmabuf))
+	if (WARN_ON(!attach))
 		return ERR_PTR(-EINVAL);
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-
 	selected = attach->selected;
-	ret = dma_buf_mapping_select(attach);
-	if (ret)
-		return ERR_PTR(ret);
+	base = dma_buf_mapping_map(attach, direction);
+	if (IS_ERR(base))
+		return ERR_CAST(base);
 
-	mapping = __dma_buf_map_sgt(attach, direction);
-	if (IS_ERR(mapping)) {
-		sg_table = ERR_CAST(mapping);
+	if (WARN_ON(dma_buf_mapping_type_of(base) != &dma_buf_mapping_sgt_type)) {
+		sg_table = ERR_PTR(-EINVAL);
 	} else {
+		mapping = container_of(base, struct dma_buf_sgt_mapping, base);
 		sg_table = dma_buf_wrap_sg_table(mapping);
-		if (IS_ERR(sg_table))
-			__dma_buf_unmap_sgt(attach, mapping, direction);
 	}
 
-	if (IS_ERR(sg_table))
+	if (IS_ERR(sg_table)) {
+		dma_buf_mapping_unmap(attach, base, direction);
 		dma_buf_mapping_unselect(attach, selected);
-	else
-		dma_buf_mapping_commit(attach);
+	}
 
 	return sg_table;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt, "DMA_BUF");
 
+/* &dma_buf_mapping_type.map / .unmap of the SGT type */
+struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_mapping *mapping = __dma_buf_map_sgt(attach, dir);
+
+	if (IS_ERR(mapping))
+		return ERR_CAST(mapping);
+	return &mapping->base;
+}
+
+void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *base,
+			    enum dma_data_direction dir)
+{
+	__dma_buf_unmap_sgt(attach,
+			    container_of(base, struct dma_buf_sgt_mapping, base),
+			    dir);
+}
+
 /**
  * dma_buf_map_sgt_unlocked - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
@@ -1413,7 +1431,9 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt_unlocked, "DMA_BUF");
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
  * @direction:  [in]    direction of DMA transfer
  *
- * This unmaps a DMA mapping for @attached obtained by dma_buf_map_sgt().
+ * This unmaps a DMA mapping for @attached obtained by dma_buf_map_sgt(), with
+ * the type it was made with even if the attachment has been invalidated and
+ * another type selected since.
  */
 void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
@@ -1429,8 +1449,7 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	mapping = dma_buf_unwrap_sg_table(sg_table);
-
-	__dma_buf_unmap_sgt(attach, mapping, direction);
+	dma_buf_mapping_unmap(attach, &mapping->base, direction);
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_sgt, "DMA_BUF");
 
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 0a1c2934a932..98d5765cfdba 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -82,6 +82,32 @@ struct dma_buf_mapping_type {
 	 */
 	void (*debugfs_dump)(struct seq_file *s,
 			     struct dma_buf_attachment *attach);
+
+	/**
+	 * @map:
+	 *
+	 * Produce a mapping of this type for @attach, for which this type has
+	 * already been selected. Called by dma_buf_mapping_map() with the
+	 * dma_resv lock held. The result embeds &struct dma_buf_mapping, which
+	 * the core fills in once this returns. A map that may unmap its result
+	 * on its own unwind must record the entry in it first, since every
+	 * unmap reads it. Responsible for pin-on-map of static importers if
+	 * the type supports them.
+	 */
+	struct dma_buf_mapping *(*map)(struct dma_buf_attachment *attach,
+				       enum dma_data_direction dir);
+
+	/**
+	 * @unmap:
+	 *
+	 * Release a mapping returned by @map. Called by dma_buf_mapping_unmap()
+	 * with the dma_resv lock held and with dma_buf_attach_map_type()
+	 * naming the entry the mapping was made with, which need not be the
+	 * attachment's current selection.
+	 */
+	void (*unmap)(struct dma_buf_attachment *attach,
+		      struct dma_buf_mapping *mapping,
+		      enum dma_data_direction dir);
 };
 
 /**
@@ -91,8 +117,9 @@ struct dma_buf_mapping_type {
  *         selected by then.
  *
  * A mapping is an object allocated by whoever produces it, the exporter for
- * the SGT type, embedding this header. The core fills the header in once the
- * producer's map callback has returned and reads it to tear the mapping down.
+ * the SGT type, embedding this header. The core fills the header in, at the
+ * latest once the producer's map callback has returned, and reads it to tear
+ * the mapping down.
  */
 struct dma_buf_mapping {
 	const struct dma_buf_mapping_match *match;
@@ -110,6 +137,12 @@ dma_buf_mapping_type_of(const struct dma_buf_mapping *mapping)
 	return mapping->match->type;
 }
 
+struct dma_buf_mapping *dma_buf_mapping_map(struct dma_buf_attachment *attach,
+					    enum dma_data_direction dir);
+void dma_buf_mapping_unmap(struct dma_buf_attachment *attach,
+			   struct dma_buf_mapping *mapping,
+			   enum dma_data_direction dir);
+
 struct dma_buf_sgt_mapping *
 dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 			struct p2pdma_provider *provider,
@@ -294,6 +327,23 @@ dma_buf_sgt_mapping_dma_device(const struct dma_buf_sgt_mapping *mapping)
 	return mapping->base.match->sgt_data.importing_dma_device;
 }
 
+/**
+ * dma_buf_sgt_mapping_table - The sg_table for a mapping of the SGT type
+ * @mapping: what dma_buf_mapping_map() returned
+ *
+ * For importers that listed more than one type and got the SGT type.
+ *
+ * Returns: the embedded &struct sg_table, or NULL if @mapping is not of the
+ * SGT type.
+ */
+static inline struct sg_table *
+dma_buf_sgt_mapping_table(struct dma_buf_mapping *mapping)
+{
+	if (WARN_ON(dma_buf_mapping_type_of(mapping) != &dma_buf_mapping_sgt_type))
+		return NULL;
+	return &container_of(mapping, struct dma_buf_sgt_mapping, base)->sgt;
+}
+
 /*
  * Importer SGT entry. Usable in a static table: the importing device is
  * supplied by dma_buf_dynamic_attach() and recorded in the matched entry.

-- 
2.54.0

