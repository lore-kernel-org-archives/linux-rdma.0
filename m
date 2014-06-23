From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 11:20:34 -0400
Message-ID: <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399313467-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean-

On Jun 20, 2014, at 5:17 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> During a remote transport disconnect, the QP leaves RTS.
>>=20
>> xprtrdma deals with this in a separate transport connect worker proc=
ess,
>> where it creates a new id and qp, and replaces the existing id and q=
p.
>>=20
>> Unfortunately there are parts of xprtrdma (namely FRMR deregistratio=
n)
>> that are not easy to serialize with this reconnect logic.
>>=20
>> Re-using the QP would mean no serialization would be needed between
>> transport reconnect and FRMR deregistration.
>>=20
>> If QP re-use is not supported, though, it's not worth considering an=
y
>> further.
>=20
> It may be possible to reuse the QP, just not the rdma_cm_id without a=
dditional code changes.  Reuse of the rdma_cm_id may also require chang=
es in the underlying IB/iWarp CMs.

Steve Wise is helping me with a particular issue where QP re-use might
be helpful.

When an RPC/RDMA transport connection is dropped (for example, the NFS
server crashes), xprtrdma destroys the transport's QP and creates a
new one for the next connection.

We=92re not quite sure what IB_WC_WR_FLUSH_ERR means in that instance. =
Our
theory is there is a gap when the old QP is destroyed:

1. If the HW reports a successful WR completion but the QP no longer
   exists, the provider substitutes an IB_WC_WR_FLUSH_ERR completion

2. If the WR is dropped before the HW even saw it, the provider inserts
   an IB_WC_WR_FLUSH_ERR completion

So if xprtrdma is trying to submit a FAST_REG_MR WR and the completion
gets flushed, xprtrdma has no way to know whether the rkey was bumped i=
n
the adapter. Thus it has no certainty which rkey to use to invalidate
that FRMR.

I was idly wondering whether re-using the QP during connection loss
would provide a guarantee that xprtrdma would never see case 1 above.
Then IB_WC_WR_FLUSH_ERR on a FAST_REG_MR WR would be a more certain
indication that the HW still has the old rkey.

I suppose that xprtrdma can =93hang onto=94 the QP without re-using it =
by
simply not destroying it until all WRs scheduled on the old QP are
completed. Is reference counting the QP the usual design pattern to dea=
l
with this case?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
