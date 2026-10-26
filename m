Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993051;
	b=KrVaaOsnIiBxXmDiTEW/6RM+Epu0CjYIDiKXLEoxyMqpU/pxgI0vNxvwPri4NoZ779V4
	 GoACRwYK9A2YzbrcLiyf0SqL5XnrXEP1+RlZsJP4u37TP9UnKBu9WCPUFYaM5o4jH4x82
	 DwpZ0NydlN0ZDY5IZoN6BYCC8e0tK6Ld0Ckbu6fioaqSur1kx9590tFjBqJ1pQZLmjkas
	 WMGBVcWK56Oc4coyWz01ct3joeIRcm/pSlEEemTMqeKf8u5eAFrgBrShzJXGOzhUVSxu3
	 rpEH9AMQN61r8eK9wguCGT0DgMxaXbgDFEJVCxU1J1tV8q0ezWuJW7LjoZmHSp1cxxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993051;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=0YaR0Q/8sQtF37KMr0VhvSkdq8LaZ7MsbrNlL5Mefec=;
	b=D+yuzf2D1vW4on9eUgD+KbbM/AYSR39JY1CZuZuemEH0lLxT/MBX9WPAhaVzLVDq/LEZ
	 yW/D7Qb6XP7zToTngnlh9vG/51xoUodoyu9szXOUn9sfu0EmRLxYiW1fnLoo2B05myXpY
	 p6BYmTVWCZJzFrwSuPn8Lh2Z0HDUm868pPYadV2ojLux2A0X70NJSRvrqPeJIR8ozTDYi
	 vELeuavIqSezmRUO25FVpBLTBcsTOJNzqa1L2+rk6qFMMlemsC19mpviZ4R5Utfg6g0xD
	 Pi3/9EV48x323645jw8PzAA0lpAT0wyg5omcqO72UpTAopsfslRutRIRuycRQdBPV9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lBKLw5en;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.62
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F3160A263C;
	Mon, 26 Oct 2026 05:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58F3160A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lBKLw5en
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBZJRQfxZSbg/SuoaTg+ipUYBCWfdGTSk/mxouEAbNB+5QPMx4Z/9+L8BUM2Yh54f7PuTa9u0JqYPSw17iaWbXg+kEVpUcTDclZzQns8LYiBJmWPFO7YupzeSsGAGs0H5iIigS9zmZB8JrPiK8CzjeGNonIc8IVtoEIuNFhAkJb3C46ikz1SIDwe8E40q8jDQhJmsOe+kFpyfuUJReXiy3OywEdyS2+XFBG+Xr5RINUSFt6+P6X4t9+4+jzfktuMOX9tYKkpriKR6xIQLE86/41b/J+zDgYIpTHnHmQraJiiM98WWpCCGyzZWTNC88uBRZzKuSlm/zIYXYaqf1PmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YaR0Q/8sQtF37KMr0VhvSkdq8LaZ7MsbrNlL5Mefec=;
 b=Y42xtrCuwdByjlUw+/sjwI9nkeaqI92vTJVcgCzmNO7sDotSsqMhmUaeOHaVtaEVzEAkyxVzLEtfLCeHGP83lOTarJOOA7iK1mnjwfWoFKty32MboJFsYOT9tnTHT+v8k2NOyBIcuJXK+gZC2Migsz1fc0BirE9gZERiHxGV325o1dD2UmvpNnxUh0WFbUsc4fPuUXLETBykK/s0ZSBJjeEkx0+Lp6W4F6nT5ZneQoyFKLCNDl9ndQlPbopnkIcqdbTtCZ7BGU4Vn4Bd/gyuZEqcQYd3Xbh9K+u4BsPsnr2vtE85PUAFOqb+z9SaF8Fnp/rFxRNCVdH88OqckMDnfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YaR0Q/8sQtF37KMr0VhvSkdq8LaZ7MsbrNlL5Mefec=;
 b=lBKLw5enD0ZnZnWcVd8/wQdo95BNmcN26oBNczsyYsMT+rOs81lK7yYGPCJOwXwTFIrKJHp6A+XXQici3sZvjnPTx+6i6PXZuQfkM9DbeyzOkQ8HCedxVueEd8maLKlU3Sth5PhIlWYmonkozSkyG6ykE0yjaYsLQM/RlgP/YBvi9r/qf8ZbbSYQEeuky1r5jVeI2iUXJIMIpQkOuB9EfYiC7AW/Dk4BPUUxm0D9uUi4lYgFHLshaN6xHPxSonhuBC7JcZgPzewB3bT5FL4tZ3Yg3pMYaAA4Fb0I/VOqh/rv1qarc7tq+NEWNo+x+2sGRmi1R97v5e9cD78UuI4L8A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:26 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:26 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
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
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 10/26] dma-buf: Convert all the simple exporters to use SGT mapping type
Date: Mon, 26 Oct 2026 16:36:01 +1100
Message-ID: <20261026053623.202642-11-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0040.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::6) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: e3a7bc74-d9fa-46b3-eb45-08df3323377d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009221227099003|261009223027099003|261009221727099003|261009223327099003|261009220027099003|261022113327099003|261021135927099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	EgYeSZrDbrwBcX94yStVp8F6rwr/V5A2A5EBKDghZVokMZlmfwdDTmhv68df+ILLQj8msCvMu7U30GNbHQ88PwfWGY/OAhetIUE56HdzSRU94wGreeaqtPJwTh5faHbv2UpSm7f7oHVzc7K5tfaqNHAx0glgIg+itgQU3wkb60fFx/1AnwTZ/Z87lYsgVrrH0U4EoCcnbRKCM2JlIFfjwAeHbPlP28Ux7VG6DJCsMINIKq49yieVXydp8ASALd7zFzCqlzu03uEq6wEHLWxHO9TROciyEZUW4QFxcalkdU5vJfXx76g1W3WhyLWENusJT8A++aVFIbTJ2sJL3//l5NAzjruMWfqfQq4jv6wl7JBgbFexOpvs06f+Dos+8Ob++drMF0FkiXkaB6OR4mNAqwZU8Mf6qV59dn93F3uGxt8fDCzfy0S6kK+fvCdF3r28/cg52Q5t1FiHdEVAXzukJUuXuPFY3dbQ1eYz2kOqWU6xksgHbj101r+cUuXSNnaDx/Npd26QuEEO2ss7xDyyoVcDt4kArda6nb78xT4lR9OvwWCsX9gFqTK5YJ2IjcDllDPKO1pvAUpUU11/0XKhZWY08KaEB4/UWt5udEdx+n1f/+Amj67AcmYnNgcKyvYG8+Z7neEnc2qm0Taurp2fJDXkE2ztC/WWMsmY+I1XivM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009221227099003)(261009223027099003)(261009221727099003)(261009223327099003)(261009220027099003)(261022113327099003)(261021135927099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGtwYlN1QWo1WllyL2JoQlRNN0xKWEo2SG9LQkdpQ3Q2d0NoOGZkazY1am82?=
 =?utf-8?B?eVZYTzVQTDJ3RmUwZ1VGSGpFWFV6bWoxUzdQdUlVUWlETVpiWi94SjNnSzhD?=
 =?utf-8?B?UXU3bE02WGxUb0c0K3EvdHVZa3Y2dFhsWFNDaWt1Nk1lYzBjbjFKLzlyK3A5?=
 =?utf-8?B?TFFkSGRIUzJGN2lTa3V0c2F6d3NST2taZWRtc29FQ0VOZjJlTElmVk5iNWtl?=
 =?utf-8?B?M1I4bS9FcWc1K2FjOXg3aWpvcVliZGdoaUVPVHJaR08zMUF1ZUdYdTRzcmsz?=
 =?utf-8?B?RTd2TnNTdHpXVkphdEFVV2NnVW04U09TL1grSE5uNi93UHZiZmpobFBqK3Vi?=
 =?utf-8?B?UTRaSmZKS0p6MUhwZFpnTVVITHRWRlpIQnd5YThuWFcyVXZIT3hNUEJqZjVO?=
 =?utf-8?B?WTVMWEFHbkFIdHRidmMxQ0FoZ1FER1J3cjBsb2MyL3R4TWZ0bmg3cEkrcndu?=
 =?utf-8?B?MFkzM2VFUnZCZnMveW93WTVXbFhNZ3kxTWdKTFVIUi9oRk9NTkRWVGY2dTFF?=
 =?utf-8?B?S3RjUUhaWE1RQlkvRDQ1bjlGR2N2ejVnL2V1NGhkb2pvR3NDNXo3TmxDbzlr?=
 =?utf-8?B?b1RvUDdMUTJWcXhOdXZzamFIT0NSYlZSNjMraG9sMXpzemF0Z0NTeGlua3Vm?=
 =?utf-8?B?eWMrRFlLVmxXS3lXZytZbmNlZFdlM01qYWxhRGw1T1ZrcmZmVU5FbGNCUk5K?=
 =?utf-8?B?ZWIxMVpOVi9pRUQwMHVzZkNnQXoveHlkaW9MMHJ4ODBLSzlObDFjVW5iTHhO?=
 =?utf-8?B?OFpHRkJXb1lCOTl3enNWK2lvbzRrZVJvOWdIeGg5ZG95dk5pdjZ0UnAvS3RC?=
 =?utf-8?B?Rmpqa2lXWXlGNER5bWEzR1ZMenUwdVdmSHhlZE0zSFhWUkRlTzJheEkxeXYz?=
 =?utf-8?B?QWFNQzFxa0dsTXBFYk9LK0NTZ1ZHWSsyWFFIc2cyYUVvZDcyb09IakVPZDJt?=
 =?utf-8?B?SDhuY0V2UjBPandyRjhBWHMvTSsxTG8yUEF1UFRHdVUxOGQ2Vk9lYWUvWVZj?=
 =?utf-8?B?Njd4eTQrTjBCTkNjb2tJbnVrUmxpQVZlREpaNXpMV1JpWWNrZzBOQ3VHOE13?=
 =?utf-8?B?TTAvb0d0TnpmRFRuemt2Q0Vpb1pPcE5PMUJWL1JiQ0xJazZ3YzJwSFIvaDJE?=
 =?utf-8?B?UlJHbS9QTDJMSitFVEJScEEwczYxS1FYdTZzNm5UQVhhUmZzbVRjVTFhYkJV?=
 =?utf-8?B?QzFodjFiUlVFdGIxcGMyTXBOK2RBdEpYZ0VvSGRkRDI5NkNOWEt3NWUrNFBQ?=
 =?utf-8?B?YnY5L2RGOHFjUkhDc1VsR2dCbkZ6U2Z2UWFzTDBkaEw5V2hmWkdHYXcrenJn?=
 =?utf-8?B?d0JCWnFIR3l1dkJPaUkxc0t6QTVaTzFHQkZieWt2bW8zMHRoLy8xOUFHK2N2?=
 =?utf-8?B?WHBicXB4VHdHWFludXlOc0UxcEUwMk8wSWdIMTUyUm1RVHdSTTJYV0NlaFR3?=
 =?utf-8?B?QnMvbFA3NURiVGp0NzVkaFJqcHZ3aHd1Q3NsSnVXckZGeWtMd0d2eWFRcVQr?=
 =?utf-8?B?bzJsTzNDNWowb243STRLcEpsUm04andobTBKaHdYY0ZyUFUxK1FaQ04rdnVo?=
 =?utf-8?B?bmJjNDFmd1AyMXhTU3A0RUFxZ2YyZlNLSTFpODMyd3FHT0ZkbzlzMlpUTCtU?=
 =?utf-8?B?ZHkxa3FvVnJIcUNlekNIRFkzK3NROTBqWXlYd3g4WXQ2dEo0MU5odUdlQVpS?=
 =?utf-8?B?Y21LNUhYanhZMkh1aFFpRVlqL3FJaEtySitnSjVoVEJ2V3NNdVNTbjkveC9n?=
 =?utf-8?B?NUVlVmxoQnhQNkJ3VUt4dlljQzZMNWEyUUNMM0ZSV3BXeGRCZ3UvR0l1QWQr?=
 =?utf-8?B?R2VlK0RrUWFiTktLdEVrNUhMNEc1c1hpeDEreFZYN1BjeEs1QlA2Q2g2a1JJ?=
 =?utf-8?B?NHFBUjJUY2NUQjhFWFVHKzd1RHBLZmpZandBVllZVm5lQ2xqWnVmaUxuNUpX?=
 =?utf-8?B?Q2k4N0VDYzdDeUhNUkY0TVgxdm9kQmhhNktaZXhNUWU2SWJvU3VEb2pvaXUv?=
 =?utf-8?B?U1UxcFc3QTJJUXdQejM2bkFSbzhzZldMTEREbmliVi9UOWF3M0hEanNWVHdQ?=
 =?utf-8?B?c0pVdUkrclgzNXJoTTR1VlBFZFJMdTVKRzNsTkhKM1psWEl4eVFNRFovTW1O?=
 =?utf-8?B?RTAvWGpyaUwvWmRadk1aTURKOFJkQnNBT24xTGpsSko4WHg1TjBDaWhaN2ta?=
 =?utf-8?B?MWl3ZFJ3QWNuc3diV0JyM3k0N2FnNEcxSG03OWVvVUJBZlZSWkNUZlo2SjJk?=
 =?utf-8?B?bkRPNEM5N0JHeEFFSklHZHhvblczTWd5WnJYN0szUEJ0ZFc3Qy9zOHJqbjFq?=
 =?utf-8?B?Ry9TYkNuQzhReWxjMkZQVUVqcUlYS1pLWHE3czFHbkZVMTZOaUJrZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a7bc74-d9fa-46b3-eb45-08df3323377d
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:26.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tM1f/Ti4vi1+KPswgST8YSbe5w0F25YruL5tJVpoYnvT/E3ez/3I+2wHNEb0Ii/WlMec3NChu3XujCRHZNvs8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Update the exporters to use a SGT mapping type and the new style mapping
type API. None of these exporters do anything with attach->peer2peer or
importer_ops->allow_peer2peer and they all follow the same pattern.

Change all the places that need to get the SGT's DMA device for DMA API
use to use dma_buf_sgt_dma_device().

This is all a mechanical change of moving the map_dma_buf/unmap_dma_buf
into DMA_BUF_SIMPLE_SGT_EXP_MATCH() arguments and switching
attach->dev to dma_buf_sgt_dma_device(attach).

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ added converters for newly added amdxdna, panfrost and panthor exporters - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_cbuf.c          |  8 ++++----
 drivers/accel/amdxdna/amdxdna_gem.c           |  5 +++--
 drivers/accel/amdxdna/amdxdna_ubuf.c          |  8 ++++----
 drivers/accel/ivpu/ivpu_gem_userptr.c         | 11 +++++++----
 drivers/dma-buf/heaps/cma_heap.c              | 12 +++++++-----
 drivers/dma-buf/heaps/system_heap.c           | 13 ++++++++-----
 drivers/dma-buf/udmabuf.c                     |  8 ++++----
 drivers/gpu/drm/armada/armada_gem.c           | 12 +++++++-----
 drivers/gpu/drm/drm_prime.c                   |  9 +++++----
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c    |  8 +++++---
 .../gpu/drm/i915/gem/selftests/mock_dmabuf.c  |  8 ++++----
 drivers/gpu/drm/msm/msm_gem_prime.c           |  7 +++++--
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |  5 +++--
 drivers/gpu/drm/panfrost/panfrost_gem.c       | 13 +++++++++----
 drivers/gpu/drm/panthor/panthor_gem.c         | 11 +++++++----
 drivers/gpu/drm/tegra/gem.c                   | 12 +++++++-----
 drivers/gpu/drm/virtio/virtgpu_prime.c        | 11 +++++++----
 drivers/iommu/iommufd/selftest.c              | 18 +++---------------
 .../common/videobuf2/videobuf2-dma-contig.c   | 15 ++++++++-------
 .../media/common/videobuf2/videobuf2-dma-sg.c | 14 +++++++++-----
 .../common/videobuf2/videobuf2-vmalloc.c      | 13 ++++++++-----
 drivers/misc/fastrpc.c                        | 12 +++++++-----
 drivers/tee/tee_heap.c                        | 13 +++++++------
 drivers/xen/gntdev-dmabuf.c                   | 19 +++++++++++--------
 samples/vfio-mdev/mbochs.c                    | 10 +++++-----
 sound/soc/fsl/fsl_asrc_m2m.c                  | 12 +++++++-----
 26 files changed, 161 insertions(+), 126 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_cbuf.c b/drivers/accel/amdxdna/amdxdna_cbuf.c
index a504560aae98..2070a371903d 100644
--- a/drivers/accel/amdxdna/amdxdna_cbuf.c
+++ b/drivers/accel/amdxdna/amdxdna_cbuf.c
@@ -5,6 +5,7 @@
 
 #include <drm/drm_mm.h>
 #include <drm/drm_prime.h>
+#include <linux/dma-buf-mapping.h>
 
 #include "amdxdna_cbuf.h"
 #include "amdxdna_pci_drv.h"
@@ -85,7 +86,7 @@ static struct sg_table *amdxdna_cbuf_map(struct dma_buf_attachment *attach,
 					 enum dma_data_direction direction)
 {
 	struct amdxdna_cbuf_priv *cbuf = attach->dmabuf->priv;
-	struct device *dev = attach->dev;
+	struct device *dev = dma_buf_sgt_dma_device(attach);
 	struct scatterlist *sgl, *sg;
 	int ret, n_entries, i;
 	struct sg_table *sgt;
@@ -140,7 +141,7 @@ static void amdxdna_cbuf_unmap(struct dma_buf_attachment *attach,
 			       struct sg_table *sgt,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_resource(attach->dev, sg_dma_address(sgt->sgl),
+	dma_unmap_resource(dma_buf_sgt_dma_device(attach), sg_dma_address(sgt->sgl),
 			   drm_prime_get_contiguous_size(sgt), direction,
 			   DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
@@ -210,12 +211,11 @@ static void amdxdna_cbuf_vunmap(struct dma_buf *dbuf, struct iosys_map *map)
 }
 
 static const struct dma_buf_ops amdxdna_cbuf_dmabuf_ops = {
-	.map_dma_buf = amdxdna_cbuf_map,
-	.unmap_dma_buf = amdxdna_cbuf_unmap,
 	.release = amdxdna_cbuf_release,
 	.mmap = amdxdna_cbuf_mmap,
 	.vmap = amdxdna_cbuf_vmap,
 	.vunmap = amdxdna_cbuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_cbuf_map, amdxdna_cbuf_unmap),
 };
 
 static int amdxdna_cbuf_clear(struct dma_buf *dbuf)
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 4b0d58d0329b..6253a720cc22 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -11,6 +11,7 @@
 #include <drm/drm_print.h>
 #include <drm/gpu_scheduler.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-direct.h>
 #include <linux/iosys-map.h>
 #include <linux/pagemap.h>
@@ -559,12 +560,12 @@ static int amdxdna_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struc
 static const struct dma_buf_ops amdxdna_dmabuf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = amdxdna_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int flags)
diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 0e0cd69cd1fb..b81f947712e8 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -7,6 +7,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_print.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -36,7 +37,7 @@ static struct sg_table *amdxdna_ubuf_map(struct dma_buf_attachment *attach,
 	if (ret)
 		goto err_free_sg;
 
-	ret = dma_map_sgtable(attach->dev, sg, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
 	if (ret)
 		goto err_free_table;
 
@@ -53,7 +54,7 @@ static void amdxdna_ubuf_unmap(struct dma_buf_attachment *attach,
 			       struct sg_table *sg,
 			       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attach->dev, sg, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sg, direction, 0);
 	sg_free_table(sg);
 	kfree(sg);
 }
@@ -70,9 +71,8 @@ static void amdxdna_ubuf_release(struct dma_buf *dbuf)
 }
 
 static const struct dma_buf_ops amdxdna_ubuf_dmabuf_ops = {
-	.map_dma_buf = amdxdna_ubuf_map,
-	.unmap_dma_buf = amdxdna_ubuf_unmap,
 	.release = amdxdna_ubuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdxdna_ubuf_map, amdxdna_ubuf_unmap),
 };
 
 struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
diff --git a/drivers/accel/ivpu/ivpu_gem_userptr.c b/drivers/accel/ivpu/ivpu_gem_userptr.c
index 7cbf3a4cdc73..7ca9d8d4f5a8 100644
--- a/drivers/accel/ivpu/ivpu_gem_userptr.c
+++ b/drivers/accel/ivpu/ivpu_gem_userptr.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
@@ -26,7 +27,8 @@ ivpu_gem_userptr_dmabuf_map(struct dma_buf_attachment *attachment,
 	struct sg_table *sgt = attachment->dmabuf->priv;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, sgt, direction, DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), sgt,
+			      direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -37,7 +39,8 @@ static void ivpu_gem_userptr_dmabuf_unmap(struct dma_buf_attachment *attachment,
 					  struct sg_table *sgt,
 					  enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attachment->dev, sgt, direction, DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), sgt, direction,
+			  DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 static void ivpu_gem_userptr_dmabuf_release(struct dma_buf *dma_buf)
@@ -56,9 +59,9 @@ static void ivpu_gem_userptr_dmabuf_release(struct dma_buf *dma_buf)
 }
 
 static const struct dma_buf_ops ivpu_gem_userptr_dmabuf_ops = {
-	.map_dma_buf = ivpu_gem_userptr_dmabuf_map,
-	.unmap_dma_buf = ivpu_gem_userptr_dmabuf_unmap,
 	.release = ivpu_gem_userptr_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(ivpu_gem_userptr_dmabuf_map,
+				     ivpu_gem_userptr_dmabuf_unmap),
 };
 
 static struct dma_buf *
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 3fb4b946c91a..fa05c242f238 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -14,6 +14,7 @@
 
 #include <linux/cma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/dma-map-ops.h>
 #include <linux/err.h>
@@ -73,7 +74,7 @@ static int cma_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 
@@ -107,7 +108,8 @@ static struct sg_table *cma_heap_map_dma_buf(struct dma_buf_attachment *attachme
 	struct sg_table *table = &a->table;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, table, direction, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, 0);
 	if (ret)
 		return ERR_PTR(-ENOMEM);
 	a->mapped = true;
@@ -121,7 +123,8 @@ static void cma_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
+			  0);
 }
 
 static int cma_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -268,14 +271,13 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
 static const struct dma_buf_ops cma_heap_buf_ops = {
 	.attach = cma_heap_attach,
 	.detach = cma_heap_detach,
-	.map_dma_buf = cma_heap_map_dma_buf,
-	.unmap_dma_buf = cma_heap_unmap_dma_buf,
 	.begin_cpu_access = cma_heap_dma_buf_begin_cpu_access,
 	.end_cpu_access = cma_heap_dma_buf_end_cpu_access,
 	.mmap = cma_heap_mmap,
 	.vmap = cma_heap_vmap,
 	.vunmap = cma_heap_vunmap,
 	.release = cma_heap_dma_buf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(cma_heap_map_dma_buf, cma_heap_unmap_dma_buf),
 };
 
 static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..e954238463d4 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -12,6 +12,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/err.h>
@@ -128,7 +129,7 @@ static int system_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->list);
 	a->mapped = false;
 	a->cc_shared = buffer->cc_shared;
@@ -165,7 +166,8 @@ static struct sg_table *system_heap_map_dma_buf(struct dma_buf_attachment *attac
 	int ret;
 
 	attrs = cc_shared_buffer(a) ? DMA_ATTR_CC_SHARED : 0;
-	ret = dma_map_sgtable(attachment->dev, table, direction, attrs);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table,
+			      direction, attrs);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -180,7 +182,8 @@ static void system_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 	struct dma_heap_attachment *a = attachment->priv;
 
 	a->mapped = false;
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
+			  0);
 }
 
 static int system_heap_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
@@ -365,14 +368,14 @@ static void system_heap_dma_buf_release(struct dma_buf *dmabuf)
 static const struct dma_buf_ops system_heap_buf_ops = {
 	.attach = system_heap_attach,
 	.detach = system_heap_detach,
-	.map_dma_buf = system_heap_map_dma_buf,
-	.unmap_dma_buf = system_heap_unmap_dma_buf,
 	.begin_cpu_access = system_heap_dma_buf_begin_cpu_access,
 	.end_cpu_access = system_heap_dma_buf_end_cpu_access,
 	.mmap = system_heap_mmap,
 	.vmap = system_heap_vmap,
 	.vunmap = system_heap_vunmap,
 	.release = system_heap_dma_buf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(system_heap_map_dma_buf,
+				     system_heap_unmap_dma_buf),
 };
 
 static struct page *alloc_largest_available(unsigned long size,
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index df6dd0046242..911a3fa347b3 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -2,6 +2,7 @@
 #include <linux/cred.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -168,14 +169,14 @@ static void put_sg_table(struct device *dev, struct sg_table *sg,
 static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
 				    enum dma_data_direction direction)
 {
-	return get_sg_table(at->dev, at->dmabuf, direction);
+	return get_sg_table(dma_buf_sgt_dma_device(at), at->dmabuf, direction);
 }
 
 static void unmap_udmabuf(struct dma_buf_attachment *at,
 			  struct sg_table *sg,
 			  enum dma_data_direction direction)
 {
-	return put_sg_table(at->dev, sg, direction);
+	return put_sg_table(dma_buf_sgt_dma_device(at), sg, direction);
 }
 
 static void unpin_all_folios(struct udmabuf *ubuf)
@@ -256,14 +257,13 @@ static int end_cpu_udmabuf(struct dma_buf *buf,
 }
 
 static const struct dma_buf_ops udmabuf_ops = {
-	.map_dma_buf	   = map_udmabuf,
-	.unmap_dma_buf	   = unmap_udmabuf,
 	.release	   = release_udmabuf,
 	.mmap		   = mmap_udmabuf,
 	.vmap		   = vmap_udmabuf,
 	.vunmap		   = vunmap_udmabuf,
 	.begin_cpu_access  = begin_cpu_udmabuf,
 	.end_cpu_access    = end_cpu_udmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(map_udmabuf, unmap_udmabuf),
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index da7335cbe82d..5cea1eab6e5c 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/mman.h>
 #include <linux/shmem_fs.h>
@@ -387,6 +388,7 @@ static struct sg_table *
 armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 	enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct armada_gem_object *dobj = drm_to_armada_gem(obj);
 	struct scatterlist *sg;
@@ -417,7 +419,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			sg_set_page(sg, page, PAGE_SIZE, 0);
 		}
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto release;
 	} else if (dobj->page) {
 		/* Single contiguous page */
@@ -426,7 +428,7 @@ armada_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 
 		sg_set_page(sgt->sgl, dobj->page, dobj->obj.size, 0);
 
-		if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+		if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 			goto free_table;
 	} else if (dobj->linear) {
 		/* Single contiguous physical region - no struct page */
@@ -458,7 +460,7 @@ static void armada_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
 	int i;
 
 	if (!dobj->linear)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir, 0);
 
 	if (dobj->obj.filp) {
 		struct scatterlist *sg;
@@ -478,10 +480,10 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
 }
 
 static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
-	.map_dma_buf	= armada_gem_prime_map_dma_buf,
-	.unmap_dma_buf	= armada_gem_prime_unmap_dma_buf,
 	.release	= drm_gem_dmabuf_release,
 	.mmap		= armada_gem_dmabuf_mmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(armada_gem_prime_map_dma_buf,
+				     armada_gem_prime_unmap_dma_buf),
 };
 
 struct dma_buf *
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index cf53b8cab4da..d797598e42f7 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -693,7 +693,7 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	if (IS_ERR(sgt))
 		return sgt;
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir,
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
 			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret) {
 		sg_free_table(sgt);
@@ -720,7 +720,8 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
 	if (!sgt)
 		return;
 
-	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
+			  DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
 	kfree(sgt);
 }
@@ -840,12 +841,12 @@ EXPORT_SYMBOL(drm_gem_dmabuf_mmap);
 static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 /**
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index b43d34c7d641..5333e77e62e0 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 #include <linux/dma-resv.h>
 #include <linux/module.h>
@@ -52,7 +53,8 @@ static struct sg_table *i915_gem_map_dma_buf(struct dma_buf_attachment *attach,
 		dst = sg_next(dst);
 	}
 
-	ret = dma_map_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir,
+			      DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		goto err_free_sg;
 
@@ -203,14 +205,14 @@ static void i915_gem_dmabuf_detach(struct dma_buf *dmabuf,
 static const struct dma_buf_ops i915_dmabuf_ops =  {
 	.attach = i915_gem_dmabuf_attach,
 	.detach = i915_gem_dmabuf_detach,
-	.map_dma_buf = i915_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = i915_gem_dmabuf_mmap,
 	.vmap = i915_gem_dmabuf_vmap,
 	.vunmap = i915_gem_dmabuf_vunmap,
 	.begin_cpu_access = i915_gem_begin_cpu_access,
 	.end_cpu_access = i915_gem_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(i915_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct dma_buf *i915_gem_prime_export(struct drm_gem_object *gem_obj, int flags)
diff --git a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
index f2863da7f5c1..911d8f59011a 100644
--- a/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c
@@ -4,6 +4,7 @@
  * Copyright © 2016 Intel Corporation
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/vmalloc.h>
 #include "mock_dmabuf.h"
 
@@ -29,7 +30,7 @@ static struct sg_table *mock_map_dma_buf(struct dma_buf_attachment *attachment,
 		sg = sg_next(sg);
 	}
 
-	err = dma_map_sgtable(attachment->dev, st, dir, 0);
+	err = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
 	if (err)
 		goto err_st;
 
@@ -46,7 +47,7 @@ static void mock_unmap_dma_buf(struct dma_buf_attachment *attachment,
 			       struct sg_table *st,
 			       enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attachment->dev, st, dir, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), st, dir, 0);
 	sg_free_table(st);
 	kfree(st);
 }
@@ -88,12 +89,11 @@ static int mock_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
 }
 
 static const struct dma_buf_ops mock_dmabuf_ops =  {
-	.map_dma_buf = mock_map_dma_buf,
-	.unmap_dma_buf = mock_unmap_dma_buf,
 	.release = mock_dmabuf_release,
 	.mmap = mock_dmabuf_mmap,
 	.vmap = mock_dmabuf_vmap,
 	.vunmap = mock_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mock_map_dma_buf, mock_unmap_dma_buf),
 };
 
 static struct dma_buf *mock_dmabuf(int npages)
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index beb7f22fd694..46cccbe5f378 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 
 #include <drm/drm_drv.h>
 #include <drm/drm_prime.h>
@@ -54,12 +55,12 @@ static void msm_gem_dmabuf_release(struct dma_buf *dma_buf)
 static const struct dma_buf_ops msm_gem_prime_dmabuf_ops =  {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = drm_gem_map_dma_buf,
-	.unmap_dma_buf = drm_gem_unmap_dma_buf,
 	.release = msm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(drm_gem_map_dma_buf,
+				     drm_gem_unmap_dma_buf),
 };
 
 struct drm_gem_object *msm_gem_prime_import(struct drm_device *dev,
@@ -132,3 +133,5 @@ void msm_gem_prime_unpin(struct drm_gem_object *obj)
 
 	msm_gem_unpin_pages_locked(obj);
 }
+
+MODULE_IMPORT_NS("DMA_BUF");
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 30cf1cdc1aa3..23beaeefab67 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/highmem.h>
 
 #include <drm/drm_prime.h>
@@ -69,12 +70,12 @@ static int omap_gem_dmabuf_mmap(struct dma_buf *buffer,
 }
 
 static const struct dma_buf_ops omap_dmabuf_ops = {
-	.map_dma_buf = omap_gem_map_dma_buf,
-	.unmap_dma_buf = omap_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = omap_gem_dmabuf_begin_cpu_access,
 	.end_cpu_access = omap_gem_dmabuf_end_cpu_access,
 	.mmap = omap_gem_dmabuf_mmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(omap_gem_map_dma_buf,
+				     omap_gem_unmap_dma_buf),
 };
 
 struct dma_buf *omap_gem_prime_export(struct drm_gem_object *obj, int flags)
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 3a7fce428898..b1ce00989be4 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 
 #include <drm/panfrost_drm.h>
@@ -15,6 +16,8 @@
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 
+MODULE_IMPORT_NS("DMA_BUF");
+
 void panfrost_gem_init(struct panfrost_device *pfdev)
 {
 	int err;
@@ -318,7 +321,8 @@ panfrost_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -339,7 +343,8 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (shmem->vaddr)
@@ -355,14 +360,14 @@ panfrost_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panfrost_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panfrost_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panfrost_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panfrost_gem_prime_begin_cpu_access,
 	.end_cpu_access = panfrost_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panfrost_gem_prime_map_dma_buf,
+				     panfrost_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 72908be5e144..4478a37562e6 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -7,6 +7,7 @@
 #include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -512,7 +513,8 @@ panthor_gem_prime_begin_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_cpu(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_cpu(dma_buf_sgt_dma_device(attach),
+						 sgt, dir);
 	}
 	dma_resv_unlock(obj->resv);
 
@@ -533,7 +535,8 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 		struct sg_table *sgt = attach->priv;
 
 		if (sgt)
-			dma_sync_sgtable_for_device(attach->dev, sgt, dir);
+			dma_sync_sgtable_for_device(dma_buf_sgt_dma_device(attach),
+						    sgt, dir);
 	}
 
 	if (bo->cmap.vaddr)
@@ -549,14 +552,14 @@ panthor_gem_prime_end_cpu_access(struct dma_buf *dma_buf,
 static const struct dma_buf_ops panthor_dma_buf_ops = {
 	.attach = drm_gem_map_attach,
 	.detach = drm_gem_map_detach,
-	.map_dma_buf = panthor_gem_prime_map_dma_buf,
-	.unmap_dma_buf = panthor_gem_prime_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
 	.begin_cpu_access = panthor_gem_prime_begin_cpu_access,
 	.end_cpu_access = panthor_gem_prime_end_cpu_access,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(panthor_gem_prime_map_dma_buf,
+				     panthor_gem_prime_unmap_dma_buf),
 };
 
 static struct dma_buf *
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index f76af733ea79..feb783ceb0d1 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -630,6 +631,7 @@ static struct sg_table *
 tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 			    enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *gem = attach->dmabuf->priv;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 	struct sg_table *sgt;
@@ -643,12 +645,12 @@ tegra_gem_prime_map_dma_buf(struct dma_buf_attachment *attach,
 					      0, gem->size, GFP_KERNEL) < 0)
 			goto free;
 	} else {
-		if (dma_get_sgtable(attach->dev, sgt, bo->vaddr, bo->iova,
+		if (dma_get_sgtable(dma_dev, sgt, bo->vaddr, bo->iova,
 				    gem->size) < 0)
 			goto free;
 	}
 
-	if (dma_map_sgtable(attach->dev, sgt, dir, 0))
+	if (dma_map_sgtable(dma_dev, sgt, dir, 0))
 		goto free;
 
 	return sgt;
@@ -667,7 +669,7 @@ static void tegra_gem_prime_unmap_dma_buf(struct dma_buf_attachment *attach,
 	struct tegra_bo *bo = to_tegra_bo(gem);
 
 	if (bo->pages)
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), sgt, dir, 0);
 
 	sg_free_table(sgt);
 	kfree(sgt);
@@ -740,14 +742,14 @@ static void tegra_gem_prime_vunmap(struct dma_buf *buf, struct iosys_map *map)
 }
 
 static const struct dma_buf_ops tegra_gem_prime_dmabuf_ops = {
-	.map_dma_buf = tegra_gem_prime_map_dma_buf,
-	.unmap_dma_buf = tegra_gem_prime_unmap_dma_buf,
 	.release = tegra_gem_prime_release,
 	.begin_cpu_access = tegra_gem_prime_begin_cpu_access,
 	.end_cpu_access = tegra_gem_prime_end_cpu_access,
 	.mmap = tegra_gem_prime_mmap,
 	.vmap = tegra_gem_prime_vmap,
 	.vunmap = tegra_gem_prime_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(tegra_gem_prime_map_dma_buf,
+				     tegra_gem_prime_unmap_dma_buf),
 };
 
 struct dma_buf *tegra_gem_prime_export(struct drm_gem_object *gem,
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index ebf471044d06..3d5203ac19b6 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -24,6 +24,7 @@
 
 #include <drm/drm_prime.h>
 #include <drm/drm_print.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/virtio_dma_buf.h>
 
 #include "virtgpu_drv.h"
@@ -54,7 +55,8 @@ virtgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
 	if (virtio_gpu_is_vram(bo))
-		return virtio_gpu_vram_map_dma_buf(bo, attach->dev, dir);
+		return virtio_gpu_vram_map_dma_buf(
+			bo, dma_buf_sgt_dma_device(attach), dir);
 
 	return drm_gem_map_dma_buf(attach, dir);
 }
@@ -67,7 +69,8 @@ static void virtgpu_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
 	struct virtio_gpu_object *bo = gem_to_virtio_gpu_obj(obj);
 
 	if (virtio_gpu_is_vram(bo)) {
-		virtio_gpu_vram_unmap_dma_buf(attach->dev, sgt, dir);
+		virtio_gpu_vram_unmap_dma_buf(dma_buf_sgt_dma_device(attach),
+					      sgt, dir);
 		return;
 	}
 
@@ -78,12 +81,12 @@ static const struct virtio_dma_buf_ops virtgpu_dmabuf_ops =  {
 	.ops = {
 		.attach = virtio_dma_buf_attach,
 		.detach = drm_gem_map_detach,
-		.map_dma_buf = virtgpu_gem_map_dma_buf,
-		.unmap_dma_buf = virtgpu_gem_unmap_dma_buf,
 		.release = drm_gem_dmabuf_release,
 		.mmap = drm_gem_dmabuf_mmap,
 		.vmap = drm_gem_dmabuf_vmap,
 		.vunmap = drm_gem_dmabuf_vunmap,
+		DMA_BUF_SIMPLE_SGT_EXP_MATCH(virtgpu_gem_map_dma_buf,
+					     virtgpu_gem_unmap_dma_buf),
 	},
 	.device_attach = drm_gem_map_attach,
 	.get_uuid = virtgpu_virtio_get_uuid,
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index f6da927461b5..f8afbbeb360f 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -6,6 +6,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/fault-inject.h>
 #include <linux/file.h>
@@ -1962,17 +1963,6 @@ struct iommufd_test_dma_buf {
 	bool revoked;
 };
 
-static int iommufd_test_dma_buf_attach(struct dma_buf *dmabuf,
-				       struct dma_buf_attachment *attachment)
-{
-	return 0;
-}
-
-static void iommufd_test_dma_buf_detach(struct dma_buf *dmabuf,
-					struct dma_buf_attachment *attachment)
-{
-}
-
 static struct sg_table *
 iommufd_test_dma_buf_map(struct dma_buf_attachment *attachment,
 			 enum dma_data_direction dir)
@@ -1995,11 +1985,9 @@ static void iommufd_test_dma_buf_release(struct dma_buf *dmabuf)
 }
 
 static const struct dma_buf_ops iommufd_test_dmabuf_ops = {
-	.attach = iommufd_test_dma_buf_attach,
-	.detach = iommufd_test_dma_buf_detach,
-	.map_dma_buf = iommufd_test_dma_buf_map,
 	.release = iommufd_test_dma_buf_release,
-	.unmap_dma_buf = iommufd_test_dma_buf_unmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(iommufd_test_dma_buf_map,
+				     iommufd_test_dma_buf_unmap),
 };
 
 int iommufd_test_dma_buf_iommufd_map(struct dma_buf_attachment *attachment,
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 9ce6284cd5f2..536f839258c6 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/refcount.h>
 #include <linux/scatterlist.h>
@@ -372,8 +373,8 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
 		 * memory locations do not require any explicit cache
 		 * maintenance prior or after being used by the device.
 		 */
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir,
-				  DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -392,8 +393,8 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir,
-				  DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
 		attach->dma_dir = DMA_NONE;
 	}
 
@@ -401,7 +402,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
 	 * mapping to the client with new direction, no cache sync
 	 * required see comment in vb2_dc_dmabuf_ops_detach()
 	 */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir,
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(db_attach), sgt, dma_dir,
 			    DMA_ATTR_SKIP_CPU_SYNC)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
@@ -462,13 +463,13 @@ static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_dc_dmabuf_ops = {
 	.attach = vb2_dc_dmabuf_ops_attach,
 	.detach = vb2_dc_dmabuf_ops_detach,
-	.map_dma_buf = vb2_dc_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
 	.begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
 	.end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dc_dmabuf_ops_vmap,
 	.mmap = vb2_dc_dmabuf_ops_mmap,
 	.release = vb2_dc_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_dc_dmabuf_ops_map,
+				     vb2_dc_dmabuf_ops_unmap),
 };
 
 static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index b1d0695cda26..fba2027e6e8d 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/refcount.h>
@@ -417,7 +418,8 @@ static void vb2_dma_sg_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -436,12 +438,14 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir, 0)) {
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(db_attach), sgt, dma_dir,
+			    0)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
 	}
@@ -510,13 +514,13 @@ static int vb2_dma_sg_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_dma_sg_dmabuf_ops = {
 	.attach = vb2_dma_sg_dmabuf_ops_attach,
 	.detach = vb2_dma_sg_dmabuf_ops_detach,
-	.map_dma_buf = vb2_dma_sg_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_dma_sg_dmabuf_ops_unmap,
 	.begin_cpu_access = vb2_dma_sg_dmabuf_ops_begin_cpu_access,
 	.end_cpu_access = vb2_dma_sg_dmabuf_ops_end_cpu_access,
 	.vmap = vb2_dma_sg_dmabuf_ops_vmap,
 	.mmap = vb2_dma_sg_dmabuf_ops_mmap,
 	.release = vb2_dma_sg_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_dma_sg_dmabuf_ops_map,
+				     vb2_dma_sg_dmabuf_ops_unmap),
 };
 
 static struct dma_buf *vb2_dma_sg_get_dmabuf(struct vb2_buffer *vb,
diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
index 63f023696f3e..d79acf83286a 100644
--- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
+++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -261,7 +262,8 @@ static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
 
 	/* release the scatterlist cache */
 	if (attach->dma_dir != DMA_NONE)
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_buf_sgt_dma_device(db_attach), sgt,
+				  attach->dma_dir, 0);
 	sg_free_table(sgt);
 	kfree(attach);
 	db_attach->priv = NULL;
@@ -270,6 +272,7 @@ static void vb2_vmalloc_dmabuf_ops_detach(struct dma_buf *dbuf,
 static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(db_attach);
 	struct vb2_vmalloc_attachment *attach = db_attach->priv;
 	struct sg_table *sgt;
 
@@ -280,12 +283,12 @@ static struct sg_table *vb2_vmalloc_dmabuf_ops_map(
 
 	/* release any previous cache */
 	if (attach->dma_dir != DMA_NONE) {
-		dma_unmap_sgtable(db_attach->dev, sgt, attach->dma_dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, attach->dma_dir, 0);
 		attach->dma_dir = DMA_NONE;
 	}
 
 	/* mapping to the client with new direction */
-	if (dma_map_sgtable(db_attach->dev, sgt, dma_dir, 0)) {
+	if (dma_map_sgtable(dma_dev, sgt, dma_dir, 0)) {
 		pr_err("failed to map scatterlist\n");
 		return ERR_PTR(-EIO);
 	}
@@ -326,11 +329,11 @@ static int vb2_vmalloc_dmabuf_ops_mmap(struct dma_buf *dbuf,
 static const struct dma_buf_ops vb2_vmalloc_dmabuf_ops = {
 	.attach = vb2_vmalloc_dmabuf_ops_attach,
 	.detach = vb2_vmalloc_dmabuf_ops_detach,
-	.map_dma_buf = vb2_vmalloc_dmabuf_ops_map,
-	.unmap_dma_buf = vb2_vmalloc_dmabuf_ops_unmap,
 	.vmap = vb2_vmalloc_dmabuf_ops_vmap,
 	.mmap = vb2_vmalloc_dmabuf_ops_mmap,
 	.release = vb2_vmalloc_dmabuf_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vb2_vmalloc_dmabuf_ops_map,
+				     vb2_vmalloc_dmabuf_ops_unmap),
 };
 
 static struct dma_buf *vb2_vmalloc_get_dmabuf(struct vb2_buffer *vb,
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index d4fac2caca86..85fed3a12f9c 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -5,6 +5,7 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/idr.h>
@@ -778,7 +779,8 @@ fastrpc_map_dma_buf(struct dma_buf_attachment *attachment,
 
 	table = &a->sgt;
 
-	ret = dma_map_sgtable(attachment->dev, table, dir, 0);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), table, dir,
+			      0);
 	if (ret)
 		table = ERR_PTR(ret);
 	return table;
@@ -788,7 +790,7 @@ static void fastrpc_unmap_dma_buf(struct dma_buf_attachment *attach,
 				  struct sg_table *table,
 				  enum dma_data_direction dir)
 {
-	dma_unmap_sgtable(attach->dev, table, dir, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attach), table, dir, 0);
 }
 
 static void fastrpc_release(struct dma_buf *dmabuf)
@@ -818,7 +820,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 		return -EINVAL;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	INIT_LIST_HEAD(&a->node);
 	attachment->priv = a;
 
@@ -866,11 +868,11 @@ static int fastrpc_mmap(struct dma_buf *dmabuf,
 static const struct dma_buf_ops fastrpc_dma_buf_ops = {
 	.attach = fastrpc_dma_buf_attach,
 	.detach = fastrpc_dma_buf_detatch,
-	.map_dma_buf = fastrpc_map_dma_buf,
-	.unmap_dma_buf = fastrpc_unmap_dma_buf,
 	.mmap = fastrpc_mmap,
 	.vmap = fastrpc_vmap,
 	.release = fastrpc_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(fastrpc_map_dma_buf,
+				     fastrpc_unmap_dma_buf),
 };
 
 static dma_addr_t fastrpc_compute_dma_addr(struct fastrpc_user *fl, dma_addr_t sg_dma_addr)
diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
index 007c00156520..099b153087a3 100644
--- a/drivers/tee/tee_heap.c
+++ b/drivers/tee/tee_heap.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-heap.h>
 #include <linux/genalloc.h>
 #include <linux/module.h>
@@ -104,7 +105,7 @@ static int tee_heap_attach(struct dma_buf *dmabuf,
 		return ret;
 	}
 
-	a->dev = attachment->dev;
+	a->dev = dma_buf_sgt_dma_device(attachment);
 	attachment->priv = a;
 
 	return 0;
@@ -126,8 +127,8 @@ tee_heap_map_dma_buf(struct dma_buf_attachment *attachment,
 	struct tee_heap_attachment *a = attachment->priv;
 	int ret;
 
-	ret = dma_map_sgtable(attachment->dev, &a->table, direction,
-			      DMA_ATTR_SKIP_CPU_SYNC);
+	ret = dma_map_sgtable(dma_buf_sgt_dma_device(attachment), &a->table,
+			      direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -142,7 +143,7 @@ static void tee_heap_unmap_dma_buf(struct dma_buf_attachment *attachment,
 
 	WARN_ON(&a->table != table);
 
-	dma_unmap_sgtable(attachment->dev, table, direction,
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction,
 			  DMA_ATTR_SKIP_CPU_SYNC);
 }
 
@@ -160,9 +161,9 @@ static void tee_heap_buf_free(struct dma_buf *dmabuf)
 static const struct dma_buf_ops tee_heap_buf_ops = {
 	.attach = tee_heap_attach,
 	.detach = tee_heap_detach,
-	.map_dma_buf = tee_heap_map_dma_buf,
-	.unmap_dma_buf = tee_heap_unmap_dma_buf,
 	.release = tee_heap_buf_free,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(tee_heap_map_dma_buf,
+				     tee_heap_unmap_dma_buf),
 };
 
 static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 83b0df460894..028cd7295fd7 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-direct.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -241,9 +242,10 @@ static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
 
 		if (sgt) {
 			if (gntdev_dmabuf_attach->dir != DMA_NONE)
-				dma_unmap_sgtable(attach->dev, sgt,
-						  gntdev_dmabuf_attach->dir,
-						  DMA_ATTR_SKIP_CPU_SYNC);
+				dma_unmap_sgtable(
+					dma_buf_sgt_dma_device(attach), sgt,
+					gntdev_dmabuf_attach->dir,
+					DMA_ATTR_SKIP_CPU_SYNC);
 			sg_free_table(sgt);
 		}
 
@@ -257,12 +259,13 @@ static struct sg_table *
 dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 			   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach = attach->priv;
 	struct gntdev_dmabuf *gntdev_dmabuf = attach->dmabuf->priv;
 	struct sg_table *sgt;
 
 	pr_debug("Mapping %d pages for dev %p\n", gntdev_dmabuf->nr_pages,
-		 attach->dev);
+		 dma_dev);
 
 	if (dir == DMA_NONE || !gntdev_dmabuf_attach)
 		return ERR_PTR(-EINVAL);
@@ -281,7 +284,7 @@ dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 	sgt = dmabuf_pages_to_sgt(gntdev_dmabuf->pages,
 				  gntdev_dmabuf->nr_pages);
 	if (!IS_ERR(sgt)) {
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC)) {
 			sg_free_table(sgt);
 			kfree(sgt);
@@ -292,7 +295,7 @@ dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
 		}
 	}
 	if (IS_ERR(sgt))
-		pr_debug("Failed to map sg table for dev %p\n", attach->dev);
+		pr_debug("Failed to map sg table for dev %p\n", dma_dev);
 	return sgt;
 }
 
@@ -338,9 +341,9 @@ static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
 static const struct dma_buf_ops dmabuf_exp_ops =  {
 	.attach = dmabuf_exp_ops_attach,
 	.detach = dmabuf_exp_ops_detach,
-	.map_dma_buf = dmabuf_exp_ops_map_dma_buf,
-	.unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
 	.release = dmabuf_exp_ops_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(dmabuf_exp_ops_map_dma_buf,
+				     dmabuf_exp_ops_unmap_dma_buf),
 };
 
 struct gntdev_dmabuf_export_args {
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 64ea19253ee3..c2eaa14b9ddd 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -32,6 +32,7 @@
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
 #include <linux/highmem.h>
+#include <linux/dma-buf-mapping.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_rect.h>
 #include <drm/drm_modeset_lock.h>
@@ -872,7 +873,7 @@ static struct sg_table *mbochs_map_dmabuf(struct dma_buf_attachment *at,
 	if (sg_alloc_table_from_pages(sg, dmabuf->pages, dmabuf->pagecount,
 				      0, dmabuf->mode.size, GFP_KERNEL) < 0)
 		goto err2;
-	if (dma_map_sgtable(at->dev, sg, direction, 0))
+	if (dma_map_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0))
 		goto err3;
 
 	return sg;
@@ -894,7 +895,7 @@ static void mbochs_unmap_dmabuf(struct dma_buf_attachment *at,
 
 	dev_dbg(dev, "%s: %d\n", __func__, dmabuf->id);
 
-	dma_unmap_sgtable(at->dev, sg, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(at), sg, direction, 0);
 	sg_free_table(sg);
 	kfree(sg);
 }
@@ -918,11 +919,10 @@ static void mbochs_release_dmabuf(struct dma_buf *buf)
 	mutex_unlock(&mdev_state->ops_lock);
 }
 
-static struct dma_buf_ops mbochs_dmabuf_ops = {
-	.map_dma_buf	  = mbochs_map_dmabuf,
-	.unmap_dma_buf	  = mbochs_unmap_dmabuf,
+static const struct dma_buf_ops mbochs_dmabuf_ops = {
 	.release	  = mbochs_release_dmabuf,
 	.mmap		  = mbochs_mmap_dmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(mbochs_map_dmabuf, mbochs_unmap_dmabuf),
 };
 
 static struct mbochs_dmabuf *mbochs_dmabuf_alloc(struct mdev_state *mdev_state,
diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
index 4bc40f328f58..63cee7b2c206 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -7,6 +7,7 @@
 
 #include <linux/dma/imx-dma.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_runtime.h>
 #include <sound/asound.h>
@@ -417,6 +418,7 @@ static int fsl_asrc_m2m_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
 static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *attachment,
 						 enum dma_data_direction direction)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attachment);
 	struct snd_dma_buffer *dmab = attachment->dmabuf->priv;
 	struct sg_table *sgt;
 
@@ -424,10 +426,10 @@ static struct sg_table *fsl_asrc_m2m_map_dma_buf(struct dma_buf_attachment *atta
 	if (!sgt)
 		return NULL;
 
-	if (dma_get_sgtable(attachment->dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
+	if (dma_get_sgtable(dma_dev, sgt, dmab->area, dmab->addr, dmab->bytes) < 0)
 		goto free;
 
-	if (dma_map_sgtable(attachment->dev, sgt, direction, 0))
+	if (dma_map_sgtable(dma_dev, sgt, direction, 0))
 		goto free;
 
 	return sgt;
@@ -442,7 +444,7 @@ static void fsl_asrc_m2m_unmap_dma_buf(struct dma_buf_attachment *attachment,
 				       struct sg_table *table,
 				       enum dma_data_direction direction)
 {
-	dma_unmap_sgtable(attachment->dev, table, direction, 0);
+	dma_unmap_sgtable(dma_buf_sgt_dma_device(attachment), table, direction, 0);
 }
 
 static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
@@ -452,9 +454,9 @@ static void fsl_asrc_m2m_release(struct dma_buf *dmabuf)
 
 static const struct dma_buf_ops fsl_asrc_m2m_dma_buf_ops = {
 	.mmap = fsl_asrc_m2m_mmap,
-	.map_dma_buf = fsl_asrc_m2m_map_dma_buf,
-	.unmap_dma_buf = fsl_asrc_m2m_unmap_dma_buf,
 	.release = fsl_asrc_m2m_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(fsl_asrc_m2m_map_dma_buf,
+				     fsl_asrc_m2m_unmap_dma_buf),
 };
 
 static int fsl_asrc_m2m_comp_task_create(struct snd_compr_stream *stream,
-- 
2.54.0

