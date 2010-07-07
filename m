From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes	driver
Date: Wed, 07 Jul 2010 09:45:28 +0300
Message-ID: <4C342288.4070803@voltaire.com>
References: <20100705135438.26042.55865.stgit@gkslx010.igk.intel.com>	<4C32EE45.9030906@Voltaire.com> <BE2BFE91933D1B4089447C64486040801EBB3C34@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801EBB3C34-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Walukiewicz, Miroslaw wrote:
> From my measuremnts it looks like the problem is related to memory allocation in the user-space and kernel path, that is a very, very expesive operation. Look for the tx path (rx is very similar). Ibv_post_send():
> 	post_send_wrapper_1_0
> 		for (w = wr; w; w = w->next) {
>                 real_wr = alloca(sizeof *real_wr);  <- 1. dyn alloc 
>                 real_wr->wr_id = w->wr_id;
> 			  next the call to HW specific part
> 			and prepare message to send
>         cmd  = alloca(cmd_size);  <- 2. dyn allocation

Hi Mirek,

I don't think there are applications around which would use raw qp AND 
are linked against libibverbs-1.0, such that they would exercise the 1_0 
wrapper, so we can ignore the 1st allocation, the one at the wrapper code.

As for the 2nd allocation, since a WQE --posting-- is synchronous,  
using the maximal values specified during the creation of the QP, I 
believe that this allocation can be done once per QP and used later.

> dive to kernel:
> 	ib_uverbs_post_send()
> 		user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL); <- 3. dyn alloc
> 		next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
>                                user_wr->num_sge * sizeof (struct ib_sge),
>                                GFP_KERNEL); <- 4. dyn alloc 				
>  		And now there is finel call to driver. 
~same here for #4 you can compute/allocate once the maximal possible 
size for "next" per qp and use it later. As for #3, this need further 
thinking.

But before diving to all this design changes, what was the penalty 
introduced by these allocations? is it in packets-per-second, latency?

> Diving to kernel is treated as a something like passing signal to kernel that there is prepared information to post_send/post_recv. The information about buffers are passed through shared page (available to userspace through mmap) to avoid copying of data. Write() ops is used to passing signal about post_send. Read() ops is used to pass information about post_recv(). We avoid additional copying of the data that way.
thanks for the heads-up, I took a look and this user/kernel shared 
memory page is used to hold the work-request, nothing to do with data.

As for the work request, you still have to copy it in user space from 
the user work request to the library mmaped buffer. So the only 
difference would be the copy_from_user done by uverbs, for few tens of 
bytes, can you tell if/what is the extra penalty introduced by this copy?

> struct nes_ud_send_wr {
>     u32               wr_cnt;
>     u32               qpn;
>     u32               flags;
>     u32               resv[1];
>     struct ib_sge     sg_list[64];
> };
>
> struct nes_ud_recv_wr {
>     u32               wr_cnt;
>     u32               qpn;
>     u32               resv[2];
>     struct ib_sge     sg_list[64];
> };
Looking on struct nes_ud_send/recv_wr, I wasn't sure to follow, the same 
instance can be used to post list of work requests, where is work 
request is limited to use one SGE, am I correct?

I don't think there a need to support posting 64 --send-- requests, for 
recv it might makes sense, but it could be done in a "batch/background" 
flow, thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
