Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6351E2858;
	Wed, 21 Jan 2026 08:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984373; cv=none; b=MCPreRGvSXn3xnCjxZfEchxuzqfPPJIK7BU3IFUTKKX6YHW/rXfWztObJ4NdimAX4YYWrNI33b/I1m6EimoK19NpmmolEqLQZpW4UMTuJ0USBHzYeQnAzSKP+cAizNHYcwGMsk6Sj42t+P+xHB/+TMu9+KT2uyT09YnCzgv0DcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984373; c=relaxed/simple;
	bh=/zT/QjwvPkSB24GeDesBZudUrJ0yllxGlSmObH/gtTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOEUXAQsNPk2De5a+2Hvy9jfk0IBWSZAiOhMLEm1EkzDWIRN63oiIrvZKa6Ia6LiB6xJ0dt2Ao92c1NE7JLfGmX7q/0C2DpQGoGRwvEp8I5DpFT4uQRmldgb/76nmXmaVomGRF1QGEMgplaAa+jkRi/xtGQdElqaC/iMxWBouDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUHFr7TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUHFr7TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F6C16AAE;
	Wed, 21 Jan 2026 08:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768984372;
	bh=/zT/QjwvPkSB24GeDesBZudUrJ0yllxGlSmObH/gtTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lUHFr7TGAeMAUTrV0mOIsyb1G5GAbPUJMTSRMrIneHR5ny44/ztcAZeCfxtAjn8vK
	 eyVgpdPBG9WzQmI6zBlbzTANLSgeSECemT+UHlbu6DtJxxM0Pf2u6NeIEBPuxrHZWP
	 om7xQF/CZkIrrSO7THkC0CAy07v9tFe7vrckwWj2uhTpWU+6ten5aVcD0aZoENXBfQ
	 QQojJJtaFv5CQAkLFtqZoawL/YWS/LYmOrMjgRM+PquvF5n73IF+VT8HFzY55/b80k
	 i6wzEZbfXg+yzDpwEpFU+4x7qStuCs2V7k1+ghigK5/fEhcku8m16Gx0ingiM2IPE4
	 nRdh5CgWDr1dA==
Date: Wed, 21 Jan 2026 10:32:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Edward Srouji <edwards@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/uverbs: Add DMABUF object type and
 operations
Message-ID: <20260121083246.GV13201@unreal>
References: <20260108-dmabuf-export-v1-0-6d47d46580d3@nvidia.com>
 <20260108-dmabuf-export-v1-1-6d47d46580d3@nvidia.com>
 <20260120181520.GS961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120181520.GS961572@ziepe.ca>

On Tue, Jan 20, 2026 at 02:15:20PM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 08, 2026 at 01:11:14PM +0200, Edward Srouji wrote:
> >  void rdma_user_mmap_entry_remove(struct rdma_user_mmap_entry *entry)
> >  {
> > +	struct ib_uverbs_dmabuf_file *uverbs_dmabuf, *tmp;
> > +
> >  	if (!entry)
> >  		return;
> >  
> > +	mutex_lock(&entry->dmabufs_lock);
> >  	xa_lock(&entry->ucontext->mmap_xa);
> >  	entry->driver_removed = true;
> >  	xa_unlock(&entry->ucontext->mmap_xa);
> > +	list_for_each_entry_safe(uverbs_dmabuf, tmp, &entry->dmabufs, dmabufs_elm) {
> > +		dma_resv_lock(uverbs_dmabuf->dmabuf->resv, NULL);
> > +		list_del(&uverbs_dmabuf->dmabufs_elm);
> > +		uverbs_dmabuf->revoked = true;
> > +		dma_buf_move_notify(uverbs_dmabuf->dmabuf);
> > +		dma_resv_unlock(uverbs_dmabuf->dmabuf->resv);
> 
> This will need the same wait that Christian pointed out for VFIO..

Yes, something like this is missing
https://lore.kernel.org/all/20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com/

<...>

> > +struct ib_uverbs_dmabuf_file {
> > +	struct ib_uobject uobj;
> > +	struct dma_buf *dmabuf;
> > +	struct list_head dmabufs_elm;
> > +	struct rdma_user_mmap_entry *mmap_entry;
> > +	struct dma_buf_phys_vec phys_vec;
> 
> Oh, are we going to have weird merge conflicts with this Leon?

No, Alex created a shared branch with the rename already applied for me.  
I had planned to merge it into the RDMA tree before taking this series, and  
then update dma_buf_phys_vec to phys_vec locally.

> 
> > +static int uverbs_dmabuf_attach(struct dma_buf *dmabuf,
> > +				struct dma_buf_attachment *attachment)
> > +{
> > +	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
> > +
> > +	if (!attachment->peer2peer)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (priv->revoked)
> > +		return -ENODEV;
> 
> This should only be checked in map

I disagree with word "only", the more accurate word is "too". There is
no need to allow new importer attach if this exporter is marked as
revoked.

> 
> This should also eventually call the new revoke testing function Leon
> is adding

We will add it once my series will be accepted.

Thanks

> 
> Jason
