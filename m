Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD883C1412;
	Wed, 15 Jul 2026 23:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784157329; cv=none; b=KCDabs76kiXm5ftGuVpO82Ag0tTmD/+M7jk+7hS+4H91xEkHtlPPyiRlS/SCyxvrT4EYvy/S+raYmtavHNSS8YfEb+/y2q7c/VSOGBkfcJB18Gv90Ru5S7Pwn3gGGTBI6I/aBbb6J5X4zOLHlZaZSftNN4Meu/oAW2G3lM3mPMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784157329; c=relaxed/simple;
	bh=PmTwD1bjwJ3TllWid4EEApDHP5hvv9bAdEyzGe4zx68=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=pf+nOpPf6S6lYl9fwFeh7wEWQheTPh+rOH/1y3qSEBMh5aWx9u/7tBsuj/QNqvWtDgIMvt1HRfUgs0lx/geymzByWAXoGStiJWJOTs6bwK6XUpxGx37RRrd375aT51p9iAtbpe4Zo3zqVJDSjRasPkmHqitLaGyDZl40OgMcWJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8K6ikjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8K6ikjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4284B1F000E9;
	Wed, 15 Jul 2026 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784157326;
	bh=ECH83PK1Wwf85pLfYuYV5e298FOUyNFzZ/xvIdhME60=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=U8K6ikjxsT/p30EwxKQaL4R1VEF1Pb05++oR9f4HZsQd1W+9pbAEtziKRK1rOnsu0
	 a/Jk3BU3cy8Zv9PzbHOx5aeQHTr0AHB0DfKX4Gyfz3OxBSAEil8iFX/9E2pVX0g11d
	 TneyaP7Cv/UPgZ9OQ9fdbKDYsykY1mBZUtf+lQGp7i0MAmU6vklrjhGSkZodGBqXI2
	 u4j+hYm3BIR+ZEWlqlYNCxTDk26nW3MHdbO2MWQL1vjwnqgDZfriB5UpPvbMwGcI3z
	 IBY4E60NhePNxsIrC39H1N6B0Mn2coJ4u+g1s4NGmLwE9LN5NylALqh+Gk4O6m+T8n
	 tWPzAJQPGDqIQ==
Date: Wed, 15 Jul 2026 18:15:25 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Wei Huang <wei.huang2@amd.com>
Subject: Re: [PATCH v2] PCI/TPH: fold reserved completer encoding in
 get_rp_completer_type()
Message-ID: <20260715231525.GA224907@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715202409.3767494-1-zhipingz@meta.com>

[+cc Wei, author of f69767a1ada3]

On Wed, Jul 15, 2026 at 01:24:00PM -0700, Zhiping Zhang wrote:
> get_rp_completer_type() returns the Root Port's "TPH Completer
> Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
> 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
> into the requester type:
> 
> 	pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
> 
> and later writes tph_req_type to the TPH Requester Enable field, which
> only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
> If a Root Port ever presents the reserved 0b10, that value could be
> written back to hardware, risking undefined behavior.
> 
> Fold the reserved encoding into "not supported" so only the three
> defined values can propagate.
> 
> Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> ---
>  drivers/pci/tph.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> index 655ffd60e62f..ebe1aa5ba5eb 100644
> --- a/drivers/pci/tph.c
> +++ b/drivers/pci/tph.c
> @@ -196,6 +196,21 @@ u16 pcie_tph_get_st_table_size(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pcie_tph_get_st_table_size);
>  
> +/*
> + * Fold the reserved 0b10 "TPH Completer Supported" encoding into
> + * "not supported" so only the three defined values propagate.
> + */
> +static u8 tph_completer_type_fold(u8 comp)
> +{
> +	switch (comp) {
> +	case PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY:
> +	case PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH:
> +		return comp;
> +	default:
> +		return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> +	}
> +}
> +
>  /* Return device's Root Port completer capability */
>  static u8 get_rp_completer_type(struct pci_dev *pdev)
>  {
> @@ -211,7 +226,8 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
>  	if (ret)
>  		return 0;
>  
> -	return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> +	return tph_completer_type_fold(FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK,
> +						 reg));

Is this just defensive programming, or is there some hardware out
there that uses this reserved value?  It's kind of an ugly wart to add
just for theoretical spec conformance testing.

If we really need it, I'd rather read something like this:

    tph_comp = FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
    if (tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
	tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
	    return tph_comp;

    return 0;
