Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E90424D65
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 22:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423830; cv=none; b=pwc/om1aQ49tZGvVc0ecO9yqo8tAXSEGOgAG7aje4HB1F0mzhV7Z3PRaD6w2vp5TLsfE8nOJPo1GMOHPtuo+uzc9+Q5/P1w2pSd+x07DFFx2Q068KewCQR9yRUS1RuqmVF6HscSHhAsxYegPOlTXpc/IC1xgDMNRwCakqydNZ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423830; c=relaxed/simple;
	bh=gLzjztUBh8eUXFB5ZGRmFKOT+KaN6m6lVeXdcVVl7OY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TPRwnPO/chCb21Qxw6FmrNO2vZl9QXIJcmRZKth1jcHSZGyANVaiRcOpBLl54+iKQ6sIJiYyCjZpPUcfSxeCq4LppggkzBlWYH+aXdmUJ92WOLejuhB4bTlHQIMlyzQ5RP7D7r6awuoX1eBL6sZ67RoHEy/Oec6s6imAXwJWR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=MrNn2ABe; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MrNn2ABe"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-910316a2fc9so54110606d6.2
        for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 15:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789423827; x=1790028627; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J3XZNUGEs58um27ogp+l/DHH3zgdwh/5Gz7nOI7x+eE=;
        b=MrNn2ABeVBBLD/psDiK3m8CL12AHXAedKA09BStuiTLavMSh2zkru9FcuKOt20Zbjd
         MPuKWICMDaDu/HrKe+osLXQuiOHKgIz3nULbZlBumSaVQJhTLkdnV6i9qHniuVqW7zyW
         VUq1B9Bp84J9Rmxq5H3BEM/2OYugq9xo+DVbdYSYrhWZIL6yPubVIh9tyoadKkW6MJcV
         wsph/3jwQHxIFMT19YoinBg6KV86GUOZkG3sd6wCFOt9ngTtwh4QitLZn8CBgXRZnGDj
         Uy/1BXjUOwpbZcfnryQr4uQtx5ZAYZ3K1fuuA9VhOBVPQzJQz323ALZB/IaHz9C4sT0n
         44LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789423827; x=1790028627;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J3XZNUGEs58um27ogp+l/DHH3zgdwh/5Gz7nOI7x+eE=;
        b=xZA2QoSdYwinDbG3LU/DJxHPdrwFtJ6jj2Ior9jN06cIqZJByJCvoDtMYwIIWko7yi
         8OIsjuByZXeDyr/CWlBo6OYPFauWeS+JDolYQtcom5pdJKROtSm4s4qO5ak0zKDTNrZX
         ybPHakNwZpoljeFIrlALCdsK079b+HMhxjpvtuWXZaT8wDLEs8GOpI9LRkOArXiL3TQ8
         rydZsv33sIDbuii7op69NHhi2nzJy+1cLFmea+IH6TCD0ZmnKOUTjj0rWFh0T5wJU95O
         MsJ1iWcc0Eb7nbf3DBo4Hxwk3W08M1OdLLhtefLYMSSbMSfMEx01rlt6RCDh1IkcsmAg
         neqw==
X-Forwarded-Encrypted: i=1; AKwUvBxlSGDKOFcX3Qal1qxspoZdsSNDbipwKjZpPpBLuv0BN3A2izKfD2Yp6SxOsTJheZ4pA8o9z+h5Rect@vger.kernel.org
X-Gm-Message-State: AFuF++k+NmJ0KI6YoPjbyVHLFV/Ha5FI49z31m/Ht7SX6f7WmKB7ToQY
	GI2KJgBlZLfNgZSz9Y5WztTActS+n7mhbhoR71rkyd2q/Yylzvuz0D4zYYiF/NGu+XE=
X-Gm-Gg: AYBFou1Eu3yet7/yLJhX1kTBzAHSmN4VcaCu25n7Ndsuqwfc6CsRVX0J1y84RLPOmJb
	YFPfYQXViqscoe66hJsIsCwm/gIfE5H4ZC1uotjgJA3oAT4WVoC7V1uD8uhUQI6i6dI6g9T6Uvn
	90T6vjg+OeulmpekNCcj4XW7/qoJWOOCQtnmJZ/9nMl5MklXwax/fO9HklOimQkUVW2JGZgex+p
	ibi29T8xkRxZHWJlsiPZDxjyuIqmRO1eLpFofbLQ01Z3DEuFBKbftRBO5Np+Nfdh5t9jxfmevxu
	ND++0HB3+hgMYIGNWF300qxPxrfPKv/B9/VOO3AlDiQUE8nBmMm8gI6rubTP1vDZNVkMsHwZGLg
	UyxhWA6BaNjy/TG3ZOdNvAV6E3Zug0/j+sWM05m961Of19I0smYJqog4tG/UBsTWm6Jy0VzCj18
	nDJGe/IMheMg+BL1G3fAqOrmlRbJWzhUdo8AmxqE8K5qaCKQQ96mzPWSJb12qYGdAjdILIrI7HP
	qtucdTb90ArnKn7J1m5vzqYuwcN0OXB8iMdUqyNqEYmblT1Vu9a00s3RMzAOohAEOA=
X-Received: by 2002:a05:6214:2243:b0:90e:9ac5:bfc6 with SMTP id 6a1803df08f44-9122e52dcdamr78819906d6.24.1789423827222;
        Mon, 14 Sep 2026 15:10:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f45ab7csm105588756d6.15.2026.09.14.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:10:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x6Esb-00000002Idd-3vnk;
	Mon, 14 Sep 2026 19:10:25 -0300
Date: Mon, 14 Sep 2026 19:10:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v6 17/18] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
Message-ID: <20260914221025.GA3196566@ziepe.ca>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
 <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>

On Mon, Sep 14, 2026 at 04:27:00PM +0200, Christian König wrote:

> > +enum pci_p2pdma_map_type
> > +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> > +			unsigned int tlp_flags)
> > +{
> > +	struct dma_buf *dmabuf = attach->dmabuf;
> > +	struct p2pdma_provider *provider;
> > +
> > +	if (!dmabuf->ops->p2pdma_provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> > +	if (!provider)
> > +		return PCI_P2PDMA_MAP_NONE;
> > +
> > +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
> 
> Calling PCI subsystem functions from dma-buf is a hard NO-GO.

This is why I had the mapping type arrangement able to know if a PCI
path was involved so it could activate PCI support for that path. In
an extendable way so other interconnects could also provide their
unique knowledge too.

> I shouldn't have allowed the mapping functions to be added to
> DMA-buf in the first place, all of this belongs either into the DMA
> layer or the exporter.

DMA layer is not the place to form dmabuf's corrupted
scatterlist. This must only be done in dmabuf.

We don't want to open code this common logic in every exporter, it
needs a helper. If you have a better place where to put the thing that
makes the dmabuf unique broken scatterlist, then I'm open :) HCH isn't
going to accept anything like that outside stuff hard wired to dmabuf.

> We should probably have a single callback the exporter provides to
> fill in a structure with PCI specific information for a mapping.

Yeah, that is where I was going.

I'm really sorry I haven't been able to come back to that mapping type
series. Were you feeling positive about that? Maybe Leon or someone
can pick it up from me. I was optimistic about scaling back to just
the maping type negotiation as a first step

Jason
