Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794925189;
	b=R4gWd0TsHF2JFuo7DC/05VZSkcwIinFBisFiOMOFKN1mAg7FZNRu01apq3WTGBVyopnZ
	 SitJTLLfDfGQa+XqD5EQ3M/EBi19v8Zb31yoykYAqAOAo1E/M0NGaZ+/j4//LxYOBTasL
	 oC+KDLZf+Zh1OR4l6TJBAg+lCQ8ztj2TvWqXdqG9+0wabYoMQZkcK/epbKWWjMQGtCcRw
	 B7EDY1Ncx7IpjeuNnYrFbB5Ece6ob7i4GkQTxeQNivw4EKtBo4D00DX4HjYVp7DpJ48cp
	 6j0yJ3qE6TzB3c5coLpEBW/Nu1mUUSGVXOWIrxE7J9SnxGCtddv/SrG4vtzPdoGIfSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
	b=hOohN4++i9R0WieWK3EwtwfIZZ+qsNMdnG213lVuco9O5kt9BP9VU4OMeGeKCkHUJFv/
	 UIWwk1U6NIuYwEFsrRv8pMOsu/MRyoMrivjybUZ7M/k7NqH4cTV5Ayv+6AeI3DJhk02ni
	 xgirSLMDHMTL7N8atshjrcdayn3PG42tVrqOKtPISbzzJqr1giy1yQTVZ5RgK0eCI59u8
	 CwKG2ifKsIYqoKtUZ7kxNOLqUxi8vVzDvJDTgfqkH0GT6vP0CcV9KeBZUxjJ30Bpq3BjF
	 WgoIXtPv26xO3BNapSCmLs5h7LxgVsd6/nnOfJydr22cImHH26SH8Ud8HvU/pD0Xkbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=CfhREIjf;
	arc=none smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE02606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE02606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=CfhREIjf
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be3cff0f6cso3198600e87.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 06:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794925187; x=1795529987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
        b=CfhREIjfWwbThKrSrBvauIPZHeC8nO5+8Ne7IIvHJ9J4ybZv/nGd5mZ8Y9Jh6jkuTT
         XH2Hv9akK66GETdTs0lc8KvhZkiDCRDiFSiO9qWojOmqQL/DQ6HunnzoZr6xg6RTHolM
         fyxRSOodhHNIEn/7PatCLSj2M2LHzFpnpg4EI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794925187; x=1795529987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4FXZ9QjPMWSPXHYn/FS5PKL+JaPOXiDC39K9maTGAmk=;
        b=fVmWHT+TaKwrVARN7Lk8Ve5MhLNIfCurdhWO7Zzs0TSTkgmePLCZoHHNn1Zeq1x8Nm
         b+4CfS2fWWQBGGs1BdQRGVj4Pk8xAm8mAZs1awFyvPXMf3m4urFtPt6duI2mdlxufoLc
         yo0jBLaOcYek86OJ8/Cs3vNh6ukJKtN6JPW6HmXb9S6SITHWncer5Mbmb4W38VkoPEuh
         b8Q51id4Ee4oKqbb6rMbH6oM7HUH9uA1VguQNb0cSdIlURcDZMjoOKkITrzD2JIL4wS0
         lcJJtrFjJqQiGTNqy6RaLrIJZes08QVuo4GqMmiNNiXGzJG5AJqcsxRhA7dnlY5jqzPT
         mgGQ==
X-Forwarded-Encrypted: i=1; AL+hErEwMTW2/sZi99aSUBfJF3ZoYn6jx3P+HnEDmQTG20J9nxtewu5U9SXOmz54NXktXkML6tk+Z1fey9wK@vger.kernel.org
X-Gm-Message-State: APuU4Z+54RNKlbk854pKlG1zExBAQxUNGq+y5s4zl2GhFN3MldzvsBDX
	JEvU8PkoZKANzIXm+NwZXB6dDlTcbULIfpSSpNCHahkn9us9b3I2kfXBjgF328F88V+4C10vJgM
	hsxYcs60AlEiZlw==
X-Gm-Gg: AYBFou1BPrR8yR8YvG/Zn6z3OPzgn7dt0+dWRT/FJP3LkToCHABdCmgoQDiGkLt4FGl
	/iTvKcTuipX0TwJW0Bcc0Cs26jW3j3aFiKorUGR9f7mIQ4X02AOtSPoZs6PWN+ozsV2vMu4YitE
	tdYM/U+VcBXBPpsyj8pKrreJtE5f94NnqwoHOr/2eb2jvFwfvqwHQ+ah++c5OsluyInoCGm46Jw
	7wRwKX96bjnlN3t4pou2w4/ZFNT4MiwCcdPBjgYpscs7r0HrUhMC9i+nLOF2mCXl5+nv3QOU0we
	+JZIVzboi2z2ahlrG0cN8o97Q3VoAPoZ/WSeEWoqpU4MlMsjfN7c+/LQfGkkDdwLAnnLR5D8Mb1
	rfaAv7ompqQmMK15cSNHodq1w+3K+Nhll2vTybM3t6olzwiMrr7RdXejdZAsJTAm3ibb/1wpgXS
	csuFpiXpzRcZaYrPSBoge/GogXXPz6QzChpTI1hlCnuPMnb+LcBBIJbss20OuZb958lcSdXXcGB
	UvAz1BrFXCPFIOapySkt/PDiDWiy++VXZ7gcgZpCSlHhbwWONOv28ox1k4ROSpYLumROhl8la4X
	fy/g3Gw5GsjAGT1W/ipaE+M7gLnQOnaHK8fhygPENhtUh3Za09f7SvMXfFm9XLHW8LI8pB0C2zg
	ctVZ1dpqfBA==
X-Received: by 2002:a05:6512:239f:b0:5c1:4793:bf2e with SMTP id 2adb3069b0e04-5c1709e5366mr5525963e87.44.1794925187208;
        Tue, 17 Nov 2026 06:19:47 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c171356581sm3987779e87.66.2026.11.17.06.19.47
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 06:19:47 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9565e87.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 06:19:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG+2DvgDfYailGVlJYJJJ0ol80/198VF5tF27rNZ+Bj70hL7c43XAD4EmIyEMaV8LZeoacPiBj05/5I@vger.kernel.org
X-Received: by 2002:a05:6402:a511:10b0:6b5:5d24:5d90 with SMTP id
 4fb4d7f45d1cf-6b85b4c22d8mr72630a12.3.1794924698252; Tue, 17 Nov 2026
 06:11:38 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116230627.3537051-1-jeffxu@chromium.org> <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
In-Reply-To: <2066d131-f999-4747-beb8-520d5e0ce1db@kernel.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 17 Nov 2026 23:11:19 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
X-Gm-Features: AclHuK8ZMC6yRFY7VxkKfsQMYV8BNfasB49bEPdk_bBjeXaAi9-9aO4mXcafXvg
Message-ID: <CAAFQd5DzTmyeVQxNdhdy8pPi+ts1cCgbztVJiMoNBeJWBzjdQQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/7] mm: kasan: skip KASAN for GFP_HIGHUSER
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Evgenii Stepanov <eugenis@google.com>, Ian Rickards <ian.rickards@arm.com>, Jann Horn <jannh@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>, 
	=?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kexec@lists.infradead.org, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 7:10=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/17/26 00:06, Jeff Xu wrote:
> > Hi all,
> >
> > Currently, GFP_HIGHUSER_MOVABLE includes __GFP_SKIP_KASAN (commits
> > c275c5c6d50a, 70c248aca9e7, and 0a54864f8dfb), allowing movable
> > userspace page allocations to skip KASAN page unpoisoning on allocation
> > and poisoning on free under CONFIG_KASAN_HW_TAGS (ARM64 MTE). However,
> > GFP_HIGHUSER does not include __GFP_SKIP_KASAN, even though it shares
> > the same kernel-accessibility contract in include/linux/gfp_types.h
> > ("for userspace allocations that may be mapped to userspace, do not nee=
d
> > to be directly accessible by the kernel but that cannot move once in
> > use") and differs only by !__GFP_MOVABLE.
> >
> > Moving __GFP_SKIP_KASAN to GFP_HIGHUSER addresses the performance issue
> > below (following up on the earlier drm/panthor discussion [1, 2]). The
> > swap issue from that discussion is not addressed by this series:
> >
> > 1. Performance: For every 4 KB page without __GFP_SKIP_KASAN,
> >    mte_set_mem_tag_range() tags all 256 16-byte MTE granules (via
> >    STG/STZG and DC GVA/GZVA) on allocation and again on free. In
> >    graphics and UI workloads, DMA-BUF (system_heap) and DRM/GPU
> >    (shmem/TTM) buffers use GFP_HIGHUSER; while steady-state rendering
> >    reuses buffers, window resizes, surface transitions, and app launche=
s
> >    synchronously allocate and free tens to hundreds of megabytes (~32 M=
B
> >    per 4K RGBA frame) on UI/compositor/render threads. That takes a
> >    significant share of the 8.3 ms (120 Hz) / 16.7 ms (60 Hz) frame
> >    budget and thrashes CPU data/MTE tag caches (especially on
> >    cold-cache free). On Armv9.2-A, skipping KASAN cuts ~32 MB DMA-BUF
> >    alloc+free latency by ~80% (~98% faster close()) and improves the
> >    OpenGL score of an app-loading benchmark by 15-23%.
> >
> > 2. False-positive KASAN report after shmem swap-in readahead [1] (not
> >    addressed here): when a shmem page is swapped in,
> >    swap_cluster_readahead() also reads the neighboring swap slots and
> >    allocates their swap-cache folios with the gfp mask of that shmem
> >    mapping. A neighboring slot can hold an unrelated page that
> >    userspace maps with PROT_MTE. If the mask lacks __GFP_SKIP_KASAN,
> >    that page's folio gets a KASAN tag in page->flags. When its owner
> >    faults it in, arch_swap_restore() writes the saved userspace tags to
> >    the memory, but page->flags keeps the KASAN tag. Later kernel
> >    accesses through page_address() then use a tag that does not match
> >    the memory and are reported by KASAN.
> >
> >    This series does not fix the readahead path. It only removes one
> >    way to hit it: shmem mappings that use GFP_HIGHUSER (e.g.
> >    drm_gem_shmem_helper / panthor) now pass __GFP_SKIP_KASAN to
> >    readahead, so the neighboring folios no longer get a KASAN tag.
> >    Shmem mappings with other gfp masks that lack __GFP_SKIP_KASAN
> >    (e.g. GFP_KERNEL) can still trigger the report. That issue should
> >    be followed up separately, for example in [1].
> >
> > What changes for users of GFP_HIGHUSER pages under CONFIG_KASAN_HW_TAGS
> > (other KASAN modes are not affected):
> >
> > - Access through vmap(): nothing changes. Those pointers already carry
> >   the match-all tag and are not checked today.
> > - Access through kmap_local_page() or page_address() (for example
> >   ramfs): accesses are no longer checked by KASAN, as is already the
> >   case for GFP_HIGHUSER_MOVABLE pages.
> > - Buffers that the kernel itself fills (pipe, FUSE, kexec, RDS) keep
> >   KASAN checking by using the new GFP_HIGHUSER_KASAN (patches 1-4).
> >
> > GFP_KERNEL, GFP_USER, slab and vmalloc() allocations are not affected.
> >
> > Patch 1 adds GFP_HIGHUSER_KASAN
>
> I really don't want us to spread KASAN-related GFP flags in the kernel.
>
> There must be a proper way to abstract this.
>
> Why is GFP_HIGHUSER not sufficient? We were already told that this is mem=
ory to
> be mapped into user space. Placing data structure on it and handing out p=
ointers
> to that would already be a bit questionable.
>
> So what are the ways to avoid GFP_HIGHUSER_KASAN?

I think the idea behind GFP_HIGHUSER_KASAN is to make it possible to
skip KASAN for GFP_HIGHUSER by default (for most of its users), but
keep it for some of the users which today use GFP_HIGHUSER for their
memory allocations, but could benefit from the added security. As per
the other patches in the series:

  pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
  kexec: use GFP_HIGHUSER_KASAN for segment pages
  net/rds: use GFP_HIGHUSER_KASAN for message pages

That said, I'm not familiar with any of the code mentioned by those
patches, so I can't really tell how much they would benefit from KASAN
or if their choice of GFP_HIGHUSER to begin with is correct.

Best,
Tomasz
