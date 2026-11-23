Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404686;
	b=tgti063IDoeSinU6lQNsCR2fhsoOaeUepzELl1GjGncMEFcyHUfz31URkqCR8rm1zkt4
	 v06dZWLkVD7l0YHGs7jLru+DXr1U5uxEBZkGvZIHY67eFmHUnWa7ueiL7vBuQh0olKzAH
	 1wew1EkY6CHimQcmuNbSvBP8MoBj2URTsCtjtXUsKVZWwYbPSEBD+divZqZ9wLDnHU//u
	 vem20XJCeQf8SfsAKfjBI/VDZabQjmNU4qcbrqNcysUwxXHg5HH5MmOPdcLbBxedfakSi
	 AW2LGt+C4KsARLp6YCKQRrRH/nBXy8gDxBOc3op7ELHzy1nDFFMmqnVG7gRZuXWT1Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404686;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
	b=lDBLJPRa6/3ysvQnDjYHtq39uVYhnmSJrdVTheJ8LXO6aW+sA6m/kHRgQH+w9DEz04B/
	 SNzHEtBTC8gvHcBMbXrJ3ZJOaAKYIuf+EwQssZ4cBd6UShdvIytrIwt+8vGHzjIk0wNKB
	 NFKgsiTM4LOazTJLEBzED91YmS+tGdEE8yuQJA+epXsky2vlHBTtGs3FOEHrs7ELauGDY
	 frs0LnbqB/FXC+5BO4tupGp/ROTmw64sElv0Dt3S/OtI11FXAlxUlmwfl9cflA2jg1E1H
	 ISyG3pURe8VtH5eyglEc75NLFJnTMYW2s1iiTEOWpIDL/aZIOmARBKIL6bC+zrAwhvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YrgltWNy;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF0C606A692
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 03:31:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FF0C606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YrgltWNy
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdb8c4233b8so152072a12.0
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404685; x=1796009485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
        b=YrgltWNyVy+bKK49Fpq+t+cUbRnSXxMTJEY5Jnbn/GDPL0DRgqMmGT5NQ+18rJU7NN
         0BoM7kVmJqRpZcv8urL2GzgxYO+oVfMQnq4HtHec4C7YDr3h15BAD08sYaACIDgOUboR
         PtEgFm28eXbI4MYuQa82/uvUyYwqFNBHOyxhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404685; x=1796009485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
        b=aShMz+lB4IoR2xzpHXZo0g5kg6BLB1te0Mu4oKo9SdsN8JUJ59WbiMRGqkmDY0NWwN
         uQUuG7skJDQ2vnyxhQAHz7BZWjyQjjClGI4jqPNlD9p6A07yLztb0AWUmUj3CUrOwAjH
         HeZ5XQVNwuRva47GdqeSp7+AVvoc3szWgujWUZoDpOJ3qJEs2j/7lBdLBHI0RJXWjy3e
         iOspPMT9dSulxY4s4UjB6e0dVG7GKX9ysiXVgeLOkYrgygU8T1anXVZrPfcT8w+Oyolz
         Nx6kvIVJjGPJxG7WwFWT3WzGjQOEE/XKhbOHsRvKsCXavV7VLjfLaXYN/A2U794yJdyb
         povA==
X-Forwarded-Encrypted: i=1; AL+hErGzc4Gnyaw4ZGfUhLoTruEdAf1nuCkCkrZ8Jx1Ay+B4TqjZoQGypHWsFxp39a5jFkntXEvx4WCGSFkX@vger.kernel.org
X-Gm-Message-State: APuU4Z8HBDcYad1BXG3GD7aBle2Ls6dI4xwhHQj5Nqg9EXyq+fuWSmy3
	L8zGweUCE3jB+7jabQoTFkp01sBKcEiDwCB7t7wVKwZeVpnn1lGYRVNoEGfpeZ52KQ==
X-Gm-Gg: AZFdTZcVq1whU6yCSys2awKrxhuuU8j1bgaczADXBmxaKarQGm6dIefkxHpfE2MNjmB
	F0XMZENj2xzQCfl89/wy2RO2ujYQVKqwujmu5Z0/VvHsYFkjZqS/CLS+gic4pT1Y1qiAX0OgSsN
	Wp0PwDKe/1/7AKNICMks/ElP9pFfeUS/3AZcq+QPrwYQ5uh8bmw+84p7D+LwsoDhKHUbIU4DcUp
	byto189unY62o72jk814VfmO88mbhPj4i5sJNPwNGrEwnore+6XZ1O6yIsLq37HTYIW1qvkGzfr
	2Le4v41d2n+PaR194fbwYWCfEUfDmxd+gQK7xbCkUuz8jFsnjZPwML7yUREnwQtG/aFd+qBueuR
	rlLkckKvPQYXwukaBYYEEzpDQSvrwUDhSQJifdq1i1UNLtZL40EYHelR/Q9hiYG6ruREmHQ7U+n
	tfb1KJcWOFdnVVlobEqrxtlPBbE+zjV9N28jtRnY4j+damDNRwelFb3yPkaTa3h2yd8Ju0OtpWl
	VgFFzP2VB+6XAe70P5/yS+XKMLe/4TJXZAMnTceMnCvIDf9raktCAQ3NRFD0aXsIqpzXH1XfoG8
	bW2q3TWmFqCdesSOI87+qUGx8ArsjTE0CmmBfJROFQxNMiuWAbr+oRDUMG2hVhcFfOx84g==
X-Received: by 2002:a05:6a20:9f08:b0:3ef:2f72:c7e5 with SMTP id adf61e73a8af0-4014ae6fe31mr16689502637.2.1795404685515;
        Sun, 22 Nov 2026 19:31:25 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c873f16b41sm4720304b3a.56.2026.11.22.19.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:24 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
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
Subject: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
Date: Sun, 22 Nov 2026 19:31:11 -0800
Message-ID: <20261123033111.2349160-3-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123033111.2349160-1-jeffxu@chromium.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org>
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

Add a KUnit test (page_alloc_skip_kasan) to verify that page allocations
using __GFP_SKIP_KASAN (GFP_KERNEL | __GFP_SKIP_KASAN, GFP_HIGHUSER, and
GFP_HIGHUSER_MOVABLE) under CONFIG_KASAN_HW_TAGS:

1. Reset page_kasan_tag() to KASAN_TAG_KERNEL (0xff) across all sub-pages
   of a high-order allocation, and
2. Return a match-all (0xff) linear-map pointer from page_address() that
   does not trigger a KASAN fault even when the underlying physical
   granules carry a mismatched tag (such as KASAN_TAG_INVALID or
   restored userspace PROT_MTE tags).

Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
kasan.mode=sync, async and asymm.

Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/kasan/kasan_test_c.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index f34163e19bd6..72342137bb18 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -380,6 +380,49 @@ static void page_alloc_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
 
+static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
+{
+	struct page *pages;
+	size_t order = 2;
+	char *ptr;
+	size_t i;
+
+	pages = alloc_pages(gfp, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+
+	for (i = 0; i < (1UL << order); i++) {
+		/*
+		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
+		 * in page->flags, and so in page_address(), not a random tag.
+		 */
+		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_KERNEL);
+
+		ptr = page_address(pages + i);
+		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+
+		/*
+		 * The memory tags of such pages are arbitrary: stale poison,
+		 * or tags set by userspace through PROT_MTE. Accesses via
+		 * page_address() must not fault regardless.
+		 */
+		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
+		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
+					  "WRITE_ONCE(*ptr, 0)", false);
+	}
+
+	__free_pages(pages, order);
+}
+
+static void page_alloc_skip_kasan(struct kunit *test)
+{
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
+
+	page_alloc_skip_kasan_helper(test, GFP_KERNEL | __GFP_SKIP_KASAN);
+	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER);
+	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
+}
+
 static void krealloc_more_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
@@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_large_invalid_free),
 	KUNIT_CASE(page_alloc_oob_right),
 	KUNIT_CASE(page_alloc_uaf),
+	KUNIT_CASE(page_alloc_skip_kasan),
 	KUNIT_CASE(krealloc_more_oob),
 	KUNIT_CASE(krealloc_less_oob),
 	KUNIT_CASE(krealloc_large_more_oob),
-- 
2.56.1.750.gf70dc682cf-goog

