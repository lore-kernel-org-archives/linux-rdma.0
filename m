Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEFF46D2D8
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784652576; cv=none; b=T62qllTNPGjUgN+Zw+E5VIMFBkcxVrsw12UI1s7UrUtblxEHWxf5cotXFIbG1i53fzgxyLGOxplyIb7fCiLVaeytwqhPnYsf0xG20Kh4CxyMcfd96SeNPxD2W9EPvM26cpHz/U/8pWZNfu3XuVvnnDDgBI+o1ivL4uJ4QbXIM/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784652576; c=relaxed/simple;
	bh=1Eewe62A+0W0Tj8OlkqWwebX8DuY99PcvPtXyaE4KnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcyLMMKIlQhINbbTZ0urAqJa0655LhFBUL49XM9YtHTCWSoKMByPwDOFOFLpxs1WjPHzk5B261Knn2wvw0r/eHtXqfBiLZsAA2bSzPicmEqwQamD8PCtmG46ZDQOFRz7yUSIErdKAk49+FzkTkv9I8cxGOwJGwLQHJx6A4YrZ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3dVJ2T0; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3dVJ2T0"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1013718b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 09:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784652574; x=1785257374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jz3tCmNLomhxeSHRRM/RsgqxQHXL6/1WUZFNVLX32Kw=;
        b=X3dVJ2T03PUCWc2hQlcjesoleW222Gl/XDcL9L/y2HmrUNhA4ZQR6uAiyQqwNTSuDM
         Og79l0p0EGCO1tfaTNwp5Nx+J3Kpb3Wmb5ttiaVoU90tTfsSxicuXAG8cETB7LwMSwoH
         KTFvd1BJI8i0GuI7rCa1J3suSYPLcncxpd8VsjlmMDKwzEJ8Kpqw4XiNcSECCCm1+iDe
         GVrHOJMTU6DOUEh2e+8jTbuSCCtQF4fDZx6RVjKIjNv6xE0bt/rspSeZqUtbBPZ3CZ6k
         gmkrg2dLDUXicwewJrKyX9WJB/BEG3rHqjr9lzjZrFEO4TvMy1jhK7c8MCBEJTKnakl6
         cclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784652574; x=1785257374;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jz3tCmNLomhxeSHRRM/RsgqxQHXL6/1WUZFNVLX32Kw=;
        b=IF33e2lntW6XXOmV/vUN0kmm454CgsLeSycpmG0KS9KM6TBHgNHSUI2v7ZylMZBSWo
         CgUfqX9lSqN1k5B2VZ5xT12doMZT+UF+MYeF1FZDtDA/hZy6qp6SZ1lRD0PFVwRX7LzP
         15YiFoR610PgJpb3mKk1GexXy+4VnT8GEFtAS3n/WbiH9SNFC9BSFdjAQ/ishxz92kPw
         D+4hyVgOAVF0qcRkV3IXbq48qKheJGMnovtYOjG2OYNpn20xMTRliUTonssWppqCj1XV
         MviyJEbsQV9TxPUZ3b4YDET34WjrVr3XSt8XHKTN39ZFwfUn05WrSKgxu+1W9/NoOtDJ
         fvUw==
X-Forwarded-Encrypted: i=1; AHgh+RrK5YjJ2X7tY3FXkIG9tj4nbMZJQb605zHCHiZ+fpBrLoNWXanp3x8l+PDkzmV+x0K18qt2oY3pD8ya@vger.kernel.org
X-Gm-Message-State: AOJu0Yz43gX+WL4nEoTl3+ubpVdd0+xhN/+27/IS4t6OrOjQLHkgD3Ir
	BedkfCX11sRmNMaFRSVnYRi7x7TMX9uot3abgAdZNRjdzjG3oiHmY+6J
X-Gm-Gg: AR+sD10ZC0iY0cBb1sCYrlVxnk/Bk6fG8W36AIW+B3wfHLyyBr0GXHZt8bOL/QvbQ5B
	m4rEoEaM5Vb5G+pfrd/zQWM2tR6MxTaR3tThtz2FJLgwvN0B0E9Sptc7gWes+Pr9t7JGNi0tP7u
	fw/KD4+xUkzPw9pBphjge2HaZddGaVRa5GHa/IM1zCPZxPc+7eGPxgLGKMYMHalSRzGkRFDuqwZ
	1Utq689EcTXycpqrVX0o3983hNoiooiP8s2rDmj+YVHyXKtKAXhfC/GlcjM6nKEtpILP8kpTk4O
	DHKVnyrhtZEHLGrXI4kTAJcZECy11PHGYtltX/Z0OpQLGX8RTMerL46qs6KXJK9QIgexnUQraCi
	Y4gYhP0UBkJplpYzM+IchbdNTiPaXpMcNc5TYJhnjyzRKxlN6Isqf96Jwm8tF51uKqOg14dj6U5
	1QMn6vJoidbffii1l0N07VJoLT2zgiECHJcQm+fj+K7FvN
X-Received: by 2002:a05:6a00:cc7:b0:848:6f5c:a327 with SMTP id d2e1a72fcca58-84c29270ea2mr18663190b3a.15.1784652574553;
        Tue, 21 Jul 2026 09:49:34 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175aad1asm5186b3a.44.2026.07.21.09.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 09:49:34 -0700 (PDT)
Date: Tue, 21 Jul 2026 09:49:31 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <al-jG2fROgMWUq_T@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413936536.1155966.8918127042760531802.stgit@skinsburskii>
 <3ed2043b-88e7-4a86-9efb-fe788191e8e8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ed2043b-88e7-4a86-9efb-fe788191e8e8@kernel.org>

On Tue, Jul 21, 2026 at 05:42:53PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 20:16, Stanislav Kinsburskii wrote:
> > hmm_range_fault() requires the caller to hold the mmap read lock for the
> > duration of the call. This is incompatible with mappings whose fault
> > handler may release the mmap lock, notably userfaultfd-managed regions,
> > where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> > after dropping the lock. Drivers that need to populate device page tables
> > for such mappings have no way to do so today.
> > 
> > Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
> > mmap_lock across any work outside the HMM fault itself. The helper takes
> > mmap_read_lock_killable() internally, calls the common HMM fault
> > implementation, and releases the lock before returning if it is still held.
> > The timeout is specified in jiffies; passing 0 retries indefinitely, while
> > a non-zero timeout makes the helper return -EBUSY when the retry budget
> > expires.
> 
> The timeout does not / cannot affect how long we might be stuck without the mmap
> lock in e.g., the userfaultfd handler. And also not how long it would take to
> actually grab the mmap lock.
> 
> That's expected with the timeout, right?
> 
> [...]
> 

You are right. Ideally, the timeout should account for the time needed
to acquire the lock.

However, this timeout is not strict, especially with userfaultfd. It is
more of a sentinel to make sure the kernel does not get stuck for too
long and that progress is being made.

The default value used by most callers is 1000 ms, so accounting for the
time needed to acquire the mmap_lock does not really make much sense to
me yet, given the sentinel goal.

Thanks,
Stanislav

> 
> Nothing else jumped at me.
> 
> -- 
> Cheers,
> 
> David
