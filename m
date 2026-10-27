Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793102770;
	b=mGqp5Z2TOWGqxrBuuCewapYaCi+9NF67VaoDzYqB8FTkZ4xgl/XEGOjER6YP0fpSyG+b
	 Eea5FAKU1tJmnlJm1CT6ZAv5Bc6lSjHzyK+NiAvdsp5gsMhVpcCKY7BolWsGwk/4d6UcD
	 zuJ9U3iGxVrBcskgq7xwyMfuPvJT+c1qXRfk8yJEyxWfzqgh8t6frorL7hyHDQXTfHwcX
	 fzdGmJYgs5cb6cqee6rlGSZc42qkxupcDw3oVquhJD35vNugzBiof9HsKUwPLsIQRdZfD
	 ui9l8YkTulHjpXyHrDrN0Z9T1pUxz7pghnufJvTKprwDfcMV5cFTaE4PZO62vJio4ww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793102770;
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
	bh=CUV4Br7Ca8wHwPrF+dwgtoKmnLHAP3rbbWCKAPurOO0=;
	b=2KsmJDx+dF3ptmO0wY/eJJrXcNaiJ/OSvmpn1o8PR3dmVkrMPOIt5SIAQypOCqXrsSqY
	 gswYlzfoTcCHB7CQJ1hZHzFUT/jJwkxeuOZAHXMLKXenUNLWUq/Ob8NHNFJq1Uz9l2c/N
	 ZIzkp+gLNsi/wmh2cKxRRwret60iCn/7gSTuEWeJ9iYhYt2aLZSALKBHsWm0K+YAONzfa
	 qJGPMozlLTTihGfapEABGGWA/5XfKNO/2VcMK6f7cQQPb9CO0sp9SnFPggBGpxx7DvI8k
	 dOuVNKV1MMQQ5TBwkeQ7SSFZS38GMyzlhIgZWcKW4rGEHQCFMkpEyfsQNx/SQNwC7lA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=n3MI1MGV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.42
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DC8606A31B;
	Tue, 27 Oct 2026 12:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0DC8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=n3MI1MGV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CimoqBVaSa4/USRfg/e9ZlN5usX+HNhhnNXOM/t5TJwvlZrMG/Ceuz00uGgHBF48PflTHCf5k2Zo6bhsvA7AodyNhSdNuC9L2Wf/qm307BuO4DrpfuFr2kmJ9Ev4VYpWZBdp234XQaurE0TfRkEcItiuWoefevLMeuT7y+PT2Itoj5TEB5cuJVkNWjL7nBZuZX25z5IxsebUAfnOQUD7N2SckPZ4yfT61sRJgvCHRQwk+fU9pMJ9VWFv1NbT7dEcNQeDdqqzXVktI2epVMWS4YYtDJz4S+GNsVQ/QCurqaiRvZoU1Rn7d+JN6OhAJOBP4RbcfkEAxTBRtySH8AzQJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUV4Br7Ca8wHwPrF+dwgtoKmnLHAP3rbbWCKAPurOO0=;
 b=vl1pDbL2sK22H6AuNKXissL/rXXhgVAQvD8v11eO2hDXvdOsPzIqbmwcDnn3BlIAHuFFo6/0snmQDXpPmBikuHsFyUzFjz8FLiEhjoVHcagxg1EO9TAe5GfKFtMKLkrfIWCpRSavxrno5p4fm+fxDLqimOa9ELQ7193DY22ciEpEa0aPDI6+D07j4JMgNfDdILUMYuQM7Ye3SBEJ1dm2eo2cUsSuC4cGOy9k4swsoS53SI8soaulrtnPpmGUdKo6lswzVc9SBfJOtCm0A9hBaAi3Ns3UX4J+xibgcCckyMLHot98ahRDDuLO04jPRDNFxh5gDzQVZ8hBzoRZRnG5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUV4Br7Ca8wHwPrF+dwgtoKmnLHAP3rbbWCKAPurOO0=;
 b=n3MI1MGVuXGwBgF+r2eI3Z4bhGYeG54CxBXelfco/HZSQklgs5iK8hnS09v8Xg7cu34pkzPYRjPOrHJ3WRtduXruzZItL+HeWxSe2Zt/upy7h+y5ix0E3b+FS2SNEJA4H0uw3glXeOr04XkdnKVBYN3pXWntSBBLT97eMM9kPIc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DSVPR12MB999172.namprd12.prod.outlook.com (2603:10b6:8:38b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:06:02 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:06:02 +0000
Message-ID: <3151a820-c583-4968-8440-673a9e390446@amd.com>
Date: Tue, 27 Oct 2026 13:05:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/26] treewide: Rename dma_buf_map_attachment(_unlocked)
 to dma_buf_sgt_
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
 <20261026053623.202642-22-apopple@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261026053623.202642-22-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::22) To PH7PR12MB5685.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 883f6f9a-1e8e-415d-2f43-08df3422ab6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261009220027099003|261009223327099003|261009221227099003|261022105027099003|261009223027099003|261009221727099003|261022075727099003|261021123027099003|261021121427099003|10067099003|56012099006|261026140227099003|6133799003|18002099003|22082099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	vzs5s5FLgEL8M08g22mEhF9xfmIjw077zhHMhRhEvSN1/IE4HQui7ykEogJB7OY54Ugh+hgLePNRWSLYUuswvN7gi07shf/DicPB9RURAPC4S5TLHb4cGxvykA742o99fJTTe1T/43oCpwY4NW14NcQq7PwX4ijG75AlCKf4unORclLV3oodOK0/l+70EAbDZoBVZ8Ps38NAho+vr5Cb0jpdPmrr7gSM4noBXBlB6sOMahMUOdzOgULsYSFsc/ol55x7Vvg4uMzrmx/7xfWJIgidkwgrz8HZo+ubw3XM3XzVTR8SrIK6K+it7/qRX8eG+7UFqGoiO/cKKpGFWUYxhN2/H5R4WJop8uy6iV79RBZUGXSGchtgy3nZtKtJUljF3GnrjWycS7x2i3QiuBhwTKwnUqUtcFF+OJ15q2Tj6yYUPdVRjiggb8vL4NvmSuJD1CjkuPsiLHjilcrkczW8E1mmLiDuM+LV10FE+yvEDoY076e5xQq+zGof3AGh2uFthHW4jd6g1KUd/3Zgfd5ZNFRTHUWzZqP7DCEVbUKhDwcAOkZhlf8XJNHcNO8rVhEod+fHZkjN97XsPqxL8Hvlke87K2GO8Zl4m/anrwOnetw+ijPWS3OfH2yDx6z++KpOFUDkNnnL8NNq/aD20UE8tSPHndib4F2byi6FKBT0YG4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261009220027099003)(261009223327099003)(261009221227099003)(261022105027099003)(261009223027099003)(261009221727099003)(261022075727099003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(261026140227099003)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2diaTVLSUd3aXVDK0ZZbVJwUVdTSjdUckV4ckpLUHp4bDFwMjFjeVBleUIx?=
 =?utf-8?B?dVVlS3BtUTFBbW8xL3NTeG96KzlpZ0Q0b0daaW4wN3drS2ZHR04ycVRQOHdj?=
 =?utf-8?B?NytGaFhhR29JaUdralpkZW5kYUR2VUIyZUdwdTU3VmNtZXpUbHFGc1ZiTHhT?=
 =?utf-8?B?Ly93L0NkMUhOSURBbThXZTl1SGlUcU9XeGE0cmY2ZlF3ckdCaXdhbE5tS0ZP?=
 =?utf-8?B?Ui9jTHJBbXF5Sndtc0h4a0JTS1l6WEF0ZWdPbmtEajdKSmIya3RzYjJ2cWp4?=
 =?utf-8?B?U3JZMitFMHJTUm4xZDZaV1JtVmwvd3hpYUhZenhEZEFyTm5KZ3V3S3NvdEFZ?=
 =?utf-8?B?ai8rcVlEeFVQcmprTzFGditjcmZjSjZJMlJtQ0dweUR3amlLZEN2eTJDKzh1?=
 =?utf-8?B?aGhxS1AzN0t2enExSHJ3NlMwVEg4d1BBOU9WaHVIVkZQWXU4TzhQUXpGNjlL?=
 =?utf-8?B?UWJZRllmYmlkd3M2NHpFK1JsaG13N1NoYXVxejlhaUNYS0lQNG1RUUdhd0RK?=
 =?utf-8?B?WEZmYy9PcnlDUHgxcm1hTUZ0YWYzSDl5RnowSldmK0ZaQnJWbW00N3NKL2tB?=
 =?utf-8?B?cEZsdnQ1eFljdi9rd2gvQUw0Q0RqVy9uM3l6d2FhWmxBdmtYMjNMaGlrN3l2?=
 =?utf-8?B?Yjl2Y0VxeTFoRm5mMldpM1l3d016Q3lpSzkyYUVVOWpIT1VoWWI4dFJsckVU?=
 =?utf-8?B?OGk5M0x3OUpsZ0pUZGJmL0lkckFUTnJwaENxUzkxdWdRVkRjUis4N0RSb2M5?=
 =?utf-8?B?RVI3VnJUWHhqS0t2Vnp1WkNDY0czK25iMHozc0pGdUcvdW1lckFHNGNKUHYw?=
 =?utf-8?B?OXh5NWtxWTVEajg4WC9MMHU2a3hWUnU1eXRrWHlKdW1sc0JBaGw3YTlJLzlh?=
 =?utf-8?B?MG9UVFY0U0RsVzJmMGtRSjRsN1FkU1BvdkFNcGtpcDFod0g5S2FRd29VWktG?=
 =?utf-8?B?L0phUjNKQStURWNHN2k4MmhhV0NHcWROWGh0bDhpUkZsbUt5RGhheFFXRENC?=
 =?utf-8?B?QlRWbVNaei84YU0vZC9QbjdtRkxCUnRaZDZBYVBwWWxWL0ZXK0R2S09TOXFK?=
 =?utf-8?B?bG90VCt3MEFTYU1tSW5wUnBnaHZITFdDc1hiZlRiQmlDakRCQ080UzEwUDBS?=
 =?utf-8?B?ZkJOTHczT3dGRHVEUGRHTXJRM2sxdnBRdHNEUFU0c0FlR0FOdFRzaG5BcWVY?=
 =?utf-8?B?RjdnRDYybVYvckRwME5UZDVrZ2NmaUN4SXdEY25qV0dOdTA5TXV3N2xqWGJG?=
 =?utf-8?B?aUN1L2g3TEtIaldxQmNoNC9hN0lIMkczRXN1SWt1Wko2aHN2OGFxWE4rcnI0?=
 =?utf-8?B?eFh6NmpyQkU3dUUxano3bVZDVTFPS3hOa095Y1Bzdml4VWZZdnNQY0ZJNGRx?=
 =?utf-8?B?Q1kxZmUrRyt4RHlYZVBNSTcvUUM1S3hPZVk1TkZSd05aU1NjVTNtd24yNC9Y?=
 =?utf-8?B?NzBXZDF2R2kxZ2dCTDVHVWR0bTJXQVRFZ2pYQjR3Um50ZUhqZE9BN20xb0NE?=
 =?utf-8?B?Y3RUUFJBTmJ3STNXSzR4NFNyQkhwNnpScU1NWmFDelNZbGFUL0RwZmQ3Tmhp?=
 =?utf-8?B?N2lzRCsxanVHenplakYyTU9zZzhOY1JJN3FtRnNsNy9vUjh3WXNpeXVsWjJq?=
 =?utf-8?B?cDYvenZicjFuSjNIbjZLbHh6Y3l1eWpPRFlqTkt0eWo1QW1DTHNSa3ZnYmZr?=
 =?utf-8?B?ckpwYTdyTGlhQngwYWVVTVJ3TlFtUFlNeWdUYmx6WXhNN0hJcEN4Ri9IcWd3?=
 =?utf-8?B?M0NrbjFaaDVaYkpjYnZxeDFwczhURTBhdzJ2RkNSUTM2bGtOVkFtZSswT3hT?=
 =?utf-8?B?ZWdRRFFudGRBTjdYakdDUG42NFRnYXluOHl3SFJEL0tkeXFPU2Ftbm5mM0tl?=
 =?utf-8?B?ZWdicmhKTGRTbDBuRGhqcEp5eEZOV2RTVXhySTFua0tyVFhvQkt3NnFHUkt3?=
 =?utf-8?B?cUpTVkZhMnQ0R25ZRU4veXI5ZTlZYUczbjRZcnBONWRHR1dYQWJxWHE3cjV1?=
 =?utf-8?B?SkR2UmNnMCt3Njc1SGJLUXpiYnQ3ZE5yUUtuQmRhdEd2QkIrTGJYZktTVlFE?=
 =?utf-8?B?d3R5amtqcUdHS09vSUg5Y1R5VkE5MzR1YXdLbTgrUUEzUXRoR3gyVE9UcHp5?=
 =?utf-8?B?RHB1MVJXNnBHaEVUOE1Sa2piWU1LR0lIV2F3dDM4dEJPSWdQRXMxQ21Na0NX?=
 =?utf-8?B?MXgrajJ3V3p4OWF2NmtNcWJ2RzBTR1JxNjFyeWRpWlA1YnJsblFFZXNqMklw?=
 =?utf-8?B?dUw5dkRrdGlhcW9Ld3d0N2RoMW9RejM4akcyWnZMNFlKSEkvaTVraWJPTm4z?=
 =?utf-8?Q?ESEUafNztzMCV4cC1C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883f6f9a-1e8e-415d-2f43-08df3422ab6f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:06:02.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxpRtpWyrx5JF7QngGjoa+N0ElvH5yL3DMSONuMOFGiEQ0A8aKxm2XxC3Bsz2LUw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999172

On 10/26/26 06:36, Alistair Popple wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> This map function only works with SGT importers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [ also rename the io_uring zcrx caller, which the unmap rename
>   used to pick up, so that this commit builds with CONFIG_IO_URING_ZCRX - apopple ]
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

I would make that the first patch in the set since dropping sgt from the interface is probably something everybody can agree on.

And sqash that together with renaming dma_buf_unmap_attachment().

Regarding the new name I think dma_buf_sgt_(un)map_attachment() is a bit long and has the sgt at the wrong location.

I would name the functions dma_buf_map_sgt() and dma_buf_unmap_sgt().

Regards,
Christian.

> ---
>  drivers/accel/amdxdna/amdxdna_gem.c           |  2 +-
>  drivers/accel/ivpu/ivpu_gem.c                 |  3 +-
>  drivers/accel/qaic/qaic_data.c                |  4 +--
>  drivers/dma-buf/dma-buf.c                     | 28 +++++++++----------
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |  3 +-
>  drivers/gpu/drm/armada/armada_gem.c           | 14 ++++++----
>  drivers/gpu/drm/drm_prime.c                   |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c    |  4 +--
>  .../drm/i915/gem/selftests/i915_gem_dmabuf.c  |  3 +-
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |  2 +-
>  drivers/gpu/drm/tegra/gem.c                   |  6 ++--
>  drivers/gpu/drm/virtio/virtgpu_prime.c        |  2 +-
>  drivers/gpu/drm/xe/xe_bo.c                    |  2 +-
>  drivers/iio/industrialio-buffer.c             |  2 +-
>  drivers/infiniband/core/umem_dmabuf.c         |  4 +--
>  .../media/common/videobuf2/videobuf2-core.c   |  2 +-
>  .../common/videobuf2/videobuf2-dma-contig.c   |  2 +-
>  .../media/common/videobuf2/videobuf2-dma-sg.c |  2 +-
>  .../platform/nvidia/tegra-vde/dmabuf-cache.c  |  2 +-
>  drivers/misc/fastrpc.c                        |  3 +-
>  drivers/usb/gadget/function/f_fs.c            |  2 +-
>  drivers/xen/gntdev-dmabuf.c                   |  2 +-
>  include/linux/dma-buf-mapping.h               |  4 +--
>  include/linux/dma-buf.h                       | 10 +++----
>  io_uring/zcrx.c                               |  3 +-
>  net/core/devmem.c                             |  4 +--
>  26 files changed, 63 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
> index 6253a720cc22..c679ec8230ff 100644
> --- a/drivers/accel/amdxdna/amdxdna_gem.c
> +++ b/drivers/accel/amdxdna/amdxdna_gem.c
> @@ -898,7 +898,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
>  		goto put_buf;
>  	}
>  
> -	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt)) {
>  		ret = PTR_ERR(sgt);
>  		goto fail_detach;
> diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
> index 4f2005a8d496..0342a3fc9185 100644
> --- a/drivers/accel/ivpu/ivpu_gem.c
> +++ b/drivers/accel/ivpu/ivpu_gem.c
> @@ -54,7 +54,8 @@ static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct
>  
>  	sgt = bo->base.sgt;
>  	if (!sgt) {
> -		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
> +		sgt = dma_buf_sgt_map_attachment(bo->base.base.import_attach,
> +						 DMA_BIDIRECTIONAL);
>  		if (IS_ERR(sgt))
>  			ivpu_err(vdev, "Failed to map BO in IOMMU: %ld\n", PTR_ERR(sgt));
>  		else
> diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
> index ef0351b6dc9b..b8de1a1e2ab9 100644
> --- a/drivers/accel/qaic/qaic_data.c
> +++ b/drivers/accel/qaic/qaic_data.c
> @@ -863,7 +863,7 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
>  
>  	drm_gem_private_object_init(dev, obj, attach->dmabuf->size);
>  	/*
> -	 * skipping dma_buf_map_attachment() as we do not know the direction
> +	 * skipping dma_buf_sgt_map_attachment() as we do not know the direction
>  	 * just yet. Once the direction is known in the subsequent IOCTL to
>  	 * attach slicing, we can do it then.
>  	 */
> @@ -889,7 +889,7 @@ static int qaic_prepare_import_bo(struct qaic_bo *bo, struct qaic_attach_slice_h
>  	struct sg_table *sgt;
>  	int ret;
>  
> -	sgt = dma_buf_map_attachment(obj->import_attach, hdr->dir);
> +	sgt = dma_buf_sgt_map_attachment(obj->import_attach, hdr->dir);
>  	if (IS_ERR(sgt)) {
>  		ret = PTR_ERR(sgt);
>  		return ret;
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index dc65752fb0fa..209a1dca19d0 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -678,7 +678,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
>   *
>   * 3. Once the buffer is attached to all devices userspace can initiate DMA
>   *    access to the shared buffer. In the kernel this is done by calling
> - *    dma_buf_map_attachment() and dma_buf_unmap_attachment().
> + *    dma_buf_sgt_map_attachment() and dma_buf_unmap_attachment().
>   *
>   * 4. Once a driver is done with a shared buffer it needs to call
>   *    dma_buf_detach() (after cleaning up any mappings) and then release the
> @@ -958,7 +958,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
>   *
>   *     - dma_buf_pin()
>   *     - dma_buf_unpin()
> - *     - dma_buf_map_attachment()
> + *     - dma_buf_sgt_map_attachment()
>   *     - dma_buf_unmap_attachment()
>   *     - dma_buf_vmap()
>   *     - dma_buf_vunmap()
> @@ -976,7 +976,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
>   *     - dma_buf_mmap()
>   *     - dma_buf_begin_cpu_access()
>   *     - dma_buf_end_cpu_access()
> - *     - dma_buf_map_attachment_unlocked()
> + *     - dma_buf_sgt_map_attachment_unlocked()
>   *     - dma_buf_unmap_attachment_unlocked()
>   *     - dma_buf_vmap_unlocked()
>   *     - dma_buf_vunmap_unlocked()
> @@ -1302,7 +1302,7 @@ __dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
>  }
>  
>  /**
> - * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
> + * dma_buf_sgt_map_attachment - Returns the scatterlist table of the attachment;
>   * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
>   * dma_buf_ops.
>   * @attach:	[in]	attachment whose scatterlist is to be returned
> @@ -1322,8 +1322,8 @@ __dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
>   * Important: Dynamic importers must wait for the exclusive fence of the struct
>   * dma_resv attached to the DMA-BUF first.
>   */
> -struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
> -					enum dma_data_direction direction)
> +struct sg_table *dma_buf_sgt_map_attachment(struct dma_buf_attachment *attach,
> +					    enum dma_data_direction direction)
>  {
>  	struct sg_table *sg_table;
>  	int ret;
> @@ -1346,7 +1346,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>  
>  	return sg_table;
>  }
> -EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, "DMA_BUF");
> +EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment, "DMA_BUF");
>  
>  /* &dma_buf_mapping_type.map / .unmap for the SGT type */
>  struct dma_buf_mapping *dma_buf_sgt_type_map(struct dma_buf_attachment *attach,
> @@ -1382,17 +1382,17 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
>  }
>  
>  /**
> - * dma_buf_map_attachment_unlocked - Returns the scatterlist table of the attachment;
> + * dma_buf_sgt_map_attachment_unlocked - Returns the scatterlist table of the attachment;
>   * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
>   * dma_buf_ops.
>   * @attach:	[in]	attachment whose scatterlist is to be returned
>   * @direction:	[in]	direction of DMA transfer
>   *
> - * Unlocked variant of dma_buf_map_attachment().
> + * Unlocked variant of dma_buf_sgt_map_attachment().
>   */
>  struct sg_table *
> -dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
> -				enum dma_data_direction direction)
> +dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
> +				    enum dma_data_direction direction)
>  {
>  	struct sg_table *sg_table;
>  
> @@ -1402,12 +1402,12 @@ dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
>  		return ERR_PTR(-EINVAL);
>  
>  	dma_resv_lock(attach->dmabuf->resv, NULL);
> -	sg_table = dma_buf_map_attachment(attach, direction);
> +	sg_table = dma_buf_sgt_map_attachment(attach, direction);
>  	dma_resv_unlock(attach->dmabuf->resv);
>  
>  	return sg_table;
>  }
> -EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, "DMA_BUF");
> +EXPORT_SYMBOL_NS_GPL(dma_buf_sgt_map_attachment_unlocked, "DMA_BUF");
>  
>  /**
>   * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
> @@ -1417,7 +1417,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, "DMA_BUF");
>   * @sg_table:	[in]	scatterlist info of the buffer to unmap
>   * @direction:  [in]    direction of DMA transfer
>   *
> - * This unmaps a DMA mapping for @attached obtained by dma_buf_map_attachment().
> + * This unmaps a DMA mapping for @attached obtained by dma_buf_sgt_map_attachment().
>   */
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>  				struct sg_table *sg_table,
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> index 016957cac1f2..169e1b27ff8e 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
> @@ -954,7 +954,8 @@ static int amdgpu_ttm_backend_bind(struct ttm_device *bdev,
>  			struct sg_table *sgt;
>  
>  			attach = gtt->gobj->import_attach;
> -			sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> +			sgt = dma_buf_sgt_map_attachment(attach,
> +							 DMA_BIDIRECTIONAL);
>  			if (IS_ERR(sgt))
>  				return PTR_ERR(sgt);
>  
> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> index 5cea1eab6e5c..506bc82f20d6 100644
> --- a/drivers/gpu/drm/armada/armada_gem.c
> +++ b/drivers/gpu/drm/armada/armada_gem.c
> @@ -531,7 +531,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
>  	get_dma_buf(buf);
>  
>  	/*
> -	 * Don't call dma_buf_map_attachment() here - it maps the
> +	 * Don't call dma_buf_sgt_map_attachment() here - it maps the
>  	 * scatterlist immediately for DMA, and this is not always
>  	 * an appropriate thing to do.
>  	 */
> @@ -542,20 +542,22 @@ int armada_gem_map_import(struct armada_gem_object *dobj)
>  {
>  	int ret;
>  
> -	dobj->sgt = dma_buf_map_attachment_unlocked(dobj->obj.import_attach,
> -						    DMA_TO_DEVICE);
> +	dobj->sgt = dma_buf_sgt_map_attachment_unlocked(dobj->obj.import_attach,
> +							DMA_TO_DEVICE);
>  	if (IS_ERR(dobj->sgt)) {
>  		ret = PTR_ERR(dobj->sgt);
>  		dobj->sgt = NULL;
> -		DRM_ERROR("dma_buf_map_attachment() error: %d\n", ret);
> +		DRM_ERROR("dma_buf_sgt_map_attachment() error: %d\n", ret);
>  		return ret;
>  	}
>  	if (dobj->sgt->nents > 1) {
> -		DRM_ERROR("dma_buf_map_attachment() returned an (unsupported) scattered list\n");
> +		DRM_ERROR(
> +			"dma_buf_sgt_map_attachment() returned an (unsupported) scattered list\n");
>  		return -EINVAL;
>  	}
>  	if (sg_dma_len(dobj->sgt->sgl) < dobj->obj.size) {
> -		DRM_ERROR("dma_buf_map_attachment() returned a small buffer\n");
> +		DRM_ERROR(
> +			"dma_buf_sgt_map_attachment() returned a small buffer\n");
>  		return -EINVAL;
>  	}
>  	dobj->dev_addr = sg_dma_address(dobj->sgt->sgl);
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 7792caf87883..330b64b3324a 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -1005,7 +1005,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
>  
>  	get_dma_buf(dma_buf);
>  
> -	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt)) {
>  		ret = PTR_ERR(sgt);
>  		goto fail_detach;
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> index 5333e77e62e0..04c7b9a97681 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
> @@ -242,8 +242,8 @@ static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
>  
>  	assert_object_held(obj);
>  
> -	sgt = dma_buf_map_attachment(obj->base.import_attach,
> -				     DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment(obj->base.import_attach,
> +					 DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt))
>  		return PTR_ERR(sgt);
>  
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> index 2fda549dd82d..fcfa819caa38 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
> @@ -293,7 +293,8 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
>  		goto out_import;
>  	}
>  
> -	st = dma_buf_map_attachment_unlocked(import_attach, DMA_BIDIRECTIONAL);
> +	st = dma_buf_sgt_map_attachment_unlocked(import_attach,
> +						 DMA_BIDIRECTIONAL);
>  	if (IS_ERR(st)) {
>  		err = PTR_ERR(st);
>  		goto out_detach;
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> index 23beaeefab67..569ee2d3ab6f 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> @@ -121,7 +121,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
>  
>  	get_dma_buf(dma_buf);
>  
> -	sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_TO_DEVICE);
>  	if (IS_ERR(sgt)) {
>  		ret = PTR_ERR(sgt);
>  		goto fail_detach;
> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> index feb783ceb0d1..fcb9308f49f0 100644
> --- a/drivers/gpu/drm/tegra/gem.c
> +++ b/drivers/gpu/drm/tegra/gem.c
> @@ -87,7 +87,8 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
>  			goto free;
>  		}
>  
> -		map->sgt = dma_buf_map_attachment_unlocked(map->attach, direction);
> +		map->sgt = dma_buf_sgt_map_attachment_unlocked(map->attach,
> +							       direction);
>  		if (IS_ERR(map->sgt)) {
>  			dma_buf_detach(buf, map->attach);
>  			err = PTR_ERR(map->sgt);
> @@ -480,7 +481,8 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
>  			goto free;
>  		}
>  
> -		bo->sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
> +		bo->sgt = dma_buf_sgt_map_attachment_unlocked(attach,
> +							      DMA_TO_DEVICE);
>  		if (IS_ERR(bo->sgt)) {
>  			err = PTR_ERR(bo->sgt);
>  			goto detach;
> diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
> index 3d5203ac19b6..de69590b5076 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_prime.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
> @@ -164,7 +164,7 @@ int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
>  	if (ret <= 0)
>  		return ret < 0 ? ret : -ETIMEDOUT;
>  
> -	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment(attach, DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt))
>  		return PTR_ERR(sgt);
>  
> diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
> index b4921a627ff3..4d93b8926ed6 100644
> --- a/drivers/gpu/drm/xe/xe_bo.c
> +++ b/drivers/gpu/drm/xe/xe_bo.c
> @@ -771,7 +771,7 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
>  		ttm_bo->sg = NULL;
>  	}
>  
> -	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> +	sg = dma_buf_sgt_map_attachment(attach, DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sg))
>  		return PTR_ERR(sg);
>  
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index a00985c92251..619181968ff9 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -1730,7 +1730,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
>  	priv->dir = buffer->direction == IIO_BUFFER_DIRECTION_IN
>  		? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>  
> -	priv->sgt = dma_buf_map_attachment(attach, priv->dir);
> +	priv->sgt = dma_buf_sgt_map_attachment(attach, priv->dir);
>  	if (IS_ERR(priv->sgt)) {
>  		err = PTR_ERR(priv->sgt);
>  		dev_err(&indio_dev->dev, "Unable to map attachment: %d\n", err);
> diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
> index 39b5564a4c35..dd584f8dcd1c 100644
> --- a/drivers/infiniband/core/umem_dmabuf.c
> +++ b/drivers/infiniband/core/umem_dmabuf.c
> @@ -29,8 +29,8 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
>  	if (umem_dmabuf->sgt)
>  		goto wait_fence;
>  
> -	sgt = dma_buf_map_attachment(umem_dmabuf->attach,
> -				     DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment(umem_dmabuf->attach,
> +					 DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt))
>  		return PTR_ERR(sgt);
>  
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index b0a6084f1757..5cd53e06da0b 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1464,7 +1464,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
>  			vb->planes[plane].mem_priv = mem_priv;
>  
>  			/*
> -			 * This pins the buffer(s) with dma_buf_map_attachment()). It's done
> +			 * This pins the buffer(s) with dma_buf_sgt_map_attachment()). It's done
>  			 * here instead just before the DMA, while queueing the buffer(s) so
>  			 * userspace knows sooner rather than later if the dma-buf map fails.
>  			 */
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index 536f839258c6..0ce643940898 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -706,7 +706,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
>  	}
>  
>  	/* get the associated scatterlist for this buffer */
> -	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
>  	if (IS_ERR(sgt)) {
>  		pr_err("Error getting dmabuf scatterlist\n");
>  		return -EINVAL;
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index fba2027e6e8d..17191373c69c 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -569,7 +569,7 @@ static int vb2_dma_sg_map_dmabuf(void *mem_priv)
>  	}
>  
>  	/* get the associated scatterlist for this buffer */
> -	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
>  	if (IS_ERR(sgt)) {
>  		pr_err("Error getting dmabuf scatterlist\n");
>  		return -EINVAL;
> diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> index 7752064be783..8f3443fa0eb5 100644
> --- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> +++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
> @@ -102,7 +102,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
>  		goto err_unlock;
>  	}
>  
> -	sgt = dma_buf_map_attachment_unlocked(attachment, dma_dir);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(attachment, dma_dir);
>  	if (IS_ERR(sgt)) {
>  		dev_err(dev, "Failed to get dmabufs sg_table\n");
>  		err = PTR_ERR(sgt);
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index 85fed3a12f9c..fce849417eb7 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -911,7 +911,8 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
>  		goto attach_err;
>  	}
>  
> -	table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
> +	table = dma_buf_sgt_map_attachment_unlocked(map->attach,
> +						    DMA_BIDIRECTIONAL);
>  	if (IS_ERR(table)) {
>  		err = PTR_ERR(table);
>  		goto map_err;
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 09680534623e..fe3c43ba72c6 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1567,7 +1567,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
>  	if (err)
>  		goto err_free_priv;
>  
> -	sg_table = dma_buf_map_attachment(attach, dir);
> +	sg_table = dma_buf_sgt_map_attachment(attach, dir);
>  	dma_resv_unlock(dmabuf->resv);
>  
>  	if (IS_ERR(sg_table)) {
> diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
> index 028cd7295fd7..3bb05596920e 100644
> --- a/drivers/xen/gntdev-dmabuf.c
> +++ b/drivers/xen/gntdev-dmabuf.c
> @@ -588,7 +588,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
>  
>  	gntdev_dmabuf->u.imp.attach = attach;
>  
> -	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
> +	sgt = dma_buf_sgt_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
>  	if (IS_ERR(sgt)) {
>  		ret = ERR_CAST(sgt);
>  		goto fail_detach;
> diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
> index 91a55cbe0bb4..02d79d5615b5 100644
> --- a/include/linux/dma-buf-mapping.h
> +++ b/include/linux/dma-buf-mapping.h
> @@ -171,7 +171,7 @@ void dma_buf_sgt_type_unmap(struct dma_buf_attachment *attach,
>   *
>   * When this type is matched the map/unmap functions are:
>   *
> - *  dma_buf_map_attachment()
> + *  dma_buf_sgt_map_attachment()
>   *  dma_buf_unmap_attachment()
>   *
>   * The struct sg_table returned by those functions has only the DMA portions
> @@ -206,7 +206,7 @@ struct dma_buf_mapping_sgt_exp_ops {
>  	/**
>  	 * @map_dma_buf:
>  	 *
> -	 * This is called by dma_buf_map_attachment() and is used to map a
> +	 * This is called by dma_buf_sgt_map_attachment() and is used to map a
>  	 * shared &dma_buf into device address space, and it is mandatory. It
>  	 * can only be called if @attach has been called successfully.
>  	 *
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 77a18b9817ac..ee6c97a5cecd 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -515,7 +515,7 @@ struct dma_buf_attach_ops {
>   *
>   * An attachment is created by calling dma_buf_attach(), and released again by
>   * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
> - * transfer is created by dma_buf_map_attachment() and freed again by calling
> + * transfer is created by dma_buf_sgt_map_attachment() and freed again by calling
>   * dma_buf_unmap_attachment().
>   */
>  struct dma_buf_attachment {
> @@ -614,8 +614,8 @@ void dma_buf_fd_install(struct dma_buf *dmabuf, int fd);
>  struct dma_buf *dma_buf_get(int fd);
>  void dma_buf_put(struct dma_buf *dmabuf);
>  
> -struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
> -					enum dma_data_direction);
> +struct sg_table *dma_buf_sgt_map_attachment(struct dma_buf_attachment *,
> +					    enum dma_data_direction);
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
>  				enum dma_data_direction);
>  void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
> @@ -625,8 +625,8 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
>  int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
>  			   enum dma_data_direction dir);
>  struct sg_table *
> -dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
> -				enum dma_data_direction direction);
> +dma_buf_sgt_map_attachment_unlocked(struct dma_buf_attachment *attach,
> +				    enum dma_data_direction direction);
>  void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
>  				       struct sg_table *sg_table,
>  				       enum dma_data_direction direction);
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 86d580d4410d..3f8be77a50dc 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -182,7 +182,8 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
>  		goto err;
>  	}
>  
> -	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_FROM_DEVICE);
> +	mem->sgt = dma_buf_sgt_map_attachment_unlocked(mem->attach,
> +						       DMA_FROM_DEVICE);
>  	if (IS_ERR(mem->sgt)) {
>  		ret = PTR_ERR(mem->sgt);
>  		mem->sgt = NULL;
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index f4d60654ce7f..86b3c54933bb 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -241,8 +241,8 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
>  		goto err_exit_ref;
>  	}
>  
> -	binding->sgt = dma_buf_map_attachment_unlocked(binding->attachment,
> -						       direction);
> +	binding->sgt = dma_buf_sgt_map_attachment_unlocked(binding->attachment,
> +							   direction);
>  	if (IS_ERR(binding->sgt)) {
>  		err = PTR_ERR(binding->sgt);
>  		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");

