Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2B047F2C3;
	Wed, 14 Oct 2026 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791960591; cv=none; b=XM/OGWWe9ECT+XHX41tawn4irm1+XbBK4AazCzAreSegXHvVayqYI/+IKySgLNymTfbfCOXsm5zxCugSLqwvah/LPC8sdWKVjswo9tod8DNgpgVc0CMUob27FxmzaI1sHMyk+hZGu024/R6DpnkyN0Ml3YgFkZ2e9E/SYNFqAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791960591; c=relaxed/simple;
	bh=q1KAHEw6AACqCmLZ/y5Jpihuik2HD14mSRZzJQpHIyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rR6W9ec4mYO51yag/DUF6uFp/qx6diOneoENg5COUOINAEpz2lXZpBCrUUxssbw3Mt80bFW+yUPoQBHWdZylU3N15hCAhntUZBuGJ7hmN4ieTrxfKgZ2QXMC84v7KjhNQNxoa8u1FxzcuqAIpPRe6DB2ZOtAoxvqy0ekEc9TmaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVJlbiM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVJlbiM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7831F000FF;
	Wed, 14 Oct 2026 06:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791960589;
	bh=HsruFh9QO1GPcgzHM/eIN4QvMcLaW/LA6gWESnfZHSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mVJlbiM/EP8ys9nyQRDJQ8sn/T7DsLfHRZN3r21zlTQW1lbP8DSx8EyerYncpPuIr
	 gA8I/QGeDH/hEoLd1e+zjbQBZxG7gm8HTOMZljFD7QZTLouzkmL0DxR9Ce798ft153
	 TNzQNikJIS5F92B+DeqacWEJVvLtcSRxU6tplhlM1ezsfZXiCx6dsF7Fk+/SH62Zo0
	 PSrKysfbHH/CqRs960H2nixrrskAKRkm/4JMCreLuuzBC2PB8eq8zqS89yOaOofyQ+
	 0pHTvN3JbWdeu49VRw0MT1hERXmPdsfhqdxp7bb8nSE4upQ3Od/TBgGvPoqsjF2M+E
	 /3rft81V54rEw==
Date: Wed, 14 Oct 2026 09:49:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	media-ci@linuxtv.org
Subject: Re: [PATCH v11 01/19] PCI/P2PDMA: Honor device-specific ACS
 redirection
Message-ID: <20261014064946.GU219304@unreal>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-1-72cf8c96e617@nvidia.com>
 <sashiko-outbox-169930@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-169930@kernel.org>

On Tue, Oct 13, 2026 at 02:44:37PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] pci/p2pdma: deadlock in calc_map_type_and_dist() calling xa_store() from softirq
> --
> 
> commit 6120f97b22446453f3e4fa09135e1a44135ecfe8
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Honor device-specific ACS redirection
> 
> This commit updates PCI P2PDMA to respect device-specific ACS redirection
> quirks for switches and ports that redirect peer-to-peer traffic without a
> standard ACS capability. It queries quirks to set Request and Completion
> Redirect flags and modifies how affected ports are warned about.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 45260423dfb09..ba94b0f339285 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> [ ... ]
> > @@ -782,15 +867,8 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
> >  		goto done;
> >  	}
> >  
> > -	if (verbose) {
> > -		/* Drop the final semicolon; the list is not empty here */
> > -		if (!seq_buf_has_overflowed(&acs_list))
> > -			acs_list.buffer[acs_list.len - 1] = '\0';
> > -		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
> > -			 pci_name(provider));
> > -		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> > -			 seq_buf_str(&acs_list));
> > -	}
> > +	if (verbose)
> > +		pci_p2pdma_warn_redir(client, provider, &acs_list, &quirk_list);
> >  
> >  map_through_host_bridge:
> >  	if (!cpu_supports_p2pdma() &&
> 
> [Severity: High]
> Does calling xa_store() further down in this function risk a deadlock?

Not in the current code base, I failed to find any reliable path for it.

Thanks
