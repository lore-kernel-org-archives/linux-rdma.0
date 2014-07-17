From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 14:25:14 -0700
Message-ID: <53C83F3A.7020608@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FCA3@ORSMSX109.amr.corp.intel.com> <53C81CB7.2030000@oracle.com> <006d01cfa1f2$65d020d0$31706270$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823739933FDEA@ORSMSX109.amr.corp.intel.com>  <008301cfa1fa$f231f550$d695dff0$@opengridcomputing.com> <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DF7CE85B-288D-4CC2-AD51-B326D5F1EE1A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 07/17/2014 01:41 PM, Chuck Lever wrote:
> On Jul 17, 2014, at 4:08 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>=
 wrote:
>=20
>> >=20
>> >=20
>>> >> -----Original Message-----
>>> >> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
>>> >> Sent: Thursday, July 17, 2014 2:56 PM
>>> >> To: 'Hefty, Sean'; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier=
'
>>> >> Cc: 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org'
>>> >> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma pro=
vider module
>>> >>=20
>>> >>=20
>>> >>=20
>>>> >>> -----Original Message-----
>>>> >>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>>>> >>> Sent: Thursday, July 17, 2014 2:50 PM
>>>> >>> To: Steve Wise; 'Shirley Ma'; 'Devesh Sharma'; 'Roland Dreier'
>>>> >>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>>>> >>> Subject: RE: [for-next 1/2] xprtrdma: take reference of rdma p=
rovider module
>>>> >>>=20
>>>>>> >>>>> So the rdma cm is expected to increase the driver referenc=
e count
>>>>> >>>> (try_module_get) for
>>>>>> >>>>> each new cm id, then deference count (module_put) when cm =
id is
>>>>> >>>> destroyed?
>>>>>> >>>>>=20
>>>>> >>>>=20
>>>>> >>>> No, I think he's saying the rdma-cm posts a RDMA_CM_DEVICE_R=
EMOVAL event
>>>>> >>>> to each
>>>>> >>>> application with rdmacm objects allocated, and each applicat=
ion is expected
>>>>> >>>> to destroy all
>>>>> >>>> the objects it has allocated before returning from the event=
 handler.
>>>> >>>=20
>>>> >>> This is almost correct.  The applications do not have to destr=
oy all the objects that
>> > it has
>>>> >>> allocated before returning from their event handler.  E.g. an =
app can queue a work
>> > item
>>>> >>> that does the destruction.  The rdmacm will block in its ib_cl=
ient remove handler
>> > until all
>>>> >>> relevant rdma_cm_id's have been destroyed.
>>>> >>>=20
>>> >>=20
>>> >> Thanks for the clarification.
>>> >>=20
>> >=20
>> > And looking at xprtrdma, it does handle the DEVICE_REMOVAL event i=
n rpcrdma_conn_upcall().
>> > It sets ep->rep_connected to -ENODEV, wakes everybody up, and call=
s rpcrdma_conn_func()
>> > for that endpoint, which schedules rep_connect_worker...  and I ga=
ve up following the code
>> > path at this point... :) =20
>> >=20
>> > For this to all work correctly, it would need to destroy all the Q=
Ps, MRs, CQs, etc for
>> > that device _before_ destroying the rdma cm ids.  Otherwise the pr=
ovider module could be
>> > unloaded too soon=85
> We can=92t really deal with a CM_DEVICE_REMOVE event while there are =
active
> NFS mounts.
>=20
> System shutdown ordering should guarantee (one would hope) that NFS
> mount points are unmounted before the RDMA/IB core infrastructure is
> torn down. Ordering shouldn=92t matter as long all NFS activity has
> ceased before the CM tries to remove the device.
>=20
> So if something is hanging up the CM, there=92s something xprtrdma is=
 not
> cleaning up properly.

I saw a problem once, restart the system without umounting the NFS. CM =
was hung on waiting for completion. It looks like a  bug in xprtrdma cl=
eanup up. I couldn't reproduce it.

Call Trace:
 [<ffffffff815c9aa9>] schedule+0x29/0x70
 [<ffffffff815c8d35>] schedule_timeout+0x165/0x200
 [<ffffffff815ca9ff>] ? wait_for_completion+0xcf/0x110
 [<ffffffff810a708e>] ? __lock_release+0x9e/0x1f0
 [<ffffffff815ca9ff>] ? wait_for_completion+0xcf/0x110
 [<ffffffff815caa07>] wait_for_completion+0xd7/0x110
 [<ffffffff8108bce0>] ? try_to_wake_up+0x260/0x260
 [<ffffffffa064cb6e>] cma_process_remove+0xee/0x110 [rdma_cm]
 [<ffffffffa064cbdc>] cma_remove_one+0x4c/0x60 [rdma_cm]
 [<ffffffffa0279e0f>] ib_unregister_device+0x4f/0x100 [ib_core]
 [<ffffffffa02f76ee>] mlx4_ib_remove+0x2e/0x260 [mlx4_ib]
 [<ffffffffa01754c9>] mlx4_remove_device+0x69/0x80 [mlx4_core]
 [<ffffffffa01755b3>] mlx4_unregister_interface+0x43/0x80 [mlx4_core]
 [<ffffffffa030970c>] mlx4_ib_cleanup+0x10/0x23 [mlx4_ib]
 [<ffffffff810d9183>] SyS_delete_module+0x183/0x1e0
 [<ffffffff810f7c94>] ? __audit_syscall_entry+0x94/0x100
 [<ffffffff812c5789>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff815cec92>] system_call_fastpath+0x16/0x1b


Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
