From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Thu, 2 Nov 2017 18:31:25 +0200
Message-ID: <20171102163125.GZ16127@mtr-leonro.local>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
 <20171101165625.GE1030@ziepe.ca>
 <20171102050942.GU16127@mtr-leonro.local>
 <20171102161222.GH18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3w1+XHTy8jVCESz1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102161222.GH18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3w1+XHTy8jVCESz1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 10:12:22AM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 07:09:42AM +0200, Leon Romanovsky wrote:
> > On Wed, Nov 01, 2017 at 10:56:25AM -0600, Jason Gunthorpe wrote:
> > > On Wed, Nov 01, 2017 at 11:11:42AM +0000, Alex Margolin wrote:
> > >
> > > >  struct verbs_context {
> > > >  	/*  "grows up" - new fields go here */
> > > > +	struct ib_mw * (*alloc_mw_ex)(struct ibv_mw_alloc_attr
> > > >  	*mw_alloc_attr);
> > >
> > > This patch is full of weird little mistakes like the above, wouldn't
> > > compile and doesn't really seem capture the proposed API.
> >
> > Those RFCs are intended to present concept and implementation direction.
> > It is a little bit over-expectation to have working code and clean UAPI
> > at this stage.
>
> Clear communication is important.
>
> If you have to send a code snippit to explain the idea then it had
> better 'work'. I'm not asking for an implementation, but certainly
> correct changes to verbs.h
>
> > > We are now asking for complete rdma-core patches before talking about
> > > merging new kernel uapi features. Please retry this RFC with the new
> > > requirement.
> >
> > There are steps in development process, and first step before rushing
> > into implementation details is to talk about concept. This is exactly
> > what Alex did.
>
> Mellanox already did the concept step internally, if you want external
> review you need to clearly communicate the idea, and I don't think
> these RFCs are detailed or clear enough.

Maybe yes and maybe no,
I didn't see anyone in this mailing list who asked more detailed
explanation for Alex's RFC back then. I'm sure that Alex would be
happy to explain it more, if something was unclear.

>
> Header file patch, man pages, documentation and an example are the
> logical next steps to vet a proposed verbs API in the public forum.

And I think that RFC should be much lighter than you wrote. Pseudo API,
motivation and examples.

>
> This is analogous to a standards body context, where the next step
> would be to draft standards language, eg 'man pages' and API signatures.
>
> Jason

--3w1+XHTy8jVCESz1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7SF0ACgkQ5GN7iDZy
WKeG2g//btwkd5vF6AB9uTnm/IOKR2QECIe5S4E5uebjvh21udRp6/XJ99gVwC5s
eGbEGsz5fMqGA58OFfQbUTKKb+Vf30aJVp9Z44mdK8sD9W5BJL0ul1EV9frGZhaO
cb08UeeasQ94GNQHO+iJQqiRG2GLHSQfxmSF/KZUVlhylaA0S/X2On8xPpeDbh50
Uv1oUyOWp8OWQ7dBX8mqFgcJfy+uAPePhO46WRbkmDGqho7neWzZssRjmuEGgtWB
5m7wM6I8qwlaaP7LBFipqpA8sfT2WnD/33aRg/FgV1zySl31o5WTAJyP4AqzPTfk
8PxLRnfgFREyUOlRiNZN4cbGRIOMvFKvQ1jSJi7QM8u/OfJHt0mxt+tRdFHkMjob
wgRKMgOQw3OO0MF3gH4wetFjNjEdum9qngbu6f2P+IQ/JvDhHJS1Mc9nWMTARdgZ
N8f3bwCZfGg2SWHwxFAmthf+pNiZdXR6nv/VSn++moDeM3AHRfFrJ45W+laiI8IL
CDqgOezUbz3rXhc9GpY4ca0nk3ietaHGu//lkfskvypqdYpGbiC6DfnNlopFnqtb
Sj14Fl4KLci5MdM1tqKVB0McY5vXDe4cR2s25LaZAd5vWRgP8MJdsjrqd9g1ZCLM
pK4qyq5Zpn1crUahxQpIQ6KLTN/tAhaiqJ/1Ill8O4iBde4mdMY=
=qz2I
-----END PGP SIGNATURE-----

--3w1+XHTy8jVCESz1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
