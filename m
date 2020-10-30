Return-Path: <SRS0=ZJsx=EF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A48FC5517A
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 15:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1296A20728
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 15:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgJ3PBT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 30 Oct 2020 11:01:19 -0400
Received: from verein.lst.de ([213.95.11.211]:54411 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgJ3PBT (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 30 Oct 2020 11:01:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C57D267373; Fri, 30 Oct 2020 16:01:15 +0100 (CET)
Date:   Fri, 30 Oct 2020 16:01:15 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "mike.marciniszyn@cornelisnetworks.com" 
        <mike.marciniszyn@cornelisnetworks.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Yanjun Zhu <yanjunz@nvidia.com>,
        "bmt@zurich.ibm.com" <bmt@zurich.ibm.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com" 
        <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>
Subject: Re: [PATCH] RDMA: Fix software RDMA drivers for dma mapping error
Message-ID: <20201030150115.GA15733@lst.de>
References: <20201030093803.278830-1-parav@nvidia.com> <20201030121731.GA36674@ziepe.ca> <71c2013a-e9af-470c-9fae-30fc0cf78ee3@cornelisnetworks.com> <BY5PR12MB43221AFDF37580F944C13967DC150@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43221AFDF37580F944C13967DC150@BY5PR12MB4322.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2020 at 12:45:45PM +0000, Parav Pandit wrote:
> Christoph did say 64-bit good enough, but he mentioned that it is not correct on 32-bit platforms.
> So it is only for theoretical correctness.
> 
> > Technically there isn't. We are already dependent on 64bit config anyway.
> > Mike M just brought this up in a side bar conversation actually.
> For rvt driver, I should drop the check and always set to 64-bit.

Strictly speaking a dma_addr_t that is just the kernel virtual address
will never be larger than 32-bit on a 32-bit platform (by definition).
But setting it to 64 is entirely harmless, as we can't generate a larger
one (also by definition).
