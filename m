From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/17] ib: Add support for XRC
Date: Wed, 15 Jun 2011 05:58:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373020FCB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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

XRC support is added to the ib_cm, however, there is an ongoing
discussion regarding the XRC protocol.  To support XRC, the rdma_cm
is extended by adding a new 'IB' specific port space.  XRC support
is dependent on the rdma_cm qp_type patch that has been queued for 3.0.

There are corresponding patches to support XRC to libibverbs, libmlx4,
and the librdmacm, including new sample applications for the librdmacm.

This patch series may also be found at:

	git://git.openfabrics.org/~shefty/rdma-dev.git xrc

which is based on 2.6.39, so the qp type patch is also included.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
