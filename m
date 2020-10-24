Return-Path: <SRS0=DDZm=D7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77329C2D0A3
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Oct 2020 07:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CEF722460
	for <linux-rdma@archiver.kernel.org>; Sat, 24 Oct 2020 07:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dYXsFDWc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759936AbgJXHsM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 24 Oct 2020 03:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759935AbgJXHsM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 24 Oct 2020 03:48:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3ABC0613CE
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2020 00:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/CnQE42MmBtHov937IKEzIAZe1qLD8zt2YNuzfv/CoU=; b=dYXsFDWcT1i7bG/RUtBykPynMy
        ObRmQQXH41RnQcdyjp3FGy7SrgPLoF9923yOhUv2irEtnQLPViKJr04jSduk4ODFMk3SDQq9MwZ02
        Ap2ELMw0OTnTMZVrDowJC1wUYZCNgHdJkHabDalpQodzac92eMJIoiFd6eunkqgSlvzg8rNfwdZ2r
        ngWNgSkeR2PGtM/4Q0XZNoPoDIBd62Xgae1nDau9fsDaaqtyjiD+D4G3KXur0la6DVuwVl2hmj0Yz
        eGiQf9ryeSYScJeF/DJC9X2uTs7lZwHZt/VXjKguBhsBlC8t+XBpy0dStjPYNXiSK22N0rUGzVzZJ
        vZ0iIfSQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWEHX-0000yc-FR; Sat, 24 Oct 2020 07:48:07 +0000
Date:   Sat, 24 Oct 2020 08:48:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Jianxin Xiong <jianxin.xiong@intel.com>,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christian Koenig <christian.koenig@amd.com>
Subject: Re: [PATCH v6 1/4] RDMA/umem: Support importing dma-buf as user
 memory region
Message-ID: <20201024074807.GA3112@infradead.org>
References: <1603471201-32588-1-git-send-email-jianxin.xiong@intel.com>
 <1603471201-32588-2-git-send-email-jianxin.xiong@intel.com>
 <20201023164911.GF401619@phenom.ffwll.local>
 <20201023182005.GP36674@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023182005.GP36674@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Oct 23, 2020 at 03:20:05PM -0300, Jason Gunthorpe wrote:
> The problem is we have RDMA drivers that assume SGL's have a valid
> struct page, and these hacky/wrong P2P sgls that DMABUF creates cannot
> be passed into those drivers.

RDMA drivers do not assume scatterlist have a valid struct page,
scatterlists are defined to have a valid struct page.  Any scatterlist
without a struct page is completely buggy.
