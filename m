From: "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: QPN re-use?  was RE: rstream application
Date: Thu, 23 Nov 2017 12:18:18 +0000
Message-ID: <CY4PR07MB2968E656A083CA1F34FE6345EB210@CY4PR07MB2968.namprd07.prod.outlook.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB1AC922@ORSMSX109.amr.corp.intel.com>
 <CY1PR0701MB201272A9D57012EB34E9E08188200@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1AD065@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1AD065-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Thanks, Sean. This makes sense. So are you suggesting and additional
> > API between CM And driver to notify when a QPN can be re-used ?
>=20
> This was what I was suggesting, but the point you make below may mean tha=
t it
> won't help that much.  :/

I think it will still help. In the general case (and this restream specific=
 case) the client destroys the QP locally, destroys the cm id (which sends =
a disconnect request) and creates a new one which sends the new connect req=
uest (with the same local QPN).
If there was an interface that the CM will tell the driver that the QPN can=
 be used only when moving to idle (in a successful case after the disconnec=
t response arrives) we won't have a problem since the client will get a dif=
ferent QPN.
There still might be a case where for example the disconnect request will b=
e dropped (and moving to timewait and idle without retrying the disconnect)=
 we might still get a reject from the server since he didn't see the discon=
nect but that is rare and will have to be addressed in the application laye=
r.

>=20
> > Just to emphasize though, the problem could still occur if on client
> > side the QPN is released After timewait, but timewait didn't pass on
> > server-side. (this is similar to the case here, The QPN re-use was
> > on the client side, where the connection was no longer in time-wait,
> > but Existed in the server side remote-qp tables ).
>=20
> IMO, the best solution is for drivers to cycle through qpn space before
> attempting to re-use any.  Otherwise, this problem is more likely to occu=
r.
>=20
> I can't easily think of a great alternative.

We can do that but that but it will not always help either (e.g. there is o=
nly one QPN available).

>=20
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
