From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Thu, 2 Nov 2017 07:09:42 +0200
Message-ID: <20171102050942.GU16127@mtr-leonro.local>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
 <20171101165625.GE1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q32ofrQ8UfzBLMEG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171101165625.GE1030-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--q32ofrQ8UfzBLMEG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 01, 2017 at 10:56:25AM -0600, Jason Gunthorpe wrote:
> On Wed, Nov 01, 2017 at 11:11:42AM +0000, Alex Margolin wrote:
>
> >  struct verbs_context {
> >  	/*  "grows up" - new fields go here */
> > +	struct ib_mw * (*alloc_mw_ex)(struct ibv_mw_alloc_attr
> >  	*mw_alloc_attr);
>
> This patch is full of weird little mistakes like the above, wouldn't
> compile and doesn't really seem capture the proposed API.

Those RFCs are intended to present concept and implementation direction.
It is a little bit over-expectation to have working code and clean UAPI
at this stage.

>
> We are now asking for complete rdma-core patches before talking about
> merging new kernel uapi features. Please retry this RFC with the new
> requirement.

There are steps in development process, and first step before rushing
into implementation details is to talk about concept. This is exactly
what Alex did.

>
> This means a patch similar to the above, except functional, and all
> the man pages and documentation.

It already exists in this RFC, just in different format - inlined and
not in patch format.

>
> The text in the cover letter should go into either into a man page or
> a Documentation/ file.

At the implementation phase, yes.

>
> For very complex uapis like this, an simple example usage is also
> going to help.

Agree.

>
> Jason

--q32ofrQ8UfzBLMEG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln6qJYACgkQ5GN7iDZy
WKe3hRAAuDDzBhm2uraCHFyDbqwjAsi85hPwhErYLF1rPlNxTQKhTYqJoQqbK0UV
XM7j6MdRhAsljaTPXzUYVVzeeSEMx8s15lTS2riJXFWVmwkpZ7H841F/qln0K+kP
rXQPynnbOeaS/yY5h3zAdLKr8QVRBXB5U1DAQ1KL4xsk2OgxDat9RkEEJye5acTv
yqza1qGVKaOeuxUMFNcGa2J+xmPGl0NWhoiCsZBCz8iWJNqUqaLtsZ2LAFmfHDw9
SgA7tTa+PCDiT6cZOyLHtMENJV1JLrxI3hEfRx+yaIwk/EB1cWqd8vZLjkf1zkjI
sy4qAlHxpfuqHci9XnoFGxP50SW9KQr2XXXA1h81AdDF6fo21ZeatFfjxFHQH3xz
lXeBLt6QtBmnFeQK1E2qVmkVL0xcTK1KPTWmG1Ad4bSz2VIOrg3NgrVj4sq2vHZC
yBVoBlqLiYGOaeZK4Eer9y7s215oMo4Ne5lllFOtD6T2GHONPxzDBTfuxTMh1HeV
vSmiWRJqvy0CScxQwYiGoOpwpnC5xaOmjalk+TTtJx/ddpI/jEBWM975xP/vtDtE
k2sDVMDKnfFgYSMjxsW+BzYJmBy/O7vHQHjtU9R5YsJWZ3pGGe+PIw657qdNsvMw
e/zQPbR5mAX3zUARLQlQk0Ot0wP4MpdAQbyUM9w02ehWItskDuI=
=ggah
-----END PGP SIGNATURE-----

--q32ofrQ8UfzBLMEG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
