From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 21:12:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D1567F@ORSMSX109.amr.corp.intel.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
 <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D15319@ORSMSX109.amr.corp.intel.com>
 <D0DEB791-D0BE-489F-AA66-7055099108B0@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D155AC@ORSMSX109.amr.corp.intel.com>
 <4791BCBA-FF5C-4F4D-90D1-C5B7981B02E4@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4791BCBA-FF5C-4F4D-90D1-C5B7981B02E4-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> 	AFAIK can see from the code, the CA node type corresponds to the
> >> "IBV_TRANSPORT_IB."  The packet format might change slightly depending
> on
> >> QP type, but the *base* transport remains IB.
> >
> > You're right from an API perspective.  The actual transport layer is
> reported by verbs using multiple fields: transport + QP type.
> 
> I don't know what you mean.  The transport is independent of the QP type.
> static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
> ...
> 	printf("\ttransport:\t\t\t%s (%d)\n",
> 	       transport_str(ib_dev->transport_type), ib_dev-
> >transport_type);
> ...
> Am I looking in the right place?

I'm simply saying that, for IB, what we call the QP type is actually the transport level protocol.  IIRC, when iwarp was added, we added transport_type to distinguish between QP type RC being IB or iWarp transport.  The result is that the actual transport level protocol is some combination between QP type and transport_type.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
