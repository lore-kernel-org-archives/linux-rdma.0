Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98FAC76195
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 16:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 985CA2080A
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 16:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfGOQ60 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jul 2019 12:58:26 -0400
Received: from verein.lst.de ([213.95.11.211]:34043 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfGOQ6Z (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 15 Jul 2019 12:58:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6E47268B05; Mon, 15 Jul 2019 18:58:23 +0200 (CEST)
Date:   Mon, 15 Jul 2019 18:58:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: properly communicate queue limits to the DMA layer v2
Message-ID: <20190715165823.GA10029@lst.de>
References: <20190617122000.22181-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617122000.22181-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jun 17, 2019 at 02:19:52PM +0200, Christoph Hellwig wrote:
> Hi Martin,
> 
> we've always had a bit of a problem communicating the block layer
> queue limits to the DMA layer, which needs to respect them when
> an IOMMU that could merge segments is used.  Unfortunately most
> drivers don't get this right.  Oddly enough we've been mostly
> getting away with it, although lately dma-debug has been catching
> a few of those issues.

Ping?  What happened to this set of bug fixes?
