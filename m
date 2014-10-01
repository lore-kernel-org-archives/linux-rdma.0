From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 0/9] Proper fields initializations
Date: Wed,  1 Oct 2014 13:49:30 +0200
Message-ID: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Following discussions in '[PATCH for-next 1/2] IB/uverbs: Add QP
creation flags, allow blocking UD multicast loopback' thread[1],
I've reviewed libibverbs and how it's handling "reserved" fields.

I have identified portion of data structures not initialized but
sent to the kernel.

That means the kernel doesn't check the value of those
non-initialized fields. In turn, this means such fields cannot
be used for future extension, or it cannot be used for extension
without an other mean to declare the presence of the extension.

Please have a look to this patchset where I tried to have proper
handling of reserved field, padding, etc. just like following
commits did it before:

  commit 00042559262a Add Valgrind annotations
  (same as commit 0e0604213ed7 Add Valgrind annotations)
  commit d5052fa0bf81 Initialize reserved attributes in modify QP command
  commit 9eb2125b2027 Fix several valgrind false positives

As I haven't tested, nor benchmarked the code with my patches,
think about it before applying them.

BTW, I think it's time to use valgrind again.

[1] http://marc.info/?i=1410799972.7830.25.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org

Yann Droneaud (9):
  ibv_cmd_create_ah(): initialize reserved fields in various structures
  ibv_cmd_post_recv(): initialize reserved field in struct
    ibv_kern_recv_wr
  ibv_cmd_post_send(): initialize reserved field in struct
    ibv_kern_send_wr
  ibv_cmd_create_srq_ex(): set reserved field in struct ibv_create_xsrq
  kern-abi: remove unused qp_type union in struct ibv_kern_send_wr
  ibv_cmd_open_qp(): initialize reserved field in struct ibv_open_qp
  ibv_cmd_create_flow(): explicitly clear fields
  ibv_cmd_create_flow(): initialize flow_id->comp_mask
  ibv_cmd_destroy_flow(): initialize comp_mask explicitly

 include/infiniband/kern-abi.h |  5 -----
 src/cmd.c                     | 24 ++++++++++++++++++++++--
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
