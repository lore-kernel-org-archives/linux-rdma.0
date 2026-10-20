Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532832;
	b=uBFPvbGpoMuIUSwpOJhCYDfhIFl9LcfdPHA0T1Hgx7ZcjjLluXmsN8vbQr2K/zX8WDSw
	 t7tftBCIwrGM8fotBcekg99jUB02NrOu3vGiDnQXMC0BDiO40LV8QXo9J+c81w6pWTSh1
	 VLJ44csOeixhTvMOfXXtCTwQuQbJo4rV38896OogzeoKFxr99dN0H/t2kc4GuRJ4Tt+bV
	 a/fI6+5GxklGlGl1QVpggqkNZ9SCfpzcg9m9wD1ep9XUnzzBJVxSOe+gKi3ins5Ah/4Px
	 pOoOcJW0RVceTcenE4/p1Ex4YDNwkdAoZtdFt/RK6axpIectnwu3VwGWN5bP3isGalw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532832;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
	b=dw8sjGDrmff6JwA6C7uETevKGg+2YqW0YzV0T+WTYjxWqam//YwKAtRU02dEbtv90/Ud
	 ZwXqCIyJhl2O7MFSloEBK6FdqezsW1NfL5tU9lZZXbb6AR/9g7PQwzDXlZ4jrADaC4gn4
	 BIFLdF04i4ivLdaNDwmNWUqHmJAvqRe6AY9Dn1gcrpYP0YwKOyfltUNDAsQnZ+oB80pFd
	 sMZclWmut0GbFCxUW5WOwbpi4g7w7lU9G8eiL57V8wHEf8yr2GSP0W6q1cQeIZPLZgOrY
	 /lXT9Rm8mpa2lPV9tlRZhybXWgn1Q1GBXXASx60RMPE03Uswe5LEXCad3lKZt9Sz7Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b="bzGQBu/X";
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0967606A321
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 21:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0967606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bzGQBu/X
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e7ad9f78dso10485585a.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 14:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792532830; x=1793137630; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
        b=bzGQBu/XirkovwO4btF+4VRDEbukUzB2MyeqAryrgq6z0Ot9GRluHKAdWmd5fgqg9t
         ZDu1Ktz+4UNXtHT8IC+siP6Ocf6rz6GRd7VEDVjyYhhc80gWFNNErqfCtS122HNP5Gc8
         Yal0So4C7N3M1J8V/qhZvVZ7b5BLxhon839NHBSmWkHKQIyfact/MXyN/ZAEema4adzb
         SUU7/h8oZ0u1JgSGeXJ16nYCwQszRCgzO90AGkiTqyvJUiA3mP2bmXCGhJM9w9d1CxQS
         8sB/rsSzNPtvRBIrbTgNFANrxD88h9a5euiEsg+ea243W67K/SX1bgUo9i0UjEZc4A10
         XlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792532830; x=1793137630;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PvIPEfkdtZUqofHUAuuyqlxSRMhwpGZiFkVH0+y5Y1c=;
        b=i08+ve9vclv4WTORssZZdyCEbRFfJ0biXSC0LiAcdEPFkciT8tLKv8AjgotlNtiZUQ
         ZCPJdGwmH2JkxHyCThCic1zH4aSqagbFsncJy4qWy8eOl11H00cNDM9mnTkZilk90MTJ
         jb+koa3o85LjeZB6M6j2LxCm0RUpEFhkP7oATO/gWlt52ojKvqLe4M2RGJKsB9hAal/M
         oGwpdSOz6wc/YWjBqSQCc2lwGG8OKRQgzZ2pJod6ZdGBITwKIx1+ErJwze6RvORwgcww
         A7TftMdENWzwfBwU+KIyvFUt9R5Sn741WzDoyx4GqmE5XZK07zEB9UbdDgxcZ5X4U5NK
         7sRg==
X-Forwarded-Encrypted: i=1; AKwUvBwln6vkBWr1kUvWhEucw7cqJXhNI3tM5tbzn17tDiFBaEd0lfexPewJIYb2NLNWo57/D2rWo3PZeLFt@vger.kernel.org
X-Gm-Message-State: AFq9FYKNkDU3JUeJGvZ7IpPzKHYOEFu6SzDH2sJ4rJaUuicqF72UsYVH
	xnLnnT9BaOhjQo6QH5sb2OHXH5VdG4m1GlCginP64zb5HpRaw7OPHMCKp2Obcvw3vf0=
X-Gm-Gg: AYBFou2iihcC/hBJXKvFT9lMeuZXbZ8EeeszAV0KNZHvREGAyQLmyxtm7efcy7D/03R
	EkOAqFkFW7Btfro6aqoWV/dPPmmkraFqT8pPd5qIXFVfHXwKE64jo5JS8uYNZlAPdbP3MVTpY6v
	Wl4oQhWwLGVdlup4rh/24e5RXQ+mtNm6Fb2eDFg3hez/NWy7b6C7/SSviDQOPxOAjD5nrnVXDBo
	j9isOeV1aC/TGgj90EMWBungVMJvu6ujh0nTmb/IS6sYEPCRzE4RQRr6YYDc6KarIT/1uzRtUQK
	4szePlN/UxZ0R+ychsfGwN1nji+SI2kwq5C9CVQ//jO4aN0H5EdyQ0l6Zn/aWYBE9gdhDyHNlAr
	FlM9dRV2k8YILGYpxlP99JG+SmuvsIVHfXdhj9W3mxDF+CPmCp67frTYdvxmXchRd+jS8Iqqw2z
	OLKfCPvYo3BCENXOQ9vKLZVaVxNG/vB8Oi+iC5i3bnuMa2B1PWcHxNolInW8Ap9kt/wC5fkf74X
	moOzfAYnbGazjUic74VezpHqeg1aG99qiIVLO7KL3I5nwQOsidL2o/LsSzw4CvPufSgRRRxGzMS
	tG+kwY8RvHH6tT9v8GHZOVCHS/4=
X-Received: by 2002:a05:620a:198a:b0:93f:3391:d5a1 with SMTP id af79cd13be357-93f57f65930mr93498685a.75.1792532830268;
        Tue, 20 Oct 2026 14:47:10 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d98978sm86912785a.10.2026.10.20.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:47:09 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 01/39] mm/vma: fix mmap_prepare file handling,
 remove file_doesnt_need_get
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
Date: Tue, 20 Oct 2026 17:47:04 -0400
Message-Id: <179253282492.1207257.6426479952081115792.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-13 16:04 +0100, Lorenzo Stoakes (ARM) wrote:
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
> 
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
> 
> The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> to drop the refcount for the original file the mapping was made under, but
> this is not true for the replaced file.
> 
...
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Have a nit below, but otherwise

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> +static bool map_same_file(struct mmap_state *map)
> +{
> +	return map->vm_file == map->file;
> +}
>  

Terrible function name :]

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>
