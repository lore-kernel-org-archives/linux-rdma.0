From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/4] debian/changelog: Update changes
Date: Sun, 1 Jan 2017 09:56:10 +0200
Message-ID: <20170101075610.GS26885@mtr-leonro.local>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-5-leon@kernel.org>
 <20161229151132.GA30742@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/U0GMd1Pus0mbMSS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161229151132.GA30742-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/U0GMd1Pus0mbMSS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 29, 2016 at 08:11:32AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 29, 2016 at 03:49:08PM +0200, Leon Romanovsky wrote:
> > From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Document the recent changes into debian/changelog.
>
> I think it would be best to maintain the changelog in the Debian
> .diff, not upstream? Same comment for RPM.

My plan is to maintain proper package in upstream till it will be part
of Debian, after that they can maintain it as they want :)

>
> Just put a single stanza with the 'closes ITP' to silence Litian and
> replace the whole file when packaging.
>
> Jason

--/U0GMd1Pus0mbMSS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhothoACgkQ5GN7iDZy
WKe/OxAAnfvlfQ27O19917zCQjcqESWsLokO9ZmxBmUy8+YclHJeGPpAngsobcGZ
L/KstyFGf41GlhFaWUXUITFyVPJ8TpWVOd7dSMknq7MRi8xeNuqX5pZ7HWi9TI41
agNBnHOHhNebRnWtIUXe3ml/DLl9UcLEM3Qf9WO6JpLBU+mAZTbt2rLwfy1TGk6N
orZNUSDErpYXoeFKqlsFcuK6hPXP/9JAysz05oc5QkR2f3mj78XseCDgxxQjznGm
zqb9Jb5zKjCHimb5kW9T37IGifPMncIO6K0FP9VYVjbGb8rUzqh6FZgZy8J7qhMX
MfTysB9brRqUc053xxrQPkyp6sR8q66XwBFaQO+dYcbNpy2LJBwCvrpc/Ew07ag0
MkeOU1mhb7hBMmuialUiSKQ89cs6ZLjsY7Ch9KMtcN/hDTS7mjVRO2h++f75Tkom
3h1ZnLUAU/EMuUWHZZ4qyCcNK0JnXkXERv1fUwJN1JdDnr/iSQJ2guATrRoLDaIV
8xvZrUPvv8oLuLkkghXySmw4Bj1gcuiLxoi1C96Lee69xWuQga8rfR0qXM1j2Zrp
KA/oIXMmDdgsBjxizXr31CD86f/atcXXO/rHUv4eGb8kUIbv7bvMfS/EPHtnxyND
9CXPFnYGZHhTVQqbNU20T4/2D1TobAIXNccwjQcsMug/Pq7bQo4=
=s6Q6
-----END PGP SIGNATURE-----

--/U0GMd1Pus0mbMSS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
