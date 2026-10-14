Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC7D4EFFD2;
	Wed, 14 Oct 2026 13:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984236; cv=none; b=QUje6wPr4lPEuX2o/2oH7R6OtYNcvYBGAMj9jBvNNEyp0S2I5NRV+qoDfs8KOWWTLbFEKsN1tZQOpVtbh6yAuNuQOKZYddSgGxuauv2EZrSEbIgsusSFAQ0KvGWbxJecXOc8O3eSFIUiFlGWkuev2GyX7OfHrtGYmrfXgdEGDyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984236; c=relaxed/simple;
	bh=1jAEigErQV8jyVaUVruOdi2WmK3q2Uuk/QLlFFuhaFc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=iQqexi8ZFLKaAnnd2ZV3wQsks6oOMzuyzjNDcIcwxYdfG6v+Vjikugr1/gYI3//+VvmexHrkDwct91xtDETlGVD3pyTiMwAyi2uHXn4IfIZshzhUb1jj0ib57Mc8ZpkybqARJmLcR0f3kfcT1jUJfi2NXOjHOdvUkatjESvG69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VY1TVQtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VY1TVQtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885C91F000FF;
	Wed, 14 Oct 2026 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791984234;
	bh=zh7/Ug58+Id/pjTRVFnSqm3xMVxCch1on+6+IzYcFOo=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=VY1TVQtlH3RX+/ZXBgKvz5jDQWSl87MupN8zI9hC24rJvxTxwxBJ4XPc3k8kRNP73
	 BJUQ8gOni1xH2vxvOF7XI7TKoskBT6qkRLbiR7u5xhazxbzMIlK/RpjbBC6lBp+AVj
	 gkt6iyd/HWLGsXX5bI3inKNXCzcuB81i3Bi01jNQ2FMCvJRHv6Po/8i3vEZIo63f9g
	 TaU5SxADJQiyj42AB8bP1vly6Wa+mrd/1/KIY4SwlLHCs93QU/imKD1M2mJndebfi4
	 n+1QmTBNHvqDZ51qsxO3RDQuiAZXeMnp0pXpWcRVh8cP4p/5V/LPvX7YZ/pScmF3an
	 4AflKGZkey73g==
Date: Wed, 14 Oct 2026 08:23:53 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
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
Message-ID: <20261014132353.GA1625948@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014065347.GW219304@unreal>

On Wed, Oct 14, 2026 at 09:53:47AM +0300, Leon Romanovsky wrote:
> On Tue, Oct 13, 2026 at 05:25:08PM +0300, Leon Romanovsky wrote:
> > PCI P2PDMA applies Request and Completion Redirect throughout both paths.
> > This misclassifies asymmetric and nested switches, and reports one answer
> > for every kind of TLP.
> > 
> > Three ACS controls act on TLP attributes the Requester chooses rather
> > than on the topology: Translation Blocking and Direct Translated P2P act on
> > a Request's Address Type, and Completion Redirect skips Completions carrying
> > Relaxed Ordering.
> > 
> > Evaluate each direction at the path divergence, decide every class from the
> > one walk, and treat a client with ATS enabled as translating unless its
> > driver declares per-mapping ATS.
> > 
> > This completes the P2PDMA side; dma-buf and mlx5 follow separately.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > Changes in v11:
> 
> 
> Bjorn,
> 
> Could you please save me from the AI-bot attack? Every rebase seems to
> uncover another bizarre pre-existing issue. It never ends.

Can you elaborate?  I'm not sure what you'd like me to do here.  I
don't control the Sashiko reviews, and I thought Sashiko was recently
changed to put pre-existing issues in a database but not in the email
responses.

Bjorn
