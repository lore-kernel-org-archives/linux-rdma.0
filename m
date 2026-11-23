Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404683;
	b=ITQ21gjQPCebA08nNMgfYyAlqAqgeY4iZrJSX5+R7HKQ2UerHZO4BovlymJOIN2oUtU3
	 MULf89zOCRuyZXGVuZsKPXt+tdTPLSXO9zHpXztxD6QH+mHLWv6HIN9lQOH5hS6r3h12b
	 6KyQG+nmqigVFi+INYmiAFPIIA+R2E1bluLlO0F5NJTp5ksN+LDvNM/aF7RJpljXuZeHz
	 QPRW5NWpEnCMroKhgWtC/ECbiTKlxR/5aK0p85FQTJP86cHhl2EdRTll60Z4Vte9WZ8zO
	 NC6yc3SiKEX1Qhk6+FgzL69qTfT2kCSDAz0hYxGXYfCypzSJdk9uSuxMTEGUQXFDujw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
	b=4ypiEQLoWFTI6XV8xvrGm+O/LDesTWI2QQGQ/Cpk1g9pd3l4Zz/zl9sY+Lx4Wd2pgoVj
	 baE2TSZbbjhjYsQWyfx8q+E8nmWpYeJsw/lPNugMuPCB3Q9BMaoOZ8v7JBDgQ+fthNRBd
	 h3+bOSO+jAC6ubamw9VjJP/e6V5S0hJsMxX20Td4u2bZfhg5quZFZLWFeo0CATtw/ifeC
	 ms0EybScwJgDl93KEBZWpteBhFJm2Y4rvUDIwCQTbSx5eVJiovdNIhC4wpqDtVyfOPO12
	 4Cf9XPhdWNoeivZxsrmx/hCfna0C0GL5lOQ8mNz5w9iehea5Pe0Q/41JVaLnvD7IA8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AxPYQPzz;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE9606A332
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 03:31:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60CE9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=AxPYQPzz
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b3f9cbafecso373960a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404683; x=1796009483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
        b=AxPYQPzz//LoTvh9Mr24xcYoaLF4FfIftHMSVYvNWkkd2ORREvf97GRTmlchcg5pA/
         BY7zxNGJ9LLSAtVEdx572axC+dtCMdmu2MGH8ThCGPY3DEEFyqzqLt5DgIuv64ua28yS
         2YY/pj6BGymwB0NT9sh7rI/OFa3aN3Yg7uhBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404683; x=1796009483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
        b=eP0Gy8sClxeyXvzxvMrTynqmFvgLOREMfb4sgg04VKGzx37cLMSMIs3xb9u1KyjyrP
         GMRZVklQtCy+temfTuSXVjkHWv2yAvZh+Bn6FnOSzVA/NiaQeATN1cKHmiHeCTauN0JF
         Bzuup1+ISmhY+dbS13XFZw9Vj/0bbtQE3zKGSUaXKTTFFjNGap0P7Am6aAju66pB6/Wc
         W0Et4rfcyMoiYMGq+X2he2TF4okqsHgPrGWuNUX8e2hMjoeHihx4TynE9GDC6Fbp7Zdd
         0RsZMVg4JdDrnpveZuprryI1TwgF6XqxmzqigSq/qN2Gb+xb0dzPiEMfwrjYY9EKRkbS
         voBA==
X-Forwarded-Encrypted: i=1; AL+hErFr0WS2kky78Gx1eNQyPhenf1rCMa+8oZCW5lUIPvSby24Q5q53mIljKD/UjxYDpaLWOyilrdeb8n1n@vger.kernel.org
X-Gm-Message-State: APuU4Z/sBIKJ0wksEPqn0jS/XFj7DMVhrJlnw+V8G0ZZP9GL9s16HevA
	8f3NghllHeVc8ehFVvk89D6CJ0qYRgH+v/Xk6K4NA6hmQZEb4m0fFK0Qdfu/thKLXQ==
X-Gm-Gg: AZFdTZcXulVd8haVicmol/IBQ/fP2RYZIkQyviAN2x9TlI8jEAAZ+Gvy+3m7Agx2Lvi
	uS+Qrp7KN/FCkzXPYA2HQ5jMLUSePwlsll5h9KwP0eKNGEwuVViP7/oM77seOQC2ZRvQQqP8Hdh
	8t6Z16Sorq7Xch4di2DyLFCNcG9ekBXS2SvTYhgrHEKTiIpEYxW8WdHMk4bu/Hg4W6245BtVd8K
	GXTv6O4pGtofpc8QTPt/oWV2VMh+IZFyNgf02z8kd4SQCrpRFYWBBHZKxE8EZr4PjPzTPZfpABZ
	PhLZvxfEbqaGkXAhebSh7p857J0FYLpKP/605RQ5As8UnMgB1gjsptg/Ky75cGdTIPVQnBTVql+
	e3vPNa5o+4dXPuJ3lYOenaHquQfMegggHPgJ+ol1hau/fIVEtFLCfhRdBKIelkOP35WnNcMaFZ+
	ictSQYQFPFDB0RshvJ2QHaCh45n4u72FgKb9KHzXFh6V1Md4FCRX/5kFOfZiWXPIM+hl4wRgWRb
	PnT4OpqWNqL2IxWEvBQODwzxGP9ZTofglinU7eGFqtSG+SEWDWTKybtTJupqafnS3ttk/9ajlS2
	TkBYljU/ZPmcaCaQmPAeIVUFosCFAQGdqlbZWazvUg42qewEnjBgN+drzc39YQnqyHiIeQ==
X-Received: by 2002:a17:90a:e70c:b0:3a0:c1b1:45fb with SMTP id 98e67ed59e1d1-3b41c58aebdmr15663729a91.0.1795404682704;
        Sun, 22 Nov 2026 19:31:22 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b41ad48786sm15745736a91.9.2026.11.22.19.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:22 -0800 (PST)
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
Subject: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Sun, 22 Nov 2026 19:31:10 -0800
Message-ID: <20261123033111.2349160-2-jeffxu@chromium.org>
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

Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so
non-movable userspace page allocations also skip KASAN tagging on
allocation and poisoning on free under CONFIG_KASAN_HW_TAGS.

GFP_HIGHUSER_MOVABLE already skips KASAN because user pages do not hold
kernel data structures and tagging every 16-byte MTE granule on
allocation and free is expensive. GFP_HIGHUSER has the same contract and
differs only in being non-movable, used mainly by DMA-BUF, DRM/GPU
buffers, and non-movable HugeTLB.

On an Armv9.2-A device (6.12 kernel, kasan.mode=sync), this reduces
32 MB /dev/dma_heap/system alloc+free latency by ~80% (~59% alloc, ~98%
close) and improves an app-loading OpenGL benchmark by 15-23%.

Callers that access GFP_HIGHUSER pages through kmap_local_page() or
page_address() (such as ramfs, pipe/FUSE buffers, kexec, and RDS) lose
HW_TAGS checking on those pages. None of them store kernel structs
there; this matches the trade-off already made for GFP_HIGHUSER_MOVABLE.
Generic and SW_TAGS KASAN are unaffected.

Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 include/linux/gfp_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index c1331bf0b239..bb54c7abfb02 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -376,8 +376,8 @@ enum {
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
-#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
+#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)

base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
-- 
2.56.1.750.gf70dc682cf-goog

