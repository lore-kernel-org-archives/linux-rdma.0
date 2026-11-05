Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860952;
	b=oDTH9ARko7Wgn5J3Ga0uh4av9P05DqZKIP+h8EjNn0prnv+4zMxtKw3HYs9O2Yxuqd5f
	 gdz3sXX6S4A0JkUtfxfMdesgeADPC5rd2dIPe0CDW219IoU3GXb0NVxKnR+4IfEUYSo2r
	 Ifkey0xckS+P5mHnO20PYVRQRriX80wGsV0RzeIHjSD8Dz2jMXgXLHQc7NY1DdLaGUVzW
	 CPqxKcjIDbuU50Ytg454uo3Wr8oFKJ3pta2q/muVuA0gbuV8qeDGQ7fSZxPHL/cN+CKK7
	 LzHB4gLtJMSKiphKuMd4Y+54jw6YcRNP1MEVdZBxusVtg/rl1Nax6/GbI7PFejcfV/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860952;
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
	bh=zBLKxpSLEBzu0nOge4IXu8c6zgK6r61SwGe1FM/pq84=;
	b=r9g0JlHL3KCW495GThrJukeUr92uqVibmhxn1Fc+RXTBDg+9iG3xigebwd0l8q2oGIOy
	 4k2No2Grykeh3yI+01HYY/01yOCPZcsgnuImCtIo3psj4ihg8Y+BsIneg4sjIyfL6lI7t
	 N0hTvTdlC/JStQmxBVEU2OIt1MnPFNgyOWHnp/5z7v2BKoNtIP5cyp7SHMpKj84M8Ur3y
	 YifUc1yxUYXGR8BziWzCx9bs9mm77dpTpYNSMgOEDosttUKkG+j3YNZfxBQ/D42tBmBbM
	 g/S3TYQpuGdb/deuyZ42KUvjmGNwnQX2Qgv80EiA5+NTwHw3Hdc7wXIA+UXk3/JW4Og==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OUhSNQyj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A9D606A329;
	Thu,  5 Nov 2026 06:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78A9D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OUhSNQyj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mg3/KIjvvnBcGL+1gk2w9Ar4k+BegJ6d9Y4K5WVKHfz/ahLVECpw6k1AIWTdXUMCAxryFNDHPE7hgLL3qhTFq/DCGA+WDtTA7O3M/G4V6F0ey/RgGOeI297+0XHX7i/B674d2zNbJuMJ3xdfCRTWWtGlacQTLFJFhw5Xe1KAs+TIgUsuzd+kbfkNdIgKMAknRhqpoNCuvprPeRCc1EO74rYAW76YHRbsoICSLwwm50u4tGwkHfCh/JFZPHK8MwxHvLcCUihLTIWwPrWqkk61UaovTR3dusWafueWBy0oodlRibUZGxZtWkIhIj+k7HdEg5+6cT5lvmSVKR6d5P7dWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBLKxpSLEBzu0nOge4IXu8c6zgK6r61SwGe1FM/pq84=;
 b=cRauGKBAF4znfTx7k1ZA8GFN2V3l6iyfXwSv+ZzZT9zE0+LYGVloni0klzEJbNkSUgFcuXwf+d+4laGRlg20beyrIXTrB08QbP5buRjuO6wZhZxMy1eUs/IBHN+u9lmNmCE+sb9vM4mEaarzH0JC5du2O5Tha2uDBtYdRcqFKx4VU1QLntkzgAj2juD6MJZpHrOkYgpqB6AknDx/+8+s2QF7L916dIYZSGeY5wOwqavsfgu0krW+b1F8YJTAsvnqMA+QiHiV/oklfnhoRu2prSqZgtuLokoWnAbfpLLxcbU7eCFKKzQKmSqiYkaaWQjtiAzAqo2R2CZaTfKNSD8raw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBLKxpSLEBzu0nOge4IXu8c6zgK6r61SwGe1FM/pq84=;
 b=OUhSNQyjSFzHqYfawVhugiKaGnKDENQpIwO9l3Vz3jhHTVVYqQDkx9MGhQpQmvANULMs/p3jmRt6wNcECasQyduaQntfppaFOWLqlQ2I/TjTQ8LhxoLVwOhu194qxUZHRGntSpb0eLM6pKBZ3udxV6rCJnDWuGUaTFi+xfgOy2P7F28sseck6n5e0HNR+6x7qAR/D2jYNjuI5u4rVZPFS5PRMG5VOQt9YPqNFWoYIuPelRMelHBMLavRQWYOXKwK78486EUPFkm99A1Jm/wJqsfMFAsID1xVnDKBVzH/aO7qmLOoTqxL1538GPnin3ey77d+nfPCnsDHdh71k45vJQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:36 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:36 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:37 +1100
Subject: [PATCH v2 02/23] dma-buf: Introduce DMA-buf mapping types
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-2-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=11337;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=iVoqCdPUrQkik8IfsEGuf01AfNkTL48S5PnMcOf9jaU=;
 b=L2zUhg2qUxb6L3LsGknzX5geWf0I701CiM880O19wXqyVpGyHVe4sQXYvd7oxAbYJILzZ7ZQ1
 c1dJTC6zm23AD26LEyG5LFqXU11bdv1ZUv8ZuG/NwqhXnXmWDbtQG/v
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0031.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::18) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CH1PR12MB9573:EE_
X-MS-Office365-Filtering-Correlation-Id: f38a420a-f03f-43c5-edd1-08df3b07d6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261022075727099003|261022113327099003|11063799006|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|3023799007|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	t0O39Bkk8wRiwevkkIqUUcCf+9EKDRL7JKs+5DyexFKS9fxlB+wYICT2A3PQCByaKf/RGgNr7hijAaImIp9JD6d0KdMJ+A6kB8d5nxqj/CxGXk9SXjLKesor865xd+xvELfSo5qpKwEqs2/H4MrXDQ06a+3+2aOViPP1xKiIoFt0VvNGQ0GPXabS8LGA8MgZXcv4/zgARXDhQnKHaUzsbWnun28Ztdd9dlaQ13eYSZhHdtThbzHeQP78IQbaVB6zm1WAD7mWJnoJXNZNITFa49I5pb5mghLDMu+ah5ynjGQYTH5eo4W0GopDiz+QGfg4+ZaAhsrM3UIEQ4MgUkqGRO0MGQHzxqZfREy9LROaJ+gCgs5NRnua1BVdNtlNhcfWcH3+lepkvSdPPPsa8m38K9BdB9t9QE3Pd1rcLE/zgH5j1wh7Ytwf8adUKTOGP+3OqUum20wdyOIdX23FuYx6ywKJweMNpK1gwIxZVAabF3gJxTgEvyKnMclkXOlTL1UPszTld9w64OQnjH9ywFDVuDjnqtMDDMKhPqumoDpl7lVH7NaN/wkrRj5qgaUT7VvrioCfQfwtUyCNG3vpgTNQbxG8OSrQNKFgxSOLysDgaIeOzBWOqRZTFbMGZyItlYv4ash7UxaiPQE/EtOlEqChFmKst2URCkZYL4Zc4zPrOjq0hrS4W2qCWu0uRI2bc5rXT2ZpwPWQ5Geo0/UMNuUFBA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261022075727099003)(261022113327099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(3023799007)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk1Ka1NMUDA3TDA4aG5WU2tGMnlWSTJvaE5ieTV2ZFJBdmFaZzZQdC96U1gw?=
 =?utf-8?B?amg5OVRhZEhuQ1JpOFVpTFlqTnRQOHRNdUIyQVpNNEdiZTdxb3ZNU1VqbDZm?=
 =?utf-8?B?MFc0dUlWV1FTYkc4SjdoNUtWQm0rb1drS0ZRUmZrS0ZwOTlaaEg5bThsSXNX?=
 =?utf-8?B?c1NGc0tHUU9iUlFwMFQ0dlpLR0luTkk1eUdRM2JDUFU5SnhXUXMwMHZxU1ZG?=
 =?utf-8?B?M3l2QzBZbEZ3NlI1d0JSVWRjaG5nUVlnaEtjOWJjS3J5dDlRSnJCbTVHTTlO?=
 =?utf-8?B?RVo5a0hzb04vaWlQN0tNcU9ENnhuOWd6bm8veXFZWEROcHp3ckRzTXYzYW85?=
 =?utf-8?B?QkIrWnBldWRNK3FKdEw1bmZhVmppL3FIRFhXNngyQnRlNjhNTFZHK09NYno2?=
 =?utf-8?B?dkt3SmVWd0pPTkcvTHhxeGRlSVJyRjBXZHVZMTZ3Sk9nZVF5RDVWSXlVd0Uy?=
 =?utf-8?B?ZTArNXl6UUdjQUlqcmlTaWtPZTM1WUc3QW1HZHVXSEZ2RFdXS1RRZm5lQlpV?=
 =?utf-8?B?RnVqU1RXbG5WcmNJV1ZhQVdPRW9BcndXeE9JNmxxa05uYVpzRldFT3hDU0t2?=
 =?utf-8?B?T214ZnhsKytwWjRpVFB5L0FxaHptcUlUZGVydnJjRS95d0dueHhiWGxrblZZ?=
 =?utf-8?B?OHNwMjlKelgycE1RdlYwckJYVElOeFh0UGFvTHhOU1M5MXh5eDY0dzM0dW1R?=
 =?utf-8?B?WGYyOGI1bjZvcHVsSG50YW91ZU5yZTMxeU5Fc2ovTWhEQnZYbDlrVmlsai9s?=
 =?utf-8?B?TTkzL1BOdlhDeVZQdExLYnhPS1ZZbENsQjZFS1hFRlV6TnJ4clRlRFM1SmNn?=
 =?utf-8?B?djh2a1lpR2M4Yy9uR0NEV0FMaWhZODJQR1pMejJrQkwyVU1ramJMb2t3YjZ6?=
 =?utf-8?B?SXQvMkg1QTRoYWw5N3ZXcmZaWDNhZGpDamp2UXpsMWVsNk5kVlA1cUtPNm5r?=
 =?utf-8?B?blVBdVU2aTlSc3Ftdmg2elV4d0xCcXpjMWwvbTdCcUluTWRjaDlqOFNJb3ha?=
 =?utf-8?B?LzQxUzgyM2xSampYY1V2eDVEeDNQYmtYVXRmajFDOU55ZDczemVjbDdmQjVR?=
 =?utf-8?B?SGUrbFR1RnMvcVo4Y2ozeUtqT2l4dHNKR1VwSjliUEpreWJCS29RSkZ2Ny9j?=
 =?utf-8?B?eFpYLzhpdFpLN1g1dXBnZitPUm9KVjllNG9TNlNxcVZPckI5UjNZOFNhcGVI?=
 =?utf-8?B?aHZSYmpSQVhqS0JMSkI5c1RFeXp2U1hFSTFiQ3NxU0xsMnJpOVYycE1HeHNE?=
 =?utf-8?B?UXcyb1M1a3RUVnJsUEZIbFVLcWpFd3p1VHE1ek5tN3p4OGFlOUUvVzZodVBH?=
 =?utf-8?B?M1F6akZENFhRazV1eXZ2cDVzaWJObEJSZ0RRTHJxSmlDWUNQdUMxR0FZZ0hP?=
 =?utf-8?B?RHVBeWhtQlJqbkt0ajFieG5Jek9oNStMNXQrSFZTa2FnVmVIOElXSkJMbjMr?=
 =?utf-8?B?aFhZU3NhcXd1blpHRW1zbGtXbzc1UmVRZllyclQ1NUh6TklWdmdrcVozTlRU?=
 =?utf-8?B?VzBhd09IRWxpSVdkb1RFUXg3L2c5R1RkNUJ4MWpSSlVVUlN1Uk44ZG9MRUZB?=
 =?utf-8?B?UTg4anRZbmNQbkpNM1lnempZZXVzYi9YMTVmc2JIZTdoRzhtNFdrNzdocmNz?=
 =?utf-8?B?Q2s4Wld3OTl4ZWRBL0F3WlVSSzg1a1AxSjJjTFNWVkdDZkZ1dkpQNTAvdWdB?=
 =?utf-8?B?TXc4em9tN0Q0U0kvYk5uc29rRTlldHlZeWFHZUMvMVVjVVZuYUhVSUVNTVRX?=
 =?utf-8?B?bHJaRFhtSVE5UTRCT2hHMndxa3I3YW44Q2luOG9ScGdwREd5SnRQMjIvU0hs?=
 =?utf-8?B?NFQ4QzIweHpYb0UrY2hJUGRnUmRseW9reStIUHFmMkxxY2VpSWMvVWtlLys3?=
 =?utf-8?B?cFBNSnJjUlBZZlVSRlNxWEhBZEEvUENZTlVDRXloZXFmcytReFFyaGJjOVM2?=
 =?utf-8?B?WGRKOFdNSUIwS1U0OGZQSkN1SDJBWHV5TEljU2d3SjlPOEI4WHM2R0NBNzZY?=
 =?utf-8?B?enJleCtCWkZnMlg4YjVRSWxYQ0JMR29vUFp5VjNoY3dSN0xVcjRuaGZ3bm1t?=
 =?utf-8?B?RzVSSmRMbnNwSnNjY0FjNjcwdjZzVjRYdTBTM3RCaEh5Y3Z0eWFWTyswQzdO?=
 =?utf-8?B?VVhKQkZZVmlFYXluT3BZSkQ0K2dIcmFhTzJHSDIvZGY3SFlpODVYRzRlNVZU?=
 =?utf-8?B?azNEQnByTlB4RFJ4ckwweDhrTGFSNlBOeFlDSVE5blZ4eUlpTFFkTGxoa3Fv?=
 =?utf-8?B?K0ZIUzZWallyY0taaHlzbjlrNXpjZkN4K055U21rRWNoazRhV24rNThOdWda?=
 =?utf-8?B?d2l6cEJERkplVVM5d2lWSDF2cDduVHc4ZUo1TmVtSnIxSlZrWkVPZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38a420a-f03f-43c5-edd1-08df3b07d6d6
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:36.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0cCUv5ENeqitxnKv6lg03+anfs8fQzpqGDhJgzCHksv9Nd+B6ODFzGZC1txZyxAvxHzT02HeIMW21jLKjyELnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

DMA-buf mapping types allow the importer and exporter to negotiate the
format of the map/unmap to be used during the attachment.

Currently DMA-buf only supports struct scatterlist as the attachment map
operation.  This is not sufficient for all use cases as dma_addr_t is a
very specific and limited type.

With mapping types the importing driver can declare what it supports. For
example:

	static const struct dma_buf_mapping_match imp_match[] = {
		DMA_BUF_IMAPPING_MY_DRIVER(...),
		DMA_BUF_IMAPPING_SGT(DMA_SGT_NO_P2P),
	};
	static const struct dma_buf_attach_ops importer_ops = {
		.supported_mapping_types = imp_match,
		.nr_supported_mapping_types = ARRAY_SIZE(imp_match),
		...
	};
	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, ...)

And the exporting driver can declare what it supports:

int exporter_match_mapping(struct dma_buf_match_args *args)
{
	struct dma_buf_mapping_match exp_match[] = {
		DMA_BUF_EMAPPING_MY_DRIVER(my_ops, dev, ...),
		DMA_BUF_EMAPPING_SGT(sgt_ops),
	};
	return dma_buf_match_mapping(args, exp_match, ...);
}

During dma_buf_dynamic_attach() the core code records every mutually
acceptable (exporter entry, importer entry) pair in attach->matches, a
small fixed-size array in the attachment, in the exporter's order of
preference. The first entry is the default and is what
dma_buf_attach_map_type() returns; later patches let the exporter choose a different entry of the set
at pin or map time, when the buffer's placement and the other attachments
are known. Importers and exporters that list a single type see exactly one
entry.

Add the basic types:

struct dma_buf_mapping_type
   Type tag and ops for each mapping type.

struct dma_buf_mapping_match
   Entry in a list of importer or exporter match specifications.
   The match specification can be extended by the mapping type with
   unique data.

dma_buf_match_mapping() / struct dma_buf_match_args
   Helper to do the matching. Called by the exporting driver
   via a dma_buf_ops callback.

struct dma_buf_mapping_exp_ops
   Base type for the per-mapping type exporter provided functions. This
   would be the map/unmap callbacks. Each mapping type can provide its own
   functions for map/unmap type operations with optimal type signatures.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Co-developed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 65 +++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 95 +++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           | 29 ++++++++++++
 3 files changed, 189 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 833be519e1e6..d27f02610c2a 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -5,6 +5,7 @@
  */
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
+#include <linux/dma-buf.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -257,3 +258,67 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
+
+/**
+ * dma_buf_match_mapping - Record the mapping types agreed upon by exporter
+ *                         and importer
+ * @args: Match arguments from attach
+ * @exp: Array of mapping types supported by the exporter, in priority order
+ * @exp_len: Number of entries in @exp
+ *
+ * Walk the exporter's list in order and, for each entry, find the first
+ * importer entry of the same type that the type's match() callback accepts.
+ * Every such pair is recorded in @args->attach->matches, so the match set
+ * preserves the exporter's priority. The first entry is the default returned
+ * by dma_buf_attach_map_type().
+ *
+ * Because the exporter list is walked in order, the exporter controls the
+ * priority of mapping types.
+ *
+ * Returns: 0 if at least one type matched, -EOPNOTSUPP if the exporter and
+ * importer have no type in common, -EINVAL if either list is empty, -E2BIG if
+ * more than DMA_BUF_MAX_MATCHES types matched, or the error a match() callback
+ * aborted the search with.
+ */
+int dma_buf_match_mapping(struct dma_buf_match_args *args,
+			  const struct dma_buf_mapping_match *exp,
+			  size_t exp_len)
+{
+	const struct dma_buf_mapping_match *exp_end = exp + exp_len;
+	const struct dma_buf_mapping_match *imp_end =
+		args->imp_matches + args->imp_len;
+	struct dma_buf_attachment *attach = args->attach;
+	unsigned int nr = 0;
+	int ret;
+
+	if (!exp_len || !args->imp_len)
+		return -EINVAL;
+
+	for (; exp != exp_end; exp++) {
+		const struct dma_buf_mapping_match *imp = args->imp_matches;
+
+		for (; imp != imp_end; imp++) {
+			if (exp->type != imp->type)
+				continue;
+			if (exp->type->match) {
+				ret = exp->type->match(args, exp, imp);
+				if (ret == -EOPNOTSUPP)
+					continue;
+				if (ret != 0)
+					return ret;
+			}
+			if (nr == ARRAY_SIZE(attach->matches))
+				return -E2BIG;
+			exp->type->finish_match(args, exp, imp,
+						&attach->matches[nr++]);
+			break;
+		}
+	}
+
+	if (!nr)
+		return -EOPNOTSUPP;
+
+	attach->nr_matches = nr;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 09bde3f748e4..28b3a65c0672 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -7,6 +7,83 @@
 #define __DMA_BUF_MAPPING_H__
 #include <linux/dma-buf.h>
 
+struct device;
+struct dma_buf;
+struct dma_buf_attachment;
+struct dma_buf_mapping_exp_ops;
+
+/* Type tag for all mapping operations */
+struct dma_buf_mapping_exp_ops {};
+
+/*
+ * Internal struct to pass arguments from the attach function to the matching
+ * function
+ */
+struct dma_buf_match_args {
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	/* The importing device passed to dma_buf_dynamic_attach() */
+	struct device *dev;
+	const struct dma_buf_mapping_match *imp_matches;
+	size_t imp_len;
+};
+
+/**
+ * struct dma_buf_mapping_type - Operations for a DMA-buf mapping type
+ *
+ * Each mapping type provides a singleton instance of this struct to describe
+ * the mapping type and its operations.
+ */
+struct dma_buf_mapping_type {
+	/**
+	 * @name: Human-readable name for this mapping type, used in debugfs
+	 *        output
+	 */
+	const char *name;
+
+	/**
+	 * @match:
+	 *
+	 * Called during attach from dma_buf_match_mapping(). &exp and &imp are
+	 * single items from the importer and exporter mapping match lists.
+	 * Both will have the same instance of this struct as their type member.
+	 * The importing device is @args->dev; importer entries do not carry
+	 * it, so they can be static tables shared by every attachment.
+	 *
+	 * It determines if the exporter/importer are compatible.
+	 *
+	 * Returns: 0 on success
+	 *   -EOPNOTSUPP means ignore the failure and continue
+	 *   Everything else aborts the search and returns the -errno
+	 */
+	int (*match)(struct dma_buf_match_args *args,
+		     const struct dma_buf_mapping_match *exp,
+		     const struct dma_buf_mapping_match *imp);
+
+	/**
+	 * @finish_match:
+	 *
+	 * Called by dma_buf_match_mapping() after a successful match to fill
+	 * in @match, the entry being added to @args->attach->matches. The
+	 * matched @exp and @imp entries are provided so the callback can copy
+	 * type-specific data into it, along with @args->dev if the type needs
+	 * the importing device later.
+	 */
+	void (*finish_match)(struct dma_buf_match_args *args,
+			     const struct dma_buf_mapping_match *exp,
+			     const struct dma_buf_mapping_match *imp,
+			     struct dma_buf_mapping_match *match);
+
+	/**
+	 * @debugfs_dump:
+	 *
+	 * Optional callback to write mapping-type-specific diagnostic
+	 * information about @attach to the debugfs seq_file @s.
+	 */
+	void (*debugfs_dump)(struct seq_file *s,
+			     struct dma_buf_attachment *attach);
+};
+
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
@@ -14,4 +91,22 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 enum dma_data_direction dir);
 void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 		      enum dma_data_direction dir);
+
+int dma_buf_match_mapping(struct dma_buf_match_args *args,
+			  const struct dma_buf_mapping_match *exp_mappings,
+			  size_t exp_len);
+
+/**
+ * dma_buf_attach_map_type - The match this attachment is mapped with
+ * @attach: the attachment
+ *
+ * Returns the entry of @attach->matches in force for the attachment: the
+ * exporter's default, which is the first entry.
+ */
+static inline const struct dma_buf_mapping_match *
+dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
+{
+	return &attach->matches[0];
+}
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index cedeb8ebc99e..81bbcd420d60 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,28 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct dma_buf_mapping_type;
+struct dma_buf_mapping_exp_ops;
+
+/*
+ * Upper bound on the number of mapping types an attachment can record as
+ * mutually acceptable. An exporter offering more compatible types than this
+ * to one importer fails the attach with -E2BIG.
+ */
+#define DMA_BUF_MAX_MATCHES 4
+
+/*
+ * Match items are generated by the importer using the DMA_BUF_IMAPPING_*() and
+ * the exporter using the DMA_BUF_EMAPPING_*() functions. Each mapping type
+ * defines its own signature with its own data to make the match and attachment.
+ */
+struct dma_buf_mapping_match {
+	const struct dma_buf_mapping_type *type;
+	const struct dma_buf_mapping_exp_ops *exp_ops;
+	union {
+		/* Each mapping_type has unique match parameters here */
+	};
+};
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -472,6 +494,11 @@ struct dma_buf_attach_ops {
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_sgt() must be called with the dma_resv lock held.
  * @importer_priv: importer specific attachment data.
+ * @matches: The match set negotiated at attach time: every mapping type both
+ *           sides accept, in the exporter's order of preference. The first
+ *           entry is the exporter's default; dma_buf_attach_map_type()
+ *           returns the entry the attachment is mapped with.
+ * @nr_matches: Number of valid entries in @matches.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -490,6 +517,8 @@ struct dma_buf_attachment {
 	const struct dma_buf_attach_ops *importer_ops;
 	void *importer_priv;
 	void *priv;
+	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
+	unsigned int nr_matches;
 };
 
 /**

-- 
2.54.0

