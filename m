From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Sat, 11 Nov 2017 10:09:43 +0200
Message-ID: <20171111080943.GT18825@mtr-leonro.local>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
 <20171030152815.GA16127@mtr-leonro.local>
 <1510341329.3735.19.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mQQrPwpUFXnyQ/Ik"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510341329.3735.19.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mQQrPwpUFXnyQ/Ik
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 02:15:29PM -0500, Doug Ledford wrote:
> On Mon, 2017-10-30 at 17:28 +0200, Leon Romanovsky wrote:
> > On Mon, Oct 30, 2017 at 08:48:07AM -0600, Jason Gunthorpe wrote:
> > > On Sun, Oct 29, 2017 at 08:28:08PM +0200, Leon Romanovsky wrote:
> > >
> > > > > > +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> > > > > > +			   struct ib_device *ib_dev,
> > > > > > +			   struct ib_udata *ucore,
> > > > > > +			   struct ib_udata *uhw)
> > > > >
> > > > > Is this really a good idea?
> > > > >
> > > > > Why not ib_uverbs_set_cq_moderation ?
> > > >
> > > > It follows already existed ib_modify_cq(), see commit 2dd571622787
> > > > ("IB/core: Add support for modify CQ")
> > >
> > > And that function should have been called set_cq_moderation:
> > >
> > > + * ib_modify_cq - Modifies moderation params of the CQ
> > > + * @cq: The CQ to modify.
> > > + * @cq_count: number of CQEs that will trigger an event
> > > + * @cq_period: max period of time in usec before triggering an event
> > > + *
> > > + */
> > > +int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
> >
> > I see it differently, this is extendable version of modify_cq, which is
> > going to benefit all other users who will decide to extend it.
>
> If it's the extendable version, then it should have just passed the attr
> struct (or equivalent), it shouldn't have spelled out the moderation
> parameters in the function signature.  So, either we need to change the
> signature of ib_modify_cq to a generic, extendable signature, or we need
> to change the name as Jason points out so we match name and parameter
> signature in the same spirit.
>
> Also, as you point out, need to update the log message to not use
> cookie.

I'll fix commit log, rebase and resubmit, but it is not clear to me the
benefits of changing kernel version of modify_cq and all their users
to extended version. I think that we better convert them once they
actually will require it.

Thanks

--mQQrPwpUFXnyQ/Ik
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloGsEcACgkQ5GN7iDZy
WKdCIQ//XwDNOcGBZ22ZyFkSF9a+53uOWhrPuCi5OgHnHAYFYjgjwknmdMFz+WQT
igsq9EaL4tUBUpWTwIrOZQRwm0WlvB5UtSw/a/I8kdhOBFF+SBklVqMBjkAXUbCA
MbHzmoiIEzPZgtLy/qYlqqH3MUHkV85To8Hc4faysB7JHH6jmwnmxALkycAiOPsF
vfIZbisaOQEP93nlK01WamA8UysGDZweLTa43DViCFPguzXXs6qiYS8FH8hK1xDb
Z23s3j1v4LVp+qadVAroIbWH+PFo3Tg3lbE598IZhj9hCzwe8u9Xi9fvfWiFTB3l
mUDTBsQCsvm7U2daP2L9kcgDGBltSBUxKxCjYOv1ru2QAf0AEGDccBagWpHhvG82
f5MR2/mHHJfUHqpG3WmlUSiHy3U2jvXoC6X9fh4Os6SWcnM/qzIsHeI2+9CKZDTp
nOOVRfjmRARp52ZeubFHTj/b6gsS8thz0sVYqutUjCwxBgmG53B7IR37sHiQ5xrQ
8tJZjuMFEwM5YQxtQa5ldmXwlE6AXQdF3auxHAZcg1V8TkxUILLiSIubVKbAP/tl
6WLXN7lNbyqQ2L2bEDU7Dl3HjDA6nM5/TgZalhEmzcneJWxn3gZi7/PBpoyYguPz
xQfFd51gYAGRb1SqdJa5eWK6JZ5sULrCiu8wBskc/G9PSBsqafw=
=uMpM
-----END PGP SIGNATURE-----

--mQQrPwpUFXnyQ/Ik--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
