From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: libibverbs and versions
Date: Wed, 02 Jun 2010 10:50:56 -0500
Message-ID: <4C067DE0.8020508@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Roland, 

I have this library I'm writing that uses libibverbs.  Somehow it seems 
to be using the 1.0 version instead of the newer version (I'm 
guessing).  When I call ibv_create_cq()  I get a seg fault and the stack 
looks like this:

#0  0x000000319d80871d in pthread_mutex_lock () from /lib64/libpthread.so.0
#1  0x00007f60e93fac9a in __ibv_create_cq (context=0x7f60e8597c51, cqe=256,
    cq_context=0x0, channel=0x0, comp_vector=0) at src/verbs.c:278
#2  0x00007f60e93f727f in __ibv_create_cq_1_0 (context=0x61db30, cqe=256,
    cq_context=0x0, channel=0x0, comp_vector=0) at src/compat-1_0.c:649

At the  __ibv_create_cq_1_0 stack frame, context looks good:

(gdb) p *context
$3 = {device = 0x61ede0, ops = {
    query_device = 0x7f60e8596c98 <c4iw_query_device>,
    query_port = 0x7f60e8596d35 <c4iw_query_port>,
    alloc_pd = 0x7f60e8596d66 <c4iw_alloc_pd>,
    dealloc_pd = 0x7f60e8596dd9 <c4iw_free_pd>,
    reg_mr = 0x7f60e8596f77 <c4iw_reg_mr>, dereg_mr = 0,
    create_cq = 0x7f60e8596fae <c4iw_dereg_mr>, poll_cq = 0,
    req_notify_cq = 0, cq_event = 0,
<stuff truncated>

But context->real_context looks bad:

(gdb) p *context->real_context
$5 = {device = 0x30ec8348e5894855, ops = {query_device = 0xe0758948e87d8948,
    query_port = 0xe87d8b48dc558966, alloc_pd = 0x458948fffffdf2e8,
    dealloc_pd = 0xc78148f07d8b48f0, reg_mr = 0xffaa4ee800000130,
    rereg_mr = 0xc78148f07d8b48ff, dereg_mr = 0xfffddce8000000b0,
    alloc_mw = 0x7d8b480974c085ff, bind_mw = 0xb70fffffed72e8f0,
    dealloc_mw = 0x8b48e0758b48dc55, create_cq = 0x89ffffac70e8e87d,
    poll_cq = 0x358d48fc558bfc45, req_notify_cq = 0xb43d8d48000016a3,
<stuff truncated>


When I walk through a different program that does work, I don't see the 
__ibv_create_cq_1_0() call.   The program seems to call 
__ibv_create_cq() directly.

What am I doing wrong?  How does the loader determine which version is 
needed?

Thanks in advance,

Stevo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
