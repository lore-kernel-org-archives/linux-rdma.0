Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C24B44C7;
	Mon, 12 Oct 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791828500; cv=none; b=gDmazvVzbAWiPBQls7qsGl9pQvfc1JMTMtQ32Uhh8nuaihWImUe/irpvTGMXXOuCTgsy91cAi8kczHMI6hH5KKCULnjexYhw0vRHKVrf4Ra1o5zbDE4EPYWB7GG8RPWfqsZtmFcdHG8FFLIdtnce5N5y0udBwgpfGJ7KgSMF0Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791828500; c=relaxed/simple;
	bh=dsWGzcaV65hPX0Jv8TnHyGTn8G4TDRaclE2SMbj2a2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4Afl78fWxN19PEJ8CmOB7O33H+CfMotvm6srgL9Mf4smIeRTTpjpPOI+RFARhblinefPzuKUzEzXC1UtM/aglIlaw0So4tzZAhpBH3IGnSakdPe5WxTWw7Jc7feEFEpnh12Zxf43pWHvmQqPI9NWPivFzUeJOXGLDHqKPfDEq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMGkuOuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMGkuOuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077291F0089B;
	Mon, 12 Oct 2026 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791828498;
	bh=3Wli0lXL90p/q6Zd9jQ+LYY2qQ0nlHmU0EB751vWIvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fMGkuOuA3HU0J2PUfACwqrLFc+hgMOiO+i+u8Svb2tKub0WK8gV8k05j4iY+pS7qE
	 EXoj2YjTUxO5M1xmqx2o8vDpWs66kAxY1FjO0y/DzxNFg0MOssq+btJLsm9Mguxt/0
	 FL6F0VAWBH1pqVUq4hMYZjq/L/dbREWmsLerVdme0SoCdHE3BOQ4bsdCR2AtHpkPpR
	 r+RfomPlMoTL187ySIPYb8PS/3ujv3L+kcjIi30RYNeyFI9zjOq+i/AArNb77EA2MS
	 zuiPmsJE7LMu8sWqmXc/yj52mbp19oPs2yHz2w8uRsDfcOg6G0jagvTgh9siQageES
	 p+uBEmUK6PtDg==
Date: Mon, 12 Oct 2026 21:08:13 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: media-ci@linuxtv.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v10 17/18] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Message-ID: <20261012180813.GI219304@unreal>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-17-6ffe7b7a4517@nvidia.com>
 <sashiko-outbox-168177@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-168177@kernel.org>

On Mon, Oct 12, 2026 at 01:27:12PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] pci: pci_p2pdma_distance_many() evaluates compatibility without applying client ATS constraints
> --
> 
> commit 254b102fe424913edc3d5f94f8d41bc5d0de2b20
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
> 
> P2PDMA assumes every client issues Untranslated Requests. A device with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests on
> a route the Untranslated answer called usable.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index e38081f797611..a5fc622e3114f 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> 
> [ ... ]
> 
> > @@ -1660,10 +1706,10 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
> >  		 pci_p2pdma_map_type_name(type), type, provider_state);
> >  
> >  	if (type == PCI_P2PDMA_MAP_UNKNOWN)
> > -		return calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
> > +		type = calc_map_type_and_dist(pdev, client, &dist, tlp_flags,
> >  					      true);
> >  
> > -	return type;
> > +	return pci_p2pdma_client_map_type(pdev, client, per_mapping, type);
> >  }
> 
> [Severity: High]
> Does pci_p2pdma_distance_many() also need to apply these new ATS constraints?
> 
> While this patch successfully updates pci_p2pdma_map_type_tlp() to evaluate ATS
> routing constraints for P2PDMA clients, pci_p2pdma_distance_many() continues
> to evaluate mapping compatibility without them:
> 
> drivers/pci/p2pdma.c:pci_p2pdma_distance_many() {
>     ...
> 		pci_client = find_parent_pci_dev(clients[i]);
> 		if (!pci_client) {
>     ...
> 		map = calc_map_type_and_dist(provider, pci_client, &distance, 0,
> 					     verbose);
>     ...
> }
> 
> If a client has ATS enabled and its Untranslated route is usable but its
> Translated route is blocked by Translation Blocking (or lacks a whitelisted
> host bridge), pci_p2pdma_distance_many() evaluates the Untranslated mapping
> with tlp_flags=0, and incorrectly returns success. 
> 
> When the driver subsequently attempts to map memory, the ATS-aware mapping
> logic will return PCI_P2PDMA_MAP_NOT_SUPPORTED and fail unexpectedly at
> runtime, breaking the API contract of the distance validation.

Yes, Sashiko is right, I'll send new version :(.

Thanks

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=17
