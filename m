From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: rdma provider module references
Date: Thu, 16 Dec 2010 09:34:22 -0600
Message-ID: <4D0A317E.2020808@opengridcomputing.com>
References: <4D08E989.5020307@aoot.com> <adapqt3gdzb.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqt3gdzb.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/15/2010 11:09 AM, Roland Dreier wrote:
>   >  I notice that if I have a user rdma application running that has an
>   >  rdma connection using iw_cxgb3, then the iw_cxgb3 module reference
>   >  count is bumped and thus it cannot be unloaded.  However when I have
>   >  an NFSRDMA connection that utilizes iw_cxgb3, the module reference
>   >  count is not bumped, and iw_cxgb3 can erroneously be unloaded while
>   >  the NFSRDMA connection is still active, causing a crash.
>
> What is supposed to happen is that as the HW driver is unloading, it
> calls ib_unregister_device() first, and this calls each client's
> .remove() method to have it release everything related to that device.
>
> However I guess NFS/RDMA is behind the RDMA CM, which is supposed to
> handle device removal.  In that code it seems to end up in
> cma_process_remove(), which appears at first glance to do the right
> things to destroy all connections etc.
>
> The idea is that RDMA devices should be like net devices, ie you can
> remove them even if they're in use -- things should just clean up,
> rather than blocking the module removal.  The uverbs case is a bit of a
> hack because we don't have a way to handle revoking the mmap regions
> etc yet.
>
> What goes wrong with NFS/RDMA in this scheme?  It looks like it should work.
>

Here's one stack.  From this I assume the offload connection was still active after iw_cxgb3 was unloaded...

Call Trace:
<IRQ>  [<ffffffff80037136>] kref_get+0x38/0x3d
  [<ffffffff885fb5b1>] :iw_cxgb3:sched+0x17/0x49
  [<ffffffff8824cf37>] :cxgb3:process_rx+0x37/0x8b
  [<ffffffff8824a3e7>] :cxgb3:process_responses+0xc09/0xc63
  [<ffffffff8824ac65>] :cxgb3:napi_rx_handler+0x36/0xa4
  [<ffffffff8000c88a>] net_rx_action+0xac/0x1e0
  [<ffffffff8824ac15>] :cxgb3:t3_sge_intr_msix_napi+0x173/0x18d
  [<ffffffff80012409>] __do_softirq+0x89/0x133
  [<ffffffff8005f2fc>] call_softirq+0x1c/0x28
  [<ffffffff8006dba8>] do_softirq+0x2c/0x85
  [<ffffffff8006da30>] do_IRQ+0xec/0xf5
  [<ffffffff800575d0>] mwait_idle+0x0/0x4a
  [<ffffffff8005e615>] ret_from_intr+0x0/0xa
<EOI>  [<ffffffff80057606>] mwait_idle+0x36/0x4a
  [<ffffffff800497be>] cpu_idle+0x95/0xb8
  [<ffffffff80078997>] start_secondary+0x498/0x4a7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
