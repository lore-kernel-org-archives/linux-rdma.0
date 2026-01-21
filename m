Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EE356A23;
	Wed, 21 Jan 2026 19:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769024717; cv=none; b=MDSPUJBOFAgUrFsh0V93bmye9tIebvnq5qJRkafrXO9Bpa9lbKslkIZCvmGKhzTKk+Pv58hGyie01r3UleUp15MbR/WJ/QYkBGlghE+FZ5pCpae9fOI6AWTuXJsf82Ug9AA5OdQlSTtbt24GXMOvnXGKHPOSMzgYKR6uQWzGnRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769024717; c=relaxed/simple;
	bh=HVyQFgBfMrcX6zrVZsiDIfHM3nU3cIMX1ciddzliDxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHBtIELMf3wG/lgOzvR7YEFJFC/n2DcUj8JOWE6pjYdB6EhEU2FCEkKRhXI8UV3uMC4sWqK/fxmwECI8rngG6ak7F6BDaAERROEaQjX4LLp5GChXKEnjyTY8cDVZFThwSSJYscD59m/MYMafVmfqcQ7xWcb4lLxYTuEnyX46pH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfF373wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfF373wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC137C4CEF1;
	Wed, 21 Jan 2026 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769024716;
	bh=HVyQFgBfMrcX6zrVZsiDIfHM3nU3cIMX1ciddzliDxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XfF373wvasaVYywYyQxHoClwiMWz8KrFsYUXRcwzTWFXH8jFxRN6XiMEK/sTFr3Mn
	 0RFROVxbShCa80gix4sGne/fdv97W8+yFsXmVIxx/HhTzIfo6pd+EqqAFJxax21d14
	 hsRYEjzVVYESAgzWRY+cmOE810Uu7FX/j75AaUmsYFnNYoBxublO4Ix0LrY/exf8xB
	 Uh1bbuO/eo8XNc2/Tz/6CsZaAuTQbajnDXxsZzzFO4Zl4/U/owt1IqABFjQKJqg03K
	 4z1fXd7fxdfSHEXD0kFJnkGug7nA67PwGWh1Ql0FmCsiVgChnPf47gVSCBSqWlyJMQ
	 oyDq0tZSmVGSA==
Date: Wed, 21 Jan 2026 21:45:06 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Message-ID: <20260121194506.GI13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <b129f0c1-b61e-4efb-9e25-d8cdadaca1b3@amd.com>
 <20260121133146.GY961572@ziepe.ca>
 <b88b500c-bacc-483d-9d1a-725d4158302a@amd.com>
 <20260121160140.GF961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260121160140.GF961572@ziepe.ca>

On Wed, Jan 21, 2026 at 12:01:40PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 04:28:17PM +0100, Christian König wrote:
> > On 1/21/26 14:31, Jason Gunthorpe wrote:
> > > On Wed, Jan 21, 2026 at 10:20:51AM +0100, Christian König wrote:
> > >> On 1/20/26 15:07, Leon Romanovsky wrote:
> > >>> From: Leon Romanovsky <leonro@nvidia.com>
> > >>>
> > >>> dma-buf invalidation is performed asynchronously by hardware, so VFIO must
> > >>> wait until all affected objects have been fully invalidated.
> > >>>
> > >>> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> > >>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > >>
> > >> Reviewed-by: Christian König <christian.koenig@amd.com>
> > >>
> > >> Please also keep in mind that the while this wait for all fences for
> > >> correctness you also need to keep the mapping valid until
> > >> dma_buf_unmap_attachment() was called.
> > > 
> > > Can you elaborate on this more?
> > > 
> > > I think what we want for dma_buf_attach_revocable() is the strong
> > > guarentee that the importer stops doing all access to the memory once
> > > this sequence is completed and the exporter can rely on it. I don't
> > > think this works any other way.
> > > 
> > > This is already true for dynamic move capable importers, right?
> > 
> > Not quite, no.
> 
> :(
> 
> It is kind of shocking to hear these APIs work like this with such a
> loose lifetime definition. Leon can you include some of these detail
> in the new comments?

If we can clarify what needs to be addressed for v5, I will proceed.  
At the moment, it's still unclear what is missing in v4.

Thanks
