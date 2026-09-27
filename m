Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12663C5848
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 21:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790545475; cv=pass; b=UilzFliqHSPawiK+SffMweZXs97jT85a/LeG5rpo6xw2qxF8blsS8m7XbLFVtRcMR8oUVC2LFaEGN5sJ2TMsaSx4+ElyyPbGEazxdgTtQpDV3az+FRJyBzT00R+QuJnS4Pxx5/xaqMvZB0CI3q/OSxOW9VJL9AgXXARc5sqWjS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790545475; c=relaxed/simple;
	bh=FAEI8WA8cSRyBC82ESn9Wgc0lJuxeWzrumO8pwMuOCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYz/hNqjf/xaJFKPDxIVOMP2cUeJF7Mrb77z8WwiFQuAZSB3bM5rzeiiHR3sPS7NCHKrJJ5IkqScCxFVnqaFTwlU1QmWbt5W4l3cA7pKsqqZ4epdZvoykpOJnpfyn58VaN/qbPzvKzmzePYlt3Tb9xUSd94Ds5HJAusvkQqsQUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uTkSzuSH; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uTkSzuSH"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533202fe429so279671cf.0
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 14:44:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790545470; cv=none;
        d=google.com; s=arc-20260327;
        b=g398IioZa4jh730AxFXKQDGOqWkUkDQx6o4mux0du1LkGNLEZOMYG/zexQlVBOByYN
         231gFUzxYIaizKECWHjczVh6Ad3fBDWMrq0s366kLsiox/4DK+x8fV53obkDWcs+0PhX
         Bp2KJzafH6+ynw4Hl77+yd5FfWbVYXlASrXkAdL2yHxDAbPsyWv8rMEYgdrmJM85dY6B
         636PzyfrsdRuQnyeiWbaWIT9KpgnLCDWT0UcfMI0YkdCqKgsr6HsIGWYv0gN2je0Jt2P
         ph45qiFMgXOyaN/k3kR00DJdeiJmr2nljlH92cHGY/vxQTiwKLLv0eDt6/35Z9l+7/7d
         w5BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        fh=xBCF77ZA1kC4n9TsU7LF/kgHOiXOhyXRc0HWpma3F8I=;
        b=s1+VhP/OdMarJqpwYwTzWuc/slKEVqj3XrSdmk2JwT+AZPsAlCZDrDjIVGqR+m4Egs
         JpfbeyGsLeGx53ub9pd7rkoKeDjHMXhWCz3bS1OgNigrO9I1hHM2exW5ANRV+T8eB8sl
         b6YO9Aq/zfdGSgzDsS6xF0M84ecxRnNPSjOiLz3lXAj3JbUpWZHqy4Rk+yMCRUD3KuVc
         /uiWBKR4UzLNBtRGtE09Ow2J+emUxU+zQnnTaXdEhIEyNKbBmJLxnLhnJMi5M06pYmfD
         JjNReJQiwSRK/IO+LYMP09HsTZ2Eu891u/N6oi4qd1uaqBVBjpA/i3ryFrNWoWtupT4J
         14gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790545470; x=1791150270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        b=uTkSzuSHeQFmSzU++DibyNABe/iMCmlnuZARLW+oPzV+mFV1OkuEV8PJE0U/YcZjPu
         4mdU2eIzXntTN8extHtdUTrWM0zlxBCZlHb8yTSX7CxOUY6W+8uJvAsp6vrhsSd33NFV
         gcB7PaSBopm59ICDkX0U+WkQ4ATVyRuqFw2DDw7CtGKI6dAG5d8otg5kCek5HIVxoG/C
         dkESqKBViUiH3IjEVCXruxR284rpAEt+hOVcmMqjzQ74w6oWQNvgWISvUzAPqyATz/PT
         WuGi5gc6LeFYHTgnPi01hn3LJr/iLZP32H7tARvOSNHlS/ETUVvvw7raXIFIU4kjf6b/
         nHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790545470; x=1791150270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y119z7sdl3qfjHiuF1t57ekDKg+i4BGISMvCcdxAaw0=;
        b=2EHEHPfzPZGlObxszpW6uhVMEzFzX6f15pHRkoaiPFsreiVhwI6Jbp5v1uhjzGavMN
         JISXgbQDRUC2i8m7lVXm/6xDaEw58WSs92Yw8mQ5Y6hpsT7skuJl2EitVp8zjCFceYWo
         KL68okpiNf3N1n8DTbKYIRqi6714ZEAwdwBTWR5F628aSKZ5rePgGszivSGr7HN3tERG
         4OFa/eZ4Opr5n1XWMcyrk1ty1MBo01wGsMl8erhADxGvXdUsLDOUN69ZqW8io/UxYHoo
         ZyK72WkTmDy3q5RZofIQYznJ1vb3kR/xnsBS6/0yb3XzP0Sou1I1qfXH1NL7uw+AAryD
         PZRg==
X-Forwarded-Encrypted: i=1; AKwUvBw3iQda1+cTLbtAYV+O/0ZZBhf7vSLAlEsWMS1oryRAE/F8zSBNMJMzLVq4CitwJmu/cqTWSFPDx85R@vger.kernel.org
X-Gm-Message-State: AFuF++n1Rsrn4Ug5SmrB2cTmVKcyjGSOHdj2mJcFzfe7GBgzoZ1YoBh2
	c1L1cp69eSL1QDwjEKUKRwzBrLAFTO8Pgw+RkdOa87vtnfOxcrG3IKjK0zFeF10n8tGpxCTwfMV
	Xk9aWFDS2TJmtllLuhsWfn5tELsb8dgGy2Sp5PWE4
X-Gm-Gg: AYBFou38/SnFrA8yoovkOLFXigiIv2GqlvsAO9nlJ/BzbC5fEurHtFZqkLzRgx+XFAD
	cCWgbh4rzfQYFcKVG7Br/epK7+j6GB36WSCdsYwf0/Q2fi3UgGNVFaRxlnuDpdU8rKBmjOoXNc/
	NUswxQE71cyabyFDI7IUs1jO+WS0fYNdaBdsihOtToXi4G2jYQr8QBPUEps/XDLpYKMf68BgI86
	HygvU55C9/goxtnguZ/8Hj6U7mQo/lxWLlASNp8UU3WFF4WwSOHMwkwesNoZ2ueoY1Ay8KAkwsb
	0cRcbiZP58zJDGbx7f7pnLKXaUnHuSK5y6mf5eBMIFEvWm/W4BU9zA==
X-Received: by 2002:ac8:6104:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-5331fed98dfmr23915841cf.0.1790545469472; Sun, 27 Sep 2026
 14:44:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 27 Sep 2026 14:44:18 -0700
X-Gm-Features: AclHuK-2F2ckU1C-yxhObu0QhsQKrsVKTug_h-Hi9fsC16ALl2HO1fuDhZLvMkI
Message-ID: <CAJuCfpEawD2NUO9EoqKnR6YR59XMdYrtUrj8KEwJVwO8AOk8Lw@mail.gmail.com>
Subject: Re: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel
 page mapping
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 9:27=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
>
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
>
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
>
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state establish=
ed
> by ops->init is released.
>
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
>
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
>
> Users can then use one of the provided helper functions to perform an
> action:
>
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page giv=
en
>   its head page.
> * discontig_kernel_map_page_range() - Maps a struct page ** array of a
>   specified count.
>
> The userland VMA tests are updated accordingly.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  45 +++++++++++++++++
>  include/linux/mm_types.h        |  44 +++++++++++++++-
>  mm/internal.h                   |   3 ++
>  mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++=
++++--
>  mm/util.c                       |   7 +++
>  tools/testing/vma/include/dup.h |  11 +++-
>  6 files changed, 209 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a1f2d375cf7d..2a92193ac6a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_f=
ull(struct vm_area_desc *desc,
>                                      vma_desc_pages(desc));
>  }
>
> +static inline
> +void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
> +               void *init_private, const struct discontig_kernel_page_op=
s *ops)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->type =3D MMAP_DISCONTIG_KERNEL_PAGES;
> +       action->map_kernel_discontig.init_private =3D init_private;
> +       action->map_kernel_discontig.ops =3D ops;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action, bool is_compat);
>
> +static inline void
> +discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +}
> +
> +static inline void
> +discontig_kernel_map_page(struct discontig_kernel_page_state *state,
> +                         struct page *page)
> +{
> +       struct folio *folio =3D page_folio(page);
> +
> +       if (folio_test_large(folio)) {
> +               VM_WARN_ON_ONCE(page !=3D folio_page(folio, 0));
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE=
;
> +               state->__folio =3D folio;
> +               state->__nr_pages =3D min(state->nr_pages_remain,
> +                                       folio_nr_pages(folio));
> +       } else {
> +               state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE;
> +               state->__page =3D page;
> +               state->__nr_pages =3D 1;
> +       }
> +}
> +
> +static inline void
> +discontig_kernel_map_page_range(struct discontig_kernel_page_state *stat=
e,
> +                               struct page **page_arr, unsigned long nr_=
pages)
> +{
> +       state->action =3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
> +       state->__page_arr =3D page_arr;
> +       state->__nr_pages =3D nr_pages;

Shouldn't we cap state->__nr_pages at state->nr_pages_remain like you
do in discontig_kernel_map_page()?

> +}
> +
>  /* Look up the first VMA which exactly match the interval vm_start ... v=
m_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm=
,
>                                 unsigned long vm_start, unsigned long vm_=
end)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9ca2ea3664bc..0cb4f9603956 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -818,8 +818,44 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
> +};
> +
> +enum discontig_kernel_page_action {
> +       DISCONTIG_KERNEL_PAGE_ABORT,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
> +       DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
> +};
> +
> +struct discontig_kernel_page_state {
> +       /* Map state. */
> +       const unsigned long start;      /* Start address of VMA. */
> +       const unsigned long end;        /* End address of VMA. */
> +       unsigned long addr;             /* The current address to be mapp=
ed. */
> +       pgoff_t pgoff;                  /* The current pgoff to be mapped=
. */
> +       unsigned long nr_pages_mapped;  /* The number of pages mapped. */
> +       unsigned long nr_pages_remain;  /* The number of pages remaining.=
 */
> +
> +       /* User-defined state. */
> +       void *vm_private_data;          /* VMA private data. */
> +       void *private;                  /* Mapping private data. */
> +
> +       /* Users should not touch these, use discontig_kernel_map_*() hel=
pers. */
> +       enum discontig_kernel_page_action action;
> +       union {
> +               struct page *__page;
> +               struct folio *__folio;
> +               struct page **__page_arr;
> +       };
> +       unsigned long __nr_pages;
> +};
> +
> +struct discontig_kernel_page_ops {
> +       int (*init)(void *vm_private_data, void **private);
> +       int (*get)(struct discontig_kernel_page_state *state);
>  };
>
>  /*
> @@ -844,6 +880,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index c767007c2187..b81fce5fe510 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1516,6 +1516,9 @@ int simple_ioremap_prepare(struct vm_area_desc *des=
c);
>  int map_kernel_pages_prepare(struct vm_area_desc *desc);
>  int map_kernel_pages_complete(struct vm_area_struct *vma,
>                               struct mmap_action *action);
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action);
>
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 448342883e9d..45b21bb04a18 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2609,17 +2609,23 @@ int vm_insert_pages(struct vm_area_struct *vma, u=
nsigned long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>
> +static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
> +               return;
> +
> +       VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> +       VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +       vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +}
> +
>  int map_kernel_pages_prepare(struct vm_area_desc *desc)
>  {
>         const struct mmap_action *action =3D &desc->action;
>         const unsigned long addr =3D action->map_kernel.start;
>         unsigned long nr_pages, end;
>
> -       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> -               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> -               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> -               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> -       }
> +       __map_kernel_pages_prepare(desc);
>
>         nr_pages =3D action->map_kernel.nr_pages;
>         end =3D addr + PAGE_SIZE * nr_pages;
> @@ -2640,6 +2646,98 @@ int map_kernel_pages_complete(struct vm_area_struc=
t *vma,
>                             &nr_pages, vma->vm_page_prot);
>  }
>
> +int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       const struct mmap_action *action =3D &desc->action;
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +
> +       /* At minimum need to be able to get pages. */
> +       if (WARN_ON_ONCE(!ops || !ops->get))
> +               return -EINVAL;
> +
> +       __map_kernel_pages_prepare(desc);
> +       return 0;
> +}
> +
> +static int apply_discontig_action(struct vm_area_struct *vma,
> +                                 struct discontig_kernel_page_state *sta=
te)
> +{
> +       unsigned long nr_pages =3D state->__nr_pages;
> +       unsigned long addr =3D state->addr;
> +       unsigned long i;
> +
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE)
> +               return insert_page(vma, addr, state->__page,
> +                                  vma->vm_page_prot, /*mkwrite=3D*/false=
);
> +       if (state->action =3D=3D DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
> +               return insert_pages(vma, addr, state->__page_arr,
> +                                   &nr_pages, vma->vm_page_prot);
> +
> +       /* Compound folio - have to iterate through each page. */
> +       for (i =3D 0; i < nr_pages; i++, addr +=3D PAGE_SIZE) {
> +               struct page *page =3D folio_page(state->__folio, i);
> +               int err;
> +
> +               err =3D insert_page(vma, addr, page, vma->vm_page_prot,
> +                                 /*mkwrite=3D*/false);
> +               if (err)
> +                       return err;
> +       }
> +       return 0;
> +}
> +
> +int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
> +                                       struct mmap_action *action)
> +{
> +       const struct discontig_kernel_page_ops *ops =3D
> +               action->map_kernel_discontig.ops;
> +       struct discontig_kernel_page_state state =3D {
> +               .start =3D vma->vm_start,
> +               .end =3D vma->vm_end,
> +               .addr =3D vma->vm_start,
> +               .pgoff =3D vma->vm_pgoff,
> +               .nr_pages_mapped =3D 0,
> +               .nr_pages_remain =3D vma_pages(vma),
> +               .vm_private_data =3D vma->vm_private_data,
> +               .private =3D action->map_kernel_discontig.init_private,
> +       };
> +       int err =3D 0;
> +
> +       if (ops->init)
> +               err =3D ops->init(vma->vm_private_data, &state.private);
> +       if (err)
> +               return err;
> +
> +       do {
> +               unsigned long end, pgoff_end;
> +               unsigned long nr_pages;
> +
> +               /* Default to abort. */
> +               state.action =3D DISCONTIG_KERNEL_PAGE_ABORT;
> +               err =3D ops->get(&state);
> +               if (err || state.action =3D=3D DISCONTIG_KERNEL_PAGE_ABOR=
T)
> +                       return err;
> +               nr_pages =3D state.__nr_pages;
> +
> +               if (!nr_pages || nr_pages > state.nr_pages_remain)
> +                       return -EINVAL;
> +               end =3D state.addr + PAGE_SIZE * nr_pages;
> +               pgoff_end =3D state.pgoff + nr_pages;
> +
> +               err =3D apply_discontig_action(vma, &state);
> +               if (err)
> +                       return err;
> +
> +               state.addr =3D end;
> +               state.pgoff =3D pgoff_end;
> +               state.nr_pages_mapped +=3D nr_pages;
> +               state.nr_pages_remain -=3D nr_pages;
> +       } while (state.addr < vma->vm_end);
> +
> +       return 0;
> +}
> +
>  /**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
> diff --git a/mm/util.c b/mm/util.c
> index 438170490e7f..c5ee52aede1e 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1469,6 +1469,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return simple_ioremap_prepare(desc);
>         case MMAP_KERNEL_PAGES:
>                 return map_kernel_pages_prepare(desc);
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               return map_discontig_kernel_pages_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1501,6 +1503,9 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_KERNEL_PAGES:
>                 err =3D map_kernel_pages_complete(vma, action);
>                 break;
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
> +               err =3D map_discontig_kernel_pages_complete(vma, action);
> +               break;
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>                 /* Should have been delegated. */
> @@ -1522,6 +1527,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> @@ -1543,6 +1549,7 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
>         case MMAP_KERNEL_PAGES:
> +       case MMAP_DISCONTIG_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>                 err =3D -EINVAL;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 1098655a5f4a..1d5f6b3cbd21 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -457,14 +457,17 @@ enum mmap_action_type {
>         MMAP_NOTHING,
>         MMAP_REMAP_PFN,
>         MMAP_IO_REMAP_PFN,
> -       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> -       MMAP_KERNEL_PAGES,      /* Map kernel page range from array. */
> +       MMAP_SIMPLE_IO_REMAP,           /* I/O remap with guardrails. */
> +       MMAP_KERNEL_PAGES,              /* Map kernel page range from arr=
ay. */
> +       MMAP_DISCONTIG_KERNEL_PAGES,    /* Map kernel discontig page rang=
e. */
>  };
>
>  /*
>   * Describes an action an mmap_prepare hook can instruct to be taken to =
complete
>   * the mapping of a VMA. Specified in vm_area_desc.
>   */
> +struct discontig_kernel_page_ops;
> +
>  struct mmap_action {
>         union {
>                 struct {
> @@ -483,6 +486,10 @@ struct mmap_action {
>                         unsigned long nr_pages;
>                         pgoff_t pgoff;
>                 } map_kernel;
> +               struct {
> +                       void *init_private;
> +                       const struct discontig_kernel_page_ops *ops;
> +               } map_kernel_discontig;
>         };
>         enum mmap_action_type type;
>
>
> --
> 2.55.0
>
