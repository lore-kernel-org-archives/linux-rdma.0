From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Wed, 13 May 2015 20:41:57 +0000
Message-ID: <HE1PR05MB1418BFAF1310893F2F2E1CF6B1D90@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <1431111412.2407.463.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCD719@ORSMSX109.amr.corp.intel.com>
 <1431117051.2407.468.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCD78C@ORSMSX109.amr.corp.intel.com>
 <20150508214855.GA3917@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150508214855.GA3917-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]

> > > If you had a device that supported iWARP and RoCE on the same
> > > physical link layer, then yes, the app would need a means of saying
> > > which transport to use in addition to the type of QP to establish.
> >
> > Ah - got it now.  And I agree, there should be some way to specify
> > this at the QP level.

Supporting iWARP and RoCE over the same RDMA device makes no sense.
First of all, it is confusing to the user. It's like supporting SRP and iSCSI
using the same SCSI device instance...

Second, different technologies affect much more than the QP. 
A technology determines the format and semantics of the whole interface.
For example, AHs, memory windows, atomics, CQE formats are different as well.
Just thinking of how to abstract all these in  single device is mind-boggling.

Finally, there is no sane way to describe device capabilities. There is no
single set of capabilities that applies to all of these technologies consistently.

> 
> Yes, the only way out is to specify on a per QP basis the addressing and
> protocol/transport/whatever thing. Socket uses the AF,SOCK,PROTO tuple to
> specify this information. We can probably productively use a similar
> breakdown:

We might consider such abstractions at the CMA layer, not at the device level.
Essentially, this is what the CMA was intended for.

> 
> AF_IB,SOCK_RC,PROTO_IBA  // InfiniBand
> AF_OPA,SOCK_RC,PROTO_IBA // Future 32 bit LID OPB 'InfiniBand'

This is not PROTO_IBA.

> AF_ETH,SOCK_RC,PROTO_IBA // RoCEv1
> AF_INET,SOCK_RC,PROTO_IBA // InfiniBand or RoCEv2, depending on the Link
> Layer AF_ETH,SOCK_RC,PROTO_USNIC AF_INET,SOCK_RC,PROTO_USNIC
> AF_INET,SOCK_RC,PROTO_IWARP
> 

[snip]
> 
> 
> Realistically, today, if a RoCE/iWarp driver appeared then it would have to
> present to the system as two RDMA devices.
> 

Exactly!
--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
