From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Thu, 16 Apr 2015 22:32:53 +0000
Message-ID: <DB4PR05MB0863C1F08DB56D677265A7BDB1E40@DB4PR05MB0863.eurprd05.prod.outlook.com>
References: <DB4PR05MB0863248FC7422B05765DD8E5B1E40@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <DB4PR05MB0863F49028F5E0E252278A6BB1E40@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC3752@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC3752-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Somnath Kotur (Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org)" <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > The RoCE Verbs interface references the HCA GID table in QPs and AHs,
> > for all RoCE versions.
> 
> The IBTA specifically does not define software interfaces.  The concern here is
> the architecture and definition of the linux rdma software stack, not verbs,
> despite the fact that the layer is named that.
>

Whatever.
The ib_* API is the Linux implementation for IBTA Verbs (both Infiniband and RoCE flavors) and iWARP Verbs.
This interface uses a GID table.
In this patch-set, there is no conceptual change in this regard.
It adds GID types, as stated by the RoCE specification, which is a natural extension to the existing code.
I am sure that we can consider additional changes in the future, but one patch-set at a time...
 
> > As I said earlier, the network layer (e.g., IPv4, IPv6, or GRH) cannot
> > be a port attribute because RoCE HCAs support all of them over the
> > same physical port.
> 
> IMO, the architecture needs to change to support multiple network and
> transport layers over the same link layer.  The current restriction of 1
> "transport" per port is too restrictive, and doesn't seem to be true even for
> current devices, like usnic.
> 

usnic uses UDP transport.
Infiniband and RoCE use the IB transport (all the BTH+ header stuff as defined by IBTA).
iWARP uses IETF defined protocols over TCP, namely RDMAP+DDP+MPA.

I am not aware of any device that mixes these transports today.
If we ever see such a need in the future, let's talk again. Currently, this is irrelevant.

> > Maybe we should change these patches to encode the port "summary" as a
> > bit mask, and provide convenient masks for queries?
> 
> Switching to bit masks is the longer term objective.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
