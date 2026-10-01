Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52CB5221DE;
	Thu,  1 Oct 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868350; cv=none; b=Oibz3qGJArOHq1r15Nhotn1vwl3alSVXzThPy2kLI71HbzokaWDNyHAYG7GUNayQsiUdUzeQLSAEmo5Yva+1tDbQnXfgYlsU/X6mI4hdSiqhF8o4WwWa6R2PipawBk3JwZ0X78YiEICqqjUhw1ZIzuCQmGfUv8afxCMbLrdmjDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868350; c=relaxed/simple;
	bh=irm07kEIUGQZOdzhH8gb8bR7eiCymrfDweaU6xPLNxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLhH7sheJEP3fl3OIKNL8/Bg+qCd01hvsXdibKQYC7/3ByAShUN8sbRFcAWK8KkLQ+mgw7+gwvqWhUEw9vA5KedZk61Ogn+2/w25kkXaC4seiCUCAmPQQk3yFILM2fCgl054gSI2KiLlIhTnpMicJkKeiMGEZjuqwM4CFJhYRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyHDOE4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyHDOE4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8671F000FF;
	Thu,  1 Oct 2026 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868348;
	bh=z6knL9/Ihm/lfv/+/37jqT3/Z2pVr/gurUnfXwQuf5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dyHDOE4IVsd3PWyuV8L9id5hH4j0gzhPnrXHC+3XsImxQA1v+FHwBpHJnUT9j122t
	 1JiwKfHhSyefRhdjoVfh+U2HSN1FmgBXPPzsMAJYC0vabYiUYknVlLRAVYvIUB+QBW
	 KppsUGDGUulAu2H5meuWUKgi0RhpJRJMOPC/jCvnLULqjuMDnxuvlzUaE+WZ0IMisZ
	 Sd5iNHCSVjgamTQoIQJvpt+cmicjIBzWEkC4kaQb50WBOcXH9rhCiWncsv4t5zYJuj
	 MyF1UBG6cdcBWpClYjy6yxya1NSDaToT8GKYmQF7tsdtpw5YITfO/tF+tlHAICT5G0
	 k4v3j7LCgqZgA==
Date: Thu, 1 Oct 2026 18:25:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>
Cc: dri-devel@lists.freedesktop.org, media-ci@linuxtv.org,
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v9 05/18] PCI/P2PDMA: Document directional ACS routing
Message-ID: <20261001152544.GO3401365@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-5-1a8e0f50ddd9@nvidia.com>
 <20261001115932.75F881F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001115932.75F881F000FF@smtp.kernel.org>

On Thu, Oct 01, 2026 at 11:59:32AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] doc: repeated sentence in disable_acs_redir description
> --
> 
> commit 83321a8abe2362759f10e2c9273854fa000319e6
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Document directional ACS routing
> 
> P2PDMA documentation describes ACS controls as path-wide, although Request
> and Completion controls apply to different transaction directions. This
> commit documents the fixed client and provider roles, the divergence port
> checked, and clarifies which controls disable_acs_redir changes.
> 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 68647ff4bdd24..bc83e07dd5fce 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -5291,12 +5291,15 @@ Kernel parameters
> >  		disable_acs_redir=<pci_dev>[; ...]
> >  				Specify one or more PCI devices (in the format
> >  				specified above) separated by semicolons.
> > -				Each device specified will have the PCI ACS
> > -				redirect capabilities forced off which will
> > -				allow P2P traffic between devices through
> > -				bridges without forcing it upstream. Note:
> > -				this removes isolation between devices and
> > -				may put more devices in an IOMMU group.
> > +				Each device specified will have the PCI ACS P2P
> > +				Request Redirect, Completion Redirect, and Egress
> > +				Control features forced off. This may allow P2P
> > +				traffic through bridges that would otherwise be
> > +				redirected upstream. This may allow P2P traffic
> > +				through bridges that would otherwise be redirected
> 
> [Severity: Low]
> This isn't a bug, but there is a repeated sentence ("This may allow P2P 
> traffic through bridges that would otherwise be redirected upstream.") in 
> this block.

Right, copy/paste error.

Bjorn, should I resend?

Thanks

> 
> > +				upstream and thus this removes isolation between
> > +				devices and may cause affected devices to share
> > +				an IOMMU group.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=5
