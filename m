From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Fri, 10 Jul 2015 13:54:20 -0600
Message-ID: <20150710195420.GA31500@obsidianresearch.com>
References: <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <20150708203205.GA21847@infradead.org>
 <20150709000337.GE16812@obsidianresearch.com>
 <559EF332.7060103@redhat.com>
 <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <55A00754.4010009@redhat.com>
 <55A01225.9000000@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A01225.9000000-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 02:42:45PM -0400, Tom Talpey wrote:

> >>For the proposed iSER patch the problem is very acute, iser makes a
> >>single PD and phys MR at boot time for each device. This means there
> >>is a single machine wide unchanging rkey that allows remote physical
> >>memory access. An attacker only has to repeatedly open QPs to iSER and
> >>guess rkey values until they find it. Add in likely non-crypto
> >>randomness for rkeys, and I bet it isn't even that hard to do.
> 
> The rkeys have a PD, wich cannot be forged, so it's not a matter of
> attacking, but it is most definitely a system integrity risk, as I
> mentioned earlier, a simple arithmetic offset mistake can overwrite
> anything.

Can you explain this conclusion?

As far as I can see the flow is:

pd = ib_alloc_pd();
mr = ib_get_dma_mr(pd,IB_ACCESS_REMOTE_WRITE);
qp = ib_create_qp(pd);

So at that instant, the far side of 'qp' can issue a RDMA WRITE op
with an rkey of mr->rkey. AFAIK that is what these APIs are *defined*
to do.

I don't need to forge a PD because I have control over the far
side of a QP already attached to PD. All I need to know is the rkey
number.

So the attack is, connect to iSER, guess RKEY. If wrong, reconnect,
try again. The PD doesn't stop it. The rkey doesn't change on every
connect. Eventually you find it, and then you have access to all of
physical memory.

That is a security issue.

> > From there, we can start to look at the bigger picture of cleanup up the
> >default trust domain in the kernel and user space both (and soliciting
> >feedback on that...I have a suspicion that some users will not like us
> >tightening up security as it might interfere with their usage in their
> >sequestered clusters).
> 
> All excellent points. It's not worse, and it adds important transport
> support.

If the iWarp&iSER community is happy with this security problem then
sure, go ahead with the iser patch.

> However, it's an extremely bad idea to codify writable privileged rmr's
> in the API as best practice. So under no circumstance should that become
> the long term plan.

Agreed. We should drop ib_get_dma_mr flags wrapper, and I propose
this, so we don't have to relearn this lesson again.

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac3fb406a74..6ed7e0f6c162 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1126,6 +1126,12 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
        struct ib_mr *mr;
        int err;
 
+       /* Granting remote access to the physical MR is a security hole, don't
+          do it. */
+       WARN_ON_ONCE(mr_access_flags &
+               (IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_READ |
+                IB_ACCESS_REMOTE_ATOMIC));
+
        err = ib_check_mr_access(mr_access_flags);
        if (err)
                return ERR_PTR(err);

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
