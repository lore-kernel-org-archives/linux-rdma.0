Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793110118;
	b=UFBO0vMiMQf0hl/pjLeuXacwLKln1Drx5J5c+gsBxkRwOJjB8Zd4OX+3dwvAluSOeTo5
	 tJPf/NygkyoiFCrw6EhtcvuQ+RaW9uDLjlR/XBPnqfN40290W38Bnn+96z5wi8b+zdVxM
	 NyPgsw/KC1VElHda9NtmYBDBRtQXP9wlteiK0G/HABGvQB7xH/6CMr54w+WppiwVmbWEG
	 sFJvzHlwYxroCHGUF9hCzS1fuWHIu4QlXIzHa+lRFpec5/0buLaCS9c7RBLvn9/YggeA/
	 CTuZEJb5+zG8h3hJm6ADD8mZba5rnQ/CzK2eltkqek9XsDW7KrFF9staJshQMdVV3PQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110118;
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
	bh=sVce+Q3LSqIo/cT7isK8P02KtriRmZPK2cj8jOTrFEI=;
	b=JwtJno1iE02zE6tCfXqMG0zPvNfQyiKZQw/1MzXyZoJHMhBpr+8lgdGlaWRNmodmEPN7
	 ZnIY8YycyFtfvd83bL6SK6KoMtSvP7Ie9tVFcpzQbpucSYpIW4epZpYA8bQUri+SiEj31
	 7RHYJZ7H709uD/cS4nS3HCdyggdusJAeD+w1Ic7GIZ6MQQ9bpSR87HmEs9bLqHHRHD0lF
	 DHAAm/Ek6VL7qg1Gwr3sEvf4RI1/xSFyBlndK7XVNISwiw66SYa9V3V1bYF1GAEiqUeL/
	 mkHW3i/97o3ieEy3UgJUpNCqUxqe8VYMWUQgnyWGXIxu8vhWNQe3Oomrz4s+KC7zHkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=J+TMQsxP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.59
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283DF606A31A;
	Tue, 27 Oct 2026 14:08:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 283DF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=J+TMQsxP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A7LXzlN9E7Q7p+l4u+GoiDp5c3Xf70TyYr2FbTboY6xH6CpWaVyzousoNbOLAwjLQlt/ZYOZ7up5DlyXsr5kdZ625N7UNTHoO6yw6UxwaKtsV50r0HAY82lOc0cf6EMl/9URx9E7JJZSA3rphUgltW31OWsyI0+KyiJSmH7Pd+e5ba7sr7fqct5gFUS63i5xmNBGN88vr1Sjb6YlFzp/QCYBpZd4nb6TxWEP9OT7xbQqsgWCgiw9jnef74bGwi/xVJgzGVBA/XhcniWLA8I7S1KKU8Q4ZsOq2F2aLtFFDvSptXnHDyf55+xjUJal2HxbD8/1hfsXEOmu+ZH0pf/5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVce+Q3LSqIo/cT7isK8P02KtriRmZPK2cj8jOTrFEI=;
 b=GaZIL7eLOn3FecFfLDQYlWH/k7eiVqIL7Iq4gc2bNONpc+QUA8GvuhXEOKJD5KjG7KqL3kqyG6Ty44JHXPjPYvUDV1pFMmDT7H51GLXMZt1JFzLW6+G4dzDx2B6r5ZEhEBAhAhTBb3W9rJkb2Bc+nTKJduwLiVFc6NbJEXznVssPUuXi/ZAxNH5czKRau5yIZ2cX76m5vbhEqK42VNQ0EWwcLAo08CWkjg9FsJ14yHtFNtJPEX6lMKN1p3TeHRtxnqS13w7dCF81fjtoNHdI56XuUnh2FtZsoZh9IPf1lkEu8zKh213p6KFM5puBYDYHn9mVJBfoQwUa/gaXbGCCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVce+Q3LSqIo/cT7isK8P02KtriRmZPK2cj8jOTrFEI=;
 b=J+TMQsxPk9a9Ow77/nmBwphbOQmdZV2iaJ7PxALDMY486XUKKurXfXiXcrbyFJX/j9GC8U1RuYUXAkMzYp0h0+6uz70vlbVHhNZKn5+SzMhDnlAlWjVkRx1FMxOA7FZeIw2VSrup+xjXS4jhi/XhquPzOxFjT1LR/ouGy1GEjZQlcf86psT8luMH5xlQada0UljSz7L9k/4qjx/0Pc11tlPdekgDCYcGsPSM7iTL6YpX1EZnQGLkAiNgBDtOmVJgKMlojZgQQVtoaAoB+XO9BNgO3EsGmo9i3IIRDiVv77HRSg+AKjV31YSLpCcWSHpajnxHMV+XNNFQL6gdYKnWjg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV2PR12MB5798.namprd12.prod.outlook.com
 (2603:10b6:408:17a::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:08:32 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:08:32 +0000
Date: Tue, 27 Oct 2026 11:08:31 -0300
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
Message-ID: <20261027140831.GA2338330@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
 <20261027123859.GE1671235@nvidia.com>
 <3a09ef96-45a6-486f-b482-fd34c27415af@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a09ef96-45a6-486f-b482-fd34c27415af@amd.com>
X-ClientProxiedBy: YT4PR01CA0421.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::23) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c9fefe3-9fd1-4ddd-0007-08df3433c848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|261026140227099003|5023799004|4143699003|11063799006|56012099006|261022105027099003|261021121427099003|10067099003|18002099003|22082099003|261026121527099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Kj0giZxU+6VCefLeuCgKVNasXtGrPqIa5KzTNXS4ZaZdEWJ/QDoKLBHiDyhlyQHoE7M+FFXREdffL70m9NQHI+Io3pOYZ1ADsB8io/JtslAvWh/RKEBUl+Ewldh+VdHS4qG3pOnLxZx5M3tS3LV3vI6qNzG7pqzn8bbEp3uHuBqPuxrjm3uoCZg0Rdcd+MQCO3ftTNne47IG/dkCaGZI1EE4aWF9nWheTjEmQUgxznYUVkF4dwyfyPVXNnvwJMKFfwdLjQm67bRsoDSqm6pZiSPW4URxoaJmbWwVQM8kZS/JOCjVGIqZf+ECnP0zIRy2rFURqEnkf6aZ3qxSMuL6SMN1yeUUU5devSMnilCVegOCP155BcV58/UvxpgDrE6KBhdEyQBuTQn4A+GaBk5Thyscfb8vqMrmoSq89TyiBiB2bCYWc3TzYj4ac3dKdRLWf34+mZBvom3WLZj/ppUMNfFOM7yviZPuphmwYGfCFrJQOln2WTuaAYOF23B6Runjf+ZR/qI1psVxdPhkYhRWr+U7w6RK5xB1tofQXMqViGuwQHf61niQrX7xEkXHFNoEpYGvsRSX515NXzZD/DptZiwtRQogQT092PV45YoEqXuZKDwU1jb3Z6bR7Mev3RsS/HMpQ6lsXU8j2soVRDkfsP2w0rbrKBLCRDImdBBDYYw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(261026140227099003)(5023799004)(4143699003)(11063799006)(56012099006)(261022105027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(261026121527099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWsraERlTTVZN0d3SXhsZVlIMjFXdHZ2ODhmdG1McUhranRRWU5WaUM3emhm?=
 =?utf-8?B?c1UzUVh6WEVoUWdrSUM3b09PWkxqU0FKZGhDclp2UmhWUENxMHFMT1loWWYy?=
 =?utf-8?B?UXBlVGVmcG01MVlraVMrdmRkaE9GanQvVDE5QzRLRk5GSEs2TFk0T1NCSXY1?=
 =?utf-8?B?VXNna3NxTHZZQXNmMGNObG14UHg1amxHS1g5V3VDVlBXRForQWdqcFBiM3py?=
 =?utf-8?B?MHV1bG1Fb0pwUUxyN2RXU2V1VnNGTEczcVF3VmxmSmpSc2o1bjJneUQxcGZ5?=
 =?utf-8?B?MmJ3dEZXdzVCQ1hja0ZYejBEd1J0SHRFN0NhYlpEZFpGVW1QWW5uVkQ0OHZu?=
 =?utf-8?B?TVQwK2FqZmwxaUhFb0pKNnJvUWFPYjJYeC9vc1BvWGNsV25ST1lpUHU5MDlE?=
 =?utf-8?B?czU0bCs1WjRxY21IMTFENDdBdTgwMTJwRWRMeWtpd3kzeThId2JTQkFiK0Ez?=
 =?utf-8?B?RWdrVHBFRm1PWnNXZ1lnMElqY25PNDJEbUtjNncyWXAwNm8zdi90SGhrY1BL?=
 =?utf-8?B?MHowUFVvTUc0b3NiZWpFUUgzZDl3L0JGY0piTTI2enFJaThxOVFmVVFqYXFT?=
 =?utf-8?B?MEpXWVV3YW5VOHpsWVJ2QTRaZ2FycStocG1oNE8zSG9sakkyd1Rub0pPcVlI?=
 =?utf-8?B?azgxSUtPRHlCdmt4QlkwSDZrZUx3QlBMVG5UMEh4N2pCTVpoQ0wxZlJpeWtY?=
 =?utf-8?B?SWkyZklVZHFsbzRZT3pEYWFGdFNyd0w1NjRLNHhGL09FbzNGUEJwa2ppbnNH?=
 =?utf-8?B?a2xESE1lRXVldVE0a2ZjUm50dld5ZnBLUDdXdXd6dEFNYVN0cVRhVHBwNnY1?=
 =?utf-8?B?bUNrS2tEd3Q4N2ZabTR5YVRQY3hTUGQ0WFA3Qy9uNk1obERETTREU3ZENG5Z?=
 =?utf-8?B?YUlacS9uU2pXanpQdUJWVTN1QjcrZjFVeHMzeW1KK0hpTGZwTXAxOXdmZTVO?=
 =?utf-8?B?TXpwUHdNdXlLdG55YU9ad2lSYVhBRGlkOVJ4OGlobUV2ODBORnpFYkM4Z2ZK?=
 =?utf-8?B?MWpzR01NR3g1N0dwMGxxejR3bWRIelZKVy92aTlMRzZQSUtJYjdHQmtGWGNU?=
 =?utf-8?B?R1ZBclJpMDQ1RDd5dXZoZU1rK0hOc0dudFRMeHhGQWZWUG1YYlZUMEY2eW56?=
 =?utf-8?B?QXZYQm9LakxCOWYvZTkyM1F6OW5yQUJ3Rm5KRHQwK0p1MW1aTkJZbG9Jangz?=
 =?utf-8?B?ZDc1dCs0RDVQMnI1L0M0NVZRREdoMXJuQUg0OXI4T0RPUTkwbHNCTHZzeVRa?=
 =?utf-8?B?T1lIMDMzMDk4Y21UeHFzOWpnclVyajdEQUVnZUJIUjRUMlBybG8wTWZNcXpl?=
 =?utf-8?B?NCtiY1hCaE1uNmZqMnRWQTU5UmtGUGp0YzRoaWVQYVpvTDFwU0NJY09tZHQz?=
 =?utf-8?B?SlhQdS9RWkhhN25KOUZ1VDdaRzRMRDd4NzRmNDNkZGY1MGFlSWxhZTNOd2N1?=
 =?utf-8?B?TGcreG1mT3BIZlFiTTBMV3VCU3hsdVU3NGJJdUxvUHA0MWZMQUEyZXZkL0oz?=
 =?utf-8?B?WFZXYVpETy9TalZqQkcyL0pOK1hlejR6YnROR0Fna2dNdjhHMW1ML3B1VllK?=
 =?utf-8?B?SnNUeldUWjNZUzU0T0NjcjNud2s5ei9WcnA2VnFVZURjUUR5UkJVeFdEZCt0?=
 =?utf-8?B?L2JjZGo5eFhVZld4OFl6VjQ3eTZXRjAyNDZRQlYyaTNBekFISkZreU5TUkJi?=
 =?utf-8?B?T1lkZHcwKzRnYWpRLy9yQTlFVllKTTBFekFiL3k4Z3dJNkpZSWNDMDEzMEhU?=
 =?utf-8?B?czA2UFlPMXJNa2V5N1ZnMWdHQ1RzTXFxSHZEOGJVVzhYcldRTU5oa2RoSjNz?=
 =?utf-8?B?K0o5RkZIcHBaL1V3M3VhT2V0MTU4WDlqbmNFR2dYL2VKaHRDUTdiRUlab0l3?=
 =?utf-8?B?Vlh0bVZmR25TbzEwN1k3Z0ZuejNJUFN2SHFVQjhaNHVrM1V1bkxsQkM5dHZD?=
 =?utf-8?B?ZEoxTkF6K0FoTTVXSk9RVmlLdHVZZG5ENHQ1cFR4eVhhTlA0TndKUUZheS9L?=
 =?utf-8?B?NkhMdndldkVZeElRa0pJdkwwRG5Rdmt6UkxpUTh3enNLdEJRWTBKV05nZFd5?=
 =?utf-8?B?YStTQ0ZaeG02M295dzcvZnRvUDRaQ05iTlpKUWFGOG9veGVCbHpsRFRubUU3?=
 =?utf-8?B?cDdjTWxsTStCREUxMnUzM2dhdXY0d0ZBb09XcktnUTVoSTMzQlRqVUpLZko0?=
 =?utf-8?B?WjJxYnpvdVhjY252bGhDZTlTQkhHSHVmMHptTWxMTWxyZ2hKVjBNdlhpME1V?=
 =?utf-8?B?U1lzT2RjdzJENlI2TXlpbE92Y2diVWR1enYrRjVoQTVUYzE2MHpSMW1kMXZz?=
 =?utf-8?Q?0Ehu0oBDLf2IMKoZS6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9fefe3-9fd1-4ddd-0007-08df3433c848
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:08:31.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SdbjAl/IIUl2wTA44SMOQDrEQho0W8sTD6wV4dcIbDr5LIdJ7EiAau8MJaFdLGm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798

On Tue, Oct 27, 2026 at 02:17:16PM +0100, Christian König wrote:
> On 10/27/26 13:38, Jason Gunthorpe wrote:
> > On Tue, Oct 27, 2026 at 01:07:36PM +0100, Christian König wrote:
> >> On 10/26/26 06:36, Alistair Popple wrote:
> >>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>
> >>> This attach function always creates a SGT mapping type importer.
> >>
> >> Yeah that is a clear NO-GO. The attachment should be the same for
> >> the new interface as well.
> > 
> > Not sure I understand this comment...
> > 
> > This was intended as a helper so that existing drivers can run through
> > the sgt based mapping type flow without having to open code it. It is
> > hardwired to only do sgt like this. If you want to use more than sgt
> > as your mapping type don't use this function
> > 
> > The point was to create a clear distinction in the API names when
> > things were in a SGT-only flow vs using the newer negotiable flow.
> 
> Well that is my point, the dma_buf_attach() or rather
> dynamic_attach() function should still be part of the new flow.

It is, this is just a helper wrapper effectively to run the flow
exactly as it is right now wired to only do sgt.

Unless you want to see that open coded in ever driver using the more
general functions, I'm not sure I see the alternative?

Jason
