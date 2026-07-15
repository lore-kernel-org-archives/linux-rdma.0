Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E14431A22
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139406; cv=none; b=raTla9pjSCOfVD+E+4901yD18eQWsMKzyg7t+Ql4zxasLhBG1xFCUIjF0ITH7+Er/JTUwApcV8Il7z6xRwhvHshNK7TDsNP504v3EnIWzj5nsh2E4CqUTl9HvANQNixe4XZmTeZYTaTs3MFKPhoUe/1kSezNyF8mguzK4cu8RJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139406; c=relaxed/simple;
	bh=QDkn/RQPvTt4rCrtIK7bOiEWlSwSa2c8a6ijlJ6xk/E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGBW2dBbNc0dT5lHIvcaO4cmDf5N+nEcTo/ueTxPSkSZ5NgDbl26JbHBGIevZSbPfCyP2w/LcAsT3LT+rx4vp4hfCoxbVpOdG7M1BmeLYckaolsjPMYhwACWuh8zVmKo5ijegoXPi1nnO2XRsqwgTPUicbpJ3i969ejcRKHrOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWXDJQHB; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWXDJQHB"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so68401775ad.0
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 11:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139400; x=1784744200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xews/oLHPsdqsmPpn1oXU4/lUwRmc6mOTrGvCA27l7U=;
        b=HWXDJQHBm4rFxdLm2+gv56gw+psJw2vVt5OZf1Y01gGSkeE4EW9Iw1ITC8mJfcU9Mc
         nFmYSlzE7OrNHy8QGK/stl3aQHjzk3uld6y7z/UymSuWaCx41XhpjaWVuqqQ9SghtLWI
         n+UzeG8MpoFpas+nJieykgj/qH1+p6tZfI7GAgeF78ymdjVvyiilieEiTbAOvbZQpeQV
         LFFoN4VDcskkFCsL6Eqpo2bQ1uRHo0Yrt6n0J0nSx72d39oyNsDMFjXeiV/4YtjN7YFi
         xCLO3M30GnghdfKEHgrM5/7c5EZPFD85fZuNth2j3B1hwals7RQhwaUFXVc0cTTXsxdr
         I2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139400; x=1784744200;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xews/oLHPsdqsmPpn1oXU4/lUwRmc6mOTrGvCA27l7U=;
        b=CYJ8kjBCC4yWv8BbF+KnAeIJQhJ+Ugk51Uk2HCwnOq/MkTpQ/dKK4QtM4/Wjbm7s0g
         Gb/EtnKO0C2VQoQELv07d64vPqP57j9y8bwVksbaweWJEebAQX91JaXyWY/IRKqZ3xpm
         UgDi9Oy+RmiWAmAkiQvfkmByM5yPGcdu5bammC/+puX5jC514rdNPso5pJbt+SmDkbhh
         6MhM1sJJ7Qi+89Eu/iagwZ6jte9ycUgmhPsvyHFM8422YyhWsSkmp7DtfcoDWXf+vTO7
         eCoWuPIbXCe/Bf+1CdKsNjPeeTThgLXuaigzFCJF2eZ/AJ4EpGr/JmfWDiDpncqOLENb
         f7pw==
X-Forwarded-Encrypted: i=1; AHgh+RosnPTh8BPhNwjql/17SEKZeRwuvudIpRw+iqjP7V4Y7r6hV3QOHw5RhP8YmeMurNS3VVWpsJ877ekl@vger.kernel.org
X-Gm-Message-State: AOJu0YzKyMSNvtgwA1i4W/YzCVzBNMIqk+H2Yf/0w77NOgS0gacknw3x
	ieOVyXl5bHbi4h5lMJ1ESKIPHFj87OExWxbCh8mr6VqQ58tk3OJeJZYN
X-Gm-Gg: AfdE7clmflzbPdymI51FWHzld2HH6STTzELzLTvDwXHXsG66zduiUC1lVGU+LFEdZ2s
	inyRG8yRULtqdtJmgu28MYjVjQooT2MEJFplq5hO2Pl/fCuuvNnbwaCyoIaI8V0yewzdffYSYNc
	5gN87UZHWl7xpeeyXNJj47WVTHZUqPculi3dqkHz2cvRWUVzmN8+auNmIkcWu/MngDmOsGNKtX4
	JVeGwQa4yzABqIHi9egy/WWEQDy5jxmevsd1Wm+OMO21WrMyT/hRF37Wu/yIHOjUchSnmB7HV1S
	zY2XnmjakqEiOuqHu39Db4hJ9b7OUOIoxISf3PlPtDOMjunMwvoLgXwN/rt7wiJGC5gkAGgDCi9
	E0AlSCCt8ZZIa++ygMpy5/jP3jmYOIfZyFu90MYvTGPU9YIXx1XQIjaLfVaWH75UcQU4cbgkHD7
	khSPAG6vmlbSCGpmRGcJJe31lpvGjG3F5OZKCKbBsAYvZndQI5luon71KEW+M=
X-Received: by 2002:a17:902:ccd2:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2cee9a64cf7mr89372715ad.8.1784139399557;
        Wed, 15 Jul 2026 11:16:39 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf10592040sm6621985ad.55.2026.07.15.11.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:38 -0700 (PDT)
Subject: [PATCH v9 6/8] RDMA/umem: Use hmm_range_fault_unlocked_timeout() for
 ODP faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:37 -0700
Message-ID: <178413939750.1155966.3639451690646685854.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 drivers/infiniband/core/umem_odp.c |   18 +++++-------------
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


