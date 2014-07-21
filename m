From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Mon, 21 Jul 2014 11:20:34 -0400
Message-ID: <D88D1952-83A1-4FF9-B028-AAE7A859A5B1@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com> <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com> <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com> <53C94199.4050601@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FE1C7B7@CMEXMB1.ad.emulex.com> <a6345162-863d
 -447c-b7c2-059ced190a13@CMEXHTCAS1.ad.emulex.com> <27ACE237-161A-4CA5-AA5C-6349CC4118E3@oracle.com> <005701cfa4f4$f7a64c00$e6f2e400$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005701cfa4f4$f7a64c00$e6f2e400$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jul 21, 2014, at 11:03 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

>=20
>=20
>> -----Original Message-----
>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>> Sent: Monday, July 21, 2014 9:54 AM
>> To: Devesh Sharma
>> Cc: Shirley Ma; Steve Wise; Hefty, Sean; Roland Dreier; linux-rdma@v=
ger.kernel.org
>> Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provide=
r module
>>=20
>> Hi Devesh-
>>=20
>> Thanks for drilling into this further.
>>=20
>> On Jul 21, 2014, at 7:48 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org=
> wrote:
>>=20
>>> In rpcrdma_ep_connect():
>>>=20
>>> write_lock(&ia->ri_qplock);
>>>               old =3D ia->ri_id;
>>>               ia->ri_id =3D id;
>>>               write_unlock(&ia->ri_qplock);
>>>=20
>>>               rdma_destroy_qp(old);
>>>               rdma_destroy_id(old);  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D> Cm -id is destroyed here.
>>>=20
>>>=20
>>> If following code fails in rpcrdma_ep_connect():
>>> id =3D rpcrdma_create_id(xprt, ia,
>>>                               (struct sockaddr *)&xprt->rx_data.add=
r);
>>>               if (IS_ERR(id)) {
>>>                       rc =3D -EHOSTUNREACH;
>>>                       goto out;
>>>               }
>>>=20
>>> it leaves old cm-id still alive. This will always fail if Device is=
 removed abruptly.
>>=20
>> For CM_EVENT_DEVICE_REMOVAL, rpcrdma_conn_upcall() sets ep->rep_conn=
ected
>> to -ENODEV.
>>=20
>> Then:
>>=20
>> 929 int
>> 930 rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
>> 931 {
>> 932         struct rdma_cm_id *id, *old;
>> 933         int rc =3D 0;
>> 934         int retry_count =3D 0;
>> 935
>> 936         if (ep->rep_connected !=3D 0) {
>> 937                 struct rpcrdma_xprt *xprt;
>> 938 retry:
>> 939                 dprintk("RPC:       %s: reconnecting...\n", __fu=
nc__);
>>=20
>> ep->rep_connected is probably -ENODEV after a device removal. It wou=
ld be
>> possible for the connect worker to destroy everything associated wit=
h this
>> connection in that case to ensure the underlying object reference co=
unts
>> are cleared.
>>=20
>> The immediate danger is that if there are pending RPCs, they could e=
xit while
>> qp/cm_id are NULL, triggering a panic in rpcrdma_deregister_frmr_ext=
ernal().
>> Checking for NULL pointers inside the ri_qplock would prevent that.
>>=20
>> However, NFS mounts via this adapter will hang indefinitely after al=
l
>> transports are torn down and the adapter is gone. The only thing tha=
t can be
>> done is something drastic like "echo b > /proc/sysrq_trigger" on the=
 client.
>>=20
>> Thus, IMO hot-plugging or passive fail-over are the only scenarios w=
here
>> this makes sense. If we have an immediate problem here, is it a prob=
lem with
>> system shutdown ordering that can be addressed in some other way?
>>=20
>> Until that support is in place, obviously I would prefer that the re=
moval of
>> the underlying driver be prevented while there are NFS mounts in pla=
ce. I
>> think that's what NFS users have come to expect.
>>=20
>> In other words, don't allow device removal until we have support for=
 device
>> insertion :-)
>>=20
>>=20
>=20
>=20
> If we fix the above problems on provider unload, shouldn't the mount =
recover if the
> provider module is subsequently loaded?  Or another provider configur=
ed such that
> rdma_resolve_addr/route() then picks an active device?

On device removal, we have to destroy everything.

On insertion, we=92ll have to create a fresh PD and MRs, which isn=92t =
done now
during reconnect. So, insertion needs work too.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
