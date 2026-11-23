Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795441037;
	b=n7KX+pRSqD+5GSoq3cRS+K/5v1zGBVrrvenZTq3xRs94VFav7P/Yz3RTNXpZt+BBHybT
	 soWc2cVtCQoDfqUldS6ZKoKtLI/SpKKflEGusF/j7f3xKiQUJKRXrVZPaEyel+Roduwx9
	 AuyRZvDTh/4BoQVGQ0XF9zCXOKN7A2FLcuxJTh2TTtF8UsoLR460kSOO56mGVmzX8KQOS
	 w3qkr/uE7DDZjasA0bNcv4mmHiqMSbqG0gx8CNdFnVow/EMYRGjBSJ0fNf5IXOnbr38Ed
	 UtjfRoM2EAlBJ0Fbzn32xosFO4sTUcQdmwQ2X/ORrdoNVeB4H50DXkVEMIk4YPipqyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441037;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
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
	bh=eyPtKhskFa/icuem1ux++Wq7s2QCd+GMBCUY+8HDaDE=;
	b=umgs9/RQGK1BA8u1DJgw3ShPkhSFkqAib+Upy7oyHf23aZl7wLE6GS8qXHBcLpk7Q3X+
	 oH8ZMB8PYKTpkh+ZXhvYduxll9QLCgxeEsb/XlS8oxPJ5bCpriLPPPAhK6zjcihDOW2IK
	 kg4LHESCEnB9Q+IK10cQtEzSmWdiE911FUagi6YROeelzTPfiBz0aJ4XBOjegSRv6tZNU
	 4hNTnqgVYVH2n+C7khV9waRrRIP+Eml1rXjI5hr/y+p8PvMZE4pdgLXzDUf2NL/SopJiY
	 UYG55Qexsj/bHdJGBuCutU5SD9gT+2vfQ22VD8me5qAweLbXNKiyYQUhB4f1oHgDTHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=d2nX1not;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.0
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010000.outbound.protection.outlook.com [52.101.201.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E418F606A334;
	Mon, 23 Nov 2026 13:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E418F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=d2nX1not
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUvXlZ3pigffe/yCsL0IMR+7cpgg57jnK8FHDc/IwgFAlQmcLIPIelDPr/1nfsaJMJ88DipBlcwNp6nDPFRTEq8nM6P6RnrCE2TBXtsGU8xhcHisDBt19AGz37uq+ehlqQS7XbN/sEIBF6MhE6HWVVxJsUdJ4SmAFJqeGGOkmNfpYhT2XGYEovbyH/zfzg3tnPfKonOpdaW8F+KzHtwFFk27bct1I2VTogZ849NCTGxEuOTyMPCNJCpivG21TGFHIp6QHmgIg6K6Tkb+erUnu5hxvrMbAtAO4bzPl9Yw0IIBUdAb9PcjQBL7D7IoLSWfSebsE/mCKMoaNlCXQ0xoNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyPtKhskFa/icuem1ux++Wq7s2QCd+GMBCUY+8HDaDE=;
 b=p5Kb2DvqRsaQB/aBhSuhMwwv4wlT/k7ofnTX7KzJw6qpkkMUHzATx1VZfjkW+kZbUXcJCoMDvpSwILIoOD84D18UNct0W3sEs6VGfd+rI/2MPAYLjJ05BQZ0c7bx6HCMVgi9v38zKqoSffwDCbuswnwTvqvxqCmjkV3t2I/NwRhYyM5QQT8m/704mSXSD2NFtYTRg0MiS19Udrk1BuQOJnLU2Re1GRYZurzWDEmKv0EKowvzExQ9MbHqmhEOr2zZ/objqVkaTfknpDL8RJFjQ7vcsov8c8gK2y6CCzvkh4fR5bTHyMGNFw3VpWUFRvBvkP544X6SIIDVtbD6PxMh8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyPtKhskFa/icuem1ux++Wq7s2QCd+GMBCUY+8HDaDE=;
 b=d2nX1not0TMhIYR2SvBqYM/Y1VsTcpTNIGy8Ju2DCwxkAAgSJ91AEB9TX3il31Dvbovrz6QJkaBatz4MvV5QS/AnE25Pmf0b2UpXapd26xVqZEwwWLr9wXGxmTBOAg//mG4vrBJiyeS75KSFOd1rRUb55Qw4LkvVGL0SP3pWszQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LVUPR12MB999161.namprd12.prod.outlook.com (2603:10b6:408:3a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 13:37:05 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 13:37:04 +0000
Message-ID: <ad46d60a-189d-4dd5-9ad8-ecfd3c90f9d9@amd.com>
Date: Mon, 23 Nov 2026 14:36:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
To: Alistair Popple <apopple@nvidia.com>,
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
 jhubbard@nvidia.com, chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
 <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::8) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LVUPR12MB999161:EE_
X-MS-Office365-Filtering-Correlation-Id: a68c3e62-35c2-4a9b-2ce4-08df4966dc8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|6133799003|18002099003|22082099003|261009223027099003|3023799007|261021123027099003|261021121427099003|921020|261022105027099003|261026140227099003|261026121527099003|261102123227099003|261022075727099003|261028144727099003|4143699003|56012099006|10067099003|261102130727099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	hy+QLPaneMahJe82ySyvex6Cum4r23RUc0X0yr0RPd2KdWu4ftL8CZ4EHY5nFUxXWEJ5NRtRk6mruYKLhSXfBy8FoCtmIRer5zuhIZLqmjd/FvUu+hNkl038QfZ6KZyYXiyqhdDjzf6JMMRpkGo4+PmaY657gLvwdhYax1TbXWPbKwRqcURnpQe2uRLl4TzmTam4zh87fzZVyzYg/rBswn9zJX9FPTBXx72KRZZCa+x6Vg+0lH19RsfqqVCI5SpPeRbi6vHd4xf7Xdv6FqUsD9irsw0NffylYdKnJhzE6YtuDLWnayPaJXF8jAO++57zfOQT6SS9YFzQhEcJvreb0XK4hDdWE5kAo2qFKYNh+HXlWWUgM5LDagGSaH7UmQsnr6bcjSI2iwXUM8EzbHnv4NwDqPhQ49HfqjaMFS8x6ijbYF3WpyCLD/IvC9Qd+lqrciOQZ1KzAFtHB1O8UgKokOz/a7RTwIaPOA0Yj9d0IZXr/C7+fGRrU2CDBlBe6/QpdzxZvxCuJOGNiLdfLVGXCEoJZ8Aa6oURPECrN9A+6sJUkwtifX5TdGvCJPFOvWT5V2Jn6q+kO7Zlwy0orUpCSlUuLUN4XYllL6RXR+CkGbZsTlgQnG3XdUlrhUw+SFgJYYv5Sh0L3Q6YS+mr/A8+e127wezs+S7ghC7HrdQ72jot51OayCmTp62nvd4mGyrXuwOkNfXiDiEvbXb3F2lWlw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(3023799007)(261021123027099003)(261021121427099003)(921020)(261022105027099003)(261026140227099003)(261026121527099003)(261102123227099003)(261022075727099003)(261028144727099003)(4143699003)(56012099006)(10067099003)(261102130727099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHRydTllbzl4MmU2Q0V0cVlHMmVQUENEeWFCeXFKYXoxdlhIWDNSZlBKOFZR?=
 =?utf-8?B?a2Fld29GTFByeC92bEFWWnRuaTFDTEZMR0Z1M0ZmZXc5TDE5TUNJR2lIYkw4?=
 =?utf-8?B?a09kb2F2ZThCaFRxOE9POTRqRHZuSnNrcFkvQ1pvcmNaYjN1NDJjbllEWllJ?=
 =?utf-8?B?STN5WHA2aEU3NmpmSjArQ1dyOXZPYXhpSitFTzQxWTNTd2FvbkJMZ3RFTE5C?=
 =?utf-8?B?TE1QaC9YT2lrT3lvUC85ZlBnQUZPTTI5U0dOTzdqNzYxMHVDOFdObVk5T3dJ?=
 =?utf-8?B?TE5UdmQzOEVLV3BFNThQMEFXWU9rRitpeUlSLzRBZWxFWkdHMk8zam9iT2ZW?=
 =?utf-8?B?VndLbWxOeWZDc3VTVmUyelVXVE5rNWFVUlpYZzRTOUxCWlFPUVBicmZleVBj?=
 =?utf-8?B?MkNZUmJvYldtbzBPeThNMVB1RWYzV3puclVwbDdRVFlGRDZSMk9rbWd4VE1O?=
 =?utf-8?B?TFVUY0JKdUpmVXBlK29YUytyczhsUzBaNjBwNU1CeWcyakE2clVvRkVCd0s4?=
 =?utf-8?B?SnhBTkg5cC9mKzQ0bGFvVThGZWN2dHF5bWJpMnpSR3gvS05GalJoajNNcDVL?=
 =?utf-8?B?djU4cWJUeVFjUmlDQVRXYTJvaEdqcW5xc2NDczFUdzlFOTUvRklLZjhuR0NF?=
 =?utf-8?B?cWc2Q1BLM0lIMWYrbVpteWEzOWo0eVlCd3JzaHBEWTRCTG9WRUh1RE1RckIy?=
 =?utf-8?B?QnFpS1crZk9HVmNqYzg4Mjc1MXNWUjFNdE55eXk0N293NFVzNklGQlpnUjBm?=
 =?utf-8?B?ME1ZbFFHb1AxSUhwaTZTTlFWblpOZnp0aUJTblBSeDhMUWsxWW90d3F4QUVW?=
 =?utf-8?B?NW8yM1BGaVUzbkhOd0FqaXV0Z1krWkJGeHZyZ2FHU1d3anRKN0VlYndnTkd1?=
 =?utf-8?B?Y0Y1SUxiejRwL1ZKR3F3czdKSmJYcmNHL05jaGpLSnZWMDFGOUpCdGg3M0V6?=
 =?utf-8?B?VnU0azRUQXRpYmxhOGZObFI2MGN4L1g4S1BNSHg5M2VEV3BQRzlOSmF0TlQ1?=
 =?utf-8?B?REt3M1hZR0Y1N2FIK1haMnFzd2lMYjJQd3J2Q2lrS2pKRUtDd1h1N0M4YlBs?=
 =?utf-8?B?QjFHVllxcmNNZWJkN2Z6RTlNeVUxd3NxcmM2VFVUK0hQTnM4MnZCMHlQdkta?=
 =?utf-8?B?VDFPSVNUeXkyZVRMUENLNEs1bXRCK2NJRmFQL2RXS0tBQkVSTGhhQkJzSnVF?=
 =?utf-8?B?cmxzYWozL3VTMi9KOWk0N2ZqbHNhV1pKWnM5aXVxSFE4djRaUXpzN2FoSWJC?=
 =?utf-8?B?RjZtQVdlS1FnQUxhWE1CRVpUM3ExQWFDaVFIMlF2WXgwM1IxempwY01oeWRR?=
 =?utf-8?B?ekFtYm56M2IzT1UrbTc2VVJIOFpvcUVOSDU2L09hbzAwYTVoKzRRdFdOMWZq?=
 =?utf-8?B?eTVFZ1JYM0R6azJmOTVDaEJsak1PdHdWRjVxQlA3WVF6M1d6eHhXODFnQUJ3?=
 =?utf-8?B?b1VzVm5LRW1lMzYvQTJwbDg4aGdVVlV3b1g1MzBIbCt4M0Jlakh1K0RDNVBP?=
 =?utf-8?B?eHF6azN5THpUU1NPWkJDRXJFaThJdGRSNGdUVE12V1lPaG11djdVVXljTkoy?=
 =?utf-8?B?Nmo4bHFwVUFkUHdiTjQ1NzJqWXVTWER2VXdyYTVXMng5b3ErTlluWElNSjBN?=
 =?utf-8?B?NG84RFBjdk9od012WFA3dEUwUVliUm9McmdPcnVHL1N2WVV6RklEMTZab0dC?=
 =?utf-8?B?cktzVDMvK1dwL1R0N3VBOEJYY1FDckVDNGtkcjVrckFJODdFOUFCMUxiSCtE?=
 =?utf-8?B?cUxKZXZQbHNKdVk4ejVQT2s3NTRKcEVMb2cvbmt5UWhJaytuVGg2U0lUb2ZF?=
 =?utf-8?B?MWV5NE9sS1daOUhWSTEzTVkvcitFTnZFaHQ1c2ZkMUpyRWhEWWRoT2FpRkFB?=
 =?utf-8?B?V3VkYldtbSt1WlYvNHJPNVVNL0lxcTNkZXJucDRKaFduSFBqdUMxaEZBR0NL?=
 =?utf-8?B?N0V4L3lMbkFSYmxybDlYc0plcml2YmNManBVckN0MHNsR3FXYVZqNG93MVMz?=
 =?utf-8?B?Z3JSSXh0bzRqYk5yc3VwcmZaK3ZpS1pKb2VRcGwzR1lUejhaZmZqY2E1Y2xS?=
 =?utf-8?B?Mm9lR1VLVTc5QkxlbnJZeUdQM3c4UmpVVmRDS1N1Si9IRjlEdmd2R0dNekpl?=
 =?utf-8?B?SjBmRU5vM0Z2dmE0Z1cvZjVkTVNrdmh1UmVDeXZjeCs5ckpMaFhXT0pubnpT?=
 =?utf-8?B?ajROQjhTQ1laU29nUE90OHppdzFRUlorM3dKVjhuckxCU01jN2IxS0F5OHpT?=
 =?utf-8?B?UUd0SXdrcHJpenNVcEFXWmE2VmZqdUdRbitlbnlqUGdUWGdGOUxYYTF0WVJj?=
 =?utf-8?Q?bKp+xCyMYotVbXKNju?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a68c3e62-35c2-4a9b-2ce4-08df4966dc8e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 13:37:04.7394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4CIqCMuPb7PKcNcuTpTIR8+Cv4zVuanBcFuEFikQ4EYsp2QDGoIGRv7bajsm5Vv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999161

On 11/20/26 06:55, Alistair Popple wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> The SGT (Scatter Gather Table) DMA mapping type represents the existing
> sg_table/scatterlist based DMA mapping. For now it continues to use a
> sg_table for map/unmap, but this will allow a future patch series to
> convert to using a different data structure for importers without having
> to convert all at once.

I strongly think we shouldn't have an SGT mapping type in the new DMA-buf mapping API.

Instead we should have something like either an array or an xarray of DMA addresses.

The framework should then either connect the SGT directly if both importer and export are using the "classic" interface or convert from DMA-addr array to SGT and back if either of them are using this new interface.

The next step should then probably be to switch over the DRM drivers to use this interface and exercise if everything still works fine.

That should be relatively straight forward because TTM drivers already use a DMA-addr array internally anyway (see function drm_prime_sg_to_dma_addr_array()).

I can also put somebody on that task should we agree that this is the way forward.

Regards,
Christian.

> 
> dma_buf_sgt_compat_match_mapping() is used during the conversion of
> exporters to transparently wrap an unaware exporter's sg_table. It is
> removed later in this series once all exporters have been converted.
> 
> A mapping is an object allocated by an exporter which embeds the generic
> struct dma_buf_mapping type header which core dma-buf code fills in. For
> the SGT type that is currently a struct dma_buf_sgt_mapping embedding a
> struct sg_table.
> 
> Importers continue to receive a struct sg_table from dma_buf_map_sgt()
> and are unaffected. A future series will convert the embedded sg_table
> into a list of DMA addresses more appropriate for importers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> Changes for v3:
> 
>  - PCIe P2P will be added as its own type in future, so dropped the P2P
>    flags from the SGT type.
>  - Exporters allocate and return struct dma_buf_sgt_mapping with the
>    sg_table embedded instead of a bare struct sg_table. This ensures
>    an unmap happens against the correct type once multiple mapping types
>    are possible.
> ---
>  drivers/dma-buf/dma-buf-mapping.c | 104 +++++++++++++++++++++++++++++
>  include/linux/dma-buf-mapping.h   | 135 ++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h           |   6 +-
>  3 files changed, 244 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> index d27f02610c2a..cc3d8d6fe009 100644
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -6,6 +6,7 @@
>  #include <linux/dma-buf-mapping.h>
>  #include <linux/dma-resv.h>
>  #include <linux/dma-buf.h>
> +#include <linux/seq_file.h>
>  #include <linux/overflow.h>
>  #include <linux/align.h>
>  
> @@ -322,3 +323,106 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
>  	return 0;
>  }
>  EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
> +
> +static void
> +dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
> +			 const struct dma_buf_mapping_match *exp,
> +			 const struct dma_buf_mapping_match *imp,
> +			 struct dma_buf_mapping_match *match)
> +{
> +	struct dma_buf_attachment *attach = args->attach;
> +
> +	*match = (struct dma_buf_mapping_match) {
> +		.type = &dma_buf_mapping_sgt_type,
> +		.exp_ops = exp->exp_ops,
> +		.sgt_data = {
> +			.importing_dma_device = args->dev,
> +		},
> +	};
> +
> +	/*
> +	 * Setup the SGT type variables stored in attach because importers and
> +	 * exporters that do not natively use mappings expect them to be there.
> +	 * When converting to use mappings users should use the match versions
> +	 * of these instead.
> +	 */
> +	attach->dev = args->dev;
> +}
> +
> +static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
> +				     struct dma_buf_attachment *attach)
> +{
> +	seq_printf(s, " %s", dev_name(dma_buf_sgt_dma_device(attach)));
> +}
> +
> +const struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
> +	.name = "DMA Mapped Scatter Gather Table",
> +	.finish_match = dma_buf_sgt_finish_match,
> +	.debugfs_dump = dma_buf_sgt_debugfs_dump,
> +};
> +EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
> +
> +/* An unaware exporter's sg_table presented as an SGT mapping */
> +struct dma_buf_sgt_compat_mapping {
> +	struct dma_buf_sgt_mapping mapping;
> +	struct sg_table *sgt;
> +};
> +
> +static struct dma_buf_sgt_mapping *
> +dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
> +			       enum dma_data_direction dir)
> +{
> +	struct dma_buf_sgt_compat_mapping *compat;
> +	struct sg_table *sgt;
> +
> +	sgt = attach->dmabuf->ops->map_dma_buf(attach, dir);
> +	if (!sgt)
> +		return ERR_PTR(-ENOMEM);
> +	if (IS_ERR(sgt))
> +		return ERR_CAST(sgt);
> +
> +	compat = kzalloc_obj(*compat);
> +	if (!compat) {
> +		attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* The exporter keeps its table; the mapping shares its entries */
> +	compat->sgt = sgt;
> +	compat->mapping.sgt = *sgt;
> +	return &compat->mapping;
> +}
> +
> +static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
> +					     struct dma_buf_sgt_mapping *mapping,
> +					     enum dma_data_direction dir)
> +{
> +	struct dma_buf_sgt_compat_mapping *compat =
> +		container_of(mapping, struct dma_buf_sgt_compat_mapping, mapping);
> +
> +	attach->dmabuf->ops->unmap_dma_buf(attach, compat->sgt, dir);
> +	kfree(compat);
> +}
> +
> +/* Route the classic map/unmap ops through the exp ops for old importers */
> +static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
> +	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
> +	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
> +};
> +
> +/*
> + * This entry is used for unaware exporters that do not support
> + * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
> + * type so aware importers can transparently work with unaware exporters. This
> + * does not require p2p because old exporters will check it through the
> + * attach->peer2peer mechanism.
> + */
> +static const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_matches[] = {
> +	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops),
> +};
> +
> +int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args)
> +{
> +	return dma_buf_match_mapping(args, dma_buf_sgt_exp_compat_matches,
> +				     ARRAY_SIZE(dma_buf_sgt_exp_compat_matches));
> +}
> diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
> index bb826bdc2911..8be03b4ba6cc 100644
> --- a/include/linux/dma-buf-mapping.h
> +++ b/include/linux/dma-buf-mapping.h
> @@ -84,6 +84,30 @@ struct dma_buf_mapping_type {
>  			     struct dma_buf_attachment *attach);
>  };
>  
> +/**
> + * struct dma_buf_mapping - header of a mapping made through an attachment
> + * @match: The match set entry the mapping was made with
> + *
> + * A mapping is an object allocated by whoever produces it, the exporter for
> + * the SGT type, embedding this header. The core fills the header in once the
> + * producer's map callback has returned and reads it to tear the mapping down.
> + */
> +struct dma_buf_mapping {
> +	const struct dma_buf_mapping_match *match;
> +};
> +
> +/**
> + * dma_buf_mapping_type_of - The type a mapping was made with
> + * @mapping: the mapping
> + *
> + * Returns: the type of the match set entry recorded in @mapping.
> + */
> +static inline const struct dma_buf_mapping_type *
> +dma_buf_mapping_type_of(const struct dma_buf_mapping *mapping)
> +{
> +	return mapping->match->type;
> +}
> +
>  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
>  					 struct p2pdma_provider *provider,
>  					 struct phys_vec *phys_vec,
> @@ -109,4 +133,115 @@ dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
>  	return &attach->matches[0];
>  }
>  
> +/*
> + * DMA Mapped Scatterlist Type
> + *
> + * When this type is matched the map/unmap functions are:
> + *
> + *  dma_buf_map_sgt()
> + *  dma_buf_unmap_sgt()
> + *
> + * The struct sg_table returned by those functions has only the DMA portions
> + * available. The caller must not try to use the struct page * information.
> + *
> + * importing_dma_device is the device passed to dma_buf_dynamic_attach(),
> + * recorded at match time, and is passed to the DMA API to provide the
> + * dma_addr_t's.
> + */
> +extern const struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
> +
> +/**
> + * struct dma_buf_sgt_mapping - A mapping of the SGT type
> + * @base: Common header, filled in by the core
> + * @sgt: The DMA mapped scatterlist, filled in by the exporter
> + *
> + * Allocated by the exporter's &dma_buf_mapping_sgt_exp_ops.map_dma_buf, which
> + * may embed it in a larger structure of its own, and released by its
> + * unmap_dma_buf. The core only fills in @base, with the same values for every
> + * map of an attachment, so an exporter that keeps one table per attachment
> + * may keep one of these per attachment and return it on every map. A mapping
> + * must not be shared between attachments. Importers are handed @sgt by
> + * dma_buf_map_sgt().
> + */
> +struct dma_buf_sgt_mapping {
> +	struct dma_buf_mapping base;
> +	struct sg_table sgt;
> +};
> +
> +/**
> + * struct dma_buf_mapping_sgt_exp_ops - Exporter ops of the SGT type
> + * @ops: Type tag
> + * @map_dma_buf: Produce a &struct dma_buf_sgt_mapping for @attach, with
> + *               &dma_buf_sgt_mapping.sgt mapped for the device returned by
> + *               dma_buf_sgt_dma_device(). Called with the dma_resv lock held.
> + *               Returns the mapping, or an ERR_PTR; NULL is taken as -ENOMEM.
> + * @unmap_dma_buf: Unmap and release a mapping returned by @map_dma_buf.
> + */
> +struct dma_buf_mapping_sgt_exp_ops {
> +	struct dma_buf_mapping_exp_ops ops;
> +	struct dma_buf_sgt_mapping *(*map_dma_buf)(struct dma_buf_attachment *attach,
> +						   enum dma_data_direction dir);
> +	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
> +			      struct dma_buf_sgt_mapping *mapping,
> +			      enum dma_data_direction dir);
> +};
> +
> +/**
> + * dma_buf_sgt_dma_device - Return the device to use for DMA mapping
> + * @attach: sgt mapping type attachment
> + *
> + * Called by the exporter to get the struct device to pass to the DMA API
> + * during the map callback. The unmap callback takes it from the mapping with
> + * dma_buf_sgt_mapping_dma_device().
> + *
> + * Returns: the importing device, or NULL if the attachment is not mapped with
> + * the SGT type.
> + */
> +static inline struct device *
> +dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
> +{
> +	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
> +		return NULL;
> +	return dma_buf_attach_map_type(attach)->sgt_data.importing_dma_device;
> +}
> +
> +static inline const struct dma_buf_mapping_sgt_exp_ops *
> +dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
> +{
> +	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
> +		return NULL;
> +	return container_of(dma_buf_attach_map_type(attach)->exp_ops,
> +			    struct dma_buf_mapping_sgt_exp_ops, ops);
> +}
> +
> +/**
> + * dma_buf_sgt_mapping_dma_device - Return the device a mapping was made for
> + * @mapping: the mapping passed to the exporter's unmap callback
> + *
> + * Called by the exporter to get the struct device to pass to the DMA API
> + * during the unmap callback. It comes from the match set entry recorded in
> + * the mapping, so it is the device the mapping was DMA mapped for whatever
> + * the attachment is mapped with by the time of the unmap.
> + *
> + * Returns: the device the mapping was DMA mapped for.
> + */
> +static inline struct device *
> +dma_buf_sgt_mapping_dma_device(const struct dma_buf_sgt_mapping *mapping)
> +{
> +	return mapping->base.match->sgt_data.importing_dma_device;
> +}
> +
> +/*
> + * Importer SGT entry. Usable in a static table: the importing device is
> + * supplied by dma_buf_dynamic_attach() and recorded in the matched entry.
> + */
> +#define DMA_BUF_IMAPPING_SGT()                                              \
> +	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type })
> +#define DMA_BUF_EMAPPING_SGT(_exp_ops)                                      \
> +	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type, \
> +					 .exp_ops = &((_exp_ops)->ops) })
> +
> +/* Match on behalf of an exporter that has no match_mapping() */
> +int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args);
> +
>  #endif
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 81bbcd420d60..6b423e22174a 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -46,7 +46,11 @@ struct dma_buf_mapping_match {
>  	const struct dma_buf_mapping_type *type;
>  	const struct dma_buf_mapping_exp_ops *exp_ops;
>  	union {
> -		/* Each mapping_type has unique match parameters here */
> +		/* For dma_buf_mapping_sgt_type */
> +		struct {
> +			/* Filled from the attaching device, not by importers */
> +			struct device *importing_dma_device;
> +		} sgt_data;
>  	};
>  };
>  
> 

