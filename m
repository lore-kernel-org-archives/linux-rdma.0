Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793029689;
	b=mJIK5bQ612uQAtAFgF7vdS63U93fdfcSKPUaGa7uZ/P88xFwNVXy5XX3DkKGXSNdGDya
	 clAJS2ZB3G2Id367pBpeDkep2nxEGo8OoqCOMpMuZIt1ZW3IdFT64MzZZJzA7PG/EOZ2I
	 uxseqod2smBhcISxaHPx1V5M8AdlMOhBvmSraGeq7XY6kjX13doeSae5zYTolDA3rMWMH
	 5C4XlgfRoS2B1Gxh0suPKyRp77qIhwli77QxXidZOXA5Iujd2MenpXrVNkvJQL67Jy+D3
	 rtNAQoRuTDQVDarI20OSM1qLVtMkXOUdCm71EqerfgFz2TMp7uciOXUD61bjSphlzUw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029689;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Subject:Cc:To:
	 From:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=YiXBe0RnEtUkVZl9hgDRsnrqIlAwiwELWEfHk0cKjZY=;
	b=MCDQkkBrpLkasjkKQ5KBh1WdzixF8CzM1Ywa6grVb1iPhhJulCttiXW5MUNpGjl7Ch/t
	 15iOSb3ZOSGHJnsuMho77zsIfKSxEb9piqU25WFcjSKHX6+7MWwmd2ABZVuDMfgV3FYyH
	 dFafEAs1BH9Ckpn8HQ3r3kCVGpFe+kONed9iCSi+UJybiSnqLGfblsMLjrmRXOTsEFtFf
	 MzrsLGtKv0jrJNEJGyZv2VC/yJQCBSd73XPi58fvH++5UiXhPcP92yTuZXMEzU8Y/J5wF
	 7eSMbXzM7BQQdeqQ8ER3cr7Mo9kQcxaAU/GpNQff8CREIadXYmaOFbRV5ysLubrIP5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KB1MImgQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.47
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E43C606A327;
	Mon, 26 Oct 2026 15:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E43C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KB1MImgQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NuX1QuxIgHsNnjQqq9S/oBqJdFdlLmfeRXiAGkgBzozZ8VmRByXaV83WITfxRsi9rnUaElMymwud8eB2/7wmaPEd/I9DgSzOTNfwZuXWaEOTd3Zg4qGTgYJ76ejorpJOSxHvQelO3A1ZM+pU56MPKA1eOrvOLUDPluYtq97spZYA4acMs56Aca9SZkVjZvRL2rqPU5gts0/4RiJiRQzgIED44PJiUMT14Y8M6ZzDgQwZ18l5vpFBXM6SQJhXFIw38eJAT2JoX064hDfxokbk2UizKrHYjvzP+HxuLoJIvp1aQgfrea2o6zxYNnaaGleEuCeVV/oQGPxuhk4dujQIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiXBe0RnEtUkVZl9hgDRsnrqIlAwiwELWEfHk0cKjZY=;
 b=w12OPQeruwwYEENclz3BEAqq2Z2tZylckDI6GS8rvZ47eOo7PuHN74/Sbb2ItZM3geoa907BFTJo87n7/t9sC0h18qkeTmBWFhb3IOq6L3kbQx1/8AdkwS/05y31I6yNRE5SmuB3jXaZuEIWCmjlEsLcrGWdFhdoXk9P1aKPPiKRDczJZDDwvQ1weMrsc+sRwxSjlQqoZZJPR2zzqJcZU9MjfcDLYyUp1aCROxK4TruZt9yNNvosoz380AhSceaTgaufaK2wAW9kt+NcjV09V400+sB3q3W+2P9+K3sUTfMVP3QTIZuPu42q4gAdcw+slWeoOkiJ9I4/nea4ofb2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiXBe0RnEtUkVZl9hgDRsnrqIlAwiwELWEfHk0cKjZY=;
 b=KB1MImgQgr0R6a7ppEAn1lIapSN1xrpSdkY0Yb/Ulcqk8c8EebZYIDw7YxU8D0h3d6uI/vrJAL0/OJlITBx3DCqLQVTbgJpFFIIxxuJQ7hMfPZL9+zXtung0Hb8kQ0YEjGensVSJQ27SDxaNhhnk5ayeLmI0EVy4CnZMPXOXUHGdJobiWqklHJWBXGfJKzBNfjL8P10JA4rfYnBlb+xn6nRhB65V77DH4e1ZV7zP08zKsdZbsi5kGcVNgry11wa4gnejQKLZrCYTO2UEGtCZqeSvystsW9rqyimCkwQ7vwgY+X6rv+lpeoKx5vfUHXR6UEnPqM+IN3Pyagt9heA+Zg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV0PR12MB351767.namprd12.prod.outlook.com (2603:10b6:408:3fc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:48:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:48:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Oct 2026 11:48:04 -0400
Message-Id: <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Cc: <linux-mm@kvack.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>,
 <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Jason Gunthorpe"
 <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com> <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
In-Reply-To: <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0306.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV0PR12MB351767:EE_
X-MS-Office365-Filtering-Correlation-Id: 5601e7b7-5676-466f-10f4-08df337886bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|261026140227099003|56012099006|4143699003|11063799006|261021121427099003|10067099003|261022105027099003|261022075727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	Q+VLUYPisuO7OgeitKqKQB9w0Z1g+beYVNpXu4CZqiONbfLZlsVOH+We/R+4aSnJL+BFAihKvBaWw3WQQKRKpNPtxD03yL8wRB9i0t3alkkf/QvXfS0JBIf3L9CAJ4HIiFbzlW36yKORqlG9JT6wErgQQhrS5xiAHsvHNgIRIlBiyVQLqBvCZVgmxm3wToHsTEbqGKieA10CY8x6Eg7V6zblDC9aG7eOm0Dylw72UBjyIM5g6R9p/zK8w6aA3GvRgsDTbjhHQ7ocSs2n6x6qpNxyHRLBktF6EaT3Iq5Oo63AK5b6b+usOUdmEosytu97JtVzs0utSRMoug2z22wToPy2vyYtDFoYgNAlAwFtwxqxH8SL9H6QPw3CPe0vlCfqH6rjFlkcalM6cpUlIyqYgSAu30u+q/yCI74eFN5fnqjYgYN57kZdgHTtXGCZ8db9w+P/JXEWKJ1IRJ9uTYXieNy04DU1ujbCrMPbfO1um+nvCDuwg91QeyxBysWXI6dV0v9+YFBDgTJnVl3jXgLs9nlNRmW5ifeGeTyGuVAAYK7ucJXxP95o1c2zzbRYpBY/bJZ9DUJF32FDBLHWOJqlfQ/hEGUlu6SzO6xDfi3gtsyp1PtIlQJvqVcpj0cWvldFeLlXiOeZLlZRyrk44VUapALQrD9AQ1RKgalnHabaI9Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(261026140227099003)(56012099006)(4143699003)(11063799006)(261021121427099003)(10067099003)(261022105027099003)(261022075727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2F5NU1NazUxaG93ODNIelpiaEI2RHlMbEtXT0VtL1poNTByVTJSZEVvd1N6?=
 =?utf-8?B?bndodDlzTTNSWUJaRnp4aVZ6UHd0SjdhaG56YVlxV3Y0UFNvYmpKckRFNjZx?=
 =?utf-8?B?V1lYbldDZzlJSDBvOUdRdElyNXJuWDBVaS9IVGJEeWJEWVNSMlZqOGhHZXll?=
 =?utf-8?B?L2RtcHdSTCtPZ3ZhQWl4cTVBcXFNemxuMFJtQU1mWmlwS1FQSkdpMlFjMXFw?=
 =?utf-8?B?RzBpZTU3ZUI5ak91eWNRYWNHejczeGEwT0h3blV6SWdQdjZPN2F0c0ZDL2pU?=
 =?utf-8?B?QkVrUWVxTklLSldHVzJVK3Z0MnQ3akJ2R0xMeWVCOUNJbDNIUEI4UDA0b2Ew?=
 =?utf-8?B?OUlFUFpyMkVRWHVGdzJuNCtKQ09VV3RNTXVJd3JQVmtQbU5EeUpwM2cxaE53?=
 =?utf-8?B?N3p1UFdhbFF4cTdXTzBxS2lDOTdSaHVJN0NGb1k2QlZXMFdhdHJDaFBXQXlS?=
 =?utf-8?B?Z3lOTUtnOUY3VXFUWlZnZWI5YjgzUkYxeXFqYmNRV0tIdE5sNnB0UWRjRkRh?=
 =?utf-8?B?YnNxUEppY3laY0V4ekxKR1hjQ3Bac1lrSGJld2VwQ1BJQWVmazlneHpIOXAv?=
 =?utf-8?B?MDRSRGRrK3FHQmpvWHRRT0RYeFhHd2JaZlhGc1VXMVdYVGVGYmZnNlBIV0U5?=
 =?utf-8?B?dHZ0NDJxRm9aM2ZCSy9ScHd4RlQvajNMaS9qN29OUEoyMGFWQ2lQWUx0S05x?=
 =?utf-8?B?R2F5WDROZytRMjhKaEZEMnRRTDNob1d4TW9KcURhb1RXKzh5L05FTnFEQXBi?=
 =?utf-8?B?alhmMTY3ZlRiaFlsenFNV2ZXdXFhZnRjcXN0anQ1NVdPbHZQQnAyaEdoWDZy?=
 =?utf-8?B?ZFQ5U01iUTN0TGNSYmNETGVCc2tsbzY0VUs2Rld5MkJYSlcvenJLRlgyY0tm?=
 =?utf-8?B?NGltc1hEbGt1bVMzU2QwenR4UTFXRm1TMFRSRy9ZVHNBQmlXU21ON05TSkV2?=
 =?utf-8?B?SmxlbnJqbWliQU1vazZiaVlyN2drUWtTV1RjZkdvVk43TERnVHRWTW1GZXQ1?=
 =?utf-8?B?TVh1TmJDUld5Ti92NlB6ckFNQURnVUhUSW5wbVdTUkVZYUg0QXJhdmdndE1a?=
 =?utf-8?B?Z1pzbzEwRDNFcjRRWThFSVBkVmJGeUZMOEtTc0VtYStuc2FYTEwycUIxdXZL?=
 =?utf-8?B?S3M1bWlYNnVZQTNLWW51SGxOLzN4bFRLRWhSL2NaNUR6Rm0yWHo1a1NNNTV2?=
 =?utf-8?B?bkZsWWVwUStFa0ZDbURURi95RmpTdUZzVDNVODIyWEozTFNSUFhHS1dFdHNt?=
 =?utf-8?B?ajdPOWcxa3V4SnpEODdmU0ZjekxRNUpvOGoyaXVWNU9TZGtVcC9NVFpuaEJv?=
 =?utf-8?B?OXdRQ2M3UUpENUV2aGhFdU5xN3J3MEhpVDlwNmU2cDh5dVN1ckYyaWp5Uzcr?=
 =?utf-8?B?V0V5WDQvdWRqNW1GeVl6dzBwMFYydVRZUDZqYW4xU3FkTWJzWGk0eXlCVmwr?=
 =?utf-8?B?aGpOWkJJRndYSXJVTTdkSldJcVdtMzJFY3lLV3BMQXJWVC8zOTN3R2RDcHp4?=
 =?utf-8?B?dGFUTVEyNFE0WTNyVkFkcTI5dUJjcFRpWWpTUUJGREIzQjhFMUpMY2FiTkth?=
 =?utf-8?B?TkR6YzdMdk8xSTMwdmtIQjZlOGZhVEg5ZW1OZnhwcDlxb2g5RFBmV3ZVb3B4?=
 =?utf-8?B?YUdVZDRSak1UZVNSUHFpMlB4SlQ0TXpmc2dOcmdCTWlTVkxRRTd1T0JRVVB0?=
 =?utf-8?B?anhWNG9BZjhaRWV0ZUhuRU8wVTU1N0RXejRHWGxjSXRxQjlXN1l1aUFDRmxh?=
 =?utf-8?B?azVxNy9sMTNKUUpEV3dYMVd6QkVmeVlUTmRweTgvZ25IU2dCVE0zM2tac2pV?=
 =?utf-8?B?QnYwQzZtbVhjb1FGelJKOVdLRjNONXc0QXI1L1Y5M1pxRTVYb1NZdUdFOVhS?=
 =?utf-8?B?aDQ2WnBYMlRLaHYzMHJxVUoybEJ1b0ozRlJVbnNkSmM1cGtUbnBFVC9YbHk4?=
 =?utf-8?B?TFV5blpOdDJZRUJZRlNVZHgzSzJIc2tFZllWUGc4NzdrVzNZR1lRUHNIc1dO?=
 =?utf-8?B?bURNV1lZTUxqb3lDeWdnU1JaTnJFd1FIbkpsb1psOXZsVFl4WStPOFlBTCtr?=
 =?utf-8?B?RjNJbXdtYXpOVEhMRWE0d3NXT21NSEtJR1JDSjhCUlo1bmh2L1JEc3RDcGpP?=
 =?utf-8?B?TVBOeFM1bEJmaDdIUi9GdGF3N3JVVDZpWHIwVEkwai9yQ1ZvVUVQOWdhRE5E?=
 =?utf-8?B?Y1hiSnJkYVhlRGFtVzNpUktnc25rTGlXTnpQYXE4MEZlZHJqRTg2SjB4NXVS?=
 =?utf-8?B?L29BcG5JODFqaHdlSWVEZnlPUnVsdStFL0huNUEvOTZmRnkzcGJxbVpTaWlw?=
 =?utf-8?Q?fo5GJz9bAN8upAkS7Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5601e7b7-5676-466f-10f4-08df337886bc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:48:06.0502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlvHzQPPkW4thMiwfMoLO2Ug3iZUNKJGWWZKSOYwpqrDDaBCaJf1g4t4yCGTS+tt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB351767

On Mon Oct 26, 2026 at 8:20 AM EDT, David Hildenbrand (Arm) wrote:
> On 10/26/26 03:04, Zi Yan wrote:
>> After disassociation, rdma_umap_fault() returns the shared zero page fro=
m
>> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
>> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are share=
d
>> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and g=
oes
>> through rmap code. Two issues:
>>=20
>> 1. shared zero page causes VM_WARN_ONs in rmap code,
>>=20
>> 2. normal pages in shared VM_PFNMAP VMAs cause accounting leak on arch
>>    without pte_special(), namely the page refcount, mapcount, and vm sta=
ts
>>    are never dropped.
>>=20
>> Map ufile->disassociate_page for VMAs without VM_WRITE and VM_MAYWRITE,
>> with vmf_insert_pfn(). The page lives until ib_uverbs_release_file(), wh=
ich
>> cannot run while a VMA holds a reference to the file.
>>=20
>> Writable VMAs keep returning disassociate_page in vmf->page, thus its
>> accounting leak on arch without pte_special() needs a separate fix.
>>=20
>> Userspace can see two differences after the patch. A mapping without
>> VM_WRITE and VM_MAYWRITE now reads what was written through writable
>> mappings of the same uverbs file instead of zeroes; after disassociation
>> both are dummy data. The first fault now allocates the page and fails wi=
th
>> VM_FAULT_SIGBUS if the allocation fails, as a write fault already does.
>>=20
>> Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---

<snip>

>> +	/* Make sure the page is usable, like what __do_fault() does */
>> +	if (PageHWPoison(page)) {
>> +		ret =3D VM_FAULT_HWPOISON;
>> +		goto out;
>>  	}
>
> Is that really required? memory_failure() complains pretty hard on pages =
it
> doesn't know how to handle (random kernel memory).
>
> I'd assume that this here is not an ordinary pagecache page that mamoery_=
failure
> would know how to handle?

You are right. Will remove it.

>
>> +
>> +	/*
>> +	 * VMAs that cannot become writable map the page as a raw pfn, like
>> +	 * the device memory it replaces. The page lives as long as the file.
>> +	 */
>> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
>> +		ret =3D vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * This VMA is forced to always be shared so this doesn't have
>> +	 * to worry about COW.
>> +	 */
>> +	vmf->page =3D page;
>> +	get_page(page);
>
>
> This split handling is pretty horrible TBH.
>
> In once case we take a reference in the other not?
>
> Why not perform a PFN mapping in any case?

For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
not fixed. I can fix that part as well.

The read-only zero page part might need more attention, since
we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
to add the support for rdma_umap_fault()?

>
> (Does GUP have to work on these things?)

These are VM_PFNMAP mappings, I guess not. But I am not a GUP expert.

--=20
Best Regards,
Yan, Zi

