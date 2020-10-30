Return-Path: <SRS0=ZJsx=EF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF0DC00A89
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 15:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7872076E
	for <linux-rdma@archiver.kernel.org>; Fri, 30 Oct 2020 15:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgJ3PBe (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 30 Oct 2020 11:01:34 -0400
Received: from verein.lst.de ([213.95.11.211]:54417 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgJ3PBe (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 30 Oct 2020 11:01:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7282B68AFE; Fri, 30 Oct 2020 16:01:32 +0100 (CET)
Date:   Fri, 30 Oct 2020 16:01:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Parav Pandit <parav@nvidia.com>
Cc:     dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, yanjunz@nvidia.com, bmt@zurich.ibm.com,
        linux-rdma@vger.kernel.org, hch@lst.de,
        syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA: Fix software RDMA drivers for dma mapping error
Message-ID: <20201030150132.GB15733@lst.de>
References: <20201030093803.278830-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030093803.278830-1-parav@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
