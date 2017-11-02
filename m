From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: How far back does rdma-core X supports the kernel Y?
Date: Thu, 2 Nov 2017 07:01:58 +0000
Message-ID: <BN3PR07MB257829836974C1D0F1257387F85C0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <BN3PR07MB257867500E3A15914B2AD075F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101173324.GF1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101173324.GF1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We have tended to use reserved to mean dont use. Someone should
> inspect the git history before trying to use a reserved value..
>=20

When reserved are used in structures, usually for alignment, they are
freely taken when a new field needs adding.
Taking this logic to enums is bad.
I agree that in enums it does raise a brow and it is evident this should
be checked.
Still, I think it is a better practice to give a more meaningful name
and/or comment to differentiate. E.g.:

IB_QP_XXX_DONT_USE /* Kept for backward compatibility only */

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
