Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F1845563B;
	Tue,  6 Oct 2026 21:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320933; cv=none; b=sBemznu8pfn5XVndMP6Zr7XFkibLE+r4hmZtLVYFZsQiNhlsVvKdP+fPzzZVp9S/xkJx12dfRsyGZ6MiPU8hA7AecP+e3aCWZ2yP/eyqfUBGmXnn4gikg0XufzguTB7g9PwrFUpCx/bR95wM88ip//ldgFI4Rt4ydRH+6mfsTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320933; c=relaxed/simple;
	bh=A5NMQcG6KYExAZ+R0eAkPUOERfHBJAtudPnbnuIDu6A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=rMpckxsJoMbI9Wa2uA2rqk4Ql2KNJtB2z6pRGQ1xZoy4F8giFBfKRpnemQIDpFIKD+nmkb9kYanPJcdgBskqfAfOazUCAuHjJoc+8jwwxhLA8tmz/OECdPIa0oUypTq+tcdcVw0QO711HqVCy4yV3L93FNxvoLmN32z9P08HwqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmHdlxOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmHdlxOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18851F0089B;
	Tue,  6 Oct 2026 21:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791320929;
	bh=0UqLDiL9RBkK//dPGDGUk1znlzLzG8ly7edRErfMKFM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=WmHdlxOuibxg1xAOVGsQJ6dxM6DrmLSPVOc4NwXwKFtxvoOgwjEJBo/oNNx0XEA4E
	 lW6BljbKtN6nFNu13HXz5jqwIl0+QgCxh6m5bPWWEpM5FjGxWahFvHFeWjD5fKSJeo
	 SCGA/bg7h43Xfm2Hx0QNbnuEhug5nM7Xhr/ZVCVjkwqDkFu0/4Ujm2F8pOitqaJFEp
	 f76WX+5ehGkRSlOk/skcKRW4xFegkBg7xE9fpcFikucDzXj1qaTHOb9knHCoC5RyvS
	 7ULExcFAoZrWg7RDqKj06x43NSe9OroGjuvH8oESAQELfEuKZ6vcBvS3vPqBgINOTf
	 SD5kRhJhkiXWg==
Date: Tue, 6 Oct 2026 16:08:48 -0500
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
Subject: Re: [PATCH v9 04/18] PCI/P2PDMA: Evaluate ACS controls at the path
 divergence
Message-ID: <20261006210848.GA712422@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-4-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:12PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ACS redirect controls choose between peer and upstream routes only at the
> path divergence. Applying them below that point rejects valid nested
> topologies because traffic already has only an upstream route.

I guess the point here is that prior to this patch,
calc_map_type_and_dist() returned PCI_P2PDMA_MAP_NOT_SUPPORTED in a
case where it didn't need to?  Can you include an example to make this
concrete?

It looks like in v7.3, we only return PCI_P2PDMA_MAP_NOT_SUPPORTED if
a TLP has to go through a host bridge.  Do we mistakenly assume that
if a bridge has PCI_ACS_RR set, a Request must go all the way to the
host bridge, even if a bridge closer to the root does not have
PCI_ACS_RR set?

> Evaluate Request controls on the client-side divergence port and Completion
> Redirect on the provider-side port and reject an unreadable ACS Control
> register.
> 
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c       | 101 +++++++++++++++++++++++++++++----------------
>  include/linux/pci-p2pdma.h |   8 ++--
>  2 files changed, 70 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 12612b82d80d..550e6c7346ef 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -493,6 +493,7 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
>  }
>  
>  enum pci_acs_p2pdma_state {
> +	PCI_ACS_P2PDMA_NOT_SUPPORTED,
>  	PCI_ACS_P2PDMA_DIRECT,
>  	PCI_ACS_P2PDMA_REDIRECT,
>  };
> @@ -730,13 +731,13 @@ static unsigned long map_types_idx(struct pci_dev *client)
>   * then to Device B. The mapping type returned depends on the ACS
>   * redirection setting of the ports along the path.
>   *
> - * The client initiates Requests to provider memory. Check Request Redirect
> - * on the client path and Completion Redirect for read Completions on the
> - * provider path.
> + * The client initiates Requests to provider memory. At the path divergence,
> + * check Request Redirect and Egress Control on the client-side port, and
> + * Completion Redirect for read Completions on the provider-side port.
>   *
> - * If ACS redirect is set on any port in the path, traffic between the
> - * devices will go through the host bridge, so return
> - * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
> + * If ACS redirects traffic at either divergence port, return
> + * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE. If the ACS Control register cannot be
> + * read, return PCI_P2PDMA_MAP_NOT_SUPPORTED. Otherwise, return
>   * PCI_P2PDMA_MAP_BUS_ADDR.
>   *
>   * Any two devices that have a data path that goes through the host bridge
> @@ -750,10 +751,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		int *dist, bool verbose)
>  {
>  	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
> +	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
>  	struct pci_dev *a = provider, *b = client, *bb;
> +	struct pci_dev *a_child = NULL, *b_child = NULL;
> +	struct pci_dev *acs_unreadable = NULL;
>  	struct pci_p2pdma *p2pdma;
>  	struct seq_buf acs_list;
> -	int acs_cnt = 0;
> +	int acs_redirect_cnt = 0;
>  	int dist_a = 0;
>  	int dist_b = 0;
>  	char buf[128];
> @@ -768,51 +772,67 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  	 */
>  	while (a) {
>  		dist_b = 0;
> -
> -		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
> -		    pci_acs_p2pdma_completion(ctrl) ==
> -			    PCI_ACS_P2PDMA_REDIRECT) {
> -			seq_buf_print_bus_devfn(&acs_list, a);
> -			acs_cnt++;
> -		}
> -
> +		b_child = NULL;
>  		bb = b;
>  
>  		while (bb) {
>  			if (a == bb)
> -				goto check_b_path_acs;
> +				goto check_paths_acs;
>  
> +			b_child = bb;
>  			bb = pci_upstream_bridge(bb);
>  			dist_b++;
>  		}
>  
> +		a_child = a;
>  		a = pci_upstream_bridge(a);
>  		dist_a++;
>  	}
>  
> +	/*
> +	 * The paths share no upstream bridge, so there is no direct path for
> +	 * ACS to gate: PCI_P2PDMA_MAP_BUS_ADDR is not reachable here and the
> +	 * request can only get to the peer through the host bridge.
> +	 */
>  	*dist = dist_a + dist_b;
>  	goto map_through_host_bridge;
>  
> -check_b_path_acs:
> -	bb = b;
> -
> -	while (bb) {
> -		if (a == bb)
> -			break;
> +check_paths_acs:
> +	*dist = dist_a + dist_b;
>  
> -		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
> -		    pci_acs_p2pdma_request(ctrl) ==
> -			    PCI_ACS_P2PDMA_REDIRECT) {
> -			seq_buf_print_bus_devfn(&acs_list, bb);
> -			acs_cnt++;
> +	/*
> +	 * ACS P2P routing controls apply where a TLP can route toward the peer
> +	 * or upstream. Below that divergence, its only route toward the other
> +	 * branch is upstream, so redirect controls do not affect the path.
> +	 */
> +	if (a_child && b_child) {
> +		if (pci_acs_p2pdma_ctrl(a_child, &ctrl))
> +			state = pci_acs_p2pdma_completion(ctrl);
> +		if (state != PCI_ACS_P2PDMA_DIRECT) {
> +			seq_buf_print_bus_devfn(&acs_list, a_child);
> +			if (state == PCI_ACS_P2PDMA_REDIRECT)
> +				acs_redirect_cnt++;
> +			else if (!acs_unreadable)
> +				acs_unreadable = a_child;
>  		}
>  
> -		bb = pci_upstream_bridge(bb);
> +		state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
> +		if (pci_acs_p2pdma_ctrl(b_child, &ctrl))
> +			state = pci_acs_p2pdma_request(ctrl);
> +		if (state != PCI_ACS_P2PDMA_DIRECT) {
> +			seq_buf_print_bus_devfn(&acs_list, b_child);
> +			if (state == PCI_ACS_P2PDMA_REDIRECT)
> +				acs_redirect_cnt++;
> +			else if (!acs_unreadable)
> +				acs_unreadable = b_child;
> +		}
>  	}
>  
> -	*dist = dist_a + dist_b;
> -
> -	if (!acs_cnt) {
> +	/*
> +	 * Below a shared upstream bridge, a path whose divergence ports do not
> +	 * redirect routes the request directly.
> +	 */
> +	if (!acs_unreadable && !acs_redirect_cnt) {
>  		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
>  		goto done;
>  	}
> @@ -821,10 +841,21 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		/* Drop the final semicolon; the list is not empty here. */
>  		if (!seq_buf_has_overflowed(&acs_list))
>  			acs_list.buffer[acs_list.len - 1] = '\0';
> -		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
> -			 pci_name(provider));
> -		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> -			 seq_buf_str(&acs_list));
> +		if (acs_unreadable)
> +			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
> +				 pci_name(provider), pci_name(acs_unreadable));
> +		else {
> +			pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
> +				 pci_name(provider));
> +			pci_warn(client, "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> +				 seq_buf_str(&acs_list));
> +		}
> +	}
> +
> +	/* An unreadable control does not establish an upstream redirect. */
> +	if (acs_unreadable) {
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +		goto done;
>  	}
>  
>  map_through_host_bridge:
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 873de20a2247..dd17501ba1b6 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -42,10 +42,10 @@ enum pci_p2pdma_map_type {
>  	PCI_P2PDMA_MAP_NONE,
>  
>  	/*
> -	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates the transaction will
> -	 * traverse the host bridge and the host bridge is not in the
> -	 * allowlist. DMA Mapping routines should return an error when
> -	 * this is returned.
> +	 * PCI_P2PDMA_MAP_NOT_SUPPORTED: Indicates no safe mapping is available,
> +	 * for example because ACS blocks the direct path or the required host
> +	 * bridge is not in the allowlist. DMA Mapping routines should return an
> +	 * error when this is returned.
>  	 */
>  	PCI_P2PDMA_MAP_NOT_SUPPORTED,
>  
> 
> -- 
> 2.55.0
> 
