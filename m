From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 13:22:38 -0400
Message-ID: <1F02274F-B3FC-40EE-A46D-FB178EA3781B@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com> <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com> <1828884A29C6694DAF28B7E6B8A823739931EDD5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823739931EDD5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 23, 2014, at 12:22 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Steve Wise is helping me with a particular issue where QP re-use mig=
ht
>> be helpful.
>>=20
>> When an RPC/RDMA transport connection is dropped (for example, the N=
=46S
>> server crashes), xprtrdma destroys the transport's QP and creates a
>> new one for the next connection.
>=20
> If the remote side crashes, the local QP can transition into the erro=
r state, which would flush all posted receives.  I believe that a WR th=
at has completed in error only has the wr_id field valid.
>=20
> Note that calling rdma_disconnect() will also transition the QP into =
the error state.

So on remote disconnect there are two steps:

1. The QP is transitioned to the error state

2. Later, when xprtrdma attempts to reconnect, it=92s transport connect
   worker destroys the old QP

I think you and Devesh are suggesting that when the QP is transitioned
to error state in step 1, the provider immediately flushes the send and
completion queues appropriately, leaving no possibility of a completed
WR with a dropped completion.

>=20
>> We're not quite sure what IB_WC_WR_FLUSH_ERR means in that instance.=
 Our
>> theory is there is a gap when the old QP is destroyed:
>>=20
>> 1. If the HW reports a successful WR completion but the QP no longer
>>   exists, the provider substitutes an IB_WC_WR_FLUSH_ERR completion
>>=20
>> 2. If the WR is dropped before the HW even saw it, the provider inse=
rts
>>   an IB_WC_WR_FLUSH_ERR completion
>>=20
>> So if xprtrdma is trying to submit a FAST_REG_MR WR and the completi=
on
>> gets flushed, xprtrdma has no way to know whether the rkey was bumpe=
d in
>> the adapter. Thus it has no certainty which rkey to use to invalidat=
e
>> that FRMR.
>=20
> I'm not familiar with the behavior of fast reg mr.

=46or the record, with both mlx4 and cxgb4, we see FRMRs left valid
after a FAST_REG_MR is flushed during a connection loss. More study
needed, obviously.

>> I was idly wondering whether re-using the QP during connection loss
>> would provide a guarantee that xprtrdma would never see case 1 above=
=2E
>> Then IB_WC_WR_FLUSH_ERR on a FAST_REG_MR WR would be a more certain
>> indication that the HW still has the old rkey.
>>=20
>> I suppose that xprtrdma can "hang onto" the QP without re-using it b=
y
>> simply not destroying it until all WRs scheduled on the old QP are
>> completed. Is reference counting the QP the usual design pattern to =
deal
>> with this case?
>=20
> I _thought_ that destroying the QP would cleanup any completion entri=
es in the CQ, but I'm not sure of this.  Referencing counting should wo=
rk though.=20

As a workaround, I can comment out the rdma_destroy_qp() call in xprtrd=
ma's
connect worker to see if there=92s any change in behavior when the old =
QP
stays around.

Given that the queues are flushed on RTS->Error, probably won=92t see a=
ny
difference at all.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
