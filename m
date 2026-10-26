Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793017231;
	b=Y7veHJRIdaHNByUz+KhQlRq+M7OoANholY8YgCtB9EdY+Y6uBpPlevoVsg6foJBNdGxg
	 0aF9tZdw3KHPzSIuutRSx4oAcVlOCRg1m2twXTQmPD4o00LWrTSXy1gs5UXKDw3iOjwS6
	 4QIM74ev09oaXAtiWGilxZaBWnbrmbuxObO1cLXMxq1OOlc8+2C/N4SGEEewuaSDhxQAD
	 RcfidtQNwjM1I4GbeIivq7WSsypYwmfKOMcJUjlDUyMuEZEEZFzvss8e2ORzo4jWmiL48
	 Qm7c+vSf0ui5Qqy/pXsOYPykH7sEvRTnk4HaR1qL73K/T5lMNCh1RfqUIVOk4uJdVgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793017231;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=M2b8Cpwjp/vQVDnm2g9Ld/DjAGfbM4iZVTCxpoq7yDU=;
	b=OLZsh6NzrHBh9gYoOPoeJrbTlcxIWIoHWDdueWvht1oM5Z9Nbox9egDyTIWMZaQK43SZ
	 RP+yBRLmbAo4pKGudajFF9W0Cjj25crcbwKq4c43dUQTGkgIgXaucJH0SXG0UOr8PKq2/
	 FRSLi7HSmoCWsblnDZaHf7kAU5p53yD5ZM6vP0uqZr841MJRuirbFrOJFcZu0rB8F1BGa
	 7wto0intRdzmKyRq3NpoG06obAf8QI80czzlQZR51+4PHCt74KJS4bveUiyLEWELf/6Lp
	 ZELy1vkEr1g54XKiXaZwz1t9bIHmmLOlm3SXuB/p9hQxq6v8D7aS27lsvCSVcvKoZ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HL/XciLR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FE2606A31A;
	Mon, 26 Oct 2026 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HL/XciLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F081F01825;
	Mon, 26 Oct 2026 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793017231;
	bh=M2b8Cpwjp/vQVDnm2g9Ld/DjAGfbM4iZVTCxpoq7yDU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HL/XciLRn2tWpwwLLrUJl0MVaUmqH+DsJ3qccRi03nf4Pd24xS17o7ct81jnxMoRa
	 CGLYLax5txB8YcN4JV7kFYIuxLu+sZIOExdpF2HwQVkVfFghNtlZ2O30DnSu4B6tzW
	 Hm0zPBxxdYYFg6aBgZtmpv/x0l4tRlKMinyFhc09gK94gf7GUar32ygwA0iuMI9ZPE
	 nQIrerybF1GR8oFAwx7ioyXS+cXXiSxmeDP1x+/fkDjhSdEdk5aZkNThsFao+EGdI8
	 yftOFqss3J7a7J/zoSbg88XCRxZVWr86wk1BqOwud6QzcMw+O3lvE6KPvugPeSNj0m
	 P+1pwxzfL9vgw==
Message-ID: <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
Date: Mon, 26 Oct 2026 13:20:25 +0100
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
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/26 03:04, Zi Yan wrote:
> After disassociation, rdma_umap_fault() returns the shared zero page from
> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and goes
> through rmap code. Two issues:
> 
> 1. shared zero page causes VM_WARN_ONs in rmap code,
> 
> 2. normal pages in shared VM_PFNMAP VMAs cause accounting leak on arch
>    without pte_special(), namely the page refcount, mapcount, and vm stats
>    are never dropped.
> 
> Map ufile->disassociate_page for VMAs without VM_WRITE and VM_MAYWRITE,
> with vmf_insert_pfn(). The page lives until ib_uverbs_release_file(), which
> cannot run while a VMA holds a reference to the file.
> 
> Writable VMAs keep returning disassociate_page in vmf->page, thus its
> accounting leak on arch without pte_special() needs a separate fix.
> 
> Userspace can see two differences after the patch. A mapping without
> VM_WRITE and VM_MAYWRITE now reads what was written through writable
> mappings of the same uverbs file instead of zeroes; after disassociation
> both are dummy data. The first fault now allocates the page and fails with
> VM_FAULT_SIGBUS if the allocation fails, as a write fault already does.
> 
> Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The issue was discovered during PG_folio development when making sure only
> rmappable folios can enter rmap code path.
> 
> Alternative: map the zero page with vmf_insert_pfn_prot()
> ===
> 
> Read-only mappings could keep reading zeroes if rdma_umap_fault()
> installed the zero page itself as a special PTE:
> 
> return vmf_insert_pfn_prot(vmf->vma, vmf->address, zero_pfn(vmf->address));
> 
> It does not work today. Commit 7b466529307be ("mm: disallow raw PFN
> mappings of huge/shared zeropage") makes vmf_insert_pfn_prot() return
> VM_FAULT_SIGBUS for the zero pfn. vmf_insert_mixed() does not support
> VM_PFNMAP, since vm_mixed_zeropage_allowed() warns on VM_PFNMAP.
> 
> The first version of that patch [1] did not change vmf_insert_pfn_prot().
> Due to no in-kernel user at that time and complication it can cause,
> vmf_insert_pfn_prot() rejects zero pages now.
> 
> Fix to writable VMA path
> ===
> A new vmf_insert_pfn_mkwrite() is needed, since vmf_insert_pfn() has a
> narrow failing scenario. When a process mapping the disassociated page has
> soft-dirty tracking enabled, vm_page_prot becomes read-only;
> vmf_insert_pfn() then uses a read-only PTE instead of a writable one;
> fixup_user_fault() is used to write to the page (e.g., KVM with the uverbs
> mapping as guest memory) and fails, because it does not take the second
> fault to upgrade the read-only PTE to a writable one.
> 
> LLM was used for investigation and code development.
> 
> [1] https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
> ---
>  drivers/infiniband/core/uverbs_main.c | 44 ++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 2a046c888dfab..c3638bf031b15 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -725,39 +725,51 @@ static void rdma_umap_close(struct vm_area_struct *vma)
>  
>  /*
>   * Once the zap_special_vma_range has been called touches to the VMA will come here and
> - * we return a dummy writable zero page for all the pfns.
> + * we map a dummy page for all the pfns.
>   */
>  static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
>  {
>  	struct ib_uverbs_file *ufile = vmf->vma->vm_file->private_data;
>  	struct rdma_umap_priv *priv = vmf->vma->vm_private_data;
>  	vm_fault_t ret = 0;
> +	struct page *page;
>  
>  	if (!priv)
>  		return VM_FAULT_SIGBUS;
>  
> -	/* Read only pages can just use the system zero page. */
> -	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> -		vmf->page = ZERO_PAGE(vmf->address);
> -		get_page(vmf->page);
> -		return 0;
> -	}
> -
>  	mutex_lock(&ufile->umap_lock);
>  	if (!ufile->disassociate_page)
>  		ufile->disassociate_page =
>  			alloc_pages(vmf->gfp_mask | __GFP_ZERO, 0);
>  
> -	if (ufile->disassociate_page) {
> -		/*
> -		 * This VMA is forced to always be shared so this doesn't have
> -		 * to worry about COW.
> -		 */
> -		vmf->page = ufile->disassociate_page;
> -		get_page(vmf->page);
> -	} else {
> +	page = ufile->disassociate_page;
> +	if (!page) {
>  		ret = VM_FAULT_SIGBUS;
> +		goto out;
> +	}
> +
> +	/* Make sure the page is usable, like what __do_fault() does */
> +	if (PageHWPoison(page)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out;
>  	}

Is that really required? memory_failure() complains pretty hard on pages it
doesn't know how to handle (random kernel memory).

I'd assume that this here is not an ordinary pagecache page that mamoery_failure
would know how to handle?

> +
> +	/*
> +	 * VMAs that cannot become writable map the page as a raw pfn, like
> +	 * the device memory it replaces. The page lives as long as the file.
> +	 */
> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
> +		goto out;
> +	}
> +
> +	/*
> +	 * This VMA is forced to always be shared so this doesn't have
> +	 * to worry about COW.
> +	 */
> +	vmf->page = page;
> +	get_page(page);


This split handling is pretty horrible TBH.

In once case we take a reference in the other not?

Why not perform a PFN mapping in any case?


(Does GUP have to work on these things?)




-- 
Cheers,

David
