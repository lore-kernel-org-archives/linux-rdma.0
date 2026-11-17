Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917232;
	b=oMhGXe2BZxX/YfA0GAAyBsPYO1GCxH2iE+c2xZu5hQkpaF9uPI/WuvuUWyLjvg2UGNnK
	 Kvx4ilV5Tqnk6kZWkglnC5xOZX8YX/zNUSIUsPCuQweopRRVW2Bbm24UvI+Xe+hWB1Oy8
	 ptP9sgQ9BEohQGfuUDPahIQaQ/Z6WsYt4Ju0Z19xWyu5ARPxsWx3AaRzEPNGJt+DRp9vI
	 OyQyLH0peow5PUjzpgmKsK16TE2PleBA3y3utroJ8a9zYlaUrDqRqXCtoXNCWRnX1QTBP
	 U73YUrkA43dCGyLCM9dIdfsVuW30YIuRRF8LZY28KoqPfiMxEDQsUBiaJfEyyhjgDUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917232;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=VOxDJy9TOCvAQR6vCcCRlG4x+qVSMFqIwRXcOJLd+mA=;
	b=ak0+j/Ue6nK3NjJTUfZfHpRZgzJAU/pXyvHc0ZDcABf2DrvxjfDXM8bsIjhksXdT+kwq
	 6Pv+Fu/hdwsDpgPc1ew13VauyIe0HBURK8bXwKnl+pQBuu0PfEbsZUWsP1ItoA1AZHO/2
	 biNt/rbHyCCbfXWANY8DXB2aNOS3cGnwRyF7oITYY9h512CoIaWM8dKUHh3bNUYurLMy7
	 z326kfiPqSN3xBYP1CY6BJjje+YUiyk3YfEbqZ/0rNEYgbwPDmmj8ow5c5rHsLPXhFmcI
	 sQPoF0wy1s3PBDHs4XYsHhLNKwNiPZCeDovJ8wWHBJkwHGTGXbxuGDyc2znhmy9BKhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dE41NnTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288A1606A323;
	Tue, 17 Nov 2026 12:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dE41NnTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE851F000C8;
	Tue, 17 Nov 2026 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917231;
	bh=VOxDJy9TOCvAQR6vCcCRlG4x+qVSMFqIwRXcOJLd+mA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dE41NnTi6gbO17yqFTsArTyug0pn92F7vS/I3uzwxDaxTar9fgQcAwMVjAgkt4zhM
	 xxcD2vRJvS/zgsFJJW9zJvVDL07+2WytffwJ5zaKvccMYOuSm2gCm9iORJyyQvlDBD
	 HOVtwMoT2bXEhPNYmY/UlFl+nO9bXdUSc2YfGolaymWH3ELTuNgDYrIxN40WnKslS+
	 f2ZSVwm9SQAq7FPKmAOjsuT3HWwrzUS5BEfxKbOCDwkNAJH9Hij/XYlK3zdW3IicJR
	 RbRw7I/PSzsKxZ4xAS2LS3onNv6NRn8G+r0DWbotNrfxiO1UIgHnnfn75KIGqV57GD
	 d2JOwOBni7Qlg==
Message-ID: <85ce1f24-8b49-4cd3-a9f7-02d1be69708e@kernel.org>
Date: Tue, 17 Nov 2026 13:06:54 +0100
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
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
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
 <20261116230627.3537051-6-jeffxu@chromium.org> <avwp1ZpVudiT1Gux@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avwp1ZpVudiT1Gux@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 11:21, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 16, 2026 at 03:06:25PM -0800, Jeff Xu wrote:
>> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so that
>> both GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE allocations skip KASAN
>> unpoisoning on allocation and poisoning on free in HW_TAGS mode.
>>
>> Previously, commit c275c5c6d50a ("kasan: disable freed user page
>> poisoning with HW tags"), commit 70c248aca9e7 ("mm: kasan: Skip
>> unpoisoning of user pages"), and commit 0a54864f8dfb ("kasan: remove
>> PG_skip_kasan_poison flag") added __GFP_SKIP_KASAN to
>> GFP_HIGHUSER_MOVABLE because user pages are not intended to be used as
>> directly addressable kernel data structures, and the lower likelihood of
>> catching a kernel linear-map bug on user payload pages does not justify
>> tagging all 256 16-byte MTE granules per 4 KB page on every allocation
>> and free.
>>
>> GFP_HIGHUSER shares the same kernel-accessibility contract in
>> include/linux/gfp_types.h ("for userspace allocations that may be mapped
>> to userspace, do not need to be directly accessible by the kernel but
>> that cannot move once in use"). The only semantic difference between
>> GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE is __GFP_MOVABLE.
>>
>> For every 4 KB page without __GFP_SKIP_KASAN under CONFIG_KASAN_HW_TAGS,
>> mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via STG/STZG
>> and DC GVA/GZVA) on allocation (__kasan_unpoison_pages) and again on
>> free (__kasan_poison_pages). For users of GFP_HIGHUSER, this can
>> significantly impact performance when allocating and freeing large
>> buffers. For example, in graphics and interactive UI workloads, large
>> DMA-BUF and DRM/GPU buffers are allocated with GFP_HIGHUSER: while
>> steady-state rendering reuses swapchain buffers, UI window resizes,
>> surface creation/teardown, and app or scene launches synchronously
>> allocate and release tens to hundreds of megabytes of DMA-BUF
>> framebuffers (~32 MB per 4K RGBA frame, or ~96 MB for a triple-buffered
>> surface) and GPU shmem pools directly on UI, compositor, and render
>> threads. Touching millions of 16-byte granules stalls these critical
>> threads for milliseconds per buffer, a significant share of the 8.3 ms
>> (120 Hz) / 16.7 ms (60 Hz) frame budget, while polluting CPU L1/L2 data
>> and MTE tag caches, evicting hot working-set cachelines, and saturating
>> DRAM bandwidth (especially on free when DMA pages are cold in the CPU
>> cache).
>>
>> GFP_HIGHUSER is used by subsystems such as the DMA-BUF system heap, DRM
>> GEM shmem/TTM and non-movable HugeTLB. They use it instead of
>> GFP_HIGHUSER_MOVABLE only because their pages are pinned for DMA or
>> cannot migrate.
>>
>> What skipping KASAN means for the kernel's own accesses to these pages:
>>
>> - Through vmap(): nothing changes. With CONFIG_KASAN_HW_TAGS those
>>   pointers already carry the match-all tag, so the page tags never
>>   protected these accesses.
>> - Through kmap_local_page() or page_address() (for example ramfs):
>>   post_alloc_hook() now gives the pages the match-all tag, so these
>>   accesses are no longer checked. GFP_HIGHUSER_MOVABLE pages already
>>   behave this way. Callers that want to keep the checks use
>>   GFP_HIGHUSER_KASAN: the previous patches in this series converted
>>   pipe, FUSE, kexec and RDS, and backports of this patch should
>>   include them.
>>
>> Slab allocations cannot use GFP_HIGHUSER, because they do not accept
>> __GFP_HIGHMEM. GFP_KERNEL, GFP_USER and vmalloc() allocations are not
>> affected.
>>
>> This patch does not address the false-positive KASAN report after shmem
>> swap-in readahead with MTE that was reported on drm/panthor [1, 2].
>> There, swap_cluster_readahead() allocates swap-cache folios for
>> neighboring swap slots with the gfp mask of the shmem mapping being
>> swapped in. If such a slot holds a page that userspace maps with
>> PROT_MTE, the folio keeps a KASAN tag in page->flags that does not
>> match the userspace tags restored by arch_swap_restore().
>>
>> This patch only removes one way to hit it: shmem mappings that use
>> GFP_HIGHUSER (such as drm_gem_shmem_helper or panthor) now pass
>> __GFP_SKIP_KASAN to readahead, so the neighboring folios no longer get
>> a KASAN tag. The readahead path itself is unchanged, and shmem mappings
>> with other gfp masks that lack __GFP_SKIP_KASAN can still trigger the
>> report. That issue should be followed up separately, for example in
>> [1].
>>
>> On an Armv9.2-A device running a 6.12-based kernel with kasan.mode=sync,
>> this reduces the allocation + release time of a ~32 MB buffer from
>> /dev/dma_heap/system by ~80%: allocation is ~59% faster and release ~98%
>> faster. Poisoning on free accounted for ~55% of the total before. In an
>> application loading benchmark, the OpenGL score improves by 15-23%,
>> recovering 60-80% of the regression that enabling MTE causes.
>>
> 
> This commit message is just inscrutable. It's like reading Finnegan's Wake :)
> LLMs are obscenely terrible at this stuff unfortunately.

I truly wonder how some can decide to submit something like that with their name
under it :)

-- 
Cheers,

David
