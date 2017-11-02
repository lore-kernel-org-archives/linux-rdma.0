From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] cbuild: Properly create tarball for SuSE
Date: Thu, 2 Nov 2017 20:25:26 +0200
Message-ID: <20171102182526.GG16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-3-leon@kernel.org>
 <20171102171738.GP18874@ziepe.ca>
 <20171102175735.GE16127@mtr-leonro.local>
 <20171102181217.GS18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6BJIGhnDLgQ8Wrmm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102181217.GS18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6BJIGhnDLgQ8Wrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 12:12:17PM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 07:57:35PM +0200, Leon Romanovsky wrote:
>
> > > Are you running cbuild as root or something? What is the docker
> > > command the script uses?
> >
> > For me too, it doesn't reproduce, most probably Alaa run it as a root.
>
> Okay lets instead ban running cbuild as root?

I'm fine with that, but lets wait till Sunday before dropping this patch,
so Alaa will have chance to respond.

Thanks

>
> Jason

--6BJIGhnDLgQ8Wrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7YxYACgkQ5GN7iDZy
WKekJQ/9F4iNQUFshsv9HgzqZ5Wgw7ShYr3MGlS4zZwa1TAyq8tosvIDi/Flo4H+
yayujXujPIdSCi0evwRjR2ZEy1V5TRH/vJyzXm/vMa6wGF09KRuQl9jIAXIpH1Hd
Stiwi6UhKsq4i5dgzpRDH7QbynOZC+uF5ymz2Hh+1w+gep3iactz6nuHMlm6xrDn
77XK5ahODAMmkYe6IhJtre8hDkLqGdlBZ7BO5OMRVRGSwTpNzxovI94VJeQTp8mk
UJgbb8tTVDaEl5+oTpJjbyCvaBuDfhKZwR5logPFUGR+/Kng5Jv4AXJPcRfrmRyj
kca6OXjhJHrWbEN7vCAMHO/SkHQhktID5V7QWG+UkHtLJslyvwdzEkHawhWV7OsR
EpYNpwP2yhIRrzjazA5ykZ8IpqGnBpjUPXFX5u+IqP3+9Cl92zXvgaJOSgdUj62z
Pfti7sacPugZ7KasF/83NhZQxQyfumtjuOULyrxgzbEsGw5j8ROWt1GCtsglu+wj
ta62dSmidwCRnQTJnfC8vZEOFT/JRNXz2FhBgwRnDRwk62GqTZzPCE8LuHhwuGES
mZa6b4c5sHv/HXKmgeGnE6Nb7tezPjxwjubUTZRhQODgvAI/80vUpzQEDWHkKNps
VGffe/71PyrJnBHA8vyFlstJUEo2ZoPU6RH3kZHc5nQp1uDb8vg=
=1wM2
-----END PGP SIGNATURE-----

--6BJIGhnDLgQ8Wrmm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
