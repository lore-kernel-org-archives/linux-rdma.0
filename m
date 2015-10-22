From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 14/22] staging/rdma/hfi1: Implement Expected Receive TID caching
Date: Thu, 22 Oct 2015 19:18:19 -0400
Message-ID: <20151022231819.GB4019@phlsvsds.ph.intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com> <1445307097-8244-15-git-send-email-ira.weiny@intel.com> <20151022104158.GL7340@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151022104158.GL7340@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2015 at 01:41:58PM +0300, Dan Carpenter wrote:
> On Mon, Oct 19, 2015 at 10:11:29PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +	case HFI1_CMD_TID_INVAL_READ:
> > +		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
> > +		if (!ret) {
> > +			addr = (unsigned long)cmd.addr +
> > +				offsetof(struct hfi1_tid_info, tidcnt);
> > +			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
> > +					 sizeof(tinfo.tidcnt)))
> > +				ret = -EFAULT;
> > +		}
> > +		break;
> 
> This switch statement uses success handling throughtout instead of
> error handling.  It's better if you write it like this:
> 
> 	case HFI1_CMD_TID_INVAL_READ:
> 		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
> 		if (ret)
> 			break;
> 
> 		addr = (unsigned long)cmd.addr +
> 		       offsetof(struct hfi1_tid_info, tidcnt);
> 		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
> 				 sizeof(tinfo.tidcnt)))
> 			ret = -EFAULT;
> 		break;

This follows the rest of the style of the case statement in this function.  We
prefer to leave this as is for a number of reasons.

1) This is consistent with the coding style elsewhere in this driver.
2) It is functionally equivalent.
3) I have a long list of patches which need to be processed and this may cause
   later merge conflicts.

The main reason is number 1.  We want to remain consistent within this driver.

> 
> 
> The casting is sort of ugly...  It would be better to make address a
> pointer.  It does cut down on the lines of code but at least the cast is
> all done at once and really "addr" is actually a pointer.
> 
> 	case HFI1_CMD_TID_INVAL_READ:
> 		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
> 		if (ret)
> 			break;
> 
> 		addr = (void __user *)(unsigned long)cmd.addr +
> 		       offsetof(struct hfi1_tid_info, tidcnt);
> 		if (copy_to_user(addr, &tinfo.tidcnt, sizeof(tinfo.tidcnt)))
> 			ret = -EFAULT;
> 		break;

I think this is more a matter of style.

> 
> 
> >  	case HFI1_CMD_TID_FREE:
> > -		ret = exp_tid_free(fp, &tinfo);
> > +		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
> > +		addr = (unsigned long)cmd.addr +
> > +			offsetof(struct hfi1_tid_info, tidcnt);
> > +		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
> > +				 sizeof(tinfo.tidcnt)))
> > +			ret = -EFAULT;
> >  		break;
> 
> This is an information leak.  We should break if
> hfi1_user_exp_rcv_clear() fails, but instead we copy uninitialized
> variables to the user.

That is a bug, thanks.

Fixed in v3  (Although, I did use the same positive error check style to be
consistent within this function.)

> 
> 
> 
> >  	case HFI1_CMD_RECV_CTRL:
> >  		ret = manage_rcvq(uctxt, subctxt_fp(fp), (int)user_val);
> > @@ -607,9 +603,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
> >  		 * Use the page where this context's flags are. User level
> >  		 * knows where it's own bitmap is within the page.
> >  		 */
> > -		memaddr = ((unsigned long)dd->events +
> > -			   ((uctxt->ctxt - dd->first_user_ctxt) *
> > -			    HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
> > +		memaddr = (unsigned long)(dd->events +
> > +					  ((uctxt->ctxt - dd->first_user_ctxt) *
> > +					   HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
> 
> I am too lazy to investigate the types of all these variables but I'm
> instead going to assert that moving the cast to later is an unrelated
> white space change.  Don't mix white space changes in with a behavior
> change patch because it makes it hard to review.

Actually this is a bug fix.  dd->events is a pointer which needs to be indexed
prior to the cast.  I'll split this into a separate patch in v3.

Thanks!
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
