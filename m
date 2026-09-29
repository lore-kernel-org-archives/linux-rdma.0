Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8AA51589F;
	Tue, 29 Sep 2026 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688192; cv=none; b=iRaQt4WocKPqT4L1QrZBnMV+7tSc7MrBfzKyo2bRO9jMoaaLe/xMM5Pu7i/e5f41PsAMgCSTA0S0wSRZnpQ9mixxMf+SQJSdzPk/nPdkrJ+XU5XDcwxTpERssd48ZIAX/lTuBCmTSgV8DgiZ3NsC7QSVgbN9+LkQajue+x7qNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688192; c=relaxed/simple;
	bh=WhZhvqTid00sGEr6jHmxUxphIyPp2JmfayN14qWNZrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhyJ2rS1VTxzHn6A8NEQxdKDt2riyTU6fUiIMca4G73dy2PUsIhMDyscj4rbk8428tI/eeajLq+Q2CdbHtMi78SlQH53Ic0aCR2fhc3dTW+XQ3H3Sq2YxHj3nsSGdTgqBTAg20bEu8Ou6aXz0NYaCY3bf/1elvcgtU25H0Hb2T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoGTfQTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoGTfQTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61431F000FF;
	Tue, 29 Sep 2026 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688190;
	bh=cBZ5sMUeIN86VkUHCeicPmRVb3a2MPzoImdcUHqRfJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NoGTfQTUx2Xl1sqyKbpdFhdMZdJ+noWXSNmnHsfFGXavFZTVe1Cx5urvzLzwqn5nr
	 7mLn4mK8T8/R1zhpXkZdIIbFBOIvoM8jHFvRE6ejsR/Ks3EXaYbGQOU64qUGrhnvtx
	 vuhP22+ENXCWO9Aypfd3LyPbBzA+dGwphUQM/mo//I9W/U08USHbFfdsBJMauHQL7y
	 F0E9osDHf6p6oK2fJ5PQElXUNS3f14H9qI328tei2n9Zj0yX3cnBTCuyWdcGfNSa5J
	 uPFxCo2svfx4VA//t7fsv62syC3K5WdxJo4K67tFjVV3VdcaBMn1xyyTcOcsGpQ+KK
	 qk29TkAqSezVg==
Date: Tue, 29 Sep 2026 16:23:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20260929132305.GJ563127@unreal>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
 <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <607e8903-a979-4d78-bf08-447321c03119@amd.com>

On Tue, Sep 29, 2026 at 11:34:05AM +0200, Christian König wrote:
> On 9/28/26 13:19, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Exporters keep the &struct p2pdma_provider backing a buffer in their own
> > private data. An importer cannot reach it, so it has no way to learn how
> > its own peer-to-peer traffic would be routed before it programs its
> > hardware.
> > 
> > Add an optional @p2pdma_provider callback for an exporter to hand that
> > provider out, and dma_buf_p2pdma_map_type() for an importer to ask by TLP
> > class. Exporters keep the provider where it already lives, so this adds an
> > operation rather than changing any existing signature or structure.
> > 
> > Tested-by: Tushar Dave <tdave@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf-mapping.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/dma-buf-mapping.h   |  3 +++
> >  include/linux/dma-buf.h           | 19 +++++++++++++++++++
> >  3 files changed, 61 insertions(+)

<...>

> > +enum pci_p2pdma_map_type
> > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > +			unsigned int tlp_flags)
> > +{
> > +	struct dma_buf *dmabuf = attach->dmabuf;
> > +	struct p2pdma_provider *provider;
> > +
> > +	dma_resv_assert_held(dmabuf->resv);
> > +
> > +	if (!dmabuf->ops->p2pdma_provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> > +	if (!provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> 
> 
> > +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
> 
> This function call here *must* be in the exporter and not the DMA-buf framework.
> 
> So clear NAK to putting that here.

"Look, it is easy to complain you don't like how it looks, but this
stuff is hard there are lots of competing concerns, if you have a
better idea now is a good time to present it."
https://lore.kernel.org/all/20260921130858.GO11599@ziepe.ca/#t

Do you have a viable solution?

Thanks

> 
> Regards,
> Christian.
