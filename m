Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793270692;
	b=mK9iBJlPu4QYZ2hIeHv4woh3AdDnbXr89NN77fVFy3DQqerUUPInC6BTzFsn0Ozm9Mzu
	 mYvVnpsX+Buz6qzGgqvSXtWYeRQqDesP2rYcGf8f/WoeMI/rbBjDcjUf/TtRlxTpnYIfn
	 NzRYu4Zb/exkDz3ybxxKRt3utvV03RDJ++eHVsv9+j1mvDzCgK24WUSKOX2rPlKzqIq7X
	 oU6lfSGPmaw4Ld5tYZMNkkEyv1EWai5DWbMGb/rd4VqWvhDhff+Bg6qz7CpPs8jm5eYJs
	 Mn48UD09E7/7nLYrol8LE6yMzn4k9VhHW8OyM4mGO0sCo7mJ/uOj0bkdJgG6Ld3+6yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793270692;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Ut7Dt82wxOXFB5jpdWIg+mDSfYAPLIzuxLMN5AZIwOs=;
	b=yd5Fkz2RUx3PqxI7Euz4fg2ujV4WB5s5+5i+EZn9k+DMHO/TRQO1AuoiLSEhOFT2cSD/
	 IkoooXnlEo3Kdx9/WZMAkXfv4rQKDTfbx1uKZlWvXDoqTQsy2y+8/jJbexP3nMWLL7Eif
	 KBX8DNAwiAc5DX0y/V3kTP4zYLuxsxyamP7/EmB/C0ywYRUYsbVHK/OZh9P6sHZKCRhBq
	 lw5YiFmZLJNtXiukf4DCqkhrh1w7rFmwNHHPWVQyvW9Qkz5oC30Em0XBevScNCZWvWYDH
	 a1e1UmnoFnueNFR1aE0xhcPeXmO7b1eHKM55Ynaa8LYhe3ybDIIX01urS260C/Vi+eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZledwiEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FF2606A31A;
	Thu, 29 Oct 2026 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZledwiEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7281F01829;
	Thu, 29 Oct 2026 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270692;
	bh=Ut7Dt82wxOXFB5jpdWIg+mDSfYAPLIzuxLMN5AZIwOs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZledwiEKv+uPF8i5NY45vGiD9j7X//bQqac/nqFiP/bjk8eAu60EZXg9cGveJxx2x
	 sqH8sWSAMIZChXFdncdC782UEPe/hNM4cIhY8mSELF5CNn2U0VOQXTtDq9z1bnEqP/
	 i3WR0JXckZJkd87I42c6K0lYzSRD/5MBe2EnknXfvjJgEHh6YqQcKAGnmG9RHfuAsx
	 HZ/73S5FHenZvLZHcZb9zXlrfUObqrD1jdyOfehQCQZImtNA6/ANIFtbAcCxzSTtI0
	 Sqfy7iY8MQ5kjD2IofCUOfyRiEQcS/Qd/ZJ43Fjtu0YrHEIrLDVSTlD2o5lSvdjTww
	 x0RkZ1QsCM92Q==
Message-ID: <b2eac616-fa24-422c-b0b1-3247befbd277@kernel.org>
Date: Thu, 29 Oct 2026 11:44:46 +0100
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
To: Zi Yan <ziy@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
 <44a5aa3e-173c-41fd-bbb5-92ae9d1cdc8f@kernel.org>
 <EBA77B7E-B4AE-4725-8E82-061676C9B1DE@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <EBA77B7E-B4AE-4725-8E82-061676C9B1DE@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/26 03:00, Zi Yan wrote:
> On 28 Oct 2026, at 16:34, David Hildenbrand (Arm) wrote:
> 
>> On 10/28/26 18:49, Zi Yan wrote:
>>>
>>>
>>> Not urgent. Like Jason said in another email, RDMA only runs on arch
>>> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
>>> zero_page checks in rmap will fire on the returned zero_page.
>>>
>>>
>>> There is one wrinkle, it does not work on
>>> s390 + mm_forbids_zeropage() == true, where zero page is not present,
>>> and a private zero page is needed.
>>
>> Yes, see vm_mixed_zeropage_allowed() I added.
>>
>> In a VM_PFNMAP it doesn't matter. It's only a problem if we can GUP involved
>> IIRC, and VM_PFNMAP just disallows it entirely.
>>
>> Similar for s390, it doesn't support any form of memory deduplication (incl.
>> shared zeropage) for some KVM use cases. IIRC, PFNMAP does not really apply there.
> 
> Got it. It is then all clear to modify vmf_insert_pfn_prot() to support
> zeropage for VM_PFNMAP (no huge zeropage support will be added).
> 
>>
>> (have to make sure that gup-fast doesn't try pinning the shared zeropage)
> 
> With special pte, GUP-fast bails out on the PTE. Without special pte,
> gup_fast_pte_range() simply returns 0. Then GUP slow rejects VM_PFNMAP.
> 
>>
>> (of course, the shared zeropage must never get mapped writable)
> 
> vmf_insert_pfn_prot() will only accept a shared zeropage on a VMA if the
> VMA has neither VM_WRITE nor VM_MAYWRITE. It should prevent the VMA
> becoming writable. Also it will ensure the result PTE is not writable.
> 
> As we discussed on IRC, VM_WARN_ON_ONCE_VMA(vma->vm_flags & VM_PFNMAP, vma)
> will be added after __do_fault() to enforce no page is returned
> from ->fault().
> 
> Since it is not urgent, I will probably send V2 after rc1 is out.
> Thank you for all the info.

Thanks for handling this!

-- 
Cheers,

David
