From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 0/3] Proposal for exposing rdma_rw MR factor
Date: Tue, 01 Aug 2017 17:06:51 -0400
Message-ID: <20170801205334.15781.18761.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since I converted NFSD to use the new rdma_rw API, I've been
struggling with how NFSD determines the size of its send CQ, and how
it provisions its send queue limit (ie, when it waits for more send
queue entries to become available).

The problem arises because rdma_rw hides the exact number of send
WQEs it has provisioned. It determines this number based on the MR
registration mode (FRWR for iWARP devices, local DMA rkey for
others), but the mode itself is no longer exposed to ULPs.

Thus when FRWR is in use, rdma_rw adds more WQEs, but NFSD is no
longer aware of this, does not provision a larger CQ, and does not
raise its send queue accounting limit. That means the extra WQEs are
never really used.

At LSF this year, Christoph and Sagi proposed a simple API that
expose information about how many CQ entries are needed so that ULPs
can provision their CQs more accurately.

The first patch here is a pre-requisite for the third. The second
patch adds the new API. The third patch changes NFSD to use the new
API to provision its CQ and send queue accounting accurately.

This approach was tested using the (fixed) force_mr core module
parameter.


---

Chuck Lever (3):
      svcrdma: Limit RQ depth
      rdma core: Add rdma_rw_mr_payload()
      svcrdma: Estimate Send Queue depth properly


 drivers/infiniband/core/rw.c             |   24 ++++++++++++++++++++
 include/rdma/rw.h                        |    2 ++
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   36 +++++++++++++++++++++---------
 3 files changed, 51 insertions(+), 11 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
