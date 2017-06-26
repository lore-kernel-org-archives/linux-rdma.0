From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 1/5] RDMA/netlink: Remove netlink clients
 infrastructure
Date: Mon, 26 Jun 2017 21:13:24 +0300
Message-ID: <20170626181324.GE1248@mtr-leonro.local>
References: <20170613085927.2908-1-leon@kernel.org>
 <20170613085927.2908-2-leon@kernel.org>
 <20170626175505.GA2904@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3rxX7Uty8SZY8iU1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626175505.GA2904-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3rxX7Uty8SZY8iU1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2017 at 12:55:05PM -0500, Chien Tin Tung wrote:
> On Tue, Jun 13, 2017 at 03:59:23AM -0500, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > RDMA netlink has complicated infrastructure to add and remove netlink
> > clients to NETLINK_RDMA family. This complicates the code and not in
> > use because not many clients are available (3 clients) and most of them
> > (2 clients) are statically compiled together with netlink.c.
> >
> > The following patch refactors RDMA netlink and opens door for the future
> > patches which will be able to get rid of a lot of dead iwcm* code.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c     |   6 +-
> >  drivers/infiniband/core/device.c  |  41 +++------
> >  drivers/infiniband/core/iwcm.c    |  10 +--
> >  drivers/infiniband/core/netlink.c | 185 ++++++++++++++++++------------=
--------
> >  include/rdma/rdma_netlink.h       |  17 ++--
> >  5 files changed, 110 insertions(+), 149 deletions(-)
>
> > diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> > index 585266144329..6735dcf5d2a3 100644
> > --- a/include/rdma/rdma_netlink.h
> > +++ b/include/rdma/rdma_netlink.h
> > @@ -10,27 +10,22 @@ struct ibnl_client_cbs {
> >         struct module *module;
> >  };
> >
> > -int ibnl_init(void);
> > -void ibnl_cleanup(void);
> > +int rdma_nl_init(void);
> > +void rdma_nl_exit(void);
>
> This hunk is in direct conflict with 233c1955 which you removed
> ibnl_init and ibnl_cleanup.  Are you putting back the init and
> exit or do you want to leave them out?

We have different git hashes and I don't know about which commit you are
referring.

This commit simply renames exit/init functions in general header file.
The init/exit is still needed, because it is called from device.c.

The git log doesn't show me anything suspicious too.
=E2=9E=9C  linux-rdma git:(topic/rdma-netlink-v1) git log -p include/rdma/r=
dma_netlink.h

Thanks

>
> Chien

--3rxX7Uty8SZY8iU1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllRTsQACgkQ5GN7iDZy
WKdzFg//eTPYzk//uBTCVmp71d559UtszwFkTsTg7ujcDodpFPOvMzR9rxdNGXWF
s74LLgbyLnkCwOAofKgFuLmr8S5qpT9wnHBHQw54nA/XWEzbeIvZUPVoOsclMKLi
6bXHogBl6FuvTRaBEs9MeNlZpsNMIHQyl1RF3+uiS0ZeuJui+H7NMxpGoPICE8Yn
20z6uC2Ad6Bw9ENLx8iHKhfmnoX4wYmr1ToPa6hl0qZKdN1hTDA922qBftjY/LNt
8Olb2foBYazNYML95+VcobiTPHgnpzs+UmRXPE043JGje0ngfkE7FqOFApV/rPF8
YgdYF/KkQMn492Wzu1QW5dcFJ6s/HhldMKLXNqUbvdAEwNUcD8Wp/oxEinGXz1y7
pmBHymi9pjADaME3FwIDKDpIwO6vJggFpIpVAty8J3wLKXvG6HRSFBqnCEL7VRnE
Jkm/tIVpDwPeDHnHlh4Ww3JPtTjg/6t9V1Hk65j53jFhgj1QNjsYym+usq07dl97
/JGFBFBawa3the0Q9qCtc7XgFXtsLHcdo3Ywv2ZW/s13fJkUBKdr28JnRDdbBM0E
2F7b5tOdE4YoSG8ItpmIeHFK/KYH3q4Ju7UbSPa6QnTnUlk4Q/CbMTMYyRlZNzq+
r7ctb9gwuhCO6NmiJu7w8AGHa2FpXnonbfa5LVryt7ktfxSY3MI=
=z7qx
-----END PGP SIGNATURE-----

--3rxX7Uty8SZY8iU1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
