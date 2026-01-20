Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92452E9EA1;
	Tue, 20 Jan 2026 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768914651; cv=none; b=FdBErIVV65RSbCvR1hm3jjPbuxqrtJ7SgzKA/bul8DyyCNpSiE3dklpJk2nXRiDbptYdE0FN4seZltr+eyzTS+IJFpkuqkGJEi7TwzNTjYnD70tHMl37LyZUQ1oZPl+O8UEwZlnQQ6e1vtOufIlpskCmWBO2jOnZ3Y1ecxX++n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768914651; c=relaxed/simple;
	bh=FxDNhPLLAfmPmJMIRFTFPDZNe22KPzHCzmgh6qnQqZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apbacqRBfK41W/5b4oapztr1OB3e2/JgrQ/FeLVFg6itdZFXKlIjl58iTd1GgTy8uOn6NUC2wA1zDSwedcl6QUdj41C/Qm8DPtCm3sUiRXhsvEpuGxxwBhfe5i1b0hU458km2MAd5X+6AApYaEVTgPXrg29U8lYbFyhlG44uPTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H66meatB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H66meatB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BAFC16AAE;
	Tue, 20 Jan 2026 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768914651;
	bh=FxDNhPLLAfmPmJMIRFTFPDZNe22KPzHCzmgh6qnQqZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H66meatBSh1LI3Kc+LtMKEFS7m/ZmLrZH8aGGFmAavlTQIAP9kvlFc180LzVGJOgr
	 VoRWA4PU3SRHk8ISpZJdCvufUfOsvhppfpHpEfM58TVVzk9DO1cdoyeGURjHg7KtNd
	 KABkX1mR2+dvVQiNrmFGlqzzMsXnRBAxpFHqa85G/7inSS7ETTqyimUMX3lonMWl6T
	 bm5tEJJ4PHjUrvp4SfDAhg4FbxylObYHHNiJu7ye5doDxIjXpEUakjTHcek5KgasRt
	 eArvXoDxK+mhIA6mo36uedrLvFigSp5RiqJqQg/qPinytKXgMEvV0BndlvT75uBnWe
	 oNtAMHkWz4fAA==
Date: Tue, 20 Jan 2026 15:10:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] iommufd: Require DMABUF revoke semantics
Message-ID: <20260120131046.GS13201@unreal>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>
 <20260119165951.GI961572@ziepe.ca>
 <20260119182300.GO13201@unreal>
 <20260119195444.GL961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119195444.GL961572@ziepe.ca>

On Mon, Jan 19, 2026 at 03:54:44PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 19, 2026 at 08:23:00PM +0200, Leon Romanovsky wrote:
> > On Mon, Jan 19, 2026 at 12:59:51PM -0400, Jason Gunthorpe wrote:
> > > On Sun, Jan 18, 2026 at 02:08:47PM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > IOMMUFD does not support page fault handling, and after a call to
> > > > .invalidate_mappings() all mappings become invalid. Ensure that
> > > > the IOMMUFD DMABUF importer is bound to a revoke‑aware DMABUF exporter
> > > > (for example, VFIO).
> > > > 
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  drivers/iommu/iommufd/pages.c | 9 ++++++++-
> > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> > > > index 76f900fa1687..a5eb2bc4ef48 100644
> > > > --- a/drivers/iommu/iommufd/pages.c
> > > > +++ b/drivers/iommu/iommufd/pages.c
> > > > @@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
> > > >  		mutex_unlock(&pages->mutex);
> > > >  	}
> > > >  
> > > > -	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > > +	rc = dma_buf_pin(attach);
> > > >  	if (rc)
> > > >  		goto err_detach;
> > > >  
> > > > +	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > > +	if (rc)
> > > > +		goto err_unpin;
> > > > +
> > > >  	dma_resv_unlock(dmabuf->resv);
> > > >  
> > > >  	/* On success iopt_release_pages() will detach and put the dmabuf. */
> > > >  	pages->dmabuf.attach = attach;
> > > >  	return 0;
> > > 
> > > Don't we need an explicit unpin after unmapping?
> > 
> > Yes, but this patch is going to be dropped in v3 because of this
> > suggestion.
> > https://lore.kernel.org/all/a397ff1e-615f-4873-98a9-940f9c16f85c@amd.com
> 
> That's not right, that suggestion is about changing VFIO. iommufd must
> still act as a pinning importer!

There is no change in iommufd, as it invokes dma_buf_dynamic_attach()
with a valid &iopt_dmabuf_attach_revoke_ops. The check determining whether
iommufd can perform a revoke is handled there.

Thanks

> 
> Jason
> 
