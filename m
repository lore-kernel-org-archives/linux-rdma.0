From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/8] verbs: Annoate ibv_wc helpers with endian
Date: Wed, 19 Jul 2017 20:17:39 +0300
Message-ID: <20170719171739.GR3259@mtr-leonro.local>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713065057.GH1528@mtr-leonro.local>
 <20170719165351.GA25714@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719165351.GA25714-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 19, 2017 at 10:53:51AM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 13, 2017 at 09:50:57AM +0300, Leon Romanovsky wrote:
>
> > > +static inline uint32_t ibv_wc_read_invalidated_rkey(struct ibv_cq_ex *cq)
> > > +{
> > > +#ifdef __CHECKER__
> > > +	return (__attribute__((force)) uint32_t)cq->read_imm_data(cq);
> > > +#else
> > > +	return cq->read_imm_data(cq);
> > > +#endif
> > > +}
> >
> > I don't think that those __CHECKER__ ifdefs should be part of the code.
> > They are part of infrastructure to support development of library, but
> > are not required for the user of that library.
>
> I don't see a way to get rid of it here and keep the ABI the same.
>
> __CHECKER__ is safe to use because we already rely on it being defined
> sensibly when we include linux/types.h and use __be32 in the public
> header.
>
> If we try and drop it post-install or something then we are really
> just blocking downstream projects from also using sparse, I don't see
> the point in doing that...

I'm curious, how many of them know and care about sparse :)

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllvlDMACgkQ5GN7iDZy
WKfL4hAAtNd0On3thWuT0OBD/EmD8WAsZBWmlHgm9+cg5h7Kk/SkS3jlLjJQ0zkn
9tfK70jH0f+7kaSmPeDJE2N6zvKm2vXi7u3pjgrkMPf8MSSYjq+ghhgd2WnZJQ0j
oPOxH3ZyItNruiYnj+WyTq7qwwVVn9g3F4JE5mX2v80dWTbL2plQ7BtlqFleh7uZ
la3llCOoRNeatGBqr26mDr1/O+nPvd7n5+PA/uqRdS0PHxtxhPcMJU1SdCtwpTMf
qcQdZNIVt38OoSlhv12KvND7R9DfANodHFyTZ+3sgBIm7LwQs46eCRGwnZbPCt99
poxCRoEprxRRfduRzcYH9nKTCoMFlAo+naEu4Nw7OfUhUZXOnI1kiqZd0F7sj26L
RjJ4H+hoj74r4b1hfSUD4L14hq/sIjvWMng9aQH3g1HNUUoyMigJNo0HtvodrcBE
zJ+Cy0VIXroTaqE+47OBwneIHxRSfRC4eJq8QSJDuI+8IddkdyGUXd4JDrwrdD1s
G0N2nl3sVTwUjRbRv0UcFUws6DLI2IMwBsU4OHUF3+P9IrMQ5b+mpF3z1/KZA2nf
ZStKe8FK4fLOHngn7F3Ouo/cHR7+YWQsrofzjGjK4ya5w2AgdPVp4C3DAgccc5Lk
LQwUhxMUpUGcIbg76dk1a/xuFT6SVskXtbpp/GfbMkQIDzL+moM=
=BBkS
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
