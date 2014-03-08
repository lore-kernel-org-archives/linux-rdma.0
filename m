From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: NFS over RDMA crashing
Date: Sat, 08 Mar 2014 13:20:48 -0600
Message-ID: <531B6D90.2090208@opengridcomputing.com>
References: <51127B3F.2090200@mellanox.com> <20130206222435.GL16417@fieldses.org> <20130207164134.GK3222@fieldses.org> <003601cf3a26$94523ee0$bcf6bca0$@opengridcomputing.com> <005d01cf3a45$94ced0d0$be6c7270$@opengridcomputing.com> <531B47B3.1070503@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531B47B3.1070503-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Yan Burman' <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I removed your change and started debugging original crash that 
> happens on top-o-tree.   Seems like rq_next_pages is screwed up.  It 
> should always be >= rq_respages, yes?  I added a BUG_ON() to assert 
> this in rdma_read_xdr() we hit the BUG_ON(). Look
>
> crash> svc_rqst.rq_next_page 0xffff8800b84e6000
>   rq_next_page = 0xffff8800b84e6228
> crash> svc_rqst.rq_respages 0xffff8800b84e6000
>   rq_respages = 0xffff8800b84e62a8
>
> Any ideas Bruce/Tom?
>

Guys, the patch below seems to fix the problem.  Dunno if it is correct 
though.  What do you think?

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c 
b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 0ce7552..6d62411 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -90,6 +90,7 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
                 sge_no++;
         }
         rqstp->rq_respages = &rqstp->rq_pages[sge_no];
+       rqstp->rq_next_page = rqstp->rq_respages;

         /* We should never run out of SGE because the limit is defined to
          * support the max allowed RPC data length
@@ -276,6 +277,7 @@ static int fast_reg_read_chunks(struct svcxprt_rdma 
*xprt,

         /* rq_respages points one past arg pages */
         rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
+       rqstp->rq_next_page = rqstp->rq_respages;

         /* Create the reply and chunk maps */
         offset = 0;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
