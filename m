From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 06/11] IB/rdmavt: Use correct numa node for SRQ
 allocation
Date: Wed, 20 Dec 2017 10:17:20 +0200
Message-ID: <20171220081720.GM2942@mtr-leonro.local>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035649.2126.1625.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Op27XXJsWz80g3oF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219035649.2126.1625.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Op27XXJsWz80g3oF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 07:56:52PM -0800, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Normal receive queue allocation ensures that kernel receive queues
> are allocated on the local numa node. Shared receive queues
> do not behave the same way.
>
> Ensure that kernel shared receive queues are allocated on the device
> local node.
>
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/srq.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)

Are you aware of "__GFP_THISNODE" flag?

Thanks

--Op27XXJsWz80g3oF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6HJAACgkQ5GN7iDZy
WKchOg/9F8ClslS3PCTMsD90eD/x+1UXOmPyUGvzmcuIwBiQDIUXV75A34UiL5nD
RK7UmG9y+e3RkuGFbpTSGUFbFiiFF7SNpNVPkUBlPWSn+wFBxTAbBQ6nMds3CDba
AMqgIPbBrtT54wKQUCcXimfdSVe0A9IZVHVo8ZNa6H8yf63UDQ6waEij97u6YSdp
QXpCIx+huJrgOjsZ9GJ47AktzJCDyco8joIQVGOwcicwTF1fy7ZwTqGEfYzdjFT3
hTnzo4R2WaruAKixeJ3jOnEFqcXNQXd+aUuCj5Of6KtsFwSNJWdQw3J30epEquXU
hlrEpKlQgsE/BAYEErGM3c23+zF/Br321PjJvcocJ2JJYD5SbtbhX4AYM7EJG3Kr
XHQpNzWqcF9ZCnliXXNMh868tw+qIF6MT0JTmGhWUAlzlCFpabY3ImRd5GWOw8mB
s8DT5ZyiHC9xrLuISUF6erQfdPLSzl87JP2qAntllcfe0NB6Akt5rzXdg1vdjxDz
hldD9S9vc2JrvLyOekLBDXGHkpq+RSqpoY9FU6wMqCe2fpPLdrUAh9aSw++YuXva
w9u24kjJWV0QvKNsV6RqrpwNt+rIahyahOAmUF7HokGaAJbldVQKEM5r+rv8GFCD
Gjotgirq9BYj78RDnGa3b2qKrlnhHG1+AQrYbSo7X9HnqT+c8RI=
=Ra4K
-----END PGP SIGNATURE-----

--Op27XXJsWz80g3oF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
