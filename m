From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdmacm-utils: Missing man pages for cmtime and udpong
Date: Sun, 30 Apr 2017 08:54:07 +0300
Message-ID: <20170430055407.GN14088@mtr-leonro.local>
References: <1493040510.17795.3.camel@profitbricks.com>
 <20170425180423.GT14088@mtr-leonro.local>
 <1493198562.3837.2.camel@profitbricks.com>
 <20170427040018.GY14088@mtr-leonro.local>
 <1493370517.3837.9.camel@profitbricks.com>
 <550f6e6a-931a-0aba-2d54-1ca1b3a44150@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K4/DQSt3oreaYeED"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <550f6e6a-931a-0aba-2d54-1ca1b3a44150-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--K4/DQSt3oreaYeED
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2017 at 10:18:15AM -0400, Hal Rosenstock wrote:
> On 4/28/2017 5:08 AM, Benjamin Drung wrote:
> > Am Donnerstag, den 27.04.2017, 07:00 +0300 schrieb Leon Romanovsky:
> >> On Wed, Apr 26, 2017 at 11:22:42AM +0200, Benjamin Drung wrote:
> >>> Am Dienstag, den 25.04.2017, 21:04 +0300 schrieb Leon Romanovsky:
> >>>> On Mon, Apr 24, 2017 at 03:28:30PM +0200, Benjamin Drung wrote:
> >>>>> Hi,
> >>>>>
> >>>>> the rdmacm-utils binaries cmtime and udpong do not have a
> >>>>> corresponding
> >>>>>  man page. Please add some since Debian recommends to ship man
> >>>>> pages
> >>>>> for all binaries.
> >>>>
> >>>> Is it requirement or recommendation?
> >>>
> >>> I looked it up. It's considered a bug. The Debian policy says in
> >>> =A712.1:
> >>
> >> I understand, I just don't see many volunteers :( to write it.
> >
> > Normally the authors of the program are in the best position to write
> > such a man page instead of the people from the distributions.
>
> There is now PR #124 in rdma-core github to resolve this. I've asked
> Sean to review as he is the author of those examples.

Thanks Hal for handling this.

Benjamin,

Do you see anything else in rdma-core which prevents us from being
accepted to Debian?

Thanks

>
> -- Hal

--K4/DQSt3oreaYeED
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkFe/8ACgkQ5GN7iDZy
WKcdvg//bD8rYvrZfkvFlx+WY7Hg2VtAZndhhDEMAUhEQ/S5Fmn/VoRObkcvCGa9
JxYvTsu7Mg+EjGKb0zz10vFnHYHO6j+mGJjBw6PiCShyvq00KumpNOBm4AQUwPYw
uSKEN+EBgrXVX3mhsIw4dDvwqA2uFxf9QrV7KoYWgFBAtrplQO4X3sjtKrQt2h4n
J3ZUvfCKzPBlBYWju6VyjqebcqkMPeVdK0AE+GyqvcVOdoXpJw7eFYph12rXk6pS
IEp17FuUibvkqqPH8fhvAKek3ElfbtgXmZ96v9hlw4a0w5QvKMWl2P+6FnunpAZs
w+TmbCC5VIopPxXba8PoTQouvzPwV1d1M06Tmh4zo69JPo1zT4PiBim3lw0KS2Ab
HgixbYhEulRpTvux1T1ljXW+N+OtCfi/79GBQ58o7t/I6RjyJwnTtX0lBki9sNKD
fiXDDqIhrcB41ifyS0Fhm+0+JN36M7Uus6q3SbkfkIIMR1Rini7hXcp3xahODvcO
FOmF91042ALf5vud7ll/a4U9vzdts2gN/4eADMFBFqu1Cxz976sVS7WCq/MaBfzL
iDEwWU/jt3IlTym+dil+FrES9gZ4xSVXroz8jmXzcIDs/jhbDHepBlR1JPJvndj9
522QHug712ivstonVknltf3mUR9/osy+c1HtpDIDYt3UCFG4BZY=
=oHnM
-----END PGP SIGNATURE-----

--K4/DQSt3oreaYeED--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
