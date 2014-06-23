From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 16:22:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823739931EDD5@ORSMSX109.amr.corp.intel.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com>
 <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com>
 <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com>
 <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com>
 <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Steve Wise is helping me with a particular issue where QP re-use might
> be helpful.
> 
> When an RPC/RDMA transport connection is dropped (for example, the NFS
> server crashes), xprtrdma destroys the transport's QP and creates a
> new one for the next connection.

If the remote side crashes, the local QP can transition into the error state, which would flush all posted receives.  I believe that a WR that has completed in error only has the wr_id field valid.

Note that calling rdma_disconnect() will also transition the QP into the error state.
 
> We're not quite sure what IB_WC_WR_FLUSH_ERR means in that instance. Our
> theory is there is a gap when the old QP is destroyed:
> 
> 1. If the HW reports a successful WR completion but the QP no longer
>    exists, the provider substitutes an IB_WC_WR_FLUSH_ERR completion
> 
> 2. If the WR is dropped before the HW even saw it, the provider inserts
>    an IB_WC_WR_FLUSH_ERR completion
> 
> So if xprtrdma is trying to submit a FAST_REG_MR WR and the completion
> gets flushed, xprtrdma has no way to know whether the rkey was bumped in
> the adapter. Thus it has no certainty which rkey to use to invalidate
> that FRMR.

I'm not familiar with the behavior of fast reg mr.
 
> I was idly wondering whether re-using the QP during connection loss
> would provide a guarantee that xprtrdma would never see case 1 above.
> Then IB_WC_WR_FLUSH_ERR on a FAST_REG_MR WR would be a more certain
> indication that the HW still has the old rkey.
> 
> I suppose that xprtrdma can "hang onto" the QP without re-using it by
> simply not destroying it until all WRs scheduled on the old QP are
> completed. Is reference counting the QP the usual design pattern to deal
> with this case?

I _thought_ that destroying the QP would cleanup any completion entries in the CQ, but I'm not sure of this.  Referencing counting should work though. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
