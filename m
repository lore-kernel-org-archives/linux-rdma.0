Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860928;
	b=I0jJhBl4VXH0PCri7EP+Hsn+6bHhmxNZwEZQTyoicagAyU/uDy11ZRhLJi4tafe1Sr/e
	 YRUQgELdNaWlZRyql13+cVe58T4ELXdgChbHAZaqeHy8F7YnI18GvMyWUzSWjiuEzGEdr
	 7LLm9hMDfuST8JFe9LexkDmID7csJ5SdHhGYp6GajMJDTvJLCfg88HyTNEORhIhuoVMY0
	 dxZl+j79wNuxu/Up58e8ti2bR6MdGWqK/JDpSJNIbU1MjbDHb6HhSZBTJyp2BeRa38M8X
	 YIbmGxymowUYKlOlwwwS3czdU9NdgiW8xT2mr4F2k4bDx3K/vxMUbvKZKXLHmnF7ZpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860928;
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
	bh=UjtDly3wgMjVJnGHR8Hab7K7XcPv5B4fYjxBAyujAQo=;
	b=b+Hc2ifnZ7UVlhHyG+JQ5LJzaFZeglw5bpUFg5/6sX2HOo9EFpQwHkVkgY31RmmmQcSE
	 k9R8p6O6DXn2smsQeFLJtJ1ty4yT5L1oOB1Id4H0e5E5xl2Z/UG58+ky5cAQQa0bitWnh
	 Q4YoXz6egBv8p8Sv1304uUoQrENJAPyZXDDNxMFqLp3Q2ug0zuYUtQ0v+fCQZqh+zae0t
	 XM/ZSX7dRpOtses+DCHu7QwxsJf4yIB0+IJgPFzO9hPUFrEAhc1LRKo+7ypZsxACalyS/
	 0///2QlFSz/pf0M58v8ATJ+d19rVfwZA4KMkZOqW8beGcPlJQrIHu5Q0VneOzpUrcBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LxOWU5bd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21D9606A331;
	Thu,  5 Nov 2026 06:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D21D9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LxOWU5bd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnlgVTmJ0ChpsY+yo/CD06GG/lCKoAnXIm8lTUnxrWKCkGe4TKK3Fs7pJ1DUNB+7jb9CRONdGLylSmz/u0baWQjvDCR5NTWTKVHAfgaYMuLlhYcrZpeCZp6GIr4uWzHzv0lZ5fei5QklM4xBESmO7oKCLI3nQVm1VaNBUiX2B44NNIAeFGRTqu3pWLiUAmAW/N5FiIbmGMWy0fRrYxmO4B+ZOAogfjLx/sorijXT3ySpPKqQwSw8vy+jByHC06Ds4x84WrBjyhXmCSRp5zwwScbcWaiqHxxTP7KhrqHpBbcfNstOv8bJxOR1rt708pFOVv6yyFj+hbNQs4UCkOAOOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjtDly3wgMjVJnGHR8Hab7K7XcPv5B4fYjxBAyujAQo=;
 b=A3JLPOn+3qR4KwUrGcQK37s6jYBR71UfDtN9HkY+SCI1YF4ADS/hIOd/DNJMCMi/Vz804oSahdotnhjaYZ9kms4qG6KVMvZtzuHOm69xqGMUErgLTQ3UHNb9aY3ch1b5VFtpEJBJacZlRCtC90dZio3e/OqwlRDh923JzKDbYJiLxrCKZuxRMxwVBEhdJHlGJWVhPZXBWRe6peTWKFTFUiU7KoRj6r9UUrG4yOjDeeMjt3mhg0d/5xbYUWbgydfYARUd8APRPzJSeWlnPIlSFFRHxhSMHiriPmPFiOhhovvGp+CPADKU1ayhlTi7+VViUiFxMMNpaHQ0n/h3Ilnncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjtDly3wgMjVJnGHR8Hab7K7XcPv5B4fYjxBAyujAQo=;
 b=LxOWU5bdX/U9r7GNrDEgBrRHrUSP9OpXR7XQR6rZC0icWe/EG2QZFnUbB2qiFxN3HWH/Mh6vi8rzElqBietGu6un2dpJ3b48r/2pG72eBEb7nCX7AlDMFrXuoTIIOe1KQdga/SJYHiBffVCzx+5b8p1OELOyjGQ+DOSXIEJOElmUZDWJdMbRrU5ESC4thwLSgHqTtQtjdnUYkEdpaEyqAkHmGsgmKZNL3sw1s3U4rVWjJHolq7xNM6GkTFBETSgZH7FX+JNXop8n+aEY63VDiDFnB1PvoJ/4RlXASCTuvqcJ3Y1FQH6CvYNuCXiTQV7cnKQxSMVZOPtgVBbazrPFqg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:41 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:41 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:38 +1100
Subject: [PATCH v2 03/23] dma-buf: Add the SGT DMA mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-3-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=11898;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=3BY7eLZMiEpA9sxHO7/AOx+KtatLP6Dh4vHTrU3Tlx0=;
 b=o692wgr4k5Im29GJaU3WVpLeqKLk/6XEa/QId0zRWDVLQdy/L2HuQHcdCn434qV5x98Q4zhrb
 D/pigfSzXZVBcZpojdeuPCR4DBfFIZ2NmXQ/B1VXjaiZtgLnN1DtHzp
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0038.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::7) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: da3a48be-9fd5-4bbe-41e1-08df3b07d9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|11063799006|5023799004|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|3023799007|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	i9HvM8iSrds8dDdddKZh44G8MUrYmQU2/1yz7Ii8BqUv3YBvCaQ9rjfHAvcQUA0nrENtVExNceOMzAFBFFLUohlUk6iiG6Ge9tKqIxx/x3faitYowfew/rpumPynaRJi4WkeUVRY2beEx8yuVh9WMq9Il9qm7zEKRrgNcrHTIuhr4eraEb+J4+61/32z5UaQd3AjCoy9q1gJrZ+rSQGsWy9qqTEvEckbhcgfWj83Hqg2d+LrLgPrV/lxAjaidqwScIXUXMdtIvrtzDojP5k8SdQ4+DFGD3O85uS+1yWcnjJSGugPwdPEEqJsZ1OwzSq5uE+2wpcTDCtUpr+0mj1P43QM7cm2F/zuN0SlQdg2/w4oXBZJ0wFaO/Gnj/DmWAPI90Z6E/vlqw0e+DfYIfiQ9CYCtqWI3NZAYmX4jaSJXMGNW1wc2xjm03yNzHXb4MileBL2z66qzCZhSV6NpD5eJ/YX6uM5vOfVDSsH42bBiAIm1BEKGKPZ3i/ZFIov5XQrL+EH2LVg1FrTzRc0jW8E6e66+6qk4+Lm5C9pFYFZE0ZUx8WlwnxBhBQYYvPW7p5cLo1+pbLTF8nGwc6BDvCrSWT89MznjNDumQy4MS+rYwA8xUX9mJgQYfpgoACpWrFU33pMGz4VyXtBm1VlXaghNdSF+iFNFlgZcW7zfTa6tFVxGlgap1JowSVAM46LrfQoSK6hKAHhIkW8yoeVpNK7OA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(11063799006)(5023799004)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(3023799007)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2xyTkV1RC9JR0NSeWVYMUpkZGxoaG9uaTJPU1ZrRGtzdWF3emJpT1ZzZG5N?=
 =?utf-8?B?N0NxWFNDNlVuQTlzYzQxNVFnQlhnd3ZHZ05vbWF2NlhpdGFjRFdjTjIyLy9U?=
 =?utf-8?B?b0lsYkdTWW5mWFdRbTRaR0x6ZUl4UStmalFLMEFyNHhKdzdsQW4zZXBIdVBk?=
 =?utf-8?B?UzB2VENoWElxSmZqNnliYkU5bkNxU0hpQ3NXMzZsY3YrRCs2d1k0RUZZdHZj?=
 =?utf-8?B?TjB0WVdOUTdoSlJaeGZFcEV3UWcxdnVuNnEyanVjZnJvbXhQU2NxQTNRMDZo?=
 =?utf-8?B?clVOU1RUa2JHWW12cDFWUExIM3pRVWJ2NzE1S1h6SXVDWFJKUVBEZHUvVTJM?=
 =?utf-8?B?SWoyUmRGZTRNYWlMbXBNdUJ0dmxXOTBmSGlVNlRidHVNWDAxcm5aaHRtdm5T?=
 =?utf-8?B?bDkxYnQ5Mm9KcklnR1ZpVTFxSVhRcmdES081dXNucE02M1ZXK1ZBM1NHYmpG?=
 =?utf-8?B?d0l4NFM3MHNTNFpYeEhxMHZldy9DTVJoSmoxeGxJbHJVVUtpRkFyc095b25i?=
 =?utf-8?B?RE9HTnRPUy9qSnpjMURXKzhxL3dsZkw0T1lPVlhjYVpXYnA3ZGVUZkR5TXNL?=
 =?utf-8?B?VXJZVE9la1doSHgrTlozY0I2VTI5NnVqaWNsRTB3OTBPRW5WZmszQVhRS1NP?=
 =?utf-8?B?bVlUNUZnbmFwUjdNV0RnaWpQQUhGOXFRSnlnV0ovRzRsZTVsVkk0ZkRDWUs4?=
 =?utf-8?B?TlNGWGtObzBrb1VNUlArNHRzc1JuQ255WUE1ZjkxTDFHOGFVK1VkZjJhZUpl?=
 =?utf-8?B?QjczVHBMWlduYWpOQVdtTEZyYTdJYjlMZHc1RGNQVkRIakczNEN1V0dFVzE2?=
 =?utf-8?B?Qkp0N0VYK3hibjV1RzhIZFFscGFmSElGdUJLQjdIUVZnQkRydHRtS1hwU1Iy?=
 =?utf-8?B?Z2FoNWp0UThtZWVuTENCVzlpUlF2SkhPMVJQSTY5Z3h6eG41VkYyUVJPVzlP?=
 =?utf-8?B?OFpyZk13VGhwTmFUaHpGZ0M1OHBxQ0FadVdIQVZnNGtOcEcvOWovVWJQTCt5?=
 =?utf-8?B?SkZ5U1hpU3pDTE9uNWZ1YnN3Ny9xOCtQRDBBSU82dWpHVnVTUDd6WVcxaTBU?=
 =?utf-8?B?ZXd1SStzWUNmL0RDUHpOL1ROU1BlNmxSNnYweVZFSzhlcUlabUF1U21naHlU?=
 =?utf-8?B?WVFJV1MrNjU4MklOUmNybno1WVUvZkVDQXM0RU02anBFR3BOeWc0Z3VXbXhC?=
 =?utf-8?B?SC9hc1lieG9La3ZkWmg2bXNsb0hhekxubTFsNlZuMzNMdjVwejQ3ZEdvR2p3?=
 =?utf-8?B?U0VBTVEveFpnZk9ZNy9IU2xKaWF2Mko3ZXkzbHFXUWhjOTcwckVhZGNLbHhz?=
 =?utf-8?B?c2grTmlIWllnd205eGZjTkRWTnpTRTRrNXZDaTJZN1BOYUh0OHJSUTV0ajUr?=
 =?utf-8?B?ekFGSTRnWkY3Wm55MnpEVHRGV3ZCYjBmZ3dHNGpRVHFUYUtaQmJwM0wycG5T?=
 =?utf-8?B?clR2bnlRZEpicTdvN20yMmhadEJVR2dYTzdMQkRWRTVlRzc2T2VIQzdGMGJJ?=
 =?utf-8?B?LzRlM1k2Nml1cHE1REpsbDAxSTluaUpqVU1mM25IZmtzRGREbXJyZTJRUmFG?=
 =?utf-8?B?NnRjS1ZJUmlzR2dVV0t2M1FFU2ZHdlM1Zy9hdDlUQldDdVI0ZlB2eEtldXls?=
 =?utf-8?B?Q3Z3aVVaQmV2eTUvTXpRNWJ2U2gvejZnSjEzKzlXRERQMS9IVHNjUVVlbHp1?=
 =?utf-8?B?UnJraEdlSEIxeFNvNHVmZ1Z2VDRzS2ZMUnZlQzhpRmQweEZkY2owRHlTcnhZ?=
 =?utf-8?B?QjdrRUkwNHA4VW5aR21UYXBXdXE2YkRUZXRsTVhpUDlJT2tOSU1mZzFPalY2?=
 =?utf-8?B?MzdvTnhXbWlyODRDcHFxWGZiYUk4Rm9sVldSdlpJN0l1OFJLdFlnMzZNZXlV?=
 =?utf-8?B?WnVsdmxkcFk3Q0JLc1ZCTE9jNWhLZUhNV0ROeWhIOURsRW51VWMySjdtc0pl?=
 =?utf-8?B?QmYvUFU4V3hZRkF1NnRFUlV1Ulk2ejZmdWorQ0JnbDNUUjcvbFpVSDA3ZmhP?=
 =?utf-8?B?dWhIQUFMdlhlQVY4UFA3bkVKUUtGbTgxZ25XcGZxalh1T2V0QWhPanRwTUE4?=
 =?utf-8?B?VDdCcndkSCt6YjJJaThFVWM2VnVaajFjY3c0NVNKTGZhNGFQSmVYbzdjN3VF?=
 =?utf-8?B?S0szL25JQXIwVnRIaWh0UnpQRzgxcWRCMmtTNUorQjZPQktCdW14KzNxVmdQ?=
 =?utf-8?B?QUE1Mzk2bmxQNkpaQ091TkllVjBETzNHVVdXSFJnSTR6SDdBVnRJRGhwSHc2?=
 =?utf-8?B?VEhpcFR6SGNrRmUxNXNsK2FyZnZKVit6L1ZhY2VkeE1Zd2pka1FVby9GMEJK?=
 =?utf-8?B?MGgyRlJ4OUVvNm5XMlpmdG42blp1QkNNVDdoTDlBVkNUZnpjMTVwZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3a48be-9fd5-4bbe-41e1-08df3b07d9e5
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:41.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rw27poez3ai1qro68+spXxKeKpCoL2X/3d5oZh7ViWtyu+yRfu0hBXBf1/uFoWctPYUd4c8OesyxUdj/jc03Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

The SGT (Scatter Gather Table) DMA mapping type represents the existing
sg_table/scatterlist based DMA mapping. It provides a sg_table based
map/unmap interface that exactly matches how things work today.

dma_buf_sgt_exp_compat_match will be used in the next patch to
transparently wrap an unaware exporter with a mapping type.

The SGT type handles the allow_peer2peer flag directly through matching
logic. The importer indicates if it is willing to accept peer2peer and the
exporter indicates if it requires peer2peer. A required peer2peer exporter
will not match to an importer that does not accept peer2peer.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 104 +++++++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 127 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           |  19 +++++-
 3 files changed, 249 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index d27f02610c2a..4eb0ea930900 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,7 @@
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/dma-buf.h>
+#include <linux/seq_file.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -322,3 +323,106 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
+
+static int dma_buf_sgt_match(struct dma_buf_match_args *args,
+			     const struct dma_buf_mapping_match *exp,
+			     const struct dma_buf_mapping_match *imp)
+{
+	switch (exp->sgt_data.exporter_requires_p2p) {
+	case DMA_SGT_NO_P2P:
+		return 0;
+	case DMA_SGT_EXPORTER_REQUIRES_P2P:
+		if (imp->sgt_data.importer_accepts_p2p !=
+		    DMA_SGT_IMPORTER_ACCEPTS_P2P)
+			return -EOPNOTSUPP;
+		return 0;
+	case DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE:
+		if (WARN_ON(!exp->sgt_data.exporting_p2p_device) ||
+		    imp->sgt_data.importer_accepts_p2p !=
+			    DMA_SGT_IMPORTER_ACCEPTS_P2P)
+			return -EOPNOTSUPP;
+		/*
+		 * Not verbose: failing to match P2P is normal when the
+		 * exporter also offers a system memory type.
+		 */
+		if (pci_p2pdma_distance(exp->sgt_data.exporting_p2p_device,
+					args->dev, false) < 0)
+			return -EOPNOTSUPP;
+		return 0;
+	}
+	return 0;
+}
+
+static inline void
+dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
+			 const struct dma_buf_mapping_match *exp,
+			 const struct dma_buf_mapping_match *imp,
+			 struct dma_buf_mapping_match *match)
+{
+	struct dma_buf_attachment *attach = args->attach;
+
+	*match = (struct dma_buf_mapping_match) {
+		.type = &dma_buf_mapping_sgt_type,
+		.exp_ops = exp->exp_ops,
+		.sgt_data = {
+			.importing_dma_device = args->dev,
+			/* exporting_p2p_device is left opaque */
+			.importer_accepts_p2p = imp->sgt_data.importer_accepts_p2p,
+			.exporter_requires_p2p = exp->sgt_data.exporter_requires_p2p,
+		},
+	};
+
+	/*
+	 * Setup the SGT type variables stored in attach because importers and
+	 * exporters that do not natively use mappings expect them to be there.
+	 * When converting to use mappings users should use the match versions
+	 * of these instead.
+	 */
+	attach->dev = args->dev;
+	attach->peer2peer = match->sgt_data.importer_accepts_p2p ==
+			    DMA_SGT_IMPORTER_ACCEPTS_P2P;
+}
+
+static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
+				     struct dma_buf_attachment *attach)
+{
+	seq_printf(s, " %s", dev_name(dma_buf_sgt_dma_device(attach)));
+}
+
+struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
+	.name = "DMA Mapped Scatter Gather Table",
+	.match = dma_buf_sgt_match,
+	.finish_match = dma_buf_sgt_finish_match,
+	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+};
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
+
+static struct sg_table *
+dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
+			       enum dma_data_direction dir)
+{
+	return attach->dmabuf->ops->map_dma_buf(attach, dir);
+}
+
+static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
+					     struct sg_table *sgt,
+					     enum dma_data_direction dir)
+{
+	attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
+}
+
+/* Route the classic map/unmap ops through the exp ops for old importers */
+static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
+	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
+	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
+};
+
+/*
+ * This mapping type is used for unaware exporters that do not support
+ * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
+ * type so aware importers can transparently work with unaware exporters. This
+ * does not require p2p because old exporters will check it through the
+ * attach->peer2peer mechanism.
+ */
+const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match =
+	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops);
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 28b3a65c0672..69073d589e54 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -12,6 +12,24 @@ struct dma_buf;
 struct dma_buf_attachment;
 struct dma_buf_mapping_exp_ops;
 
+enum dma_sgt_requires_p2p {
+	DMA_SGT_NO_P2P = 0,
+	/*
+	 * Exporter: MMIO, importer must accept P2P and pci_p2pdma_distance()
+	 * from exporting_p2p_device must succeed at match time. The match runs
+	 * without the dma_resv lock whenever an importer attaches, so only use
+	 * this if exporting_p2p_device stays bound to its driver for as long as
+	 * the dma_buf exists. Importers that are not PCI devices never match.
+	 */
+	DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE,
+	/*
+	 * Exporter: MMIO, importer must accept P2P. No distance check at match;
+	 * the exporter's map does its own, e.g. via dma_buf_phys_vec_to_sgt().
+	 */
+	DMA_SGT_EXPORTER_REQUIRES_P2P,
+	DMA_SGT_IMPORTER_ACCEPTS_P2P,
+};
+
 /* Type tag for all mapping operations */
 struct dma_buf_mapping_exp_ops {};
 
@@ -109,4 +127,113 @@ dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
 	return &attach->matches[0];
 }
 
+/*
+ * DMA Mapped Scatterlist Type
+ *
+ * When this type is matched the map/unmap functions are:
+ *
+ *  dma_buf_map_sgt()
+ *  dma_buf_unmap_sgt()
+ *
+ * The struct sg_table returned by those functions has only the DMA portions
+ * available. The caller must not try to use the struct page * information.
+ *
+ * importing_dma_device is the device passed to dma_buf_dynamic_attach(),
+ * recorded at match time, and is passed to the DMA API to provide the
+ * dma_addr_t's.
+ */
+extern struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
+
+struct dma_buf_mapping_sgt_exp_ops {
+	struct dma_buf_mapping_exp_ops ops;
+	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,
+					enum dma_data_direction dir);
+	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
+			      struct sg_table *sgt,
+			      enum dma_data_direction dir);
+};
+
+/**
+ * dma_buf_sgt_dma_device - Return the device to use for DMA mapping
+ * @attach: sgt mapping type attachment
+ *
+ * Called by the exporter to get the struct device to pass to the DMA API
+ * during map and unmap callbacks.
+ */
+static inline struct device *
+dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
+{
+	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return dma_buf_attach_map_type(attach)->sgt_data.importing_dma_device;
+}
+
+/**
+ * dma_buf_sgt_p2p_allowed - True if MMIO memory can be used peer to peer
+ * @attach: sgt mapping type attachment
+ *
+ * Should be called by exporters, returns true if the exporter's
+ * DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE was matched.
+ */
+static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
+{
+	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
+		return false;
+	return dma_buf_attach_map_type(attach)->sgt_data.exporter_requires_p2p ==
+	       DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+}
+
+static inline const struct dma_buf_mapping_sgt_exp_ops *
+dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
+{
+	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return container_of(dma_buf_attach_map_type(attach)->exp_ops,
+			    struct dma_buf_mapping_sgt_exp_ops, ops);
+}
+
+/*
+ * Importer SGT entry. Usable in a static table: the importing device is
+ * supplied by dma_buf_dynamic_attach() and recorded in the matched entry.
+ */
+#define DMA_BUF_IMAPPING_SGT(_importer_accepts_p2p)                         \
+	((struct dma_buf_mapping_match){                                    \
+		.type = &dma_buf_mapping_sgt_type,                          \
+		.sgt_data = { .importer_accepts_p2p = (_importer_accepts_p2p) } })
+#define DMA_BUF_EMAPPING_SGT(_exp_ops)                                      \
+	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type, \
+					 .exp_ops = &((_exp_ops)->ops) })
+
+/*
+ * Only matches if the importing device is P2P capable and the P2P subsystem
+ * says P2P is possible from p2p_device.
+ */
+static inline struct dma_buf_mapping_match
+DMA_BUF_EMAPPING_SGT_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_ops,
+			 struct pci_dev *p2p_device)
+{
+	struct dma_buf_mapping_match match = DMA_BUF_EMAPPING_SGT(exp_ops);
+
+	match.sgt_data.exporter_requires_p2p =
+		DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+	match.sgt_data.exporting_p2p_device = p2p_device;
+	return match;
+}
+
+/*
+ * Only matches if the importer accepts P2P. Whether the importing device can
+ * actually reach the exporter's MMIO is left to the exporter's map, for
+ * exporters whose importers need not be PCI devices.
+ */
+static inline struct dma_buf_mapping_match
+DMA_BUF_EMAPPING_SGT_REQUIRES_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_ops)
+{
+	struct dma_buf_mapping_match match = DMA_BUF_EMAPPING_SGT(exp_ops);
+
+	match.sgt_data.exporter_requires_p2p = DMA_SGT_EXPORTER_REQUIRES_P2P;
+	return match;
+}
+
+extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 81bbcd420d60..de73f931a2f8 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -30,6 +30,7 @@ struct dma_buf_attachment;
 struct dma_buf_mapping_type;
 struct dma_buf_mapping_exp_ops;
 
+
 /*
  * Upper bound on the number of mapping types an attachment can record as
  * mutually acceptable. An exporter offering more compatible types than this
@@ -46,7 +47,23 @@ struct dma_buf_mapping_match {
 	const struct dma_buf_mapping_type *type;
 	const struct dma_buf_mapping_exp_ops *exp_ops;
 	union {
-		/* Each mapping_type has unique match parameters here */
+		/* For dma_buf_mapping_sgt_type */
+		struct {
+			/* Filled from the attaching device, not by importers */
+			struct device *importing_dma_device;
+			/* Only used if DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE */
+			struct pci_dev *exporting_p2p_device;
+			/*
+			 * These p2p flags are used to support the hard coded
+			 * mechanism for p2p. If an exporting device knows it
+			 * will put MMIO into the sgt then it should set
+			 * exporter_requires_p2p. Importers should set
+			 * importer_accepts_p2p unless it is known that the
+			 * importing HW never supports P2P because of HW issues.
+			 */
+			u8 importer_accepts_p2p;
+			u8 exporter_requires_p2p;
+		} sgt_data;
 	};
 };
 

-- 
2.54.0

