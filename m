Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793102869;
	b=zB/hc6esBZoQd1Z83AjcPpY/pwkUSYfkHTWf7scnMjN0hZq8Qx+HBjThx1T9L2s95wzw
	 1NoYqJZwg3r3/NZnuazsuKVGC+ydpKEmdjffZgbu1M8CQazT/bPLnDWlRhM06m8H9WjZQ
	 gxLxRQakpGiUUIkaKE5l+AOu9vbRR/I5/WnE9ifCrvh+xCBl+fT2Enau5BSyXCPtX4N0D
	 4pCgpP+FPinFdAR6LwKH5mxqBEb2tDQPYtY8aLIJtQyZue2x70eeNrSmrT59UK7ktHjD8
	 MolCx7u06lBfE0vsEncAl2dAItf+NWXsneVM0rYXi51et2K6xVTYtkFQIi5VkBK+1rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793102869;
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
	bh=L8+mthjJl1Gbd9g1bMqlAT759JL0TYJKY9Oe/jdxjK0=;
	b=AE8fv6UeiJNR03FWeV6gqsFcVNjrEhA3DvnK33TqGwAME4oOg4mHeQFMIa5Xdsm5SBSH
	 1Vn/TBooJOH9Msh6IQZKsC5c96hO0JBQB0j3QEOqphCn/KyFhM/MNDQtCFJspmpMPMgUV
	 v8E7BY4zy613hs2480OP/p705bRU72Czxtc2/4V45DS59XGD76D4VMlGYU7pb2W/ZjDqy
	 34pkrm7KLr6cozBSqgD35Gidg4X7luyT1fXy96s3amGjhNBSjKhxokQCP+2KYECQ2YNXZ
	 Ifqq+ve6ulJt/XQmO1+/9GtlpoYOQcqmzQQ5pXzhT3k4lWyO8gJuGL2rPxchrlbYomQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qQye7IoB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.34
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011034.outbound.protection.outlook.com [52.101.57.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A40A606A31A;
	Tue, 27 Oct 2026 12:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A40A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qQye7IoB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpdQ9auH8Ss4F2UsqC4nkAhsIygqCqbmQlQShtG8AoSThtnzYB6hCZmQZzu6YKZ8/SM7Z/slnE7mt6aJTh6ZXdbF8Kfh2ualmZQX/ismf17tsiEiHp1kDixhZ2dks1/cHMlanCQQCcpnVnC+pcaWYUFy6mnbPPSBEKj9Kmk//t+dFBRX/u2C5h1OOSrLxL6/BaV4+n9vU1xa6CtGvCKHbkATZ+G0ERVqu5XlJqA59r4FmxvDaMNG8jNDJrGAwUhTZBB14GQgCMYHPjHiWGt4H9JNmC30vMlwHF0NpYsEksYng3bYYWOn5Hc5HWrG4kZb73l0/5dubos0URh48FCR7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8+mthjJl1Gbd9g1bMqlAT759JL0TYJKY9Oe/jdxjK0=;
 b=ANYBq9Zjuw8+332LjXckncmh808S78wUjR4knNHDQs/IwldnVPkhHHCkwZSOR9Gmy92JQm309ZWf9T3XB4ybiWxdg0PKKosMywhNnnQia1O8reITLNVzfaFkxuwnXUT+EIX7jY5LE1k+YrzI/ttJtryzegQIbg5wOUmBfNWXk9RGqfw03Q8iX7X+FyTWzFmeUyVKVLlipKzszAi3q+U/gKmYqt+qRBc22eiiJbcuXbsMjrKMoH5OK6XDHt+UA7zko1xNeC3I8le7it68NfaQovfgBJ1xPgSYOnHvw3ERdSrjKsUWz11ODpvQHX0ghZPoxjiROOJBSC9vIuOWnXsu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8+mthjJl1Gbd9g1bMqlAT759JL0TYJKY9Oe/jdxjK0=;
 b=qQye7IoBYnErQd1gIbMPlxGH4D5+nMPSE7WOIgq0BkRFpYKXoT0QL69voEc1ypR6FUGYFGeK6yzlMdDrKVGiCNAyJcp5S6xDpTNJRFl2FlZ+72lNcN/hOvM3ZCSkCPX9Woa0NH1eE4U1yTYAm019oDKBSgC7GA1tj/lhmaUwunY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DSVPR12MB999172.namprd12.prod.outlook.com (2603:10b6:8:38b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:07:43 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:07:43 +0000
Message-ID: <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
Date: Tue, 27 Oct 2026 13:07:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
To: Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 sumit.semwal@linaro.org, jgg@nvidia.com
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com,
 jhubbard@nvidia.com
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261026053623.202642-24-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::11) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DSVPR12MB999172:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0db6d2-5af8-49b0-446b-08df3422e801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261009221227099003|261022105027099003|261009223027099003|261022075727099003|261021123027099003|261021121427099003|10067099003|56012099006|261026140227099003|6133799003|18002099003|22082099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	K43pHnt/siFHLiWreLcZ6BKhGOMHbxEjcvYZDA8ZusP9QC4VYpvJ58/Y+v/pj+tUKGiTvEL/+XlL5HM3O3OuECiGw70qG8ytMe831wnnMbtJ2J8mhdlLKPVtIo7pYlDubT3aWGOKciQ/haxbsJkrAI6VIfpyNsSl5F9aWp6BymEueDzjNQXobMqd6mRRimM0y8OrGR6rVhOz3nBqZFtN6xPjAlFgDwf3fCxOOoF6FyYas6cGB3u1B5q8BHTIPn71GxQfZ9cFTUvuEGjC3blmIfy/mFBzU60X+Gz9lqltSsdMgw/FLm9k5z/8DD4WFJzzopRdDzYYKEEA4OIirkltuLp9J0bpt8eTodyMuY0nwybtltsAEwwRYeXTypwcW8XMmtAIxeeS8M/awPkMOjf6kY/bhK20GjB5Ufx2Koy+hDMZ3JJGWprsplCb8n6NnlySzSvbt79Imgv2LqWJGe7RiOkPY5vStURpCHrBJzEMkd0lf4M7foKzZb6lzVOxOfeP2uQeKPfboOivf+2tno3jMlZWnrk5DETWtjqKYGgSIJzU3HSGUbnNxNM61pFIbhagvj3JedxNFDMrsWrey77yu1WlLRZ84aRTvna9Zl+Ot0YWx+kgN/u9LMWuBSp95oDbbm8WBDD/zobVRq6PfLcgy30pYR5bTjB2pOvT4ERcEqo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261009221227099003)(261022105027099003)(261009223027099003)(261022075727099003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(261026140227099003)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2FmSVpJYWd6NlhrTmFEc0FhWnFuVTlrUUNlREpMTlpxcGM0UEE0MVo5Mm0y?=
 =?utf-8?B?c1dDMU0zYWdQL3hMbkxiWVZVMkp4Q2p3anBEalhnTGl5K1RyRVkvNjRONVZ6?=
 =?utf-8?B?ZEpwbng4cm8vMEY5SFM0Nzc4OEFRVDJMZVhTbU9kRHF5Y0s3eE41c0FzcHk3?=
 =?utf-8?B?cW5nYlgrTS9xOUJxZko0cUdRY2loeURYamprN3IzOVlHNjMyYkU2ekJUK3Ro?=
 =?utf-8?B?WVUzaStRa09BaE1BcUZ1RHZHb201RnVkK2grNFNMUmNhdTRiUXFGMzc1VWor?=
 =?utf-8?B?em9CRlN0cU5aRTVPZjVaMmwyVmlXdlMrZGVlam1PWU56ZEl1elVzaUxpSzN4?=
 =?utf-8?B?WDM5Nyt4T091ZWZSTWEwd0piVnlINHphNlNSZjR5TllUQTZQZVE0Y3pkMCtQ?=
 =?utf-8?B?QytFOFBjRTVGUHVsbCtGWmh5d2pkNU5seVM3L2hudmF1azJVaGZIVTJvWmhB?=
 =?utf-8?B?LzlzOFk4Nm1xd3FlbzJoSkRtYWc1aWo2aDlGTzZNR3JXVEpWc3NkUE10Myt3?=
 =?utf-8?B?a0FUN0lrajFEQjRmVHdjclJRMVJLT2loaFM1a0Y4NGZYSjFtZGFtNmxwaGhI?=
 =?utf-8?B?K0RpNThENTA4bEMzL1l6NWJHcGxxMDB5RVR6UkIrZmRXdmxvN0lKSVBVY1FS?=
 =?utf-8?B?SVpKTEM0V2MzeVVLVzk5bVE4NElRSThTVG5BQkl5UmpKUlVwbDVlTjNKc3FO?=
 =?utf-8?B?c0VwblBPMkl6S3VYWnBHdHA2VUE2VXlTeFc3V3lHbmZMMnVEZjFmSHBYZ2FB?=
 =?utf-8?B?akloVUhjY0dlbVduUlRndXVqNFRPVUhpM2thQ1Rrd244ME82RHV3RXpBdzg4?=
 =?utf-8?B?UGpNRlV2ckIyakhqZ1FnaUpjOVpDNmh2S245NExWWlhwQStBWWh1ZmsxMjJu?=
 =?utf-8?B?bmtsbVBzejI5QVNzcXBtUnpnYWhHaU9teE1FNmUrMHcxVDBoT1Y0MnJ5S1hP?=
 =?utf-8?B?N0xGcHlKa005RXkvYjBtbS9zSVk2NVJJSG84UkljMUY0amNsSGVwT1JtMFUw?=
 =?utf-8?B?ZXdOWDI2TjN6Q0F6TVdUWG1ZYUgyVk0wRjQyT1BoSDZHUUt2bEY3Wjl1Q2cz?=
 =?utf-8?B?NHoxZXNvMk94cWZJejN4Yk1RZnJPM2lYY203VWtERVM5ektleGJFQ0p6d3BS?=
 =?utf-8?B?ODRCa1VNUEZSNTk0NEIzZTR6MGl0Y0hMVkhHQjF5VGl1c2piVnVORElNT05X?=
 =?utf-8?B?anMvZk5lS2RBZ1pHTWhlaGExU2ZpakNqaHNBTXA1bmYwS25oeXRGN3VrMFFC?=
 =?utf-8?B?RHgxWmYxcEdWaUYrSmpXMFpOTW5XY3FMT2psRDltVXBRWnU5OFE2eTc3SVdV?=
 =?utf-8?B?WGU1aFk1Q1ZNYzZUdzRBQnRwNTJySlFINDNEUmh4UUo1VzlsaUN1LzlsZ0lr?=
 =?utf-8?B?cUJRb1c2VXQwM3h6WElmYzhOcXZqaEpBeTE4aVB2cU1RZ3BNOTBhSzZTbmZI?=
 =?utf-8?B?NnozNzE5MmRneEZhdDZzQWZDeFdDRmUwYVpNR2FnZ2tsV2xSR3lDWUZ2Qk9M?=
 =?utf-8?B?a2R4RVZneUVYZkEvZ3l5NXBGY1c2dnF5NUtUdDBYdTAzeTFNUVk1ZWI5VkJF?=
 =?utf-8?B?ZTNGZzVtVXAyQ1BNNkZMZkFnREJDMUZmR3ZrUHQxQTI4Q3FOcXN0RHRlOGhp?=
 =?utf-8?B?KzRWSnpJMExEMnpKNXdCSDYvWWM4RElRV2VWNEJ5L0s5TTF3YXBJRDJ4UXJx?=
 =?utf-8?B?VnpQd0tBYmd3UEt6T3hMdksvWmdKRUcrenlHbTY5ZWNsREdCdHM3Z09Qa1Zw?=
 =?utf-8?B?K3BqejZ4VVpDZDlUamNkeXpPZHJLSmRXeDBEdGp2WFRaOGRFdGZoMm5EVU5L?=
 =?utf-8?B?K1JoOFhkMzVMNmxOd2laWG9RTmZjTUttN3RBejErODRIcFRSd0UrTWxPL3Aw?=
 =?utf-8?B?WGFzeTlJaU01bzNyVElaRW53MjYvNDJnRnpRQlpwYTB1UzFCMmNPdkphUDRN?=
 =?utf-8?B?cytsSjI3bldEMVNUYUcycTRRT3ZId1l4TjZCT1ZDVjRNWFFYOGhYaDN2R0xD?=
 =?utf-8?B?SXA0Sjh6RU5pTDM4cWRpell6emlxeDRRTWI0ZG5BNXZjbW14ZGhYeUFGazgy?=
 =?utf-8?B?UXpwOFprUnJqRDJyK2VUZHFHdDRFVE05Ym1CazNlRUNrMnMyYW5ZOWV6M1BV?=
 =?utf-8?B?ZUJQVEd0bHNuVGxYaTgrd2Yvd3l4aGw1ZEE2eitsWDlIbCtLNUVndm1vR0RU?=
 =?utf-8?B?UlpCN1RQdUVCTWgyY3hRemxlQkZpdU9mWXBuZlFlbHVkWUxDUWJwcmZYN3ZH?=
 =?utf-8?B?eXJ6TEZKQjZaMzBWZFMzdjdJbGQwODF5NmNZa09wc2EwQXY0YVpudGdVeEow?=
 =?utf-8?Q?Wat/mPR60hI/YisUXV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0db6d2-5af8-49b0-446b-08df3422e801
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:07:43.7512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbDlH0oTh56+r83Ds5tJZFoqcPt+/H1vZYN8UlG9KtQgVhmDPmXZD4B3G86VmoAA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999172

On 10/26/26 06:36, Alistair Popple wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> This attach function always creates a SGT mapping type importer.

Yeah that is a clear NO-GO. The attachment should be the same for the new interface as well.

Regards,
Christian.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/gpu/todo.rst                         |  2 +-
>  drivers/accel/amdxdna/amdxdna_gem.c                |  2 +-
>  drivers/accel/ivpu/ivpu_gem.c                      |  2 +-
>  drivers/accel/qaic/qaic_data.c                     |  2 +-
>  drivers/dma-buf/dma-buf.c                          | 14 +++++++-------
>  drivers/gpu/drm/armada/armada_gem.c                |  2 +-
>  drivers/gpu/drm/drm_gem_shmem_helper.c             |  2 +-
>  drivers/gpu/drm/drm_prime.c                        |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |  2 +-
>  .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |  2 +-
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |  2 +-
>  drivers/gpu/drm/tegra/gem.c                        |  4 ++--
>  drivers/iio/industrialio-buffer.c                  |  2 +-
>  .../media/common/videobuf2/videobuf2-dma-contig.c  |  2 +-
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  2 +-
>  .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |  2 +-
>  drivers/misc/fastrpc.c                             |  2 +-
>  drivers/usb/gadget/function/f_fs.c                 |  2 +-
>  drivers/xen/gntdev-dmabuf.c                        |  2 +-
>  include/linux/dma-buf.h                            | 10 +++++-----
>  io_uring/zcrx.c                                    |  2 +-
>  net/core/devmem.c                                  |  2 +-
>  22 files changed, 33 insertions(+), 33 deletions(-)
> 
> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
> index 14cf37590fc7..be0397c197f1 100644
> --- a/Documentation/gpu/todo.rst
> +++ b/Documentation/gpu/todo.rst
> @@ -633,7 +633,7 @@ Remove automatic page mapping from dma-buf importing
>  
>  When importing dma-bufs, the dma-buf and PRIME frameworks automatically map
>  imported pages into the importer's DMA area. drm_gem_prime_fd_to_handle() and
> -drm_gem_prime_handle_to_fd() require that importers call dma_buf_attach()
> +drm_gem_prime_handle_to_fd() require that importers call dma_buf_sgt_attach()
>  even if they never do actual device DMA, but only CPU access through
>  dma_buf_vmap(). This is a problem for USB devices, which do not support DMA
>  operations.
> diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
> index a7e759bb0460..2b2f1e9fb9ec 100644
> --- a/drivers/accel/amdxdna/amdxdna_gem.c
> +++ b/drivers/accel/amdxdna/amdxdna_gem.c
> @@ -893,7 +893,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
>  
>  	get_dma_buf(dma_buf);
>  
> -	attach = dma_buf_attach(dma_buf, dev->dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
>  	if (IS_ERR(attach)) {
>  		ret = PTR_ERR(attach);
>  		goto put_buf;
> diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
> index 8d6ed95ccc7c..d1c99b974a34 100644
> --- a/drivers/accel/ivpu/ivpu_gem.c
> +++ b/drivers/accel/ivpu/ivpu_gem.c
> @@ -219,7 +219,7 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
>  	struct ivpu_bo *bo;
>  	int ret;
>  
> -	attach = dma_buf_attach(dma_buf, attach_dev);
> +	attach = dma_buf_sgt_attach(dma_buf, attach_dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
> index 92d49448df72..88331028b7bf 100644
> --- a/drivers/accel/qaic/qaic_data.c
> +++ b/drivers/accel/qaic/qaic_data.c
> @@ -850,7 +850,7 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
>  	obj = &bo->base;
>  	get_dma_buf(dma_buf);
>  
> -	attach = dma_buf_attach(dma_buf, dev->dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
>  	if (IS_ERR(attach)) {
>  		ret = PTR_ERR(attach);
>  		goto attach_fail;
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 12604c60122e..06bc25eff079 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -671,7 +671,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
>   * 2. Userspace passes this file-descriptors to all drivers it wants this buffer
>   *    to share with: First the file descriptor is converted to a &dma_buf using
>   *    dma_buf_get(). Then the buffer is attached to the device using
> - *    dma_buf_attach().
> + *    dma_buf_sgt_attach().
>   *
>   *    Up to this stage the exporter is still free to migrate or reallocate the
>   *    backing storage.
> @@ -966,7 +966,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
>   * 2. Importers must not hold the dma-buf reservation lock when calling these
>   *    functions:
>   *
> - *     - dma_buf_attach()
> + *     - dma_buf_sgt_attach()
>   *     - dma_buf_dynamic_attach()
>   *     - dma_buf_detach()
>   *     - dma_buf_export()
> @@ -1100,15 +1100,15 @@ struct dma_buf_attachment *dma_buf_mapping_attach(
>  EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_attach, "DMA_BUF");
>  
>  /**
> - * dma_buf_attach - Wrapper for dma_buf_mapping_attach
> + * dma_buf_sgt_attach - Wrapper for dma_buf_mapping_attach
>   * @dmabuf:	[in]	buffer to attach device to.
>   * @dev:	[in]	device to be attached.
>   *
>   * Wrapper to call dma_buf_mapping_attach() for drivers which still use a static
>   * mapping.
>   */
> -struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> -					  struct device *dev)
> +struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
> +					      struct device *dev)
>  {
>  	struct dma_buf_mapping_match sgt_match[] = {
>  		DMA_BUF_IMAPPING_SGT(dev, DMA_SGT_NO_P2P),
> @@ -1117,7 +1117,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>  	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
>  				      NULL, NULL);
>  }
> -EXPORT_SYMBOL_NS_GPL(dma_buf_attach, "DMA_BUF");
> +EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");
>  
>  /**
>   * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
> @@ -1149,7 +1149,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_dynamic_attach, "DMA_BUF");
>   * @dmabuf:	[in]	buffer to detach from.
>   * @attach:	[in]	attachment to be detached; is free'd after this call.
>   *
> - * Clean up a device attachment obtained by calling dma_buf_attach().
> + * Clean up a device attachment obtained by calling dma_buf_sgt_attach().
>   *
>   * Optionally this calls &dma_buf_ops.detach for device-specific detach.
>   */
> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> index 72c7cd2b3fb9..438f33304eab 100644
> --- a/drivers/gpu/drm/armada/armada_gem.c
> +++ b/drivers/gpu/drm/armada/armada_gem.c
> @@ -518,7 +518,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
>  		}
>  	}
>  
> -	attach = dma_buf_attach(buf, dev->dev);
> +	attach = dma_buf_sgt_attach(buf, dev->dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index d654a22a30de..9e937af2ee73 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -964,7 +964,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
>  		return obj;
>  	}
>  
> -	attach = dma_buf_attach(dma_buf, dev->dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 3ffbe3d28929..3084e8c28e53 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -999,7 +999,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
>  	if (!dev->driver->gem_prime_import_sg_table)
>  		return ERR_PTR(-EINVAL);
>  
> -	attach = dma_buf_attach(dma_buf, attach_dev);
> +	attach = dma_buf_sgt_attach(dma_buf, attach_dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> index 7f939c281308..9865a7a9ad8f 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> @@ -306,7 +306,7 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
>  		return ERR_PTR(-E2BIG);
>  
>  	/* need to attach */
> -	attach = dma_buf_attach(dma_buf, dev->dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> index 6b6d235fd3e9..3c193e6d9d11 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> @@ -287,7 +287,7 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
>  		goto out_import;
>  
>  	/* Now try a fake an importer */
> -	import_attach = dma_buf_attach(dmabuf, obj->base.dev->dev);
> +	import_attach = dma_buf_sgt_attach(dmabuf, obj->base.dev->dev);
>  	if (IS_ERR(import_attach)) {
>  		err = PTR_ERR(import_attach);
>  		goto out_import;
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> index c549b94b2e8a..ca0962a99509 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> @@ -115,7 +115,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
>  		}
>  	}
>  
> -	attach = dma_buf_attach(dma_buf, dev->dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev->dev);
>  	if (IS_ERR(attach))
>  		return ERR_CAST(attach);
>  
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index f06826fe8366..803409824711 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -81,7 +81,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
>  	if (obj->dma_buf) {
>  		struct dma_buf *buf = obj->dma_buf;
>  
> -		map->attach = dma_buf_attach(buf, dev);
> +		map->attach = dma_buf_sgt_attach(buf, dev);
>  		if (IS_ERR(map->attach)) {
>  			err = PTR_ERR(map->attach);
>  			goto free;
> @@ -475,7 +475,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
>  	 * domain, map it first to the DRM device to get an sgt.
>  	 */
>  	if (tegra->domain) {
> -		attach = dma_buf_attach(buf, drm->dev);
> +		attach = dma_buf_sgt_attach(buf, drm->dev);
>  		if (IS_ERR(attach)) {
>  			err = PTR_ERR(attach);
>  			goto free;
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index f81154642bcd..abffbcc76c4c 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -1717,7 +1717,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
>  		goto err_free_priv;
>  	}
>  
> -	attach = dma_buf_attach(dmabuf, dma_dev);
> +	attach = dma_buf_sgt_attach(dmabuf, dma_dev);
>  	if (IS_ERR(attach)) {
>  		err = PTR_ERR(attach);
>  		goto err_dmabuf_put;
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index e13521b5c0e8..c7fa86cba8ad 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -789,7 +789,7 @@ static void *vb2_dc_attach_dmabuf(struct vb2_buffer *vb, struct device *dev,
>  	buf->vb = vb;
>  
>  	/* create attachment for the dmabuf with the user device */
> -	dba = dma_buf_attach(dbuf, buf->dev);
> +	dba = dma_buf_sgt_attach(dbuf, buf->dev);
>  	if (IS_ERR(dba)) {
>  		pr_err("failed to attach dmabuf\n");
>  		kfree(buf);
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 59e346a5d48b..4c93b7f58e1f 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -638,7 +638,7 @@ static void *vb2_dma_sg_attach_dmabuf(struct vb2_buffer *vb, struct device *dev,
>  
>  	buf->dev = dev;
>  	/* create attachment for the dmabuf with the user device */
> -	dba = dma_buf_attach(dbuf, buf->dev);
> +	dba = dma_buf_sgt_attach(dbuf, buf->dev);
>  	if (IS_ERR(dba)) {
>  		pr_err("failed to attach dmabuf\n");
>  		kfree(buf);
> diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> index 55d58a4dbbe2..d80282ebe4b4 100644
> --- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> +++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> @@ -96,7 +96,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
>  		goto ref;
>  	}
>  
> -	attachment = dma_buf_attach(dmabuf, dev);
> +	attachment = dma_buf_sgt_attach(dmabuf, dev);
>  	if (IS_ERR(attachment)) {
>  		dev_err(dev, "Failed to attach dmabuf\n");
>  		err = PTR_ERR(attachment);
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index 375ce39c78c9..24ae1038b634 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -904,7 +904,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
>  		goto get_err;
>  	}
>  
> -	map->attach = dma_buf_attach(map->buf, sess->dev);
> +	map->attach = dma_buf_sgt_attach(map->buf, sess->dev);
>  	if (IS_ERR(map->attach)) {
>  		dev_err(sess->dev, "Failed to attach dmabuf\n");
>  		err = PTR_ERR(map->attach);
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 4016edfa4c02..bfa24bcfe84c 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1549,7 +1549,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
>  	if (IS_ERR(dmabuf))
>  		return PTR_ERR(dmabuf);
>  
> -	attach = dma_buf_attach(dmabuf, gadget->dev.parent);
> +	attach = dma_buf_sgt_attach(dmabuf, gadget->dev.parent);
>  	if (IS_ERR(attach)) {
>  		err = PTR_ERR(attach);
>  		goto err_dmabuf_put;
> diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
> index cd851eb04a69..e7ffb546e717 100644
> --- a/drivers/xen/gntdev-dmabuf.c
> +++ b/drivers/xen/gntdev-dmabuf.c
> @@ -580,7 +580,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
>  	gntdev_dmabuf->priv = priv;
>  	gntdev_dmabuf->fd = fd;
>  
> -	attach = dma_buf_attach(dma_buf, dev);
> +	attach = dma_buf_sgt_attach(dma_buf, dev);
>  	if (IS_ERR(attach)) {
>  		ret = ERR_CAST(attach);
>  		goto fail_free_obj;
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index b264e1c4a9df..208752eb93d9 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -77,7 +77,7 @@ struct dma_buf_ops {
>  	/**
>  	 * @attach:
>  	 *
> -	 * This is called from dma_buf_attach() to make sure that a given
> +	 * This is called from dma_buf_sgt_attach() to make sure that a given
>  	 * &dma_buf_attachment.dev can access the provided &dma_buf. Exporters
>  	 * which support buffer objects in special locations like VRAM or
>  	 * device-specific carveout areas should check whether the buffer could
> @@ -125,7 +125,7 @@ struct dma_buf_ops {
>  	 * exclusive with @cache_sgt_mapping.
>  	 *
>  	 * This is called automatically for non-dynamic importers from
> -	 * dma_buf_attach().
> +	 * dma_buf_sgt_attach().
>  	 *
>  	 * Note that similar to non-dynamic exporters in their @map_dma_buf
>  	 * callback the driver must guarantee that the memory is available for
> @@ -513,7 +513,7 @@ struct dma_buf_attach_ops {
>   * and its user device(s). The list contains one attachment struct per device
>   * attached to the buffer.
>   *
> - * An attachment is created by calling dma_buf_attach(), and released again by
> + * An attachment is created by calling dma_buf_sgt_attach(), and released again by
>   * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
>   * transfer is created by dma_buf_sgt_map_attachment() and freed again by calling
>   * dma_buf_sgt_unmap_attachment().
> @@ -591,8 +591,8 @@ static inline bool dma_buf_is_dynamic(struct dma_buf *dmabuf)
>  	return !!dmabuf->ops->pin;
>  }
>  
> -struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> -					  struct device *dev);
> +struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
> +					      struct device *dev);
>  struct dma_buf_attachment *
>  dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
>  		       const struct dma_buf_attach_ops *importer_ops,
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 67f74ce4f096..2cbf65b29f89 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -175,7 +175,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
>  		goto err;
>  	}
>  
> -	mem->attach = dma_buf_attach(mem->dmabuf, ifq->dev);
> +	mem->attach = dma_buf_sgt_attach(mem->dmabuf, ifq->dev);
>  	if (IS_ERR(mem->attach)) {
>  		ret = PTR_ERR(mem->attach);
>  		mem->attach = NULL;
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index f30fa375c9ab..d7c08da306cf 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -234,7 +234,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
>  	binding->dmabuf = dmabuf;
>  	binding->direction = direction;
>  
> -	binding->attachment = dma_buf_attach(binding->dmabuf, dma_dev);
> +	binding->attachment = dma_buf_sgt_attach(binding->dmabuf, dma_dev);
>  	if (IS_ERR(binding->attachment)) {
>  		err = PTR_ERR(binding->attachment);
>  		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");

