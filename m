Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793239251;
	b=oNHyuzIzx7uMHbL8j0KZA0VKt+6SZU5SUNhe4E0m4w77bafOQa0EOyoFSF0uxd8lX9pW
	 B4dhV9yiKL91SDlKVXBoKFDChKakGTATRTQSGZPEEmI72MsC4DYyStL/fwOn3INeH/kxw
	 BLSVTyQqDDTHLmozO/8WsVVEXqzRKI+Yf+oAauRWDQUjoc7ztls5Y9mPyVvBl+dkDHxnR
	 vu5E32iEQMVfu3yhVJcWv5qpAJXCMshNikuxqQjWygQ6NsXz84VaaV1795xuCn1lnapdS
	 qB1JOqrPXBromiNjMPjPygv+Y3QIBbzHacOqwuTanqa9RqaMflII9JmdV+NbiFXR46w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239251;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:X-Mailer:Message-ID:In-Reply-To:References:Content-Type:
	 X-MS-Reactions:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=wXh21ZtbBV0WqjvjXU8QtKhqp1jWV/KXknHIuaGmwsY=;
	b=NThPcFovYNyWkQGF3RAr5QDcw2p1n4gTGPWCu4EDnfDxWbFGf6IQBkIermDD179Ls2Hn
	 hPtsWj9fXXr6rfADJmE5GRLlvzyXQrQ4WNAvre/BHSdsazhKF35sJ2KtD0vP207SP5GTB
	 pohEyUSgZo6dzNCj+tJqZVLyYIGBze1AJb59agbYGfC50LjGNk9MthH0s9SJarIv8fulM
	 mEozxQ4+MpfLj7IB2G+2dKEC+36w0tk/opv89E4Q8pj1pQdXEfhXRsIfxiWrdo0Ohm8pK
	 oFKlRb0kPm+GVrlJVri2C5NMXZdQrolcZHxCt2YkTlj/ab6XKa7pX/fqAq0tXN5/GAw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="a0u/Zj9b";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.42
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011042.outbound.protection.outlook.com [52.101.52.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422F606A31A;
	Thu, 29 Oct 2026 02:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1422F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=a0u/Zj9b
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTxNOobxSRe+Wv0RRVQFRXsR7RnlOS1bmp1NgSeULNcoAPYWbUBVRQOtiYheYH8nH6dEBtTBMDmD+a6PHtQR+QfLepNXZCcja7SkFVBzVAuxCYzCvUHqwzR6RHbVvLaZaEcA+l9sV4Kysq5sf6UVt+a5yy8eQne/ChSDFRWSUboLobhYpyuNGyJCZsPGocdmdB5+KWyXJvx60jbS6mcphV7qyRATA0XIdq7/nmEEigOCjHOjSzmJEwRzXQ5zcn4CCU8lAVAcu9v/arB7Qi3ZKeOgC0ysijWHjwbviHWBUsKPkn2wTQ5P45EluQ2MpLaWUlpPIGh71e8DdLqv1aW92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXh21ZtbBV0WqjvjXU8QtKhqp1jWV/KXknHIuaGmwsY=;
 b=nr7q7P6hVs6pN5SHJf+/07oIeK2Ozo/2ct4H5VVTdOV9/SV7X9bDpFI703ynNOOjAGGJAtMVTK1B6uKSqB3MtnK521/o0fgNdOm9jB+XT7PYjQ4941lBUK1dDi1G0N89CAp/qBIzn4zXkDIDtCNWYTblUqqSXKGmbr/qfgcznZc62nwBI5waOv2AYg5itRZ5BpHkaItTKmm8amghM/s/xPb0LNKvowag6wA67hatP7lceZlFMccnyaUz6fNPeMaMpr5JUP9vwom3CQMklvc9rrmL4xB2WlbQZEM9zVWc6PdO5U86T06F67kh0CnPmRhnm507yKY9VkYP/yMF6Immxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXh21ZtbBV0WqjvjXU8QtKhqp1jWV/KXknHIuaGmwsY=;
 b=a0u/Zj9b29KiE9Eby99trvdVg96F2alVvcLfZ3UdPD8DITKaD7p2p8jWb1BuiSrxXcnle5oOoBYvvu/YksCTa2Khf2gFuGRJIGe4mWSMp2KX7DCWfUwQlL+VQTn/BKXcDfdnTO+9sxstzM52Pv23/TdqqYarg9E41PU6+h0uPm8Nv4feSrIJjvKA7CtBhRHaeHkHWGofZEHqKmqhHpHpzaDn0dzVL6fcbljf0fXmx5OKTG1EnV/WbF4ab9pCZ9LvMNZj9OfnFUy6l2Aw/xG6/5nHDl4fUpxvsEw8MGd5u27GkG9VbR7/M512OXhMz96KsIbIpbCerGGxPv41LBoU4Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 02:00:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 02:00:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Date: Wed, 28 Oct 2026 22:00:43 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <EBA77B7E-B4AE-4725-8E82-061676C9B1DE@nvidia.com>
In-Reply-To: <44a5aa3e-173c-41fd-bbb5-92ae9d1cdc8f@kernel.org>
References:
 <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
 <44a5aa3e-173c-41fd-bbb5-92ae9d1cdc8f@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:408:e6::16) To IA0PR12MB8374.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: bb4b30dd-130e-4081-fe67-08df356072a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|18002099003|22082099003|56012099006|11063799006|261022105027099003|4143699003|261021121427099003|261026121527099003|261026140227099003|10067099003|261009223027099003|261022075727099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	MLLNSiWpJUgaI/9OyM/VYcK4VfmsR6PcQjJQcVgpXryw2xIBUlZQGwpEXbKcSbOYv9LXpEXUvXSyMA74KKzJLh8YzShkJtpa1oXIoFz5x9bTodf2XMYl+EjpG52TrwL5Zi98kPPr851vJeIY0CBQqi3BQCo9HZOwzqm1/nC1I8UVgu/ZQqLwYfyxTaeRYtez5CRpanw46QeQoPZEorWOpAi3Q5kjKjd4xVEG2CLKLLwXPbl6D4aAaxir0Ou9NNzh6lW3/nc+b2S+nJvQM74jt8O3k9VHN03TjjJYVbYwtuudL4BT8PnY8PlA7etiNxPqjDw2E2t4rvhgFDOXRB74XuGPLyLIALK3bfzdC7WcMvbb905rQ78Ea6kBfgo2Dwi53V/yJcM1d7qqN1ioMKF2iNAIiSenx+ZBPaCCM8GYac2XNn+Banb6st65AYdnWveRMHf/nnt+tzP5A8ziIve62sZeqYtsAv5DmltgNW6YhND7A4QTP90fDJCkJwp5OLQG+/9e7JRzPZwMsRFKTx9Tc9qOKDsGOQyV6Ma6MQwCK2RqRgaXQIvtU1+ltZX0+1xqoV/coDQZ1RnzZKXe4wje2CBhmc2YGHxkE1UsLExaoic9030sCBVZcOs8+RcV8aVB6SThHvVOLwwMEvnxaOtfejSWyciz7l+EtukjtmJe4E8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(261022105027099003)(4143699003)(261021121427099003)(261026121527099003)(261026140227099003)(10067099003)(261009223027099003)(261022075727099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g1N6arjFibNoKnIXcVISBMx2tbFFyfqSSAWi2Ya1vnV65pWtM5L9fOJ8zw6Z?=
 =?us-ascii?Q?jHEQu60oCsMywpSoJC+wOc+Oijiq9S6DwXlvniMQKVJeZdYNDwkafE8Q1Oon?=
 =?us-ascii?Q?dQow4D0rhOTDS497aGS5UQyuxjzEbcl+O7cSpI5tytJkUd5npBXptBgukW2G?=
 =?us-ascii?Q?10jRJmO/qPl0I/o7tA8WZaBxtCeLgEXpR5jkK6tYMeGDQFpX7VMSX5nlIUeH?=
 =?us-ascii?Q?kt4ttdTpqjNlpZ9gUrXFWJ8Lbbc4DYkjO1d+UpCx3v+vh7iTexDH4D7LDO73?=
 =?us-ascii?Q?648FBfudTeQNY2iAYL9NEC74xXaAYbpBX9wklUabqeiVSj3Di766JZrVlqD1?=
 =?us-ascii?Q?hzjtaOS0tTgvBSUjAMh0b8vq2AcGwYzep66zFrhcSvqwf28+aGjEjbg4e+LL?=
 =?us-ascii?Q?LPLwI7tk4VkjiSGVrvc2iUISUAXk1Jmx65/l438TnM8mqysQ8nKq++Q1OJgU?=
 =?us-ascii?Q?EzCGF/vqnOX9JupgwtXR3ISv1o8JAgxP58DuB6ZkC4GXwOvyKucrvARp2F+M?=
 =?us-ascii?Q?jhVipwn03eW7z2CdRvpVAd0+qnKkEJzRyxL8c1S606KzS/ig3jQcX2MuBntE?=
 =?us-ascii?Q?70EZhIJfRkvBFxzQmoB8NQ7lVzFHUO0Zp65kP0oUZxEFySeOkhzZn2GbiFql?=
 =?us-ascii?Q?SZXyoun4Ohj479x/k0QDzfMcMip2BDjC4NWhk7yYG1hqCvXDhquKImyJsEIR?=
 =?us-ascii?Q?uD4XCIG4VeGwo2/nbqr5DTvqSpDL/75Iit/fsi6FCvDNn4JjpP2PVWsabzP1?=
 =?us-ascii?Q?RhDkdspN5pEorjRtBhPhZbjupMduNRdWjVtwYT2c7VIrr+FSkwl7v3KRLAr1?=
 =?us-ascii?Q?bcGFZmC9y3vD4Mo2UhftYZtxKJVS9dlfFOgq2lTsOPlv/ZDOzEmYtUb06c6O?=
 =?us-ascii?Q?+rUe9qVl/XQxYMq5vHcR7362EGa8cV9PN5cjWQ+Ss4OHw3lVNY2Z60KBqDKB?=
 =?us-ascii?Q?J2OD4O+gPMni6n7VwSsYKi2rWYwroV8Wfe3wpuaX7rb4ofZmbO0MSKizst2X?=
 =?us-ascii?Q?5y2JLK6Aou5sjQUhavQr3Eoy+RPYpyEU9DbATE6JT9tq5yintgQtzUg6Alv2?=
 =?us-ascii?Q?zJKeKWR6nHA6uAzQfxXymUrzVYKL+tjQA5y2ysqMF2iLtJRVySFVnIVnEEcU?=
 =?us-ascii?Q?+1Pf3MIn7utM109MF8x1ojn7rhLzGXswwt6Vrx8ZnXzEMPrmnjcsj0KN31wW?=
 =?us-ascii?Q?2a+elDbQdRytsUT9c1yLSw8PHDQ5vbfvZ+yR3RCz165arIwGWQyQaffZNOMz?=
 =?us-ascii?Q?2FwJW+Duj7XQWXZeuPzEU1+rZD7xrzX3IdUEnj4IbCCHCO6nakfYgO42CEdL?=
 =?us-ascii?Q?LsT6QGQlBf23/veeWEGAaN8Oendw9c89+RMhX671fErqiPeQ2up+TnGO7h03?=
 =?us-ascii?Q?ULmA1LEer1S77k/RStRoAHgpWHjoXDbsqzX+Yuh7N/rJ9KCG7ZG/uwbdWv7V?=
 =?us-ascii?Q?MPILqCu25ZksieJxfOt/fByUVocnjVZG+6yF8FY/gnxyKLsdGODXi8W63Gx1?=
 =?us-ascii?Q?MiD/9t6tPHsgNcvWykX8n7NocOw67M1o+i5SwAUMKwfQrSYKAykxpHg2F5Lb?=
 =?us-ascii?Q?1MmI0Wd3zRKDEITha09wYpSaO/2tarq9BBhfA23Rxj6e2N6l5I2NPdn7/QE4?=
 =?us-ascii?Q?Nt2Dpf70dd7RDx9I5Mcel9FIQ0FyUjlUriuEKk3ZlTf7I3jSR1rSIKfRj8Hu?=
 =?us-ascii?Q?rzgQnnSLwW4yAYNxlmihAT/vm6Iry3MlsZoSFGRxSon9jKU8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4b30dd-130e-4081-fe67-08df356072a3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 02:00:46.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1pthwFLddgkaOzDCtY5k6H8IRnte96fWtJ1kPLUF33yqrm3wfUzXI1lr2uhjBC9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097

On 28 Oct 2026, at 16:34, David Hildenbrand (Arm) wrote:

> On 10/28/26 18:49, Zi Yan wrote:
>> On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:
>>
>>>>
>>>> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
>>>> not fixed. I can fix that part as well.
>>>
>>> We should do that; returning kernel allocations from this function in ->fault is
>>> bad.
>>>
>>> How urgent is this fix here? (can it actually be triggered?Specific hardware?)
>>>
>>
>> Not urgent. Like Jason said in another email, RDMA only runs on arch
>> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
>> zero_page checks in rmap will fire on the returned zero_page.
>>
>>>>
>>>> The read-only zero page part might need more attention, since
>>>> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
>>>> to add the support for rdma_umap_fault()?
>>>
>>> We just have to make sure that we cannot install it writable etc. But that's not
>>> a concern.
>>>
>>> Just have to be careful :)
>>
>> There is one wrinkle, it does not work on
>> s390 + mm_forbids_zeropage() == true, where zero page is not present,
>> and a private zero page is needed.
>
> Yes, see vm_mixed_zeropage_allowed() I added.
>
> In a VM_PFNMAP it doesn't matter. It's only a problem if we can GUP involved
> IIRC, and VM_PFNMAP just disallows it entirely.
>
> Similar for s390, it doesn't support any form of memory deduplication (incl.
> shared zeropage) for some KVM use cases. IIRC, PFNMAP does not really apply there.

Got it. It is then all clear to modify vmf_insert_pfn_prot() to support
zeropage for VM_PFNMAP (no huge zeropage support will be added).

>
> (have to make sure that gup-fast doesn't try pinning the shared zeropage)

With special pte, GUP-fast bails out on the PTE. Without special pte,
gup_fast_pte_range() simply returns 0. Then GUP slow rejects VM_PFNMAP.

>
> (of course, the shared zeropage must never get mapped writable)

vmf_insert_pfn_prot() will only accept a shared zeropage on a VMA if the
VMA has neither VM_WRITE nor VM_MAYWRITE. It should prevent the VMA
becoming writable. Also it will ensure the result PTE is not writable.

As we discussed on IRC, VM_WARN_ON_ONCE_VMA(vma->vm_flags & VM_PFNMAP, vma)
will be added after __do_fault() to enforce no page is returned
from ->fault().

Since it is not urgent, I will probably send V2 after rc1 is out.
Thank you for all the info.

Best Regards,
Yan, Zi
