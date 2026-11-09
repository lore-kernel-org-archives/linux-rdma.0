Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794221991;
	b=AK9rF6N9599LoPPYtHjIpNtfElAhbokcnqkgQ7pTZhIndKMmXY6vQNVv6r3GIsMlPM5x
	 iwRAGsJxzwDY+sQRzvFl621ZGGj4oJi5piKuurrhdd4LqXtMMDyyyt1fsaq2ic1bBIM41
	 +7iHHEDAWFP052BLiGYUba5mJWqpopU/823/B7JZy7sHsQSDKngJJeAeTofG2CLQxBGM2
	 lvKHwR8cYx0tRPMBBWL4buOeNrKVCXWzQsCjzB2QIUbuHjmaB7NmJdkspBCTvg9ofDtK0
	 0J2fI8UdWl5OPTeHutUR9NYD3r4L0ew9DpJscA6nzG7QOoQOg5EnDgWA5XrMGmUwOxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221991;
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
	bh=jjpFTnz0Yc1Y7M/dvGri5n0tXtSUOW6fg0KalqDzOkk=;
	b=VP56kqS7McNPgLcyvzn1bHLdGL1bNCQJ22SAFQIsQYeBqx2OheYCXwCAn24PQ7ym+bJA
	 be54+/p5scZyamSLvw0wjOUwxl4jqU07SV0eSJHAYEqkGsNjeTpi+xeF3YEvZ4DUhybx6
	 o4gx/qvWkYhTqQi/HpiB26P2MIMn4OJ2e/DxiST0cDrt9RZn2eb3ja/4lD1pN4Hx4yYCL
	 kMTBpZvSbPIeTOAYhI28dAtbErKDU89BZax4QGw8NBcQey/sN3PNoccY2Zs3woYYXqT/G
	 27ZJrXJ8LW9enM/AT8q7T0+xAJpY8YkjLj2ykbBPidEH6ra77G1fQCfH+fbIOFepdUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ANP3+TJD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C74606A321;
	Mon,  9 Nov 2026 10:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93C74606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ANP3+TJD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jB2QqypgFyay5R2PUD893g2YTKTAm7c0K8OL4LIpufgkRSFLR3GvCpARuLXPQIh36HnWOZfDQA4AsLxo4KFIzRNGJyEAlz7iMbOBx7Q4jZM86JyiLLQ1Vha+fxEwYF88VOACDX47yx6py2uPRZrYY9i7VKF51NwtFQFi79GrCkkgHy4mrZQhW+/wkeQZioDgra/Rqpq8ArJc9miH7sLPDlFxnj6HbJ2ZB848prP6DiWmf4BnVwBDs6P5ZOrsQ2IbaLzmrfWEzW4Uz1u8AXtsERwynIPinOS9Ao3JJW+FkuyDxxqf22f+gw1t5DvcJqoEgFcIp6GixgKuXZDDJAgmRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjpFTnz0Yc1Y7M/dvGri5n0tXtSUOW6fg0KalqDzOkk=;
 b=erOc4FBGOcWKWClP4MKts9uhBLa20zBgxqQ1XXMZ+zjIdgD6gjEeVW/NqA3yZMt0zsrJ+OXeKJkuGJ5j3N2tG1VjxN94h3BFT6i0jkTB5Rv3deVpppjL1M3VGB4+iZLoE0j+cKFTnGts/gMl53OZrsTfxJIX2zO/zbGu3E+WVsXrWNf3NO+fVArAbBwjM+aYk0hRHT3c1U3BEJX5PZ0eZ9M86XtwOwWMeGI85X9+k9Rz5MAFas62ec1jiRykDtJ5M71xIPJjd1a9uMj8BjnpLLzNORFSOLmoF72acZ22oFWmOAR+XXEUyQafIKlaMOJmlT28cR6SSq/tXIoiYq5vOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjpFTnz0Yc1Y7M/dvGri5n0tXtSUOW6fg0KalqDzOkk=;
 b=ANP3+TJDD1IcoTuWLSt8OyLrmuSXPB/xEKVow9ZMcO5IRhRLJX/KXExoBH3AXJWv//Mk+GCjTxqVs2vUqjjfF1LlGEBPg5JafPXSaM0HUOnwH92KcjJ0/RNrMR56qnpFsWalOpCRdt/m5k6G1oxRI60VxGHqwkBoYk+rT5q1JhA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH8PR12MB7280.namprd12.prod.outlook.com (2603:10b6:510:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:59:46 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 10:59:46 +0000
Message-ID: <de268b0f-19fd-4e05-a8d2-e0f436aaedfc@amd.com>
Date: Mon, 9 Nov 2026 11:59:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/23] dma-buf: Let the exporter select mapping type at
 pin/map
To: Alistair Popple <apopple@nvidia.com>,
 Karl Mehltretter <kmehltretter@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <avE0QsqV5RZoaWc3@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0385.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::10) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH8PR12MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 40f2945f-107e-413c-4277-08df3e5090c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|22082099003|18002099003|10067099003|4143699003|11063799006|56012099006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	qoGw77O/HTNC6edPpNcBFGuUlJfUlac8Uvd7a2ZcsU9ltxGDz0HbszH4wnF1Kt8X6lDL46aXHnXwiXzOdcfVX8bRjDY923pRa1nbf5Ijs63hCIcWedsr4rIvTYPa7f5VxlSbZs7MnBF6axQRFvcTliGfJvcBBqHYmwK9ImmQuI6lQZmaS9hoaKSaq8IPvjQxMuLZm7wczWJWi4kg4WgNdqj+5TB5HfIbf4PkrkCZ56g9C4K3lnRRHZXnghybOwRwzTGsZMDt+vaPMTwvuBlRtAogCsC9TTSpxNkXtshD3K/G90uQaZEXTJQ0BSm2lqNmHlWieAoxiPS8dG9f1gPSn81AUeR9jTAekgr4mXz6hxvMpYQcUmaI1b5gQH6ttUqRkhLkH0g8Ijmh5O2UUkcuHTmYPCp5gW4BuOQecZa8S9cS9Cy+PArc646bJJwyOAnNU5k9SCOTPEeiEn3FUdJnxGgr3BYl0Miq9dxvWDVAc/UbELKcKrlf3Ce/g19fmPWQGIHqLEkixo+C+RNiRVNsbxKlCbLX9fCwJeeuJ+n1RGDlXIfJN+zSmTIDsKodNd6B3/dp0fq9AxQ79CogIwVFrVj9chc24G3HwYJsechBQMU+XwTDMrQ+hEUrTKaRy+o7lFcJgFhr0coRhuQL7HL5IwmGw58svFB9A96+iULZRmI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHBqK3VLVm00M3BZWGhmS1JmVTVkcVplYkxNSVNRT2ZzaHNiV2doUFRqbXVO?=
 =?utf-8?B?bnY1SzhPOWR2NUgzRWNwenIrNk45L1hwc0hGN2V1c0g5cEFtTmJFVmVJMzBv?=
 =?utf-8?B?d0ErSmhiYmxMSDJiU1o4WUVmcktlUnljYUpHRWNTMjFIekJHU3RZTDI4UTVK?=
 =?utf-8?B?d240RE1yK2NOOEZ1dE1PWDFGTnBlangzMmtGb1dpejY5MXdlQXF0UXBaeWY4?=
 =?utf-8?B?aVJvVmlpaVVINy95c0N1Y1ZVVkpydmViKzh4N3psWElvWkhBdDNNV1RJVGh3?=
 =?utf-8?B?MG5lRWtFNGpJOC9TVnMxV1lEWkVFclh4UkJJbDhKa1dwTDBRaVl1VG5nUS9F?=
 =?utf-8?B?Z2JrU3J0emZmdmRJQUVLSEMzU0FkRlBoMEk2UlRzb1Yzc3QzNklYUDVFK1lm?=
 =?utf-8?B?VmlzSlZRamZaMGxyZmpJL1FiWFg0SU5GUWVQdmdId1NlQmNuT21mV0ZSOHZt?=
 =?utf-8?B?Z3UyRmErSmxPUHlKcUtVMEplMVh3OXg5K1BHQlV3WWdJVDZFbzlMUU5GSGxw?=
 =?utf-8?B?WjdmNzhMRnVlRFZPMmVxWmxWR1ZnOEs2bXVHMlRJM0xPNTBYRUlWL3JOc29W?=
 =?utf-8?B?THI0eC9UZkovb2hxR3lHaXF3RXFsd3J2SStNMXNtWFpUYi9LZlJ4M25lOUly?=
 =?utf-8?B?bVA5VHI2Mkt4VExQNEs0NTArS2l4ZDZzT1VtRDMrMS83amg4QjZ6UGxaN21N?=
 =?utf-8?B?MmhDYmlEb2txdG82c2REWEppRUx5VlljbC9kRm9FM2hScko4RUtoV08wcUZQ?=
 =?utf-8?B?RlI1ekRpOE5UamcydTFmSGFIU3JzS3NXRTEvekcvUDhYaGFyVUNsdTNxbGpU?=
 =?utf-8?B?NkZzUVhobkdwNk1MOWIzbXRWczA4YlpMVHFRVmNYSHk1TjRGUk1vUFRzYjdQ?=
 =?utf-8?B?cVpFaWEzcVJtWXg0OVFVRFlHdmkybXA2WWMxdTl5Q2NiOG1LYUFNME16S1pS?=
 =?utf-8?B?a0NubUd2ZXk5Z1Z1RXdhRytXQWxoRWhHRjByT2ZjT1pYcGU3bEI2TmpxMnRo?=
 =?utf-8?B?YW9SNkFRdVhkUWM3b202Ymg2M0diU0hNQllkZm5mVUl4aDlCaU42UTJmTjMv?=
 =?utf-8?B?QUJva1dzSENTaG1lMCtvbDFiaENJdDFDMUlld0dQaUxFdWt0N1ZFbi9Uc1dE?=
 =?utf-8?B?bUhFSFhCVzgvOWQwWmNqNkJXYk9uYlI1UWU2c3FpdVNGRGxUK212dzllMHNm?=
 =?utf-8?B?bERCVytCRyt0aHJBT3BIVU0yL2JSZXMyZW1jMVBnZExXdnVDTmVZM29mVERC?=
 =?utf-8?B?eUpSaG9TamovcldFbll2R2xHMGt4bXA0MHp1M1FCaUVmSGg0TGZ3VWNsVkR2?=
 =?utf-8?B?djB3MUFwUStHWkczR3ZWb0NhWkxLRDR1OXlxanRFUHIwWVNvMTZ5U1g4NXBO?=
 =?utf-8?B?VTVvdnlxbFI2ZVRJQXVyeHFUTGlMNWhYazEyL2hiblRiNTcwNEljUiswWjhz?=
 =?utf-8?B?Tm1MOW5UYVJQTTFhSENsV3lhdzVxaWRyWGV4UUEwYVlRZ2FJL1BlR0NjTGsr?=
 =?utf-8?B?TFZzSVhvS3l3MFRobGVUbEg4c0JXNmVqd2pIU0ZqRC9ldG1JQ2h4dTdxNFVq?=
 =?utf-8?B?dmMxb0xzUE5lcUpsR2FKd3BoUVNyT2duaFV1TXJsMTRaSTVIVnZEVWE5eVJG?=
 =?utf-8?B?aUVKVGxaMys4Mzl2TXA1K1FmaFFmejlVck4zbVpSWWNFZXNsWjUzZGVnWHo3?=
 =?utf-8?B?Q2RsYisrVnVXeml6YWd0SmxGcjZjSFBQVktERXlFODdaTFFGcFlvbW1Jejhz?=
 =?utf-8?B?eHlzVG1TL0s2dzJuSHVSNGRqL2ZmWlNEa0JBSFpYL2dCczJ1K2ZyYWEvWmVq?=
 =?utf-8?B?UkRFRmNJcS9YSFV0eVVHWktzUlk3aG5ORkF5bi9HdU15eDdyZWI5TkVUZzlu?=
 =?utf-8?B?UGRkZk5waFZyQ1FIRlZ2Vm1ZaXZJdGl0L2VnWHJCUlNwS0Y1RVRpSVBqa1Ra?=
 =?utf-8?B?elljbGlXdU9xS0hURVVJMmlocWgwV3hLZERlVTZjaEdaOVZaTkE0K0RoQzVS?=
 =?utf-8?B?RStkajFzNVFSZEtaODE4RHRBbit1UjJ4Ry9QTTVWZk1jR1EyZXNRMVdXOGdm?=
 =?utf-8?B?U2RidDNpait0dElxbUhCTUpsekF1K0xkbjdYQlcyekxWSW96bVRrRURCdVAv?=
 =?utf-8?B?d3pIVzN0RGVxeCtNaVBGYiswZ1RKcnNHMXYvUnIxSklpd3luV1FyWkF3U0pX?=
 =?utf-8?B?OWt3bldvUE16V0RZUFQwRkZQaGpjTDlnSW1qMnJ3bjBmTmlyeEJHbktnaEIz?=
 =?utf-8?B?Wkx1cis5TDJxUGZGZGR5OGdrT2U2eHg4Skxhc3hrM3dRYmFISm0yR1F6Nm9J?=
 =?utf-8?Q?pFzr47XDeC9R0SfxXC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f2945f-107e-413c-4277-08df3e5090c6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:59:45.9781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+gRbDQJn+Xt835MzctSJv0SzxEEGYhUWpC5Onx6E28apa85SRLM+JE161Yn6PY+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7280

On 11/9/26 03:58, Alistair Popple wrote:
> On 2026-11-07 at 19:57 +1100, Karl Mehltretter <kmehltretter@gmail.com> wrote...
>> On Thu, Nov 05, 2026 at 05:40:41PM +0100, Alistair Popple wrote:
>>> + * A pin or map that fails after dma_buf_mapping_select() may reopen the
>>> + * choice only if it was the one that made it. A selection that predates the
>>> + * call belongs to a live pin or mapping and must survive, otherwise the next
>>> + * pin or map would reselect under it without an invalidate.
>>> + */
>>> +void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
>>> +			      bool was_selected)
>>> +{
>>> +	dma_resv_assert_held(attach->dmabuf->resv);
>>> +
>>> +	if (was_selected)
>>> +		return;
>>> +
>>> +	attach->selected = false;
>>> +	attach->selected_idx = 0;
>>> +}
>>> +
>>
>> After dma_buf_invalidate_mappings(), attach->selected is false while
>> attach->selected_idx still holds that mapping's entry for a pending
>> unmap. 
>>
>> If a pin/map fails before that unmap runs, was_selected is false and
>> dma_buf_mapping_unselect() resets attach->selected_idx to 0.
>>
>> A subsequent dma_buf_unmap_sgt() then uses matches[0].
> 
> Actually there's a bigger issue here. The contract at the moment states that
> mapping type may change after invalidation. However that doesn't account for the
> fact mappings can outlive the invalidation.
> 
> This could be dealt with by switching everything over to the generic
> dma_buf_mapping_map/unmap() path, but that requires an allocation per mapping
> just to track the mapping type.

You need an allocation per mapping anyway to identify the mapping anyway.

We currently abuse the sg_table for that, but essentially the idea of having a structure/object to represent the mapping needs to stay around as far as I can see.

Regards,
Christian.

> 
> The alternate is we update the contract to say mapping type cannot change until
> after all importers have unmapped. Enforcing this would require tracking the
> number of live mappings/pins per-attachment, but I think this is the better
> solution so will add that for the next version.
> 
>>>  int dma_buf_pin(struct dma_buf_attachment *attach)
>>>  {
>>>  	struct dma_buf *dmabuf = attach->dmabuf;
>>> +	bool selected = attach->selected;
>>>  	int ret = 0;
>>>  
>>>  	WARN_ON(!attach->importer_ops);
>>>  
>>>  	dma_resv_assert_held(dmabuf->resv);
>>>  
>>> -	if (dmabuf->ops->pin)
>>> +	ret = dma_buf_mapping_select(attach);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	if (dmabuf->ops->pin) {
>>>  		ret = dmabuf->ops->pin(attach);
>>> +		if (ret)
>>> +			dma_buf_mapping_unselect(attach, selected);
>>> +	}
>>
>> dma_buf_mapping_select() sets attach->selected = true before ops->pin()
>> and the map callbacks run.
>>
>> In patches 14/15, xe/amdgpu migrate a VRAM buffer to system memory
>> during pin and map when the attachment does not accept P2P.
>>
>> That migration calls dma_buf_invalidate_mappings() and clears
>> attach->selected on every attachment, also the one being pinned/mapped. 
>>
>> When the callback succeeds, the attachment stays pinned or mapped with
>> attach->selected == false.
>>
>> A later map/pin on the same attachment can then reselect without an
>> invalidation.
> 
> Argh. Thanks. Will fix.
> 
>  - Alistair
> 
>> Thanks,
>> Karl

