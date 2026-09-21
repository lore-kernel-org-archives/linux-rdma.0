Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DEA49B5A8
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996143; cv=none; b=VMQrLdIjJqHlKOZZJ1nkBwz+Pm/sC9u1hxv0jts8FNxB0jlTUhjmSnfAa7Mc/dgq7eKr4sG9Ci1k3TwHIP1m+TEcfhFyPzKLjeAMgRtizrE1XMQAJrV3WcKzK6diA4eIGpFj99GdeL8GD6vUtnApc0ITpEzU8GZgHUoY+fseX/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996143; c=relaxed/simple;
	bh=7iRzAcHHARKyQ+ATaMDpW4DruCrP6jplXNxnuj7OqwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0B+CiiYeI9FhT2T/rzfwZcTYfFsVOQfGUmRdKwmjk4XnX3MEBU0phuymfgbOvSD4dEYTbkfEiLKxODof94OAnqtxjfFW/yBG7zFK2kmDpM1ghH+YPZUxeF5yP187gALUDFo/cwYMBjDHqLsOxU2CBgOXWTCeORtm4ytACvmI58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=OVbP23qH; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OVbP23qH"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-671563fb8beso2635975d50.3
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 06:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789996141; x=1790600941; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/I4CnabOFJ3V+cBV+khghf4ltJkhcHX6gZAKyxfIiuU=;
        b=OVbP23qHxpA1f0E25xNKG0Utb4qY1pci7lNk1dz9kSCfiFs84khz7O89QkedKxGdF/
         0BgGqFlTDcjyoq1EhB62Hs1JbrYZYD8S5vHBJOhauPNXuaX1nb3pv3wtsBQTIyaxKlHH
         W5RPLjfQVDytPLMyAVNbHYDlUMwBER/D7KO1XAs4nvgPFc7AW8QN2S5fU7XQBgbrQklV
         mea3UtzB/mAP5ERVg1OpKwyibQEtCEHIyAnlL9kblIObxvClWKjATxcupqTIfL8HDbgJ
         DArpRHVstouE13CeyOaGnHw7CHAQLXfCxKjIZToSseuODn/RSEXWdw31uTLaznBIBhdH
         ujIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789996141; x=1790600941;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/I4CnabOFJ3V+cBV+khghf4ltJkhcHX6gZAKyxfIiuU=;
        b=zKajij4hRRN2dvZVweJWk7HOneh20Laz8YUPdVVrhtTz7EKtla1IjzKZbH09GQ3gMr
         u2nnypGnv9FAdBcbdWbHHzsl4gr+P0FrE1Qg01XrFc1nkp9QdbKSSZ5Wa923H4hjv9uc
         7pxZbhqBJ5p+yi6x6/kUdxbDDugP+YITtnCb76YKPYDIZdxeBb6xtTs1KJ+AnaU12srD
         73RwCyeOYmHsBEd6zK0DbLkYG629LhXdrmnjR7o39oqrwp+9DZcjnoAMF2TkKJ3DGEya
         x05EyDv4lxNx/5CaBs6B2FHaLwhxlsjUvkVKVnBNbW+zEWffkiVxVdqP5JoWCuDsqzjM
         LHwA==
X-Forwarded-Encrypted: i=1; AKwUvByEOo8wiORESiayxZF3iVgG+rSJb4ZRzCyeT5yy/+jgh6HLcWDxZl2MWV+Owdq0TjKw8gLXsM50OqMH@vger.kernel.org
X-Gm-Message-State: AFuF++nYEene4zf6iqc0Gzvu6sZu6iU1gTVPIdIBjJoWShHl75OvN2CU
	kRkWC5i6mrLD/1mmNCS0XDesuMM4tEcLxPVu3XhfddNvWt4gzT0Q8h2l40Yr61JTYUE=
X-Gm-Gg: AYBFou1wvUMD388GMRqTWK1dIYuUNAMJwnGIJHIvlXhkZ2tos6rVEanm2UZe0u0Pf+7
	3NGWoueVJ9QLQAEhxLDgF5ulOeYz9bEchzbC6OXp6BHDbdcM7LUes4H16KuQgun8fbCsQrfN6fg
	KPEFKGxiD4TlODMPIlX+Q1wwW1Q0LmeYor0emeP0rQ2/7x+DlFSe8gO6zpBaIr+9typ1b/JfRXV
	2RjRDGfyXDom3khB4I7aIITzZbC3UauZcJXh6mO0FIhO4mJEDc3udzdK07bZKAJRTv4ekEvVxSH
	jUcm/ds+S9aKNe7qL67PR3FEIyLHeMTVdyMf6XKn32CSOqwW4vVuyyuZT1hZFFFmBs7oXThEYbN
	0KWjlRJ60+D+S9R+2N3IamdPsAO6jJVxp5R3ohYMkGSAtAdj5IHOsmV8QFM5XjSN5v7iA21EcRq
	ulgUr0MTJLDN3LKrPZxFponh2xKBxDTc6E6sRDeWH9Jtgk7PhUpnCwwwqluMEXlG6tPexTiyR2n
	vhIq/H5HymvT+c2SRne6aHL9g4MVlj7ELOkdOOgAOtf4sYpDVcZp4Tp
X-Received: by 2002:a05:690e:11ca:b0:672:a52c:db25 with SMTP id 956f58d0204a3-672a52ce30bmr1843524d50.109.1789996140490;
        Mon, 21 Sep 2026 06:09:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260aa1db7sm67720106d6.44.2026.09.21.06.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:08:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x8dlS-00000006Jlj-41LR;
	Mon, 21 Sep 2026 10:08:58 -0300
Date: Mon, 21 Sep 2026 10:08:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	iommu@lists.linux.dev, Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
Message-ID: <20260921130858.GO11599@ziepe.ca>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
 <20260918121500.GV13683@unreal>
 <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
 <20260918170524.GH11599@ziepe.ca>
 <9656f2f9-2e39-4007-b065-3b763b53c6de@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9656f2f9-2e39-4007-b065-3b763b53c6de@amd.com>

On Mon, Sep 21, 2026 at 08:43:49AM +0200, Christian König wrote:
> On 9/18/26 19:05, Jason Gunthorpe wrote:
> > On Fri, Sep 18, 2026 at 03:42:28PM +0200, Thomas Hellström wrote:
> >>
> >> 1) Xe attachment check if pci_p2pdma_distance() returns OK for the
> >> path. Then Xe always sets up dma-addresses using dma_map_resource(). 
> > 
> > Open coding pci_p2pdma_distance() in drivers is a hack. Using
> > dma_map_resource() like this was never "allowed".
> > 
> > We've fixed things so these hacks are not needed, the drivers need to
> > move over to things like dma_buf_phys_vec_to_sgt() and the hmm helpers
> > to use the DMA API correctly.
> 
> That is a completely broken approach as well since it limits the
> exported resources to addresses the CPU can reach.

Yes, of course it does. The DMA API only works on phy_addr_t. If you
have a struct p2pdma_provider * then you have a phys_addr_t for it.

If the exporter knows it is working with a MMIO mapping on a PCI
device it gets to acquire a p2pdma_provider and use the helper.

None of this is suposed to solve your "resources the CPU cannot reach"
problem, that has nothing to do with DMA API or P2P. It is not broken
just because it doesn't solve every problem.

> Christoph Hellwig is right that drivers should never use that stuff
> directly, not even through that dma_buf_phys_vec_to_sgt() function.

Hellwig's point was that the subsystem needs a mapping helper that
goes from the subsystem address representation to the HW
representation and hides these details from the drivers.

Look at what he built in nvme around biovec.

The dma_buf_phys_vec_to_sgt() is the dmabuf version of the same idea,
the subystem provides the mapping helper. We can try to do better, but
better is not making the exporters touch the mapping algorithm.

Ultimately I want to see something in lib/ handle this with a
non-scatterlist datastructure, but there is a huge gulf between where
dmabuf is now and it being able to work with a non-scatterlist
datastructure.

Look, it is easy to complain you don't like how it looks, but this
stuff is hard there are lots of competing concerns, if you have a
better idea now is a good time to present it. Maybe if you look
closely you will appreciate how much work has gone into even getting
things this far.

> >> It seems to me that a pci-device settable flag "ATS always enabled"
> >> should be enough to fix both issues?
> > 
> > It should be be per-mapping to support the NIC workflow that isn't a
> > global operation.
> 
> I just realized what you guys are doing and I'm not sure if the
> Linux PCI subsystem should support such hacks at all.

I don't know how to respond to that. It is spec complaint, it is
shipping in enormous volumes, of course Linux needs to support the HW
that exists.

> Basically from the point of view of the TA the NIC has ATS enabled
> all the time, but has a per request option to use translated
> addresses directly without previously translating and caching them
> using ATS, correct?

Yep. Very few devices in the world can use ATS for every single
operation. Many have this split operating model. Some even only use
ATS for DMA flows that are faultable.

Mostly the OS can't tell what the device is doing and doesn't
care. The P2P routing is the main issue and we have hacked around it
in our systems till now. Leon is trying to fix it. Thomas needs it
fixed too for Xe. So what's the issue here?

DMABUF needs to learn how to do interconnect specific behaviors. PCI
is an interconnect, it has lots and lots of crazy rules. An
importer/exporter that chooses to use PCI for their DMA should have a
way to exchange PCI specific information.

So should UALink and all the other zoo of options we have now. It
cannot be completely generic and meet everyones needs.

Can we focus on that instead of arguing if the PCI craziness should
exist or not?

> If yes than that is extremely questionable behavior, I'm not sure if
> that is covered by the PCIe spec.

Spec doesn't say anything about when a device has to translated vs
untranslated. The ATS flags only say translated is allowed to be used.

> ATS is meant to be an optimization which moves the TLB from the root
> complex (TA) into the devices at the cost of TLB invalidation
> complexity. But what you do here is abusing that functionality as
> far as I can see.

ATS is for alot more than that, and there is no abuse here.

Jason
