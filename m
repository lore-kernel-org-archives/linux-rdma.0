From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 09:11:02 -0700
Message-ID: <20150818161102.GA4040@kroah.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150818141542.4127.90517.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
> The move from infiniband to staging requires a temporary
> PCI dependency to fix 0-day build issues.  The
> drivers/infiniband/hw/Kconfig gratuitously added it for all drivers.
> 
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/hfi1/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why are these drivers not in drivers/staging/infiniband/ ?  Why do they
all need their own drivers/staging/ directory?

Anyway, either way, I can't take this patch as it's only in the rdma
trees at the moment, not in mine.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
