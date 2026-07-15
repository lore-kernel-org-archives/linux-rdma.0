Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ECA3ACF02;
	Wed, 15 Jul 2026 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784131399; cv=none; b=BURRQS8jyX7peWOnogYrLIc4mnE1NXGM4J48j2iPq1UJGl/wqlkLBeoMpY44siDCROP9r0VpZvE75cRgCND8qPh69Sl69yrpoT7RVXej5XzANShOtk45j7NuY/Dk9DUXpjWBhRZ4ii0J+OitzMDUBEIsSvOkdF77qpCdgtDhalY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784131399; c=relaxed/simple;
	bh=j66ycXNqmfL9ElgeVy3WnEOOmbqq6eqLlP83Cj5txIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D62+2ZNsRC5qYNLToHzxCNqg9X5i8BdvidEnqZ6Iwcb+8yRdtH2JwiEjqu9nDL+y708/H0JDTv3vNjMCNZbuSswHmOWBQNOVv8lmZUIz2lRFzm/TVuUGObkB4261tkS/z05qRqOepRrDdmWBkIcjBu9Mi7C9Eu+mUzVM6XcD2Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTe0PVEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTe0PVEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD31F00AC4;
	Wed, 15 Jul 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784131398;
	bh=f4C6n0w9mDrtHRCnStTGRTvpeLhmwUbbHGkqcxBvTik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BTe0PVEtIUgNNd0HJimWRQQVEEPMbL5+bzLWuypuzi9NIZDNIO6kUqirtSxlAWLFk
	 PrBLqf5Yq1l3QU6VH4iviptT0e9bRWpUM/uEXAasgR77pKC9z+vQd3N/ZT12gq+TOA
	 iSjdO6i4rRi3jSv2zcy+p4iHl9QURtzFzqcQgPTQEhJK2/xGqbUIZZT2Vi6+Rct4P3
	 d+GhP1nj6V3srM5djsFI26cexSh0CwKsIKZqFVpU6Sr6h376esJkNnOtKiwg2jmpGj
	 k+k3ZxxMJZcOYT4zJ80nQ91avqazBAS8yWXPX8UPGPMQCt3fqQNPTCHC8TVxaX0t6I
	 khlJo9zamFdrw==
Date: Wed, 15 Jul 2026 17:02:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com, 
	akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net, dakr@kernel.org, 
	jgg@ziepe.ca, kees@kernel.org, leon@kernel.org, liam@infradead.org, 
	lizhi.hou@amd.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com, 
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org, 
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org, 
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org, surenb@google.com, 
	tzimmermann@suse.de, vbabka@kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alet21wLwM6P_Km2@lucifer>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alecaJ1FUso39D9k@skinsburskii>

To avoid confusion: obviously please don't merge this series Andrew.

On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:
> On Wed, Jul 15, 2026 at 02:41:43PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> > > This small fixup series applies on top of:
> > >
> > >   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> > >
> > > The first patch updates the HMM documentation example to make the
> > > mmu_interval_read_retry() state explicit: callers should use the notifier and
> > > notifier_seq stored in the same hmm_range that was passed to
> > > hmm_range_fault_unlocked_timeout().
> > >
> > > The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> > > timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> > > HMM retry budget. These callers no longer keep an absolute deadline around
> > > their outer driver retry loops or pass a computed remaining time into HMM.
> > >
> > > This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> > > HMM succeeds and the driver later observes an invalidation through
> > > mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> > > retry budget.
> > >
> > > Changes in v2:
> > >   - Kept the nouveau outer absolute timeout around the
> > >     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
> > >     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
> > >     fault worker, so userspace fatal signals cannot break an endless stream of
> > >     invalidations there.
> > >   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
> > >     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
> > >     never 0, which would mean retry indefinitely.
> > >   - Updated the nouveau fixup commit message to explain the worker-thread
> > >     timeout issue and the time_after_eq() boundary behavior.
> > >   - Fixed the amdxdna fixup commit message. It now describes
> > >     aie2_populate_range() correctly instead of carrying stale nouveau prose,
> > >     and notes that command submission still keeps its broader timeout while HMM
> > >     gets a fresh relative retry budget.
> > >
> > >
> > > ---
> > >
> > > Stanislav Kinsburskii (4):
> > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> >
> > Why a fixup series instead of properly resending the full thing?
> >
>
> The goal was to get a Sashiko review, and v8 has already been applied to
> both `mm-new` and `linux-next`.

Please don't do this, this is completely impossible to track for review :)

mm review is currently very difficult based on volumes, it'll become impossible
to manage if people sound fragments of series.

Please just resend the whole thing at this point.

>
> You can find more details here:
>
>   https://sashiko.dev/#/message/alaWmUEeIBeSkmO0%40skinsburskii
>
> Thanks, Stanislav
>
> > --
> > Cheers,
> >
> > David

Thanks, Lorenzo
