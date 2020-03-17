Return-Path: <SRS0=Q14g=5C=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC188C10F29
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 12:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723C920736
	for <linux-rdma@archiver.kernel.org>; Tue, 17 Mar 2020 12:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgCQMpi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 17 Mar 2020 08:45:38 -0400
Received: from verein.lst.de ([213.95.11.211]:59647 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgCQMph (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 17 Mar 2020 08:45:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id DC43468BFE; Tue, 17 Mar 2020 13:45:33 +0100 (CET)
Date:   Tue, 17 Mar 2020 13:45:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc:     Bernard Metzler <BMT@zurich.ibm.com>, sagi@grimberg.me, hch@lst.de,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: broken CRCs at NVMeF target with SIW & NVMe/TCP transports
Message-ID: <20200317124533.GB12316@lst.de>
References: <20200316162008.GA7001@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316162008.GA7001@chelsio.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 16, 2020 at 09:50:10PM +0530, Krishnamraju Eraparaju wrote:
> 
> I'm seeing broken CRCs at NVMeF target while running the below program
> at host. Here RDMA transport is SoftiWARP, but I'm also seeing the
> same issue with NVMe/TCP aswell.
> 
> It appears to me that the same buffer is being rewritten by the
> application/ULP before getting the completion for the previous requests.
> getting the completion for the previous requests. HW based
> HW based trasports(like iw_cxgb4) are not showing this issue because
> they copy/DMA and then compute the CRC on copied buffer.

For TCP we can set BDI_CAP_STABLE_WRITES.  For RDMA I don't think that
is a good idea as pretty much all RDMA block drivers rely on the
DMA behavior above.  The answer is to bounce buffer the data in
SoftiWARP / SoftRoCE.
