From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/14] staging/rdma/hfi1: Add TID entry program function body
Date: Thu, 17 Dec 2015 16:24:20 -0500
Message-ID: <20151217212420.GB13023@phlsvsds.ph.intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com> <1450335624-12134-14-git-send-email-ira.weiny@intel.com> <20151217120645.GJ5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151217120645.GJ5284@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 03:06:45PM +0300, Dan Carpenter wrote:
> On Thu, Dec 17, 2015 at 02:00:23AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +	mutex_lock(&uctxt->exp_lock);
> > +	/*
> > +	 * The first step is to program the RcvArray entries which are complete
> > +	 * groups.
> > +	 */
> > +	while (ngroups && uctxt->tid_group_list.count) {
> > +		struct tid_group *grp =
> > +			tid_group_pop(&uctxt->tid_group_list);
> > +
> > +		ret = program_rcvarray(fp, vaddr, grp, pagesets,
> > +				       pageidx, dd->rcv_entries.group_size,
> > +				       pages, tidlist, &tididx, &mapped);
> > +		/*
> > +		 * If there was a failure to program the RcvArray
> > +		 * entries for the entire group, reset the grp fields
> > +		 * and add the grp back to the free group list.
> > +		 */
> > +		if (ret <= 0) {
> > +			tid_group_add_tail(grp, &uctxt->tid_group_list);
> > +			hfi1_cdbg(TID,
> > +				  "Failed to program RcvArray group %d", ret);
> > +			goto unlock;
> 
> We print a failure message but we still return success when ret == 0.

Not programming anything (return of 0) is allowed.  So it should not be an
error here.  User space is required to handle this case.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
