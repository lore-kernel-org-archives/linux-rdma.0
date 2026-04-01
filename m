Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B3B3C196A;
	Wed,  1 Apr 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775053034; cv=none; b=YdFDw8DzNMlbOU7dXAYokeC8kqc+rsoVuC5jb3Soh664W0VPMK63FrQwH+jGEBolZTApoDd8kAFU6dojGnSXHxBWfZsyenVMokOfR93EFAHIacAiaHuSbta6lb+bthK+Y1nAg7xzK8c6vduEoRjYEzFaE6h8ZmGVCzw36tp1W2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775053034; c=relaxed/simple;
	bh=KjfbT286xOgrlvRi95F8Ih/wXYmnOt6Lm5PYUCc46so=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ew9YiaFh2IFd+ix7xHhaknuL2GQ+o6nYAoArj59WBt5YLvX+vqdNYRX6IfXWRkbFFt3o3Mr+LLvsxYK6syHEa1M7D+2E1vnfcnvJt719wxFy/N/gceBcFhSNYrkgt1cHzIyCt7EycWWiGRYeF66TP6KKtyiTJcuLjcYgUl8/jXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8494568D05; Wed,  1 Apr 2026 16:17:07 +0200 (CEST)
Date: Wed, 1 Apr 2026 16:17:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shivaji Kant <shivajikant@google.com>
Cc: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pranjal Shrivastava <praan@google.com>
Subject: Re: [RFC PATCH] nvme: enable PCI P2PDMA support for RDMA transport
Message-ID: <20260401141706.GA22165@lst.de>
References: <20260401103441.1229964-1-shivajikant@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401103441.1229964-1-shivajikant@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 01, 2026 at 10:34:41AM +0000, Shivaji Kant wrote:
> Enable BLK_FEAT_PCI_P2PDMA on the NVMe when the underlying
> RDMA controller supports it.
> 
> blk_stack_limits() currently filters out this feature bit because it is
> absent from BLK_FEAT_INHERIT_MASK. Manually re-assert the capability
> in nvme_update_ns_info() after the stacking operation.

This is really two different features/fixes and should be two patches.
Note that Chaitanya also has an outstanding patch about p2p on multipath,
so please work with him.

> Hardware reachability remains enforced by late-stage distance checks
> during DMA mapping.

I don't know what this is supposed to mean.  Callers need to check the
reachability first before submitting P2P I/O.

> +static bool nvme_rdma_supports_pci_p2pdma(struct nvme_ctrl *ctrl)
> +{
> +	struct nvme_rdma_ctrl *r_ctrl = to_rdma_ctrl(ctrl);
> +	bool supported = false;
> +
> +	if (r_ctrl && r_ctrl->device)

to_rdma_ctrl is a wrapper around container_of, so r_ctrl can't be
NULL for a non-NULL ctrl.  ->device also should not NULL because it
is set up before namespaces are probed.

> +		supported = ib_dma_pci_p2p_dma_supported(r_ctrl->device->dev);
> +
> +	dev_dbg(ctrl->device, "PCI P2PDMA support result: %s\n",
> +			supported ? "PASSED" : "FAILED (HW/Driver restriction)");

Overly long line, and screaming isn't really something we do in our
messages.  We also don't do that debug message in PCI, so please just
drop it.  IF you think this is important enough add a tracepoint in the
core code in a separate patch.

