Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602FC4BD780;
	Wed, 30 Sep 2026 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790770437; cv=none; b=Ws0lcK8GZFyKthLArHc92pGTBV/AdnjeSoiEZRx1y/DBBJ9tta8RPV+auZe0L/ZnlPV+pOoaa/27PPRJXQ1VO+Nc0hYHueFvDMcJSuBBm2zF3CLUXs6l2T9aUtoCkh5vwVYTj6wZaV9goekGjzd39QGQGOdUP0c1JeyFJn0CMj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790770437; c=relaxed/simple;
	bh=9zqk1yjGZQmKRl+UKGVN4e5kEOdj6OMfEzrnv6x2WFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mh1966qwiDgHcdpdg4QMMUIxEYeea6MEihdLcavxQmSOEI4HW+qUjlrYflg0UkNH+HcSBn19wzaLJWUbuxlKQqn2g6RErehoPrZZ/Huosyzrf03a6qeN22B7nhv97KWdBVmsksuVJ6pFExmoNNUimyZxXVpe7W0YUMx52N2U9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzaBatxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzaBatxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483E81F000FF;
	Wed, 30 Sep 2026 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790770432;
	bh=k6PKVkFFdQkVOzBjY1QQQ7xkTUrcrzdRqFqZ7LnlOYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CzaBatxTnlcDDUj47mqRx04KHNsI5KYUKycPAWgY2lsjGykiTNrDUpWNQpKykJT1P
	 St1D0g6tWWT/RdpHRf8J6Cwo2jKXUHvdopUINvfFoBAkf/pAuOYeQtsujRzLt2wqBq
	 VA5YTdK9TX/64HU0gefk46zHkjcSAMhyDevS6rAMZ4USu1UMhmH9hTKD0gowoLP5h/
	 AejYfAmjlQ5HokTagSwYo4RQTrSsRYeu6gKzBywSIzr38epOZz/KZ5HB1/vtPOIZAD
	 P2IU3LkydOfpHdNzqZVociHrisqXu2Dre6PDH7st0mXjQNPrz5srdqkeBzYabLs/b+
	 i9p0CC2ZMg7Tw==
Date: Wed, 30 Sep 2026 15:13:49 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, fengchengwen <fengchengwen@huawei.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
Message-ID: <20260930121349.GD3401365@unreal>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <20260731211601.3033906-6-zhipingz@meta.com>
 <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
 <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>
 <20260924233058.GA163130@ziepe.ca>
 <CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com>
 <20260928172939.GK163130@ziepe.ca>
 <CAH3zFs1mCujYjB=5ywo+huAjPJZQoe9u7NM4evNRYr5_ZQbcXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH3zFs1mCujYjB=5ywo+huAjPJZQoe9u7NM4evNRYr5_ZQbcXQ@mail.gmail.com>

On Mon, Sep 28, 2026 at 02:47:46PM -0700, Zhiping Zhang wrote:
> On Mon, Sep 28, 2026 at 10:30 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > >
> > On Thu, Sep 24, 2026 at 11:17:57PM -0700, Zhiping Zhang wrote:
> > > On Thu, Sep 24, 2026 at 4:31 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >
> > > > >
> > > > On Wed, Sep 23, 2026 at 11:24:56PM -0700, Zhiping Zhang wrote:
> > > > > I don't think this belongs in the importer. Every in-tree dma-buf
> > > > > caller of pci_p2pdma_distance() is the exporter, in its .attach,
> > > > > clearing attach->peer2peer -- amdgpu_dma_buf.c, xe_dma_buf.c,
> > > > > habanalabs memory.c. There is no importer-side caller.
> > > >
> > > > Right, and they shouldn't be doing that, but it still has to be
> > > > checked that the st is going directly to the peer device not the host
> > > > bridge. Not using the distance, but by the PCI_P2PDMA_MAP_BUS_ADDR
> > > > indication.
> > > >
> > > > I fear you will need some of Leon's series to make that happen.
> > > >
> > > > So probably the proposed change to dmabuf ops is far too simple.
> > > >
> > > > Jason
> > >
> > > Hi Jason,
> > >
> > > Thanks for the comments.
> > >
> > > Agreed -- the tag should not be handed out unless the routing is
> > > PCI_P2PDMA_MAP_BUS_ADDR. That can be enforced conservatively on 7.3
> > > with two changes. I can fold both into patch 4.
> > > ```
> > > In drivers/pci/p2pdma.c, make pci_p2pdma_map_type() callable from
> > > tristate VFIO_PCI_CORE:
> > >
> > >     EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);
> >
> > No, that's been rejected several times already.
> >
> > > and in drivers/vfio/pci/vfio_pci_dmabuf.c,
> > > vfio_pci_dma_buf_get_pci_tph() gains:
> > >
> > >     struct dma_buf_attachment *attach;
> > >
> > >     if (list_empty(&dmabuf->attachments))
> > >         return -EOPNOTSUPP;
> > >
> > >     list_for_each_entry(attach, &dmabuf->attachments, node)
> > >         if (pci_p2pdma_map_type(priv->provider, attach->dev) !=
> > >             PCI_P2PDMA_MAP_BUS_ADDR)
> > >                 return -EOPNOTSUPP;
> > > ```
> >
> > Also no, this has to be done via PCI_P2PDMA_MAP_BUS_ADDR which also
> > enforces putting the determination in the right place in the code
> > flow..
> >
> > > Two properties are worth stating explicitly:
> >
> > Ah! AI!
> >
> > Jason
> 
> Thanks Jason, I see what you meant by Leon's series now:
>   https://lore.kernel.org/all/20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com/
> 
> Looking at v8, it seems patches 1-4 can stay functionally unchanged,
> while patch 5 uses dma_buf_p2pdma_map_type() on its own attachment for
> both the initial TPH query and revalidation. Is that what you expect?
> 
> If so, would you prefer that I wait for Leon's series and rebase the
> whole stack on it, or split the series so patches 1-4 can land first
> and patch 5 follows after Leon's series?

I would like you to join me there and explain to Christian why the
importer needs access to the exporter's internals.

You are already second user for the same functionally.

Thanks

> 
> Thanks,
> Zhiping
