Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795536211;
	b=FKpD6bYoXZuyERAu1bUAeMIITdw9N6Y0eRL9V6OkjV2hBzWD17Os8eLVk0Y0zKR+6IWc
	 /T2T8E7DAdt2NLCAPX9J3bRdrcns71DOAruLbjE5gzO5l6k25U2RHUNm0rI2BrYQ9xlgj
	 /FC3BwTq7rVHEoU2M132CI8z5ErWEkYXGGZznzcv/VFtM50VJaOsimoCB0JEoauU7mPQN
	 +oVNgxrqE+k6/SsOxSO/FX/NGmdSnKoLtMPUDgzTgjvrQ3Piv3FK71yPWGSgu/xHPOA3a
	 hUlqZma7z/mo7tYnFpQ8KxevohcV3l6WvwR2s+pq4aOurKl2k5+Zbhz2XDbyBR2K7ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536211;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5bQJNMobLMqtuKHhwgVId/roqubolCM8LnRFW1vjp3o=;
	b=CKqksOA4Y3FDOZH/FkXA9Sk5TJcrdrrl9GERA56zTohIK3tbA0RVLDGTWkMwAlnbbKxK
	 aHRE0KBtM9jiahGfpU9EN/nM7SLSre7I7hShCOs7INtm7oC571PQ4aDLFP8ycGquLRVUB
	 QlRDzl6Pua8AV+Tnf/5q1Z9Xbfm0i4t2HL3pZjwJCzTcWx2pEnn21jfdzVNMWNepeU1Hj
	 aFQpj2plJwuI7I2totw7s1jL3loiJPZ4Vra5XIGPEw452fwC6mjhBc4RFYKChP/2w2X2Q
	 Z4JUviutoeG0kjwp4ILZgBx0JobJbQMMK6HNdA5iDHoVqsXBCdXM5TpRQiHozEh2zCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mbA21XMT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.4
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010004.outbound.protection.outlook.com [52.101.201.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23E7606A31E;
	Tue, 24 Nov 2026 16:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A23E7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=mbA21XMT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gq0Jh1gCOjTATy4Jm2MMKtHvk65tQl0FSyePRv/vKMI98tnlaTxQYUqJN7Bg2/zAgqSo7uYP6bGPxxrjal7rq8pugKcFPkw2Z8i7noD5LDOfR9+TRTsFRAlMKnI44DBx5V3qrqUR64NqkUYnqznZkyephAo8t3QWg7QrZFaRkQNz09ZqLu2hUuhhHeMmLVatvkIoccwlQDQ20F5vKUhWULQz02jdO76QJPFECk9p4W6UM2tOWtVwCpMDV3h/184/QlPcGT71golPOI70XwBWAK/lb1Dnhl8eeiU2FXayNCsnMcV6bXOjc47uNgQMX4IEc4E28AAix8PtLQIXNZ9J9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bQJNMobLMqtuKHhwgVId/roqubolCM8LnRFW1vjp3o=;
 b=AnKh4GO2r58cT0mkgRyNQscqPeT9yQgLi/CSsPL1R265ulQHjKpd4a7ebxccUzyMCgDOR3XWuuT77Ec2JW3V+UWPq1mrGmNJ25MXm1JMHtMjSOUYq4OVbnQEbK938TRfKIPdNIcMntph/O3N9p5NLI6vhuiWNBPocMLSu4FKGLXCG2TDV7bNEaLI+7I6rK28gErgvOkiTtUBLI7E/qINIP4AqW2a8tWFVPD7N+6EUXMuzX+qmLyn75OwD7ZP42s5p7UYJITrkJKEBO/enAaKpg7s/Uxdyfb/kWmKz87IJpPBkJA8g2l8VSS0gR2LiKiv/PO3bU/68FCL92yG+J2+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bQJNMobLMqtuKHhwgVId/roqubolCM8LnRFW1vjp3o=;
 b=mbA21XMT6a1VPpfZHwdu5BOyKuhRJTcSCb6hRPL8WD7/8XmyZpsqFYRaLUkd3xW3Iy8rgBgbb1QsGZq1c3ERQ8DK4O1YXZi2N69DIOBEz7zC32I60PLmbeTZvkh6TywNfBUssB++jOsWhkrGYIHceLI1Mju7cMAjBo1aMpegJHQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 16:02:50 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 16:02:43 +0000
Message-ID: <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
Date: Tue, 24 Nov 2026 17:02:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alistair Popple <apopple@nvidia.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
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
 jhubbard@nvidia.com, chaitanyak@nvidia.com, Leon Romanovsky <leon@kernel.org>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
 <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
 <20261123165716.GM179082@ziepe.ca>
 <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
 <awT8prWsj11TBdmP@nvdebian.thelocal>
 <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
 <20261124142032.GN9566@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261124142032.GN9566@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: ee4f091b-b256-4438-2ade-08df4a445f68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|261102130727099003|261026121527099003|10067099003|11063799006|5023799004|4143699003|56012099006|261028144727099003|261022105027099003|261026140227099003|261021121427099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CSGAM0gi8jGkyMss17S7FUuh3CUCJyHW0gDVBrOLeQ0Nvw8Jl5Sk3ZbSQIcxo4GZo3B+xZrZ0q4zz3OrX6pFQ35QoBEzId6zmMS9BEWiDlwEPFvkMc7cj906oA0/ui1++IUjt+GVu4Fsu1xw0Mzx0oMygVPKyS/wYdtts44UiZ2S4hxQ31oFxasqp1jMa5Zucrl5PD8Y4bV63rCbk0woTpUodga+GQlCWlJmBKXmFpEMMa30s2+nVk0h1EeYaQHgK5zUgMfPmNEmMneXMIpXm4139Iowqc/w76BRkgv9Ljp/icf+vcrOLuhPgY+S0aIwq78OgTzjEQ5WfM3MglJKo521Je34YAxKEm5ZZLzmf8mEerrVCeXObBEYUtpdwKXvapxQwpBmbL58qZOEY533WXVQk5KWUtS5t0ptHzvNVrhfx6kWUCT+Xa+GjAlebIgRApL3/W0LyvjCZAtch9soI2K/eBFh7dgSp6VorU6q3cHW49MyI1Lq57FFXhCxzRcdJTinY6sGBqliCbp93VTVSj1cwxQm2bR6n6hz54QAn2/7Bd6ejtVkGnDKqDaNCqPgDbA82EsPCFtHsJx4HdQ/qXyu+dcMybNI+k5+ICETjTOli1J0EhW6uJgTk4I80Uzi6/qNmpCreX6ct28iKbvz/rzjpurIPZbo9OV0vz5YNuc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(261102130727099003)(261026121527099003)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(261028144727099003)(261022105027099003)(261026140227099003)(261021121427099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHh0WmJ3VC84SUhURnlVclRMdzhPbVdVSDVXNmpwcEY5cFk5SElvY21DL01n?=
 =?utf-8?B?d003ckxkeXAxSjVHSENWR2IxS1ZOc09yODFYYnRrek9IZnZZZXFpR3hIYzda?=
 =?utf-8?B?L0pqU3lXQUk3eVVaWE9RdjBwSk14ZmZiQm1SYUtMcXIxeEtWMU9maXFBU3lr?=
 =?utf-8?B?V0VtU3ZhNUJrRmJlSUhPL0lEQjhHckthMWtDK1NucHpEWUJaRWR1N2hTcUxS?=
 =?utf-8?B?V3ZwRjFRT3lwc3ZYaENkSGZyRnVZSVR6Sy80YTRFbGQ2czJkNkRaRUxwcXpI?=
 =?utf-8?B?TjVLcDJEbk1aYVNuTGx4NFJYRmF0ajhscDA1M2dqc0RtUUV3aTlHZ1FZSHJj?=
 =?utf-8?B?VlJodm5PeWNwWVNYcmE1T3FsSk0yb1AzcndMQ2p3MnNKOHdnaG4yQWNhV1Y3?=
 =?utf-8?B?K2FIRWtaNEhlWVZ6UU5EUjVyUmRNVmFrQ213V2ppdGZCL1krOGRRbmV0S1hy?=
 =?utf-8?B?UVo0Q01JcngwY0F6VlV6S0lubndCR0FiMzYzMk4wOVFBRkJXTFNFRFBONm5q?=
 =?utf-8?B?elp6TG5vN3VCOUZ5a1I3ZFl1cFB1UFVObXgrWUQ5Qk80U20ycllweGw1Mk45?=
 =?utf-8?B?dlQ3MS80eWpwcVlneHVhdm8xSGl6MDl3UTV2enc0ZUhERzI0TEd3QTRVSHVV?=
 =?utf-8?B?S0Eyc3VuWHB0L0VUK1JsMHNmZEs1MzB3T2pjNGxGTDJoTUxkR0F0M3NhUFZJ?=
 =?utf-8?B?TDY3WldjUnJ4NlV4Y1EzbTFBZXVXeU1MelJzMDVuSjgyMW9wOXdTU2pOUWds?=
 =?utf-8?B?UHd4VTBXOWFQY3ViT0RGM0NORldwZXM5a056SVJ5cVc2Y0VycnUxQjc4VzZt?=
 =?utf-8?B?V3E3emJRdGQ1RTh2MHJSU09TL2RVTko5Yk9PWWJERkJSS3Qyb0pDZkNJSFpw?=
 =?utf-8?B?L0FLL0UxRmNNb09QY3NlRHh0VlVkb2Q2UmxDVEpLcTBHNnRYVVgwR09OTG5H?=
 =?utf-8?B?d2dLblFMaWZoZEhwUFpyZEJXSTVQbXd6YjhNNERGZHhyS3VWU3laTVlYb0pD?=
 =?utf-8?B?NGR1TjJ5d2pTRko2Qk5CUmRqVmg0Q2x6YUdYUEtBT0l6bU1mUXlnUWxCcFBk?=
 =?utf-8?B?VWU4M29HZmNvdjVKcTdDTmMxdGZoRlZOblRYUWp1Y1pZSjdHWXZBY3lHWDAw?=
 =?utf-8?B?T2ZkTm9zNFRmRUN6MEVlNXF2czhESFlqVHhSL0xoMGVhLy9zSDljb1RnNU1M?=
 =?utf-8?B?ZFdsOU5uWmJHc2d2K0R5K1ZlNGwyYnpwZlBoSzRheURtQzA4SXhaQXNkQ09G?=
 =?utf-8?B?cGRlWjRGMDdIMlBaSTUyV2M3WDkyb0hBN2lodUlqanpibFQ4c3M1d0tIZ0d4?=
 =?utf-8?B?ZURTL2l6TnF6WmlQa0o2YmtFOU1CTEEwQXBTYlFDTzdhVzRlWUNzQjFuMDhD?=
 =?utf-8?B?Mms0RDRXc0tYdkdFQ3RPeFlNOGltaUpwNC92Q3FBaE9GTVJuQ1k1SGFuZk9H?=
 =?utf-8?B?RGt4ckF4Z0Jsc0ZiTUZUdXZtaHRuQ3grcjdpWWVYZC9Xd1lxRlpOU0pJb2lM?=
 =?utf-8?B?OEJzTXpuZFRnQzc4Y2FjL0NybUl5MkhkbXhwZGphYUJGRXNLODhrUjlyQTRB?=
 =?utf-8?B?dlF2bCtXTjV5disvODM4Y3NNNld2WjFKOUFXc3l3WXdzM25nRUhxNWJ4U2RM?=
 =?utf-8?B?dkVMTVdiYmw5WnZITFNtU3JVVW4xYjhtQ0Uvd0JVWWIwMkhXMTIzQnZRMjdn?=
 =?utf-8?B?YmhCbFhKV3dDMEFzTGNVR2VLMThaQlMyZTZ5MmZUNVkxYjJpT2ZrZmdKWTJN?=
 =?utf-8?B?R1NqQzlUZnZFeTg4dERNOWFuS3hGU3UxZmw5VlhVR1ZaWVNocU82ZE5qbVVo?=
 =?utf-8?B?TTk3QVBoRDk5bnBUa1RiMXhoaVVpNnFuMkl4dERzMDRWdHR4aW1raDVWWVpK?=
 =?utf-8?B?OWo5dU9yQ1dkVGxVNERxM29GVUVuby81c3JPdjN5TE5sUGg0SjVaVmt3L1Zu?=
 =?utf-8?B?WCtxOFB4UG9rbkdpWlV5ZFZmZ0Q2dk1UQlVRck5NNll2WU50YXJyR0JIT0pl?=
 =?utf-8?B?ZEg3dERwWnJhSE9BWnJmdGIwMWJVRXBnSFlLdXN6RUR6VUYxSzVnbXJrMFVJ?=
 =?utf-8?B?N1FnQ2tPRU50UnRGcS8xVEhma1AvcE5keTMwOGdnYXM2aUNILzdwWnRIbmdF?=
 =?utf-8?B?VW9NeFBISlgzOFNuZkxzU1dlNis3eG5YWFdicDNYUk56akd4MjJzbndTdW8w?=
 =?utf-8?B?ZFhMV3pMVHBsUUpFOWM3c0ljbWltQWhJa2RQdVptamM4UG5tWUhTTFk1VVVN?=
 =?utf-8?B?LzUybk94WVBsSkNPanErL3Nqc0E2NUpFSjd4VlhnemszSUJOWHgrQWtBN2Zm?=
 =?utf-8?Q?2thNZKfYtt+Mr00oiP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4f091b-b256-4438-2ade-08df4a445f68
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 16:02:43.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCJtcX6OJL5gLPJWv1WZrBnucO+5mrKnka3K10xkvL2RhEUSaVrMOP6mr1a+or3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179

On 11/24/26 15:20, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 01:36:21PM +0100, Christian König wrote:
>>> The core then negotiates compatible types and adds converters between them,
>>
>> I have strong objections to that plan and would potentially NAK it.
>>
>> DMA-buf should *NEVER* accept CPU physical addresses nor provide
>> conversion between different address types.
>>
>> Keep in mind that DMA-buf is solely a container for DMA addresses,
>> nothing else and it should not provide any mapping functionality
>> whatsoever.
> 
> dmabuf needs to provide support for drivers to help them use the
> interface, and going from physical to dma_addr_t is absolutely a
> common task every driver must do. I don't care how you call it, but it
> is a service that must be provided by *something* and matched to the
> needs of dmabuf.
> 
> I will definitely NAK any direction to open code dma mapping in every
> driver again. If we are going away from SGT then we are fixing all the
> DRM mistakes, including the wrong open coded DMA mapping, sketchy use
> of SGT, and abuse of P2P that seems to be endemic in drm.

Completely agree to that as well.

> Meaing the exporter constructs a phys_addr list, gets a P2P provider,
> and some common code constructs what is passed to the importer. I
> don't care if this is in "dmabuf" or some "dmabuf library" or
> *whatever* but it must exist as common shared code.
> 
> dma_buf_phys_vec_to_sgt() is the template how to implement this
> transformation.

Well what I disagree with the dma_buf_ prefix here.

DMA-buf is just the container of the result of this process and it shouldn't hold any code to actually generate the addresses. That is simply not part of the job of transferring those information between drivers.

The whole conversion from phys_vec to DMA addresses is something some API should provide based on the data the exporter/importer have negotiated (e.g. p2pdma_provider for example). 

I think we need something like a DMA P2P API which sits on top of the PCI and iova API.

> 
>>> and having SGT as a type is what allows that. It only exists for unconverted
>>> exporters and importers and eventually goes away once everything is converted.
>>> The idea being we don't have to convert everything all at once, whilst also being
>>> able to add support for different interconnect types. Are you ok with the SGT
>>> type if it is just transitional?
>>
>> Not really, it just complicate things.
>>
>> What we should do with the mapping interface is to add the
>> information in which domain the DMA addresses are to be used.
> 
> You need to negotiate the actual C data types too, especially if you
> want to do that nasty idea where dmabuf populates an iommu domain.

Yeah agree as well, but to be honest that task is negligible. We first need to figure out where to put the code. 

Christian.

> 
> Jason

