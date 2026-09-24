Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A00E424646
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267894; cv=none; b=HRDd95gG/rGIE4NKG9okoZqmeqqCLER54YjhpMyGY3BiOWYUZ8abok8nRJKKA3nI7+9JtEV8/t5B2Xz0q6D/JPZrjwK/Nr3dHQd1QxE/wAb/fMlQeInzSyTZQCW41A+oAXuaVFFkgBOxaTZuAcNP9vNMAGAtsx/bidrlPJ8EtFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267894; c=relaxed/simple;
	bh=Y6dfgoDu9ENyHz35342iESy0PYqePxl/sIn9jSurkUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k82jQ0OmtjemQNj0cHBnyrwKaxGxKBGWp0JpZeIsFZ1FVX8Wu3UmsQAolOY334Aal6YNfkHV1O6NGMONctFh8blThgaXE3w6QT/64vPALPCU5Z3Y1cw9iGF1M4OX9kcA3QxH1JSoQd5LqOdsN7yXU7kdh7R89KbVQdQqMozsOJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DELaQ6H+; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DELaQ6H+"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76543e1so245171cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 09:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790267891; x=1790872691; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=DELaQ6H+GoqYKhSPbbw83I2UghjOPLUKt/HJzwYXOl5vd4By1b/ewKsZIbd9ahXhZb
         TJDLBT2drAnq8j1D4gtZjKdZE54vfhHIW07z7SMjyhNrpJZ88lIXL27llafwJKgt7Hvw
         zeqWn52o1fsiwmzoo4rrDQZv3h3IiFJnFO2iuBnkUsGA3ktjvtFHA3Jr6K2ZEcGMg8M1
         1di2ZTIAJ2yTB2V6zmlctv6zG6tcG5IvMF9RkWmI06r7tX+skZxDuVThBB0MSr3NZe3S
         B2+XxiOTA95Xk/3/+mlBZ2rpvQSIcAx9lD43yFxhcrOBvTesr5mE416XkZK5Fw1vsdLx
         5Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267891; x=1790872691;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=Y4svAosqVTWtL2r2YkTQVyTsMpc4NZIHsK5FCXqRRNYdT8oc1Bxn0ZiyZ7ni8fc0sp
         ab4h/TzguPy8TKuaSoue7wZBagXfElmINPsKz5EjMcfibAikB1zNBS6rrBZkQVdoeV4J
         9P/ATipvjZqe8cOGRjKDtTD7ru6LUEgUAp+AfMBKqJZDnqVMHTQLT+bo8q9b6JGajZqh
         jZ9Ra+sudpShsdKV0LrDXnAbIzB4T6xU9mpGdsa/bAzWzFRE9dC/uMOyOz+NoamjUSo6
         4kPEVpkRvKbrQAot6aBafusQ7TjPQXYs6NofaQhlecdEMKDJtCMsEdLGmOrQV9yQKrIe
         ghOA==
X-Forwarded-Encrypted: i=1; AKwUvBxoHqxowd15xVKQtf2ikWt33wrWebSdt2Oa8Kyz5cRibi4GZSHi/lD7RDq4mvA1Oh2FXwaNHfbkQNCL@vger.kernel.org
X-Gm-Message-State: AFuF++lBUb2lN24NxpOD9JQa4PJuRFQY9s27k1Ntz46nTRo97v+m/AGh
	8BihWGGdAVcy67JM4aEAlkFeKbExZjfSudokr7GNYy48Lkwt4n3mUzqpaQ9EsgmbgtQ=
X-Gm-Gg: AYBFou3qDCBKgwb0ILVGfOdYxwD7wrxPRAwckWEqItU2qryEocQN7FIh4tuenIkhg7w
	KTEA79jRWrfEdn9+mpr1azCXJB5ayR7tMI8QwrVqhy4jCgR89cHtQPH0UHwzGY+5Eek6UZPJXnt
	ScaQxbmJNFAV8mcrAAsONmiqGNHUx+e/0kR729nBhBBQ0420eW+5L1g2YarABoR3GKsV9DQA39V
	eSClccL1k3DpUiOgdf+6ywTLWHnJAa+UDbBQpk50FGHFcxhOkI7irgYBXgPbA0J3q7d5brAfatp
	o7Up1rgpIRtrUH0z8gqa0t5vGjgMWBf6BA5D9U8xejyD0Eqovu8R6YG+qGU9G4xNwglMNf5WmS2
	724FY8chMMl2mgfuvsb07KIJSeFwgL+Wva46lENHTAUxDtVjxwi/yvLge/dqW3B7av46DGz30U7
	GDSi5Aug+To0flLFYZD1qP6hGa3NEIlvh1FkTOvcNrCYMZs2zs/V2O0NmVEn+9PyaDeaQHPuc1V
	MYYxXAdPgCWgMKt+TVOtzx+zGEZIecDyd0z1E5Jyi9MD1NnyXp9Fuo=
X-Received: by 2002:ac8:5743:0:b0:530:d860:ffba with SMTP id d75a77b69052e-532fe9f05bamr29797891cf.6.1790267890993;
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb32f6aasm45064551cf.16.2026.09.24.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:38:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
Message-ID: <arVRqJZkql6sGunt@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:12PM +0100, Lorenzo Stoakes (ARM) wrote:
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
> 
> This abstracts the check and expresses it in terms of the desired behaviour
> rather than an arbitrary and confusing VMA flag.
> 
> This also lays the groundwork for making further improvements in VMA flag
> usage.
> 
> Also update the userland VMA tests to reflect the change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

