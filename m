Return-Path: <SRS0=hjws=EL=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4318EC55179
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 17:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B542083B
	for <linux-rdma@archiver.kernel.org>; Thu,  5 Nov 2020 17:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKER30 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 5 Nov 2020 12:29:26 -0500
Received: from verein.lst.de ([213.95.11.211]:48041 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKER30 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 5 Nov 2020 12:29:26 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B7E4D68C4E; Thu,  5 Nov 2020 18:29:21 +0100 (CET)
Date:   Thu, 5 Nov 2020 18:29:21 +0100
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
Message-ID: <20201105172921.GA9537@lst.de>
References: <20201105074205.1690638-1-hch@lst.de> <20201105074205.1690638-5-hch@lst.de> <20201105143418.GA4142106@ziepe.ca> <20201105170816.GC7502@lst.de> <20201105172357.GE36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105172357.GE36674@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2020 at 01:23:57PM -0400, Jason Gunthorpe wrote:
> But that depends on the calling driver doing this properly, and we
> don't expose an API to get the PCI device of the struct ib_device
> .. how does nvme even work here?

The PCI p2pdma APIs walk the parent chains of a struct device until
they find a PCI device.  And the ib_device eventually ends up there.

> 
> If we can't get here then why did you add the check to the unmap side?

Because I added them to the map and unmap side, but forgot to commit
the map side.  Mostly to be prepared for the case where we could
end up there.  And thinking out loud I actually need to double check
rdmavt if that is true there as well.  It certainly is for rxe and
siw as I checked it on a live system.

> The SW drivers can't handle PCI pages at all, they are going to try to
> memcpy them or something else not __iomem, so we really do need to
> prevent P2P pages going into them.

Ok, let's prevent it for now.  And if someone wants to do it there
they have to do all the work.
