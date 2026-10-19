Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434941;
	b=mOFnWqaCv3cU96APX2vi9c5REkEzHdAYkAs6y3i1KnLr3TKtz1VH2JjwbjIzRcLR1qsS
	 7RS4/g1+X7nYuLvBf6TdsmpK6SNlNn7kJE4RsmhJggizrANQoq5b1Nz7pDGiTrKfw6UJm
	 KXR07TJ5Bv+jgFQBgC/+eGplBvKCOZJdacxwUtze62R49gbH5Wcf4LYTTKD4ffOsSwqeF
	 1dvfjcNidzeJvMG5n9iYrB1rW0CYpVBQXAWB6V5iOpD+y68tAgd3r2OKOSBeQiccoGHJz
	 nfub0YbwA8/cK4w3fCMAwYdofTY7kkJBnXrjq15XZCL86356owE6yMt78xf/5+AeKwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434941;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=n32poB4tkKKa1H8C9bhY2dZAW0+q+igXltm4JEhLcqw=;
	b=Vo3SOAilZvIqg84UJcgD5JLmUmoDjZms/msU1VkXAS/mlFSq4eOQ/GofhpWNtIcKlcKT
	 4oKwYz28gcHdKlkGlhhB9OvvpsMKzkTFpKZXc9XKM9Gt6sp+IEH0Wi13m399BrAIGjz29
	 6ae2drMHzsE0rxR1qV9eU3O7rUTrZezSsPlB3G2xqNw+roccWr/t5/t/8OSnG3Zef+XTr
	 2ZqQmDN+GqE856iWT0yuQOCvXdSnzZ0W/0ci9xtFtz+wbp5HxaJPe6SF1PGagHPM82g3q
	 XArcP6LvVVeD6bFFyuvWuw+d+3EHqZt4XUQ6I6srKQi3Z9D/Uv7MW3idjEsSAv4xwQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="WF/haCzz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89AB606A31B;
	Mon, 19 Oct 2026 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WF/haCzz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A91F000C4;
	Mon, 19 Oct 2026 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434940;
	bh=n32poB4tkKKa1H8C9bhY2dZAW0+q+igXltm4JEhLcqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WF/haCzzvQJPPUWBj50CMBjC9jE8aMytYuSftFLlIRaLScaIBZDKoWDLcaFTUeGEV
	 byMWI9zl0IMmBs2kznsH6KszESmy5Ku3CiNrSTFKMxRE5ZYt8DWF6wx7l+W1MTbgh/
	 rgCknL4xvUV3nKHSke3FicCrirp+WspbboJtB1+Lna8TM/2KW/p42LTcaiSac1x9Z6
	 ihKcDophwBMK2dSGA2wfIJ9rFX6a2DpIqH9R9lMqcWsPa9aKhZakK4XMMVbOE9qwJs
	 1hTpeRS2qHQ4ucPyhETyPMF7fIBtrFACCSFbc78XmFJYmRs4c1MQ3xMvfCffqrUioZ
	 JuyVU8tQ0aM/Q==
Date: Mon, 19 Oct 2026 21:35:37 +0300
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
Message-ID: <20261019183537.GI64621@unreal>
References: <20261014132353.GA1625948@bhelgaas>
 <eb8e0edd-4c4d-402e-9875-bdbc6d191edf@app.fastmail.com>
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
In-Reply-To: <eb8e0edd-4c4d-402e-9875-bdbc6d191edf@app.fastmail.com>

On Wed, Oct 14, 2026 at 05:49:53PM +0300, Leon Romanovsky wrote:
> 
> 
> On Wed, Oct 14, 2026, at 16:23, Bjorn Helgaas wrote:
> > On Wed, Oct 14, 2026 at 09:53:47AM +0300, Leon Romanovsky wrote:
> >> On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
> >> > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> >> > This misclassifies asymmetric and nested switches, and reports one answer
> >> > for every kind of TLP.
> >> > 
> >> > Three ACS controls act on TLP attributes the Requester chooses rather
> >> > than on the topology: Translation Blocking and Direct Translated P2P act on
> >> > a Request's Address Type, and Completion Redirect skips Completions carrying
> >> > Relaxed Ordering.
> >> > 
> >> > Evaluate each direction at the path divergence, decide every class from the
> >> > one walk, and treat a client with ATS enabled as translating unless its
> >> > driver declares per-mapping ATS.
> >> > 
> >> > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> >> > 
> >> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >> > ---
> >> > Changes in v11:
> >> 
> >> 
> >> Bjorn,
> >> 
> >> Could you please save me from the AI-bot attack? Every rebase seems to
> >> uncover another bizarre pre-existing issue. It never ends.
> >
> > Can you elaborate?  I'm not sure what you'd like me to do here.  I
> > don't control the Sashiko reviews, and I thought Sashiko was recently
> > changed to put pre-existing issues in a database but not in the email
> > responses.
> 
> AI reviews are not deterministic and every resubmission gives us slightly different result, which is in this phase of submission is  full of hallucinated flows not applicable to the upstream.
> 
> In addition to upstream Sashiko, i run everything through local one with slightly better models which hallucinating even more.
> 
> I would ask you to merge the series so it gets real exposure in addition to my kunit and specific hw setup.

Bjorn,

We're in the merge window now, so I don't expect such a large series to be
merged. What about the next cycle? Should I send v12 after -rc1, or wait?

Thanks

> 
> Thanks 
> 
> >
> > Bjorn
> 
