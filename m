Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5F239184E
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126574; cv=none; b=lg2FRZBdA+XR5Xe0BH3xNFaeBdzRT9PTcCSybbIa4myPKE42JKlVJex9mkUcxKLl50EhneQ9qWGedPVUVAfnfGFlnt3RNY2t6AUZRoJakS/oU0YmweeFBpGR21hoG9uCjWRr+9hU5P1MJhQMigfjrk3gUJan+aZ50FKq8u5L3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126574; c=relaxed/simple;
	bh=yasRtJyu7Ov53Xca8IMDdwCAT0wNHf1OQgxn2u0jL/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0GAOGS0t97c4cpY1JSMSpERA5O47rdobFackljDFPZ430IS3xkhEgHS4lqUahTKnBWWThmxRbz/JCtPQMXyzDeEAQzwqSKeMCMe/lihDeP1/M14LNh/VZEbG2/qwbulpM9PXxf9wS717IVa+9tem3ASuSpaQwSNwYdfXfOXCp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z2+m/uyy; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z2+m/uyy"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so3753380a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 07:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784126572; x=1784731372; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YFdvFy4JZmcJMIT1d11E7kO8Wgq6KQpSjvMclrKV/Fk=;
        b=Z2+m/uyywK2oDuVHkcU90yKGSxi4PXe4S4gs03x26bD8X6BCvYPSoHsOWUVQ68zjJn
         u6uXHrMw7ZOXrVq1VdS5td7IyQ8sA4W9utSQPJhP1guDgcl0ujJZcIpCa5VN8nU6vfqI
         0SA4lI3rEt//wtQ4pl5ZPWM6gBnQ/ZbF2ZewA6cyBkndA493VtdpkfdXXUP30SNDAPBX
         /swURmiOE/86c7y/VAeW2J+frU6dAPvJXLzAshMyHOUW04knMYbnlJu58naekN8vnH/K
         8Zc/IntpugtEnt6H6gF/61oGVerRQGzJNkpteI4rGiGR7H+bWyTsX8bH9Ce+qMETEA66
         HYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126572; x=1784731372;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YFdvFy4JZmcJMIT1d11E7kO8Wgq6KQpSjvMclrKV/Fk=;
        b=r+iqNriRQYh6W2qhoBA05/riGXkFY9DqDpMoeCJ6Y/g3fvzL7Sx1Wurr6p7EX0T3FY
         bqSQp1Q1aaBs3otY0XtD2zVeqXH1WCOzO9qxwiV0JMVsz9zpkXKL+WmEqOdmZ0PV6sgj
         TFefr6lPJGdL5UbEAd7rtfmORFc1KD0ZZTiJliXSWvoGKCPdM13Qc9B3wJp4xKxrDiBA
         kL1c3nE6QEzHXHeSw40dzdcTrzfREj63iEMoSUaApB58QMRZRxSWBnLQGWqx1gbK/HUP
         FWgpFwPX/PVR42xUGVVNb/RUoNNvO4VG8MxaWTEKig0B3hQOqzMzUHmw+V6G8X7WpiJ1
         Nqlw==
X-Forwarded-Encrypted: i=1; AHgh+RrHjqLnJOu8UZW/6/vczYnhdwNRUXNRiehvpL4L2bMcsd9opGaPW+R2nkNmoWs75CljZ2YPQpRLzb6n@vger.kernel.org
X-Gm-Message-State: AOJu0YzCpgzVtj33lr/JGoC2QMHzLr/jMLUs7Gy61uNe/2PWeAt/xV/g
	LzqVJVV7aG3ilPfk3gCqkDvWoXVIyayEKbwWE43HST3uREcOLXsRSu6M
X-Gm-Gg: AfdE7clD3TN3VBmcR9sS1bXT2z1dTU/kxTMYmV7PLERubs2I/tw1i6QVA1ZBqN3kbBA
	4ZocDhsKNnuoEee1uYMtlNIlOagx8OjJ4hJVVtMsKrqug51uA5GyWKaFJlx3vT7BXPoxtnNrq2J
	eUidUgCiI42G6khZj8vvj6lw9SH6dS6L/Kp+iZMUh9y5ixKhExTDVMYxrpK2bLdWuIIxlE2YCDr
	y2BgP3cJqTIKKRQPQRjgTVKHZnS/tbiHJUATf1iuJEuZCm2BWPHOIXBy+v0dnopfqHIP4J9zqgZ
	I8F/T8POp9XWXPad6IUSb+imVbuneuZnqHldX0x7GXANx/K2pDgKQe9haUwBi4rrYKZf1GK/f0u
	c/hhmwQ7cYQ7QWr6FDqyHocqaKL1CjH6kQ9PlKLMKUV4iBtchfA5hOBGi/kAEqUq6W9uQeKf2dd
	pWz1/6oTd7gA305f7XuJHIalF1SSjgJqDOQQWjxHJChw+dAk9ufsLs1HY=
X-Received: by 2002:a17:90b:2890:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-38e29ff97b1mr2563808a91.9.1784126571549;
        Wed, 15 Jul 2026 07:42:51 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6da2sm3320825a91.4.2026.07.15.07.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:42:51 -0700 (PDT)
Date: Wed, 15 Jul 2026 07:42:48 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org,
	leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
	ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alecaJ1FUso39D9k@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>

On Wed, Jul 15, 2026 at 02:41:43PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> > This small fixup series applies on top of:
> > 
> >   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> > 
> > The first patch updates the HMM documentation example to make the
> > mmu_interval_read_retry() state explicit: callers should use the notifier and
> > notifier_seq stored in the same hmm_range that was passed to
> > hmm_range_fault_unlocked_timeout().
> > 
> > The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> > timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> > HMM retry budget. These callers no longer keep an absolute deadline around
> > their outer driver retry loops or pass a computed remaining time into HMM.
> > 
> > This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> > HMM succeeds and the driver later observes an invalidation through
> > mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> > retry budget.
> > 
> > Changes in v2:
> >   - Kept the nouveau outer absolute timeout around the
> >     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
> >     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
> >     fault worker, so userspace fatal signals cannot break an endless stream of
> >     invalidations there.
> >   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
> >     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
> >     never 0, which would mean retry indefinitely.
> >   - Updated the nouveau fixup commit message to explain the worker-thread
> >     timeout issue and the time_after_eq() boundary behavior.
> >   - Fixed the amdxdna fixup commit message. It now describes
> >     aie2_populate_range() correctly instead of carrying stale nouveau prose,
> >     and notes that command submission still keeps its broader timeout while HMM
> >     gets a fresh relative retry budget.
> > 
> > 
> > ---
> > 
> > Stanislav Kinsburskii (4):
> >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> 
> Why a fixup series instead of properly resending the full thing?
> 

The goal was to get a Sashiko review, and v8 has already been applied to
both `mm-new` and `linux-next`.

You can find more details here:

  https://sashiko.dev/#/message/alaWmUEeIBeSkmO0%40skinsburskii

Thanks, Stanislav

> -- 
> Cheers,
> 
> David
