From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3] svcrdma: advertise the correct max payload
Date: Wed, 24 Sep 2014 14:12:58 -0700
Message-ID: <55D3FB7C-3DDD-42B0-96F7-8134096F745C@oracle.com>
References: <20140923221122.24227.91718.stgit@build.ogc.int> <5422B14C.3040502@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5422B14C.3040502-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, fields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Sep 24, 2014, at 4:55 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 9/24/2014 1:11 AM, Steve Wise wrote:
>> Svcrdma currently advertises 1MB, which is too large.  The correct v=
alue
>> is the minimum of RPCSVC_MAXPAYLOAD and the max scatter-gather allow=
ed
>> in an NFSRDMA IO chunk * the host page size. This bug is usually ben=
ign
>> because the Linux X64 NFSRDMA client correctly limits the payload si=
ze to
>> the correct value (64*4096 =3D 256KB).  But if the Linux client is P=
PC64
>> with a 64KB page size, then the client will indeed use a payload siz=
e
>> that will overflow the server.
>>=20
>=20
> Maybe I'm a bit late with this, but can you explain why SG table is
> limited to 64 (fastreg MR and page_list probably bound it). Where is =
it
> coming from? Naturally it needs to be bound by some figure, but why 6=
4?

It=92s arbitrary, AFAIK. It has been used to allocate some data structu=
res
on the stack, for example, so it can=92t be too large.

It=92s something we need to look at.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
