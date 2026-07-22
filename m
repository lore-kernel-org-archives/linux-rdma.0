Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F57035C1B7
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746365; cv=none; b=SNEyGJ0RAz0495Jc85D0nvcYLyShhelZsqCLOco7omkcGiE2H2yAVS7c163mp4AhsGzM5mGOyxhMPsbYr9vy0Os+FJs0tnJA5Oj5FtcGzRuVSYAdwKfRiLDj1sgtGfe8++ZB1UDaLuu1e5215fo6IKp0F1DMlO13Kc0F87bbppY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746365; c=relaxed/simple;
	bh=0l6MVvOJRh+S8vgqEY5AG8STSmRz2uSsmD/X3ffNyHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvskMUaAQF1Tt2wUEDhayv7g3+/olUOp/vWrHfGi/QkOoMhrRsaH7ky4LjMPOGonouZUPFo8r4lrFBrPSryOzW6H9j9wJAnyekq7TuLWgWme+BRje1cL6Pd829eNO3gi/NPNyQqcz4/ZVth/qT8jwnB5lN890fp43LidgsEOito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGrm4QFp; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGrm4QFp"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ceaf8a1265so130845815ad.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784746362; x=1785351162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uym772qkEh9LOk/iL6aKk1xWDH0j1Tlr0rPbsmQanS4=;
        b=cGrm4QFpmYKxTJ7Ok+BjVqPMTUxCP0tuPiPrt9pSWNhLEToaIN0LaxMf4dzmTgMH67
         yTgNSlDlMUGxR1UpzLZhno2yXQxAdpWfRphUmXCYRgKLcKFXKG1gdg/50Pm1e2Hzmdy2
         do9T2lC7VItQZ4QqtzY2rAcx+NavZNkeggd4aHXTBo8xKb4DOTNu4gmIu8ky+l390KjS
         MTo4qo8R1zUUimkLGcH/lR3Z1ISusZy+bA9BW1h+05E6gfHW+EXqElptkAdwcY0S5GbD
         ecimiIQb720CpincUStXDdsdfgNgyjaXVCXQaplL7RlZNhNIYZjjth/7izuo0x3OA3/y
         9GJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746362; x=1785351162;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uym772qkEh9LOk/iL6aKk1xWDH0j1Tlr0rPbsmQanS4=;
        b=p48/n3gIG5BRY0PkIBBx2Fm6wbO8VUBRXNpg/FIsgXxr5YcNSN4943W+hF5YuXu6T3
         ItwKc+6qe19/0fyBlHxEnJEWl6t8Lx3VQ2j2SU7cZUvrfHVqPFiRpX89KdMa2RUguK6L
         wkrxiO/oxAW86MueWygaWRkmt8kzk/TT6vSjLHcbl0qLN3/yWUlvK4ZOXHKYguWNK5dw
         r/X86ac1xmEhKPkoXjRVBh0Je3BllUaOGMowJx3OtdJ0nBKtlh+f8hklKbLJwQ1coUA9
         s0fve3JdAfvcgV0cnJzyTKkEHGxkt8Wr4NElZYvxJ8bzqg9Uf1RdsNmw5oTv/aZG7l6r
         r9sg==
X-Forwarded-Encrypted: i=1; AHgh+RpVYW8oi3qd3NMpDklxBtFUPshnPviExPqTzZC0EFcdbuy/JUO0oEpElScbURJjz+rz/CX1qfLViFAi@vger.kernel.org
X-Gm-Message-State: AOJu0YwhHVIWyXgVxsKX/RgMGAHtm0yWa0enreniiWawtOpyn0BnKULu
	172Kzwxn9Dtm7jMKhV1H6uMq+8HkgnUTMoYG5JlmW3H4OzD0xwR/eQr8
X-Gm-Gg: AR+sD100UJX2CzRioiFliHx0tyJCWwBwz6iA7Ois3B82kms/nTbTZw6qIFSxHBhNzqe
	doWtwtYuAuUft8pc2VenwA7XMqJXyy4rpoNeVMKUtwBTTU/KHctid/5SdrVmpjm9qF/SmnyK8Z2
	30nwA9PjbP8zd5W6gB8yFOtCjOx0CjwIzenVCwyPrUYXby7vKhefBRb343PwnHa9AaY8J/jcUF8
	dBLZagmUTk5mj9txeYEtF8mmI1kySKKwkrqZ0RqBVVNhtooVbHzddjZ8obCb8b3qkMDpHjLFxz6
	lUFWe2tcUnSln56ahkdVhXXKVnzrjnhLLc57mbMv6uM4HQVXQDZh7Q3+S2XWw/44bDobbHO3ILw
	nHhvfTqdDFy0nIZ/aiuSh+tvau23WdSdgXMGZtRw24Pu+ZAgsFsU+W4hGZGxnQmKBWsJDJMpdpz
	xXQdTxaVljF8m6Mvy6u4n/td3gxU+M4DAiy7zfQwIHzYcmRoQKpT4mmKk=
X-Received: by 2002:a17:902:da8b:b0:2cc:7e4a:bcc5 with SMTP id d9443c01a7336-2cfa71aa7demr1018275ad.32.1784746361700;
        Wed, 22 Jul 2026 11:52:41 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efde5cfsm19378335ad.31.2026.07.22.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:52:41 -0700 (PDT)
Date: Wed, 22 Jul 2026 11:52:38 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, jgg@ziepe.ca,
	kees@kernel.org, kys@microsoft.com, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	longli@microsoft.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <amERdq2X5l5vHfJo@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413941236.1155966.14485211391150425997.stgit@skinsburskii>
 <al7CGPdJGM+asOFK@gsse-cloud1.jf.intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al7CGPdJGM+asOFK@gsse-cloud1.jf.intel.com>

On Mon, Jul 20, 2026 at 05:49:28PM -0700, Matthew Brost wrote:
> On Wed, Jul 15, 2026 at 11:16:52AM -0700, Stanislav Kinsburskii wrote:
> > Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault()
> > and open-code mmu interval sequence setup before each HMM walk. They also
> > retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.
> > 
> > Use hmm_range_fault_unlocked_timeout() for those faults. The HMM helper now
> > owns mmap_lock acquisition and refreshes range->notifier_seq for its
> > internal retries, while GPU SVM keeps its existing driver-lock validation
> > with mmu_interval_read_retry() after a successful fault.
> > 
> > Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
> > fault attempt. This scopes the timeout to repeated HMM notifier retries
> > while preserving the outer retry loops that restart when the interval is
> > invalidated before GPU SVM updates or consumes the mapping state.
> > 
> 
> This part doesn't seem right for get_pages(), see below.
> 
> > Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> > called with the mmap lock already held by its caller.
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> > ---
> >  drivers/gpu/drm/drm_gpusvm.c |   61 +++++-------------------------------------
> >  1 file changed, 7 insertions(+), 54 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> > index 958cb605aedd..de5bbfe58ee9 100644
> > --- a/drivers/gpu/drm/drm_gpusvm.c
> > +++ b/drivers/gpu/drm/drm_gpusvm.c
> > @@ -773,8 +773,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
> >  		.end = end,
> >  		.dev_private_owner = dev_private_owner,
> >  	};
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
> >  	unsigned long *pfns;
> >  	unsigned long npages = npages_in_range(start, end);
> > @@ -788,22 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
> >  	hmm_range.hmm_pfns = pfns;
> >  
> >  retry:
> > -	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -	mmap_read_lock(range->gpusvm->mm);
> > -
> > -	while (true) {
> > -		err = hmm_range_fault(&hmm_range);
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > -	mmap_read_unlock(range->gpusvm->mm);
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  	if (err)
> >  		goto err_free;
> >  
> > @@ -1406,8 +1390,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  		.dev_private_owner = ctx->device_private_page_owner,
> >  	};
> >  	void *zdd;
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	unsigned long i, j;
> >  	unsigned long npages = npages_in_range(pages_start, pages_end);
> >  	unsigned long num_dma_mapped;
> > @@ -1422,9 +1405,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  	struct dma_iova_state *state = &svm_pages->state;
> >  
> >  retry:
> > -	if (time_after(jiffies, timeout))
> > -		return -EBUSY;
> > -
> 
> I think that by deleting the code above, you have changed this function's
> semantics by removing the hard cap of HMM_RANGE_DEFAULT_TIMEOUT. This
> code was added because, on some non-production platforms, the timing in
> this function could cause it to livelock.
> 
> Is there any reason this was remove aside from timeout variable not
> being a deadline now? You likely should add the deadline back in.
> 

Indeed, this one can be called from a kernel thread context as well.
I'll revert the change in the next revision.

Thanks,
Stanislav


> Matt
> 
> >  	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> >  	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
> >  		goto set_seqno;
> > @@ -1439,21 +1419,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
> >  	}
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (true) {
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -
> > -		if (err == -EBUSY) {
> > -			if (time_after(jiffies, timeout))
> > -				break;
> > -
> > -			hmm_range.notifier_seq =
> > -				mmu_interval_read_begin(notifier);
> > -			continue;
> > -		}
> > -		break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  	mmput(mm);
> >  	if (err)
> >  		goto err_free;
> > @@ -1720,8 +1686,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
> >  		.end = drm_gpusvm_range_end(range),
> >  		.dev_private_owner = NULL,
> >  	};
> > -	unsigned long timeout =
> > -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> > +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> >  	unsigned long *pfns;
> >  	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
> >  					       drm_gpusvm_range_end(range));
> > @@ -1736,24 +1701,12 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
> >  		return -ENOMEM;
> >  
> >  	hmm_range.hmm_pfns = pfns;
> > -	while (!time_after(jiffies, timeout)) {
> > -		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> > -		if (time_after(jiffies, timeout)) {
> > -			err = -ETIME;
> > -			break;
> > -		}
> > -
> > -		mmap_read_lock(mm);
> > -		err = hmm_range_fault(&hmm_range);
> > -		mmap_read_unlock(mm);
> > -		if (err != -EBUSY)
> > -			break;
> > -	}
> > +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
> >  
> >  	kvfree(pfns);
> >  	mmput(mm);
> >  
> > -	return err;
> > +	return err == -EBUSY ? -ETIME : err;
> >  }
> >  EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
> >  
> > 
> > 
