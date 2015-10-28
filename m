From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: RFC: RPC/RDMA memory invalidation
Date: Wed, 28 Oct 2015 15:56:08 -0400
Message-ID: <094A348A-0764-4F46-A422-FBF2F1DC1C28@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RPC/RDMA is moving towards a model where R_keys are invalidated
as part of reply handling (either the client does it in the
reply handler, or the server does it via Send With Invalidate).
This fences the RPC's memory from the server before the RPC
consumer is awoken and can access it.

There are some cases where no reply occurs, however.

- A signal such as ^C or a software fault

- A soft timeout

- A local RPC client error

- A GSS credential problem

The safest thing to do is to ensure that memory is completely
fenced (invalidated and DMA unmapped) before allowing such an
abnormally terminated RPC to exit and its memory to be re-used.

Unfortunately in the current kernel RPC client implementation
there is no place an RPC can park itself, after it is awoken
by means other than a reply, to wait for R_key invalidation
to complete. Even if invalidation is started asynchronously
as the RPC exits, it opens a window where an RPC can complete
and exit while the memory is still registered and exposed for
a short period.

One way to handle this rare situation is to ensure that such
an error exit always results in a connection loss if the
request has registered memory. Any registered memory would be
invalidated by the loss and fenced from the server; only a
DMA unmap, which never sleeps, would be needed before the RPC
exits.

Knocking the QP out of RTS may seem drastic, but I believe in
some of these cases the connection may already be gone.

A key question is whether connection loss guarantees that the
server is fenced, for all device types, from existing
registered MRs. After reconnect, each MR must be registered
again before it can be accessed remotely. Is this true for the
Linux IB core, and all kernel providers, when using FRWR?

After a connection loss, the Linux kernel RPC/RDMA client
creates a new QP as it reconnects, thus I=E2=80=99d expect the QPN to
be different on the new connection. That should be enough to
prevent access to MRs that were registered with the previous
QP and PD, right?

I ask here because I am often surprised by the subtlety of
standards language. ;-)

-=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
