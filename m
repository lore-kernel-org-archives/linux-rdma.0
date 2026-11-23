Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795459086;
	b=N3VQGz6mpJDT+MQafSiHSVdGEI39inzeyBgOcUx6Q64hZQLcVqgV0fbJYx0lUoE00JN7
	 P+Ljm+EnFBD2fLg8ha2Pb8USBNl62HxNlu6JnVKdVZ4jxXuBil8XHrwUU+zYiw4LprCA/
	 VXnUPb7X8F4YWvSIpAn+j4wRYtbsbp37B8azs44VufFkSyd5A7Of2oc6ihFifyPB+a88H
	 Sda7HWmit874LDQO6Ao4AXiM9zw9u+xD3ehktK3NAUzWO6I5R1bdpv9I9cZlO21envgHQ
	 V51Eo+WmxG1Qcx7eRN85vtdatJYVVApzml6E07Sdnd4UIWKp5vrB9YM6UYzXkIEgdkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459086;
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
	bh=F29Qo893FtKyDmIuT7CvyB1/BdWiWvBPBsRyqgUt/iU=;
	b=tlVtI2jIFpJLN276dW0P2EooO/FgDtqbnYfYGPSecF6am2wGa//mIB5LrgzZTuzWsWSc
	 nDrc2/FeCcsuld6m8JXX99A93DtRueEkb0bgFoFPXY9cpY6b+KlMWVOi5NHU6r6coNLkA
	 bv0N53ibcLo3KY1Pm/JoZvIyi1q6kT1f+XhKfL82/UsAsRijvX9u8ZLs7Rm4UIrfrl5ok
	 WYV0+chOYz8Q3UnlhJe0Nl3s86GEETzoXYSZw0//LL1Hjl/GKdQC+aXhWFG8N6NG/lJ5Q
	 pFjsZa1GqNohrfUE3iXMGE8yVSsYEHs1pIevj/2KkmTNdIafU1AsOGwjuTvbWdRirBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="5ZAPUyK/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.59
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268B606A31A;
	Mon, 23 Nov 2026 18:38:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5268B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5ZAPUyK/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRdHPV4A4wqlSUOGRTqAeQJvSlZnC2a8r4RA/QkJ6v/PSTS8giOMozXb4ijkxt4f+AwfmG9G4vH/NY7I7KUkMyDCHwx8gWEeYOtRZMzmj4Vr+urllyt6QSDXYfqkye+nQfwHLWNFUzZXJYsGjQfR3OEaM84QLu+nJXJ7SJuCjaNghvEWQs/RRutV81+GEJh0lKw6qAy4D8a+wshmPCHFAva+30s0X/DRjkZaKSX+hSXtVFjJqj0gvVRGUAxA6iv0N44oNW9n1BSjZa35b09VT9Rp9fqzMBTILgyuNr/fMlXZT1iXrfMeKOoEBYIX7QOo6wRVKa8Ke2ElD8wzbDL32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F29Qo893FtKyDmIuT7CvyB1/BdWiWvBPBsRyqgUt/iU=;
 b=Ad1b+1bzT/Gkc+aNgIyhq+SRZ/U8UtS1pmAbk9L+hMSwaPDTdKVRBAgeO/IEFyDP2K0iMv3QeLRC1cfPaBdWjOXLP7vd8HSAis8wsQesetwljE1v1M1kUhrviXa53I5K0Sqy24FxUozE/LnuQtvO8/fIhn9MTrEFjc1XowbvlNaxW4g1GT++gfPrbR71Dmpyu6po9unt2OxOIzLxklL/dho8it3XGy4qCqOHxgUgF5LRXdBIUuuk9KfY0p83vCppi+1TP+Z1giQBKpkZZ4ILraj24vvbwAoUudjN0cYTMzMjzdk13dpJsKq3qodCscokqxurJHHeOdiKj4eHT/kRgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F29Qo893FtKyDmIuT7CvyB1/BdWiWvBPBsRyqgUt/iU=;
 b=5ZAPUyK/1vN+o/VvC1puW6AINvYwSwfuNtqn2+jbWt3eBBT5hkkC88GMx0VZA+kPeQ0rSP/R2gfBQ5EhONxpYojsLPkBlKEtOLRS0BqqQbCUM7cJW5zNr5DKqYh4lRX9dxVv8raY0RTWfb3BNKr/JhNyQGbqLfydqA0+S9OMJiE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LVUPR12MB999135.namprd12.prod.outlook.com (2603:10b6:408:3a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 18:37:58 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 18:37:57 +0000
Message-ID: <7ac7edd0-5c38-440a-b26a-21bcbb6f4702@amd.com>
Date: Mon, 23 Nov 2026 19:37:41 +0100
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261123165716.GM179082@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::17) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LVUPR12MB999135:EE_
X-MS-Office365-Filtering-Correlation-Id: 88af90bb-eecf-4238-7d0f-08df4990e4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|261102123227099003|261026121527099003|261026140227099003|261022115727099003|261022105027099003|261028144727099003|261021121427099003|261102130727099003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Fj/v9ZPNJ54MJV/cx5rPqLyzL35yS+KBkwP95H3tUfGq8Bc7J30c38RRHNaidjlSsBE6T+iKJGZ6EOcKQ/Znq/JWELtBOl4ZXhTme43r84PqQg7M2byM2UULt+lgkNeVf0jpNbHn8ZEk5mCgorO7ULLQmdJgOz3oWf+43ucCCnU2mygqHFDOA8XcU/H6F7SXqPxCBzAAecmo4uFfmfOKmsMVYl+7FHTQh5L7o9gC/z/+wDLsEqY6klqOgrj+eMMFcOVjvVzIspsQjeX2vkEO7DT7z35C1i32rKLhEmEQVW0CooV/80Y8rh20Q+ML28mJ3rkCaGlaPwXw30pxJbigBg8MyPZzQtNVSBKKqhma4slUqlCP9RP+BQQED4FGD2EMx68wWs4KJ2Fb/rruQm4AaH0SEcQ8JfEd5a26ukiAw1BHt+XF5Pv/uRre2K0GB9RstU98wt1qj5hc1SIzNRPQBwSIbFF5xj275RWVfx3RAilUygNLh09XIH0bzUxNg8xLqQIuARCIZtoWT52uo/+fpmHjvS9xIfD9j3bozDBDCTuqrodiuWi671c41+wp09R1SMFwlMDa+H1/KOEZgTqVjXyQmav36g9zhYn7I9n67BBWbf75YyrjULAJAySo8YRTajm9l9WGdhfkY7KG293PDU/VFy/Hnp29H2fBMg34SqQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(261102123227099003)(261026121527099003)(261026140227099003)(261022115727099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102130727099003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXVpWFlXT2ZHSkRPMHgxL3JORmUvaDBtTVBEQlI2cDZlcEk1VHRISFZjS2N3?=
 =?utf-8?B?V3l3di9aUUw3Y1RKdW1RaW92U05yUEV4T0o3YnJIV0ZBUjBCS281WHFnM1E0?=
 =?utf-8?B?MTc2bUdBb3ZjdHdGVkVhM3J4VEdWaTM0TXA5VDNhNW1sbWwvWUtEa1pvS0xh?=
 =?utf-8?B?NnZDUGh3Ykh5Q1g5MUtTdjkzZ2dkbUJsL1BiVnlUV1NNSmxFZXVERTJrdmNk?=
 =?utf-8?B?dGtyTTZ4aWFvdXZIUml4d3lyV0paNXE2VnhlcnFtdDAyMUlUY215UHRJYmgr?=
 =?utf-8?B?L3h0NlpicFVXb2lnNnA1WWVMNk1QbjdEV21OMjZ4blpRSENKOEdPelNpU3JW?=
 =?utf-8?B?VmozbHVYZExSM3VhZHhUS1gydnZESjJuV3VEdEJlbERTNTE2MUM5b1RrdVh6?=
 =?utf-8?B?MStLZzBLTUNRY2c5RXlLQnhUQkpPNmwzWnl5V3pPbkpIaC94ZHVURnU5RkVG?=
 =?utf-8?B?VEJOVjN6b0xRS2ZLdnptWURJNmd5WjR2a3E2YlhtS3R4RDNLcFJSZjZ6MEdi?=
 =?utf-8?B?U0RuMWxCSFR6UER6SUNDS0pFa3BVK1VJbTk3MkxYNlV1NW45NjZUalBGcFdw?=
 =?utf-8?B?Si9oem5wcCtiVnhQSHdBVkwwY2F5bWtCV2VIcU9yMGFWeDRJQUtFNWxTekFO?=
 =?utf-8?B?ZHVkdC9udHFMaHJxVVR1SDB0WklYTWFVU0hLV210OC8xUEZLT2xxWHcyS2gx?=
 =?utf-8?B?STJIb21kK0NCS3RYUU4xb2VKeThWcFFDZnd6MTRrRTlqd0NCU3BEWDVTQlFi?=
 =?utf-8?B?eUZ1VWV6U2lvRTl3QnlEeGFjcFg0YnNEa2lzZnJVMjVJVHpHUkRmcXpSbmJH?=
 =?utf-8?B?dUkyblN1NHQ1cDZISytUbkxzb1p3VlZCLzhlKzhPaXlMQm5zczNnMFlqT3FO?=
 =?utf-8?B?MHNGNTdROHNSUkN0ckF2N0pRRE5Sb3QyUzdVeko3TG9nL1ZuVFlNdERXTEo4?=
 =?utf-8?B?UDhuNFg1M2pzSHJqTXVYdlI0VWpmenhiZzFzR3llUzJOOVlLRnkyVzJEL0FT?=
 =?utf-8?B?SXM5ZzZYL0NjcmNxTWw1YXYrUDF0eUZxb1Y0L091SkxsUG5YeGc5YnlDTHlM?=
 =?utf-8?B?dC85MUc3dm9UZHNHd0Y0cGU1Q0NjWmNWMEJqZkF5RXI5MGp1VWVQTzZpeG1L?=
 =?utf-8?B?MW15ZmlrVXlTUXB2aXNvUkljMkJtaGFpNExldHNUSS9sOXVNY0dGTEljdm5a?=
 =?utf-8?B?RFlYbGYzM0Z0d3RheTVoZzNHdXM3QXE5OVFvWFU2dzdIem1WR1hTS0xLQllI?=
 =?utf-8?B?OFhEbzNIcjM0cnJuVlZIRUlkb3pEazJ5SlVIaDgrK2JkNG5FcWVqb2xYaStX?=
 =?utf-8?B?bVgzVE1jU0lNZ1NkOWJXVkFmVlcxTTA1R25kWmh4dUVsNHRsN1FBRVRnNGlJ?=
 =?utf-8?B?L3hFanAvMHR0L3pnM2FVRWlmQTljWjRVamNKZTA1amtHd2hDcmR4aE4zNW1r?=
 =?utf-8?B?Zjh4R2NlcjRSbU11Y0pzR1BJMkRkTDRSbUFlQmtNOVAxU252OTU0RCtDbzdo?=
 =?utf-8?B?M2s5cTBaOUZnZFdSSVlXYTBCMnhjTTR6Y2ZodHlqVnd6TXQzT2ZEU3cwUlBt?=
 =?utf-8?B?SlV2c1hYbi9qWjd5TTNjVWtCZGJSTVh1RlJNWkgvV2pGMWdUc3dvdVRmZGEv?=
 =?utf-8?B?Z3dBNHZKRHBHNGVaUXZ5TlN0ZUZjamFIdXRQRjBzcUJxWlZjbURDdUxiMkRZ?=
 =?utf-8?B?dC9iQlo5N2xvdDR6WFo3NUVvOE5tbVpaMDZNRlJEWmVnTlh6SzhsVUtjZzU2?=
 =?utf-8?B?dkc2dnBSWGYrNTBLWEd0aEtzMzY0bWNBZUc3c2locjRESTJ6NzBmdTJUN2dN?=
 =?utf-8?B?ajl3d1h3Unc1aWFaUCtkM3REajFadzMxV2hWNWoweWpiM0pXUjFCd0hBYXNN?=
 =?utf-8?B?NG93aU5XaW45M0dXdWd6RFUwNmVvL1VuNFRhWkx5Y3l0d0ppS3AzbVJ1cFN3?=
 =?utf-8?B?V3phUGdER3l5ZGoyTm1FMi8wY3pxQmJlMGE5NjFVd1hTS1RBa3VUUEZ4Zisz?=
 =?utf-8?B?TkJFZHN6UDBoMW51OXQ1aGEydXF2S2ozNFhLbFFJMUNSUUtpTk4wb2FBa0pk?=
 =?utf-8?B?QllWWGY3ajNtSEozY1MxMjJMeG5hb3dKSTFjTDQ0UlY1VHA5S3ptQTAxeWNp?=
 =?utf-8?B?U08rWHl3VjVKakdYVHdCLy9vb2pVYjVJZDFQM2V4SThmcE9nL0JGUjQwWkNO?=
 =?utf-8?B?ZlczamdLRlkydVE5eXptRWtUU0FGOHNqVkszQ3RNcTRIc0FNQ1JsUk03U1M3?=
 =?utf-8?B?SlpDM2x0NUp1ZjJUN2VOZ3ZpZHJEMlRkcUV6ZzNQVzlZQlpzd2NDdHhhcjhx?=
 =?utf-8?Q?5IHBA3FsFXORP37sOd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88af90bb-eecf-4238-7d0f-08df4990e4f4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 18:37:57.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSBnICMpkVc3iAF/ZD/kGUjqNO0rGHyyYIXh+aTcSW6DzYltTP1z0IA812/CnWxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999135

On 11/23/26 17:57, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 02:36:46PM +0100, Christian König wrote:
>> On 11/20/26 06:55, Alistair Popple wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> The SGT (Scatter Gather Table) DMA mapping type represents the existing
>>> sg_table/scatterlist based DMA mapping. For now it continues to use a
>>> sg_table for map/unmap, but this will allow a future patch series to
>>> convert to using a different data structure for importers without having
>>> to convert all at once.
>>
>> I strongly think we shouldn't have an SGT mapping type in the new DMA-buf mapping API.
>>
>> Instead we should have something like either an array or an xarray
>> of DMA addresses.
> 
> My plan was always to get there, but I don't think it is reasonable to
> start there? There are too many places all over the place that are
> just hardwired to do SGT right now.
> 

> Part of the design of this series was to allow the conversion away
> from SGT to be done incrementally without breaking compatibility.

Do you know the joke from the hitchhikers guide to the galaxy where the dolphins are happy for exactly the same reasons?

I'm pushing against this plan for exactly the same reason because I think it will make the conversation away from SGT even more problematic than it already is.

> So it is effectively this:
> 
>> The framework should then either connect the SGT directly if both
>> importer and export are using the "classic" interface 

Yeah but that should not be a separate mapping type, it's rather that we just convert back and forth from DMA addresses to SGT for compatibility reasons.

> And this:
> 
>> or convert
>> from DMA-addr array to SGT and back if either of them are using this
>> new interface.
> 
> Is something I imagined as a followup series.
> 
> As this is actually quite complicated and needs discussion exactly
> what it will look like.

Actually that is the easy step I think because quite a lot of drivers already convert the SGT to a DMA addr array outside of the DMA-buf framework anyway.

The more complicated one is then starting to come up with more bus types and doing optimization work.

Christian.

> 
> Jason

