Return-Path: <SRS0=cPpa=DA=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C0BC4363D
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Sep 2020 05:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873AA21D43
	for <linux-rdma@archiver.kernel.org>; Wed, 23 Sep 2020 05:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgIWFm4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:42:56 -0400
Received: from verein.lst.de ([213.95.11.211]:47245 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgIWFmz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 23 Sep 2020 01:42:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F67E67373; Wed, 23 Sep 2020 07:42:52 +0200 (CEST)
Date:   Wed, 23 Sep 2020 07:42:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Roland Scheidegger <sroland@vmware.com>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>
Subject: Re: [PATCH rdma-next v3 1/2] lib/scatterlist: Add support in
 dynamic allocation of SG table from pages
Message-ID: <20200923054251.GA15249@lst.de>
References: <20200922083958.2150803-1-leon@kernel.org> <20200922083958.2150803-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922083958.2150803-2-leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Sep 22, 2020 at 11:39:57AM +0300, Leon Romanovsky wrote:
> E.g. with the Infiniband driver that allocates a single page for hold
> the
> pages. For 1TB memory registration, the temporary buffer would consume
> only
> 4KB, instead of 2GB.

Formatting looks  little weird here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
