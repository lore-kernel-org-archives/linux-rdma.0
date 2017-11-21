From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: rstream application
Date: Tue, 21 Nov 2017 08:59:37 +0000
Message-ID: <CY1PR0701MB201250D3B52CD57F5DB62BA588230@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <CY1PR0701MB20123BEF45FFB6AF762D4468882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <CY1PR0701MB2012D019C936BFC566F41DD4882E0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1AC288@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1AC288-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Monday, November 20, 2017 8:59 PM
> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Jason Gunthorpe
> <jgg-uk2M96/98Pc@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Amrani, Ram
> <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Radzi, Amit <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: RE: rstream application
>=20
> > We've been debugging an issue with the rstream application, would be
> > glad to get your help.
> > This application is part of the OFA logo program and therefore we've
> > been debugging it.
> > Intermittently we get an error: Connection refused (stale connection )
> > on the second connect in the test.
> > (rstream -S all -T a )
> > It looks like in some cases the server side gets a new connection
> > request before destroying the cm-id, Leaving the remote id and remote
> > qp in the remote_id_table and remote_qp_table
>=20
> Can you provide more details on when the problem occurs?  Is the client
> attempting to connect to a server that is not yet active, or trying to co=
nnect
> to a server that already accepted a connection?  Do you know if the
> hardware re-uses QPNs?
> --
Thanks Sean,=20
Rstream client connects to server, runs latency test, calls rs_close and th=
en connects
Again before running the bandwidth test. The issue occurs on the second con=
nect
(after latency and before bandwidth).
Server does the same. It seems the close state in some cases doesn't comple=
te
Before the second connect request arrives.
Yes, the hardware re-uses QPNs once they are destroyed.=20

> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
