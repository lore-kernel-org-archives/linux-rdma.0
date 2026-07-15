Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944F243B6EA
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127736; cv=none; b=pR54Qxnzu+u46iddWTer6AKyyOR8HqFsaNslccaeFla5lvTd6oDyJ/VkSv4sABALp/6g45NwVnP2eSW90jtkdDh1skahpi0OEza6DZPPnfEjCWgkbOCApaV47j7XTXHwnoDPKI2rr7Mh8XuvJZLFdX+pQBqLRngTsbrs+S2rKH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127736; c=relaxed/simple;
	bh=QBcmHHIDpPZ2zSYqCsJ07Zn7cTcc/wqKwrbcJo89maY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyJC2oC8LcLHUOPydlSE1Y/M6PBrWf5mnWC/BdkbSrRtxMUE4SdeYZTtjVBSEXIRxS6O0WMr50HsE7LAwraqRvbouZzpL/F+rfWOj+Gr30oS3Z9qJ0ldvUuiAuDriIa6PEotDO1OdG4Mn1G235JBfHVhzH8uzxQwPnMLomsNqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DE2WqHhT; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DE2WqHhT"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-97622cc1f40so2193807241.3
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1784127733; x=1784732533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nGecurzBYdjUfiEExv0oL4FVVbYZSUEIMh9OhYH+0R0=;
        b=DE2WqHhTKM3qWnPPNIomeJRudvuTvXFYZNsYdA++akthGHjRltuFiX2iUsmeHcvuah
         11wmhmJHWQUCtSD/AlL6FzZabxDIkrvNpJ7dCRvviHJ3OETCfkXIPvrg8LFuppfR3I6U
         vr0IqCCj8SBxmsK46CKoUnqdCVSSlD79b5FSkmkPIlxgKt4HWWbahu2hKBqCyq6cl208
         Wrv5rBFFHPOrPGRvZLdAlFL4tltc0DxhseNJAD2LzDZEU+TRQA4zleDET+SFvuwktmxS
         1G27sEZSxUCyjA+AA8cZPpVK4+T3CJKxupJJhoeFIBBBsBuURQ7sfJW0yzAiKGu5XeXy
         vyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784127733; x=1784732533;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nGecurzBYdjUfiEExv0oL4FVVbYZSUEIMh9OhYH+0R0=;
        b=Ei+5/TVooTtnASrPwwyReXxE5rQIeShPLrx/XCg4kilve1HWUq3fqaBDO+v0ln6H1w
         JLXUOkDPbDPXelfeaXfyP5M8znRntGgRgXYH574T/VGsrmoTaqpt5IXGH2oWRw6Zyey2
         1VN0dI7X1elR5vsvY7Nlmlf4yXshxWTqqhSQCfvqDW3ZPjfe2zaJbmuBqjAXFlxlgrMW
         UusVxZ21yeY6xS5dTacm+5NbTenWozaAf66eocNBxOcMYswuGc8ZHbB+iGeqokAu3/ai
         GEU9zSBXXs5zO/qYx8VjGhwo+loHU7Sdw2f+pQxoyu7zjHPwLRfK4RPvUAn4LvElnwfR
         GuSw==
X-Forwarded-Encrypted: i=1; AHgh+RoYwmjRyRZXdZX1ud9rRF/heMrrdRiMkpdRvHe0e7rpsTx8bG/J1o8zjErGZbkJ6uvwEEr9tQ6Pv7hV@vger.kernel.org
X-Gm-Message-State: AOJu0YyYKM3KnC1SeEJIleQFM15dBZTBLQONBg9sDnaaX4Wggegxn10v
	yRjJ32kvbY3YQaeC57o7VwMzSY3yNXcYqGG8F4TRXpLi0SfaIki+uWaH9SkSNxQK3Ls=
X-Gm-Gg: AfdE7cliuSqe7g0ImY47oM7fyXdbbIunFZ2yqXrU2i2QMd/lAS66KeL3Co+SS7ORDdC
	t48Vlgh9lSxNHSZrq3Q//Pl7PNAL/dahynVBL+hhZ1CHcRjiWHbFsnccnEJfWn3Zy1psCFsn8jV
	PGnwPzMV/QYlFxFq42e0O2JBqCfX0Gg2/LM+ZJ0xox38O2vZAEF9auz4/rIVXT18QkES74omNTW
	MSququmaoxJCxl5uTs0oVe9Xh4USu5CWzIRGKGJB85OeL+S361nzEhpR6jp186svsnCMM0RSr3g
	pCX5X/BjAHoVxrksbjrSlckNB3pQvoYXOEyL7njLfhwG5NocXdWSLQi3Bm8G8UJ4+BRpHw/8OaL
	0KeAJjQzNBa5HhXynbNXGmNuANUFp3EXiwq+ExLQk1o8teI+obpZeUcbObD/D
X-Received: by 2002:a05:6102:d87:b0:737:9edc:36f6 with SMTP id ada2fe7eead31-7458757b204mr4167130137.26.1784127732764;
        Wed, 15 Jul 2026 08:02:12 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e0811sm196100666d6.3.2026.07.15.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:02:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wk17i-00000000TXQ-3Nvp;
	Wed, 15 Jul 2026 12:02:10 -0300
Date: Wed, 15 Jul 2026 12:02:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com,
	akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net,
	dakr@kernel.org, kees@kernel.org, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
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
Message-ID: <20260715150210.GA3846105@ziepe.ca>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alecaJ1FUso39D9k@skinsburskii>

On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:

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

I think if you send the whole thing with a base-commit tag that
specifies a real base commit in linux-next sashiko should work

Jason
