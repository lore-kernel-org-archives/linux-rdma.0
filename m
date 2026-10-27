Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793104550;
	b=Tvrq1m1w3gibfLt1b5UyhFZKEj1sRDkV30jBmoIx8W15sSYBTybDySy1NJHfnfMYXSHl
	 oOEsBt1QdWCPBioWRuaxI1lF1XKyzPs0ehWvwhZ0EWiVf/+6ixfpFcFMxtq3dMCya8vof
	 4YRPx7OaUf3lX7NLMpihl19i0I1HhT+MHQwC9mo8Ng6MVeH3vEezhJWQLPn/rSiZG3OFj
	 YFHv+rxD76+x0M8cglzN7qIbnVoEMJnILr+49HY5s9ssmx5du0wfmS5M+WewFdtmw0tJG
	 CIEOpljwObDjEinvu1vbTdxeh0OeXZDShh6Z2r0bCr9LMTBuD8vyrbXDWSASs0o/2Fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104550;
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
	bh=JmNkO1oeu8Q6enNGaTSBYuPDqF483zkSI0IFq1/QJes=;
	b=JQuovaLwzPSgTIrfGytt9BpNn/p4eRdS2OdxqDrhIUgv78NpORs5sLLcLjJxcZTbQhJE
	 5CZqYckrdY3gE8sjXcl3EJmzZ8F9XC5uLCrkjvJdYVTYdcxz8uRp9sKYP/xgFVA0nM42d
	 /S2T+qbB+aLb4SInp47w4L1Y2G04KV23MMjV5GIi0DgXH8uKT61xUA0ETClk3agp0nRUS
	 polNl8RLON/lU/dqyiLijgrs8rmyor03EjtK2wM52v/hm1HhL7JAHJFMN56ryh9Q90dws
	 l9z3BUkUr+7p6Szd9kjcGs8WEGlxnZikFEcv+6yRKOg5V7eVr+UTvjAu+j+YTf/bMKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RyoPKFlV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.38
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6188D606A325;
	Tue, 27 Oct 2026 12:35:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6188D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RyoPKFlV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6Huc3XPaG5vxg2RdQLXqsR4ftXj7tRLpNouxn7znTTYW8Ks3e/caujhK3QyXRkoo4UPDTMuxipSAKkklhUWQVCBjCxcZUE7JIipRrgZPGqsH5lnGYFmXwqfEhGnF3jszDehbbs8WBkBr55BwPYhjxyDURHpebP+K/u8hJoR7KMc2FTAVsxdGG6xdI5kW1ZHo2Z158zLQaouYwnMiDfPjl/GQLL5bQIn+eYnMeECcSLxRleE+HGacj+VRx2a2YSogYBtUOy73i9LtQN7wH9Cv+DRz+yUM985QDZuhDceOX58cR5sagcOf5gD/I4s+z7c0tpApyaneIupie+EEaeMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmNkO1oeu8Q6enNGaTSBYuPDqF483zkSI0IFq1/QJes=;
 b=OZUjq9Clg3apG0A5XKc0fUuQnZcIMaB7H/4Toz100V+mY23/7tL77aX9TYHvoPxr43lxLtYUYukin99xaSSGK4z7HWJHWvAYFYbVEtUl+JMmQChF5H6KMKLy/BHba2C+IySm2nw8u7pb5eKpCy1xSXE+0L/tPnAHKjsEfsEaRva1czU1686Z/RxYH4hg3aSrXzZdR4Az29f85x27+6xV1wo9/NiSXDqp8QQSQaplN/3swSIBCJSxdM9gxHrPs632YGo9r/vpSqAA+RN3x39rhsKPKn7grVB8hgDT+QWSLfT92NnqajEMkrx+OY3NVznjOOsp29psCsz4Ao37sJcICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmNkO1oeu8Q6enNGaTSBYuPDqF483zkSI0IFq1/QJes=;
 b=RyoPKFlVdrWs6LcH04qpPbsE3AncT/y2bhKFWDX5+GkWxIqbU51TnkASvYK53+lfJgQUphafqgXUbneqhwlOb3K8UtI6cf/N8IUQh6zrGpKSI+AtGSqLZHoC50/9F0L5uKxSz3PaGwBIfYB7nYoNqJ0ID1W3dM9Dfi3TyxKKRiNnfK0PRDSrnkaIXgbTwdmAdobE7YyC2UeUs1K5faF9BA9yc8SPcBlQjiDoxsXQE814zrCmM38dakO4VuqaBpNCm7xQva1JS50QHdbNI+gHlgp26nc6yk+waeRU6ouJ4V+yIdgmr/S4A06e2cSkG2PQ0R67ObNKnWe9xiP6DmgHag==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SN7PR12MB7449.namprd12.prod.outlook.com
 (2603:10b6:806:299::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 12:35:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 12:35:45 +0000
Date: Tue, 27 Oct 2026 09:35:43 -0300
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
Subject: Re: [PATCH 21/26] treewide: Rename dma_buf_map_attachment(_unlocked)
 to dma_buf_sgt_
Message-ID: <20261027123543.GD1671235@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-22-apopple@nvidia.com>
 <3151a820-c583-4968-8440-673a9e390446@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3151a820-c583-4968-8440-673a9e390446@amd.com>
X-ClientProxiedBy: BN9PR03CA0451.namprd03.prod.outlook.com
 (2603:10b6:408:139::6) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: cab984f3-35ca-4ae8-adc4-08df3426d228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|22082099003|6133799003|18002099003|261026140227099003|56012099006|4143699003|11063799006|261021121427099003|10067099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	t8aHLOA+TyrzKDHQO0t2dDZauQLALlan4uLXeh3zzSYu6D05gsPnfyYUNVACxRUxvEdSoleonSoMLYdsUoi72atGRHR4RC13ndfqO6BoriG57CfWo/TIpCDefNUEBzFN/j2ch9Bj14Mr+LRoIKDCLF8KRcd9oow5PbYDSPGxkh3FJxzaESC9JG+RNXeniACDsU0R+Uekiw8wdtYT20MxwG109bzXrNTPDEZ2tdtJMBppDbSIkSX8YDPWiBreoi9NeYKF157JAAcqkkgCuU+GRnpfS84ZwaGgvn4w7EIo96EZaxG6m1JeXFIIFnKI+wYxjP6A0hCABCOnzQRpVhw4uixe1HC4iUIqbRGH33DG+NIEJ2oZaVyFfNV+PA+1dCcKFxlDWLW6Da6fLirw/Ibtf1f/6kMoGkJYC846zrYQuIGgE/1ncJOa9ddyLEbhNxh4t6uRxpIv3V0vLPKGZ/w83j1d/cX34S0zuvAtohFrol8bgCi6hwxn6JFWAWaU6IrRBBe917hlN/kwZTZLTJiw2lYiSybeNqn7mz5aP+96wTRKrxsLeQtEIfMWkBhLxjF97BluU7qUv0Yan9WCKp/izAzKBN03YbTUrByoxe76yMqoXVJUcHy83Bpo5hu+mRQsTzTEP22BMapvbQ58D0BYxL+z+YJV3QjLiQWIiPek1r0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(22082099003)(6133799003)(18002099003)(261026140227099003)(56012099006)(4143699003)(11063799006)(261021121427099003)(10067099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTdGTDEvcnduMFgrWXlkZExibzBxUGdhalRjeE9yemJQV3VjSmZSWHprd0FK?=
 =?utf-8?B?K2VBU1UvNnF6N2dzZFBMQllwV2FCZVkzU3Zzek9mNFdHamdQTlBqM1hPeDNp?=
 =?utf-8?B?U3p4LyswY3l1UGNKdVZOWURSZExDOEZLOGUvVTZmRzNaMHkyR3E4RndNSHIr?=
 =?utf-8?B?UnNvKzREVUdWYVZNeW1vZG0vZUNmRHpxR2g1OHNzRTE3ckFXTk1zdDFoZ0Zu?=
 =?utf-8?B?bCtKUk1ia2tYTmwrUWJrOEx2TEtBaVhRSitDckZ0dCtHc2hqN0NueXVjWEJG?=
 =?utf-8?B?VTFOakFqZndZc0dVV2NvMlY1bGRsdkU5ZHFtN0ZlYm9ZVmhxVCtYODNrNCtr?=
 =?utf-8?B?c1VLblRDczN5MUEvL1ZJZnVEbyt5VWJnNVdMSEhjMXlZSVZjYk1HdkRXYUpY?=
 =?utf-8?B?SGZ0eHFnUnZPK1BmanU0NFJ2UmdYdHpmYm8ydHZFRmllMXkzLzNQRGZvczBV?=
 =?utf-8?B?OEFUaTU5S0VtQktMcG1XOHZ0M2EvTy93eTZTUVE1dVI0eXFqbmxvTjhpN0di?=
 =?utf-8?B?U0hkUjlPdW4zRkxQdTdtU0YxcWZLKy9lWTBHYklmNmtseWtSWXlCRjNhZmFE?=
 =?utf-8?B?cldzM2dhV3ExUkhrbEpDMHMyb0RyVElCUEJWYjJCQkxNUHNEc1BLbHJjb0xB?=
 =?utf-8?B?QkVDUnZ6RllzM1k1T3RkWFRxOWZJRXZrZTlrYm40WHhMMU9OZVcyelBuZDV5?=
 =?utf-8?B?ajM5cGZ5aGVmNC82MkRmOUg5aTNyNVhaL1hBaUxBTW5tcWt4cjJBUy85cTFU?=
 =?utf-8?B?dFJGK2NKNlZjNUtPT0RrQlBlcS93OGhJaW1KMEcwYmo4WEdGY1lEREJwTGpt?=
 =?utf-8?B?eU02TmtiRTFYbVM0RWN6djM2bmcrMEsrZktrcjJ4ci9qbmF1Z3FPTk13TEJk?=
 =?utf-8?B?YzVWV2YveHhTOExyTlNhQlhpWlYwOC9lMGRISWpGKzRIek9jcnhnQk1iZStp?=
 =?utf-8?B?RUxmMHpzeEpQcTdBZE1yaVNuMmR1d0ZaU2tCQ1JrWG5JWTUrOGRIUmZ5MzBt?=
 =?utf-8?B?RGZuQ3RNYmJNUGVyUHdIQzQyWkdXbTRHeDUwV1JnZ3pTR05mcFRzTzhTSEFB?=
 =?utf-8?B?K3ZZbDRsbzFuTjlNKzRocGFWbm5zKyt2YUx1OHlicnZYUU1YU3h6MkN4dzRH?=
 =?utf-8?B?d2x2VlFaWUNiZzY3WklmMzBmOHRkaWU2dWM5ZG9vUVNuOHJud0t4cFduendU?=
 =?utf-8?B?OTFINkcvTlZKa3BjeTNwT0xheEVocnhWc0U5Z3dhL3dpR3JYUHRMaTlvbUov?=
 =?utf-8?B?a0I2Vmd4UjBzeDlDRm9Hb1lNMjBJbnFBR3hPY2x2amlWMFBQWXRQTGJsRkRU?=
 =?utf-8?B?eGk1SVA2aDgzaWVITE9aQks2ZjFRSHdYckUzbFNMWmRFdHkyV2tBOWhFdFp5?=
 =?utf-8?B?UlRrL0VjRnJwVUVrU3BEYVpXKzcyZnNxc0pYY2pPNmFjejZWcitEb1VaVlds?=
 =?utf-8?B?ckR3MkQ5NFoxTzhmNlhvWVR6enA3SjdyRXFOWVQwamc4VmYzaWNiWHFhNlZ4?=
 =?utf-8?B?aGxtL1paaFFBQUo0d2FVakU2Y0ZMdE1nYnlYL253M1VidExBeFI1cDhBUDN1?=
 =?utf-8?B?ek9iQTk4STVZMFhZdEtwMjdlTlpaelM3QnUvNExiT3hwblVySmpBc1ErVDdm?=
 =?utf-8?B?bFBpYXJOOWF5eThmcVcyVnNmK1hNVHZIRmw2d3JMOUlFNDd2VkpHZEpEOUcz?=
 =?utf-8?B?OTA5Y2hvZTQ1b25ydTZWcDNCOTgxMlVuc1VlZU9EUHIwcUd4V0dNb3UwU05k?=
 =?utf-8?B?S1dqMTRoZjd0SUxxaldjZEpRTUZuRTJ4Q3BIZkdqYmI4c0FSUXVSbVROVElU?=
 =?utf-8?B?MlZQbmlnM0RZMU5aYjVNN2RrUE8zUWRJcHc0WG0xRE9CbFFEOUxaWXZGT1NT?=
 =?utf-8?B?RTdmOVl2TVJxT3A1ZXhDdUlVOW5xM0wwYXdpdHhPSjRDYVFvZG5YdC9xSW1H?=
 =?utf-8?B?S3BmbTVRT0NWWEdoRXZ4TzFnS1h0NlJXRzYwRG5zb2pVNS9uZWN3cXZaZFpv?=
 =?utf-8?B?dEtOUEZDdUxxRVRQV3BSRzBPbDBrOHNTZHladUl0SDhINU15WVFqWGRHWXk3?=
 =?utf-8?B?TDNrckl5RG05RmtsMVp1Ry9ENjc4MjR5c0lFRVM4ZCtxSTFWYTlPWHM1dUdr?=
 =?utf-8?B?aHN0eW1YbnkwNUhUNEI3dFNxYk8xUExvUFFTaEhpQkJ3U3JBTTltUHA0dm1o?=
 =?utf-8?B?TjlrRzBPK1B4dWxRL1ByZ1FaWWNYMmVMWFRBV1JZTGdZKzVQb2w3U0xUZFA2?=
 =?utf-8?B?dHYxcE40QjRyRFRFcGZOSURvQ2dWaktDc3pwMzM1WmJRNE1IUUFLWS8xUUNX?=
 =?utf-8?Q?LdT9mS8bTLcRO/rplr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab984f3-35ca-4ae8-adc4-08df3426d228
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 12:35:45.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MOvrrnmVAgmELSqXIcwbV5llD2gJGXDMRSdW+j4GC2GiyaVROynMK0x7mjJsOnqP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

On Tue, Oct 27, 2026 at 01:05:55PM +0100, Christian König wrote:
> On 10/26/26 06:36, Alistair Popple wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > This map function only works with SGT importers.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > [ also rename the io_uring zcrx caller, which the unmap rename
> >   used to pick up, so that this commit builds with CONFIG_IO_URING_ZCRX - apopple ]
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> I would make that the first patch in the set since dropping sgt from
> the interface is probably something everybody can agree on.
> 
> And sqash that together with renaming dma_buf_unmap_attachment().
> 
> Regarding the new name I think dma_buf_sgt_(un)map_attachment() is a
> bit long and has the sgt at the wrong location.
> 
> I would name the functions dma_buf_map_sgt() and dma_buf_unmap_sgt().

I was going for a namespace 'dma_buf_sgt_X' would capture all the
functions related to the sgt mapping type and so on for other types.

Jason
