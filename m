From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 3/3] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Thu, 19 Nov 2015 16:54:44 -0800
Message-ID: <20151120005444.GA32083@kroah.com>
References: <1447112084-12532-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447112084-12532-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 06:34:44PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add a module paramter to toggle prescan/Fast ECN Detection and remove the
> Kconfig option which used to control this.

Ick, no, not a module parameter, that's horrid (hint, it isn't a
per-device option...)

Why can't you do this dynamically?
Why would anyone ever want to make this "slow"?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
