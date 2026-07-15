Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A8242FCB0
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139357; cv=none; b=GHmxM6ffD/j4R4EEjHePMTk2xjBosgpxVAhNDpv5kCTViwflagAh6ZFE3EDB1OEzit8+pFidm/U7Mdr2QxAKbhYSk2pyAQyLXrfGHnm8MbNeuXIwYkjxm2ZmhhXCn+ZhdiYLiDnWzG4Za0Rvoggbw45i2eL2IMzUv+CMsHDI0VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139357; c=relaxed/simple;
	bh=zkOtlkRnr6/zYfHYeMY5gJhs9XhgBCQr9DFspQ5RBzI=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=WJrqxyJdnN0m7FW7Nrj6hSIzXYGTbQbBc+3HDUXgB4+ZiC/8igIpMTsDZpnEImN3umALxs6qd6fokvZWCZkZCLBmZ5ZLS++SAY49NxkJn1CmJdrgjDCsGDH7npekRpY47zsJAq2ecN100AvC8giH1qF2BpGkG/JRVee6BddpD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaGO2/jq; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaGO2/jq"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cacf197759so40552655ad.2
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139353; x=1784744153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8cXs1v6rCZCT506ix1H6vuS6eKjBp0nDmZrJvk5ap0=;
        b=TaGO2/jquJv0DdvYr7QZjxt4QRj1L2FFQD/TDX9v4bAG7ISdZ3aqXSPrnvaW1eu8o1
         g08VjTgqGTfL1oJFsXLqS3Ft0dc3zuMeXDWVdnKqCrSupaPIrxcKexOF4liNY9XGP+Cm
         wpX8eiD8BnIsqT2+uhBZEmQvyeJ7+GJc1a+Qtz4kCveu8K+0AK1NmuTG3r2LufMt7JzQ
         DVroLejkMqqkOiRZyeLUhKMgMSp42jdsNOnoc2G2PJ+i9cQ6nJ9MC33f06W/nJPGL4ka
         PL68nIgV88q1CbLKyD38GpiWP8cTbaWWMESxXHgTmheJ8eZyzjND3YeFfoDP1crMUpQW
         ecFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139353; x=1784744153;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o8cXs1v6rCZCT506ix1H6vuS6eKjBp0nDmZrJvk5ap0=;
        b=iHLclWMSSOnY8E3G5seBDCF1149QTCB5uObrAzOdAR4iOj4QF1CKV4NaT6UMPOdEJA
         U9N5KghkRdKSTboqQFq5nHHLxbjiPvV3/WThoN3Zlsspv4GHc0rL7ntQjz8oc7+FzD+j
         92FpZ77cfjfl4C6dLC0tx5CR1AdizMLP4WXsbHFylz1uriJUKoX9a0NsuPaxfsezb1bG
         dHkoA8ntBhidCr5T6hPpWqeIowqKUnIZwX/V+E0ok0xTi05yygngXEwpQwTdMQgrIWVP
         FgbzH41DxefNJ5XP+KRu8LKOob+3BeZzf34R5rBBIRHkFd4PYMlHvhJIaM2WLUNFHZ3c
         LjmA==
X-Forwarded-Encrypted: i=1; AHgh+RpmuDteIZ+DZR801sPOlGocKFuudWnEdMNugs9norI2a/7TyqNhnkXCMMxPT8nPuPi/kMWubDgKEFod@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1MTCAsaBJEmiTL50YEpHMSESjyzwjUdI7bdo8Eoe3LbYe7AVm
	73TPLtXsagk7SJveV0cErA2gUD6434LzCVBISFSzmFdFEI7EmrWC+SeZ
X-Gm-Gg: AfdE7clnKOwxO78kDFX8nzthwM3y8MSC5AJlR8m0rJ+4pNsp5LdiClp8gnbFr21uh1C
	91Y9c97e/nybCzBaH/aSeQltc7M0i/s6KtJPmq/PZ6ABd+ImrfKiBL37brtsx/JDhQ11c9XN9kM
	+lNo0CVs+Zdv5nQN9BuYqoXzHrBIpirZiLVAwhwYU2CCa8u6RNhYEfER3jZSe2YX1iUKowEaD8L
	j+pCXy0miurniW2ZTHfWdkQLvaLB2RH+tGz14UeUV5vRvCBt8JIpC/woyFfNfgaoedQfVlK3W2x
	u8c7q27Kw/EpysqNZS3oRUBc/ZX1mUhfbZ4Mp1Y6P84/aXpuJeJPzg2hYCXFqN73j8yysa7uGVz
	dVcdsvF2nt/E0FsS0yshUS+s7aBizOvaAV1zP9ISXu725V7vtnKftnujXt71Lt98nAD4RKIUEhv
	XDqOTXnxDgC7Vh5W+X8VfY0jucGnXIjrsjKwzjJSeHHt2D/tenmpaImyKK7O4gL7GvcZC5kg==
X-Received: by 2002:a17:903:19c3:b0:2c9:97a9:2096 with SMTP id d9443c01a7336-2ce9f05981emr195144115ad.42.1784139352792;
        Wed, 15 Jul 2026 11:15:52 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1055cde6sm6969345ad.52.2026.07.15.11.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:15:51 -0700 (PDT)
Subject: [PATCH v9 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
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
Date: Wed, 15 Jul 2026 11:15:50 -0700
Message-ID: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

This series extends the HMM framework to support userfaultfd-backed memory
by allowing the mmap read lock to be dropped during hmm_range_fault().

Some page fault handlers — most notably userfaultfd — require the mmap lock
to be released so that userspace can resolve the fault. The current HMM
interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
in pages from userfaultfd-registered regions.

This series follows the established int *locked pattern from
get_user_pages_remote() in mm/gup.c. A new helper function,
hmm_range_fault_locked(), accepts an int *locked parameter. When the
mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
the caller to restart its walk. The existing hmm_range_fault() is
refactored into a thin wrapper that passes NULL, preserving current
behavior for all existing callers.

Possible approaches to lift this limitation are documented in
Documentation/mm/hmm.rst.

Changes in v9:

  - Folded the fixups into the full 8-patch series instead of sending a
    separate fixup series.
  - Clarified that the HMM timeout bounds repeated HMM/mmu-notifier retry
    attempts, with the helper refreshing range->notifier_seq internally.
  - Kept nouveau’s explicit outer deadline because its retry loop runs in a GPU
    fault worker and cannot rely on fatal signals from the faulting process.
  - Converted amdxdna, and GPU SVM callers to pass the shole timeout budget to
    hmm_range_fault_unlocked_timeout().

Changes in v8:

  - Make hmm_range_fault_unlocked_timeout() the primary documented HMM
    range-fault API, and move hmm_range_fault() into the “use only if the
    caller really must hold mmap_lock” category.
  - Clarify that the timeout is a retry budget for repeated mmu-notifier
    invalidation retries. HMM does not interrupt an in-progress page fault
    when the timeout expires.
  - Restart the retry timeout only when handle_mm_fault() dropped
    mmap_lock, because that indicates a lock-dropping fault handler such as
    userfaultfd made progress. Ordinary -EBUSY retries keep the existing
    deadline.
  - Remove the attempted timeout selftest. The remaining selftest covers the
    intended userfaultfd path by resolving missing-page faults through
    HMM_DMIRROR_READ_UNLOCKED and hmm_range_fault_unlocked_timeout(..., 0).

Changes in v7:
  - Replaced the unlocked HMM API with
    hmm_range_fault_unlocked_timeout(). The helper now takes a timeout in
    jiffies, with 0 meaning retry indefinitely.
  - Moved -EBUSY retry handling into the HMM helper for the unlocked path.
    The helper refreshes range->notifier_seq internally before each retry.
  - Switched the unlocked path to mmap_read_lock_killable() and return
    -EINTR if mmap lock acquisition is interrupted or a fatal signal is
    pending during retry handling.
  - Removed the redundant non-timeout hmm_range_fault_unlocked() interface.
  - Updated Documentation/mm/hmm.rst and kernel-doc to describe the timeout API
    and the intended caller pattern.
  - Updated the HMM selftests to use hmm_range_fault_unlocked_timeout()
    only, including coverage for the finite-timeout path.
  - Added in-tree users of the new helper:
      - mshv
      - nouveau
      - RDMA/umem
      - amdxdna
      - drm/gpusvm
  - Preserved each converted driver’s existing timeout convention:
      - unbounded retry where the old code retried indefinitely,
      - HMM_RANGE_DEFAULT_TIMEOUT where the old code used that budget,
      - existing driver-specific timeout return values such as -ETIME.
  - Used max_t(long, timeout - jiffies, 1) when passing remaining time from
    absolute jiffies deadlines to avoid unsigned underflow while keeping a
    minimum one-jiffy retry window.
  - Left callers on hmm_range_fault() when they already need to hold
    mmap_lock across surrounding work, such as drm_gpusvm_check_pages().

Changes in v6:
  - Reworked the new API from the external int *locked pattern to
    hmm_range_fault_unlocked(), which owns mmap_read_lock() internally.
  - Changed the dropped-lock contract: hmm_range_fault_unlocked() now returns
    -EBUSY when the mmap lock is dropped, and callers restart with a fresh
    mmu_interval_read_begin() sequence.
  - Kept hmm_range_fault() as the locked variant for existing users, preserving
    its caller-held mmap lock contract.
  - Added an in-tree user by converting the MSHV region fault path to
    hmm_range_fault_unlocked().
  - Updated Documentation/mm/hmm.rst and kernel-doc to describe the unlocked
    helper and retry pattern.
  - Updated commit messages to match the new API and return semantics.
  - Kept the userfaultfd HMM selftest using the test_hmm unlocked read ioctl
    path.

Changes in v5:
 - Rework hmm_range_fault_unlockable() retry handling to retry
   VM_FAULT_RETRY internally with FAULT_FLAG_TRIED set, matching the
   fixup_user_fault() pattern and avoiding repeated first-retry lock drops.
 - Distinguish VM_FAULT_RETRY from VM_FAULT_COMPLETED: retry faults now
   reacquire the mmap lock internally, while completed faults return to the
   caller with *locked = 0 so the caller can restart with a fresh notifier
   sequence.
 - Document the two *locked return states, including the -EINTR case when a
   fatal signal is pending after the mmap lock has already been dropped.
 - Update comments around HMM_FAULT_UNLOCKED and the HMM fault loop to match
   the current hmm_range_fault_unlockable() implementation.

Changes in v4:
 - Rebased on 7.2-rc1

Changes in v3:
 - Return -EFAULT from dmirror_fault_unlockable() when the mirrored mm can
   no longer be pinned.
 - Add an eventfd stop signal for the userfaultfd handler thread to avoid
   waiting for the poll timeout on successful test completion.

Changes in v2:

 - Split into a preparatory refactor (new patch 1) that moves
   handle_mm_fault() out of the walk callbacks, plus a smaller feature
   patch on top.  Suggested by David Hildenbrand.
 - Hugetlb regions are now supported on the unlockable path; the v1
   -EFAULT short-circuit and the hugetlb_vma_lock_read drop/retake
   dance are gone.
 - Distinct internal sentinels for "needs fault" (HMM_FAULT_PENDING)
   and "lock dropped" (HMM_FAULT_UNLOCKED).
 - Outer loop now re-walks after a successful internal fault so the
   faulted pfns end up in range->hmm_pfns.
 - Kernel-doc on hmm_range_fault_unlockable() and the
   Documentation/mm/hmm.rst example match the implementation.
 - Dropped the mshv driver conversion (v1 patch 2); will post
   separately.
 - Selftest converted to drive the path through test_hmm with a
   userfaultfd handler (new HMM_DMIRROR_READ_UNLOCKABLE ioctl).

---

Stanislav Kinsburskii (8):
      mm/hmm: move page fault handling out of walk callbacks
      mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
      selftests/mm: add HMM test for mmap lock-dropping faults
      mshv: Use hmm_range_fault_unlocked_timeout() for region faults
      drm/nouveau: Use hmm_range_fault_unlocked_timeout() for SVM faults
      RDMA/umem: Use hmm_range_fault_unlocked_timeout() for ODP faults
      accel/amdxdna: Use hmm_range_fault_unlocked_timeout() for range population
      drm/gpusvm: Use hmm_range_fault_unlocked_timeout() for range faults


 Documentation/mm/hmm.rst               |   79 +++++++---
 drivers/accel/amdxdna/aie2_ctx.c       |   23 ---
 drivers/gpu/drm/drm_gpusvm.c           |   61 +-------
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   20 +-
 drivers/hv/mshv_regions.c              |   54 +------
 drivers/infiniband/core/umem_odp.c     |   18 +-
 include/linux/hmm.h                    |    2 
 lib/test_hmm.c                         |  107 +++++++++++++
 lib/test_hmm_uapi.h                    |    1 
 mm/hmm.c                               |  259 +++++++++++++++++++++++++-------
 tools/testing/selftests/mm/hmm-tests.c |  150 +++++++++++++++++++
 11 files changed, 551 insertions(+), 223 deletions(-)

