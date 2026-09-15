Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91B1A0B0E;
	Tue, 15 Sep 2026 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789510986; cv=none; b=MmV+/bY2ufa2NqvLoDGzAaYhHewog+F0Pl8lX8E9iNUyOkCs6ZiwdXQciZOlPU9Ucw9DBfEWuYcQSsWA8Cq3t2zul6F+BFp8jwz9/gWBDosfnsyVT+GqnZuC+FRQq0I2Q0owybuKw5CRvHaYdbi3V5yCDBz8xaHCKyFDurRvHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789510986; c=relaxed/simple;
	bh=nFQdfxncAoOmcmOyBTEwZOFsphrzOVWCtdAQby49Jgo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=boMUJhX2L991Dj3My5NnBliZjatxO3Kvqxyp5Ot4x5Eo1jv/8HxfzQgGkaJzz3FxpWxRRLfHXYPNxeRuQd77GK8MPb9GyLpPU2IgNqeEH8Xo7FUZYz6vCTS4HwBTHHChVYdctaTDmPD+tFrIEOFSDAHeuYCmc6JmyF9S/9Wye9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ip0PRVVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ip0PRVVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237E91F000FF;
	Tue, 15 Sep 2026 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789510985;
	bh=dwm9SNCI/zPefF57vWE0rOxvF15hPG+jgHi2LM34FCE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Ip0PRVVDKBmCB7bz5A2s32XkXUzqIUfDYb99X8/TGNgPc3IElTD93DAxctyOrwwPZ
	 UfG4dQPBnSTDCPizXGSRJXymcXAfCqKZb0XjGT+c2afKa7agvir+amjMJB2aHV5Oml
	 TvAH4qpeW5MfvSVFf0rbPkBpP5wKcUWkwbOvRPGlHR4sjscea4AHhN4cD9LqHwDnVo
	 5+UDDychWytXK7iIb5L6FmnVSm0ddrAAjGbl0I7k6bV5US+Eg/Saogt2g+ocfugF5C
	 9Uou0JyP1WVfMt/t19I0HA5Zo7YA5EeWFK9NXcBPT6QVp2qLRu40nDZtUTYIp+dA/t
	 +QVOkGvzhUOdw==
Date: Tue, 15 Sep 2026 17:23:03 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v13 2/5] PCI/TPH: Add requester/completer type helpers
Message-ID: <20260915222303.GA877199@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731211601.3033906-3-zhipingz@meta.com>

On Fri, Jul 31, 2026 at 02:15:49PM -0700, Zhiping Zhang wrote:
> Add pcie_tph_enabled_req_type() so drivers can query the enabled TPH
> requester mode without reaching into pci_dev internals.
> 
> Add pcie_tph_completer_type() so drivers that publish TPH metadata for a
> device acting as a completer can gate on the "TPH Completer Supported"
> field of Device Capabilities 2 (bits 13:12, PCI_EXP_DEVCAP2_TPH_COMP_MASK)
> rather than reusing requester-side state. It applies the same reserved-
> encoding fold as get_rp_completer_type(), inlined, so the reserved 0b10
> value never reaches callers.
> 
> This keeps pci_dev::tph_req_type and the completer-capability decode
> inside the PCI/TPH code and provides !CONFIG_PCIE_TPH stubs for callers.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/tph.c       | 44 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci-tph.h |  8 ++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> index 5cbb381e2a02..d0202ff7a1b2 100644
> --- a/drivers/pci/tph.c
> +++ b/drivers/pci/tph.c
> @@ -223,6 +223,50 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
>  	return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
>  }
>  
> +/**
> + * pcie_tph_enabled_req_type - Return the device's enabled TPH requester type
> + * @pdev: PCI device to query
> + *
> + * Return: PCI_TPH_REQ_DISABLE, PCI_TPH_REQ_TPH_ONLY or PCI_TPH_REQ_EXT_TPH.
> + */
> +u8 pcie_tph_enabled_req_type(struct pci_dev *pdev)
> +{
> +	return pdev->tph_req_type;
> +}
> +EXPORT_SYMBOL(pcie_tph_enabled_req_type);
> +
> +/**
> + * pcie_tph_completer_type - Return the device's TPH Completer support
> + * @pdev: PCI device to query
> + *
> + * Reads the "TPH Completer Supported" field (bits 13:12) of Device

s/Reads/Read/ to match other doc ("Return ... type" above, "Write tag" below)

> + * Capabilities 2. The reserved 0b10 encoding is folded into
> + * "not supported" so callers only need to compare against the three
> + * defined values.

s/The reserved 0b10 encoding is folded/Fold reserved 0b10 encoding/

> + *
> + * Return: one of %PCI_EXP_DEVCAP2_TPH_COMP_NONE,
> + *         %PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY or
> + *         %PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH.
> + */
> +u8 pcie_tph_completer_type(struct pci_dev *pdev)
> +{
> +	u8 tph_comp;
> +	u32 reg;
> +
> +	if (pcie_capability_read_dword(pdev, PCI_EXP_DEVCAP2, &reg))
> +		return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> +	if (PCI_POSSIBLE_ERROR(reg))
> +		return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> +
> +	/* 0b10 is reserved; fold it into "not supported" (see above). */
> +	tph_comp = FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> +	if (tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
> +	    tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
> +		return tph_comp;
> +	return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> +}
> +EXPORT_SYMBOL(pcie_tph_completer_type);
> +
>  /* Write tag to ST table - Return 0 if OK, otherwise -errno */
>  static int write_tag_to_st_table(struct pci_dev *pdev, int index, u16 tag)
>  {
> diff --git a/include/linux/pci-tph.h b/include/linux/pci-tph.h
> index be68cd17f2f8..7743af6fe432 100644
> --- a/include/linux/pci-tph.h
> +++ b/include/linux/pci-tph.h
> @@ -9,6 +9,8 @@
>  #ifndef LINUX_PCI_TPH_H
>  #define LINUX_PCI_TPH_H
>  
> +#include <linux/pci_regs.h>
> +
>  /*
>   * According to the ECN for PCI Firmware Spec, Steering Tag can be different
>   * depending on the memory type: Volatile Memory or Persistent Memory. When a
> @@ -30,6 +32,8 @@ void pcie_disable_tph(struct pci_dev *pdev);
>  int pcie_enable_tph(struct pci_dev *pdev, int mode);
>  u16 pcie_tph_get_st_table_size(struct pci_dev *pdev);
>  u32 pcie_tph_get_st_table_loc(struct pci_dev *pdev);
> +u8 pcie_tph_enabled_req_type(struct pci_dev *pdev);
> +u8 pcie_tph_completer_type(struct pci_dev *pdev);
>  #else
>  static inline int pcie_tph_set_st_entry(struct pci_dev *pdev,
>  					unsigned int index, u16 tag)
> @@ -41,6 +45,10 @@ static inline int pcie_tph_get_cpu_st(struct pci_dev *dev,
>  static inline void pcie_disable_tph(struct pci_dev *pdev) { }
>  static inline int pcie_enable_tph(struct pci_dev *pdev, int mode)
>  { return -EINVAL; }
> +static inline u8 pcie_tph_enabled_req_type(struct pci_dev *pdev)
> +{ return PCI_TPH_REQ_DISABLE; }
> +static inline u8 pcie_tph_completer_type(struct pci_dev *pdev)
> +{ return PCI_EXP_DEVCAP2_TPH_COMP_NONE; }
>  #endif
>  
>  #endif /* LINUX_PCI_TPH_H */
> -- 
> 2.53.0-Meta
> 
