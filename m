From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: set Gen3 half-swing for integrated devices
Date: Thu, 5 Nov 2015 11:41:23 -0500
Message-ID: <20151105164121.GA14837@phlsvsds.ph.intel.com>
References: <1446689168-21620-1-git-send-email-ira.weiny@intel.com> <20151105073448.GQ18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151105073448.GQ18797@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 10:34:48AM +0300, Dan Carpenter wrote:
> On Wed, Nov 04, 2015 at 09:06:08PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
> > +#define CCE_PCIE_CTRL_XMT_MARGIN_GEN1_GEN2_OVERWRITE_ENABLE_MASK 0x1ull
> 
> There is absolutely no point to having a variable name which is nine
> bajillion characters long since we are not able to use it and have to
> instead use macro majic to hide the first twelve zillion characters.
>

The long names are directly from the hardware specification.

>
> If
> we can't even see the name when it is used, then why does it exist? Also
> macro magic breaks grep and cscope.  Just think of a better name to
> begin with and get rid of the PC macro.

We did not want the PC macro but using the "real" names caused checkpatch
failures.  Indeed using the PC macro reduces the readability of the code in
terms of following the hardware spec because we lose the "real" name.

Is this an example where we should ignore the line lengths of checkpatch to
preserve the readability of the code?

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
