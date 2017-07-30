From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
Date: Sun, 30 Jul 2017 08:23:30 +0300
Message-ID: <20170730052330.GK13672@mtr-leonro.local>
References: <20170726181232.7363-1-leon@kernel.org>
 <2679977c-6258-ed15-a234-3682b8be65f3@intel.com>
 <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h22Fi9ANawrtbNPX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--h22Fi9ANawrtbNPX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 11:06:56AM -0400, Dennis Dalessandro wrote:
> On 7/27/2017 11:05 AM, Dennis Dalessandro wrote:
> > On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
> > > The following changes since commit
> > > a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:
> > >
> > >    RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400)
> > >
> > > are available in the git repository at:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> > > tags/rdma-rc-2017-07-26
> > >
> > > for you to fetch changes up to 5dc78ad1904db597bdb4427f3ead437aae86f54c:
> > >
> > >    IB/ipoib: Notify on modify QP failure only when relevant
> > > (2017-07-23 10:52:00 +0300)
> > >
> > > ----------------------------------------------------------------
> > > IPoIB fixes for 4.13
> > >
> > > The patchset provides various fixes for IPoIB. It is combination of
> > > fixes to various issues discovered during verification along with
> > > static checkers cleanup patches.
> > >
> > > Most of the patches are from pre-git era and hence lack of Fixes lines.
> >
> > I'm not sure that patches 4,6,7,8, and 11 really should go in the RC. I
> > think those should go to for-next. My opinion anyway.
>
> Ugh, one of those days, hands move faster than brain. That should have said
> 9 instead of 11.

They are one-liners, simple fixes, all in one place and this is why I grouped them together.

>
> -Denny
>

--h22Fi9ANawrtbNPX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll9bVIACgkQ5GN7iDZy
WKcLIA/+MwI/EAdFEUY344ZicORcd6+//38SbtgIvgs4BsYbD/9Th5kE/q/ygRxj
piuAh43JJWZV/rTkOg5HPA7H0Lz/jz2yynPr9LfxllYNNdOaAG11nxpvWjWdaAYn
SuuTtmte5KSccUAsz7Hn54LyALME2pE5CSot1KlmnldY3qVrM7Zmq32vjKNXxYIY
P/hwf2k8ucbFWoZ5qwf1gFEpTOFHRAPmdxGKfcj60GdB3S9dTMpMwBenSdT3ygSh
UQrw4Ahck3y9LM7FW9QLmlETtdAGZALWd89lIhLLq1ce8qDz65r2hAeR/nLtxZWP
sDczwmFK5GpDug5s02dLt3mwdo8w6b6qvVpVx4tNQhkD52SnHsGqyNLL0LuEeVs9
L9dBhTtXfVmGl2GrUf5tL+pzk+gakSWDswlUhNGWHDIxnwPIZnHaXUp0lCv6uXQt
bqlGlqIXrRwd4IIaAeQHMwMsrAJT9V2yY4QkAGKYW4wpkTzs+eja9NcZ3Ekz9ez5
DWlgpycVtfbkt1bnhvWrJEkMv+htP9rD44lGjb5J+hFxnX7ZniO0YZgPOeOv/LpH
bYaULR2BjLd/53DEjwJnBYVVMmy76bRA7VF1LuJOj99Qk6oMf71SJyHTctPeaqke
mSGRNYYqCHOdD4Lx221gXA5ieuT/XdKvGDHo0XvTusD1mLx+1po=
=0nUZ
-----END PGP SIGNATURE-----

--h22Fi9ANawrtbNPX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
