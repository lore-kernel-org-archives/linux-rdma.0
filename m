Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795523802;
	b=YTS3cpdbwYCv1YHrSKsJx/kEYhGWmz+CxjoSIdKZjeZ/6BRu4ItjaCPtx3VIcSJhyMgw
	 DP6uwuZsQ+O1z1bAbW6RoEobzD3G8YVnfQDtJmZZOsErQzFGMIDqo+PZ4varM6tTZckgO
	 hVP55I1v2mOhCJtYDsmV4WqgErPUA6xXiEP5G7HngDCjuVWZ0BYaFENLgLZWkRPEyCs1o
	 0gRlEu5+ZUkcvUbA9U5YXZLJJ3IAJZaJD4svUkiYCRinn9SwcOCY0dXpXBn/KKju0aV0d
	 nOi8QDnc6QeicTYrKZNcPY3WPb2ItkLvD25agDiVEmPT6G22noXMw09JRlsuyLmEoug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523802;
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
	bh=wUqGi0asszbN4dhIxO+gZaZle9N/6uln8kH4AIJVyHo=;
	b=0rWCER4wdQFAsSz1enrO4n5M2pqHuELpeHF3s25CD+XzTW1hc4+GkCymWTgLzNFrBRjm
	 35/XBJiJjYt6tTBMjw2jTRVQzR5GrS/2C+xSirWCtWauM47JvRG1QsxXCY3DznejnuFWc
	 PVG4zai4pHy+A7ddsRFzyiuEMR1u/X6yf5wkOq/fUFcudxsjWscSOcpC0U1BXAXIsavDG
	 LgF7Lu/cJsEc3T8jHrjsnTNAvC4XtFwGURN7B9+hLPzenrs4eLREr6mO6b26phmLwPIYR
	 X0z3q0HqRW6vbMGMBiNlDjIROzQGeEzbDqBb0Ig8WjdiPCJkak5Cm2f4hxP4bJLepmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="19mX/iwC";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.50
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010050.outbound.protection.outlook.com [40.93.198.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8163B606A327;
	Tue, 24 Nov 2026 12:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8163B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=19mX/iwC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JbgVCZGIP6OwjitDGwHiW0cWDhtrRTigZR0Gv5RxkV+SDkZ0EuUf+kfCln99LexzQpLFkprCbBIKbiuugwdb+yaCDvEIyum3tZ8gMw6yI4/rwF+bMVhl9HxJFYZok00mUzv7GKTKK7fHbbNOAsA8Pq6L/JGpJ/IAZtMwB9WTm5EpxrTPIjZEpWubQ1O2FOTK8vQrIQyC8ZjqOW1A5CMfDAXqVf3HBUPgRKys6XVafrpIN/GCE4F4PxD41hmDwg9nxiyXJvHtmK3gn621QQ+eTOldgGHI7ISIE00cICFPviRPLcaA8WGQ+Wy2YqLIJEvqUUXOIYNG+pv4CYr6dM8TaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUqGi0asszbN4dhIxO+gZaZle9N/6uln8kH4AIJVyHo=;
 b=J+YUGzAS7fTcyVvuTyR7XOZRair4NM5ARI+PCbDUnkZKKOU9xmbHOEhSMTDAUAMBQTzzeQdia3xmHIrbXh7Crfn5W+dfolT7OskydAPPNkE5HAfM6oQrdF9oRBHM5bcs3RRMg5ZHQ0S1HzAagyRs9I4w2zk5lgI/Z/OKL80v2OMIVEyXy0RG3e5M/2EY/332F8x9yzBcf/EHGg0pOxK41Oa+nsPXODd5EhswNALcTgXjCjdhwNaj2h4YctvOvrMAOefTpp0/FHZQlDhAz8b3TxL4Y8d56wtad6AZH52fDsihhynOqB5u7W1kNqOHGA7ngpjefvyO3mvmLx5adjekIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUqGi0asszbN4dhIxO+gZaZle9N/6uln8kH4AIJVyHo=;
 b=19mX/iwClCI4bNSJyXNkfMdHOEijCNpn7pVx6AkrxxDyBRbaESQPO81OlnpDkQohQqcJ8XNqMO8I0/wpzzgIShUt9DRlzPBYR+m5jS1FYiVQf/MAEKkZOx4sE1ryI5R4nboI1FDBm0Dvf/zKEnmXMIdK31wlTceGS61a843n1/0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 12:36:37 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 12:36:37 +0000
Message-ID: <63eb7b6e-e0a8-4443-a434-0301ed59beae@amd.com>
Date: Tue, 24 Nov 2026 13:36:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sumit Semwal <sumit.semwal@linaro.org>,
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <awT8prWsj11TBdmP@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0274.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::18) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: da56025a-4a2f-4a47-7c3d-08df4a2794cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10067099003|5023799004|11063799006|4143699003|56012099006|261022075727099003|261022105027099003|261022115727099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261102130727099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	feCmSxzinazgK+ddzPvYJCrymh3A+htw6xwY9TOAvxpZo3FHL0t2REvOe0ILoVSrqD4pLy4vabNaTnFa3aquueicYxaj/0mNAsbxX8BXHUUvqgAMuWWALKHogVyS+jBs62ANsjhrwL8SFKeH8XA9A6UsoVoCC4rQ5otVNRE2N6PxmT8a50dmxoO27/yPUNlmcFP6yzpui2I//bKJHsuF1K/dP+v48jWVimNjV7Xq96gl5xI3wpmHEEa+xsBDf4sUmvm1P9pFnLjjd3kHWmgfkV6siyCqGxAKfx3UHJNQ0ieBc0kjw87rOxlKrku7EKdWSuUTrVntrYomhlCbiXW/SgMvCvSiQRNLrJdLvAXK6wWhMtAy2YRgke9GP7CDtnAs4Xe5rO8710sc6FaFnAHG835KuaRImPcGBPY3oIxbUP4zvPfcRHsUJnGjI6vaEkpmddp1pocJiUv9++dGUnl4qoFOnMcaQRo0R2IRChKWElulZqUtoY5JqZjCxYU+eKhZ5SCbrYGp6SblrPGT1Ha8itYECePcYWq3zH10sUv7y1y2cTdfLypLaQRBbDGtKpc7FZQ7g0MwFwnGFW5LZTlCVJv3N4hw8R7Xh7dGdh4tCRA/jhdyQkewFw+maHL8ek4Kbni7vg/M5fIj0Dd4BBDRxjZRgRxxuIiCdsy40kj91ks=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(261022075727099003)(261022105027099003)(261022115727099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102130727099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUoxNTZ2dEN5Ym1NWEdHSExORXBCRklSc1lhc29pdExFNkhpeGNyNzNhY3Ba?=
 =?utf-8?B?VmRETFRqYlN5b3ZyazRJUVh4enIvaE56YzljT0tPYWZiRTdsV1o3Z1V0ZUVp?=
 =?utf-8?B?alF1UHpKcGlKcjdyMXZZbmtXMGZBbG15TCt0a1R0UXJUeXR6VG1sNmVzNFlu?=
 =?utf-8?B?VW1zTEMvRUZRTkE2QW9sb05MenlCdTQwYmVKWmUvdDlyeW43ZVpCRXI4TWhz?=
 =?utf-8?B?TDdJVEJNQzE2NGRvREw5bzZQdWp1TzllL0Z3T2xoL3EwaDBzZWtaVi95dnhN?=
 =?utf-8?B?Z21lUDRhbUtjVGdWY040ckVUbDdtOGR0R2xDckpCQTZ1RUNOOTk0ZFJoMGdJ?=
 =?utf-8?B?cjYvNHFqQWFhUythRGFGUHNQZmo5bWE5dWk4cnI5OVFNNThQZE1VSWZjczVN?=
 =?utf-8?B?dGpWMWpxWUx1Nk1TRWs0a3g5U0htUUpjZWJ1YUVUM21ZVnBwTTlZN3hVcjE3?=
 =?utf-8?B?VEM1Ym1UclRDV09uTXRDdEY1SSs3dVhuOENld1VnSHMwbXVvNUc1NW15QVpU?=
 =?utf-8?B?M1BDekxqdXJMNm9tMnlBUVBCTFBXYWh4c3A1VXQzS0h4ZEc0ZmdWVnZ0Y1By?=
 =?utf-8?B?bElVQjM0RmltRlNISkE1UVRmVVBackJJZERBbnY0WTBwd0tDYUxoMWxXTmQz?=
 =?utf-8?B?WlJxcDVrQXc0Qkhmb0EyMlI1K0UrSkxyTWpnYUFFWWVCMERYZjM3UjdLKzZk?=
 =?utf-8?B?Q05FUFJnOElzaTJyV2V6MzJmbFFqdUdwMURDdHZacjF1SU0xMjFqRS9waXds?=
 =?utf-8?B?REVzUHl5SG50VUtPTmtvcU5jbk5VWmh5eEdKaWNyWEszdm9lS2NPMGxCNnlx?=
 =?utf-8?B?L2pEMUtCcnc0NFgvd2VaTEF5L0tnMlJxNVBSRFcxWE1ISjBpYS9hYk5pYXMx?=
 =?utf-8?B?eDZyODZWL0J3alZsckE3OUtDRlM5Mll5ekhhOFUvdU8zaXdsZzRENC9tY2Zh?=
 =?utf-8?B?Qm41K3Z6WFYxVFVJTFV4QmRUR3JpYUIzQ0dkMFNROGNUU0VCVTljVWtlaGpT?=
 =?utf-8?B?aWRtM1g1cHYzNGcvaTl4UGY5R0MweHRBYlRnWXowWjgvL25QNjY0NXVuMTEv?=
 =?utf-8?B?ekE4eUk2KzFPbnZ2SzV1MFRBVXVjK0xvMWxPYzhRVFpDWGVYTldPdDJpcE1j?=
 =?utf-8?B?YWlhWFlSVGgrQ3RWU3M4VmQzbVpyTVkzY0xqaE5jSTk5VFJYL1NnZXM5RW01?=
 =?utf-8?B?T0Zya3JvYTZMd1dxYkdBNHRGS1BCMU5JYm9MWG9xa2xFYmM5SFRFUEY4amE0?=
 =?utf-8?B?Z1Yzb2tNOUJ6S3BZN1Brd0pCb1UvUEtPeUJBcjlFZXdPUkZnZ3RuV0pMd1Nr?=
 =?utf-8?B?blhMUDBhY1JFaWJNcEo0MVgyd3VlUjBJQ253NHJjZzl6MUJ3MGJhNDBoRjFa?=
 =?utf-8?B?aktRT08vWkN5bXhYamhYcm1tMDY2S0wwc1dOR3phN2htZUg0ejI2T3JYZnFB?=
 =?utf-8?B?VGRndGNNMDhYQzRhS0xwWGlYazBqSmkwSUJuU0wySE1vbkxzTC9nZlZpRWw3?=
 =?utf-8?B?aXRTTGRRdGRmL0xoZVB2NkpyM1lzOVVUWUgyV3ZjYVIvTmZFaVMvUXMvM2tl?=
 =?utf-8?B?a1dxbkRDN0JXUzdOWTgzTEJIdElLUGZDYXc4cWJ3VVhETzBWS0VsbDlEa3FU?=
 =?utf-8?B?LzBpRFNwMG9URzJwVTl5WG9NTW1oR3FrQWVCd1pEa2FpTDJaWFhHRno1MVBm?=
 =?utf-8?B?eGJZK0dnYW9WRUpqTmlpYzdsak5KNEJYa1Q3cEM0MTFSdm9BTkJ4WHZ0VFQ0?=
 =?utf-8?B?WUdTVzVHVXhzN0hqdHp3KzdRRHhQNnlkamJhUGhsZElJK2FuRDJxWWRHbktH?=
 =?utf-8?B?aGNIZVBMdzVqNndvTkVpRnRHSWVGK28rQkVZRFpJUTBYS1R3TkNmREZRbjNt?=
 =?utf-8?B?by9mRzhTMXVXZnk0TjZWclVhR20vYW5VbWZrZXU3aTBMWFJERytmTEV1Z2E3?=
 =?utf-8?B?L2gva0VvSXJOdzNRNjZNV0g0bkx1Z2w0QVdIZmFJSjcrakIyNk85VTJjWHp3?=
 =?utf-8?B?RCtxeFkxQWZ6ZGxOZ3ZmMWNWc3BWZzNJNXlTcjd1c3R1RXQ0SkhUU04wRTRX?=
 =?utf-8?B?bE0vVm1YRERhdG1BL0ZPb3NYdS8wNmt0dUk0OEt1MERlTDZNU1Vzb0kyelZ0?=
 =?utf-8?B?U29EUEphWWxMNE5UMXBQd2cxbnY1RjhtRnlnRk0yODREVjFpVnVTRmt1Z0dG?=
 =?utf-8?B?RWpkMmVxTldJRTljT0VBRXFTcko4ZDIrZENwK293UVFNNFoxbjYyUFB6cjBM?=
 =?utf-8?B?L1RSbEk0eGFxanRVbityb3NWcXlTaE1SYXZkQlBmWks4LzUvczVzdmhjcjF5?=
 =?utf-8?Q?I2A/JK5/bILZRRiFMj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da56025a-4a2f-4a47-7c3d-08df4a2794cd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 12:36:37.2768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27sY3Rr2a0wztZlzHvLMGZIzFiy4Uq0kBGeO/HSHqWgvc9ki3obIq/Yx0pH+fYxx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370

On 11/24/26 07:23, Alistair Popple wrote:
> On 2026-11-24 at 05:37 +1100, Christian König <christian.koenig@amd.com> wrote...
>> On 11/23/26 17:57, Jason Gunthorpe wrote:
>>> On Mon, Nov 23, 2026 at 02:36:46PM +0100, Christian König wrote:
>>>> On 11/20/26 06:55, Alistair Popple wrote:
>>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>>>
>>>>> The SGT (Scatter Gather Table) DMA mapping type represents the existing
>>>>> sg_table/scatterlist based DMA mapping. For now it continues to use a
>>>>> sg_table for map/unmap, but this will allow a future patch series to
>>>>> convert to using a different data structure for importers without having
>>>>> to convert all at once.
>>>>
>>>> I strongly think we shouldn't have an SGT mapping type in the new DMA-buf mapping API.
>>>>
>>>> Instead we should have something like either an array or an xarray
>>>> of DMA addresses.
>>>
>>> My plan was always to get there, but I don't think it is reasonable to
>>> start there? There are too many places all over the place that are
>>> just hardwired to do SGT right now.
> 
> Right. There are around 70 drivers upstream that make use of the sg_table handed
> down via a dma-buf import, so I don't think it's tractable to convert them all
> in one go. So obviously we will need some way of phasing this in to give time
> for each driver change to be implemented, reviewed, etc.

My suggestion is not to convert all drivers in one go, but rather to come up with some sane representation of the DMA addresses instead of using an SGT in the new interface.

> Obviously some of those will share a common structure/helper and conversions
> will be similar, so that is an over-estimate. But based on an initial poke
> around there are plenty of drivers that bake the sg_table more deeply into their
> data structures.
> 
>>> Part of the design of this series was to allow the conversion away
>>> from SGT to be done incrementally without breaking compatibility.
>>
>> Do you know the joke from the hitchhikers guide to the galaxy where the dolphins are happy for exactly the same reasons?
>>
>> I'm pushing against this plan for exactly the same reason because I think it will make the conversation away from SGT even more problematic than it already is.
>>
>>> So it is effectively this:
>>>
>>>> The framework should then either connect the SGT directly if both
>>>> importer and export are using the "classic" interface 
>>
>> Yeah but that should not be a separate mapping type, it's rather that we just convert back and forth from DMA addresses to SGT for compatibility reasons.
> 
> Right, I think this is actually fairly close to my plan, which is to provide a type
> for each address class an exporter can produce - either a CPU physical address
> or some device context + P2P/MMIO address but in future could be some other
> interconnect type.
> 
> The core then negotiates compatible types and adds converters between them,

I have strong objections to that plan and would potentially NAK it.

DMA-buf should *NEVER* accept CPU physical addresses nor provide conversion between different address types.

Keep in mind that DMA-buf is solely a container for DMA addresses, nothing else and it should not provide any mapping functionality whatsoever.

> and having SGT as a type is what allows that. It only exists for unconverted
> exporters and importers and eventually goes away once everything is converted.
> The idea being we don't have to convert everything all at once, whilst also being
> able to add support for different interconnect types. Are you ok with the SGT
> type if it is just transitional?

Not really, it just complicate things.

What we should do with the mapping interface is to add the information in which domain the DMA addresses are to be used.

The conversion between SGT and DMA address array is an exception we can make to aid transition between the old and the new interface, but that is basically a 1 to 1 copy between different data structures.

> As discussed a bit previously types also add enforcement of the rules around when
> the exporter type/location can change.
> 
> I do have most of this coded up, so can post a mega series of all patches if
> it's helpful to see the overall direction in code form. I didn't do that because
> this conversion of exporters to not return sg_tables makes it quite a large
> patch series, so I was going to post them as separate RFCs building on top of
> this. Not sure if you have a preference there?

I think we should have the core interface plus some test cases and at least one driver converted over as example of how the new interface would be used.

>>> And this:
>>>
>>>> or convert
>>>> from DMA-addr array to SGT and back if either of them are using this
>>>> new interface.
>>>look like 
>>> Is something I imagined as a followup series.
>>>
>>> As this is actually quite complicated and needs discussion exactly
>>> what it will look like.
>>
>> Actually that is the easy step I think because quite a lot of drivers already convert the SGT to a DMA addr array outside of the DMA-buf framework anyway.
>>
>> The more complicated one is then starting to come up with more bus types and doing optimization work.
> 
> Individually the actual data structure conversion isn't that hard, but there's
> a lot of them and the mapping types allow you to do them incrementally without
> breaking some unconverted importer importing from a converted exporter.

Breaking classic users is actually completely intentional because we most likely still have people abusing the struct page inside the SGT.

And those will need to be converted over to be using pure DMA addresses similar to how MSM has switched over recently.

So the whole idea is when you have classic to classic interface pass along the SGT between exporter and importer. Then move as much as possible drivers over to the new interface and start identifying where and why some drivers have problems.

Regards,
Christian.

> 
> That is also why I think adding the types now rather than later is reasonable.
> The rules for when an exporter may change type or placement are what most of the
> previous review discussion has been about, and I didn't want to drop them.
> 
> Thanks for looking.
> 
>  - Alistair
> 
>> Christian.
>>
>>>
>>> Jason
>>

