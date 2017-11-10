From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Fri, 10 Nov 2017 14:15:29 -0500
Message-ID: <1510341329.3735.19.camel@redhat.com>
References: <20171029135140.32649-1-leon@kernel.org>
         <20171029135140.32649-2-leon@kernel.org> <20171029174345.GC4488@ziepe.ca>
         <20171029182808.GN16127@mtr-leonro.local> <20171030144807.GA12392@ziepe.ca>
         <20171030152815.GA16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jcQ3ZtEJ3nk+TG+zavrj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030152815.GA16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jcQ3ZtEJ3nk+TG+zavrj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-10-30 at 17:28 +0200, Leon Romanovsky wrote:
> On Mon, Oct 30, 2017 at 08:48:07AM -0600, Jason Gunthorpe wrote:
> > On Sun, Oct 29, 2017 at 08:28:08PM +0200, Leon Romanovsky wrote:
> >=20
> > > > > +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> > > > > +			   struct ib_device *ib_dev,
> > > > > +			   struct ib_udata *ucore,
> > > > > +			   struct ib_udata *uhw)
> > > >=20
> > > > Is this really a good idea?
> > > >=20
> > > > Why not ib_uverbs_set_cq_moderation ?
> > >=20
> > > It follows already existed ib_modify_cq(), see commit 2dd571622787
> > > ("IB/core: Add support for modify CQ")
> >=20
> > And that function should have been called set_cq_moderation:
> >=20
> > + * ib_modify_cq - Modifies moderation params of the CQ
> > + * @cq: The CQ to modify.
> > + * @cq_count: number of CQEs that will trigger an event
> > + * @cq_period: max period of time in usec before triggering an event
> > + *
> > + */
> > +int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
>=20
> I see it differently, this is extendable version of modify_cq, which is
> going to benefit all other users who will decide to extend it.

If it's the extendable version, then it should have just passed the attr
struct (or equivalent), it shouldn't have spelled out the moderation
parameters in the function signature.  So, either we need to change the
signature of ib_modify_cq to a generic, extendable signature, or we need
to change the name as Jason points out so we match name and parameter
signature in the same spirit.

Also, as you point out, need to update the log message to not use
cookie.

Let's please make this consistent before merging.  BTW, because so much
of the rest of the API uses things like modify_qp with an attr struct
and a single entry point, I'm leaning towards following that here for
the sake of API consistency.  Although I can see Jason's point about
having simpler entry points for the API, I don't think it buys us
anything in the RDMA space because we already have to be aware of and
use the monolithic single entry point API style.  I'm more inclined to
think a single API style is better than mixed API styles, just like
mixed coding styles is bad.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-jcQ3ZtEJ3nk+TG+zavrj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF+tEACgkQuCajMw5X
L91xNw/8CZ3h407USXZnxnSXDLblKS+1fsyYhTrszzV4UvudmNoiHBGPsD7FYFPA
dkuaUwruZbKmWpCHvg7FwD8oyVnECYmoNkU6D9npBERE/yIKzdP+q7014ihYI2Ji
LvW2PEUBXcsVwuWxKWLzf9iAy5wjq2pSA5SRMPaRXjDbpbnQKBHoygXjYsMW4yuF
EtwViGRIbS3zMUElbery1PTTX9lgtpjwtqtkUK7uouoFH9yCCXKugzlK73/3Ef/+
nKsiwukdKLSQ1iTwKJHB3AVPPcLGERLjlw/EATqEeRzNNceM33nvH9SG97AbzKwn
7q1a4CBU13c10Ggwos4xV0dbu7ucSRvr5AMxGd2RDfD0QXDMvLXtNa+Fs0fgSzUN
4d0RzEsk6F1Ibt3R959k/qVo8cczBNZZZEEeLRkmC78teMkeJ8genzTpTrseu0Ok
lJBTKGtASUjrDmUwCDgkYYeYsK+EUoRnWzivq8H1qIIj83xy7szCrMEUo/RY0/bv
SfSSOipBLBf2o0ks2OGZmBhq1BsCN5NQHz3jkUh12DqfDsWLjXBWLsLyBkwQItny
odJpammDkVXZsV7Vz4/KIqwpwhVVH+8qgXvSZ9T2NGp6Z3cmMqvDgWsrDqaRHuyp
anmgbiQC6/Phlw5W2bQwy1ndMx3sP/+zubCSmqj2rozYGgXSxiU=
=W4ny
-----END PGP SIGNATURE-----

--=-jcQ3ZtEJ3nk+TG+zavrj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
