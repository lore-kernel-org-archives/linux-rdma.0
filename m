From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] Re-send with SPDX headers
Date: Fri, 19 Jan 2018 15:19:30 -0500
Message-ID: <20180119201640.3084.73639.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna and RDMA maintainers-

Here are the two patches in my "xprtrdma trace points" series for
v4.16 that introduce new files. These have been updated to include
SPDX headers in the new files.

RDMA maintainers, please ACK the first patch. Anna, can you replace
the corresponding patches in your tree with these?

Thanks!

---

Chuck Lever (2):
      rdma/ib: Add trace point macros to display human-readable values
      rpcrdma: infrastructure for static trace points in rpcrdma.ko


 include/trace/events/rdma.h     |  129 +++++++++++++++++++++++++++++++++++++++
 include/trace/events/rpcrdma.h  |   15 +++++
 net/sunrpc/xprtrdma/module.c    |   12 ++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 +
 4 files changed, 153 insertions(+), 5 deletions(-)
 create mode 100644 include/trace/events/rdma.h
 create mode 100644 include/trace/events/rpcrdma.h

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
