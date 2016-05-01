From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Sun, 1 May 2016 11:31:00 +0300
Message-ID: <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB046FD8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/04/2016 19:35, Hefty, Sean wrote:
>> For a lot of applications, we want to hide the lower level protocol. For
>> example, we try hard to hide whether IB/RoCE is used by an application.
>> Thus, is it wise to expose this thing in API?
>
> IMO - yes.
>
> An application must know what protocol it is using in order to communicate at all.  Even sockets exposes the protocol to the app.  If an app truly doesn't care, it still needs a generic way to determine if it is using matching protocols.
>

I think socket protocols resembles QP types more than how we use 
protocols in the IB world.

>> A user creates a UD QP, he doesn't know or care whether the lower layer
>> is Ethernet (RoCE v1/V2) or IB.
>
> He cares if that there's more than one choice available.  There are no guarantees that a ud qp can communicate with some other ud qp.
>

One of the core questions here is where do we draw the line between the 
application and the administrator. For example, we could say that an 
administrator could configure the protocol we use as default for the 
fabric and that an application with the right privileges could override 
this default protocol.

Saying that, maybe we should query a QP for its attributes only after it 
is created and a protocol is somehow assigned to it. What do you think?

>> I agree that the max_lso could be different for various QP types and
>> maybe probing a QP type would be favorable that getting this information
>> in a generic query_device.
>
> The qp type is being used as a stand-in for the transport protocol.  This worked when the APIs were developed and the only transport was IB.  But it is not true today.
>

Agree, a QP type hides now several protocols. However, most applications 
that were written in this IB-only verbs world functions great under 
other protocols. It sometimes depend on an administrator configurations 
and such, but still.

> LSO ultimately applies to a specific protocol.  IMO that's what needs to be captured.  Applications can still check for this in a generic fashion by matching which protocol (value) it is using against the LSO protocol support.
>

If a protocol is already assigned when an application queries a QP type, 
we get that a QP type uniquely defines a protocol for this application 
and thus querying a QP type is enough.
If that's not the case, an application needs to somehow ask for a 
specific protocol (and it might needs to be privileged to do so).

So, what do you think about stating an optional protocol in create_qp 
and putting LSO in query_qp?

Thanks for taking a look.

> - Sean
>

Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
