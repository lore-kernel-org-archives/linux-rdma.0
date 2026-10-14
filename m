Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C19E471CE0;
	Wed, 14 Oct 2026 06:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791960420; cv=none; b=YCSwjii86mknYlhAAFAiSKMxyWZxRLbN62dOcvN7Ei+/72ZCWyP/Gig+g+fFlYoelBf3tEdDTlkNvIlus5fr+Rcn4k0TN/jnFyk/ZcKsVWH0tCoDp8CVSC7z86qKVZY3Qs77kAk40XQ8P2dqIp4BYApDV7oX7m/ZWs3qWNkhvaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791960420; c=relaxed/simple;
	bh=mSnnriOkSKlnUk+6fo/Kq1ixneeAL4WZQRBSJOIW3qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItzHLXwsaiaaObExfgrhPXk1ROObty6mb9bOWiPZiSAt0QevAACe7hHujF2ZG/pa6jq4cPnmrM1SgtjU7C5qulU60JXPCfpX1oEZBV6YGxKK7Xfl8JnXLcOqy5Jl17Milno+xWvUrtCQrbTNPhdJTqNfB+VvzSl12BY5ujDvRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFTX6Ntx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFTX6Ntx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486491F000FF;
	Wed, 14 Oct 2026 06:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791960417;
	bh=j8H0NoEXZnVe8rGJVifKPpZGEuefBe+Pz5xO0QIVr0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gFTX6Ntxaax3HpDdnJEqgzvZFPRgjas53WK98vDIqzhm1UPXFlZfgiJLI+UFizKym
	 mzRe1ELAzr/6yp6GwQycX4feklE7pujtlHPXnezGoCTQ0GA5E/j6MMTXpRjkEPJCnD
	 WAWUvtH+z9KtQaBxwt2Y1dkoUO3thjterApS1b0UpngvYErooh4lTKMtM4zx9VxQ3/
	 Hp9pcaMzrbSTogPgKIz5XiWtSNDze4uoyXUHHJtBxzO4isSFFHGOtL1KUtdanEeeBw
	 hVWB+3MaPWbukUdvhIJ2jgupe4/cJIk5mtbJ82xxyJ/IQ4YRF2xY2RQubi7/vpLqiP
	 iotkrBwrhKqFA==
Date: Wed, 14 Oct 2026 09:46:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	media-ci@linuxtv.org
Subject: Re: [PATCH v11 09/19] PCI/P2PDMA: Route Relaxed Ordering Completions
 directly
Message-ID: <20261014064653.GT219304@unreal>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-9-72cf8c96e617@nvidia.com>
 <sashiko-outbox-169923@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-169923@kernel.org>

On Tue, Oct 13, 2026 at 02:37:38PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] pci/p2pdma: false positive warning if Relaxed Ordering route succeeds
> --
> 
> commit e6e15dbbdb2b5d6dee258b1197f71025a221015f
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Route Relaxed Ordering Completions directly
> 
> ACS P2P Completion Redirect leaves Completions carrying Relaxed Ordering
> alone, per PCIe r7.0 sec 6.12.1.1. A Completion copies that attribute from
> its Request, so a client setting it on Non-Posted Requests need not use the
> host bridge solely because Completion Redirect is enabled.
> 
> Route Completions directly for PCI_P2PDMA_TLP_RELAXED_CPL unless a device
> quirk redirects them or the Completer lacks an internal route to its
> sibling. Neither restriction promises a Relaxed Ordering exception. No
> caller selects these classes yet.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 9d416329aa4b8..785e4668a2af5 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -580,11 +580,15 @@ pci_acs_p2pdma_request(u16 ctrl, unsigned int tlp_flags)
> >  /*
> >   * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
> >   * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
> > - * affects a Completion.
> > + * affects a Completion, and that one leaves Completions carrying the Relaxed
> > + * Ordering attribute alone.
> >   */
> >  static enum pci_acs_p2pdma_state
> >  pci_acs_p2pdma_completion(u16 ctrl, unsigned int tlp_flags)
> >  {
> > +	if (tlp_flags & PCI_P2PDMA_TLP_RELAXED_CPL)
> > +		return PCI_ACS_P2PDMA_DIRECT;
> > +
> 
> [Severity: Low]
> Now that Relaxed Ordering completions can route directly while strict ordering
> might still redirect, does this cause a false positive warning in
> calc_map_type_and_dist() in drivers/pci/p2pdma.c?

There are no in-kernel callers that selects RO.

In current code, this flow is impossible.

Thanks
