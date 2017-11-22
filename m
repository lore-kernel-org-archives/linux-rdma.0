From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: QPN re-use?  was RE: rstream application
Date: Wed, 22 Nov 2017 13:44:56 +0000
Message-ID: <CY1PR0701MB201272A9D57012EB34E9E08188200@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB1AC922@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1AC922-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Tuesday, November 21, 2017 6:27 PM
> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Jason Gunthorpe
> <jgg-uk2M96/98Pc@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Amrani, Ram
> <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Radzi, Amit <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: QPN re-use? was RE: rstream application
>=20
> > Rstream client connects to server, runs latency test, calls rs_close
> > and then connects Again before running the bandwidth test. The issue
> > occurs on the second connect (after latency and before bandwidth).
> > Server does the same. It seems the close state in some cases doesn't
> > complete Before the second connect request arrives.
> > Yes, the hardware re-uses QPNs once they are destroyed.
>=20
> If the issue is that the QP is in time wait, I'm not sure this is complet=
ely an
> application issue.  The QP being re-used could have been allocated by
> another application, with timewait being set to something large.  This
> wouldn't be an rstream issue, but something all applications would be
> required to handle.
>=20
> It sounds like there needs to be some sort of coordination of QPN re-use
> between the drivers and CM, especially if the driver wants to re-use QPNs=
 as
> LIFO.

Thanks, Sean. This makes sense. So are you suggesting and additional API be=
tween CM
And driver to notify when a QPN can be re-used ?=20
Just to emphasize though, the problem could still occur if on client side t=
he QPN is released
After timewait, but timewait didn't pass on server-side. (this is similar t=
o the case here,=20
The QPN re-use was on the client side, where the connection was no longer i=
n time-wait, but
Existed in the server side remote-qp tables ).=20

Thanks,
Michal

>=20
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
