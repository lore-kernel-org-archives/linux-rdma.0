From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 18/18] staging/rdma/hfi1: Workaround
 CONFIG_SDMA_VERBOSITY timing issue
Date: Fri, 20 Nov 2015 09:57:03 -0800
Message-ID: <20151120175703.GA15988@kroah.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-18-git-send-email-jubin.john@intel.com>
 <20151120011135.GH11695@kroah.com>
 <32E1700B9017364D9B60AED9960492BC259BD8A2@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC259BD8A2-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 04:01:18PM +0000, Marciniszyn, Mike wrote:
> > That sounds like a horrid hack, and this implies that a slower machine will
> > still have this problem...
> 
> Greg,
> 
> I'm NAK'ing this patch for two reasons:
> 1. Code underneath the CONFIG option is only used during rework
> 2. It is a hack as you have noted
> 
> We are going to take this up internally to get to the root cause.
> 
> Go ahead and drop or whatever you do.

This whole series is dropped from my queue, it needs to be fixed up and
resent before I will consider it again.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
