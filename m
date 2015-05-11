From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 04/14] xprtrdma: Use ib_device pointer safely
Date: Mon, 11 May 2015 14:57:36 -0400
Message-ID: <46C61716-AF81-41D9-BC21-141A5F70C637@oracle.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175720.3483.80356.stgit@manet.1015granger.net> <554B37CF.2070206@dev.mellanox.co.il> <E1ADA91B-45DA-46B6-A114-E2600613969A@oracle.com> <554B6F2A.6000608@dev.mellanox.co.il> <BDE22240-DC37-4C54-B71E-D88EF54D3119@oracle.com> <554B80B7.8090900@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FCE01F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCE01F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 11, 2015, at 2:26 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>>> ia->ri_device is never updated. The only place it is set is in
>>> rpcrdma_ia_open().
>>=20
>> So you assume that each ri_id that you will recreate contains the
>> same device handle?
>>=20
>> I think that for ADDR_CHANGE event when the slave belongs to another
>> device you will hit a mismatch. CC'ing Sean for more info...
>=20
> I'm not familiar with the xprtrdma code.  From the perspective of the=
 rdma_cm, if a listen is associated with a specific IP address, then it=
 will also be associated with a specific device.  If an address change =
occurs, and the address moves to another device, then the app is essent=
ially left with an unusable listen.  Received connection requests will =
not find a matching listen and be dropped.

Thanks Sean.

xprtrdma is the client-side (initiator), so it drives transport connect=
s. The
server-side (target) does the listens. My proposed change is only on th=
e client.

> If the address moves ports on the same device, then I think this work=
s out fine in the case where the app ignores the ADDR_CHANGE event.

xprtrdma currently doesn=92t explicitly handle ADDR_CHANGE events (and =
neither
does the server-side, looks like).

In the deployment scenarios I=92m aware of, a single HCA with two ports=
 is
used to form the bonded pair. I=92m sure that=92s not the only way this=
 can
be done, though.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
