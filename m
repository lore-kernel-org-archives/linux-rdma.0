Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF73D411D;
	Tue,  6 Oct 2026 21:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791322330; cv=none; b=ATQAeH24Fa2+Z+b4RS7Jy7AS++qkh5DD83S8kNGpTFSi9aAFVLbzP5Iw6KQ0TYzmdsx1VkQGFkW+zs/4wO1b34ze2XQ7TjdbZjrbBshb2io8XyXnUduGovyfIWEFOTUyrMuZRl588wrIHGkkM12mWjISg8XovAoydZ2Dd3Fnib4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791322330; c=relaxed/simple;
	bh=bzfvYExlUeiBsAerby/OOOHUWMbab8lSYw8VKLITbAM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Y2dVDD/Aqx800TXv+6k/L4YafQ5l5VRh5by89jjQ04+FMVVTb2GkAMZGAhBN/HQ9fsHmpK7lL3C25tKDCE3uCFQcLlZz3FxygLpdEzrw0ZINC2Nt/RYXTG20AbXMkCkHGVek61iVQCO9u8xPer6V/Afy0KiIukVcnjccFT8rPDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mu7i09Li; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mu7i09Li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC151F0089C;
	Tue,  6 Oct 2026 21:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791322326;
	bh=lPh972gHXCkD0mD4dAGIvo5Eox0pSnObmtanCp/CfDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=mu7i09Lim4PhqcCC67x3w+Uluo0qAKUrEbAdFHhsvwu/V1lZt/aigzR71Q7rg0MsM
	 /ytWgZzcsJ2B/d/ZqhqjdyvErwMPeNzpxLNM/MnYYaW0tG2kndql6Axzjjt6SaD56H
	 Fbb3bMb3hBJ5bTMKUH/sLZ6iO4yKLkDMtqNd+HJ1S4KjfRaPsdr6I2wCOt22o+g6b6
	 vve7fEpP8DN40APkXPjDJskv4nsDESequYUBh23pdGNG/+bhPoXhOLWdAL+mKqB4N8
	 c+X4Kej0Ppf/y2Zdfa6mr29PUZyBUC6h+atz46KjE9/jhZ+z2J5j5J+fTg78F8ALm6
	 xv2T+A+ZSOT4A==
Date: Tue, 6 Oct 2026 16:32:05 -0500
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
Subject: Re: [PATCH v9 05/18] PCI/P2PDMA: Document directional ACS routing
Message-ID: <20261006213205.GA713622@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-5-1a8e0f50ddd9@nvidia.com>

On Thu, Oct 01, 2026 at 02:55:13PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> P2PDMA documentation describes ACS controls as path-wide, although Request
> and Completion controls apply to different transaction directions and only
> affect peer-versus-upstream decisions at the path divergence.
> 
> Document the fixed client and provider roles, the divergence port checked
> for each TLP direction, and the conservative handling of unreadable ACS
> state. Clarify which controls disable_acs_redir changes.
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 15 +++++++++------
>  Documentation/driver-api/pci/p2pdma.rst         | 13 +++++++++++++
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..bc83e07dd5fc 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5291,12 +5291,15 @@ Kernel parameters
>  		disable_acs_redir=<pci_dev>[; ...]
>  				Specify one or more PCI devices (in the format
>  				specified above) separated by semicolons.
> -				Each device specified will have the PCI ACS
> -				redirect capabilities forced off which will
> -				allow P2P traffic between devices through
> -				bridges without forcing it upstream. Note:
> -				this removes isolation between devices and
> -				may put more devices in an IOMMU group.
> +				Each device specified will have the PCI ACS P2P
> +				Request Redirect, Completion Redirect, and Egress
> +				Control features forced off. This may allow P2P
> +				traffic through bridges that would otherwise be
> +				redirected upstream. This may allow P2P traffic
> +				through bridges that would otherwise be redirected
> +				upstream and thus this removes isolation between
> +				devices and may cause affected devices to share
> +				an IOMMU group.
>  		config_acs=
>  				Format:
>  				<ACS flags>@<pci_dev>[; ...]
> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> index 80f8fec9b0e9..42b18610bf7d 100644
> --- a/Documentation/driver-api/pci/p2pdma.rst
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -15,6 +15,19 @@ then based on the ACS settings the transaction can route entirely within
>  the PCIe hierarchy and never reach the root port. The kernel will evaluate
>  the PCIe topology and always permit P2P in these well-defined cases.
>  
> +The client remains the PCIe requester when it reads or writes provider memory.
> +Where the paths diverge, the kernel therefore evaluates P2P Request Redirect
> +and Egress Control on the client-side port, and P2P Completion Redirect on the
> +provider-side port for completions from a read. An enabled Egress Control is
> +conservatively treated as a Request redirect.

I think "where the paths diverge" means the point where a port decides
whether to route a TLP up through its Upstream Port (or to the RC) or
back down via a sibling Downstream Port?

I'm not sure p2pdma.rst includes the context to interpret "divergence"
yet.  I think the code comments in [4/18] might also need a little
more context about divergence.

IIUC, this divergence point is basically a static point where the ACS
controls being applied makes a routing difference.

> +Below the divergence, the route toward the other branch is already upstream,
> +so those P2P redirect controls do not affect it. Redirect controls for the
> +reverse transaction directions do not affect the mapping. P2P DMA is routed
> +through the host bridge when either applicable port redirects. If an ACS
> +Control register cannot be read, P2P DMA is rejected because the kernel cannot
> +establish a usable route.
> +
>  This evaluation assumes clients issue strictly ordered Requests carrying an
>  Untranslated address. Its result is not defined when clients use Relaxed
>  Ordering or issue ATS-translated Requests because those TLP attributes can
> 
> -- 
> 2.55.0
> 
