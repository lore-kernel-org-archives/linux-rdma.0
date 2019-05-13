From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: Annoying gcc / rdma / networking warnings
Date: Mon, 13 May 2019 01:11:42 +0000
Message-ID: <20190513011131.GA7948@mellanox.com>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
Content-Language: en-US
Content-ID: <033C054F7D32E54F9DBDAE6C64BA08E5@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 11, 2019 at 12:52:06PM -0400, Linus Torvalds wrote:
> Jason and Davem,
>  with gcc-9, I'm now seeing a number of annoying warnings from the
> rdma layer. I think it depends on the exact gcc version, because I'm
> seeing them on my laptop but didn't see them on my desktop, probably
> due to updating at different times.

I can see them too on a latest FC30 compiler.. It is pretty amazing
FC30 shipped this month with a compiler that was just released 10 days
ago. :)

Also a lot of of 'taking address of a packed member' warnings in RDMA
code for structs that probably should be aligned(4) not packed. I'll
have to look at those more carefully this week and see what can be
done.

> So if you look at the types like gcc does, then the rdma layer really
> is passing a pointer to a 16-byte sockaddr, and then filling it with
> (much bigger) sockaddr_ip6 data.

It looks like gcc is assuming that since we started with the _sockaddr
union member that the memory is actually bounded to that specific
member. This doesn't seem unreasonable and matches a lot of uses of
unions. However I wonder how that sort of analysis is going to work in
the kernel, considering our container_of idiom breaks it in the same
way, but maybe that is special case'd..

So if we tell gcc the sockaddr memory is actually the whole union then
it becomes happy, see below.

> So David, arguably the kernel "struct sockaddr" is simply wrong, if it
> can't contain a "struct sockaddr_in6". No? Is extending it a huge
> problem for other users that don't need it (mainly stack, I assume..)?

We have sockaddr_storage for this, and arguably this code is just
over-optimizing to save a few bytes of stack vs sockaddr_storage..
=20
> Also equally arguably, the rdma code could just use a "struct
> sockaddr_in6 for this use and avoid the gcc issue, couldn't it?=20

I think the specific sockaddr types should only ever be used if we
*know* the sa_family is that type. If the sa_family is not known then
it should be sockaddr or sockaddr_storage. Otherwise things get very
confusing.

When using sockaddr_storage code always has the cast to sockaddr
anyhow, as it is not a union, so this jaunty cast is not out of place
in sockets code.

Below silences the warning, and the warning continues to work in other
cases, ie if I remove _sockaddr_in6 from the union I do get compile
warnings about out of bound references.

Jason

>From 38a4d7e4644a13378c11381feb3936aa1faf9f58 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@mellanox.com>
Date: Sun, 12 May 2019 21:57:57 -0300
Subject: [PATCH] RDMA: Directly cast the sockaddr union to sockaddr

gcc 9 now does allocation size tracking and thinks that passing the member
of a union and then accessing beyond that member's bounds is an overflow.

Instead of using the union member, use the entire union with a cast to
get to the sockaddr. gcc will now know that the memory extends the full
size of the union.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/addr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.=
c
index 0dce94e3c49561..d0b04b0d309fa6 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -730,8 +730,8 @@ int roce_resolve_route_from_path(struct sa_path_rec *re=
c,
 	if (rec->roce.route_resolved)
 		return 0;
=20
-	rdma_gid2ip(&sgid._sockaddr, &rec->sgid);
-	rdma_gid2ip(&dgid._sockaddr, &rec->dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid, &rec->sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid, &rec->dgid);
=20
 	if (sgid._sockaddr.sa_family !=3D dgid._sockaddr.sa_family)
 		return -EINVAL;
@@ -742,7 +742,7 @@ int roce_resolve_route_from_path(struct sa_path_rec *re=
c,
 	dev_addr.net =3D &init_net;
 	dev_addr.sgid_attr =3D attr;
=20
-	ret =3D addr_resolve(&sgid._sockaddr, &dgid._sockaddr,
+	ret =3D addr_resolve((struct sockaddr *)&sgid, (struct sockaddr *)&dgid,
 			   &dev_addr, false, true, 0);
 	if (ret)
 		return ret;
@@ -814,22 +814,22 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *=
sgid,
 	struct rdma_dev_addr dev_addr;
 	struct resolve_cb_context ctx;
 	union {
-		struct sockaddr     _sockaddr;
 		struct sockaddr_in  _sockaddr_in;
 		struct sockaddr_in6 _sockaddr_in6;
 	} sgid_addr, dgid_addr;
 	int ret;
=20
-	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
+	rdma_gid2ip((struct sockaddr *)&sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&dgid_addr, dgid);
=20
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	dev_addr.net =3D &init_net;
 	dev_addr.sgid_attr =3D sgid_attr;
=20
 	init_completion(&ctx.comp);
-	ret =3D rdma_resolve_ip(&sgid_addr._sockaddr, &dgid_addr._sockaddr,
-			      &dev_addr, 1000, resolve_cb, true, &ctx);
+	ret =3D rdma_resolve_ip((struct sockaddr *)&sgid_addr,
+			      (struct sockaddr *)&dgid_addr, &dev_addr, 1000,
+			      resolve_cb, true, &ctx);
 	if (ret)
 		return ret;
=20
--=20
2.21.0
