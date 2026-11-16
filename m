Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794833884;
	b=VUE73ktSY/SqQwYUjopjzjjDC4hzy2cckBn2/DJ1auDG/mlisLuMSBi3iCvJi45pvCZx
	 kHsq9JR4r1z42119/aMvfOWKa6w5/gl4StS21LH0nIkPO+s8En/YUuE0dkCRZCYUHYmZQ
	 VLg56C3w8mfw9W584BHRPD+axv4nGQ+uSO/NqT4mepS+Mf0Oxjkva/3KaGr/S9D7AwBPR
	 G3HvEGItFHJYwVslsSmCfsIzbcwafbl+sE6cGtzMlvGrwwL3W2olOPKtuxpBCD4C79bn6
	 iV0SfUkrqWGIIXCbgQxeg5OukNvb+FLe5xxAfBFYMM8VjPZCk9d+vznU4pQjbzk/V9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833884;
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
	bh=hYciQj3SKQaeterWqoO2WWlbcMQ4WfWLOXZDSmdLoMU=;
	b=g6dWiRtkVa3lIN+cxtBn9oiglns7JTlG3Z86hX7BYXBAcJd9XQa5fTx8zCrjlDCoVROP
	 v+BdjU4wWBkjnj62iH8+SBwX6KNkvJE9QYveylWtK6rQeNzqo/OicXKmyk92UHxxvjici
	 Ao3KRB/njHbn+CU9KaG/ALY2YJFdjdHB5WgqZJLPgO/iLznIO0U9ykv7V18ZLQpzc0H9I
	 DVZLsEAj0MAgHrvN24k2Wgt5bg3GbM5JPuXJ+2zvbkPDU0BJUnFqxJZL29KIKKHVfooLD
	 p5kPZ2lQpGFA1YtiZBZXstXbXYMNqM38+Cl5uetEuJvzJn+I7RnGk0rILSYx1rXEj+Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LTB7ktJB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20BE606A335;
	Mon, 16 Nov 2026 12:58:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F20BE606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LTB7ktJB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UM3/DMFJ2RQXohHDT6VLfgkwG7ONDcUg2nM6lOH4Madcj5TaHqs6Lo1TWrngKCMDVDISSF3lbu/ER7NK3M2xkF8XoALznWnFtXP7nBrdL2oFwsJi4THDLQKr2xXlhqGUfCtgqb3ULpUQynSxnlsCOnVaPqf35HT/HCKysjpvVThZJqYifJsz4FsDhmKlRSxlPbFUK9Spp497x2PevQ+QPGxhHDlYNP50EhpIIYQqt43KTRoJs/V/HXwQVOaRqvQBkb8P1zxD5tn/cS2bkBguzWfjKHTo/HK6PI2pnd7sqBM9mycTESNofr3fbzQfXuAECG5RAtdvbkcdHSXpi12Tgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYciQj3SKQaeterWqoO2WWlbcMQ4WfWLOXZDSmdLoMU=;
 b=ORO0edwr1w5WJblaP1SB8KvO5w+3o0w2ae6cRK+6Fegk78ElL6qDZ1g3ZaKF+Aci79ZfcfQfVATx7k4O9mqsdm0qhGjA8LWUOWQyK2kj1AGOc3cN4uFD2Q9+AJ4CwldxHuEkGyXcf+DTfJagxWPvqW86sczTMniPlleHlh7ACFDXD6KPPNw6Hl8xdut7UK6J/qUPXsznQAShgdLNbBweulPRyWWYJciIcpLjTgnYkzAUQZolY/N/J0OUeA8fy4gNawpZri6FZtvD/U7Hdpx+Rldtg4+UEdE9NemPi8XI3nAfln/RYcLUdV7yCKES8Zrs/SEPR9dF+bAd9Zxfk9M/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYciQj3SKQaeterWqoO2WWlbcMQ4WfWLOXZDSmdLoMU=;
 b=LTB7ktJBRH3xPIPnGuhmu8fwcys9kRSflGfBdrbI86SRU1rbhEoRmuXCP4ICCXiODMWXPX8TbQjSidKnKPxkxjF8lVc4HRy2tFEiIjpU19kZlR+jhwyBAmIIK8Uojh8q+S7D203niKBkPZpFi0ibRFQONl0TtKlOgbxApCtcWZ0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA1PR12MB6068.namprd12.prod.outlook.com (2603:10b6:208:3ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 12:57:59 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 12:57:58 +0000
Message-ID: <8768b2e1-e944-46a0-8508-84a9ff491412@amd.com>
Date: Mon, 16 Nov 2026 13:57:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/23] dma-buf: Let the exporter select mapping type at
 pin/map
To: Alistair Popple <apopple@nvidia.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 Xu Yilun <yilun.xu@linux.intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
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
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
 <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>
 <au7mBMbRC8q6NILj@gmail.com> <avE0QsqV5RZoaWc3@nvdebian.thelocal>
 <de268b0f-19fd-4e05-a8d2-e0f436aaedfc@amd.com>
 <avqgQ1k8zx0_N4rM@nvdebian.thelocal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <avqgQ1k8zx0_N4rM@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0601.namprd03.prod.outlook.com
 (2603:10b6:408:106::6) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA1PR12MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7a7d3c-22b2-41c0-c9c3-08df43e13d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261102123227099003|261028144727099003|261102130727099003|261022075727099003|261022105027099003|261021135927099003|261021121427099003|261026121527099003|261026140227099003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	bUTXmXzBj5NAF6d8lYILsVTGtOpLbAzFmBibZuErWbvGHLguWWBeENOpI8rI3KbLe7AiT+NhD4Qf4q2SzRNrLoy6psqhAaly1rm3Cr/GNRXSNJb1cE9p1lM99vkXwQuazlVegKr852pc1m/vaS4V0V/DX8deEGXX7vH/2thFMrlmVdWn5bc8P0VQSOMzGXkZvDG+ffkRGR56fmygr8itz4O3Dg0AQiue7tkI8nctqgQMk9/vFd1qvRoGiPuZds4VPNVgNrY36h2QYizxegEpDZbhmXtBmP/oJpcVKY58rUHulQgm38jV3nHftrGEnmsapNbS/81vaM9RfjT9qG9uyiFwhpn6C34I5dABhPRqu481u1P48ezqj+uEN8N86lNw4BwFCWfie71jlEwH+wvohdKe4lv1B7oHPusPQuZTmOzAeNp66utau0sNrmHMgncllMAemnYSGQn0tBnosDPV8pqLPZuePIMO5bXyF4pLHZD9u/ifB0uWxNUXHIM7PNJJTZGtnzO+waXAIaTwQlUSMRcozA1wCgKxDqUe5seddBXjOMP413nJZVne+CdCxIOwepDuwwmmeJ2pgXhUMipHDOz3BKrBi/nNgQm4dJKq1vqjyusxMiGQGZCrtK1Jn3xBsDNVPO+aN28YYZcYctEq3hwZWJvce7CRiFZpDMdiqCE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261102123227099003)(261028144727099003)(261102130727099003)(261022075727099003)(261022105027099003)(261021135927099003)(261021121427099003)(261026121527099003)(261026140227099003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVp5cGJtYW5vblhHdFlacDd1anZnYk9ta2JoRkRBWTlCV29zTGVxL2VHcS9j?=
 =?utf-8?B?QjVsaGJOM2JZUzJ4cWR4Z2V5YlA1ZDZucy9EWjhHUWFEcU1JR1RWWFJ3bmpH?=
 =?utf-8?B?VmZDZHJBMDBsWmQwOEhOVHM4eHVuYmFPeHdGZFZLcS9qWDFPdUh4QmZmZmxa?=
 =?utf-8?B?S0ZsMkdSZGpuR0dCc0w5dXVOTk1yRHZVaytJQW9RUHFXUkZiMWdQdzFDamxR?=
 =?utf-8?B?RTBYYUxobENpQW15ODRtWk9KSXRhaEZzZHp1ZEgwa0Q5V2h0d1FGaHF0bStS?=
 =?utf-8?B?dGhNOEtDNU0vK0NUdmNneGhmazh0cTdmMjFZZUJIR0RnRWJlQlN3ckFlODEv?=
 =?utf-8?B?NFllTUIvak41dEN3SGxvc3VOTFFmVjBqa2lJcjZiUTlqeVdIUHBrYWVsTUtx?=
 =?utf-8?B?bTBpNkN2Nm1WY0wxZm92SitHbXRibzJvRjI1TGw0NGJzQmo2VE92ZXpDU1kw?=
 =?utf-8?B?OFo0ZjBnUDhJNVhhNjhYUTA1VDExZStJRUZleFhsNmN1QUdKYVlpMFYxWGEz?=
 =?utf-8?B?TlZQbjB5SmZkVWZlMC9TZUk3Uml3d0lnc2Foa0d3TjRFNEE0QmVjVWM1MVJZ?=
 =?utf-8?B?cU9EWHhLUXpvVDA3RWl3TjV1RWkzbC9tSXNzcU5qNzZCNlE5SjJzcmZ4dUlS?=
 =?utf-8?B?Szd0SFNRWTFhc1FYOTZiVlFURW93SGgza1hyMllTa1VGb3NhVEhYYy85SC9w?=
 =?utf-8?B?MUJCTDNYNENWMkZieXFLTVZ1cE1kdk9Eem9ZKzNveU5MbjBLOVBoYklBVVYr?=
 =?utf-8?B?bTUraGExTGE2SHhKSG1YSFp6U2ViUTBpcUd0dkR6NHRzT29YVk5iWGhTV1Js?=
 =?utf-8?B?WEFMVFZ2bFI2WTZRdFdtUE1FVDYxV29RNTZDUTNEclRLQ1cwUTVtb0RBQ3Fx?=
 =?utf-8?B?T1llNld2M3Q2RWthQ1cvTXlpamhGZWIrTkdzeXBVTTh6MitHcWlsdjNVT1lu?=
 =?utf-8?B?VTVEa1pSZzEvZWR2WllKNmVGdllURC9mTloydm1zY3pCZ3JaZEl2VjRydlRP?=
 =?utf-8?B?b1BGb1dyTEFlNGtDWWpITnEyMTVpQ21GZko0b2xhK2M5NWhBV2ZjcjdlTXlh?=
 =?utf-8?B?U2ZVREFhN0lsOGoxWHpJcEx2R0lxMnJyNGZybjM2dXdnQUtLRWllYlhvdGl2?=
 =?utf-8?B?Q2U2N1VZKytLN3FPZ2pTeW1aMTg0R2NKcm1DdEtpZUlGVjl6RnFwYVZLdXVM?=
 =?utf-8?B?dnRpL0NTUjkxbVRzOFZ0SkE1dmtFeHp5SFJZQkVwaXZHaE5Rbk1kNW9VWnFM?=
 =?utf-8?B?QkZvNG9NQU9ITkg4MVFSb3NsYXRNNHZUYUJGZ0pQQzVzMktmT0dVdlVLQUI0?=
 =?utf-8?B?bzdvMEFDRWk3VHpFandRbG5kKzIvUlBLRU5hOXc4R0VuRFNMWk5UOU9WTXVm?=
 =?utf-8?B?OG1aWk95Um00VktwVGU3QXN6Mjg2MDdPUFlMRUpBeHdNZkNvY0JoRW9tdmI4?=
 =?utf-8?B?TTc0SUMzZ09ERVJyS2F2b1JjdjdGR3NSbGpjS0dNSU9WczdMd3RZajZFTWF0?=
 =?utf-8?B?OHFHeG43TmxpbnpqZGJ2S1M4U253MnJqRU5lekNlSW9DSGgwUHFTMjFXdER3?=
 =?utf-8?B?YjFlcnc0MTJ6Ly9OSklpYWVETThaT3luT1BQcU1xa1Q2ZGRDc3gyV2tHWXFS?=
 =?utf-8?B?L3hkWWV1NkJsNGhtcnhUR2xQU3FzcVJZZ0pJdXM0TEhhaGY3L3dPdTI2aGYx?=
 =?utf-8?B?SVhuMnZrV3BUY0g0MGRIZFZVd2kzUnM1ZldIcFFobm9QdGFsTVJjUmxiU2NF?=
 =?utf-8?B?Yzk5WUIrd3M1UkowcEtpOHRxeWwyRm1lVVBTM1l0bDhmUUpLV0NGdHcrTEVM?=
 =?utf-8?B?M2ZaZzJ2dW5ybDhRYUo1c2g4b3FXeXNrNmd3N1c5dFlQWnRDcC9QeGdsZjhq?=
 =?utf-8?B?YkxUc09LTGNmcFdSVis5cnNTR1YxeVdaSGhLc0lIVGdzclFjVVNJbG5XR2E2?=
 =?utf-8?B?aUJobHJUU01DQTJrVVA2d0J2TmZ5TXJ1ZXFvRnhvanp0OGoxUDZrYm9PMFIx?=
 =?utf-8?B?Y3c5SXQrdVN0TzRsYkczeVhxT1U2RXJ4Si9mbFhLOHdaVHJpR3FPSFVScmhj?=
 =?utf-8?B?cXp1QWZFYTVUZTdRcHlPLzlRVXJsZE5EY1hXaGVyNDNTS2xFU2xDa09uTnFT?=
 =?utf-8?B?Tk93YTBZRWorbENqVFFrWGo4Qm94L0hicG1Tb1B1RWNGaThRWkpWWXlsRjVH?=
 =?utf-8?B?SUhRS0JJT0R0MmVQV05KRy9JSndRWU8rVVpuWjdOOGpraGFCam8ya2FHa01a?=
 =?utf-8?B?WjRpRW1yRW5ySCs2TmFzblRoVjlkSlRHdjJ0RlJheXdsVzE0UmtNN29nYzFq?=
 =?utf-8?Q?47fBIFgJbCbjZaw8sE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7a7d3c-22b2-41c0-c9c3-08df43e13d2f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 12:57:58.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NfsjKpikeXvk0eFUXeC36vVisqiFEDJ62gQvE1j6B7OvZ7a0iG3co00NSvADw4lX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6068

On 11/16/26 07:27, Alistair Popple wrote:
> On 2026-11-09 at 21:59 +1100, Christian König <christian.koenig@amd.com> wrote...
>> On 11/9/26 03:58, Alistair Popple wrote:
>>> On 2026-11-07 at 19:57 +1100, Karl Mehltretter <kmehltretter@gmail.com> wrote...
>>>> On Thu, Nov 05, 2026 at 05:40:41PM +0100, Alistair Popple wrote:
>>>>> + * A pin or map that fails after dma_buf_mapping_select() may reopen the
>>>>> + * choice only if it was the one that made it. A selection that predates the
>>>>> + * call belongs to a live pin or mapping and must survive, otherwise the next
>>>>> + * pin or map would reselect under it without an invalidate.
>>>>> + */
>>>>> +void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
>>>>> +			      bool was_selected)
>>>>> +{
>>>>> +	dma_resv_assert_held(attach->dmabuf->resv);
>>>>> +
>>>>> +	if (was_selected)
>>>>> +		return;
>>>>> +
>>>>> +	attach->selected = false;
>>>>> +	attach->selected_idx = 0;
>>>>> +}
>>>>> +
>>>>
>>>> After dma_buf_invalidate_mappings(), attach->selected is false while
>>>> attach->selected_idx still holds that mapping's entry for a pending
>>>> unmap. 
>>>>
>>>> If a pin/map fails before that unmap runs, was_selected is false and
>>>> dma_buf_mapping_unselect() resets attach->selected_idx to 0.
>>>>
>>>> A subsequent dma_buf_unmap_sgt() then uses matches[0].
>>>
>>> Actually there's a bigger issue here. The contract at the moment states that
>>> mapping type may change after invalidation. However that doesn't account for the
>>> fact mappings can outlive the invalidation.
>>>
>>> This could be dealt with by switching everything over to the generic
>>> dma_buf_mapping_map/unmap() path, but that requires an allocation per mapping
>>> just to track the mapping type.
>>
>> You need an allocation per mapping anyway to identify the mapping anyway.
>>
>> We currently abuse the sg_table for that, but essentially the idea of having a structure/object to represent the mapping needs to stay around as far as I can see.
> 
> Oh right, I see that now.
> 
> Do you think it makes sense to convert all exporters to return a mapping type
> specific struct (eg. dma_buf_sgt_mapping) rather than the sgt directly?

No, we essentially want to get away from the whole sgt approach.

The whole purpose of DMA-buf was to exchange DMA addresses between drivers and sgt is problematic for that job because it mixed both the input as well as the output of the DMA mapping operation into one structure.

What we need is the functionality to either say map the buffer at this specific address in that address space (IOMMU domain, internal address space whatever) or just to return DMA addresses plus the information in which address space those addresses are valid.

Regards,
Christian.

> Ie. change map_dma_buf() callbacks to return *dma_buf_sgt_mapping instead of
> *sg_table and convert exporters to allocate that instead of a *sg_table.
> 
> I've taken a look at doing that and whilst it touches all the exporters the
> changes are fairly mechanical in nature, with only two or three annoying
> exporters that have slightly different patterns (one of which is buggy).
> 
>  - Alistair
> 
>> Regards,
>> Christian.
>>
>>>
>>> The alternate is we update the contract to say mapping type cannot change until
>>> after all importers have unmapped. Enforcing this would require tracking the
>>> number of live mappings/pins per-attachment, but I think this is the better
>>> solution so will add that for the next version.
>>>
>>>>>  int dma_buf_pin(struct dma_buf_attachment *attach)
>>>>>  {
>>>>>  	struct dma_buf *dmabuf = attach->dmabuf;
>>>>> +	bool selected = attach->selected;
>>>>>  	int ret = 0;
>>>>>  
>>>>>  	WARN_ON(!attach->importer_ops);
>>>>>  
>>>>>  	dma_resv_assert_held(dmabuf->resv);
>>>>>  
>>>>> -	if (dmabuf->ops->pin)
>>>>> +	ret = dma_buf_mapping_select(attach);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>> +
>>>>> +	if (dmabuf->ops->pin) {
>>>>>  		ret = dmabuf->ops->pin(attach);
>>>>> +		if (ret)
>>>>> +			dma_buf_mapping_unselect(attach, selected);
>>>>> +	}
>>>>
>>>> dma_buf_mapping_select() sets attach->selected = true before ops->pin()
>>>> and the map callbacks run.
>>>>
>>>> In patches 14/15, xe/amdgpu migrate a VRAM buffer to system memory
>>>> during pin and map when the attachment does not accept P2P.
>>>>
>>>> That migration calls dma_buf_invalidate_mappings() and clears
>>>> attach->selected on every attachment, also the one being pinned/mapped. 
>>>>
>>>> When the callback succeeds, the attachment stays pinned or mapped with
>>>> attach->selected == false.
>>>>
>>>> A later map/pin on the same attachment can then reselect without an
>>>> invalidation.
>>>
>>> Argh. Thanks. Will fix.
>>>
>>>  - Alistair
>>>
>>>> Thanks,
>>>> Karl
>>

