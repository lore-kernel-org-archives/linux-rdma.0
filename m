Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FFA4A4826
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 20:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023733; cv=none; b=ao/ENJmmkSKstct+1QPXEOqDxVpmtII8q3hKYivpYRYFdss1rMmxcMHYwLIdLY5HqCWCIPHlehIfxbEb8HQlIMXBjK7p42WPsT+010EaUB/JnmCJqewQNwiv3hQeikRbj/D/nt9UGMM/WeqmwOskE070nS8Fz9N92sE9Jje6Ui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023733; c=relaxed/simple;
	bh=duuqjqeee1gxRjF5xn4L1VFmmMHLBdcH21nRueFfC6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RllU7K5Gh0HNuMA8qU4bmpPgxccS/fUnCiNlZCDNqKcMZXoVz93I9vz9GS8bk6qJBVaJyeM/cYQGAmWn84Ds078DRLD713D3gl0o31y++0XbrdBvCsu+W8lVkWpji2USVnwjAqadtbspNhzWAafUt2vYmdH+pCXIqy/2V/1iooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LLimrgB4; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLimrgB4"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469f204f6so2380826b3a.2
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 13:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790023730; x=1790628530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9RpdHbEhaZD0mMR4lSv7YIPkc3oHh9/Jw4xKi9A6gsk=;
        b=LLimrgB4OLYrO3yRYyMqbBIfEJcC6vydiVWdt+bN2J00jyw9zmdOhng8dXbnB9YBvL
         KLRo2H/BVeQSZbd5ZKg8NcmFoJGobbU64MSteGWQiMNiucQ/+aFxHhloPlG2589TnOPy
         xuZfAN+uCklXZ7HUwWA2TXCpA7Oc7LjDbTtu8ulilmB+e4rElR0rTkk2836k3CaMYa7N
         cOVUTYqWKJUSB5ma4aDuEohibGmNWNbV0q08YcNfuJ7lpwRgi8WRmXr9ILPCToe6empR
         EDklh5DY4gOVUfGHDEUatpD9Vqp14MRrsJUmBD0Cq5slXZ5Zl60enx8tTaNinsc1dSNz
         W/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790023730; x=1790628530;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9RpdHbEhaZD0mMR4lSv7YIPkc3oHh9/Jw4xKi9A6gsk=;
        b=JVj0KXAlnoQ2sQhBCPUqDg/8KwUg8NdDDS6K/CxShm6Lea6Ua61QJ6tU3I87WDYwma
         2zhpv83itlGFlSE+L2UuWA32EPKLgYRUajIUr4Wn7P47zkS+e0iAojwTWTlhNGfoiunB
         kstPoOorI7JLTyy2KTiu9k6oCOoNLVRNoSnWW89LpNFBrglU/6NVC2dKZ2s+WovCjI5i
         39LfnRyfp0hjDPCEfk3ZdEzfCEhIgrNxoPdxsG64K56PZzxm1mGRMHsbmIJhT6BIRU3Q
         vC65+4uQHu1a6ySiLSD0s6ti5fK4JVFRMa22DnVD5ghPnn+OePGyqITR3TWrt7QC6/Lj
         pBOw==
X-Forwarded-Encrypted: i=1; AKwUvByEryH3qNPW7ttnf4QBM2C7w5EUEt6PshqpjLoEBUrLtY7+cLYT1z1SLbdXnoFMSPLeXesmSP8JBjnc@vger.kernel.org
X-Gm-Message-State: AFuF++nKv9lBm6f4T68WwIfe4b7btQdhXYf0mu87vbL7C8PxyNVS3kyy
	R5DKnnUcxygJ5IfleYb1PxaK17zaWhEqFKgeJ+KCXgcakX9fOaWiUqeIEt2Q5cKAEQ==
X-Gm-Gg: AYBFou0efd1QwXM1AckMAcJavrkLqocAxQ8nT4V4/oXrswS9uPH3k6iCXKR5LqlVZE3
	HzGMOxc75bymlpk1gzKng1Rf/vn+owJkXG9oVJDovA8ca0xvYaffOyoPCp0VOJVVYSChV0qZp7T
	IeoMQdzjG5aj1zKJtVRQ594RQ7MU7Msd/covYdwJZdlgSwLGsBWcb1lRAkrbkvF3AT+FTPmX5n/
	+6Tz1ExOc+oVphYAVAVUA7T8gFbmBlcGaZyz38cptATK0Tcc84zhjzjmAafZu4BpdbJ5unewteX
	UoJ1CHuZPoKUcSV5EUm/VgPGaK/DfStRuTo6g1SJ3sdb6JTksK9Z7UNiHtagbmLezcRsly+bGAT
	u+kSIKihfHHemV4r40gTPNRcIxSHmtE6OaH9xQ3KGsdIWwiGjm8bFz7FMY8sypDDnixTB6NJE2x
	4AdMjLNyhOIgqk+B7GnxjeFcKcZ4T0G7grB9636fGdE9Jq3QuP+3djP6m7+tS3Vp6zhtt79/RgF
	UvCuDHJCJin3ksyrSVwM8R+wNkcLkAc1/deRc0a9t2/YZPQ1Lw=
X-Received: by 2002:a05:6a00:6c97:b0:878:34b8:2320 with SMTP id d2e1a72fcca58-87834b82455mr8559084b3a.40.1790023729351;
        Mon, 21 Sep 2026 13:48:49 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87bf84b6859sm44247b3a.52.2026.09.21.13.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:48:48 -0700 (PDT)
Date: Mon, 21 Sep 2026 20:48:45 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 06/10] vfio: selftests: Allow drivers to specify
 required region size
Message-ID: <arGYLavnr25ZSyuw@google.com>
References: <6-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
 <20260917235245.CAAE41F00898@smtp.kernel.org>
 <20260918115217.GA11142@nvidia.com>
 <CALzav=f4NTb4Csn2BoK5kk=MckFRvbVnOdO9yiCz8MLXdRMPOg@mail.gmail.com>
 <20260918200000.GB11142@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200000.GB11142@nvidia.com>

On 2026-09-18 05:00 PM, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 07:58:58AM -0700, David Matlack wrote:
> > > >
> > > > [Severity: Medium]
> > > > Since this changes the vfio test to use the dynamic driver->region.size
> > > > instead of SZ_2M, should tools/testing/selftests/kvm/irq_test.c be updated
> > > > as well?
> > > >
> > > > It looks like vfio_setup_msi() in kvm/irq_test.c still forcefully overwrites
> > > > the dynamically probed size back to 2MB:
> > > >
> > > > tools/testing/selftests/kvm/irq_test.c:vfio_setup_msi() {
> > > >       ...
> > > >       region = &device->driver.region;
> > > >       region->size = SZ_2M;
> > > >       region->iova = iova_allocator_alloc(allocator, region->size);
> > > >       ...
> > > > }
> > > >
> > > > Will this cause the KVM irq_test to fail with a VFIO_ASSERT_GE during driver
> > > > initialization via vfio_pci_driver_init() when tested with a driver that
> > > > requires a larger region, such as the mlx5 driver mentioned in the commit
> > > > message?
> > >
> > > I have no idea, Dave? Did kvm start using this stuff?
> > 
> > Yes, KVM started linking in the VFIO selftests library in 7.3 and
> > irq_test.c is the first test using it.
> 
> Okay, so I think this is all that is needed:
> 
> @@ -101,7 +100,6 @@ static int vfio_setup_msi(struct vfio_pci_device *device)
>         allocator = iova_allocator_init(device->iommu);
>  
>         region = &device->driver.region;
> -       region->size = SZ_2M;
>         region->iova = iova_allocator_alloc(allocator, region->size);
>         region->vaddr = kvm_mmap(region->size, prot, flags, -1);
>         TEST_ASSERT(region->vaddr != MAP_FAILED, "mmap() failed\n");
> 
> > Looks like that is also causing the dma_rmb/wmb() redefinition
> > compiler warning from the kernel-test-robot.
> 
> Yeah, for some reason kvm defined them in its private headers instead
> of putting them in the right place :(
> 
> I think I can just delete the kvm definitions.
> 
> I don't have an arm system or userspace cross compiler to test it with
> though..

Wait, really? I can help with building and running the KVM/arm64
selftests if that's what you need.

> Are we good on everything else, can Alex pick it up after I fix this?

Yes all good from my pov after we address this feedback. I am no longer
seeing failures[1] when using the IGB driver with this series applied.

[1] https://lore.kernel.org/all/anzvkibgzTae9eV9@google.com/
