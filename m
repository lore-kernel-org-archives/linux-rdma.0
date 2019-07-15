Return-Path: <SRS0=EqZ5=VM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA700C76195
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 17:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17BC20665
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Jul 2019 17:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfGORqV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:46:21 -0400
Received: from verein.lst.de ([213.95.11.211]:34432 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730235AbfGORqV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 15 Jul 2019 13:46:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EA02168B05; Mon, 15 Jul 2019 19:46:17 +0200 (CEST)
Date:   Mon, 15 Jul 2019 19:46:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: properly communicate queue limits to the DMA layer v2
Message-ID: <20190715174617.GA11094@lst.de>
References: <20190617122000.22181-1-hch@lst.de> <20190715165823.GA10029@lst.de> <yq1tvbn2ofc.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1tvbn2ofc.fsf@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 15, 2019 at 01:33:11PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > Ping?  What happened to this set of bug fixes?
> 
> I thought they depended on Jens' tree?

I think all the patches on the block side went into 5.2, but it's been
a while, so I might misremember..
