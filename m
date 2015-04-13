From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Mon, 13 Apr 2015 23:50:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC0C00@ORSMSX109.amr.corp.intel.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBE792@ORSMSX109.amr.corp.intel.com>
 <7F44EA5110810A40B7DAFB605C41975D58F98121@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D58F98121-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, this comment probably could use a reword..
> > > +	IB_GID_TYPE_IB        = 0,
> > > +	IB_GID_TYPE_ROCE_V2   = 1,
> > > +	IB_GID_TYPE_SIZE
> > > +};
> >
> > Can you explain the purpose of defining a 'GID type'.  A GID is just a
> global
> > address.  Why does it matter to anyone using it how it was constructed?
> 
> This is part of RoCE V2 Specification.  Please refer to Section A 17.8 .
> The GID Type determines the protocol for outbound packet generation i.e
> RoCE V1 (0x8915 Ether Type) or RoCEV2 (IPv4 or IPv6)

This isn't an interface for the RoCE specification.  Why does this need to be added to the verbs interface?  It hasn't been needed by apps yet, and I don't see why the apps should be made to care now how the GID is formatted.

> > > @@ -265,7 +295,9 @@ enum ib_port_cap_flags {
> > >  	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
> > >  	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
> > >  	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
> > > -	IB_PORT_IP_BASED_GIDS			= 1 << 26
> > > +	IB_PORT_IP_BASED_GIDS			= 1 << 26,
> > > +	IB_PORT_ROCE				= 1 << 27,
> > > +	IB_PORT_ROCE_V2				= 1 << 28,
> >
> > Why does RoCE suddenly require a port capability bit?  RoCE runs today
> > without setting any bit.
> Again, this is part of RoCE V2 SPEC, please refer to Section A17.5.1-
> Query HCA(Pasting snippet below)
> A new "RoCE Supported" capability bit shall be added to the Port
> Attributes
> list. This capability bit applies exclusively to ports of the new
> "RoCEv2" type

Same comment as above.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
