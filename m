From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: {RFC] ibv_post_send()/ibv_post_recv() kernel path optimizations
Date: Fri, 6 Aug 2010 11:03:36 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040805BD83E5F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently the ibv_post_send()/ibv_post_recv() path through kernel 
(using /dev/infiniband/rdmacm) could be optimized by removing dynamic memory allocations on the path. 

Currently the transmit/receive path works following way:
User calls ibv_post_send() where vendor specific function is called. 
When the path should go through kernel the ibv_cmd_post_send() is called.
 The function creates the POST_SEND message body that is passed to kernel. 
As the number of sges is unknown the dynamic allocation for message body is performed. 
(see libibverbs/src/cmd.c)

In the kernel the message body is parsed and a structure of wr and sges is recreated using dynamic allocations in kernel 
The goal of this operation is having a similar structure like in user space. 

The proposed path optimization is removing of dynamic allocations 
by redefining a structure definition passed to kernel. 
>From 

struct ibv_post_send {
        __u32 command;
        __u16 in_words;
        __u16 out_words;
        __u64 response;
        __u32 qp_handle;
        __u32 wr_count;
        __u32 sge_count;
        __u32 wqe_size;
        struct ibv_kern_send_wr send_wr[0];
};
To 

struct ibv_post_send {
        __u32 command;
        __u16 in_words;
        __u16 out_words;
        __u64 response;
        __u32 qp_handle;
        __u32 wr_count;
        __u32 sge_count;
        __u32 wqe_size;
        struct ibv_kern_send_wr send_wr[512];
};

Similar change is required in kernel  struct ib_uverbs_post_send defined in /ofa_kernel/include/rdma/ib_uverbs.h

This change limits a number of send_wr passed from unlimited (assured by dynamic allocation) to reasonable number of 512. 
I think this number should be a max number of QP entries available to send. 
As the all iB/iWARP applications are low latency applications so the number of WRs passed are never unlimited.

As the result instead of dynamic allocation the ibv_cmd_post_send() fills the proposed structure 
directly and passes it to kernel. Whenever the number of send_wr number exceeds the limit the ENOMEM error is returned.

In kernel  in ib_uverbs_post_send() instead of dynamic allocation of the ib_send_wr structures 
the table of 512  ib_send_wr structures  will be defined and 
all entries will be linked to unidirectional list so qp->device->post_send(qp, wr, &bad_wr) API will be not changed. 

As I know no driver uses that kernel path to posting buffers so iWARP multicast acceleration implemented in NES driver 
Would be a first application that can utilize the optimized path. 

Regards,

Mirek

Signed-off-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
