From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 28 Apr 2016 16:35:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5721C3AD.8050407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For a lot of applications, we want to hide the lower level protocol. For
> example, we try hard to hide whether IB/RoCE is used by an application.
> Thus, is it wise to expose this thing in API?

IMO - yes.

An application must know what protocol it is using in order to communicate at all.  Even sockets exposes the protocol to the app.  If an app truly doesn't care, it still needs a generic way to determine if it is using matching protocols.

> A user creates a UD QP, he doesn't know or care whether the lower layer
> is Ethernet (RoCE v1/V2) or IB.

He cares if that there's more than one choice available.  There are no guarantees that a ud qp can communicate with some other ud qp.

> I agree that the max_lso could be different for various QP types and
> maybe probing a QP type would be favorable that getting this information
> in a generic query_device.

The qp type is being used as a stand-in for the transport protocol.  This worked when the APIs were developed and the only transport was IB.  But it is not true today.

LSO ultimately applies to a specific protocol.  IMO that's what needs to be captured.  Applications can still check for this in a generic fashion by matching which protocol (value) it is using against the LSO protocol support.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
