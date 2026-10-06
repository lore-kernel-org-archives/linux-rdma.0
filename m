Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237DC286D70;
	Tue,  6 Oct 2026 20:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319790; cv=none; b=s5H9oQbpbZoHjOwRQxv4GcHQrt8F+sYtOrVarV7USgleEEMOqwd3WWfc+EBGIQLHgABiacm4VOOcozfBd4ARLnB63/KxAntDU/DBZDCnhdsF2f7aWAhTZPYRQFh8g859m+CvwbeVMA5y4418ijjEkDj4JrSj5RIwHxgydAdl01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319790; c=relaxed/simple;
	bh=CdBZo7dAD6w8z0zdZMujPTtr/0tsxGD7fufPM7H3/9A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Zg4hQodGt9JVUkgRLdJOCsSt02/XvhOepDIyQTVtGkZC5vVk9+RDGhSGn1IVsWDPC3uV5OocCFn+vyhr/tVGLzGKbcoiWe+d94l8pdcNi0Bh5mZGxRCZngPfFMZJYhZxJFcj8Jp8CXVfwAEvX5jeEtU3hdohqkuSUkxMMry+lmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED/Eg9fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED/Eg9fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEE11F0089B;
	Tue,  6 Oct 2026 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791319788;
	bh=n1jIlLDVhEwFYQay6yaey3Xrl4lCWZyVE+tBuM4GUdY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=ED/Eg9fwW7atMhGUfk1Pv1orH+H+fvTLcL4v4uwRtk6qDEigqQ2fvGPFTyCMA8g9J
	 wczLoxgzCPvRktsmIDJf7ZgQontEyJzkFFeZGTsNfYs70KK8B3zrHNVInfZ1y48IPO
	 xyk2IiSFTFtxKiNse9K+fqcKDRuudbwamcQKPf6iO2vWwgzAOgY0zgagVb+Xk5ETaX
	 4tfHC/DUYljpQ2Pu6Q13f0IKFF6gDTpOcX2cUQnQXUMH8tvplp4LpRDC7RBbeq7+it
	 HrujV2BeRmvuKJIjiWu2jWMRNxweKoUGOojw20Qxk9jWlUAfb5kCCuF8ca5KgthW/0
	 X9Q2SeTdjdvFw==
Date: Tue, 6 Oct 2026 15:49:47 -0500
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
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20261006204947.GA708098@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-2-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.

Does "the reverse TLP direction" refer to Completions?

> Evaluate Request Redirect for client Requests and Completion Redirect for
> provider read Completions. Continue treating enabled Egress Control
> conservatively as a Request redirect.

Completion Redirect is intended to avoid ordering rule violations
between Completions and Requests when Requests are redirected (PCIe
r7.0, sec 6.12.1.1).  I assume this patch preserves the ordering rule,
but does the commit log need to say something about that?  I don't
know enough about P2P DMA for it to be obvious to me.

Not really a question for this series, but p2pdma.c and p2pdma.rst
refer to "clients" and "providers", neither of which are mentioned in
the PCIe spec.  In this case it sounds like a client is a Requester
and a provider is a Completer in spec terms.  Is that always the case?
If so, "client" and "provider" in this paragraph are not adding any
information.

If "client" is not the same concept as "Requester" and "provider" not
the same as "Completer", maybe p2pdma.rst could explain the
difference?

> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c | 75 ++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 58 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 4e4d2df17a45..12612b82d80d 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -21,6 +21,8 @@
>  #include <linux/seq_buf.h>
>  #include <linux/xarray.h>
>  
> +#include "pci.h"
> +
>  struct pci_p2pdma {
>  	struct gen_pool *pool;
>  	bool p2pmem_published;
> @@ -490,26 +492,56 @@ static struct pci_dev *find_parent_pci_dev(struct device *dev)
>  	return NULL;
>  }
>  
> +enum pci_acs_p2pdma_state {
> +	PCI_ACS_P2PDMA_DIRECT,
> +	PCI_ACS_P2PDMA_REDIRECT,
> +};
> +
>  /*
> - * Check if a PCI bridge has its ACS redirection bits set to redirect P2P
> - * TLPs upstream via ACS. Returns 1 if the packets will be redirected
> - * upstream, 0 otherwise.
> + * Decide how a peer-to-peer Request at an ACS-capable ingress port routes,
> + * from that port's ACS Control register.
> + *
> + * Linux does not read the Egress Control Vector, so Egress Control is treated
> + * conservatively as a redirect. Per PCIe r7.0 Table 6-11 the outcomes it
> + * selects are a direct route and an ACS Violation, and neither one lets peer
> + * bus addressing be assumed.
>   */
> -static int pci_bridge_has_acs_redir(struct pci_dev *pdev)
> +static enum pci_acs_p2pdma_state
> +pci_acs_p2pdma_request(u16 ctrl)
>  {
> -	int pos;
> -	u16 ctrl;
> +	return ctrl & (PCI_ACS_RR | PCI_ACS_EC) ?
> +		PCI_ACS_P2PDMA_REDIRECT : PCI_ACS_P2PDMA_DIRECT;
> +}
>  
> -	pos = pdev->acs_cap;
> -	if (!pos)
> -		return 0;
> +/*
> + * Decide how a peer-to-peer Completion at an ACS-capable ingress port routes.
> + * PCIe r7.0 sec 6.12.1.1: no ACS control other than P2P Completion Redirect
> + * affects a Completion.
> + */
> +static enum pci_acs_p2pdma_state
> +pci_acs_p2pdma_completion(u16 ctrl)
> +{
> +	return ctrl & PCI_ACS_CR ? PCI_ACS_P2PDMA_REDIRECT :
> +				   PCI_ACS_P2PDMA_DIRECT;
> +}
>  
> -	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
> +/*
> + * Read @pdev's ACS Control register. A device without an ACS capability has
> + * no peer-to-peer controls at all, which routes the same as having them all
> + * clear. Returns false when the register is present but cannot be read; @ctrl
> + * is then meaningless.
> + */
> +static bool pci_acs_p2pdma_ctrl(struct pci_dev *pdev, u16 *ctrl)
> +{
> +	int pos;
>  
> -	if (ctrl & (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC))
> -		return 1;
> +	pos = pdev->acs_cap;
> +	if (!pos) {
> +		*ctrl = 0;
> +		return true;
> +	}
>  
> -	return 0;
> +	return !pci_read_config_word(pdev, pos + PCI_ACS_CTRL, ctrl);
>  }
>  
>  static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
> @@ -698,6 +730,10 @@ static unsigned long map_types_idx(struct pci_dev *client)
>   * then to Device B. The mapping type returned depends on the ACS
>   * redirection setting of the ports along the path.
>   *
> + * The client initiates Requests to provider memory. Check Request Redirect
> + * on the client path and Completion Redirect for read Completions on the
> + * provider path.
> + *
>   * If ACS redirect is set on any port in the path, traffic between the
>   * devices will go through the host bridge, so return
>   * PCI_P2PDMA_MAP_THRU_HOST_BRIDGE; otherwise return
> @@ -721,6 +757,7 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  	int dist_a = 0;
>  	int dist_b = 0;
>  	char buf[128];
> +	u16 ctrl;
>  
>  	seq_buf_init(&acs_list, buf, sizeof(buf));
>  
> @@ -732,7 +769,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  	while (a) {
>  		dist_b = 0;
>  
> -		if (pci_bridge_has_acs_redir(a)) {
> +		if (!pci_acs_p2pdma_ctrl(a, &ctrl) ||
> +		    pci_acs_p2pdma_completion(ctrl) ==
> +			    PCI_ACS_P2PDMA_REDIRECT) {
>  			seq_buf_print_bus_devfn(&acs_list, a);
>  			acs_cnt++;
>  		}
> @@ -761,7 +800,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		if (a == bb)
>  			break;
>  
> -		if (pci_bridge_has_acs_redir(bb)) {
> +		if (!pci_acs_p2pdma_ctrl(bb, &ctrl) ||
> +		    pci_acs_p2pdma_request(ctrl) ==
> +			    PCI_ACS_P2PDMA_REDIRECT) {
>  			seq_buf_print_bus_devfn(&acs_list, bb);
>  			acs_cnt++;
>  		}
> @@ -1109,10 +1150,10 @@ EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
>  /**
>   * pci_p2pdma_map_type - Determine the mapping type for P2PDMA transfers
>   * @provider: P2PDMA provider structure
> - * @dev: Target device for the transfer
> + * @dev: Client device that initiates the transfer
>   *
>   * Determines how peer-to-peer DMA transfers should be mapped between
> - * the provider and the target device. The mapping type indicates whether
> + * the provider and the client device. The mapping type indicates whether
>   * the transfer can be done directly through PCI switches or must go
>   * through the host bridge.
>   */
> 
> -- 
> 2.55.0
> 
