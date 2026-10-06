Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0FE37F00C;
	Tue,  6 Oct 2026 22:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791325272; cv=none; b=lNsXG5D+KHBNcJI9eoJWspjQ2es9Ba4WQLbEXRFsdH1mLVsN5hBk6h+RP9TXEjlMe5nqS4zTPeBFdkEQqgwHtc9ugwywVuftxHfH3aA+Kmu94u3uMXrqlShaes5y7MIivWLG6kEaHYO30jFXC7aZQOW8GHkZckwnZ4+7jVpXgqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791325272; c=relaxed/simple;
	bh=MoO9vgW9a3cnb7uJYv4Pp/f04GYp/V+VqdxQZcRfd5c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=cqycdkrrjoqotaA5Fs/IrvebhFpaiMliLSDXglf8g9Pwlu1P1xHVkopdalV6vnXllV85CTU4PwhrsP91XiAAEX45T09NK3y0HMyUZp7ilkyxhi9yUAMjJw+nSFSdCPn6kth7pYhzTxDlIzDVEFOeV5A5pY2GLFOpNqCWYq+1Bjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVNBsQT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVNBsQT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013941F0089B;
	Tue,  6 Oct 2026 22:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791325271;
	bh=cfp7iysnIwOqsRhNGcF+6fkeHEEsvMikccHQN1B4900=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=iVNBsQT2JyG7a+snUA5nIQ1ulrZjmPQ+zyhqCKUU6vQrX82EgZ9XU+IxZZtaq65Hf
	 Wk+SbIc2uKAYC7oQNgHgWLE9McyajhTdjK5dHAhg8P8lDoHyKRVkT1XBnoGz6FBVPd
	 mvk28ogpARegCJX/y95b8aVtrLJPwsY8A6A8YxdVU/scKs5dhnhXHMjwPo4kXOYW3m
	 dcQGBbQF/dykB7LV5e3KX8WKAMKbiuOmzbQ8LSwDlorzpUt01HxkTtsWx9ctQCMR2R
	 a03y7NGZtZyN/hSJWkuqlv8hurAKLT+8wPJ7+g2JP12OjsQdyDgbj0KwE/r7CCgSLy
	 fvfn6E2kqjO6Q==
Date: Tue, 6 Oct 2026 17:21:09 -0500
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
Subject: Re: [PATCH v9 08/18] PCI/P2PDMA: Route Relaxed Ordering Completions
 directly
Message-ID: <20261006222109.GA719055@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-8-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:16PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ACS P2P Completion Redirect leaves Completions carrying the Relaxed
> Ordering attribute alone. PCIe r7.0 sec 6.12.1.1 redirects only those "that
> do not have the Relaxed Ordering Attribute bit set", and sec 7.7.12.5
> describes the enable bit as "applicable only to Completions whose Relaxed
> Ordering Attribute is clear". P2PDMA reports one answer for every kind of
> TLP, so a client whose provider returns such Completions is sent through
> the host bridge for a redirect that never happens to it.

I guess pci_acs_p2pdma_completion() returned PCI_ACS_P2PDMA_REDIRECT
even for RO Completions?  But that didn't change the hardware
behavior -- maybe the caller *thought* Completions were routed through
the host bridge, but they actually weren't.

I kind of lost the plot here.  What does the caller do with this
information?  I don't think a device is *required* to set RO even when
it is enabled, and it may set RO on some transactions but not others.

> Add enum pci_p2pdma_tlp_flags and let a caller state that property.
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 43e225cc5735..1fadef6d0609 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -544,11 +544,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
>  /*
>   * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
>   * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
> - * affects a Completion.
> + * affects a Completion, and that one leaves Completions carrying the Relaxed
> + * Ordering attribute alone.
>   */
>  static enum pci_acs_p2pdma_state
>  pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
>  {
> +	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
> +		return PCI_ACS_P2PDMA_DIRECT;
> +
>  	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
>  				   PCI_ACS_P2PDMA_DIRECT;
>  }
> 
> -- 
> 2.55.0
> 
