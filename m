From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Fri, 24 Jul 2015 17:13:38 -0500
Message-ID: <00f001d0c65d$fdf27d50$f9d777f0$@opengridcomputing.com>
References: <20150722175755.GH26909@obsidianresearch.com> <55B0C18B.4080901@dev.mellanox.co.il> <20150723163124.GD25174@obsidianresearch.com> <55B11D84.102@dev.mellanox.co.il> <20150723185334.GB31346@obsidianresearch.com> <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com> <20150724162657.GA21473@obsidianresearch.com> <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com> <20150724191003.GA26225@obsidianresearch.com> <A1A0BF6E-992A-4B34-8D24-EA8AA8D6983B@oracle.com> <20150724202445.GA28033@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724202445.GA28033-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On Behalf Of Jason Gunthorpe
> Sent: Friday, July 24, 2015 3:25 PM
> To: Chuck Lever
> Cc: Sagi Grimberg; Christoph Hellwig; linux-rdma; Liran Liss; Oren Du=
er
> Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory regist=
ration API
>=20
> On Fri, Jul 24, 2015 at 03:59:06PM -0400, Chuck Lever wrote:
> > And RPC-over-RDMA version 1 does not have any way to signal that
> > the server has invalidated the MRs. Such signaling would be a
> > pre-requisite to allow the Linux NFS/RDMA client to interoperate
> > with non-Linux NFS/RDMA servers that do not have such support.
>=20
> You can implement client support immediately, nothing special is
> required.
>=20
> When processing a SEND WC check ex.invalidate_rkey and
> IB_WC_WITH_INVALIDATE. If that rkey matches the MR associated with
> that RPC slot then skip the invalidate.
>=20
> No protocol negotiation is required at that point.
>=20
> I am unclear what happens sever side if the server starts issuing
> SEND_WITH_INVALIDATE to a client that doesn't expect it. The net
> result is a MR would be invalidated twice. I don't know if this is OK
> or not.
>=20

It is ok to invalidate an already-invalid MR.

> If it is OK, then the server can probably just start using it as
> well without negotiation.
>=20
> Otherwise the client has to signal the server it supports it once at
> connection setup.
>=20
> > For FRWR, you could post LINV from the receive completion upcall
> > handler, and handle the rest of the invalidation from the send
> > completion upcall, then poke the RPC reply handler.
>=20
> Yes
>=20
> > But this wouldn=E2=80=99t work at all for FMR, whose unmap verb is
> > synchronous, would it?
>=20
> It could run the FMR unmap in a thread/workqueue/tasklet and then
> complete the RPC side from that context. Same basic idea, using your
> taslket not the driver's sendq context.
>=20
> > I=E2=80=99m not sure we=E2=80=99d buy more than a few microseconds =
here, and
> > the receive upcall is single-threaded.
>=20
> Not sure on how that matches your performance goals, just remarking
> that lauching the invalidate in the recv upcall and completing
> processing from the sendq upcall is the very best performance you can
> expect from this API.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
