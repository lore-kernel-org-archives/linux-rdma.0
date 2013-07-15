From: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Repeated Stale Connection errors on successive reconnect attempt with
 new cmid/QPs..
Date: Mon, 15 Jul 2013 07:45:20 -0700
Message-ID: <CABqF1pak6PG=gnuDPgj+pY4cSqGcASTyKdhezALTWtEvnSHFwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,
I am using rdmacm as my connection manager and I have N processes tryin=
g to
establish a complete mesh of connections over RC protocol.

I am receiving Connection rejected event with error 10.  As per the
IBTA, the Connection Server
is rejecting the connection requests thinking that it is a stale connec=
tion.

I read an earlier response from Sean stating that it is advisable to
recreate the QP and retry
the connection. That is exactly what I am doing.
Everytime I get err 10, I destroy the cmid and the attached QP, and go
through the entire
connection management again. (create a new cmid, resolve addr/resolve
route/ connect)

The reconnect attempt succeeds until the Route resolve step, at which
point I create a new QP, and issue the connect.
I am stuck in this loop where I keep getting Rejects (err 10) after
repeated attempts.
It almost seems as if the underlying QP number is being recycled and
the remote Connection server keeps rejecting the connection requests.

As per the IBTA:
"A CM may receive a REQ/REP specifying a remote QPN in
=93REQ:local QPN=94/=94REP:local QPN=94 that the CM already considers c=
onnected
to a local QP. A local CM may receive such a REQ/REP if its local
QP has a stale connection, as described in section 12.4.1. When a CM
receives such a REQ/REP it shall abort the connection establishment by
issuing REJ to the REQ/REP. It shall then issue DREQ, with =93DREQ:remo=
te
QPN=94 set to the remote QPN from the REQ/REP, until DREP is received
or Max Retries is exceeded, and place the local QP in the TimeWait stat=
e"

So, the connection Server should issue a disconnect request. But the co=
nnecting
client does not get any disconnect requests..? Should librdmacm be
sending out this
disconnect..? Could this be a bug in the kernel driver..?


I scanned the source for cm.c, and I dont see the kernel driver
issuing a disconnect when it detects a stale connection...


-Lokesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
