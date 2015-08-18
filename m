From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer section for hfi1
Date: Tue, 18 Aug 2015 08:44:03 -0700
Message-ID: <20150818154403.GB3049@kroah.com>
References: <20150818140609.3571.87830.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150818140609.3571.87830.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 10:06:09AM -0400, Mike Marciniszyn wrote:
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  0 files changed
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b3c1a56..45953e9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9892,6 +9892,13 @@ M:	Arnaud Patard <arnaud.patard-dQbF7i+pzddAfugRpC6u6w@public.gmane.org>
>  S:	Odd Fixes
>  F:	drivers/staging/xgifb/
>  
> +HFI1 DRIVER
> +M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +L:	devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
> +S:	Supported
> +F:	drivers/staging/hfi1

Why do this for a driver that is being deleted?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
