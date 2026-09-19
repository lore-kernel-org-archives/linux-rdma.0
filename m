Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA447CC8D;
	Sat, 19 Sep 2026 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789817163; cv=none; b=pAjxPN2o+xoxcFHw1+OHZ/S4h5M1ZX0SHzAIlLa9LSg0fnB3cw4so/AUWbJWAqjUkybMKnP9ZuZpHGau2WdpuPYOwy72beOIyfyPrX8Fi88muGVgRYHo8grftfo/gb+m89cLUIBQxiq8xXgCwXIiEhzrXtXqfcZy/IwEhh9FEuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789817163; c=relaxed/simple;
	bh=nDD77lCUuGPanc1dIg/pQIPYUjWYdkS3J6zyyFNMC8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svqfMB9zvWH4WNA0TneA4edhLOfCZs6mD9kU2vebRRTCiB9poGUpO1+o3SD71dONSDaNzpmztF/YYuLhucom6U0eEVEFOWkM/8b9c4y1F9ro6jjgk4RHa5I+iwtLRBxZgVB28CAdNgu35xqszgv1zu9vEa7MG8+Hu2IiJIymKhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sui0KgF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sui0KgF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C851F000FF;
	Sat, 19 Sep 2026 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789817161;
	bh=fCBBvMJ9RrgDcgopr8ESfkQ/nu0fhXNb8XpG2GhGV3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sui0KgF3V2wTPBaekHDtIyHqVKUojFZmU+nR3zYPd4Qff3fAUw1mGdgQ2cFUX0D0I
	 InGzWCQ//u4sYwraWmImGSipYxNodKmw9viNFmdga6R89wkkJa5kHmFghWOeMhAbEp
	 VJgY2LR00tyXPtcMGnjB5oUHQeRY/ObD7gqxpxtnVlwqV1PRNatsiGmUFqix37NyI2
	 +c1nS9yKklEMhDWGntIWA1dGxa7wrbzihQIU37bPl+8ce7ovJNklkrKtYmu5RSQVxs
	 oCZVzA0RzhElJEh0/40G2hlT6zbBw/0uXiG9Z0GebhzupLJTpGvRH1fi7cdt8CIadC
	 b4FjqbEqhQIbg==
Date: Sat, 19 Sep 2026 14:25:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a
 direct peer-to-peer route
Message-ID: <20260919112556.GB13683@unreal>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
 <321890690ce83d1943b2f678bd9bee9b8c895b66.camel@linux.intel.com>
 <20260918121500.GV13683@unreal>
 <b517070d0b9236b03962fcba649faffcacda23eb.camel@linux.intel.com>
 <20260918170524.GH11599@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918170524.GH11599@ziepe.ca>

On Fri, Sep 18, 2026 at 02:05:24PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 03:42:28PM +0200, Thomas Hellström wrote:
> > 
> > 1) Xe attachment check if pci_p2pdma_distance() returns OK for the
> > path. Then Xe always sets up dma-addresses using dma_map_resource(). 
> 
> Open coding pci_p2pdma_distance() in drivers is a hack. Using
> dma_map_resource() like this was never "allowed".
> 
> We've fixed things so these hacks are not needed, the drivers need to
> move over to things like dma_buf_phys_vec_to_sgt() and the hmm helpers
> to use the DMA API correctly.

And this brings us back to my original question: what exactly should I
change in this series, given that it works as expected for all users of
the existing DMA and P2P APIs without any additional "hacks"? This
includes, for example, VFIO, iommufd, and RDMA. In our internal tests,
the GPU driver converted to use these interfaces also works as expected.

IMHO, it is time to update XE too.

Thanks
