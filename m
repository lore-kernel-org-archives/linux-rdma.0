Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A74718D9
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791135816; cv=pass; b=UQnqQzl36ZHCM/rFuhaZqNN06uwrDZHA2iz//8MPUGcqR+PeiZO3PNFKqEXpx2LyiKWY6d6VptcU/xFDAikRUquqeXswSDsjkB6dDeymxH2cEbUFt4JS96qSP6uMHgxC4COmPODdXYld7t3K0uxOeNewckL5C4QBgUiTMZHqAVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791135816; c=relaxed/simple;
	bh=kLTbSagc0N48D5iLz2IHv2jwZa7qPxl4pR47fwwH0D8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I42nngpMtdJ5UtLQJLCq5Nt0Vr0h/z41nCLSDM2JezpQ1833puhpXTkW/bqQTunO7HVM3ZFmU9HIsN8pbb5YT8KNwzn2itdZCDaujYnV9iz9foC0zBlCQJWJAPw6TeE8XiQvx/rxunh8658I+M3ywRsEW1KECm5JHugRLt+FsLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ES7oeIxC; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ES7oeIxC"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5351f9dbfe0so96091cf.1
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 10:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791135811; cv=none;
        d=google.com; s=arc-20260327;
        b=hebtQmfnqXm7msjY52+jdrSS1DOQNYH5ewUHh+Np1Fd7G1LTTifTuO5e1xI2mgjirn
         TYw1ESrupGxZxCjYrBMTNkoS+fsyMMeIK4ZAg3igH0t5y0lcBZaZgCTSZAf/U4DiYBvC
         J7vrdFhFJx/wzM7A+TdmL2Iq/di/MzvQLOYVXBX+UbDNrul7gst6fPhr12yF3fiR4BSV
         l5XL1zg6WL7qiSr6BR4O1rVKCi1HNm5JIsLH57G9iZeHOE0AlYe2heQDjsmTwU9hcMbY
         ZT+YjhUnuYBx7B5avps6j9GOjXgRe/en1JPYY6WhVMZ9t+jpdURaWdkoqPbOkHebHOBC
         YcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        fh=MoeVuc8SI5yqsx1SxvA8rnpdwlNkkLiG3fVpy2fccdA=;
        b=I10nR+DVuSV0ObLTdUYW0odP7JGPr+mr5jnhd1y83a+mNZkPBNJP5axTdQVsOUY+cT
         5nEFfMz1XYbcp1ZvSpxZh20iy5CMIbZuvV3JynlHUclRG4H+cH8glmQq1450AqX5djen
         IVJ5WsOyJLLHbpZ9zz92t9uRvpZ5ExW1VBi3Sjow75MJoYy+dxWNwFUaoMk6eFniVbj1
         cA3lP0DFVv9JNnlf+SiGPUpm87MdLN96iQBCxmRpL59CHsQ4yNGcWoR0NU2uurubugdS
         RwIEq0rHZcsA6CpPZSu836594JW8AJOs0aXmAVJ+otrcCQuQtJd0afM30EuI4/4HTsa9
         G+NQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791135811; x=1791740611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=ES7oeIxCMYXbczDPyt7XA5z9Ij09lL8c9BgmtjQHX7E6P05QmIToK3BjkYWQ3J1BQa
         48d5ZTQ6DeFif/PpVJrUI09VigAaByshX9zzR3ydSnkd0ygjDAEoKVQ3lwQj6Np+vE2V
         7o3qsyF8B9o1uIjDgkLuoFXfmERglrgcWVcE4/OLuYVkBRXTAiq0+nqwOfrw90uvohou
         5bP7mWJawSf2U5SqaD/zJX9f/NZjTfkuUScECR7+9IJ6mbR72egFT/Qr4VmmGQw1lLoc
         FVXDmh9dBk4PP5Ny2hxAh9HpcWryBUIVm7PSxJREWa0Y79YDMJCRFzw3EbSxQVSNdYOg
         Nvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135811; x=1791740611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMNQ59LV7QrrLF0PW8JXbsDZwLj1dza/KEaeRbY4SzE=;
        b=Zmd251cmgigSonZ2C3aN+JnVkCHzaSebpsfGSrjahC3XGmnWDkHq2NzwVeMIZn4yrH
         dQjUd0bmdwT/mNrA5rHxv7lbtErDbywE/VrGZW214naHkXDPYrHus6iNGXlkIUZvlKzd
         t6q7kf0PqYusHiTj/HurkM3j3f9RxDzQhPhMs6QkjOAfzVRB+A0WEVmhyzgC/idFCw/Z
         NryTmYcQ5udVWWQOCX4jS+akYDeNh+3eOLFhxXO2gW01un8z8+/oRQ1bh2L0hTlA78oY
         6nfuSVhiqVc9Ym4eOYfVmxILX+flN6Yhyv2S6FvTk29L5QEGGmgVVPhv5k1LVcJ/CaXe
         IsGQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3Dq3hMI43ARfo9Nih/C3+xvq+anXjkrxLBTN6tt9aQhFSICujrpTB2ZZVkuO6pNmUqym/r7obUuZ0@vger.kernel.org
X-Gm-Message-State: AFuF++l499jdsF8yZhFSiVi34nZB5isgEuaeGe6PFMpG/lnA2uVd890o
	YvJbultcFaaNTij+WnAu4saWZnICzYPDYAwulas2eCygCM6FlAcTHa2QKO1dO6Jqd6tPM1R/1pJ
	Jmwcb+BSh8cALR2rPx0pRY7/2QUlpIqNrtRFCaWW+
X-Gm-Gg: AYBFou241pF1VNZ8rPEHDcAFWQXQCrhfnBpxivZGTSt9nz79Iu/Q2oLKnjNUR8wIkMF
	e7w4FVBpjZ00ViERBdE0K0+0FygbaJeLxa0O4hWsuVqBcf+JABiu3GigjM0D29LuK34pKwuYt2P
	PBUP37fGbcqnpTWk3y6y6tnj9NBzPHNuJbgU7coCjdbh6aYnWkjLZAjwNl3058JYIPIT51G6rKT
	w3564S5ZJ+DuSS9KxiE2CVyYuxTCj0ojMVjgNg5Q8kG4li94kp1p7jzeSL2MvHCd3icPcfvotlt
	E4BMPVi3Bk9kB3nHugpe4wliEZdHfx7MQlvzaGnOmd+cp1fKKss+8cEt
X-Received: by 2002:a05:622a:5c09:b0:532:eff8:3491 with SMTP id
 d75a77b69052e-5351497bae9mr16844861cf.14.1791135809929; Sun, 04 Oct 2026
 10:43:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:43:17 -0700
X-Gm-Features: AclHuK-Z2ieyqrFQLh5f1D20FCqfsVRqEWMyJIzhNXdOxd9iUhJDwyyLAY8lrcs
Message-ID: <CAJuCfpFounkD97p9iJ8zUunAMoOv+h8Tnxf2NOkp7qs3cfqs7w@mail.gmail.com>
Subject: Re: [PATCH v4 14/38] mm/vma: add vma[_flags]_is_mm_managed() predicates
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
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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

On Sat, Oct 3, 2026 at 6:38=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT an=
d
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>
> Otherwise they are instead owned by some other kernel component, usually =
a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> on ordinary VMAs while locking them, which is addressed later in this
> series.)
>
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  include/linux/mm.h              | 53 +++++++++++++++++++++++++++++++++++=
+++++-
>  tools/testing/vma/include/dup.h | 29 +++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 97e1eb4fe3a4..83953757735a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1612,6 +1612,41 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>         return is_shared_maywrite(&vma->flags);
>  }
>
> +/**
> + * vma_flags_is_mm_managed() - Do the specified VMA flags indicate that =
the
> + * contents of the VMA are managed by core mm?
> + * @flags: The VMA flags to test.
> + *
> + * Such a mapping is one established by a simple mmap() or brk() with no=
 driver
> + * or other kernel component involved.
> + *
> + * They are rmappable, and core mm services rmap operations including re=
claim,
> + * as well as population, CoW and merge/split (if eligible).
> + *
> + * Mappings which fail this test are those where this is not the case -
> + * e.g. MMIO, user-mapped kernel pages, udmabuf (pfnmap shmem), etc.
> + *
> + * Returns: true if the flags indicate an mm-managed mapping.
> + */
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +/**
> + * vma_is_mm_managed() - Are the contents of @vma managed by core mm?
> + * @vma: The VMA to test.
> + *
> + * See vma_flags_is_mm_managed() for a description of this property.
> + *
> + * Returns: true if the VMA is mm-managed.
> + */
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  /**
>   * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to =
be
>   * merged with another?
> @@ -1620,7 +1655,23 @@ static inline bool vma_is_shared_maywrite(const st=
ruct vm_area_struct *vma)
>   */
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
>  /**
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index a6a8e53c4b38..89c645a6ad60 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1665,7 +1665,34 @@ static inline bool file_is_dev_zero(const struct f=
ile *file)
>         return file && file->f_op =3D=3D &zero_fops;
>  }
>
> +static inline bool vma_flags_is_mm_managed(const vma_flags_t *flags)
> +{
> +       return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BI=
T,
> +                                  VMA_IO_BIT);
> +}
> +
> +static inline bool vma_is_mm_managed(const struct vm_area_struct *vma)
> +{
> +       return vma_flags_is_mm_managed(&vma->flags);
> +}
> +
>  static inline bool vma_flags_can_merge(const vma_flags_t *flags)
>  {
> -       return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
> +       /*
> +        * VMA merging assumes that a VMA's flags and fields completely d=
escribe
> +        * its state.
> +        *
> +        * However, mappings which are not mm-managed may have establishe=
d state
> +        * upon mapping not embodied in any attribute of the VMA.
> +        *
> +        * Additionally, private (CoW) PFN maps encode the source PFN of =
the
> +        * range in vma->vm_pgoff, which may otherwise cause spurious mer=
ges.
> +        */
> +       if (!vma_flags_is_mm_managed(flags))
> +               return false;
> +       /* VMA explicitly marked as being unmergeable. */
> +       if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
> +               return false;
> +
> +       return true;
>  }
>
> --
> 2.55.0
>
