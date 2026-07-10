Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A9143B497
	for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701871; cv=none; b=iZUd8Otq6k54z5ph6sUPCafTc17E+U4kq2NV3kSxW94H3hd8hlRu5Buif4cGP0I2VCXpSvTqrYysu98SbWhoQYMByx2C5b9gFkFsfozdwB6vxU0cWxJmw7uZDqK92mTWJaV6yOmzeuFNoIEGcbFdiWHZ5JP2AddxfOVth3axHLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701871; c=relaxed/simple;
	bh=f7MiJ/V3Sa3Z4+LOlKBCBuiD8YraJfksnG/xFb+njPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e4YBw3XU3MfTiEv10xS+W1Bo9MNec8ZDGqIgfUsU8g0QQ6U1dl9SM+osG3ufkSOXLV2iF/xDrOLu98yENTURdhwVXLJmNbVQ+R6XsTlTUBwCNi0ALAjKJWsmgo6rnS02GNusQbYt+h0/BncpfaGxKhkQVVdsbIjN61riI/nzUNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=FI3oP9YY; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="FI3oP9YY"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c22c61795so7682841cf.0
        for <linux-rdma@vger.kernel.org>; Fri, 10 Jul 2026 09:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701869; x=1784306669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f7jwDOcuUIXFwEJ3t6jZRtuRC5qCtLyV1KSZwcqARY0=;
        b=FI3oP9YYHhgE4T+LuS14BPDc6wqIOy69I4OhseWi8Rt1tf/J5Mw3KqzOf6S+XJf4aX
         tV/TkU2s864YpvGiyNx/mIKxQhOkoEySrwrleUYzVE/nk7OeZ09B60cbMn2C3XmSQBy0
         dqUTDIHtc1vDT6N+p+5/Cqtfo4tviypiymM9uA+GYCDiJoYk42KS1Thf96n87SaVikK8
         5dCSyAFF9LCmzGimeccwBw2zwbOpBfwEa5eAjiDX/+tKjtEvbX2JvgOrjflIojIjBHVg
         u4wJfYIrprUsVaVeeMCc8E4o9AmWKP8vhp3Wh/GBkbzhgV/KPNV40AuvmCVuiOEOMOXf
         te3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701869; x=1784306669;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7jwDOcuUIXFwEJ3t6jZRtuRC5qCtLyV1KSZwcqARY0=;
        b=q5pmwMcqBq/4FgvGOjLHSwP+m+YJTm/AOSmg5M3oEwe6WtcVsLOOVfZ/7l7mAOc3iL
         LV6aJdtgK+NP1+mdy6ZNlA/5GJlo4H4u6ChubTqdfmXHQqkyfpkjuWVw3+cmQ9b+38o5
         1bW2DRtpDs7KfidLq58/o/5V+QVdz8i19g7oh8J3Nj/RwXC8ubTZilgn416jwN/KAyv4
         KBM30q5eEJ5Ei+p3Uj79JVHMsNdcnaupEtKzPWiMkEteXcGYESdHLuJ2UwuV/MQT6EDg
         FMI4a8rkFfkUrwDbEew4pzGADZh7kUXrw42+4nVDEBH9awXW1SJx/HIDix9PvT9reqsY
         tg1Q==
X-Forwarded-Encrypted: i=1; AHgh+Rol59j1XwTIqGkm6bLGcxvf03HeiN2btdqrzDqWofDJ1BgTHOP5s7/hKonSTLaLvl7AXiGfOffIlHto@vger.kernel.org
X-Gm-Message-State: AOJu0YzUdT3EiauTKuulv3wBv/bm34zzglow7YfvYQyHnMl7Graz+iiX
	zq9I6xQbJVvT3F2W7e7gtVMeCvOlVtlx0p/kIXocOq8xT/ISSxLBzA0sChzs+jXHQaQ=
X-Gm-Gg: AfdE7cn9DsvzvSBdxv4XOLP+E71BW7+ttyK6HmsLFjCehFAb3SN+HTT3Pjuwy0LFdTQ
	t+S3aNDKYeeqUikGTwF14WLUGz/u9I94xvECP19MRSjv4MW3puqPwet3SkngrYe5Dhj6RFod5wL
	wNspd7Do/tiNnfEnztpfnNheXg9cbuX37QLb3ocCIR1B4uyV9ZIJeAiwLHtP+dq5PPxrs0Gu9aV
	esbgDmPrMygbv9cbyJkraTS1FXobYfRApZYOyZVHv595B/nOj4uzJuzRhw4H+eAuyDJFiPD23OQ
	t18OeWLcigFWP8sbaWq7WHkUB8JSe53J3yB24VnaW0GUT+JXTsa7JGgwoBb+XopdIAVbXpEKBx9
	8fxi4ikAFXxcGwaMXXscXBPi9XSJpPyLSGnQhdVpssrOEmuk3SA+xFOnwy/nt
X-Received: by 2002:a05:622a:96:b0:51c:7b12:5ff5 with SMTP id d75a77b69052e-51c8b43fec2mr132124531cf.81.1783701869227;
        Fri, 10 Jul 2026 09:44:29 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4b91sm45168766d6.19.2026.07.10.09.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:44:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEKx-00000007Yxj-3wpY;
	Fri, 10 Jul 2026 13:44:27 -0300
Date: Fri, 10 Jul 2026 13:44:27 -0300
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
Subject: Re: [PATCH v7 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <20260710164427.GW118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345366389.660027.12986386801605494596.stgit@skinsburskii>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345366389.660027.12986386801605494596.stgit@skinsburskii>

On Tue, Jul 07, 2026 at 12:47:43PM -0700, Stanislav Kinsburskii wrote:
> Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault(),
> then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires. Those paths use
> MMU interval notifiers whose mm matches the mm that was locked for the HMM
> fault.
> 
> Use hmm_range_fault_unlocked_timeout() for those faults and pass the
> remaining retry budget to HMM. The helper owns mmap_lock acquisition and
> refreshes range->notifier_seq internally for each retry, while GPU SVM
> keeps its existing driver-lock validation with mmu_interval_read_retry()
> after a successful fault.
> 
> Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> called with the mmap lock already held by its caller.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
>  1 file changed, 7 insertions(+), 45 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> -	mmap_read_unlock(range->gpusvm->mm);
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +				max_t(long, timeout - jiffies, 1));

Same remark about max_t

Jason
