Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC446D555;
	Wed, 14 Oct 2026 06:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791960658; cv=none; b=uJvLyoYppeFkKfxB/b0QaSSs/Rxz1UEAE8pVfjJB9BVfGGoZE54tfWQdKEr5Ex1FT5OStkQMBV4nvix4rOnFHFgDk27lsfHtL96mFo+c3JNmTnnTn3uSKJVqSQT+G4mjtburPHsYiNTtYUf/3U42ElswRYfMLqsgHcz+DC1IkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791960658; c=relaxed/simple;
	bh=RtL5f3/xfkbwf3PgcHK/lFdSYayMDKGyF+DgU7ozY2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIdfP4bTVSn2epZBJ9nqzwpUgVRiANi1F1Dqud75Ex6fEC/FKwgh8idshqXEcb3gEcC5qMwaocNetPzbbFj5I/O4LMzKTWdq773xom3FVw2LJGeceZ3Vm7TPQoos+S+1Qfk2FmPoD8XtJo/1M5olzElksHtS0HQEI+30rGvzBl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiTD6qvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiTD6qvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7E61F000FF;
	Wed, 14 Oct 2026 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791960655;
	bh=bV1zn0uXJvtOvThcSa3dCZxRP7Qp0g86hwJjMMOUPco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QiTD6qvzbvE2rgpkA4tjnmGVYiZVi8I5Vkvp2eFVw44MBwb94b3fBr8mcJE6Xsf+i
	 sdI8HB3RxYk8MFFDg9ofDZxxpkT5vmYD7BWLXpz6hW3fxXCpGjYc/pJaigtB95TJWC
	 Dqc34R6sX/hg8C9RPL4gUjc4sb0S+ykxGVPoSJGZeChOWejQA9Le8RSqM89NIMBCSL
	 HJhtRvcbnRIMDTzFzGojgCLPWedcFKiO4fG1R3ytySvPQAHn5VYWPCQgaqGK5XRPVi
	 umihsnuAMfutWFsctHa+o3LVdO+vJaYIAknYhMKaoIaEz4rObJi4xh1ohe0Yu7gSkl
	 ul5q7jUw8UU8w==
Date: Wed, 14 Oct 2026 09:50:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	media-ci@linuxtv.org
Subject: Re: [PATCH v11 10/19] PCI/P2PDMA: Reject Translated Requests blocked
 by Translation Blocking
Message-ID: <20261014065051.GV219304@unreal>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-10-72cf8c96e617@nvidia.com>
 <sashiko-outbox-169939@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-169939@kernel.org>

On Tue, Oct 13, 2026 at 02:49:05PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] pci/p2pdma: deadlock in calc_map_type_and_dist() due to non-IRQ-safe xa_store()
> --
> 
> commit f019da119f00a99a75cbfe2deec0db131a89232d
> Author: Leon Romanovsky <leon@kernel.org>
> 
> PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
>     
> ACS Translation Blocking rejects upstream Memory Requests with a Translated
> address before any peer-routing controls apply, per PCIe r7.0 sec 6.12.1.1.
> P2PDMA ignores that bit and can report a route whose ports reject the
> Requester's address type.
>     
> Add PCI_ACS_P2PDMA_BLOCKED and scan the ports traversed by each route. A
> direct route passes only ports below the divergence; a host-bridge route
> also passes the common port and its ancestors. Reject the affected class
> without falling back to another route, and preserve blocking precedence
> over internal-route restrictions.
> 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 785e4668a2af5..fc4dea28c8606 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> [ ... ]
> > @@ -1162,6 +1252,11 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
> >  		}
> >  	}
> >  
> > +	path.tb_on_path = pci_p2pdma_path_blocks_translation(client, a);
> > +	if (b_child)
> > +		path.tb_above_divergence =
> > +			pci_p2pdma_path_blocks_translation(b_child, NULL);
> > +
> >  	/*
> >  	 * The walk and the config reads above serve every class; only the
> >  	 * decision below depends on the kind of TLP being routed.
> 
> [Severity: High]
> Does xa_store() use an IRQ-safe lock here?

Same, this not-safe path is not taken in current codebase.

Thanks
