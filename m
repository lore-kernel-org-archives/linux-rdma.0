From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 21:01:38 +0300
Message-ID: <20171010180138.GG2106@mtr-leonro.local>
References: <1507568205.46071.46.camel@redhat.com>
 <1507568492.2674.11.camel@wdc.com>
 <20171010041423.GJ1252@mtr-leonro.local>
 <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
 <20171010150018.GC2106@mtr-leonro.local>
 <1507648402.46071.53.camel@redhat.com>
 <20171010154439.GE2106@mtr-leonro.local>
 <1507651473.2815.20.camel@wdc.com>
 <20171010170429.GA21288@obsidianresearch.com>
 <1507655454.2815.43.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y+xroYBkGM9OatJL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507655454.2815.43.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Y+xroYBkGM9OatJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 10, 2017 at 05:10:55PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 11:04 -0600, Jason Gunthorpe wrote:
> > considering our general dislike of module parameters, could you
> > achieve this via some communication from srp_daemon instead?
> >
> > Perhaps even on a per target basis?
>
> The SRP target driver already creates one /sys/kernel/config/target/srpt/$GUID
> directory per HCA port. How about adding an attribute to that configfs directory?

Sounds good.

Thanks

>
> Bart.

--Y+xroYBkGM9OatJL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlndCwEACgkQ5GN7iDZy
WKcMRg//QGZ8Hb61QHLNbj82ahWwzIppY0mqL7TTjhpGQtpTzHNBjTLSpj9hd10z
C3PLDLqj8NW554aOpV91G6obsmhE8zTG9brGlQPThgw+x/yl6s5njBRLi6aqjwr+
MddrfFRa1PK4Po01feBILTnRebiXDfo/k0p1OI6O17GpszbEG9x1EBz5w1T7Yql4
xqbIqqUU9vOavvIeabW6BWJ0lAyC0NvVlWS5mjkcp6URgpRLnUiflYxVhBd5Mn2M
ZuTuPkFI/6YFBxu7Gsgdqydr6vQSEnL4lXoqYToJDRnYvEvpJQLNYhrFNJ7DsrDt
ojea+birKSEft0h+VvYp3Iref8GT2cIdiOa1nAJF6WuQEzvLSIe2f586Od7FkU1R
XYLWfimY91vOOD6XLthSSry9IGc5oJTtN30jZWKN6dm56GAPZJc2Vgq49N+Hh/6Q
GJSVr+UjYK8c3YsKPwT7A3ep8m3nIWMf/fW/sJiYVHSGCf+VmcSVXUL01v8vqIFy
SQ9vYHBsA0nRL6zz8gAavLsqBWLQn0WnRxDNjV8Md9TBIgJBgk2z3N8ECOrweqiQ
/8kDlI9FpIm6JTGIgc5fYyqYuqkyefztv1ZrpJSCCTyAafVKQNeiyACesWcyBMDI
uj8saJVOHu0qagVMPgFBp2aKJAUB02iFt/7bLGzTSAzNF+j752o=
=syuJ
-----END PGP SIGNATURE-----

--Y+xroYBkGM9OatJL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
