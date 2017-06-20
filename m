From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 1/2] RDMA/qedr: Notify user application if DPM is
 supported
Date: Tue, 20 Jun 2017 08:34:24 +0000
Message-ID: <BN3PR07MB2578EC6DD9C3DF920388418AF8C50@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
 <1497790871-23945-2-git-send-email-Ram.Amrani@cavium.com>
 <20170619155553.GB10188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170619155553.GB10188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Um, how is uapi compatibility achieved here? I don't see any size
> tests related to qedr_alloc_ucontext_resp:
>=20
> struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
>                                         struct ib_udata *udata)
> {
>         struct qedr_alloc_ucontext_resp uresp;
>         rc =3D ib_copy_to_udata(udata, &uresp, sizeof(uresp));
>=20
> Seems bad.
>=20
> Same with the other patch.
>=20
> Jason

It does seem bad. Did you had in mind something like this:
         struct qedr_alloc_ucontext_resp uresp;
         size_t copy_size =3D min_t(size_t, sizeof(uresp), udata->outlen);

         rc =3D ib_copy_to_udata(udata, &uresp, copy_size);

If so, it makes sense to me to protect everybody's transactions.
I.e.:
	static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size=
_t len)
	{
		size_t copy_size =3D min_t(size_t, sizeof(uresp), udata->outlen);
		return copy_to_user(udata->outbuf, src, copy_size) ? -EFAULT : 0;
	}

Likewise, a protection can be added for ib_copy_from_udata() too.

Let me know if I'm missing something. If not, I'll send a patch.

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
