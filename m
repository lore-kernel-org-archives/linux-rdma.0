From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 14/22] staging/rdma/hfi1: Implement Expected Receive
 TID caching
Date: Thu, 22 Oct 2015 13:41:58 +0300
Message-ID: <20151022104158.GL7340@mwanda>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
 <1445307097-8244-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1445307097-8244-15-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ira.weiny@intel.com
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org, Mitko Haralanov <mitko.haralanov@intel.com>, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 19, 2015 at 10:11:29PM -0400, ira.weiny@intel.com wrote:
> +	case HFI1_CMD_TID_INVAL_READ:
> +		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
> +		if (!ret) {
> +			addr = (unsigned long)cmd.addr +
> +				offsetof(struct hfi1_tid_info, tidcnt);
> +			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
> +					 sizeof(tinfo.tidcnt)))
> +				ret = -EFAULT;
> +		}
> +		break;

This switch statement uses success handling throughtout instead of
error handling.  It's better if you write it like this:

	case HFI1_CMD_TID_INVAL_READ:
		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
		if (ret)
			break;

		addr = (unsigned long)cmd.addr +
		       offsetof(struct hfi1_tid_info, tidcnt);
		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
				 sizeof(tinfo.tidcnt)))
			ret = -EFAULT;
		break;


The casting is sort of ugly...  It would be better to make address a
pointer.  It does cut down on the lines of code but at least the cast is
all done at once and really "addr" is actually a pointer.

	case HFI1_CMD_TID_INVAL_READ:
		ret = hfi1_user_exp_rcv_invalid(fp, &tinfo);
		if (ret)
			break;

		addr = (void __user *)(unsigned long)cmd.addr +
		       offsetof(struct hfi1_tid_info, tidcnt);
		if (copy_to_user(addr, &tinfo.tidcnt, sizeof(tinfo.tidcnt)))
			ret = -EFAULT;
		break;


>  	case HFI1_CMD_TID_FREE:
> -		ret = exp_tid_free(fp, &tinfo);
> +		ret = hfi1_user_exp_rcv_clear(fp, &tinfo);
> +		addr = (unsigned long)cmd.addr +
> +			offsetof(struct hfi1_tid_info, tidcnt);
> +		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
> +				 sizeof(tinfo.tidcnt)))
> +			ret = -EFAULT;
>  		break;

This is an information leak.  We should break if
hfi1_user_exp_rcv_clear() fails, but instead we copy uninitialized
variables to the user.



>  	case HFI1_CMD_RECV_CTRL:
>  		ret = manage_rcvq(uctxt, subctxt_fp(fp), (int)user_val);
> @@ -607,9 +603,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
>  		 * Use the page where this context's flags are. User level
>  		 * knows where it's own bitmap is within the page.
>  		 */
> -		memaddr = ((unsigned long)dd->events +
> -			   ((uctxt->ctxt - dd->first_user_ctxt) *
> -			    HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;
> +		memaddr = (unsigned long)(dd->events +
> +					  ((uctxt->ctxt - dd->first_user_ctxt) *
> +					   HFI1_MAX_SHARED_CTXTS)) & PAGE_MASK;

I am too lazy to investigate the types of all these variables but I'm
instead going to assert that moving the cast to later is an unrelated
white space change.  Don't mix white space changes in with a behavior
change patch because it makes it hard to review.

regards,
dan carpenter
