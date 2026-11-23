Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424070;
	b=HR1A2Lyxi/dApAzdAFL/AsHe6cxIYvcBFMyMdiE82Cxyv6A1J5V/VTPlorDaNOE5NMmM
	 QVos9yQigQihk8el8oBNdzl3c8nRB82StKsNxVhO48zvjOuL2prruXdT8Z9fWgUek8KMo
	 hVZkbZv6JNDOun3m9i2QvKoPOmCovzLvWYoMrzUCp+5DNDpIJ47NTaXrXhgAen//WefRB
	 kbCzgy5267adnNCw8DQ3TQ64P3/uxsoo1tlzDxFVvCLuNLg/0PrRdBVfofWYFUSYYNIWr
	 5Utl/ZDIotCleDmngDP9VTMFxX2LiP6HDZAem0UrQzvuj6mWhA0FQ+YV4kS5uOd5feA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424070;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3l2+EYB5IAhRg1PJ4Js44zono8mAKRvWJrn0noFOBos=;
	b=IWJruHu6TUDk42+x354TGp8LkgR8r8jWH5TuEzgNkd7D4PIlh5vI+41n/5Exdz45jZdw
	 1I7i5wvsGpjtgNn5Is7/3Vpt33NRAq/Xy8pMubcuSfX9wgb3JsrRhECKfh+iYi2ZS61EO
	 10niWt/N4FEilj3rE9bEUqqQp05eMh5A+CBwfT8o7CHGTmuFI9YFVOIsIWYyyrwf/G0sA
	 fOQOBi+bnwPzzHUeP8fS9NJ7k8eQzK5NCRHc/yEVXbTH9l1tyP9US6lP1VMIdzsD/LseE
	 mn/3vPHsAxSMIkX595SCC6WxLENFxDbOdYiJd2jFvGEp6MzKGgrlO7aU+hLyq4I6BUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="b8CCq/Qj";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38DA606A327;
	Mon, 23 Nov 2026 08:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C38DA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b8CCq/Qj
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A96BB1476;
	Mon, 23 Nov 2026 00:54:20 -0800 (PST)
Received: from [10.57.91.245] (unknown [10.57.91.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EDE83F882;
	Mon, 23 Nov 2026 00:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795424063; bh=ykI/c43VekHLh4s+DX69UMu73TIR/+eRfarVxHM0qgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b8CCq/QjFlgDBE/HQ51/le1Tvx6bIj3ok6U20/6tBMHepTzBZ0epejSL7lohPcGE5
	 TccmXxaTX1nOgvhWwz/yDQDmKLfY9hIOwx+ymd8SYuvACzj45XaT4fYDvGJ38LAJvQ
	 3Ws6uekPCDvBC0r165mQR+Op1SCVMfoJdRpjUC4I=
Message-ID: <d7dae0fd-a4bd-404b-954e-99236dfca560@arm.com>
Date: Mon, 23 Nov 2026 08:54:11 +0000
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
Subject: Re: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver
 <elver@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Chia-I Wu <olvaffe@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Ian Rickards <ian.rickards@arm.com>,
 Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>,
 Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Collingbourne <peter@pcc.me.uk>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
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
References: <20261123033111.2349160-1-jeffxu@chromium.org>
 <20261123033111.2349160-2-jeffxu@chromium.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261123033111.2349160-2-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/11/2026 03:31, Jeff Xu wrote:
> Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so
> non-movable userspace page allocations also skip KASAN tagging on
> allocation and poisoning on free under CONFIG_KASAN_HW_TAGS.
> 
> GFP_HIGHUSER_MOVABLE already skips KASAN because user pages do not hold
> kernel data structures and tagging every 16-byte MTE granule on
> allocation and free is expensive. GFP_HIGHUSER has the same contract and
> differs only in being non-movable, used mainly by DMA-BUF, DRM/GPU
> buffers, and non-movable HugeTLB.
> 
> On an Armv9.2-A device (6.12 kernel, kasan.mode=sync), this reduces
> 32 MB /dev/dma_heap/system alloc+free latency by ~80% (~59% alloc, ~98%
> close) and improves an app-loading OpenGL benchmark by 15-23%.
> 
> Callers that access GFP_HIGHUSER pages through kmap_local_page() or
> page_address() (such as ramfs, pipe/FUSE buffers, kexec, and RDS) lose
> HW_TAGS checking on those pages. None of them store kernel structs
> there; this matches the trade-off already made for GFP_HIGHUSER_MOVABLE.
> Generic and SW_TAGS KASAN are unaffected.
> 
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>

LGTM; I agree with your assessment of the risk.

We have seen poisoning pages at free-time being a performance bottleneck because
the tags are kept inline with data in the cache, and setting the tags therefore
causes hot data to be evicted to bring in the cold data just to set the tags. We
had been experimenting with the concept of "elide poison on free" for "in-kernel
MTE enabled in production" use cases to solve this. But the security analysis is
a bit complex.

I anticipate that your change is probably solving most of the same performance
cost in a much more straightforward manner. I'm guessing these DMA/DRM/GPU
buffers are the largest in-kernel memory allocators for the Android app start
use case.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/linux/gfp_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index c1331bf0b239..bb54c7abfb02 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -376,8 +376,8 @@ enum {
>  #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
>  #define GFP_DMA		__GFP_DMA
>  #define GFP_DMA32	__GFP_DMA32
> -#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
> -#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
> +#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
>  #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
>  			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
>  #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
> 
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859

