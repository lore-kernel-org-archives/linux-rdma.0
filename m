Return-Path: <SRS0=QnZA=DG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D35C4727C
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Sep 2020 18:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691B821548
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Sep 2020 18:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I0A5/glo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgI2SP1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Sep 2020 14:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbgI2SP1 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 29 Sep 2020 14:15:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBE2C061755
        for <linux-rdma@vger.kernel.org>; Tue, 29 Sep 2020 11:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8rAz7BhgXzb+5tz1VX8WasIyRvcKFpYP3hYfxAh52dg=; b=I0A5/glodQzWty/tnx0wptvNNN
        rTX5P1g9CSkUA0AxbB9LBl75dr83qDNkMBeYxwMRqiT6H6lRUjXkbdHBy2/JoNTAILPHvbrLWNvdD
        mvklJa3/ni/0pdUTOAKQCNBs4XSb7KtXF52FIksi5Yg1AXDXLJQF0qT31PuOq/zrpAci69qcUlq/7
        KYdr/EyZEbnl5AUQrAzhramcJIfvVwUoL6hKUYGmLS4hN7dw1AK6QrYOneuTF8KkLygRKg8TAtbcm
        qSY+nwfw8WJI6V1VI3mVAbPZe5lPKVcx2+qIpA3x8pLCHN4bdhdyuQudqaN6Wcrb5LQnmYEpdX3X4
        pEmhC6Pw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNK9p-0002DV-Jt; Tue, 29 Sep 2020 18:15:21 +0000
Date:   Tue, 29 Sep 2020 19:15:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v2 1/4] IB/core: Improve ODP to use
 hmm_range_fault()
Message-ID: <20200929181521.GA8089@infradead.org>
References: <20200922082104.2148873-1-leon@kernel.org>
 <20200922082104.2148873-2-leon@kernel.org>
 <20200929175946.GA767138@nvidia.com>
 <20200929180210.GA5012@infradead.org>
 <20200929181325.GA9475@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929181325.GA9475@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 29, 2020 at 03:13:25PM -0300, Jason Gunthorpe wrote:
> My eventual hope is to be able to send this DMA page list to the HW
> without having to parse and copy it like is done today. We already
> have it in a linear array that can be DMA'd from.
> 
> However, the HW knows 0 means need-fault (the flag bits are zero), it
> doesn't know what to do with DMA_MAPPING_ERROR..

I think you are falling into the same traps as the original hmm
code.  The above might be true for mlx5 hardware, but this is generic
infrastructure.  Making any assumptions about being able to directly
pass it on to hardware is just futile.  Nevermind such pesky things
as endianess conversions.
