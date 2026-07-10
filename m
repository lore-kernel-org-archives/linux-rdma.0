Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1C346FCA;
	Fri, 10 Jul 2026 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783721532; cv=none; b=LeL8ZAe2rSUFfDreEtQ6sOjbXsDbXYYmLjhPlyo+EUzaa3k7Fj5b+rkTARS4tDWcbzsAfcrZOchpZl5n1ptO4ew0FTAEArvxHLH9nR6DQdmGEYkO+crRLHXtePC8op1XVIN876kntFqUi/+rSl71opPBOWoUN/LQb3ANMVcMoVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783721532; c=relaxed/simple;
	bh=AZRiN8fHqLe//F1J0HLYXYtYLFkLf41jfZO8V1DqJGA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=U8ZdBa6eR27C8oMkNBEba4J+9mjrhS6sEK5/4KQrnmYLjUicHN2cpIV6+PElPdN6hwMF8nP/tNNqlir9SELB9UjJ+JXlPcrh40OD83FGTU3Kv7yhvGgjGiCybc+bCLFNHdkRTv/hkbejCo6kEXXjHArlI7WqCU9PdFRa8LWEU2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yaM672l8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yaM672l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE30C1F000E9;
	Fri, 10 Jul 2026 22:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783721530;
	bh=fo7hh4EtlekICL5k1AderHImVib8Wo/fra/wRbqEq/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yaM672l8pa/XMuK2uZBBEO6oCy6GZgo5f+KmfIVM/ga9krsyMfE5SWqDP7o7QFIGc
	 lGJhMoIXqjfeE0FMaH7nJ6ePG7Wzz1LC+2cK0WS2NcmXDgVqfHH34jNk0JoY7+u4V9
	 BsiLi8zdUMFgF7SqWqnUIoo6uK8JKalKt/P+V2qs=
Date: Fri, 10 Jul 2026 15:12:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-Id: <20260710151209.157d7c80b03dc56d73b5884a@linux-foundation.org>
In-Reply-To: <178371879503.900500.7148019929226548795.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371879503.900500.7148019929226548795.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 14:26:35 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> hmm_range_fault() requires the caller to hold the mmap read lock for the
> duration of the call. This is incompatible with mappings whose fault
> handler may release the mmap lock, notably userfaultfd-managed regions,
> where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> after dropping the lock. Drivers that need to populate device page tables
> for such mappings have no way to do so today.
> 
> Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
> mmap_lock across any work outside the HMM fault itself. The helper takes
> mmap_read_lock_killable() internally, calls the common HMM fault
> implementation, and releases the lock before returning if it is still held.
> The timeout is specified in jiffies; passing 0 retries indefinitely, while
> a non-zero timeout makes the helper return -EBUSY when the retry budget
> expires.
> 
> When handle_mm_fault() drops mmap_lock, or when the range is invalidated,
> hmm_range_fault_unlocked_timeout() refreshes range->notifier_seq and
> retries the walk internally. If the lock was dropped, the retry deadline is
> also restarted because a lock-dropping fault handler made progress.
> Ordinary -EBUSY retries keep the existing deadline, preserving the caller's
> timeout policy for repeated mmu-notifier invalidations.
> 
> The caller only needs to perform the usual post-success
> mmu_interval_read_retry() check while holding its update lock before
> consuming the pfns. If mmap_lock acquisition is interrupted or a fatal
> signal is pending during retry handling, -EINTR is returned instead.
> 
> The common implementation conditionally sets FAULT_FLAG_ALLOW_RETRY and
> FAULT_FLAG_KILLABLE only for hmm_range_fault_unlocked_timeout(). The
> existing hmm_range_fault() path still passes no locked state, does not
> allow handle_mm_fault() to drop mmap_lock, and remains a thin wrapper
> preserving the existing API contract for current callers.
> 
> The previous refactor that moved page fault handling out of the page-table
> walk callbacks is what makes this change small. Faults now run after
> walk_page_range() has unwound, with only mmap_lock held, so dropping it
> does not interact with the walker's pte spinlock or hugetlb_vma_lock.
> Hugetlb regions therefore participate in the unlocked path uniformly with
> PTE- and PMD-level mappings; no special case is required.
> 
> Documentation/mm/hmm.rst is updated with a description of the new API and
> the recommended caller pattern.
> 
> ...
>

A trivial thing:

> +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> +				     unsigned long timeout)
> +{
> +	struct mm_struct *mm = range->notifier->mm;
> +	unsigned long deadline = 0;
> +	bool locked = false;

This could be local to the do loop and it needn't be initialized.

> +	int ret;
> +
> +	do {
> +		if (fatal_signal_pending(current))
> +			return -EINTR;
> +
> +		if (timeout) {
> +			/*
> +			 * If the previous fault dropped mmap_lock, then the fault
> +			 * handler made progress. Restart the retry timeout in that
> +			 * case, but keep the existing deadline for ordinary -EBUSY
> +			 * retries.
> +			 */
> +			if (!locked)
> +				deadline = jiffies + timeout;
> +
> +			if (time_after(jiffies, deadline))
> +				return -EBUSY;
> +		}
> +
> +		range->notifier_seq =
> +			mmu_interval_read_begin(range->notifier);
> +
> +		ret = mmap_read_lock_killable(mm);
> +		if (ret)
> +			return ret;
> +
> +		locked = true;
> +		ret = hmm_range_fault_locked(range, &locked);
> +		if (locked)
> +			mmap_read_unlock(mm);
> +	} while (ret == -EBUSY);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(hmm_range_fault_unlocked_timeout);
> +

