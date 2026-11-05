Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860998;
	b=LjZyBq1obwTnQtBLYhbNKVU8MFZGD/U16oTvNNv0+U9e5LiANpUxR1rCvUynss8nKBag
	 XHc/Y0pt1kvFtPO8qfonyyA4kR9qQWXGLSR9i5ZKP8DEB//rxbD0AV5OESUPcUpBcALjz
	 xbr6U3N/AA1EhjRMHaKzzAbkCZPOoCzteRbxRitRoOjcHl1rHoAB7mnNQERvj8CWDoIWP
	 ABy/JHRjGAfq0YR1V6iyyD74eR3LurTh343u21Gi1DcM8MR+xbZDO6qPOGDgwT2D0uu/+
	 bj+i3JdbrIQAYbQgYBcgG3ZSiu0fdMccooyS50ZcZJVILM8KM/OjiSQKPS/cnwYdzLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860998;
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
	bh=oxaYAoqJrLF7mUX16Tnu+y4TmGJii1VHyVzHWCmkR6A=;
	b=u3SSVyp9nzh7AVd2+zzulNVdS2ZKO0ixeiZN+cOP/hJmqtyI6yl4vDprAF5g51EKAW2w
	 o207KIhhwEpp/NfldDH7JeDc4LIYcyNuPqY2MGfMJwi5ZXY948+xztLrJSknyuN+FVIIi
	 XvkhY75fzWVBWMLTST07PXEw07ENFmBp1P9/yoDRwoJ4PLiouV2g2C/Cfx+RTMdrfpkAy
	 6sleZqGQe/X4DkDqYW4Cm0PMagW1+VzGI0jOLYFW7AxZgDTxcfJ1ch9Si1uHnBBdQzgNT
	 3CgUNActgoczob3w5he4a2IRJICc1n6NFTZYJxnuY6k/gLmC6rESkQ+Ow50ZaAFLz3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RzoHxgHn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737E6606A31B;
	Thu,  5 Nov 2026 06:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 737E6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RzoHxgHn
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0ZC//xoEsWLEB+zjfMQGZHzW21rDIVRKirbWdckp4fGK2T/z50qI+stIZndSFEDpzluzCT5ePrggBZCc1ymyh2RhDNmVtDmRZi4a+VXfBqATpaZJ9NYkB13c4Utb426POSHfBisC1g3mLbYLho08t4BdfRw02TQPH3iEUO/Ptu0puMdPrFZfpZQaSgTKfTCJ639WVmbfLunVL6HRO6vDyducPF4s7pMAyrvBvM7zffRsovVPLdkB9p5HdC/pFnchv/86wJt58jVtoAJf6hdOSZrdHjRajJdpVKpiL0RHsSPBXhA9SxlO8eLKRVGv027PWi6/zuClQVQ79pxdsLf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxaYAoqJrLF7mUX16Tnu+y4TmGJii1VHyVzHWCmkR6A=;
 b=n1G7RzUVepA9IKeJI+Jm38GUOgKqja4LUO8KtQyHzkBNewEBzJyg5z7fcJRk8ymjtpZk1Uqn7mRztEyhHz5afO7bcB3r3CmzYodi+i6sXdp7snshNinU3F+lgqlXrlTRYy9u0p6E08RK+6q5ZbB20xVX9k7P2hdTDLwPISvItG/WtXyt4fKGc6vb4J2Dgwew61qODXBySkuGZvJWK6n3gatRpHolRDwdy7vaPKi2qZf2gX+79Cy1NjEzcl9LOe+03V1qMXVStVgOqJM49xaA040Bk2VRfm6EM+rKgMlBmi+YZRrCDz+zX3IMVTHXqB6NbFPmTouGSCGiT4juJrOMew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxaYAoqJrLF7mUX16Tnu+y4TmGJii1VHyVzHWCmkR6A=;
 b=RzoHxgHn7al9x/Xm9AwR/crr74Io0CIVCxpTPZZCsqBybDe9z9Kv/eR7iFnu+Ti3g+RFkN+qKJMKO40JvVTalQtLMTBjg6w1Tq34E6kYTIMeD4L6+1o1LnHDLq+QQCMqYlF4ax8xunUSbKBWB4sSc+yr0glP7KH66fM4YM8dsbGm9q8ZXdEjx6KD0pwRQnJ+I/VCBGEkdSyQa38XvkOffv7HTrppnt4vJJ61LcNeIlTCcrc9Vb4zRuuvvdXk0uIC5ivWHSOZlBgerlspN2IZ7CEMbce4jweP0TFxdo2JVIOeIlyv6l6g/ndOGwj+iW4alE9CFubNE9gjvl26b66H6g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:43:13 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:43:13 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:57 +1100
Subject: [PATCH v2 22/23] dma-buf: Add kunit tests for mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-22-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
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
 Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, 
 jhubbard@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=14167;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=B2qRXMzhIp1qFb/po8FFiGRp9srzGPcnQZaxKQKjL/0=;
 b=/I+dCeGpSbU4hE3eocD1BgrXQ7IPxQX6R3TrUltmX1Gi5bv1VtFYlCbEi00kRqtnEcTn3FDMz
 anXmnfGpapRCyD6gO5gpOmRq5QG3peba38Ny62LwMTK3FVUyQTDt/8Z
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::19) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: 662331c4-9ada-4110-2d9e-08df3b081098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	rSCgurj+n36vocNrDmIVU4Lx5kH2KQT6jTtsMLTiZhFnoN7HniBD7W55CZUITxlgYHvV5kiD6JjBSIFZcR+NGGz7caFf2ymYCnBd9ncNLluQ8YaYxp3qTEF5UWPJynWdWRG/p6uNYunf2DhPj0BvaG5593Xu/GX2sNzGXtihLUzlQZXeS1B+yNB2bHaqacyVgyDkyIJUgb3kfW3tI7IXtn6ZsHe/fWweQjICoX+vmltLbbJtmyxttY4E5+7LNv2n32Sdt2GX3yZApiwoC84r27DZSNGTCsWlyFtG9dK9bxhQTStzUIXekAc4TUcNp07PAfesZi0iDg9y0B2aVy61/WdjjZGDqQZSoqICTwyj5ZU6aEa02LtNEAlqHLngMqVenk6FXLZMksUV8bha9oHAwth37RxxbzDdsoafx82/3QFzcXHEmYjlTUqdz5heKhhCwkhaGrTD760FTv8f+78sAHaTXcMtfa1qt/bDCmdc/HCIhQ2WPWgrgQp+KfB7xc4OFgt8/uOAyvG5QeaOB/n5BI9i01JPt97LwZ6buJMPFTlWWf+YbGgUqiFByuC8B4FZBvz85GcN87JUrJzdWK2LT9LKPEbFsCbRvZ97RqMwdmuPja5Ek+XxGpIn5477REoVrrkBHrVqLSUL2B7sHdjT7sVQJPSWr8ecGIGk00nLuO6KhtOKiVSPO6lbVDkFHhMAa4IOM5lpbPEuY515npe5XA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXpaQ04rVm5qSnBwdnBzbmFNcFN6eTVJS05NNVI3TVFwUFdWYzZpT3VXVkEv?=
 =?utf-8?B?UVp1dWVuRldhcHBXTFZWZXA5TlVOSndUWUhmSjRBRGl5NGljQ0g1M3dJOTUx?=
 =?utf-8?B?MDZnaCt5N1c1bGR5Nm9iNlVtT0E4MjhjZGV6ZHdYSDduZ3Q5bkZCc0JIbkNr?=
 =?utf-8?B?L1ExVTIyUUVHZm1tT2k4cy9rMU9hMTM0UnVnZ0M0azNRZ3E5a1E4OGhCSmF1?=
 =?utf-8?B?MytnSGMyczhpWWVhd0RrYlhxTytaRDJyb0tuMEVhYVFBdFRrWHJWTGhkUWZC?=
 =?utf-8?B?VTRmTTRIVEZSTXVFS3dHb0k3c3FIV040WnJHTEFEeUV1WTN1MUxYV09kWjli?=
 =?utf-8?B?RU83TzAwM25xRE11L0ZSSEI3ekNBYURWVUJ5b2Juc3JVWkFjNUhEZUhhZGwr?=
 =?utf-8?B?MUpFOXVKbHF6Q2FDY3VQOW80cENuMndsazBndWhuSVdJUnh2NnVDMjNwQmFJ?=
 =?utf-8?B?QklHMkRTZEVqdVZCVXpENElybk5yOWhVNUZlYXJWZVhBbkR6VHJSYlp5L1lk?=
 =?utf-8?B?eFZ2ZTJYSjhXV1NXaWtqVlBES1J2WU5PMk94cmlwdWJpR3ZnZk5EcG5VTWYy?=
 =?utf-8?B?bndTK3g5ZTJwOXI2N3dxbERWNzJXdTJTWERmK1NyMFNZVEtja3NzYjk3amds?=
 =?utf-8?B?bjl1ZGo0YWhTQk1KM2VsTVdLRGp1NkdWd05Jb3VuY3FSdTZFbTAxZjZuL0Vr?=
 =?utf-8?B?cyt2MUcwd09GekdRUkd0bGR0TG05blVmdlNVN2srR2NJN25OMVZlN3BXNDd4?=
 =?utf-8?B?SUNPeUFWNFZrUjA5aXlzblc0WXFKQkRKcWtTOXZwL1JTczJDeVhqcnJsK0pt?=
 =?utf-8?B?NFZEdU9hdlp6cXZQRUU5TUlYZHNrMnZOVCtBVzh0VFZ3RkdrTVBITGNTVktx?=
 =?utf-8?B?Nkc2bHdGMTdXUlNKWDAvTVo2WFAxU0g4bFN6bUY0emFnVzlVSXVJNzFZYnNN?=
 =?utf-8?B?b1dvVHkzOVdKZXJwL2xWQjcwallCNmozU3BQWWZkajIwR2Z5VDd6cGFTaXJF?=
 =?utf-8?B?THlVYjB3WmxHaW1mM09zeklHbUFscGpGbThhRXF1eVV6d2owWDU5elFGekFp?=
 =?utf-8?B?d3ozUHdTb3k1dlJVOU1hekFzMXRudDZhMEp3TzVSQWRsT1R3ck51T0hBaC9x?=
 =?utf-8?B?QVpXZDhTS1FzYjd3WFYzY0Q1c1BVZmxWRW40Yi8vcVUrOGkxNyt5N0VSTFJy?=
 =?utf-8?B?RHNMam1yTm16Tk1GSzY4RC9oLzBVaUlxTGpJZ0xZSXFQUU9kMHVaK1E2T3hx?=
 =?utf-8?B?cm9pYU0vRmNUR1cvcWRESjNhQUJGYms3Ny93S2JBUms3UGtYSnFBeW5tZHEv?=
 =?utf-8?B?end4VExOU3Jqa2I5cXUrdEpweGxRMmhKeklCbGJ4dWFBaTE3WXo5OGN0dndI?=
 =?utf-8?B?eGZPc3piR25tajhBSmxYTU0zN25vREFobHdZQStSdmlmYno1VDA5NnRyNkhk?=
 =?utf-8?B?NDQ0dlBaR1VITkt4WXNhUnBoQ0Z5dXRTS2JZYkx5ZWY0QXQ5VDNyWHl5Qk9q?=
 =?utf-8?B?ZEVMZFJPRjZteUlESmE0MlJ0NFdaZU40cjFQaW5YcFpPbHJnaExPT01FVVl1?=
 =?utf-8?B?UlBUMlVOcXBCaGN6ajFHOGpEaysrSGJ4MUhmclFoQ0s4UGV6U1V4MlMzbGhv?=
 =?utf-8?B?NktFQXZtYndDNml4UW9nVFppUldoTStXcTJCaWhEckozRHdVa3BjWFUxY3Jx?=
 =?utf-8?B?N04xQVRVaCtxbnNlUGRqVXBtam9CbDIyWFkycGdFZzkxVTUxL3djcTBRUS96?=
 =?utf-8?B?M1BkbjJVSVJtY3Fmd2hwcmRHZDl5WVJVMjdrdmMzRmlraURsNFJGZkFvV0ZE?=
 =?utf-8?B?Y3pXbGNJU0VhdmcySEtlaWplUGd0aFA0UVhhK01jdzNjMmY0bnZWRFQ4RGhS?=
 =?utf-8?B?eUpYVjBaZlh1SU1LUVcrZTdZQW5FRjhvckZQU1pvNHVUVmVKQ2VraW0xaHFU?=
 =?utf-8?B?YUdZRVMvVEl4Z2xYN0J2UUFUOTZCdjJqblpXcGFRVXRTa0lGOFppZnk5YVBx?=
 =?utf-8?B?YmxFZzBtNEVNaDhlalRqQ1krU0N3ME12T3FNYkNYU3BLaVF5bGlxbkNRcXRr?=
 =?utf-8?B?N2FicWVpeEZGZ0lGbjdScmRSLytYaHRhQy80UmFQczBZMUkzYW42a29jeHJS?=
 =?utf-8?B?NlB4b2ZIQVdtdnpHbGcrVnA4REFRcmkyNVdFZzhMMHFQdVl3dmtwcTBQbGRJ?=
 =?utf-8?B?ZXVOWnVGZzA1d1FNcWxQa2t3djdKc2JWZmI0bFdyNnF6dWFreW5kS05oWkJZ?=
 =?utf-8?B?UkxiMXpWU0F1ZDNWcWFuZDU2NzI4c3NGcmJuT0FDTGVuQmpvcHhWM0Z5eUw3?=
 =?utf-8?B?eGRLdks3OFJhQzdEOGlENXhXbENrT1A0a05wa1owUFJXRllPMkYrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662331c4-9ada-4110-2d9e-08df3b081098
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:43:13.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnsNlPrgyZL77z/iuMFfFQHHAmkDGlZgNmzCJPD4MlCd58nHnRJkPVuftVFicbN9iUUCPhy6cEyn5kA3qNnw0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Some basic coverage of common flows:
 - Check dma_buf_match_mapping()'s rules. These choices effectively
   become driver facing API and it would be a pain to change them later
 - Test the dma_bug_sgt attachment flow to see that the new wrappers work

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/Makefile         |   1 +
 drivers/dma-buf/st-dma-mapping.c | 403 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 404 insertions(+)

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index 523731b0f83e..02745fca8b88 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -11,6 +11,7 @@ dmabuf_kunit-y := \
 	st-dma-fence.o \
 	st-dma-fence-chain.o \
 	st-dma-fence-unwrap.o \
+	st-dma-mapping.o \
 	st-dma-resv.o
 
 obj-$(CONFIG_DMABUF_KUNIT_TEST) += dmabuf_kunit.o
diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
new file mode 100644
index 000000000000..cbfa99aeb0ff
--- /dev/null
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -0,0 +1,403 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for dma_buf_match_mapping()
+ */
+
+#include <kunit/device.h>
+#include <kunit/test.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
+#include <linux/errno.h>
+
+/* Mock tracking state -- reset before each test */
+static bool mock_match_called;
+static const struct dma_buf_mapping_match *mock_match_exp_arg;
+static const struct dma_buf_mapping_match *mock_match_imp_arg;
+static struct device *mock_match_dev_arg;
+static int mock_match_ret;
+
+static bool mock_finish_called;
+static const struct dma_buf_match_args *mock_finish_args_arg;
+static const struct dma_buf_mapping_match *mock_finish_exp_arg;
+static const struct dma_buf_mapping_match *mock_finish_imp_arg;
+
+static int reset_mock_state(struct kunit *test)
+{
+	mock_match_called = false;
+	mock_match_exp_arg = NULL;
+	mock_match_imp_arg = NULL;
+	mock_match_dev_arg = NULL;
+	mock_match_ret = 0;
+	mock_finish_called = false;
+	mock_finish_args_arg = NULL;
+	mock_finish_exp_arg = NULL;
+	mock_finish_imp_arg = NULL;
+	return 0;
+}
+
+static int mock_match(struct dma_buf_match_args *args,
+		      const struct dma_buf_mapping_match *exp,
+		      const struct dma_buf_mapping_match *imp)
+{
+	mock_match_called = true;
+	mock_match_exp_arg = exp;
+	mock_match_imp_arg = imp;
+	mock_match_dev_arg = args->dev;
+	return mock_match_ret;
+}
+
+static void mock_finish_match(struct dma_buf_match_args *args,
+			      const struct dma_buf_mapping_match *exp,
+			      const struct dma_buf_mapping_match *imp,
+			      struct dma_buf_mapping_match *match)
+{
+	mock_finish_called = true;
+	mock_finish_args_arg = args;
+	mock_finish_exp_arg = exp;
+	mock_finish_imp_arg = imp;
+
+	*match = (struct dma_buf_mapping_match){
+		.type = exp->type,
+		.exp_ops = exp->exp_ops,
+	};
+}
+
+/* Type with both match and finish_match callbacks */
+static struct dma_buf_mapping_type mock_type_a = {
+	.name = "mock_type_a",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+/* Second type -- distinct pointer identity from A */
+static struct dma_buf_mapping_type mock_type_b = {
+	.name = "mock_type_b",
+	.match = mock_match,
+	.finish_match = mock_finish_match,
+};
+
+static void test_match_fail(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_mapping_match exp[] = { { .type = &mock_type_b } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* Zero-length exporter array returns -EINVAL */
+	KUNIT_EXPECT_EQ(test, dma_buf_match_mapping(&args, NULL, 0), -EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Zero-length importer array returns -EINVAL */
+	args = (struct dma_buf_match_args){ .attach = &attach };
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EINVAL);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* Different types produce no match */
+	args.imp_matches = matches;
+	args.imp_len = ARRAY_SIZE(matches);
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/* When type->match() is NULL same types always match */
+static void test_match_no_match_callback(struct kunit *test)
+{
+	static struct dma_buf_mapping_type mock_type_no_match = {
+		.name = "mock_type_no_match",
+		.finish_match = mock_finish_match,
+	};
+	struct dma_buf_mapping_match matches[] = {
+		{ .type = &mock_type_no_match }
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	KUNIT_EXPECT_EQ(
+		test,
+		dma_buf_match_mapping(&args, matches, ARRAY_SIZE(matches)), 0);
+	KUNIT_EXPECT_FALSE(test, mock_match_called);
+	KUNIT_EXPECT_TRUE(test, mock_finish_called);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_args_arg, &args);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_exp_arg, &matches[0]);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &matches[0]);
+}
+
+static void test_match_callback_returns(struct kunit *test)
+{
+	struct dma_buf_mapping_match matches[] = { { .type = &mock_type_a } };
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = matches,
+		.imp_len = ARRAY_SIZE(matches),
+	};
+
+	/* type->match() returns -EOPNOTSUPP. Skips to next */
+	mock_match_ret = -EOPNOTSUPP;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+
+	/* type->match() returns an error code. Stops immediately, returns code */
+	mock_match_ret = -ENOMEM;
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, matches,
+					      ARRAY_SIZE(matches)),
+			-ENOMEM);
+	KUNIT_EXPECT_TRUE(test, mock_match_called);
+	KUNIT_EXPECT_FALSE(test, mock_finish_called);
+}
+
+/*
+ * The match set records every compatible pair, in the exporter's order. The
+ * first entry is the default selection.
+ */
+static void test_match_exporter_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp1[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match exp2[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp[2] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp,
+		.imp_len = ARRAY_SIZE(imp),
+	};
+
+	/* Both match, exporter order preserved, first is the default */
+	KUNIT_EXPECT_EQ(
+		test, dma_buf_match_mapping(&args, exp1, ARRAY_SIZE(exp1)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_a);
+
+	/* Only the second importer type is offered */
+	KUNIT_EXPECT_EQ(
+		test, dma_buf_match_mapping(&args, exp2, ARRAY_SIZE(exp2)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp[1]);
+}
+
+/* The exporter's order wins over the importer's */
+static void test_match_importer_priority(struct kunit *test)
+{
+	struct dma_buf_mapping_match exp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = { { .type = &mock_type_b } };
+	struct dma_buf_mapping_match imp2[] = {
+		{ .type = &mock_type_b },
+		{ .type = &mock_type_a },
+	};
+	struct dma_buf_attachment attach = {};
+	struct dma_buf_match_args args = {
+		.attach = &attach,
+		.imp_matches = imp1,
+		.imp_len = ARRAY_SIZE(imp1),
+	};
+
+	/* Single importer type */
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_finish_imp_arg, &imp1[0]);
+
+	/* Importer prefers B, exporter prefers A: A is the default */
+	args.imp_matches = imp2;
+	args.imp_len = ARRAY_SIZE(imp2);
+	KUNIT_EXPECT_EQ(test,
+			dma_buf_match_mapping(&args, exp, ARRAY_SIZE(exp)), 0);
+	KUNIT_ASSERT_EQ(test, attach.nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[0].type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, attach.matches[1].type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(&attach)->type,
+			    &mock_type_a);
+}
+
+static void mock_dmabuf_release(struct dma_buf *dmabuf)
+{
+}
+
+static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attach,
+					 enum dma_data_direction dir)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static void mock_unmap_dma_buf(struct dma_buf_attachment *attach,
+			       struct sg_table *sgt,
+			       enum dma_data_direction dir)
+{
+}
+
+static const struct dma_buf_mapping_sgt_exp_ops mock_sgt_ops = {
+	.map_dma_buf = mock_map_dma_buf,
+	.unmap_dma_buf = mock_unmap_dma_buf,
+};
+
+static const struct dma_buf_ops mock_dmabuf_simple_sgt_ops = {
+	.release = mock_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
+};
+
+static int mock_dmabuf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+
+	sgt_match[num_match++] =
+		(struct dma_buf_mapping_match){ .type = &mock_type_a };
+
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT(&mock_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops mock_dmabuf_two_exp_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_match_mapping,
+};
+
+struct dma_exporter {
+	const struct dma_buf_ops *ops;
+	const char *desc;
+};
+
+static struct dma_buf *mock_dmabuf_export(const struct dma_buf_ops *ops)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+
+	exp_info.ops = ops;
+	exp_info.size = PAGE_SIZE;
+	exp_info.priv = ERR_PTR(-EINVAL);
+	return dma_buf_export(&exp_info);
+}
+
+/*
+ * Check that a simple SGT exporter with single_exporter_match works with
+ * dma_buf_attach()
+ */
+static void test_sgt_attach(struct kunit *test)
+{
+	const struct dma_exporter *param = test->param_value;
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(param->ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_attach(dmabuf, dev);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &dma_buf_mapping_sgt_type);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_sgt_dma_device(attach), dev);
+	KUNIT_EXPECT_FALSE(test, dma_buf_sgt_p2p_allowed(attach));
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static void mock_move_notify(struct dma_buf_attachment *attach)
+{
+}
+
+/*
+ * Mock importer: declares a dma_buf_attach_ops whose supported_mapping_types
+ * table is whatever the test put in @_matches.
+ */
+#define MOCK_IMPORTER_OPS(_name, _matches)                          \
+	const struct dma_buf_attach_ops _name = {                   \
+		.invalidate_mappings = &mock_move_notify,           \
+		.supported_mapping_types = (_matches),              \
+		.nr_supported_mapping_types = ARRAY_SIZE(_matches), \
+	}
+
+/* Check a dynamic attach with a non-sgt mapping type */
+static void test_mock_attach(struct kunit *test)
+{
+	struct dma_buf_mapping_match imp[] = { { .type = &mock_type_a } };
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_two_exp_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, mock_match_dev_arg, dev);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+static const struct dma_exporter dma_exporter_params[] = {
+	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
+	{ &mock_dmabuf_two_exp_ops, "two_exp" },
+};
+KUNIT_ARRAY_PARAM_DESC(dma_exporter, dma_exporter_params, desc);
+
+static struct kunit_case dma_mapping_cases[] = {
+	KUNIT_CASE(test_match_fail),
+	KUNIT_CASE(test_match_no_match_callback),
+	KUNIT_CASE(test_match_callback_returns),
+	KUNIT_CASE(test_match_exporter_priority),
+	KUNIT_CASE(test_match_importer_priority),
+	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
+	KUNIT_CASE(test_mock_attach),
+	{}
+};
+
+static struct kunit_suite dma_mapping_test_suite = {
+	.name = "dma-buf-mapping",
+	.init = reset_mock_state,
+	.test_cases = dma_mapping_cases,
+};
+
+kunit_test_suite(dma_mapping_test_suite);
+
+MODULE_IMPORT_NS("DMA_BUF");

-- 
2.54.0

