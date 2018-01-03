From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/hfi1,core: Driver updates for 12/22/2017
Date: Wed, 3 Jan 2018 17:25:29 +0200
Message-ID: <20180103152529.GS10145@mtr-leonro.local>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
 <20171222233738.GB17198@ziepe.ca>
 <20171225104615.GH2942@mtr-leonro.local>
 <2517cf89-211d-0f40-17e5-eae670ff429e@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CUrluEZVXmx7ezWQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2517cf89-211d-0f40-17e5-eae670ff429e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CUrluEZVXmx7ezWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 10:13:19AM -0500, Dennis Dalessandro wrote:
> On 12/25/2017 5:46 AM, Leon Romanovsky wrote:
> > On Fri, Dec 22, 2017 at 04:37:38PM -0700, Jason Gunthorpe wrote:
> > > On Fri, Dec 22, 2017 at 08:45:35AM -0800, Dennis Dalessandro wrote:
> > > > Don Hiatt (2):
> > > >        IB/core: Use rdma_cap_opa_mad to check for OPA
> > > >        IB/hfi1: Change slid arg in ingress_pkey_table_fail to 32bit
> > >
> > > For now I took these two to for-next the other should sit on the list
> > > for a bit.
> >
> > Just to emphasize how easy to add new field in nldev:
>
> Agree. I'm going to look into that when I can. For now, the patch is minor
> and adds something important for debugging. I've made folks aware internally
> this is the last patch like this, so I'd like to see this go in for the
> current cycle and then we'll get to work on the new implementation. Does
> that sound reasonable?

It will be great.

Thanks

>
> -Denny

--CUrluEZVXmx7ezWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpM9ekACgkQ5GN7iDZy
WKeUgg//c3Rka4IW1udz+4VDz+mDSZ1DGrDd5Nl0uadciKpAys3a3yLzsKuzgblb
sJeMbMQ8DJ4TC/syzFJ5fzE8eyC4mCHFXycpHNyjbiaT0YtB6EUJllfVH9ECYHle
CYKdniq8TlFAd6RiIK2pPXeWjmeD0qFxN4yy4lbyl9/v2O//Ia+C7gAUXKmA3vNi
Hl0tFpnJMHt5c5ZCw4I0iyO53YWmVlki0zb4zJO5VTDPkv5FncmnCmySEbap+qwS
x3zaWaS4t5AMJNY4vftOE1LQgpeTmlHv7B4Dy5YxcIA0Sz9fbV+1RVE0S+N7EYLD
jvjxuAC3N6KOr7FxpGCwnId+nUVR5+tQbZdumY9Hc9rWECkRr+abN2Gwob0Ji0lP
EkHPvN5cUIZzayA3ZizsorLPS10Rj/EuHD6Qj4weMSxBgNpPTnxJ5nmZG670MBZF
ri6YRwIRNXR4uSq2BcAjy0BO/UbtvZj2lsF0u95bJ1YUg6EePmlBlFHQdNynOe9e
F3foJEM0WSDbqJB2qFULK+M4mzSIc61bkrpvFfGkSobd1UbQqFNh3+GsuhNRBdrM
6rfRZELq/VjAQwavdIDLQpqgJXdWKAYniaHg/DuWMiGfaNE9sOIZbXY0wWykiTiC
Wjd2eJcAP4AWmM8pSoAD9/ufbcPCRjscwxBNAfqMUzHaFspxdQ0=
=WUGa
-----END PGP SIGNATURE-----

--CUrluEZVXmx7ezWQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
