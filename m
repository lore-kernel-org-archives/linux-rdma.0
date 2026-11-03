Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712786;
	b=okRtgccOsVlw7gOJFRN94Shum4mIUN9Ks1gChbHZmxXRqxRitG9yt1DlxApN7Eij4RCG
	 4aRQPW4rhZJjJMz/4j6Y1F2fF/CDE53VMiU5dQ/SyibgBbQaX91pRUR4RI1UQtgtNLqyQ
	 ykDzJdYGfmkdDmSKjaX7EjKtPoq9OL0X2PK3xvcm75oFUE+YYqvPuKqapG6cPD27rdCSa
	 5mB/cFPBCtbxwhwgbdxqssy9kSs6L17Afb+Ujl0p5eaFFLIiDnqVjLdYhCa7vrAkcq+HG
	 OyEJyB1WEpLSRqsJl7IBMWVrNVLq7jnVvgGqFZ3QQlCvcoKkjSq4P2r0s+BfeKz/ClQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712786;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=22QbouE8cQ/+KqBR8JqAf++7e526LrzApHVyHj4Hi0o=;
	b=glxXluUaCf6kXvfvxk7ywJ+8L1XCnghpyCAaIb3uaohdjyFY5r/y6yh0Z4/AnkVfT2XE
	 BsQIdEt92Un2bNG4YbjEcP59qiDSJa+7i1keH6an+YwutBH9oaMh3h2kRpI56efqSsl0C
	 +T+NBQgX1gY5k/f1ig3zBBuNu6a4/poduRcyo3qsKLuPez0vLnXBu4HaKD/p1+XUZyX7O
	 iMngaBAdIrqKVmqA6Umfe0f2khLJLG162SYPWXNBzlNt42ppKx3EnQYiJy9f34cGmPzQh
	 0qlQ7cFMe/vU3THSdpxIgP580z5pWGTkP15bZUZyd7w5+6jOhvL4qIqVLIOBOLrPKQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGos98CD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7846083602;
	Tue,  3 Nov 2026 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGos98CD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE9F1F00A1E;
	Tue,  3 Nov 2026 13:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712785;
	bh=22QbouE8cQ/+KqBR8JqAf++7e526LrzApHVyHj4Hi0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iGos98CDWJFnllXPkCf8GCsRc1D6heFPT8Ll+q6MHeLy0v8iW8HvOnABe+bnd/dY8
	 Fj6xY0lnNvx0cLeybulsFMPH5PNYyIRtZaE/9+HQvcALFKBJF5CpZ9DqbKjMsCuEW4
	 2TW1HpV2WXbtF9Oa7L4FtRe3U5R48bCtsBvt63QFKRjgrmkiXUi0ajC0sYkULz9nZp
	 t/WF/tfglE4p/ZEak3bpvtrg+FjOIOPDTrQoV8xLABTyokXa+vv9dbyQZOKsn1GvnC
	 6jTiDLxOEDzEByv212uS/1McM8X2HI0QUNmfWdbz7KAQriKAMzyv2n6EF1JN9nSZQ0
	 GREHWwMO3yiyw==
Date: Tue, 3 Nov 2026 14:25:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Message-ID: <20261103122542.GH264423@unreal>
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
 <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>

On Wed, Oct 28, 2026 at 01:49:23PM -0400, Zi Yan wrote:
> On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:
> 
> >>>> +	/*
> >>>> +	 * VMAs that cannot become writable map the page as a raw pfn, like
> >>>> +	 * the device memory it replaces. The page lives as long as the file.
> >>>> +	 */
> >>>> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> >>>> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
> >>>> +		goto out;
> >>>> +	}
> >>>> +
> >>>> +	/*
> >>>> +	 * This VMA is forced to always be shared so this doesn't have
> >>>> +	 * to worry about COW.
> >>>> +	 */
> >>>> +	vmf->page = page;
> >>>> +	get_page(page);
> >>>
> >>>
> >>> This split handling is pretty horrible TBH.
> >>>
> >>> In once case we take a reference in the other not?
> >>>
> >>> Why not perform a PFN mapping in any case?
> >>
> >> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
> >> not fixed. I can fix that part as well.
> >
> > We should do that; returning kernel allocations from this function in ->fault is
> > bad.
> >
> > How urgent is this fix here? (can it actually be triggered?Specific hardware?)
> >
> 
> Not urgent. Like Jason said in another email, RDMA only runs on arch
> with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
> zero_page checks in rmap will fire on the returned zero_page.
> 
> >>
> >> The read-only zero page part might need more attention, since
> >> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
> >> to add the support for rdma_umap_fault()?
> >
> > We just have to make sure that we cannot install it writable etc. But that's not
> > a concern.
> >
> > Just have to be careful :)
> 
> There is one wrinkle, it does not work on
> s390 + mm_forbids_zeropage() == true, where zero page is not present,
> and a private zero page is needed.
> 
> Jason, is RDMA supported on s390? 

Yes
