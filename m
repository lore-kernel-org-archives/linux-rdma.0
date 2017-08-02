From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Wed, 2 Aug 2017 00:30:33 +0000
Message-ID: <VI1PR0502MB300860BDA4E6BD0B10F5DB1ED1B00@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
 <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801190052.GA31205@obsidianresearch.com>
 <VI1PR0502MB3008D65E9568764C4A781230D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170801233754.GB10239@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801233754.GB10239-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, August 01, 2017 6:38 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Tue, Aug 01, 2017 at 10:06:14PM +0000, Parav Pandit wrote:
>=20
> > > > >  Initial Condition VA=3D0 Data =3D 0  RDMA-W VA=3D0 Data=3D1  RDM=
A-R
> > > > > VA=3D0
> > > > >
> > > > > Spec says 1 must be returned, but sounds like this relaxed
> > > > > version could
> > > return 0.
> > >
> > > > No. Table 76 stays as is as described before.
> > >
> > > How is this possible?
>=20
> > I am not sure what more can I explain you Jason.
> > Requester side HCA follows HCA Table-76.
> > Incoming read responses are not processed until previous writes are
> > ACKed implicitly (in read responses) or explicitly by ACK packets.
> > Same as before described in spec. No extra description needed for this
> > patchset.
>=20
> But doing that pretty much destroys much of the entire point of having a =
relaxed
> ordering :P
>
Probably not. I can understand that having that would be possibly ultimate =
thing.
I like to add that whenever its available too.
Some of the applications are heavy write or read driven instead of mix oper=
ations - those benefit from this attribute.
=20
> > > > >  RDMA-W VA=3D0 Data=3D1
> > > > >  RDMA-W VA=3D0 Data=3D2
> > > > >  SEND
> > > > >
> > > > > Sounds like with the relaxed version the app could see 1 at SEND =
CQ time.
> > > > >
> > > > > So RDMA-W -> RDMA-W degrades to a F
> > >
> > > > No. Table-76 is based on  how requester sees the execution.
> > > > So it stays as '#'.
> > >
> > > How is this possible?
> > >
> > Please don't mix requester side ordering with responder side execution.
> > C9-28 on responder side is relaxed - as explained few times before.
>=20
> No, I see what you are tring to say now.=20
Great.

> I disagree with this. Table-76 and C9-28
> are describing the same thing, you cannot weaken C9-28 without also resta=
ting
> Table 76.
>
The intent is to not extend the definition of fence bit beyond RDMA reads h=
ere.
What you are asking is when ooo attribute is set, and if user still wants t=
o do in-order RDMA Writes for W1 and W2, fence bit should be extended for i=
t.
There can be very few use cases where certain operations needs to follow or=
dering and certain don't in a single QP.
User is rather better off not setting this attribute on a QP when it needs =
W1, W2 ordering.

> Table 76 is clearly talking about the entire system, including the execut=
ion and
> memory subsystem of the completer.
>=20
> > It covers only requester side.
> > Send with invalidate execution on responder side is described in
> > 9.4.1.1.1
>=20
> I suppose 9.4.1.1.1 point #1 already allows the out of order behavior.
>
It allows because to indicates below.
(a) Paragraph above #1. Snippet below.
"Since the invalidation operation is not executed
by the transport layer, the Invalidate operation may take place either
before or after the transport-level acknowledge has been generated"

So it can still send out the ACK while invalidation in progress (not yet st=
arted).
While that is in progress new operation can still target invalidated region=
.
Now depending on how slow invalidation is going, subsequent operation DMA a=
lso.
Most good adapters won't send out ACK before invalidating to my knowledge e=
ven though spec allows it.
Because doing so is very hard to debug and keeps hole open for accidental m=
emory corruption.

Also 9.4.1.1.1 is for subsequent operations where Send_Inv is second operat=
ion.

The example of=20
RDMA-W1, RDMA-W2, Send_Invalidate actually follows section 9.4.1.1.1 point =
#2.

 > > You are proposing a different behavior and attribute which may be done
> > for a HCA that support such thing.  Please submit a different patch
> > for it whenever its appropriate.  Current query HCA attribute is bit
> > field for future relaxation. May be what you described can be done.
>=20
> you do have to define them in a sensible and usefully broad way using the
> community process.
>
Sure. That's why we are discussing here.
=20
> > Other out of order atomics such as
> > Atomic->Read
> > Write->Atomic may be done in future under different attribute.
>=20
> I think that is a mistake, you should start with them being out of order =
and
> require the app to fence to bring order back, even if the current HCAs ex=
ecute
> them in order anyhow.
>=20
I would agree for Atomic->read case because it's very similar to READ->Read=
.
Write->Atomic goes back to first point as atomic completions can trigger im=
plicit Write completions.
So Write->atomic I will keep out of this attribute.
Let me check with Idan for applying fence bit on Atomic->read, what he thin=
ks about it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
