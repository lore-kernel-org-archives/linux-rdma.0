Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6653F58CE
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 21:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784756700; cv=none; b=s5gWeqUxIljUjok5f8jfqFM7dDjz+2Z3F7XAQMnENNQcH4jSXnFnUCg/MT9eBwD1MhxVrGrFl41eE1YobTaGG5Ho6i7uMAbc6fE1WQSct+gRYI54nfOnxO84mYJf8YLD5Gr7K5VJuuZQ29ZPJJho/Xl1dZmBX9HosWbKmlbQt7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784756700; c=relaxed/simple;
	bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b2+3trM9mHqcbND2lShjbYNMUBpjylwKi+brCo08L9SLC9hf3I9P0WpiLpSwn9wEuFZJhVY1en+C6izMOsk1zzYbCOhSf/gGsKYMQqr8f3A3H42BpKvKgRxnnuMZndcm8L3HlhWhhkerxX00S6C1WqB/b8dD2T+lB8Q0D653/nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PTMOc09F; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PTMOc09F"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848d21bbaffso593757b3a.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 14:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756697; x=1785361497; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=PTMOc09FpcMlM1DZNUhPtBUi/K2aOWkLARcKfkanolkLZxB6W1E4j8SxD8pdcvvU3Z
         4OUnqhRDqm7SnYk5Wyg0CyjAOu+KMvNSVcH0xAukoVzeUEA5fYXzT/o94NBxxSD6MGj+
         IN+s+1LTizRBVmM49hhXv/iwOHDtKTfca33m7E/iLv0BsXJr7if4H293U+9R5KwknEDc
         qNWwMa8WmksgPgWpWSvXsaG/Wv3WYnO6t2667aKZv/CyHt9b/835czW4PgMGP4VHlIfH
         fuGhVRvQNL4OgtpnRhLvGsI9w+lVynv7fPfX3GsEp3GJiNoLJqpqbdjC1mTY91lWJ+TV
         613A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756697; x=1785361497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hwr2PA6k/yzOHBkhyRcV60oQVyvCsFMHOEQ+QEbH+Ag=;
        b=erJoXdOA1bCgKy0pQskymohvaeTG/7xwnVYcFTAJz4m2hLo86Q+MjnlbhsROo6rl4k
         O5nSUvACMIAX2WOv5IMCErZzgrFUix0pJagvSxGHn7YCePptqembs5OHW/9o2O3D6hde
         xXC+F6Hy9yVTQbIkmGN+H6PwZeIL8qTF5VDvqAxjPVBmBuFxjprh7GzfVlZjsZC+PCab
         rLdfTwMrOnE8QqZBu6Z4PycqDMLXs5I5d689V6UN5bQaVAkMQE/CoT3FOX+3FeadILbp
         djEpEA7AlCsOuxrO+5f/oSz7ZmjIWJ+5M3jgE4M2CT2WF/k9erVW7MAzyFi9IVnJFFMv
         p0fw==
X-Forwarded-Encrypted: i=1; AHgh+RomJecGuDiNphtqhlHPZ5R0IkvmCa8N6mPY8FF/liYE1Y7WOc/JrQuzWiWp7x5u2agagWMae4id9zVz@vger.kernel.org
X-Gm-Message-State: AOJu0YyyPCOYAGKpuBp269Ae/Lu804nNoTZ6rH/rtriOsY4rycQytfp6
	TjQT0OKEKPaBXO558F6bzHD9cdNBy9i00WDhjQBJuVo6qIma7gCEbS4s
X-Gm-Gg: AR+sD10Qad3KsB22l+4skzJfoSHVI19HKAAfOKfeeKOpPZPtIRYq4poMUZBATY1uos+
	L4u9ZkhBAvq59pp+daE8Dvown+jxVNxvFumquiKtLaZoQMvN91zppKXJiIx6Z1IqFEN8Rhytywx
	Q4OvJ3KISdvgO485/kxYjN22ErVuEkGjw5PJv6MHGA08HtotB1f9u0O3erYXSNM5i4kCY1XCDLM
	cLMxtzqGJreAkx6WRsj052DfIsaeZaxJWGmEl8PxReD4I+iWhiJWAw9Jc19soMGe369jy3tdFHq
	LPyZT2I6gUoPwo/fr6sOeJDtiLsljJvZlkasaN7MoKeUMYAY5UKj9Sje/X2VjqFZrUePUvSQcXl
	dba10FgyqM0aw7TKuP7yaLq4y7qxrvajF99fo+WdkBNh/whirLhP+/Y0abUrbTrpi+YnPBTqYzS
	KLizcs5q1QTReVBhTGzDtTWhlwW3DiVtgj6uF1wJgqC8ZBEzYy
X-Received: by 2002:a05:6a00:1388:b0:848:7b92:8e74 with SMTP id d2e1a72fcca58-84e2c1b9f43mr598680b3a.39.1784756697112;
        Wed, 22 Jul 2026 14:44:57 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:56 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:28 -0700
Subject: [PATCH v10 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout()
 for ODP faults
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-6-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=2457;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=wCDSwsZ/5jgwWzEqFja4q7w3SxWPNbitK21qCohy6H8=;
 b=oTLl/A3KKM6QVfczDQir+MiwWd6xegg7AP0nwym7Jb+EYIV4zgzMMZlGO0Uy3Tv+0wtFJYifg
 zfmA30BQ0D/AoP9W2yBY0iwSakKcdy31nmnUIbQ0QmfiWeEgduaY6fE
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

