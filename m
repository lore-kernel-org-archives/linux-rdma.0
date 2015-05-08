From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Fri, 8 May 2015 15:48:55 -0600
Message-ID: <20150508214855.GA3917@obsidianresearch.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <1431111412.2407.463.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCD719@ORSMSX109.amr.corp.intel.com>
 <1431117051.2407.468.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCD78C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCD78C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 08, 2015 at 08:56:16PM +0000, Hefty, Sean wrote:

> > If you had a device that supported iWARP and RoCE on the same physical
> > link layer, then yes, the app would need a means of saying which
> > transport to use in addition to the type of QP to establish.
> 
> Ah - got it now.  And I agree, there should be some way to specify
> this at the QP level.

Yes, the only way out is to specify on a per QP basis the addressing
and protocol/transport/whatever thing. Socket uses the AF,SOCK,PROTO
tuple to specify this information. We can probably productively use a
similar breakdown:

AF_IB,SOCK_RC,PROTO_IBA  // InfiniBand
AF_OPA,SOCK_RC,PROTO_IBA // Future 32 bit LID OPB 'InfiniBand'
AF_ETH,SOCK_RC,PROTO_IBA // RoCEv1
AF_INET,SOCK_RC,PROTO_IBA // InfiniBand or RoCEv2, depending on the Link Layer
AF_ETH,SOCK_RC,PROTO_USNIC
AF_INET,SOCK_RC,PROTO_USNIC
AF_INET,SOCK_RC,PROTO_IWARP

The expectation would be that any SOCK,PROTO combination can
'interoperate' with any AF combination - which is true with the above
examples, ie with the right magic NAT hardware RoCEv2/v1/IB/(OPA?) can
all interwork at the BTH layer.

Which is to also say, it also unambiguously implies which standard
defines the subtle verbs varietions that the app has to cope with.

Incompatible AH's can not be used with the wrong type of QP, the CM
layers would auto create QPs with the correct type to reflect how the
CM process was run, etc.

But Michael's patches are still an improvement, ie a RoCE + iWarp port
would still have the cap_mad as true and would still have to create a
QP1 interface, which I think is captured OK. The CM side probably
explodes if a port is both iWarp and RoCE, but that is alot of work to
fix anyhow..

I think we have to tackle the addressing problem as part of the RoCEv2
stuff, just burying all this in a qp index is really horrible.

Realistically, today, if a RoCE/iWarp driver appeared then it would
have to present to the system as two RDMA devices.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
