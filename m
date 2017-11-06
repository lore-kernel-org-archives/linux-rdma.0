From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: Perftest fails when declaring support for MW_TYPE_2A
Date: Mon, 6 Nov 2017 18:27:11 +0000
Message-ID: <CY1PR0701MB201242460E94C26B04E4ADBB88500@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <CY1PR0701MB2012478CF41D9E2292887ABC885F0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171101164527.GC1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101164527.GC1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgg-uk2M96/98Pc@public.gmane.org]
> Sent: Wednesday, November 01, 2017 6:45 PM
> To: Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Cc: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Gil Rockah
> <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; lunnys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>;
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: Re: Perftest fails when declaring support for MW_TYPE_2A
>=20
> On Wed, Nov 01, 2017 at 03:35:54PM +0000, Kalderon, Michal wrote:
> > Hi Mellanox/ Accelio,
> >
> > There is a very old commit in perftest 96050b8b that assumes bit 23 in
> > device cap flags means there is driver support for contiguous buffer
> > allocation of user data
>=20
> Wow.
>=20
> This is
>=20
> https://github.com/linux-
> rdma/perftest/blob/master/src/perftest_resources.c#L272
>=20
> And it is totally unacceptable for upstream'ed open source code to have c=
rap
> like this.
>=20
> Delete it.
>=20
> Jason
Zohar,=20

Can you comment? Would you like me to provide a patch ? or would you rather=
?=20
Thanks,
Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
