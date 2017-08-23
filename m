From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-next v1 00/11] Hardware tag matching support
Date: Wed, 23 Aug 2017 08:06:03 +0300
Message-ID: <20170823050603.GL1724@mtr-leonro.local>
References: <20170815085912.10181-1-leon@kernel.org>
 <1503434809.78641.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ESr4fftwSwE2Rzwi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503434809.78641.14.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ESr4fftwSwE2Rzwi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 04:46:49PM -0400, Doug Ledford wrote:
> On Tue, 2017-08-15 at 11:59 +0300, Leon Romanovsky wrote:
> > This patch series adds to Mellanox ConnectX HCA driver support of
> > tag matching. It introduces new hardware object eXtended shared
> > Receive
> > Queue (XRQ), which follows SRQ semantics with addition of extended
> > receive buffers topologies and offloads.
> >
> > This series adds tag matching topology and rendezvouz offload.
> >
> > Changelog:
> > v0->v1:
> >  * Rebased version, no change
> > RFC->v0:
> >  * Followed after RFC posted on the ML and OFVWG discussions
> >  * Implements agreed verbs interface
> >  * Rebased on top of latest version
> >  * Adding feature description under Documentaion/infiniband
> >  * In struct ib_srq_init_attr moved CQ outside XRC inner struct.
> >  * Added max size of the information passed after the RNDV header
> >  * Added hca_sq_owner HW flag for RNDV QPs
> >
> > Thanks
> >
> > ----------------------------------------------------------------
> >
> > Doug,
> >
> > Please note that I merged our shared pull request from the mailing
> > list before sending this series. Please let me know if something
> > needs
> > to be redone.
>
> Hi Leon,
>
> Does this patchset require the shared pull request?

I did some merge/rebase testing (worth recheck), but at the end, the series
which were dependant on this shared code didn't make into this cycle.

I did merge tests between Saeed's queue and my queue by dropping shared
code and merge of rdma-rc too.

Thanks

--ESr4fftwSwE2Rzwi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdDTsACgkQ5GN7iDZy
WKclHg/9Fnfqfu9y7qE1QIZ8i9RmzK3ztAG60qNFNRakCb6qxHLwgbKVbzNrdvnf
lgcWt1HzO4gNLtQZvi6p0bwep3cnS7DVYmaBEoul5IqPSKoyqe6SuqfsG94yukXz
kVDFMqBwlyzR6eevjrt0Xh4jR9TXH7L/2u6zxhnoQSDo0qx+hT4jbeqpar2Ysu78
Rfd7nquj1v+gD9fy6efCaVvMXpN+XFdlAh5hMP1ljcex6dqGlxY0/0RBoU/TyPkk
24Qr3Z+AcM6DR+O2GpJ90VwmTeCDJZjmjSeWf2CDkQUfR4yCo0tiFhlCZc5fRaik
JwCE/AugR/nHbV8TH9I3+9cEKkrOvq8sZm8jB38NNI7KhWxFHIkRY8Jo4F8elu+I
o0yPGlW7+0SiRmVk7YlZNLYOTBCZhW6CsrnzUirP/ofaSuDaWD7cc5WVRLz+tSp1
7sMmCT2SDXCy59qdC0c8fsFuKzcdPsF/kYPMcjjdrb1Ck3fr9vpfCIx70FgsNct0
xBKnpl8YeZLyBTBA7LqnpAxiuYnQj/dMszvBAqL56lCPN4ms1LFhVPN3HeO/JohA
z7pSEtZnbkrVXW/CfjMspY2N2oyoC5E+j5BeS3PIR8o0HWHXSQPU+HZ+sPtplsOV
p1x4sIZUIJyr0iEh70DPcGIY2215jldI4Lr8YAbjTDdg0MOGhWI=
=5Nz+
-----END PGP SIGNATURE-----

--ESr4fftwSwE2Rzwi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
