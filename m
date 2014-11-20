From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA developers bi-weekly meeting minutes (11/20)
Date: Thu, 20 Nov 2014 13:46:38 -0500
Message-ID: <2DA1028B-0EE0-415F-BA98-B9A50C87F820@oracle.com>
References: <546E31C0.1070400@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546E31C0.1070400-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Nov 20, 2014, at 1:24 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Attendees:
>=20
> Jeff Becker (NASA)
> Yan Burman (Mellanox)
> Wendy Cheng (Intel)
> Rupert Dance (Soft Forge)
> Steve Dickson (Red Hat)
> Chuck Lever (Oracle)
> Doug Ledford (RedHat)
> Shirley Ma (Oracle)
> Sachin Prabhu (RedHat)
> Devesh Sharma (Emulex)
> Anna Schumaker (Net App)
> Steve Wise (OpenGridComputing, Chelsio)
>=20
> Moderator:
> Shirley Ma (Oracle)
>=20
> NFSoRDMA developers bi-weekly meeting is to help organizing NFSoRDMA =
development and test effort from different resources to speed up NFSoRD=
MA upstream kernel work and NFSoRDMA diagnosing/debugging tools develop=
ment. Hopefully the quality of NFSoRDMA upstream patches can be improve=
d by being tested with a quorum of HW vendors.
>=20
> Today's meeting notes:
>=20
> NFSoRDMA performance:
> ---------------------
> Even though NFSoRDMA performance seems better than IPoIB-cm, the gap =
between what the IB protocol can provide and what NFS(RDMA,IPoIB-cm) ca=
n achieve is still big on small I/O block size (focused on 8K IO size f=
or database workload). Even large I/O block size(128K above), NFS perfo=
rmance is not comparable to RDMA microbenchmark. We are focusing the ef=
fort to figure out the root cause. Several experimental methods have be=
en used on how to improve NFSoRDMA performance.
>=20
> Yan saw NFS server does RDMA send for small packet size, less than 10=
0bytes, which should have used post_send instead.

This is an artifact of how NFS/RDMA works.

The client provides a registered area for the server to write
into if an RPC reply is larger than the small pre-posted
buffers that are normally used.

Most of the time, each RPC reply is small enough to use RDMA
SEND, and the server can convey the RPC/RDMA header and the
RPC reply in a single SEND operation.

If the reply is large, the server conveys the RPC/RDMA header
via RDMA send, and the RPC reply via an RDMA WRITE into the
client=92s registered buffer.

Solaris server chooses RDMA SEND in nearly every case.

Linux server chooses RDMA SEND then RDMA WRITE whenever
the client offers that choice.

Originally, it was felt that doing the RDMA WRITE is better
for the client because the client doesn=92t have to copy the
RPC header from the RDMA receive buffer back into rq_rcv_buf.
Note that the RPC header is generally just a few hundred
bytes.

Several people have claimed that RDMA WRITE for small I/O
is relatively expensive and should be avoided. It=92s also
expensive for the client to register and deregister the
receive buffer for the RDMA WRITE if the server doesn=92t
use it.

I=92ve explored changing the client to offer no registered
buffer if it knows the RPC reply will be small, thus
forcing the server to use RDMA SEND where it=92s safe.

Solaris server worked fine. Of course, it already works
this way.

Linux server showed some data and metadata corruption on
complex workloads like kernel builds. There=92s a bug in
there somewhere that will need to be addressed before we
can change the client behavior.

The improvement was consistent, but under ten microseconds
per RPC with FRWR (more with FMR because deregistering the
buffer takes longer and is synchronous with RPC execution).

At this stage, there are bigger problems to be addressed,
so this is not a top priority.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
