From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 07/10] providers: Use the new common PCI
 matching infrastructure
Date: Mon, 25 Sep 2017 12:52:44 +0000
Message-ID: <BN3PR07MB257830D380228ABEDC67A3F4F87A0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <BN3PR07MB2578333789DA041401297EC0F8650@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20170924155845.GB14796@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924155845.GB14796-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Sun, Sep 24, 2017 at 01:29:09PM +0000, Amrani, Ram wrote:
> > >  static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev=
 *sysfs_dev)
> > >  {
> > >  	struct qelr_device *dev;
> > > @@ -269,7 +238,7 @@ static const struct verbs_device_ops qelr_dev_ops=
 =3D {
> > >  	.name =3D "qelr",
> >
> > Should this be the driver name or the library name?
> > The driver name is qedr and the library name is libqedr. It is usually =
abbreviated to qelr.
> > I reckon that this should be the driver name (otherwise auto-load will =
fail?!).
>=20
> I will fix all the names, it is confusing as all the other drivers use
> their lib name as prefix..
>=20
> The above string is only used for diagnostic prints.
>=20
> Jason

Thank you.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
