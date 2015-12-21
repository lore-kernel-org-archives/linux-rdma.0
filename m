From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 01/13] staging/rdma/hfi1: Use BIT macro
Date: Mon, 21 Dec 2015 13:46:13 -0800
Message-ID: <20151221214613.GA8842@kroah.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
 <1447729175-28745-2-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447729175-28745-2-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2015 at 09:59:23PM -0500, Jubin John wrote:
> This patch fixes the checkpatch issue:
> CHECK: Prefer using the BIT macro
> 
> Use of BIT macro for HDRQ_INCREMENT in chip.h causes a change in
> format specifier for error message in init.c in order to avoid a
> build warning.
> 
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch, and a few others in this series did not apply.  Please fix
them up and resend the ones I missed.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
