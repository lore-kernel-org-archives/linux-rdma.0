From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: RFC: CQ pools and implicit CQ resource allocation
Date: Fri,  9 Sep 2016 14:36:21 +0200
Message-ID: <1473424587-13818-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds support to the RDMA core to implicitly allocate the required
CQEs when creating a QP.  The primary driver for that was to implement a
common scheme for CQ pooling, which helps with better resource usage for
server / target style drivers that have many outstanding connections.  In
fact the first version of this code from Sagi did just that: add a CQ pool
API, and convert drivers that were using some form of pooling (iSER initiator
& target, NVMe target) to that API.  But looking at the API I felt that
there was still way too much logic in the individual ULPs, and looked into a
way to make that boilerplate code go away.  It turns out that we can simply
create CQs underneath if we know the poll context that the ULP requires, so
this series shows an approach that makes CQs mostly invisible to ULPs.

One concern Sagi had when reviewing an earlier version of my edits was that
the over allocation as part of using a pool might be harmful for client side
driver that only have one (or a few) connections. I played around with iSER
a bit and could not measure and slowdown, but that doesn't mean there aren't
any down sides - I'd really like some feedback from the hardware driver
people on what CQ sizing / allocation preferences their hardware has.

This series applied on top of the "move unsafe global rkey handling to the
RDMA core V2" series.

A git tree is available at:

    git://git.infradead.org/users/hch/rdma.git rdma-cq


Gitweb:

    http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
