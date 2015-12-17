From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/14] staging/rdma/hfi1: Start adding building blocks for TID caching
Date: Thu, 17 Dec 2015 15:56:58 -0500
Message-ID: <20151217205658.GA13023@phlsvsds.ph.intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com> <1450335624-12134-9-git-send-email-ira.weiny@intel.com> <20151217115952.GI5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151217115952.GI5284@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 17, 2015 at 02:59:52PM +0300, Dan Carpenter wrote:
> On Thu, Dec 17, 2015 at 02:00:18AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +}
> > +
> > +static int program_rcvarray(struct file *fp, unsigned long vaddr,
> > +			    struct tid_group *grp,
> > +			    struct tid_pageset *sets,
> > +			    unsigned start, u16 count, struct page **pages,
> > +			    u32 *tidlist, unsigned *tididx, unsigned *pmapped)
> > +{
> 
> It's not clear what a zero return from this function means.  Could we
> add some documentation?

Added the following.

/**
 * program_rcvarray() - program an RcvArray group with receive buffers
 * @fp: file pointer
 * @vaddr: starting user virtual address
 * @grp: RcvArray group
 * @sets: array of struct tid_pageset holding information on physically
 *        contiguous chunks from the user buffer
 * @start: starting index into sets array
 * @count: number of struct tid_pageset's to program
 * @pages: an array of struct page * for the user buffer
 * @tidlist: the array of u32 elements when the information about the
 *           programmed RcvArray entries is to be encoded.
 * @tididx: starting offset into tidlist
 * @pmapped: (output parameter) number of pages programmed into the RcvArray
 *           entries.
 *
 * This function will program up to 'count' number of RcvArray entries from the
 * group 'grp'. To make best use of write-combining writes, the function will
 * perform writes to the unused RcvArray entries which will be ignored by the
 * HW. Each RcvArray entry will be programmed with a physically contiguous
 * buffer chunk from the user's virtual buffer.
 *
 * Return:
 *  -EINVAL if the requested count is larger than the size of the group,
 *  -ENOMEM or -EFAULT on error from set_rcvarray_entry(), or
 *  number of RcvArray entries programmed.
 */


Ira

> 
> regards,
> dan carpenter
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
