Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90F040DFD5;
	Tue,  5 May 2026 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939458; cv=none; b=nNsuwkmCEQGCrfsuDBvjauilxbOkkA7YJWOIyBKzvu7Wtqhu4KVXS3mbJMGjAl+p+UIggv1TGxvhXhpzqKUZz1qZiCF/80tuUIgtGnVxw5U5eTiVFE3PRWXFxBVG5+e8DG++1DAr1uIbuMfEoznR8QE8TlqdZ4CiXTbXGDFFmZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939458; c=relaxed/simple;
	bh=gilj1Gom0i0+f4DKl3WyFHEO9/tTz6CbvsD1Z5sNUKI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rafVZT4JU7p/roFyerLNrmlSPkfBuBV9Wd+snf5AHjH7xX4qbuMvea1TdDWpXA8sJyL0RBCQgOq71+0wLrxwGqepZ+CRulXhIkwfxdWqNANZo0f4ZGtPH4LyIZy7GsMqR06u+cb3wgsQ2D1nYvVZGybge5yuF+dwGZZZecCcqa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id D161592009C; Tue,  5 May 2026 02:04:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id CD67B92009B;
	Tue,  5 May 2026 01:04:15 +0100 (BST)
Date: Tue, 5 May 2026 01:04:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, 
    Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
    linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: Export pci_parent_bus_reset() for drivers to
 use
In-Reply-To: <6ddfb7a-2a83-cb84-ad73-9bd985652858@linux.intel.com>
Message-ID: <alpine.DEB.2.21.2605050048140.46195@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2306200153110.14084@angie.orcam.me.uk> <alpine.DEB.2.21.2306200231020.14084@angie.orcam.me.uk> <6ddfb7a-2a83-cb84-ad73-9bd985652858@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 8 Aug 2023, Ilpo Järvinen wrote:

> > Index: linux-macro/drivers/pci/pci.c
> > ===================================================================
> > --- linux-macro.orig/drivers/pci/pci.c
> > +++ linux-macro/drivers/pci/pci.c
> > @@ -5149,7 +5149,19 @@ int pci_bridge_secondary_bus_reset(struc
> >  }
> >  EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
> >  
> > -static int pci_parent_bus_reset(struct pci_dev *dev, bool probe)
> > +/**
> > + * pci_parent_bus_reset - Reset a device via its upstream PCI bridge
> > + * @dev: Device to reset.
> > + * @probe: Only check if reset is possible if TRUE, actually reset if FALSE.
> > + *
> > + * Perform a device reset by requesting a secondary bus reset via the
> > + * device's immediate upstream PCI bridge.
> 
> >  Return 0 if successful or
> 
> Kernel doc has Return: section for return values.

 No function description in this file follows this convention though.  I 
have now made the amendment requested anyway.

> > + * -ENOTTY if the reset failed or it could not have been issued in the
> > + * first place because the device is not on a secondary bus of any PCI
> > + * bridge or it wouldn't be the only device reset.  If probing, then
> > + * only verify whether it would be possible to issue a reset.
> 
> I guess most of the in-depth explanation about reasons why reset 
> might not me issuable could go into the longer description block.

 Likewise.  Thanks for your review, v2 now posted at: 
<https://lore.kernel.org/r/alpine.DEB.2.21.2605050051390.46195@angie.orcam.me.uk/>.

  Maciej
