Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2AD47F774
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791138264; cv=pass; b=ccRn3v+JfTgtyr4NRjquSwfYg5kU61M0pDmJFEuaEsRqblfJyj5H7CdDwdTiqZ5iBw/cRyf3wqZyI1H12uMUbJW2XUZjz2JId+LAYcRRPTdDNkKnzZzRM93/OY1O37/BW7mHd/9sNXQYrM4H91IBjqa/P+ppS1cD2nqIC500vnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791138264; c=relaxed/simple;
	bh=3aBRZG0J7nrNd8eWZI+tOUTLRCjKVPsGyHM+wAKTgfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BPdnzRyWBhBkN8GFxdt/cRDBst1GHDULAztFs7X2vtZvE/9mNwEUHEpGXWq8Y9fRg5XDeCw0TKI5OLe6lpi9thrqt1Lr6Zmfe6OHYPXRPzZp59xTV8jqVHGruSi5louYqol5e+GLhp/zTRl3QLcGLnrPyk6WPXad+GNxxD3+Ofk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KEICTv8q; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KEICTv8q"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso5458a12.1
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 11:24:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791138259; cv=none;
        d=google.com; s=arc-20260327;
        b=bOivsngZ3+2dvoPcZ0esoWC447wrkEBwO5LopOe+v1p0/CDEaGCs2ntv5w5IAT+knn
         rlzTiHlVfOUtLYhRM79r9EQYEvzskYnecwfCUZuIeSavAwlHH1Xase5LyrNug5QMTidx
         qfZpyaOYYRjs7R9Wzf1t+4rUEPrfEIVKa3il5cXYosBS3fR+RHNcHwEyei/YE+Z032r5
         fzzn3okjU/r5+jFWI16irIvfqyAEdpG6EyTSfS+wlfYr8RbaWa7KecVluDYsgk+7YNkU
         JEeazaG1YBq+md1uLsSbsKKW0PGHgUFv3vG3Mp9abcz/NclI6XdLVRfT2C2ZN1kxoXWv
         I3EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        fh=Fhd/UY5fRu0naNFnd5HUScTSnGL3ghWNBiDL65RchWA=;
        b=W1R/ERp0Eppxl/CZMrR+RBy/r6O8sUCuQCFS3XOL5C2+nVeXSO3/YCsQn2Az73rvHT
         hsEMP6hbcvMXGIxYKF6Dv2r/LjXHKzsNILWO+87OxQXT3iVqwT9ZMjosH+xoq3PwGk8O
         nsFeoJXLDE4956c7/x1cfNNpHeL/q5ga2BETKeJzAsRVH7psJ3a1iKyk/Jn4UiF8zWpC
         ICj/1kE2F9x6JoLDxCNn2Ck7/3NLaZZqQT1nJjmFNqPY2R6Ax/T1zq8h4meoWfu6zKM/
         Bp2o0la3wKTYKeBDhrXlfkmayT9ztygTuQxNEaFvfkM/xmafKVJkJEzYW7iNJC4SPRXb
         trQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791138259; x=1791743059; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=KEICTv8q3qYQz0TDKQmwuTgoTQ4+Uy1f2gTr+1Jcucbl5RmoQf2zx5avi3znfbqUYL
         mG1jalfiys6PieVouC35387QdwiS2THeCy3HWXmEuLexCnajpnQwhh/u9Y81k/N0it1v
         6biJ0Bn2hXpnvHERYN2DDPKYzyERopIrR/ej2fNfRzT1xGN8QAaJv6VWm2hyycPisVEl
         qB9CHMbhrYjxR4ocOq/KkaOeuqyvDPC6FbGfnWk4xRxdLwi4hIKZwIs5KxBN6T00oVYW
         +O8flBmEMxmEHcstMjXIfvMA8gZDeceIYjglqxvmVfj4NzY1wBNFHVUVhUCMCQrSV5QF
         dmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791138259; x=1791743059;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=COuPsBcUBk1eT8Q71dO8QdpqB3ZPgP0C77xCCCNJQiA=;
        b=wayBHOQCnFW1MZUuk51YJPrL0lBj8QrhTgF084jB683XeS/zkwau6v+i71Sau1BvVJ
         Joi2VKd+deOBz9b2gueXYN2Xu+aBeo9V+THw/K5Edoq9ef8TmxytfVYGENHS1HsDJ1Ep
         9yMEO/cnrEMtd41oRuSVcnH1biPu+EFi+g5s1i6vt8DBXz4Mulyzxl04bsKt9FJjQzcI
         cEToY0vmMslytfUq/dOcF7y/SuGZTXYt+8WvDNG/n62tWeJPsQtZRTmejd38brQT23P5
         8L2/xGhyaBRpcNnv1P2NVB+TAXZL1UJ/nCDZF11OUdc+TDVdYWhNAWt1HuZwELz7kw/Z
         qYig==
X-Forwarded-Encrypted: i=1; AKwUvBzLtAzo/rgseO4TLTMAwa3s4GbmVWNKxutlbMjTq1b9GKfn/HAqO3rytwVPdl7b60+5BCS467Bws4uW@vger.kernel.org
X-Gm-Message-State: AFq9FYKeSxXrhISuK5Q5KwkmsWG2y2BCd3cag8vvRZREVz/pimNYZMX9
	AdJ2ADclPcFwBC4YtcRmcs2FZbUEMGr/5gnmhw7CckUbT1I7NI3u3yP391QIdBOHvyqermhocC8
	YM6KaDnRnqbfWZP0ndBavX4jm2AS/8WJVcgYjZPnY
X-Gm-Gg: AYBFou2G2IIbbazGyOZeg+NFIqs7rpjQgBhgqyJPxi0nZYTUcsiZQnHCkAEecFDrAAc
	tTi6+ZFXoa0wArb669qeBW6aNeYFgKUcDQUMIEaqp1TQNsCPfQYy6bTncoR55pkpdZgbcFEFo20
	2R+TeDS7DNqNP5VrtQfdnzSswRXD2buodMEOdS1SQ+8yuAxC6q58G71TTxoHB9w3O06sYFIFcbh
	groR2JCghwJ/MWgZ1ZfKBrVNMXYwp8XtuKYYqiVSGV0cVtLVEU/wumlsxi7lZ8YzScq9ezWWzPt
	N4rqfp5hMrofWvhcIBADzKDvo5HewtJFfNiRBzRREWKuApa30WMnBdTY7xSIbqvCF3I=
X-Received: by 2002:a05:6402:a2cb:10b0:6af:7a5a:97e4 with SMTP id
 4fb4d7f45d1cf-6afaf6bf03amr34523a12.12.1791138257648; Sun, 04 Oct 2026
 11:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:24:03 -0700
X-Gm-Features: AclHuK9H1gPgFkK4n-5s4Gd8NQjwfuvbGlNRYoPrM6gC5ICSAC1H3Sf5qTdT1bA
Message-ID: <CAJuCfpHOo8UhAZMvO5A3dKbqxQGAWtKGMHXJ+Fc=qwH=Nm0b6w@mail.gmail.com>
Subject: Re: [PATCH v4 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
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

On Sat, Oct 3, 2026 at 6:40=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/gup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index c2dfcb4744bc..e6310a7cc05b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct=
 *vma,
>         if (!vma_is_accessible(vma))
>                 return -EFAULT;
>
> +       /* Unreadable VMAs also cannot be faulted in. */
> +       if (!vma_test(vma, VMA_MAYREAD_BIT))
> +               return -EFAULT;
> +
>         gup_flags =3D FOLL_TOUCH;
>         /*
>          * We want to touch writable mappings with a write fault in order
>
> --
> 2.55.0
>
