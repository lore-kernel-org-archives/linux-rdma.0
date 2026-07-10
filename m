Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5DE43B498
	for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701665; cv=none; b=YkF9k2tdGttlTVfVo/GvTisvqrVbf5fopYQxy3hRdtnPZynySpbimpAlMiREb/u209lV7BqagVJ7XtH4sZD+UJ4AHT+O+Noj9LUuUeyVWx+VDzRAbkpJIbbVRym+87uTSc/mWAHFTLe6j3a+nOsWQBkPWjCmvW8GRMeYoqVaiao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701665; c=relaxed/simple;
	bh=97gDvxv4aZQT4UUmzVBR2oQfVgbx3iRf3Vdj/SRY1i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdnjZD4Ned90Vh/aESqLrnycrqgw1kSWif8f3FCxP+FKf9OJpdqGEER1HdGtTUZq25xYhOpAFSTaO0zsKfXA9dyotd2u+yKAWplpi4j2AHAjTLOIh8PJRmfwf7YG13fn48pcUmbI4E1o+2DkU7N0WtFZkqjlieRAR+H9jlVIJI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZRBAEdjI; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZRBAEdjI"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so8909806d6.3
        for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701660; x=1784306460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z7U3THTZDjx6I8tSiQ91l//DDsukKiO5Egsu4KIAjvc=;
        b=ZRBAEdjIeQtxxaryQLV/DV1M6etRXRRZeJZTBzc3/D5Jje14ctDu1qTn0m1JV8zpds
         Pp4m1qoAU/VDjCMVBeX4OSKQOcE5veBAo/TST3hsT2nTEcuadmb3cinmOGbMXw19nxVc
         mOpb1qm4dFhtftaATu4oF55dQxbjqBss94bmOeknL4rTJtLOabGpf/D1FqZ+Sg7AEBMs
         LrQffX/B7EQ55m8kbqt4A8evJBTuCPUlF/U4sWOAbeCD0VFS8MAhd3nJmM3MgCYEPSCh
         J2k45cMnPosDIq6gu284SEDm/ZaRv4T/PjTaV65pA4U+7OCTehCqqvw9JrFtwG5LUuVv
         6Ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701660; x=1784306460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7U3THTZDjx6I8tSiQ91l//DDsukKiO5Egsu4KIAjvc=;
        b=f3lXZLrNYEBgbQoysCJYTeX7V1fTSxK+DHWlrAiowrhflSOZ/BxrmP191E0AlfK7Sw
         +TKXza6TW/VXEnu2ta0TO73eWaTsZzFjhkBDfrP7PXywxLo45hRk4rr4J2TSEnArWPDq
         vKEvBw9l2wpcoxewlDSBqLKlfKkeD5C+Xwltqv1o5iy6IEbTdG36dTrK7Z4tfQ9dlbOY
         hHMbkA0pukV9jF0pE9rIjarGjMdcQBLiFRvsi2n7OzW2yt/rQehajlS/df6nkYGTbRZy
         CsMDghj9hRURYM39oHsDkAEGTZ2So67xPahuYpxJqdXLIVYvRlNJqOAp8qgCClnKAHjR
         2Dpw==
X-Forwarded-Encrypted: i=1; AHgh+RqVxyhRBjqcD5PPinSEGB3Yr6LuDZVJuaRGNPwh6kPLHxng0O8R8aOugTAXu/XrS1wjKE2Tz+1kTaXD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3kyxRHX3xYfowC0M7sKwXr4/lijVPHs5HcnHYDul3L9g09thw
	xbt9ggPqZBkdkkhlfc86BcsekRyzspw8NAidRG5LZnu1Mj7WgakNlHKvoQAAcEYLEGU=
X-Gm-Gg: AfdE7cnxera7/Ig/lCloFVlEepe8lN/eu/fgeBTN+IfbUfia0/ZLjlDd/iDvm1HEthT
	IDiSKx41krarkLoCNavWZX9Kcd5jrjKiirFDEhbIHAfFHZ8uWu3lUyHTjRxyb9pcLdrRrph9Ven
	6DcTsTyxSoQ/I1keKAVYulsq8Uzt0xtEXyX3rIc/1Xolmh3zBnGPMDCdG1m770E084WH8Ou0q3d
	Nef1T/XOkRBU4Dx5Y3BNOxWrvAcGOeHnJWCxC1f+xDfSa12qZ2VU/a20oVc7o2d6lIG74t8nJe1
	VcGKZnSBwCf3e+7hu2qr/Iq5T2NasNU1aCOKBr1vuOBTXKn3UGMgDCy9SWvLjs0mSW5gFY6pocR
	+sAamHINPnMXuDFIlmLqpAsUQnSolNj/xWtcZF1np/VxSIX/yFLn6xR/m0qTEebL5eHW/QIY=
X-Received: by 2002:a05:622a:558d:b0:51c:164b:b241 with SMTP id d75a77b69052e-51c8b2d5582mr133755821cf.13.1783701660503;
        Fri, 10 Jul 2026 09:41:00 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e0347sm45334476d6.2.2026.07.10.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:40:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEHb-00000007Yc5-1TXt;
	Fri, 10 Jul 2026 13:40:59 -0300
Date: Fri, 10 Jul 2026 13:40:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-ID: <20260710164059.GT118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345364273.660027.15274510603185163961.stgit@skinsburskii>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345364273.660027.15274510603185163961.stgit@skinsburskii>

On Tue, Jul 07, 2026 at 12:47:22PM -0700, Stanislav Kinsburskii wrote:
> nouveau_range_fault() takes mmap_read_lock() only to call
> hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
> deadline across both HMM -EBUSY retries and post-fault
> mmu_interval_read_retry() retries.
> 
> Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
> the mmap lock and refreshes range->notifier_seq for its internal retries.
> Nouveau keeps its existing absolute deadline in the outer loop and passes
> the remaining jiffies to the helper for each fault attempt, so retries
> caused by mmu_interval_read_retry() do not reset the overall retry budget.
> 
> Nouveau still validates the interval notifier sequence while holding
> svmm->mutex before programming the GPU mapping.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_svm.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> -		mmap_read_lock(mm);
> -		ret = hmm_range_fault(&range);
> -		mmap_read_unlock(mm);
> -		if (ret) {
> -			if (ret == -EBUSY)
> -				continue;
> +		ret = hmm_range_fault_unlocked_timeout(&range,
> +				       max_t(long, timeout - jiffies, 1UL));

Avoid max_t, 1L should be a signed long.

Though I'm even more concerned about the timeout if drivers are now
wrapping the whole thing in a timeout... That's not sensible at all

Jason
