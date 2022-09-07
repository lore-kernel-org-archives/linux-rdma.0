Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976E3C38145
	for <linux-rdma@archiver.kernel.org>; Wed,  7 Sep 2022 12:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIGMDi (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 7 Sep 2022 08:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGMDe (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 7 Sep 2022 08:03:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669ED86B4E;
        Wed,  7 Sep 2022 05:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=yDyhZ5ZtH6BaK6n5derVRRnPFzzPHmtJ3IeUVWjkRg4=; b=aVUwJ4rmcWxuQGrOJim80hnOG2
        15duQkRbJ+Ac+C1t4Es+eDo1Qw3kcnSku5oZwhkCC3nosICQWACsC0+o1VjiH/HEVMQAyODWTq3mj
        9cIxAOqY1P/dP1DvM9tB5m72rPJ5D/EYHOJdvOvy8eNesxRBsomLuXmOXjXdbf+Re17xqGWBkjWwt
        8A1IMDCO+I/iVn7Y5nQ1qt1cDiNNAyUjLKSAMFxTEEjlktfP7AMpwTlNDoC50FP4MzVbJ7Zlx1qQk
        AQsvtn+HLNkb9+QCHkyk9ObVFnllwa0rA/o38+T6eJp3nAcGQOsyrPGQ/zoEBEI6H/EtHN8riDv0f
        azgbKM4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVtmE-005wDS-Rl; Wed, 07 Sep 2022 12:03:30 +0000
Date:   Wed, 7 Sep 2022 05:03:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Oded Gabbay <ogabbay@kernel.org>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <YxiIkh/yeWQkZ54x@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 06, 2022 at 12:38:44PM +0200, Christian König wrote:
> The problem is once more that this is MMIO space, in other words register
> BARs which needs to be exported/imported.

Everything used for P2P is bar space.

> Adding struct pages for it generally sounds like the wrong approach here.
> You can't even access this with the CPU or would trigger potentially
> unwanted hardware actions.

How would an access from the CPU vs anther device make any difference?

> Would you mind if I start to tackle this problem?

Yes, I've been waiting forever for someone to tacke how the scatterlist
is abused in dma-buf..
