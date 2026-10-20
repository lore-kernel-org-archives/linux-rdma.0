Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792491916;
	b=COsm9jpVCcbADvk5w0QR6xHwKmw4+CcnYFtVR72K2rRNMQsNMFtLtDdcuAk0zpjXKdW3
	 3TE4zz9le3eYeQuo/EDgvRWpQk56u5w4AzB8IhpP8L1piVYIONxjYBYS4ItCQDlIZBlvL
	 lpG5SMTWkVcWPu8LeWBi6kjqCNEt4Fdbakwr1gEIaCjoTYI91PamuyAfuP1riXUZPXjh2
	 qGXFXBTxlpDtnkvA8Vot5Vd+hb8NzBOomGBY7VrXmalCVCDPE2bR799cJk1rEVEHTgbZL
	 YOiBW7t4vHjgmnGrWmsw++dwMOkvxeNvggsP2Zt+gs/akYuVuoLkWZqM6zWmBkrn+lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491916;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GmgvE7biHiDHJAgyZpIMu3iqBMY4bU18LDyGcOQMk4g=;
	b=2UpyNORC2FGjWg/yHgQ4myFX41nFkvW7EPXkqHe7hdU8cVOfs11+qRw+OOaZuE3FrpaK
	 h29ygICOgJYJpdd6Wn07Cgs+GGywppmO1pN1KeCtJQK+YIN27rWRcPPaUEZAjn74Vg4iq
	 Ragz3qhmafAnxoaxh2auLsZi99VkirnIpzVx8h0z2dl40DM2dAdTpVvBCg1+5cP1/wDIS
	 Ihf4UmC0mREOWwykxobSpnZHiDD79vlGN/YCdaprk+xlI9kNwkUAFraMANVH7aOTv880J
	 +8APQ+1a4UsZjM9K90Yl5H7beHUt/zk/oJya5vHrS4y/S7167KkmaOSrHNQgLXasaRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lguxzf8Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA99A606A319;
	Tue, 20 Oct 2026 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lguxzf8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A819C1F000C4;
	Tue, 20 Oct 2026 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491915;
	bh=GmgvE7biHiDHJAgyZpIMu3iqBMY4bU18LDyGcOQMk4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lguxzf8ZkSVPiujCO3yHX9RyjwaBzTk20uTEzjFrJiN0TZqi4fB+bCu0Y04iDSvHw
	 dyo+dunY5RFPtvt4z5gbQgc5c31+1wikH2oM+R2A8/9CmcWOCa/DujSVSn8P1Jiy5O
	 IkMGGDOk8VQqJlgDFCMIgIr1GYaj0gVoOQgJSBM8pOf5XItP41xBc0W6hhUtqbWfKS
	 GmYr+B3T+hLhpI4/Q+wr8TYB8Q9ErStEBUwgL3YlmwntUJUiBnNXnidK/nAcYrgCvT
	 E3e8iZ7vB5loeWynl9dd7Vq2QfVKRPC/ECeBnyG1PUM/lSztdK1tJB3H2dRMTvg+ed
	 fC7b+st9MDTpQ==
Date: Tue, 20 Oct 2026 13:25:10 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Subject: Re: [PATCH v11 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Message-ID: <20261020102510.GL64621@unreal>
References: <20261019183537.GI64621@unreal>
 <20261019191845.GA2219127@bhelgaas>
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
In-Reply-To: <20261019191845.GA2219127@bhelgaas>

On Mon, Oct 19, 2026 at 02:18:45PM -0500, Bjorn Helgaas wrote:
> On Mon, Oct 19, 2026 at 09:35:37PM +0300, Leon Romanovsky wrote:
> > On Wed, Oct 14, 2026 at 05:49:53PM +0300, Leon Romanovsky wrote:
> > > On Wed, Oct 14, 2026, at 16:23, Bjorn Helgaas wrote:
> > > > On Wed, Oct 14, 2026 at 09:53:47AM +0300, Leon Romanovsky wrote:
> > > >> On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
> > > >> > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> > > >> > This misclassifies asymmetric and nested switches, and reports one answer
> > > >> > for every kind of TLP.
> > > >> > 
> > > >> > Three ACS controls act on TLP attributes the Requester chooses rather
> > > >> > than on the topology: Translation Blocking and Direct Translated P2P act on
> > > >> > a Request's Address Type, and Completion Redirect skips Completions carrying
> > > >> > Relaxed Ordering.
> > > >> > 
> > > >> > Evaluate each direction at the path divergence, decide every class from the
> > > >> > one walk, and treat a client with ATS enabled as translating unless its
> > > >> > driver declares per-mapping ATS.
> > > >> > 
> > > >> > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> > > >> > 
> > > >> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > >> > ---
> > > >> > Changes in v11:
> > > >> 
> > > >> 
> > > >> Bjorn,
> > > >> 
> > > >> Could you please save me from the AI-bot attack? Every rebase seems to
> > > >> uncover another bizarre pre-existing issue. It never ends.
> > > >
> > > > Can you elaborate?  I'm not sure what you'd like me to do here.  I
> > > > don't control the Sashiko reviews, and I thought Sashiko was recently
> > > > changed to put pre-existing issues in a database but not in the email
> > > > responses.
> > > 
> > > AI reviews are not deterministic and every resubmission gives us slightly different result, which is in this phase of submission is  full of hallucinated flows not applicable to the upstream.
> > > 
> > > In addition to upstream Sashiko, i run everything through local one with slightly better models which hallucinating even more.
> > > 
> > > I would ask you to merge the series so it gets real exposure in addition to my kunit and specific hw setup.
> > 
> > Bjorn,
> > 
> > We're in the merge window now, so I don't expect such a large series to be
> > merged. What about the next cycle? Should I send v12 after -rc1, or wait?
> 
> After -rc1 would be good.

Thanks
