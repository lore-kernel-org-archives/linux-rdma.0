Return-Path: <SRS0=adbP=EC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00231C4363A
	for <linux-rdma@archiver.kernel.org>; Tue, 27 Oct 2020 08:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97333207C3
	for <linux-rdma@archiver.kernel.org>; Tue, 27 Oct 2020 08:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dRm7AtSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgJ0IIV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 27 Oct 2020 04:08:21 -0400
Received: from casper.infradead.org ([90.155.50.34]:34146 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgJ0IIV (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 27 Oct 2020 04:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4pKuAsyiH24Ww755Jm+xfRiXHhuYbUQ5IacY5+bzdvs=; b=dRm7AtSGKZKfRHsJEG25DPDGe7
        vVZJ8ERkUFGMp09BUle110ztL+kZg9+nmbxc/Lpq107XF43uEG7oQtWE/v6YMtSXHuzNMSVzTNmHk
        8oOQPKa1yhgWUhhsPmYqnAIkLCBdFafBtwIrIsYu8i+l+PXp4vhs1vHS06QE5Kaymq9sQCDG4duQB
        hgTLWQr3FB6A37H0aajYEY0j9UVQiHTbWmI6YDXvfVVzczNm0pD+XoINbDP6VGrEegf+kvpecz5dK
        ohxHmbwa7yDMbZl36e1MqWbk5c0h4yWamrtTYtY+qdvc1tKaPP8aiUEIKws+tnXFl/iZ6aIBnqY+w
        T1iaLjrA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXK1g-0000hv-Ld; Tue, 27 Oct 2020 08:08:16 +0000
Date:   Tue, 27 Oct 2020 08:08:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jianxin Xiong <jianxin.xiong@intel.com>,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>
Subject: Re: [PATCH v6 1/4] RDMA/umem: Support importing dma-buf as user
 memory region
Message-ID: <20201027080816.GA2692@infradead.org>
References: <1603471201-32588-1-git-send-email-jianxin.xiong@intel.com>
 <1603471201-32588-2-git-send-email-jianxin.xiong@intel.com>
 <20201023164911.GF401619@phenom.ffwll.local>
 <20201023182005.GP36674@ziepe.ca>
 <20201024074807.GA3112@infradead.org>
 <20201026122637.GQ36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026122637.GQ36674@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Oct 26, 2020 at 09:26:37AM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 24, 2020 at 08:48:07AM +0100, Christoph Hellwig wrote:
> > On Fri, Oct 23, 2020 at 03:20:05PM -0300, Jason Gunthorpe wrote:
> > > The problem is we have RDMA drivers that assume SGL's have a valid
> > > struct page, and these hacky/wrong P2P sgls that DMABUF creates cannot
> > > be passed into those drivers.
> > 
> > RDMA drivers do not assume scatterlist have a valid struct page,
> > scatterlists are defined to have a valid struct page.  Any scatterlist
> > without a struct page is completely buggy.
> 
> It is not just having the struct page, it needs to be a CPU accessible
> one for memcpy/etc. They aren't correct with the
> MEMORY_DEVICE_PCI_P2PDMA SGLs either.

Exactly.
