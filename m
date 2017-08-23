From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Update device query
 parameters and port caps
Date: Wed, 23 Aug 2017 21:53:26 +0300
Message-ID: <20170823185326.GX1724@mtr-leonro.local>
References: <cover.1503468979.git.aditr@vmware.com>
 <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr@vmware.com>
 <20170823090920.GN1724@mtr-leonro.local>
 <34d28cff-79a5-b604-fc1e-8d083f53225d@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n1q7a47AT2c4WQJe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <34d28cff-79a5-b604-fc1e-8d083f53225d-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--n1q7a47AT2c4WQJe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 23, 2017 at 11:08:01AM -0700, Adit Ranadive wrote:
> On Wed, Aug 23, 2017 at 12:09:20AM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 22, 2017 at 11:19:01PM -0700, Adit Ranadive wrote:
> > > Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len
> > > and the IP_BASED_GIDS port cap flag.
> > >
> > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 9 ++++++++-
> > >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   | 9 +++++++++
> > >  2 files changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > > index 3a308ff..df0a6b5 100644
> > > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
> > > @@ -149,6 +149,13 @@
> > >  	((_dev->dsr->caps.mode == PVRDMA_DEVICE_MODE_ROCE) &&		\
> > >  	 (PVRDMA_IS_VERSION17(_dev) || PVRDMA_IS_VERSION18(_dev)))
> > >
> > > +/*
> > > + * Get capability values based on device version.
> > > + */
> > > +
> > > +#define PVRDMA_GET_CAP(_dev, _old_val, _val) \
> > > +	((PVRDMA_IS_VERSION18(_dev)) ? _val : _old_val)
> > > +
> >
> > The current macro implementation will require you to go and update all
> > the places once you will move to new version. In simple case, everything
> > is supported and you will change your check of PVRDMA_IS_VERSION18 to
> > something PVRDMA_IS_VERSIONXXX and it will work.
>
> Thanks for taking a look. That's the intention I wrote the macro with so it
> should pick up the value based on the current device version. If you are
> concerned that we will change device caps without changing the PVRDMA
> version, that's something we avoid for compatibility reasons.

I have hard time to understand how will you extend this macro once new
feature is introduced.

Let's for an example conduct the following experiment:
1. IB/core gets new exciting ROCE_V3
2. You are adding support to it and increasing the version to be VERSION19.
3. You now have code for ROCE_V2 and ROCE_V3.

So the question is: how will your VRDMA_GET_CAP() look in such case?
RECE_V2 is supported in VERSION18 and above, while ROCE_V3 is supported
in VERSION19 only.

And if we add more than one new feature, how will it look?

Thanks


>
> > In more complex case, when one of the features is supported in one version
> > but isn't supported in another you will need to add "if(specific_feature)" magic
> > into it.
>
> This will not happen based on how our version model currently works.

--n1q7a47AT2c4WQJe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdzyYACgkQ5GN7iDZy
WKcEnRAAzI//q5+JvdDathVIBj3arGS+Nu9shBjW3AXiB/s2a7vDAbEfAZ65gbSU
HT39oH/AZNi0ol+WlX8Z4UaGN1mY8+oGJQKrRUuZvjC/iWevtZj91v54DvjnXf/g
50EjJAzzCmMrDRaxI8Gi7/DCKeirX1ZBkkjb7HrSw3Ly5R3wmR44WDRYq13qvwpF
6PU/0MTXzeNjf6/1aIVJA9Eq24OtQY6C5+tAl9rB2enFOQdZef8Wp7pIb/ZYeY+U
9mftMxaBgEJ0UkuAS5O7WiLbi5/d1oQAvDEPnqI+c20mu+hhgYZja60i8Lvc3Sci
48F8S+Gn2KZ1AIpDGpUNAx/I1rfzJpuk3q69GGeuHWf1iQSZub93j9ybgD0q+bF8
VWlGiAeNLZyZkRum//P6tM6rbdpJDoaKMY0Ob0gC8GdHNfxzdv0MenOn4bAjka6m
cjSCgmCPn7nBzqsStz4nCnj0z/F8X9xjU8vgvklVhdjo81rBQ3rdUWjGPKpBe6ps
h9qumxaYwtt8LJSU1NAdlU7TlldzsSbtN20iwAdJGqIaaPYXen5tI9ZrMcV2thDN
W2W0ztI0yHJ5vYQlTBdRyNix4GZg3IGrY31z+pe2W4PiBDdqJgPUp5H7SV+jGiw6
hh8ZKxL74a8indJSn25lsjL86Xg4204WBwgOYdE3WSFw/KVR15s=
=jFYV
-----END PGP SIGNATURE-----

--n1q7a47AT2c4WQJe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
