From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 0/3] no IBV_SEND_INLINE thus memory registration required on QLogic/Intel HCA
Date: Sat, 17 Aug 2013 15:38:13 +0200
Message-ID: <cover.1376746185.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While doing some tests, I've found that rdma_client failed
on my QLogic/Intel QLE7340 / QLE7342 HCA:

    # rdma_client
    rdma_client: start
    rdma_post_send 22
    rdma_client: end -1
 
I had a deeper look on the examples and found that max_inline_data was returned as 0,
thus IBV_SEND_INLINE is not available and memory must be registered to provide a valid
lkey in WR.

[BTW, having registered the memory and still use IBV_SEND_INLINE was OK,
 that should be an error, isn't it ?]

Please find some patches to
- document IBV_SEND_INLINE and memory registration,
- add a query function to check max_inline_data on QP created by cma,
- fix the examples to not use IBV_SEND_INLINE if max_inline_data is less than expected.

Yann Droneaud (3):
  man: rdma_post_*(): memory region is optional only with
    IBV_SEND_INLINE.
  adds rdma_query_qp() function.
  examples: use IBV_SEND_INLINE if supported

 examples/rdma_client.c  | 25 +++++++++++++++++++------
 examples/rdma_server.c  | 31 +++++++++++++++++++++++++------
 examples/rdma_xclient.c | 42 ++++++++++++++++++++++++++++++++++--------
 examples/rdma_xserver.c | 39 +++++++++++++++++++++++++++++----------
 include/rdma/rdma_cma.h | 16 ++++++++++++++++
 man/rdma_post_send.3    |  2 +-
 man/rdma_post_ud_send.3 |  2 +-
 man/rdma_post_write.3   |  2 +-
 src/cma.c               | 24 ++++++++++++++++++++++++
 src/librdmacm.map       |  1 +
 10 files changed, 151 insertions(+), 33 deletions(-)

-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
