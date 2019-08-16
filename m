Return-Path: <SRS0=I597=WM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F423C3A59C
	for <linux-rdma@archiver.kernel.org>; Fri, 16 Aug 2019 08:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14450206C2
	for <linux-rdma@archiver.kernel.org>; Fri, 16 Aug 2019 08:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfHPIQU (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 16 Aug 2019 04:16:20 -0400
Received: from verein.lst.de ([213.95.11.211]:53453 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfHPIQU (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 16 Aug 2019 04:16:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1C51568B02; Fri, 16 Aug 2019 10:16:17 +0200 (CEST)
Date:   Fri, 16 Aug 2019 10:16:16 +0200
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
Subject: Re: [PATCH v3 14/14] PCI/P2PDMA: Update pci_p2pdma_distance_many()
 documentation
Message-ID: <20190816081616.GN9249@lst.de>
References: <20190812173048.9186-1-logang@deltatee.com> <20190812173048.9186-15-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812173048.9186-15-logang@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 12, 2019 at 11:30:48AM -0600, Logan Gunthorpe wrote:
> The comment describing pci_p2pdma_distance_many() still referred to
> the devices being behind the same root port. This no longer applies
> so reword the documentation.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
