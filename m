From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 10:41:32 -0400
Message-ID: <23E050C1-2A41-4E99-9539-15B07545CA44@oracle.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <55925B70.1070409@mellanox.com> <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jun 30, 2015, at 10:29 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

>=20
>=20
>> -----Original Message-----
>> From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
>> Sent: Tuesday, June 30, 2015 4:04 AM
>> To: Steve Wise; Chuck Lever
>> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linu=
x-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org;
>> infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access =
flags
>>=20
>> On 6/30/2015 12:36 AM, Steve Wise wrote:
>>> The semantics for MR access flags are not consistent across RDMA
>>> protocols.  So rather than have applications try and glean what the=
y
>>> need, have them pass in the intended roles and attributes for the M=
R to
>>> be allocated and let the RDMA core select the appropriate access fl=
ags
>>> given the roles, attributes, and device capabilities.
>>=20
>> wait, we have NFSoRDMA (net/sunrpc/xprtrdma/*) in the kernel for yea=
rs
>> and it works on top of both IB/RoCE and iWARP.I know they have there=
 5-6
>> memory registration methods.. but if we stick to their mode that use=
s
>> fast registration ala your upstream commit 0f7ec3 "RDMA/core: Add me=
mory
>> management extensions support"  -- what's missing or how come it wor=
k
>> w/o the enhancement suggested here?Added Chuck.
>=20
> NFSRDMA currently checks the transport type to decide how to set the =
access flags for memory registration.  With the new services exported i=
n this series, we can change/simplify NFSRDMA to not have to know the t=
ransport type. =20

I was planning to look at this more closely soon, but if you
have patches I=92d happily consider them, or you can just point
me to what needs to be changed and I can put it together for 4.3.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
