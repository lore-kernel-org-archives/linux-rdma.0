Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112305;
	b=Q1bmL9mPLRWBjPVlVEtFpTbSsuymlpxP1pYZvGQjZzctFC41MIPxiCIkzVDPF223PW3k
	 T//ngzTcytefSyNGaw9ibTQZQxsz+tcRM0wJH05riUpr3Fvmu/dc86keZqGIW5kp84w/k
	 9xr4CpXDy1q6P3/DYH2wGJpAZSBUKSL9/SVXVArGB9Z5HRX6Ydoiti1BsOV8TOmhtAz82
	 5M4unST1vuxL/f6G/Ovdtq5mJkCD+y6Mfp4cglGd6FZzrwTOK2awCaZNTBr8QRmu7yKtV
	 z4c8OH4Qog5F0XhCaprRlifqQaGRRzAR66OKLE165ONl+XzdkoxpAtw6CCw3jZnfPEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112305;
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
	bh=pYpuXu/XlsN9cEXcuXlg/rflwX5JFAfOUOoc3U7esFg=;
	b=ipzgFnRTn2KML1PY/rBorikJoZ0XiekKRUElcL2ypqJIo2PGYGFq6kFkEHCzNCegnN5h
	 pIwVIQ0MX9SZRHIIBIlQ8xZITFPB5xtX/KxabgsT7dQS6XRAl2u84sukuVBA4m3/M73qC
	 4yOPLqZ60GdJ+gFHyoou8Fr7n7uYArg7Y2DxBwPF9LQuiA43mzAnN/s30/Mm7hr5B3lQt
	 HiW79rVIMDs7K6rhLRcFzw61NcXlQah/+Gi32MSjs1dbnhwA1Pom99P0k8FrMETvk4mn+
	 tb4+roMux5MX023oYoIFrTp1+e1Qf3Qb3W4FueRSSHY5Y+eQV46oRGYo10I5tfukYIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RrFsZHhO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.42
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12496606A320;
	Tue, 27 Oct 2026 14:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12496606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RrFsZHhO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyHkG8NHBbIteDUICkW7XJPcTfcEZMcoF24n/xI2DQ9hFyJiRyvmMrrTnpIsIyT0ABVebyvLs6V/X/YLqY1GGAmnq9JrBXPTnjGk82xA953nxzBXjOL6//wrE6TJABDVDP/99CtFrPhNjJl5mFpUvuP/gPpXbYvrbOwnCBMGaP4OiV3L0P4vaRphj4XdvJewisrK6dTh2GvNAIsTmECSNZea5J5u+I/wuX9mDHbJZ3rKD76HwjNzoDdzYlelD5GQ3LmEjt1ruPLNoKanoSQXbs2vzLUEII2yjIayVgo5fwlP4bBC+GF64PrwAkGWhksOKEwsNip4vt9MwE20CPLmUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYpuXu/XlsN9cEXcuXlg/rflwX5JFAfOUOoc3U7esFg=;
 b=JPEnbtF5IZcpGkTgYodH0yu1qulPj5rcd9zChUG42T5ofbgeCwfhEhgC4lzmrMgg17opj4ua0bHv4LtMuCHlYTFVKaASp4ZlHc/dwbKLMESUul5YkLIFqZUqAbwk6VsxD1YXYhcp2qhwekEZ9PQSsERWP3ALVGk64qZK3Yru6/0vAxUggWNVAhVqJRIePGtVnIv6ZlPZlepJSmOj1FULxOT4J1jsrqp+yldlxhd/oT/dozznvN30fi56+q4Ke8NowkEDXzd6Kg3LSLjOOrQRKjwIzaOwUk9G90pyJ3tzPg+DgfCtnrVHTPHXHCLy0vPoBbE8jQOa42aoDpF1ym4Oww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYpuXu/XlsN9cEXcuXlg/rflwX5JFAfOUOoc3U7esFg=;
 b=RrFsZHhOsaIa0O/x5773gHNH31G3X2tv2XOQSQBRZweRpXAad7LqFA5N9B4K7lD0F1wOuwTt0S07IPF29bd2Sp8WG8aUaPx8XMI9GfOgqScduVKbB6jLyO3oIs0vdNQbg0GRBN+K8cKtnaagN6jL1WvhjMUEtJMoXa5Bzs3861FkXEXmatTZ5H2ea185fBkvmV3Bra3LOknA8Ex6R+WWEHJY7j5floXY64+3VyFCC0x1XmXBS+/fx90DwwdBG58pIc7fl6IVTlIoa05ihAkwI2W2nwJ1r4rcslmpeE61gCUhal/8CZQWGC2DtutP/VG3Le9D78FYaVLbejj+iuZDtQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS2PR12MB320397.namprd12.prod.outlook.com
 (2603:10b6:8:70d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:45:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:45:00 +0000
Date: Tue, 27 Oct 2026 11:44:59 -0300
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
Message-ID: <20261027144459.GC2338330@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com>
 <27307d58-9ca9-4624-a564-6e35fb4befb5@amd.com>
 <20261027123859.GE1671235@nvidia.com>
 <3a09ef96-45a6-486f-b482-fd34c27415af@amd.com>
 <20261027140831.GA2338330@nvidia.com>
 <7193d384-5e28-4f85-8004-1dc9318d5c1c@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7193d384-5e28-4f85-8004-1dc9318d5c1c@amd.com>
X-ClientProxiedBy: MN0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:52c::12) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS2PR12MB320397:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e3bcca2-a549-47ba-ddfc-08df3438e094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|261026140227099003|261026130827099003|5023799004|4143699003|11063799006|56012099006|261026121527099003|261021130227099003|261022113327099003|261021123027099003|261021121427099003|261022115727099003|261021135927099003|261022075727099003|261022105027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	AuHsd7wqRHKtQ5Z36OcyhZCsbfQO+GcL+EjrcCW3L4xDXkE/8j2r8/ukrglICQcOIN4y2CKRGS8lDS0Eu+AGHkT7xlBseDhPjI/NT45VyfqRhaN+lgRssv175koumVQ51pK1Mrm92JYuXpiVmqX1wXkXexy7VG1GUKDR5eU0u015wwVJoSTzgg/5Ww+dCGENvXi1h7kQcoyH9DP0bSmKdoOGP+Qs+3MEI+i5Zf5d4gbIZdTBBBMp+C0YdooXhXHmoocYLZkBinFDw91XjZlRfRKKk6gkPa02mAM9WoC426sLjPcySlkpqBGoK7YzlBWn0RLRxtFysZXy/4oHV/xeZcaoWJqKDxt1/pvQtW13FJmFLHCRTKH5k8RDFlLkrA+X0rWctqKH20LidErhiJqH6/TnCyzdw+vH3hxWaXiuQhrdeY+05TPy23DTxO4fcIG9l5vaT7XQ2XWh8ciPjTbAYRpN7R4SkjgI6XAZEFrB/jxTyNZcqP0NjLUM+GM2SXzGAK1zJ03p2a7fIJPQQDMCF/SBvkkqW/d80MN2aNM6i7+gTjuQMCkcCCcAOfEMWGOJFlfG0Zf/c9g0BHVTrlCMCHoQqszu3ZDqqHpzv4W3M1w71oMC3XFk0cfG2C6igJi8PQ/6yaWMjDXGyoHe0cEQQfSbEQkLiRz8Qecg/S19zFg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(261026140227099003)(261026130827099003)(5023799004)(4143699003)(11063799006)(56012099006)(261026121527099003)(261021130227099003)(261022113327099003)(261021123027099003)(261021121427099003)(261022115727099003)(261021135927099003)(261022075727099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wkh4MjdNMkhYdkhRSWlZYUNCU3lpM1pVTFFqLzNZVk84N2QwNnUvV1lhOERt?=
 =?utf-8?B?YUZDRDh0eGoxUTZhdVNSTUFmSWZSOXlBMng4cVRVWGpVYUpiTkZRT0NEN3Q0?=
 =?utf-8?B?WEpBb0xCekpOa0p1c25oRzROeUNuUm05Y0JLV0JYcllxSDlmckdHU1lVaVhS?=
 =?utf-8?B?Q0NaUEF1SG45bGdobHV1TUdFZWN6b2NidnVqN3NCMnFodURBYjlZK1U5SHl1?=
 =?utf-8?B?akZOMGpsdkc2dXh1RFJsZkxPWWpCb2xGNnhiUGRmL2ROdHlaL1dmVEhPcTU4?=
 =?utf-8?B?eGNTa2grWkM1Y1gzMVdVY1lLNmxGU3hYNEFaSll3b0VHNjhnbzU4TmpnYzkr?=
 =?utf-8?B?VUMwaExlb2JMODFNTDhrM0ZpT0hlWGo4UWJNbDdocEpjMVdwamZwaFJteGd6?=
 =?utf-8?B?MXZ4OHI5aDMzOFFmQnUvY1JyWnpSSW1QeEVFTVNHUE5kRlVPeWw4elNGcUlB?=
 =?utf-8?B?Z085VklFU3JjWVZvQ2ZlZXM3NXdmSzZ3V3BhaDluLzVnRTR1Tk9OOWJOUmJ0?=
 =?utf-8?B?WVIvV0t4aktnckhsQkpkaFMrd0sxM3F5alNRN1gzSWZodHJhMm5HUHcvZDM5?=
 =?utf-8?B?S044OGtNYUNiRjIrM0JCNGZHZlJNZW43S2RjRlk5ZEtsV1p3cWF0Qlg2R1Fi?=
 =?utf-8?B?TERuK3RoUEVYMEZFTHhUME8yUWJIOEMyVHUvbU56SUpuTk1XOHhrS01XYk5F?=
 =?utf-8?B?dFZUU204SFFmM3NMa04yWnF3UGtTRC9pWlh3Qm03c1dYZW9tNEZuMWYrVThT?=
 =?utf-8?B?UUR0VXg3MFA0UWdoME12Mk5WZU56VlZaQ3hyTHFtekc5Nk8xRWpwNldtaTg2?=
 =?utf-8?B?QVRKWUFxdk0zWDlraHVnVHc3MnltUkxodzFNUVA0LzRTaHhrN2kxVjJkVVF0?=
 =?utf-8?B?Q1VmY2dmMDdpWVZrTitmeXpVbmhaUURyeGJXK2lsaGdQd3JiY3c4dURNVkdy?=
 =?utf-8?B?SXQyUDA4Z2tFM0lHdFVPN253cXBJVjNmUTNHa3hTU0hRam5YM3pOQWtJTVBw?=
 =?utf-8?B?VjBiMERjTWFzWkhNcTJHdnAxQ2V6aVE5Z1U4M2pxZFZVamZMYjJkYUcvS09w?=
 =?utf-8?B?RHRSYUtBa3pPaTFaaDlXZ0xhQXl2dVBJdC9HQTJuUlBZSmtiNVo0RE5ka1JF?=
 =?utf-8?B?eTFUNkg0NElQelZIeEZJc3VNM0JwTk9Mcmw5L25POFdhcHdHUmc5S1hhV2FK?=
 =?utf-8?B?VHhvMVRGNVlrUjA5cWJkc2d4STBYdXAzZE9xbm5tbXBwOXFyYVJGZWNkRkdH?=
 =?utf-8?B?ME81UDdHTU4xTHVpRE0yYWFzeW82MzZMak41bWxRLzNMdzhFQTBXZzR2dHlB?=
 =?utf-8?B?eGorZ1pZMVo1UFMrMm9LTFlmNEtGelJmV1p0TGpYbllNNytYWjlHcjZ4OEJz?=
 =?utf-8?B?blJENzAwQUJoY0pGaWY4NFNPMUxlZ3FHTXVVKzl2Szl2eUE1R0ZpREEyZjYr?=
 =?utf-8?B?YlFCU0ZtU1lzSjlNL0JPTEtnL2d2SUV6QXUzdW8yaFZaSVB5OGhDNFRJbzJk?=
 =?utf-8?B?UFhUQUNHeFVkRmNvaGZyWGlPQi9adFp0aDIwdkRseldCNVJFVmpFODVuRjBH?=
 =?utf-8?B?bUJEeWdTRW9kVE9zTFI1djlaOHh0RGI5bEgwVFhZMk5qbGJmOXJacFFDUnJs?=
 =?utf-8?B?cHpudnRjVEpyQnBRZ2JjTUF2V3JZR1M0S2lxMFUySm5IUkU1akF5ZzlhTUFR?=
 =?utf-8?B?ZlhScUphcjNkQVI4QnBJTVJLczNDRUhxREJ5RGk0RzhCUmkwRWZMb01JTEhp?=
 =?utf-8?B?SVNGZVIwRDd2STZ2MU1mYllwa1htUklwKzdNYnhlc0ZDZmFiUE1YeEZvdjd0?=
 =?utf-8?B?ZXZidHN4ckU3MlZHSzB6SmZGRTBVWXB6YWdXeldGcEcrQjlJcHZvRzUxZ2ZJ?=
 =?utf-8?B?cm1MRWxWOHI0bEhkTllPK0JXTVF3UVFybVl1RzJISmlnd0I0WithcEd6MGNx?=
 =?utf-8?B?U1VIWC9HajV6b3RZNUJoYjB3dlhWdzdlWUpWcGJqK2UwTm44L2N0aWFXZWkw?=
 =?utf-8?B?T2IvUzFPUEZkaWFiTk1UNVh6WG8rT21KcjhvYStkakhsNVBWQ0N2bGpzcDFF?=
 =?utf-8?B?WDB2WmNpLytBWGVHaStsb29qampRMnVzNFBHUTdES1QwSW04UXlFRm1qRlVq?=
 =?utf-8?B?Zzd6Q1ZjM0RNZTZ6VkFlOVkyaTVnbzMxbkxhZFNwL0llaXkzV1N3N214M2Fw?=
 =?utf-8?B?QmVhTDJDeXc0TnBuajRjUjN1dnBNdG02MFduMnJaeEY3QnRVRzd5bmRMNGFF?=
 =?utf-8?B?ckxZVGZTNEZkODJrb0dVb1ByazZEUi91MjFldUxaQ0tNNThtT2xWMm5BdEIr?=
 =?utf-8?Q?w7mzVdumHWtBcAClyf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3bcca2-a549-47ba-ddfc-08df3438e094
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:45:00.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB+uUy+K1OLaQoKW2tGFeP/kpFXPNmAFqvw3lnCUFk0YnnJo8Z06sE9SfQwfzcwv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB320397

On Tue, Oct 27, 2026 at 03:28:44PM +0100, Christian König wrote:
> On 10/27/26 15:08, Jason Gunthorpe wrote:
> > On Tue, Oct 27, 2026 at 02:17:16PM +0100, Christian König wrote:
> >> On 10/27/26 13:38, Jason Gunthorpe wrote:
> >>> On Tue, Oct 27, 2026 at 01:07:36PM +0100, Christian König wrote:
> >>>> On 10/26/26 06:36, Alistair Popple wrote:
> >>>>> From: Jason Gunthorpe <jgg@nvidia.com>
> >>>>>
> >>>>> This attach function always creates a SGT mapping type importer.
> >>>>
> >>>> Yeah that is a clear NO-GO. The attachment should be the same for
> >>>> the new interface as well.
> >>>
> >>> Not sure I understand this comment...
> >>>
> >>> This was intended as a helper so that existing drivers can run through
> >>> the sgt based mapping type flow without having to open code it. It is
> >>> hardwired to only do sgt like this. If you want to use more than sgt
> >>> as your mapping type don't use this function
> >>>
> >>> The point was to create a clear distinction in the API names when
> >>> things were in a SGT-only flow vs using the newer negotiable flow.
> >>
> >> Well that is my point, the dma_buf_attach() or rather
> >> dynamic_attach() function should still be part of the new flow.
> > 
> > It is, this is just a helper wrapper effectively to run the flow
> > exactly as it is right now wired to only do sgt.
> > 
> > Unless you want to see that open coded in ever driver using the more
> > general functions, I'm not sure I see the alternative?
> 
> I still don't see what you mean.

The function is this:

struct dma_buf_attachment *dma_buf_sgt_attach(struct dma_buf *dmabuf,
					      struct device *dev)
{
	struct dma_buf_mapping_match sgt_match[] = {
		DMA_BUF_IMAPPING_SGT(dev, DMA_SGT_NO_P2P),
	};

	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
				      NULL, NULL);
}
EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_attach, "DMA_BUF");

Which is just a wrapper around the more general attach function,
forcing it to do SGT.

I don't see why we should label a function that can ony do SGT anything
other than under the SGT names.

If you want to get rid of it then the above has to get dropped into
every caller, or something like...

> If a driver can only deal with sgt then it won't implement the
> dma_buf_attach_ops->supported_mapping_types (or whatever we name
> that).
> 
> So if either dma_buf_attach_ops is NULL or
> dma_buf_attach_ops->supported_mapping_types is NULL then we only
> match to the sgt export.

This is basically changing how dma_buf_mapping_attach() works to hard
wire in SGT behaviors. I think this is something you'd regret down the
road as it starts muddling up different concerns..

dma_buf_sgt_attach() is very readable for what the driver is doing,
and grepable. Implicitly doing things when other things are NULL is
more indirect.

> What I want to avoid is to get just another dma_buf_attach() variant
> since we already added a parameter structure here.

It is a pretty standard kernel style to do things like this rather
than expose super APIs with complex signatures to every caller. If
there are many places with the same operation it does tend to help
alot to mark them with a helper function like this.

Jason
