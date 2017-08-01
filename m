From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 1 Aug 2017 18:14:08 +0000
Message-ID: <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170722212706.GA14714-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Saturday, July 22, 2017 4:27 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>; Bart Van Assche
> <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> On Sat, Jul 22, 2017 at 05:32:05PM +0000, Parav Pandit wrote:
> > >
> > > Eg
> > >
> > >  RDMA-W VA=3D0 Data=3D1
> > >  RDMA-R VA=3D0
> > >  RDMA-W VA=3D0 Data=3D2
> > >
> > > What does the read return? Spec says 1, but it sounds like this
> > > relaxed ordering could return 2.
> > >
> > Spec says Data=3D1 on RDMA-R only if Fence is set on read operation in =
Table-
> 76.
> > Otherwise duplicate read request after executing RDMA-W2 of Data=3D2 ca=
n
> return Data=3D2 on read request.
>=20
> Erm, I should have written it like this
>=20
>  Initial Condition VA=3D0 Data =3D 0
>  RDMA-W VA=3D0 Data=3D1
>  RDMA-R VA=3D0
>=20
> Spec says 1 must be returned, but sounds like this relaxed version could =
return 0.
No. Table 76 stays as is as described before.

> So RDMA Write -> RDMA Read degrades to a F
>=20
> Similarly,
>=20
>  RDMA-W VA=3D0 Data=3D1
>  RDMA-W VA=3D0 Data=3D2
>  SEND
>=20
> Sounds like with the relaxed version the app could see 1 at SEND CQ time.
>=20
> So RDMA-W -> RDMA-W degrades to a F
No. Table-76 is based on  how requester sees the execution.
So it stays as '#'.

>=20
> > > Whta about
> > >
> > >  RDMA-W VA=3D0 Data=3D1
> > >  SEND WITH INVALIDATE VA=3D0
> > >  RDMA-W VA=3D0 Data=3D2
> > >
> > > Spec says the second RDMA-W must fail,
> > Right.
> >
> > > but it sounds like this relaxed ordering would allow it to happen.
>=20
> > No. Table 76 is followed in this case.
> > 1st operation Write.
> > 2nd operation send.
> > There is implicit fence defined by '#' in Table, which is followed.
> > So 2nd RDMA-W continue to fail.
>=20
> So, I expect what is happening here is that the SEND RCQ is delayed until=
 the
> sequence numbers catch up, eg guarenteeing that all packets prior to the =
SEND
> have been seen and committed to memory.
> Which is what table 76 is primarily talking about.
>=20
> However, SEND WITH INVALIDATE is a special cases that impacts the process=
ing
> of work itself, not just the CPU observation, which is a bit outside what=
 table 76
> is talking about.
>=20
SEND, SEND WITH IMM, SEND WITH INVALIDATE falls in same category as send as=
 first column in Table76.

> I'd advocate for allowing this to be out of order (but documented as such=
), as
> impliclty fencing SEND WITH INVALIDATE is not acceptable for performance =
and
It is as per first column of Table-76.

> most workloads using that feature do not care about this strict ordering.
>=20
nvme fabrics do care.
nvme fabrics target does RDMA-W, RDMA_S_INV sequence on the same memory key=
 that is being used in RDMA-W without waiting for RDMA-W completion for goo=
d reason.
I recall SMB doing the same as well.
RDMA-S_INV after RDMA-W cannot break the order.

> The requirement is really that by the time the SEND RCQ is seen that the
> INVALIDATE has taken effect.
>=20
Current Table-76 requirement already relaxes for=20
RDMA-R-> RDMA_S_INV.
However most users won't do above sequence because users would not like to =
fail duplicate read requests.
So let's continue with Table-76 for SEND as 2nd operation as defined today.=
 (first column stays as is)

> Atomic are basically similar, sounds like Atomic Op -> RDMA Read should
> degrade to a F as well. I'd say that is desired as well.

No. Table-76 stays as is.
Atomic->Atomic is already 'F'.
Atomic->RDMA_R is continues as '#'. (Similar to RDMA_W->RDMA_R).

> > I completely understand and agree that storage protocols who depend on
> > RDMA-CM would like to have this.  But again, unavailability of this
> > bit in RDMA-CM is not a blocker for user land apps and let them start
> > using it.  Once RDMA-CM has it, storage kernel ULPs can also be
> > enabled.
>=20
> If there is no path to get this into the RDMA CM then it is just another =
vendor
> feature and it does not belong in the common API.

RDMA CM is not the only connection manager is use today.
Once RDMA CM has it, it can be extended there as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
