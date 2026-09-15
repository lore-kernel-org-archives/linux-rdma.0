Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776971632DD;
	Tue, 15 Sep 2026 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789510767; cv=none; b=KGPVtlKdjrjV1E3t0fvKhvX0PbSQmJ65GED5AyqRAHRwUkd4iSF6E8zPOy9YF5jjoH1tMRi43POdFiwjCvWmDFb7SJD2utH5JOAfAs9QtJVGHGAvNvJM0grB9XSCzI1lTUf2Kt+hU/QmS64/PQqdhv+g6ODeMm6k0sHWKDV7OLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789510767; c=relaxed/simple;
	bh=9bXzsRWtDMAA63S64a4K1hyLWGolgOZqXgwCtzddk20=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=lPa6dkRzM23E1x96EaMaXePQsiF0r3KxSLc2Iln0P27IP6Q/2uzTTNKRFwbkBnHFu2S+HjeeOl2t/ypBO1tyaX0Au5aGXVt8w8YDy6/CwrPe5pr/St0L1//bU563p+3FToNeRAM/Q9CkG0ISFT7WlNA5oOts4ZZLrYf3H3ZVzBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBIm2uEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBIm2uEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71781F000FF;
	Tue, 15 Sep 2026 22:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789510766;
	bh=rpSdZ5OvbqeZKcuM5Z7YsgmPO0kkzXfzBgg4m9PtGwE=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=VBIm2uEPIhgM3jm2hdfHcjfOfhndYhFHtIcUjlyzRpLGPLEVZuvTjM2TxGa6XoVKW
	 TgO0OvZk7bmr/BV3ov/hWb2AG/vTXi3Xa1rIgax3sIjpxa65N2G5Yu59oEcs0D6Yqa
	 GY8P/ZjyMROBXqi9VoawKc0qVWaY7LofAkSl6lQ/psAArD+IMyUAxESxx0vHrMWb9X
	 G/z88e12qtTyXpTLFDJyRPizwVg9XOhCQS2zds4XGabWODIdj054tlVCFxRHLkyw6b
	 1l4eBMnxGkVzOdAV5HoWDtY/6tkoZbCfFKKeZEWaNn9tm2gU932VGGNyPlYBinkApX
	 xm8i9sfWanJjA==
Date: Tue, 15 Sep 2026 17:19:24 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Chengwen Feng <fengchengwen@huawei.com>
Subject: Re: [PATCH v13 1/5] PCI/TPH: treat reserved 0b10 completer encoding
 as unsupported
Message-ID: <20260915221924.GA876929@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731211601.3033906-2-zhipingz@meta.com>

On Fri, Jul 31, 2026 at 02:15:48PM -0700, Zhiping Zhang wrote:
> get_rp_completer_type() returns the Root Port's "TPH Completer
> Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
> 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
> into the requester type:
> 
> 	pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
> 
> and later writes tph_req_type to the TPH Requester Enable field, which
> only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
> 
> No known hardware presents the reserved 0b10 in this field, so this is
> defensive hardening rather than a fix for observed silicon: fold the
> reserved encoding into "not supported" so only the three architected
> values can ever reach the Requester Enable field.
> 
> Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> Acked-by: Chengwen Feng <fengchengwen@huawei.com>

In subject, to match history of the file:

  PCI/TPH: Treat reserved 0b10 completer encoding as unsupported

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/tph.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> index 655ffd60e62f..5cbb381e2a02 100644
> --- a/drivers/pci/tph.c
> +++ b/drivers/pci/tph.c
> @@ -200,6 +200,7 @@ EXPORT_SYMBOL(pcie_tph_get_st_table_size);
>  static u8 get_rp_completer_type(struct pci_dev *pdev)
>  {
>  	struct pci_dev *rp;
> +	u8 tph_comp;
>  	u32 reg;
>  	int ret;
>  
> @@ -211,7 +212,15 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
>  	if (ret)
>  		return 0;
>  
> -	return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> +	/*
> +	 * 0b10 is reserved; treat it as "not supported" so only the
> +	 * architected encodings reach the Requester Enable field.
> +	 */
> +	tph_comp = FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> +	if (tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
> +	    tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
> +		return tph_comp;
> +	return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
>  }
>  
>  /* Write tag to ST table - Return 0 if OK, otherwise -errno */
> -- 
> 2.53.0-Meta
> 
