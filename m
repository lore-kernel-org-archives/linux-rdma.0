Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550114;
	b=sc0N0ymiOTF3e0Gn+uCqUvXFRzsHSARdXEr4wilMMcfrEfisYhs7PdTWaO6DQhlkwi/e
	 0BIjXgNqkfXUdKMI1zbxSAjkJLNviGweBSRIB4/X+wyYhiwamhpeZz3nCm4uoQGHlRxM9
	 wMn2eIgStEmSmcAJZTKWIVYdg+CzKagayNJ+5RKr5lyQhsRf1lsTaF2gsTa8wju5acwGx
	 eqlZMSTasFWeSqyX09Mt8q+wU81cmUtB/DUjo1JcyN9cMoVc9pmiVOAal+z0Ww+Nk7HoG
	 fTvTz4/R0m8fMBIsVDtdkZL0/KNziu3M12ofhglcaY6FnSB0od5HdesqZ+R/yxUWRhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
	b=E9ORfyg5STZ4WT+yrPPBo8mo0MSg64gJd5D5Qq7Irq0tlAWIxhd/dHqJG8muxbi5a1hu
	 lq0XeuxHREggyvf0M3kMQ7CQAwDRlfhQW7JgU7OIj4/U2wkeTyq/OjANSOJgOMhbNWd4x
	 li+/bVLQvmIIrEECb0tL/dY3JLkEtl8YkwzCuL70bcWzsey28VaFPF3pcisX7yzy2rUS9
	 vQDswTaVkUeCkrJB58UC4/5//HgJat88lvvWhBBHgBhsZ5QcdDq1VcdSFfWwvYIwnCPHv
	 C8Jw+o086u+HoGzrr+9WBnSfjwu+GDolKRBakpmDP4C9fx4syhEXld46HBYDxzDra3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NzN+FZj7;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA59C606A33D
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 19:55:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA59C606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NzN+FZj7
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b5e147f101so417574b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 11:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795550113; x=1796154913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
        b=NzN+FZj7y2Q4CIkzbGAvBjRkEx0HupldjNkvzS3Uq4m6W7oVevksM1jk/CdTgX0TP8
         TS2U/IBomPj149qQpXWRfe2Su6jATx66oZt3XTcs/nZf2XR9Qa69rABd5cA/Dr6lo3d7
         HiwpVVdI3Jb4tt7uE2eXPvcCBWRN74AsTjFIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795550113; x=1796154913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
        b=l4G1kwpAWWrA0myY1LFg0iRc5yS/lQRtesZi0YzHpThwc/tjIa6LHFwLrNxEMNGyUL
         zp1APqByfBWH+NtIUeru3MZ0Nuj4ZDzpiJKd0IJEIHSpRzzVBHTPw1LCJ70MvAMbH/Ny
         OEIeBZ0pW1rJFya9Z4JrE3ylUNDMH44IpPCcCqXVlEu+oqbQG76uevquIdnb6eBOulGF
         /tlELHbsMweYSY03SSsxuLv4Q1cwutYTaj7mue/UpxdSCD374IOdaAFHDstWajsTg4ua
         lpI7deEobVY9bJrBetSVwhsWAz8C9UQiEVtsTgshzQTmbhw06+X5NTmaqb8qJiSepkSp
         wjvQ==
X-Forwarded-Encrypted: i=1; AL+hErH3RGQrg4x5j2wMUB/6on3qIzzPP8Rix5cTN/j2LKlL6YkX2dxXOfxzsCWqiDLy4w5LoZxt9bFrV2S/@vger.kernel.org
X-Gm-Message-State: APuU4Z8TbUhnh5/Bsf4jeQrK0/JjbP+yXC2qnwDl1JRTKuK1y7wJ2RNm
	jaQYOyT10xEYTDg8aUBEet/LgIZdHony+jXMCLehecvBV6hbs/5lsgwXQSocVsR3Rw==
X-Gm-Gg: AZFdTZcp9GAi9KZxIO2tb8Uf1Z8fsBbJSKzF6BJ0zuJEbV1lMo+OYA5mbKVwDjs8sNy
	bAKKELlOt1Hys96sgHOkzjFU4XOiwilb9HlCpoOZcmTVSd1KXzvPYhFs9gkfHcRf4WWaaDpzvF+
	vnhXIIz54JtOUQNQb9K3+Kze0hLMgYBhQlTiWr+KBkPIem1xSozpR9IdnJS9gyJ7iiZQzVhYTLK
	sgLA4bvxZwmxr3qmkpEUov6dCQlJ2UztuosQi8Ai5m/IbjB1ieUAtODJoQ3t8nOSHFktA5k0q33
	BP2CUyNNSRCBxXxxHCs5wQnktPds2FXThLBT2kvrzgcq8ux9DpmpHtTW3IpI+7jho/CIsREx5RH
	h3dJsMNGZ0sGVJeFFl80qrCWW24tigvwkL+7SyIIazwuTqNPt4holZ7TbZMsNXqbAlZYDlRixAI
	qDotm2W0XqaaySRNwaaOA9AhN9lqstK+OknJZCgM/tzXLXe2zx2tpta5g2I+ffowmcuccSuVK9M
	cPCEI4TyXpIaIp/49TtRzwmSRNHPHc7bwcOtOicss4hZOpDLAXAPfLUYsNFpZdmaQl2KUa7UMV7
	NNu6Pe1ItqlWwH33acBrxTzex5Ramp3d/z2Cmu6HFe127OOO7apc9wa/WwJnpMeJVTXHey4D8VG
	UVaI5EAXR+d0l5xw=
X-Received: by 2002:aa7:804c:0:b0:8a0:646e:7e16 with SMTP id d2e1a72fcca58-8c87b4f38cbmr15568834b3a.2.1795550112810;
        Tue, 24 Nov 2026 11:55:12 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c872e4c43bsm7550418b3a.26.2026.11.24.11.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:55:12 -0800 (PST)
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
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
Date: Tue, 24 Nov 2026 11:55:08 -0800
Message-ID: <20261124195508.164641-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <74dd67a2-eaff-4bbb-8105-4481fbbdd016@kernel.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org> <20261123033111.2349160-3-jeffxu@chromium.org> <74dd67a2-eaff-4bbb-8105-4481fbbdd016@kernel.org>
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

On Tue, Nov 24, 2026 at 09:17:45AM +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 04:31, Jeff Xu wrote:
> > +static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
> > +{
> > +	struct page *pages;
> > +	size_t order = 2;
>
> Why magic value two?
>
> Should be const.

Just a small non-zero order so the loop checks tag resets on sub-pages
as well as the head page. I'll change it to "const unsigned int order = 2;"
and add a brief comment explaining that in v3.

> > +	char *ptr;
> > +	size_t i;
> > +
> > +	pages = alloc_pages(gfp, order);
> > +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
> > +
> > +	for (i = 0; i < (1UL << order); i++) {
>
> "1 << order" is sufficient.

Will change to "1 << order" in v3.

> > +		/*
> > +		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
> > +		 * in page->flags, and so in page_address(), not a random tag.
> > +		 */
> > +		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
> > +				(u8)KASAN_TAG_KERNEL);
>
> Squeeze this into a single line.

Will do in v3.

> > +
> > +		ptr = page_address(pages + i);
> > +		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> > +
> > +		/*
> > +		 * The memory tags of such pages are arbitrary: stale poison,
> > +		 * or tags set by userspace through PROT_MTE. Accesses via
> > +		 * page_address() must not fault regardless.
> > +		 */
> > +		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
> > +		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
> > +					  "WRITE_ONCE(*ptr, 0)", false);
>
> Why do we care about checking HW behavior? (match-all working)

Good point, match_all_ptr_tag() already tests match-all behavior in
hardware. I'll drop the kasan_poison() and KUNIT_EXPECT_KASAN_RESULT()
checks in v3. That also lets me drop the local ptr variable.

> > @@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
> >  	KUNIT_CASE(kmalloc_large_invalid_free),
> >  	KUNIT_CASE(page_alloc_oob_right),
> >  	KUNIT_CASE(page_alloc_uaf),
> > +	KUNIT_CASE(page_alloc_skip_kasan),
>
> Don't we have to limit this case to having actual MTE-capable HW etc?

No extra gating is needed here: on non-MTE hardware (or with kasan=off),
kasan_init_hw_tags() returns early without calling kasan_enable(), so
kasan_suite_init() sees !kasan_enabled() and aborts the suite before any
test case runs. For Generic and SW_TAGS builds,
KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS) skips the test,
matching the rest of kasan_kunit_test_cases[].

I confirmed this by booting the HW_TAGS kernel under QEMU with mte=off
and with kasan=off: in both cases the suite fails to initialize and no
test case runs.

I'll add a short comment in page_alloc_skip_kasan() noting that in v3.

Thanks,
Jeff
