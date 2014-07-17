From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 16:41:45 -0400
Message-ID: <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com>  <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jul 17, 2014, at 4:08 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> w=
rote:

>=20
>=20
>> -----Original Message-----
>> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
>> Sent: Thursday, July 17, 2014 2:56 PM
>> To: 'Hefty, Sean'; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>> Cc: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org'
>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provide=
r module
>>=20
>>=20
>>=20
>>> -----Original Message-----
>>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>>> Sent: Thursday, July 17, 2014 2:50 PM
>>> To: Steve Wise; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma provid=
er module
>>>=20
>>>>> So the rdma cm is expected to increase the driver reference count
>>>> (try_module_get) for
>>>>> each new cm id, then deference count (module_put) when cm id is
>>>> destroyed?
>>>>>=20
>>>>=20
>>>> No, I think he's saying the rdma-cm posts a RDMA_CM_DEVICE_REMOVAL=
 event
>>>> to each
>>>> application with rdmacm objects allocated, and each application is=
 expected
>>>> to destroy all
>>>> the objects it has allocated before returning from the event handl=
er.
>>>=20
>>> This is almost correct.  The applications do not have to destroy al=
l the objects that
> it has
>>> allocated before returning from their event handler.  E.g. an app c=
an queue a work
> item
>>> that does the destruction.  The rdmacm will block in its ib_client =
remove handler
> until all
>>> relevant rdma_cm_id's have been destroyed.
>>>=20
>>=20
>> Thanks for the clarification.
>>=20
>=20
> And looking at xprtrdma, it does handle the DEVICE_REMOVAL event in r=
pcrdma_conn_upcall().
> It sets ep->rep_connected to -ENODEV, wakes everybody up, and calls r=
pcrdma_conn_func()
> for that endpoint, which schedules rep_connect_worker...  and I gave =
up following the code
> path at this point... :) =20
>=20
> For this to all work correctly, it would need to destroy all the QPs,=
 MRs, CQs, etc for
> that device _before_ destroying the rdma cm ids.  Otherwise the provi=
der module could be
> unloaded too soon=85

We can=92t really deal with a CM_DEVICE_REMOVE event while there are ac=
tive
NFS mounts.

System shutdown ordering should guarantee (one would hope) that NFS
mount points are unmounted before the RDMA/IB core infrastructure is
torn down. Ordering shouldn=92t matter as long all NFS activity has
ceased before the CM tries to remove the device.

So if something is hanging up the CM, there=92s something xprtrdma is n=
ot
cleaning up properly.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
