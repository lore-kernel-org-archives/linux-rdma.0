Return-Path: <SRS0=hjws=EL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E001EC55179
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFEB20867
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 17:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgKERIT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Nov 2020 12:08:19 -0500
Received: from verein.lst.de ([213.95.11.211]:47919 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgKERIT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Nov 2020 12:08:19 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E83EA68B02; Thu,  5 Nov 2020 18:08:16 +0100 (CET)
Date:   Thu, 5 Nov 2020 18:08:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Zhu Yanjun <yanjunz@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] PCI/P2PDMA: Remove the DMA_VIRT_OPS hacks
Message-ID: <20201105170816.GC7502@lst.de>
References: <20201105074205.1690638-1-hch@lst.de> <20201105074205.1690638-5-hch@lst.de> <20201105143418.GA4142106@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201105143418.GA4142106@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2020 at 10:34:18AM -0400, Jason Gunthorpe wrote:
> The check is removed here, but I didn't see a matching check added to
> the IB side? Something like:
> 
> static int rdma_rw_map_sg(struct ib_device *dev, struct scatterlist *sg,
> 			  u32 sg_cnt, enum dma_data_direction dir)
> {
> 	if (is_pci_p2pdma_page(sg_page(sg))) {
> 		if (ib_uses_virt_dma(dev))
> 			return 0;
> 		return pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
> 	}
> 	return ib_dma_map_sg(dev, sg, sg_cnt, dir);
> }

We should never get a P2P page into the rdma_rw_map_sg or other ib_dma*
routines for the software drivers, as their struct devices don't connect
to a PCІ device underneath, and thus no valid P2P distance can be
retourned.  That being said IFF we want to implement P2P for those
we'd need somethign like the above check, except that we still need
to cal ib_dma_map_sg, i.e.:

static int rdma_rw_map_sg(struct ib_device *dev, struct scatterlist *sg,
 			  u32 sg_cnt, enum dma_data_direction dir)
{
	if (is_pci_p2pdma_page(sg_page(sg)) && !ib_uses_virt_dma(dev))
		return pci_p2pdma_map_sg(dev->dma_device, sg, sg_cnt, dir);
	return ib_dma_map_sg(dev, sg, sg_cnt, dir);
}
