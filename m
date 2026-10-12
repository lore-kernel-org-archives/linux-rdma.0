Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A834348C7C;
	Mon, 12 Oct 2026 11:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802930; cv=none; b=RpEgxO8+f+Mhc9jRcHA0zM1vPLWEFQzfONlI9bGAiDJGp1jau9k8rg83AyFsoD/r1CaKNCr/LL210RCw3Sgs4MwtYBX3VXW/+Oq3XpVvYX5U2Gi+FgcO5CzlYnLe2ROs4INAtxGRt/Yj3NqB/LuZZNHLJJPiGy2JJK3FISFyEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802930; c=relaxed/simple;
	bh=aj+gYybFQdwaLzcOujCEl6Ayb88eLjuLhCdZZHUlOxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlEfr70YbN7dYy3XSTgFaTV+vCxOsMYZFigqOzhbzyG9TrgyMbAiqy0MNFaO1jOwvSpRGjnOSGg2oEfEU6Cp1sVwYtALHO+Y5Xs0s1kqOjIU4g8BaV/LdXAigQRK3NWfI1ATViyARkryRfXYs4eWYVM9JORkzIL6/M2FeR1Ufaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtvBiCKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtvBiCKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1728B1F0089B;
	Mon, 12 Oct 2026 11:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802929;
	bh=MAfYAMjPNeKmn70tZ8yJzw3w1YF8t8B5YaHyVdbC17s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BtvBiCKVAPhg4YheaU0NRTp6NmOfBz71i/2zIRP+ixQZlDRLqv9KZ2Et0goaQhFpF
	 1adHNcrWs0a7uEmFieyjjaBhTuH/edNCuGf5KUXuHN+d31KNWCXCjrDUDy/uY8IDLj
	 ao5nVaaGaM3ZuU2zQAZKdppFM3eRolLpwvA45qAEDycS2m7tXyRi46Kzr4N+vK83o0
	 krr9G8jYOmbF3ozKel1ofXEIzfyqphTOx0GaT0Id1f0N61X9eRhy9mKzsF/zW5S4mF
	 sUDGOczGxsWpKhIstJfvyoiyO8ynN0redIjjsgQeIiEyNg9T4Pyqk0CnbhM/lWgwV3
	 vkCX5+ikp0/xg==
Date: Mon, 12 Oct 2026 14:02:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
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
Subject: Re: [PATCH v9 01/18] PCI/P2PDMA: Document the TLP attribute
 assumptions
Message-ID: <20261012110205.GD219304@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-1-1a8e0f50ddd9@nvidia.com>
 <20261007201257.GA781492@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007201257.GA781492@bhelgaas>

On Wed, Oct 07, 2026 at 03:12:57PM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 01, 2026 at 02:55:09PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > P2PDMA selects a mapping without receiving the Request's ordering or
> > Address Type attributes. Its ACS handles only strictly ordered Requests
> > carrying an Untranslated address.
> > 
> > Document that the result is not defined for Relaxed Ordering or
> > ATS-translated Requests because those TLP attributes can select different
> > routes through the fabric.
> > 
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Tested-by: Tushar Dave <tdave@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> > index 63cff9e4d2c9..80f8fec9b0e9 100644
> > --- a/Documentation/driver-api/pci/p2pdma.rst
> > +++ b/Documentation/driver-api/pci/p2pdma.rst
> > @@ -15,6 +15,13 @@ then based on the ACS settings the transaction can route entirely within
> >  the PCIe hierarchy and never reach the root port. The kernel will evaluate
> >  the PCIe topology and always permit P2P in these well-defined cases.
> >  
> > +This evaluation assumes clients issue strictly ordered Requests carrying an
> > +Untranslated address. Its result is not defined when clients use Relaxed
> > +Ordering or issue ATS-translated Requests because those TLP attributes can
> > +select different routes through the fabric. Unless ACS Translation Blocking
> > +is enabled, a Port with ACS Direct Translated P2P enabled routes a
> > +Translated Request directly to the peer regardless of the redirect controls.
> 
> This whole paragraph is removed later in the series, so kudos for
> documenting the current state before it changes :)

This may be a leftover from the prerequisite fixes you merged. I'll keep it
in the series for historical context. :)

> 
> Unrelated to anything in this series, but this doc mentions
> "p2p_provider", which doesn't exist.  Should it be "p2pdma_provider"?

Yes.
