From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Fri, 20 Jun 2014 18:30:59 -0400
Message-ID: <905C8760-5964-47F8-8DF2-0C018CBDF695@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com> <53A4B4A1.50301@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A4B4A1.50301-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shirley-

I=92ve found that to move the QP back to the IB_QPS_INIT state, I need =
to
call ib_modify_qp() with a specific set of attributes, including the
pkey_index and port_num.

rdma_init_qp_attr() extracts those attributes. But, when I try to call =
it
after rdma_disconnect(), the rdma_cm_id is not in the RDMA_CM_IDLE stat=
e,
and the call fails.

So I can=92t get the QP back to the INIT state unless the rdma_cm_id ha=
s
somehow been reset.

I suppose I could call rdma_init_qp_attr() while the transport is still
connected, and save the returned attributes.


On Jun 20, 2014, at 6:24 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> The QP can be reused. The rdma_id_private has a field reuseaddr. What=
 additional change is needed besides rdma_set_reuseaddr?
>=20
> Shirley
>=20
> On 06/20/2014 02:17 PM, Hefty, Sean wrote:
>>> During a remote transport disconnect, the QP leaves RTS.
>>>=20
>>> xprtrdma deals with this in a separate transport connect worker pro=
cess,
>>> where it creates a new id and qp, and replaces the existing id and =
qp.
>>>=20
>>> Unfortunately there are parts of xprtrdma (namely FRMR deregistrati=
on)
>>> that are not easy to serialize with this reconnect logic.
>>>=20
>>> Re-using the QP would mean no serialization would be needed between
>>> transport reconnect and FRMR deregistration.
>>>=20
>>> If QP re-use is not supported, though, it's not worth considering a=
ny
>>> further.
>>=20
>> It may be possible to reuse the QP, just not the rdma_cm_id without =
additional code changes.  Reuse of the rdma_cm_id may also require chan=
ges in the underlying IB/iWarp CMs.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
