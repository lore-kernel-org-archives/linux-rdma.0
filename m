From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 16:17:23 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE0A1CC@CMEXMB1.ad.emulex.com>
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
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
> Sent: Monday, June 23, 2014 8:51 PM
> To: Hefty, Sean
> Cc: linux-rdma
> Subject: Re: how to re-use a QP for a new connection
> 
> Hi Sean-
> 
> On Jun 20, 2014, at 5:17 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> >> During a remote transport disconnect, the QP leaves RTS.
> >>
> >> xprtrdma deals with this in a separate transport connect worker
> >> process, where it creates a new id and qp, and replaces the existing id and
> qp.
> >>
> >> Unfortunately there are parts of xprtrdma (namely FRMR
> >> deregistration) that are not easy to serialize with this reconnect logic.
> >>
> >> Re-using the QP would mean no serialization would be needed between
> >> transport reconnect and FRMR deregistration.
> >>
> >> If QP re-use is not supported, though, it's not worth considering any
> >> further.
> >
> > It may be possible to reuse the QP, just not the rdma_cm_id without
> additional code changes.  Reuse of the rdma_cm_id may also require
> changes in the underlying IB/iWarp CMs.
> 
> Steve Wise is helping me with a particular issue where QP re-use might be
> helpful.
> 
> When an RPC/RDMA transport connection is dropped (for example, the NFS
> server crashes), xprtrdma destroys the transport's QP and creates a new one
> for the next connection.
> 
> We're not quite sure what IB_WC_WR_FLUSH_ERR means in that instance.
> Our theory is there is a gap when the old QP is destroyed:
> 
> 1. If the HW reports a successful WR completion but the QP no longer
>    exists, the provider substitutes an IB_WC_WR_FLUSH_ERR completion

QP still exists but its state is ERROR. This state change could be due to multiple reasons. The WQE/RQE which
Caused this state transition is reported by h/w in the corresponding CQE. Rest of the CQEs after that are completed
With FLUSH-ERROR. This means Data Flow cannot happen anymore and QP needs a reconnection OR a fresh QP needs to be
Created and reconnected.

> 
> 2. If the WR is dropped before the HW even saw it, the provider inserts
>    an IB_WC_WR_FLUSH_ERR completion
> 
> So if xprtrdma is trying to submit a FAST_REG_MR WR and the completion
> gets flushed, xprtrdma has no way to know whether the rkey was bumped in
> the adapter. Thus it has no certainty which rkey to use to invalidate that
> FRMR.

If FRMR WQE is completed in flush, It must be assumed that the request is _incomplete_
> 
> I was idly wondering whether re-using the QP during connection loss would
> provide a guarantee that xprtrdma would never see case 1 above.
> Then IB_WC_WR_FLUSH_ERR on a FAST_REG_MR WR would be a more
> certain indication that the HW still has the old rkey.
> 
> I suppose that xprtrdma can "hang onto" the QP without re-using it by simply
> not destroying it until all WRs scheduled on the old QP are completed. Is
> reference counting the QP the usual design pattern to deal with this case?

Why can we assume that all those FRMRs for which flush completion is reported are invalid while rest are still valid
Even if a new connection is in place after some time?

> 
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
