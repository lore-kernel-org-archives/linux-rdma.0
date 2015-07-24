From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH V6 1/9] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Fri, 24 Jul 2015 13:14:02 -0600
Message-ID: <20150724191402.GB26225@obsidianresearch.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161820.25617.63886.stgit@build2.ogc.int>
 <20150724164123.GA25480@obsidianresearch.com>
 <00ca01d0c640$2f813d70$8e83b850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00ca01d0c640$2f813d70$8e83b850$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: sagig@mellanox.com, Steve Wise <swise@opengridcomputing.com>
Cc: dledford@redhat.com, infinipath@intel.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 01:40:17PM -0500, Steve Wise wrote:
> > Huh. How does this relate to the max_page_list_len argument:
> > 
> >  struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)
> > 
> > Shouldn't max_fast_reg_page_list_len be checked during the above?
> > 
> > Ie does this still make sense:
> > 
> > drivers/infiniband/ulp/iser/iser_verbs.c:       desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE + 1);
> > 
> > ?
> > 
> > The only ULP that checks this is SRP, so basically, all our ULPs are
> > probably quietly broken? cxgb3 has a limit of 10 (!?!?!!)
> > 
> 
> Yea seems like some drivers need to enforce this in ib_alloc_fast_reg_mr() as well as ib_alloc_fast_reg_page_list(), and ULPs need
> to not exceed the device max.

Great, Sagi, can you incorporate that in your series so that
ib_alloc_mr's max_entires is checked against
max_fast_reg_page_list_len and EINVAL's if it is too great?

Also, after your series can we drop ib_alloc_fast_reg_page_list, and
then also the associated WR stuff?

Thanks,
Jason
