Return-Path: <SRS0=PR/X=XE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC215C433EF
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Sep 2019 09:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7406021A4C
	for <linux-rdma@archiver.kernel.org>; Mon,  9 Sep 2019 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568022015;
	bh=Qg/woz40Ie68udKTXwrdRP0pCLCp/XGE1ZxfYaQjAH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NMLi3Na7Xz5n2BgLJAMU5tNogrWa4IBD+gQhf+uktk1Kvi+GCRBZtK9lxgEqcycHm
	 2M3EcQidm8gJPdpUBmXIo7j1s9XzT9IV2anamR44nDO91GdHizO6FpQfZ4lSK4NyVs
	 kHxUq5WztrYRHFLz7+sjB+7gGMobn5fqHKBiK5ow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfIIJkO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 9 Sep 2019 05:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfIIJkO (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 9 Sep 2019 05:40:14 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56B832086D;
        Mon,  9 Sep 2019 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568022013;
        bh=Qg/woz40Ie68udKTXwrdRP0pCLCp/XGE1ZxfYaQjAH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oWywqd+ktRkVF0G4BtRS3Vm5k3IIJOkVAFBffuDNG0E7ayffBxsC1QWqlqKuL9kjW
         9ldCs2enOhjTy8vcFVFCR/GqR8btAmUwtTYWungH3MdyIJ5r5DshLWTegbqNjrr949
         7yJbA+maVzhCBvFWMB3P9l1cl6YG8Ify5v9GzB5s=
Date:   Mon, 9 Sep 2019 12:40:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>
Subject: Re: [PATCH rdma-next v1 1/4] IB/mlx5: Introduce ODP diagnostic
 counters
Message-ID: <20190909094010.GA6601@unreal>
References: <20190830081612.2611-1-leon@kernel.org>
 <20190830081612.2611-2-leon@kernel.org>
 <20190909084535.GB2843@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909084535.GB2843@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Sep 09, 2019 at 08:45:36AM +0000, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2019 at 11:16:09AM +0300, Leon Romanovsky wrote:
> > From: Erez Alfasi <ereza@mellanox.com>
> >
> > Introduce ODP diagnostic counters and count the following
> > per MR within IB/mlx5 driver:
> >  1) Page faults:
> > 	Total number of faulted pages.
> >  2) Page invalidations:
> > 	Total number of pages invalidated by the OS during all
> > 	invalidation events. The translations can be no longer
> > 	valid due to either non-present pages or mapping changes.
> >  3) Prefetched pages:
> > 	When prefetching a page, page fault is generated
> > 	in order to bring the page to the main memory.
> > 	The prefetched pages counter will be updated
> > 	during a page fault flow only if it was derived
> > 	from prefetching operation.
> >
> > Signed-off-by: Erez Alfasi <ereza@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/hw/mlx5/odp.c | 18 ++++++++++++++++++
> >  include/rdma/ib_umem_odp.h       | 14 ++++++++++++++
> >  2 files changed, 32 insertions(+)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> > index 905936423a03..b7c8a49ac753 100644
> > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > @@ -287,6 +287,10 @@ void mlx5_ib_invalidate_range(struct ib_umem_odp *umem_odp, unsigned long start,
> >
> >  	ib_umem_odp_unmap_dma_pages(umem_odp, start, end);
> >
> > +	/* Count page invalidations */
> > +	ib_update_odp_stats(umem_odp, invalidations,
> > +			    ib_umem_odp_num_pages(umem_odp));
>
> This doesn't seem right, it should only count the number of pages that
> were actually removed from the mapping

Absolutely, It is my mistake, I think that I mislead Erez back then.

>
> > diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
> > index b37c674b7fe6..3359e34516da 100644
> > +++ b/include/rdma/ib_umem_odp.h
> > @@ -37,6 +37,12 @@
> >  #include <rdma/ib_verbs.h>
> >  #include <linux/interval_tree.h>
> >
> > +struct ib_odp_counters {
> > +	atomic64_t faults;
> > +	atomic64_t invalidations;
> > +	atomic64_t prefetched;
> > +};
> > +
> >  struct ib_umem_odp {
> >  	struct ib_umem umem;
> >  	struct ib_ucontext_per_mm *per_mm;
> > @@ -62,6 +68,11 @@ struct ib_umem_odp {
> >  	struct mutex		umem_mutex;
> >  	void			*private; /* for the HW driver to use. */
> >
> > +	/*
> > +	 * ODP diagnostic counters.
> > +	 */
> > +	struct ib_odp_counters odp_stats;
>
> This really belongs in the MR not the umem

Bu why? We have umem_odp, all our statistics calculations are done
in umem_odp level.

>
> >  	int notifiers_seq;
> >  	int notifiers_count;
> >  	int npages;
> > @@ -106,6 +117,9 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
> >  	       umem_odp->page_shift;
> >  }
> >
> > +#define ib_update_odp_stats(umem_odp, counter_name, value)		    \
> > +	atomic64_add(value, &(umem_odp->odp_stats.counter_name))
>
> Missing brackets in a macro

I am doubt about that, because it is one to one replace and not "real" macro.

Thanks

>
> Jason
