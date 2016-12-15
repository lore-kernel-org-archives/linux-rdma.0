From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Thu, 15 Dec 2016 21:17:51 +0200
Message-ID: <20161215191751.GJ811@mtr-leonro.local>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481306104-19352-9-git-send-email-tatyana.e.nikolova@intel.com>
 <20161210143421.GC2521@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7081@fmsmsx104.amr.corp.intel.com>
 <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
 <20161215183537.GH811@mtr-leonro.local>
 <20161215185034.GB16552@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161215185034.GB16552-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 15, 2016 at 11:50:34AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 15, 2016 at 08:35:37PM +0200, Leon Romanovsky wrote:
>
> > I had in mind much simplier infrastucture, just add pr_debug(..) call
> > and allow every provider to place in any place in their code.
>
> I think the bitmask thing has to be hoisted too.
>
> > My main point is that I want to see all ENV variables in one place.
>
> Why?

There are two reasons:
1. Easy to document and for curious users to spot all possible
variables.
2. It helps to potential authors to reuse variables instead of inventing
their own.

>
> I really don't want to see util/ files include provider headers, for
> instance, so I don't like your SET() macro idea..
>
> At this point I'd settle for having all ENV vars *documented* in one
> place :(

See, reason #1 :)

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhS7F8ACgkQ5GN7iDZy
WKc1Vw//fI96XrLwmcSShT6Vk8AzfJ1slne1xkJP03qzdKG1DZRWwdCJJX3/+DFv
sVGJS5NBagZLSCE5LYLBebyYsNCXoa3YxxAz4RD6R7+qXRDTQMEOsUL1ZIGadnhT
zeX8D73HIlazBPo01Vllrzj3YI1jSjpd07hxsK3vXQr48noRpBLLfjc9Gf5PcEB7
nKUq/RKF0j+67jrLETFBIexNG1TlrBgrG/rsJ2LTcASPf9dXqg4e+3Gc7B4jMmR9
VBhIlW2xWhT4hBgbE3aOSQP3TpsZ/oOIWEp3VdAvuXpZlBBWPJ/kVJyeIN6bn//b
3azOw8yn0gdUmm7WUCA/5SYHoDIdoXb7TFKRZti6FDzTyZqy6tlTl+oxD2yCRgdj
nxn50ph35sdNdRAa0XSmGEWmmGMaN6PUk6mHqYZJ+XVATgOFlCRIpHFj5qEb6OQU
9/inHDUr5ST3CgdYYAGECbpWWPLUO1F4K0aBiO7w+SymAuNiosHwpVYKlkUBnkmZ
o3uKIkQfCFCKPGgbK/If2vjEWrl/YTQh6e3QAVbs1zkF9w1d0cETCmhL+RM8NSD5
YpCH/C7BK0j/IJcFjGsJWhK7cZRycueQwSSTMOHTQODXDNf5bAoH8itUN8g1gNg9
cguK8PQnm8xzE4wEstvHTqkifRq24NYGzTLTNmjBLy7KuNZ05Nc=
=q9tY
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
