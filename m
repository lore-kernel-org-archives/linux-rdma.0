From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Fri, 15 May 2015 17:02:57 +0200
Message-ID: <55560AA1.9040901@profitbricks.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>	 <1431529914.2377.22.camel@redhat.com>	 <1828884A29C6694DAF28B7E6B8A82373A8FDA105@ORSMSX109.amr.corp.intel.com>	 <5555AEE5.9060503@profitbricks.com> <1431700819.27722.15.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431700819.27722.15.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/15/2015 04:40 PM, Doug Ledford wrote:
[snip]
> 
> The test itself doesn't mean that.  It means we need a RoCE address
> (it's true when transport is IB and link layer is Ethernet).  That we
> *use* it during connectionless communication because we have to generate
> our own address vector for the packet while during connected queue pair
> use the address vector is created by the card using the queue pair
> information is just the circumstance of its use.  And even though a
> disconnected queue pair isn't solidly connected to a remote endpoint, it
> is solidly bound to an adapter that requires either an IB or Ethernet
> address family.  Maybe this to resolve your issue with the wording:

Thanks for the explain :-) The term 'connectionless' still sounds a little
strange to me when it's just means no HW support on creating address vector,
but I can understand the concept.

> 
> This helper is true when the address family of this queue pair is of the
> Ethernet (RoCE) variety.

Sounds good, will be merged in next version :-)

Regards,
Michael Wang

> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
