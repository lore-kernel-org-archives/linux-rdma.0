From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: How far back does rdma-core X supports the kernel Y?
Date: Thu, 2 Nov 2017 06:55:27 +0000
Message-ID: <BN3PR07MB25786FC9996B2749BF08A5FAF85C0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <287a10c2-15a7-0748-c59e-3f084e7538f4@dev.mellanox.co.il>
 <20171101180001.GH1030@ziepe.ca>
 <3424c3a1-22cb-7330-81d6-0e1bf45ab755@dev.mellanox.co.il>
 <20171101185319.GK1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101185319.GK1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> > >Okay, then it should be
> > >
> > >  if (attr_mask & ~(IB_QP_RATE_LIMIT - 1))
> > >

I'm OK with this

> I think Ram is explaining that the kernel rdma_cm provides the
> attr_mask to use with modify_qp, and that the 4.3 kernel sets the
> three now reserved bits. The expectation is that user space will flow
> those bits and values from the kernel rdma_cm interface back to
> uverbs.
>=20
> Userspace never looks at the attr_mask, and it does not matter that
> the values were never in verbs.h.
>=20
> rdma-core is expected to work on 4.3, so if 4.3 is using this kind of
> path, we cannot block it in userspace.
>=20
> At least, I think that is what Ram is saying.
>=20
> Jason

Exactly.
Using IB_QP_RATE_LIMIT instead of IB_QP_DEST_QPN solves this.

As I've said I can create a patch but it'll have to wait to e/o next week.
What are the other locations that you've seen similar errors?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
