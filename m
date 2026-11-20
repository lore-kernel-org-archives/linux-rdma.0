Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154250;
	b=EmhK0s3aBmhKafMoCMe1mu6e30MU5RzWj7otcfbT2qroytxenP8PgtKzDwKZm26n6RlQ
	 K4WlCzy3FeD8Ltyl0BKmeTVLVHrdeTNVc2PMyHxSaZUMyBWBS2FAck2eOYCLmSsGG+rL+
	 FRzBGm0zGR5O5gXyIvo/yOck3lhN9oQN7fJIIeaswgOQT735bzhXSiuv4Jo95g30SQgeA
	 NBf9fEdJGW++BMXZE2WRL5RjTFwfVsGB1fUAm3ZgoExJHxVzzirYB9nn1Ds1mdt2i0k2E
	 34HXQs9QvTAJ3MZFj5gc868usuv05Bsn19rO81M29L4IoyNB9yMRMpqWBYoimMUO/MA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154250;
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
	bh=hmFfG/nrQFVfxbVmlp44z8+ZcA1xzt5pkm0BxFIy+fc=;
	b=sxPrcNEyCZ9t7DGw51or2BKO/KtW+xo3qe8LvSAIu1bZ570PhZcmPNP5Mkt84goEyzQi
	 TIdm0xcWO3XChFiZ5EbYu5Fk7H6hCmkYjdlSUX2q85C57hbqFHjdP5Ah/uqZDDs3n206q
	 Gf+dNQaFkqehLdy97oRMMwX26TL4k/tyMe6gYNV423LpCBF9MmQq3jrSaHF/IhsGaWHur
	 I8ZHZqq+SIGcPlQweAPgFyVTv3eP2xqnsYhM4LUba0Tg9zp7F1X+ju3JzqvanAdVFwDjf
	 ghf5ufrPE2aO3rV1jai9NDt8B6iNTSjbegnQAko7ZjGkR33J/WZ+2NAffH8WuO/uMPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lqsRVnsR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.10
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013010.outbound.protection.outlook.com [40.93.196.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0318760A260E;
	Fri, 20 Nov 2026 05:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0318760A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lqsRVnsR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzP1Md41H8DwlWb2Dx/coBmdNRhpk6Q6Qz4IDxVhEPxox8lEcW7DnI4oVBiVL1A7eQlLcXt9x6TyhMT1qwRD4Wzgthn6TbkBBPKNi/kDKKni6Qchus+HXcesuG4D3mYTDcWaDHqdTWT6XnBwCRpuYS2Z6djAnnPEh8eKH/vwfAiEbOsKhWCGfH0DfCoRJVBgjBLSiusiZossqP8tj09vKq/yuPvc5Gp0ULRDEt48AlRJUEWdrI1zYFNOYyXlVzwv1g5b2lcTcnPfpz53aHjEQD7GY1eTf2FK341TdR9R7Kg3GKAi6hf2LUmmy4E10yU1gS8pTaPcBZpgMHqCE4GLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmFfG/nrQFVfxbVmlp44z8+ZcA1xzt5pkm0BxFIy+fc=;
 b=tRIH1SSAIVJGLj7cEUY30HdbAhEwFzHCe5mwlxpxTIH/fZnPz6PIxfu4C5sIHjZyZjiP2AO3yJEFDbNafStVneSid1yMKivS0BTD3i1qp2a7tgT/VQFG7yJmQJamcUyQTJkh3LTe5Rz2ouTfcNehpOOUnOSgrRp6HvfTI8sy0ApXL92toiG0ImDKP7xmpqSBNQ+t3nio4pI6u4VJwGcnQwRYr+p6q7XWkdPzQznsDb1xhiUTdxDP/IckIoAU8yJ1yrZOfZMnRY4Xyj/+ODJ0aOzqF5C/0MFqcZnlGQzBU5vd/sCKzCIxU5lqDLxAo7q50pHQSNsJQQJfPqU2SptyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmFfG/nrQFVfxbVmlp44z8+ZcA1xzt5pkm0BxFIy+fc=;
 b=lqsRVnsRzzV/XHq9LMZ6aY2YNqy2BFZH2utXFZg8N/mNkd6l8YVUL/4auoLCSiuVGdRBTHkygxEc/LSLyAUqiQRUK/yxoYhaygub6jpAXOrMou9J6JQrDVUjuIF/TkVVOLpiWcom2znTzfmJ+BgP2Ql8bAbAFLRRTsshezgWkfatKNpMAHOdrIsPUQ82rj7VZi0RIb+con0PTHbB1UF8yacxzaHS4SiGqmwVx27S6qkQHx4Ubjl9C7Pu2v6zbNKlzEhGtHs7WJXIKPTj/cXGBnf/WZawMCOS7A/bgNEfjU3YjH3rI3FiFPCCWwDhuy/OnmoDGDD5eB1PPNxbJLqylQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:22 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:22 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:48 +1100
Subject: [PATCH v3 10/24] drm: Convert drm_gem_map_dma_buf() and its users
 to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-10-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=23857;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=hQwEjUQAzENrXiTc/TVSUbQduy6ijlo1PGEDs4z2eTA=;
 b=wfkJwc6dbJ3XiWvj0B2bL8PStxmeTjwoLUEWS5UnVrWRHx/XKsbr3Y3YoGxfwYGj80xYeW1W5
 hCchyc6Pld7BtPLyhmopEMgxnGbxR6d8V9jedrb0jAJ1R8++PUNoSpW
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0027.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::13) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 31e2ad4a-237f-4f84-46f2-08df46cb2523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009220027099003|261009223027099003|261009221727099003|261009221227099003|261009223327099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZjLARCurRJ184KQwjyvLLFcHK38UqTHI5Up9uW+i+LKYziTw9kCjfSvYeHnfVp/twg3SgOrCh79zqI5iymbmyWsnBvmyXGGASuvHf2+AnLBW52NdmY7PWsVzcIUhSP66IMziwuB6jMbsT00n/lGm/5i/pY44NGBQWzZ1Rh0+IW49XjyiROENuHj9O9ROqodQUtuEUh2I0twrEHmneU189u8NFLWVJlsryhahWCHjyFDzyYGjuTzSFowpqc/7RykXRlBizZAP3i66lv4ltqRbVw6UN2hVUpjD7CQrZIym78CAC26xcOSWrKGYKYhbEa71kky0scmAfgadpt3z4pK+Hn7xpTNOzL/PC8Pjxn7rAZ3f6lH7sHDRn7zdFFaf/98W1bJ3/zrNPqw8/xok+JJd8bUGWw4tSJpx+8Mf/7aQl0eRD/pJk//8L2L9k39+6UaVfFiCHOKZ9u+7mEqyxvEnggspT6IheGAyTEsmkrX81K2ZlbObJnOK9n1o5FB75qdjy6uG4bxCQifWe2arNDBF/Lg7z/hZANgc9CQn8UvuJVyBNaUcfoeRaF8yEeXQJcR4HD3pEPqJTSlqGrh1t+bLzF89onKgLkYFyqmRYmxkE3rLrUrI1NXY2DwwLbi5DNgU3nit3agh34fmd803kGwBsKIrsow14mK/+4olDr2bv1YqycfYmVl7oNNcKYY9k1fWuk9Qi+csvdxyS0tjyesHhQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009220027099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009223327099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmNGOWtMaE1mUC9ocWVra2NNazd5VkZuTWtabFJnUzllV1EvMkxsS2NhbjNs?=
 =?utf-8?B?RjRWOERUaEhTR2dGNlkvckptM1Q3UXY2cGl0K0xGeHBLR0VGdU1iUXhodTlY?=
 =?utf-8?B?RE5TVzBmMUVCZWErdTROUE90K2dKOUNHZkF3dE1XVE9PMWpkU2tHamFEdldB?=
 =?utf-8?B?ZFJlMTA0SE1uQS9xRS9JNW1LLy9Kc3hMdFhBSExnTHdqZURscmlVVFJ1OTMx?=
 =?utf-8?B?R2FqNWZnLy95RGh4R2o3eWlMSVBJQkJhbDRabHk3ODJWMlI5bi9IWjZNakha?=
 =?utf-8?B?dDd5bStKU2I2ZW5LS1F3YkFvdWtxQ3VPWWwxdXgwcnJJeEdkNVc3RjlwQ1NO?=
 =?utf-8?B?RzQ3V1dKVEQ4ZjVPY1QxM2lvTGtMbndtK3IzaHBwY3BZTVYxU0o2RVMxL0o3?=
 =?utf-8?B?UUhsZmZUak5JSUc4c3JXRkFudHYvZHFiOHExc3dhNk9RalZhMzRZVDNQZ3V0?=
 =?utf-8?B?b29FNjY5WkpSUFNEUGdFYUpxTHRUUVhzS24yVEVMeEp1TkZXVVhSa2dJa2FH?=
 =?utf-8?B?cWpLeFJ3TlhsRTNFQ1o2QzIzbmxaejFTK3NSNmY5Y3B5alR1SnNDUjdJeVVT?=
 =?utf-8?B?eElRdjhmV2U3bHIxYzIrcWFOeFplNU93MldOMVNnay9KRThjdmhzM3B6SEc4?=
 =?utf-8?B?Z2lHRjYxYzBQN1o0WHdDbjcrZVB1ekQzZzQ2M3V4Wkh3MkFzWnFRZFVoUERi?=
 =?utf-8?B?cmhlQklMRUpKalVPSHA3WStkRUx6TWgvSW5FM1ZDTHRUY1pPMzNyTGl4Z0Vl?=
 =?utf-8?B?RmhOSWE2Ni83RHZMMmxNZmQ0QUpsMC9wUkhIQjVtckZHYjNrbHJXaDN0bHpW?=
 =?utf-8?B?Ylo2akcyT2F3ZWFSaERqeWoxM1RMM21iM2l6R2hseHBnQmRNdzEyOUlPKzlL?=
 =?utf-8?B?cXczanQydTFBTnV6WUJieG0wZlhwZVU3dXlPazZkazVoeVFoTGtCNzFrbnQy?=
 =?utf-8?B?UmVuVForNnVhMVhId0tzS2hqNFIrZTE4TVNKekRDNWVlT1ZpY0x2VGlEdXhu?=
 =?utf-8?B?UVRoZVI5ajVmYURmODJFUjlGUDA3UUJ0Qkx3SnpzdE5WTFhaZWtqb2VJZ29X?=
 =?utf-8?B?a3hpTzBrVW1QTWJWZTJjdW1td0dsbU5lK2JreURtUDhCWVZ5RDl0eHkza0to?=
 =?utf-8?B?NGdNSm1ycUVKV21aaWdXU3NYeU42YlpHQ1NRTjkxU3pzSC9RZzdabEdMbTVR?=
 =?utf-8?B?VnVrSEU3d0VZVyt2OUZPQTQ0NjRMYkNqZFZZUkhYb096UklTTlR2NEp4N2tX?=
 =?utf-8?B?cFVvMU5kblZaL2VLcTZXNGlaSzhLUEpLY1E4dzFWNG12L3VzVTNranpGT3h0?=
 =?utf-8?B?K0V2YU02Q1N2MjVOVzB3T1ZHaGJwS25FVUtIdmcwdmREYnR5azd5Um8ybU9V?=
 =?utf-8?B?UEp6M2JGU283V0dOTFRaM0g0cFlKV1FoSFlyc3NWMkRjSmcxOFlJRWVhMGVG?=
 =?utf-8?B?Qk9Lb1kxRnNjUittNnF6LzR6aWZBeDk4Y1Jwd2w1ZlZWOUtCRUFEWkVoT0Rh?=
 =?utf-8?B?UzJ1bjhQeTl5bGNnU2FJNUNtNG5hVGY1aDFMWkZaRWN3WEIrV3BtVTQrZHRW?=
 =?utf-8?B?SGhZQkNZdnZMQWZxVnd3RWgwUU5jZEo5bFkxTkkrTW9zV2tZU1FLRTY2R010?=
 =?utf-8?B?QzJSNmFwNXlpZVg0ZTFCK2lLaDlBcTltUWNGbkJKbWV0cXJ4UmE1UnRQcDdI?=
 =?utf-8?B?VUtUck14RGRsbGRCa0l0UUxIOUVhZko0NjlhaGV3OU1aVm5UbUJlL1B4Ynhr?=
 =?utf-8?B?Sk5UTkV6eG5DNnJhcDZLdWxidWRZbC80eTFUbjEzc3Vjc2R5MkxReHFFd1hs?=
 =?utf-8?B?UUFlT0NqWVJqUHU3Nk15di9YdkhsckZ5OVppV1Z4NHhlVWM2SUJiQlJKYi8v?=
 =?utf-8?B?enJFbmpjYURZZTdYYXdBOElTY293cFNXNE1SUnFMWUlvQWVWZUk0bGlrQm9l?=
 =?utf-8?B?bnJsR2hDaUJGM2FPajM1dXJTNldTZzZPcWVvbzJST2pxeDZVZlg2UDN5RDhR?=
 =?utf-8?B?bjhIZW1yMUdsYWxFMDRiZnZmb2o3cXEycm1hN3VmZFNhS3c2VEVER3dObW05?=
 =?utf-8?B?SjR2V0dGL2ZhRlljMTFLSWpKaFFvWTRrU09LTjQ2aklWUG00dnhXQUZHemtY?=
 =?utf-8?B?eTlhb1FrUklkbUNXV0xBb1lLVEFxRWplcWVOY1JWQmZTdUczc0NmNDBGWHow?=
 =?utf-8?B?b09kODI1Y1RCaGl3WEFjRjZKSHZCSC8xQXJiU3JBYU9oQXkwY1NCU3ZxUWs4?=
 =?utf-8?B?S3F5TER5Q3U4UmlZeWFsNHQ2STRaRThrUmMwWXcxQW5HMkJwUEt4c2NvRVQx?=
 =?utf-8?B?VVBYakdmR1FZSnZEaWdvMmVhL1FQbW1GYUZTamNNakhtK0FCUzV2QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e2ad4a-237f-4f84-46f2-08df46cb2523
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:22.7544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9O21flXj63kk8tgRMmsDdUVKDAXEFAyFPsXk9NQzh05C7ARTu+zbQ0gw5clJ1E7LqEaC+hThBb8OrzdYV/qNlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

drm_gem_map_dma_buf() gets its table from the object's get_sg_table(),
which allocates and drm_gem_unmap_dma_buf() frees it.

Rather than pass a caller-provided table through every get_sg_table()
implementation have the mapping take over the table. It copies the
headers into the embedded struct dma_buf_sgt_mapping.sgt and frees the
container. Unmap then frees the entries through the copy.

drm_gem_map_attach() checked dma_buf->ops->map_dma_buf to see whether
drm_gem_map_dma_buf() is in use. That callback now lives in the SGT
exporter ops, so check those instead. virtio-gpu's prime callbacks wrap
drm_gem_map_dma_buf() and so are converted here too.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_gem.c        |  5 ++-
 drivers/gpu/drm/drm_prime.c                | 72 ++++++++++++++++++++----------
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c | 23 ++++++----
 drivers/gpu/drm/msm/msm_gem_prime.c        |  7 ++-
 drivers/gpu/drm/panfrost/panfrost_gem.c    | 27 ++++++-----
 drivers/gpu/drm/panthor/panthor_gem.c      | 25 ++++++-----
 drivers/gpu/drm/virtio/virtgpu_drv.h       |  9 ++--
 drivers/gpu/drm/virtio/virtgpu_prime.c     | 22 +++++----
 drivers/gpu/drm/virtio/virtgpu_vram.c      | 25 ++++++-----
 include/drm/drm_prime.h                    |  8 ++--
 10 files changed, 139 insertions(+), 84 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index adee6e806eed..74b8e86638b1 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -11,6 +11,7 @@
 #include <drm/drm_print.h>
 #include <drm/gpu_scheduler.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-direct.h>
 #include <linux/iosys-map.h>
 #include <linux/pagemap.h>
@@ -669,12 +670,12 @@ static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struc
 static const struct dma_buf_ops amdxdna_dmabuf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = amdxdna_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int flags)
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index e27bda3423ed..e4a2a1de371c 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -28,6 +28,7 @@
 
 #include <linux/export.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/rbtree.h>
 #include <linux/module.h>
 
@@ -587,6 +588,16 @@ int drm_prime_handle_to_fd_ioctl(struct drm_device *dev, void *data,
  * option for sharing lots of buffers for rendering.
  */
 
+static bool is_gem_map_dma_buf(struct dma_buf_attachment *attach)
+{
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
+
+	if (sgt_exp_ops && sgt_exp_ops->map_dma_buf == drm_gem_map_dma_buf)
+		return true;
+	return false;
+}
+
 /**
  * drm_gem_map_attach - dma_buf attach implementation for GEM
  * @dma_buf: buffer to attach device to
@@ -608,7 +619,7 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 	 * drm_gem_map_dma_buf() requires obj->get_sg_table(), but drivers
 	 * that implement their own ->map_dma_buf() do not.
 	 */
-	if (dma_buf->ops->map_dma_buf == drm_gem_map_dma_buf &&
+	if (is_gem_map_dma_buf(attach) &&
 	    !obj->funcs->get_sg_table)
 		return -ENOSYS;
 
@@ -657,16 +668,18 @@ EXPORT_SYMBOL(drm_gem_map_detach);
  * @dir: direction of DMA transfer
  *
  * Calls &drm_gem_object_funcs.get_sg_table and then maps the scatterlist. This
- * can be used as the &dma_buf_ops.map_dma_buf callback. Should be used together
- * with drm_gem_unmap_dma_buf().
+ * can be used as the &dma_buf_mapping_sgt_exp_ops.map_dma_buf callback. Should
+ * be used together with drm_gem_unmap_dma_buf().
  *
- * Returns:sg_table containing the scatterlist to be returned; returns ERR_PTR
- * on error. May return -EINTR if it is interrupted by a signal.
+ * Returns: the mapping containing the scatterlist to be returned; returns
+ * ERR_PTR on error. May return -EINTR if it is interrupted by a signal.
  */
-struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
-				     enum dma_data_direction dir)
+struct dma_buf_sgt_mapping *
+drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
+		    enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 	int ret;
 
@@ -676,40 +689,51 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	if (WARN_ON(!obj->funcs->get_sg_table))
 		return ERR_PTR(-ENOSYS);
 
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
 	sgt = obj->funcs->get_sg_table(obj);
-	if (IS_ERR(sgt))
-		return sgt;
+	if (IS_ERR(sgt)) {
+		kfree(mapping);
+		return ERR_CAST(sgt);
+	}
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir,
-			      DMA_ATTR_SKIP_CPU_SYNC);
+	/* Take over the table header; the copy now owns the scatterlist. */
+	mapping->sgt = *sgt;
+	kfree(sgt);
+
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), &mapping->sgt,
+			      dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret) {
-		sg_free_table(sgt);
-		kfree(sgt);
-		sgt = ERR_PTR(ret);
+		sg_free_table(&mapping->sgt);
+		kfree(mapping);
+		return ERR_PTR(ret);
 	}
 
-	return sgt;
+	return mapping;
 }
 EXPORT_SYMBOL(drm_gem_map_dma_buf);
 
 /**
  * drm_gem_unmap_dma_buf - unmap_dma_buf implementation for GEM
  * @attach: attachment to unmap buffer from
- * @sgt: scatterlist info of the buffer to unmap
+ * @mapping: mapping of the buffer to unmap
  * @dir: direction of DMA transfer
  *
- * This can be used as the &dma_buf_ops.unmap_dma_buf callback.
+ * This can be used as the &dma_buf_mapping_sgt_exp_ops.unmap_dma_buf callback.
  */
 void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
-			   struct sg_table *sgt,
+			   struct dma_buf_sgt_mapping *mapping,
 			   enum dma_data_direction dir)
 {
-	if (!sgt)
+	if (!mapping)
 		return;
 
-	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
-	sg_free_table(sgt);
-	kfree(sgt);
+	dma_unmap_sgtable(dma_buf_sgt_mapping_dma_device(mapping),
+			  &mapping->sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	sg_free_table(&mapping->sgt);
+	kfree(mapping);
 }
 EXPORT_SYMBOL(drm_gem_unmap_dma_buf);
 
@@ -827,12 +851,12 @@ EXPORT_SYMBOL(drm_gem_dmabuf_mmap);
 static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 /**
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index 4ab54d2e616f..41210ca14a92 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 #include <linux/dma-resv.h>
 #include <linux/module.h>
@@ -24,10 +25,12 @@ static struct drm_i915_gem_object *dma_buf_to_obj(struct dma_buf *buf)
 	return to_intel_bo(buf->priv);
 }
 
-static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
-					     enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
+		     enum dma_data_direction dir)
 {
 	struct drm_i915_gem_object *obj = dma_buf_to_obj(attach->dmabuf);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 	struct scatterlist *src, *dst;
 	int ret, i;
@@ -36,11 +39,12 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	 * Make a copy of the object's sgt, so that we can make an independent
 	 * mapping
 	 */
-	sgt = kmalloc_obj(*sgt);
-	if (!sgt) {
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping) {
 		ret = -ENOMEM;
 		goto err;
 	}
+	sgt = &mapping->sgt;
 
 	ret = sg_alloc_table(sgt, obj->mm.pages->orig_nents, GFP_KERNEL);
 	if (ret)
@@ -52,16 +56,17 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
 		dst = sg_next(dst);
 	}
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
+			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		goto err_free_sg;
 
-	return sgt;
+	return mapping;
 
 err_free_sg:
 	sg_free_table(sgt);
 err_free:
-	kfree(sgt);
+	kfree(mapping);
 err:
 	return ERR_PTR(ret);
 }
@@ -203,14 +208,14 @@ static void i915_gem_dmabuf_detach(struct dma_buf *dmabuf,
 static const struct dma_buf_ops i915_dmabuf_ops =  {
 	.attach = i915_gem_dmabuf_attach,
 	.detach = i915_gem_dmabuf_detach,
-	.map_dma_buf = i915_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = i915_gem_dmabuf_mmap,
 	.vmap = i915_gem_dmabuf_vmap,
 	.vunmap = i915_gem_dmabuf_vunmap,
 	.begin_cpu_access = i915_gem_begin_cpu_access,
 	.end_cpu_access = i915_gem_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(i915_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct dma_buf *i915_gem_prime_export(struct drm_gem_object *gem_obj, int flags)
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index e1e74e9b7e6a..b6aae3c85250 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 
 #include <drm/drm_drv.h>
 #include <drm/drm_prime.h>
@@ -54,12 +55,12 @@ static void msm_gem_dmabuf_release(struct dma_buf *dma_buf)
 static const struct dma_buf_ops msm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = msm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct drm_gem_object *msm_gem_prime_import(struct drm_device *dev,
@@ -125,3 +126,5 @@ void msm_gem_prime_unpin(struct drm_gem_object *obj)
 
 	msm_gem_unpin_pages_locked(obj);
 }
+
+MODULE_IMPORT_NS("DMA_BUF");
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 518f24549b9d..e54818736a31 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 
 #include <drm/panfrost_drm.h>
@@ -23,6 +24,8 @@ MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with T
 #define panfrost_transparent_hugepage false
 #endif
 
+MODULE_IMPORT_NS("DMA_BUF");
+
 int panfrost_gem_init(struct panfrost_device *pfdev)
 {
 	if (panfrost_transparent_hugepage) {
@@ -289,25 +292,25 @@ static size_t panfrost_gem_rss(struct drm_gem_object *obj)
 	return 0;
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 panfrost_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			       enum dma_data_direction dir)
 {
-	struct sg_table *sgt = drm_gem_map_dma_buf(attach, dir);
+	struct dma_buf_sgt_mapping *mapping = drm_gem_map_dma_buf(attach, dir);
 
-	if (!IS_ERR(sgt))
-		attach->priv = sgt;
+	if (!IS_ERR(mapping))
+		attach->priv = &mapping->sgt;
 
-	return sgt;
+	return mapping;
 }
 
 static void
 panfrost_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-				 struct sg_table *sgt,
+				 struct dma_buf_sgt_mapping *mapping,
 				 enum dma_data_direction dir)
 {
 	attach->priv = NULL;
-	drm_gem_unmap_dma_buf(attach, sgt, dir);
+	drm_gem_unmap_dma_buf(attach, mapping, dir);
 }
 
 static int
@@ -330,7 +333,8 @@ panfrost_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -351,7 +355,8 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (shmem->vaddr)
@@ -367,14 +372,14 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panfrost_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panfrost_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panfrost_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panfrost_gem_prime_begin_cpu_access,
 	.end_cpu_access = panfrost_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panfrost_gem_prime_map_dma_buf,
+				     panfrost_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 22b57ab6f929..002fea6e5b06 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -7,6 +7,7 @@
 #include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -471,25 +472,25 @@ static void panthor_gem_free_object(struct drm_gem_object *obj)
 	drm_gem_object_put(vm_root_gem);
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 panthor_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			      enum dma_data_direction dir)
 {
-	struct sg_table *sgt = drm_gem_map_dma_buf(attach, dir);
+	struct dma_buf_sgt_mapping *mapping = drm_gem_map_dma_buf(attach, dir);
 
-	if (!IS_ERR(sgt))
-		attach->priv = sgt;
+	if (!IS_ERR(mapping))
+		attach->priv = &mapping->sgt;
 
-	return sgt;
+	return mapping;
 }
 
 static void
 panthor_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-				struct sg_table *sgt,
+				struct dma_buf_sgt_mapping *mapping,
 				enum dma_data_direction dir)
 {
 	attach->priv = NULL;
-	drm_gem_unmap_dma_buf(attach, sgt, dir);
+	drm_gem_unmap_dma_buf(attach, mapping, dir);
 }
 
 static int
@@ -512,7 +513,8 @@ panthor_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -533,7 +535,8 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (bo->cmap.vaddr)
@@ -549,14 +552,14 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panthor_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panthor_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panthor_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panthor_gem_prime_begin_cpu_access,
 	.end_cpu_access = panthor_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panthor_gem_prime_map_dma_buf,
+				     panthor_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index f3bbbe4468bf..35956816b6e2 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -153,6 +153,7 @@ struct virtio_gpu_object_array {
 	struct drm_gem_object *objs[] __counted_by(total);
 };
 
+struct dma_buf_sgt_mapping;
 struct virtio_gpu_vbuffer;
 struct virtio_gpu_device;
 
@@ -555,11 +556,11 @@ bool virtio_gpu_is_vram(struct virtio_gpu_object *bo);
 int virtio_gpu_vram_create(struct virtio_gpu_device *vgdev,
 			   struct virtio_gpu_object_params *params,
 			   struct virtio_gpu_object **bo_ptr);
-struct sg_table *virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo,
-					     struct device *dev,
-					     enum dma_data_direction dir);
+struct dma_buf_sgt_mapping *
+virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo, struct device *dev,
+			    enum dma_data_direction dir);
 void virtio_gpu_vram_unmap_dma_buf(struct device *dev,
-				   struct sg_table *sgt,
+				   struct dma_buf_sgt_mapping *mapping,
 				   enum dma_data_direction dir);
 void virtio_gpu_vram_map_deferred(struct virtio_gpu_object_vram *vram);
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index a47783b47dcc..a01c70f4d6e8 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -24,6 +24,7 @@
 
 #include <drm/drm_prime.h>
 #include <drm/drm_print.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/virtio_dma_buf.h>
 
 #include "virtgpu_drv.h"
@@ -46,44 +47,49 @@ static int virtgpu_virtio_get_uuid(struct dma_buf *buf,
 	return 0;
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 virtgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 			enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
-	if (virtio_gpu_is_vram(bo))
-		return virtio_gpu_vram_map_dma_buf(bo, attach->dev, dir);
+	if (virtio_gpu_is_vram(bo)) {
+		struct device *dev = dma_buf_sgt_dma_device(attach);
+
+		return virtio_gpu_vram_map_dma_buf(bo, dev, dir);
+	}
 
 	return drm_gem_map_dma_buf(attach, dir);
 }
 
 static void virtgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
-				      struct sg_table *sgt,
+				      struct dma_buf_sgt_mapping *mapping,
 				      enum dma_data_direction dir)
 {
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
 	if (virtio_gpu_is_vram(bo)) {
-		virtio_gpu_vram_unmap_dma_buf(attach->dev, sgt, dir);
+		struct device *dev = dma_buf_sgt_mapping_dma_device(mapping);
+
+		virtio_gpu_vram_unmap_dma_buf(dev, mapping, dir);
 		return;
 	}
 
-	drm_gem_unmap_dma_buf(attach, sgt, dir);
+	drm_gem_unmap_dma_buf(attach, mapping, dir);
 }
 
 static const struct virtio_dma_buf_ops virtgpu_dmabuf_ops =  {
 	.ops = {
 		.attach = virtio_dma_buf_attach,
 		.detach = drm_gem_map_detach,
-		.map_dma_buf = virtgpu_gem_map_dma_buf,
-		.unmap_dma_buf = virtgpu_gem_unmap_dma_buf,
 		.release = drm_gem_dmabuf_release,
 		.mmap = drm_gem_dmabuf_mmap,
 		.vmap = drm_gem_dmabuf_vmap,
 		.vunmap = drm_gem_dmabuf_vunmap,
+		DMA_BUF_SIMPLE_SGT_EXP_MATCH(virtgpu_gem_map_dma_buf,
+					     virtgpu_gem_unmap_dma_buf),
 	},
 	.device_attach = drm_gem_map_attach,
 	.get_uuid = virtgpu_virtio_get_uuid,
diff --git a/drivers/gpu/drm/virtio/virtgpu_vram.c b/drivers/gpu/drm/virtio/virtgpu_vram.c
index 01241ce4d07c..0a430b04cc2f 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vram.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vram.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "virtgpu_drv.h"
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 
 static DEFINE_MUTEX(map_lock);
@@ -77,19 +78,21 @@ static int virtio_gpu_vram_mmap(struct drm_gem_object *obj,
 	return ret;
 }
 
-struct sg_table *virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo,
-					     struct device *dev,
-					     enum dma_data_direction dir)
+struct dma_buf_sgt_mapping *
+virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo, struct device *dev,
+			    enum dma_data_direction dir)
 {
 	struct virtio_gpu_device *vgdev = bo->base.base.dev->dev_private;
 	struct virtio_gpu_object_vram *vram = to_virtio_gpu_vram(bo);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 	dma_addr_t addr;
 	int ret;
 
-	sgt = kzalloc_obj(*sgt);
-	if (!sgt)
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
 		return ERR_PTR(-ENOMEM);
+	sgt = &mapping->sgt;
 
 	if (!(bo->blob_flags & VIRTGPU_BLOB_FLAG_USE_MAPPABLE)) {
 		// Virtio devices can access the dma-buf via its UUID. Return a stub
@@ -98,7 +101,7 @@ struct sg_table *virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo,
 			ret = -EIO;
 			goto out;
 		}
-		return sgt;
+		return mapping;
 	}
 
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
@@ -116,24 +119,26 @@ struct sg_table *virtio_gpu_vram_map_dma_buf(struct virtio_gpu_object *bo,
 	sg_dma_address(sgt->sgl) = addr;
 	sg_dma_len(sgt->sgl) = vram->vram_node.size;
 
-	return sgt;
+	return mapping;
 out:
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 	return ERR_PTR(ret);
 }
 
 void virtio_gpu_vram_unmap_dma_buf(struct device *dev,
-				   struct sg_table *sgt,
+				   struct dma_buf_sgt_mapping *mapping,
 				   enum dma_data_direction dir)
 {
+	struct sg_table *sgt = &mapping->sgt;
+
 	if (sgt->nents) {
 		dma_unmap_resource(dev, sg_dma_address(sgt->sgl),
 				   sg_dma_len(sgt->sgl), dir,
 				   DMA_ATTR_SKIP_CPU_SYNC);
 	}
 	sg_free_table(sgt);
-	kfree(sgt);
+	kfree(mapping);
 }
 
 static const struct drm_gem_object_funcs virtio_gpu_vram_funcs = {
diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
index f50f862f0d8b..4fceac922a7a 100644
--- a/include/drm/drm_prime.h
+++ b/include/drm/drm_prime.h
@@ -54,6 +54,7 @@ struct device;
 struct dma_buf_export_info;
 struct dma_buf;
 struct dma_buf_attachment;
+struct dma_buf_sgt_mapping;
 struct iosys_map;
 
 enum dma_data_direction;
@@ -81,10 +82,11 @@ int drm_gem_map_attach(struct dma_buf *dma_buf,
 		       struct dma_buf_attachment *attach);
 void drm_gem_map_detach(struct dma_buf *dma_buf,
 			struct dma_buf_attachment *attach);
-struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
-				     enum dma_data_direction dir);
+struct dma_buf_sgt_mapping *
+drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
+		    enum dma_data_direction dir);
 void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
-			   struct sg_table *sgt,
+			   struct dma_buf_sgt_mapping *mapping,
 			   enum dma_data_direction dir);
 int drm_gem_dmabuf_vmap(struct dma_buf *dma_buf, struct iosys_map *map);
 void drm_gem_dmabuf_vunmap(struct dma_buf *dma_buf, struct iosys_map *map);

-- 
2.54.0

