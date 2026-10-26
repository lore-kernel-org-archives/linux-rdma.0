Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015398;
	b=nmR8himna9ZexeSE0urgBMsa8bmUaD5Gc7iHqMQ0r6xn5RQnQchKOkHmUKvFkWUmFsYS
	 ZcmGqVsjxTtpbWeI+WsqRyOCHOU6JZl2GjX0yCVHyWvDT2NMyWSw4jRtiupAlG7o3gLFj
	 JF13TUzUPFEziBHYzyFRRSM3QGAc81sacUO5yzxM+Q13kaKu3hFlejvbO6Wxk55fubfDJ
	 XQQMmDmvn3U218zqfjoKnae9y1cHd3Eubqr/YwyJvDfif0McjBqMRayh582jRAkcIxkoi
	 ekDTts3dxCVQ3JA4/Zu/N4xzVyL5YK6HLZOSTt674U0cvGJ5zqll+peEkv8m5MrJnVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
	b=5DLFTLrFiRbk2qRJ2el1z32J2bhBf+O/EOn3IaKTMFrczN2wQALDoDStk/XkgNWJRu9N
	 lwwcG0TtEU2F3/YlD1+8YGKgALcl6w2jo0rUL1K7IkByQdvpYmhREferCQYcMojFWDMff
	 rk+l/rehXQzmjcZZbgPxMyAXW3Nu+pnCOtnhIH0haK70E/fbqW8bLOk4f0BuRH34TNWj5
	 eDGBZqVhcSn7M6DNJLP7Py6V7SWcXkBxLZwT/37lj8DAsIwhjmdxpFcCp2jXuHnIrNEgD
	 Pv8GDq1HGr7tTiD0j0TGtPu5Ic1CY0ILLnFm4GSl3Z6GUQmPRuzNTTffFHtdSs9+i1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="hK/O+qNX";
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18804606A31B
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 11:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18804606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=hK/O+qNX
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e515769d3so277799185a.3
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 04:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793015397; x=1793620197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
        b=hK/O+qNXeJhM5LwnoL5qBYJ78C39bcD2ABnxRxe/3llRlU4tp9cMOVGl+LwFqsqq+Y
         FG9IHBVTzbFW3jDQG4byXq8q2I7TZpddzAGui/B2iAs3677YpjhMOfYlC2gIbJ2q5QwO
         SNBWmUWaUk3J/2BY5DHpWRCIwha1AWKbTVP97/ODeSGeCT1cquJIYXuAB8l639TfhmCo
         KASeJfnVvxLs6Ljxqxm5ewDzEy7Lt0W966BDSOTQD3QYsHQU3JYhlTClAq4I6D8k2bh7
         62kHDec50pnNXKFn9o9MNyTuE9jgqK024AnDUd6cU29tmoDcGaMzmADf8cgCCW57cT3I
         N54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793015397; x=1793620197;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
        b=ePYLavpni2ydK/+m75y3aiaH/822fNimkWgb+Ocy/yLCJYbZcHPxXvkI0O+kd1QOlU
         Ic1801O1nGZRZXGWHpv8ZT35td2pXTlbxot3/NJP/A4XnsxpUSJf7bqZsjDTaBHyqKwF
         B3px26jY+GcFJgBcslcwTQEuEdsGPkWWZRkfqNZFlLWGy4Je6NL2Xr9d8ywztprjmHi+
         kyMgFOGd4v/jnwjDwm9GXnD/plohNrEcVLy5vjMLdavIgWMrQ4AEccG8+JzP4uUzgvGK
         2iIqGIKJz+uENsPqIle7YNlcQtxBlv0D7996ftlraFNcZtXNucf8wJsuXG4ut4caR1nz
         oJRQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTKFwuB68RBeqdrHP5K945uyFgP76OUhgjpMJju5LVBQ9MG2+TE+kYrXl64il/hv6rzNwDuKpmZfTf@vger.kernel.org
X-Gm-Message-State: AFq9FYKOLk0G8pSWfGVJZm2iHZJ+uP6Thlwz40VjIEj4UP2TqDexQtCo
	lHiHN8FMW5QVuJO1DvPE0oIQIGGHthTwQ39qq5WKpOgZ2/p16W73TU+crrLm7RV9FGw=
X-Gm-Gg: AYBFou3CcpbhBxQZMVQ+8Lf/bmAyQ/hTZacf4Oa8InmjDsx1bqf8ATjMGqAtVN7FAcb
	oP3hxhU3Awne0Pxd5GT+s9ptHVUD/ASJsmdi56sDDj+CyxgzcV9agFCVXZ/NWTUFQT1MLuloMUm
	vjQ631AEuE/refGbvbbww5arrDEFl12/+r9zRJydaKXV4RjIO8fpw2NO2t0X1ix4YoJpFcrCUwB
	1t6BeQQ+vtqoOMGmUl12i0j9g0z8qI/QXFEYlp84y66Y3jVN0XVtwr5vxGXp196hAcySJ3ovSEJ
	RRwVu8ECllv9HDc4o4zXq/ST69DXGM8aCIjbRZ8QZbxvhQxufMJEL/RsT5FVXOCKa4JFVvasAHY
	AS6E6SgF03LQBXirBEz3mShdvt0wl5VD+n/Kjq0e/yz9XcZ3v/yzyPLlPEhTgr2dFc2Rv6QenZX
	7kJpT/LDvMgSBCBrysmrnEfg/+AsDaYg3cvC8yRia3k/nDnCKU4CU0w7RtEYz5rNKuLIhPK2xUs
	LZE+JBQTJSXqo2O5WV5X8xzBBih0US9sXkmf1wFq1smd13PPlDTXo0iYtZxYHI8zwnVZPWB4v2f
	uGcvAR0aqQexEagKPjOpbyt/8RAq+UxZF30YWsie8ib3xYV1+VnnJmd90l0=
X-Received: by 2002:a05:620a:4482:b0:93e:c12c:43f9 with SMTP id af79cd13be357-940ef9bcb84mr927155285a.70.1793015396920;
        Mon, 26 Oct 2026 04:49:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f06690c0sm666997585a.11.2026.10.26.04.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:49:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xLJD9-00000006ir2-3FkQ;
	Mon, 26 Oct 2026 08:49:55 -0300
Date: Mon, 26 Oct 2026 08:49:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Message-ID: <20261026114955.GP3977851@ziepe.ca>
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
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
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>

On Sun, Oct 25, 2026 at 10:04:42PM -0400, Zi Yan wrote:
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

Is that why all of the above was so hard to read?

The zero page was used because things like the clock page really need
to be zero. Reflecting back random things from the disassociate page
is not going to work out.

I don't think rdma supports any architectures without the special bit
so I'm not sure this is a real issue in practice.

I guess using vmf_insert_pfn_prot() consistently is the right answer
since these VMAs are not supposed to be mixed maps.

Jason
