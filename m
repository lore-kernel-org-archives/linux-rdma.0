From: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Fri, 20 Oct 2017 17:20:22 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663875E0841@FMSMSX108.amr.corp.intel.com>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020073724.GY2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Friday, October 20, 2017 3:37 AM
> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> misinterpreted flag
> 
> On Thu, Oct 19, 2017 at 05:40:59PM -0400, Michael J. Ruhl wrote:
> > I was playing with the ibacm service and discovered an issue
> > the other day.
> >
> > If no provider library is present (I removed libacmp.so, and the
> > provider keyword in the opts.cfg file is libacmp), when a resolve
> > request is posted, the kernel will crash with the following Oops:
> >
> > Call Trace:
> >  ? netlink_dump+0x12c/0x290
> >  __netlink_dump_start+0x186/0x1f0
> >  rdma_nl_rcv_msg+0x193/0x1b0 [ib_core]
> >  rdma_nl_rcv+0xdc/0x130 [ib_core]
> >  netlink_unicast+0x181/0x240
> >  netlink_sendmsg+0x2c2/0x3b0
> >  sock_sendmsg+0x38/0x50
> >  SYSC_sendto+0x102/0x190
> >  ? __audit_syscall_entry+0xaf/0x100
> >  ? syscall_trace_enter+0x1d0/0x2b0
> >  ? __audit_syscall_exit+0x209/0x290
> >  SyS_sendto+0xe/0x10
> >  do_syscall_64+0x67/0x1b0
> >  entry_SYSCALL64_slow_path+0x25/0x25
> >
> > The issue is that in rdma_nl_rcv_msg(), the check
> > 'if (flags & NLM_F_DUMP)' is not completely correct.
> >
> > NLM_F_DUMP is two bits NLM_F_ROOT | NLM_F_MATCH.
> >
> > ibacm sends a RDMA_NL_LS response with the RDMA_NL_LS_F_ERR bit set
> > if an error occurs in the service (like no provider being available,
> > or ACM_STATUS_ENODATA, etc.).
> >
> > NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.
> >
> > The current code thinks that it sees a NLM_F_DUMP flag and incorrectly calls
> > the .dump() callback.
> 
> Hi Michael,
> 
> Thanks for the report and for excellent analysis, You are right that
> RDMA_NL_LS_F_ERR has the same value as NLM_F_ROOT and it is bad, but
> I just think that it is not the final root cause.
> 
> In case of errors, the LS was supposed to send NLMSG_ERROR message and not
> overload general nlmsg_flags, which is awful. However I don't know if it is
> feasible to fix current implementation without breaking UAPI contract.

I agree this is probably something that needs to get followed up on.
 
> In meanwhile, can we implement dummy dumpit functions for the LS,
> which reuse ib_nl_is_good_ip_resp?

The original code does not call the netlink_dump_start() code for this path, so if we create a dummy dump function we will have to add code to special case this and call it directly.

So maybe we could just go back to the original code and call .doit rather than .dump in the non netlink_dump_start() path? 

i.e.:
      if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
           (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
               cb.skb = skb;
               cb.nlh = nlh;
               cb.dump = cb_table[op].dump;
-               return cb.dump(skb, &cb);
+               return cb.doit(skb, &cb);
       } else {
               c.dump = cb_table[op].dump;


> I prefer this solution over yours, because it doesn't mix LS-specifics with
> general decision function and leaves LS anomalies in the LS-relevant code.

The problem with this is that the code has to take into consideration the LS anomalies either before the this function is called, or has to deal with them here.

The other thought would be to special case the LS stuff before this decision and call the .doit function there (and then return).
 
> And returning 0 in absence of dumpit function as a response with
> NLM_F_DUMP flag is wrong. User should be aware of the fact that
> something wrong was with his request.

This was the value that the function returns if .dump and .doit are NOT selected, so I thought that this was appropriate.  Should that value (the final return 0) be changed to something different?

Mike
 
> Thanks
> 
> >
> > The included patch is an atempt to fix this issue.  This patch fixes the
> > issue that I am seeing, but I am not sure how to test the messages for
> > RDMA_NL_RDMA_CM or RDMA_NL_IWCM (or any message that uses the
> > NLM_F_DUMP bits).
> >
> > If anyone has some knowledge of these services, any extra testing would
> > be welcomed.
> >
> > If the patch has no issues or comments, I will formally re-submit it
> > (through my usual channel Denny).
> >
> > Thanks,
> >
> > Mike
> >
> >
> > ---
> >
> > Michael J. Ruhl (1):
> >       RDMA/netlink: OOPs in rdma_nl_rcv_msg() from misinterpreted flag
> >
> >
> >  drivers/infiniband/core/netlink.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> > --
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
