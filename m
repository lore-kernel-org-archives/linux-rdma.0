From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 17:27:22 +0000
Message-ID: <BN3PR07MB257867500E3A15914B2AD075F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101163915.GB1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> WTF is this?
>=20
> Based on the comment it should be:
>=20
>          if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))
>=20
> To match the comment. And other places have the same mistake.
>=20
> This was broken recently by 3ca7a1031486b588a7fbe0d262f8f89738215b58
>=20
> Bodong??
>=20

Oh yeah, that too.
But my point is that even after I've fixed this (I haven't checked other lo=
cations),
then backwardly compatibility is foo because the above check fails.
If you take a look at that kernel you can see it sets IB_QP_SMAC in attr_ma=
sk
and returns it to the user space. When modify QP is invoked it fails on tha=
t
check (IB_QP_DEST_QPN < IB_QP_SMAC).
This happens perhaps for the other bits. Haven't checked it yet.

For compatibility, we should pass the bits as they are (i.e. not fail the c=
heck), and ignore them
in later kernels.
Also, currently they are marked in ib_verbs.h as reserved. This is misleadi=
ng as
it hints they are for future use. We should mark them as don't ever use.

If that sounds right to you, I can fix it. But it'll have wait till end of =
next week because
I'm not in the office.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
