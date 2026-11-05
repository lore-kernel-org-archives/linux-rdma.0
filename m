Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860956;
	b=h1oqCEnc6SzClGXT2Kx1os3PkC38joEB+3BcS7h8WWT7B15UIDBtJYXM9cWO0NxcOE8x
	 9blS0wuoo5ihzKmmC5wzoed2Lq+/6492xeAgLYFZhIGdLz4kRW67iK5pfbBl0CVOf9leP
	 sIxnCi9xYWwqLQw8Bf1PycK4VTR0yCCP1TaUbQj8rlBe7+VdobMRq2hHsUBjraUsw+ESs
	 W/5jCHlfBEMAZyfL9xTj9b/g4TdPUDMEfgiHhQYXiZELaUwt8o3q/VKgGiwWybrFmXH/n
	 Rq06j9HfRt1ErdPk6Y262oSCldB/pt7/4EpS+aWOBkZ7GOycuUL7TCXJbiIJimr8Oew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860956;
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
	bh=L59wo4PaXs89ZVWJC/mZumnrFEozQFJVheUhVb609hE=;
	b=0yTwe+j/BLUaqEotMWXCuNAKrh/ITjLmIbJTnEETFWcdWm41e7M2xBnmuOBZQZ0HHJsx
	 pSyTVz4jGBlHo9nI8qvO20ikVkeG4M6sOWPFYZiE5WgMyRKCM3SFlXuCHQYsuggAJKkSe
	 zstwtlyan6a4cExRaAFzoRzSrCZKJ8G2gugwQWkLfQ5UOC20nAGWsf7lYtl3JVbzIyP1z
	 jIsHjOQXlbbdr44co28IYweqngkTrqqyttjlFeDoS9Ycf5yeuvqYG+TqfXr1HQ1WCxau/
	 qQJmRsduHa+8xvLuFBxydTW2xH/7wYBdanR0RAywvqhOkeVvXia8lbQk4S7lGfq9o2w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bckz83NI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AE0606D825;
	Thu,  5 Nov 2026 06:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2AE0606D825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bckz83NI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbarRIuc0yAJZ5Cyx892gUIi1a0BhvJcFCLaXBmI9ZfgCpFpgvHhqNQRmLzjsuDteN87tgaIPHfvnsfMZzRAUhXRch42O++WzGSTAtpeea2p6/Drogi6qVoFRQhdv6pBKRmSjQNGEa3fS89tQJaH8YWCHcZCJ8MA9lwJe1hb9t+kKKaAC3aRTb4+45YyWFF5xK00tdnrnn5CeadKvuLoxwbSInh2Q+CLHvEvUTLo6uQOLVbgCTYfMKoWORpehF+G0RLcIm866QQ/LJJfUheb+WaodtxaJI9Jvt1WAjORjg0mbK0gSAL237uIJDyjg7g2/0tOY5jJYZYAKG28eQEbew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L59wo4PaXs89ZVWJC/mZumnrFEozQFJVheUhVb609hE=;
 b=h6rffw7MA1lVlqXoCyRomH58zGfNLzNFnftjR0t+b1I1PKJ0hb3RXkiOQesaRpBAqQvqZX18Hdg14fgWHBiXI8tujqK2ACjY3ENS8rqqDK+At21SlwKbYAe1i6Aw0tjdPp70LHS+PW/0eB1sVoS+i5ECiGk7zCpk+JKqP+Sxzv7Aj/I/vMAUweeL9T7d4/NWwvs9L6pWmpTVDJQSn8T5KQ6TFFsvVP7/BkaVOrAhapKeohNwT9tThg2pL6CEsPTWlwtsueiqZnufV31gjpRHHZ3R+vh14AV17wsdF/l2KChJOB0TjAo3/bCKcpEeyK0QXtesMSoSA4AqAQdoWZ3rrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L59wo4PaXs89ZVWJC/mZumnrFEozQFJVheUhVb609hE=;
 b=bckz83NIjLb6FXiuxwAArBmCSTnmCTAETLfj2DcM3wTJ+CrrDQQW3uTHIw43+T4iDUk1AsLCr57X0Yf6LjW1DmAYP/7E1Ry/wMvW9OCwq8JdEgRWaiXv1BaYYPn4L8TqbloB3AqzTMUfnf412nwZ2R72g+R4BxPxfHuicHaJ9PxFCQ/pLlzM1Tdz5lYv/pn4HGwlHT5OeijbpuCL4uHR7lOhnT5l2MkRB6je+asLgA3El9XahCu3WoUO3zOSZi5qF99Lclr3St3AXzwONdjjw+9BLyIwelXgJVgAC8EAB65GbMJKE97NBJ50Oh+vl0i/P96Xbp15WRqgwEeolcpexA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:25 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:25 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:47 +1100
Subject: [PATCH v2 12/23] drm/vmwgfx: Use match_mapping instead of dummy
 calls
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-12-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=2254;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=N8Cz8s3LFNUxkaqgxPAF91k6HaUkzBxE7X9L+ZZp09M=;
 b=HtWy2gmp+omTG9BCGfpHD9Bly7JzMVLqx+/9BE5mJ5WF9q3gm0QJhGv/pdJCvvl2GzmjPtlaA
 J0nJsMWRJE5Bz0WtvL6Fl3X5tcOyraRidV8zgn70d+JTxCs424kZuo1
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0014.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::19) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 9804e908-8767-4c45-3138-08df3b07f3f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|11063799006|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+uJ+HHwvZUnZk03nVchQzPfxQTASgpeKGXPttUV61aqOys+0AN+u7mucvPgDKfKRXY/qF9NqBEcGGgohq9D8+QRc4spCs324mKtfI99xalt76i8QJbhOckmLmm8oFKFL1j0BH+RhTiq/UZ6tyqcjnttHp9IkKRRaft6Nbl1HhzSOiWJO+2YOGp3DfVa2mtsgm+FxV//nXuR0EhT7wDz5xyxCbESGVYGGFiBy74eCf78K/ZJdf/qWVudbxZb0meC+EZbuKSibhxyRg1UyML63FZ86n5/Wv/cFkjTbAEqaHwSzpRPOb9s6Cyp4d/CUsH0A4zD9MXKm5bPod5r+37U4PaVGPUxMLJXyj1tqINTVrfPJmK4VrHrnR3i7B2DRDs2o4ipDdjgmRgab058I0+ckekLi+aPoQ/dyEW2M5VDwsw7ZfAvFgxySbakdevB2/7Z4FRumyCLhqrHLdr3FKD51TNP+I5XEW5dz1nBVq9lje+Q4wbfmXXftr3Rzggsa6C4Z/RC3iacFAXot0ibTyhD3IdBeZz14gw8Th2xCwj45ZsRnv6RMisPNzOttFQV1HVevqSNx+yDUpvtDSWEiJxHwf6+hu0hh1LnOyKDvT1Uxq64AXlWVFzKtSdzz+eRmdHozHT7dqYGzKBGNKkebIX49zYELgEgf094v8RlxWwvhzQwAR5qnmxnas+eaSf23TTDRAe3lN2BvtQEMYOoMQAd76A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2ZyT25DVVJVckVHTEVrSU5qTDdvUW9TQVgwVzVyaVRIQXU0RDZwSXlvZDRl?=
 =?utf-8?B?RDNFR2dEVFFFdUtCNDVyTEF5N1NqbGhGTEt2VlVGODFsN2RkNC8vWnpjdDZn?=
 =?utf-8?B?OGhyKytZTU8rbUhncVNDN0MxOXdZc0h5L1BMNEEvWTVKTmw1YTZtcC9nNmVG?=
 =?utf-8?B?Znl2b2lHQXcwMjdHeUFoK1c4VTk1UXZhczNsbjBnKzdTdXpsbWd3KzViMW5p?=
 =?utf-8?B?U2NMTXFJZnpROFlDNEpha2pDMUYzSTZOV0V3SGczUUhqY1RoR3BzcTZFamNN?=
 =?utf-8?B?S1N1Wm9GcEVmeHlod3VaSXNWeGtKMjRyaVBCM0U2cGozRGsxbDR3MWtZWlZH?=
 =?utf-8?B?WmtxTDJ2SUNmZmtJcUlhaktiSkZvTU5IOENHTWVlVFRzTlFuVFJ6SVFTa05F?=
 =?utf-8?B?YkNOYnQvalhmVzFJZjBZOTlkSGp3VTVYcGEzVjZNZFpOYnNjT2RvQ3pXR0o1?=
 =?utf-8?B?aTluWTliMUN5WHVoOFJpMU9qOUFSQk9sLzdaS1dMU0xrSm5YSVpWcU9MYmdu?=
 =?utf-8?B?YUNmMTM4N2JCcGhwSHRhQkJCTjBhQnY3d1ZvcHlmUy9lM3FYZXRvWk9Ea0hU?=
 =?utf-8?B?QmpTMlB0ck5VSlR3ZGFRNzBtZjg5Z1QyZ1NGakpUMGJZL1hySHFVWUR3M2Ir?=
 =?utf-8?B?TUlOY1ppQjZJdlFYOXJ1UDduS3k5WTZjUzJCK0RHM2V2TDR0OThVMCtpTjE5?=
 =?utf-8?B?MTFrdEFOU1RZNVF1K2Fqb0F6L3ZFa1NIRS9taE92Q1ljVEdJOUVwMFdaZHRj?=
 =?utf-8?B?ekRJOXdySEhIZS9DcGF5YndVNWxzcjRDN1c2R1hOTDRTUnVSdXJRZEhHenBs?=
 =?utf-8?B?bllVZ0pWSnBYNFdLSHhRcGRQNXBCUERvMkg4LzRmWVhnTlBkZEhJRXF1QU8x?=
 =?utf-8?B?cFFlL3YvdG1Pc3pDQkhuQXh0THk2Undvc3BaVzRVa2V6blFlVmRYVlRPZVp2?=
 =?utf-8?B?L2YyN1AybGd2aXIyeTFyQ3c3N2taVWl3QWY2Z0FYMGE4VWVZZmFNa1dmc0hG?=
 =?utf-8?B?czdYQVF1aWlNTlM5aXFEMGd6Q2VLK2tOcG1QRUtUaXovRllpZlNJMmxEMThr?=
 =?utf-8?B?TkV1ZWorenBJdVBpeFdaYWl5TWZFdnBMeFM2VnJmaUpxNXdJVGhwKzMyQXVj?=
 =?utf-8?B?WlBSOW9mYjJqS2U0NS9scWlFd0R1N29vR2V5YnJPaFVmRWJOb0tLcFRBSlpI?=
 =?utf-8?B?UzdOWmg5YVQxTStQckRZclJRbjZFbGV0RVd1KzJQQjFwamViOGp1d2UvRlhT?=
 =?utf-8?B?TWFOUGxmeVJXM3p5VUxOV01BMnRuUnl0SURqeitKZUw2M2d4Z3RadUZUc1VX?=
 =?utf-8?B?a256VEVkQllRMmd6VVYxMFllZU5mejZKWnE4S2hSL1Qxd2Z5M1B4dFFlMmxv?=
 =?utf-8?B?eVhoYzBvS3M3WFpEZWFOc0tUUDIzaHY1bERpcGZCbUlQY1FUTEhQMTFldlNO?=
 =?utf-8?B?dEs1clpzcTYvTlppbVg4NHE4WWhWSGw5VHJTUlBzMDRtUnRvQzYwWTVuUFM5?=
 =?utf-8?B?cmhSaWt6VXpnSzNWaGVYTnlQU3VrV2I0T3lzR0FHYU1za28xMGhEbCtwL0xu?=
 =?utf-8?B?NXQxeTUyMGdCc01FU2FVbWNadDVmcWJRM2swaEc0dGMwQUNZRVAzblo0QlVO?=
 =?utf-8?B?bG9LZ1dzK3k3S3RUd3F6clBidGJNeW1XdytMVHFQMEhhQlp0OGhFK3V5YVZw?=
 =?utf-8?B?WnhnRHoyeS9VaHZzcGwvOXdmN1dWajRMNldvc2FUREIrMHd1K3A2cE9Nalc0?=
 =?utf-8?B?T3N0RmVpUkQ0QVo3L0JONEgrdU1ReklLZkZvcE41WGRCWHlOOXV1R1llSEQx?=
 =?utf-8?B?MUhVem9lR3R4N0dGaHJiakhRK2FFR1NXemR5bFhRcW0wbkt5NnZIMkZ1YlVu?=
 =?utf-8?B?dWd2OFhuVEZ1c0s3a1lVY0E1c1BhVzR1RVZ0UUZXOFBoT1JzQTRmdXhMcGFH?=
 =?utf-8?B?SXFpcWRaZko1RTd1MHJ4bEJIcDJ3aTJsV1NsM1B2bGdPV1dhWWZJL2VKWC9y?=
 =?utf-8?B?L21IakJZMFRxK215aGtpL0ttaCt4Qkg3eUlLc0Q4dkhaSFAwVkdrVmZUb0dr?=
 =?utf-8?B?MzlrZHlzU1J4QVRUYklqSDJyK1NSSU56eVpONWRuQWk0WEw1K012REZnZHZz?=
 =?utf-8?B?cGlTbk9pOXRRRVZuTTRVK29tRzAzdDJGN2VSWExQdTZCSUUrOENkRkx1QmNS?=
 =?utf-8?B?RWNGY0JKME41bFhybG8xamRZZ2NFVkdud09oMEZhYTFPbnJWRFBacEtKMnhi?=
 =?utf-8?B?VXNFRFBjNzJ4MVRZb0h1c2NRYjNxZWVLM2EvWkd6MFRlQ1JJV2QxWDRGRzlP?=
 =?utf-8?B?STJNdU82QW5XT09GeGdhYVlVYk9lcHRzNTRyNkxrcVFpR05ST2xrdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9804e908-8767-4c45-3138-08df3b07f3f6
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:25.4247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKL9BTc4E0zi6omfWECDpvgjj1LDr2bN+mT3ft269fAXXCzKGhtahDSkWSYOGR8GHZE8QK1/jKIedOlVX0e4TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

vmwgfx is creating a DMA-buf that cannot be attached by providing
always fail functions for dma_buf_ops.

The attach/detach callbacks are already optional inside DMA-buf, but
dma_buf_export() is checking for non-null map/unmap callbacks.

Instead use the mapping type interface and provide an always fail
match_mapping(). Remove the unused SGT and attach/detach functions, they
can never be called if match_mapping() fails.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
index 598b90ac7590..90e4342a378d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_prime.c
@@ -35,41 +35,19 @@
 #include "vmwgfx_bo.h"
 #include "ttm_object.h"
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 
 /*
- * DMA-BUF attach- and mapping methods. No need to implement
- * these until we have other virtual devices use them.
+ * No need to implement these until we have other virtual devices use them.
  */
-
-static int vmw_prime_map_attach(struct dma_buf *dma_buf,
-				struct dma_buf_attachment *attach)
-{
-	return -ENOSYS;
-}
-
-static void vmw_prime_map_detach(struct dma_buf *dma_buf,
-				 struct dma_buf_attachment *attach)
-{
-}
-
-static struct sg_table *vmw_prime_map_dma_buf(struct dma_buf_attachment *attach,
-					      enum dma_data_direction dir)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
-static void vmw_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
-				    struct sg_table *sgb,
-				    enum dma_data_direction dir)
+static int vmw_prime_match_mapping(struct dma_buf_match_args *args)
 {
+	return -EOPNOTSUPP;
 }
 
 const struct dma_buf_ops vmw_prime_dmabuf_ops =  {
-	.attach = vmw_prime_map_attach,
-	.detach = vmw_prime_map_detach,
-	.map_dma_buf = vmw_prime_map_dma_buf,
-	.unmap_dma_buf = vmw_prime_unmap_dma_buf,
 	.release = NULL,
+	.match_mapping = vmw_prime_match_mapping,
 };
 
 int vmw_prime_fd_to_handle(struct drm_device *dev,

-- 
2.54.0

