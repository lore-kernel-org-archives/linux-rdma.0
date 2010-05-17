From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: InfiniBand/RDMA merge plans for 2.6.35
Date: Mon, 17 May 2010 12:58:59 -0700
Message-ID: <7943A3B0D2C7416186D6A61FE071D640@amr.corp.intel.com>
References: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq6mo58m.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Here are a few topics that are not ready in time for the 2.6.35 window
>and will need to wait for 2.6.36 at least:

I just wanted to make sure that this didn't get dropped off the radar for 2.6.36
review.  I have a set of patches to add support for AF_IB to the rdma_cm.  At
this point, all received feedback has been incorporated.  I won't repost the
entire patch set unless requested, but it's also available from:

	git://git.openfabrics.org/~shefty/rdma-dev.git af_ib

which has been updated to 2.6.34-rc7.  I tried to keep the patches small, to
make review a little easier.

Jason, you've been most involved in reviewing the patches so far.  Any chance I
can ask you to assist Roland with a more formal review?

 drivers/infiniband/core/addr.c           |   20 ++-
 drivers/infiniband/core/cma.c            |  469 ++++++++++++++++++++++--------
 drivers/infiniband/core/sa_query.c       |    6 +
 drivers/infiniband/core/ucma.c           |  356 ++++++++++++++++++++---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
 include/linux/socket.h                   |    2 +
 include/rdma/ib.h                        |   89 ++++++
 include/rdma/ib_addr.h                   |    6 +-
 include/rdma/ib_sa.h                     |    6 +
 include/rdma/rdma_cm.h                   |   19 ++-
 include/rdma/rdma_user_cm.h              |   76 ++++-
 net/9p/trans_rdma.c                      |    3 +-
 net/rds/ib.c                             |    2 +-
 net/rds/ib_cm.c                          |    2 +-
 net/rds/iw.c                             |    2 +-
 net/rds/iw_cm.c                          |    2 +-
 net/rds/rdma_transport.c                 |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    3 +-
 net/sunrpc/xprtrdma/verbs.c              |    2 +-
 19 files changed, 877 insertions(+), 193 deletions(-)

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
