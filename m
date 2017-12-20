From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Wed, 20 Dec 2017 19:11:46 +0200
Message-ID: <20171220171146.GX2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
 <20171220163655.GW2942@mtr-leonro.local>
 <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 11:00:30AM -0600, Steve Wise wrote:
> >
> > >
> > > Any thoughts/suggestions?
> >
> > Care to try?
> >
>
> Sure, I'm building the kernel now.  Where do I get the rdma command that
> will work with this?

I uploaded iproute2 part.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/iproute2.git/log/?h=topic/restrack

WIP: no manuals, no review yet and not massively tested - but works for me :


>
> Is there a way to extend commands with provider-specific data?
>

In future yes, rdmatool provides "-d" option (detailed output) and IMHO
all vendor specific will got there.

Thanks

--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6mdIACgkQ5GN7iDZy
WKcP/RAAhq7qy8s5AyIEGx5VJNoQCB23wOjOt49A4D8/sZ6jxHonsgcfGw1AOPBA
W5ddxdCNOnsVtgYm9PX8PPpHEiCtxnk4Bxftc07N3K3jLWzQXHu319gprFIeQPvI
LcI08AXlxKZveJO5YiBPU3TG9E/l2/aAnglbN9AQ52eMO/jWaco8i6GZewEUa/7d
0lm3SNiP9VWXgX7SZt8sV98zxeNE7A9Nlz+UPFPGSKlMw9qkJn8nIUmhUvAlzK7L
9Hdzqj/szz/kzzWSIXForzsfNZ/H22l0eRoglIVU2SW9EZm4ILrZLquIQnhWO742
32KS7KJljqlWQ5TKXQUjXSFmZOuYEVRcpsOVLtSGZNqMSNIV0kzFrlX7ozCnVrx1
cFl1HP2+HuNcKcNe2RW8FVr6JZVpIFGNbOgVyPMKhJlSM0si8gT1NhKRzMmIDsFS
LfuBrv6hNWg8o7TGuEpmN9kyTEGnpQsEi3WFJZ0WBjtehObH+0bQ4WY7MKnSGZ9t
i1m9nUjgKfpKqQ8gBqnSms+owBYF5jh2hZBaZiM2Ibtwu0b421bzAlkovV/7vhJx
gIrWjM2f+9q5IX760m63gci4XFs1MFniSiDZUjiWKLTlUgovZOjwmWk9f2gkb0PM
pvxei7Pl1+aYHDIi10f9Ttb8vyp1hv2GWKlwbYIUAFAehpulI9E=
=lmwn
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
