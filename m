From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: uverbs message alignment
Date: Fri, 20 Jul 2012 16:42:07 -0500
Message-ID: <5009D0AF.1090409@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

I noticed a an alignment issue, I think, with struct ibv_create_qp.

I was adding a new __u32 to my raw qp create message.  Here is the new 
struct with the new field added (nfids) from my libcxgb4 abi header file:

struct c4iw_create_raw_qp_req {
         struct ibv_create_qp ibv_req;
         __u32 port;
         __u32 vlan_pri;
         __u32 nfids;
};

sizeof sez it is 80 bytes, but when packed like this:

struct c4iw_create_raw_qp_req {
         struct ibv_create_qp ibv_req;
         __u32 port;
         __u32 vlan_pri;
         __u32 nfids;
} __attribute__ ((packed));

sizeof sez its 76 bytes.

I think this means struct ibv_create_qp is somehow not naturally 
aligned.  Shouldn't it be?

Here is struct ibv_create_qp.  I'm not sure why it isn't aligned:

struct ibv_create_qp {
         __u32 command;
         __u16 in_words;
         __u16 out_words;
         __u64 response;
         __u64 user_handle;
         __u32 pd_handle;
         __u32 send_cq_handle;
         __u32 recv_cq_handle;
         __u32 srq_handle;
         __u32 max_send_wr;
         __u32 max_recv_wr;
         __u32 max_send_sge;
         __u32 max_recv_sge;
         __u32 max_inline_data;
         __u8  sq_sig_all;
         __u8  qp_type;
         __u8  is_srq;
         __u8  reserved;
         __u64 driver_data[0];
};

Does this have to do with field driver_data being defined as a __u64 and 
my struct is using __u32s?  Am I incorrect in using 3 __u32s?

This causes a problem, because the provider libs use sizeof their cmd 
struct to determine the amount of data to move into the kernel. The 
kernel then sets udata->inlen/outlen based on these sizes. Its harmless, 
until:

I discovered this because I was adding code in my kernel driver to 
detect a down-level library by looking at udata->inlen like this:

         if (udata->inlen - sizeof(struct ib_uverbs_cmd_hdr) != sizeof ureq)
                 return ERR_PTR(-EINVAL);

Here's what ureq is in the driver's ABI header:

struct c4iw_create_raw_qp_req {
     __u32 port;
     __u32 vlan_pri;
     __u32 nfids;
};

However, udata->inlen was 24 due to this packed issue (sizeof struct 
ib_uverbs_cmd_hdr is 8 by the way).  It should have been 20. When I 
packed the struct, my driver then found the correct size.

Also, I would think when we enter a provider's verb call, that 
udata->inlen would == the size of the driver's version of the ABI 
request message, and outlen would == the size of the driver's version of 
the ABI response message.  I think having to subtract the struct 
ib_uverbs_cmd_hdr is a bug too eh?


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
