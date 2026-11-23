Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424313;
	b=MX8VnnDg6+dapCRaei1gQAV5zlkZj42jkiUbAQ6r5DyPJz6Xh9ueRKxTF5nggP3a53iQ
	 vs88pShsQ4865GfIj9u00Y/ueuI/+UaxgpR4yhHb4d5dJdWLlBjGTVDVv6oOy1Etsd3ib
	 BEEpA/6oRsYns4Ysw1/mIBKqHE8D/6Eu0RCd68NoOZ6bUO0vq7DohqcS6zSF13DCEH0d/
	 oaNBkwEJ5Awcpbr0x/xe4c2JWet5ulEmTNHaVF8YCnXmrbMOO5JMBOc+OnIIZp7AwZfxn
	 gDOEkOHFwl8w6XccR69uFo/OkOw7H/SdnEd0GlFujeB99XHGWtr0yGl4T3xZbG1EMTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424313;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=b3WMjSBwi5PFDvIaCpQd7Axi/XWPxIYqZlMheE6sk7Q=;
	b=sIvehgBMbjwdqGlTAQ9AwBphQxzmF7BmJTV11amiST1OX3VsFf06jx2ezQlZy7iqeD5q
	 Etgv6ovvgQH5t44cDSKf+ILioqxoq6lLqS7Zn5trSFjr0a8945Q9X9jMz/MAIL8kNjuvC
	 FS2Sj6NXf+zAcTaeQBNVREPfsXGfHHsnM9LX7Q+HaVOTMhF2DUB5Ro+lEKp8mjK6O5zLM
	 UXurJKAQiEEHq9q3jefuIbgeyoHI8d8zqADkZdoVhf8RRR6SWufARGKccPyyHT5imEte8
	 gwXkZ2n58PewiLgwtDvXs4/1SyeTwO2y80+N23VMGpdSnaHMoQEjhuZoRATKaUFbI5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ljFKBqmi;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6C7606A31E;
	Mon, 23 Nov 2026 08:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A6C7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ljFKBqmi
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB6561A25;
	Mon, 23 Nov 2026 00:58:28 -0800 (PST)
Received: from [10.57.91.245] (unknown [10.57.91.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFF623F882;
	Mon, 23 Nov 2026 00:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795424311; bh=IyuQOHegOm7o8+idks5YbotHgA2kGInEw/MsLFSwZbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ljFKBqmieG86A9o17mg2OKClKeqYmywjsi88qro4DKa+Bzf6DMkYNr9cZvknPpkUp
	 MK+dIkOffcqanqO2jC1axlvaTs8nppW4q108uU909LcHYNdp1I6oK5movdwY5TJcih
	 uXIzdw84Y8RliXz46ZJI31Ytyxy9qn1kOEfkLx1Q=
Message-ID: <7a3ffc6a-866d-472b-91d6-886ca8095008@arm.com>
Date: Mon, 23 Nov 2026 08:58:20 +0000
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
 <20261123033111.2349160-3-jeffxu@chromium.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261123033111.2349160-3-jeffxu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/11/2026 03:31, Jeff Xu wrote:
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

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

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
> +	char *ptr;
> +	size_t i;
> +
> +	pages = alloc_pages(gfp, order);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
> +
> +	for (i = 0; i < (1UL << order); i++) {
> +		/*
> +		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
> +		 * in page->flags, and so in page_address(), not a random tag.
> +		 */
> +		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
> +				(u8)KASAN_TAG_KERNEL);
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
>  	KUNIT_CASE(krealloc_more_oob),
>  	KUNIT_CASE(krealloc_less_oob),
>  	KUNIT_CASE(krealloc_large_more_oob),

