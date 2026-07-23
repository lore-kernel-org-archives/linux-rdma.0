Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34463E3163;
	Thu, 23 Jul 2026 21:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841766; cv=none; b=Ev/xMUO6Oj6d+SMDY3PUn/RtlTTR2GDadoQVFdDvCdpSqUJaO76oug22zR/ObXA9cm05fSd5q+edIYWv0/PLyFMHoztX1lwvLePdj2t39XD2FTXKdeuSxxF6t++onMkcM389r3b0bC8iwVBNFzbtlwCNdxLAeZCCc3jnrzj7DE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841766; c=relaxed/simple;
	bh=lBYihD8VUd3/ijOxM1HG7tlwRXQ5GtSXGskH/OAen8c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZZkgd3Pb9lmvd6Xqfhs7pIIv/GZ/rp1hLQjcfL7bFFcWZ2RKzDiPnsOp3ohY1hP9vPR4gNt5FZWdqxrH3lY0nHs7Ful7ysZP7XfWAMMJcCp7rZ1mc9oRpx3cZV20OjtrgxLZC8O8kN7x0MPvJ02z991sRsGKw+dz7nBU3Hv6Jeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PqDGtK1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PqDGtK1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E381F000E9;
	Thu, 23 Jul 2026 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841764;
	bh=8LsF46xxakxlsARFJxGTWxEVy+kM0PIVoXm+jBklc8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PqDGtK1ymZc6iwXzb09CtmFYmLViI3ZUzwC4EZJzeq9zwSf91u2vNh/4wCIJIHPWO
	 e15iO8gkDRLbbRBA2tojf2jKWmot7imPS0HbTnDJI9D1VtypOpQwHATciE7rioefeK
	 s0fKBNhwMPvzspt/Hs40GfWyqW0dMZJpQhg7C0tk=
Date: Thu, 23 Jul 2026 14:22:42 -0700
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
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().
> 

Thanks, I've updated mm.git to this version.

AI review suggests there may be some problems.  Sorry, I don't recall if
these were considered in previous versions of the patchset:

	https://sashiko.dev/#/patchset/20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com

> 
> Changes in v11:
>   - Reject unstable address spaces in hmm_range_fault_unlocked_timeout()
>     after taking mmap_lock and before walking page tables.
>   - Compute the remaining HMM timeout budget before the time_after_eq()
>     check in drm_gpusvm_get_pages() to make sure it can't result in zero
>     and lead to infinite HMM range faulting loop.

Here's how v11 altered mm.git:


 drivers/gpu/drm/drm_gpusvm.c |    4 ++--
 mm/hmm.c                     |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~b
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -1422,11 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
+	remaining = timeout - jiffies;
+
 	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
-	remaining = timeout - jiffies;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
--- a/mm/hmm.c~b
+++ a/mm/hmm.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mmzone.h>
+#include <linux/oom.h>
 #include <linux/pagemap.h>
 #include <linux/leafops.h>
 #include <linux/hugetlb.h>
@@ -806,6 +807,11 @@ int hmm_range_fault_unlocked_timeout(str
 		if (ret)
 			return ret;
 
+		if (check_stable_address_space(mm)) {
+			mmap_read_unlock(mm);
+			return -EFAULT;
+		}
+
 		if (timeout && time_after(jiffies, deadline)) {
 			mmap_read_unlock(mm);
 			return -EBUSY;
_

