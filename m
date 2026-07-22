Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48146215075;
	Wed, 22 Jul 2026 22:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784760500; cv=none; b=InVAIXU26Syjp7HEWeY6ukNjS+oduHEfYxfmYz9eNEOQcDxEAu4pxFmwIxP1+Dc8i8KiBcIpgSFkuPJDMRAR6B85kceTovDxpm40VYe5TkPo3c5EH7xQFd78ddWwPnE2AXPGzB8TxR4Iz+5rph+KGmqivKC1i8yPTRr6MrLvlio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784760500; c=relaxed/simple;
	bh=3KozxUktFFuphNeoA5oY3DRrjqfB3qtuLGq2VnUnylE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=osnb2+DYBjkqhXxXYCCws/ueKN3W1BxFCw5ghEsgO3Y7uMjk92HeFt4a3RS5DBwfudn7V+9ZK5/FdOM5pmKovI6GTW3OyAemq/6i1ENTPxOlIiaKaDIESiBWCP08Q6WE2lIuKGVhWDxQ/fDa88YC2kIIWzRMZWZNRX5m3F1sfFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ey11rnFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ey11rnFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A931F000E9;
	Wed, 22 Jul 2026 22:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784760498;
	bh=PNgL8SYp9VI1NhjQT8Ovt6BfZV4gAJBoTR6QXW/SnYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ey11rnFQSaKacaNArWVfr0eeKP+Coih9IwasoSNFGEWkgFxEAp6Gj30weTETOSTMu
	 Kb3glBybuhz+H4qunDZQxS9olJTmLRVgjyXlAi+i+JjF52ZA7V5vh6IJduz1xNJhqy
	 6T2KvTOpUyORKJL9JJtXt564uLU4rprlu8gbdCNE=
Date: Wed, 22 Jul 2026 15:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Long Li <longli@microsoft.com>, Lyude Paul
 <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Min Ma <mamin506@gmail.com>, Lizhi Hou
 <lizhi.hou@amd.com>, Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
 dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v10 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260722154817.8c036f2d007edccbd7ab84c7@linux-foundation.org>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 14:44:22 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks, I've updated mm.git's mm-unstable branch to this version.

Sashiko pointed at a few things, some pre-existing.  The jiffies race
in [8/8] looks legit.

	https://sashiko.dev/#/patchset/20260722-hmm-v10-v1-0-606464dd601a@gmail.com

> Changes in v10:
>   - Included contended mmap_lock acquisition in the
>     hmm_range_fault_unlocked_timeout() retry budget.
>   - Dropped the redundant top-level fatal_signal_pending() check in the HMM
>     unlocked retry loop; mmap_read_lock_killable() now covers that path.
>   - Restored the absolute outer timeout in drm_gpusvm_get_pages(), since it can
>     run from GPU page-fault workers and must not rely on the worker task’s fatal
>     signal state to stop invalidation retries.

Here's how v10 altered mm.git:


 drivers/gpu/drm/drm_gpusvm.c |   11 +++++++++--
 mm/hmm.c                     |   29 +++++++++++++----------------
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~b
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -1405,7 +1405,9 @@ int drm_gpusvm_get_pages(struct drm_gpus
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long remaining;
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1420,6 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
+	if (time_after_eq(jiffies, timeout))
+		return -EBUSY;
+
+	remaining = timeout - jiffies;
+
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1434,7 +1441,7 @@ retry:
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, remaining);
 	mmput(mm);
 	if (err)
 		goto err_free;
--- a/mm/hmm.c~b
+++ a/mm/hmm.c
@@ -790,22 +790,14 @@ int hmm_range_fault_unlocked_timeout(str
 	int ret;
 
 	do {
-		if (fatal_signal_pending(current))
-			return -EINTR;
-
-		if (timeout) {
-			/*
-			 * If the previous fault dropped mmap_lock, then the fault
-			 * handler made progress. Restart the retry timeout in that
-			 * case, but keep the existing deadline for ordinary -EBUSY
-			 * retries.
-			 */
-			if (!locked)
-				deadline = jiffies + timeout;
-
-			if (time_after(jiffies, deadline))
-				return -EBUSY;
-		}
+		/*
+		 * If the previous fault dropped mmap_lock, then the fault
+		 * handler made progress. Restart the retry timeout in that
+		 * case, but keep the existing deadline for ordinary -EBUSY
+		 * retries.
+		 */
+		if (timeout && !locked)
+			deadline = jiffies + timeout;
 
 		range->notifier_seq =
 			mmu_interval_read_begin(range->notifier);
@@ -814,6 +806,11 @@ int hmm_range_fault_unlocked_timeout(str
 		if (ret)
 			return ret;
 
+		if (timeout && time_after(jiffies, deadline)) {
+			mmap_read_unlock(mm);
+			return -EBUSY;
+		}
+
 		locked = true;
 		ret = hmm_range_fault_locked(range, &locked);
 		if (locked)
_

