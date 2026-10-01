Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8948B52759B;
	Thu,  1 Oct 2026 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868242; cv=none; b=tARM+F6vL7LwbNEocBwf01HiAPo466+mDDzx6FYNXRXoP5Mkfl3V+cfGpTgdzMIL0vw+sq4aBdxSkwKafa3LikspZy7iXyNE9yS8UdHijgXWGL7xFTMK+7iNNiXw/5aqSdCGmv3b7WchzlIn8mdMnxcydJPQvoJ+F+NbsEkiKEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868242; c=relaxed/simple;
	bh=qisIMv3sJpvvfRJBF+yt/t9IH4umJpP8BzRegAeHITk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lTS4ZO8oBsguMyxK+SLs54H8xxKQLrXbzM7QYRgSPWoPI99pox/M79Mb802iRuOgOjub+jpldTimxJOtR00lJEOV3cYk2lfngh9vONibw8Ux0/uM560qTnluthHOXreXe5oLxPZpNY2dm3eZfAM3EPnjWK628NVkttGnD8nKX18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKHEr+Q/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKHEr+Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090A01F000FF;
	Thu,  1 Oct 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868240;
	bh=u2Ft3FbFfr4tJ/bFZdJy0PXDor5ut/5iXgrR9l6rsPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WKHEr+Q/TULo60S7m4kSFKAMsAxsNLRf9p20X8KWtX2OrakXvwdbBi9nUWwW0a2YC
	 remeRO9qKeNQ6b7M+nk8n+TQKg2KnxQOjR2Ya/VxkjnCELMva434kMD9v+3or4+mzp
	 pihzuHWOq1tmhUis81VXca7bqmjlckVkWzJJEsxjs6HL1PoGQrKMU/pz7l/fb+6+bQ
	 zvf7bIXcfLupi/Oek4XmVP2yJC/cJAXZ4B8xZbDoHZCPuX+k6hwWFAyRJz/l0CAeTd
	 GGq4d92rNJC5fE693UvPoMEMercHMx6JCiCkcuT/pp/no5FSdbOVpFsiGz1ilIDVak
	 wHPM7eRgd/MgA==
Date: Thu, 1 Oct 2026 18:23:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v9 17/18] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Message-ID: <20261001152355.GN3401365@unreal>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-17-1a8e0f50ddd9@nvidia.com>
 <20261001120756.A5CC41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001120756.A5CC41F000FF@smtp.kernel.org>

On Thu, Oct 01, 2026 at 12:07:56PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] pci/p2pdma: pcim_p2pdma_set_ats_per_mapping() silently fails for pure clients
> --
> 
> commit 39432dea495f68fb0a21d0daa1f31ba24e130b39
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
> 
> P2PDMA assumes every client issues Untranslated Requests. A device with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests on
> a route the Untranslated answer called usable. This commit takes the
> Address Type from its ATS Enable bit and avoids handing such a client
> bus addresses unless the client declared per-mapping ATS.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 6a63901c65fb6..9c0943fdb3e36 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> [ ... ]
> > @@ -1633,6 +1674,9 @@ pci_p2pdma_map_type_tlp(struct p2pdma_provider *provider, struct device *dev,
> >  	cache_index = map_types_idx(client);
> >  
> >  	rcu_read_lock();
> > +	/* The declaration belongs to the client, the cache to the provider. */
> > +	p2pdma = rcu_dereference(client->p2pdma);
> > +	per_mapping = p2pdma && p2pdma->ats_per_mapping;
> 
> [Severity: High]
> Does this code handle pure P2PDMA clients correctly?
> 
> Since pure clients (devices initiating P2P transfers but not providing memory)
> have no mechanism or reason to call pcim_p2pdma_init(), client->p2pdma will
> be NULL for them.
> 
> This means when they call pcim_p2pdma_set_ats_per_mapping(), it silently returns
> and drops the configuration:
> 
> drivers/pci/p2pdma.c:pcim_p2pdma_set_ats_per_mapping() {
>     ...
> 	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
> 	if (!p2p)
> 		/*
> 		 * ats_per_mapping is a performance optimization,
> 		 ...
> 		 */
> 		return;
> 
> 	p2p->ats_per_mapping = true;
> }
> 
> Because client->p2pdma is NULL, per_mapping will always evaluate to false
> here in pci_p2pdma_map_type_tlp(). This leads to pci_p2pdma_client_map_type()
> incorrectly overriding the map type, which could return
> PCI_P2PDMA_MAP_NOT_SUPPORTED and break P2P transfers that should have been
> permitted.
> 
> How should pure clients register their ATS per-mapping capability if they
> do not initialize pdev->p2pdma?

I don't know there Sashiko gets these ideas, but no "pure client"
shouldn't call to pcim_p2pdma_set_ats_per_mapping().

Thanks

> 
> >  	p2pdma = rcu_dereference(pdev->p2pdma);
> >  
> >  	if (p2pdma)
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=17
