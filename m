Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795605574;
	b=HGq1mdaqbNMDWkvOqj+dc4Kw5ck3yRM3NzUD5GmBYsOGcyHIs6xKK9yhaB7X7JvmbaPY
	 j60Jqmc400W3lwbFJi/CSD6nZy4npigFJsy1s0gYpUn2TAVUVl7fwGsL+sbQ60VfAXXmO
	 YtHgvoWyCLZemPpOL6zsoWhqb5RtOFxMZ5n20jOk+nOmH7hoglTaFF4PQHCFBveUqJQK/
	 YfxwDxtrdGoPtrGUO9t6QGB6Hr0erUA5xY7gnc6mKpG3AtiugKcatCKaZ6m+LTiHF6u8a
	 Dk+tAaf2MN9BupNq27m8vJTm76W2iwdArQOn/udW2bcqBRA6wtPFZh8uptkBMYf2FgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605574;
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
	bh=EMYXFK4E9UiDjmRTN056wP6mFQKcBip6wGIq+gc3dZ8=;
	b=FtcJt3MbFluexQnplRvL2e1KYGuwjQ3IiJ2E2MnACDhdbgKpOaF542DyJZpztRPbCIsG
	 t8aXQCQG71hf1Wcw4veWu7+8PzvIIIBWgAFmMfBupQCU07Ttq9G28DktSf6Fm3Y8tHFmx
	 7Q0lwh1BgeGDbtHo7d1qi8RwaBo77IVZNKsu7uFZOijBUR0Qh66SiWoxku30EYXflXrZg
	 6V+sbeqiMYUwTVAOVHDc/be4DLm92P6lYcG7oM1GFWzq/lrF4RUuI8Rv8z92+xLATaRq+
	 DIraiiskBZsFbwA/vbYb/LQcXsnHTCsTGKW30edDK3k1UuKobeOtPVSksyi6BtjXMLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EveQdXXe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.20
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C88606A32A;
	Wed, 25 Nov 2026 11:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70C88606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=EveQdXXe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icdmdKPWDb+4QCKRrGjdU9GWmoldOsSThiw7615IyV1Gv781pc44WOvjVR353OMBJQ05UPjnFS7ah8xKDBl8dWutYNf17selyTXtYpaVFjbxukhRY9HmQGIolJtUKWIiHcq023zkIygDBP83nmtIu328L44/83uUkSir63JiVqZHbmjkHNYyfB/afgqiJj6EJaaNgWzPIKqTN5NSlD0e1Hm3Bp4m/b7DF90fDpPUsmaJQiXLcPEhM2X51bwHx2hrOgbjtBIIk0bpUcBY8rh+61PP2FcC/YosnJ/PjSbJ+PuyKCyxe3/S0HuwqMkOS+xLlSidN6QOXoyUs1jyUb4vyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMYXFK4E9UiDjmRTN056wP6mFQKcBip6wGIq+gc3dZ8=;
 b=b3F1yqdcV/hMdmeRgmx4ePWKQqsQtcQWzpuKBeQCf81+R+LRlv871nIoUdWflR9W1t3P/+xyfXt77JDL2CNJEG4t8zlie5aofPmIyy4Pe86R5ci1rTor2eL6HdazZmDmLf+Eu3aPpDvaabq9If7Uqv41Jlv2AszoJsIbUjLalGGE86t87mjk4XlMD3CMsdO4dlu/nHL6YDmtptwMaLsgqpMWQs9sVIp5PkeVxh0KVm8cpFwMLjlwadNpgOYu/7/AkmBr3/OYde8WHhonzRFYADzVs0lzEUfjlEGgNysv6tA5Q54wHtvcnpAdSDOoj97U/z+SKqvcjvQ5Qm2VaHryEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMYXFK4E9UiDjmRTN056wP6mFQKcBip6wGIq+gc3dZ8=;
 b=EveQdXXekTA4HlTNvlqeNdX2RQD3dOhhixP2voO3TWhfb5tUT7W6La770Ut7tcWpmqNOEvs3Yzs5IF6bDzJ+hR0tHHHK2yL4BwfQRi6MejNaquBPW7llzZ+YqEQ4bZHTSaECiKhRLO/5DsdzFcgPbK7mWsmHs0g6C99FDWBfunU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LV3PR12MB9166.namprd12.prod.outlook.com (2603:10b6:408:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 11:19:29 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 11:19:29 +0000
Message-ID: <fb9a6b12-c134-4e40-86a5-dbcb59c0b91b@amd.com>
Date: Wed, 25 Nov 2026 12:19:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
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
 <7a5a2d3a-e42e-4dc0-8d22-8dd1bd249501@amd.com>
 <20261124194618.GC114530@ziepe.ca> <awZ_Os1pXelOGaFP@nvdebian.thelocal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <awZ_Os1pXelOGaFP@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::26) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LV3PR12MB9166:EE_
X-MS-Office365-Filtering-Correlation-Id: 943d2c3a-1b56-4791-45b1-08df4ae5f8c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|4143699003|6133799003|22082099003|18002099003|10067099003|56012099006|11063799006|261102123227099003|261102130727099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	EoqLlE5+BzmwXgnLTN7ajf6JsXy5Jo4+6ZHP7w16zOOLjD+VhAZcJ5yHG/4rLbxJdgENQUcRhfBGxpbuD00YRy/PrYdMJIKwLPBu2sYSY+Inmuwn12Hx4oezY1VewJLOvsOdFg1C39UgKly8j4bjiOJDIh2iSKFqfWMZJSRlKL+WmBd0asWq5CVAtzi2FVBXEPRTL352de5sD3SVCXlkzes3zzhyBDlJtzQc8a6YosaJEOWG+6z7AeIOX8d5wtQR1ntxC3xEh4priND0VdreKiBK6n4BhSVL+2aqzj4cEV9YKJz/p8tapelT4gwYWXREJmc3wQ5LSdEj2f6rbUMIvsygyxpwwpEzv5WaX4ul5iREXbM9qgPtEl9YuVEf6qjsPGSLUmMny11m/vnx1Pc5VL01w1AJRB3RkwHqaOaSCHpABC42dyEg1tr6pyo+PjdOS1kgWg5sYjvy4sQfJlZ4Sr8vSfIQgT1+zYE1rRNOooFZzCb+o8HZKDT/PVOGA0oC/giRrGmpQJaq+tPL/VBc1h96hy4lzcOTZS/GOZT1QtiRvt1UPsBjKr2qxPAgeV5wuaoHKMDo06FSEgGPAXZV0t5dSUjlWaZ51iD3KjkSCuurh63Xkxt8q/dhiDmEoRJbKasQ5RX/bp/UuD8k/JRy4vo7f1FEJ4/rtFQYSHRglA4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(4143699003)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(261102123227099003)(261102130727099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGpad0w3MmM4UU9HZjhmV3RvN0Nvejl0Sys5SHhqekEraC9TQnU4L29XSzMz?=
 =?utf-8?B?ZndiQWJadVVTVXh1Sk43bm9BSlBmY0hxbHlmeENyS2xoamJVS1dDRU1oSncz?=
 =?utf-8?B?YnhicjNLUHVFZEZkdWt0Q0lxSWlkUDVaRU9tSExaS2l6YXhuQzYwRys5OW0y?=
 =?utf-8?B?cWE4WUpJM202aFdlRGRsUnM4dDVrTVRXVGZKUFpIZWFleUtRZnozNnFnNWZs?=
 =?utf-8?B?MFR2OEZwRTZaZjlkQjNVT0hNZ3RGRnBQOHFLS2pXTVNWTFVOamZvZk5pWEZt?=
 =?utf-8?B?Zm40bGp5NVVzM3oxMUpyazRwODJKcnJFTHlNVGllMlVBWkp5cjBXOHZFVnlo?=
 =?utf-8?B?RVFXRlA4cENVWW0zS0hrM2RmYTNNM0FLUStxYUVkNkVubU1TdVBZQ3R1ZGJ3?=
 =?utf-8?B?dFo0K0lUYnRnZVpBMkF4dzBkcE1jM0xxNlBoQlZ2bUxOT0N6TzRMRjJRNG41?=
 =?utf-8?B?NVhkTUNsWUtsYTRZdWtvVVpEOUFxcExjVjh2SnNMclBGUXhtdU1hK3ZrbXZK?=
 =?utf-8?B?eWtnTjlpZGp1MHgvNkNCbWRydjRIVmlMRjRVV2dDL1o1MVNzbWFkK0dFOGZv?=
 =?utf-8?B?c0lUVGpWZlZCTzBCRTREMXhNZDZHS1NzZkQ0a0lXdmZpb2FrT2p2cUxHYkF2?=
 =?utf-8?B?UlZubkNLc1Zvdm93bXpjUWU5bWw1Q3hGQzU4V2xTOEM4OVB5MzdOZkhhQkFE?=
 =?utf-8?B?S3VRVzhXN2FZT1luOGh2UWlXZm04d2U1MXhqbFp2cmFBQ2hsczY3TTJoUXNs?=
 =?utf-8?B?YWJmaVJYSkNPRnNZckZDeFlHRkNKWXhkWnYrMXArSDArc3FPb3NrcHJjRGox?=
 =?utf-8?B?NnNJbmNGZGYyM2FnYVJJdlQyWTEwcXo1WkxmeGFlU3dOYnJVTWlDczJldklW?=
 =?utf-8?B?dWFKNWtLTDV0dGMxRkRoVms4cndyY244MU5QWGp3ZUYzcXNwYkRULzZFemRW?=
 =?utf-8?B?RVRFZVFpTEV4eUlmR3FkWklTTjMvbnhmVUlDVW4xaXdObDJLOXlWUTR2akVB?=
 =?utf-8?B?MWo3YUtZa2lBb1JmRmdxd01ySHpDZnVlQktmOGc4QWxiZWlIMHl1V0ZCRjhI?=
 =?utf-8?B?VXFJZXBVRktCRGN4UzFkVnRycW40VWtIV1ZzS09hbjdMNkdYdlRWd1Roanli?=
 =?utf-8?B?STRXbDRMc1VpNDV3aXk1cXE3Tktxd3VLU3hPVzdtS3AzUHNuY1RWanBTakhH?=
 =?utf-8?B?c01CQmM1YngzeW45WGgyNld2d2F5SlAwRzdsKzFIdGlCYnNsdUhRdGMyRjE4?=
 =?utf-8?B?U0VRWGZUZ0ZxY1hyMnJNZ3BDRkQvMlc3Y1ROU24vUUdRYW5FSFJacmZla1hK?=
 =?utf-8?B?Wmw4bVZ0eEtDamMycmplQWs1anYwcmcxVEdiZjFwSGRYNGhZM2czeW9GWWdS?=
 =?utf-8?B?d2NXVnY0VXUvbVFoRmdSSHFjUTZ0RGtpUGdZWVN0S3ozWW9rY1BoM09IR1l6?=
 =?utf-8?B?R3ltd2tOQTM3OVI4QUgyNG5GWTg1S05oSnZIcFZTMmtFRGlLWEhwY1UvUnpG?=
 =?utf-8?B?LzZXSzdWRmkyYjhkKzhMNG0zTTRMUjczeUhwcEI4enFCZE0zUytOZC9CV3ZF?=
 =?utf-8?B?U1VWci9leDc4b3ZURXpYMm0vc01sOVJqL3lYb0V6YlRpMDBWZUZpTGNjY040?=
 =?utf-8?B?dkg4bjlWUzdjNUZQU2pyVUJHSm9wWXh0ai9MTWU4dEM0bXVFd09idnJFWVo3?=
 =?utf-8?B?a0dtRlhtNU0xTWs0Tmk1Qklka3F0c2trSmNjVjVLWU1SM3RpMW9NTjdoR2RP?=
 =?utf-8?B?NkpsdzNHZnlxdUt4cVVvQlI4dkJ5bVNpY0R6Zjk2VFVqLzFabFViek9uemlv?=
 =?utf-8?B?TFY3UkR4K2dGWUZtVkpJTUtsdVlTa3o2LythVGFMVDc2Vi9odDllaWthb0JJ?=
 =?utf-8?B?eVQvOGdvamgrb1ZzSHhUU3ZQd3hvaUxIamZKMkhZM0ZqeWZYNkhpZThuUlZu?=
 =?utf-8?B?OHdpRG80WXRmRWRCMk1uWURCaDJTR2RkVWgxWlRaWWVEOGlnMkJFVXVtbFQ2?=
 =?utf-8?B?NHZSSURpR2sxelFxc2NDeFFGbTlZRXBQRXFTakl1b21zQjNnMzZ3dVZtNDV3?=
 =?utf-8?B?T1p6ZDlmelY4S3NMNVNtTWVwRXBsaFBIazhOS3ZOQk8vV1NpV3YxTFZ5WjVa?=
 =?utf-8?B?RFhOL2I0Sjk3LzF5dkJPZXRob3NmZExJOE9mSEhVUEVXUjd3Q0JTcGE2V09I?=
 =?utf-8?B?VkhDeG5LU2lvRGQ1MzBKL3VFNDljdGZKS2E2RXNPaEJXZmhGanNtRGVsZW05?=
 =?utf-8?B?TGpBUk50YVU3VEp5emg2Mkw1WXVPZzFnVkxJRzNSdXNiUEtNTndtbEgxUmdO?=
 =?utf-8?Q?YlOPwqY3oZZvoEPuG9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 943d2c3a-1b56-4791-45b1-08df4ae5f8c8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:19:29.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBUPN/GqxGJfSkQzQJO6/EdpN2flA5Lmw2GAtTD4ZWj0J5PudNB6wW/RbvhAcjcC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9166

On 11/25/26 08:18, Alistair Popple wrote:
> On 2026-11-25 at 06:46 +1100, Jason Gunthorpe <jgg@ziepe.ca> wrote...
>> On Tue, Nov 24, 2026 at 05:02:31PM +0100, Christian König wrote:
>>> The whole conversion from phys_vec to DMA addresses is something
>>> some API should provide based on the data the exporter/importer have
>>> negotiated (e.g. p2pdma_provider for example).
>>
>> Yeah, probably, and this is exactly why I think it will take some
>> time. Building a new something in lib/ like this is not a
>> straightforward task.
>>
>> But also, this:
>>
>>>> You need to negotiate the actual C data types too, especially if you
>>>> want to do that nasty idea where dmabuf populates an iommu domain.
>>>
>>> Yeah agree as well, but to be honest that task is negligible. We
>>> first need to figure out where to put the code.
>>
>> Means you need to get the phys_addr_t into the dma-buf code so it can
>> do this conversion.
> 
> We all agreed that open-coding DMA mapping of buffers in every exporter is
> something we don't want to do. The disagreement now seems to be where the code
> converting between physical locations provided by an exporter to DMA addresses
> usable by an importer lives.

Yes, exactly that.

>> I'm still absolutely NAKity against allowing any DRM driver visibility
>> to an importer's iommu_domain if we do this hack.
>>
>> I don't see how to meet all these concerns without making dma-buf into
>> a "converter" framework...
> 
> Right, something has to do the conversion and we've agreed that shouldn't be
> in either the exporters or the importers. The main objection seems to be having
> dma-buf do that, and instead having some DMA/library code to do it.

Right.

DMA-buf is the high level API/uAPI importers and exporters talk to interchange information how to access the buffer, handle locking, handle lifetime, handle a generic driver independent uAPI....

The low level API which talks for example to the IOMMU driver for creating the information how to access the buffer is simply not the task at hand for that framework. The stuff we already handle is more than complicated enough.

> If I drop the type/placement negotiation for now and focus on SGT removal I can
> simplify things a lot. Plan would be something like:
> 
> 1) Introduce a new C data type (dma_phys_list?) for exporters to pass physical
>    location info and context for mapping.

Something like this maybe?

struct {
	u32	mapping_type;
	u32	num_entries;
	union {
		dma_addr_t	*dma_addr;
		u64		*generic_64bit_addr;
		...
	};
}
....
	

> 2) Introduce two new dma_buf_ops - map_dma_phys_list() and unmap_dma_phys_list()
>    - which are replacements for {un}map_dma_buf that converted exporters use to
>    return a dma_phys_list instead of returning a sg_table.
> 
> 3) Move dma_buf_phys_vec_to_sgt() somewhere other than drivers/dma-buf and
>    rename it dma_phys_list_to_sgt().
> 
> 4) Update dma_buf_{un}map_sgt() to call the new map_dma_phys_list() ops and
>    dma_phys_list_to_sgt() to create an sg_table for unconverted importers
>    importing from a converted exporter.
> 
> 5) Add dma_buf_iommu_map() taking a IOMMU domain/iova/offset/size to be called
>    from iommufd for mapping an attachment into an IOMMU domain.

I think a whole bunch of other drivers would be really happy to use that interface as well, yes.

> 
> 6) Add a new C data type (dma_map_list?) containing DMA address regions
>    an importer should program HW with and new dma-buf functions to replace
>    dma_buf_{un}map_sgt().
> 
> Names are really just placeholders, so easily changed if you don't like them.
> Let me know what you think, thanks.

That totally sounds like a plan to me.

Regards,
Christian.

> 
> Regards,
> 
> Alistair

