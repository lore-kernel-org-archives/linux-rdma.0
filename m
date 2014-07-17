From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 00/21] NFS/RDMA client patches for 3.17
Date: Thu, 17 Jul 2014 10:16:21 -0400
Message-ID: <5DD61444-DCBF-40B7-B246-6CAD450E7047@oracle.com>
References: <59034BAD-306F-462F-A274-3EB06C0CBE47@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FE10DE1@CMEXMB1.ad.emulex.com> <3cf9f937-4c1c-4a39-9fb8-aca5eea15880@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3cf9f937-4c1c-4a39-9fb8-aca5eea15880-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 17, 2014, at 10:12 AM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org> =
wrote:

> Hi Chuck,
>=20
> Tested the cable pull also. V3 is passing the cable pull test also. I=
 have tried following tests:
>=20
> Run iozone on nfs-rdma mount.
> Bring down the link from switch (to simulate cable pull).
> Wait for 10 secs.
> Bring back the link.
> This test passes, iozone resumes traffic.
>=20
> Run iozone on nfs-rdma mount.
> Bring down the link from switch (to simulate cable pull).
> Wait for 70 secs.
> Bring back the link.
> This test passes, iozone resumes traffic.

Thanks Devesh!

May I add "Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>=94 ?

>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
>> Sent: Thursday, July 17, 2014 10:37 AM
>> To: Chuck Lever; linux-rdma; Linux NFS Mailing List
>> Subject: RE: [PATCH v3 00/21] NFS/RDMA client patches for 3.17
>>=20
>> Hi Chuck,
>>=20
>>=20
>> Tested v3 with  ocrdma (linux-3.16-rc5 inbox`ed ocrdma). Both Cthon =
and
>> iozone passes with and regressions. I will perform cable pull test a=
s well and
>> get back to you.
>>=20
>> -Regards
>> Devesh
>>=20
>>> -----Original Message-----
>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>>> Sent: Tuesday, July 15, 2014 7:54 PM
>>> To: linux-rdma; Linux NFS Mailing List
>>> Subject: [PATCH v3 00/21] NFS/RDMA client patches for 3.17
>>>=20
>>> The main purpose of this series is to address connection drop recov=
ery
>>> issues by fixing FRMR re-use to make it less likely the client will
>>> deadlock due to a memory management operation error.
>>>=20
>>> Some clean-ups and other fixes are present as well.
>>>=20
>>> See topic branch nfs-rdma-for-3.17 in
>>>=20
>>> git://git.linux-nfs.org/projects/cel/cel-2.6.git
>>>=20
>>> I tested with NFSv3 and NFSv4 on all three supported memory
>>> registration modes. Used cthon04, iozone, and dbench with both Sola=
ris
>>> and Linux NFS/RDMA servers. Used xfstests with Linux.
>>>=20
>>> v3:
>>> Only two substantive changes:
>>>=20
>>> - Patch 08/21 now uses generic IB helpers for managing FRMR
>>>  rkeys
>>>=20
>>> - Add Tested-by: from Steve Wise
>>>=20
>>>=20
>>> v2:
>>> Many patches from v1 have been written or replaced.
>>>=20
>>> The MW ref counting approach in v1 is abandoned. Instead, I've
>>> eliminated signaling FAST_REG_MR and LOCAL_INV, and added
>> appropriate
>>> recovery mechanisms after a transport reconnect that should prevent
>>> rkey dis- synchrony entirely.
>>>=20
>>> A couple of optimizations have been added, including:
>>>=20
>>> - Allocating each MW separately rather than carving each out of a
>>>  large piece of contiguous memory
>>>=20
>>> - Now that the receive CQ upcall handler dequeues a bundle of CQEs
>>>  at once, fire off the reply handler tasklet just once per upcall
>>>  to reduce context switches and how often hard IRQs are disabled
>>>=20
>>> Jury is still out on the latter.
>>>=20
>>> --
>>> Chuck Lever
>>> chuck[dot]lever[at]oracle[dot]com
>>>=20
>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
>> majordomo
>>> info at http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info a=
t
>> http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
