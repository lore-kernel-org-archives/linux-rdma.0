Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A316256C63D
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790177584; cv=pass; b=CvYXyk7HzsYksP0oK810Ex6XRBjcv0qSr+Bb1Oumhqc5TsJUnncb2cWCOZAo0hTOaHKGl4ap8UCLVYLyr6cJhaz4zcka9OI96YWEA2jSjVvxUqvSi1KBNXnEag4kYpfy9b5FhC2/2xHThiLSuIc+lAKJ/u29mu6KRxN3wqqXt2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790177584; c=relaxed/simple;
	bh=jxwZm7xClD+2zV/lVJfi9AIfVTBsL5zv+L1dfqymGXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eav1R3THMVtPMKBpEkROeUN9shZR170Fk8WA8k8khN2MtWEeX6vZKyLOlxgaspWrJrfzKsAXZakaQw15OmKW06T7j7EKZtjVwnoovSidrUcCxRBzzozkxy2iprz/ARm0lP5PcOs+mPoYJU07KD+k/eXAhZymSLaaG8n0MMdangs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJl5hpCg; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJl5hpCg"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52faa58bff5so263801cf.0
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:32:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790177576; cv=none;
        d=google.com; s=arc-20260327;
        b=bRzcRlOUl861gdfCA/jJfMoMuD9D91FrSbcZIWLrp0h+26LlPMywruqHHg5v50+896
         bxyKIA4uKWErH4aZBgtp9DMDUAMwCH/sMtl91QZRgx58ZZHqxKMmKX5Zob/8r4BCLoHW
         tO5RU2DZohUnTPzw/BOgSxOVX9yrBUOYaD1s4BmEWYWEF54Jb733wYmKF797FKCaY4IX
         Kb2bFV3t1yDzCpnPPrpXAb+ZIQbpoBNepoOKfboBO4fHWs7RdceSs4IY1M4RkhCsK5zM
         s1TaDGSvQvBVVFS1lFOmGitS8kQRcrmJhdjJxT7r/dgqop2PSoFkn0jDe9xOmXW5qsE4
         CDOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        fh=PiBdV7JoOVKn9Ye4VXsu0WHua8OvzFEE9Ip+bTXIJXg=;
        b=Gs69yoKR7sbiKW0lyEFCXpdr8epahwWuphPE0x0oRfk7xByjkDkTX5FIOYugheX6I5
         jHGUZoxpiNpmynI97s7tNV8FS2kjDqIrnKW+3tZbM8b5+WO75paWrz31lC7Uz/QsNmWh
         MiEv0q06Fmn4vvJH2Vgn18pQVm4g55SJOq1JIx23ZzRQDJlqjW1WAOnjnFx+cCGzW39v
         wyCrt3Qlu6+0nx6htbKVplvSru2qQOASCdVjS2bOdmKPJrZfUH78UW3WCwvSiGvloI2I
         X7z4ofLGfQ/Vuc2qoSx7S278//cmAEGm3VL2CxScKsOuOcaoyptleFo+PCDxB8hgV6Ek
         WJFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790177576; x=1790782376; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        b=IJl5hpCgDZvausqw/IJ2FYc3W9CfGi+nssMYdDJ/8PTbaXMCTt07HByEyVbAK/0HC8
         6yNOi3s/GjWN4gPjU7/SGOEhJwp/h42by7XjswTgd0M8C36s1STruU9cY/xFBk7RTDTE
         AZuf+8PUb0DsjlvBKMGgNgOc5n4XKTc6lj1zXfMAUHks8kfvd5jZnnR2s7g5kYMnzfSJ
         C+2gRfez0U1ZXHuSLkm8Zhu/uaxwZeVyVu0EvODxrdEjERrY8KawWuSv8wwLfji6rqsN
         HPPy9F4KVnfB5gHHqAcEJPH3BEm+6PP7Z8KA1aWsdlXCjjefUCb25+c+Oy+/abo6B4H9
         /29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790177576; x=1790782376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hKtcWNVFda3wl86zaKIN0hpMLzWuZcmeXVfEC0xSzRI=;
        b=R+fuChGrxGQtsoyDUtxDvIgctI2q2NK35yIeQS3pPPLcavfvzcebByXatsRVI7vIo1
         OXaWoaVrenj9rjbNmHXGP5ShFkBYRPAHffdEzDINoOTgYudwXbajPeO87egUk9qJMM2Q
         Y8qYBW4ORbQ6nwGCf0f+MX/8+17QHpwfsu5R6z75piChAIFO/D2I8VT7xd9GEuRRxyNk
         zvo0Jmptm1y+MeyqES5GXw/lQQg5mCZIYvACAsWYdwY6KMHGN0dzjlm1V25UzCSpXaOg
         keBHOi8uKpOVDG+K/f9Q9M+jSWWOcDZmaqP2ZEq+bRB5RR2ni52EAANtvkvSnN+uZzUk
         Qrbw==
X-Forwarded-Encrypted: i=1; AKwUvBxZfymJ7u+qtFzYyeCxpmXPdHMQWXQEdS9wbdkfpEwFXdNrFqSJT7cqlDlcZmSqPMBge1LReIDvWXt7@vger.kernel.org
X-Gm-Message-State: AFuF++kDAXjjrR1xlypmZqYFi3yVYTGIhBX4DiorvplbzeFFlUBVzpfb
	GRkjFQMQ46OEcAEd/ig8mwoQDePgdXSMtsSsKohB/S6WHhZ3igrM9hDabgggCqaoLJWo/lc5LLA
	h7jo3rNMUzTMWwQfhwhtJtTo7tj4DexJ1KBczPHgI
X-Gm-Gg: AYBFou2ixLpDR7knkUypTeNZzJCK6I9MbLV5IwmAaG/7jbg2mdk1m1CYi+zkyQfr03i
	XfcyY95Mx7fN0800YF0Ef48EW9pZ9rwIHXr8NESvU2cvZfOqzTzFaZ29SzetbuPLwOBfC556AiS
	OB/xpClWrhnTB9TRlMp8JyotwUn4qSm9c446J4xScKtDnyLvZPpRlvOQWsPKzKVo0E5ZRTlF+Wy
	z5c7OGpIuxyVLgw25XZlH9SG2YszTz+Tqsr+euZ3qdLldPXcOHMxP47PZjyXFAU1XDIUG5DEvG3
	MudBiOhqma++ykMoz/vwoOA/ShgN93yMZFqgVgzImIdGLzWQ2LLD2Ec6Wo3lw5UV77cVOxF8i3S
	Ur8XAkkpfhQ==
X-Received: by 2002:ac8:5f13:0:b0:532:8423:1e78 with SMTP id
 d75a77b69052e-532f8eef5afmr573491cf.10.1790177574693; Wed, 23 Sep 2026
 08:32:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 08:32:43 -0700
X-Gm-Features: AclHuK8Inh8u6lJouEWaJf_8_dOxdEc__Ja8ROlufrRS70N8N3MQ9iMsAEM4G5I
Message-ID: <CAJuCfpEa8tUmYJBjx-cRdAE8y-jcKY0C81kAOa1QZS7F6tKdfQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
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

On Thu, Sep 17, 2026 at 9:24=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> It only makes sense to manipulate VMA fields if we allocated a new VMA,
> rather than merged it.
>
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since i=
t
> never touches an existing VMA. Previously set_vma_user_defined_fields()
> overwrote the merged VMA's fields with those set for the new mapping. In
> practice these are the same values, with rare exceptions such as shmem
> selecting vm_ops based on whether the file has been unlinked, so no
> user-visible change is expected.
>
> Make this dependency explicit, and additionally constify have_mmap_prepar=
e
> while we're here.

The fact that we might be overriding attributes of an existing VMA
that we merged with is technically a bug even if we never hit it,
right? If so, should we have:

Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")

>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index fa784f069da4..4b74b48c29b7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2894,7 +2894,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>  {
>         struct mm_struct *mm =3D current->mm;
>         struct vm_area_struct *vma =3D NULL;
> -       bool have_mmap_prepare =3D file && file->f_op->mmap_prepare;
> +       const bool have_mmap_prepare =3D file && file->f_op->mmap_prepare=
;
>         VMA_ITERATOR(vmi, mm, addr);
>         const pgoff_t anon_pgoff =3D addr >> PAGE_SHIFT;
>         MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags=
, file);
> @@ -2937,7 +2937,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>                 allocated_new =3D true;
>         }
>
> -       if (have_mmap_prepare && !map_is_anon(&map))
> +       if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
>                 set_vma_user_defined_fields(vma, &map);
>
>         __mmap_complete(&map, vma);
>
> --
> 2.55.0
>
