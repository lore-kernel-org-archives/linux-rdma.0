From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 1 Aug 2017 22:06:14 +0000
Message-ID: <VI1PR0502MB3008D65E9568764C4A781230D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
 <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801190052.GA31205@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801190052.GA31205-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, August 01, 2017 2:01 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Tue, Aug 01, 2017 at 06:14:08PM +0000, Parav Pandit wrote:
>=20
> > >  Initial Condition VA=3D0 Data =3D 0
> > >  RDMA-W VA=3D0 Data=3D1
> > >  RDMA-R VA=3D0
> > >
> > > Spec says 1 must be returned, but sounds like this relaxed version co=
uld
> return 0.
>=20
> > No. Table 76 stays as is as described before.
>=20
> How is this possible?
I am not sure what more can I explain you Jason.
Requester side HCA follows HCA Table-76.
Incoming read responses are not processed until previous writes are ACKed i=
mplicitly (in read responses) or explicitly by ACK packets.
Same as before described in spec. No extra description needed for this patc=
hset.

>=20
> > >  RDMA-W VA=3D0 Data=3D1
> > >  RDMA-W VA=3D0 Data=3D2
> > >  SEND
> > >
> > > Sounds like with the relaxed version the app could see 1 at SEND CQ t=
ime.
> > >
> > > So RDMA-W -> RDMA-W degrades to a F
>=20
> > No. Table-76 is based on  how requester sees the execution.
> > So it stays as '#'.
>=20
> How is this possible?
>=20
Please don't mix requester side ordering with responder side execution.
C9-28 on responder side is relaxed - as explained few times before.

> You've clearly stated this feature allows out of order execution across p=
acket
> boundaries, there is no way to know at the responder what the missed pack=
ets
> where, so ineventiably, both of these cases must be possible. Or you are =
wrong
> about the statement on out of order.
Two examples already explained about out-of-order execution.
To me it appears that you are confused with requester vs responder side exe=
cution.
What more can I explain other than repeating=20
(a) Table 76 on requester side stays as is and
(b) C9-28 is relaxed on responder side.

> > > However, SEND WITH INVALIDATE is a special cases that impacts the
> > > processing of work itself, not just the CPU observation, which is a
> > > bit outside what table 76 is talking about.
>=20
> > SEND, SEND WITH IMM, SEND WITH INVALIDATE falls in same category as
> send as first column in Table76.
>=20
> Not really, I don't think you understand how this all fits together..
>=20

> > > I'd advocate for allowing this to be out of order (but documented as
> > > such), as impliclty fencing SEND WITH INVALIDATE is not acceptable
> > > for performance and
>=20
> > It is as per first column of Table-76.
>=20
> Dn't understand you remark, it is clearly ordered..
>=20
I was saying, that there is no change on send ordering at requester side.

> > > most workloads using that feature do not care about this strict order=
ing.
> > >
> > nvme fabrics do care.
> > nvme fabrics target does RDMA-W, RDMA_S_INV sequence on the same
> memory key that is being used in RDMA-W without waiting for RDMA-W
> completion for good reason.
> > I recall SMB doing the same as well.
> > RDMA-S_INV after RDMA-W cannot break the order.
>=20
> They don't care, because RDMA_WRITE, SEND_WITH_INVALIDATE on the same
> rkey does not try to write to the rkey memory twice, which is the only ca=
se
> where adding out of order execution really matters.
>=20
It doesn't have to be an overlapping write to same rkey.
One block IO can translate to multiple RDMA-W from the target side, potenti=
ally to same rkey.
One possibility is target code ran out of number of local sges or had fragm=
ented memory.
So=20
RDMA-W1 (key=3DA, VA=3D0x1000, len=3D16K with 4 SGEs)
RDMA-W2 (key=3DA, VA=3D0x5000, len=3D16K, with 4 SGEs)
Send(Invalidate_key=3DA)
You do not want SEND_INVALIDATE to stop DMA of RDMA-W1 at later point.
So Send CQE cannot reach before previous RDMA-w1 and w2 are completed.

> They only care that the invalidate guarentees no DMA is possible once it =
reaches
> the receiver's CQ.
>=20
> > > The requirement is really that by the time the SEND RCQ is seen that
> > > the INVALIDATE has taken effect.
> > >
> > Current Table-76 requirement already relaxes for
> > RDMA-R-> RDMA_S_INV.
> > However most users won't do above sequence because users would not like=
 to
> fail duplicate read requests.
> > So let's continue with Table-76 for SEND as 2nd operation as defined
> > today. (first column stays as is)
>=20
> As I said, table 76 does not really capture the full behavior of INVALIDA=
TE.
>=20
It covers only requester side.
Send with invalidate execution on responder side is described in 9.4.1.1.1

> The spec requires WRITE,INV,WRITE to fail, but it would be just a fine fo=
r
> storage protocols if WRITE,INV,WRITE could succeed, so long as delivering=
 the
> INV to the CQ fences the DMA, which can be done in a high performance way=
.
> Fencing the WRITE,INV,WRITE can not be done with high performance.
>=20
You are proposing a different behavior and attribute which may be done for =
a HCA that support such thing.
Please submit a different patch for it whenever its appropriate.
Current query HCA attribute is bit field for future relaxation. May be what=
 you described can be done.

> > > Atomic are basically similar, sounds like Atomic Op -> RDMA Read
> > > should degrade to a F as well. I'd say that is desired as well.
> >
> > No. Table-76 stays as is.
> > Atomic->Atomic is already 'F'.
> > Atomic->RDMA_R is continues as '#'. (Similar to RDMA_W->RDMA_R).
>=20
> Same argument as above, many apps will tolerate out of order for atomics,=
 thee
> default for an out of order mode should be to allow it, and let apps requ=
est in
> order with fence.
>
Following are already 'F'.
Atomic->Atomic
Atomic->Write=20
Read->Atomic

Other out of order atomics such as
Atomic->Read
Write->Atomic may be done in future under different attribute.

Jason,
Once single attribute is not solution to all out-of-order needs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
