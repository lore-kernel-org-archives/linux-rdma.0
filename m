From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Fri, 18 Jun 2010 10:23:27 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E5A7C65@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
 <adask52o9p6.fsf@roland-alpha.cisco.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Unfortunately for IB the size of an RMPP response and buffer cannot be
> controlled by the kernel.  So if an application has a large response to
> send, the entire buffer must be copied into the kernel and the kernel
> cannot decide on its own segmentation boundaries.  Hence the ability for
> selected management applications to control and limit the amount of kernel
> memory space is desirable.  These issues become serious at scale when
> larger RMPP responses are needed and more clients may also be issuing
> requests.  The two can combine and result in N^2 types behavior for kernel
> memory footprint relative to N=cluster node count or potentially N=cluster
> CPU core count.

There's no requirement that an entire RMPP response be copied to the kernel before being sent.  The current implementation does this, but that behavior can be modified to copy the data only when needed.  The total number of outstanding sends that a client can have can also be restricted to throttle back a client trying to send large messages to everyone on the fabric.

> >There are QLogic customers who have requested the ability to perform
> >RMPP transaction handling in user space.  This was an option in our old
> >proprietary stack and there are a few customers still using it which
> >need a way to forward migrate to OFED while containing the scope of
> >their application changes.  While we have developed appropriate "shim"
> libraries to allow their applications to migrate, we can't simulate/shim
> rmpp processing without some kernel support.

There's nothing that prevents RMPP from running between an application and a library, with the library exchanging reassembled mads with the kernel.  It may not be ideal from your perspective, but I don't see why it's not possible to support existing applications.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
