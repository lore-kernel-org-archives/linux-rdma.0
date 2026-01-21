Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB3B441045;
	Wed, 21 Jan 2026 08:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984910; cv=none; b=ur/4jZ9mvr5jtAwXJX4gLOXPeO5dvV1DbnG1xzBGUc8bgnmGnrNWsyS+gCI7QdLSGsK03PbeJAAYTcz5PjCsyGVelDPfhdEx9SYN1/tVihUnWaHfp7+UNWb6eQ4ppgmhIWIu1POZuqlFzm5xWPiZKSlJJrR8tjAlUD+d3FjD19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984910; c=relaxed/simple;
	bh=vX9ez30UqQH8Ea7faskYAe/RcTUI4WeiZy+2L8FsrmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uXjIsOuIyf9AmDrfY9jyKLDuBQdqQwr3BJwlz/Vewj2gHzUBnTAj5iyE5W+7KvizTC+3/xikJ+DxfzubSttPZQVDO06eT2h6j6kQJaaE4OfnnOGnvzV2UCJQ2s2NTGGZP4MK/M17PzI9T60XmHUxDsg3wyoSeTckTgF8kpd03F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/jftV8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/jftV8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7174C116D0;
	Wed, 21 Jan 2026 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768984909;
	bh=vX9ez30UqQH8Ea7faskYAe/RcTUI4WeiZy+2L8FsrmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N/jftV8WqKnsm2maFReUTyS1FKZrVxHQAluTkW3EpHJ4ervet/wKOmSASptNsqcn8
	 YCUzQehY130BGt6cUU9BFs3H9AF/0B02h/cwqe1DJtbIVQn1O0baHcQoVTQ4ECkrKj
	 2eY60EIQdA2ElUlO9F+1P5ikr5b7v9ZGk6mmC2XusS1ZE2PrwNWovFFzfgQo56DnSf
	 RBQuuCWVT7WPdSGkQQLmpBx1Aohcb+mdN3pnRJHuhScYqnsOPK8OkZ0n/Q7YnxOFCo
	 mWv0ZGyr+NyMttlGy80VgLqW+5iigg0WaDm1Zt85kap7Vth+hi3cX+K4uvuAZIXBk1
	 /elzGAkYMChww==
Date: Wed, 21 Jan 2026 10:41:43 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
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
Subject: Re: [PATCH v3 1/7] dma-buf: Rename .move_notify() callback to a
 clearer identifier
Message-ID: <20260121084143.GW13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-1-b7e0b07b8214@nvidia.com>
 <59762c7e-f00b-49c6-bfab-ff647d3fe05d@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59762c7e-f00b-49c6-bfab-ff647d3fe05d@amd.com>

On Wed, Jan 21, 2026 at 09:33:27AM +0100, Christian König wrote:
> On 1/20/26 15:07, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Rename the .move_notify() callback to .invalidate_mappings() to make its
> > purpose explicit and highlight that it is responsible for invalidating
> > existing mappings.
> > 
> > Suggested-by: Christian König <christian.koenig@amd.com>
> > Reviewed-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf.c                   | 6 +++---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 4 ++--
> >  drivers/gpu/drm/virtio/virtgpu_prime.c      | 2 +-
> >  drivers/gpu/drm/xe/tests/xe_dma_buf.c       | 6 +++---
> >  drivers/gpu/drm/xe/xe_dma_buf.c             | 2 +-
> >  drivers/infiniband/core/umem_dmabuf.c       | 4 ++--
> >  drivers/infiniband/hw/mlx5/mr.c             | 2 +-
> >  drivers/iommu/iommufd/pages.c               | 2 +-
> >  include/linux/dma-buf.h                     | 6 +++---
> >  9 files changed, 17 insertions(+), 17 deletions(-)

<...>

> >  	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
> > @@ -1055,7 +1055,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_pin, "DMA_BUF");
> >   *
> >   * This unpins a buffer pinned by dma_buf_pin() and allows the exporter to move
> >   * any mapping of @attach again and inform the importer through
> > - * &dma_buf_attach_ops.move_notify.
> > + * &dma_buf_attach_ops.invalidate_mappings.
> >   */
> >  void dma_buf_unpin(struct dma_buf_attachment *attach)
> >  {
> > @@ -1262,7 +1262,7 @@ void dma_buf_move_notify(struct dma_buf *dmabuf)
> 
> Thinking more about it we can keep the function names as they are in the importers, but renaming renaming this framework function as well would be really nice to have.

Let me prepare an additional patch on top of this series. I'd prefer to
avoid unnecessary resubmissions caused solely by renaming.

Thanks

> 
> Regards,
> Christian.
