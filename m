From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [for-next 1/2] xprtrdma: take reference of rdma provider module
Date: Thu, 17 Jul 2014 11:05:58 -0400
Message-ID: <78A77C48-AC73-4C01-B139-A00B4F674C70@oracle.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3e39e90f-7095-4eb9-a844-516672a355ad@CMEXHTCAS2.ad.emulex.com> <53C7E546.3080008@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53C7E546.3080008-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jul 17, 2014, at 11:01 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

>=20
>=20
> On 7/17/2014 9:01 AM, Devesh Sharma wrote:
>> If verndor driver is attempted for removal while xprtrdma still has =
an
>> active mount, the removal of driver may never complete and can cause
>> unseen races or in worst case system crash.
>>=20
>> To solve this, xprtrdma module should get reference of struct ib_dev=
ice
>> structure for every mount. Reference is taken after local device add=
ress
>> resolution is completed successfuly.
>>=20
>> reference to the struct ib_device pointer is put just before cm_id d=
estruction.
>>=20
>> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>=20
> This seems like an issue with the rdma-cm or rdma core, not xprtrdma.

Good point. I was wondering if svcrdma might have a similar issue.

Infrequently I see a hang during shutdown that appears to be related to
the ordering of removal of one of the RDMA modules, but I=92ve never ha=
d
time to chase it.

See also: https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D252


> I see that user rdma applications cause a ref on the provider module =
here in ib_uverbs_open():
>=20
>        if (!try_module_get(dev->ib_dev->owner)) {
>                ret =3D -ENODEV;
>                goto err;
>=20
>=20
> Maybe kernel applications that allocate device resources should cause=
 a ref on the provider's module.
>=20
> Sean/Roland,  is there some history here as to how rdma provider modu=
le removal should be handled?
>=20
> Steve.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
