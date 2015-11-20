From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 2/2] staging/rdma/hfi1: Eliminate WARN_ON when VL is
 invalid
Date: Fri, 20 Nov 2015 08:35:42 -0800
Message-ID: <20151120163542.GA31501@kroah.com>
References: <1447114701-11003-1-git-send-email-jubin.john@intel.com>
 <1447114701-11003-3-git-send-email-jubin.john@intel.com>
 <20151120005837.GA18080@kroah.com>
 <32E1700B9017364D9B60AED9960492BC259BD7E1@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259BD7E1-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 03:23:55PM +0000, Marciniszyn, Mike wrote:
> > >  drivers/staging/rdma/hfi1/sdma.c |   12 ++++++++++--
> > >  1 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > Doesn't apply to my tree :(
> 
> Ok.
> 
> Is the inprocess branch available?

I do not understand what you mean here :(
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
