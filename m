From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Mon, 21 Jul 2014 10:53:50 -0400
Message-ID: <27ACE237-161A-4CA5-AA5C-6349CC4118E3@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com> <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com> <008c01cfa201$f1eecda0$d5cc68e0$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE1482F@CMEXMB1.ad.emulex.com> <002401cfa28c$11feb4e0$35fc1ea0$@opengridcomputing.com> <53C94199.4050601@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FE1C7B7@CMEXMB1.ad.emulex.com> <a6345162-863d
 -447c-b7c2-059ced190a13@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a6345162-863d-447c-b7c2-059ced190a13-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh-

Thanks for drilling into this further.

On Jul 21, 2014, at 7:48 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> w=
rote:

> In rpcrdma_ep_connect():
>=20
> write_lock(&ia->ri_qplock);
>                old =3D ia->ri_id;
>                ia->ri_id =3D id;
>                write_unlock(&ia->ri_qplock);
>=20
>                rdma_destroy_qp(old);
>                rdma_destroy_id(old);  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D> Cm -id is destroyed here.
>=20
>=20
> If following code fails in rpcrdma_ep_connect():
> id =3D rpcrdma_create_id(xprt, ia,
>                                (struct sockaddr *)&xprt->rx_data.addr=
);
>                if (IS_ERR(id)) {
>                        rc =3D -EHOSTUNREACH;
>                        goto out;
>                }
>=20
> it leaves old cm-id still alive. This will always fail if Device is r=
emoved abruptly.

=46or CM_EVENT_DEVICE_REMOVAL, rpcrdma_conn_upcall() sets ep->rep_conne=
cted
to -ENODEV.

Then:

 929 int
 930 rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 931 {
 932         struct rdma_cm_id *id, *old;
 933         int rc =3D 0;
 934         int retry_count =3D 0;
 935=20
 936         if (ep->rep_connected !=3D 0) {
 937                 struct rpcrdma_xprt *xprt;
 938 retry:
 939                 dprintk("RPC:       %s: reconnecting...\n", __func=
__);

ep->rep_connected is probably -ENODEV after a device removal. It would =
be
possible for the connect worker to destroy everything associated with t=
his
connection in that case to ensure the underlying object reference count=
s
are cleared.

The immediate danger is that if there are pending RPCs, they could exit=
 while
qp/cm_id are NULL, triggering a panic in rpcrdma_deregister_frmr_extern=
al().
Checking for NULL pointers inside the ri_qplock would prevent that.

However, NFS mounts via this adapter will hang indefinitely after all
transports are torn down and the adapter is gone. The only thing that c=
an be
done is something drastic like =93echo b > /proc/sysrq_trigger=94 on th=
e client.

Thus, IMO hot-plugging or passive fail-over are the only scenarios wher=
e
this makes sense. If we have an immediate problem here, is it a problem=
 with
system shutdown ordering that can be addressed in some other way?

Until that support is in place, obviously I would prefer that the remov=
al of
the underlying driver be prevented while there are NFS mounts in place.=
 I
think that=92s what NFS users have come to expect.

In other words, don=92t allow device removal until we have support for =
device
insertion :-)


> In rdma_resolve_addr()/rdma_destroy_id() cm_dev is referenced/de-refe=
renced here (cma.c):
>=20
> static int cma_acquire_dev(struct rdma_id_private *id_priv,
>                           struct rdma_id_private *listen_id_priv) {
> .
> .
> if (!ret)
>                cma_attach_to_dev(id_priv, cma_dev);
> }
>=20
> static void cma_release_dev(struct rdma_id_private *id_priv)
> {
>        mutex_lock(&lock);
>        list_del(&id_priv->list);
>        cma_deref_dev(id_priv->cma_dev);
> .
> .
> }
>=20
> Since as per design of nfs-rdma at-least previously known good cm-id =
always remains live utill
> another good cm-id is created, cma_dev->refcount never becomes 0 upon=
 device removal .
> Thus blocking the rmmod <vendor driver> forever.
>=20
> -Regards
> Devesh
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
>> Sent: Monday, July 21, 2014 11:42 AM
>> To: Shirley Ma; Steve Wise; 'Chuck Lever'
>> Cc: 'Hefty, Sean'; 'Roland Dreier'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provide=
r
>> module
>>=20
>> Shirley,
>>=20
>> Once rmmod is issued, the connection corresponding to the active mou=
nt is
>> destroyed and all the associated resources Are freed. As per the pro=
cessing
>> logic of DEVICE-REMOVAL event, nfs-rdma wakes-up all the  waiters, T=
his
>> results into Re-establishment efforts, since the device is not prese=
nt any
>> more, rdma_resolve_address() fails with CM resolution Error. This lo=
op
>> continues forever.
>>=20
>> I am yet to find out which part of ocrdma is blocked. I am putting s=
ome debug
>> messages to find it out. I will get back to The group with an update=
=2E
>>=20
>> -Regards
>> Devesh
>>=20
>>> -----Original Message-----
>>> From: Shirley Ma [mailto:shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>> Sent: Friday, July 18, 2014 9:18 PM
>>> To: Steve Wise; Devesh Sharma; 'Chuck Lever'
>>> Cc: 'Hefty, Sean'; 'Roland Dreier'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provid=
er
>>> module
>>>=20
>>>=20
>>> On 07/18/2014 06:27 AM, Steve Wise wrote:
>>>>>>> We can't really deal with a CM_DEVICE_REMOVE event while there
>>>>>>> are active NFS mounts.
>>>>>>>=20
>>>>>>> System shutdown ordering should guarantee (one would hope) that
>>> NFS
>>>>>>> mount points are unmounted before the RDMA/IB core
>> infrastructure
>>>>>>> is torn down. Ordering shouldn't matter as long all NFS activit=
y
>>>>>>> has ceased before the CM tries to remove the device.
>>>>>>>=20
>>>>>>> So if something is hanging up the CM, there's something xprtrdm=
a
>>>>>>> is not cleaning up properly.
>>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>> Devesh, how are you reproducing this?  Are you just rmmod'ing th=
e
>>>>>> ocrdma module while there are active mounts?
>>>>>=20
>>>>> Yes, I am issuing rmmod while there is an active mount. In my cas=
e
>>>>> rmmod ocrdma remains blocked forever.
>>> Where is it blocked?
>>>=20
>>>>> Off-the-course of this discussion: Is there a reasoning behind no=
t
>>>>> using
>>>>> ib_register_client()/ib_unregister_client() framework?
>>>>=20
>>>> I think the idea is that you don't need to use it if you are
>>>> transport-independent and use the rdmacm...
>>>>=20
>>>>=20
>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma"
>>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
>>> majordomo
>>>> info at  http://vger.kernel.org/majordomo-info.html
>>>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info a=
t
>> http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
