From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 11 May 2015 02:42:33 -0400
Message-ID: <20150511064232.GA3042@phlsvsds.ph.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com> <1430720099-32512-2-git-send-email-ira.weiny@intel.com> <1430750492.2407.9.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com> <1430761111.2407.85.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com> <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com> <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20BA79B2-9DA5-49B3-8455-BD4021CB882C-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 05, 2015 at 08:22:21PM +0000, Dave Goodell (dgoodell) wrote:
> On May 5, 2015, at 2:51 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> > 
> >>> I thought USNIC_UDP had an embedded USNIC protocol header inside the
> >>> UDP header.  That would make it a UDP_ENCAP protocol.
> >> 
> >> Someone from Cisco can correct me, but USNIC supports 2 protocols.  Just
> >> plain UDP, and a proprietary protocol that runs over Ethernet, but uses the
> >> same EtherType as RoCE.  I thought these could both be active on the same
> >> port at the same time.
> >> 
> > 
> > 'protocol' refers to what your device generates when you do a post_send() on 
> > some QP.
> > In the RoCE case, it is IBTA transport headers + payload over UDP encapsulation
> > over IP. In the USNIC case, you might want the protocol to refer to addition
> > information the distinguishes this wire protocol rather than just "I am sending
> > UDP packets"...
> 
> In the case that usNIC is operating in UDP mode (which is the overwhelming majority of the cases), there is absolutely no additional protocol that ends up on the wire or headers in the user buffers besides UDP/IP/Ethernet.  They are 100% plain UDP packets, they just happen to be sent via OS-bypass queues instead of traveling through the kernel networking stack.  
> 
> [^^^^^ there continues to be confusion about this for some reason, but I don't know why]

So what is this patch for?

commit 248567f79304b953ea492fb92ade097b62ed09b2
Author: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Date:   Thu Jan 9 14:48:19 2014 -0800

IB/core: Add RDMA_TRANSPORT_USNIC_UDP
        
Add RDMA_TRANSPORT_USNIC_UDP which will be used by usNIC.
	        
Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

This is probably where a lot of the confusion is coming from.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
