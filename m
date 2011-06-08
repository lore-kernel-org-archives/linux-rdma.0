From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Re: librdma_cm and PSNs
Date: Tue, 7 Jun 2011 21:07:31 -0400
Message-ID: <201106072107.31735.kerr.g@husky.neu.edu>
References: <201106041737.16482.kerr.g@husky.neu.edu> <1828884A29C6694DAF28B7E6B8A82373012DA1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373012DA1-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sunday, June 05, 2011 09:22:30 AM you wrote:
> > While doing this I have noticed that in a simple RDMA application,
> > librdma does not seem to configure the PSNs between the two nodes to
> > match each other; not through calls to ibv_modify_qp anyhow. The
> > arguments given to ibv_modify_qp by librdma_cm seem to be (for example):
> > 
> > Node 1:
> > RQ_PSN is 464684127
> > SQ_PSN is 2204625
> > 
> > Node 2:
> > RQ_PSN is 1327604689
> > SQ_PSN is 11699295
> 
> Are you capturing the ibv_modify_qp calls for the correct transitions?  You
> can check the qp_attr_mask to see when the PSN values are being set. 
> RQ_PSN is set on the RTR transition call.  SQ_PSN is set on the RTS
> transition.

I was checking for (attr_mask & IBV_QP_RQ_PSN) and (attr_mask & 
IBV_QP_SQ_PSN). I now check on the state changes too, but I see the same 
results.

> 
> > If I use ibv_query_qp() to query the PSNs they will prove to match (SQ ->
> > RQ on the opposite nodes), as they should. If not through ibv_modify_qp,
> > how is librdma_cm configuring the PSNs?
> 
> The PSNs are set by the kernel using random numbers.  For IB, the
> underlying CM exchanges the PSNs as part of the connection process.  The
> librdmacm calls into the kernel (rdma_init_qp_attr() or something like
> that) to get the attributes that it passes into ibv_modify_qp.
> 

The behavior of the PSNs, in this case, seems quite odd to me. I set up some 
wrapper code that does the following.

/** This code checks both based on state changes and the attr_mask */
int ibv_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
                   int attr_mask) //int attr_mask)
{
  JNOTE("********* WRAPPER for ibv_modify_qp");
  if (attr_mask & IBV_QP_RQ_PSN) { 
    printf("RQ_PSN is %ju\n", attr->rq_psn);
  }    
  if (attr_mask & IBV_QP_SQ_PSN) { 
    printf("SQ_PSN is %ju\n", attr->sq_psn);
  }    
  if (attr_mask & IBV_QP_STATE) {  
    if (attr->qp_state == IBV_QPS_RTR) {
      printf("RQ_PSN is %ju\n", attr->rq_psn);
    } else if (attr->qp_state == IBV_QPS_RTS) {
      printf("SQ_PSN is %ju\n", attr->sq_psn);
    }  
  }    

  int rslt =  _real_ibv_modify_qp(qp, attr, attr_mask);

  struct ibv_qp_attr query_attr; 
  struct ibv_qp_init_attr init_attr; 
  int foo = _real_ibv_query_qp(qp, &query_attr, attr_mask, &init_attr);

  if (attr_mask & IBV_QP_RQ_PSN) { 
    printf("attr.rq_psn is %ju\n", query_attr.rq_psn);
  }    
  if (attr_mask & IBV_QP_SQ_PSN) { 
    printf("attr.sq_psn is %ju\n", query_attr.sq_psn);
  }
  if (attr_mask & IBV_QP_STATE) {  
    printf("qp state set attr.sq_psn is %ju\n", query_attr.sq_psn); 
    printf("qp state set attr.rq_psn is %ju\n", query_attr.rq_psn);
  }

  return rslt;
}

In the log output, the values given to the attr argument of ibv_modify_qp, 
will not match the values returned by ibv_query_qp for RQ_PSN. It seems the 
proper values are being passed in for the SQ_PSN.

In the end, the values returned by ibv_query_qp will match up. For example:

[Node 1]
qp state set attr.sq_psn is 3188869
qp state set attr.rq_psn is 1930748
[Node 2]
qp state set attr.sq_psn is 1930745
qp state set attr.rq_psn is 3188867

Regards,

-- 
Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
