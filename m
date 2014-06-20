From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Fri, 20 Jun 2014 16:32:30 -0400
Message-ID: <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373993132A8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean-

On Jun 20, 2014, at 3:41 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> I'm considering a change to xprtrdma that would re-use the QP and
>> rdma_cm_id after a transport disconnect.
>>=20
>> I use rdma_disconnect() and then wait for the TIMEWAIT_EXIT upcall.
>> But after that, rdma_resolve_addr() always fails (-EINVAL).
>>=20
>> What does xprtrdma need to do to get the rdma_cm_id back to the
>> RDMA_CM_IDLE state so I can reset the QP?
>=20
> I don't know that the kernel rdma cm code supports this.  It's likely=
 that the id would need to have its state reset and data structures cle=
aned up.  That said, I doubt re-use of the rdma_cm_id would provide any=
 real advantage.

During a remote transport disconnect, the QP leaves RTS.

xprtrdma deals with this in a separate transport connect worker process=
,
where it creates a new id and qp, and replaces the existing id and qp.

Unfortunately there are parts of xprtrdma (namely FRMR deregistration)
that are not easy to serialize with this reconnect logic.

Re-using the QP would mean no serialization would be needed between
transport reconnect and FRMR deregistration.

If QP re-use is not supported, though, it=92s not worth considering any
further.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
