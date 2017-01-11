From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 11:38:45 -0500
Message-ID: <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB2207F28F05DC6E22B03CC516F8660-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 11, 2017, at 2:41 AM, Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> 
> Hi Chuck,
> We discovered that your recent work (see[1]) on NFSoRDMA broke that functionality on our device.
> This seems to stem from a new requirement of minimum 18 SGES for NFSoRDMA to work.

This issue was reported weeks ago by Broadcom, and I have a fix
pending for v4.11.

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=commit;h=a300d316ac76ad000e14c4d309afdcdb6c0bd9ac

The above fix reduces the minimum requirement to 5 SGEs, so it
probably won't address the issue for your device (though
Broadcom reported that the fix worked for them).


> Our device supports only 4 SGEs, and it seems other devices also have limitations in that
> regard which would prevent the NFSoRDMA from working on them.

Of course NFS/RDMA should work for all in-tree drivers.

I will revisit [1] and see if there's any way to manage with 4
SGEs. I think reducing the minimum to a single partial or whole
page should be enough.

If not, I will send a revert for [1] for v4.10-rc.


> Mounting NFS over RDMA fails with the message: "Cannot allocate memory".
> After enabling RPC debug information we've found this is due to this piece of code
> from net/sunrpc/xprtrdma/verbs.c:
> 
>        if (ia->ri_device->attrs.max_sge < RPCRDMA_MAX_SEND_SGES) {
>                dprintk("RPC:       %s: insufficient sge's available\n",
>                        __func__);
>                return -ENOMEM;
>        }
> 
> Our device supports 4 sges while the minimum is now 18 sges, for PAGE_SIZE of 4KB:
> 
>        #define RPCRDMA_MAX_INLINE  (65536)     /* max inline thresh */
> 
>        RPCRDMA_MAX_SEND_PAGES = PAGE_SIZE + RPCRDMA_MAX_INLINE - 1,
>        RPCRDMA_MAX_PAGE_SGES = (RPCRDMA_MAX_SEND_PAGES >> PAGE_SHIFT) + 1,
>        RPCRDMA_MAX_SEND_SGES = 1 + 1 + RPCRDMA_MAX_PAGE_SGES + 1,
> 
> On kernel 4.8 and before, NFSoRDMA worked well with our device as only 2 SGEs were required.
> The code looked like this:
>        #define RPCRDMA_MAX_IOVS        (2)
> 
>        if (ia->ri_device->attrs.max_sge < RPCRDMA_MAX_IOVS) {
>                dprintk("RPC:       %s: insufficient sge's available\n",
>                        __func__);
>                return -ENOMEM;
>        }
> 
> Browsing the code of other drivers it can be seen that this ability is either hardcoded or is
> learnt by the driver from the device.

In the latter case, there's no way for me to know what that
capability is by looking at kernel code. There's also no way
for me to know about out-of-tree drivers or pre-release devices.

It's not feasible for me to stock my lab with more than a
couple of devices anyway.

For all these reasons, I rely on HCA vendors for smoke testing
NFS/RDMA with their devices.

[1] was posted for review on public mailing lists for weeks. I
received no review comments or reports of testing successes or
failures from any vendor, until Broadcom's report in late
December, three months after [1] appeared in a kernel release
candidate.

This may sound like sour grapes, but this is a review and
testing gap, and I think the community should have the ability
to address it.

HCA vendors, especially, have to focus on kernel release
candidate testing if functional ULPs are a critical release
criterion for them.


> If I'm not mistaken, this issue affects nes and
> cxgb3/4 drivers, and perhaps others.

ocrdma and Oracle's HCA.


> E.g., for cxgb4:
> 
>        #define T4_MAX_RECV_SGE 4

Yet, without hard-coded max_sge values in kernel drivers, it's
difficult to say whether 4 is truly the lower bound.


>        static int c4iw_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
>                                     struct ib_udata *uhw)
>        {
>                ...
>                props->max_sge = T4_MAX_RECV_SGE;
> 
> ***
> [1] https://patchwork.kernel.org/patch/9333951/
> 

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
