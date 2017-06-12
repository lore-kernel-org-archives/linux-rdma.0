From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 21:53:55 +0000
Message-ID: <VI1PR0502MB30082486BC3B1669FE48764ED1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
 <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <b5279c09-027f-e374-ffde-7f236c52322c@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
 <085201d2e3be$81070ce0$831526a0$@opengridcomputing.com>
 <20170612210259.GA25652@obsidianresearch.com>
 <086401d2e3c1$72d54b20$587fe160$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <086401d2e3c1$72d54b20$587fe160$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> Sent: Monday, June 12, 2017 4:19 PM
> To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: 'Hefty, Sean' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; 'Dalessandro, Dennis'
> <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; 'Doug Ledford'
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> > On Mon, Jun 12, 2017 at 03:57:29PM -0500, Steve Wise wrote:
> > > > > > When transmitter and receiver is enabled to do so, as I
> > > > > > described in
> > > > > overview section of Documentation, it helps
> > > > > > (a) to avoid retransmission - improves network utilization
> > > > > > (b) reduces latency due to timers not kicking in.
> > > > >
> > > > > Yes those benefits are clear. I see no reason why it shouldn't
> > > > > always be done is my point. Application shouldn't have to care
> > > > > and there is no need to make this an additional flag.
> > > >
> > > > The app cares when data from write 2 can be written at the target
> > > > before
> data
> > > > from write 1, especially if the writes target the same memory buffe=
rs.
> (At least
> > I
> > > > think this is the intent of exposing this to the app.)
> > > >
> > > > Note that the provider can always provide stronger ordering than
> > > > what the
> app
> > > > needs.
> > >
> > > My understanding is that IB or IW apps should never assume ingress
> > > write or read response data is _placed_ into local memory in the
> > > order it was transmitted from the peer.  The only guarantee is that
> > > the _indication_ of the arrived data preserve the sender's ordering.
> > > However, I'm thinking that there are applications out there that
> > > spin polling local memory that is the target of a write or read
> > > response and assume the last bit of that memory will get written
> > > last...
> >
> > That is with respect to the CPU, but IB requires strong ordering
> > between messages within the same QP, eg if I do
> >
> > RDMA WRITE addr=3D0 data=3D1
> > RDMA WRITE addr=3D0 data=3D2
> > RDMA WRITE addr=3D0 data=3D3
> > RDMA READ  addr=3D0
> >
> > I must always get 3, not something else.
>=20
> Correct, but the peer, ie the remote end that is the target of those writ=
es,
> can spin looking at local address 0 and it might see 1, 2, or 3.  Eventua=
lly it
> will see 3.  But there is no guarantee that it will see 1 before 2 or eve=
n see 1
> or 2
> at all depending on timing.
>=20
> But what I was getting at is this:  Say you tell your peer to RDMA WRITE
> 16KB into your local buffer.  And let us say the last bit of that 16KB da=
ta will
> be a 1, and that the current value of that bit location in the local buff=
er is 0.
> It is incorrect for the app to spin reading that bit until reads 1, and a=
ssume
> the data prior to that bit has been placed at that point.  At least with =
the
> iWARP spec, out of order placement is allowed.  So if the 16KB was broken
> into X iWARP DDP segments, the last segment could have been placed
> before the other segments.
> A correct application will require the peer to post a SEND after the WRIT=
E or
> WRITE_WITH_IMMEDIATE, and only know the data has been placed into the
> local buffer when it polls the recv completion for the SEND or
> WRITE_W_IMMD.  An iWARP RNIC _must_ guarantee in-order delivery of
> data (but not actual placement).  Am I making sense?
>=20
> I'm guessing no HCAs nor RNICs actually place data out of order.  cxgb*
> does not.  So applications _might_ be doing the spin technique I describe=
d.
> I recall a long time ago that MVAPICH2 did this.  Not sure if it still do=
es.
>=20
> >
> > It would be notable if this 'out of order' feature violated that
> > invariant, but many ULPs would probably still be OK.
> >
I certainly don't see a point in breaking the users who are polling on data=
, even though they should have followed optional requirement o9-20.
Also read responses can come out of orders, if such messages are polled eit=
her, it would also break, not just writes.
Refer table 79 for two read operations.

> > Frankly, Parav's original message doesn't seem to describe at all what
> > this is about, so maybe we should all wait until v2, and maybe more
> > people from Mellanox could contribute to sensibly describing it if
> > they want it in ibverbs.

I will add following more details to Documentation.
1. Mention about pcie relax ordering - Barts point
2. Include responder side table like Table 79 to crisply describe all cases=
 and ordering with respect to send and other messages
3. Also indicate that C9-28 is relaxed when ooo is enabled on a QP as a des=
cription to new responder side table.
This was offline comment that I received.
4. Provide examples that Steve and Jason highlighted, with multiple writes =
to same memory location.
5. Reiterate table 79, to make it clear that what doesn't change, or change=
s.
Let me know if you want to see any more details.

> >
> > Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
