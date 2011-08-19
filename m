From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/20 v2] rdma: Add XRC support
Date: Fri, 19 Aug 2011 02:14:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41B0A@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC provides a scalability enhancement when a process on one node
must communicate with multiple processes on another node.  This
is commonly the case when running MPI applications on multi-core
systems in a cluster.

An XRC connection consists of an initiator (XRC INI) qp and a target
(XRC TGT) qp.  A single xrc ini -> xrc tgt qp connection enables a
process to communicate with all remote processes on a single node.
Security is enforced through the use of a special type of protection
domain and shared receive queues.  An xrc srq is allocated
on an xrc domain.  The xrc tgt qp is also allocated on an xrc domain.
A process may receive data on an xrc srq from a tgt qp if the xrc
domains are the same.

The following patch series adds support for XRC.  The patches used
the patches found in Roland's xrc branch as a base, plus added in
patches found in the OFED 1.5 linux git tree.  The latter were mainly
used for updating the mlx4 driver.  I broke the patches up, so that
I could follow each change better.

This set differs from Roland's xrc branch in that XRC initiator and
target QP types are separated, and a type is specified when creating
an SRQ.  The patches differ from the OFED 1.5 patches by using the
existing QP APIs and ABI to create and manage XRC QPs.  XRCD's may
still be shared among multiple processes, and XRC QPs may be connected
out of band.

There are corresponding patches to libibverbs, libmlx4, and the
librdmacm to support XRC.

This patch sets are also available on the ofa server:

	git://git.openfabrics.org/~shefty/rdma-dev.git   xrc
	git://git.openfabrics.org/~shefty/libibverbs.git xrc
	git://git.openfabrics.org/~shefty/libmlx4.git    xrc
	git://git.openfabrics.org/~shefty/librdmacm.git  xrc

Changes from v1:
- Add ability for any process using an xrcd to open an existing tgt qp
- Provided update to ib_cm changes based on proposed errata.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
