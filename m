Return-Path: <SRS0=tA3/=WD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A7EC433FF
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 05:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D0A22305
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Aug 2019 05:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfHGF7Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Aug 2019 01:59:24 -0400
Received: from verein.lst.de ([213.95.11.211]:34555 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfHGF7Y (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 7 Aug 2019 01:59:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D5A7E68B20; Wed,  7 Aug 2019 07:59:18 +0200 (CEST)
Date:   Wed, 7 Aug 2019 07:59:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Eric Pilmore <epilmore@gigaio.com>,
        Stephen Bates <sbates@raithlin.com>
Subject: Re: [PATCH v2 11/14] PCI/P2PDMA: Store mapping method in an xarray
Message-ID: <20190807055918.GB6627@lst.de>
References: <20190730163545.4915-1-logang@deltatee.com> <20190730163545.4915-12-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730163545.4915-12-logang@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 30, 2019 at 10:35:42AM -0600, Logan Gunthorpe wrote:
> When upstream_bridge_distance() is called store the method required
> to map the DMA transfers in an xarray so that it can be looked up
> efficiently on the hot path in pci_p2pdma_map_sg().
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/pci/p2pdma.c | 40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index fe647bd8f947..010aa8742bec 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -19,10 +19,19 @@
>  #include <linux/random.h>
>  #include <linux/seq_buf.h>
>  #include <linux/iommu.h>
> +#include <linux/xarray.h>
> +
> +enum pci_p2pdma_map_type {
> +	PCI_P2PDMA_MAP_UNKNOWN = 0,
> +	PCI_P2PDMA_MAP_NOT_SUPPORTED,
> +	PCI_P2PDMA_MAP_BUS_ADDR,
> +	PCI_P2PDMA_MAP_THRU_IOMMU,
> +};

So here we add a new enum for the map type, but for the internal code
the previousloading of the distance is kept, which seems a little
strange.

> +	if (!(dist & P2PDMA_THRU_HOST_BRIDGE)) {
> +		map_type = PCI_P2PDMA_MAP_BUS_ADDR;
> +		goto store_map_type_and_return;
> +	}
> +
> +	if (host_bridge_whitelist(provider, client)) {
> +		map_type = PCI_P2PDMA_MAP_THRU_IOMMU;
> +	} else {
> +		dist |= P2PDMA_NOT_SUPPORTED;
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +	}
>  
> +store_map_type_and_return:

Why not:

	if (dist & P2PDMA_THRU_HOST_BRIDGE) {
		if (host_bridge_whitelist(provider, client)) {
			map_type = PCI_P2PDMA_MAP_THRU_IOMMU;
		} else {
			dist |= P2PDMA_NOT_SUPPORTED;
			map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
		}
	}
