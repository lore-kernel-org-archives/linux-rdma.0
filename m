From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/14] staging/rdma/hfi1: Start adding building blocks
 for TID caching
Date: Thu, 17 Dec 2015 14:23:39 +0300
Message-ID: <20151217112339.GH5284@mwanda>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
 <1450335624-12134-9-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450335624-12134-9-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 02:00:18AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
> +			      struct tid_group **grp)
> +{
> +	struct hfi1_filedata *fd = fp->private_data;
> +	struct hfi1_ctxtdata *uctxt = fd->uctxt;
> +	struct hfi1_devdata *dd = uctxt->dd;
> +	struct mmu_rb_node *node;
> +	u8 tidctrl = EXP_TID_GET(tidinfo, CTRL);
> +	u32 tidbase = uctxt->expected_base,
> +		tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
> +
> +	if (tididx > uctxt->expected_count) {

Should this be >= ?  I don't think it makes that much difference since
we're not using it as an offset.

> +		dd_dev_err(dd, "Invalid RcvArray entry (%u) index for ctxt %u\n",
> +			   tididx, uctxt->ctxt);
> +		return -EINVAL;
> +	}
> +
> +	if (tidctrl == 0x3)
> +		return -EINVAL;
> +
> +	rcventry = tidbase + tididx + (tidctrl - 1);
> +
> +	spin_lock(&fd->rb_lock);
> +	node = mmu_rb_search_by_entry(&fd->tid_rb_root, rcventry);
> +	if (!node) {
> +		spin_unlock(&fd->rb_lock);
> +		return -EBADF;
> +	}
> +	rb_erase(&node->rbnode, &fd->tid_rb_root);
> +	spin_unlock(&fd->rb_lock);
> +	if (grp)
> +		*grp = node->grp;
> +	clear_tid_node(fd, fd->subctxt, node);
> +	return 0;
> +}

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
