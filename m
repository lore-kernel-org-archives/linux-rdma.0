Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DEC47D472
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784828223; cv=none; b=n2C+9sQJmNZkEZvkGoGAFwhrPF5ztDmH4bEIkElDmcxVpnQL10VKruW/UWRT/57F+KSidhmw2BjgHk0kD7trgypExgiHbwjHRwuAGeMk1fi8QezJKK8LlrmYffklMtniWSiMQi9NQkZeebpMx2/yX+HdEY+sbnMw/6jyGUM52BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784828223; c=relaxed/simple;
	bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X/1224FuP5XrMnHo6lR6ctDQUU2D5J4bWExkNh691BZzSITQib94d6mJeXKNjlo7Co4DDMlOwRNfs/Jbq7cqwycbhLKi5ks6Q2kq80lzcevhulUqB23pNY1VrfmZOzfj318GqYCFPsvKcy6CqAI95pTXWcCQd3h6p8qMjKSwKLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzoH7ryx; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzoH7ryx"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84867f07d63so1101625b3a.2
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828214; x=1785433014; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=jzoH7ryxgSw+y1bE/RYZqr6Afgy4TpkGNtQTGolNvAGj73SbggEjTkbqeXKAAC0bwa
         4IUqcI6QLz7xVuCtPTYe7yXdTMbbRghVyZ411PH+ypOPC65riMLpSiIiZ5UpvsFuYs4U
         YqN2rgS7wKE6eoocuuu+CF65r3Oe3mUQFrFOMEdjlGQB4sLstr7/0ow7JfsVKNKCZ1C3
         puIE293rl6nIrOUlUN4gKti7+6ays49hwz+eWaISQi5Wj+3NtPmeJ5Js8XTNU3L0wLbJ
         4RN4DeSZpqlSsEfGOx/6IAeIN9yYchuCXgsDbteNoKuPtFrx0TCxK9qwiccpRkxSvdxs
         dm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828214; x=1785433014;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=nSf45oSv0gu3fcbzH2UOlKIWT/nbhFChQviI2d27eFUM+0PwH4EcPgaOC2/bgS3ozG
         ZgRUEEHy/oCcd6ev4wgXxjStoJfHGHgNNWhZG55WzbGnhi0qMuiBK+UhnbgVyEGqx3C/
         nRIxP2ARFbW+JrEPeZ1x58WdvLwTnUU4r7Xdv8RAo8NM/lVHLD1ms/fAwXleZOa7wpFN
         0Z4DW4mqS2Ikwiau/dFZfLe9SVXYvkR82ty+fk4DA5zVKO4lkXdtj7Uwv/tOAb8AYAGG
         NgZ5jTDsnmZOmMCusUOLt/m9n/z1EHF/SfJxmFlLZ3dgJ/3fMY5u29+q/TASirbIVReT
         Jl0w==
X-Forwarded-Encrypted: i=1; AHgh+RqRzuxkt/BEfz7ebkO9c/Ti5SmzGLNI6DJ/H955N0+hZHY7qHKiioT4rV5Y0VgI5POHnNZKxT/lvxEF@vger.kernel.org
X-Gm-Message-State: AOJu0YxIiTy1o3ukmenybxIZQYhTa6zEuRjzugfDcTuH2PygY4n+ooId
	BnsjamesGblCPhyfztfI56pXoOqYZlaDymuXeWXmnOR6C9uN18TYvwKb
X-Gm-Gg: AR+sD105v6aNtUegzLPMF089qHDL+e4yiSdEQ8yrfkt39kStdgmq83H/u62xCQBbMna
	Z0mROkOaL+j1fYEpEYnhCQfqxhwpUUtx4Msf1rB/ZRXEcp47uuCrstsSwHi1bneU7JZIhqfTUtD
	Mr8zNLWysRFVwuO1DnZDEcIDR6ppG5uRc97Z6dKTmXoNbaBPlmuSzmUjWtU5vgSVLlQ9+abByRP
	EVlB2lzLaPy/vp+8J1mF4OVPyOgI/MUUapSaxWASQFTDq0uiBxEmxYZJy0Fad5QDXAuMF1a6ftX
	6fpL3Q4jUwekqmIy2+xTic8YNVEuGfDIYN38zGfX/siIm6MLtnWdsT4iTiVxxvLq83uGu/wsxfw
	CeqIvfdOODFe6HVXqcvoZm18vufq8GLxu5VQ4KHX3w35jkvYBPPOxTICuMf6a18M24qS9pxd321
	M4xWFqrJ+ymkjELQqbZRSTpbv/yPO0KaUn17t/gyUHqKxySiw8
X-Received: by 2002:a05:6a00:e88:b0:847:b16b:46d9 with SMTP id d2e1a72fcca58-84e2b8aa77bmr4617793b3a.34.1784828214639;
        Thu, 23 Jul 2026 10:36:54 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:54 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:38 -0700
Subject: [PATCH v11 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout()
 for ODP faults
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-6-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=2457;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
 b=gezzOLTGQ+6T3Wy5w3nFtel93rrT2Kd9eeZ0n6f5FEQw8Beb0IrNif+mDyjnRhH39tdmJbOsG
 yXEZFknqYwdCOt8awUKVwHYE2B6xTW+3MpwtLFeYQDVzLwrWkfuTvq6
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=

ib_umem_odp_map_dma_and_lock() takes mmap_read_lock() only around
hmm_range_fault(), then retries -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT
expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
ODP keeps using HMM_RANGE_DEFAULT_TIMEOUT for each HMM fault attempt,
while interval invalidation retries continue to be handled by the existing
outer loop.

ODP still validates the interval notifier sequence while holding umem_mutex
before DMA mapping pages.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/infiniband/core/umem_odp.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 404fa1cc3254..9cc21cd762d9 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -329,7 +329,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	struct mm_struct *owning_mm = umem_odp->umem.owning_mm;
 	int pfn_index, dma_index, ret = 0, start_idx;
 	unsigned int page_shift, hmm_order, pfn_start_idx;
-	unsigned long num_pfns, current_seq;
+	unsigned long num_pfns;
 	struct hmm_range range = {};
 	unsigned long timeout;
 
@@ -363,26 +363,18 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	}
 
 	range.hmm_pfns = &(umem_odp->map.pfn_list[pfn_start_idx]);
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
-	current_seq = range.notifier_seq =
-		mmu_interval_read_begin(&umem_odp->notifier);
-
-	mmap_read_lock(owning_mm);
-	ret = hmm_range_fault(&range);
-	mmap_read_unlock(owning_mm);
-	if (unlikely(ret)) {
-		if (ret == -EBUSY && !time_after(jiffies, timeout))
-			goto retry;
+	ret = hmm_range_fault_unlocked_timeout(&range, timeout);
+	if (unlikely(ret))
 		goto out_put_mm;
-	}
 
 	start_idx = (range.start - ib_umem_start(umem_odp)) >> page_shift;
 	dma_index = start_idx;
 
 	mutex_lock(&umem_odp->umem_mutex);
-	if (mmu_interval_read_retry(&umem_odp->notifier, current_seq)) {
+	if (mmu_interval_read_retry(&umem_odp->notifier, range.notifier_seq)) {
 		mutex_unlock(&umem_odp->umem_mutex);
 		goto retry;
 	}

-- 
2.43.0

