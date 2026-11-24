Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550101;
	b=40kClRS5KwwKwf97RhH4vg0X33OnMhKpox8vCoZDMZNhk0dLvzKR4ugciH6moI0plbJU
	 vW84Vo3YqYhZoEeLqLmbc64DYV0AdfLWVRHchTRXgSXPBb4ByOMbCN7XdySI46EY13a6O
	 lm3h0VnbcIBsJwfn9DIfRnXodvZPhMC4RIwAIoEPJVaU6eiIgaLl+DszDmzO6J82nPRDm
	 qhlHijq2cTjpLjboLA2UdCUzvrBdsiAwzh5Gjx4KduLXZ7ie7igzVUZkUbFS0e+t7BK0Q
	 SgxW9tGQMXaBBmWTNLsHoKH9gOnhFSPomPLupBUnOvN7yvY+vN8aQAQUTMfcKxfcw/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
	b=R0YIAiisi19M6ivE8K98nYQv2D23fSi70b8FOwCNKfmZIEv9sZf24tVHrsfnc6s3/Qu5
	 Q67mr1yCyDap7O6fX8BhK5QeDNzPe2L0ZRgn2No6VH7709YXuYdjW6uOebC0AYXTi/85t
	 o//KxU+oWDFu1MKg2CztccSqIH4UXb6/uUsB6ySMCFARDX0N7oL1YlCRMqegz0RxJgpOt
	 FhjIaKeoS/gCa7IIhE61VLm65K9iw8h47VEQEG+1ZjLWC7M6BPZLH2QYQvtUyo9dvz585
	 F4hgpYLg+20mRndItyD6ijaERwJFeBOCfjbjUkILtAtN7hKhiWDnklDS4llEaejpiDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=F8BWsB0n;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD2606A331
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 19:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59BD2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=F8BWsB0n
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cde60d879e4so107865a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 11:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795550100; x=1796154900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
        b=F8BWsB0nCAqeb/AWcfO+HDVK8mZYlTd5OrAGXo+PDo4qNalYx0D3fOywTn36jlGI3o
         c+cNELy8fDLVUhaoRcT08PS33thK2uCkqwfG9C9YuYZMNa4hOWdKcnZwta+H9xQ9PyXj
         BerC9R4yihNnd8XXBnr17D3gJaZI3rr46c44Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795550100; x=1796154900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IV7aCStFZdnFeaXhFPoQdGrpPnMKMt+5GDtnao0aM7M=;
        b=zGlz632lJnVt60qEqipUGl3kHjZJT/6JQtk2Bjp21bIxcKOG5PjqF5hYhf8X2qLy1I
         7/P0Z0TC8XheVHC/fVla3NOFR2udJpUgVgoiG0ciyZXxWHazRYWT7oUZlpVFGTEoNPZ0
         uuYTRfj+Lto40bTF9/WnbNU96biS5Nw8yiNUWIr128W+wqYBAToQpnbUDPO13YMnQlGC
         qGqK2Rf/EMulgEj1kmcotcLC7fMlZwzLxKaFsqodb7gRByvRyfD6rHbQXt4gxTsAj5MU
         6hNAbAdmAB0SpVADllOkUU0yxmukUDbcL0fqmkhKy8xALy8al18qQ70lFqqB2KsHeuIq
         g7gw==
X-Forwarded-Encrypted: i=1; AL+hErEVgHNhohZxquBjW/sLTyKmv7MoyJXD9V/VNvkYXk1g/CxSQgaEJn37NWJm1+4V/46lwm+2bM2jNXF2@vger.kernel.org
X-Gm-Message-State: APuU4Z+8zfK9AWEdtFsQevUq9CacbuF2dqciYnKX/4pMaWM+2n+ff3gL
	JaoN6BsJ2ogweFn29KwHb6a058rrEbdlPBM8V8FeAI5BY9stOezXjXIXaOhWgCIxYw==
X-Gm-Gg: AZFdTZcKtcl+3Yv+mZmL9fHtP08k/20cjEabej3DJCvVlOuslSrB32kbSpbekWI6EWE
	i6hGLOQpA7mqMivghSfCK7p5OrO1snNwg7j1RYG6+cQ0s5r3BA/v53CwvegozaLeBJ2Mswfup8w
	IffIX2RAyrw1qv3k1/5b2GD7qpYFd5nb1w87pwVXFG7eq47VMWR7wTE4fk53PN+76x7RSqGwiNA
	pNbWFCCFBmg8/4BW8XmOaNkQllY1yLaV6mmHiUlOtmxPNV/pGDbcoZkBfD5RR/miSwzUVLtBdve
	xXHDZHGDJjn8Ttkj1k+A/V7sMNhrQajJg1rAVV9YaLH9fM0ktv71wegOAeSc5KpBQpwDuvy9xZg
	20qV9adLtSxp3mv7p/Oe3gqndCj7RTSXpTac4k4T7A3GfqsilVs7iBYwWrECL7N05T/XLzeGz+4
	t8f+RfpbA777IkBBQe8LIzLD0DbpdsvJxS3HWaEC+tpJDS47s+khUl0xFWVAc4J1MTVVfGg/y/j
	9VSIym80MgUXy5sg9J1ChaT5EnuWlkzqVTSAf+p0fPukmIesUa9q0wg7DLjxQcA5m6N72Xcnwn2
	HalBREzpqMFzaGZWoFYEmUEmBxi5aR98/9gl+SmI5tLybqLoIHO3JuJmiAz/oK/LY/2Lgg==
X-Received: by 2002:a17:903:4688:b0:2f0:7d6d:4a09 with SMTP id d9443c01a7336-2f07d6d4bc1mr137239435ad.1.1795550100419;
        Tue, 24 Nov 2026 11:55:00 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2f03f142b8bsm72335435ad.70.2026.11.24.11.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:55:00 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Tue, 24 Nov 2026 11:54:55 -0800
Message-ID: <20261124195455.164425-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org> <20261123033111.2349160-2-jeffxu@chromium.org> <7ed1f755-5759-4b5b-ae00-a814f16b7903@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Nov 24, 2026 at 09:10:53AM +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 04:31, Jeff Xu wrote:
> > -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> > -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> > +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
> > +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>
> Can we please add a big fat comment above GFP_HIGHUSER, explaining why we use
> __GFP_SKIP_KASAN and which security impact this has?

Sure, I'll add a comment above GFP_HIGHUSER in v3:

/*
 * GFP_HIGHUSER (and GFP_HIGHUSER_MOVABLE derived from it) sets
 * __GFP_SKIP_KASAN to skip HW_TAGS tagging on allocation and poisoning on
 * free. These pages are meant for userspace data (e.g. anonymous and page
 * cache pages, DMA-BUF, GPU/DRM buffers) rather than kernel data structures,
 * and tagging every granule on allocation and free is expensive.
 *
 * Security impact: under CONFIG_KASAN_HW_TAGS, these pages carry the
 * match-all tag (0xff), so kernel accesses via page_address() or
 * kmap_local_page() lose HW_TAGS out-of-bounds and use-after-free
 * detection. Callers that store kernel data structures in these pages
 * should not use GFP_HIGHUSER. Generic and SW_TAGS KASAN are unaffected.
 */

Thanks,
Jeff
