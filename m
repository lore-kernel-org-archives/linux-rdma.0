Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870425;
	b=iiyeiLtvZX5CGXhfHvLarGllzMYpBxqeo+6EY5sxH91zvuVxDOZlXKc/rP0Xs4TBse3x
	 baik0hDqGXWKaiSJBj4KrR9j1RWQTXmJSkV6QywudtErnrvYWpUZtn9EJIlo6cVS66sql
	 mjt8uu7cjbmUb3mWvzsSvUtBCFR6HTYq5CC30ZwPtzMOE0nPsAzsTanJGOvfT+DFHSa8z
	 Y0UWwdIuKvIxmuNuruVGX1wo05DsKiS22CvGjvb3Spjro0GpVXCFUUSMmmnjs6OKPzROf
	 vFecD+pMV+BMia9c/oKWSnmGScG3dEc0eGh7El3FVs+kBK5ohhaWTFhKukmvniOVR+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
	b=eoMh177OwTkgfH4yQrd4r2fkCOWuB31SEHSQys8l7ADvBYatG4lKj5qZI36Y8FfqbY3z
	 ugEHSpS+1cDEW2XlMn7rrPLtjeHsscGLXBDPgb9TbXdn6sTLsorrYhXkSOAJ+SanH5xei
	 JnJstCNo7M8UMuiDySYFb0sk0iqMYUuJp5dY2wcNciDIxa/5lPNeyL3k/E3Wq3CV4pS8H
	 lC/k2+juE+Op6Qgn+x1Hjmrb4jqDOLaYLUp+ofWccMYW893hpPsp4BHhYUC4qOip/G8XH
	 Xyg+vYOuZrDX5SzvjaYG69kosjeM19PgagXfpLeD97akMmbzLJ51SIurQqvArlpI3Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=MJR1HdCG;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A8B60A5BD4
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4A8B60A5BD4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=MJR1HdCG
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3b522ef8dso1498a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870424; x=1795475224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
        b=MJR1HdCG1wWH3hDIRoiEgv1K5UeU+oV3eu2gTuvSPb82VDk0dQt1fxMu575tdzDRGV
         nUFCKCO0UTGdyHAaOGD1thvWdC5zgS6BIK0tGbz0ddiEBrRU3UF7z1PABYXgFTbzfP7t
         p/Fggtbeu2kof0DUPF3WoBkPiM6QK+GVj83Cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870424; x=1795475224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
        b=PhtMoeHGG3XxqKC8XgRN+Q/zV0Asp+3uRdwo0eKFIQr8s1kUZz2AtflzFKntK+IjRJ
         +OLLeCuiOABE1SwtbZGYenZ9wcEq3DEX9LYnDXlGab36i8/1zAo11CbayRt0KUHjs4s7
         s3C34FEjNh8OisXoU67Gu99ijpVXovkONPUpsl0LzTrPkUFdpKOuV15nW1djf58vfRab
         LE3ad7C/BmTNbuWHiBDO0AA3kFiR8M3yWsrF8zSX5uHrPUu1S7iK3wUbgBwMWwixUi2j
         TkC7aqvk3x4n4hwTpglVvv0YYvZvTPoi0G9KbYJ7r6r89QnIIr6JlFnHvaQyJWYUxik1
         R34g==
X-Forwarded-Encrypted: i=1; AL+hErEodb6+3IjbenYmY7kyeiuuDbXan3I3nk77RP2usBcpXqiDAtJ2npdD+KMMpkR94LBgLAd8XwSnMmO9@vger.kernel.org
X-Gm-Message-State: APuU4Z+7Smd09vMM5x+QrC3g7WyTO8YI576ejBV8FkRxfuER3fdY5USQ
	nsww2iczRDB2BCANiJQODtNSojuAeJB+9SaEx94v6LN7f7UsRLkjHJRAmDVKfRplvQ==
X-Gm-Gg: AZFdTZfRa4UE4q0nA094T4zcNOqgP/GIgqJhLJkeMj0HUNdrhe9wNUmKGIGNOUyRQXp
	NGIOduiV7/0K+3TonCg3UPmPKDee7iMABaBIvIXtdsdeWkwJ51KNFFqKK20+4dKsq6xA4gY4oc/
	OJrlK4a48+UoJemVLVho3giafU6fN6QjrYOlcFG2FpRRceLq6Rqi55jS4gUTXCH2omSPrWXHZvp
	TVw74MOFAyQMDFKQnG78CIjn5j96/4VSTyC48VAfp0dJCyyrsMtXr6AF5+mCKnOsYyZeoVLxejg
	lkAOgzqp8r0cJ6HgWbjFyTCG2Ngyj49Yz1ymnSCgvPIyKv1UVt+9pAHll+01vqINqBj4AQ5F71g
	/6lGrpS/dqPp804NBx8jJAJoUVvhlvBOQRtKagWzbwk5w+NAr8NGL85+zK5ElkUV3Xtdc2Rpx3N
	iOQYvcVW9j4+O5bEjbmweDXXg6Yor1xiaIuxM/P10UmkmObFmyn0R0imYzU2JPef6YA+AaqzcBC
	s8fbzhuMY+qslTbnIZjAExZKBMxUfm1uTyoBN24qa8YiDP4Jmbqkjo9AoPioasi/zHD555qj0Ah
	dTq9l9zHe6EeU1BrRBwRIvle6exBUTHBpSgo8EZOnpFVaO1rhbLBfs52d87Z5Ey662W+EXTGQNs
	AewfgQfdsWnbZ7IKI
X-Received: by 2002:a17:90b:5906:b0:3b0:d0be:f02c with SMTP id 98e67ed59e1d1-3b1b0b4ffffmr17720470a91.6.1794870423621;
        Mon, 16 Nov 2026 15:07:03 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-cddc13275cfsm5035019a12.0.2026.11.16.15.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:07:03 -0800 (PST)
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
	Evgenii Stepanov <eugenis@google.com>,
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
Subject: [PATCH v1 7/7] mm/kasan/kunit: add page_alloc_highuser_kasan test
Date: Mon, 16 Nov 2026 15:06:27 -0800
Message-ID: <20261116230627.3537051-8-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
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

Add a KUnit test (page_alloc_highuser_kasan) to verify that, unlike
GFP_HIGHUSER, page allocations using GFP_HIGHUSER_KASAN under
CONFIG_KASAN_HW_TAGS:
1. Get a KASAN tag in page_kasan_tag() across all sub-pages of a
   high-order allocation, and the same tag in the pointer returned by
   page_address(), and
2. Are poisoned on free, so that a use-after-free through the stale
   pointer is reported.

The test fails if __GFP_SKIP_KASAN is added to GFP_HIGHUSER_KASAN.

Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
kasan.mode=sync, async and asymm.

Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/kasan/kasan_test_c.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 72342137bb18..285b82793bdd 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -423,6 +423,33 @@ static void page_alloc_skip_kasan(struct kunit *test)
 	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
 }
 
+static void page_alloc_highuser_kasan(struct kunit *test)
+{
+	struct page *pages;
+	size_t order = 2;
+	char *ptr;
+	size_t i;
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
+
+	pages = alloc_pages(GFP_HIGHUSER_KASAN, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+	ptr = page_address(pages);
+
+	/* Unlike GFP_HIGHUSER, these pages must get a KASAN tag. */
+	for (i = 0; i < (1UL << order); i++) {
+		KUNIT_EXPECT_GE(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_KERNEL);
+	}
+	KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), page_kasan_tag(pages));
+
+	/* They are poisoned on free, so a use-after-free is reported. */
+	__free_pages(pages, order);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*ptr));
+}
+
 static void krealloc_more_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
@@ -2413,6 +2440,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(page_alloc_oob_right),
 	KUNIT_CASE(page_alloc_uaf),
 	KUNIT_CASE(page_alloc_skip_kasan),
+	KUNIT_CASE(page_alloc_highuser_kasan),
 	KUNIT_CASE(krealloc_more_oob),
 	KUNIT_CASE(krealloc_less_oob),
 	KUNIT_CASE(krealloc_large_more_oob),
-- 
2.56.0.611.g1030f0b940-goog

