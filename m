Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242A43F8CF
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784756697; cv=none; b=P36K+kJvMVO5lYX4XxwiOksMW73qEg9ShlrMSo1aR+TdtILpwxHiEHTu8Ehy9kuMuzyWKgmE5rjoDeutMjmJzjrZkSuFLe2G5TrjuPVG/gORoGxHFKII9IY0grNfdtnwgs5VJSaaUqLR71tu1vWbfDae4iaXvubSbV2Yox9TSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784756697; c=relaxed/simple;
	bh=ZyAhBAfWZePcXjSsL7QqvsrSYU5bhX/lu/bgMYHTJjg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ciG5IJrlpC/r+yFtLNwulQm9nOv/tQ4obQAStdWLNvBDohn+gi8MQAQ7UoJ0nFvUJSiTpkhQQcLaxwui1sP8AQyeYM+KENkfnN5k9g3XlOo6i6u7G+hQ792c6YvkJC4QoqIkEgxK5YGnC3BsRM2TtTAZhkTnjQP1HSJNxbA0d2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r2b1GNxZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r2b1GNxZ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-848595b338cso14772556b3a.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756693; x=1785361493; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=r2b1GNxZG0pMLdmLeYUJ66eog3ws7mntKym23Cgz76GD4C0nsBH3f9m19Hrcw373vY
         MPWtKIY6/nnSTSrV4hxZ2Qi5iWYBvD8PtV/YL/RdqRvyZntwz2M1BXvYgNcrmp4ugxDS
         ZBcwsrYtDo7vcMTi9eLs9+q9nXv5LZlEP2NphZlze0yRmKypPyBeSJOVE61JJMgq4sek
         nE5PMZeAiq/qBmTTWpjLnLhZoLnBoie8tXP2TL5aqjFgygETjzB5LNn28ue2CagrPNK+
         367OCC0BdQLtNLgYOMZksa/UfMZTzrtKUVcYO/YSqHKXz8yJnzhvh4sf7VVa1QEqxfss
         auaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756693; x=1785361493;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3slUHnl834IP76VoxdiRinKrcbFYlUZTVsrXFJZ4JdY=;
        b=DJclBhKmyiiWMYzcigOakFTwCYtnGFiHNKckIgIf3oQM/qIxBlW5HsW8161ZsvrMXK
         xTSOSQ5yHXNVZTab7abZt2lnhuEFQA0s34vMLeXXpWxxtTyK4QMtmXIQdb/YrA91SRn2
         qjW2K2zJNg5m6ESINnTwU2YAurCMj+si1ba2/zsIwHGQ18YSaX0ZFPYGJACYxjLPdCJK
         /7J6+VBJBJ9D71TqRzIXmBNn6GIC8GrsnyC+NbapT5u+neqKt4SaN1lJAApUVa/4G0BC
         2AeYiZ1PqZ2iwoT64sjZ9vi3e299nESywAWipdTo7UseNSZQl2tnFcHQRvWCLafUXSHz
         nc+Q==
X-Forwarded-Encrypted: i=1; AHgh+RoBPXe6x/mr7YHr9tmgBWlXgGmiFlOj7ZNBoX7lHTzKO/oq4wcVYsTa2E7hNnNicdF0RgMOnVaWAQSP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4UJyNhou6UhEPoYG95a1cHHrjn3+P32qVfpqf1sYoKLJNqVIN
	QNTvBV5+m9p5PwC3Z7Cra6woTsT/QbdHd33xcpG0T6jpGSuvP8heoNCr
X-Gm-Gg: AR+sD10IvQ0ZqV06IqS0l4bv6v7qQDc3Oef5i3zBvVy7VhOQvqRZ+Qw0XKoDdA44pVz
	RyzbnMl3gorEyYnD3UqjV1q3swSaL5luinDpP/YoYNHynCGa6daEGFh6mf4JlJ569VVJVvJ2eci
	6G7DOGCh+7JIcQJjOYuLCo6UQ5xVdSwbSqXigtt8mutlVI6mRmPpx1RlyFPAesAbzjufA5FmHaO
	NiyL/yKv5/iykp63/A2XNyD11A9JALxeO1etCZPe3qSZXCNVXGdPA7SuYoHGnhEtzGHVg0jUevW
	MBY6LLxqfmrzuRE+8I5KMX1tshuz+/5O26YGSuECPH8ObM7x14CLRTNefCpKWSoy+Zxnr6mH+TR
	15XWqjYdzJoVjH+gWTTQRFvqsGHbQieXWQPYfyP74WO85MFHckAApcIshjaBP2RIX9KuYc9t52m
	dBvP6Ylj74yBOIIWHxsx0/XF/neDj10rThZCWkuoBSwsiLlpQe
X-Received: by 2002:a05:6a00:4fd3:b0:848:3fe2:c88b with SMTP id d2e1a72fcca58-84e2b7f59camr674000b3a.6.1784756693352;
        Wed, 22 Jul 2026 14:44:53 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:52 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:26 -0700
Subject: [PATCH v10 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-4-606464dd601a@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=3646;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=ZyAhBAfWZePcXjSsL7QqvsrSYU5bhX/lu/bgMYHTJjg=;
 b=tdDpNRsCNvmVGCNOZZ9HC3yxGmAH4ax4m27NmzACrsQovmkbRz97eJ93jI+rhX+xJ0J5zVBrq
 FSNwxKzSGzhDXRe3C8R+8iVP4estzVdVfYmBtDp3huLkA3AiN268Vyv
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=

MSHV currently faults movable memory regions by taking mmap_read_lock()
around hmm_range_fault(). That prevents the fault path from handling VMAs
whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
mappings.

Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
preserves MSHV's existing unbounded retry behavior while letting the HMM
helper own mmap_lock acquisition and refresh range->notifier_seq internally
before walking the range. After the fault succeeds, MSHV still takes
mreg_mutex and checks mmu_interval_read_retry() before installing the pages
into the region, so the existing invalidation synchronization is preserved.

Fold the small fault-and-lock helper into mshv_region_range_fault(), since
the remaining retry path is just the standard "fault, take the driver lock,
check the interval notifier sequence" pattern.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/hv/mshv_regions.c | 54 +++++++++--------------------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index 6d65e5b42152..dddaade31b5d 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -381,46 +381,6 @@ int mshv_region_get(struct mshv_mem_region *region)
 	return kref_get_unless_zero(&region->mreg_refcount);
 }
 
-/**
- * mshv_region_hmm_fault_and_lock - Handle HMM faults and lock the memory region
- * @region: Pointer to the memory region structure
- * @range: Pointer to the HMM range structure
- *
- * This function performs the following steps:
- * 1. Reads the notifier sequence for the HMM range.
- * 2. Acquires a read lock on the memory map.
- * 3. Handles HMM faults for the specified range.
- * 4. Releases the read lock on the memory map.
- * 5. If successful, locks the memory region mutex.
- * 6. Verifies if the notifier sequence has changed during the operation.
- *    If it has, releases the mutex and returns -EBUSY to match with
- *    hmm_range_fault() return code for repeating.
- *
- * Return: 0 on success, a negative error code otherwise.
- */
-static int mshv_region_hmm_fault_and_lock(struct mshv_mem_region *region,
-					  struct hmm_range *range)
-{
-	int ret;
-
-	range->notifier_seq = mmu_interval_read_begin(range->notifier);
-	mmap_read_lock(region->mreg_mni.mm);
-	ret = hmm_range_fault(range);
-	mmap_read_unlock(region->mreg_mni.mm);
-	if (ret)
-		return ret;
-
-	mutex_lock(&region->mreg_mutex);
-
-	if (mmu_interval_read_retry(range->notifier, range->notifier_seq)) {
-		mutex_unlock(&region->mreg_mutex);
-		cond_resched();
-		return -EBUSY;
-	}
-
-	return 0;
-}
-
 /**
  * mshv_region_range_fault - Handle memory range faults for a given region.
  * @region: Pointer to the memory region structure.
@@ -452,13 +412,19 @@ static int mshv_region_range_fault(struct mshv_mem_region *region,
 	range.start = region->start_uaddr + page_offset * HV_HYP_PAGE_SIZE;
 	range.end = range.start + page_count * HV_HYP_PAGE_SIZE;
 
-	do {
-		ret = mshv_region_hmm_fault_and_lock(region, &range);
-	} while (ret == -EBUSY);
-
+again:
+	ret = hmm_range_fault_unlocked_timeout(&range, 0);
 	if (ret)
 		goto out;
 
+	mutex_lock(&region->mreg_mutex);
+
+	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
+		mutex_unlock(&region->mreg_mutex);
+		cond_resched();
+		goto again;
+	}
+
 	for (i = 0; i < page_count; i++)
 		region->mreg_pages[page_offset + i] = hmm_pfn_to_page(pfns[i]);
 

-- 
2.43.0

