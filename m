Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870409;
	b=aa/hJXCJRs7YVsaJnlZPbwSkVl25scxUz01M1qUEWwfaas9+lHE7c60f/IJ7Q/TRWgLZ
	 V1INs7iVPWP6+jfwe1oMUeufLmH6lC/4PHNg1Ql7LxgQiM+hmLYGPuPGvnwD8m4MrRm9B
	 td9u/+fPHQUUH69O9HTkgbZ/mdWUxKBoP8P37LkEpAAAlsSFBx0AHTWEw/IU8K6tEaSjX
	 uc+kUEMTxuHbu6DqEpJ14BPf8Ml4wTwSmqup/SX+fjJjFePH9v0Pw6i4J6u/+G7lnyxeq
	 DDnsSs49+9w/zbw82xBoxj3CKbptlw1kXfFvMLy73HRLBV/XLPQd80vk9g5Wl8vHicQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
	b=bC0Eshsg8M1GaN+FFODqxRxVeHqxrnbUeybA//kHSP6TS3OfBcVCYlIY39eDAvHQSgBw
	 RSFDWnJxzg5GbwXUkDyQyqB0wg8sdpGp5+sQQx/jq86FskE8jU5RlJfkD8WCxIRSVN1br
	 4W+Cp40aq3mrqRfM8Y/i+bBpzqYaliwU+HCtw4Dsov0frjcmCZlORsxNAugT5vKlomiSb
	 wEfEZZWroJQS4t8XZzsie6KqvhXfooJ8f5S+4IFzd6fpsIQEz8QkBHUoFCZ2y3OeE9toa
	 XLhhBJ6tiREXLGRE4xFC610hIiYFhHkUv+N3GnSNvn2Ayw1ahiB19Sq5hWvwkA8cQJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=kk6K2Mds;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A0A606A323
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5A0A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=kk6K2Mds
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cddaf52317cso275599a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870408; x=1795475208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
        b=kk6K2MdsQgdCogkjrc1s8JbIoFQAiggPJV7wUYjqOZ6QuiZpbJJvKe9lzn7JrPs2BS
         XjdRRTRvTuEkLTTU0BybV3HCSYy8668HmwSRmTX/PQgwdZujyZiZT2sd7WxcQHk2u1Zp
         xhfLBrYKJ8E8wCfRTNb8MH5R9pBQK8BDFXS3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870408; x=1795475208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
        b=iQhn2UPethTD9Qy2PPqNVFzmEtb+mCxIkDW7rXest8h8anZS+rXUbUzIp6pBi2FNM+
         C10w3YxLJOI2Czr255zsiQoY7uhTf7qgX57aBH6jDJV3SFn9XTNg6i2nhVq3loW0s5Lv
         u8fD4J/Cx+0s9283l7odeyTTBIEE70/J0IwN/KI2vq8jcwf1TYabRvl7VN4uI4NdkS+e
         x3LmM/W52EpbPv+gG53niqLGo0GrfKmwi+zVJmt1WOzYq4c2dQAVidJv5YFcvrjdqQme
         y/eCL4Wfd/1iDc+s8lrz0UwUX0QPXU/I29U0zMftX4vkv7yPeOGlqwPgyICk29T+H7mi
         D2LQ==
X-Forwarded-Encrypted: i=1; AL+hErEE75D443LY7ePxdfXTt5S8xyZ1xy8nQERg0fGbEgvCH4qz8wDxRxFQirWG3NFZLmqcfDUb2M6Yeetu@vger.kernel.org
X-Gm-Message-State: APuU4Z+0U+Nk9xfWPmEJHDFbFcJKVA8m4fKUSChVe1KZzmOAhjFiPghA
	BDJ1r9g2iIMJhtP0JEX8/8MyWSrB2nbRem+DTlp8xjbkOXBgSD6TBpP+l2IBpLbVlg==
X-Gm-Gg: AZFdTZcmB6MKRlHesLChzUSsCM+vqAUG3CB4olMlR6FvSax7NKIAKZpyCVwWIYk9Odr
	cTu7DIZMjozU69QZdVWNIGYXTPT1PJmP9OMt0XycbxfGIk345JfcgAddO/I3NrfU69DSMAE9LjP
	5Y1q9uRc2z7ffK6FRDZjxExfmkHQ5auKsj7VIALllI1cTvTzC+9OflCaOSll11GKeNNslDLK5wE
	lsXrLngfl9xK7pRKMjwzt+ALD0U95y5YAOg+/VQA0hf5z+HMKJpA3QW8Zsa9nxVbAew8qsx82BO
	xnIrlqGa8/ow87AUO97rarZzM9H2YsmWQL0FMbfrj+K+7ksabGaQ8W+MqD8wcexAGHP3/yGACT0
	DC/52XGhESw+CRqxE+EFe6qgLxL6y+cXtZxysjrW5gDK6f4qV/3Y0Arc49sHFYAGeZXPDAQ8Daw
	7WHzb4OvPIiXur5ysS3jKmzNvyC8Yxv2n1Ck6Mc+Zy5RuF8sP1Fqay/FK0EA6hqG4cpZvFoP1g6
	ZVwpbOJW7urjpQuuTtzQLoDclTbcTSOOhNxFP/Gxc8OGuckKnIl8iUqJ/3SI8EwkUS8WarN+u0w
	qyxE1YgQ82RaxbaD8t7NdAJWtJm6zzY8Hd/2K5SDydxYZ1Y+dLiFXINJeqMa7WVoVjU1D4s=
X-Received: by 2002:a17:90a:9f98:b0:3b3:b15f:eb89 with SMTP id 98e67ed59e1d1-3b3b15feeb1mr321766a91.1.1794870408006;
        Mon, 16 Nov 2026 15:06:48 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3ab9f3c5dsm1108222a91.0.2026.11.16.15.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:47 -0800 (PST)
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
Subject: [PATCH v1 1/7] mm: add GFP_HIGHUSER_KASAN
Date: Mon, 16 Nov 2026 15:06:21 -0800
Message-ID: <20261116230627.3537051-2-jeffxu@chromium.org>
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

A later patch in this series adds __GFP_SKIP_KASAN to GFP_HIGHUSER, so
that with CONFIG_KASAN_HW_TAGS its pages are neither tagged on
allocation nor poisoned on free. That suits pages whose contents belong
to userspace and are mapped there.

Some GFP_HIGHUSER users allocate buffers that the kernel itself fills
and drains through kmap_local_page(), such as pipe buffers. While such
pages are tagged, KASAN can report a linear overflow out of the page
and an access to it while it is free.

Add GFP_HIGHUSER_KASAN for these users, so that they can be converted
before GFP_HIGHUSER changes. It has the value GFP_HIGHUSER has today
and will not gain __GFP_SKIP_KASAN. The two stay identical without
CONFIG_KASAN_HW_TAGS, where __GFP_SKIP_KASAN is 0.

GFP_HIGHUSER_KASAN must not be used for memory that userspace can map
with PROT_MTE (anonymous, shmem and hugetlb pages). Userspace sets the
memory tags of such a page, while the kernel keeps accessing it through
page_address() with the KASAN tag from page->flags. The two do not
match, and kernel accesses are reported as KASAN faults. arm64 does not
reset the tag in page->flags when the page is mapped; it relies on the
page having been allocated with __GFP_SKIP_KASAN. Nothing checks for
misuse at allocation or mapping time.

No functional change. The kernel-doc describes GFP_HIGHUSER as it will
be once it skips KASAN tagging.

Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 include/linux/gfp_types.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index c1331bf0b239..567c93fc1cfb 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -356,6 +356,16 @@ enum {
  * move once in use. An example may be a hardware allocation that maps
  * data directly into userspace but has no addressing limitations.
  *
+ * %GFP_HIGHUSER_KASAN is %GFP_HIGHUSER for pages that the kernel itself reads
+ * and writes, such as pipe buffers. Unlike %GFP_HIGHUSER it does not skip
+ * KASAN tagging: with CONFIG_KASAN_HW_TAGS the pages get a KASAN tag, which
+ * page_address() and kmap_local_page() return in the pointer. It must not be
+ * used for memory that userspace can map with PROT_MTE (anonymous, shmem and
+ * hugetlb pages). Userspace sets the memory tags of such a page, so the
+ * kernel's tagged pointer no longer matches them and kernel accesses to the
+ * page are reported as KASAN faults. Nothing checks for this at allocation
+ * or mapping time; those reports are the only sign of misuse.
+ *
  * %GFP_HIGHUSER_MOVABLE is for userspace allocations that the kernel does not
  * need direct access to but can use kmap() when access is required. They
  * are expected to be movable via page reclaim or page migration. Typically,
@@ -377,6 +387,7 @@ enum {
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
+#define GFP_HIGHUSER_KASAN	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)

base-commit: 4b028d0cedf95f66b8c5294fde2d7d698bf830da
-- 
2.56.0.611.g1030f0b940-goog

