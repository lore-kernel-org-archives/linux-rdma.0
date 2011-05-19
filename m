From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 22:37:48 +0300
Message-ID: <20110519193748.GE2659@mtldesk30>
References: <20110519060704.GA2659@mtldesk30>
 <1305796637.2359.6.camel@deela.quest-ce.net>
 <20110519093402.GB2659@mtldesk30>
 <1305802216.2359.11.camel@deela.quest-ce.net>
 <1828884A29C6694DAF28B7E6B8A82373FE8B@ORSMSX101.amr.corp.intel.com>
 <1305816321.2359.15.camel@deela.quest-ce.net>
 <1305817426.2359.23.camel@deela.quest-ce.net>
 <20110519154650.GD2659@mtldesk30>
 <1305824364.2359.37.camel@deela.quest-ce.net>
 <1828884A29C6694DAF28B7E6B8A82373FF57@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373FF57-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org" <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2011 at 06:06:03PM +0000, Hefty, Sean wrote:
> 
> max_qp_wr does not distinguish between max send or receive or indicate if those values should be the same.  IMO, Setting
> 
> max_qp_wr = max(send wr, recv wr)
> 
> makes more sense than
> 
> max_qp_wr = min(send wr, recv wr)
> 
> The maximum values reported are not meant to be guaranteed minimums.
> 

Here's what the spec says:
The maximum number of outstanding work requests on any
Work Queue supported by this HCA.

I think the text should be interpreted as you said:
max_qp_wr = max(send wr, recv wr)

But I also don't find much use for the value returned by query HCA.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
