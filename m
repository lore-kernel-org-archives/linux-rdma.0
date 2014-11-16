From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next] RDMA/CMA: Mark IPv4 addresses correctly when the
 listener is IPv6
Date: Sun, 16 Nov 2014 09:04:33 +0000
Message-ID: <6c0a5a44a42a43ee96c05907dcdc0a51@AM3PR05MB0935.eurprd05.prod.outlook.com>
References: <1415893935-4583-1-git-send-email-ogerlitz@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237399E01B66@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E01B66-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Thursday, November 13, 2014 6:24 PM
> To: Or Gerlitz
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Roland Dreier; Yotam Kenneth
> Subject: RE: [PATCH for-next] RDMA/CMA: Mark IPv4 addresses correctly
> when the listener is IPv6
> 
> > From: Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > When accepting a new connection with the listener being IPv6, the
> > family of the new connection is set as IPv6. This causes cma_zero_addr
> > function to return true on an non-zero address. As a result, the wrong
> > code path is taken. This causes the connection request to be rejected,
> > as the RDMA-CM code looks for the wrong type of device.
> >
> > Since copying the ip address is done in different function depending
> > on the family (cma_save_ip4_info/cma_save_ip6_info) this is fixed by
> > hard coding the family of the IP address according to the function.
> >
> > Signed-off-by: Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/cma.c
> b/drivers/infiniband/core/cma.c
> > index d570030..6e5e11c 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -866,12 +866,12 @@ static void cma_save_ip4_info(struct rdma_cm_id
> *id,
> > struct rdma_cm_id *listen_i
> >
> >  	listen4 = (struct sockaddr_in *) &listen_id->route.addr.src_addr;
> >  	ip4 = (struct sockaddr_in *) &id->route.addr.src_addr;
> > -	ip4->sin_family = listen4->sin_family;
> > +	ip4->sin_family = AF_INET;
> >  	ip4->sin_addr.s_addr = hdr->dst_addr.ip4.addr;
> >  	ip4->sin_port = listen4->sin_port;
> >
> >  	ip4 = (struct sockaddr_in *) &id->route.addr.dst_addr;
> > -	ip4->sin_family = listen4->sin_family;
> > +	ip4->sin_family = AF_INET;
> >  	ip4->sin_addr.s_addr = hdr->src_addr.ip4.addr;
> >  	ip4->sin_port = hdr->port;
> >  }
> > @@ -883,12 +883,12 @@ static void cma_save_ip6_info(struct rdma_cm_id
> *id,
> > struct rdma_cm_id *listen_i
> >
> >  	listen6 = (struct sockaddr_in6 *) &listen_id->route.addr.src_addr;
> >  	ip6 = (struct sockaddr_in6 *) &id->route.addr.src_addr;
> > -	ip6->sin6_family = listen6->sin6_family;
> > +	ip6->sin6_family = AF_INET6;
> >  	ip6->sin6_addr = hdr->dst_addr.ip6;
> >  	ip6->sin6_port = listen6->sin6_port;
> >
> >  	ip6 = (struct sockaddr_in6 *) &id->route.addr.dst_addr;
> > -	ip6->sin6_family = listen6->sin6_family;
> > +	ip6->sin6_family = AF_INET6;
> >  	ip6->sin6_addr = hdr->src_addr.ip6;
> >  	ip6->sin6_port = hdr->port;
> 
> I can't say that I understand what the problem is or how the change
> fixes it.  Is listen4->sin_port above not AF_INET?  If that's the case,
> then aren't we still taking the wrong code path and just masking some
> bug further up in the code path?


An IPv6 listener socket can accept IPv4 connection, especially
when listening to the "any" interface. This behavior is
configurable with the net.ipv6.bindv6only sysctl flag. In
RDMA-CM, we use this flag as the baseline value for the CM-ID
flag "afonly". If afonly is set to 0, a listening RDMA-CM ID for
IPv6 any address will happily accept an IPv4 connection. The IP
addresses saved in cma_save_ip[46]_info are only used internally
in the RDMA-CM code for selecting the appropriate device for
answering and sending a reply. As such, there is no problem with
hard coding the appropriate address family in the functions.

Thanks,
--Shachar
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
