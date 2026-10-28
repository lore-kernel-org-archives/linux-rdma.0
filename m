Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793219645;
	b=3OGqU4Pa01wbZbJ9EsnQmFnBeZSWWqe7dBGkIlFJQNl64Gqf57p8UDcMgtjya49aNlKX
	 xaky+a4ppk1yvEmm73WQ+dOAl2briZPnn6UBSZY12OdjvZ7a+HKAmXaasD87/WMJ6BsC7
	 H6X2KGuNTv0sbFwmXx7JK7vZaIi8L+jtDgM84qMcWfStV/jLikLKYJkm2jLe/jIB0zgWh
	 tOmj5PPZ7kD6MHY1FLxT9ncDaKrMy/+/1SiScl/SD9xu19TTI/cnQ7UraUAEyhw+4v0XF
	 XXy9F7Ue+krDKdFathf0oz6YdOy9z36L/C6tWCy02GPGCjJj3lMOxepme0Uja66SThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793219645;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=5HMKZuJ5mzuvxrnS1ESvLr/009YKienGm5nWikk9ws4=;
	b=nAD/y22zHVqK3lfM1WrkDGHH8IMF/sRzVOO9dzJXQfIDFUxqYggYN+s9VvaNF7jk07XS
	 9ySv5J8Z2HdGSpaoZ0+zlhTCWPVZ7jkM3yTSTQTJ20D6rdButXid6tE/tQY9XAvMMihh4
	 bX7vscjRBHnuAlJu7fE/CdhOEEA7kaD6WUHGR9J5XxA1jRHMKGwEYTg05geb+WrVY3yqU
	 qey6bC9/1ozeKJnZrPz0LsX/9XKmuBDorz1zHCz/a6+eTgPL2lRAujvyXjf3GK0LLcAE2
	 wTB32Ua/IDO07+6AawAH6gSEQ9qEagrkLSY7UUGUSWYp6O0+8O65LtWmPZ6y8nHElcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIBWz7ft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBED606A31D;
	Wed, 28 Oct 2026 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIBWz7ft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B341F01825;
	Wed, 28 Oct 2026 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793219645;
	bh=5HMKZuJ5mzuvxrnS1ESvLr/009YKienGm5nWikk9ws4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cIBWz7ftIdOwqDs027jvbsvqfjLC7DFt594wmqtGfW3hHL7XAk4RfMM3E/c6GxnLz
	 M+32Ms3Yplm33eju/AyD5QrKJ5c36zTKSdZQkNiXmI2OdbwRRx2vh22uQpoZ+tx6jy
	 cWYZ2hOiEp9gOPEnO6AcWWioGmfDctCgxK3BmgZx1V7JmLWNUjzT1quMRZT/yYUtt2
	 96aDlR58KXqhUwNUS+dsm/bVVTDrjnzrVIMXtpzG6+GIOnjPjIaMNNrPWRPkY/nDAT
	 8GXnNgRTSCneh9SNPYxBNwHikmsbbhB9CNuKUwtS9wxZzrt+rNAhhSofzl8N1IPKCZ
	 y44AKjUVHOC4g==
Message-ID: <44a5aa3e-173c-41fd-bbb5-92ae9d1cdc8f@kernel.org>
Date: Wed, 28 Oct 2026 21:34:00 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/26 18:49, Zi Yan wrote:
> On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:
> 
>>>
>>> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
>>> not fixed. I can fix that part as well.
>>
>> We should do that; returning kernel allocations from this function in ->fault is
>> bad.
>>
>> How urgent is this fix here? (can it actually be triggered?Specific hardware?)
>>
> 
> Not urgent. Like Jason said in another email, RDMA only runs on arch
> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
> zero_page checks in rmap will fire on the returned zero_page.
> 
>>>
>>> The read-only zero page part might need more attention, since
>>> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
>>> to add the support for rdma_umap_fault()?
>>
>> We just have to make sure that we cannot install it writable etc. But that's not
>> a concern.
>>
>> Just have to be careful :)
> 
> There is one wrinkle, it does not work on
> s390 + mm_forbids_zeropage() == true, where zero page is not present,
> and a private zero page is needed.

Yes, see vm_mixed_zeropage_allowed() I added.

In a VM_PFNMAP it doesn't matter. It's only a problem if we can GUP involved
IIRC, and VM_PFNMAP just disallows it entirely.

Similar for s390, it doesn't support any form of memory deduplication (incl.
shared zeropage) for some KVM use cases. IIRC, PFNMAP does not really apply there.

(have to make sure that gup-fast doesn't try pinning the shared zeropage)

(of course, the shared zeropage must never get mapped writable)

-- 
Cheers,

David
