Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597BE471407
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134589; cv=pass; b=gKiJhsccMFWRwneVN2aCRzcJG51/aUKDzEqpOLIuDe0gE7+6z6A6M2ILJDgG54yURizS81yh++3KgOHSq5paOLo05CpmEJ1tnDp5GyhNoTfRLCihlWjuEm29/Y6Kk+JD+4PZImzSr1KijPtrrcyK2L49Ka224S2bs0ovko4uF44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134589; c=relaxed/simple;
	bh=5YwE6gm7wg0FWDw+d5L2a31cmRORmzOWrTnpytOvhqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BAiCp/I3g6bZWIquGveNvdlPMmjzIwZmyZP2g+chvLe1Ij+R/d5XY1thBnEiqci/X43DphLG86tGQiHVDmDNvBMZ8OwEvR3qLJGNbe/mPB0e5/EK6ar4JczeR+kT0dbrJ1quXc75KpZQEdWIqidJp47fs6QXmlW4aXHBkNNrENg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ev/NnSUV; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ev/NnSUV"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5337c7b9937so259921cf.0
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 10:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134583; cv=none;
        d=google.com; s=arc-20260327;
        b=CKUWTznlanxc3LS4GVnN/J5kgWwkM8M1HPPK3FcltrX1iA05OLP/brDSj3yVxot57R
         TbZrdrntbmfIXR3ic6jDwb3uKCDMZ+p2v4YHXnTHN6tKgbU+jvOh46awl30r6LU0+QTz
         ftDn8C9CWcAoPwQqUPKJPPTCG8/qkDixcOHtKd3HBjhVUvxHcXDxwxBmmczKFfbfYpy9
         nDcH0OF38oVfB1qEKMsWsHBmlsHN0dS2tUz/FT1M+BdQ5RFbfArThhCy2fJeVuZXL8+T
         yiFME4ssSxytIxE1MvCZ0Ew7IRD8ECauDLyiHFJ315+RpmJnXd9m7ehTohPsrUj9Eso+
         NndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        fh=EpeEcWG47oFynrv0aQqrYnnp5mkWqEh96br+ewUUiq0=;
        b=oqFw5cE6dYjKNyJ5qPMFN1ot8nR4O4hoXQpzc8YKzQ/Iazc9A53aW/1n262TzUOA6s
         7iMOCleXt46klaNVMz/CCTqsfn8Cz9RzA7kN4yVpLn5TICeJpTM7wcm3fvXqPHuq3c4X
         l60NcTS7YoH68H+6qVlwpTCQqk8ym+y4gMrQ5ZK/dWIZLv3mj9M03SarxwUWzCPOpwUk
         f7efx/Infa0Ljvt5BI8Z2Jbh6ral757vj+eNq1MlrvImn0wpAJEWXmcRx07scFIDA7Ei
         yn/JJ6qb7PNWJbMBSiFmZ0DwUd90XHVkzpxNuHMjfJ/BVhBi9qDRzG+LFqtnjD8/lyQ+
         P5LQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791134583; x=1791739383; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        b=ev/NnSUViOZ+ATajuN/BHEOpjCgrxKI1nt1o2XQCuN5h7KpRGDTtqS2IKJN37vT8R6
         IbuBrgwBCixnrX5DYs5zuSpVaN0v5SBvJXggFwQVQeKiRmVp7c0/zqEuo+mf9hQYE+ap
         XREirLdhnpqRqpG6A+D5jtBOZgfp+zeKZylZAZ4yJTfDpftaH0fV8uU4OqxMdwqT+x/O
         aKbyGDnO34Q8OmZXgttyU3B7s5pjk9WcC2we5ktK5gynifeEucE6Om6Sq6OSysMfD75o
         AjLX4rLLg4//L2FGOrssLIPqc+S2KZ2Y7d9tVn4emORbQv0AmSNSfDGfDi5GXB6+4Vjj
         Ym5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134583; x=1791739383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqiCaT+6hB/MlQ3EgaRNQmjR57IQALnN7KoYl50i5vw=;
        b=ROwLWs9rnPMwQkZMTg73spNeU/hBpdmLWsCLhKUsqqTxdx/z8pTcfehDwiBipLPzPU
         ZSlVomOFoM5l46oc/mEyRCZ0MFGU7M1DgPqznM6QtZypUnuHod+V60R7tYtuQWNXjjRv
         xjfM16GbPPv8GJt7gMvJblrOI4bNq3Ply2K9n199sh7nsgUW0/hjiM2Db+ce6xVzXI+B
         PfcdhFMEePNg30MVyOQTAqtD1ftbOAFhOgDx67thdNKMQHRJJzShnnpXOaTcbe/2AagP
         ZrphYLK+nDsSvPWUBcWCV8UeCxrxf1tsTx6PaLhnxo3TQNNTGpbkmkrHfVMCmWutXD2Q
         s+HA==
X-Forwarded-Encrypted: i=1; AKwUvBz4kgXkP+wiTcy3kGAq1NFsARzFThc8v3DDfQK7TimuDdbKSeWEn/I/FlUFEHAltKWxbzijmNftfw7h@vger.kernel.org
X-Gm-Message-State: AFuF++nhc6lh8Sa5xxpX+3azTPWywmH2fS0mMvdSxmOIOYgSUdI5npA/
	jOSxnklRWxO1IEuuR0VnH6dqmCIl1UKa7qlgYAmAbW2dnVu3932HdFB5fMWStxZSVub6mqZMDl1
	HI4cMtKm4WXFcAUUR8RY/ozvoqMhJ3mqA74YPndTi
X-Gm-Gg: AYBFou2R9jM69ptpEg/q0gbf7xaFS9A+njZ2173CNG54+u0TqMZEszw95RrE3vL1zaN
	GD5QitwtGvAVb3ju1yVxJbdPgZtMTPljoNlgJuXQQt2V79ihRcugroBY5k3uCnG7ejI6nf5Y8xs
	bZP1C/oilvbLhFULUz+dFyQYKHGl3lxmE/TATpgL/ExJ+pYlCfGWHAdlPtqSsE19gvIc4QRB29i
	VUxvS9dpo/kkNTWMD/tHrko5lc58j1brYR2l3oWPdA6aBDlBlL1/Tm4VdvYR5oESl+Fvfyd0FLa
	Isas/+1TWSdsBviYPOPNcl2bnSZJ2DZUkzmblH54nXDEpBRfCIHdeuF8XSgjvfnzSbI=
X-Received: by 2002:ac8:574c:0:b0:531:475:4ce6 with SMTP id
 d75a77b69052e-535131b2b85mr16362481cf.9.1791134581910; Sun, 04 Oct 2026
 10:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-12-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:22:50 -0700
X-Gm-Features: AclHuK9b8f-m7wgF2pmH0VTlVxkwioKHBPR714nLjuu-GaXS_Vt3fJyAlsba0Do
Message-ID: <CAJuCfpH8GeLKqFtfC_a5i08dQ2ZyyROSrYqYP6Btq03xbF_nXA@mail.gmail.com>
Subject: Re: [PATCH v4 12/38] ALSA: pcm: use vm_insert_page() to map PCM
 status page
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
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 6:37=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> There's no need to keep a fault handler around for this, instead map on
> mmap.
>
> While we're here, rename area to vma to be consistent.
>
> This correctly makes the mapping a mixed map mapping.
>
> This works towards establishing the invariant that only PFN mapped or mix=
ed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clea=
rs
> VM_MAYWRITE, so it must not be mm-managed; the control page mapping remai=
ns
> writable and is left fault-based.
>
> The assumption is made that the struct pcm_mmap_status structure is at mo=
st
> a page in size, which is asserted as a build bug.
>
> This is safe to assume, as the size of the structure is 56 bytes at most.
>
> Acked-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  sound/core/pcm_native.c | 38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)
>
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
> index 62324282fcae..c98fb3df14f3 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3760,39 +3760,27 @@ static __poll_t snd_pcm_poll(struct file *file, p=
oll_table *wait)
>  /*
>   * mmap status record
>   */
> -static vm_fault_t snd_pcm_mmap_status_fault(struct vm_fault *vmf)
> +static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> +                              struct vm_area_struct *vma)
>  {
> -       struct snd_pcm_substream *substream =3D vmf->vma->vm_private_data=
;
> +       const unsigned long size =3D vma->vm_end - vma->vm_start;
>         struct snd_pcm_runtime *runtime;
> -
> -       if (substream =3D=3D NULL)
> -               return VM_FAULT_SIGBUS;
> -       runtime =3D substream->runtime;
> -       vmf->page =3D virt_to_page(runtime->status);
> -       get_page(vmf->page);
> -       return 0;
> -}
> +       struct page *page;
>
> -static const struct vm_operations_struct snd_pcm_vm_ops_status =3D
> -{
> -       .fault =3D        snd_pcm_mmap_status_fault,
> -};
> +       BUILD_BUG_ON(sizeof(struct snd_pcm_mmap_status) > PAGE_SIZE);
>
> -static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, stru=
ct file *file,
> -                              struct vm_area_struct *area)
> -{
> -       long size;
> -       if (!(area->vm_flags & VM_READ))
> +       if (!(vma->vm_flags & VM_READ))
>                 return -EINVAL;
> -       size =3D area->vm_end - area->vm_start;
> -       if (size !=3D PAGE_ALIGN(sizeof(struct snd_pcm_mmap_status)))
> +       if (size !=3D PAGE_SIZE)
>                 return -EINVAL;
> -       area->vm_ops =3D &snd_pcm_vm_ops_status;
> -       area->vm_private_data =3D substream;
> -       vm_flags_mod(area, VM_DONTEXPAND | VM_DONTDUMP,
> +
> +       vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP,
>                      VM_WRITE | VM_MAYWRITE);
> +       vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
>
> -       return 0;
> +       runtime =3D substream->runtime;
> +       page =3D virt_to_page(runtime->status);
> +       return vm_insert_page(vma, vma->vm_start, page);
>  }
>
>  /*
>
> --
> 2.55.0
>
