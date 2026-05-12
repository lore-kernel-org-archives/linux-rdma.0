Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93FB38E5EF;
	Tue, 12 May 2026 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778576415; cv=none; b=aby/uR5TV29Cd5wfX0/C/a5CGzipHlH0ekGRljx3xmLBVOopZ03LNtQ1nkSAtM2Dk0UydS8lWsNkso1CwedbAqxNHvlwJaFe60na+18AbMY9IOvXRjtcS6YS3wfiin54SQtQ7bmEnEuYuutK4e5LD/zWgkE2QoEnTxa1+eyflZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778576415; c=relaxed/simple;
	bh=mRO6HYK8zR58M6WfaxPSs3TTYuHgr1rfoSMZvltT5Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHKyPuAIQYSxWg7KXjsedCsT9rpRinKfP/FQd4mvR/fpShFSkC+JNFo/1ziSH4oFaXxYcTxGxP4Jt15BnOAD1f3nhtKKM67im6uaiX5GQlLxs4hBhQcI++9JzMenJkk9j/dfV0REnZfCOPZsxDcsQR1nc8px8u3aoTz3OvNJJ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmGoSe9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmGoSe9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE54C2BCB0;
	Tue, 12 May 2026 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778576414;
	bh=mRO6HYK8zR58M6WfaxPSs3TTYuHgr1rfoSMZvltT5Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HmGoSe9lsUNpwoy/lvxKquP+ymuUlNC3VAZXr/92XEC1koEnGibsSOWCVwBwJaFYH
	 FQp+iABDOF3ELbIza7XiAAiGxvM00tI1ezL8508fErWV2/eN4FHRjgZ7PgoqE4AeE6
	 P+wlowBZWcvUO2jiQ7N3plciNsK2ISZSPVZiaRigBejXfpwU4Hc+UrkonUfkRI9K53
	 Lc3V590nAT9vzI6wsoykrT4F37GpfprRXaeuT2ro3Efw5DqIlS78PJw8X6SF4ngU02
	 CZSdrX5zjL5AjIu4Jn167ZPpvvnQemnK5eBLyi+osCGYRzbhMPMh/boJM+RjSr9xSZ
	 LGp5oTyl+TFaw==
Date: Tue, 12 May 2026 12:00:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PCI: Export pci_parent_bus_reset() for drivers to
 use
Message-ID: <20260512090006.GQ15586@unreal>
References: <alpine.DEB.2.21.2605050042390.46195@angie.orcam.me.uk>
 <alpine.DEB.2.21.2605050051390.46195@angie.orcam.me.uk>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2605050051390.46195@angie.orcam.me.uk>

On Tue, May 05, 2026 at 01:03:39AM +0100, Maciej W. Rozycki wrote:
> Export pci_parent_bus_reset() so that drivers do not duplicate it.  
> Document the interface.
> 
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> ---
> Changes from v1, 
> <https://lore.kernel.org/r/alpine.DEB.2.21.2306200231020.14084@angie.orcam.me.uk/>:
> 
> - Reword function description so as to list the return values separately.
> ---
>  drivers/pci/pci.c   |   17 ++++++++++++++++-
>  include/linux/pci.h |    1 +
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> linux-pci-parent-bus-reset-export.diff
> Index: linux-macro/drivers/pci/pci.c
> ===================================================================
> --- linux-macro.orig/drivers/pci/pci.c
> +++ linux-macro/drivers/pci/pci.c
> @@ -4833,7 +4833,21 @@ int pci_bridge_secondary_bus_reset(struc
>  }
>  EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
>  
> -static int pci_parent_bus_reset(struct pci_dev *dev, bool probe)
> +/**
> + * pci_parent_bus_reset - Reset a device via its upstream PCI bridge
> + * @dev: Device to reset.
> + * @probe: Only check if reset is possible if TRUE, actually reset if FALSE.
> + *
> + * Perform a device reset by requesting a secondary bus reset via the
> + * device's immediate upstream PCI bridge.  Return failure if the reset
> + * failed or it could not have been issued in the first place because
> + * the device is not on a secondary bus of any PCI bridge or it wouldn't
> + * be the only device reset.  If probing, then only verify whether it
> + * would be possible to issue a reset.
> + *
> + * Returns: 0 if successful or -ENOTTY otherwise.
> + */
> +int pci_parent_bus_reset(struct pci_dev *dev, bool probe)
>  {
>  	struct pci_dev *pdev;
>  
> @@ -4850,6 +4864,7 @@ static int pci_parent_bus_reset(struct p
>  
>  	return pci_bridge_secondary_bus_reset(dev->bus->self);
>  }
> +EXPORT_SYMBOL_GPL(pci_parent_bus_reset);

I wouldn't recommend doing this solely for hfi1. The driver is likely to be
removed or significantly changed soon.

https://lore.kernel.org/linux-rdma/177516078937.637585.1447184858924347033.stgit@awdrv-04.cornelisnetworks.com/

Thanks
