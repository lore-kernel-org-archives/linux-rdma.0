From: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user verbs
Date: Wed, 28 Jun 2017 10:23:06 +0000
Message-ID: <CY1PR0701MB1337A8E7B1E40CC4C1EC230A90DD0@CY1PR0701MB1337.namprd07.prod.outlook.com>
References: <1498572282-22370-1-git-send-email-Ram.Amrani@cavium.com>
 <1498572282-22370-2-git-send-email-Ram.Amrani@cavium.com>
 <20170628095422.GA1248@mtr-leonro.local>
 <BN3PR07MB25788193EFA21CEB5C430201F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170628101124.GD1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170628101124.GD1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Wednesday, June 28, 2017 1:11 PM
> To: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel
> <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: Re: [PATCH rdma v1 1/1] IB/core: Fix input len in multiple user =
verbs
>=20
> On Wed, Jun 28, 2017 at 10:02:45AM +0000, Amrani, Ram wrote:
> > > > Most user verbs pass user data to the kernel with the inclusion of =
the
> > > > ib_uverbs_cmd_hdr structure. This is problematic because the vendor=
 has
> > > > no ideas if the verb was called by a legacy verb or an extended ver=
b.
> > >
> > > Why vendor should know about it? It has midlayer (ib/core) between hi=
m
> > > and user to handle it.
> > >
> >
> > Knowing the inlen can be used to determine if the library is newer than
> > the kernel and what features it supports or not.
>=20
> It is not interesting case, because we are not breaking UAPI, only
> extending. It ensures that kernel will fill as much as possible and will
> always have success in it. After that it is library responsibility to
> understand if everything was filled.
>=20
> Thanks

In our case, kernel driver needs to know whether library supports a certain
feature (doorbell overflow recovery). It doesn't care if it was an extended
verb or not, but it cares whether the lib is sufficiently new to have provi=
ded
the required information. If the library is sufficiently new (supports) the=
n
kernel will register the library's doorbell address with the overflow recov=
ery
mechanism, and perform recovery if required, otherwise it would not (as the
library is not supplying the necessary information for recovery to take pla=
ce).
This is not something the library needs to know, but the kernel driver. Hav=
ing
correct input len is required for successfully avoiding breaking the UAPI.

Ariel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
