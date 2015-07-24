From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V6 1/9] RDMA/iser: Limit sg tablesize and max_sectors to
 device fastreg max depth
Date: Fri, 24 Jul 2015 10:41:23 -0600
Message-ID: <20150724164123.GA25480@obsidianresearch.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161820.25617.63886.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150724161820.25617.63886.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 11:18:21AM -0500, Steve Wise wrote:
> Currently the sg tablesize, which dictates fast register page list
> depth to use, does not take into account the limits of the rdma device.
> So adjust it once we discover the device fastreg max depth limit.  Also
> adjust the max_sectors based on the resulting sg tablesize.

Huh. How does this relate to the max_page_list_len argument:

 struct ib_mr *ib_alloc_fast_reg_mr(struct ib_pd *pd, int max_page_list_len)

Shouldn't max_fast_reg_page_list_len be checked during the above?

Ie does this still make sense:

drivers/infiniband/ulp/iser/iser_verbs.c:       desc->data_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE + 1);

?

The only ULP that checks this is SRP, so basically, all our ULPs are
probably quietly broken? cxgb3 has a limit of 10 (!?!?!!)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
