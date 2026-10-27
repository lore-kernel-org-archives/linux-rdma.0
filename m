Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793104748;
	b=ciCRhy+2BhLf/MqGftcAW7HDuJeyjLGQ8crMzzi+tquLUPvgXggGSzrNGyElske0rHf/
	 byVG+bzF0hCm5vHgmV7rahA9cjdzN+OVqnOA4Nq3FMc02hQVp2DArc+nximb0IJAfZLYX
	 Jhcuf8jdUpWziqgEJG00diuBbxaNLuE2C+RJudIzmVYlZ/d2o7L3X8d55jT/PXiAPKYVx
	 8sme3O2XstvCklGLLg34bXRaE8qyjSd4Yr4m5Xi69NsCwXWg2YrqUPDmF7tPVNUwIIHLu
	 fLyqp/OP7hyzZ3T5Ku5GagxmNHPMNsApdtaJOcolRJ2fgeW8i3P/hVLRtLHua+5JZ7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104748;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=HziDsGmgK9Gf37+SktFNo49wkeEA9Ry2xyPH26deLYs=;
	b=pesfYHQ+L25Y74ppacRmNJE9iMhUT0UYehkaNobQTJD+R9cWv2FwDw633S33G+iWIjZe
	 lwr9HTWzr8nh9B+n6m9VyRMukAc2DVp108kt/r+6PpS3h31HS7Jxa/YbKaXazYYoQDTxD
	 b/MWajWZNR8C5d8Vbo4+KWmvgxpzHJnUueZVPKSD0O0ppXzBoGWakwUWzQZS56q2zGhIS
	 LWAFzXTWcpDkMAuOuTmiGAxnYahHwDkmOP+Lw/JJUd8zOqRXb5sWSjK0xRLwgYm8Vz2Yx
	 /RFhCQf9c2x7xJi0lPiQjjUSA0RxrZdbneR+BKmRAIIc/MdeSnHpgUj1iBUXJE6omng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k1bhtu35;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF0606A323;
	Tue, 27 Oct 2026 12:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6FF0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=k1bhtu35
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5zYQVaaDRq/8BRlpblbEfEwddZdxLFJ9aohQl3v789ZsQqJIkhZ3+nA8CANtTFcKzFb4uUEag+1wQ8Xrhv3lfGkG7iMo31Mo+N0iv5Rs6lBrPJ2VXrzVmye/58br2JVAZUQlPqY7dXCnzDfaMiVGanvfbsm+RQHl9K20HkSbuj81flSeQyo63lpbR+VMxjUPK3JWdJ8U/X2g9XyujG+VyUvLkK1LipFMANN8CPNhbdMT0jZYLAEXP0xiDHXt/gHuN/f8hnQ537gj4kQneXuNH2X/zBf1XngcJeo/o+asqi4RQl9joYZ42NaWOjyq9Gq+tDbo4FeOrlPOvpfYpj0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HziDsGmgK9Gf37+SktFNo49wkeEA9Ry2xyPH26deLYs=;
 b=gJnqJZGMVjSdsfRp1in9586Pg+52lp06LArAtMG0PSTJ+2dTi8lkgBuarqfI3McaA1eG1rkQ4VqZs+O/zYMBK3zE/cC5iLMBOT2MU0Asx2YW/haSp0TY093yt0uak4uXITvXwiDR7QNwalX7Jp4X5DR41EgF9+NWHy3/zHMrRHRf+YeqaZMpjMaLzKjJ8035RDN5xhF2paj1Hc/w3zS4uE2JGK+KlU8/b6Rjok/t+hyMny/vEP/eLWE0orlxNSw5HjDkqrdWfwAsDpVaZfFLfLksQP32d2Afj/BfRUqWlCsuh4oAK+qWLqvGeW5lTlszLIZ77BxrB7FP+UZN8mR2Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HziDsGmgK9Gf37+SktFNo49wkeEA9Ry2xyPH26deLYs=;
 b=k1bhtu35NcetzH3jUQF+t3rhAJIwNujuTgVYEBXPU0Hie5bIfca9A9SwvyCb1ls/eN3ckzroFWhieQhBWIHQZO7RJmK4o5mCgPMk4l+clweyazwI5biGfILuNi78SX9pWCqgEoQlBk7vX3vsCcQGHcwUpIcJ3ZjEY3Xr7vCIgwn0aYnsgnUtYBERSEgjPf1fWHZyJUTWk42xyK9woDDrcSVP1Ax4MfOCFPfnQQrVUOBUjfURiJ21XMdWyyvdIdnJDSFhJ2wNycAhY8V8qCKFyBXPV7G5tVYdCPA89clQ3IhEfHilEsUmG9Je8tFfK12zgRgx8SdiTg/AHwbf9YOQ8g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB7548.namprd12.prod.outlook.com
 (2603:10b6:610:144::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:39:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:39:00 +0000
Date: Tue, 27 Oct 2026 09:38:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
	sumit.semwal@linaro.org,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com,
	treding@nvidia.com, jhubbard@nvidia.com
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
Message-ID: <20261027123859.GE1671235@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
X-ClientProxiedBy: MN0P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::23) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: ba848c84-75e6-4b89-5207-08df342746bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|261026140227099003|56012099006|11063799006|4143699003|10067099003|261022105027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	ouxHyHteo6Af9DAYY30UBwqgYDBkUk6Nb22Q6a3WKojA5bGgTZR5QTdm5m/4GBEOd2AZNAilXQuQRojaZOgGEsIuvXXc6SqjBDhD1t7DvrvzoMxoL6uQXGN8IegxAh91seomhzTZ9dmp9Zr27PFRFUtMyKfRCwufhKBhzbQwoBY+GYVLgKHzFilR51Aff2g784ONq7BzKFaXoer/9p41zubqeay/74uc+oDmnDRkOxGGUtXpUq+9NcPQbUf7JfrH9Qcv6vnCf4TtXm7Uz4FY3D/qzWDWIB44AD1D/eU6+xENlqnP5yn4GSwKjXFiHzbNOfVh7M7ijKekXxDxSeZQxwHKB258GzvpxBXpw5Af/xd/9EshR5vHjDB10iqSyTukeChVhrXX83DWfb9JXNQzNUNc8mYmp3ms96jUuDSTeahUjrqdGjd6tz6w44gJY1n8ficPIkg6Ql5rvP4sIeSqieNorvE9Hfr0W4prL6LWUxxlt4OwVrugVUdHPA2MTR56ashnKojTcPH3vIWmweMOY4cT/jclrx7bH7aHltI8lbErdml8JufAtf/c55HL87zIiwqkrcUYeVBDHy4DRlx6+RhqS50FkUWERJgVwDXBC8cy1vlePPJgjLJw3V+ymyWebWP4DGhp+/MMmVna0NkicNRjMeqdb3dl1czbtAHURfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(261026140227099003)(56012099006)(11063799006)(4143699003)(10067099003)(261022105027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnFuU2cvRDJQZndzaTA3dFArU3k3Uy9XKzZBNndhNmZpQ1dpVzhYem9LaGli?=
 =?utf-8?B?djRKOWZPS09SelNuNXZQSWVBYUN3NS85bkplVytwRjE4MDh1NzV4T0tFSHY0?=
 =?utf-8?B?VWJhS0JDOGpPRnRwOHF3QkRsUVM1WE52UDlwZGRDM0haczJLQUZ3cWFBYnkz?=
 =?utf-8?B?ekI3bnFMcHczVXZyaVQ3a2QzWCttc1J1UEFXcm95cEUxVHJ4cTlFbzNMNGww?=
 =?utf-8?B?TlNSZk9IVi9mbHN0dGUzZkhjTWhwUmhlNVMxdXVWT3R3dWVsQlZaLzFyNExM?=
 =?utf-8?B?ZDVlNGtmZytMdDAyaUxWZ3RSMERKQVo2OWtDMVhsQmVyTDlObkZZRjg1ZWNC?=
 =?utf-8?B?NWZEVk9UY3hyd2JqcjNJNXVIK0xqSHpVVkEvN1VCYStQUTJxQmtkSDFaby8y?=
 =?utf-8?B?aTdvMHBNamdtYjczT2VBcTh2M2pvUTRZYTV5UFAvNGdSMkorRWdJQ1NWbElv?=
 =?utf-8?B?cnh4bFNtNmp1VUFNU3RyVXp3TklUb1hVYUFjcHROVi83dGdac3pzRms3K3Fx?=
 =?utf-8?B?b08zaWNWMFFlYm02cTdmYTQwUHlXVWJiSHJ5N1NhNms5T0l0UHIvYTFSaXJw?=
 =?utf-8?B?S01vcFErVzJuOVQ1Rm1PQWxYNTgvNURSc2t3REQ4blhNUWYzK2RzVXE3SHpv?=
 =?utf-8?B?TVJtMnhDRGFXWDQxUzRSRjhGREhpM2YwV21jY2l5a1VXSlQ0djAyZm93b2dr?=
 =?utf-8?B?ckVwOWF1UHJURSsrT3dGQ0ZtMEwrQ1VldUsvRUdVWmdpOHlzU3BDdnBMbFFz?=
 =?utf-8?B?dlJlNDFDd2p0Zm8wTHN5SFE2dkgzZi9rL04ydnBzeTkxQzZsL0lTdHh3R0FN?=
 =?utf-8?B?N0J1MjFVcUNJTDBsQzdEOG1SUm1oNWt3aXM5bGpsdHZLdGdnOGZhS2VkKzJE?=
 =?utf-8?B?UXpzaEhRaXZCSDR2WENmbnRuYTRxZTIxaHJYb2ZmdFh2TVN3eUl4dEVtdytn?=
 =?utf-8?B?dkJwUGVhUFpKZ1h3ZjI4SFgzRmxzN1VoSWYxMVBYdkdLWTY1d3VNL2VuVE1H?=
 =?utf-8?B?aHFlQUorMlJ6eHhJdzZGM0hyQURTRGl3WnlFYUx0V1p1M3J1NjVhWk9BZGR6?=
 =?utf-8?B?MDhadGNmTjZESWU1Z1BtN0NDU2xNaVBmcXA4ZC9EZ2tMRDNJVm5wQnVvdHhj?=
 =?utf-8?B?OTU1aUJHQ1ZYTzNZZ3l6WlduSnRCUlF6Z2xIRmI3b0ZGTUcySi91emxhQ1NR?=
 =?utf-8?B?YmxHT25mdW5Ra0gzaU1QNFdEd1Y0Uko5VjJ1a3l3RUZDTmJrUjN1UllvOEVQ?=
 =?utf-8?B?WFVpYXl5RDY0SzFrQVZYNFpad2s5dTZUUTdTMmpxR2RoR1Q1NnpEbnBUbkxT?=
 =?utf-8?B?Ym1tR2E2VkxxVVQvOWp4VTVsWUNmSnlVcUlJSVBqM0h4ZHcyNDZyVkxjYzZI?=
 =?utf-8?B?ckJlNmttemlPSzNOa2hCSnpMZE1hZStEci9zQThqODZSVnljanRGbzAyOEdv?=
 =?utf-8?B?ZE5IV2RvendGVzlDTXN4b0dTL1p4RHFXcjRYN2ZocHBIa3lUMjlESnFVbHhX?=
 =?utf-8?B?K2tINTcvUGY3cnppTkcreWVFL2NsSTNzUC9RMldhL2Y5Wmpac3VhNXBkOEhP?=
 =?utf-8?B?eDYxajZvaUlXZnU5amxXekNrU0tKc3MyTVQxY29qV2UyL0hzaHJuVHJpalVE?=
 =?utf-8?B?SVJzby9XSkswUXlrQmgxMFZZdWJpWDB3U2ZacVZUZEhNR2RETnFXUllkVUZN?=
 =?utf-8?B?YzUxM2Q4bHJaSmNjeGgwcEc1SG05UmlMK2lXQWF4Sy9EaU1BS3d2VWlyblUv?=
 =?utf-8?B?YnBhNCtqOFNta1dvRFhYTzdrSnhEWVcyYm1MdUpBZFd5VGNJeWlVaEVTNUY2?=
 =?utf-8?B?R0NNUnVUeGlMN1dQR0ZIcFg1YmhZNEVXTk1aY0g2M21kY201N2FLaHpUMjFm?=
 =?utf-8?B?bnFUaURRQnErVWtJek5OaXM2ZnhGK2hweFJsK2NhNVFqUEpxV1VudmZzU1hR?=
 =?utf-8?B?SXY0NFMrWnNXNUNoZ0cxYnkzOGp4cm85UWVDYXM5TURVc0VKajl1bnZla3cv?=
 =?utf-8?B?N0VqNVFsWWsyd2JnWXNOZlI1ZEpkSkFTbFJUb0QwOVQzUTZBdzdpTmJ4Qkpi?=
 =?utf-8?B?WVFEQnN6YityR3NpdlJNdjBaVng0ZlVtWXRoRk9ZbnBzRStzdVFDMGhnekVM?=
 =?utf-8?B?WXlCcVdRck9LWCtWZFdRc2dvWnZIQ2xyY2R1elYwK25kMFczbU9WOUpad2dL?=
 =?utf-8?B?eXFXemZvYWhac2VSczNaMmNaWHd3dzNNMkJpQ0dqR1VIR3pXUEEzbDFoMGlp?=
 =?utf-8?B?VE9jb0FwakxTYmhnZzdDTFdhQzR1Ukg1dWR3dWNyUzdrY3BQcW1OMVU5UlRx?=
 =?utf-8?Q?ZqDqhL5G3uBsTKwptY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba848c84-75e6-4b89-5207-08df342746bf
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:39:00.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9lvOFOBrhp1LpevKB0FFkNPeFfo8NeyoJEGpRTivn0hYN/4K5wYDyGHfn7oI41x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

On Tue, Oct 27, 2026 at 01:07:36PM +0100, Christian König wrote:
> On 10/26/26 06:36, Alistair Popple wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > This attach function always creates a SGT mapping type importer.
> 
> Yeah that is a clear NO-GO. The attachment should be the same for
> the new interface as well.

Not sure I understand this comment...

This was intended as a helper so that existing drivers can run through
the sgt based mapping type flow without having to open code it. It is
hardwired to only do sgt like this. If you want to use more than sgt
as your mapping type don't use this function

The point was to create a clear distinction in the API names when
things were in a SGT-only flow vs using the newer negotiable flow.

> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Alistair since you rebased it you should put your SOB on every
patch...

Regards,
Jason
