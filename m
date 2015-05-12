From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Tue, 12 May 2015 02:13:53 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1107C20E@CRSMSX101.amr.corp.intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418DF0669B6E6CABE1D9F1EB1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <20BA79B2-9DA5-49B3-8455-BD4021CB882C@cisco.com>
 <20150511064232.GA3042@phlsvsds.ph.intel.com>
 <D72B89F6-B333-4DC2-9BA7-CB45EBC31843@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D72B89F6-B333-4DC2-9BA7-CB45EBC31843-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On May 10, 2015, at 11:42 PM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Tue, May 05, 2015 at 08:22:21PM +0000, Dave Goodell (dgoodell) wrote:
> >>
> >> In the case that usNIC is operating in UDP mode (which is the overwhelming
> majority of the cases), there is absolutely no additional protocol that ends up on
> the wire or headers in the user buffers besides UDP/IP/Ethernet.  They are
> 100% plain UDP packets, they just happen to be sent via OS-bypass queues
> instead of traveling through the kernel networking stack.
> >>
> >> [^^^^^ there continues to be confusion about this for some reason, but I
> don't know why]
> >
> > So what is this patch for?
> 
> Does my earlier email clarify the situation any?  http://marc.info/?l=linux-
> rdma&m=142972178630720&w=2

Somewhat, is there any reason applications need to distinguish between the " The legacy RDMA_TRANSPORT_USNIC type" and " The current RDMA_TRANSPORT_USNIC_UDP type"?

Or does the former no longer exist?

> 
> > commit 248567f79304b953ea492fb92ade097b62ed09b2
> > Author: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> > Date:   Thu Jan 9 14:48:19 2014 -0800
> >
> > IB/core: Add RDMA_TRANSPORT_USNIC_UDP
> >
> > Add RDMA_TRANSPORT_USNIC_UDP which will be used by usNIC.
> >
> > Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> >
> > This is probably where a lot of the confusion is coming from.
> 
> Arguably RDMA_TRANSPORT_USNIC_UDP could/should have simply been
> named RDMA_TRANSPORT_UDP.

I guess I'm wondering if there needs to be an RDMA_TRANSPORT_USNIC to represent the " The legacy RDMA_TRANSPORT_USNIC type" you mention in the link above.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
