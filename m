Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792437527;
	b=qPY/y/Zpu4nvvNWC+7TD55OSYBJrN0KbTVYuMnqhI6Wy/B7RqnhG5gFHedLzR/uG3r4+
	 mLPCkODX0uuDFEjfH2NPaUyExTGEI9demq5ZlSGEhLTxTlhC/1M+L6GOzCdcRWvavk5X2
	 wijxw7dZymxutPL7lLlQzlW2M7u9Cfhv3vsG5ycxdc/shDip+Yw3rf0yFHD/AznRjInkQ
	 D0WJeuY5FjZR5MlWV7IYCR1Yjttk5JynvFGtV8IIoOm2QIXbkgQr9lRzwm/hoAwJEs1QX
	 y4J9x7Ad5uvtlX8eKy+wbm6q0AMMH4CHn99qBJwqJQ7FkrkcpZCiOjNjXebe/Lu3+dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437527;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=77mlLPeWieg1gPE9ZVsd30acJWkC/9GBsg5MHF+AKxs=;
	b=A55zkVs25sZqZCxY6eud3xELUsoY74BJM0G3mON6OC8ZLt/oRvvX3wJx5KdZ/49KgiZX
	 ubjq59zQYWvkw9lCfqXEq3PytS37+LRNmj1OcR1g0o8wKRubEPGc9+pxJsEdReqM9iFvZ
	 wqY00t/TDlFP6VODevTCBR/DUGZVO7WzlV2dqJ+plB526Tquok5yxuBnoOBG+bYEf+2Uu
	 3EqytGXOe6j/24HjWIkQqvG4fY0EYDqaBkiIgtIq7w91mARyrgTqswC3+WDliId9yRft3
	 kweomInmyCP5948sm84mwJzsIRCTHaEaYfhnvtXjtRQjfyXQpDMRd7iseI9Fg49EmEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sc8vkZXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50686606A31D;
	Mon, 19 Oct 2026 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sc8vkZXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4E51F000C5;
	Mon, 19 Oct 2026 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792437526;
	bh=77mlLPeWieg1gPE9ZVsd30acJWkC/9GBsg5MHF+AKxs=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Sc8vkZXorvzEGiY+LTRN6fEVRb6T2XdkonoSOpCOZ99dDlclFWXdAjTQzLo55Kja+
	 932j/jmJktfh0c/WttptWZOh5I9zbZL57LJ/70JPW6RB9MAy/sJj7hrADPlbGFd+D8
	 eeSXvklCAyOzanZ3JWVuxsfOFe18y4ZQJtWe2Pkd4cLoJef/pF3++QAjondU+Pdn9g
	 dujZFbDGxAIYKSZ9tTyMkY+vBOiUJxYTllh9R09mMFN190XHAqxSyvINACudxH1uSo
	 CbXmLOyhnCQ002lb5K0f1ajSB/A+r6h/S2iZC53DsHfbZRjmNvpVAZomX+VyY6SRgO
	 gqeNX1nCz852w==
Date: Mon, 19 Oct 2026 14:18:45 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
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
Subject: Re: [PATCH v11 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261019191845.GA2219127@bhelgaas>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019183537.GI64621@unreal>

On Mon, Oct 19, 2026 at 09:35:37PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 14, 2026 at 05:49:53PM +0300, Leon Romanovsky wrote:
> > On Wed, Oct 14, 2026, at 16:23, Bjorn Helgaas wrote:
> > > On Wed, Oct 14, 2026 at 09:53:47AM +0300, Leon Romanovsky wrote:
> > >> On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
> > >> > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> > >> > This misclassifies asymmetric and nested switches, and reports one answer
> > >> > for every kind of TLP.
> > >> > 
> > >> > Three ACS controls act on TLP attributes the Requester chooses rather
> > >> > than on the topology: Translation Blocking and Direct Translated P2P act on
> > >> > a Request's Address Type, and Completion Redirect skips Completions carrying
> > >> > Relaxed Ordering.
> > >> > 
> > >> > Evaluate each direction at the path divergence, decide every class from the
> > >> > one walk, and treat a client with ATS enabled as translating unless its
> > >> > driver declares per-mapping ATS.
> > >> > 
> > >> > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> > >> > 
> > >> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > >> > ---
> > >> > Changes in v11:
> > >> 
> > >> 
> > >> Bjorn,
> > >> 
> > >> Could you please save me from the AI-bot attack? Every rebase seems to
> > >> uncover another bizarre pre-existing issue. It never ends.
> > >
> > > Can you elaborate?  I'm not sure what you'd like me to do here.  I
> > > don't control the Sashiko reviews, and I thought Sashiko was recently
> > > changed to put pre-existing issues in a database but not in the email
> > > responses.
> > 
> > AI reviews are not deterministic and every resubmission gives us slightly different result, which is in this phase of submission is  full of hallucinated flows not applicable to the upstream.
> > 
> > In addition to upstream Sashiko, i run everything through local one with slightly better models which hallucinating even more.
> > 
> > I would ask you to merge the series so it gets real exposure in addition to my kunit and specific hw setup.
> 
> Bjorn,
> 
> We're in the merge window now, so I don't expect such a large series to be
> merged. What about the next cycle? Should I send v12 after -rc1, or wait?

After -rc1 would be good.
