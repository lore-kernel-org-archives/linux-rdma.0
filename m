Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A4328627;
	Wed, 21 Jan 2026 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768992298; cv=none; b=D0roNdeeTndorU8uyZBE5KCCo/oOfkvPvCcj1EL0KdXPRUT8Sd/a6YzHEGhq3CqmALIpsQ4n3J5qG/tGgKk4IMpoojm8n2aR5OyRukxnQktpB4vh0D7B3CTJD/lJe4rWKB0vtW9xGR0K/QJRPWceOWBdua7tRE30hHOgYZo3HAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768992298; c=relaxed/simple;
	bh=RigXg4DjlKaa6QSDWIT9y5XHQBoImXr5kkVisbqD/oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlYPAmTxqnXRCrNZDbCl5UN1tOCZ8Balzi6CfKS7y4VI2Y8cXhvutw1jr8bBRJczn6lp1BpNfJPZPeSJSAluhLrJ8UgHw0lwWp64ug0Mtbt6eHf+9zBJARnjz1SxLH9X3hZe+P50fMx4vuByyieL8h/sjEIErSKTh40iqKMiDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahf9kV1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahf9kV1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48E4C19422;
	Wed, 21 Jan 2026 10:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768992297;
	bh=RigXg4DjlKaa6QSDWIT9y5XHQBoImXr5kkVisbqD/oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ahf9kV1wXXoMLiaqKsEIG/UGwy2yJvAEXz5UxYeAn6pkL831lX1ZtGjzdM4txxSl1
	 +pazqTL82uZnQR/lq02Yn0CUkkNx6m62sJz3qFQSjt3RIKYoYgKzUpz5lHm96KWki2
	 lmsN5dz7M653itHr9/W+0ss34jWO2MVE8dhc3c/FeCtc5OBbvW5B+k0z0x7Smb10PS
	 VwfwFR44T9j4X0/96SNufS4CdrK0pHdr3x0K0nzSLYdvqVKJsFLhcJuJ55fqOJHgg5
	 qtCGWFawYOKxqtFbbgwBon7CZ1Vxj1ZFn3irlF7uz7KqZV/1nipJWzsYg1FuwX9EH3
	 B0W/jyyKakLIQ==
Date: Wed, 21 Jan 2026 12:44:51 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Matthew Brost <matthew.brost@intel.com>,
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
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20260121104451.GB13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <aW/pQmOO8komCgOK@lstrano-desk.jf.intel.com>
 <015b25e6-cfe1-4110-963f-5f8dc4720d1b@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <015b25e6-cfe1-4110-963f-5f8dc4720d1b@amd.com>

On Wed, Jan 21, 2026 at 11:41:48AM +0100, Christian König wrote:
> On 1/20/26 21:44, Matthew Brost wrote:
> > On Tue, Jan 20, 2026 at 04:07:06PM +0200, Leon Romanovsky wrote:
> >> From: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> dma-buf invalidation is performed asynchronously by hardware, so VFIO must
> >> wait until all affected objects have been fully invalidated.
> >>
> >> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> >> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >> ---
> >>  drivers/vfio/pci/vfio_pci_dmabuf.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> >> index d4d0f7d08c53..33bc6a1909dd 100644
> >> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> >> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> >> @@ -321,6 +321,9 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> >>  			dma_resv_lock(priv->dmabuf->resv, NULL);
> >>  			priv->revoked = revoked;
> >>  			dma_buf_move_notify(priv->dmabuf);
> >> +			dma_resv_wait_timeout(priv->dmabuf->resv,
> >> +					      DMA_RESV_USAGE_KERNEL, false,
> >> +					      MAX_SCHEDULE_TIMEOUT);
> > 
> > Should we explicitly call out in the dma_buf_move_notify() /
> > invalidate_mappings kernel-doc that KERNEL slots are the mechanism
> > for communicating asynchronous dma_buf_move_notify /
> > invalidate_mappings events via fences?
> 
> Oh, I missed that! And no that is not correct.
> 
> This should be DMA_RESV_USAGE_BOOKKEEP so that we wait for everything.

Will change.

> 
> Regards,
> Christian.
> 
> > 
> > Yes, this is probably implied, but it wouldn’t hurt to state this
> > explicitly as part of the cross-driver contract.
> > 
> > Here is what we have now:
> > 
> >  	 * - Dynamic importers should set fences for any access that they can't
> > 	 *   disable immediately from their &dma_buf_attach_ops.invalidate_mappings
> >  	 *   callback.
> > 
> > Matt
> > 
> >>  			dma_resv_unlock(priv->dmabuf->resv);
> >>  		}
> >>  		fput(priv->dmabuf->file);
> >> @@ -342,6 +345,8 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> >>  		priv->vdev = NULL;
> >>  		priv->revoked = true;
> >>  		dma_buf_move_notify(priv->dmabuf);
> >> +		dma_resv_wait_timeout(priv->dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> >> +				      false, MAX_SCHEDULE_TIMEOUT);
> >>  		dma_resv_unlock(priv->dmabuf->resv);
> >>  		vfio_device_put_registration(&vdev->vdev);
> >>  		fput(priv->dmabuf->file);
> >>
> >> -- 
> >> 2.52.0
> >>
> 
> 
