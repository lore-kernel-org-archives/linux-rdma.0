Return-Path: <SRS0=Nq8O=CY=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E0CC433E2
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Sep 2020 22:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F3420809
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Sep 2020 22:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgIOW1h (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:27:37 -0400
Received: from verein.lst.de ([213.95.11.211]:48385 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727593AbgIOQTy (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 15 Sep 2020 12:19:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D7B1168BEB; Tue, 15 Sep 2020 18:19:26 +0200 (CEST)
Date:   Tue, 15 Sep 2020 18:19:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v1 2/4] lib/scatterlist: Add support in
 dynamically allocation of SG entries
Message-ID: <20200915161926.GB24320@lst.de>
References: <20200910134259.1304543-1-leon@kernel.org> <20200910134259.1304543-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910134259.1304543-3-leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

> +			/* We decrease one since the prvious last sge in used to
> +			 * chainning.
> +			 */

The normal style would be:

			/*
			 * We decrease one since the prvious last sge in used to
			 * chain the chunks together.
			 */

(also fixing up what I think it should be saying while I'm at it)

> + *   Thus if @nents is bigger than @max_ents, the scatterlists will be
> + *   chained in units of @max_ents.
> + *
> + **/
> +static int sg_alloc_next(struct sg_table *table, struct scatterlist *last,
> +			 unsigned int nents, unsigned int max_ents,
> +			 gfp_t gfp_mask)
> +{
> +	return sg_alloc(table, last, nents, max_ents, NULL, 0, gfp_mask,
> +			sg_kmalloc);
> +}

This helper seems unused in this patch.  For bisection you probably
want to move it into the next patch with the user.

In fact I'm not even sure there is much of a point in splitting out
this patch either.
