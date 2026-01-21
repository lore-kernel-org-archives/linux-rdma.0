Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8532FA29
	for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 16:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011324; cv=none; b=lsdQUgJMJnyDflf5jAWhFx789XXZjwJLk/WUG/XuxiFnvE0yxGINrf9MnaQ+woLcAiPDdDM9nxBV2MHNblSe7y2xisL4k1kXYfVkis6gxfqnl93YZzifcLMnIiFrBGapNZEj+X1XMYk1PctLJxH2KwaASIw2/vXuYHilppltLLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011324; c=relaxed/simple;
	bh=ALN3BZ1h37bw87fH1I2phtqMuOjkp7pNGMZRlYvqJKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts0g2wMuzqC3+2x3glPSrJqrjAA7aoUIt5+mL5Jl9YUKL4Fu7ggLkDNBc4rKz+vbRMbsl27w8QxHKZ6w47yo45SAtWDoUk3vl4XK5DnVmNHk/VZYSF+nZhXf0jy+3ub3cRfNPd2QVtEVMhYA/i1cHqeJ3GUMB89brCgPuoUbo+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=X16z7tde; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="X16z7tde"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-894724bc5cbso8692036d6.1
        for <linux-rdma@vger.kernel.org>; Wed, 21 Jan 2026 08:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769011321; x=1769616121; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xk50a3DJCYgVIrcCVz4YsPwnwCkWAaxm0jVyWa00IrY=;
        b=X16z7tdesWZLkENeMRiLL/WJp/rLoVbX6D1QijflhBe2/uBAkosgAPRfAv/W7cqdyA
         KWgQbhpfbakzuXL6TirYWlRPb4bf98HlnLsiyycryZ/jHAa8qNDAnw9fNCUjnhWODe8K
         th7OJzwQkEASI74aTvsVXB5mra5Zt+IbjNXlClsxfH0YVrqRDyBbda/JxxaBlRIBLR3V
         uMsd06s0fudVLyCV3K53Kx2gf18pY+syyrW7kIL1YCK3RmYhKOqcVx4HDa1rACuI8l7c
         V9a71IgVHlZSBI6lMe63D2SglDMJ4stYBA/RntH6Bk8NEUsOIWj+3+sHYonBxXQeqsfA
         yN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769011321; x=1769616121;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xk50a3DJCYgVIrcCVz4YsPwnwCkWAaxm0jVyWa00IrY=;
        b=MpTG0w+jFC3plqnx1pCTzxBhDwohH9pFvv0JFVAsiXN6H+L2lSotr3Chc9oV0Ickrd
         SFummy4L+pzqq3rBDpJ8osCjX8dNkO31vcltvTp4AR14sZPopndu/BD0mo0/64jD+k2H
         gA36uHpM6OHcP9RCZor/NUz3cbP6hhpg1WzOpLN9nKjUDPFvjdVykfIYE4UajrFE3yIr
         Y2g5ABwa4kUGtV4tIgofQqWdqVNcNgJyH3HUVGU9X6NiRZyjk/V1e+7PhM7xie2nlcqO
         8kOgvGffLe8iH7K8PidRYEB/rMyXFna5sZgI4gUAr5D/UWKItm5/6elZ0Npbnv2cHHTh
         JQqg==
X-Forwarded-Encrypted: i=1; AJvYcCXtyMxdibxIuIMdgb+fWmPDXUoWZ55yrJoQ27XngKnKxbHiwptYEh8EzNPdfqcfJZ+qeNTqb8ghFiSG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8p77vvkxDqqxcXo86V1WSMXabSJeQ8UUk2X2LkVFKXPDeykIe
	KhJs9gTWsLIBSrt+t1R4J4shjSovYa4li1kLIOEK1tImvjEuyZNc7QpYrbheWoN/z7U=
X-Gm-Gg: AZuq6aLPVCa6RrOGsQqDplYy7Yg+J21ZNPEaK4Ft8zsBlHvtafM479m5Q5n3ifGL0cW
	HRjton9TOJ0xTbbXCs3rK9vElztsHEbxYEJKM/R2aUKQnyAwwtaQMYn2gBj6qn2WMBvitH9I6jK
	OqS7JbP4/LwLuZvFJo9I3Nyse8UL3KzHZ5KBFSDSCgelV96t6oIkGDr2URQAGCl9FGmm4x16jBw
	a2nuJGzOAqhhiofnL6Jb128/U7wCA4G7DMLyaxYPMUz4ZdeiS3xX4VKsM+VER91vUnxbYaKamI/
	k8+zMEc5f9WBKtlVvlbNKpDzBfUosocEA10iSa+wZTuSLgOBhJKh0tMNIZDWckqAnXQTcOMsWAY
	anH+im1TiX3lpW8rPf4wynEAjjQ43t1uiaGx0ahevmeTg1nWRIgXr5GLC6gvQdLDhy46el/Jc5O
	68OtH7gwsk7G4ytw6Z+bBZ9ovcE9WeJnE0Cn7JbNsLsUFW/Pb8wLOuxuEJEiPV/oF+so6j1kgyB
	GRnYg==
X-Received: by 2002:ad4:5c4d:0:b0:88a:3861:9131 with SMTP id 6a1803df08f44-893982737e8mr294508076d6.34.1769011302558;
        Wed, 21 Jan 2026 08:01:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8946e3aee12sm27692726d6.39.2026.01.21.08.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 08:01:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viaeK-00000006Es6-2jLq;
	Wed, 21 Jan 2026 12:01:40 -0400
Date: Wed, 21 Jan 2026 12:01:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v3 6/7] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260121160140.GF961572@ziepe.ca>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <b129f0c1-b61e-4efb-9e25-d8cdadaca1b3@amd.com>
 <20260121133146.GY961572@ziepe.ca>
 <b88b500c-bacc-483d-9d1a-725d4158302a@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b88b500c-bacc-483d-9d1a-725d4158302a@amd.com>

On Wed, Jan 21, 2026 at 04:28:17PM +0100, Christian König wrote:
> On 1/21/26 14:31, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 10:20:51AM +0100, Christian König wrote:
> >> On 1/20/26 15:07, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>
> >>> dma-buf invalidation is performed asynchronously by hardware, so VFIO must
> >>> wait until all affected objects have been fully invalidated.
> >>>
> >>> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> Reviewed-by: Christian König <christian.koenig@amd.com>
> >>
> >> Please also keep in mind that the while this wait for all fences for
> >> correctness you also need to keep the mapping valid until
> >> dma_buf_unmap_attachment() was called.
> > 
> > Can you elaborate on this more?
> > 
> > I think what we want for dma_buf_attach_revocable() is the strong
> > guarentee that the importer stops doing all access to the memory once
> > this sequence is completed and the exporter can rely on it. I don't
> > think this works any other way.
> > 
> > This is already true for dynamic move capable importers, right?
> 
> Not quite, no.

:(

It is kind of shocking to hear these APIs work like this with such a
loose lifetime definition. Leon can you include some of these detail
in the new comments?

> >> In other words you can only redirect the DMA-addresses previously
> >> given out into nirvana (or a dummy memory or similar), but you still
> >> need to avoid re-using them for something else.
> > 
> > Does any driver do this? If you unload/reload a GPU driver it is
> > going to re-use the addresses handed out?
> 
> I never fully read through all the source code, but if I'm not
> completely mistaken that is enforced for all GPU drivers through the
> DMA-buf and DRM layer lifetime handling and I think even in other in
> kernel frameworks like V4L, alsa etc...

> What roughly happens is that each DMA-buf mapping through a couple
> of hoops keeps a reference on the device, so even after a hotplug
> event the device can only fully go away after all housekeeping
> structures are destroyed and buffers freed.

A simple reference on the device means nothing for these kinds of
questions. It does not stop unloading and reloading a driver.

Obviously if the driver is loaded fresh it will reallocate.

To do what you are saying the DRM drivers would have to block during
driver remove until all unmaps happen.

> Background is that a lot of device still make reads even after you
> have invalidated a mapping, but then discard the result.

And they also don't insert fences to conclude that?

> So when you don't have same grace period you end up with PCI AER,
> warnings from IOMMU, random accesses to PCI BARs which just happen
> to be in the old location of something etc...

Yes, definitely. It is very important to have a definitive point in
the API where all accesses stop. While "read but discard" seems
harmless on the surface, there are corner cases where it is not OK.

Am I understanding right that these devices must finish their reads
before doing unmap?

> I would rather like to keep that semantics even for forcefully
> shootdowns since it proved to be rather reliable.

We can investigate making unmap the barrier point if this is the case.

Jason
