From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Sun, 3 Dec 2017 08:55:01 +0200
Message-ID: <20171203065501.GA2110@mtr-leonro.local>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
 <20171201182806.GL7754@ziepe.ca>
 <20171202084019.GG8126@mtr-leonro.local>
 <20171202162856.GA28143@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171202162856.GA28143-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 02, 2017 at 09:28:56AM -0700, Jason Gunthorpe wrote:
> On Sat, Dec 02, 2017 at 10:40:19AM +0200, Leon Romanovsky wrote:
> > On Fri, Dec 01, 2017 at 11:28:06AM -0700, Jason Gunthorpe wrote:
> > > On Fri, Dec 01, 2017 at 07:13:05PM +0100, Benjamin Drung wrote:
> > > > GitHub does not allow to rebase & merge the pull request. Is there any
> > > > reason to not allow the rebase & merge workflow? My commits are atomic
> > > > and the git history is cleaner without the merge commits.
> > >
> > > We have been using the merge workflow. I'm not sure this was every
> > > really discussed which is best or not.
> > >
> > > The git history is simpler with rebase, but merge preserves the 'what
> > > did I test' and preserves the series boundaries, which are also useful things.
> >
> > We are also putting cover letters into the merge commit for documentation
> > purposes.
>
> Are we?

Rarely,

Merge: cea6f4e0 e0ed9229
Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date:   Thu Sep 28 16:58:57 2017 +0300

    Merge branch 'jgunthorpe-new-init'

    * jgunthorpe-new-init:
      rxe: Use VERBS_NAME_MATCH to match the rxe device
      hns: Use the generic modalias matcher
      cxgb: Use the new common PCI matching infrastructure
      providers: Use the new common PCI matching infrastructure
      verbs: Provide common code to match providers against kernel devices
      verbs: Remove the init_device entry point
      providers: Use the new match_device and allocate_device ops
      verbs: Split init_device into a match and alloc/bind step
      cxgb4: Move sysconf up to driver_init
      verbs: Change verbs_register_driver to accept the ops struct directly


> I wish github did that :(

Github is doing it, it will help if PR authors place cover letter in
their PR.

> On the plus side it does sign all
> merge commits made through the web interface
>
> commit 4925a85fc53f8f037a6792df450891340ee5a76b
> gpg: Signature made Mon 20 Nov 2017 01:34:16 AM MST using RSA key ID 3AFDEB23
> gpg: Good signature from "GitHub (web-flow commit signing) <noreply-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>"
> gpg: WARNING: This key is not certified with a trusted signature!
> gpg:          There is no indication that the signature belongs to the owner.
> Primary key fingerprint: 5DE3 E050 9C47 EA3C F04A  42D3 4AEE 18F8 3AFD EB23
> Merge: 3d9b214443effe 9db80df802bf91
> Author: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date:   Mon Nov 20 10:34:16 2017 +0200
>
>     Merge pull request #254 from jgunthorpe/rdma_cm_mc
>
>     Support for the MC join flag in RDMA CM
>
>
> Jason

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlojn6UACgkQ5GN7iDZy
WKfxsQ/9FTa/vhlu5SKwk9mubTlvuCy8aexX3kHDfrpAc/7xJSvQL5Fi74BLCv0D
F36TGWhTfwClNbvNZ8gCJ+4WJmjdv2GaKHYj2BP/u83RBr4RAcvSpJ/lcypswtND
jh2BIuTX8lLib4szlPzCIrZhMGyiAC7GAHW20LgtmQvWck4HqZ9s3yacyPNkm36e
Xf9s+PjHIlTEky7NW8oQh80rwBVQ294t9x6pHwXcEDgpg1RPxf8EkJHatmUT4lvL
EMS45G8en4TLPdh+kDN+5g6uWm2u8qZ/vAx8DUkbQFzdK0pzh3Im8BF3UnN3hBOh
LxVpMrq7pJ9s2PvknaGBsxKFDywIvRIQl3o3bp3Ohr5XpWlqtzTs+Ek3pK5tFtfr
LWKgDO7w4yM1MNgqfyl2nGbNGaz1qBTbv5jqHldhjvO3fOhU3fS2oaZT2BC4/lRc
2/YstlkitN5K0ave1u9En/xnDOJc66MbV/fQE2AruSx+m3YVSaj74D7rempUveSw
23K6VgfaNt9jUGWxgJJcz/ys1rQ6HSJAdY8FHoy4DbZt94YBv0cQaUOdTYQzrXqK
geN89s1FbxIiXd8DEbeMDKZ33GnpnXAy6/mFf+49fXDPazh/HTBJI74V4l8nvF71
gh10mzNd/GFmUDSzb3lBmnWaDUBYDVp1dX+49zi2taUin2cRHho=
=ks8J
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
