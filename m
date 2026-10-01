Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C23D8121;
	Thu,  1 Oct 2026 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859591; cv=none; b=JZX3X3larjRmca3plEII92LqpsJ1qUUX7w2QSj7VINI2etk9TYENuJNviJrxNtLANcuoTpYx+DlUlhL2BqHQs1asdzewuaGZS9FEUSr1gD9L0GbfNdDbZ34zIEjpc/b/ob7DpjJWePgPgHwVSO3Dt2bh69kVRgc3uTjj/MwuGnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859591; c=relaxed/simple;
	bh=+oEEYMyapdfy2MygoVgo6lezDIyzegG2R9t+lllJbIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRp0bIXDNuskvk6SzK+OoATc6vTZPiK9n44OP02TWWOD/Cf7jkRPRiVQKg0P9+m2ryEEg2qdwDBk8KimB04BqV2O05CAgK+Csn7aQIyQQGbc7iN7LpqIdC0+OKegh/Gurf/0hdq2SxOAUBgJc3ecYW+rUG8qjgIh2HoGXLhzPtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIF/B0EW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIF/B0EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB11F1F000FF;
	Thu,  1 Oct 2026 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790859589;
	bh=mWEhNC2bx28+yRg0dPmgwrk6vKK8w5OBcpeNy+gKRH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JIF/B0EWXJ0MDjxeLJZ7yO1RQlpIaMdKbKKNsSXNWszWPJ3PBB4IoBEyGD5DARCr6
	 EghD/+7Ha3UjceHW9Y7A7cvC/XxmnNWI28uTVunnCjnAZhrBDv5jL1BQBGa3yejDd9
	 8JtJ9TQEwE9J8Epe8QYSKPF+/imypf3aX6Ku8z3ojDryet26BK6wy/1B+aVsbYEP8A
	 bCyy3I8sdeW1g+eTaXFkbJPLdBLEP9UbiViiSkgnH4LRiYzLb6taZ99aGK9yoG235C
	 WMk4EwMOCwp9Tvw37ZZdHse/DBW/9OckkefvsDEBIG7Q+OIcogIXov6gHrykqeG8MO
	 4GyhjSqX2XKAg==
Date: Thu, 1 Oct 2026 15:59:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	media-ci@linuxtv.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v9 16/18] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Message-ID: <20261001125944.GM3401365@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-16-1a8e0f50ddd9@nvidia.com>
 <20261001120807.8723F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001120807.8723F1F000FF@smtp.kernel.org>

On Thu, Oct 01, 2026 at 12:08:07PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] pci/p2pdma: pure clients cannot set ats_per_mapping because pdev->p2pdma is NULL
> --
> 
> commit f332086fc4a4273d099c81fafb33298021d47d1a
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Let a client declare that it selects ATS per mapping
> 
> The PCIe ATS Enable bit covers the whole device, so P2PDMA cannot tell
> from it whether a client will translate a given address. Most devices
> translate any address once ATS is enabled, but some choose ATS per DMA
> mapping and can still use bus addresses for the rest.
> 
> Add pcim_p2pdma_set_ats_per_mapping() so the driver of such a device can
> declare that before P2PDMA starts treating clients with ATS enabled as
> translating everything.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index cf190bd572d4a..6a63901c65fb6 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> 
> [ ... ]
> 
> > @@ -1562,6 +1563,32 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
> >  
> > +/**
> > + * pcim_p2pdma_set_ats_per_mapping - Declare per-mapping ATS for a client
> > + * @pdev: PCI device that initiates peer-to-peer DMA
> > + *
> > + * Declare that @pdev issues Translated Requests only for the DMA mappings its
> > + * driver sets up to use ATS, rather than for any address once ATS is enabled.
> > + * P2PDMA then routes this client's Requests with the Address Type each query
> > + * asks about, rather than the one its ATS Enable bit implies.
> > + */
> > +void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
> > +{
> > +	struct pci_p2pdma *p2p;
> > +
> > +	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> > +	if (!p2p)
> > +		/*
> > +		 * ats_per_mapping is a performance optimization,
> > +		 * if pcim_p2pdma_init() didn't set pdev->p2pdma pointer
> > +		 * for some reason, let's simply use ATS global settings.
> > +		 */
> > +		return;
> 
> [Severity: Medium]
> Will this silently fail for pure P2PDMA clients?
> 
> It looks like pdev->p2pdma is only allocated when a device registers as a
> P2P memory provider via pcim_p2pdma_init():

Yes, this is exactly for them and no one else.

Thanks

> 
> drivers/pci/p2pdma.c:pcim_p2pdma_init() {
> 	...
> 	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
> 	...
> }
> 
> If a driver for a pure P2PDMA client (e.g., an NVMe initiator without CMB)
> calls pcim_p2pdma_set_ats_per_mapping() to declare its ATS behavior, won't
> pdev->p2pdma be NULL since it never called pcim_p2pdma_init()?

Only RDMA NICs support that per-mapping thing.

Thanks

> 
> If so, wouldn't this cause the client to silently fall back to suboptimal
> global ATS routing, as it can never successfully set the ats_per_mapping flag?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=16
