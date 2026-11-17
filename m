Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910254;
	b=Dga18pZ7irVXnr86ZtHrVhbyMhrDhTcjtT2A3qViXXsUKgbJKz+QPvl1sgG9xs9//O0g
	 0XEb9tjDuwUijp2VkANQSeGDBPg7Em2C0qIQ2sjysznkO2VTL4ibdINPLxixRCR5PMfx0
	 LKjmEb3+yoYUtpcNq97AE3iacfFroYMnvPDLOl10xbYuE5t/mgNmhiEGC9f8lXeZ3ugTD
	 uj8TYWoFICCITFSv7Sc4x6COINGQNZ7d7Y3YB2Rm8PJ4RvZR+73oSL9jfVFyFLoeE9wum
	 jjPkjiFWXS46FSCzcYq3fdfNHoDyjOQt8IbZEFY+ZfHg25y0dunj7zSA8hcn1xp+SBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910254;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=+GkmMaOI4w0aqQVtKDo6X7pwmr1pb5SKm4lboaaoDN0=;
	b=KdhW0PNAfIQRDICsjH0h34FImXMF/hHa4DgUQ6TAlq9CMNKcpORxyj0XqItvqEes8K+e
	 XMtmUVwjjYkOBJM+nKtZpL5QN1/sAXDgnLtqfZnmAEYNJlxao5jZCXu6ni9oK6jwNHekd
	 SR0N2QggDtP5UuQF9ZPSWUEt0BLZUoosAtnr9tDJnKDhT2ILd6Ccqd1BkILs7IR5iSspe
	 gcZVLqNhE5UHN6xvCQBR7EO+4jN2sqcJIoZBq35nmClhw9sXs3iWqmvOMkrkGom3p1V4K
	 U07Lp4FHrpjMMTr2/llM2CPPjQHPC0jObUCqlMsXStILTOTqQgvLs+OQz6RREIAIs8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUw8jcou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C390606A31C;
	Tue, 17 Nov 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TUw8jcou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDE01F000C5;
	Tue, 17 Nov 2026 10:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910254;
	bh=+GkmMaOI4w0aqQVtKDo6X7pwmr1pb5SKm4lboaaoDN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TUw8jcou2ovDdPtEhkJuWnsat3KXtYoPaGeopJdgMREGL9aYBGnJbVL1z6osDjWrp
	 Epx4UWIGGOjRLZ/mZiUkM0zkzZhhmQYE+p7SXejlTFbWKUWQ/AHWUVrMLEVc2dBQNy
	 zfilop6KPGIys8xQfyR55lQJlGf45jy2i5SYIQD2bBwSg5IA5pEtddZGm38eD9w9sL
	 5xAuVwiRAfFqyTENPOnPRwuzCvL/cB+BbHq04cHEffnWVxEw0U7k8UbFVcUzzbXqX4
	 xGsVuysvjJg1aYhO0jb/SO4KkFZESBjYvWAmvrEhC7wvnwsam8Pvqt6EQCyZTz1Awy
	 tDjmfe9iLYOrA==
Message-ID: <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
Date: Tue, 17 Nov 2026 11:10:37 +0100
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
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Evgenii Stepanov <eugenis@google.com>,
 Ian Rickards <ian.rickards@arm.com>, Jann Horn <jannh@google.com>,
 Jeff Vander Stoep <jeffv@google.com>, Jeff Xu <jeffxu@google.com>,
 Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Peter Collingbourne <peter@pcc.me.uk>, =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?=
 <ptosi@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Allison Henderson
 <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, kexec@lists.infradead.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20261116230627.3537051-1-jeffxu@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 00:06, Jeff Xu wrote:
> Hi all,
> 
> Currently, GFP_HIGHUSER_MOVABLE includes __GFP_SKIP_KASAN (commits
> c275c5c6d50a, 70c248aca9e7, and 0a54864f8dfb), allowing movable
> userspace page allocations to skip KASAN page unpoisoning on allocation
> and poisoning on free under CONFIG_KASAN_HW_TAGS (ARM64 MTE). However,
> GFP_HIGHUSER does not include __GFP_SKIP_KASAN, even though it shares
> the same kernel-accessibility contract in include/linux/gfp_types.h
> ("for userspace allocations that may be mapped to userspace, do not need
> to be directly accessible by the kernel but that cannot move once in
> use") and differs only by !__GFP_MOVABLE.
> 
> Moving __GFP_SKIP_KASAN to GFP_HIGHUSER addresses the performance issue
> below (following up on the earlier drm/panthor discussion [1, 2]). The
> swap issue from that discussion is not addressed by this series:
> 
> 1. Performance: For every 4 KB page without __GFP_SKIP_KASAN,
>    mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via
>    STG/STZG and DC GVA/GZVA) on allocation and again on free. In
>    graphics and UI workloads, DMA-BUF (system_heap) and DRM/GPU
>    (shmem/TTM) buffers use GFP_HIGHUSER; while steady-state rendering
>    reuses buffers, window resizes, surface transitions, and app launches
>    synchronously allocate and free tens to hundreds of megabytes (~32 MB
>    per 4K RGBA frame) on UI/compositor/render threads. That takes a
>    significant share of the 8.3 ms (120 Hz) / 16.7 ms (60 Hz) frame
>    budget and thrashes CPU data/MTE tag caches (especially on
>    cold-cache free). On Armv9.2-A, skipping KASAN cuts ~32 MB DMA-BUF
>    alloc+free latency by ~80% (~98% faster close()) and improves the
>    OpenGL score of an app-loading benchmark by 15-23%.
> 
> 2. False-positive KASAN report after shmem swap-in readahead [1] (not
>    addressed here): when a shmem page is swapped in,
>    swap_cluster_readahead() also reads the neighboring swap slots and
>    allocates their swap-cache folios with the gfp mask of that shmem
>    mapping. A neighboring slot can hold an unrelated page that
>    userspace maps with PROT_MTE. If the mask lacks __GFP_SKIP_KASAN,
>    that page's folio gets a KASAN tag in page->flags. When its owner
>    faults it in, arch_swap_restore() writes the saved userspace tags to
>    the memory, but page->flags keeps the KASAN tag. Later kernel
>    accesses through page_address() then use a tag that does not match
>    the memory and are reported by KASAN.
> 
>    This series does not fix the readahead path. It only removes one
>    way to hit it: shmem mappings that use GFP_HIGHUSER (e.g.
>    drm_gem_shmem_helper / panthor) now pass __GFP_SKIP_KASAN to
>    readahead, so the neighboring folios no longer get a KASAN tag.
>    Shmem mappings with other gfp masks that lack __GFP_SKIP_KASAN
>    (e.g. GFP_KERNEL) can still trigger the report. That issue should
>    be followed up separately, for example in [1].
> 
> What changes for users of GFP_HIGHUSER pages under CONFIG_KASAN_HW_TAGS
> (other KASAN modes are not affected):
> 
> - Access through vmap(): nothing changes. Those pointers already carry
>   the match-all tag and are not checked today.
> - Access through kmap_local_page() or page_address() (for example
>   ramfs): accesses are no longer checked by KASAN, as is already the
>   case for GFP_HIGHUSER_MOVABLE pages.
> - Buffers that the kernel itself fills (pipe, FUSE, kexec, RDS) keep
>   KASAN checking by using the new GFP_HIGHUSER_KASAN (patches 1-4).
> 
> GFP_KERNEL, GFP_USER, slab and vmalloc() allocations are not affected.
> 
> Patch 1 adds GFP_HIGHUSER_KASAN

I really don't want us to spread KASAN-related GFP flags in the kernel.

There must be a proper way to abstract this.

Why is GFP_HIGHUSER not sufficient? We were already told that this is memory to
be mapped into user space. Placing data structure on it and handing out pointers
to that would already be a bit questionable.

So what are the ways to avoid GFP_HIGHUSER_KASAN?

-- 
Cheers,

David
