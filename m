Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794910893;
	b=O3A2476UtZqI8LL3vX+8c0TSR4zW/eml8SzQeGaMEkgzHQzhQU6EOeyF771CVkSOxYAD
	 IbVL7D1ijzX3Jh5bCK+cyeRMqrOdF1WpN/TVAc5xz5pmjjZA+QuPrR8H1hXlGmCiEgztL
	 LN4TfDEQcm3MliXq+er3UF/5KJdP6jY3vLFukJ1LOmsOenx4lCsdL9wyArfUQW/YSBDwl
	 jCt5GZmqeixwSN8U8lkS3GMfoVrIXe/2UgUKgWMQG+57aqT09h+86O2bm8KlUluHCm9nn
	 jvw1R8yo6+dHuP28Il3XA+0TBHK7FTDigBueARqcat0w3VHZU1ZJ3/NXvrZy6NhYkYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794910893;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UXZ+gJIG1gP+CKxMaNvlafcmbL7c2harfJRX7gxsgMw=;
	b=iI2F44jEsjHe/fJqfWvc/jC5+3OmqWc6AFSBf1HO3OIdBNK3NeDO5QQ6WwhyR/TSI1oD
	 kvlSlc3bVxyQyAfdH02x2PLdSgy6I2VnFnSJl+uMj0jvrgvaBbILGrQ14KISNfwQePUql
	 jt54bBUghf/skqBLhet6IETrFqb3SeBhLt3VOqpD85Az3C/x0mzJ9Dy1yv//+M176bzkw
	 C+CTCOqg2k2Rs5/35W4V1VcIqbykyyuNKw9j8KM/lHHyGVfcSMI1GlnAmVnRVlJTUwFJ+
	 AlDIEThtVlSkMtR41KqZWJpiDB7sxNbMgAIEcn+NeYPiVatPV2MCQIO170oRWcK6KqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D4vzbT3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276A2606A31C;
	Tue, 17 Nov 2026 10:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D4vzbT3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50EE1F000C7;
	Tue, 17 Nov 2026 10:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910893;
	bh=UXZ+gJIG1gP+CKxMaNvlafcmbL7c2harfJRX7gxsgMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D4vzbT3sw6LKGRN1Fg0eToodi7N2R3UHzlrzyKZcneYi5J/U0DmDi89zjIaNP7pyS
	 o26kzC7X/Z7O6vkZCrPxe6Y2s1wjY/PAqZDwbbMBnRCtUl8eMqa0urT7Loya0Rn0lo
	 z1KLoBuF19/bJ9Vgm/5uGC9cPGVtz4KGniyfFwyzW3XwRCzRDA39L2lWGYcWbUVUVo
	 0Y1WxFNqDlcvdOEk8AKLlIiP2HaIqPWGjnokZeRZgiYWbhCf+xAPAX6JGK7cyWH8vY
	 ljTYNlayqp0pdAmVEPtObScMCePJssRfTggh1ZV9DHp5hInv8hoKtVIBfM41sJ7YA+
	 j/OEM5rAPdiDQ==
Date: Tue, 17 Nov 2026 10:21:18 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chia-I Wu <olvaffe@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Evgenii Stepanov <eugenis@google.com>, Ian Rickards <ian.rickards@arm.com>, 
	Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>, 
	Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Peter Collingbourne <peter@pcc.me.uk>, =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kexec@lists.infradead.org, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Message-ID: <avwp1ZpVudiT1Gux@gremlin>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-6-jeffxu@chromium.org>
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
In-Reply-To: <20261116230627.3537051-6-jeffxu@chromium.org>

On Mon, Nov 16, 2026 at 03:06:25PM -0800, Jeff Xu wrote:
> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so that
> both GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE allocations skip KASAN
> unpoisoning on allocation and poisoning on free in HW_TAGS mode.
>
> Previously, commit c275c5c6d50a ("kasan: disable freed user page
> poisoning with HW tags"), commit 70c248aca9e7 ("mm: kasan: Skip
> unpoisoning of user pages"), and commit 0a54864f8dfb ("kasan: remove
> PG_skip_kasan_poison flag") added __GFP_SKIP_KASAN to
> GFP_HIGHUSER_MOVABLE because user pages are not intended to be used as
> directly addressable kernel data structures, and the lower likelihood of
> catching a kernel linear-map bug on user payload pages does not justify
> tagging all 256 16-byte MTE granules per 4 KB page on every allocation
> and free.
>
> GFP_HIGHUSER shares the same kernel-accessibility contract in
> include/linux/gfp_types.h ("for userspace allocations that may be mapped
> to userspace, do not need to be directly accessible by the kernel but
> that cannot move once in use"). The only semantic difference between
> GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE is __GFP_MOVABLE.
>
> For every 4 KB page without __GFP_SKIP_KASAN under CONFIG_KASAN_HW_TAGS,
> mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via STG/STZG
> and DC GVA/GZVA) on allocation (__kasan_unpoison_pages) and again on
> free (__kasan_poison_pages). For users of GFP_HIGHUSER, this can
> significantly impact performance when allocating and freeing large
> buffers. For example, in graphics and interactive UI workloads, large
> DMA-BUF and DRM/GPU buffers are allocated with GFP_HIGHUSER: while
> steady-state rendering reuses swapchain buffers, UI window resizes,
> surface creation/teardown, and app or scene launches synchronously
> allocate and release tens to hundreds of megabytes of DMA-BUF
> framebuffers (~32 MB per 4K RGBA frame, or ~96 MB for a triple-buffered
> surface) and GPU shmem pools directly on UI, compositor, and render
> threads. Touching millions of 16-byte granules stalls these critical
> threads for milliseconds per buffer, a significant share of the 8.3 ms
> (120 Hz) / 16.7 ms (60 Hz) frame budget, while polluting CPU L1/L2 data
> and MTE tag caches, evicting hot working-set cachelines, and saturating
> DRAM bandwidth (especially on free when DMA pages are cold in the CPU
> cache).
>
> GFP_HIGHUSER is used by subsystems such as the DMA-BUF system heap, DRM
> GEM shmem/TTM and non-movable HugeTLB. They use it instead of
> GFP_HIGHUSER_MOVABLE only because their pages are pinned for DMA or
> cannot migrate.
>
> What skipping KASAN means for the kernel's own accesses to these pages:
>
> - Through vmap(): nothing changes. With CONFIG_KASAN_HW_TAGS those
>   pointers already carry the match-all tag, so the page tags never
>   protected these accesses.
> - Through kmap_local_page() or page_address() (for example ramfs):
>   post_alloc_hook() now gives the pages the match-all tag, so these
>   accesses are no longer checked. GFP_HIGHUSER_MOVABLE pages already
>   behave this way. Callers that want to keep the checks use
>   GFP_HIGHUSER_KASAN: the previous patches in this series converted
>   pipe, FUSE, kexec and RDS, and backports of this patch should
>   include them.
>
> Slab allocations cannot use GFP_HIGHUSER, because they do not accept
> __GFP_HIGHMEM. GFP_KERNEL, GFP_USER and vmalloc() allocations are not
> affected.
>
> This patch does not address the false-positive KASAN report after shmem
> swap-in readahead with MTE that was reported on drm/panthor [1, 2].
> There, swap_cluster_readahead() allocates swap-cache folios for
> neighboring swap slots with the gfp mask of the shmem mapping being
> swapped in. If such a slot holds a page that userspace maps with
> PROT_MTE, the folio keeps a KASAN tag in page->flags that does not
> match the userspace tags restored by arch_swap_restore().
>
> This patch only removes one way to hit it: shmem mappings that use
> GFP_HIGHUSER (such as drm_gem_shmem_helper or panthor) now pass
> __GFP_SKIP_KASAN to readahead, so the neighboring folios no longer get
> a KASAN tag. The readahead path itself is unchanged, and shmem mappings
> with other gfp masks that lack __GFP_SKIP_KASAN can still trigger the
> report. That issue should be followed up separately, for example in
> [1].
>
> On an Armv9.2-A device running a 6.12-based kernel with kasan.mode=sync,
> this reduces the allocation + release time of a ~32 MB buffer from
> /dev/dma_heap/system by ~80%: allocation is ~59% faster and release ~98%
> faster. Poisoning on free accounted for ~55% of the total before. In an
> application loading benchmark, the OpenGL score improves by 15-23%,
> recovering 60-80% of the regression that enabling MTE causes.
>

This commit message is just inscrutable. It's like reading Finnegan's Wake :)
LLMs are obscenely terrible at this stuff unfortunately.

You seem to have rewritten commit messages for the other patches, could you do
the same for this one? Thanks.

> Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
> Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
> Assisted-by: LLM

This tag isn't used any longer! Thanks for acking LLM usage though, we prefer
you disclose it but in the commit message or the cover letter etc.

> Signed-off-by: Jeff Xu <jeffxu@chromium.org>
> ---
>  include/linux/gfp_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 567c93fc1cfb..bcc4827deb4c 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -386,9 +386,9 @@ enum {
>  #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
>  #define GFP_DMA		__GFP_DMA
>  #define GFP_DMA32	__GFP_DMA32
> -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
>  #define GFP_HIGHUSER_KASAN	(GFP_USER | __GFP_HIGHMEM)
> -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>  #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
>  			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
>  #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
> --
> 2.56.0.611.g1030f0b940-goog
>

--
Cheers, Lorenzo
