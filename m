Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793029443;
	b=UqZWB/OvSgf0DXQUiVjqpS4lcg++S/IomHj/pa649TmbdfIJXxM52XDoeAZU6RH4sP2e
	 yk616YHDawOL2iu8XLWGMgXdTrw3cfOqGOzIoWN46vTrbMnKUkh4IuJVBPwehwtwIDcrQ
	 kJ50NAm/DFkJnXonxvuQ56vFrJFFkOSlmVSuSNvVRzeS3utolOQqtOdVCaW55lW3QJXdC
	 l85azjx1231B7mx/TT3JaTlSj12nUnj6nSnAMHbwPlPoM1tlQQ11J07UBsuMM0rF6m/Pr
	 ZtB4Ri0zTe8F7Z25R5gbA0Z1B9D2JklY123B5IJ9e0pAh48bktcDF3LyCOMYc0EeG2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793029443;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:To:From:
	 Subject:X-Mailer:References:In-Reply-To:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=wrMdSDSkUL/R7RnR2JBCyofEx2S1ffPrgucJXDAyDm8=;
	b=cIYe3Dxh7Zq1CWiP3/r7becEqtyp32I1GcqSO3V/5GqzeRpnYlJ3w0vb+M3TZsE3WizF
	 G3eSxiAdrw27ebCQ329Sk/2qGEL9IgTt87RwMRzrNb1vpJpBjNuP0jrc9x1LmqoMKLi9i
	 YnMCQ0PeaFiro8o25SqIOjX7WsneJbgdYSZLznMOuakeuCgBdzvKZ+KY0XijfJyWK9hTw
	 pOk4oLcmSR9vBB3oN/4sPW+9Y1Aa6zpaxPphuyeTQl0RkhVPWgD48yJ5OxhD9ELBEsvjs
	 wakzBhpdgaGA6Aa3R1rZQR1S9DqFzDJGHQpZxuLC4gN5/Q0IbAx/eXA2rvGwL8RlEGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RhppWDtC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.30
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FBC606A31A;
	Mon, 26 Oct 2026 15:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57FBC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RhppWDtC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spB74e2xdMRwHNzuk1dPlpdtskfgdlxoX111BrWv2BkJl4ev85xxK/zgcwfvJyDEJGuIFQ4FWqCVVRNN875T6uoH9x5MyoBYtl7H6xZHsJqPEnZI98DYNANOR0U5JptLsq/4P1OZ0Rciw/lY8koW58l8x3V6SVWQBZ7MQwUgwTzQ2P0s7dLgTp+YMJ2y1W3b0HjIpZYD+hJGzWdBCZ14wehdPQgRaj2B6eI8c+mB0c25VLUNPi0XvixULQFLI8AaFpAqi3X7EOjBmC1gDuHLGplmfXgFFlOy9WmKSeG1xM6rrEGzF0+YPECiQW0zaqjgP2O4bGJwiJB1ILSq6v41xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrMdSDSkUL/R7RnR2JBCyofEx2S1ffPrgucJXDAyDm8=;
 b=MKHjVMDCx4cmmAElzK20qvDrv5J5NLMTb5hmRmy5VXB4rQ3vJ2RdUop6e64Lx2MzjEm4UKyR8gjeVYlGS/5CdrHUyblqqO/9rJnCZu2EFrPi8ZChL/HrUQvBt1LbbAnt6j34renJQwDtGnyvz+HEpB+w1rK+bWodYRmlisGfN5AQjqP1epXeqVa8Bt6ned94ritPKHa22bKgRSJWTHC/Qq/yaYP+jADYNJk1CoJ4QlFteZFaWfFTaASrohWvtk51cGn16t7UEFo3JYdtxArrwMANiuois9nwQNpzr3sD0WLj+HEcTsJEGyDUiK+5oOeYuCrJPu4gusSNowNTGg5aTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrMdSDSkUL/R7RnR2JBCyofEx2S1ffPrgucJXDAyDm8=;
 b=RhppWDtC/VamABL1SeHDvt4W79GbX8sc5rEiTH9di7mimOWHcZT1z1rC/bhwbKAwWOJR5Xc2YDWedK4nnmplPX6FuxFPWwjYg+0T2krtvM59JOn5sVtOWX7YgjhRC7zfdiBbW9PC6Ua7qhZYJYBa1CegkgR9qBJAExAHxOX1SXiHI/U7EJMERG/aCoOe7jY6stw8C+lQGeOoId2FfQ5jF8dey9kOoTRwTYprRo9G/UTX8O6Bpkl+YqvqdhANPQ6YCC2tc0TCguOW2bhXkX2aPxgYoZSjvXqcKSPSUYZ1uqsAitq892kfdgRmnXX2KC47LkjQdGb+yU7QT2n5Ak8x8w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6327.namprd12.prod.outlook.com (2603:10b6:8:a2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.22; Mon, 26 Oct 2026 15:41:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:41:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Oct 2026 11:41:54 -0400
Message-Id: <DMEVUFVL2D1Z.3AOCMD4UUMT4V@nvidia.com>
Cc: "Leon Romanovsky" <leon@kernel.org>, <linux-mm@kvack.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>,
 <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Jason Gunthorpe" <jgg@ziepe.ca>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
X-Mailer: aerc 0.22.0
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com> <20261026114955.GP3977851@ziepe.ca>
In-Reply-To: <20261026114955.GP3977851@ziepe.ca>
X-ClientProxiedBy: MN2PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:208:23d::14) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b06e59-720b-4637-2102-08df3377a9ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|261026140227099003|4143699003|11063799006|56012099006|261022075727099003|261021121427099003|261022105027099003|10067099003|261009223027099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HAktKA0Rex6q+Lbhdfn2vkAxIJZNn2QqXM8saIIrf2MaugFrDSUix8xitsZIXjkec8ut6ybEEYy20+/LI8ZIZLTTxLJhvBXqgraKmmyn/J3cuoUUOfSzLINQKmCiQnj8ikEzKkGbOgRVIskW8+o7KHV2dt1GB3cwW9ojaVsoyUSAYNx11VIw1/Hup276+/lQ9GBMojY2yTKKuOmO5ywNz3PtI0loTO63NvC6PhOE2C3yxIYTDynraKt34Q11LX/KUXFX3/+zpuIrac4RycTfyIYgoglDQ7aa+0kyqqt8fKAx/HauGNmQPnyP/QOQkhKUF8bnrZcV2D0vycqU4g+aMklF5mXge6OOr/AHsguJFE0P2PcgJTXjfO+9FP7PewiT4lT8hqamGL3qRwtEtv2vSb4B2J6yewefs9WsTfuqkMpqGKGaet3mDbJfom6y359Tyob7BqcdY9LWGrYPXzmiYAxeUW5/kjiAi06OvSuIigxaPZJLphRIxR7tKEhaz0S0Lmtb80bg18zslSDKA/Z71Q8DloDyZOe+29dJY9hu2XAT7mbPWZwEG3RHrOKfxXzKiZEeqkcaBP3qEg+nKo7N3FosLvp9YbKtvsAGQw2ARivDQe/TPdwz21CNpvCQdisi1J8hSLCGAGUZ9fx9HFJKmCsEQ8hec/ZPdTK6iN5I3Ko=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(261026140227099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261021121427099003)(261022105027099003)(10067099003)(261009223027099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGYrcFlnK05hTURpK2F6NHdQL0F3T2FzcDZuSWgxNUp2bk51SjBwc2tLMUs1?=
 =?utf-8?B?bnZSbG5oY0RlTzVVZHNxdVlqYVE0K3o2cmFYcnRvZ2FGT254N29xMFBxd1Mx?=
 =?utf-8?B?MmQvRGRUUitpNWo4YVN2U0ZJS2FGT1RXT2ZPcy9qVWZYM1JVMlVmRzJSQy9U?=
 =?utf-8?B?QU9BTWJoOS9rY0FjYjlua1F3cDd0YTJJaUROMkxEUDF6azlsV3kzWWxyNDBU?=
 =?utf-8?B?V0dvMGVlMFJjK0N2NExRTGZ3VWlpSnBKb1Y4ZTBxcVRiSUlLVkx2SWxWbkcw?=
 =?utf-8?B?TnpFbk96Sks2Mnl3bXdSVGZIK3VmZmxadXBjMVh3bTFyRDg3S0xjNnlCaThY?=
 =?utf-8?B?QUZSOUlSNklYWUx2VU5uR0lBTW9hS2JFL3lNcXZnakdPVUtSUFJaTDFKb3dh?=
 =?utf-8?B?UXVjRGV2SWtHU213aWFaeGFuc3VSK05VRkxJU21mNHhEQUNsN1kvT3pXZXE3?=
 =?utf-8?B?Y21qQUxuTEozT1JmYlNUMUFCS3c1S2VmMlpmS1NzT0xucWVHb3BVQTNmMWJG?=
 =?utf-8?B?cVdOL2w4TnRHdFhFR0YxYyttZmIyYzd5YXJBdmxzeWNDc1ZreGJhTHBNU1o5?=
 =?utf-8?B?WkdYVW5wRng4NHc5TUNtMXpIbHdOTWE0ZTQvdGlHSXhGR0hXNUh0NXJHTCs4?=
 =?utf-8?B?M2Z2RHNkVGtLMWFtcXowS0dRSkhNN3RWNURKN3o0UXJhN054R2VXUDdMSXQ4?=
 =?utf-8?B?YmZuQUpISkFNS3R3K2VOcHlpbVFTbFRsdlJ4Y2ZZN0FLM005VE9nU0dOeWlh?=
 =?utf-8?B?SDNCbUR0eVppdDc5QUhvaHBLc1VOTFZxT2VmVnk2Z0JtaG56WjR1NDdSSkc3?=
 =?utf-8?B?ckd2Q3duQVEwN1M0OG9hYVN6VVJvQ0dFTkdVSDB1a2RKc0lVeDJaNFE2eGlH?=
 =?utf-8?B?RUVwTTU5aXFHR3pJVVFyTUphbmxzeEkvV09zRjFlRzF5aUVncTlXYnFKK2VF?=
 =?utf-8?B?V3hzY1U2QkJxOEY1Rlo2VE11dE8wb3M5M0ZtUlRBV0VJOHhpKy9UeEYzY1RE?=
 =?utf-8?B?VUNoaTZMSCtXdU0ySXd5T3VjaEJjaGRaWGd6THJFbFhwU2F5Mll1ZnpCeGFr?=
 =?utf-8?B?MXF4cGFQekVKWk5VN2hHVmhDMXVUdThxZDBDbllwYzExUTdCQXkxM25oRVRp?=
 =?utf-8?B?bEVIaXlPa1RFUTVYS3VLR0FVRVJjNlJ6NnRUSlhQK3RyZURvT3Rsa0RpRFdO?=
 =?utf-8?B?cC9OMTNTanB6ZDRjL3RKSkRISWRQTWV1UkpyWUFaUUh3bldxVlRhQ1QzN1l2?=
 =?utf-8?B?dWRFVTAvdlMxSUJPbEk4SVliVm1nRnpSNWpNTml2TXNqNXlZakt3YlpkeCtx?=
 =?utf-8?B?a2pGRkkrNmN0SVVFMzJFcjMvZWhFVThZbmcyd0g4VEJVWkpJNlNxeXZzaWww?=
 =?utf-8?B?ZEkxTlR6ZU5lQkt3N0NnaHVhd0V4ci9WM3pUZlB1V05pODg5QVBRV1lERTFs?=
 =?utf-8?B?RW5idWhua3pDbld2WThuT2g0clJaSmc5WUdjeUd2RkhzanRNcEx4TmVEYkdE?=
 =?utf-8?B?U1djZG9TZm9vT0lFVXNHNXN6ZFMyWHY3d1FHOEZtRmRWSWYyNWhGaHBwQWFF?=
 =?utf-8?B?a3Q0Umx0NWp0ai9VQmJOSGhUZkQxWHhvVy9yU2NHeWQ5WWgweW81WSs1b0Yv?=
 =?utf-8?B?U0l1emZVKzhSRFdJQjRqVGl2L3VZdmxIejRJdHNMdTk4R0tvWVJoSGtQR2J5?=
 =?utf-8?B?U2ozWkthMXAzdm5YRHFPUzNNbDhwdDFqdWEvNytQV3VUa3hnUjAzYW8wd1cz?=
 =?utf-8?B?SThINTVNM2d6L1Z5Y05wRjR5bWZ4YWhtTEs1a29ncEFtSlFENGF1OWlHZmVD?=
 =?utf-8?B?Mk5odmdyK0FRNU42bTZPVDFibnpYVnBIM3dVWGdYNCtrOGlSOUY4R3dyU3ZT?=
 =?utf-8?B?MGduc20zVEtqdEpnNDNIL0ZhSklvMGlQcEdHbVFoVmIybVBqa3NPYm13N3kw?=
 =?utf-8?B?MS9PNFpnWjlpTGFsR2xqaWxKbnJNNFM2bmgzaTBmeU1oYVQ5c2oyTVFDKzRq?=
 =?utf-8?B?bkdiYklMRHFJYytqeEtVeHRWRkF5S09sRlBweFdwQ3dkVElXbUM4OHM1OFAw?=
 =?utf-8?B?akNlSi9yZWM0VEM3aUVQbkNxZ2FJNHRGdFArQzB3TmJVNDlrOTd2cnpXdUpJ?=
 =?utf-8?B?YmppY09CUEdaUkJ3OEFuTk5iS0YxUXRTV3VMcTUzcjFiUDYyTzNUYWt4aG1R?=
 =?utf-8?B?YmozVkxSTXBxZGY4ME1TQnM3VWpkVUx6M3hWN1JOc21EWDhPaG8xZkNWQWJo?=
 =?utf-8?B?WjhwcWd1UG8zbXdoak53ZjNPNXFiaTlpOVRpZ0ZlVWpTK3ltazU1dWRIZ0hU?=
 =?utf-8?Q?9OZ828/kSiLJm4XNFe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b06e59-720b-4637-2102-08df3377a9ff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:41:55.7401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmER9XIT7VqWXohT2BO6QHq75tcj2orP2IrF24otd7qEEhssSu2+lh48Zuc+XU/9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6327

On Mon Oct 26, 2026 at 7:49 AM EDT, Jason Gunthorpe wrote:
> On Sun, Oct 25, 2026 at 10:04:42PM -0400, Zi Yan wrote:
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
>> The issue was discovered during PG_folio development when making sure on=
ly
>> rmappable folios can enter rmap code path.
>>=20
>> Alternative: map the zero page with vmf_insert_pfn_prot()
>> =3D=3D=3D
>>=20
>> Read-only mappings could keep reading zeroes if rdma_umap_fault()
>> installed the zero page itself as a special PTE:
>>=20
>> return vmf_insert_pfn_prot(vmf->vma, vmf->address, zero_pfn(vmf->address=
));
>>=20
>> It does not work today. Commit 7b466529307be ("mm: disallow raw PFN
>> mappings of huge/shared zeropage") makes vmf_insert_pfn_prot() return
>> VM_FAULT_SIGBUS for the zero pfn. vmf_insert_mixed() does not support
>> VM_PFNMAP, since vm_mixed_zeropage_allowed() warns on VM_PFNMAP.
>>=20
>> The first version of that patch [1] did not change vmf_insert_pfn_prot()=
.
>> Due to no in-kernel user at that time and complication it can cause,
>> vmf_insert_pfn_prot() rejects zero pages now.
>>=20
>> Fix to writable VMA path
>> =3D=3D=3D
>> A new vmf_insert_pfn_mkwrite() is needed, since vmf_insert_pfn() has a
>> narrow failing scenario. When a process mapping the disassociated page h=
as
>> soft-dirty tracking enabled, vm_page_prot becomes read-only;
>> vmf_insert_pfn() then uses a read-only PTE instead of a writable one;
>> fixup_user_fault() is used to write to the page (e.g., KVM with the uver=
bs
>> mapping as guest memory) and fails, because it does not take the second
>> fault to upgrade the read-only PTE to a writable one.
>>=20
>> LLM was used for investigation and code development.
>
> Is that why all of the above was so hard to read?

LLM drafted the original long and full of details commit message and
cover letter, I trimmed down as much as I can but kept the necessary detail=
s.
Let me know which part is hard to read.

I provided the details because:

1. the original code returns a page on VM_PFNMAP VMAs instead of a
   proper vm_insert*()
2. vmf_insert_pfn_prot() is the proper fix but it has been changed to
   block zero_page, so I would like to know it is worth the effort to
   add complication for this single user.
3. the writable path needs a separate fix, which also requires
   additional MM fixes, a new vmf_insert_pfn_mkwrite() function.

Probably I should have sent it as a RFC instead.

>
> The zero page was used because things like the clock page really need
> to be zero. Reflecting back random things from the disassociate page
> is not going to work out.

Got it. I did not realize that each ufile has only one disassociate page an=
d
the read-only page and writable page can be used in a single ufile.

>
> I don't think rdma supports any architectures without the special bit
> so I'm not sure this is a real issue in practice.

Sounds good.

>
> I guess using vmf_insert_pfn_prot() consistently is the right answer
> since these VMAs are not supposed to be mixed maps.

It requires nontrivial MM changes[1] plus rdma_umap_fault() needs to
handle when mm_forbids_zeropage() is true. Basically, it needs to get a
zero page itself when that happens.

Maybe it is better to add a dedicated zero_disassociate_page for it, to
avoid the fallback handling.

In terms of allowing vmf_insert_pfn_prot() to accept zero_page, I would
like to get inputs from David and Kiril. Or the rule can be no zero_page
for PFNMAP and device needs to manage its own zero page and do the
vm_insert*().


[1] https://lore.kernel.org/all/c0979ad4-9fec-49f1-8442-d90061b79504@kernel=
.org/

--=20
Best Regards,
Yan, Zi

