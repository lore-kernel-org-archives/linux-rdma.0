Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C21134CCF;
	Tue,  6 Oct 2026 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791323342; cv=none; b=rtyBuGrMEsoFU5mJZIfvYgwBTtchWeYFwI8eqhHdUUKKUHGriYvx8ztFv6+UGM5hTH0V/894p6OgQVTTsbP3PDdjEgI46/qgpBxJiSFaa3X/9FAnUVCVvYNlprp1Z3WPds3v0GOOh4PJ9C2+JUk/TRXpME06YVtcGEEdlHUVP/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791323342; c=relaxed/simple;
	bh=9/kIwIroF3I78IKmLSDuil+2CDGn0X72S83yzgqd7/g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BSrlAfsrj0OZzKhi+9OpUllWeFarU8x9UB+jQTvhZ2WIwQd/VIFRI2bUDYmExoN0ag1FyUBK9eftNG4SJsgiO7d/QA5VsMOJKkBsyIrinEv0lp+7mc4kEgL1g58kFTT1A34o3M8A8pymts5eNLWqFfhxBEn1bvowM5d2MXUqJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5v2niIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5v2niIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35B91F0089B;
	Tue,  6 Oct 2026 21:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791323340;
	bh=DOWWt1KJLFYMrWcgT4FQO58tS9UYRaxA2t0lKYqxiTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Q5v2niIJ5LRiKoDFZltL3IbLPktOJr5pP30s5DSLcbt7GSEtaOrjaS2MbGXva/rHo
	 QphiZGiboKLj+JYKWvdvZpAQTI1HZk7dqUpSR/BsyAJVl8JlvzTyBSdXtc0qxOSAcP
	 UJTUQDck9g0spi4EUe2Cg6f0RMqY//NeuZoQxvXlx5fsAMPtQY3ETYBtdfyd82pqd5
	 17Tyk3Zpyh8Smibz0CdsEbfty1JqfiHQogouoEZZnJilPhni1gh7ZN5IwXEFOcsHz5
	 xpn7wVe6vIYIfBKbZXDwfXxj3/7Nfo9zSphjycYssaD1pFvLPuV7NEvEe/THhy/u8k
	 rlMDKf7O8JzeA==
Date: Tue, 6 Oct 2026 16:48:58 -0500
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
Subject: Re: [PATCH v9 06/18] PCI/P2PDMA: Collect the path's ACS controls
 before deciding
Message-ID: <20261006214858.GA717151@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-6-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:14PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> calc_map_type_and_dist() reads each divergence port's ACS Control register
> and folds the result into running counters as it goes. Any routing property
> that depends on the kind of TLP being routed would have to be threaded
> through that code, so there is nowhere to put one without reading the
> registers again for each kind.

What is the "one" that there's nowhere to put?  I guess the routing
property?  So this is an optimization to avoid some config reads?

> Collect the two ports' ACS Control values into struct pci_p2pdma_acs_path
> first, then decide from it. pci_p2pdma_route() applies the same rule as
> before: a path routes directly only when both directions do.
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c | 148 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 96 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 550e6c7346ef..841c86be31bb 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -553,6 +553,80 @@ static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
>  	seq_buf_printf(buf, "%s;", pci_name(pdev));
>  }
>  
> +/*
> + * What the topology walk found out about one provider/client path. Producing
> + * this costs a walk and one config read per divergence port, none of which
> + * depends on the TLP being routed.
> + *
> + * @req_ctrl:	ACS Control of the client-side divergence port. That is the
> + *		first port at which a Request can route toward the peer rather
> + *		than upstream, so it is where the Request controls apply.
> + * @cpl_ctrl:	ACS Control of the provider-side divergence port, likewise for
> + *		the Completions travelling back.
> + * @unreadable:	First port whose ACS Control could not be read, if any.
> + */
> +struct pci_p2pdma_acs_path {
> +	u16 req_ctrl;
> +	u16 cpl_ctrl;
> +	struct pci_dev *unreadable;
> +};
> +
> +/*
> + * Combine both directions into a mapping type. Only a path that routes the
> + * Request and the Completions it generates directly can be programmed with
> + * the peer's bus addresses.
> + */
> +static enum pci_p2pdma_map_type
> +pci_p2pdma_route(const struct pci_p2pdma_acs_path *path)
> +{
> +	if (path->unreadable)
> +		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +
> +	if (pci_acs_p2pdma_request(path->req_ctrl) == PCI_ACS_P2PDMA_DIRECT &&
> +	    pci_acs_p2pdma_completion(path->cpl_ctrl) == PCI_ACS_P2PDMA_DIRECT)
> +		return PCI_P2PDMA_MAP_BUS_ADDR;
> +
> +	return PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
> +}
> +
> +/*
> + * Name the ports that keep this path off a direct route, so that the admin
> + * can hand them to pci=disable_acs_redir=.
> + */
> +static void pci_p2pdma_warn_path(struct pci_dev *client,
> +				 struct pci_dev *provider,
> +				 const struct pci_p2pdma_acs_path *path,
> +				 struct pci_dev *a_child,
> +				 struct pci_dev *b_child)
> +{
> +	struct seq_buf acs_list;
> +	char buf[128];
> +
> +	if (path->unreadable) {
> +		pci_warn(client,
> +			 "ACS Control is unreadable for provider %s at %s\n",
> +			 pci_name(provider), pci_name(path->unreadable));
> +		return;
> +	}
> +
> +	seq_buf_init(&acs_list, buf, sizeof(buf));
> +	if (pci_acs_p2pdma_completion(path->cpl_ctrl) != PCI_ACS_P2PDMA_DIRECT)
> +		seq_buf_print_bus_devfn(&acs_list, a_child);
> +	if (pci_acs_p2pdma_request(path->req_ctrl) != PCI_ACS_P2PDMA_DIRECT)
> +		seq_buf_print_bus_devfn(&acs_list, b_child);
> +
> +	/* Drop the final semicolon; the list is not empty here. */
> +	if (!seq_buf_has_overflowed(&acs_list))
> +		acs_list.buffer[acs_list.len - 1] = '\0';
> +
> +	pci_warn(client,
> +		 "ACS redirect is set between the client and provider (%s)\n",
> +		 pci_name(provider));
> +	pci_warn(client,
> +		 "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> +		 seq_buf_str(&acs_list));
> +}
> +
>  static bool cpu_supports_p2pdma(void)
>  {
>  #ifdef CONFIG_X86
> @@ -751,19 +825,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		int *dist, bool verbose)
>  {
>  	enum pci_p2pdma_map_type map_type = PCI_P2PDMA_MAP_THRU_HOST_BRIDGE;
> -	enum pci_acs_p2pdma_state state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
>  	struct pci_dev *a = provider, *b = client, *bb;
>  	struct pci_dev *a_child = NULL, *b_child = NULL;
> -	struct pci_dev *acs_unreadable = NULL;
> +	struct pci_p2pdma_acs_path path = {};
>  	struct pci_p2pdma *p2pdma;
> -	struct seq_buf acs_list;
> -	int acs_redirect_cnt = 0;
> +	bool cpu_p2pdma, host_whitelisted = false;
>  	int dist_a = 0;
>  	int dist_b = 0;
> -	char buf[128];
> -	u16 ctrl;
> -
> -	seq_buf_init(&acs_list, buf, sizeof(buf));
>  
>  	/*
>  	 * Note, we don't need to take references to devices returned by
> @@ -806,61 +874,35 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  	 * branch is upstream, so redirect controls do not affect the path.
>  	 */
>  	if (a_child && b_child) {
> -		if (pci_acs_p2pdma_ctrl(a_child, &ctrl))
> -			state = pci_acs_p2pdma_completion(ctrl);
> -		if (state != PCI_ACS_P2PDMA_DIRECT) {
> -			seq_buf_print_bus_devfn(&acs_list, a_child);
> -			if (state == PCI_ACS_P2PDMA_REDIRECT)
> -				acs_redirect_cnt++;
> -			else if (!acs_unreadable)
> -				acs_unreadable = a_child;
> -		}
> -
> -		state = PCI_ACS_P2PDMA_NOT_SUPPORTED;
> -		if (pci_acs_p2pdma_ctrl(b_child, &ctrl))
> -			state = pci_acs_p2pdma_request(ctrl);
> -		if (state != PCI_ACS_P2PDMA_DIRECT) {
> -			seq_buf_print_bus_devfn(&acs_list, b_child);
> -			if (state == PCI_ACS_P2PDMA_REDIRECT)
> -				acs_redirect_cnt++;
> -			else if (!acs_unreadable)
> -				acs_unreadable = b_child;
> -		}
> +		if (!pci_acs_p2pdma_ctrl(a_child, &path.cpl_ctrl))
> +			path.unreadable = a_child;
> +		if (!pci_acs_p2pdma_ctrl(b_child, &path.req_ctrl) &&
> +		    !path.unreadable)
> +			path.unreadable = b_child;
>  	}
>  
>  	/*
>  	 * Below a shared upstream bridge, a path whose divergence ports do not
>  	 * redirect routes the request directly.
>  	 */
> -	if (!acs_unreadable && !acs_redirect_cnt) {
> -		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
> +	map_type = pci_p2pdma_route(&path);
> +	if (map_type == PCI_P2PDMA_MAP_BUS_ADDR)
>  		goto done;
> -	}
>  
> -	if (verbose) {
> -		/* Drop the final semicolon; the list is not empty here. */
> -		if (!seq_buf_has_overflowed(&acs_list))
> -			acs_list.buffer[acs_list.len - 1] = '\0';
> -		if (acs_unreadable)
> -			pci_warn(client, "ACS Control is unreadable for provider %s at %s\n",
> -				 pci_name(provider), pci_name(acs_unreadable));
> -		else {
> -			pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
> -				 pci_name(provider));
> -			pci_warn(client, "to disable ACS controls for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
> -				 seq_buf_str(&acs_list));
> -		}
> -	}
> +	if (verbose)
> +		pci_p2pdma_warn_path(client, provider, &path, a_child, b_child);
>  
>  	/* An unreadable control does not establish an upstream redirect. */
> -	if (acs_unreadable) {
> -		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +	if (path.unreadable)
>  		goto done;
> -	}
>  
>  map_through_host_bridge:
> -	if (!cpu_supports_p2pdma() &&
> -	    !host_bridge_whitelist(provider, client, verbose)) {
> +	cpu_p2pdma = cpu_supports_p2pdma();
> +	if (!cpu_p2pdma)
> +		host_whitelisted = host_bridge_whitelist(provider, client,
> +							  verbose);
> +
> +	if (!cpu_p2pdma && !host_whitelisted) {
>  		if (verbose)
>  			pci_warn(client, "cannot be used for peer-to-peer DMA as the client and provider (%s) do not share an upstream bridge or whitelisted host bridge\n",
>  				 pci_name(provider));
> @@ -1193,8 +1235,9 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
>  {
>  	enum pci_p2pdma_map_type type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	struct pci_dev *pdev = to_pci_dev(provider->owner);
> -	struct pci_dev *client;
>  	struct pci_p2pdma *p2pdma;
> +	unsigned long cache_index;
> +	struct pci_dev *client;
>  	int dist;
>  
>  	if (!pdev->p2pdma)
> @@ -1204,13 +1247,14 @@ enum pci_p2pdma_map_type pci_p2pdma_map_type(struct p2pdma_provider *provider,
>  		return PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  
>  	client = to_pci_dev(dev);
> +	cache_index = map_types_idx(client);
>  
>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(pdev->p2pdma);
>  
>  	if (p2pdma)
>  		type = xa_to_value(xa_load(&p2pdma->map_types,
> -					   map_types_idx(client)));
> +					   cache_index));
>  	rcu_read_unlock();
>  
>  	if (type == PCI_P2PDMA_MAP_UNKNOWN)
> 
> -- 
> 2.55.0
> 
