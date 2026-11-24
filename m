Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508281;
	b=wxzF8rWBIfQNcKb23+gU0LDIiFXck95vzdZKdoGEeqfDwKxN1zwifxtboZBnLw7xaXmt
	 RRbI57v9YgXaIpglYZlJ3eO6ayp2MncXTw/ma/saH2P9xqMG6Nz3+xdVOs22AW7b3/jAw
	 VBg+OKF6KmsemKCnJyDsoMrY1M50TzJlwneJAD2989LgDl2GSY1oc2Qz+j5yZp/suBN9j
	 0zQmRfINc+LVhhj1vCP3VzT4hmm9vrTdlK1Q0nUzsEwFhDY/1PFvkNT4izkAvq9Cjx75L
	 /bLvBVJmKpO5JUULfiI34Xxn47rcPxVWi5kVBTIXlJ5rSP7tKWdJhJHKWK2+D+0iz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508281;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=FXF3amYK4zVK9HrsHP25oSXQsLclmm6eVoNLKiPVVAk=;
	b=HfNqKeHrkc+mBMFEIncsPl9GCSFFcP+jzZb5aAxPDlh2r2Ydn3SC74RDoFS7vqp3pN8o
	 f8y0rZ/FcJ5ZKkbaDsFNIdw5gV/zP0fYRX5KEFj61hFHhdsNaNiRJRJF+1Zq5WPbd138t
	 qxohk3xqmv+IB1ZOyIzmR+5SYp2aUGenz2Gh0GbJwtgHmSVceCNaMKeVwt+Pw6fLuPrHg
	 KujlLkD30qOXyfFmsQq4RZN/6BgSEOfQZRcyfsoLfzEEclL4T3lmaqVJiVDkTUsS71LgS
	 7Z2Z2MlT8EHvJJpWepNaL0L52LQSDq94lhNnMkEdIpJkgKSWeFoDMOVyd+6BOBuieeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDfksFj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FE606A31E;
	Tue, 24 Nov 2026 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDfksFj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B505E1F000C4;
	Tue, 24 Nov 2026 08:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508281;
	bh=FXF3amYK4zVK9HrsHP25oSXQsLclmm6eVoNLKiPVVAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jDfksFj90RJuUYMvQl/D3DcouK7J4WV7mZz3xt4Ni+IJnZVhJeicGKcJbs7h1ClSc
	 umDt4lfTGeLUThRvmvaMVMkyL8DZ1vNmwfedc0zwkDaEcBb4yw3Np6ZLJ35arCmyW9
	 A5ZgWhVN6lINi9/7peguLU5acV7966donpMgCZXSUxFIYAQTH8GwsoiEg5phANvA8P
	 YrQzrNCR8FajQyg8aCkJ4ufXQMkJeC+OfUeruoDxyo8N45lFVUks5DGI9X0RGYp3H+
	 I2vgTRhcthwLELfGV7udxRMB5gHre/OVC9exQklOIYSZxpUkrtjtwlBPTHbkrzxi/B
	 6d73Z4BcdjGqQ==
Message-ID: <74dd67a2-eaff-4bbb-8105-4481fbbdd016@kernel.org>
Date: Tue, 24 Nov 2026 09:17:45 +0100
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
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
To: Jeff Xu <jeffxu@chromium.org>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
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
 Ryan Roberts <ryan.roberts@arm.com>, Tomasz Figa <tfiga@chromium.org>,
 Will Deacon <will@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
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
 <20261123033111.2349160-3-jeffxu@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123033111.2349160-3-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/26 04:31, Jeff Xu wrote:
> Add a KUnit test (page_alloc_skip_kasan) to verify that page allocations
> using __GFP_SKIP_KASAN (GFP_KERNEL | __GFP_SKIP_KASAN, GFP_HIGHUSER, and
> GFP_HIGHUSER_MOVABLE) under CONFIG_KASAN_HW_TAGS:
> 
> 1. Reset page_kasan_tag() to KASAN_TAG_KERNEL (0xff) across all sub-pages
>    of a high-order allocation, and
> 2. Return a match-all (0xff) linear-map pointer from page_address() that
>    does not trigger a KASAN fault even when the underlying physical
>    granules carry a mismatched tag (such as KASAN_TAG_INVALID or
>    restored userspace PROT_MTE tags).
> 
> Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
> kasan.mode=sync, async and asymm.
> 
> Signed-off-by: Jeff Xu <jeffxu@chromium.org>
> ---
>  mm/kasan/kasan_test_c.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index f34163e19bd6..72342137bb18 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -380,6 +380,49 @@ static void page_alloc_uaf(struct kunit *test)
>  	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>  
> +static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
> +{
> +	struct page *pages;
> +	size_t order = 2;

Why magic value two?

Should be const.

> +	char *ptr;
> +	size_t i;
> +
> +	pages = alloc_pages(gfp, order);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
> +
> +	for (i = 0; i < (1UL << order); i++) {

"1 << order" is sufficient.

> +		/*
> +		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
> +		 * in page->flags, and so in page_address(), not a random tag.
> +		 */
> +		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
> +				(u8)KASAN_TAG_KERNEL);

Squeeze this into a single line.

> +
> +		ptr = page_address(pages + i);
> +		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> +
> +		/*
> +		 * The memory tags of such pages are arbitrary: stale poison,
> +		 * or tags set by userspace through PROT_MTE. Accesses via
> +		 * page_address() must not fault regardless.
> +		 */
> +		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
> +		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
> +					  "WRITE_ONCE(*ptr, 0)", false);

Why do we care about checking HW behavior? (match-all working)

> +	}
> +
> +	__free_pages(pages, order);
> +}
> +
> +static void page_alloc_skip_kasan(struct kunit *test)
> +{
> +	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
> +
> +	page_alloc_skip_kasan_helper(test, GFP_KERNEL | __GFP_SKIP_KASAN);
> +	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER);
> +	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
> +}
> +
>  static void krealloc_more_oob_helper(struct kunit *test,
>  					size_t size1, size_t size2)
>  {
> @@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
>  	KUNIT_CASE(kmalloc_large_invalid_free),
>  	KUNIT_CASE(page_alloc_oob_right),
>  	KUNIT_CASE(page_alloc_uaf),
> +	KUNIT_CASE(page_alloc_skip_kasan),

Don't we have to limit this case to having actual MTE-capable HW etc?

>  	KUNIT_CASE(krealloc_more_oob),
>  	KUNIT_CASE(krealloc_less_oob),
>  	KUNIT_CASE(krealloc_large_more_oob),


-- 
Cheers,

David
